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

static int freecursor(lua_State *L, ud_t *ud)
    {
    nk_cursor_t *cursor = (nk_cursor_t*)ud->handle;
    int is_atlas_cursor = IsAtlasCursor(ud);
    if(!freeuserdata(L, ud, "cursor")) return 0;
    if(is_atlas_cursor) return 0;
    Free(L, cursor);
    return 0;
    }

static int Create(lua_State *L)
/* cursor = cursor(image, size, offset) */
    {
    ud_t *ud, *image_ud;
    nk_cursor_t *cursor;
    nk_image_t *image;
    nk_vec2_t size, offset;

    image = checkimage(L, 1, &image_ud);
    if(echeckvec2(L, 2, &size)) return argerror(L, 2);
    if(echeckvec2(L, 2, &offset)) return argerror(L, 3);

    cursor = (nk_cursor_t*)Malloc(L, sizeof(nk_cursor_t));
    cursor->img = *image;
    cursor->size = size;
    cursor->offset = offset;

    ud = newuserdata(L, cursor, CURSOR_MT, "cursor");
    ud->parent_ud = image_ud;
    ud->destructor = freecursor;
    return 1;
    }

int pushatlascursor(lua_State *L, ud_t* atlas_ud, nk_cursor_t *cursor)
    {
    ud_t *ud = moonnuklear_userdata(cursor);
    if(ud) /* already in */
        { pushfont(L, cursor); return 1; }
    /* cursor is not yet known, create userdata and push it */
    ud = newuserdata(L, cursor, CURSOR_MT, "cursor");
    ud->parent_ud = atlas_ud;
    ud->destructor = freecursor;
    MarkAtlasCursor(ud);
    return 1;
    }

TYPE_FUNC(cursor)
DELETE_FUNC(cursor)

static const struct luaL_Reg Methods[] = 
    {
        { "type", Type },
        { "free",  Delete },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg MetaMethods[] = 
    {
        { "__gc",  Delete },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg Functions[] = 
    {
        { "new_cursor", Create },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_cursor(lua_State *L)
    {
    udata_define(L, CURSOR_MT, Methods, MetaMethods);
    luaL_setfuncs(L, Functions, 0);
    }

