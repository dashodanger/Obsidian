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

/* userdata for callbacks */
typedef struct { 
    int ref; /* reference of the Lua callback function on the Lua registry */
    char *item;
} cbinfo_t;

#define VOID_CONTEXT(Func, func) /* void func(context) */\
static int Func(lua_State *L)                           \
    {                                                   \
    nk_context_t *context = checkcontext(L, 1, NULL);   \
    func(context);                                      \
    return 0;                                           \
    }

/*-----------------------------------------------------------------------------
 | WIDGET
 *----------------------------------------------------------------------------*/

static int Widget(lua_State *L)
/* widget(context, bounds, [padding]) */
    {
    nk_rect_t bounds;
    nk_vec2_t padding;
    nk_flags state;
    nk_context_t *context = checkcontext(L, 1, NULL);
    if(echeckrect(L, 2, &bounds)) return argerror(L, 2);
    if(lua_isnoneornil(L, 3))
        state = nk_widget(&bounds, context);
    else
        {
        if(echeckvec2(L, 3, &padding)) return argerror(L, 3);
        state = nk_widget_fitting(&bounds, context, padding);
        }
    pushflags(L, state); /* widgetlayoutstates */
    pushrect(L, &bounds);
    return 2;
    }

static int Widget_bounds(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_rect_t bounds = nk_widget_bounds(context);
    return pushrect(L, &bounds);
    }

static int Widget_position(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_vec2_t v = nk_widget_position(context);
    return pushvec2(L, &v);
    }

static int Widget_size(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_vec2_t v = nk_widget_size(context);
    return pushvec2(L, &v);
    }

static int Widget_width(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    lua_pushnumber(L, nk_widget_width(context));
    return 1;
    }

static int Widget_height(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    lua_pushnumber(L, nk_widget_height(context));
    return 1;
    }

static int Widget_is_hovered(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    lua_pushboolean(L, nk_widget_is_hovered(context));
    return 1;
    }

static int Widget_is_mouse_clicked(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_buttons button = checkbuttons(L, 2);
    lua_pushboolean(L, nk_widget_is_mouse_clicked(context, button));
    return 1;
    }

static int Widget_has_mouse_click_down(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_buttons button = checkbuttons(L, 2);
    int down = checkboolean(L, 3);
    lua_pushboolean(L, nk_widget_has_mouse_click_down(context, button, down));
    return 1;
    }

static int Spacing(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    int cols = luaL_checkinteger(L, 2);
    nk_spacing(context, cols);
    return 0;
    }


static int WidgetDisableBegin(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_widget_disable_begin(context);
    return 0;
    }

static int WidgetDisableEnd(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_widget_disable_end(context);
    return 0;
    }

/*-----------------------------------------------------------------------------
 | BUTTON
 *----------------------------------------------------------------------------*/

static int Button(lua_State *L)
    {
    int rc;
    size_t len;
    const char *title;
    nk_color_t color;
    nk_flags alignment;
    enum nk_symbol_type symbol;
    nk_image_t *image;
#if 0 //@@ for styled buttons, use nk.style_push/nk.style_pop instead
    //const nk_style_button_t *style:
    //rc = nk_button_text_styled(context, style, title, len);
    //rc = nk_button_image_styled(context, style, *image);
    //rc = nk_button_image_text_styled(context, style, *image, title, len, alignment);
    //rc = nk_button_symbol_styled(context, style, symbol);
    //rc = nk_button_symbol_text_styled(context, style, symbol, title, len, alignment);
#endif
    nk_context_t *context = checkcontext(L, 1, NULL);
    int arg_type = lua_type(L, 2);
    if(arg_type == LUA_TNIL)
        {
        title = luaL_checklstring(L, 3, &len);
        rc = nk_button_text(context, title, len);
        }
    else if(arg_type == LUA_TTABLE)
        {
        if(echeckcolor(L, 2, &color)) return argerror(L, 2);
        rc = nk_button_color(context, color);
        }
    else if((image = testimage(L, 2, NULL)) != NULL)
        {
        if(lua_isnoneornil(L, 3))
            rc = nk_button_image(context, *image);
        else
            {
            title = luaL_checklstring(L, 3, &len);
            alignment = checkflags(L, 4); /* textalign */
            rc = nk_button_image_text(context, *image, title, len, alignment);
            }
        }
    else
        {
        symbol = checksymboltype(L, 2);
        if(lua_isnoneornil(L, 3))
            rc = nk_button_symbol(context, symbol);
        else
            {
            title = luaL_checklstring(L, 3, &len);
            alignment = checkflags(L, 4); /* textalign */
            rc = nk_button_symbol_text(context, symbol, title, len, alignment);
            }
        }
    lua_pushboolean(L, rc);
    return 1;
    }


