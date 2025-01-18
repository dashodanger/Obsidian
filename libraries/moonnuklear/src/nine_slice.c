/* The MIT License (MIT)
 *
 * Copyright (c) 2024 Stefano Trettel
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

static int freenine_slice(lua_State *L, ud_t *ud)
    {
    nk_nine_slice_t *nine_slice = (nk_nine_slice_t*)ud->handle;
    freechildren(L, CURSOR_MT, ud);
    if(!freeuserdata(L, ud, "nine_slice")) return 0;
    Free(L, nine_slice);
    return 0;
    }

static ud_t* New(lua_State *L, unsigned short w, unsigned short h, nk_rect_t subregion, unsigned short l, unsigned short t, unsigned short r, unsigned short b)
    {
    ud_t *ud;
    nk_nine_slice_t *nine_slice;
    int id = 0;
    void *ptr = NULL;

    if(lua_type(L, 1) == LUA_TLIGHTUSERDATA)
        ptr = checklightuserdata(L, 1);
    else
        id = luaL_checkinteger(L, 1);

    nine_slice = (nk_nine_slice_t*)Malloc(L, sizeof(nk_nine_slice_t));
    if(ptr) { nine_slice->img.handle.ptr = ptr; } else { nine_slice->img.handle.id = id; }
    nine_slice->l = l;
    nine_slice->t = t;
    nine_slice->r = r;
    nine_slice->b = b;
    nine_slice->img.w = w;
    nine_slice->img.h = h;
    nine_slice->img.region[0] = (unsigned short)subregion.x;
    nine_slice->img.region[1] = (unsigned short)subregion.y;
    nine_slice->img.region[2] = (unsigned short)subregion.w;
    nine_slice->img.region[3] = (unsigned short)subregion.h;
    ud = newuserdata(L, nine_slice, NINE_SLICE_MT, "nine_slice");
    ud->parent_ud = NULL;
    ud->destructor = freenine_slice;
    if(!ptr) MarkNineSliceId(ud);
    return ud;
    }

static int NewNineSlice(lua_State *L)
/* nine_slice = new_nine_slice(ptr|id, l, t, r, b) */
    { 
    nk_rect_t subregion;
    unsigned short l = luaL_checkinteger(L, 2);
    unsigned short t = luaL_checkinteger(L, 3);
    unsigned short r = luaL_checkinteger(L, 4);
    unsigned short b = luaL_checkinteger(L, 5);
    memset(&subregion, 0, sizeof(subregion));
    New(L, 0, 0, subregion, l, t, r, b);
    return 1;
    }

static int NewSubNineSlice(lua_State *L)
/* nine_slice = new_subnine_slice(ptr|id, w, h, rect, l, t, r, b) */
    {
    ud_t *ud;
    nk_rect_t subregion;
    unsigned short w = luaL_checkinteger(L, 2);
    unsigned short h = luaL_checkinteger(L, 3);
    unsigned short l = luaL_checkinteger(L, 5);
    unsigned short t = luaL_checkinteger(L, 6);
    unsigned short r = luaL_checkinteger(L, 7);
    unsigned short b = luaL_checkinteger(L, 8);
    if(echeckrect(L, 4, &subregion)) return argerror(L, 4);
    ud = New(L, w, h, subregion, l, t, r, b);
    MarkSubNineSlice(ud);
    return 1;
    }

#if 0
static int NineSlice_is_subnine_slice(lua_State *L)
    {
    ud_t *ud;
    (void)checknine_slice(L, 1, &ud);
    lua_pushboolean(L, IsSubNineSlice(ud));
    return 1;
    }
#endif

static int NineSlice_info(lua_State *L)
    {
    ud_t *ud;
    nk_rect_t r;
    nk_nine_slice_t *nine_slice = checknine_slice(L, 1, &ud);
    if(IsNineSliceId(ud))
        lua_pushlightuserdata(L, nine_slice->img.handle.ptr);
    else
        lua_pushinteger(L, nine_slice->img.handle.id);
    lua_pushinteger(L, nine_slice->l);
    lua_pushinteger(L, nine_slice->t);
    lua_pushinteger(L, nine_slice->r);
    lua_pushinteger(L, nine_slice->b);
    if(!IsSubNineSlice(ud))
        return 5;
    lua_pushinteger(L, nine_slice->img.w);
    lua_pushinteger(L, nine_slice->img.h);
    r.x = nine_slice->img.region[0];
    r.y = nine_slice->img.region[1];
    r.w = nine_slice->img.region[2];
    r.h = nine_slice->img.region[3];
    pushrect(L, &r);
    return 8;
    }

TYPE_FUNC(nine_slice)
DELETE_FUNC(nine_slice)

static const struct luaL_Reg Methods[] = 
    {
        { "type", Type },
        { "free",  Delete },
//      { "is_subnine_slice", NineSlice_is_subnine_slice },
        { "info", NineSlice_info },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg MetaMethods[] = 
    {
        { "__gc",  Delete },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg Functions[] = 
    {
        { "new_nine_slice", NewNineSlice },
        { "new_subnine_slice", NewSubNineSlice },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_nine_slice(lua_State *L)
    {
    udata_define(L, NINE_SLICE_MT, Methods, MetaMethods);
    luaL_setfuncs(L, Functions, 0);
    }

