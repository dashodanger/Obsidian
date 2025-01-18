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

#define ECHECK_PREAMBLE                                                         \
    memset(p, 0, sizeof(*p));                                                   \
    if(lua_isnoneornil(L, arg))                                                 \
        { lua_pushstring(L, errstring(ERR_NOTPRESENT)); return ERR_NOTPRESENT; }\
    if(lua_type(L, arg) != LUA_TTABLE)                                          \
        { lua_pushstring(L, errstring(ERR_TABLE)); return ERR_TABLE; }
        
#define POPERROR() lua_pop(L, 1)

#define PUSHFIELD(sname)    \
    do { lua_pushstring(L, sname); lua_rawget(L, arg); arg1 = lua_gettop(L); } while(0)

#define POPFIELD()          \
    do { lua_remove(L, arg1); } while(0)

#define GetFloatiOpt(name, i, defval) do {          \
    lua_rawgeti(L, arg, i);                         \
    err = 0;                                        \
    if(lua_isnumber(L, -1))                         \
        p->name = lua_tonumber(L, -1);              \
    else if(lua_isnoneornil(L, -1))                 \
        p->name = defval;                           \
    else                                            \
        err = ERR_TYPE;                             \
    lua_pop(L, 1);                                  \
    if(err)                                         \
        return fielderror(L, #i, err);              \
} while(0)


#define GetFloatOpt(name, sname, defval) do {       \
    lua_pushstring(L, sname);                       \
    lua_rawget(L, arg);                             \
    err = 0;                                        \
    if(lua_isnumber(L, -1))                         \
        p->name = lua_tonumber(L, -1);              \
    else if(lua_isnoneornil(L, -1))                 \
        p->name = defval;                           \
    else                                            \
        err = ERR_TYPE;                             \
    lua_pop(L, 1);                                  \
    if(err)                                         \
        return fielderror(L, sname, err);           \
} while(0)

#define GetFloati(name, i) GetFloatiOpt(name, i, 0)
#define GetFloat(name, sname) GetFloatOpt(name, sname, 0)

#define GetIntegeriOpt(name, i, defval) do {        \
    lua_rawgeti(L, arg, i);                         \
    err = 0;                                        \
    if(lua_isinteger(L, -1))                        \
        p->name = lua_tointeger(L, -1);             \
    else if(lua_isnoneornil(L, -1))                 \
        p->name = defval;                           \
    else                                            \
        err = ERR_TYPE;                             \
    lua_pop(L, 1);                                  \
    if(err)                                         \
        return fielderror(L, #i, err);              \
} while(0)


#define GetIntegerOpt(name, sname, defval) do {     \
    lua_pushstring(L, sname);                       \
    lua_rawget(L, arg);                             \
    err = 0;                                        \
    if(lua_isinteger(L, -1))                        \
        p->name = lua_tointeger(L, -1);             \
    else if(lua_isnoneornil(L, -1))                 \
        p->name = defval;                           \
    else                                            \
        err = ERR_TYPE;                             \
    lua_pop(L, 1);                                  \
    if(err)                                         \
        return fielderror(L, sname, err);           \
} while(0)

#define GetIntegeri(name, i) GetIntegeriOpt(name, i, 0)
#define GetInteger(name, sname) GetIntegerOpt(name, sname, 0)

#define GetEnum(name, sname, testfunc) do {         \
    lua_pushstring(L, sname);                       \
    lua_rawget(L, arg);                             \
    p->name = testfunc(L, -1, &err);                \
    lua_pop(L, 1);                                  \
    if(err)                                         \
        return fielderror(L, sname, err);           \
} while(0)

#define GetEnumi(name, i, testfunc) do {            \
    lua_rawgeti(L, arg, i);                         \
    p->name = testfunc(L, -1, &err);                \
    lua_pop(L, 1);                                  \
    if(err)                                         \
        return fielderror(L, #i, err);              \
} while(0)