static int Button_set_behavior(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_button_behavior behavior = checkbuttonbehavior(L, 2);
    nk_button_set_behavior(context, behavior);
    return 0;
    }

static int Button_push_behavior(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_button_behavior behavior = checkbuttonbehavior(L, 2);
    lua_pushboolean(L, nk_button_push_behavior(context, behavior));
    return 1;
    }

static int Button_pop_behavior(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    lua_pushboolean(L, nk_button_pop_behavior(context));
    return 1;
    }

/*-----------------------------------------------------------------------------
 | CHART
 *----------------------------------------------------------------------------*/

static int Chart_begin(lua_State *L)
    {
    int rc;
    nk_color_t color, highlight;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_chart_type chart_type = checkcharttype(L, 2);
    int count = luaL_checkinteger(L, 3);
    float min = luaL_checknumber(L, 4);
    float max = luaL_checknumber(L, 5);
    if(lua_isnoneornil(L, 6))
        rc = nk_chart_begin(context, chart_type, count, min, max);
    else
        {
        if(echeckcolor(L, 6, &color)) return argerror(L, 6);
        if(echeckcolor(L, 7, &highlight)) return argerror(L, 7);
        rc = nk_chart_begin_colored(context, chart_type, color, highlight, count, min, max);
        }
    lua_pushboolean(L, rc);
    return 1;
    }

static int Chart_add_slot(lua_State *L)
    {
    nk_color_t color, highlight;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_chart_type chart_type = checkcharttype(L, 2);
    int count = luaL_checkinteger(L, 3);
    float min = luaL_checknumber(L, 4);
    float max = luaL_checknumber(L, 5);
    if(lua_isnoneornil(L, 6))
        nk_chart_add_slot(context, chart_type, count, min, max);
    else
        {
        if(echeckcolor(L, 6, &color)) return argerror(L, 6);
        if(echeckcolor(L, 7, &highlight)) return argerror(L, 7);
        nk_chart_add_slot_colored(context, chart_type, color, highlight, count, min, max);
        }
    return 0;
    }

static int Chart_push(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float value = luaL_checknumber(L, 2);
    int slot = optindex(L, 3, 0);
    pushflags(L, nk_chart_push_slot(context, value, slot)); /* charteventflags */
    return 1;
    }

VOID_CONTEXT(Chart_end, nk_chart_end)

static int Plot(lua_State *L)
    {
    int nvalues, err;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_chart_type chart_type = checkcharttype(L, 2);
    int count = luaL_checkinteger(L, 4);
    int offset = luaL_checkinteger(L, 5);
    float *values = checkfloatlist(L, 3, &nvalues, &err);
    if(err) return argerrorc(L, 3, err);
    /* plots values[offset] to values[offset+count-1] */
    if(offset < 0 || (offset+count) > nvalues)
        {
        freefloatlist(L, values, count);
        return argerrorc(L, 4, ERR_BOUNDARIES);
        }
    nk_plot(context, chart_type, values, count, offset);
    freefloatlist(L, values, count);
    return 0;
    }

static float ValueGetter(void* info_, int index)
    {
#define info ((cbinfo_t*)(info_))
#define L moonnuklear_L
    float val;
    lua_rawgeti(L, LUA_REGISTRYINDEX, info->ref);
    pushindex(L, index);
    if(lua_pcall(L, 1, 1, 0) != LUA_OK)
        { lua_error(L); return 0; }
    val = luaL_checknumber(L, -1);
    lua_pop(L, 1);
    return val;
#undef L
#undef info
    }

static int Plot_function(lua_State *L)
    {
    cbinfo_t info;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_chart_type chart_type = checkcharttype(L, 2);
    int count = luaL_checkinteger(L, 4);
    int offset = luaL_checkinteger(L, 5);
    if(!lua_isfunction(L, 3))
        return argerrorc(L, 3, ERR_TYPE);
    lua_pushvalue(L, 3);
    info.ref = luaL_ref(L, LUA_REGISTRYINDEX);
    nk_plot_function(context, chart_type, &info, ValueGetter, count, offset);
    luaL_unref(L, LUA_REGISTRYINDEX, info.ref);
    return 0;
    }

/*-----------------------------------------------------------------------------
 | CHECKBOX
 *----------------------------------------------------------------------------*/

static int Check(lua_State *L)
    {
    size_t len;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 2, &len);
    int active = checkboolean(L, 3);
    lua_pushboolean(L, nk_check_text(context, s, (int)len, active));
    return 1;
    }

