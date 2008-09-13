//------------------------------------------------------------------------
//  LEVEL building - QUAKE II format
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "csg_main.h"

#include "g_image.h"
#include "ui_chooser.h"

#include "q_bsp.h"
#include "q_pakfile.h"
#include "q2_main.h"
#include "q2_structs.h"


#define TEMP_FILENAME    "temp/out.pak"

static char *level_name;


void Q2_CreateEntities(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_ENTITIES);

  /* add the worldspawn entity */

  lump->Printf("{\n");

  lump->KeyPair("_generated_by", OBLIGE_TITLE " (c) Andrew Apted");
  lump->KeyPair("_oblige_version", OBLIGE_VERSION);
  lump->KeyPair("_oblige_home",  "http://oblige.sourceforge.net");
  lump->KeyPair("_random_seed",  main_win->game_box->get_Seed());

  lump->KeyPair("message",   "level created by Oblige");
  lump->KeyPair("worldtype", "0");
//lump->KeyPair("origin",    "0 0 0");
  lump->KeyPair("classname", "worldspawn");

  lump->Printf("}\n");

  // add everything else

  for (unsigned int j = 0; j < all_entities.size(); j++)
  {
    entity_info_c *E = all_entities[j];

    lump->Printf("{\n");

    // TODO: other models (doors etc) --> "model" "*45"

    // FIXME: other entity properties

    lump->KeyPair("origin", "%1.1f %1.1f %1.1f", E->x, E->y, E->z);
    lump->KeyPair("classname", E->name.c_str());

    lump->Printf("}\n");
  }

  // add a trailing nul
  u8_t zero = 0;

  lump->Append(&zero, 1);
}


//------------------------------------------------------------------------

std::vector<dplane2_t> q2_planes;

#define NUM_PLANE_HASH  64
static std::vector<u16_t> * plane_hashtab[NUM_PLANE_HASH];


static void ClearPlanes(void)
{
  q2_planes.clear();

  for (int h = 0; h < NUM_PLANE_HASH; h++)
  {
    delete plane_hashtab[h];
    plane_hashtab[h] = NULL;
  }
}


