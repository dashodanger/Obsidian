//------------------------------------------------------------------------
//  EXTRA stuff for DOOM
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2008-2017 Andrew Apted
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
#include <iterator>

#include "csg_main.h"
#include "g_doom.h"
#include "images.h"
#include "lib_tga.h"
#include "lib_util.h"
#include "lib_wad.h"
#include "lib_zip.h"
#include "main.h"
#include "minilua.h"
#include "physfs.h"
#include "raw_def.h"
#include "sys_assert.h"
#include "sys_endian.h"
#include "sys_macro.h"
#include "tx_forge.h"
#include "tx_skies.h"

static uint8_t *sky_pixels;
static int      sky_W;
static int      sky_H;
static int      sky_final_W;

constexpr uint8_t MAX_POST_LEN = 200;

static void AddPost(qLump_c *lump, int y, int len, const uint8_t *pixels, int W, int H)
{
    if (len <= 0)
    {
        return;
    }

    uint8_t  buffer[512];
    uint8_t *dest = buffer;

    *dest++ = y;                     // Y-OFFSET
    *dest++ = len;                   // # PIXELS

    *dest++ = pixels[((y) % H) * W]; // TOP-PADDING

    for (; len > 0; len--, y++)
    {
        *dest++ = pixels[((y) % H) * W];
    }

    *dest++ = pixels[((y - 1) % H) * W]; // BOTTOM-PADDING

    lump->Append(buffer, dest - buffer);
}

static void EndOfPost(qLump_c *lump)
{
    uint8_t datum = 255;

    lump->Append(&datum, 1);
}

namespace Doom
{
qLump_c *CreatePatch(int new_W, int new_H, int ofs_X, int ofs_Y, const uint8_t *pixels, int W, int H, int trans_p = -1)
{
    qLump_c *lump = new qLump_c();

    int x, y;

    uint32_t *offsets   = new uint32_t[new_W];
    uint32_t  beginning = sizeof(raw_patch_header_t) + new_W * 4;

    for (x = 0; x < W; x++, pixels++)
    {
        offsets[x] = beginning + (uint32_t)lump->GetSize();

        for (y = 0; y < new_H;)
        {
            if (trans_p >= 0 && pixels[((y) % H) * W] == trans_p)
            {
                y++;
                continue;
            }

            int len = 1;

            while ((y + len) < new_H && len < MAX_POST_LEN && !(trans_p >= 0 && pixels[((y + len) % H) * W] == trans_p))
            {
                len++;
            }

            if (y <= 252)
            {
                AddPost(lump, y, len, pixels, W, H);
            }

            y = y + len;
        }

        EndOfPost(lump);
    }

    for (x = W; x < new_W; x++)
    {
        offsets[x] = offsets[x % W];
    }

    lump->Prepend(offsets, new_W * sizeof(uint32_t));

    delete[] offsets;

    raw_patch_header_t header;

    header.width    = LE_U16(new_W);
    header.height   = LE_U16(new_H);
    header.x_offset = LE_U16(ofs_X);
    header.y_offset = LE_U16(ofs_Y);

    lump->Prepend(&header, sizeof(header));

    return lump;
}

qLump_c *CreateFlat(int new_W, int new_H, const uint8_t *pixels, int W, int H)
{
    qLump_c *lump = new qLump_c();

    // create a skewed but working flat when original is 128x32
    if (W != new_W && W == new_W * 2 && H * 2 == new_H)
    {
        for (int y = 0; y < new_H; y++)
        {
            for (int x = 0; x < new_W; x++)
            {
                int oy = (y + x / 2) % new_H;
                int ox = x + ((oy >= H) ? W / 2 : 0);

                lump->Append(&pixels[(oy % H) * W + (ox % W)], 1);
            }
        }
        return lump;
    }

    for (int y = 0; y < new_H; y++)
    {
        for (int x = 0; x < new_W; x += W)
        {
            int span = OBSIDIAN_MIN(W, new_W - x);

            SYS_ASSERT(span > 0);

            lump->Append(&pixels[(y % H) * W + (x % W)], span);
        }
    }

    return lump;
}
} // namespace Doom

static uint8_t *Flat_Realign(const uint8_t *pixels, int W, int H, int dx = 32, int dy = 32)
{
    uint8_t *new_pix = new uint8_t[W * H];

    for (int y = 0; y < H; y++)
    {
        for (int x = 0; x < W; x++)
        {
            int nx = (x + dx + W) % W;
            int ny = (y + dy + H) % H;

            new_pix[ny * W + nx] = pixels[y * W + x];
        }
    }

    return new_pix;
}