static int Check_align(lua_State *L)
    {
    size_t len;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 2, &len);
    int active = checkboolean(L, 3);
    unsigned int widgetalignflags = luaL_checkinteger(L, 4);
    unsigned int textalignflags = luaL_checkinteger(L, 5);
    lua_pushboolean(L, nk_check_text_align(context, s, (int)len, active, widgetalignflags, textalignflags));
    return 1;
    }

static int Check_flags(lua_State *L)
    {
    size_t len;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 2, &len);
    unsigned int flags = luaL_checkinteger(L, 3);
    unsigned int value = luaL_checkinteger(L, 4);
    lua_pushinteger(L, nk_check_flags_text(context, s, len, flags, value));
    return 1;
    }

static int Checkbox(lua_State *L)
    {
    size_t len;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 2, &len);
    int active = checkboolean(L, 3);
    nk_checkbox_text(context, s, len, &active);
    lua_pushboolean(L, active);
    return 1;
    }

static int Checkbox_align(lua_State *L)
    {
    size_t len;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 2, &len);
    int active = checkboolean(L, 3);
    unsigned int widgetalignflags = luaL_checkinteger(L, 4);
    unsigned int textalignflags = luaL_checkinteger(L, 5);
    nk_checkbox_text_align(context, s, len, &active, widgetalignflags, textalignflags);
    lua_pushboolean(L, active);
    return 1;
    }

static int Checkbox_flags(lua_State *L)
    {
    size_t len;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 2, &len);
    unsigned int flags = luaL_checkinteger(L, 3);
    unsigned int value = luaL_checkinteger(L, 4);
    nk_checkbox_flags_text(context, s, len, &flags, value);
    lua_pushinteger(L, flags);
    return 1;
    }

/*-----------------------------------------------------------------------------
 | COLOR PICKER
 *----------------------------------------------------------------------------*/

static int Color_picker(lua_State *L)
    {
    nk_colorf_t color;
    enum nk_color_format fmt;
    nk_context_t *context = checkcontext(L, 1, NULL);
    if(echeckcolorf(L, 2, &color)) return argerror(L, 2);
    fmt = checkcolorformat(L, 3);
    color = nk_color_picker(context, color, fmt);
    return pushcolorf(L, &color);
    }

/*-----------------------------------------------------------------------------
 | COMBOBOX
 *----------------------------------------------------------------------------*/

static int Combo(lua_State *L)
    {
    nk_vec2_t size;
    char **items;
    int count, err;
    nk_context_t *context = checkcontext(L, 1, NULL);
    int selected = luaL_checkinteger(L, 3);
    int item_height = luaL_checkinteger(L, 4);
    if(echeckvec2(L, 5, &size)) return argerror(L, 5);
    items = checkstringlist(L, 2, &count, &err);
    if(err) return argerrorc(L, 2, err);
    if(selected < 1 || selected > count)
        { freestringlist(L, items, count); return argerrorc(L, 3, ERR_RANGE); }
    selected = nk_combo(context, (const char**)items, count, selected - 1, item_height, size) + 1;
    //int nk_combo_separator(struct nk_context *ctx, const char *items_separated_by_separator,
    //    int separator, int selected, int count, int item_height, struct nk_vec2 size)
    freestringlist(L, items, count);
    lua_pushinteger(L, selected);
    return 1;
    }


static void ItemGetter(void* info_, int selected, const char** item)
    {
#define info ((cbinfo_t*)(info_))
#define L moonnuklear_L
    const char *s;
    lua_rawgeti(L, LUA_REGISTRYINDEX, info->ref);
    lua_pushinteger(L, selected+1);
    if(lua_pcall(L, 1, 1, 0) != LUA_OK)
        { lua_error(L); return; }
    if(info->item) Free(L, info->item);
    s = luaL_checkstring(L, -1);
    info->item = Strdup(L, s);
    *item = info->item;
    lua_pop(L, 1);
    return;
#undef L
#undef info
    }

static int Combo_callback(lua_State *L)
    {
    cbinfo_t info;
    nk_vec2_t size;
    nk_context_t *context = checkcontext(L, 1, NULL);
    int selected = luaL_checkinteger(L, 3);
    int count = luaL_checkinteger(L, 4);
    int item_height = luaL_checkinteger(L, 5);
    if(echeckvec2(L, 6, &size)) return argerror(L, 6);
    if(!lua_isfunction(L, 2))
        return argerrorc(L, 2, ERR_TYPE);
    lua_pushvalue(L, 2);
    info.ref = luaL_ref(L, LUA_REGISTRYINDEX);
    info.item = NULL;
    selected = nk_combo_callback(context, ItemGetter, &info, selected-1, count, item_height, size);
    if(info.item) Free(L, info.item);
    luaL_unref(L, LUA_REGISTRYINDEX, info.ref);
    lua_pushinteger(L, selected+1);
    return 1;
    }