#define GetObjectOpt(name, sname, ttt) do {         \
/* eg: nk_buffer -> ttt = buffer */                 \
    lua_pushstring(L, sname);                       \
    lua_rawget(L, arg);                             \
    err = 0;                                        \
    if(lua_isnoneornil(L, -1))                      \
        p->name = 0;                                \
    else                                            \
        {                                           \
        p->name = test##ttt(L, -1, NULL);           \
        if(!p->name) err = ERR_TYPE;                \
        }                                           \
    lua_pop(L, 1);                                  \
    if(err)                                         \
        return fielderror(L, sname, err);           \
} while(0)


static int fielderror(lua_State *L, const char *fieldname, int errcode)
    { 
    lua_pushfstring(L, "%s: %s", fieldname, errstring(errcode)); 
    return ERR_GENERIC; 
    }

static int prependfield(lua_State *L, const char *fieldname)
    { 
    lua_pushfstring(L, "%s.%s", fieldname, lua_tostring(L, -1));
    lua_remove(L, -2);
    return ERR_GENERIC; 
    }

#define SetFloat(name, sname) do { lua_pushnumber(L, p->name); lua_setfield(L, -2, sname); } while(0)
#define SetFloati(name, i) do { lua_pushnumber(L, p->name); lua_seti(L, -2, i); } while(0)
#define SetInteger(name, sname) do { lua_pushinteger(L, p->name); lua_setfield(L, -2, sname); } while(0)
#define SetIntegeri(name, i) do { lua_pushinteger(L, p->name); lua_seti(L, -2, i); } while(0)
#define SetEnum(name, sname, pushfunc) do { pushfunc(L, p->name); lua_setfield(L, -2, sname); } while(0)
#define SetVec2(name, sname) do { pushvec2(L, &(p->name)); lua_setfield(L, -2, sname); } while(0)
#define SetVec2i(name, sname) do { pushvec2i(L, &(p->name)); lua_setfield(L, -2, sname); } while(0)
#define SetRect(name, sname) do { pushrect(L, &(p->name)); lua_setfield(L, -2, sname); } while(0)
#define SetColor(name, sname) do { pushcolor(L, &(p->name)); lua_setfield(L, -2, sname); } while(0)

#define SetFloatArray(name, sname, n) do { int i_;                                      \
    lua_newtable(L);                                                                    \
    for(i_=0; i_<(n); i_++) { lua_pushnumber(L, p->name[i_]); lua_seti(L, -2, i_+1); }  \
    lua_setfield(L, -2, sname);                                                         \
} while(0)

#define SetVec2iArray(name, sname, n) do { int i_;                                      \
    lua_newtable(L);                                                                    \
    for(i_=0; i_<(n); i_++) { pushvec2i(L, &p->name[i_]); lua_seti(L, -2, i_+1); }      \
    lua_setfield(L, -2, sname);                                                         \
} while(0)


int echeckvec2(lua_State *L, int arg, nk_vec2_t *p)
    {
    int err;
    ECHECK_PREAMBLE;
    GetFloati(x, 1);
    GetFloati(y, 2);
    return ERR_SUCCESS;
    }

int pushvec2(lua_State *L, nk_vec2_t *p)
    {
    lua_newtable(L);
    SetFloati(x, 1);
    SetFloati(y, 2);
    return 1;
    }

int echeckvec2i(lua_State *L, int arg, nk_vec2i_t *p)
    {
    int err;
    ECHECK_PREAMBLE;
    GetIntegeri(x, 1);
    GetIntegeri(y, 2);
    return ERR_SUCCESS;
    }


int pushvec2i(lua_State *L, nk_vec2i_t *p)
    {
    lua_newtable(L);
    SetIntegeri(x, 1);
    SetIntegeri(y, 2);
    return 1;
    }

int echeckscroll(lua_State *L, int arg, nk_scroll_t *p)
    {
    int err;
    ECHECK_PREAMBLE;
    GetIntegeri(x, 1);
    GetIntegeri(y, 2);
    return ERR_SUCCESS;
    }


