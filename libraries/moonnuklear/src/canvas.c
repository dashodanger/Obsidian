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

static int freecanvas(lua_State *L, ud_t *ud)
    {
    //nk_canvas_t *canvas = (nk_canvas_t*)ud->handle;
    if(!freeuserdata(L, ud, "canvas")) return 0;
    return 0;
    }

int newcanvas(lua_State *L, nk_canvas_t *canvas)
    {
    ud_t *ud = userdata(canvas);
    if(ud) /* already in */
        pushcanvas(L, canvas);
    else /* new */
        {
        ud = newuserdata(L, canvas, CANVAS_MT, "canvas");
        ud->parent_ud = NULL;
        ud->destructor = freecanvas;
        }
    return 1;
    }

static int Stroke_line(lua_State *L)
    {
    nk_color_t color;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    float x0 = luaL_checknumber(L, 2);
    float y0 = luaL_checknumber(L, 3);
    float x1 = luaL_checknumber(L, 4);
    float y1 = luaL_checknumber(L, 5);
    float line_thickness = luaL_checknumber(L, 6);
    if(echeckcolor(L, 7, &color)) return argerror(L, 7);
    nk_stroke_line(canvas, x0, y0, x1, y1, line_thickness, color);
    return 0;
    }

static int Stroke_curve(lua_State *L)
    {
    nk_color_t color;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    float ax = luaL_checknumber(L, 2);
    float ay = luaL_checknumber(L, 3);
    float ctrl0x = luaL_checknumber(L, 4);
    float ctrl0y = luaL_checknumber(L, 5);
    float ctrl1x = luaL_checknumber(L, 6);
    float ctrl1y = luaL_checknumber(L, 7);
    float bx = luaL_checknumber(L, 8);
    float by = luaL_checknumber(L, 9);
    float line_thickness = luaL_checknumber(L, 10);
    if(echeckcolor(L, 11, &color)) return argerror(L, 11);
    nk_stroke_curve(canvas, ax, ay, ctrl0x, ctrl0y, ctrl1x, ctrl1y, bx, by, line_thickness, color);
    return 0;
    }

static int Stroke_rect(lua_State *L)
    {
    nk_rect_t r;
    nk_color_t color;
    float rounding, line_thickness;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    if(echeckrect(L, 2, &r)) return argerror(L, 2);
    rounding = luaL_checknumber(L, 3);
    line_thickness = luaL_checknumber(L, 4);
    if(echeckcolor(L, 5, &color)) return argerror(L, 5);
    nk_stroke_rect(canvas, r, rounding, line_thickness, color);
    return 0;
    }

static int Stroke_circle(lua_State *L)
    {
    nk_rect_t r;
    nk_color_t color;
    float line_thickness;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    if(echeckrect(L, 2, &r)) return argerror(L, 2);
    line_thickness = luaL_checknumber(L, 3);
    if(echeckcolor(L, 4, &color)) return argerror(L, 4);
    nk_stroke_circle(canvas, r, line_thickness, color);
    return 0;
    }

static int Stroke_arc(lua_State *L)
    {
    nk_color_t color;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    float cx = luaL_checknumber(L, 2);
    float cy = luaL_checknumber(L, 3);
    float radius = luaL_checknumber(L, 4);
    float a_min = luaL_checknumber(L, 5);
    float a_max = luaL_checknumber(L, 6);
    float line_thickness = luaL_checknumber(L, 7);
    if(echeckcolor(L, 8, &color)) return argerror(L, 8);
    nk_stroke_arc(canvas, cx, cy, radius, a_min, a_max, line_thickness, color);
    return 0;
    }

static int Stroke_triangle(lua_State *L)
    {
    nk_color_t color;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    float x0 = luaL_checknumber(L, 2);
    float y0 = luaL_checknumber(L, 3);
    float x1 = luaL_checknumber(L, 4);
    float y1 = luaL_checknumber(L, 5);
    float x2 = luaL_checknumber(L, 6);
    float y2 = luaL_checknumber(L, 7);
    float line_thickness = luaL_checknumber(L, 8);
    if(echeckcolor(L, 9, &color)) return argerror(L, 9);
    nk_stroke_triangle(canvas, x0, y0, x1, y1, x2, y2, line_thickness, color);
    return 0;
    }

#define F(Func, func) /* void func(canvas, points, point_count, line_thickness, color) */\
static int Func(lua_State *L)                                   \
    {                                                           \
    int err, point_count;                                       \
    float line_thickness;                                       \
    nk_color_t color;                                           \
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);  \
    float *points = checkvec2list(L, 2, &point_count, &err);    \
    if(err) return argerrorc(L, 2, err);                        \
    line_thickness = luaL_checknumber(L, 3);                    \
    if(echeckcolor(L, 4, &color)) return argerror(L, 4);        \
    func(canvas, points, point_count, line_thickness, color);       \
    return 0;                                                   \
    }

F(Stroke_polyline, nk_stroke_polyline)
F(Stroke_polygon, nk_stroke_polygon)

#undef F

static int Fill_rect(lua_State *L)
    {
    nk_rect_t r;
    nk_color_t color;
    float rounding;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    if(echeckrect(L, 2, &r)) return argerror(L, 2);
    rounding = luaL_checknumber(L, 3);
    if(echeckcolor(L, 4, &color)) return argerror(L, 4);
    nk_fill_rect(canvas, r, rounding, color);
    return 0;
    }