namespace Doom
{
int wad_logo_gfx(lua_State *L)
{
    // LUA: wad_logo_gfx(lump, kind, image, W, H, colmap)

    const char *patch = luaL_checkstring(L, 1);
    const char *kind  = luaL_checkstring(L, 2);
    const char *image = luaL_checkstring(L, 3);

    bool is_flat = false;
    bool realign = false;

    if (strchr(kind, 'p'))
    {
        is_flat = false;
    }
    else if (strchr(kind, 'f'))
    {
        is_flat = true;
    }
    else
    {
        return luaL_argerror(L, 2, "unknown kind");
    }

    if (strchr(kind, 'm'))
    {
        realign = true;
    }

    int new_W  = luaL_checkinteger(L, 4);
    int new_H  = luaL_checkinteger(L, 5);
    int map_id = luaL_checkinteger(L, 6);

    if (new_W < 1)
    {
        return luaL_argerror(L, 4, "bad width");
    }
    if (new_H < 1)
    {
        return luaL_argerror(L, 5, "bad height");
    }

    if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    {
        return luaL_argerror(L, 6, "colmap value out of range");
    }

    // find the requested image (TODO: look in a table)
    const logo_image_t *logo = NULL;

    if (StringCompare(image, logo_BOLT.name) == 0)
    {
        logo = &logo_BOLT;
    }
    else if (StringCompare(image, logo_PILL.name) == 0)
    {
        logo = &logo_PILL;
    }
    else if (StringCompare(image, logo_CARVE.name) == 0)
    {
        logo = &logo_CARVE;
    }
    else if (StringCompare(image, logo_RELIEF.name) == 0)
    {
        logo = &logo_RELIEF;
    }
    else
    {
        return luaL_argerror(L, 3, "unknown image name");
    }

    // colorize logo
    color_mapping_t *map = &color_mappings[map_id - 1];

    if (map->size < 2)
    {
        return luaL_error(L, "wad_logo_gfx: colormap too small");
    }

    uint8_t *pixels = new uint8_t[logo->width * logo->height];
    uint8_t *p_end  = pixels + (logo->width * logo->height);

    const uint8_t *src = logo->data;

    for (uint8_t *dest = pixels; dest < p_end; dest++, src++)
    {
        int idx = ((*src) * map->size) >> 8;

        *dest = map->colors[idx];
    }

    if (realign)
    {
        uint8_t *new_pix = Flat_Realign(pixels, logo->width, logo->height);

        delete[] pixels;
        pixels = new_pix;
    }

    // splosh it into the wad
    if (is_flat)
    {
        qLump_c *lump = CreateFlat(new_W, new_H, pixels, logo->width, logo->height);

        AddSectionLump('F', patch, lump);
    }
    else
    {
        qLump_c *lump = CreatePatch(new_W, new_H, 0, 0, pixels, logo->width, logo->height);

        AddSectionLump('P', patch, lump);
    }

    delete[] pixels;

    return 0;
}

//------------------------------------------------------------------------

int fsky_create(lua_State *L)
{
    // LUA: fsky_create(width, height, bg_col)

    int W  = luaL_checkinteger(L, 1);
    int H  = luaL_checkinteger(L, 2);
    int bg = luaL_checkinteger(L, 3);

    sky_final_W = W;

    if (W != 256)
    {
        return luaL_argerror(L, 1, "bad width");
    }

    if (H < 128 || H > 256)
    {
        return luaL_argerror(L, 2, "bad height");
    }

    if (sky_pixels && !(sky_W == W && sky_H == H))
    {
        delete[] sky_pixels;
    }

    if (!sky_pixels)
    {
        sky_W = W;
        sky_H = H;

        sky_pixels = new uint8_t[sky_W * sky_H];
    }

    memset(sky_pixels, bg, sky_W * sky_H);

    return 0;
}

int fsky_write(lua_State *L)
{
    // LUA: fsky_write(patch)

    const char *patch = luaL_checkstring(L, 1);

    SYS_ASSERT(sky_pixels);

    qLump_c *lump = CreatePatch(sky_final_W, sky_H, 0, 0, sky_pixels, sky_W, sky_H);

    AddSectionLump('P', patch, lump);

    return 0;
}

int fsky_free(lua_State *L)
{
    // LUA: fsky_free()

    if (sky_pixels)
    {
        delete[] sky_pixels;
    }

    return 0;
}

int fsky_solid_box(lua_State *L)
{
    // LUA: fsky_solid_box(x, y, w, h, col)

    int x1 = luaL_checkinteger(L, 1);
    int y1 = luaL_checkinteger(L, 2);
    int x2 = x1 + luaL_checkinteger(L, 3);
    int y2 = y1 + luaL_checkinteger(L, 4);

    int col = luaL_checkinteger(L, 5);

    SYS_ASSERT(sky_pixels);

    // clip box to pixel rectangle
    x1 = OBSIDIAN_MAX(x1, 0);
    y1 = OBSIDIAN_MAX(y1, 0);

    x2 = OBSIDIAN_MIN(x2, sky_W);
    y2 = OBSIDIAN_MIN(y2, sky_H);

    for (int y = y1; y < y2; y++)
    {
        if (x2 > x1)
        {
            memset(&sky_pixels[y * sky_W + x1], col, (x2 - x1));
        }
    }

    return 0;
}

int fsky_add_stars(lua_State *L)
{
    // LUA: fsky_add_stars { seed=X, colmap=X, power=X, thresh=X }

    if (lua_type(L, 1) != LUA_TTABLE)
    {
        return luaL_argerror(L, 1, "missing table: star info");
    }

    int seed   = 1;
    int map_id = 1;

    double powscale = 3.0;
    double thresh   = 0.25;

    lua_getfield(L, 1, "seed");
    lua_getfield(L, 1, "colmap");
    lua_getfield(L, 1, "power");
    lua_getfield(L, 1, "thresh");

    if (!lua_isnil(L, -4))
    {
        seed = luaL_checkinteger(L, -4);
    }
    if (!lua_isnil(L, -3))
    {
        map_id = luaL_checkinteger(L, -3);
    }
    if (!lua_isnil(L, -2))
    {
        powscale = luaL_checknumber(L, -2);
    }
    if (!lua_isnil(L, -1))
    {
        thresh = luaL_checknumber(L, -1);
    }

    lua_pop(L, 4);

    // validation...
    SYS_ASSERT(sky_pixels);

    if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    {
        return luaL_error(L, "fsky_add_stars: colmap value out of range");
    }

    if (powscale < 0.01)
    {
        return luaL_error(L, "fsky_add_stars: bad power value");
    }

    if (thresh > 0.98)
    {
        return luaL_error(L, "fsky_add_stars: bad thresh value");
    }

    SKY_AddStars(seed, sky_pixels, sky_W, sky_H, &color_mappings[map_id - 1], powscale, thresh);

    return 0;
}

int fsky_add_clouds(lua_State *L)
{
    // LUA: fsky_add_clouds { seed=X, colmap=X, power=X, thresh=X,
    //                        fracdim=X, squish=X }

    if (lua_type(L, 1) != LUA_TTABLE)
    {
        return luaL_argerror(L, 1, "missing table: cloud info");
    }

    int seed   = 1;
    int map_id = 1;

    double powscale = 1.2;
    double thresh   = 0.0;
    double fracdim  = 2.4;
    double squish   = 1.0;

    lua_getfield(L, 1, "seed");
    lua_getfield(L, 1, "colmap");

    if (!lua_isnil(L, -2))
    {
        seed = luaL_checkinteger(L, -2);
    }
    if (!lua_isnil(L, -1))
    {
        map_id = luaL_checkinteger(L, -1);
    }

    lua_pop(L, 2);

    lua_getfield(L, 1, "power");
    lua_getfield(L, 1, "thresh");
    lua_getfield(L, 1, "fracdim");
    lua_getfield(L, 1, "squish");

    if (!lua_isnil(L, -4))
    {
        powscale = luaL_checknumber(L, -4);
    }
    if (!lua_isnil(L, -3))
    {
        thresh = luaL_checknumber(L, -3);
    }
    if (!lua_isnil(L, -2))
    {
        fracdim = luaL_checknumber(L, -2);
    }
    if (!lua_isnil(L, -1))
    {
        squish = luaL_checknumber(L, -1);
    }

    lua_pop(L, 4);

    // validation...
    SYS_ASSERT(sky_pixels);

    if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    {
        return luaL_error(L, "fsky_add_clouds: colmap value out of range");
    }

    if (powscale < 0.01)
    {
        return luaL_error(L, "fsky_add_clouds: bad power value");
    }

    if (thresh > 0.98)
    {
        return luaL_error(L, "fsky_add_clouds: bad thresh value");
    }

    if (fracdim > 2.99 || fracdim < 0.2)
    {
        return luaL_error(L, "fsky_add_clouds: bad fracdim value");
    }

    if (squish > 4.1 || squish < 0.24)
    {
        return luaL_error(L, "fsky_add_clouds: bad squish value");
    }

    SKY_AddClouds(seed, sky_pixels, sky_W, sky_H, &color_mappings[map_id - 1], powscale, thresh, fracdim, squish);

    return 0;
}

int fsky_add_hills(lua_State *L)
{
    // LUA: fsky_add_hills { seed=X, colmap=X, power=X, fracdim=X,
    //                       min_h=X, max_h=X }

    if (lua_type(L, 1) != LUA_TTABLE)
    {
        return luaL_argerror(L, 1, "missing table: cloud info");
    }

    int seed   = 1;
    int map_id = 1;

    double min_h = -0.20;
    double max_h = 0.75;

    double powscale = 0.8;
    double fracdim  = 1.8;

    lua_getfield(L, 1, "seed");
    lua_getfield(L, 1, "colmap");

    if (!lua_isnil(L, -2))
    {
        seed = luaL_checkinteger(L, -2);
    }
    if (!lua_isnil(L, -1))
    {
        map_id = luaL_checkinteger(L, -1);
    }

    lua_pop(L, 2);

    lua_getfield(L, 1, "min_h");
    lua_getfield(L, 1, "max_h");
    lua_getfield(L, 1, "power");
    lua_getfield(L, 1, "fracdim");

    if (!lua_isnil(L, -4))
    {
        min_h = luaL_checknumber(L, -4);
    }
    if (!lua_isnil(L, -3))
    {
        max_h = luaL_checknumber(L, -3);
    }
    if (!lua_isnil(L, -2))
    {
        powscale = luaL_checknumber(L, -2);
    }
    if (!lua_isnil(L, -1))
    {
        fracdim = luaL_checknumber(L, -1);
    }

    lua_pop(L, 4);

    // validation...
    SYS_ASSERT(sky_pixels);

    if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    {
        return luaL_error(L, "fsky_add_hills: colmap value out of range");
    }

    if (min_h >= max_h || max_h <= 0.0)
    {
        return luaL_error(L, "fsky_add_hills: bad height range");
    }

    if (powscale < 0.01)
    {
        return luaL_error(L, "fsky_add_hills: bad power value");
    }

    if (fracdim > 2.99 || fracdim < 0.2)
    {
        return luaL_error(L, "fsky_add_hills: bad fracdim value");
    }

    SKY_AddHills(seed, sky_pixels, sky_W, sky_H, &color_mappings[map_id - 1], min_h, max_h, powscale, fracdim);

    return 0;
}
} // namespace Doom

//------------------------------------------------------------------------

static int FontIndexForChar(char ch)
{
    ch = ToUpperASCII(ch);

    if (ch == ' ')
    {
        return 0;
    }

    if ('A' <= ch && ch <= 'Z')
    {
        return 12 + (ch - 'A');
    }

    if ('0' <= ch && ch <= '9')
    {
        return 1 + (ch - '0');
    }

    switch (ch)
    {
    case ':':
    case ';':
    case '=':
        return 11;

    case '-':
    case '_':
        return 38;

    case '.':
    case ',':
        return 39;

    case '!':
        return 40;
    case '?':
        return 41;

    case '\'':
    case '`':
    case '"':
        return 42;

    case '&':
        return 43;

    case '\\':
    case '/':
        return 44;

    // does not exist
    default:
        return -1;
    }
}

static void BlastFontChar(int index, int x, int y, uint8_t *pixels, int W, int H, const logo_image_t *font, int fw,
                          int fh, const color_mapping_t *map, int thresh)
{
    SYS_ASSERT(0 <= index && index < 44);

    int fx = fw * (index % 11);
    int fy = fh * (index / 11);

    SYS_ASSERT(0 <= fx && fx + fw <= font->width);
    SYS_ASSERT(0 <= fy && fy + fh <= font->height);

    SYS_ASSERT(0 <= x && x + fw <= W);
    SYS_ASSERT(0 <= y && y + fh <= H);

    for (int dy = 0; dy < fh; dy++)
    {
        for (int dx = 0; dx < fw; dx++)
        {
            uint8_t pix = font->data[(fy + dy) * font->width + (fx + dx)];

            if (pix < thresh)
            {
                continue;
            }

            // map pixel
            pix = map->colors[map->size * (pix - thresh) / (256 - thresh)];

            pixels[(y + dy) * W + (x + dx)] = pix;
        }
    }
}