u16_t Q2_AddPlane(double x, double y, double z,
                  double dx, double dy, double dz)
{
  bool flipped = false;

  double len = sqrt(dx*dx + dy*dy + dz*dz);

  SYS_ASSERT(len > 0);

  dx /= len;
  dy /= len;
  dz /= len;

  double ax = fabs(dx);
  double ay = fabs(dy);
  double az = fabs(dz);

  // flip plane to make major axis positive
  if ( (-dx >= MAX(ay, az)) ||
       (-dy >= MAX(ax, az)) ||
       (-dz >= MAX(ax, ay)) )
  {
    flipped = true;

    dx = -dx;
    dy = -dy;
    dz = -dz;
  }

  SYS_ASSERT(! (dx < -1.0 + EPSILON));
  SYS_ASSERT(! (dy < -1.0 + EPSILON));
  SYS_ASSERT(! (dz < -1.0 + EPSILON));

  // distance to the origin (0,0,0)
  double dist = (x*dx + y*dy + z*dz);


  // create plane structures
  // Quake II stores them in pairs
  dplane2_t dp[2];

  dp[0].normal[0] = dx; dp[1].normal[0] = -dx;
  dp[0].normal[1] = dy; dp[1].normal[1] = -dy;
  dp[0].normal[2] = dz; dp[1].normal[2] = -dz;

  dp[0].dist =  dist;
  dp[1].dist = -dist;

  if (ax > 1.0 - EPSILON)
    dp[0].type = PLANE_X;
  else if (ay > 1.0 - EPSILON)
    dp[0].type = PLANE_Y;
  else if (az > 1.0 - EPSILON)
    dp[0].type = PLANE_Z;
  else if (ax >= MAX(ay, az))
    dp[0].type = PLANE_ANYX;
  else if (ay >= MAX(ax, az))
    dp[0].type = PLANE_ANYY;
  else
    dp[0].type = PLANE_ANYZ;

  dp[1].type = dp[0].type;


  // find an existing matching plane.
  // For speed we use a hash-table based on dx/dy/dz/dist
  int hash = I_ROUND(dist / 8.0);
  hash = IntHash(hash ^ I_ROUND((dx+1.0) * 8));
  hash = IntHash(hash ^ I_ROUND((dy+1.0) * 8));
  hash = IntHash(hash ^ I_ROUND((dz+1.0) * 8));

  hash = hash & (NUM_PLANE_HASH-1);
  SYS_ASSERT(hash >= 0);

  if (! plane_hashtab[hash])
    plane_hashtab[hash] = new std::vector<u16_t>;
    
  std::vector<u16_t> *hashtab = plane_hashtab[hash];

  for (unsigned int i = 0; i < hashtab->size(); i++)
  {
    u16_t plane_idx = (*hashtab)[i];

    SYS_ASSERT(plane_idx < q2_planes.size());

    dplane2_t *test_p = &q2_planes[plane_idx];

    // Note: ignore the 'type' field because it was generated
    //       from (and completely depends on) the plane normal.
    if (fabs(test_p->dist - dist)  <= Q_EPSILON &&
        fabs(test_p->normal[0] - dx) <= EPSILON &&
        fabs(test_p->normal[1] - dy) <= EPSILON &&
        fabs(test_p->normal[2] - dz) <= EPSILON)
    {
      // found it
      return plane_idx | (flipped ? 1 : 0);
    }
  }


  // not found, so add new one  [We only store dp[0] in the hash-tab]
  u16_t plane_idx = q2_planes.size();

  if (plane_idx >= MAX_MAP_PLANES-2)
    Main_FatalError("Quake2 build failure: exceeded limit of %d PLANES\n",
                    MAX_MAP_PLANES);

  q2_planes.push_back(dp[0]);
  q2_planes.push_back(dp[1]);

fprintf(stderr, "ADDED PLANE (idx %d), count %d\n",
                 (int)plane_idx, (int)q2_planes.size());

  hashtab->push_back(plane_idx);


  return plane_idx | (flipped ? 1 : 0);
}


static void Q2_CreatePlanes(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_PLANES);

  // FIXME: write separately, fix endianness as we go

  lump->Append(&q2_planes[0], q2_planes.size() * sizeof(dplane2_t));
}


//------------------------------------------------------------------------

std::vector<texinfo2_t> q2_texinfos;

#define NUM_TEXINFO_HASH  64
static std::vector<u16_t> * texinfo_hashtab[NUM_TEXINFO_HASH];


static void ClearTexInfo(void)
{
  q2_texinfos.clear();

  for (int h = 0; h < NUM_TEXINFO_HASH; h++)
  {
    delete texinfo_hashtab[h];
    texinfo_hashtab[h] = NULL;
  }

fprintf(stderr, "CLEAR TEX INFO: size now %d\n", (int)q2_texinfos.size());
}

static bool MatchTexInfo(const texinfo2_t *A, const texinfo2_t *B)
{
  if (strcmp(A->texture, B->texture) != 0)
    return false;

  if (A->flags != B->flags)
    return false;

  for (int k = 0; k < 4; k++)
  {
    if (fabs(A->s[k] - B->s[k]) > 0.01)
      return false;

    if (fabs(A->t[k] - B->t[k]) > 0.01)
      return false;
  }

  return true; // yay!
}