int pushscroll(lua_State *L, nk_scroll_t *p)
    {
    lua_newtable(L);
    SetIntegeri(x, 1);
    SetIntegeri(y, 2);
    return 1;
    }

int echeckrect(lua_State *L, int arg, nk_rect_t *p)
    {
    int err;
    ECHECK_PREAMBLE;
    GetFloati(x, 1);
    GetFloati(y, 2);
    GetFloati(w, 3);
    GetFloati(h, 4);
    return ERR_SUCCESS;
    }

int pushrect(lua_State *L, nk_rect_t *p)
    {
    lua_newtable(L);
    SetFloati(x, 1);
    SetFloati(y, 2);
    SetFloati(w, 3);
    SetFloati(h, 4);
    return 1;
    }

/* NOTE: to avoid confusion, in the MoonNuklear/script interface colors are always
 * represented arrays of 4 floats (normalized RGBA components).
 * The utilities defined below convert them to/from nk_color_t or nk_colorf_t, as
 * expected by the Nuklear API.
 */

int echeckcolor(lua_State *L, int arg, nk_color_t *p)
    {
    nk_colorf_t color; 
    int err = echeckcolorf(L, arg, &color);
    if(err) return err;
    *p = nk_rgba_cf(color);
    return ERR_SUCCESS;
    }

int pushcolor(lua_State *L, nk_color_t *p)
    { 
    nk_colorf_t color = nk_color_cf(*p); 
    return pushcolorf(L, &color); 
    }

int echeckcolorf(lua_State *L, int arg, nk_colorf_t *p)
    {
    int err;
    ECHECK_PREAMBLE;
    GetFloatiOpt(r, 1, 0.0f);
    GetFloatiOpt(g, 2, 0.0f);
    GetFloatiOpt(b, 3, 0.0f);
    GetFloatiOpt(a, 4, 1.0f);
    return ERR_SUCCESS;
    }

int pushcolorf(lua_State *L, nk_colorf_t *p)
    {
    lua_newtable(L);
    SetFloati(r, 1);
    SetFloati(g, 2);
    SetFloati(b, 3);
    SetFloati(a, 4);
    return 1;
    }

int echeckcolortable(lua_State *L, int arg, nk_color_t p[NK_COLOR_COUNT], nk_color_t defcolor)
    {
    int err, arg1;
    ECHECK_PREAMBLE;
#define GetColor(i, sname) do {                     \
    PUSHFIELD(sname);                               \
    err = echeckcolor(L, arg1, &(p[i]));            \
    POPFIELD();                                     \
    if(err)                                         \
        {                                           \
        if(err==ERR_NOTPRESENT)                     \
            { POPERROR(); p[i] = defcolor; }        \
        else                                        \
            return prependfield(L, sname);          \
        }                                           \
} while(0)
    GetColor(NK_COLOR_TEXT, "text");
    GetColor(NK_COLOR_WINDOW, "window");
    GetColor(NK_COLOR_HEADER, "header");
    GetColor(NK_COLOR_BORDER, "border");
    GetColor(NK_COLOR_BUTTON, "button");
    GetColor(NK_COLOR_BUTTON_HOVER, "button_hover");
    GetColor(NK_COLOR_BUTTON_ACTIVE, "button_active");
    GetColor(NK_COLOR_TOGGLE, "toggle");
    GetColor(NK_COLOR_TOGGLE_HOVER, "toggle_hover");
    GetColor(NK_COLOR_TOGGLE_CURSOR, "toggle_cursor");
    GetColor(NK_COLOR_SELECT, "select");
    GetColor(NK_COLOR_SELECT_ACTIVE, "select_active");
    GetColor(NK_COLOR_SLIDER, "slider");
    GetColor(NK_COLOR_SLIDER_CURSOR, "slider_cursor");
    GetColor(NK_COLOR_SLIDER_CURSOR_HOVER, "slider_cursor_hover");
    GetColor(NK_COLOR_SLIDER_CURSOR_ACTIVE, "slider_cursor_active");
    GetColor(NK_COLOR_PROPERTY, "property");
    GetColor(NK_COLOR_EDIT, "edit");
    GetColor(NK_COLOR_EDIT_CURSOR, "edit_cursor");
    GetColor(NK_COLOR_COMBO, "combo");
    GetColor(NK_COLOR_CHART, "chart");
    GetColor(NK_COLOR_CHART_COLOR, "chart_color");
    GetColor(NK_COLOR_CHART_COLOR_HIGHLIGHT, "chart_color_highlight");
    GetColor(NK_COLOR_SCROLLBAR, "scrollbar");
    GetColor(NK_COLOR_SCROLLBAR_CURSOR, "scrollbar_cursor");
    GetColor(NK_COLOR_SCROLLBAR_CURSOR_HOVER, "scrollbar_cursor_hover");
    GetColor(NK_COLOR_SCROLLBAR_CURSOR_ACTIVE, "scrollbar_cursor_active");
    GetColor(NK_COLOR_TAB_HEADER, "tab_header");
    return ERR_SUCCESS;