static void CreateNamePatch(const char *patch, const char *text, const logo_image_t *font, const color_mapping_t *map)
{
    // TODO: adjustable threshhold
    int thresh = 16;

    int font_w = font->width / 11;
    int font_h = font->height / 4;

    int buffer[64];
    int length = 0;

    // Convert string to font indexes (0 = space, 1+ = index)

    for (; *text && length < 60; text++)
    {
        int idx = FontIndexForChar(*text);

        if (idx >= 0)
        {
            buffer[length++] = idx;
        }
    }

    if (length == 0)
    {
        buffer[length++] = 41;
        buffer[length++] = 41;
    }

    int W = font_w * length;
    int H = font_h;

    uint8_t *pixels = new uint8_t[W * H];

    memset(pixels, 255, W * H);

    for (int p = 0; p < length; p++)
    {
        if (buffer[p] <= 0)
        {
            continue;
        }

        BlastFontChar(buffer[p] - 1, p * font_w, 0, pixels, W, H, font, font_w, font_h, map, thresh);
    }

    qLump_c *lump = Doom::CreatePatch(W, H, 0, 0, pixels, W, H, 255);

    Doom::WriteLump(patch, lump);

    delete lump;
    delete[] pixels;
}

namespace Doom
{
int wad_name_gfx(lua_State *L)
{
    // LUA: wad_name_gfx(patch, text, colmap)

    const char *patch = luaL_checkstring(L, 1);
    const char *text  = luaL_checkstring(L, 2);

    int map_id = luaL_checkinteger(L, 3);

    if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    {
        return luaL_argerror(L, 1, "colmap value out of range");
    }

    CreateNamePatch(patch, text, &font_CWILV, &color_mappings[map_id - 1]);

    return 0;
}

int wad_add_text_lump(lua_State *L)
{
    // LUA: wad_add_text_lump(lump, strings)
    //
    // The 'strings' parameter is a table.

    const char *name = luaL_checkstring(L, 1);

    if (lua_type(L, 2) != LUA_TTABLE)
    {
        return luaL_argerror(L, 2, "expected a table: strings");
    }

    qLump_c *lump = new qLump_c();

    // grab all the strings from the table
    for (int i = 0; true; i++)
    {
        lua_pushinteger(L, 1 + i);
        lua_gettable(L, 2);

        if (lua_isnil(L, -1))
        {
            lua_pop(L, 1);
            break;
        }

        if (lua_type(L, -1) != LUA_TSTRING)
        {
            return luaL_error(L, "wad_add_text_lump: item #%d is not a string", 1 + i);
        }

        // use this method since it allows embedded zeros in the string
        // (just in case some crazy person wants to write a binary lump).
        size_t      len;
        const char *str = lua_tolstring(L, -1, &len);

        lump->Append(str, (int)len);

        lua_pop(L, 1);
    }

    if (game_object->file_per_map)
    {
        ZIPF_AddMem(name, (uint8_t *)lump->GetBuffer(), lump->GetSize());
    }
    else
    {
        WriteLump(name, lump);
    }

    delete lump;

    return 0;
}

int wad_add_binary_lump(lua_State *L)
{
    // LUA: wad_add_binary_lump(lump, uint8_ts)
    //
    // The 'uint8_ts' parameter is a table, which can contain numbers, strings,
    // and booleans.  Each number ends up as a single uint8_t.

    const char *name = luaL_checkstring(L, 1);

    if (lua_type(L, 2) != LUA_TTABLE)
    {
        return luaL_argerror(L, 2, "expected a table: uint8_ts");
    }

    qLump_c *lump = new qLump_c();

    // grab all the stuff from the table
    for (int i = 0; true; i++)
    {
        lua_pushinteger(L, 1 + i);
        lua_gettable(L, 2);

        if (lua_isnil(L, -1))
        {
            lua_pop(L, 1);
            break;
        }

        int val_type = lua_type(L, -1);

        uint8_t value;

        switch (val_type)
        {
        case LUA_TNUMBER:
            value = lua_tointeger(L, -1) & 0xFF;
            lump->Append(&value, 1);
            break;

        case LUA_TBOOLEAN:
            value = lua_toboolean(L, -1);
            lump->Append(&value, 1);
            break;

        case LUA_TSTRING: {
            size_t      len;
            const char *str = lua_tolstring(L, -1, &len);

            lump->Append(str, (int)len);
        }
        break;

        default:
            return luaL_error(L, "wad_add_binary_lump: item #%d is illegal", 1 + i);
        }

        lua_pop(L, 1);
    }

    WriteLump(name, lump);
    delete lump;

    return 0;
}
} // namespace Doom

static void TransferFILEtoWAD(PHYSFS_File *fp, const char *dest_lump)
{
    WAD_NewLump(dest_lump);

    int   buf_size = 4096;
    char *buffer   = new char[buf_size];

    for (;;)
    {
        int got_len = (int)PHYSFS_readBytes(fp, buffer, buf_size);

        if (got_len <= 0)
        {
            break;
        }

        WAD_AppendData(buffer, got_len);
    }

    delete[] buffer;

    WAD_FinishLump();
}

static void TransferFILEtoPK3(PHYSFS_File *fp, const char *pk3filename)
{
    PHYSFS_sint64 buf_size = PHYSFS_fileLength(fp);
    uint8_t      *buffer   = new uint8_t[buf_size];
    PHYSFS_readBytes(fp, buffer, buf_size);

    ZIPF_AddMem(pk3filename, buffer, buf_size);

    delete[] buffer;
}

static void TransferWADtoWAD(int src_entry, const char *dest_lump)
{
    int length = WAD_EntryLen(src_entry);

    WAD_NewLump(dest_lump);

    int   buf_size = 4096;
    char *buffer   = new char[buf_size];

    for (int pos = 0; pos < length;)
    {
        int want_len = OBSIDIAN_MIN(buf_size, length - pos);

        // FIXME: handle error better
        if (!WAD_ReadData(src_entry, pos, want_len, buffer))
        {
            break;
        }

        WAD_AppendData(buffer, want_len);

        pos += want_len;
    }

    delete[] buffer;

    WAD_FinishLump();
}

static qLump_c *DoLoadLump(int src_entry)
{
    qLump_c *lump = new qLump_c();

    int length = WAD_EntryLen(src_entry);

    int   buf_size = 4096;
    char *buffer   = new char[buf_size];

    for (int pos = 0; pos < length;)
    {
        int want_len = OBSIDIAN_MIN(buf_size, length - pos);

        // FIXME: handle error better
        if (!WAD_ReadData(src_entry, pos, want_len, buffer))
        {
            break;
        }

        lump->Append(buffer, want_len);

        pos += want_len;
    }

    delete[] buffer;

    return lump;
}

constexpr uint8_t NUM_LEVEL_LUMPS = 12;

static const char *level_lumps[NUM_LEVEL_LUMPS] = {
    "THINGS",   "LINEDEFS", "SIDEDEFS", "VERTEXES", "SEGS", "SSECTORS", "NODES", "SECTORS", "REJECT", "BLOCKMAP",
    "BEHAVIOR", // <-- hexen support
    "SCRIPTS"   // -JL- Lump with script sources
};

static bool IsLevelLump(const char *name)
{
    for (int i = 0; i < NUM_LEVEL_LUMPS; i++)
    {
        if (StringCompare(name, level_lumps[i]) == 0)
        {
            return true;
        }
    }

    return false;
}

