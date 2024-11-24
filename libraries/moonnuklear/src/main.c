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

lua_State *moonnuklear_L = NULL;

static void AtExit(void)
    {
    if(moonnuklear_L)
        {
        enums_free_all(moonnuklear_L);
        moonnuklear_L = NULL;
        }
    }


int luaopen_moonnuklear(lua_State *L)
/* Lua calls this function to load the module */
    {
    moonnuklear_L = L;

    moonnuklear_utils_init(L);
    atexit(AtExit);

    lua_newtable(L); /* the nk table */

    /* add nk functions: */
    moonnuklear_open_versions(L);
    moonnuklear_open_enums(L);
    moonnuklear_open_flags(L);
    moonnuklear_open_tracing(L);
    moonnuklear_open_window(L);
    moonnuklear_open_layout(L);
    moonnuklear_open_widgets(L);
    moonnuklear_open_style(L);
    moonnuklear_open_context(L);
    moonnuklear_open_atlas(L);
    moonnuklear_open_font(L);
    moonnuklear_open_buffer(L);
    moonnuklear_open_image(L);
    moonnuklear_open_nine_slice(L);
    moonnuklear_open_cursor(L);
    moonnuklear_open_edit(L);
    moonnuklear_open_canvas(L);
    moonnuklear_open_panel(L);
    moonnuklear_open_input(L);

#if 0
    /* Add functions implemented in Lua @@ */
    lua_pushvalue(L, -1); lua_setglobal(L, "moonnuklear");
    if(luaL_dostring(L, "require('moonnuklear.utils')") != 0) lua_error(L);
    lua_pushnil(L);  lua_setglobal(L, "moonnuklear");
#endif

    return 1;
    }