#undef GetColor
    }

int echeckkeytable(lua_State *L, int arg, int p[NK_KEY_MAX])
    {
    ECHECK_PREAMBLE;
#define GetKey(i, sname) do {                       \
    lua_pushstring(L, sname); lua_rawget(L, arg);   \
    p[i] = optboolean(L, -1, 0);                    \
    lua_pop(L, 1);                                  \
} while(0)
    GetKey(NK_KEY_NONE, "none");
    GetKey(NK_KEY_SHIFT, "shift");
    GetKey(NK_KEY_CTRL, "ctrl");
    GetKey(NK_KEY_DEL, "del");
    GetKey(NK_KEY_ENTER, "enter");
    GetKey(NK_KEY_TAB, "tab");
    GetKey(NK_KEY_BACKSPACE, "backspace");
    GetKey(NK_KEY_COPY, "copy");
    GetKey(NK_KEY_CUT, "cut");
    GetKey(NK_KEY_PASTE, "paste");
    GetKey(NK_KEY_UP, "up");
    GetKey(NK_KEY_DOWN, "down");
    GetKey(NK_KEY_LEFT, "left");
    GetKey(NK_KEY_RIGHT, "right");
    GetKey(NK_KEY_TEXT_INSERT_MODE, "text_insert_mode");
    GetKey(NK_KEY_TEXT_REPLACE_MODE, "text_replace_mode");
    GetKey(NK_KEY_TEXT_RESET_MODE, "text_reset_mode");
    GetKey(NK_KEY_TEXT_LINE_START, "text_line_start");
    GetKey(NK_KEY_TEXT_LINE_END, "text_line_end");
    GetKey(NK_KEY_TEXT_START, "text_start");
    GetKey(NK_KEY_TEXT_END, "text_end");
    GetKey(NK_KEY_TEXT_UNDO, "text_undo");
    GetKey(NK_KEY_TEXT_REDO, "text_redo");
    GetKey(NK_KEY_TEXT_SELECT_ALL, "text_select_all");
    GetKey(NK_KEY_TEXT_WORD_LEFT, "text_word_left");
    GetKey(NK_KEY_TEXT_WORD_RIGHT, "text_word_right");
    GetKey(NK_KEY_SCROLL_START, "scroll_start");
    GetKey(NK_KEY_SCROLL_END, "scroll_end");
    GetKey(NK_KEY_SCROLL_DOWN, "scroll_down");
    GetKey(NK_KEY_SCROLL_UP, "scroll_up");
#undef GetKey
    return ERR_SUCCESS;
    }


int pushmemorystatus(lua_State *L, nk_memory_status_t *p)
    {
    lua_newtable(L);
//  SetEnum(type, "type", pushbufferallocationtype);
    SetInteger(size, "size");
    SetInteger(allocated, "allocated");
    SetInteger(needed, "needed");
    SetInteger(calls, "calls");
    lua_pushlightuserdata(L, p->memory);
    lua_setfield(L, -2, "ptr");
    return 1;
    }