namespace Doom
{
int pk3_insert_file(lua_State *L)
{
    // LUA: pk3_insert_file(filename, pk3filename)

    const char *filename    = luaL_checkstring(L, 1);
    const char *pk3filename = luaL_checkstring(L, 2);

    PHYSFS_File *fp = PHYSFS_openRead(filename);

    if (!fp)
    { // this is unlikely (we know it exists)
        return luaL_error(L, "pk3_insert_file: cannot open file: %s", filename);
    }

    TransferFILEtoPK3(fp, pk3filename);

    PHYSFS_close(fp);

    return 0;
}

int wad_insert_file(lua_State *L)
{
    // LUA: wad_insert_file(filename, lumpname)

    const char *filename  = luaL_checkstring(L, 1);
    const char *dest_lump = luaL_checkstring(L, 2);

    PHYSFS_File *fp = PHYSFS_openRead(filename);

    if (!fp)
    { // this is unlikely (we know it exists)
        return luaL_error(L, "wad_insert_file: cannot open file: %s", filename);
    }

    TransferFILEtoWAD(fp, dest_lump);

    PHYSFS_close(fp);

    return 0;
}

int wad_transfer_lump(lua_State *L)
{
    // LUA: wad_transfer_lump(wad_file, src_lump, dest_lump)
    //
    // Open an existing wad file and copy the lump into our wad.

    std::string pkg_name  = luaL_checkstring(L, 1);
    const char *src_lump  = luaL_checkstring(L, 2);
    const char *dest_lump = luaL_checkstring(L, 3);

    if (GetExtension(pkg_name) != ".wad")
    {
        return luaL_error(L, "wad_transfer_lump: file extension is not WAD: %s\n", pkg_name.c_str());
    }

    if (!WAD_OpenRead(pkg_name))
    {
        return luaL_error(L, "wad_transfer_lump: bad WAD file: %s", pkg_name.c_str());
    }

    int entry = WAD_FindEntry(src_lump);
    if (entry < 0)
    {
        WAD_CloseRead();
        return luaL_error(L, "wad_transfer_lump: lump '%s' not found", src_lump);
    }

    TransferWADtoWAD(entry, dest_lump);

    WAD_CloseRead();

    return 0;
}

int wad_transfer_map(lua_State *L)
{
    // LUA: wad_transfer_map(wad_file, src_map, dest_map)
    //
    // Open an existing wad file and copy the map into our wad.

    std::string pkg_name = luaL_checkstring(L, 1);
    const char *src_map  = luaL_checkstring(L, 2);
    const char *dest_map = luaL_checkstring(L, 3);

    if (GetExtension(pkg_name) != ".wad")
    {
        return luaL_error(L, "wad_transfer_map: file extension is not WAD: %s\n", pkg_name.c_str());
    }

    if (!WAD_OpenRead(pkg_name))
    {
        return luaL_error(L, "wad_transfer_map: bad WAD file: %s", pkg_name.c_str());
    }

    int entry = WAD_FindEntry(src_map);
    if (entry < 0)
    {
        WAD_CloseRead();
        return luaL_error(L, "wad_transfer_map: map '%s' not found", src_map);
    }

    // step 1: copy the map marker
    TransferWADtoWAD(entry, dest_map);
    entry++;

    // step 2: copy all the lumps belonging to the map.
    for (int loop = 0; loop < 15; loop++)
    {
        if (entry >= WAD_NumEntries())
        {
            break;
        }

        const char *src_lump = WAD_EntryName(entry);
        if (!IsLevelLump(src_lump))
        {
            break;
        }

        TransferWADtoWAD(entry, src_lump);
        entry++;
    }

    WAD_CloseRead();

    return 0;
}
} // namespace Doom

static void DoMergeSection(char ch, const char *start1, const char *start2, const char *end1, const char *end2)
{
    int start = WAD_FindEntry(start1);
    if (start < 0 && start2)
    {
        start1 = start2;
        start  = WAD_FindEntry(start1);
    }

    if (start < 0)
    {
        return;
    }

    int end = WAD_FindEntry(end1);
    if (end < 0 && end2)
    {
        end1 = end2;
        end  = WAD_FindEntry(end1);
    }

    if (end < 0)
    {
        LogPrint("WARNING: %s found but %s is missing.\n", start1, end1);
        return;
    }
    else if (end < start)
    {
        LogPrint("WARNING: %s marker found before %s!\n", end1, start1);
        return;
    }

    for (int i = start + 1; i < end; i++)
    {
        // skip other markers (e.g. F1_START)
        if (WAD_EntryLen(i) == 0)
        {
            continue;
        }

        Doom::AddSectionLump(ch, WAD_EntryName(i), DoLoadLump(i));
    }
}

namespace Doom
{
int wad_merge_sections(lua_State *L)
{
    // LUA: wad_merge_sections(file_name)
    //
    // Open an existing wad file and merge the patches, sprites, flats
    // and other stuff (which occur in between P_START/P_END and similar
    // marker lumps).

    std::string pkg_name = luaL_checkstring(L, 1);

    LogPrint("Merging WAD sections from: %s\n", pkg_name.c_str());

    if (GetExtension(pkg_name) != ".wad")
    {
        return luaL_error(L, "wad_merge_sections: file extension is not WAD: %s\n", pkg_name.c_str());
    }

    if (!WAD_OpenRead(pkg_name))
    {
        return luaL_error(L, "wad_merge_sections: bad WAD file: %s", pkg_name.c_str());
    }

    DoMergeSection('P', "P_START", "PP_START", "P_END", "PP_END");
    DoMergeSection('S', "S_START", "SS_START", "S_END", "SS_END");
    DoMergeSection('F', "F_START", "FF_START", "F_END", "FF_END");
    DoMergeSection('C', "C_START", NULL, "C_END", NULL);
    DoMergeSection('T', "TX_START", NULL, "TX_END", NULL);

    WAD_CloseRead();

    return 0;
}
} // namespace Doom

constexpr bool DIRTY_CHAR(char c)
{
    return c == '\0';
}

void G_PushCleanString(lua_State *L, const char *buf, int len)
{
    if (!std::any_of(buf, buf + len, DIRTY_CHAR))
    {
        lua_pushlstring(L, buf, len);
        return;
    }

    // this is quite sub-optimal, since we assume dirty strings are rare
    // (i.e. the usual case is plain text files).

    std::string dest;
    dest.reserve(len);

    std::copy_if(buf, buf + len, std::back_inserter(dest), [](const char c) { return !DIRTY_CHAR(c); });

    lua_pushstring(L, dest.c_str());
}

namespace Doom
{
int wad_read_text_lump(lua_State *L)
{
    // LUA: wad_read_text_lump(file_name, lump_name) --> table
    //
    // Open the wad file and find the given lump.  If it exists, it is assumed
    // to be text, and a table is returned containing a string for each line.
    // Certain characters (esp. zero uint8_ts) will be silently removed.
    //
    // If the lump does not exist, NIL is returned.
    // If the _file_ does not exist, an error is raised.

    std::string pkg_name = luaL_checkstring(L, 1);
    const char *src_lump = luaL_checkstring(L, 2);

    if (GetExtension(pkg_name) != ".wad")
    {
        return luaL_error(L, "wad_read_text_lump: file extension is not WAD: %s\n", pkg_name.c_str());
    }

    if (!WAD_OpenRead(pkg_name))
    {
        return luaL_error(L, "wad_read_text_lump: bad WAD file: %s", pkg_name.c_str());
    }

    int entry = WAD_FindEntry(src_lump);
    if (entry < 0)
    {
        WAD_CloseRead();

        lua_pushnil(L);
        return 1;
    }

    qLump_c *lump = DoLoadLump(entry);

    WAD_CloseRead();

    // create the table
    lua_newtable(L);

    const uint8_t *buf   = lump->GetBuffer();
    const uint8_t *b_end = buf + lump->GetSize();

    int cur_pos = 1;

    while (buf < b_end)
    {
        const uint8_t *next = buf;
        while (next < b_end && *next != '\n')
        {
            next++;
        }

        if (next < b_end)
        {
            next++;
        }

        size_t len = (next - buf);

        lua_pushinteger(L, cur_pos);
        G_PushCleanString(L, (const char *)buf, len);

        lua_rawset(L, -3);

        buf = next;
        cur_pos++;
    }

    return 1;
}
} // namespace Doom

//------------------------------------------------------------------------

//
// Utility function to parse a "color" value.
//
// We accept two formats:
//   - a string : "#RGB" or "#RRGGBB"   -- like in HTML or CSS
//   - a table  : { red, green, blue }  -- values are 0..255
//
static rgb_color_t Grab_Color(lua_State *L, int stack_idx)
{
    if (lua_isstring(L, stack_idx))
    {
        const char *name = luaL_checkstring(L, stack_idx);

        if (name[0] != '#')
        {
            luaL_error(L, "bad color string (missing #)");
        }

        int raw_hex = strtol(name + 1, NULL, 16);
        int r = 0, g = 0, b = 0;

        if (strlen(name) == 4)
        {
            r = ((raw_hex >> 8) & 0x0f) * 17;
            g = ((raw_hex >> 4) & 0x0f) * 17;
            b = ((raw_hex) & 0x0f) * 17;
        }
        else if (strlen(name) == 7)
        {
            r = (raw_hex >> 16) & 0xff;
            g = (raw_hex >> 8) & 0xff;
            b = (raw_hex) & 0xff;
        }
        else
        {
            luaL_error(L, "bad color string");
        }

        return OBSIDIAN_MAKE_RGBA(r, g, b, 255);
    }

    if (lua_istable(L, stack_idx))
    {
        int r, g, b;

        lua_pushinteger(L, 1);
        lua_gettable(L, stack_idx);

        lua_pushinteger(L, 2);
        lua_gettable(L, stack_idx);

        lua_pushinteger(L, 3);
        lua_gettable(L, stack_idx);

        if (!lua_isnumber(L, -3) || !lua_isnumber(L, -2) || !lua_isnumber(L, -1))
        {
            luaL_error(L, "bad color table");
        }

        r = luaL_checkinteger(L, -3);
        g = luaL_checkinteger(L, -2);
        b = luaL_checkinteger(L, -1);

        lua_pop(L, 3);

        return OBSIDIAN_MAKE_RGBA(r, g, b, 255);
    }

    luaL_error(L, "bad color value (not a string or table)");
    return OBSIDIAN_MAKE_RGBA(0, 0, 0, 255); /* NOT REACHED */
}

