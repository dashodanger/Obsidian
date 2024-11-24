//------------------------------------------------------------------------
//  LEVEL building - Wolf3d format
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2016 Andrew Apted
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

#include <string.h>

#include "lib_util.h"
#include "m_lua.h"
#include "m_trans.h"
#include "main.h"
#include "minilua.h"
#include "sys_assert.h"

static constexpr const char *TEMP_GAMEFILE = "GAMEMAPS.TMP";
static constexpr const char *TEMP_MAPTEMP  = "MAPTEMP.TMP";
static constexpr const char *TEMP_HEADFILE = "MAPHEAD.TMP";

static constexpr uint16_t RLEW_TAG = 0xABCD;

static uint8_t no_tile = 48;
static uint8_t no_obj  = 0;

/* private data */

static FILE *map_fp;
static FILE *head_fp;

static int write_errors_seen;

static int current_map; // 1 to 60
static int current_offset;

static uint16_t *solid_plane;
static uint16_t *thing_plane;

static std::string level_name;

static constexpr uint8_t PL_START = 2;

std::string        wolf_output_dir;
extern std::string BestDirectory();

//------------------------------------------------------------------------
//  WOLF OUTPUT
//------------------------------------------------------------------------

static void WF_PutU16(uint16_t val, FILE *fp)
{
    fputc(val & 0xFF, fp);
    fputc((val >> 8) & 0xFF, fp);
}

static void WF_PutU32(uint32_t val, FILE *fp)
{
    fputc(val & 0xFF, fp);
    fputc((val >> 8) & 0xFF, fp);
    fputc((val >> 16) & 0xFF, fp);
    fputc((val >> 24) & 0xFF, fp);
}

static void WF_PutNString(const char *str, int max_len, FILE *fp)
{
    for (; *str && max_len > 0; max_len--)
    {
        fputc(*str++, fp);
    }

    for (; max_len > 0; max_len--)
    {
        fputc(0, fp);
    }
}

int rle_compress_plane(uint16_t *plane, int src_len)
{
    uint16_t       *dest = plane + PL_START;
    const uint16_t *src  = plane + PL_START;
    const uint16_t *endp = plane + PL_START + (src_len / 2);

    while (src < endp)
    {
        // don't want no Carmackization...
        SYS_ASSERT((*src & 0xFF00) != 0xA700);
        SYS_ASSERT((*src & 0xFF00) != 0xA800);

        // it shouldn't match the RLEW tag either...
        SYS_ASSERT(*src != RLEW_TAG);

        // determine longest run
        int run = 1;

        while (src + run < endp && run < 100 && src[run - 1] == src[run])
        {
            run++;
        }

        if (run > 3)
        {
            // Note: use src[2] since src may == dest, hence src[0] and src[1]
            //       would get overwritten by the tag and count.

            *dest++ = RLEW_TAG; // tag
            *dest++ = run;      // count
            *dest++ = src[2];   // value

            src += run;
        }
        else
        {
            for (; run > 0; run--)
            {
                *dest++ = *src++;
            }
        }
    }

    int dest_len = 2 * (dest - plane);

    plane[0] = dest_len + 2; // compressed size (bytes)
    plane[1] = src_len;      // expanded size (bytes)

    return dest_len + 4;     // total size
}

//------------------------------------------------------------------------

static void WF_WritePlane(uint16_t *plane, int *offset, int *length)
{
    *offset = (int)ftell(map_fp);

    *length = rle_compress_plane(plane, 64 * 64 * 2);

    if (1 != fwrite(plane, *length, 1, map_fp))
    {
        if (write_errors_seen < 10)
        {
            write_errors_seen += 1;
            LogPrint("Failure writing to map file! (%d bytes)\n", *length);
        }
    }
}

static void WF_WriteBlankPlane(int *offset, int *length)
{
    *offset = (int)ftell(map_fp);

    WF_PutU16(3 * 2 + 2, map_fp);   // compressed size + 2
    WF_PutU16(64 * 64 * 2, map_fp); // expanded size

    WF_PutU16(RLEW_TAG, map_fp);    // tag
    WF_PutU16(64 * 64, map_fp);     // count
    WF_PutU16(0, map_fp);           // value

    *length = (int)ftell(map_fp);
    *length -= *offset;
}