int echeckdrawvertexlayoutelement(lua_State *L, int arg, nk_draw_vertex_layout_element_t *p)
    {
    int err;
    ECHECK_PREAMBLE;
    GetEnumi(attribute, 1, testdrawvertexlayoutattribute);
    GetEnumi(format, 2, testdrawvertexlayoutformat);
    GetIntegeriOpt(offset, 3, 0);
    return ERR_SUCCESS;
    }

int pushstyleitem(lua_State *L, nk_style_item_t *p)
    {
    if(p->type == NK_STYLE_ITEM_IMAGE)
        pushimage(L, &p->data.image);
    else if(p->type == NK_STYLE_ITEM_NINE_SLICE)
        pushnine_slice(L, &p->data.image);
    else if(p->type == NK_STYLE_ITEM_COLOR)
        {
        if(p->data.color.r == 0 && p->data.color.b == 0 
                && p->data.color.g == 0 && p->data.color.a == 0)
            lua_pushstring(L, "hide");
        else
            pushcolor(L, &p->data.color);
        }
    else
        return unexpected(L);
    return 1;
    }

nk_style_item_t checkstyleitem(lua_State *L, int arg)
    {
    nk_color_t color;
    nk_image_t *image;
    nk_nine_slice_t *nine_slice;
    if(lua_isstring(L, arg))
        {
        if(strcmp(lua_tostring(L, arg), "hide") == 0)
            return nk_style_item_hide();
        }
    else if((image = testimage(L, arg, NULL)) != NULL)
        return nk_style_item_image(*image);
    else if((nine_slice = testnine_slice(L, arg, NULL)) != NULL)
        return nk_style_item_nine_slice(*nine_slice);
    else
        {
        if(echeckcolor(L, arg, &color)==ERR_SUCCESS)
            return nk_style_item_color(color);
        }
    argerrorc(L, arg, ERR_VALUE);
    return nk_style_item_hide(); /* not reached */
    }

int pushfontglyph(lua_State *L, const nk_font_glyph_t *p)
    {
    lua_newtable(L);
    SetInteger(codepoint, "codepoint");
    SetFloat(xadvance, "xadvance");
    SetFloat(x0, "x0");
    SetFloat(y0, "y0");
    SetFloat(x1, "x1");
    SetFloat(y1, "y1");
    SetFloat(w, "w");
    SetFloat(h, "h");
    SetFloat(u0, "u0");
    SetFloat(v0, "v0");
    SetFloat(u1, "u1");
    SetFloat(v1, "v1");
    return 1;
    }

nk_plugin_filter testpluginfilter(lua_State *L, int arg)
    {
    int err;
    int what = testfilter(L, arg, &err);
    if(err == ERR_NOTPRESENT)
        return nk_filter_default;
    if(err > 0)
        { argerrorc(L, arg, err); return NULL; }
    switch(what)
        {
        case MOONNUKLEAR_FILTER_DEFAULT: return nk_filter_default;
        case MOONNUKLEAR_FILTER_ASCII: return nk_filter_ascii;
        case MOONNUKLEAR_FILTER_FLOAT: return nk_filter_float;
        case MOONNUKLEAR_FILTER_DECIMAL: return nk_filter_decimal;
        case MOONNUKLEAR_FILTER_HEX: return nk_filter_hex;
        case MOONNUKLEAR_FILTER_OCT: return nk_filter_oct;
        case MOONNUKLEAR_FILTER_BINARY: return nk_filter_binary;
        default: unexpected(L); break;
        }
    return NULL;
    }