static int Fill_rect_multi_color(lua_State *L)
    {
    nk_rect_t r;
    nk_color_t left, top, right, bottom;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    if(echeckrect(L, 2, &r)) return argerror(L, 2);
    if(echeckcolor(L, 3, &left)) return argerror(L, 3);
    if(echeckcolor(L, 4, &top)) return argerror(L, 4);
    if(echeckcolor(L, 5, &right)) return argerror(L, 5);
    if(echeckcolor(L, 6, &bottom)) return argerror(L, 6);
    (void)canvas;
    return 0;
    }

static int Fill_circle(lua_State *L)
    {
    nk_rect_t r;
    nk_color_t color;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    if(echeckrect(L, 2, &r)) return argerror(L, 2);
    if(echeckcolor(L, 3, &color)) return argerror(L, 3);
    nk_fill_circle(canvas, r, color);
    return 0;
    }

static int Fill_arc(lua_State *L)
    {
    nk_color_t color;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    float cx = luaL_checknumber(L, 2);
    float cy = luaL_checknumber(L, 3);
    float radius = luaL_checknumber(L, 4);
    float a_min = luaL_checknumber(L, 5);
    float a_max = luaL_checknumber(L, 6);
    if(echeckcolor(L, 7, &color)) return argerror(L, 7);
    nk_fill_arc(canvas, cx, cy, radius, a_min, a_max, color);
    return 0;
    }

static int Fill_triangle(lua_State *L)
    {
    nk_color_t color;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    float x0 = luaL_checknumber(L, 2);
    float y0 = luaL_checknumber(L, 3);
    float x1 = luaL_checknumber(L, 4);
    float y1 = luaL_checknumber(L, 5);
    float x2 = luaL_checknumber(L, 6);
    float y2 = luaL_checknumber(L, 7);
    if(echeckcolor(L, 8, &color)) return argerror(L, 8);
    nk_fill_triangle(canvas, x0, y0, x1, y1, x2, y2, color);
    return 0;
    }

static int Fill_polygon(lua_State *L)
    {
    int err, point_count;
    nk_color_t color;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    float *points = checkvec2list(L, 2, &point_count, &err);
    if(err) return argerrorc(L, 2, err);
    if(echeckcolor(L, 3, &color)) return argerror(L, 3);
    nk_fill_polygon(canvas, points, point_count, color);
    return 0;
    }

static int Draw_image(lua_State *L)
    {
    nk_rect_t r;
    nk_color_t color;
    nk_image_t *image;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    if(echeckrect(L, 2, &r)) return argerror(L, 2);
    image = checkimage(L, 3, NULL);
    if(echeckcolor(L, 4, &color)) return argerror(L, 4);
    nk_draw_image(canvas, r, image, color);
    return 0;
    }

static int Draw_nine_slice(lua_State *L)
    {
    nk_rect_t r;
    nk_color_t color;
    nk_nine_slice_t *nine_slice;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    if(echeckrect(L, 2, &r)) return argerror(L, 2);
    nine_slice = checknine_slice(L, 3, NULL);
    if(echeckcolor(L, 4, &color)) return argerror(L, 4);
    nk_draw_nine_slice(canvas, r, nine_slice, color);
    return 0;
    }


static int Draw_text(lua_State *L)
    {
    size_t len;
    nk_rect_t r;
    nk_color_t bg, fg;
    const char *s;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    nk_user_font_t *font = checkfont(L, 4, NULL);
    if(echeckrect(L, 2, &r)) return argerror(L, 2);
    s = luaL_checklstring(L, 3, &len);
    if(echeckcolor(L, 5, &bg)) return argerror(L, 5);
    if(echeckcolor(L, 6, &fg)) return argerror(L, 6);
    nk_draw_text(canvas, r, s, (int)len, font, bg, fg);
    return 0;
    }

static int Push_scissor(lua_State *L)
    {
    nk_rect_t r;
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    if(echeckrect(L, 2, &r)) return argerror(L, 2);
    nk_push_scissor(canvas, r);
    return 0;
    }

#if 0
// typedef void (*nk_command_custom_callback)(void *canvas, short x,short y, unsigned short w, unsigned short h, nk_handle callback_data);
//void nk_push_custom(canvas, nk_rect_t, nk_command_custom_callback, nk_handle usr);
static int Push_custom(lua_State *L) //@@
    {
    nk_canvas_t *canvas = checkcanvas(L, 1, NULL);
    (void)canvas;
    return 0;
    }
#endif

TYPE_FUNC(canvas)
DELETE_FUNC(canvas)

static const struct luaL_Reg Methods[] = 
    {
        { "type", Type },
        { "free",  Delete },
        { "stroke_line", Stroke_line },
        { "stroke_curve", Stroke_curve },
        { "stroke_rect", Stroke_rect },
        { "stroke_circle", Stroke_circle },
        { "stroke_arc", Stroke_arc },
        { "stroke_triangle", Stroke_triangle },
        { "stroke_polyline", Stroke_polyline },
        { "stroke_polygon", Stroke_polygon },
        { "fill_rect", Fill_rect },
        { "fill_rect_multi_color", Fill_rect_multi_color },
        { "fill_circle", Fill_circle },
        { "fill_arc", Fill_arc },
        { "fill_triangle", Fill_triangle },
        { "fill_polygon", Fill_polygon },
        { "draw_image", Draw_image },
        { "draw_nine_slice", Draw_nine_slice },
        { "draw_text", Draw_text },
        { "push_scissor", Push_scissor },
//      { "push_custom", Push_custom },

        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg MetaMethods[] = 
    {
        { "__gc",  Delete },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg Functions[] = 
    {
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_canvas(lua_State *L)
    {
    udata_define(L, CANVAS_MT, Methods, MetaMethods);
    luaL_setfuncs(L, Functions, 0);
    }

