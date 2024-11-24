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
#include "style.h"

#define VOID_CONTEXT(Func, func) /* void func(context) */\
static int Func(lua_State *L)                           \
    {                                                   \
    nk_context_t *context = checkcontext(L, 1, NULL);   \
    func(context);                                      \
    return 0;                                           \
    }

#define BOOLEAN_CONTEXT(Func, func) /* int func(context) */\
static int Func(lua_State *L)                           \
    {                                                   \
    nk_context_t *context = checkcontext(L, 1, NULL);   \
    lua_pushboolean(L, func(context));                  \
    return 1;                                           \
    }

VOID_CONTEXT(Style_default, nk_style_default)
 
static int Style_from_table(lua_State *L)
    {
    nk_color_t table[NK_COLOR_COUNT];
    nk_color_t defcolor = nk_rgba(0, 0, 0, 255);
    nk_context_t *context = checkcontext(L, 1, NULL);
    if(!lua_isnoneornil(L, 3) && echeckcolor(L, 3, &defcolor))
        return argerror(L, 3);
    if(echeckcolortable(L, 2, table, defcolor))
        return argerror(L, 2);
    nk_style_from_table(context, table);
    return 0;
    }

static int Style_load_cursor(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_style_cursor style = checkstylecursor(L, 2);
    const nk_cursor_t* cursor = checkcursor(L, 3, NULL);
    nk_style_load_cursor(context, style, cursor);
    return 0;
    }

static int Style_load_all_cursors(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_atlas_t *atlas = checkatlas(L, 2, NULL);
    nk_style_load_all_cursors(context, atlas->cursors);
    return 0;
    }

static int Style_set_font(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const nk_user_font_t *user_font = checkfont(L, 2, NULL);
    nk_style_set_font(context, user_font);
    return 0;
    }

static int Style_set_cursor(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_style_cursor stylecursor = checkstylecursor(L, 2);
    lua_pushboolean(L, nk_style_set_cursor(context, stylecursor));
    return 1;
    }


VOID_CONTEXT(Style_show_cursor, nk_style_show_cursor)
VOID_CONTEXT(Style_hide_cursor, nk_style_hide_cursor)

static int Style_push_font(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const nk_user_font_t *user_font = checkfont(L, 2, NULL);
    lua_pushboolean(L, nk_style_push_font(context, user_font));
    return 1;
    }

BOOLEAN_CONTEXT(Style_pop_font, nk_style_pop_font)

static float* address_float(nk_context_t *context, enum nonnk_style what)
    {
    switch(what)
        { 
        CASE_NONNK_STYLE_FLOAT
        default: return NULL;
        }
    return NULL;
    }