static void WF_WriteMap(void)
{
    const auto message = StringFormat("%s %s", OBSIDIAN_TITLE.c_str(), OBSIDIAN_VERSION);

    WF_PutNString(message.c_str(), 64, map_fp);

    int plane_offsets[3];
    int plane_lengths[3];

    WF_WritePlane(solid_plane, plane_offsets + 0, plane_lengths + 0);
    WF_WritePlane(thing_plane, plane_offsets + 1, plane_lengths + 1);
    WF_WriteBlankPlane(plane_offsets + 2, plane_lengths + 2);

    current_offset = (int)ftell(map_fp);
    // TODO: validate (error check)

    WF_PutU32(plane_offsets[0], map_fp);
    WF_PutU32(plane_offsets[1], map_fp);
    WF_PutU32(plane_offsets[2], map_fp);

    WF_PutU16(plane_lengths[0], map_fp);
    WF_PutU16(plane_lengths[1], map_fp);
    WF_PutU16(plane_lengths[2], map_fp);

    // width and height
    WF_PutU16(64, map_fp);
    WF_PutU16(64, map_fp);

    WF_PutNString(level_name.empty() ? "Custom Map" : level_name.c_str(), 16, map_fp);

    WF_PutNString("!ID!", 4, map_fp);
}

static void WF_WriteHead(void)
{
    // offset to map data (info struct)
    WF_PutU32(current_offset, head_fp);
}

//------------------------------------------------------------------------

// LUA: wolf_block(x, y, plane, value)
//
int WF_wolf_block(lua_State *L)
{
    int x = luaL_checkinteger(L, 1);
    int y = luaL_checkinteger(L, 2);

    int tile = luaL_checkinteger(L, 3);
    int obj  = luaL_checkinteger(L, 4);

    // adjust and validate coords
    x = x - 1;
    y = 64 - y;

    SYS_ASSERT(0 <= x && x <= 63);
    SYS_ASSERT(0 <= y && y <= 63);

    solid_plane[PL_START + y * 64 + x] = tile;
    thing_plane[PL_START + y * 64 + x] = obj;

    return 0;
}

// LUA: wolf_read(x, y, plane)
//
int WF_wolf_read(lua_State *L)
{
    int x = luaL_checkinteger(L, 1);
    int y = luaL_checkinteger(L, 2);

    int plane = luaL_checkinteger(L, 3);

    // adjust and validate coords
    SYS_ASSERT(1 <= x && x <= 64);
    SYS_ASSERT(1 <= y && y <= 64);

    x--;
    y = 64 - y;

    int value = 0;

    switch (plane)
    {
    case 1:
        value = solid_plane[PL_START + y * 64 + x];
        break;

    case 2:
        value = thing_plane[PL_START + y * 64 + x];
        break;

    default:
        // other planes are silently ignored
        break;
    }

    lua_pushinteger(L, value);
    return 1;
}

static void WF_DumpMap(void)
{
    static const char *turning_points = ">/^\\</v\\";
    // static char *player_angles  = "^>v<";

    bool show_floors = false;

    char line_buf[80];

    for (int y = 0; y < 64; y++)
    {
        for (int x = 0; x < 64; x++)
        {
            int tile = solid_plane[PL_START + y * 64 + x];
            int obj  = thing_plane[PL_START + y * 64 + x];

            int ch;

            if (tile == no_tile)
            {
                ch = '#';
            }
            else if (obj >= 19 && obj <= 22)
            {
                ch = 'p'; // player_angles[obj-19];
            }
            else if (tile < 52)
            {
                ch = 'A' + (tile / 2);
            }
            else if (tile < 64)
            {
                ch = (show_floors ? 'A' : '1') + ((tile - 52) / 2);
            }
            else if (90 <= tile && tile <= 101)
            {
                ch = '+';
            }
            else if (show_floors && 108 <= tile && tile <= 143)
            {
                ch = '0' + ((tile - 108) % 10);
            }
            else if (obj == no_obj)
            {
                ch = '.';
            }
            else if ((obj >= 43 && obj <= 56) || obj == 29)
            {
                ch = '$'; // pickup
            }
            else if ((obj >= 23 && obj <= 71) || obj == 124)
            {
                ch = '%'; // scenery
            }
            else if (obj >= 108)
            {
                ch = 'm'; // monster
            }
            else if (90 <= obj && obj <= 97)
            {
                ch = turning_points[obj - 90];
            }
            else
            {
                ch = '?';
            }

            line_buf[x] = ch;
        }

        line_buf[64] = 0;

        DebugPrint("%s\n", line_buf);
    }
}

static void WF_FreeStuff()
{
    delete[] solid_plane;
    solid_plane = NULL;
    delete[] thing_plane;
    thing_plane = NULL;
}

//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

class wolf_game_interface_c : public game_interface_c
{
  private:
    std::string file_ext;

  public:
    wolf_game_interface_c()
    {
        file_ext.clear();
    }

    ~wolf_game_interface_c()
    {
    }

    bool Start(const char *preset);
    bool Finish(bool build_ok);

    void BeginLevel();
    void EndLevel();
    void Property(std::string key, std::string value);
    // Don't really need this, but whatever
    std::string Filename();
    std::string ZIP_Filename();

  private:
    void Rename();
    void Tidy();
};

