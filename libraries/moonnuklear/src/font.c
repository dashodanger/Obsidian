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
#undef userdata /* to avoid clash between font.userdata and moonnuklear_userdata */

/* 
 * NOTE: The Nuklear API presents two 'font' objects: nk_user_font and nk_font.
 * MoonNuklear instead presents to the scripts a single 'font' object, that always
 * corresponds to a nk_user_font and may or may not have a link to a nk_font:
 * it has one if the nk_user_font is the font->handle of a nk_font, while it has
 * not one if the nk_user_font was created by the user via nk.new_user_font().
 * 
 * Font objects are created either by using nk.new_user_font() or by using the
 * atlas:add() method, in which case they are associated with a font atlas object.
 */

static int freefont(lua_State *L, ud_t *ud)
    {
    nk_user_font_t *font = (nk_user_font_t*)ud->handle;
    nk_font_config_t *cfg = ud->font_config;
    int allocated = IsAllocated(ud);
    if(!freeuserdata(L, ud, "font")) return 0;
    if(cfg) freefontconfig(L, cfg);
    if(allocated) Free(L, font);
    return 0;
    }

int pushatlasfont(lua_State *L, ud_t *atlas_ud, nk_font_t *atlas_font, nk_font_config_t *cfg)
/* Pushes the user font embedded in an atlas font, possibly creating the
 * associated ud if it is not yet known by MoonNuklear */
    {
    nk_user_font_t *font = &atlas_font->handle;
    ud_t *ud = moonnuklear_userdata(font);
    if(ud) /* already known */
        { 
        if(cfg) { return unexpected(L); }
        pushfont(L, font); return 1; 
        }
    /* not yet known, create ud */
    ud = newuserdata(L, font, FONT_MT, "font");
    ud->parent_ud = atlas_ud;
    ud->font = atlas_font;
    ud->font_config = cfg;
    ud->destructor = freefont;
    return 1;
    }

static int FontFromPtr(lua_State *L)
    {
    nk_font_t *ptr = (nk_font_t*)checklightuserdata(L, 1);
    nk_user_font_t *font = &ptr->handle;
    ud_t *ud = newuserdata(L, font, FONT_MT, "font (ptr)");
    ud->parent_ud = NULL;
    ud->font = ptr;
    ud->font_config = NULL;
    ud->destructor = freefont;
    return 1;
    }

/*------------------------------------------------------------------------------*
 | User font                                                                    |
 *------------------------------------------------------------------------------*/

static float WidthCallback(nk_handle handle, float height, const char* text, int len) // nk_text_width_f
    {
#define L moonnuklear_L
    float width;
    ud_t *ud = (ud_t*)(handle.ptr);
    pushvalue(L, ud->ref1);    // function
    lua_pushnumber(L, height); // arg1
    lua_pushlstring(L, text, len); // arg2
    if(lua_pcall(L, 2, 1, 0) != LUA_OK)
        { lua_error(L); return 0; }
    width = luaL_checknumber(L, -1); // retval1
    lua_pop(L, 1);
    return width;
#undef L
    }

static void QueryCallback(nk_handle handle, float height, nk_user_font_glyph_t *glyph, nk_rune codepoint, nk_rune next_codepoint) // nk_query_font_glyph_f
    {
#define L moonnuklear_L
    ud_t *ud = (ud_t*)(handle.ptr);
    pushvalue(L, ud->ref2);             // function
    lua_pushnumber(L, height);          // arg1
    lua_pushinteger(L, codepoint);      // arg2
    lua_pushinteger(L, next_codepoint); // arg3
    if(lua_pcall(L, 3, 6, 0) != LUA_OK)
        { lua_error(L); return; }
    /* fill glyph with the returned values */
    if(echeckvec2(L, -6, &glyph->uv[0])) argerror(L, -6);  // retval1
    if(echeckvec2(L, -5, &glyph->uv[1])) argerror(L, -5);  // retval2
    if(echeckvec2(L, -4, &glyph->offset)) argerror(L, -4); // retval3
    glyph->width = luaL_checknumber(L, -3);                // retval4
    glyph->height = luaL_checknumber(L, -2);               // retval5
    glyph->xadvance = luaL_checknumber(L, -1);             // retval6
    lua_pop(L, 6);
    return;
#undef L
    }