static uint8_t PaletteLookup(rgb_color_t col, const rgb_color_t *palette)
{
    int r = OBSIDIAN_RGB_RED(col);
    int g = OBSIDIAN_RGB_GREEN(col);
    int b = OBSIDIAN_RGB_BLUE(col);

    int best      = 0;
    int best_dist = (1 << 30);

    // ignore the very last color
    for (int c = 0; c < 255; c++)
    {
        int dr = r - OBSIDIAN_RGB_RED(palette[c]);
        int dg = g - OBSIDIAN_RGB_GREEN(palette[c]);
        int db = b - OBSIDIAN_RGB_BLUE(palette[c]);

        int dist = dr * dr + dg * dg + db * db;

        if (dist < best_dist)
        {
            best      = c;
            best_dist = dist;
        }
    }

    return best;
}

//------------------------------------------------------------------------
//   TITLE DRAWING
//------------------------------------------------------------------------

static int title_W;
static int title_H;

static int title_W3; // the above values * 3
static int title_H3; //

static rgb_color_t *title_pix;

static rgb_color_t title_palette[256];

typedef enum
{
    REND_Solid = 0,
    REND_Additive,
    REND_Subtract,
    REND_Multiply,

    REND_Textured,
    REND_Gradient,
    REND_Gradient3,
    REND_Random

} title_rendermode_e;

typedef enum
{
    PEN_Circle = 0,
    PEN_Box,
    PEN_Slash,
    PEN_Slash2,

} title_pentype_e;

// the current drawing context
static struct
{
    title_pentype_e pen_type;

    title_rendermode_e render_mode;

    rgb_color_t color[4];

    int box_w, box_h;

    int grad_y1, grad_y2;

    void Reset()
    {
        pen_type = PEN_Circle;

        render_mode = REND_Solid;

        for (int i = 0; i < 4; i++)
        {
            color[i] = OBSIDIAN_MAKE_RGBA(0, 0, 0, 255);
        }

        box_w = 1;
        box_h = 1;
    }

} title_drawctx;

// simple cache for image loading
static tga_image_c *title_last_tga;
static std::string  title_last_filename;

namespace Doom
{
int title_create(lua_State *L)
{
    // LUA: title_create(width, height, bg)

    int W = luaL_checkinteger(L, 1);
    int H = luaL_checkinteger(L, 2);

    rgb_color_t bg = Grab_Color(L, 3);

    if (W < 16 || W > 1024)
    {
        return luaL_argerror(L, 1, "bad width");
    }

    if (H < 16 || H > 256)
    {
        return luaL_argerror(L, 2, "bad height");
    }

    if (title_pix)
    {
        delete[] title_pix;
    }

    title_W = W;
    title_H = H;

    title_W3 = W * 3;
    title_H3 = H * 3;

    title_pix = new rgb_color_t[W * H * 9];

    for (int i = 0; i < W * H * 9; i++)
    {
        title_pix[i] = bg;
    }

    title_drawctx.Reset();

    return 0;
}

int title_free(lua_State *L)
{
    // LUA: title_free()

    if (title_pix)
    {
        delete[] title_pix;
        title_pix = NULL;
    }

    if (title_last_tga)
    {
        delete title_last_tga;
        title_last_tga = NULL;

        title_last_filename.clear();
    }

    return 0;
}
} // namespace Doom

static bool TitleCacheImage(const char *filename)
{
    // keep the last image cached in memory
    if (title_last_filename != filename)
    {
        if (title_last_tga)
        {
            delete title_last_tga;
            title_last_filename.clear();
        }

        title_last_tga = TGA_LoadImage(filename);

        if (!title_last_tga)
        {
            return false;
        }

        title_last_filename = filename;
    }

    return true;
}

static int TitleAveragePixel(int x, int y)
{
    x *= 3;
    y *= 3;

    // compute average
    int r = 0;
    int g = 0;
    int b = 0;

    for (int ky = 0; ky < 3; ky++)
    {
        for (int kx = 0; kx < 3; kx++)
        {
            const rgb_color_t c = title_pix[(y + ky) * title_W3 + (x + kx)];

            r += OBSIDIAN_RGB_RED(c);
            g += OBSIDIAN_RGB_GREEN(c);
            b += OBSIDIAN_RGB_BLUE(c);
        }
    }

    r = r / 9;
    g = g / 9;
    b = b / 9;

    return OBSIDIAN_MAKE_RGBA(r, g, b, 255);
}

static qLump_c *TitleCreateTGA()
{
    qLump_c *lump = new qLump_c();

    lump->AddByte(0); // id_length
    lump->AddByte(0); // colormap_type
    lump->AddByte(2); // TGA_RGB

    lump->AddByte(0); // colormap_xxx
    lump->AddByte(0);
    lump->AddByte(0);
    lump->AddByte(0);
    lump->AddByte(0);

    lump->AddByte(0);             // x_offset
    lump->AddByte(0);
    lump->AddByte(0);             // y_offset
    lump->AddByte(0);

    lump->AddByte(title_W & 255); // width
    lump->AddByte(title_W >> 8);

    lump->AddByte(title_H & 255); // height
    lump->AddByte(title_H >> 8);

    lump->AddByte(24);            // pixel_bits
    lump->AddByte(0);             // attributes

    for (int y = title_H - 1; y >= 0; y--)
    {
        for (int x = 0; x < title_W; x++)
        {
            rgb_color_t col = TitleAveragePixel(x, y);

            lump->AddByte(OBSIDIAN_RGB_BLUE(col));
            lump->AddByte(OBSIDIAN_RGB_GREEN(col));
            lump->AddByte(OBSIDIAN_RGB_RED(col));
        }
    }

    return lump;
}

static qLump_c *TitleCreatePatch()
{
    // convert image to the palette  [ this is very slow! ]

    uint8_t *conv_pixels = new uint8_t[title_W * title_H];

    for (int y = 0; y < title_H; y++)
    {
        for (int x = 0; x < title_W; x++)
        {
            rgb_color_t col = TitleAveragePixel(x, y);

            conv_pixels[y * title_W + x] = PaletteLookup(col, title_palette);
        }
    }

    qLump_c *lump = Doom::CreatePatch(title_W, title_H, 0, 0, conv_pixels, title_W, title_H);

    delete[] conv_pixels;

    return lump;
}

static qLump_c *TitleCreateRaw()
{
    // convert image to the palette  [ this is very slow! ]

    uint8_t *conv_pixels = new uint8_t[title_W * title_H];

    for (int y = 0; y < title_H; y++)
    {
        for (int x = 0; x < title_W; x++)
        {
            rgb_color_t col = TitleAveragePixel(x, y);

            conv_pixels[y * title_W + x] = PaletteLookup(col, title_palette);
        }
    }

    qLump_c *lump = new qLump_c;

    lump->Append(conv_pixels, title_W * title_H);

    delete[] conv_pixels;

    return lump;
}

namespace Doom
{
int title_write(lua_State *L)
{
    // LUA: title_write(lumpname [, format])

    const char *lumpname = luaL_checkstring(L, 1);
    const char *format   = luaL_optstring(L, 2, "");

    SYS_ASSERT(title_pix);

    qLump_c *lump;

    if (StringCompare(format, "tga") == 0)
    {
        lump = TitleCreateTGA();
    }
    else if (StringCompare(format, "raw") == 0)
    {
        lump = TitleCreateRaw();
    }
    else
    {
        lump   = TitleCreatePatch();
        format = "lmp";
    }

    if (game_object->file_per_map)
    {
        ZIPF_AddMem(StringFormat("graphics/%s.%s", lumpname, format), (uint8_t *)lump->GetBuffer(), lump->GetSize());
    }
    else
    {
        WriteLump(lumpname, lump);
    }

    delete lump;

    return 0;
}

int title_set_palette(lua_State *L)
{
    // LUA: title_set_palette(pal_table)

    int stack_idx = 1;

    if (!lua_istable(L, stack_idx))
    {
        luaL_argerror(L, 1, "bad palette (not a table)");
    }

    for (int c = 0; c < 256; c++)
    {
        lua_pushinteger(L, c * 3 + 1);
        lua_gettable(L, stack_idx);

        lua_pushinteger(L, c * 3 + 2);
        lua_gettable(L, stack_idx);

        lua_pushinteger(L, c * 3 + 3);
        lua_gettable(L, stack_idx);

        if (!lua_isnumber(L, -3) || !lua_isnumber(L, -2) || !lua_isnumber(L, -1))
        {
            luaL_error(L, "bad palette");
        }

        int r = lua_tointeger(L, -3);
        int g = lua_tointeger(L, -2);
        int b = lua_tointeger(L, -1);

        lua_pop(L, 3);

        title_palette[c] = OBSIDIAN_MAKE_RGBA(r, g, b, 255);
    }

    return 0;
}
} // namespace Doom

