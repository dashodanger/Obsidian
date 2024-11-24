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

static int Layout_set_min_row_height(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float height = luaL_checknumber(L, 1);
    nk_layout_set_min_row_height(context, height);
    return 0;
    }

static int Layout_reset_min_row_height(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_layout_reset_min_row_height(context);
    return 0;
    }

static int Layout_widget_bounds(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_rect_t r = nk_layout_widget_bounds(context);
    return pushrect(L, &r);
    }

static int Layout_ratio_from_pixel(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float pixel_width = luaL_checknumber(L, 2);
    lua_pushnumber(L, nk_layout_ratio_from_pixel(context, pixel_width));
    return 1;
    }

static int Layout_row_dynamic(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float height = luaL_checknumber(L, 2);
    int cols = luaL_checkinteger(L, 3);
    nk_layout_row_dynamic(context, height, cols);
    return 0;
    }

static int Layout_row_static(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float height = luaL_checknumber(L, 2);
    int item_width = luaL_checkinteger(L, 3);
    int cols = luaL_checkinteger(L, 4);
    nk_layout_row_static(context, height, item_width, cols);
    return 0;
    }

static int Layout_row_begin(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_layout_format fmt = checklayoutformat(L, 2);
    float row_height = luaL_checknumber(L, 3);
    int cols = luaL_checkinteger(L, 4);
    nk_layout_row_begin(context, fmt, row_height, cols);
    return 0;
    }

static int Layout_row_push(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float value = luaL_checknumber(L, 2);
    nk_layout_row_push(context, value);
    return 0;
    }

static int Layout_row_end(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_layout_row_end(context);
    return 0;
    }

static int Layout_row(lua_State *L)
    {
    ud_t *ud;
    int cols, err;
    nk_context_t *context = checkcontext(L, 1, &ud);
    enum nk_layout_format fmt = checklayoutformat(L, 2);
    float height = luaL_checknumber(L, 3);
    float *ratio = checkfloatlist(L, 4, &cols, &err);
    if(err) return argerrorc(L, 4, err);
    /* free the old list and replace it with the new one 
    *  (This is because it seems that nuklear retains the passed float*
    *  instead of making an internal copy. So, to avoid memory leaks, we
    *  store it the context's ud and free it the next time this function
    *  is called, or when the context itself is deleted.)
    */
    if(ud->ratio) Free(L, ud->ratio);
    ud->ratio = ratio;
    nk_layout_row(context, fmt, height, cols, ratio);
    return 0;
    }

static int Layout_row_template_begin(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float row_height = luaL_checknumber(L, 2);
    nk_layout_row_template_begin(context, row_height);
    return 0;
    }

static int Layout_row_template_push_dynamic(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_layout_row_template_push_dynamic(context);
    return 0;
    }

static int Layout_row_template_push_variable(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float min_width = luaL_checknumber(L, 2);
    nk_layout_row_template_push_variable(context, min_width);
    return 0;
    }

static int Layout_row_template_push_static(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float width = luaL_checknumber(L, 2);
    nk_layout_row_template_push_static(context, width);
    return 0;
    }

static int Layout_row_template_end(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_layout_row_template_end(context);
    return 0;
    }

static int Layout_space_begin(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_layout_format fmt = checklayoutformat(L, 2);
    float height = luaL_checknumber(L, 3);
    int widget_count = luaL_checkinteger(L, 4);
    nk_layout_space_begin(context, fmt, height, widget_count);
    return 0;
    }

static int Layout_space_push(lua_State *L)
    {
    nk_rect_t bounds; 
    nk_context_t *context = checkcontext(L, 1, NULL);
    if(echeckrect(L, 2, &bounds)) return argerror(L, 2);
    nk_layout_space_push(context, bounds);
    return 0;
    }

static int Layout_space_end(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_layout_space_end(context);
    return 0;
    }

static int Layout_space_bounds(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_rect_t r = nk_layout_space_bounds(context);
    return pushrect(L, &r);
    }

static int Layout_space_to_screen(lua_State *L)
    {
    nk_vec2_t v1, v2;
    nk_context_t *context = checkcontext(L, 1, NULL);
    if(echeckvec2(L, 2, &v1)) return argerror(L, 2);
    v2 = nk_layout_space_to_screen(context, v1);
    return pushvec2(L, &v2);
    }

static int Layout_space_to_local(lua_State *L)
    {
    nk_vec2_t v1, v2;
    nk_context_t *context = checkcontext(L, 1, NULL);
    if(echeckvec2(L, 2, &v1)) return argerror(L, 2);
    v2 = nk_layout_space_to_local(context, v1);
    return pushvec2(L, &v2);
    }

static int Layout_space_rect_to_screen(lua_State *L)
    {
    nk_rect_t r1, r2;
    nk_context_t *context = checkcontext(L, 1, NULL);
    if(echeckrect(L, 2, &r1)) return argerror(L, 2);
    r2 = nk_layout_space_rect_to_screen(context, r1);
    return pushrect(L, &r2);
    }

static int Layout_space_rect_to_local(lua_State *L)
    {
    nk_rect_t r1, r2;
    nk_context_t *context = checkcontext(L, 1, NULL);
    if(echeckrect(L, 2, &r1)) return argerror(L, 2);
    r2 = nk_layout_space_rect_to_local(context, r1);
    return pushrect(L, &r2);
    }


static const struct luaL_Reg Functions[] = 
    {
        { "layout_set_min_row_height", Layout_set_min_row_height },
        { "layout_reset_min_row_height", Layout_reset_min_row_height },
        { "layout_widget_bounds", Layout_widget_bounds },
        { "layout_ratio_from_pixel", Layout_ratio_from_pixel },
        { "layout_row_dynamic", Layout_row_dynamic },
        { "layout_row_static", Layout_row_static },
        { "layout_row_begin", Layout_row_begin },
        { "layout_row_push", Layout_row_push },
        { "layout_row_end", Layout_row_end },
        { "layout_row", Layout_row },
        { "layout_row_template_begin", Layout_row_template_begin },
        { "layout_row_template_push_dynamic", Layout_row_template_push_dynamic },
        { "layout_row_template_push_variable", Layout_row_template_push_variable },
        { "layout_row_template_push_static", Layout_row_template_push_static },
        { "layout_row_template_end", Layout_row_template_end },
        { "layout_space_begin", Layout_space_begin },
        { "layout_space_push", Layout_space_push },
        { "layout_space_end", Layout_space_end },
        { "layout_space_bounds", Layout_space_bounds },
        { "layout_space_to_screen", Layout_space_to_screen },
        { "layout_space_to_local", Layout_space_to_local },
        { "layout_space_rect_to_screen", Layout_space_rect_to_screen },
        { "layout_space_rect_to_local", Layout_space_rect_to_local },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_layout(lua_State *L)
    {
    luaL_setfuncs(L, Functions, 0);
    }