static int New(lua_State *L)
/* user_font = user_font(height, width_func, texture_id, query_func) */
    {
    ud_t *ud;
    int ref1, ref2;
    nk_user_font_t *font;
    float height = luaL_checknumber(L, 1);
    int texture_id = luaL_checknumber(L, 3);
    if(!lua_isfunction(L, 2)) return argerrorc(L, 2, ERR_TYPE);
    if(!lua_isfunction(L, 4)) return argerrorc(L, 4, ERR_TYPE);
    lua_pushvalue(L, 2); ref1 = luaL_ref(L, LUA_REGISTRYINDEX);
    lua_pushvalue(L, 4); ref2 = luaL_ref(L, LUA_REGISTRYINDEX);

    font = (nk_user_font_t*)Malloc(L, sizeof(nk_user_font_t));
    ud = newuserdata(L, font, FONT_MT, "font (user)");
    ud->parent_ud = NULL;
    ud->font = NULL;
    ud->ref1 = ref1;
    ud->ref2 = ref2;
    ud->destructor = freefont;
    MarkAllocated(ud);

    font->userdata.ptr = ud;
    font->height = height; /* max height of the font */
    font->width = WidthCallback; /* font string width in pixel callback */
    font->query = QueryCallback; /* font glyph callback to query drawing info */
    font->texture.id = texture_id; /* texture handle to the used font atlas or texture */
    return 1;
    }

static int Height(lua_State *L)
    {
    nk_user_font_t *font = checkfont(L, 1, NULL);
    lua_pushnumber(L, font->height);
    return 1;
    }

static int SetHeight(lua_State *L)
    {
    nk_user_font_t *font = checkfont(L, 1, NULL);
    float height = luaL_checknumber(L, 2);
    font->height = height;
    return 0;
    }

static int Width(lua_State *L)
    {
    size_t len;
    nk_user_font_t *font = checkfont(L, 1, NULL);
    float height = luaL_checknumber(L, 2);
    const char *text = luaL_checklstring(L, 3, &len);
    lua_pushnumber(L, font->width(font->userdata, height, text, (int)len));
    return 1;
    }

static int FindGlyph(lua_State *L)
    {
    ud_t *ud;
    nk_font_t *font;
    const nk_font_glyph_t *glyph;
    nk_rune unicode;
    (void*)checkfont(L, 1, &ud);
    if((font = ud->font) == NULL)
        return luaL_argerror(L, 1, "function not available for user created fonts"); //@@
    unicode = luaL_checkinteger(L, 2);
    glyph = nk_font_find_glyph(font, unicode);
    if(!glyph) return 0; /* not found */
    return pushfontglyph(L, glyph);
    }

static int Ranges(lua_State *L)
    {
    ud_t *ud;
    nk_font_t *font;
    (void*)checkfont(L, 1, &ud);
    if((font = ud->font) == NULL)
        return luaL_argerror(L, 1, "function not available for user created fonts"); //@@
    pushrunelist(L, font->config->range);
    return 1;
    }


TYPE_FUNC(font)
DELETE_FUNC(font)

static const struct luaL_Reg Methods[] = 
    {
        { "type", Type },
        { "free",  Delete },
        { "height", Height },
        { "set_height", SetHeight },
        { "width", Width },
        { "ranges", Ranges }, //@@
        { "find_glyph", FindGlyph },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg MetaMethods[] = 
    {
        { "__gc",  Delete },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg Functions[] = 
    {
        { "new_user_font", New },
        { "font_from_ptr", FontFromPtr },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_font(lua_State *L)
    {
    udata_define(L, FONT_MT, Methods, MetaMethods);
    luaL_setfuncs(L, Functions, 0);
    }