static int Style_push_float(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    float value = luaL_checknumber(L, 3);
    float *address = address_float(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    lua_pushboolean(L, nk_style_push_float(context, address, value));
    return 1;
    }

BOOLEAN_CONTEXT(Style_pop_float, nk_style_pop_float)

static int Style_set_float(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    float value = luaL_checknumber(L, 3);
    float *address = address_float(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    *address = value;
    return 0;
    }

static int Style_get_float(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    float *address = address_float(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    lua_pushnumber(L, *address);
    return 1;
    }

static nk_vec2_t* address_vec2(nk_context_t *context, enum nonnk_style what)
    {
    switch(what)
        { 
        CASE_NONNK_STYLE_VEC2
        default: return NULL;
        }
    return NULL;
    }

static int Style_push_vec2(lua_State *L)
    {
    nk_vec2_t value;
    nk_vec2_t *address = NULL;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    if(echeckvec2(L, 3, &value)) return argerror(L, 3);
    address = address_vec2(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    lua_pushboolean(L, nk_style_push_vec2(context, address, value));
    return 1;
    }

BOOLEAN_CONTEXT(Style_pop_vec2, nk_style_pop_vec2)

static int Style_set_vec2(lua_State *L)
    {
    nk_vec2_t value;
    nk_vec2_t *address = NULL;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    if(echeckvec2(L, 3, &value)) return argerror(L, 3);
    address = address_vec2(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    *address = value;
    return 0;
    }

static int Style_get_vec2(lua_State *L)
    {
    nk_vec2_t *address = NULL;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    address = address_vec2(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    pushvec2(L, address);
    return 1;
    }

static nk_flags* address_flags(nk_context_t *context, enum nonnk_style what)
    {
    switch(what)
        { 
        CASE_NONNK_STYLE_FLAGS
        default: return NULL;
        }
    return NULL;
    }

static int Style_push_flags(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    nk_flags value = checkflags(L, 3);
    nk_flags *address = address_flags(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    lua_pushboolean(L, nk_style_push_flags(context, address, value));
    return 1;
    }

BOOLEAN_CONTEXT(Style_pop_flags, nk_style_pop_flags)

static int Style_set_flags(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    nk_flags value = checkflags(L, 3);
    nk_flags *address = address_flags(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    *address = value;
    return 1;
    }

static int Style_get_flags(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    nk_flags *address = address_flags(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    pushflags(L, *address);
    return 1;
    }

static nk_color_t* address_color(nk_context_t *context, enum nonnk_style what)
    {
    switch(what)
        { 
        CASE_NONNK_STYLE_COLOR
        default: return NULL;
        }
    return NULL;
    }


static int Style_push_color(lua_State *L)
    {
    nk_color_t value;
    nk_color_t *address = NULL;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    if(echeckcolor(L, 3, &value)) return argerror(L, 3);
    address = address_color(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    lua_pushboolean(L, nk_style_push_color(context, address, value));
    return 1;
    }

BOOLEAN_CONTEXT(Style_pop_color, nk_style_pop_color)

static int Style_set_color(lua_State *L)
    {
    nk_color_t value;
    nk_color_t *address = NULL;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    if(echeckcolor(L, 3, &value)) return argerror(L, 3);
    address = address_color(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    *address = value;
    return 0;
    }


static int Style_get_color(lua_State *L)
    {
    nk_color_t *address = NULL;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    address = address_color(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    pushcolor(L, address);
    return 1;
    }

static nk_style_item_t *address_styleitem(nk_context_t *context, enum nonnk_style what)
    {
    switch(what)
        { 
        CASE_NONNK_STYLE_ITEM
        default: return NULL;
        }
    return NULL;
    }

static int Style_push_style_item(lua_State *L)
    {
    nk_style_item_t *address = NULL;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    nk_style_item_t value = checkstyleitem(L, 3);
    address = address_styleitem(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    lua_pushboolean(L, nk_style_push_style_item(context, address, value));
    return 1;
    }

BOOLEAN_CONTEXT(Style_pop_style_item, nk_style_pop_style_item)

static int Style_set_style_item(lua_State *L)
    {
    nk_style_item_t *address = NULL;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    nk_style_item_t value = checkstyleitem(L, 3);
    address = address_styleitem(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    *address = value;
    return 0;
    }

static int Style_get_style_item(lua_State *L)
    {
    nk_style_item_t *address = NULL;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    address = address_styleitem(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    pushstyleitem(L, address);
    return 1;
    }

static int* address_boolean(nk_context_t *context, enum nonnk_style what)
    {
    switch(what)
        { 
        CASE_NONNK_STYLE_BOOL
        default: return NULL;
        }
    return NULL;
    }

static int Style_set_boolean(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    int value = checkboolean(L, 3);
    int *address = address_boolean(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    *address = value;
    return 0;
    }

static int Style_get_boolean(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    int *address = address_boolean(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    lua_pushboolean(L, *address);
    return 1;
    }

static enum nk_symbol_type *address_symboltype(nk_context_t *context, enum nonnk_style what)
    {
    switch(what)
        { 
        CASE_NONNK_STYLE_SYMBOL_TYPE
        default: return NULL;
        }
    return NULL;
    }

static int Style_set_symboltype(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    enum nk_symbol_type value = checksymboltype(L, 3);
    enum nk_symbol_type *address = address_symboltype(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    *address = value;
    return 0;
    }

static int Style_get_symboltype(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nonnk_style what = checkstylefield(L, 2);
    enum nk_symbol_type *address = address_symboltype(context, what);
    if(!address) return argerrorc(L, 2, ERR_VALUE);
    pushsymboltype(L, *address);
    return 1;
    }

#if 0
//@@TODO?: CALLBACK and nk_handle_ptr fields ?
//const char* nk_style_get_color_by_name(enum nk_style_colors); useless
#endif

static const struct luaL_Reg Functions[] = 
    {
        { "style_default", Style_default },
        { "style_from_table", Style_from_table },
        { "style_load_cursor", Style_load_cursor },
        { "style_load_all_cursors", Style_load_all_cursors },
        { "style_set_font", Style_set_font },
        { "style_set_cursor", Style_set_cursor },
        { "style_show_cursor", Style_show_cursor },
        { "style_hide_cursor", Style_hide_cursor },
        { "style_push_font", Style_push_font },
        { "style_pop_font", Style_pop_font },
        { "style_push_float", Style_push_float },
        { "style_pop_float", Style_pop_float },
        { "style_set_float", Style_set_float },
        { "style_get_float", Style_get_float },
        { "style_push_vec2", Style_push_vec2 },
        { "style_pop_vec2", Style_pop_vec2 },
        { "style_set_vec2", Style_set_vec2 },
        { "style_get_vec2", Style_get_vec2 },
        { "style_push_flags", Style_push_flags },
        { "style_pop_flags", Style_pop_flags },
        { "style_set_flags", Style_set_flags },
        { "style_get_flags", Style_get_flags },
        { "style_push_color", Style_push_color },
        { "style_pop_color", Style_pop_color },
        { "style_set_color", Style_set_color },
        { "style_get_color", Style_get_color },
        { "style_push_style_item", Style_push_style_item },
        { "style_pop_style_item", Style_pop_style_item },
        { "style_set_style_item", Style_set_style_item },
        { "style_get_style_item", Style_get_style_item },
        { "style_set_boolean", Style_set_boolean },
        { "style_get_boolean", Style_get_boolean },
        { "style_set_symbol_type", Style_set_symboltype },
        { "style_get_symbol_type", Style_get_symboltype },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_style(lua_State *L)
    {
    luaL_setfuncs(L, Functions, 0);
    }