static void TitleParsePen(const char *what)
{
    if (StringCompare(what, "circle") == 0)
    {
        title_drawctx.pen_type = PEN_Circle;
    }
    else if (StringCompare(what, "box") == 0)
    {
        title_drawctx.pen_type = PEN_Box;
    }
    else if (StringCompare(what, "slash") == 0)
    {
        title_drawctx.pen_type = PEN_Slash;
    }
    else if (StringCompare(what, "slash2") == 0)
    {
        title_drawctx.pen_type = PEN_Slash2;
    }
}

static void TitleParseRenderMode(const char *what)
{
    // Note: REND_Textured is handled differently

    if (StringCompare(what, "solid") == 0)
    {
        title_drawctx.render_mode = REND_Solid;
    }
    else if (StringCompare(what, "additive") == 0)
    {
        title_drawctx.render_mode = REND_Additive;
    }
    else if (StringCompare(what, "subtract") == 0)
    {
        title_drawctx.render_mode = REND_Subtract;
    }
    else if (StringCompare(what, "multiply") == 0)
    {
        title_drawctx.render_mode = REND_Multiply;
    }
    else if (StringCompare(what, "gradient") == 0)
    {
        title_drawctx.render_mode = REND_Gradient;
    }
    else if (StringCompare(what, "gradient3") == 0)
    {
        title_drawctx.render_mode = REND_Gradient3;
    }
    else if (StringCompare(what, "random") == 0)
    {
        title_drawctx.render_mode = REND_Random;
    }
}

static void TitleParseTexture(lua_State *L, const char *filename)
{
    if (!TitleCacheImage(filename))
    {
        luaL_error(L, "title_prop: no such image: %s", filename);
    }

    title_drawctx.render_mode = REND_Textured;
}

namespace Doom
{
int title_property(lua_State *L)
{
    // LUA: title_property(name, value)

    const char *propname = luaL_checkstring(L, 1);

    if (StringCompare(propname, "reset") == 0)
    {
        title_drawctx.Reset();
    }
    else if (StringCompare(propname, "color") == 0 || StringCompare(propname, "color1") == 0)
    {
        title_drawctx.color[0] = Grab_Color(L, 2);
    }
    else if (StringCompare(propname, "color2") == 0)
    {
        title_drawctx.color[1] = Grab_Color(L, 2);
    }
    else if (StringCompare(propname, "color3") == 0)
    {
        title_drawctx.color[2] = Grab_Color(L, 2);
    }
    else if (StringCompare(propname, "color4") == 0)
    {
        title_drawctx.color[3] = Grab_Color(L, 2);
    }
    else if (StringCompare(propname, "box_w") == 0)
    {
        title_drawctx.box_w = luaL_checkinteger(L, 2);
    }
    else if (StringCompare(propname, "box_h") == 0)
    {
        title_drawctx.box_h = luaL_checkinteger(L, 2);
    }
    else if (StringCompare(propname, "grad_y1") == 0)
    {
        title_drawctx.grad_y1 = luaL_checkinteger(L, 2);
    }
    else if (StringCompare(propname, "grad_y2") == 0)
    {
        title_drawctx.grad_y2 = luaL_checkinteger(L, 2);
    }
    else if (StringCompare(propname, "pen_type") == 0)
    {
        TitleParsePen(luaL_checkstring(L, 2));
    }
    else if (StringCompare(propname, "render_mode") == 0)
    {
        TitleParseRenderMode(luaL_checkstring(L, 2));
    }
    else if (StringCompare(propname, "texture") == 0)
    {
        TitleParseTexture(L, luaL_checkstring(L, 2));
    }

    return 0;
}
} // namespace Doom

static inline rgb_color_t CalcAlphaBlend(rgb_color_t C1, rgb_color_t C2, int alpha)
{
    if (alpha == 255)
    {
        return C2;
    }
    if (alpha == 0)
    {
        return C1;
    }

    int r = OBSIDIAN_RGB_RED(C1) * (256 - alpha) + OBSIDIAN_RGB_RED(C2) * alpha;
    int g = OBSIDIAN_RGB_GREEN(C1) * (256 - alpha) + OBSIDIAN_RGB_GREEN(C2) * alpha;
    int b = OBSIDIAN_RGB_BLUE(C1) * (256 - alpha) + OBSIDIAN_RGB_BLUE(C2) * alpha;

    r >>= 8;
    g >>= 8;
    b >>= 8;

    return OBSIDIAN_MAKE_RGBA(r, g, b, 255);
}

static inline rgb_color_t CalcGradient(float along)
{
    if (along < 0)
    {
        along = 0;
    }
    if (along > 1)
    {
        along = 1;
    }

    rgb_color_t col1 = title_drawctx.color[0];
    rgb_color_t col2 = title_drawctx.color[1];

    if (title_drawctx.render_mode == REND_Gradient3)
    {
        along = along * 2.0;

        if (along > 1)
        {
            along = along - 1;

            col1 = col2;
            col2 = title_drawctx.color[2];
        }
    }
    else
    {
        // this assumes top color is brigher than bottom color
        along = pow(along, 0.75);
    }

    int r = OBSIDIAN_RGB_RED(col1) * (1 - along) + OBSIDIAN_RGB_RED(col2) * along;
    int g = OBSIDIAN_RGB_GREEN(col1) * (1 - along) + OBSIDIAN_RGB_GREEN(col2) * along;
    int b = OBSIDIAN_RGB_BLUE(col1) * (1 - along) + OBSIDIAN_RGB_BLUE(col2) * along;

    return OBSIDIAN_MAKE_RGBA(r, g, b, 255);
}

static inline rgb_color_t CalcAdditive(rgb_color_t C1, rgb_color_t C2)
{
    int r = OBSIDIAN_RGB_RED(C1) + OBSIDIAN_RGB_RED(C2);
    int g = OBSIDIAN_RGB_GREEN(C1) + OBSIDIAN_RGB_GREEN(C2);
    int b = OBSIDIAN_RGB_BLUE(C1) + OBSIDIAN_RGB_BLUE(C2);

    r = OBSIDIAN_MIN(r, 255);
    g = OBSIDIAN_MIN(g, 255);
    b = OBSIDIAN_MIN(b, 255);

    return OBSIDIAN_MAKE_RGBA(r, g, b, 255);
}

static inline rgb_color_t CalcSubtract(rgb_color_t C1, rgb_color_t C2)
{
    int r = OBSIDIAN_RGB_RED(C1) - OBSIDIAN_RGB_RED(C2);
    int g = OBSIDIAN_RGB_GREEN(C1) - OBSIDIAN_RGB_GREEN(C2);
    int b = OBSIDIAN_RGB_BLUE(C1) - OBSIDIAN_RGB_BLUE(C2);

    r = OBSIDIAN_MAX(r, 0);
    g = OBSIDIAN_MAX(g, 0);
    b = OBSIDIAN_MAX(b, 0);

    return OBSIDIAN_MAKE_RGBA(r, g, b, 255);
}

static inline rgb_color_t CalcMultiply(rgb_color_t C1, rgb_color_t C2)
{
    int r = OBSIDIAN_RGB_RED(C1) * (OBSIDIAN_RGB_RED(C2) + 1);
    int g = OBSIDIAN_RGB_GREEN(C1) * (OBSIDIAN_RGB_GREEN(C2) + 1);
    int b = OBSIDIAN_RGB_BLUE(C1) * (OBSIDIAN_RGB_BLUE(C2) + 1);

    r = r >> 8;
    g = g >> 8;
    b = b >> 8;

    return OBSIDIAN_MAKE_RGBA(r, g, b, 255);
}

