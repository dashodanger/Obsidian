//------------------------------------------------------------------------
//  DOOM SHADING / LIGHTING
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2013-2017 Andrew Apted
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

#include <algorithm>

#include "csg_local.h"
#include "csg_main.h"
#include "lib_argv.h"
#include "lib_util.h"
#include "main.h"
#include "sys_macro.h"

/*

Lighting Model
--------------

1. all brushes are added with a "ambient" value, generally sourced
   from the current AREA on the map.  With no other lighting stuff,
   sectors will get this value.

   [ floor and ceiling brushes are expected to have same ambient
     value, depending on the 2D AREA on the map they exist in ]

2. normal LIGHT brushes have an "light_add" value.  The MAXIMUM of
   all light brushes is computed, then added to the ambient value.

3. a SHADOW brush is a light brush with "shadow" value.  If this
   brush exists, AND there are no additive light brushes, then
   the shadow value (typically 32 units) is subtracted from the
   ambient value.

4. a SKY_SHADOW brush is a shadow brush which only applies when
   the ceiling is a SKY brush.

5. any floor or ceiling brush can supply a "light_add" value in
   the top/bottom face.  It is equivalent to having a LIGHT brush
   there with the specified value.

   similiary a face can have a "shadow" value, and will act the
   same as a SHADOW brush.

6. for 3D floors, it is expected that the ambient value of each
   floor will be the same, then adjusted by "light_add" or "shadow"
   values in the top/bottom faces of the brushes.

---##  in caves, certain entities (torches) are used as light sources,
---##  and we trace rays to see what nearby cells should be lit by them
---##  (less light for further distances).
---##
---##  floor brushes need "is_cave = 1" in top face of floor brushes,
---##  and torch entities need a "cave_light = 48" field.

*/

constexpr uint8_t DEFAULT_AMBIENT_LEVEL = 144;

static int current_region_group;

static int SHADE_CalcRegionGroup(region_c *R)
{
    if (R->gaps.empty())
    {
        return -1;
    }

    /* group regions with a tag and same floor height */

    csg_brush_c *B = R->gaps.front()->bottom;
    csg_brush_c *T = R->gaps.back()->top;

    csg_property_set_c *f_face = &B->t.face;
    csg_property_set_c *c_face = &T->b.face;

    // differentiate floor heights
    int base = ((int)B->t.z & 0x1FFF) << 16;

    std::string tag = f_face->getStr("tag");
    if (!tag.empty())
    {
        return base + StringToInt(tag);
    }

    tag = c_face->getStr("tag");
    if (!tag.empty())
    {
        return base + StringToInt(tag);
    }

    // closed sectors are usually doors
    if (R->isClosed())
    {
        return base + 9999;
    }

    /* otherwise keep separate */

    int xor_val = 0;

    if (T->bflags & BFLAG_Sky)
    { // separate sky sectors  [ why?? ]
        xor_val = 0x77777777;
    }

    int result = current_region_group;
    current_region_group++;

    return result ^ xor_val;
}

struct region_index_Compare
{
    inline bool operator()(const region_c *A, const region_c *B) const
    {
        return A->index > B->index;
    }
};

static void SHADE_GroupRegions()
{
    current_region_group = 0x40000000; // a value outside normal tag values

    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        R->index = SHADE_CalcRegionGroup(R);
    }

    // group regions together in the array
    // (this has a side-effect of placing all solid regions at the end)

    std::sort(all_regions.begin(), all_regions.end(), region_index_Compare());
}

static void SHADE_MergeResults()
{
    unsigned int i, k, n;

    // ensure groups get same value in every region

    for (i = 0; i < all_regions.size(); i = k + 1)
    {
        if (all_regions[i]->index < 0)
        {
            break;
        }

        k = i;

        for (k = i; k + 1 < all_regions.size() && all_regions[k + 1]->index == all_regions[i]->index; k++)
        {
        }

        int result = 0;

        for (n = i; n <= k; n++)
        {
            result = OBSIDIAN_MAX(result, all_regions[n]->shade);
        }

        for (n = i; n <= k; n++)
        {
            all_regions[n]->shade = result;
        }
    }
}

