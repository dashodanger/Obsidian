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

/*-----------------------------------------------------------------------------
 | Window
 *----------------------------------------------------------------------------*/

static int Window_begin(lua_State *L)
    {
    int rc = 0;
    const char *name;
    nk_rect_t bounds;
    nk_flags flags;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *title = luaL_checkstring(L, 2);
    if(echeckrect(L, 3, &bounds)) return argerror(L, 3);
    flags = checkflags(L, 4); /* nk_panel_flags */
    if(lua_isnoneornil(L, 5))
        rc = nk_begin(context, title, bounds, flags);
    else
        {
        name = luaL_checkstring(L, 5);
        rc = nk_begin_titled(context, name, title, bounds, flags);
        }
    lua_pushboolean(L, rc);
    return 1;
    }

static int Window_end(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_end(context);
    return 0;
    }

static int Window_get_bounds(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_rect_t r = nk_window_get_bounds(context);
    return pushrect(L, &r);
    }

static int Window_get_position(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_vec2_t v = nk_window_get_position(context);
    return pushvec2(L, &v);
    }

static int Window_get_size(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_vec2_t v = nk_window_get_size(context);
    return pushvec2(L, &v);
    }

static int Window_get_width(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float w = nk_window_get_width(context);
    lua_pushnumber(L, w);
    return 1;
    }

static int Window_get_height(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float h = nk_window_get_height(context);
    lua_pushnumber(L, h);
    return 1;
    }

static int Window_get_content_region(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_rect_t r = nk_window_get_content_region(context);
    return pushrect(L, &r);
    }

static int Window_get_content_region_min(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_vec2_t v = nk_window_get_content_region_min(context);
    return pushvec2(L, &v);
    }

static int Window_get_content_region_max(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_vec2_t v = nk_window_get_content_region_max(context);
    return pushvec2(L, &v);
    }

static int Window_get_content_region_size(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_vec2_t v = nk_window_get_content_region_size(context);
    return pushvec2(L, &v);
    }

static int Window_get_canvas(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_canvas_t* canvas = nk_window_get_canvas(context);
    if(!canvas) return 0;
    return newcanvas(L, canvas);
    }

#define F(Func, func)                                   \
static int Func(lua_State *L)                           \
    {                                                   \
    nk_context_t *context = checkcontext(L, 1, NULL);   \
    lua_pushboolean(L, func(context));                  \
    return 1;                                           \
    }

F(Window_has_focus, nk_window_has_focus)
F(Window_is_hovered, nk_window_is_hovered)
F(Window_is_any_hovered, nk_window_is_any_hovered)
F(Item_is_any_active, nk_item_is_any_active)

#undef F


#define F(Func, func)                                   \
static int Func(lua_State *L)                           \
    {                                                   \
    nk_context_t *context = checkcontext(L, 1, NULL);   \
    const char *name = luaL_checkstring(L, 2);          \
    lua_pushboolean(L, func(context, name));            \
    return 1;                                           \
    }

F(Window_is_collapsed, nk_window_is_collapsed)
F(Window_is_closed, nk_window_is_closed)
F(Window_is_hidden, nk_window_is_hidden)
F(Window_is_active, nk_window_is_active)

#undef F


static int Window_set_bounds(lua_State *L)
    {
    nk_rect_t bounds;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *name = luaL_checkstring(L, 2);
    if(echeckrect(L, 3, &bounds)) return argerror(L, 3);
    nk_window_set_bounds(context, name, bounds);
    return 0;
    }

static int Window_set_position(lua_State *L)
    {
    nk_vec2_t pos;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *name = luaL_checkstring(L, 2);
    if(echeckvec2(L, 3, &pos)) return argerror(L, 3);
    nk_window_set_position(context, name, pos);
    return 0;
    }

static int Window_set_size(lua_State *L)
    {
    nk_vec2_t size;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *name = luaL_checkstring(L, 2);
    if(echeckvec2(L, 3, &size)) return argerror(L, 3);
    nk_window_set_size(context, name, size);
    return 0;
    }

static int Window_set_focus(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *name = luaL_checkstring(L, 2);
    nk_window_set_focus(context, name);
    return 0;
    }

static int Window_close(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *name = luaL_checkstring(L, 2);
    nk_window_close(context, name);
    return 0;
    }

static int Window_collapse(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *name = luaL_checkstring(L, 2);
    enum nk_collapse_states state = checkcollapsestates(L, 3);
    nk_window_collapse(context, name, state);
    return 0;
    }

static int Window_collapse_if(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *name = luaL_checkstring(L, 2);
    enum nk_collapse_states state = checkcollapsestates(L, 3);
    int cond = checkboolean(L, 4);
    nk_window_collapse_if(context, name, state, cond);
    return 0;
    }