nk_font_config_t *echeckfontconfig(lua_State *L, int arg, float height, int *err)
    {
    int count;
    nk_font_config_t *p;
    if(lua_isnoneornil(L, arg))
        { *err = ERR_NOTPRESENT; lua_pushstring(L, errstring(ERR_NOTPRESENT)); return NULL; }
    if(lua_type(L, arg) != LUA_TTABLE)
        { *err = ERR_TABLE; lua_pushstring(L, errstring(ERR_TABLE)); return NULL; }
    if((p = (nk_font_config_t*)MallocNoErr(L, sizeof(nk_font_config_t))) == NULL)
        { *err = ERR_MEMORY; lua_pushstring(L, errstring(ERR_MEMORY)); return NULL; }

    p->size = height;

    lua_pushstring(L, "merge_mode"); lua_rawget(L, arg); 
    p->merge_mode = optboolean(L, -1, 0); //@@ DOC
    lua_pop(L, 1);

    lua_pushstring(L, "pixel_snap"); lua_rawget(L, arg); 
    p->pixel_snap = optboolean(L, -1, 0); //@@ DOC
    lua_pop(L, 1);

    lua_pushstring(L, "coord_type"); lua_rawget(L, arg); 
    p->coord_type = testfontcoordtype(L, -1, err);
    lua_pop(L, 1);
    if(*err == ERR_NOTPRESENT)
        p->coord_type = NK_COORD_UV;
    else if(*err)
        { lua_pushstring(L, errstring(*err)); return NULL; }
    
    lua_pushstring(L, "spacing"); lua_rawget(L, arg); 
    *err = echeckvec2(L, -1, &p->spacing);
    lua_pop(L, 1);
    if(*err == ERR_NOTPRESENT)
        p->spacing = nk_vec2(0, 0);
    else if(*err)
        { lua_pushstring(L, errstring(*err)); return NULL; }

    lua_pushstring(L, "oversample_v"); lua_rawget(L, arg); 
    p->oversample_v = luaL_optinteger(L, -1, 1);
    lua_pop(L, 1);

    lua_pushstring(L, "oversample_h"); lua_rawget(L, arg);
    p->oversample_h = luaL_optinteger(L, -1, 3);
    lua_pop(L, 1);

    lua_pushstring(L, "fallback_glyph"); lua_rawget(L, arg);
    p->fallback_glyph = luaL_optinteger(L, -1, '?');
    lua_pop(L, 1);

    lua_pushstring(L, "ranges"); lua_rawget(L, arg);
    if(lua_isnil(L, -1))
        { lua_pop(L, 1); pushrunelist(L, nk_font_default_glyph_ranges()); }
    p->range = checkrunelist(L, -1, &count, err);
    lua_pop(L, 1);
    if(*err)
        { Free(L, p); lua_pushstring(L, errstring(*err)); return NULL; }

    *err = ERR_SUCCESS;
    return p;
    }

void freefontconfig(lua_State *L, nk_font_config_t *p)
    {
    if(p->range) freerunelist(L, (nk_rune*)p->range);
    Free(L, p);
    }



/*-----------------------------------------------------------------------------
 | Commands
 *----------------------------------------------------------------------------*/

static int command_scissor(lua_State *L, nk_command_t *pp)
    {
    nk_command_scissor_t *p = (nk_command_scissor_t*)pp;
    SetInteger(x, "x");
    SetInteger(y, "y");
    SetInteger(w, "w");
    SetInteger(h, "h");
    return 1;
    }

static int command_line(lua_State *L, nk_command_t *pp)
    {
    nk_command_line_t *p = (nk_command_line_t*)pp;
    SetInteger(line_thickness, "line_thickness");
    SetVec2i(begin, "start");
    SetVec2i(end, "stop");
    SetColor(color, "color");
    return 1;
    }

static int command_curve(lua_State *L, nk_command_t *pp)
    {
    nk_command_curve_t *p = (nk_command_curve_t*)pp;
    SetInteger(line_thickness, "line_thickness");
    SetVec2i(begin, "start");
    SetVec2i(end, "stop");
    SetVec2iArray(ctrl, "ctrl", 2);
    SetColor(color, "color");
    return 1;
    }

static int command_rect(lua_State *L, nk_command_t *pp)
    {
    nk_command_rect_t *p = (nk_command_rect_t*)pp;
    SetInteger(rounding, "rounding");
    SetInteger(line_thickness, "line_thickness");
    SetInteger(x, "x");
    SetInteger(y, "y");
    SetInteger(w, "w");
    SetInteger(h, "h");
    SetColor(color, "color");
    return 1;
    }