/*-----------------------------------------------------------------------------
 | ABSTRACT COMBOBOX
 *----------------------------------------------------------------------------*/

static int Combo_begin(lua_State *L)
    {
    int rc, arg_type;
    size_t len;
    const char *s;
    nk_vec2_t size;
    nk_color_t color;
    enum nk_symbol_type symbol;
    nk_image_t *image;
    nk_context_t *context = checkcontext(L, 1, NULL);
    if(echeckvec2(L, 4, &size)) return argerror(L, 4);
    arg_type = lua_type(L, 2);
    if(arg_type == LUA_TNIL)
        {
        s = luaL_checklstring(L, 3, &len);
        rc = nk_combo_begin_text(context, s, (int)len, size);
        }
    else if(arg_type == LUA_TTABLE)
        {
        if(echeckcolor(L, 2, &color)) return argerror(L, 2);
        rc = nk_combo_begin_color(context, color, size);
        }
    else 
        {
        s = luaL_optlstring(L, 3, NULL, &len);
        if((image = testimage(L, 2, NULL)) != NULL)
            {
            rc = s ? nk_combo_begin_image_text(context, s, len, *image, size)
                   : nk_combo_begin_image(context, *image,  size);
            }
        else
            {
            symbol = checksymboltype(L, 2);
            rc = s ? nk_combo_begin_symbol_text(context, s, len, symbol, size)
                   : nk_combo_begin_symbol(context,  symbol,  size);
            }
        }
    lua_pushboolean(L, rc);
    return 1;
    }

static int Combo_item(lua_State *L)
    {
    int rc;
    size_t len;
    enum nk_symbol_type symbol;
    nk_image_t *image;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *s = luaL_checklstring(L, 3, &len);
    nk_flags alignment = checkflags(L, 4); /* textalign */
    int arg_type = lua_type(L, 2);
    if(arg_type == LUA_TNIL)
        rc = nk_combo_item_text(context, s, len, alignment);
    else if((image = testimage(L, 2, NULL)) != NULL)
        rc = nk_combo_item_image_text(context, *image, s, len, alignment);
    else
        {
        symbol = checksymboltype(L, 2);
        rc = nk_combo_item_symbol_text(context, symbol, s, len, alignment);
        }
    lua_pushboolean(L, rc);
    return 1;
    }

VOID_CONTEXT(Combo_close, nk_combo_close)
VOID_CONTEXT(Combo_end, nk_combo_end)

/*-----------------------------------------------------------------------------
 | CONTEXTUAL
 *----------------------------------------------------------------------------*/

static int Contextual_begin(lua_State *L)
    {
    nk_vec2_t size;
    nk_rect_t trigger_bounds;
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_flags flags = checkflags(L, 2); /* panelflags */
    if(echeckvec2(L, 3, &size)) return argerror(L, 3);
    if(echeckrect(L, 4, &trigger_bounds)) return argerror(L, 4);
    lua_pushboolean(L, nk_contextual_begin(context, flags, size, trigger_bounds));
    return 1;
    }

static int Contextual_item(lua_State *L)
    {
    int rc;
    size_t len;
    enum nk_symbol_type symbol;
    nk_image_t *image;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *s = luaL_checklstring(L, 3, &len);
    nk_flags alignment = checkflags(L, 4); /* textalign */
    if(lua_isnoneornil(L, 2))
        rc = nk_contextual_item_text(context, s, len, alignment);
    else if((image = testimage(L, 2, NULL)) != NULL)
        rc = nk_contextual_item_image_text(context, *image, s, len, alignment);
    else
        {
        symbol = checksymboltype(L, 2);
        rc = nk_contextual_item_symbol_text(context, symbol, s, len, alignment);
        }
    lua_pushboolean(L, rc);
    return 1;
    }

VOID_CONTEXT(Contextual_close, nk_contextual_close)
VOID_CONTEXT(Contextual_end, nk_contextual_end)

/*-----------------------------------------------------------------------------
 | IMAGE
 *----------------------------------------------------------------------------*/

static int Image(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_image_t *image = checkimage(L, 2, NULL);
    nk_image(context, *image);
    return 0;
    }

/*-----------------------------------------------------------------------------
 | LABEL/TEXT
 *----------------------------------------------------------------------------*/

