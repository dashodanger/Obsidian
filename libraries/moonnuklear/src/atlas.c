/* The MIT License (MIT)
 *
 * Copyright (c) 2018 Stefano Trettel
 *
 * Software repository: MoonNuklear, https://github.com/stetre/moonnuklear
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "internal.h"

static int freefont_atlas(lua_State *L, ud_t *ud)
    {
    nk_atlas_t *atlas = (nk_atlas_t*)ud->handle;
    freechildren(L, FONT_MT, ud);
    freechildren(L, CURSOR_MT, ud);
    if(!freeuserdata(L, ud, "atlas")) return 0;
    nk_font_atlas_clear(atlas);
    Free(L, atlas);
    return 0;
    }

static int Init(lua_State *L)
    {
    ud_t *ud;
    nk_atlas_t *atlas;
    atlas = (nk_atlas_t*)Malloc(L, sizeof(nk_atlas_t));
    nk_font_atlas_init_default(atlas);
    //void nk_font_atlas_init(nk_atlas_t*, nk_allocator_t*);
    //void nk_font_atlas_init_custom(nk_atlas_t*, nk_allocator_t*, nk_allocator_t*);
    ud = newuserdata(L, atlas, ATLAS_MT, "atlas");
    ud->parent_ud = NULL;
    ud->destructor = freefont_atlas;
    return 1;
    }

static int InitFromPtr(lua_State *L)
    {
    ud_t *ud;
    nk_atlas_t *atlas = (nk_atlas_t*)checklightuserdata(L, 1);
    ud = newuserdata(L, atlas, ATLAS_MT, "atlas");
    ud->parent_ud = NULL;
    ud->destructor = freefont_atlas;
    MarkBorrowed(ud);
    return 1;
    }

static int Font_atlas_begin(lua_State *L)
    {
    nk_atlas_t *atlas = checkatlas(L, 1, NULL);
    nk_font_atlas_begin(atlas);
    return 0;
    }
 
static int Font_atlas_add(lua_State *L)
    {
    int err;
    ud_t *ud;
    nk_font_t* font;
    nk_atlas_t *atlas = checkatlas(L, 1, &ud);
    float height = luaL_checknumber(L, 2);
    const char *file_path = luaL_optstring(L, 3, NULL);
    nk_font_config_t *config = echeckfontconfig(L, 4, height, &err);
    if(err)
        { if(err == ERR_NOTPRESENT) lua_pop(L, 1); else return argerror(L, 4); }
    if(file_path)
        font = nk_font_atlas_add_from_file(atlas, file_path, height, config);
    else
        font = nk_font_atlas_add_default(atlas, height, config);
    //Not currently used:
    //nk_font_t* nk_font_atlas_add(atlas, const nk_font_config_t*);
    //nk_font_t* nk_font_atlas_add_from_memory(atlas, void*, nk_size, float, const nk_font_config_t*);
    //nk_font_t *nk_font_atlas_add_compressed(atlas, void*, nk_size, float, const nk_font_config_t*);
    //nk_font_t* nk_font_atlas_add_compressed_base85(atlas, const char*, float, const nk_font_config_t*);
    if(!font) return errorc(L, ERR_FAILED);
    pushatlasfont(L, ud, font, config);
    return 1;
    }

static int Font_atlas_bake(lua_State *L)
    {
    ud_t *ud;
    int width, height;
    size_t len = 0;
    nk_atlas_t *atlas = checkatlas(L, 1, &ud);
    enum nk_font_atlas_format fmt = checkfontatlasformat(L, 2);
    const void* pixels = nk_font_atlas_bake(atlas, &width, &height, fmt);
    switch(fmt)
        {
        case NK_FONT_ATLAS_ALPHA8: len = width*height; break;
        case NK_FONT_ATLAS_RGBA32: len = width*height*4; break;
        }
    lua_pushlstring(L, (char*)pixels, len);
    lua_pushinteger(L, width);
    lua_pushinteger(L, height);
    return 3;
    }

static int Font_atlas_end(lua_State *L)
    {
    nk_handle_t tex;
    nk_draw_null_texture_t dnt;
    nk_atlas_t *atlas = checkatlas(L, 1, NULL);
    tex.id = luaL_checkinteger(L, 2);
    nk_font_atlas_end(atlas, tex, &dnt);
    lua_pushinteger(L, dnt.texture.id);
    pushvec2(L, &dnt.uv);
    return 2;
    }

static int Font_atlas_cleanup(lua_State *L)
    {
    nk_atlas_t *atlas = checkatlas(L, 1, NULL);
    nk_font_atlas_cleanup(atlas);
    return 0;
    }

static int Default_font(lua_State *L)
    {
    ud_t *ud;
    nk_atlas_t *atlas = checkatlas(L, 1, &ud);
    if(!atlas->default_font) return 0;
    pushatlasfont(L, ud, atlas->default_font, NULL);
    return 1;
    }

static int Cursor(lua_State *L)
    {
    ud_t *ud;
    nk_atlas_t *atlas = checkatlas(L, 1, &ud);
    enum nk_style_cursor what = checkstylecursor(L, 2);
    pushatlascursor(L, ud, &atlas->cursors[what]);
    return 1;
    }


#define F(Func, func)                       \
static int Func(lua_State *L)               \
    {                                       \
    pushrunelist(L, (nk_rune*)func());      \
    return 1;                               \
    }

F(Font_default_glyph_ranges, nk_font_default_glyph_ranges)
F(Font_chinese_glyph_ranges, nk_font_chinese_glyph_ranges)
F(Font_cyrillic_glyph_ranges, nk_font_cyrillic_glyph_ranges)
F(Font_korean_glyph_ranges, nk_font_korean_glyph_ranges)
#undef F


TYPE_FUNC(atlas)
DELETE_FUNC(atlas)

static const struct luaL_Reg Methods[] = 
    {
        { "type", Type },
        { "free",  Delete },
        { "begin", Font_atlas_begin },
        { "add", Font_atlas_add },
        { "bake", Font_atlas_bake },
        { "done", Font_atlas_end }, /* 'end' is a reserved keyword in Lua */
        { "cleanup", Font_atlas_cleanup },
        { "default_font", Default_font },
        { "cursor", Cursor },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg MetaMethods[] = 
    {
        { "__gc",  Delete },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg Functions[] = 
    {
        { "new_font_atlas", Init },
        { "font_atlas_from_ptr", InitFromPtr },
        { "font_default_glyph_ranges", Font_default_glyph_ranges },
        { "font_chinese_glyph_ranges", Font_chinese_glyph_ranges },
        { "font_cyrillic_glyph_ranges", Font_cyrillic_glyph_ranges },
        { "font_korean_glyph_ranges", Font_korean_glyph_ranges },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_atlas(lua_State *L)
    {
    udata_define(L, ATLAS_MT, Methods, MetaMethods);
    luaL_setfuncs(L, Functions, 0);
    }