static inline rgb_color_t CalcPixel(int x, int y)
{
    float along = 0;

    int px, py;
    int hash;

    switch (title_drawctx.render_mode)
    {
    case REND_Solid:
        break;

    case REND_Additive:
        return CalcAdditive(title_pix[y * title_W3 + x], title_drawctx.color[0]);

    case REND_Subtract:
        return CalcSubtract(title_pix[y * title_W3 + x], title_drawctx.color[0]);

    case REND_Multiply:
        return CalcMultiply(title_pix[y * title_W3 + x], title_drawctx.color[0]);

    case REND_Textured:
        if (!title_last_tga)
        {
            return OBSIDIAN_MAKE_RGBA(0, 255, 255, 255);
        }

        px = (x / 3) % title_last_tga->width;
        py = (y / 3) % title_last_tga->height;

        return title_last_tga->pixels[py * title_last_tga->width + px];

    case REND_Gradient:
    case REND_Gradient3:
        if (title_drawctx.grad_y2 > title_drawctx.grad_y1)
        {
            along =
                (float)(y - 3 * title_drawctx.grad_y1) / (float)(3 * title_drawctx.grad_y2 - 3 * title_drawctx.grad_y1);
        }
        return CalcGradient(along);

    case REND_Random:
        x    = x | 1;
        y    = y | 1;
        hash = IntHash((y << 16) | x);
        hash = (hash >> 8) & 3;
        return title_drawctx.color[hash];
    }

    return title_drawctx.color[0];
}

static void TDraw_Box(int x, int y, int w, int h)
{
    // clip the box
    int x1 = x;
    int y1 = y;
    int x2 = x + w;
    int y2 = y + h;

    x1 = OBSIDIAN_MAX(x1, 0);
    y1 = OBSIDIAN_MAX(y1, 0);

    x2 = OBSIDIAN_MIN(x2, title_W3);
    y2 = OBSIDIAN_MIN(y2, title_H3);

    if (x1 > x2 || y1 > y2)
    {
        return;
    }

    for (int y = y1; y < y2; y++)
    {
        for (int x = x1; x < x2; x++)
        {
            title_pix[y * title_W3 + x] = CalcPixel(x, y);
        }
    }
}

static void TDraw_Slash(int x, int y, int w, int dir)
{
    if (!dir)
    {
        y = y + w;
    }

    int box_size = title_drawctx.box_h * 3;

    for (int i = 0; i <= w; i++)
    {
        TDraw_Box(x, y, box_size, box_size);

        x += 1;
        y += dir ? 1 : -1;
    }
}

static void TDraw_Circle(int x, int y, int w, int h)
{
    int bmx = x + w / 2;
    int bmy = y + h / 2;

    // clip the box
    int x1 = x;
    int y1 = y;
    int x2 = x + w;
    int y2 = y + h;

    x1 = OBSIDIAN_MAX(x1, 0);
    y1 = OBSIDIAN_MAX(y1, 0);

    x2 = OBSIDIAN_MIN(x2, title_W3);
    y2 = OBSIDIAN_MIN(y2, title_H3);

    if (x1 > x2 || y1 > y2)
    {
        return;
    }

    for (int y = y1; y < y2; y++)
    {
        for (int x = x1; x < x2; x++)
        {
            float dx = (x - bmx) / (float)w;
            float dy = (y - bmy) / (float)h;

            if (dx * dx + dy * dy > 0.25)
            {
                continue;
            }

            title_pix[y * title_W3 + x] = CalcPixel(x, y);
        }
    }
}

static void TDraw_LinePart(int x, int y)
{
    switch (title_drawctx.pen_type)
    {
    case PEN_Circle:
        TDraw_Circle(x, y, title_drawctx.box_w * 3, title_drawctx.box_w * 3);
        break;

    case PEN_Box:
        TDraw_Box(x, y, title_drawctx.box_w * 3, title_drawctx.box_h * 3);
        break;

    case PEN_Slash:
        TDraw_Slash(x, y, title_drawctx.box_w * 3, 0);
        break;

    case PEN_Slash2:
        TDraw_Slash(x, y, title_drawctx.box_w * 3, 1);
        break;
    }
}

enum title_outcodes_e
{
    O_TOP    = 1,
    O_BOTTOM = 2,
    O_LEFT   = 4,
    O_RIGHT  = 8,
};

static int CalcOutcode(int x, int y)
{
    return ((y < 0) ? O_BOTTOM : 0) | ((y >= title_H3) ? O_TOP : 0) | ((x < 0) ? O_LEFT : 0) |
           ((x >= title_W3) ? O_RIGHT : 0);
}

static void TDraw_Line(int x1, int y1, int x2, int y2)
{
    int out1 = CalcOutcode(x1, y1);
    int out2 = CalcOutcode(x2, y2);

    if (out1 & out2)
    {
        return;
    }

    // handle simple (but common) cases of horiz/vert lines

    if (y1 == y2)
    {
        if (x1 > x2)
        {
            int tmp = x1;
            x1      = x2;
            x2      = tmp;
        }

        x1 = OBSIDIAN_MAX(0, x1);
        x2 = OBSIDIAN_MIN(title_W3 - 1, x2);

        for (; x1 <= x2; x1++)
        {
            TDraw_LinePart(x1, y1);
        }

        return;
    }

    if (x1 == x2)
    {
        if (y1 > y2)
        {
            int tmp = y1;
            y1      = y2;
            y2      = tmp;
        }

        y1 = OBSIDIAN_MAX(0, y1);
        y2 = OBSIDIAN_MIN(title_H3 - 1, y2);

        for (; y1 <= y2; y1++)
        {
            TDraw_LinePart(x1, y1);
        }

        return;
    }

    // clip diagonal line to the map
    // (this is the Cohen-Sutherland clipping algorithm)

    while (out1 | out2)
    {
        // may be partially inside box, find an outside point
        int outside = (out1 ? out1 : out2);

        int dx = x2 - x1;
        int dy = y2 - y1;

        // this almost certainly cannot happen, but for the sake of
        // robustness we check anyway (just in case)
        if (dx == 0 && dy == 0)
        {
            return;
        }

        int new_x, new_y;

        // clip to each side
        if (outside & O_BOTTOM)
        {
            new_y = 0;
            new_x = x1 + dx * (new_y - y1) / dy;
        }
        else if (outside & O_TOP)
        {
            new_y = title_H3 - 1;
            new_x = x1 + dx * (new_y - y1) / dy;
        }
        else if (outside & O_LEFT)
        {
            new_x = 0;
            new_y = y1 + dy * (new_x - x1) / dx;
        }
        else
        {
            SYS_ASSERT(outside & O_RIGHT);

            new_x = title_W3 - 1;
            new_y = y1 + dy * (new_x - x1) / dx;
        }

        if (out1)
        {
            x1 = new_x;
            y1 = new_y;

            out1 = CalcOutcode(x1, y1);
        }
        else
        {
            SYS_ASSERT(out2);

            x2 = new_x;
            y2 = new_y;

            out2 = CalcOutcode(x2, y2);
        }

        if (out1 & out2)
        {
            return;
        }
    }

    // this is the Bresenham line drawing algorithm
    // (based on code from am_map.c in the GPL DOOM source)

    int dx = x2 - x1;
    int dy = y2 - y1;

    int ax = 2 * (dx < 0 ? -dx : dx);
    int ay = 2 * (dy < 0 ? -dy : dy);

    int sx = dx < 0 ? -1 : 1;
    int sy = dy < 0 ? -1 : 1;

    int x = x1;
    int y = y1;

    if (ax > ay) // horizontal stepping
    {
        int d = ay - ax / 2;

        TDraw_LinePart(x, y);

        while (x != x2)
        {
            if (d >= 0)
            {
                y += sy;
                d -= ax;
            }

            x += sx;
            d += ay;

            TDraw_LinePart(x, y);
        }
    }
    else // vertical stepping
    {
        int d = ax - ay / 2;

        TDraw_LinePart(x, y);

        while (y != y2)
        {
            if (d >= 0)
            {
                x += sx;
                d -= ay;
            }

            y += sy;
            d += ax;

            TDraw_LinePart(x, y);
        }
    }
}

static void TDraw_Image(int x, int y, tga_image_c *img)
{
    for (int dy = 0; dy < img->height; dy++, y++)
    {
        if (y < 0)
        {
            continue;
        }
        if (y >= title_H)
        {
            break;
        }

        for (int dx = 0; dx < img->width; dx++)
        {
            int nx = x + dx;

            if (nx < 0)
            {
                continue;
            }
            if (nx >= title_W)
            {
                break;
            }

            rgb_color_t pix = img->pixels[dy * img->width + dx];

            int alpha = OBSIDIAN_RGB_ALPHA(pix);
            if (alpha == 0)
            {
                continue;
            }

            for (int ky = 0; ky < 3; ky++)
            {
                for (int kx = 0; kx < 3; kx++)
                {
                    int pos = (y * 3 + ky) * title_W3 + nx * 3 + kx;

                    if (alpha == 255)
                    {
                        title_pix[pos] = pix;
                    }
                    else
                    {
                        title_pix[pos] = CalcAlphaBlend(title_pix[pos], pix, alpha);
                    }
                }
            }
        }
    }
}

