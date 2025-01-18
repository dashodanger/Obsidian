//------------------------------------------------------------------------
//  LEVEL building - DOOM format
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
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

#include "g_doom.h"

#include <locale.h>
#include <string.h>

#include <bitset>
#include <string>

#include "bsp.h"
#include "lib_util.h"
#include "lib_wad.h"
#include "lib_zip.h"
#include "m_cookie.h"
#include "m_lua.h"
#include "m_trans.h"
#include "main.h"
#include "raw_def.h"
#include "sys_assert.h"
#include "sys_endian.h"
#include "sys_macro.h"
#include "sys_xoshiro.h"

// SLUMP for Vanilla Doom
#include "slump.h"

extern void        CSG_DOOM_Write();
extern std::string BestDirectory();

extern int ef_solid_type;
extern int ef_liquid_type;
extern int ef_thing_mode;

static std::string level_name;
static std::string level_description;

int Doom::sub_format;

int dm_offset_map;

static qLump_c *header_lump;
static qLump_c *thing_lump;
static qLump_c *vertex_lump;
static qLump_c *sector_lump;
static qLump_c *sidedef_lump;
static qLump_c *linedef_lump;
static qLump_c *textmap_lump;
static qLump_c *endmap_lump;

static int errors_seen;

std::string current_port;
bool        build_nodes;

int udmf_vertexes;
int udmf_sectors;
int udmf_linedefs;
int udmf_things;
int udmf_sidedefs;

enum wad_section_e
{
    SECTION_Patches = 0,
    SECTION_Sprites,
    SECTION_Colormaps,
    SECTION_ZDoomTex,
    SECTION_Flats,

    NUM_SECTIONS
};

enum map_format_e
{
    FORMAT_BINARY = 0,
    FORMAT_UDMF
};

map_format_e map_format;
static bool  UDMF_mode;

static std::vector<qLump_c *> *sections[NUM_SECTIONS];

static const char *section_markers[NUM_SECTIONS][2] = {
    {"PP_START", "PP_END"},
    {"SS_START", "SS_END"},
    {"C_START", "C_END"},
    {"TX_START", "TX_END"},

    // flats must end with F_END (a single 'F') to be vanilla compatible
    {"FF_START", "F_END"}};