bool wolf_game_interface_c::Start(const char *ext)
{
    WF_FreeStuff();

    write_errors_seen = 0;

    if (IsPathAbsolute(batch_output_file))
    {
        wolf_output_dir = GetDirectory(batch_output_file);
    }
    else
    {
        wolf_output_dir = Resolve_DefaultOutputPath();
    }

    if (ext)
    {
        file_ext = ext;
    }

    if (StringCompare(file_ext, "BC") == 0)
    {
        map_fp = FileOpen(TEMP_MAPTEMP, "wb");
    }
    else
    {
        map_fp = FileOpen(TEMP_GAMEFILE, "wb");
    }

    if (!map_fp)
    {
        LogPrint("Unable to create map file:\n%s", strerror(errno));

        ProgStatus("%s", _("Error (create file)"));
        return false;
    }

    head_fp = FileOpen(TEMP_HEADFILE, "wb");

    if (!head_fp)
    {
        fclose(map_fp);

        LogPrint("Unable to create %s:\n%s", TEMP_HEADFILE, strerror(errno));

        ProgStatus("%s", _("Error (create file)"));
        return false;
    }

    // the maphead file always begins with the RLE tag
    WF_PutU16(RLEW_TAG, head_fp);

    // setup local variables
    current_map    = 1;
    current_offset = 0;

    solid_plane = new uint16_t[64 * 64 + 8]; // extra space for compressor
    thing_plane = new uint16_t[64 * 64 + 8];
    ob_build_progress = 0.0f;
    ob_build_step.clear();
    return true;
}

bool wolf_game_interface_c::Finish(bool build_ok)
{
    WF_FreeStuff();

    // set remaining map offsets to zero (no map)
    for (; current_map <= 100; current_map++)
    {
        WF_PutU32(0, head_fp);
    }

    fclose(map_fp);
    fclose(head_fp);

    map_fp = head_fp = NULL;

    if (!build_ok)
    {
        Tidy();
        return false;
    }

    if (write_errors_seen > 0)
    {
        ProgStatus("%s", _("Error (write file)"));
        Tidy();
        return false;
    }

    Rename();

    return true; // OK!
}

void wolf_game_interface_c::Rename()
{
    std::string gamemaps = PathAppend(wolf_output_dir, (StringCompare(file_ext, "BC") == 0
                                                            ? StringFormat("MAPTEMP.%s", file_ext.c_str())
                                                            : StringFormat("GAMEMAPS.%s", file_ext.c_str())));
    std::string maphead  = PathAppend(wolf_output_dir, StringFormat("MAPHEAD.%s", file_ext.c_str()));

    if (create_backups)
    {
        Main::BackupFile(gamemaps);
        Main::BackupFile(maphead);
    }

    FileDelete(gamemaps);
    FileDelete(maphead);

    if (StringCompare(file_ext, "BC") == 0)
    {
        FileRename(TEMP_MAPTEMP, gamemaps);
    }
    else
    {
        FileRename(TEMP_GAMEFILE, gamemaps);
    }
    FileRename(TEMP_HEADFILE, maphead);
}

void wolf_game_interface_c::Tidy()
{
    FileDelete(TEMP_MAPTEMP);
    FileDelete(TEMP_GAMEFILE);
    FileDelete(TEMP_HEADFILE);
}

void wolf_game_interface_c::BeginLevel()
{
    no_tile = StringToInt(ob_get_param("no_tile"));
    no_obj  = StringToInt(ob_get_param("no_obj"));
    // clear the planes before use
    for (int i = 0; i < 64 * 64; i++)
    {
        solid_plane[PL_START + i] = no_tile;
        thing_plane[PL_START + i] = no_obj;
    }

    SYS_ASSERT(current_map < 100);
}

int v094_begin_wolf_level(lua_State *L)
{
    game_object->BeginLevel();
    return 0;
}

void wolf_game_interface_c::EndLevel()
{
    WF_DumpMap();

    WF_WriteMap();
    WF_WriteHead();

    current_map += 1;

    level_name.clear();
}

int v094_end_wolf_level(lua_State *L)
{
    game_object->EndLevel();
    return 0;
}

void wolf_game_interface_c::Property(std::string key, std::string value)
{
    if (StringCompare(key, "level_name") == 0)
    {
        level_name = value.c_str();
    }
    else if (StringCompare(key, "file_ext") == 0)
    {
        file_ext = value.c_str();
    }
    else
    {
        LogPrint("WARNING: unknown WOLF3D property: %s=%s\n", key.c_str(), value.c_str());
    }
}

std::string wolf_game_interface_c::Filename()
{
    return "";
}

std::string wolf_game_interface_c::ZIP_Filename()
{
    return "";
}

game_interface_c *Wolf_GameObject()
{
    return new wolf_game_interface_c();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