static int command_rect_filled(lua_State *L, nk_command_t *pp)
    {
    nk_command_rect_filled_t *p = (nk_command_rect_filled_t*)pp;
    SetInteger(rounding, "rounding");
    SetInteger(x, "x");
    SetInteger(y, "y");
    SetInteger(w, "w");
    SetInteger(h, "h");
    SetColor(color, "color");
    return 1;
    }

static int command_rect_multi_color(lua_State *L, nk_command_t *pp)
    {
    nk_command_rect_multi_color_t *p = (nk_command_rect_multi_color_t*)pp;
    SetInteger(x, "x");
    SetInteger(y, "y");
    SetInteger(w, "w");
    SetInteger(h, "h");
    SetColor(left, "left");
    SetColor(top, "top");
    SetColor(bottom, "bottom");
    SetColor(right, "right");
    return 1;
    }

static int command_triangle(lua_State *L, nk_command_t *pp)
    {
    nk_command_triangle_t *p = (nk_command_triangle_t*)pp;
    SetInteger(line_thickness, "line_thickness");
    SetVec2i(a, "a");
    SetVec2i(b, "b");
    SetVec2i(c, "c");
    SetColor(color, "color");
    return 1;
    }

static int command_triangle_filled(lua_State *L, nk_command_t *pp)
    {
    nk_command_triangle_filled_t *p = (nk_command_triangle_filled_t*)pp;
    SetVec2i(a, "a");
    SetVec2i(b, "b");
    SetVec2i(c, "c");
    SetColor(color, "color");
    return 1;
    }

static int command_circle(lua_State *L, nk_command_t *pp)
    {
    nk_command_circle_t *p = (nk_command_circle_t*)pp;
    SetInteger(line_thickness, "line_thickness");
    SetInteger(x, "x");
    SetInteger(y, "y");
    SetInteger(w, "w");
    SetInteger(h, "h");
    SetColor(color, "color");
    return 1;
    }

static int command_circle_filled(lua_State *L, nk_command_t *pp)
    {
    nk_command_circle_filled_t *p = (nk_command_circle_filled_t*)pp;
    SetInteger(x, "x");
    SetInteger(y, "y");
    SetInteger(w, "w");
    SetInteger(h, "h");
    SetColor(color, "color");
    return 1;
    }

static int command_arc(lua_State *L, nk_command_t *pp)
    {
    nk_command_arc_t *p = (nk_command_arc_t*)pp;
    SetInteger(line_thickness, "line_thickness");
    SetInteger(cx, "cx");
    SetInteger(cy, "cy");
    SetInteger(r, "r");
    SetFloatArray(a, "a", 2);
    SetColor(color, "color");
    return 1;
    }

static int command_arc_filled(lua_State *L, nk_command_t *pp)
    {
    nk_command_arc_filled_t *p = (nk_command_arc_filled_t*)pp;
    SetInteger(cx, "cx");
    SetInteger(cy, "cy");
    SetInteger(r, "r");
    SetFloatArray(a, "a", 2);
    SetColor(color, "color");
    return 1;
    }

static int command_polygon(lua_State *L, nk_command_t *pp)
    {
    nk_command_polygon_t *p = (nk_command_polygon_t*)pp;
    SetInteger(line_thickness, "line_thickness");
    SetVec2iArray(points, "points", p->point_count);
    SetColor(color, "color");
    return 1;
    }

static int command_polygon_filled(lua_State *L, nk_command_t *pp)
    {
    nk_command_polygon_filled_t *p = (nk_command_polygon_filled_t*)pp;
    SetVec2iArray(points, "points", p->point_count);
    SetColor(color, "color");
    return 1;
    }

static int command_polyline(lua_State *L, nk_command_t *pp)
    {
    nk_command_polyline_t *p = (nk_command_polyline_t*)pp;
    SetInteger(line_thickness, "line_thickness");
    SetVec2iArray(points, "points", p->point_count);
    SetColor(color, "color");
    return 1;
    }