static int Label(lua_State *L)
    {
    size_t len;
    nk_color_t color;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 2, &len);
    nk_flags alignment = checkflags(L, 3); /* textalign */
    if(lua_isnoneornil(L, 4))
        nk_text(context, s, len, alignment);
    else
        {
        if(echeckcolor(L, 4, &color)) return argerror(L, 4);
        nk_text_colored(context, s, len, alignment, color);
        }
    return 0;
    }

static int Label_wrap(lua_State *L)
    {
    size_t len;
    nk_color_t color;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 2, &len);
    if(lua_isnoneornil(L, 3))
        nk_text_wrap(context, s, len);
    else
        {
        if(echeckcolor(L, 3, &color)) return argerror(L, 3);
        nk_text_wrap_colored(context, s, len, color);
        }
    return 0;
    }

/*-----------------------------------------------------------------------------
 | MENU/MENUBAR
 *----------------------------------------------------------------------------*/

VOID_CONTEXT(Menubar_begin, nk_menubar_begin)
VOID_CONTEXT(Menubar_end, nk_menubar_end)

static int Menu_begin(lua_State *L)
    {
    int rc;
    size_t len;
    nk_vec2_t size;
    enum nk_symbol_type symbol;
    nk_image_t *image;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *s = luaL_checklstring(L, 3, &len);
    nk_flags alignment = checkflags(L, 4); /* textalign */
    if(echeckvec2(L, 5, &size)) return argerror(L, 5);
    if(lua_isnoneornil(L, 2))
        rc = nk_menu_begin_text(context, s, len, alignment, size);
    else if((image = testimage(L, 2, NULL)) != NULL)
        rc = nk_menu_begin_image_text(context, s, len, alignment, *image, size);
    else
        {
        symbol = checksymboltype(L, 2);
        rc = nk_menu_begin_symbol_text(context, s, len, alignment, symbol, size);
        }
    lua_pushboolean(L, rc);
    return 1;
    }


static int Menu_item(lua_State *L)
    {
    int rc;
    size_t len;
    enum nk_symbol_type symbol;
    nk_image_t *image;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *s = luaL_checklstring(L, 3, &len);
    nk_flags alignment = checkflags(L, 4); /* textalign */
    if(lua_isnoneornil(L, 2))
        rc = nk_menu_item_text(context, s, len, alignment);
    else if((image = testimage(L, 2, NULL)) != NULL)
        rc = nk_menu_item_image_text(context, *image, s, len, alignment);
    else
        {
        symbol = checksymboltype(L, 2);
        rc = nk_menu_item_symbol_text(context, symbol, s, len, alignment);
        }
    lua_pushboolean(L, rc);
    return 1;
    }

VOID_CONTEXT(Menu_close, nk_menu_close)
VOID_CONTEXT(Menu_end, nk_menu_end)

/*-----------------------------------------------------------------------------
 | OPTION / RADIO BUTTON
 *----------------------------------------------------------------------------*/

static int Option(lua_State *L)
    {
    size_t len;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 2, &len);
    int active = checkboolean(L, 3);
    int changed = nk_radio_text(context, s, len, &active);
    lua_pushboolean(L, active);
    lua_pushboolean(L, changed);
    return 2;
    }

static int Option_align(lua_State *L)
    {
    size_t len;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 2, &len);
    int active = checkboolean(L, 3);
    unsigned int widgetalignflags = luaL_checkinteger(L, 4);
    unsigned int textalignflags = luaL_checkinteger(L, 5);
    int changed = nk_radio_text_align(context, s, len, &active, widgetalignflags, textalignflags);
    lua_pushboolean(L, active);
    lua_pushboolean(L, changed);
    return 2;
    }

/*-----------------------------------------------------------------------------
 | POPUP
 *----------------------------------------------------------------------------*/

static int Popup_begin(lua_State *L)
    {
    nk_rect_t bounds;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_popup_type popup_type = checkpopuptype(L,2);
    const char *s = luaL_checkstring(L, 3);
    nk_flags flags = checkflags(L, 4); /* nk_window_flags */
    if(echeckrect(L, 5, &bounds)) return argerror(L, 5);
    lua_pushboolean(L, nk_popup_begin(context, popup_type, s, flags, bounds));
    return 1;
    }

VOID_CONTEXT(Popup_close, nk_popup_close)
VOID_CONTEXT(Popup_end, nk_popup_end)

static int Popup_get_scroll(lua_State *L)
    {
    nk_uint offset_x, offset_y;
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_popup_get_scroll(context, &offset_x, &offset_y);
    lua_pushinteger(L, offset_x);
    lua_pushinteger(L, offset_y);
    return 2;
    }