// Empty script numbers matching Korax requirements to prevent errors being
// thrown
static constexpr uint8_t empty_korax_behavior[128] = {
    0x41, 0x43, 0x53, 0x00, 0x24, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00,
    0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x07, 0x00,
    0x00, 0x00, 0xF9, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFA, 0x00, 0x00, 0x00, 0x0C,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFB, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0xFC, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFD, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0xFE, 0x00, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00,
    0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

qLump_c::qLump_c() : buffer(), crlf(false)
{
}

qLump_c::~qLump_c()
{
}

int qLump_c::GetSize() const
{
    return (int)buffer.size();
}

const uint8_t *qLump_c::GetBuffer() const
{
    return buffer.empty() ? nullptr : &buffer[0];
}

void qLump_c::Append(const void *data, uint32_t len)
{
    if (len == 0)
    {
        return;
    }

    uint32_t old_size = buffer.size();
    uint32_t new_size = old_size + len;

    buffer.resize(new_size);

    memcpy(&buffer[old_size], data, len);
}

void qLump_c::Append(qLump_c *other)
{
    if (other->buffer.size() > 0)
    {
        Append(&other->buffer[0], other->buffer.size());
    }
}

void qLump_c::Prepend(const void *data, uint32_t len)
{
    if (len == 0)
    {
        return;
    }

    uint32_t old_size = buffer.size();
    uint32_t new_size = old_size + len;

    buffer.resize(new_size);

    if (old_size > 0)
    {
        memmove(&buffer[len], &buffer[0], old_size);
    }
    memcpy(&buffer[0], data, len);
}

void qLump_c::AddByte(uint8_t value)
{
    Append(&value, 1);
}

void qLump_c::RawPrintf(const char *str)
{
    if (!crlf)
    {
        Append(str, strlen(str));
        return;
    }

    // convert each newline into CR/LF pair
    while (*str)
    {
        const char *next = strchr(str, '\n');

        Append(str, next ? (next - str) : strlen(str));

        if (!next)
        {
            break;
        }

        Append("\r\n", 2);

        str = next + 1;
    }
}

void qLump_c::Printf(const char *str, ...)
{
    static char msg_buf[OBSIDIAN_MSG_BUF_LEN];

    va_list args;

    va_start(args, str);
    vsnprintf(msg_buf, OBSIDIAN_MSG_BUF_LEN - 1, str, args);
    va_end(args);

    msg_buf[OBSIDIAN_MSG_BUF_LEN - 2] = 0;

    RawPrintf(msg_buf);
}

void qLump_c::KeyPair(const char *key, const char *val, ...)
{
    static char v_buffer[OBSIDIAN_MSG_BUF_LEN];

    va_list args;

    va_start(args, val);
    vsnprintf(v_buffer, OBSIDIAN_MSG_BUF_LEN - 1, val, args);
    va_end(args);

    v_buffer[OBSIDIAN_MSG_BUF_LEN - 2] = 0;

    RawPrintf("\"");
    RawPrintf(key);
    RawPrintf("\" \"");
    RawPrintf(v_buffer);
    RawPrintf("\"\n");
}

void qLump_c::SetCRLF(bool enable)
{
    crlf = enable;
}

qLump_c *BSP_CreateInfoLump()
{
    qLump_c *L = new qLump_c();

    L->SetCRLF(true);

    L->Printf("\n");
    L->Printf("-- Levels created by OBSIDIAN %s \"%s\"\n", OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str());
    L->Printf("-- Build %s\n", OBSIDIAN_VERSION);
    L->Printf("-- Based on the OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n");
    L->Printf("-- %s\n", OBSIDIAN_WEBSITE);
    L->Printf("\n");

    std::vector<std::string> lines;

    ob_read_all_config(&lines, false /* need_full */);

    for (unsigned int i = 0; i < lines.size(); i++)
    {
        L->Printf("%s\n", lines[i].c_str());
    }

    L->Printf("\n\n\n");

    // terminate lump with ^Z and a NUL character
    static const uint8_t terminator[2] = {26, 0};

    L->Append(terminator, 2);

    return L;
}

//----------------------------------------------------------------------------
//  AJBSP NODE BUILDING
//----------------------------------------------------------------------------

// TODO: Have the new GUI use this
static float node_progress = 0.0f;

namespace Doom
{

void Send_Prog_Nodes(int progress, int num_maps)
{
    node_progress = (float)progress / (float)num_maps;
    ob_build_step = _("Nodes");
}

bool BuildNodes(std::string filename)
{
    LogPrint("\n");

    if (!build_nodes)
    {
        return true;
    }

    // Prep AJBSP parameters
    ajbsp::buildinfo_t build_info;
    build_info.fast = true;
    if (StringCompare(current_port, "limit_enforcing") == 0 || StringCompare(current_port, "boom") == 0)
    {
        build_info.gl_nodes    = false;
        build_info.force_v5    = false;
        build_info.force_xnod  = false;
        build_info.do_blockmap = true;
        build_info.do_reject   = true;
    }
    else
    { // ZDoom
        build_info.gl_nodes       = true;
        build_info.do_reject      = false;
        build_info.do_blockmap    = false;
        build_info.force_xnod     = true;
        build_info.force_compress = true;
    }

    if (ajbsp::BuildNodes(filename, &build_info) != 0)
    {
        ProgStatus("%s", _("AJBSP Error!"));
        return false;
    }

    return true;
}

} // namespace Doom

//------------------------------------------------------------------------
//  WAD OUTPUT
//------------------------------------------------------------------------

namespace Doom
{
void WriteLump(std::string_view name, const void *data, uint32_t len)
{
    SYS_ASSERT(name.size() <= 8);

    WAD_NewLump(name);

    if (len > 0)
    {
        if (!WAD_AppendData(data, len))
        {
            errors_seen++;
        }
    }

    WAD_FinishLump();
}
} // namespace Doom

void Doom::WriteLump(std::string_view name, qLump_c *lump)
{
    WriteLump(name, lump->GetBuffer(), lump->GetSize());
}

namespace Doom
{
static void WriteBehavior()
{
    // Keep this in case we need BEHAVIOR LUMPS in non-Hexen games

    /*raw_behavior_header_t behavior;

    std::string_view acs{"ACS"};
    memcpy(behavior.marker, acs.data(), 4);

    behavior.offset = LE_U32(8);
    behavior.func_num = 0;
    behavior.str_num = 0;

    WriteLump("BEHAVIOR", &behavior, sizeof(behavior));*/

    WriteLump("BEHAVIOR", empty_korax_behavior, 128);
}

static void ClearSections()
{
    for (int k = 0; k < NUM_SECTIONS; k++)
    {
        if (!sections[k])
        {
            sections[k] = new std::vector<qLump_c *>;
        }

        for (unsigned int n = 0; n < sections[k]->size(); n++)
        {
            delete sections[k]->at(n);
            sections[k]->at(n) = nullptr;
        }

        sections[k]->clear();
    }
}

static void WriteSections()
{
    for (int k = 0; k < NUM_SECTIONS; k++)
    {
        if (sections[k]->empty())
        {
            continue;
        }

        WriteLump(section_markers[k][0], nullptr, 0);

        for (auto *lump : *sections[k])
        {
            WriteLump(lump->name.c_str(), lump);
        }

        WriteLump(section_markers[k][1], nullptr, 0);
    }
}

} // namespace Doom

void Doom::AddSectionLump(char ch, std::string_view name, qLump_c *lump)
{
    int k;
    switch (ch)
    {
    case 'P':
        k = SECTION_Patches;
        break;
    case 'S':
        k = SECTION_Sprites;
        break;
    case 'C':
        k = SECTION_Colormaps;
        break;
    case 'T':
        k = SECTION_ZDoomTex;
        break;
    case 'F':
        k = SECTION_Flats;
        break;

    default:
        FatalError("DM_AddSectionLump: bad section '%c'\n", ch);
    }

    lump->name = name;

    sections[k]->push_back(lump);
}

bool Doom::StartWAD(const std::string &filename)
{
    if (!WAD_OpenWrite(filename))
    {
        ob_error_message = StringFormat(_("Unable to create wad file:\n\n%s"), strerror(errno));
        return false;
    }

    errors_seen = 0;

    ClearSections();

    qLump_c *info = BSP_CreateInfoLump();
    if (game_object->file_per_map)
    {
        ZIPF_AddMem("OBSIDATA.txt", (uint8_t *)info->GetBuffer(), info->GetSize());
    }
    else
    {
        WriteLump("OBSIDATA", info);
    }
    delete info;

    return true; // OK
}

bool Doom::EndWAD()
{
    WriteSections();
    ClearSections();

    WAD_CloseWrite();

    return errors_seen == 0;
}

namespace Doom
{
static void FreeLumps()
{
    delete header_lump;
    header_lump = nullptr;
    if (!UDMF_mode)
    {
        delete thing_lump;
        thing_lump = nullptr;
        delete sector_lump;
        sector_lump = nullptr;
        delete vertex_lump;
        vertex_lump = nullptr;
        delete sidedef_lump;
        sidedef_lump = nullptr;
        delete linedef_lump;
        linedef_lump = nullptr;
    }
    else
    {
        delete textmap_lump;
        textmap_lump = nullptr;
        delete endmap_lump;
        endmap_lump = nullptr;
    }
}
} // namespace Doom

void Doom::BeginLevel()
{
    FreeLumps();

    header_lump = new qLump_c();
    if (!UDMF_mode)
    {
        thing_lump   = new qLump_c();
        vertex_lump  = new qLump_c();
        sector_lump  = new qLump_c();
        linedef_lump = new qLump_c();
        sidedef_lump = new qLump_c();
    }
    else
    {
        textmap_lump = new qLump_c();
        if (sub_format == SUBFMT_Hexen)
        {
            textmap_lump->Printf("namespace = \"Hexen\";\n\n");
        }
        else
        {
            textmap_lump->Printf("namespace = \"ZDoomTranslated\";\n\n");
        }
        endmap_lump = new qLump_c();
    }
}

int Doom::v094_begin_level(lua_State *L)
{
    BeginLevel();
    return 0;
}

void Doom::EndLevel(const std::string &level_name)
{
    // terminate header lump with trailing NUL
    if (header_lump->GetSize() > 0)
    {
        const uint8_t nuls[4] = {0, 0, 0, 0};
        header_lump->Append(nuls, 1);
    }

    // in case we need it
    std::string level_wad = PathAppend(home_dir, StringFormat("%s.wad", level_name.c_str()));

    if (game_object->file_per_map)
    {
        WAD_CloseWrite();
        if (!WAD_OpenWrite(level_wad))
        { // Just stick it in the resource WAD?
            WAD_OpenWrite(game_object->Filename());
        }
    }

    WriteLump(level_name, header_lump);

    if (UDMF_mode)
    {
        WriteLump("TEXTMAP", textmap_lump);
    }

    if (!UDMF_mode)
    {
        WriteLump("THINGS", thing_lump);
        WriteLump("LINEDEFS", linedef_lump);
        WriteLump("SIDEDEFS", sidedef_lump);
        WriteLump("VERTEXES", vertex_lump);

        WriteLump("SEGS", NULL, 0);
        WriteLump("SSECTORS", NULL, 0);
        WriteLump("NODES", NULL, 0);
        WriteLump("SECTORS", sector_lump);
        if (sub_format == SUBFMT_Hexen)
        {
            WriteBehavior();
        }
    }
    else
    {
        if (sub_format == SUBFMT_Hexen)
        {
            WriteBehavior();
        }
        WriteLump("ENDMAP", NULL, 0);
    }

    FreeLumps();

    if (game_object->file_per_map)
    {
        WAD_CloseWrite();
        Doom::BuildNodes(level_wad);
        if (!ZIPF_AddFile(level_wad, "maps"))
        {
            FileDelete(level_wad);
            ZIPF_CloseWrite();
            FileDelete(game_object->ZIP_Filename());
            FileDelete(game_object->Filename());
            FatalError(_("Error writing map WAD to %s\n"), game_object->ZIP_Filename().c_str());
        }
        else
        {
            FileDelete(level_wad);
        }
        WAD_OpenWrite(game_object->Filename());
    }
}

int Doom::v094_end_level(lua_State *L)
{
    const char *levelname = luaL_checkstring(L, 1);
    EndLevel(levelname);
    return 0;
}

//------------------------------------------------------------------------

void Doom::HeaderPrintf(const char *str, ...)
{
    static char message_buf[OBSIDIAN_MSG_BUF_LEN];

    va_list args;

    va_start(args, str);
    vsnprintf(message_buf, OBSIDIAN_MSG_BUF_LEN, str, args);
    va_end(args);

    message_buf[OBSIDIAN_MSG_BUF_LEN - 1] = 0;

    header_lump->Append(message_buf, strlen(message_buf));
}

void Doom::AddVertex(int x, int y)
{
    if (dm_offset_map)
    {
        x += 32;
        y += 32;
    }

    if (!UDMF_mode)
    {
        raw_vertex_t vert;

        vert.x = LE_S16(x);
        vert.y = LE_S16(y);
        vertex_lump->Append(&vert, sizeof(vert));
    }
    else
    {
        textmap_lump->Printf("\nvertex\n{\n");
        textmap_lump->Printf("\tx = %f;\n", (double)x);
        textmap_lump->Printf("\ty = %f;\n", (double)y);
        textmap_lump->Printf("}\n");
        udmf_vertexes += 1;
    }
}

int Doom::v094_add_vertex(lua_State *L)
{
    int x = luaL_checkinteger(L, 1);
    int y = luaL_checkinteger(L, 2);
    AddVertex(x, y);
    return 0;
}

void Doom::AddSector(int f_h, const std::string &f_tex, int c_h, const std::string &c_tex, int light, int special,
                     int tag)
{
    if (!UDMF_mode)
    {
        raw_sector_t sec;

        sec.floorh = LE_S16(f_h);
        sec.ceilh  = LE_S16(c_h);

        memcpy(sec.floor_tex, f_tex.data(), 8);
        memcpy(sec.ceil_tex, c_tex.data(), 8);

        sec.light = LE_U16(light);
        sec.type  = LE_U16(special);
        sec.tag   = LE_S16(tag);
        sector_lump->Append(&sec, sizeof(sec));
    }
    else
    {
        textmap_lump->Printf("\nsector\n{\n");
        textmap_lump->Printf("\theightfloor = %d;\n", f_h);
        textmap_lump->Printf("\theightceiling = %d;\n", c_h);
        textmap_lump->Printf("\ttexturefloor = \"%s\";\n", f_tex.c_str());
        textmap_lump->Printf("\ttextureceiling = \"%s\";\n", c_tex.c_str());
        textmap_lump->Printf("\tlightlevel = %d;\n", light);
        textmap_lump->Printf("\tspecial = %d;\n", special);
        textmap_lump->Printf("\tid = %d;\n", tag);
        textmap_lump->Printf("}\n");
        udmf_sectors += 1;
    }
}

int Doom::v094_add_sector(lua_State *L)
{
    int         f_h     = luaL_checkinteger(L, 1);
    int         c_h     = luaL_checkinteger(L, 2);
    const char *f_tex   = luaL_checkstring(L, 3);
    const char *c_tex   = luaL_checkstring(L, 4);
    int         light   = luaL_checkinteger(L, 5);
    int         special = luaL_checkinteger(L, 6);
    int         tag     = luaL_checkinteger(L, 7);
    AddSector(f_h, f_tex, c_h, c_tex, light, special, tag);
    return 0;
}

void Doom::AddSidedef(int sector, const std::string &l_tex, const std::string &m_tex, const std::string &u_tex,
                      int x_offset, int y_offset)
{
    if (!UDMF_mode)
    {
        raw_sidedef_t side;

        side.sector = LE_S16(sector);

        memcpy(side.lower_tex, l_tex.data(), 8);
        memcpy(side.mid_tex, m_tex.data(), 8);
        memcpy(side.upper_tex, u_tex.data(), 8);

        side.x_offset = LE_S16(x_offset);
        side.y_offset = LE_S16(y_offset);
        sidedef_lump->Append(&side, sizeof(side));
    }
    else
    {
        textmap_lump->Printf("\nsidedef\n{\n");
        textmap_lump->Printf("\toffsetx = %d;\n", x_offset);
        textmap_lump->Printf("\toffsety = %d;\n", y_offset);
        textmap_lump->Printf("\ttexturetop = \"%s\";\n", u_tex.c_str());
        textmap_lump->Printf("\ttexturemiddle = \"%s\";\n", m_tex.c_str());
        textmap_lump->Printf("\ttexturebottom = \"%s\";\n", l_tex.c_str());
        textmap_lump->Printf("\tsector = %d;\n", sector);
        textmap_lump->Printf("}\n");
        udmf_sidedefs += 1;
    }
}

int Doom::v094_add_sidedef(lua_State *L)
{
    int         sector   = luaL_checkinteger(L, 1);
    const char *l_tex    = luaL_checkstring(L, 2);
    const char *m_tex    = luaL_checkstring(L, 3);
    const char *u_tex    = luaL_checkstring(L, 4);
    int         x_offset = luaL_checkinteger(L, 5);
    int         y_offset = luaL_checkinteger(L, 6);
    AddSidedef(sector, l_tex, m_tex, u_tex, x_offset, y_offset);
    return 0;
}

void Doom::AddLinedef(int vert1, int vert2, int side1, int side2, int type, int flags, int tag, const uint8_t *args)
{
    if (sub_format != SUBFMT_Hexen)
    {
        if (!UDMF_mode)
        {
            raw_linedef_t line;

            line.start = LE_U16(vert1);
            line.end   = LE_U16(vert2);

            line.right = side1 < 0 ? 0xFFFF : LE_U16(side1);
            line.left  = side2 < 0 ? 0xFFFF : LE_U16(side2);

            line.type  = LE_U16(type);
            line.flags = LE_U16(flags);
            line.tag   = LE_U16(tag);
            linedef_lump->Append(&line, sizeof(line));
        }
        else
        {
            textmap_lump->Printf("\nlinedef\n{\n");
            textmap_lump->Printf("\tid = %d;\n", tag);
            textmap_lump->Printf("\tv1 = %d;\n", vert1);
            textmap_lump->Printf("\tv2 = %d;\n", vert2);
            textmap_lump->Printf("\tsidefront = %d;\n", side1 < 0 ? -1 : side1);
            textmap_lump->Printf("\tsideback = %d;\n", side2 < 0 ? -1 : side2);
            textmap_lump->Printf("\targ0 = %d;\n", tag);
            textmap_lump->Printf("\tspecial = %d;\n", type);
            std::bitset<16> udmf_flags(flags);
            if (udmf_flags.test(0))
            {
                textmap_lump->Printf("\tblocking = true;\n");
            }
            if (udmf_flags.test(1))
            {
                textmap_lump->Printf("\tblockmonsters = true;\n");
            }
            if (udmf_flags.test(2))
            {
                textmap_lump->Printf("\ttwosided = true;\n");
            }
            if (udmf_flags.test(3))
            {
                textmap_lump->Printf("\tdontpegtop = true;\n");
            }
            if (udmf_flags.test(4))
            {
                textmap_lump->Printf("\tdontpegbottom = true;\n");
            }
            if (udmf_flags.test(5))
            {
                textmap_lump->Printf("\tsecret = true;\n");
            }
            if (udmf_flags.test(6))
            {
                textmap_lump->Printf("\tblocksound = true;\n");
            }
            if (udmf_flags.test(7))
            {
                textmap_lump->Printf("\tdontdraw = true;\n");
            }
            if (udmf_flags.test(8))
            {
                textmap_lump->Printf("\tmapped = true;\n");
            }
            if (udmf_flags.test(9))
            {
                textmap_lump->Printf("\tpassuse = true;\n");
            }
            textmap_lump->Printf("}\n");
            udmf_linedefs += 1;
        }
    }
    else // Hexen format
    {
        if (!UDMF_mode)
        {
            raw_hexen_linedef_t line;

            // clear unused fields (esp. arguments)
            memset(&line, 0, sizeof(line));

            line.start = LE_U16(vert1);
            line.end   = LE_U16(vert2);

            line.right = side1 < 0 ? 0xffff : LE_U16(side1);
            line.left  = side2 < 0 ? 0xffff : LE_U16(side2);

            line.type  = type; // 8 bits
            line.flags = LE_U16(flags);

            // tag value is UNUSED

            if (args)
            {
                memcpy(line.args, args, 5);
            }

            linedef_lump->Append(&line, sizeof(line));
        }
        else
        {
            textmap_lump->Printf("\nlinedef\n{\n");
            if (type == 121)
            {
                textmap_lump->Printf("\tid = %d;\n", args[0]);
            }
            textmap_lump->Printf("\tv1 = %d;\n", vert1);
            textmap_lump->Printf("\tv2 = %d;\n", vert2);
            textmap_lump->Printf("\tsidefront = %d;\n", side1 < 0 ? -1 : side1);
            textmap_lump->Printf("\tsideback = %d;\n", side2 < 0 ? -1 : side2);
            if (type == 121)
            {
                textmap_lump->Printf("\tspecial = 0;\n");
                textmap_lump->Printf("\targ0 = 0;\n");
            }
            else
            {
                textmap_lump->Printf("\tspecial = %d;\n", type);
                textmap_lump->Printf("\targ0 = %d;\n", args[0]);
            }
            textmap_lump->Printf("\targ1 = %d;\n", args[1]);
            textmap_lump->Printf("\targ2 = %d;\n", args[2]);
            textmap_lump->Printf("\targ3 = %d;\n", args[3]);
            textmap_lump->Printf("\targ4 = %d;\n", args[4]);
            std::bitset<16> udmf_flags(flags);
            if (udmf_flags.test(0))
            {
                textmap_lump->Printf("\tblocking = true;\n");
            }
            if (udmf_flags.test(1))
            {
                textmap_lump->Printf("\tblockmonsters = true;\n");
            }
            if (udmf_flags.test(2))
            {
                textmap_lump->Printf("\ttwosided = true;\n");
            }
            if (udmf_flags.test(3))
            {
                textmap_lump->Printf("\tdontpegtop = true;\n");
            }
            if (udmf_flags.test(4))
            {
                textmap_lump->Printf("\tdontpegbottom = true;\n");
            }
            if (udmf_flags.test(5))
            {
                textmap_lump->Printf("\tsecret = true;\n");
            }
            if (udmf_flags.test(6))
            {
                textmap_lump->Printf("\tblocksound = true;\n");
            }
            if (udmf_flags.test(7))
            {
                textmap_lump->Printf("\tdontdraw = true;\n");
            }
            if (udmf_flags.test(8))
            {
                textmap_lump->Printf("\tmapped = true;\n");
            }
            if (udmf_flags.test(9))
            {
                textmap_lump->Printf("\trepeatspecial = true;\n");
            }
            int spac = (flags & 0x1C00) >> 10;
            if (type > 0)
            {
                if (spac == 0)
                {
                    textmap_lump->Printf("\tplayercross = true;\n");
                }
                if (spac == 1)
                {
                    textmap_lump->Printf("\tplayeruse = true;\n");
                }
                if (spac == 2)
                {
                    textmap_lump->Printf("\tmonstercross = true;\n");
                }
                if (spac == 3)
                {
                    textmap_lump->Printf("\timpact = true;\n");
                }
                if (spac == 4)
                {
                    textmap_lump->Printf("\tplayerpush = true;\n");
                }
                if (spac == 5)
                {
                    textmap_lump->Printf("\tmissilecross = true;\n");
                }
            }
            textmap_lump->Printf("}\n");
            udmf_linedefs += 1;
        }
    }
}

int v094_grab_args(lua_State *L, uint8_t *args, int stack_pos)
{

    int what = lua_type(L, stack_pos);

    if (what == LUA_TNONE || what == LUA_TNIL)
    {
        return 0;
    }

    if (what != LUA_TTABLE)
    {
        return luaL_argerror(L, stack_pos, "expected a table");
    }

    for (int i = 0; i < 5; i++)
    {
        lua_pushinteger(L, i + 1);
        lua_gettable(L, stack_pos);

        if (lua_isnumber(L, -1))
        {
            args[i] = lua_tointeger(L, -1);
        }

        lua_pop(L, 1);
    }

    return 0;
}

int Doom::v094_add_linedef(lua_State *L)
{
    int      vert1 = luaL_checkinteger(L, 1);
    int      vert2 = luaL_checkinteger(L, 2);
    int      side1 = luaL_checkinteger(L, 3);
    int      side2 = luaL_checkinteger(L, 4);
    int      type  = luaL_checkinteger(L, 5);
    int      flags = luaL_checkinteger(L, 6);
    int      tag   = luaL_checkinteger(L, 7);
    uint8_t *args  = new uint8_t[5];
    v094_grab_args(L, args, 8);
    AddLinedef(vert1, vert2, side1, side2, type, flags, tag, args);
    delete[] args;
    return 0;
}

void Doom::AddThing(int x, int y, int h, int type, int angle, int options, int tid, uint8_t special,
                    const uint8_t *args)
{
    if (dm_offset_map)
    {
        x += 32;
        y += 32;
    }

    if (sub_format != SUBFMT_Hexen)
    {
        if (!UDMF_mode)
        {
            raw_thing_t thing;

            thing.x = LE_S16(x);
            thing.y = LE_S16(y);

            thing.type    = LE_U16(type);
            thing.angle   = LE_S16(angle);
            thing.options = LE_U16(options);
            thing_lump->Append(&thing, sizeof(thing));
        }
        else
        {
            textmap_lump->Printf("\nthing\n{\n");
            textmap_lump->Printf("\tx = %f;\n", (double)x);
            textmap_lump->Printf("\ty = %f;\n", (double)y);
            textmap_lump->Printf("\ttype = %d;\n", type);
            textmap_lump->Printf("\tangle = %d;\n", angle);
            std::bitset<16> udmf_flags(options);
            if (udmf_flags.test(0))
            {
                textmap_lump->Printf("\tskill1 = true;\n");
                textmap_lump->Printf("\tskill2 = true;\n");
            }
            if (udmf_flags.test(1))
            {
                textmap_lump->Printf("\tskill3 = true;\n");
            }
            if (udmf_flags.test(2))
            {
                textmap_lump->Printf("\tskill4 = true;\n");
                textmap_lump->Printf("\tskill5 = true;\n");
            }
            if (udmf_flags.test(3))
            {
                textmap_lump->Printf("\tambush = true;\n");
            }
            if (udmf_flags.test(4))
            {
                textmap_lump->Printf("\tsingle = false;\n");
            }
            else
            {
                textmap_lump->Printf("\tsingle = true;\n");
            }
            if (udmf_flags.test(5))
            {
                textmap_lump->Printf("\tdm = false;\n");
            }
            else
            {
                textmap_lump->Printf("\tdm = true;\n");
            }
            if (udmf_flags.test(6))
            {
                textmap_lump->Printf("\tcoop = false;\n");
            }
            else
            {
                textmap_lump->Printf("\tcoop = true;\n");
            }
            if (udmf_flags.test(7))
            {
                textmap_lump->Printf("\tfriend = true;\n");
            }
            // Testing fix for compatibility with ZDoom mods that add classes in
            // games other than Hexen
            textmap_lump->Printf("\tclass1 = true;\n");
            textmap_lump->Printf("\tclass2 = true;\n");
            textmap_lump->Printf("\tclass3 = true;\n");
            textmap_lump->Printf("}\n");
            udmf_things += 1;
        }
    }
    else // Hexen format
    {
        if (!UDMF_mode)
        {
            raw_hexen_thing_t thing;

            // clear unused fields (esp. arguments)
            memset(&thing, 0, sizeof(thing));

            thing.x = LE_S16(x);
            thing.y = LE_S16(y);

            if (ob_hexen_ceiling_check(type))
            {
                thing.height = 0;
            }
            else
            {
                thing.height = LE_S16(h);
            }
            thing.type    = LE_U16(type);
            thing.angle   = LE_S16(angle);
            thing.options = LE_U16(options);

            thing.tid     = LE_S16(tid);
            thing.special = special;

            if (args)
            {
                memcpy(thing.args, args, 5);
            }

            thing_lump->Append(&thing, sizeof(thing));
        }
        else
        {
            textmap_lump->Printf("\nthing\n{\n");
            textmap_lump->Printf("\tid = %d;\n", tid);
            textmap_lump->Printf("\tx = %f;\n", (double)x);
            textmap_lump->Printf("\ty = %f;\n", (double)y);
            if (ob_hexen_ceiling_check(type))
            {
                textmap_lump->Printf("\theight = %f;\n", 0);
            }
            else
            {
                textmap_lump->Printf("\theight = %f;\n", (double)h);
            }
            textmap_lump->Printf("\ttype = %d;\n", type);
            textmap_lump->Printf("\tangle = %d;\n", angle);
            std::bitset<16> udmf_flags(options);
            if (udmf_flags.test(0))
            {
                textmap_lump->Printf("\tskill1 = true;\n");
                textmap_lump->Printf("\tskill2 = true;\n");
            }
            if (udmf_flags.test(1))
            {
                textmap_lump->Printf("\tskill3 = true;\n");
            }
            if (udmf_flags.test(2))
            {
                textmap_lump->Printf("\tskill4 = true;\n");
                textmap_lump->Printf("\tskill5 = true;\n");
            }
            if (udmf_flags.test(3))
            {
                textmap_lump->Printf("\tambush = true;\n");
            }
            if (udmf_flags.test(4))
            {
                textmap_lump->Printf("\tdormant = true;\n");
            }
            if (udmf_flags.test(5))
            {
                textmap_lump->Printf("\tclass1 = true;\n");
            }
            if (udmf_flags.test(6))
            {
                textmap_lump->Printf("\tclass2 = true;\n");
            }
            if (udmf_flags.test(7))
            {
                textmap_lump->Printf("\tclass3 = true;\n");
            }
            if (udmf_flags.test(8))
            {
                textmap_lump->Printf("\tsingle = true;\n");
            }
            if (udmf_flags.test(9))
            {
                textmap_lump->Printf("\tcoop = true;\n");
            }
            if (udmf_flags.test(10))
            {
                textmap_lump->Printf("\tdm = true;\n");
            }
            textmap_lump->Printf("\tspecial = %d;\n", special);
            if (args)
            {
                textmap_lump->Printf("\targ0 = %d;\n", args[0]);
                textmap_lump->Printf("\targ1 = %d;\n", args[1]);
                textmap_lump->Printf("\targ2 = %d;\n", args[2]);
                textmap_lump->Printf("\targ3 = %d;\n", args[3]);
                textmap_lump->Printf("\targ4 = %d;\n", args[4]);
            }
            textmap_lump->Printf("}\n");
            udmf_things += 1;
        }
    }
}

int Doom::v094_add_thing(lua_State *L)
{
    int      x       = luaL_checkinteger(L, 1);
    int      y       = luaL_checkinteger(L, 2);
    int      h       = luaL_checkinteger(L, 3);
    int      type    = luaL_checkinteger(L, 4);
    int      angle   = luaL_checkinteger(L, 5);
    int      options = luaL_checkinteger(L, 6);
    int      tid     = luaL_checkinteger(L, 7);
    uint8_t  special = luaL_checkinteger(L, 8);
    uint8_t *args    = new uint8_t[5];
    v094_grab_args(L, args, 9);
    AddThing(x, y, h, type, angle, options, tid, special, args);
    delete[] args;
    return 0;
}

int Doom::NumVertexes()
{
    if (!UDMF_mode)
    {
        return vertex_lump->GetSize() / sizeof(raw_vertex_t);
    }
    return udmf_vertexes;
}

int Doom::NumSectors()
{
    if (!UDMF_mode)
    {
        return sector_lump->GetSize() / sizeof(raw_sector_t);
    }
    return udmf_sectors;
}

int Doom::NumSidedefs()
{
    if (!UDMF_mode)
    {
        return sidedef_lump->GetSize() / sizeof(raw_sidedef_t);
    }
    return udmf_sidedefs;
}

int Doom::NumLinedefs()
{
    if (!UDMF_mode)
    {
        if (sub_format == SUBFMT_Hexen)
        {
            return linedef_lump->GetSize() / sizeof(raw_hexen_linedef_t);
        }

        return linedef_lump->GetSize() / sizeof(raw_linedef_t);
    }
    return udmf_linedefs;
}

int Doom::NumThings()
{
    if (!UDMF_mode)
    {
        if (sub_format == SUBFMT_Hexen)
        {
            return thing_lump->GetSize() / sizeof(raw_hexen_thing_t);
        }

        return thing_lump->GetSize() / sizeof(raw_thing_t);
    }
    return udmf_things;
}

//------------------------------------------------------------------------

namespace Doom
{
class game_interface_c : public ::game_interface_c
{
  private:
    std::string filename;
    std::string zip_filename;
    bool        compress_output;

  public:
    game_interface_c() : filename(""), zip_filename(""), compress_output(false)
    {
    }

    bool Start(const char *preset);
    bool Finish(bool build_ok);

    void        BeginLevel();
    void        EndLevel();
    void        Property(std::string key, std::string value);
    std::string Filename();
    std::string ZIP_Filename();
};
} // namespace Doom

bool Doom::game_interface_c::Start(const char *preset)
{
    sub_format = 0;

    ef_solid_type  = 0;
    ef_liquid_type = 0;
    ef_thing_mode  = 0;

    current_port    = ob_get_param("port");
    compress_output = ob_mod_enabled("compress_output");
    file_per_map    = (compress_output && StringCompare(current_port, "limit_enforcing") != 0);

    ob_invoke_hook("pre_setup");

    if (IsPathAbsolute(batch_output_file))
    {
        filename = batch_output_file;
    }
    else
    {
        filename = PathAppend(CurrentDirectoryGet(), batch_output_file);
    }
    if (compress_output)
    {
        zip_filename = filename;
        ReplaceExtension(zip_filename, ".pk3");
    }

    if (filename.empty())
    {
        ProgStatus("%s", _("Cancelled"));
        return false;
    }

    if (file_per_map)
    {
        filename = PathAppend(home_dir, "temp/resources.wad");
    }
    else
    {
        ReplaceExtension(filename, ".wad");
    }

    if (create_backups && !file_per_map)
    {
        Main::BackupFile(filename);
    }

    // Need to preempt the rest of this process for now if we are using Vanilla
    // Doom
    if (StringCompare(current_port, "limit_enforcing") == 0)
    {
        map_format  = FORMAT_BINARY;
        build_nodes = true;
        ob_build_progress = 0.0f;
        ob_build_step.clear();
        return true;
    }

    if (compress_output)
    {
        if (FileExists(zip_filename))
        {
            if (create_backups)
            {
                Main::BackupFile(zip_filename);
            }
            FileDelete(zip_filename);
        }
        if (!ZIPF_OpenWrite(zip_filename))
        {
            ProgStatus("%s", _("Error (create PK3/ZIP)"));
            return false;
        }
    }

    if (!StartWAD(filename))
    {
        ProgStatus("%s", _("Error (create file)"));
        return false;
    }

    ob_build_progress = 0.20f;
    ob_build_step = _("CSG");

    if (StringCompare(current_port, "zdoom") == 0)
    {
        map_format  = FORMAT_UDMF;
        build_nodes = ob_mod_enabled("build_nodes");
    }
    else if (StringCompare(current_port, "edge") == 0)
    {
        map_format  = FORMAT_UDMF;
        build_nodes = false;
    }
    else
    {
        map_format  = FORMAT_BINARY;
        build_nodes = true;
    }
    if (map_format == FORMAT_UDMF)
    {
        UDMF_mode = true;
        setlocale(LC_NUMERIC, "C");
    }
    else
    {
        UDMF_mode = false;
    }
    return true;
}

bool Doom::game_interface_c::Finish(bool build_ok)
{
    // Skip DM_EndWAD if using Vanilla Doom
    if (StringCompare(current_port, "limit_enforcing") != 0)
    {
        // TODO: handle write errors
        EndWAD();
    }
    else
    {
        build_ok = slump::BuildLevels(filename);
    }

    if (UDMF_mode)
    {
        setlocale(LC_NUMERIC, numeric_locale.c_str());
    }

    if (build_ok)
    {
        build_ok = Doom::BuildNodes(filename);
    }

    if (!build_ok)
    {
        // remove the WAD if an error occurred
        if (!preserve_failures)
        {
            FileDelete(filename);
        }
    }
    
    if (build_ok)
    {
        if (compress_output)
        {
            if (!ZIPF_AddFile(filename, ""))
            {
                LogPrint("Adding WAD to PK3 failed! Retaining original "
                         "WAD.\n");
                ZIPF_CloseWrite();
                FileDelete(zip_filename);
            }
            else
            {
                if (!ZIPF_CloseWrite())
                {
                    LogPrint("Corrupt PK3! Retaining original WAD.\n");
                    FileDelete(zip_filename);
                }
                else
                {
                    FileDelete(filename);
                }
            }
        }
    }

    return build_ok;
}

void Doom::game_interface_c::BeginLevel()
{
    udmf_vertexes = 0;
    udmf_sectors  = 0;
    udmf_linedefs = 0;
    udmf_things   = 0;
    udmf_sidedefs = 0;
    Doom::BeginLevel();
}

void Doom::game_interface_c::Property(std::string key, std::string value)
{
    if (StringCompare(key, "level_name") == 0)
    {
        level_name = value;
    }
    else if (StringCompare(key, "description") == 0)
    {
        level_description = value;
    }
    else if (StringCompare(key, "sub_format") == 0)
    {
        if (StringCompare(value, "doom") == 0)
        {
            sub_format = 0;
        }
        else if (StringCompare(value, "hexen") == 0)
        {
            sub_format = SUBFMT_Hexen;
        }
        else if (StringCompare(value, "strife") == 0)
        {
            sub_format = SUBFMT_Strife;
        }
        else
        {
            LogPrint("WARNING: unknown DOOM sub_format '%s'\n", value.c_str());
        }
    }
    else if (StringCompare(key, "offset_map") == 0)
    {
        dm_offset_map = StringToInt(value);
    }
    else if (StringCompare(key, "ef_solid_type") == 0)
    {
        ef_solid_type = StringToInt(value);
    }
    else if (StringCompare(key, "ef_liquid_type") == 0)
    {
        ef_liquid_type = StringToInt(value);
    }
    else if (StringCompare(key, "ef_thing_mode") == 0)
    {
        ef_thing_mode = StringToInt(value);
    }
    else
    {
        LogPrint("WARNING: unknown DOOM property: %s=%s\n", key.c_str(), value.c_str());
    }
}

std::string Doom::game_interface_c::Filename()
{
    return filename;
}

std::string Doom::game_interface_c::ZIP_Filename()
{
    return zip_filename;
}

void Doom::game_interface_c::EndLevel()
{
    if (level_name.empty())
    {
        FatalError("Script problem: did not set level name!\n");
    }

    ob_build_step = _("CSG");

    CSG_DOOM_Write();

    Doom::EndLevel(level_name);

    level_name.clear();

    level_description.clear();
}

game_interface_c *Doom_GameObject()
{
    return new Doom::game_interface_c();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