u16_t Q2_AddTexInfo(const char *texture, int flags, double *s4, double *t4)
{
fprintf(stderr, "1 ADD TEX INFO: size now %d\n", (int)q2_texinfos.size());

  // create texinfo structure
  texinfo2_t tin;

  for (int k = 0; k < 4; k++)
  {
    tin.s[k] = s4[k];
    tin.t[k] = t4[k];
  }

  if (strlen(texture)+1 >= sizeof(tin.texture))
    Main_FatalError("TEXTURE NAME TOO LONG: '%s'\n", texture);

  strcpy(tin.texture, texture);

  tin.flags  = flags;
  tin.value  = 0;
  tin.anim_next = -1;

fprintf(stderr, "D ADD TEX INFO: size now %d\n", (int)q2_texinfos.size());

  // find an existing texinfo.
  // For speed we use a hash-table.
  int hash = (int)StringHash(texture);
  hash = hash & (NUM_TEXINFO_HASH-1);

  SYS_ASSERT(hash >= 0);

  if (! texinfo_hashtab[hash])
    texinfo_hashtab[hash] = new std::vector<u16_t>;

  std::vector<u16_t> *hashtab = texinfo_hashtab[hash];

fprintf(stderr, "Hash Tab: %p  q2_texinfos: %p", hashtab, &q2_texinfos);
fprintf(stderr, "W ADD TEX INFO: size now %d\n", (int)q2_texinfos.size());

  for (unsigned int i = 0; i < hashtab->size(); i++)
  {
    u16_t tin_idx = (*hashtab)[i];

    SYS_ASSERT(tin_idx < q2_texinfos.size());

fprintf(stderr, "X ADD TEX INFO: size now %d\n", (int)q2_texinfos.size());
    if (MatchTexInfo(&tin, &q2_texinfos[tin_idx]))
{ fprintf(stderr, "  MATCHED IN HASH\n");
      return tin_idx;  // found it
}
  }


  // not found, so add new one
  u16_t tin_idx = q2_texinfos.size();

fprintf(stderr, "TexInfo %d --> %d '%s' (%1.1f %1.1f %1.1f %1.1f) "
        "(%1.1f %1.1f %1.1f %1.1f)\n",
        tin_idx, flags, texture,
        s4[0], s4[1], s4[2], s4[3],
        t4[0], t4[1], t4[2], t4[3]);


  if (tin_idx >= MAX_MAP_TEXINFO)
    Main_FatalError("Quake2 build failure: exceeded limit of %d TEXINFOS\n",
                    MAX_MAP_TEXINFO);

fprintf(stderr, "Y ADD TEX INFO: size now %d\n", (int)q2_texinfos.size());
  q2_texinfos.push_back(tin);

fprintf(stderr, "JOO ADD TEX INFO: size now %d\n", (int)q2_texinfos.size());
  hashtab->push_back(tin_idx);
fprintf(stderr, "Z ADD TEX INFO: size now %d\n", (int)q2_texinfos.size());

  return tin_idx;
}

static void Q2_CreateTexInfo(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_TEXINFO);

  // FIXME: write separately, fix endianness as we go
 
  lump->Append(&q2_texinfos[0], q2_texinfos.size() * sizeof(texinfo2_t));
}


//------------------------------------------------------------------------

static void DummyArea(void)
{
  /* TEMP DUMMY STUFF */

  qLump_c *lump = BSP_NewLump(LUMP_AREAS);

  darea_t area;

  area.num_portals  = LE_U32(0);
  area.first_portal = LE_U32(0);

  lump->Append(&area, sizeof(area));
}

static void DummyVis(void)
{
  /* TEMP DUMMY STUFF */

  qLump_c *lump = BSP_NewLump(LUMP_VISIBILITY);

  dvis_t vis;

  vis.numclusters = LE_U32(1);

  vis.offsets[0][0] = LE_U32(sizeof(vis));
  vis.offsets[0][1] = LE_U32(sizeof(vis));

  lump->Append(&vis, sizeof(vis));

  byte dummy_v = 255;

  lump->Append(&dummy_v, 1);
  lump->Append(&dummy_v, 1);
  lump->Append(&dummy_v, 1);
  lump->Append(&dummy_v, 1);
}

static void DummyLeafBrush(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_LEAFBRUSHES);

  dbrush_t brush;

  brush.firstside = 0;
  brush.numsides  = 0;

  brush.contents  = 0;

  lump->Append(&brush, sizeof(brush));
}


//------------------------------------------------------------------------