static int Popup_set_scroll(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_uint offset_x = luaL_checkinteger(L, 2);
    nk_uint offset_y = luaL_checkinteger(L, 3);
    nk_popup_set_scroll(context, offset_x, offset_y);
    return 0;
    }


/*-----------------------------------------------------------------------------
 | PROPERTY  
 *----------------------------------------------------------------------------*/

static int Property(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *text = luaL_checkstring(L, 2);
    double min = luaL_checknumber(L, 3);
    double val = luaL_checknumber(L, 4);
    double max = luaL_checknumber(L, 5);
    double step = luaL_checknumber(L, 6);
    float inc_per_pixel = luaL_checknumber(L, 7);
    nk_property_double(context, text, min, &val, max, step, inc_per_pixel);
    lua_pushnumber(L, val);
    return 1;
    }

/*-----------------------------------------------------------------------------
 | PROGRESSBAR
 *----------------------------------------------------------------------------*/

static int Progress(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_size cur = luaL_checkinteger(L, 2);
    nk_size max = luaL_checkinteger(L, 3);
    enum nk_modify modifyable = checkmodify(L, 4);
    lua_pushinteger(L, nk_prog(context, cur, max, (int)modifyable));
    return 1;
    }

/*-----------------------------------------------------------------------------
 | RULE_HORIZONTAL
 *----------------------------------------------------------------------------*/

static int Rule_horizontal(lua_State *L)
    {
    nk_color_t color;
    nk_context_t *context = checkcontext(L, 1, NULL);
    int rounding = checkboolean(L, 3);
    if(echeckcolor(L, 2, &color)) return argerror(L, 2);
    nk_rule_horizontal(context, color, rounding);
    return 0;
    }

/*-----------------------------------------------------------------------------
 | SELECTABLE
 *----------------------------------------------------------------------------*/

static int Selectable(lua_State *L)
    {
    size_t len;
    int changed;
    enum nk_symbol_type symbol;
    nk_image_t *image;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 3, &len);
    nk_flags alignment = checkflags(L, 4); /* textalign */
    int value = checkboolean(L, 5);
    int arg_type = lua_type(L, 2);
    if(arg_type == LUA_TNIL)
        changed = nk_selectable_text(context, s, len, alignment, &value);
    else if((image = testimage(L, 2, NULL)) != NULL)
        changed = nk_selectable_image_text(context, *image, s, len, alignment, &value);
    else
        {
        symbol = checksymboltype(L, 2);
        changed = nk_selectable_symbol_text(context, symbol, s, len, alignment, &value);
        }
    lua_pushboolean(L, value);
    lua_pushboolean(L, changed);
    return 2;
    }

/*-----------------------------------------------------------------------------
 | SLIDER
 *----------------------------------------------------------------------------*/

static int Slider(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float min = luaL_checknumber(L, 2);
    float val = luaL_checknumber(L, 3);
    float max = luaL_checknumber(L, 4);
    float step = luaL_checknumber(L, 5);
    nk_slider_float(context, min, &val, max, step);
    lua_pushnumber(L, val);
    return 1;
    }

/*-----------------------------------------------------------------------------
 | SPACER
 *----------------------------------------------------------------------------*/

static int Spacer(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_spacer(context);
    return 0;
    }


/*-----------------------------------------------------------------------------
 | TOOLTIP
 *----------------------------------------------------------------------------*/

static int Tooltip(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *s = luaL_checkstring(L, 2);
    nk_tooltip(context, s);
    return 0;
    }

static int Tooltip_begin(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    float width = luaL_checknumber(L, 2);
    lua_pushboolean(L, nk_tooltip_begin(context, width));
    return 1;
    }

VOID_CONTEXT(Tooltip_end, nk_tooltip_end)

/*-----------------------------------------------------------------------------
 | TREE
 *----------------------------------------------------------------------------*/

static int Tree_push(lua_State *L)
/* tree_push(context, type, title, state, hash, [image] */
    {
    int rc;
    size_t len;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_tree_type tree_type = checktreetype(L, 2);
    const char *title = luaL_checkstring(L, 3);
    enum nk_collapse_states init_state = checkcollapsestates(L, 4);
    const char *hash = luaL_checklstring(L, 5, &len);
    int seed = __LINE__; //* always the same... is it important? @@
    nk_image_t *image = testimage(L, 6, NULL);
    if(image)
        rc = nk_tree_image_push_hashed(context, tree_type, *image, title, init_state, hash, (int)len, seed);
    else
        rc = nk_tree_push_hashed(context, tree_type, title, init_state, hash, (int)len, seed);
    lua_pushboolean(L, rc);
    return 1;
    }


