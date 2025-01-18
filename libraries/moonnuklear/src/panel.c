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

static int freepanel(lua_State *L, ud_t *ud)
    {
    // nk_panel_t *panel = (nk_panel_t*)ud->handle;
    if(!freeuserdata(L, ud, "panel")) return 0;
    return 0;
    }

static int newpanel(lua_State *L, ud_t *context_ud, nk_panel_t *panel)
    {
    ud_t *ud = userdata(panel);
    if(ud) /* already in */
        return pushpanel(L, panel);
    ud = newuserdata(L, panel, PANEL_MT, "panel");
    ud->parent_ud = context_ud;
    ud->context = (nk_context_t*)context_ud->context;
    ud->destructor = freepanel;
    return 1;
    }

static int Window_get_panel(lua_State *L)
    {
    ud_t *ud;
    nk_context_t *context = checkcontext(L, 1, &ud);
    nk_panel_t* panel = nk_window_get_panel(context);
    return newpanel(L, ud, panel);
    }

static int Get_bounds(lua_State *L)
    {
    nk_panel_t* panel = checkpanel(L, 1, NULL);
    pushrect(L, &panel->bounds);
    return 1;
    }

static int Get_type(lua_State *L)
    {
    nk_panel_t* panel = checkpanel(L, 1, NULL);
    pushflags(L, panel->type); /* nk_panel_type */
    return 1;
    }

static int Get_flags(lua_State *L)
    {
    nk_panel_t* panel = checkpanel(L, 1, NULL);
    pushflags(L, panel->flags); /* nk_window_flags */
    return 1;
    }

static int Get_offset(lua_State *L)
    {
    nk_panel_t* panel = checkpanel(L, 1, NULL);
    lua_pushinteger(L, *panel->offset_x);
    lua_pushinteger(L, *panel->offset_y);
    return 2;
    }

static int Get_at(lua_State *L)
    {
    nk_panel_t* panel = checkpanel(L, 1, NULL);
    lua_pushnumber(L, panel->at_x);
    lua_pushnumber(L, panel->at_y);
    return 2;
    }

#define F(Func, what) /* float */           \
static int Func(lua_State *L)               \
    {                                       \
    nk_panel_t* panel = checkpanel(L, 1, NULL); \
    lua_pushnumber(L, panel->what);         \
    return 1;                               \
    }

F(Get_footer_height, footer_height)
F(Get_header_height, header_height)
F(Get_border, border)
F(Get_max_x, max_x)

#undef F

static int Has_scrolling(lua_State *L)
    {
    nk_panel_t* panel = checkpanel(L, 1, NULL);
    lua_pushboolean(L, panel->has_scrolling);
    return 1;
    }

static int Get_clip(lua_State *L)
    {
    nk_panel_t* panel = checkpanel(L, 1, NULL);
    pushrect(L, &panel->clip);
    return 1;
    }

#if 0 //@@

struct nk_panel {  nk_panel_t
    struct nk_menu_state menu;
    struct nk_row_layout row;
    struct nk_chart chart;
    nk_canvas_t *buffer; //@@ panel_get_canvas?
    struct nk_panel *parent;
};

#endif


TYPE_FUNC(panel)
DELETE_FUNC(panel)

static const struct luaL_Reg Methods[] = 
    {
        { "type", Type },
        { "free",  Delete },
        { "get_bounds", Get_bounds },
        { "get_type", Get_type },
        { "get_flags", Get_flags },
        { "get_offset", Get_offset },
        { "get_at", Get_at },
        { "get_footer_height", Get_footer_height },
        { "get_header_height", Get_header_height },
        { "get_border", Get_border },
        { "get_max_x", Get_max_x },
        { "has_scrolling", Has_scrolling },
        { "get_clip", Get_clip },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg MetaMethods[] = 
    {
        { "__gc",  Delete },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg Functions[] = 
    {
        { "window_get_panel", Window_get_panel },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_panel(lua_State *L)
    {
    udata_define(L, PANEL_MT, Methods, MetaMethods);
    luaL_setfuncs(L, Functions, 0);
    }