namespace Doom
{
int title_draw_rect(lua_State *L)
{
    // LUA: title_draw_rect(x, y, w, h)

    int x = luaL_checkinteger(L, 1);
    int y = luaL_checkinteger(L, 2);
    int w = luaL_checkinteger(L, 3);
    int h = luaL_checkinteger(L, 4);

    SYS_ASSERT(title_pix);

    TDraw_Box(x * 3, y * 3, w * 3, h * 3);
    return 0;
}

int title_draw_disc(lua_State *L)
{
    // LUA: title_draw_disc(x, y, w, h)

    int x = luaL_checkinteger(L, 1);
    int y = luaL_checkinteger(L, 2);
    int w = luaL_checkinteger(L, 3);
    int h = luaL_checkinteger(L, 4);

    SYS_ASSERT(title_pix);

    TDraw_Circle(x * 3, y * 3, w * 3, h * 3);
    return 0;
}

int title_draw_line(lua_State *L)
{
    // LUA: title_draw_line(x1, y1, x2, y2)

    int x1 = luaL_checkinteger(L, 1);
    int y1 = luaL_checkinteger(L, 2);
    int x2 = luaL_checkinteger(L, 3);
    int y2 = luaL_checkinteger(L, 4);
    TDraw_Line(x1 * 3, y1 * 3, x2 * 3, y2 * 3);
    return 0;
}

int title_load_image(lua_State *L)
{
    // LUA: title_load_image(x, y, filename)

    int x = luaL_checkinteger(L, 1);
    int y = luaL_checkinteger(L, 2);

    const char *filename = luaL_checkstring(L, 3);

    if (!TitleCacheImage(filename))
    {
        luaL_error(L, "title_load_image: no such file: %s", filename);
    }

    TDraw_Image(x, y, title_last_tga);

    return 0;
}

int title_draw_clouds(lua_State *L)
{
    // LUA: title_draw_clouds(seed, hue1,hue2,hue3, thresh, power, fracdim)

    unsigned long long seed = luaL_checkinteger(L, 1);

    rgb_color_t hue1 = Grab_Color(L, 2);
    rgb_color_t hue2 = Grab_Color(L, 3);
    rgb_color_t hue3 = Grab_Color(L, 4);

    double thresh   = luaL_optnumber(L, 5, 0.0);
    double powscale = luaL_optnumber(L, 6, 1.0);
    double fracdim  = luaL_optnumber(L, 7, 2.4);

    if (thresh > 0.98)
    {
        return luaL_error(L, "title_draw_clouds: bad thresh value");
    }

    if (powscale < 0.01)
    {
        return luaL_error(L, "title_draw_clouds: bad power value");
    }

    if (fracdim > 2.99 || fracdim < 0.2)
    {
        return luaL_error(L, "title_draw_clouds: bad fracdim value");
    }

    SYS_ASSERT(title_pix);
    SYS_ASSERT(title_W > 0);

    // create height field
    // [ it is a square, and size must be a power of two ]

    int W = OBSIDIAN_MAX(title_W, title_H) - 1;
    for (int k = 0; k < 30; k++)
    {
        W |= (W >> 1);
    }
    W += 1;

    float *synth = new float[W * W];

    TX_SpectralSynth(seed, synth, W, fracdim, powscale);

    for (int y = 0; y < title_H; y++)
    {
        for (int x = 0; x < title_W; x++)
        {
            float src = synth[y * W + x];

            if (src < thresh)
            {
                continue;
            }

            src = (src - thresh) * 2 / (1.0 - thresh);

            float r, g, b;

            if (src < 1.0)
            {
                r = OBSIDIAN_RGB_RED(hue2) * src + OBSIDIAN_RGB_RED(hue1) * (1.0 - src);
                g = OBSIDIAN_RGB_GREEN(hue2) * src + OBSIDIAN_RGB_GREEN(hue1) * (1.0 - src);
                b = OBSIDIAN_RGB_BLUE(hue2) * src + OBSIDIAN_RGB_BLUE(hue1) * (1.0 - src);
            }
            else
            {
                src = src - 1.0;

                r = OBSIDIAN_RGB_RED(hue3) * src + OBSIDIAN_RGB_RED(hue2) * (1.0 - src);
                g = OBSIDIAN_RGB_GREEN(hue3) * src + OBSIDIAN_RGB_GREEN(hue2) * (1.0 - src);
                b = OBSIDIAN_RGB_BLUE(hue3) * src + OBSIDIAN_RGB_BLUE(hue2) * (1.0 - src);
            }

            int r2 = OBSIDIAN_CLAMP(0, r, 255);
            int g2 = OBSIDIAN_CLAMP(0, g, 255);
            int b2 = OBSIDIAN_CLAMP(0, b, 255);

            rgb_color_t col = OBSIDIAN_MAKE_RGBA(r2, g2, b2, 255);

            for (int dy = 0; dy < 3; dy++)
            {
                for (int dx = 0; dx < 3; dx++)
                {
                    title_pix[(y * 3 + dy) * title_W3 + (x * 3 + dx)] = col;
                }
            }
        }
    }

    delete[] synth;

    return 0;
}

int title_draw_planet(lua_State *L)
{
    // LUA: title_draw_planet(x,y,r, seed, flags, hue1,hue2,hue3)

#if 0
    int px = luaL_checkinteger(L, 1);
    int py = luaL_checkinteger(L, 2);

    int ph = luaL_checkinteger(L, 3);
    int pw = ph * 5 / 4;

    int seed = luaL_checkinteger(L, 4);

    const char *flag_str = luaL_checkstring(L, 5);

    rgb_color_t hue1 = Grab_Color(L, 6);
    rgb_color_t hue2 = Grab_Color(L, 7);
    rgb_color_t hue3 = Grab_Color(L, 8);


    SYS_ASSERT(title_pix);

    px *= 3;  py *= 3;
    pw *= 3;  ph *= 3;

    // FIXME : clip !!!!


    int W = 512;

    float * synth = new float[W * W];

    TX_SpectralSynth(seed, synth, W, 1.8, 1.0);

    // add craters
    srand(seed);

    if (false)
    for (int ci = 0 ; ci < 250 ; ci++)
    {
        int cr = 8 + (rand() & 63);

        int mx = rand() & 511;
        int my = rand() & 511;

        for (int dx = -cr ; dx < cr ; dx++)
        for (int dy = -cr ; dy < cr ; dy++)
        {
            if (dx*dx + dy*dy > cr*cr)
                continue;

            float d = hypot(dx, dy) / (float)cr;

            int sx = (mx + dx) & 511;
            int sy = (my + dy) & 511;

            synth[sy*W + sx] += 0.3 * (1 - d*d);
        }
    }

/*
for (int ky = 40 ; ky < 110 ; ky++)
for (int kx = 0   ; kx < W ; kx++)
{
    synth[ky*W + kx] -= 0.1;
}*/


    for (int y = py - ph ; y < py + ph ; y++)
    for (int x = px - pw ; x < px + pw ; x++)
    {
        int dx = (x - px) * 4 / 5;
        int dy = (y - py);

        if (dx * dx + dy * dy > ph * ph)
            continue;


        // coordinate in synthesized noise
        int tx1 = dx & 511;
        int tx2 = (dx+1) & 511;

        int ty1 = dy & 511;
        int ty2 = (dy+1) & 511;


        float K  = synth[tx1*W + ty1];

        float T1 = synth[ty1*W + tx2] - synth[ty1*W + tx1];
        float T2 = synth[ty2*W + tx1] - synth[ty1*W + tx1];


        // compute normal at point
        float nx = dx / (float)ph + T1 * 10;
        float ny = dy / (float)ph + T2 * 10;
        float nz = 1.0 - hypot(nx, ny);


        rgb_color_t col;

        // TEMP CRUD
#if 1
        int ity = 128 + (nx - ny + nz) * 128;
        ity = OBSIDIAN_CLAMP(0, ity, 255);

        if ((int)(K * 32) & 3)
            col = OBSIDIAN_MAKE_RGBA(0  , 0  , ity, 255);
        else
            col = OBSIDIAN_MAKE_RGBA(0  ,ity ,   0, 255);
#else
        // moon colors
        int ity = 80 + (nx + nx + nx) * 60;
        ity = OBSIDIAN_CLAMP(0, ity, 255);

        col = OBSIDIAN_MAKE_RGBA(ity, ity, ity, 255);
#endif

        title_pix[y * title_W3 + x] = col;
    }

    delete[] synth;
#endif

    return 0;
}
} // namespace Doom

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