VOID_CONTEXT(Tree_pop, nk_tree_pop)

static int Tree_element_push(lua_State *L)
/* tree_element_push(context, type, title, state, selected, hash, [image] */
    {
    int rc;
    size_t len;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_tree_type tree_type = checktreetype(L, 2);
    const char *title = luaL_checkstring(L, 3);
    enum nk_collapse_states init_state = checkcollapsestates(L, 4);
    int selected = checkboolean(L, 5);
    const char *hash = luaL_checklstring(L, 6, &len);
    int seed = __LINE__; //* always the same... is it important? @@
    nk_image_t *image = testimage(L, 7, NULL);
    if(image)
        rc = nk_tree_element_image_push_hashed(context, tree_type, *image, title, init_state, &selected, hash, (int)len, seed);
    else
        rc = nk_tree_element_push_hashed(context, tree_type, title, init_state, &selected, hash, (int)len, seed);
    lua_pushboolean(L, rc);
    lua_pushboolean(L, selected);
    return 2;
    }

VOID_CONTEXT(Tree_element_pop, nk_tree_element_pop)


static int Tree_state_push(lua_State *L)
    {
    int rc;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_tree_type tree_type = checktreetype(L, 2);
    const char *title = luaL_checkstring(L, 3);
    enum nk_collapse_states state = checkcollapsestates(L, 4);
    rc = nk_tree_state_push(context, tree_type, title, &state);
    lua_pushboolean(L, rc);
    pushcollapsestates(L, state);
    return 2;
    }

static int Tree_state_image_push(lua_State *L)
    {
    int rc;
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_tree_type tree_type = checktreetype(L, 2);
    nk_image_t *image = checkimage(L, 3, NULL);
    const char *title = luaL_checkstring(L, 4);
    enum nk_collapse_states state = checkcollapsestates(L, 5);
    rc = nk_tree_state_image_push(context, tree_type, *image, title, &state);
    lua_pushboolean(L, rc);
    pushcollapsestates(L, state);
    return 2;
    }

VOID_CONTEXT(Tree_state_pop, nk_tree_state_pop)

#if 0
/*-----------------------------------------------------------------------------
 | Value          
 *----------------------------------------------------------------------------*/

static int Value_bool(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *prefix = luaL_checkstring(L, 2);
    int val = checkboolean(L, 3);
    nk_value_bool(context, prefix, val);
    return 0;
    }

static int Value_int(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *prefix = luaL_checkstring(L, 2);
    int val = luaL_checkinteger(L, 3);
    nk_value_int(context, prefix, val);
    return 0;
    }

static int Value_uint(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *prefix = luaL_checkstring(L, 2);
    unsigned int val = luaL_checkinteger(L, 3);
    nk_value_uint(context, prefix, val);
    return 0;
    }

static int Value_float(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char *prefix = luaL_checkstring(L, 2);
    float val = luaL_checknumber(L, 3);
    nk_value_float(context, prefix, val);
    return 0;
    }

#define F(Func, func) /* void func(context, string, color) */ \
static int Func(lua_State *L)                               \
    {                                                       \
    nk_color_t color;                                       \
    nk_context_t *context = checkcontext(L, 1, NULL);       \
    const char *s = luaL_checkstring(L, 2);                 \
    if(echeckcolor(L, 3, &color)) return argerror(L, 3);    \
    func(context, s, color);                                \
    return 0;                                               \
    }
F(Value_color_byte, nk_value_color_byte)
F(Value_color_float, nk_value_color_float)
F(Value_color_hex, nk_value_color_hex)

#undef F

#endif

/*-----------------------------------------------------------------------------
 | Color utilities
 *----------------------------------------------------------------------------*/

static int Color_from_bytes(lua_State *L)
/* converts a RGBA-0-255 color to a normalized float color */
    {
    nk_color_t color;
    color.r = luaL_checkinteger(L, 1);
    color.g = luaL_checkinteger(L, 2);
    color.b = luaL_checkinteger(L, 3);
    color.a = luaL_optinteger(L, 4, 255);
    return pushcolor(L, &color);
    }

static int Color_bytes(lua_State *L)
    {
    nk_color_t colorb;
    nk_colorf_t color;
    if(echeckcolorf(L, 1, &color)) return argerror(L, 1);
    colorb = nk_rgba_cf(color);
    lua_pushinteger(L, colorb.r);
    lua_pushinteger(L, colorb.g);
    lua_pushinteger(L, colorb.b);
    lua_pushinteger(L, colorb.a);
    return 4;
    }