static int command_image(lua_State *L, nk_command_t *pp)
    {
    nk_command_image_t *p = (nk_command_image_t*)pp;
    pushimage(L, &p->img); lua_setfield(L, -2, "image");
    SetInteger(x, "x");
    SetInteger(y, "y");
    SetInteger(w, "w");
    SetInteger(h, "h");
    SetColor(col, "color");
    return 1;
    }

static int command_text(lua_State *L, nk_command_t *pp)
    {
    nk_command_text_t *p = (nk_command_text_t*)pp;
    pushfont(L, (nk_user_font_t*)(p->font)); lua_setfield(L, -2, "font");
    SetInteger(x, "x");
    SetInteger(y, "y");
    SetInteger(w, "w");
    SetInteger(h, "h");
    SetColor(background, "background");
    SetColor(foreground, "foreground");
    lua_pushlstring(L, p->string, p->length); lua_setfield(L, -2, "text");
    return 1;
    }

#if 0
static int command_custom(lua_State *L, nk_command_t *pp) //@@
    {
    (void)pp;
    return unexpected(L);
//  nk_command_custom_t *p = (nk_command_custom_t*)pp;
//  return 1;
    }

/* command base and header of every command inside the buffer */
struct nk_command {
    enum nk_command_type type;
    nk_size next;
#ifdef NK_INCLUDE_COMMAND_USERDATA
    nk_handle userdata;
#endif
};

typedef void (*nk_command_custom_callback)(void *canvas, short x,short y,
    unsigned short w, unsigned short h, nk_handle callback_data);
struct nk_command_custom_t {
    struct nk_command header;
    short x, y;
    unsigned short w, h;
    nk_handle callback_data;
    nk_command_custom_callback callback;
};
#endif

int pushcommand(lua_State *L, nk_command_t *p)
    {
    lua_newtable(L);
    SetEnum(type, "type", pushcommandtype);
    switch(p->type)
        {
        case NK_COMMAND_NOP: return 1;
        case NK_COMMAND_SCISSOR: return command_scissor(L, p);
        case NK_COMMAND_LINE: return command_line(L, p);
        case NK_COMMAND_CURVE: return command_curve(L, p);
        case NK_COMMAND_RECT: return command_rect(L, p);
        case NK_COMMAND_RECT_FILLED: return command_rect_filled(L, p);
        case NK_COMMAND_RECT_MULTI_COLOR: return command_rect_multi_color(L, p);
        case NK_COMMAND_TRIANGLE: return command_triangle(L, p);
        case NK_COMMAND_TRIANGLE_FILLED: return command_triangle_filled(L, p);
        case NK_COMMAND_CIRCLE: return command_circle(L, p);
        case NK_COMMAND_CIRCLE_FILLED: return command_circle_filled(L, p);
        case NK_COMMAND_ARC: return command_arc(L, p);
        case NK_COMMAND_ARC_FILLED: return command_arc_filled(L, p);
        case NK_COMMAND_POLYGON: return command_polygon(L, p);
        case NK_COMMAND_POLYGON_FILLED: return command_polygon_filled(L, p);
        case NK_COMMAND_POLYLINE: return command_polyline(L, p);
        case NK_COMMAND_TEXT: return command_text(L, p);
        case NK_COMMAND_IMAGE: return command_image(L, p);
//      case NK_COMMAND_CUSTOM: return command_custom(L, p);
        default: break;
        }
    return unexpected(L);
    }


int pushdrawcommand(lua_State *L, nk_draw_command_t *p)
    {
    lua_newtable(L);
    SetInteger(elem_count, "elem_count");
    SetRect(clip_rect, "clip_rect");
    //pushhandle(L, &p->texture); lua_setfield(L, -2, "texture");
    lua_pushinteger(L, p->texture.id); lua_setfield(L, -2, "texture_id");
    return 1;
    }

