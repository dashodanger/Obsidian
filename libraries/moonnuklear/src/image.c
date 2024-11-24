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

static int freeimage(lua_State *L, ud_t *ud)
    {
    nk_image_t *image = (nk_image_t*)ud->handle;
    freechildren(L, CURSOR_MT, ud);
    if(!freeuserdata(L, ud, "image")) return 0;
    Free(L, image);
    return 0;
    }

static ud_t* New(lua_State *L, unsigned short w, unsigned short h, nk_rect_t subregion)
    {
    ud_t *ud;
    nk_image_t *image;
    int id = 0;
    void *ptr = NULL;

    if(lua_type(L, 1) == LUA_TLIGHTUSERDATA)
        ptr = checklightuserdata(L, 1);
    else
        id = luaL_checkinteger(L, 1);

    image = (nk_image_t*)Malloc(L, sizeof(nk_image_t));
    if(ptr) { image->handle.ptr = ptr; } else { image->handle.id = id; }
    image->w = w;
    image->h = h;
    image->region[0] = (unsigned short)subregion.x;
    image->region[1] = (unsigned short)subregion.y;
    image->region[2] = (unsigned short)subregion.w;
    image->region[3] = (unsigned short)subregion.h;
    ud = newuserdata(L, image, IMAGE_MT, "image");
    ud->parent_ud = NULL;
    ud->destructor = freeimage;
    if(!ptr) MarkImageId(ud);
    return ud;
    }

static int NewImage(lua_State *L)
/* image = new_image(ptr|id) */
    { 
    nk_rect_t subregion;
    memset(&subregion, 0, sizeof(subregion));
    New(L, 0, 0, subregion);
    return 1;
    }

static int NewSubImage(lua_State *L)
/* image = new_subimage(ptr|id, w, h, rect) */
    {
    ud_t *ud;
    nk_rect_t subregion;
    unsigned short w = luaL_checkinteger(L, 2);
    unsigned short h = luaL_checkinteger(L, 3);
    if(echeckrect(L, 4, &subregion)) return argerror(L, 4);
    ud = New(L, w, h, subregion);
    MarkSubImage(ud);
    return 1;
    }

#if 0
static int Image_is_subimage(lua_State *L)
    {
    ud_t *ud;
    (void)checkimage(L, 1, &ud);
    lua_pushboolean(L, IsSubImage(ud));
    return 1;
    }
#endif

static int Image_info(lua_State *L)
    {
    ud_t *ud;
    nk_rect_t r;
    nk_image_t *image = checkimage(L, 1, &ud);
    if(IsImageId(ud))
        lua_pushlightuserdata(L, image->handle.ptr);
    else
        lua_pushinteger(L, image->handle.id);
    if(!IsSubImage(ud))
        return 1;
    lua_pushinteger(L, image->w);
    lua_pushinteger(L, image->h);
    r.x = image->region[0];
    r.y = image->region[1];
    r.w = image->region[2];
    r.h = image->region[3];
    pushrect(L, &r);
    return 4;
    }

TYPE_FUNC(image)
DELETE_FUNC(image)

static const struct luaL_Reg Methods[] = 
    {
        { "type", Type },
        { "free",  Delete },
//      { "is_subimage", Image_is_subimage },
        { "info", Image_info },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg MetaMethods[] = 
    {
        { "__gc",  Delete },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg Functions[] = 
    {
        { "new_image", NewImage },
        { "new_subimage", NewSubImage },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_image(lua_State *L)
    {
    udata_define(L, IMAGE_MT, Methods, MetaMethods);
    luaL_setfuncs(L, Functions, 0);
    }