static int Window_show(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *name = luaL_checkstring(L, 2);
    enum nk_show_states state = checkshowstates(L, 3);
    nk_window_show(context, name, state);
    return 0;
    }

static int Window_show_if(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *name = luaL_checkstring(L, 2);
    enum nk_show_states state = checkshowstates(L, 3);
    int cond = checkboolean(L, 4);
    nk_window_show_if(context, name, state, cond);
    return 0;
    }

static int Window_get_scroll(lua_State *L)
    {
    nk_uint offset_x, offset_y;
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_window_get_scroll(context, &offset_x, &offset_y);
    lua_pushinteger(L, offset_x);
    lua_pushinteger(L, offset_y);
    return 2;
    }

static int Window_set_scroll(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_uint offset_x = luaL_checkinteger(L, 2);
    nk_uint offset_y = luaL_checkinteger(L, 3);
    nk_window_set_scroll(context, offset_x, offset_y);
    return 0;
    }

#if 0
//@@ nk_window_t *nk_window_find(nk_context_t *ctx, const char *name);
#endif

/*-----------------------------------------------------------------------------
 | Group
 *----------------------------------------------------------------------------*/

static int Group_begin(lua_State *L)
    {
    int rc = 0;
    const char *name;
    nk_flags flags;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *title = luaL_checkstring(L, 2);
    flags = checkflags(L, 3); /* nk_panel_flags */
    if(lua_isnoneornil(L, 4))
        rc = nk_group_begin(context, title, flags);
    else
        {
        name = luaL_checkstring(L, 4);
        rc = nk_group_begin_titled(context, name, title, flags);
        }
    lua_pushboolean(L, rc);
    return 1;
    }

static int Group_end(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_group_end(context);
    return 0;
    }

static int Group_scrolled_begin(lua_State *L)
    {
    nk_scroll_t offset;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *title = luaL_checkstring(L, 2);
    nk_flags flags = checkflags(L, 3); /* nk_panel_flags */
    if(echeckscroll(L, 4, &offset)) return argerror(L, 4);
    if(!nk_group_scrolled_begin(context, &offset, title, flags))
        {
        lua_pushboolean(L, 0);
        return 1;
        }
    lua_pushboolean(L, 1);
    return 1;
    }

static int Group_scrolled_end(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_group_scrolled_end(context);
    return 0;
    }

static int Group_get_scroll(lua_State *L)
    {
    nk_uint offset_x, offset_y;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *title = luaL_checkstring(L, 2);
    nk_group_get_scroll(context, title, &offset_x, &offset_y);
    lua_pushinteger(L, offset_x);
    lua_pushinteger(L, offset_y);
    return 2;
    }

static int Group_set_scroll(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *title = luaL_checkstring(L, 2);
    nk_uint offset_x = luaL_checkinteger(L, 3);
    nk_uint offset_y = luaL_checkinteger(L, 4);
    nk_group_set_scroll(context, title, offset_x, offset_y);
    return 0;
    }


static const struct luaL_Reg Functions[] = 
    {
        { "window_begin", Window_begin },
        { "window_end", Window_end },
        { "window_get_bounds", Window_get_bounds },
        { "window_get_position", Window_get_position },
        { "window_get_size", Window_get_size },
        { "window_get_width", Window_get_width },
        { "window_get_height", Window_get_height },
        { "window_get_content_region", Window_get_content_region },
        { "window_get_content_region_min", Window_get_content_region_min },
        { "window_get_content_region_max", Window_get_content_region_max },
        { "window_get_content_region_size", Window_get_content_region_size },
        { "window_get_canvas", Window_get_canvas },
        { "window_get_scroll", Window_get_scroll },
        { "window_has_focus", Window_has_focus },
        { "window_is_hovered", Window_is_hovered },
        { "window_is_collapsed", Window_is_collapsed },
        { "window_is_closed", Window_is_closed },
        { "window_is_hidden", Window_is_hidden },
        { "window_is_active", Window_is_active },
        { "window_is_any_hovered", Window_is_any_hovered },
        { "item_is_any_active", Item_is_any_active },
        { "window_set_bounds", Window_set_bounds },
        { "window_set_position", Window_set_position },
        { "window_set_size", Window_set_size },
        { "window_set_focus", Window_set_focus },
        { "window_set_scroll", Window_set_scroll },
        { "window_close", Window_close },
        { "window_collapse", Window_collapse },
        { "window_collapse_if", Window_collapse_if },
        { "window_show", Window_show },
        { "window_show_if", Window_show_if },
        { "group_begin", Group_begin },
        { "group_end", Group_end },
        { "group_scrolled_begin", Group_scrolled_begin },
        { "group_scrolled_end", Group_scrolled_end },
        { "group_get_scroll", Group_get_scroll },
        { "group_set_scroll", Group_set_scroll },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_window(lua_State *L)
    {
    luaL_setfuncs(L, Functions, 0);
    }