static int Rgba_to_hsva(lua_State *L)
    {
    float h, s, v, a;
    nk_colorf_t color;
    if(echeckcolorf(L, 1, &color)) return argerror(L, 1);
    nk_colorf_hsva_f(&h, &s, &v, &a, color);
    color.r = h;
    color.g = s;
    color.b = v;
    color.a = a;
    return pushcolorf(L, &color);
    }

static int Hsva_to_rgba(lua_State *L)
    {
    nk_colorf_t color;
    if(echeckcolorf(L, 1, &color)) return argerror(L, 1);
    color = nk_hsva_colorf(color.r, color.g, color.b, color.a);
    return pushcolorf(L, &color);
    }


static const struct luaL_Reg Functions[] = 
    {
        { "widget", Widget },
        { "widget_bounds", Widget_bounds },
        { "widget_position", Widget_position },
        { "widget_size", Widget_size },
        { "widget_width", Widget_width },
        { "widget_height", Widget_height },
        { "widget_is_hovered", Widget_is_hovered },
        { "widget_is_mouse_clicked", Widget_is_mouse_clicked },
        { "widget_has_mouse_click_down", Widget_has_mouse_click_down },
        { "spacing", Spacing },
        { "widget_disable_begin", WidgetDisableBegin },
        { "widget_disable_end", WidgetDisableEnd },
        { "button", Button },
        { "button_set_behavior", Button_set_behavior },
        { "button_push_behavior", Button_push_behavior },
        { "button_pop_behavior", Button_pop_behavior },
        { "chart_begin", Chart_begin },
        { "chart_add_slot", Chart_add_slot },
        { "chart_push", Chart_push },
        { "chart_end", Chart_end },
        { "plot", Plot },
        { "plot_function", Plot_function },
        { "check", Check },
        { "check_flags", Check_flags },
        { "check_align", Check_align },
        { "checkbox", Checkbox },
        { "checkbox_flags", Checkbox_flags },
        { "checkbox_align", Checkbox_align },
        { "color_picker", Color_picker },
        { "combo", Combo },
        { "combo_callback", Combo_callback },
        { "combo_begin", Combo_begin },
        { "combo_item", Combo_item },
        { "combo_close", Combo_close },
        { "combo_end", Combo_end },
        { "contextual_begin", Contextual_begin },
        { "contextual_item", Contextual_item },
        { "contextual_close", Contextual_close },
        { "contextual_end", Contextual_end },
        { "edit_string", edit_string },
//@@    { "edit_buffer", edit_buffer },
        { "edit_focus", edit_focus },
        { "edit_unfocus", edit_unfocus },
        { "image", Image },
        { "label", Label },
        { "label_wrap", Label_wrap },
        { "menu_begin", Menu_begin },
        { "menu_item", Menu_item },
        { "menu_close", Menu_close },
        { "menu_end", Menu_end },
        { "menubar_begin", Menubar_begin },
        { "menubar_end", Menubar_end },
        { "popup_begin", Popup_begin },
        { "popup_close", Popup_close },
        { "popup_end", Popup_end },
        { "popup_get_scroll", Popup_get_scroll },
        { "popup_set_scroll", Popup_set_scroll },
        { "property", Property },
        { "progress", Progress },
        { "option", Option },
        { "option_align", Option_align },
        { "rule_horizontal", Rule_horizontal },
        { "selectable", Selectable },
        { "slider", Slider},
        { "spacer", Spacer },
        { "tooltip", Tooltip },
        { "tooltip_begin", Tooltip_begin },
        { "tooltip_end", Tooltip_end },
        { "tree_push", Tree_push },
        { "tree_pop", Tree_pop },
        { "tree_element_push", Tree_element_push },
        { "tree_element_pop", Tree_element_pop },
        { "tree_state_push", Tree_state_push },
        { "tree_state_image_push", Tree_state_image_push },
        { "tree_state_pop", Tree_state_pop },
#if 0 // use label with formatting instead
        { "value_bool", Value_bool },
        { "value_int", Value_int },
        { "value_uint", Value_uint },
        { "value_float", Value_float },
        { "value_color_byte", Value_color_byte },
        { "value_color_float", Value_color_float },
        { "value_color_hex", Value_color_hex },
#endif
        { "color_from_bytes", Color_from_bytes },
        { "color_bytes", Color_bytes },
        { "rgba_to_hsva", Rgba_to_hsva },
        { "hsva_to_rgba", Hsva_to_rgba },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_widgets(lua_State *L)
    {
    luaL_setfuncs(L, Functions, 0);
    }