const byte oblige_pop[256] =
{
  175, 175, 175, 221, 221, 221, 221, 221, 221, 221, 221, 221, 175, 175, 175, 175,
  175, 175, 175, 175, 221, 221, 221, 221, 221, 221, 221, 175, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175, 175,
  175, 175, 175, 175,  62,  59,  58,  57, 221, 221,  59,  62, 175, 175, 175, 175,
  175, 175,  63,  59,  57,  57,  57, 221, 221,  57,  57,  57,  59,  63, 175, 175,
  175, 172,  58,  57,  57,  57,  57, 221, 221,  57,  57,  57,  57,  58, 172, 175,
  175,  59,  57,  57,  57,  61, 221, 221, 174,  63,  61,  57,  57,  57,  59, 175,
  175,  57,  57,  57, 171, 175, 221, 221, 221, 221, 221, 221,  57,  57,  57, 175,
  175,  57,  57,  57, 171, 221, 221, 221, 221, 221, 221, 171,  57,  57,  57, 175,
  175,  59,  57,  57,  57,  61,  63, 175, 174, 221, 221,  57,  57,  57,  59, 175,
  175, 172,  58,  57,  57,  57,  57,  57,  57,  57,  57,  57,  57,  58, 172, 175,
  175, 175,  63,  59,  57,  57,  57,  57,  57,  57,  57,  57,  59,  63, 175, 175,
  175, 175, 175, 175,  62,  59,  58,  57,  57,  58,  59,  62, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 221, 175, 175, 175, 175, 175, 175, 175, 175
};


//------------------------------------------------------------------------


class quake2_game_interface_c : public game_interface_c
{
private:


public:
  quake2_game_interface_c()
  { }

  ~quake2_game_interface_c()
  { }

  bool Start();
  bool Finish(bool build_ok);

  void BeginLevel();
  void LevelProp(const char *key, const char *value);
  void EndLevel();
};


bool quake2_game_interface_c::Start()
{
  const char *filename = Select_Output_File();

  if (! filename)  // cancelled
    return false;

  if (! PAK_OpenWrite(TEMP_FILENAME))
    return false;

  main_win->build_box->ProgInit(1);

  main_win->build_box->ProgBegin(1, 100, BUILD_PROGRESS_FG);
  main_win->build_box->ProgStatus("Making levels");

  return true;
}


bool quake2_game_interface_c::Finish(bool build_ok)
{
  PAK_CloseWrite();

  // tidy up
/////  FileDelete(TEMP_FILENAME);

  return build_ok;
}


void quake2_game_interface_c::BeginLevel()
{
  // nothing needed
}


void quake2_game_interface_c::LevelProp(const char *key, const char *value)
{
  if (StringCaseCmp(key, "level_name") == 0)
  {
    level_name = StringDup(value);
  }
  else
  {
    LogPrintf("WARNING: QUAKE2: unknown level prop: %s=%s\n", key, value);
  }
}


void quake2_game_interface_c::EndLevel()
{
  if (! level_name)
    Main_FatalError("Script problem: did not set level name!\n");

  if (strlen(level_name) >= 32)
    Main_FatalError("Script problem: level name too long: %s\n", level_name);

  char entry_in_pak[64];
  sprintf(entry_in_pak, "maps/%s.bsp", level_name);

  if (! BSP_OpenLevel("maps/base1.bsp", 2))
    return; //!!!!!! FUCK

  ClearPlanes();
  ClearTexInfo();

  BSP_ClearVertices(LUMP_VERTEXES, MAX_MAP_VERTS);
  BSP_ClearEdges(LUMP_EDGES, MAX_MAP_EDGES);
  BSP_ClearLightmap(LUMP_LIGHTING, MAX_MAP_LIGHTING);

//!!!! TEMP CRUD
byte solid_light[512];
for (int L=0; L < 512; L++) solid_light[L] = 64;
BSP_AddLightBlock(16, 32, solid_light);


  CSG2_MergeAreas();
  CSG2_MakeMiniMap();

  Q2_BuildBSP();

  Q2_CreateEntities();
  Q2_CreateModel();
  Q2_CreatePlanes();
  Q2_CreateTexInfo();

  DummyArea();
  DummyVis();
  DummyLeafBrush();

  BSP_WriteVertices();
  BSP_WriteEdges();

  BSP_CloseLevel();

  // FREE STUFF !!!!
}


game_interface_c * Quake2_GameObject(void)
{
  return new quake2_game_interface_c();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