#if 0
static int SHADE_CaveLighting(region_c *R, double z2)
{
    int result = 0;

    double x2 = R->mid_x;
    double y2 = R->mid_y;

    for (unsigned int k = 0 ; k < cave_lights.size() ; k++)
    {
        csg_entity_c *E = cave_lights[k];

        double x1 = E->x;
        double y1 = E->y;
        double z1 = E->z + 64.0;

//??    int brightness = E->props.getInt("cave_light", 0);

        // basic distance check
        if (fabs(x1 - x2) > 500 || fabs(y1 - y2) > 500)
            continue;

        // more complex distance check
        double dist = ComputeDist(x1, y1, x2, y2);

        int level;

        if (dist <= 104)
            level = 48;
        else if (dist <= 232)
            level = 32;
        else if (dist <= 488)
            level = 16;
        else
            continue;

        if (level < result)
            continue;

        // line of sight blocked?
        if (CSG_TraceRay(x1,y1,z1, x2,y2,z2, "v"))
            continue;

        result = level;
    }

    return result;
}
#endif

static void SHADE_VisitRegion(region_c *R)
{
    csg_brush_c *B = R->gaps.front()->bottom;
    csg_brush_c *T = R->gaps.back()->top;

    int ambient = -1; // Unset
    int light   = -1;
    int shadow  = -1;

    // grab ambient value  [ should always be present ]

    ambient = T->props.getInt("ambient", -1);

    if (ambient < 0)
    {
        ambient = B->props.getInt("ambient", -1);
    }

    if (ambient < 0)
    {
        ambient = DEFAULT_AMBIENT_LEVEL;
    }

    // process light brushes

    for (unsigned int i = 0; i < R->brushes.size(); i++)
    {
        csg_brush_c *LB = R->brushes[i];

        if (LB->bkind != BKIND_Light)
        {
            continue;
        }

        if (LB->t.z < B->t.z + 1 || LB->b.z > T->b.z - 1)
        {
            continue;
        }

        int br_light  = LB->props.getInt("light_add", -1);
        int br_shadow = LB->props.getInt("shadow", -1);

        light  = OBSIDIAN_MAX(light, br_light);
        shadow = OBSIDIAN_MAX(shadow, br_shadow);

        int sky_shadow = LB->props.getInt("sky_shadow", -1);

        if (sky_shadow > 0 && (T->bflags & BFLAG_Sky))
        {
            shadow = OBSIDIAN_MAX(shadow, sky_shadow);
        }
    }

    // check brush faces

    for (unsigned int pass = 0; pass < 2; pass++)
    {
        csg_property_set_c *P = (pass == 0) ? &B->t.face : &T->b.face;

        int fc_light  = P->getInt("light_add", -1);
        int fc_shadow = P->getInt("shadow", -1);

        light  = OBSIDIAN_MAX(light, fc_light);
        shadow = OBSIDIAN_MAX(shadow, fc_shadow);
    }

#if 0 // DISABLED, WE DO THIS IN LUA CODE NOW
      // check torch entities in caves
    if (B->t.face.getInt("is_cave"))
    {
        double z2 = B->t.z + 80.0;

        int cave = SHADE_CaveLighting(R, z2);

        if (cave > 0)
            light = OBSIDIAN_MAX(light, cave);
    }
#endif

    // combine them

    R->shade = ambient;

    if (light > 0)
    {
        R->shade += light;
    }
    else if (shadow > 0)
    {
        R->shade -= shadow;
    }
}

static void SHADE_LightWorld()
{
    bool no_light = (argv::Find(0, "nolight") >= 0);

    if (no_light)
    {
        LogPrint("LIGHTING DISABLED (-nolight specified)\n");
    }

    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        if (R->gaps.empty())
        {
            continue;
        }

        if (no_light)
        {
            R->shade = 192;
            continue;
        }

        SHADE_VisitRegion(R);
    }
}

void CSG_Shade()
{
    LogPrint("Lighting level...\n");

    //    SHADE_CollectLights();

    // SHADE_GroupRegions();
    SHADE_LightWorld();
    // SHADE_MergeResults();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
