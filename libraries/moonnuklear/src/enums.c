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
#include "style.h"

/*------------------------------------------------------------------------------*
 | Code<->string map for enumerations                                           |
 *------------------------------------------------------------------------------*/


/* code <-> string record */
#define rec_t struct rec_s
struct rec_s {
    RB_ENTRY(rec_s) CodeEntry;
    RB_ENTRY(rec_s) StringEntry;
    uint32_t domain;
    uint32_t code;  /* (domain, code) = search key in code tree */
    char     *str;  /* (domain, str) = search key in string tree */
};

/* compare functions */
static int cmp_code(rec_t *rec1, rec_t *rec2) 
    { 
    if(rec1->domain != rec2->domain)
        return (rec1->domain < rec2->domain ? -1 : rec1->domain > rec2->domain);
    return (rec1->code < rec2->code ? -1 : rec1->code > rec2->code);
    } 

static int cmp_str(rec_t *rec1, rec_t *rec2) 
    { 
    if(rec1->domain != rec2->domain)
        return (rec1->domain < rec2->domain ? -1 : rec1->domain > rec2->domain);
    return strcmp(rec1->str, rec2->str);
    } 

static RB_HEAD(CodeTree, rec_s) CodeHead = RB_INITIALIZER(&CodeHead);
RB_PROTOTYPE_STATIC(CodeTree, rec_s, CodeEntry, cmp_code) 
RB_GENERATE_STATIC(CodeTree, rec_s, CodeEntry, cmp_code) 

static RB_HEAD(StringTree, rec_s) StringHead = RB_INITIALIZER(&StringHead);
RB_PROTOTYPE_STATIC(StringTree, rec_s, StringEntry, cmp_str) 
RB_GENERATE_STATIC(StringTree, rec_s, StringEntry, cmp_str) 
 
static rec_t *code_remove(rec_t *rec) 
    { return RB_REMOVE(CodeTree, &CodeHead, rec); }
static rec_t *code_insert(rec_t *rec) 
    { return RB_INSERT(CodeTree, &CodeHead, rec); }
static rec_t *code_search(uint32_t domain, uint32_t code) 
    { rec_t tmp; tmp.domain = domain; tmp.code = code; return RB_FIND(CodeTree, &CodeHead, &tmp); }
static rec_t *code_first(uint32_t domain, uint32_t code) 
    { rec_t tmp; tmp.domain = domain; tmp.code = code; return RB_NFIND(CodeTree, &CodeHead, &tmp); }
static rec_t *code_next(rec_t *rec)
    { return RB_NEXT(CodeTree, &CodeHead, rec); }
#if 0
static rec_t *code_prev(rec_t *rec)
    { return RB_PREV(CodeTree, &CodeHead, rec); }
static rec_t *code_min(void)
    { return RB_MIN(CodeTree, &CodeHead); }
static rec_t *code_max(void)
    { return RB_MAX(CodeTree, &CodeHead); }
static rec_t *code_root(void)
    { return RB_ROOT(&CodeHead); }
#endif
 
static rec_t *str_remove(rec_t *rec) 
    { return RB_REMOVE(StringTree, &StringHead, rec); }
static rec_t *str_insert(rec_t *rec) 
    { return RB_INSERT(StringTree, &StringHead, rec); }
static rec_t *str_search(uint32_t domain, const char* str) 
    { rec_t tmp; tmp.domain = domain; tmp.str = (char*)str; return RB_FIND(StringTree, &StringHead, &tmp); }
#if 0
static rec_t *str_first(uint32_t domain, const char* str ) 
    { rec_t tmp; tmp.domain = domain; tmp.str = str; return RB_NFIND(StringTree, &StringHead, &tmp); }
static rec_t *str_next(rec_t *rec)
    { return RB_NEXT(StringTree, &StringHead, rec); }
static rec_t *str_prev(rec_t *rec)
    { return RB_PREV(StringTree, &StringHead, rec); }
static rec_t *str_min(void)
    { return RB_MIN(StringTree, &StringHead); }
static rec_t *str_max(void)
    { return RB_MAX(StringTree, &StringHead); }
static rec_t *str_root(void)
    { return RB_ROOT(&StringHead); }
#endif


static int enums_new(lua_State *L, uint32_t domain, uint32_t code, const char *str)
    {
    rec_t *rec;
    if((rec = (rec_t*)Malloc(L, sizeof(rec_t))) == NULL) 
        return luaL_error(L, errstring(ERR_MEMORY));

    memset(rec, 0, sizeof(rec_t));
    rec->domain = domain;
    rec->code = code;
    rec->str = Strdup(L, str);
    if(code_search(domain, code) || str_search(domain, str))
        { 
        Free(L, rec->str);
        Free(L, rec); 
        return unexpected(L); /* duplicate value */
        }
    code_insert(rec);
    str_insert(rec);
    return 0;
    }

static void enums_free(lua_State *L, rec_t* rec)
    {
    if(code_search(rec->domain, rec->code) == rec)
        code_remove(rec);
    if(str_search(rec->domain, rec->str) == rec)
        str_remove(rec);
    Free(L, rec->str);
    Free(L, rec);   
    }

void enums_free_all(lua_State *L)
    {
    rec_t *rec;
    while((rec = code_first(0, 0)))
        enums_free(L, rec);
    }

#if 0
uint32_t enums_code(uint32_t domain, const char *str, int* found)
    {
    rec_t *rec = str_search(domain, str);
    if(!rec)
        { *found = 0; return 0; }
    *found = 1; 
    return rec->code;
    }

const char* enums_string(uint32_t domain, uint32_t code)
    {
    rec_t *rec = code_search(domain, code);
    if(!rec)
        return NULL;
    return rec->str;
    }

#endif


uint32_t enums_test(lua_State *L, uint32_t domain, int arg, int *err)
    {
    rec_t *rec;
    const char *s = luaL_optstring(L, arg, NULL);

    if(!s)
        { *err = ERR_NOTPRESENT; return 0; }

    rec = str_search(domain, s);
    if(!rec)
        { *err = ERR_VALUE; return 0; }
    
    *err = ERR_SUCCESS;
    return rec->code;
    }

uint32_t enums_check(lua_State *L, uint32_t domain, int arg)
    {
    rec_t *rec;
    const char *s = luaL_checkstring(L, arg);

    rec = str_search(domain, s);
    if(!rec)
        return luaL_argerror(L, arg, badvalue(L, s));
    
    return rec->code;
    }

int enums_push(lua_State *L, uint32_t domain, uint32_t code)
    {
    rec_t *rec = code_search(domain, code);

    if(!rec)
        return unexpected(L);

    lua_pushstring(L, rec->str);
    return 1;
    }

int enums_values(lua_State *L, uint32_t domain)
    {
    int i;
    rec_t *rec;

    lua_newtable(L);
    i = 1;
    rec = code_first(domain, 0);
    while(rec)
        {
        if(rec->domain == domain)
            {
            lua_pushstring(L, rec->str);
            lua_rawseti(L, -2, i++);
            }
        rec = code_next(rec);
        }

    return 1;
    }


uint32_t* enums_checklist(lua_State *L, uint32_t domain, int arg, uint32_t *count, int *err)
    {
    uint32_t* list;
    uint32_t i;

    *count = 0;
    *err = 0;
    if(lua_isnoneornil(L, arg))
        { *err = ERR_NOTPRESENT; return NULL; }
    if(lua_type(L, arg) != LUA_TTABLE)
        { *err = ERR_TABLE; return NULL; }

    *count = luaL_len(L, arg);
    if(*count == 0)
        { *err = ERR_NOTPRESENT; return NULL; }

    list = (uint32_t*)MallocNoErr(L, sizeof(uint32_t) * (*count));
    if(!list)
        { *count = 0; *err = ERR_MEMORY; return NULL; }

    for(i=0; i<*count; i++)
        {
        lua_rawgeti(L, arg, i+1);
        list[i] = enums_test(L, domain, -1, err);
        lua_pop(L, 1);
        if(*err)
            { Free(L, list); *count = 0; return NULL; }
        }
    return list;
    }

void enums_freelist(lua_State *L, uint32_t *list)
    {
    if(!list)
        return;
    Free(L, list);
    }

/*------------------------------------------------------------------------------*
 |                                                                              |
 *------------------------------------------------------------------------------*/

static int Enum(lua_State *L)
/* { strings } = nk.enum('type') lists all the values for a given enum type */
    { 
    const char *s = luaL_checkstring(L, 1); 
#define CASE(xxx) if(strcmp(s, ""#xxx) == 0) return values##xxx(L)
    CASE(heading);
    CASE(keys);
    CASE(buttons);
    CASE(collapsestates);
    CASE(showstates);
    CASE(layoutformat);
    CASE(modify);
    CASE(buttonbehavior);
    CASE(orientation);
    CASE(charttype);
    CASE(colorformat);
    CASE(popuptype);
    CASE(treetype);
    CASE(symboltype);
//  CASE(stylecolors);
    CASE(stylecursor);
    CASE(fontcoordtype);
    CASE(fontatlasformat);
    CASE(allocationtype);
    CASE(bufferallocationtype);
    CASE(textedittype);
    CASE(texteditmode);
    CASE(commandtype);
    CASE(drawliststroke);
    CASE(drawvertexlayoutattribute);
    CASE(drawvertexlayoutformat);
    CASE(styleitemtype);
    CASE(panelrowlayouttype);
    CASE(stylefield);
    CASE(filter);
#undef CASE
    return 0;
    }

static const struct luaL_Reg Functions[] = 
    {
        { "enum", Enum },
        { NULL, NULL } /* sentinel */
    };


void moonnuklear_open_enums(lua_State *L)
    {
    uint32_t domain;

    luaL_setfuncs(L, Functions, 0);

#define ADD(what, s) do {                               \
    lua_pushstring(L, s); lua_setfield(L, -2, #what);   \
    enums_new(L, domain, NK_##what, s);                 \
} while(0)

    domain = DOMAIN_HEADING; /* nk_heading */
    ADD(UP, "up");
    ADD(RIGHT, "right");
    ADD(DOWN, "down");
    ADD(LEFT, "left");

    domain = DOMAIN_KEYS; /* nk_keys */
    ADD(KEY_NONE, "none");
    ADD(KEY_SHIFT, "shift");
    ADD(KEY_CTRL, "ctrl");
    ADD(KEY_DEL, "del");
    ADD(KEY_ENTER, "enter");
    ADD(KEY_TAB, "tab");
    ADD(KEY_BACKSPACE, "backspace");
    ADD(KEY_COPY, "copy");
    ADD(KEY_CUT, "cut");
    ADD(KEY_PASTE, "paste");
    ADD(KEY_UP, "up");
    ADD(KEY_DOWN, "down");
    ADD(KEY_LEFT, "left");
    ADD(KEY_RIGHT, "right");
    ADD(KEY_TEXT_INSERT_MODE, "text insert mode");
    ADD(KEY_TEXT_REPLACE_MODE, "text replace mode");
    ADD(KEY_TEXT_RESET_MODE, "text reset mode");
    ADD(KEY_TEXT_LINE_START, "text line start");
    ADD(KEY_TEXT_LINE_END, "text line end");
    ADD(KEY_TEXT_START, "text start");
    ADD(KEY_TEXT_END, "text end");
    ADD(KEY_TEXT_UNDO, "text undo");
    ADD(KEY_TEXT_REDO, "text redo");
    ADD(KEY_TEXT_SELECT_ALL, "text select all");
    ADD(KEY_TEXT_WORD_LEFT, "text word left");
    ADD(KEY_TEXT_WORD_RIGHT, "text word right");
    ADD(KEY_SCROLL_START, "scroll start");
    ADD(KEY_SCROLL_END, "scroll end");
    ADD(KEY_SCROLL_DOWN, "scroll down");
    ADD(KEY_SCROLL_UP, "scroll up");
//  ADD(KEY_MAX, "max");

    domain = DOMAIN_BUTTONS; /* nk_buttons */
    ADD(BUTTON_LEFT, "left");
    ADD(BUTTON_MIDDLE, "middle");
    ADD(BUTTON_RIGHT, "right");
    ADD(BUTTON_DOUBLE, "double");
//  ADD(BUTTON_MAX, "max");

    domain = DOMAIN_COLLAPSE_STATES; /* nk_collapse_states */
    ADD(MINIMIZED, "minimized");
    ADD(MAXIMIZED, "maximized");

    domain = DOMAIN_SHOW_STATES; /* nk_show_states */
    ADD(HIDDEN, "hidden");
    ADD(SHOWN, "shown");

    domain = DOMAIN_LAYOUT_FORMAT; /* nk_layout_format */
    ADD(DYNAMIC, "dynamic");
    ADD(STATIC, "static");

    domain = DOMAIN_MODIFY; /* nk_modify */
    ADD(FIXED, "fixed");
    ADD(MODIFIABLE, "modifiable");

    domain = DOMAIN_BUTTON_BEHAVIOR; /* nk_button_behavior */
    ADD(BUTTON_DEFAULT, "default");
    ADD(BUTTON_REPEATER, "repeater");

    domain = DOMAIN_ORIENTATION; /* nk_orientation */
    ADD(VERTICAL, "vertical");
    ADD(HORIZONTAL, "horizontal");

    domain = DOMAIN_CHART_TYPE; /* nk_chart_type */
    ADD(CHART_LINES, "lines");
    ADD(CHART_COLUMN, "column");
//  ADD(CHART_MAX, "max");

    domain = DOMAIN_COLOR_FORMAT; /* nk_color_format */
    ADD(RGB, "rgb");
    ADD(RGBA, "rgba");

    domain = DOMAIN_POPUP_TYPE; /* nk_popup_type */
    ADD(POPUP_STATIC, "static");
    ADD(POPUP_DYNAMIC, "dynamic");

    domain = DOMAIN_TREE_TYPE; /* nk_tree_type */
    ADD(TREE_NODE, "node");
    ADD(TREE_TAB, "tab");

    domain = DOMAIN_SYMBOL_TYPE; /* nk_symbol_type */
    ADD(SYMBOL_NONE, "none");
    ADD(SYMBOL_X, "x");
    ADD(SYMBOL_UNDERSCORE, "underscore");
    ADD(SYMBOL_CIRCLE_SOLID, "circle solid");
    ADD(SYMBOL_CIRCLE_OUTLINE, "circle outline");
    ADD(SYMBOL_RECT_SOLID, "rect solid");
    ADD(SYMBOL_RECT_OUTLINE, "rect outline");
    ADD(SYMBOL_TRIANGLE_UP, "triangle up");
    ADD(SYMBOL_TRIANGLE_DOWN, "triangle down");
    ADD(SYMBOL_TRIANGLE_LEFT, "triangle left");
    ADD(SYMBOL_TRIANGLE_RIGHT, "triangle right");
    ADD(SYMBOL_PLUS, "plus");
    ADD(SYMBOL_MINUS, "minus");
//  ADD(SYMBOL_MAX, "max");

#if 0 // see echeckcolortable() instead
    domain = DOMAIN_STYLE_COLORS; /* nk_style_colors */
    ADD(COLOR_TEXT, "text");
    ADD(COLOR_WINDOW, "window");
    ADD(COLOR_HEADER, "header");
    ADD(COLOR_BORDER, "border");
    ADD(COLOR_BUTTON, "button");
    ADD(COLOR_BUTTON_HOVER, "button hover");
    ADD(COLOR_BUTTON_ACTIVE, "button active");
    ADD(COLOR_TOGGLE, "toggle");
    ADD(COLOR_TOGGLE_HOVER, "toggle hover");
    ADD(COLOR_TOGGLE_CURSOR, "toggle cursor");
    ADD(COLOR_SELECT, "select");
    ADD(COLOR_SELECT_ACTIVE, "select active");
    ADD(COLOR_SLIDER, "slider");
    ADD(COLOR_SLIDER_CURSOR, "slider cursor");
    ADD(COLOR_SLIDER_CURSOR_HOVER, "slider cursor hover");
    ADD(COLOR_SLIDER_CURSOR_ACTIVE, "slider cursor active");
    ADD(COLOR_PROPERTY, "property");
    ADD(COLOR_EDIT, "edit");
    ADD(COLOR_EDIT_CURSOR, "edit cursor");
    ADD(COLOR_COMBO, "combo");
    ADD(COLOR_CHART, "chart");
    ADD(COLOR_CHART_COLOR, "chart color");
    ADD(COLOR_CHART_COLOR_HIGHLIGHT, "chart color highlight");
    ADD(COLOR_SCROLLBAR, "scrollbar");
    ADD(COLOR_SCROLLBAR_CURSOR, "scrollbar cursor");
    ADD(COLOR_SCROLLBAR_CURSOR_HOVER, "scrollbar cursor hover");
    ADD(COLOR_SCROLLBAR_CURSOR_ACTIVE, "scrollbar cursor active");
    ADD(COLOR_TAB_HEADER, "tab header");
//  ADD(COLOR_COUNT, "count");
#endif

    domain = DOMAIN_STYLE_CURSOR; /* nk_style_cursor */
    ADD(CURSOR_ARROW, "arrow");
    ADD(CURSOR_TEXT, "text");
    ADD(CURSOR_MOVE, "move");
    ADD(CURSOR_RESIZE_VERTICAL, "resize vertical");
    ADD(CURSOR_RESIZE_HORIZONTAL, "resize horizontal");
    ADD(CURSOR_RESIZE_TOP_LEFT_DOWN_RIGHT, "resize top left down right");
    ADD(CURSOR_RESIZE_TOP_RIGHT_DOWN_LEFT, "resize top right down left");
//  ADD(CURSOR_COUNT, "count");

    domain = DOMAIN_FONT_COORD_TYPE; /* nk_font_coord_type */
    ADD(COORD_UV, "uv");
    ADD(COORD_PIXEL, "pixel");

    domain = DOMAIN_FONT_ATLAS_FORMAT; /* nk_font_atlas_format */
    ADD(FONT_ATLAS_ALPHA8, "alpha8");
    ADD(FONT_ATLAS_RGBA32, "rgba32");

    domain = DOMAIN_ALLOCATION_TYPE; /* nk_allocation_type */
    ADD(BUFFER_FIXED, "fixed");
    ADD(BUFFER_DYNAMIC, "dynamic");

    domain = DOMAIN_BUFFER_ALLOCATION_TYPE; /* nk_buffer_allocation_type */
    ADD(BUFFER_FRONT, "front");
    ADD(BUFFER_BACK, "back");
//  ADD(BUFFER_MAX, "max");

    domain = DOMAIN_TEXT_EDIT_TYPE; /* nk_text_edit_type */
    ADD(TEXT_EDIT_SINGLE_LINE, "single line");
    ADD(TEXT_EDIT_MULTI_LINE, "multi line");

    domain = DOMAIN_TEXT_EDIT_MODE; /* nk_text_edit_mode */
    ADD(TEXT_EDIT_MODE_VIEW, "view");
    ADD(TEXT_EDIT_MODE_INSERT, "insert");
    ADD(TEXT_EDIT_MODE_REPLACE, "replace");

    domain = DOMAIN_COMMAND_TYPE; /* nk_command_type */
    ADD(COMMAND_NOP, "nop");
    ADD(COMMAND_SCISSOR, "scissor");
    ADD(COMMAND_LINE, "line");
    ADD(COMMAND_CURVE, "curve");
    ADD(COMMAND_RECT, "rect");
    ADD(COMMAND_RECT_FILLED, "rect filled");
    ADD(COMMAND_RECT_MULTI_COLOR, "rect multi color");
    ADD(COMMAND_CIRCLE, "circle");
    ADD(COMMAND_CIRCLE_FILLED, "circle filled");
    ADD(COMMAND_ARC, "arc");
    ADD(COMMAND_ARC_FILLED, "arc filled");
    ADD(COMMAND_TRIANGLE, "triangle");
    ADD(COMMAND_TRIANGLE_FILLED, "triangle filled");
    ADD(COMMAND_POLYGON, "polygon");
    ADD(COMMAND_POLYGON_FILLED, "polygon filled");
    ADD(COMMAND_POLYLINE, "polyline");
    ADD(COMMAND_TEXT, "text");
    ADD(COMMAND_IMAGE, "image");
    ADD(COMMAND_CUSTOM, "custom");

    domain = DOMAIN_DRAW_LIST_STROKE; /* nk_draw_list_stroke */
    ADD(STROKE_OPEN, "open");
    ADD(STROKE_CLOSED, "closed");

    domain = DOMAIN_DRAW_VERTEX_LAYOUT_ATTRIBUTE; /* nk_draw_vertex_layout_attribute */
    ADD(VERTEX_POSITION, "position");
    ADD(VERTEX_COLOR, "color");
    ADD(VERTEX_TEXCOORD, "texcoord");
//  ADD(VERTEX_ATTRIBUTE_COUNT, "attribute count");

    domain = DOMAIN_DRAW_VERTEX_LAYOUT_FORMAT; /* nk_draw_vertex_layout_format */
    ADD(FORMAT_SCHAR, "char");
    ADD(FORMAT_SSHORT, "short");
    ADD(FORMAT_SINT, "int");
    ADD(FORMAT_UCHAR, "uchar");
    ADD(FORMAT_USHORT, "ushort");
    ADD(FORMAT_UINT, "uint");
    ADD(FORMAT_FLOAT, "float");
    ADD(FORMAT_DOUBLE, "double");
    ADD(FORMAT_R8G8B8, "r8g8b8");
    ADD(FORMAT_R16G15B16, "r16g15b16");
    ADD(FORMAT_R32G32B32, "r32g32b32");
    ADD(FORMAT_R8G8B8A8, "r8g8b8a8");
    ADD(FORMAT_B8G8R8A8, "b8g8r8a8");
    ADD(FORMAT_R16G15B16A16, "r16g15b16a16");
    ADD(FORMAT_R32G32B32A32, "r32g32b32a32");
    ADD(FORMAT_R32G32B32A32_FLOAT, "r32g32b32a32 float");
    ADD(FORMAT_R32G32B32A32_DOUBLE, "r32g32b32a32 double");
    ADD(FORMAT_RGB32, "rgb32");
    ADD(FORMAT_RGBA32, "rgba32");

    domain = DOMAIN_STYLE_ITEM_TYPE; /* nk_style_item_type */
    ADD(STYLE_ITEM_COLOR, "color");
    ADD(STYLE_ITEM_IMAGE, "image");
    ADD(STYLE_ITEM_NINE_SLICE, "nine slice");

    domain = DOMAIN_PANEL_ROW_LAYOUT_TYPE; /* nk_panel_row_layout_type */
    ADD(LAYOUT_DYNAMIC_FIXED, "dynamic fixed ");
    ADD(LAYOUT_DYNAMIC_ROW, "dynamic row");
    ADD(LAYOUT_DYNAMIC_FREE, "dynamic free");
    ADD(LAYOUT_DYNAMIC, "dynamic");
    ADD(LAYOUT_STATIC_FIXED, "static fixed");
    ADD(LAYOUT_STATIC_ROW, "static row");
    ADD(LAYOUT_STATIC_FREE, "static free");
    ADD(LAYOUT_STATIC, "static");
    ADD(LAYOUT_TEMPLATE, "template");

#undef ADD

#define ADD(what, s) do {                                       \
    enums_new(L, domain, MOONNUKLEAR_FILTER_##what, s);  \
} while(0)

    domain = DOMAIN_NONNK_FILTER; /* MOONNUKLEAR_FILTER_XXX */
    ADD(DEFAULT, "default");
    ADD(ASCII, "ascii");
    ADD(FLOAT, "float");
    ADD(DECIMAL, "decimal");
    ADD(HEX, "hex");
    ADD(OCT, "oct");
    ADD(BINARY, "binary");

#undef ADD

#define ADD(what, s) do {                                   \
    enums_new(L, domain, nonnk_style_##what, s);            \
} while(0)

    domain = DOMAIN_NONNK_STYLE; /* nonnk_style */
    ADD(textXcolor, "text.color");
    ADD(textXpadding, "text.padding");
    ADD(buttonXnormal, "button.normal");
    ADD(buttonXhover, "button.hover");
    ADD(buttonXactive, "button.active");
    ADD(buttonXborder_color, "button.border_color");
    ADD(buttonXtext_background, "button.text_background");
    ADD(buttonXtext_normal, "button.text_normal");
    ADD(buttonXtext_hover, "button.text_hover");
    ADD(buttonXtext_active, "button.text_active");
    ADD(buttonXpadding, "button.padding");
    ADD(buttonXimage_padding, "button.image_padding");
    ADD(buttonXtouch_padding, "button.touch_padding");
    ADD(buttonXuserdata, "button.userdata");
    ADD(buttonXtext_alignment, "button.text_alignment");
    ADD(buttonXborder, "button.border");
    ADD(buttonXrounding, "button.rounding");
    ADD(buttonXdraw_begin, "button.draw_begin");
    ADD(buttonXdraw_end, "button.draw_end");
    ADD(contextual_buttonXnormal, "contextual_button.normal");
    ADD(contextual_buttonXhover, "contextual_button.hover");
    ADD(contextual_buttonXactive, "contextual_button.active");
    ADD(contextual_buttonXborder_color, "contextual_button.border_color");
    ADD(contextual_buttonXtext_background, "contextual_button.text_background");
    ADD(contextual_buttonXtext_normal, "contextual_button.text_normal");
    ADD(contextual_buttonXtext_hover, "contextual_button.text_hover");
    ADD(contextual_buttonXtext_active, "contextual_button.text_active");
    ADD(contextual_buttonXpadding, "contextual_button.padding");
    ADD(contextual_buttonXtouch_padding, "contextual_button.touch_padding");
    ADD(contextual_buttonXuserdata, "contextual_button.userdata");
    ADD(contextual_buttonXtext_alignment, "contextual_button.text_alignment");
    ADD(contextual_buttonXborder, "contextual_button.border");
    ADD(contextual_buttonXrounding, "contextual_button.rounding");
    ADD(contextual_buttonXdraw_begin, "contextual_button.draw_begin");
    ADD(contextual_buttonXdraw_end, "contextual_button.draw_end");
    ADD(menu_buttonXnormal, "menu_button.normal");
    ADD(menu_buttonXhover, "menu_button.hover");
    ADD(menu_buttonXactive, "menu_button.active");
    ADD(menu_buttonXborder_color, "menu_button.border_color");
    ADD(menu_buttonXtext_background, "menu_button.text_background");
    ADD(menu_buttonXtext_normal, "menu_button.text_normal");
    ADD(menu_buttonXtext_hover, "menu_button.text_hover");
    ADD(menu_buttonXtext_active, "menu_button.text_active");
    ADD(menu_buttonXpadding, "menu_button.padding");
    ADD(menu_buttonXtouch_padding, "menu_button.touch_padding");
    ADD(menu_buttonXuserdata, "menu_button.userdata");
    ADD(menu_buttonXtext_alignment, "menu_button.text_alignment");
    ADD(menu_buttonXborder, "menu_button.border");
    ADD(menu_buttonXrounding, "menu_button.rounding");
    ADD(menu_buttonXdraw_begin, "menu_button.draw_begin");
    ADD(menu_buttonXdraw_end, "menu_button.draw_end");
    ADD(checkboxXnormal, "checkbox.normal");
    ADD(checkboxXhover, "checkbox.hover");
    ADD(checkboxXactive, "checkbox.active");
    ADD(checkboxXcursor_normal, "checkbox.cursor_normal");
    ADD(checkboxXcursor_hover, "checkbox.cursor_hover");
    ADD(checkboxXuserdata, "checkbox.userdata");
    ADD(checkboxXtext_background, "checkbox.text_background");
    ADD(checkboxXtext_normal, "checkbox.text_normal");
    ADD(checkboxXtext_hover, "checkbox.text_hover");
    ADD(checkboxXtext_active, "checkbox.text_active");
    ADD(checkboxXpadding, "checkbox.padding");
    ADD(checkboxXtouch_padding, "checkbox.touch_padding");
    ADD(checkboxXborder_color, "checkbox.border_color");
    ADD(checkboxXborder, "checkbox.border");
    ADD(checkboxXspacing, "checkbox.spacing");
    ADD(optionXnormal, "option.normal");
    ADD(optionXhover, "option.hover");
    ADD(optionXactive, "option.active");
    ADD(optionXcursor_normal, "option.cursor_normal");
    ADD(optionXcursor_hover, "option.cursor_hover");
    ADD(optionXuserdata, "option.userdata");
    ADD(optionXtext_background, "option.text_background");
    ADD(optionXtext_normal, "option.text_normal");
    ADD(optionXtext_hover, "option.text_hover");
    ADD(optionXtext_active, "option.text_active");
    ADD(optionXpadding, "option.padding");
    ADD(optionXtouch_padding, "option.touch_padding");
    ADD(optionXborder_color, "option.border_color");
    ADD(optionXborder, "option.border");
    ADD(optionXspacing, "option.spacing");
    ADD(selectableXnormal, "selectable.normal");
    ADD(selectableXhover, "selectable.hover");
    ADD(selectableXpressed, "selectable.pressed");
    ADD(selectableXnormal_active, "selectable.normal_active");
    ADD(selectableXhover_active, "selectable.hover_active");
    ADD(selectableXpressed_active, "selectable.pressed_active");
    ADD(selectableXtext_normal, "selectable.text_normal");
    ADD(selectableXtext_hover, "selectable.text_hover");
    ADD(selectableXtext_pressed, "selectable.text_pressed");
    ADD(selectableXtext_normal_active, "selectable.text_normal_active");
    ADD(selectableXtext_hover_active, "selectable.text_hover_active");
    ADD(selectableXtext_pressed_active, "selectable.text_pressed_active");
    ADD(selectableXpadding, "selectable.padding");
    ADD(selectableXtouch_padding, "selectable.touch_padding");
    ADD(selectableXuserdata, "selectable.userdata");
    ADD(selectableXrounding, "selectable.rounding");
    ADD(selectableXdraw_begin, "selectable.draw_begin");
    ADD(selectableXdraw_end, "selectable.draw_end");
    ADD(sliderXnormal, "slider.normal");
    ADD(sliderXhover, "slider.hover");
    ADD(sliderXactive, "slider.active");
    ADD(sliderXbar_normal, "slider.bar_normal");
    ADD(sliderXbar_hover, "slider.bar_hover");
    ADD(sliderXbar_active, "slider.bar_active");
    ADD(sliderXbar_filled, "slider.bar_filled");
    ADD(sliderXcursor_normal, "slider.cursor_normal");
    ADD(sliderXcursor_hover, "slider.cursor_hover");
    ADD(sliderXcursor_active, "slider.cursor_active");
    ADD(sliderXinc_symbol, "slider.inc_symbol");
    ADD(sliderXdec_symbol, "slider.dec_symbol");
    ADD(sliderXcursor_size, "slider.cursor_size");
    ADD(sliderXpadding, "slider.padding");
    ADD(sliderXspacing, "slider.spacing");
    ADD(sliderXuserdata, "slider.userdata");
    ADD(sliderXshow_buttons, "slider.show_buttons");
    ADD(sliderXbar_height, "slider.bar_height");
    ADD(sliderXrounding, "slider.rounding");
    ADD(sliderXdraw_begin, "slider.draw_begin");
    ADD(sliderXdraw_end, "slider.draw_end");
    ADD(sliderXinc_buttonXnormal, "slider.inc_button.normal");
    ADD(sliderXinc_buttonXhover, "slider.inc_button.hover");
    ADD(sliderXinc_buttonXactive, "slider.inc_button.active");
    ADD(sliderXinc_buttonXborder_color, "slider.inc_button.border_color");
    ADD(sliderXinc_buttonXtext_background, "slider.inc_button.text_background");
    ADD(sliderXinc_buttonXtext_normal, "slider.inc_button.text_normal");
    ADD(sliderXinc_buttonXtext_hover, "slider.inc_button.text_hover");
    ADD(sliderXinc_buttonXtext_active, "slider.inc_button.text_active");
    ADD(sliderXinc_buttonXpadding, "slider.inc_button.padding");
    ADD(sliderXinc_buttonXtouch_padding, "slider.inc_button.touch_padding");
    ADD(sliderXinc_buttonXuserdata, "slider.inc_button.userdata");
    ADD(sliderXinc_buttonXtext_alignment, "slider.inc_button.text_alignment");
    ADD(sliderXinc_buttonXborder, "slider.inc_button.border");
    ADD(sliderXinc_buttonXrounding, "slider.inc_button.rounding");
    ADD(sliderXinc_buttonXdraw_begin, "slider.inc_button.draw_begin");
    ADD(sliderXinc_buttonXdraw_end, "slider.inc_button.draw_end");
    ADD(sliderXdec_buttonXnormal, "slider.dec_button.normal");
    ADD(sliderXdec_buttonXhover, "slider.dec_button.hover");
    ADD(sliderXdec_buttonXactive, "slider.dec_button.active");
    ADD(sliderXdec_buttonXborder_color, "slider.dec_button.border_color");
    ADD(sliderXdec_buttonXtext_background, "slider.dec_button.text_background");
    ADD(sliderXdec_buttonXtext_normal, "slider.dec_button.text_normal");
    ADD(sliderXdec_buttonXtext_hover, "slider.dec_button.text_hover");
    ADD(sliderXdec_buttonXtext_active, "slider.dec_button.text_active");
    ADD(sliderXdec_buttonXpadding, "slider.dec_button.padding");
    ADD(sliderXdec_buttonXtouch_padding, "slider.dec_button.touch_padding");
    ADD(sliderXdec_buttonXuserdata, "slider.dec_button.userdata");
    ADD(sliderXdec_buttonXtext_alignment, "slider.dec_button.text_alignment");
    ADD(sliderXdec_buttonXborder, "slider.dec_button.border");
    ADD(sliderXdec_buttonXrounding, "slider.dec_button.rounding");
    ADD(sliderXdec_buttonXdraw_begin, "slider.dec_button.draw_begin");
    ADD(sliderXdec_buttonXdraw_end, "slider.dec_button.draw_end");
    ADD(progressXnormal, "progress.normal");
    ADD(progressXhover, "progress.hover");
    ADD(progressXactive, "progress.active");
    ADD(progressXcursor_normal, "progress.cursor_normal");
    ADD(progressXcursor_hover, "progress.cursor_hover");
    ADD(progressXcursor_active, "progress.cursor_active");
    ADD(progressXborder_color, "progress.border_color");
    ADD(progressXcursor_border_color, "progress.cursor_border_color");
    ADD(progressXuserdata, "progress.userdata");
    ADD(progressXpadding, "progress.padding");
    ADD(progressXrounding, "progress.rounding");
    ADD(progressXborder, "progress.border");
    ADD(progressXcursor_rounding, "progress.cursor_rounding");
    ADD(progressXcursor_border, "progress.cursor_border");
    ADD(progressXdraw_begin, "progress.draw_begin");
    ADD(progressXdraw_end, "progress.draw_end");
    ADD(scrollhXnormal, "scrollh.normal");
    ADD(scrollhXhover, "scrollh.hover");
    ADD(scrollhXactive, "scrollh.active");
    ADD(scrollhXcursor_normal, "scrollh.cursor_normal");
    ADD(scrollhXcursor_hover, "scrollh.cursor_hover");
    ADD(scrollhXcursor_active, "scrollh.cursor_active");
    ADD(scrollhXdec_symbol, "scrollh.dec_symbol");
    ADD(scrollhXinc_symbol, "scrollh.inc_symbol");
    ADD(scrollhXuserdata, "scrollh.userdata");
    ADD(scrollhXborder_color, "scrollh.border_color");
    ADD(scrollhXcursor_border_color, "scrollh.cursor_border_color");
    ADD(scrollhXpadding, "scrollh.padding");
    ADD(scrollhXshow_buttons, "scrollh.show_buttons");
    ADD(scrollhXborder, "scrollh.border");
    ADD(scrollhXrounding, "scrollh.rounding");
    ADD(scrollhXborder_cursor, "scrollh.border_cursor");
    ADD(scrollhXrounding_cursor, "scrollh.rounding_cursor");
    ADD(scrollhXdraw_begin, "scrollh.draw_begin");
    ADD(scrollhXdraw_end, "scrollh.draw_end");
    ADD(scrollvXnormal, "scrollv.normal");
    ADD(scrollvXhover, "scrollv.hover");
    ADD(scrollvXactive, "scrollv.active");
    ADD(scrollvXcursor_normal, "scrollv.cursor_normal");
    ADD(scrollvXcursor_hover, "scrollv.cursor_hover");
    ADD(scrollvXcursor_active, "scrollv.cursor_active");
    ADD(scrollvXdec_symbol, "scrollv.dec_symbol");
    ADD(scrollvXinc_symbol, "scrollv.inc_symbol");
    ADD(scrollvXuserdata, "scrollv.userdata");
    ADD(scrollvXborder_color, "scrollv.border_color");
    ADD(scrollvXcursor_border_color, "scrollv.cursor_border_color");
    ADD(scrollvXpadding, "scrollv.padding");
    ADD(scrollvXshow_buttons, "scrollv.show_buttons");
    ADD(scrollvXborder, "scrollv.border");
    ADD(scrollvXrounding, "scrollv.rounding");
    ADD(scrollvXborder_cursor, "scrollv.border_cursor");
    ADD(scrollvXrounding_cursor, "scrollv.rounding_cursor");
    ADD(scrollvXdraw_begin, "scrollv.draw_begin");
    ADD(scrollvXdraw_end, "scrollv.draw_end");
    ADD(scrollhXinc_buttonXnormal, "scrollh.inc_button.normal");
    ADD(scrollhXinc_buttonXhover, "scrollh.inc_button.hover");
    ADD(scrollhXinc_buttonXactive, "scrollh.inc_button.active");
    ADD(scrollhXinc_buttonXborder_color, "scrollh.inc_button.border_color");
    ADD(scrollhXinc_buttonXtext_background, "scrollh.inc_button.text_background");
    ADD(scrollhXinc_buttonXtext_normal, "scrollh.inc_button.text_normal");
    ADD(scrollhXinc_buttonXtext_hover, "scrollh.inc_button.text_hover");
    ADD(scrollhXinc_buttonXtext_active, "scrollh.inc_button.text_active");
    ADD(scrollhXinc_buttonXpadding, "scrollh.inc_button.padding");
    ADD(scrollhXinc_buttonXtouch_padding, "scrollh.inc_button.touch_padding");
    ADD(scrollhXinc_buttonXuserdata, "scrollh.inc_button.userdata");
    ADD(scrollhXinc_buttonXtext_alignment, "scrollh.inc_button.text_alignment");
    ADD(scrollhXinc_buttonXborder, "scrollh.inc_button.border");
    ADD(scrollhXinc_buttonXrounding, "scrollh.inc_button.rounding");
    ADD(scrollhXinc_buttonXdraw_begin, "scrollh.inc_button.draw_begin");
    ADD(scrollhXinc_buttonXdraw_end, "scrollh.inc_button.draw_end");
    ADD(scrollhXdec_buttonXnormal, "scrollh.dec_button.normal");
    ADD(scrollhXdec_buttonXhover, "scrollh.dec_button.hover");
    ADD(scrollhXdec_buttonXactive, "scrollh.dec_button.active");
    ADD(scrollhXdec_buttonXborder_color, "scrollh.dec_button.border_color");
    ADD(scrollhXdec_buttonXtext_background, "scrollh.dec_button.text_background");
    ADD(scrollhXdec_buttonXtext_normal, "scrollh.dec_button.text_normal");
    ADD(scrollhXdec_buttonXtext_hover, "scrollh.dec_button.text_hover");
    ADD(scrollhXdec_buttonXtext_active, "scrollh.dec_button.text_active");
    ADD(scrollhXdec_buttonXpadding, "scrollh.dec_button.padding");
    ADD(scrollhXdec_buttonXtouch_padding, "scrollh.dec_button.touch_padding");
    ADD(scrollhXdec_buttonXuserdata, "scrollh.dec_button.userdata");
    ADD(scrollhXdec_buttonXtext_alignment, "scrollh.dec_button.text_alignment");
    ADD(scrollhXdec_buttonXborder, "scrollh.dec_button.border");
    ADD(scrollhXdec_buttonXrounding, "scrollh.dec_button.rounding");
    ADD(scrollhXdec_buttonXdraw_begin, "scrollh.dec_button.draw_begin");
    ADD(scrollhXdec_buttonXdraw_end, "scrollh.dec_button.draw_end");
    ADD(scrollvXinc_buttonXnormal, "scrollv.inc_button.normal");
    ADD(scrollvXinc_buttonXhover, "scrollv.inc_button.hover");
    ADD(scrollvXinc_buttonXactive, "scrollv.inc_button.active");
    ADD(scrollvXinc_buttonXborder_color, "scrollv.inc_button.border_color");
    ADD(scrollvXinc_buttonXtext_background, "scrollv.inc_button.text_background");
    ADD(scrollvXinc_buttonXtext_normal, "scrollv.inc_button.text_normal");
    ADD(scrollvXinc_buttonXtext_hover, "scrollv.inc_button.text_hover");
    ADD(scrollvXinc_buttonXtext_active, "scrollv.inc_button.text_active");
    ADD(scrollvXinc_buttonXpadding, "scrollv.inc_button.padding");
    ADD(scrollvXinc_buttonXtouch_padding, "scrollv.inc_button.touch_padding");
    ADD(scrollvXinc_buttonXuserdata, "scrollv.inc_button.userdata");
    ADD(scrollvXinc_buttonXtext_alignment, "scrollv.inc_button.text_alignment");
    ADD(scrollvXinc_buttonXborder, "scrollv.inc_button.border");
    ADD(scrollvXinc_buttonXrounding, "scrollv.inc_button.rounding");
    ADD(scrollvXinc_buttonXdraw_begin, "scrollv.inc_button.draw_begin");
    ADD(scrollvXinc_buttonXdraw_end, "scrollv.inc_button.draw_end");
    ADD(scrollvXdec_buttonXnormal, "scrollv.dec_button.normal");
    ADD(scrollvXdec_buttonXhover, "scrollv.dec_button.hover");
    ADD(scrollvXdec_buttonXactive, "scrollv.dec_button.active");
    ADD(scrollvXdec_buttonXborder_color, "scrollv.dec_button.border_color");
    ADD(scrollvXdec_buttonXtext_background, "scrollv.dec_button.text_background");
    ADD(scrollvXdec_buttonXtext_normal, "scrollv.dec_button.text_normal");
    ADD(scrollvXdec_buttonXtext_hover, "scrollv.dec_button.text_hover");
    ADD(scrollvXdec_buttonXtext_active, "scrollv.dec_button.text_active");
    ADD(scrollvXdec_buttonXpadding, "scrollv.dec_button.padding");
    ADD(scrollvXdec_buttonXtouch_padding, "scrollv.dec_button.touch_padding");
    ADD(scrollvXdec_buttonXuserdata, "scrollv.dec_button.userdata");
    ADD(scrollvXdec_buttonXtext_alignment, "scrollv.dec_button.text_alignment");
    ADD(scrollvXdec_buttonXborder, "scrollv.dec_button.border");
    ADD(scrollvXdec_buttonXrounding, "scrollv.dec_button.rounding");
    ADD(scrollvXdec_buttonXdraw_begin, "scrollv.dec_button.draw_begin");
    ADD(scrollvXdec_buttonXdraw_end, "scrollv.dec_button.draw_end");
    ADD(editXnormal, "edit.normal");
    ADD(editXhover, "edit.hover");
    ADD(editXactive, "edit.active");
    ADD(editXcursor_normal, "edit.cursor_normal");
    ADD(editXcursor_hover, "edit.cursor_hover");
    ADD(editXcursor_text_normal, "edit.cursor_text_normal");
    ADD(editXcursor_text_hover, "edit.cursor_text_hover");
    ADD(editXborder_color, "edit.border_color");
    ADD(editXtext_normal, "edit.text_normal");
    ADD(editXtext_hover, "edit.text_hover");
    ADD(editXtext_active, "edit.text_active");
    ADD(editXselected_normal, "edit.selected_normal");
    ADD(editXselected_hover, "edit.selected_hover");
    ADD(editXselected_text_normal, "edit.selected_text_normal");
    ADD(editXselected_text_hover, "edit.selected_text_hover");
    ADD(editXscrollbar_size, "edit.scrollbar_size");
    ADD(editXpadding, "edit.padding");
    ADD(editXrow_padding, "edit.row_padding");
    ADD(editXcursor_size, "edit.cursor_size");
    ADD(editXborder, "edit.border");
    ADD(editXrounding, "edit.rounding");
    ADD(editXscrollbarXnormal, "edit.scrollbar.normal");
    ADD(editXscrollbarXhover, "edit.scrollbar.hover");
    ADD(editXscrollbarXactive, "edit.scrollbar.active");
    ADD(editXscrollbarXcursor_normal, "edit.scrollbar.cursor_normal");
    ADD(editXscrollbarXcursor_hover, "edit.scrollbar.cursor_hover");
    ADD(editXscrollbarXcursor_active, "edit.scrollbar.cursor_active");
    ADD(editXscrollbarXdec_symbol, "edit.scrollbar.dec_symbol");
    ADD(editXscrollbarXinc_symbol, "edit.scrollbar.inc_symbol");
    ADD(editXscrollbarXuserdata, "edit.scrollbar.userdata");
    ADD(editXscrollbarXborder_color, "edit.scrollbar.border_color");
    ADD(editXscrollbarXcursor_border_color, "edit.scrollbar.cursor_border_color");
    ADD(editXscrollbarXpadding, "edit.scrollbar.padding");
    ADD(editXscrollbarXshow_buttons, "edit.scrollbar.show_buttons");
    ADD(editXscrollbarXborder, "edit.scrollbar.border");
    ADD(editXscrollbarXrounding, "edit.scrollbar.rounding");
    ADD(editXscrollbarXborder_cursor, "edit.scrollbar.border_cursor");
    ADD(editXscrollbarXrounding_cursor, "edit.scrollbar.rounding_cursor");
    ADD(editXscrollbarXdraw_begin, "edit.scrollbar.draw_begin");
    ADD(editXscrollbarXdraw_end, "edit.scrollbar.draw_end");
    ADD(editXscrollbarXinc_buttonXnormal, "edit.scrollbar.inc_button.normal");
    ADD(editXscrollbarXinc_buttonXhover, "edit.scrollbar.inc_button.hover");
    ADD(editXscrollbarXinc_buttonXactive, "edit.scrollbar.inc_button.active");
    ADD(editXscrollbarXinc_buttonXborder_color, "edit.scrollbar.inc_button.border_color");
    ADD(editXscrollbarXinc_buttonXtext_background, "edit.scrollbar.inc_button.text_background");
    ADD(editXscrollbarXinc_buttonXtext_normal, "edit.scrollbar.inc_button.text_normal");
    ADD(editXscrollbarXinc_buttonXtext_hover, "edit.scrollbar.inc_button.text_hover");
    ADD(editXscrollbarXinc_buttonXtext_active, "edit.scrollbar.inc_button.text_active");
    ADD(editXscrollbarXinc_buttonXpadding, "edit.scrollbar.inc_button.padding");
    ADD(editXscrollbarXinc_buttonXtouch_padding, "edit.scrollbar.inc_button.touch_padding");
    ADD(editXscrollbarXinc_buttonXuserdata, "edit.scrollbar.inc_button.userdata");
    ADD(editXscrollbarXinc_buttonXtext_alignment, "edit.scrollbar.inc_button.text_alignment");
    ADD(editXscrollbarXinc_buttonXborder, "edit.scrollbar.inc_button.border");
    ADD(editXscrollbarXinc_buttonXrounding, "edit.scrollbar.inc_button.rounding");
    ADD(editXscrollbarXinc_buttonXdraw_begin, "edit.scrollbar.inc_button.draw_begin");
    ADD(editXscrollbarXinc_buttonXdraw_end, "edit.scrollbar.inc_button.draw_end");
    ADD(editXscrollbarXdec_buttonXnormal, "edit.scrollbar.dec_button.normal");
    ADD(editXscrollbarXdec_buttonXhover, "edit.scrollbar.dec_button.hover");
    ADD(editXscrollbarXdec_buttonXactive, "edit.scrollbar.dec_button.active");
    ADD(editXscrollbarXdec_buttonXborder_color, "edit.scrollbar.dec_button.border_color");
    ADD(editXscrollbarXdec_buttonXtext_background, "edit.scrollbar.dec_button.text_background");
    ADD(editXscrollbarXdec_buttonXtext_normal, "edit.scrollbar.dec_button.text_normal");
    ADD(editXscrollbarXdec_buttonXtext_hover, "edit.scrollbar.dec_button.text_hover");
    ADD(editXscrollbarXdec_buttonXtext_active, "edit.scrollbar.dec_button.text_active");
    ADD(editXscrollbarXdec_buttonXpadding, "edit.scrollbar.dec_button.padding");
    ADD(editXscrollbarXdec_buttonXtouch_padding, "edit.scrollbar.dec_button.touch_padding");
    ADD(editXscrollbarXdec_buttonXuserdata, "edit.scrollbar.dec_button.userdata");
    ADD(editXscrollbarXdec_buttonXtext_alignment, "edit.scrollbar.dec_button.text_alignment");
    ADD(editXscrollbarXdec_buttonXborder, "edit.scrollbar.dec_button.border");
    ADD(editXscrollbarXdec_buttonXrounding, "edit.scrollbar.dec_button.rounding");
    ADD(editXscrollbarXdec_buttonXdraw_begin, "edit.scrollbar.dec_button.draw_begin");
    ADD(editXscrollbarXdec_buttonXdraw_end, "edit.scrollbar.dec_button.draw_end");
    ADD(propertyXnormal, "property.normal");
    ADD(propertyXhover, "property.hover");
    ADD(propertyXactive, "property.active");
    ADD(propertyXborder_color, "property.border_color");
    ADD(propertyXlabel_normal, "property.label_normal");
    ADD(propertyXlabel_hover, "property.label_hover");
    ADD(propertyXlabel_active, "property.label_active");
    ADD(propertyXsym_left, "property.sym_left");
    ADD(propertyXsym_right, "property.sym_right");
    ADD(propertyXuserdata, "property.userdata");
    ADD(propertyXpadding, "property.padding");
    ADD(propertyXborder, "property.border");
    ADD(propertyXrounding, "property.rounding");
    ADD(propertyXdraw_begin, "property.draw_begin");
    ADD(propertyXdraw_end, "property.draw_end");
    ADD(propertyXdec_buttonXnormal, "property.dec_button.normal");
    ADD(propertyXdec_buttonXhover, "property.dec_button.hover");
    ADD(propertyXdec_buttonXactive, "property.dec_button.active");
    ADD(propertyXdec_buttonXborder_color, "property.dec_button.border_color");
    ADD(propertyXdec_buttonXtext_background, "property.dec_button.text_background");
    ADD(propertyXdec_buttonXtext_normal, "property.dec_button.text_normal");
    ADD(propertyXdec_buttonXtext_hover, "property.dec_button.text_hover");
    ADD(propertyXdec_buttonXtext_active, "property.dec_button.text_active");
    ADD(propertyXdec_buttonXpadding, "property.dec_button.padding");
    ADD(propertyXdec_buttonXtouch_padding, "property.dec_button.touch_padding");
    ADD(propertyXdec_buttonXuserdata, "property.dec_button.userdata");
    ADD(propertyXdec_buttonXtext_alignment, "property.dec_button.text_alignment");
    ADD(propertyXdec_buttonXborder, "property.dec_button.border");
    ADD(propertyXdec_buttonXrounding, "property.dec_button.rounding");
    ADD(propertyXdec_buttonXdraw_begin, "property.dec_button.draw_begin");
    ADD(propertyXdec_buttonXdraw_end, "property.dec_button.draw_end");
    ADD(propertyXinc_buttonXnormal, "property.inc_button.normal");
    ADD(propertyXinc_buttonXhover, "property.inc_button.hover");
    ADD(propertyXinc_buttonXactive, "property.inc_button.active");
    ADD(propertyXinc_buttonXborder_color, "property.inc_button.border_color");
    ADD(propertyXinc_buttonXtext_background, "property.inc_button.text_background");
    ADD(propertyXinc_buttonXtext_normal, "property.inc_button.text_normal");
    ADD(propertyXinc_buttonXtext_hover, "property.inc_button.text_hover");
    ADD(propertyXinc_buttonXtext_active, "property.inc_button.text_active");
    ADD(propertyXinc_buttonXpadding, "property.inc_button.padding");
    ADD(propertyXinc_buttonXtouch_padding, "property.inc_button.touch_padding");
    ADD(propertyXinc_buttonXuserdata, "property.inc_button.userdata");
    ADD(propertyXinc_buttonXtext_alignment, "property.inc_button.text_alignment");
    ADD(propertyXinc_buttonXborder, "property.inc_button.border");
    ADD(propertyXinc_buttonXrounding, "property.inc_button.rounding");
    ADD(propertyXinc_buttonXdraw_begin, "property.inc_button.draw_begin");
    ADD(propertyXinc_buttonXdraw_end, "property.inc_button.draw_end");
    ADD(propertyXeditXnormal, "property.edit.normal");
    ADD(propertyXeditXhover, "property.edit.hover");
    ADD(propertyXeditXactive, "property.edit.active");
    ADD(propertyXeditXborder_color, "property.edit.border_color");
    ADD(propertyXeditXcursor_normal, "property.edit.cursor_normal");
    ADD(propertyXeditXcursor_hover, "property.edit.cursor_hover");
    ADD(propertyXeditXcursor_text_normal, "property.edit.cursor_text_normal");
    ADD(propertyXeditXcursor_text_hover, "property.edit.cursor_text_hover");
    ADD(propertyXeditXtext_normal, "property.edit.text_normal");
    ADD(propertyXeditXtext_hover, "property.edit.text_hover");
    ADD(propertyXeditXtext_active, "property.edit.text_active");
    ADD(propertyXeditXselected_normal, "property.edit.selected_normal");
    ADD(propertyXeditXselected_hover, "property.edit.selected_hover");
    ADD(propertyXeditXselected_text_normal, "property.edit.selected_text_normal");
    ADD(propertyXeditXselected_text_hover, "property.edit.selected_text_hover");
    ADD(propertyXeditXpadding, "property.edit.padding");
    ADD(propertyXeditXcursor_size, "property.edit.cursor_size");
    ADD(propertyXeditXborder, "property.edit.border");
    ADD(propertyXeditXrounding, "property.edit.rounding");
    ADD(chartXbackground, "chart.background");
    ADD(chartXborder_color, "chart.border_color");
    ADD(chartXselected_color, "chart.selected_color");
    ADD(chartXcolor, "chart.color");
    ADD(chartXpadding, "chart.padding");
    ADD(chartXborder, "chart.border");
    ADD(chartXrounding, "chart.rounding");
    ADD(comboXnormal, "combo.normal");
    ADD(comboXhover, "combo.hover");
    ADD(comboXactive, "combo.active");
    ADD(comboXborder_color, "combo.border_color");
    ADD(comboXlabel_normal, "combo.label_normal");
    ADD(comboXlabel_hover, "combo.label_hover");
    ADD(comboXlabel_active, "combo.label_active");
    ADD(comboXsym_normal, "combo.sym_normal");
    ADD(comboXsym_hover, "combo.sym_hover");
    ADD(comboXsym_active, "combo.sym_active");
    ADD(comboXcontent_padding, "combo.content_padding");
    ADD(comboXbutton_padding, "combo.button_padding");
    ADD(comboXspacing, "combo.spacing");
    ADD(comboXborder, "combo.border");
    ADD(comboXrounding, "combo.rounding");
    ADD(comboXbuttonXnormal, "combo.button.normal");
    ADD(comboXbuttonXhover, "combo.button.hover");
    ADD(comboXbuttonXactive, "combo.button.active");
    ADD(comboXbuttonXborder_color, "combo.button.border_color");
    ADD(comboXbuttonXtext_background, "combo.button.text_background");
    ADD(comboXbuttonXtext_normal, "combo.button.text_normal");
    ADD(comboXbuttonXtext_hover, "combo.button.text_hover");
    ADD(comboXbuttonXtext_active, "combo.button.text_active");
    ADD(comboXbuttonXpadding, "combo.button.padding");
    ADD(comboXbuttonXtouch_padding, "combo.button.touch_padding");
    ADD(comboXbuttonXuserdata, "combo.button.userdata");
    ADD(comboXbuttonXtext_alignment, "combo.button.text_alignment");
    ADD(comboXbuttonXborder, "combo.button.border");
    ADD(comboXbuttonXrounding, "combo.button.rounding");
    ADD(comboXbuttonXdraw_begin, "combo.button.draw_begin");
    ADD(comboXbuttonXdraw_end, "combo.button.draw_end");
    ADD(tabXbackground, "tab.background");
    ADD(tabXborder_color, "tab.border_color");
    ADD(tabXtext, "tab.text");
    ADD(tabXsym_minimize, "tab.sym_minimize");
    ADD(tabXsym_maximize, "tab.sym_maximize");
    ADD(tabXpadding, "tab.padding");
    ADD(tabXspacing, "tab.spacing");
    ADD(tabXindent, "tab.indent");
    ADD(tabXborder, "tab.border");
    ADD(tabXrounding, "tab.rounding");
    ADD(tabXtab_minimize_buttonXnormal, "tab.tab_minimize_button.normal");
    ADD(tabXtab_minimize_buttonXhover, "tab.tab_minimize_button.hover");
    ADD(tabXtab_minimize_buttonXactive, "tab.tab_minimize_button.active");
    ADD(tabXtab_minimize_buttonXborder_color, "tab.tab_minimize_button.border_color");
    ADD(tabXtab_minimize_buttonXtext_background, "tab.tab_minimize_button.text_background");
    ADD(tabXtab_minimize_buttonXtext_normal, "tab.tab_minimize_button.text_normal");
    ADD(tabXtab_minimize_buttonXtext_hover, "tab.tab_minimize_button.text_hover");
    ADD(tabXtab_minimize_buttonXtext_active, "tab.tab_minimize_button.text_active");
    ADD(tabXtab_minimize_buttonXpadding, "tab.tab_minimize_button.padding");
    ADD(tabXtab_minimize_buttonXtouch_padding, "tab.tab_minimize_button.touch_padding");
    ADD(tabXtab_minimize_buttonXuserdata, "tab.tab_minimize_button.userdata");
    ADD(tabXtab_minimize_buttonXtext_alignment, "tab.tab_minimize_button.text_alignment");
    ADD(tabXtab_minimize_buttonXborder, "tab.tab_minimize_button.border");
    ADD(tabXtab_minimize_buttonXrounding, "tab.tab_minimize_button.rounding");
    ADD(tabXtab_minimize_buttonXdraw_begin, "tab.tab_minimize_button.draw_begin");
    ADD(tabXtab_minimize_buttonXdraw_end, "tab.tab_minimize_button.draw_end");
    ADD(tabXtab_maximize_buttonXnormal, "tab.tab_maximize_button.normal");
    ADD(tabXtab_maximize_buttonXhover, "tab.tab_maximize_button.hover");
    ADD(tabXtab_maximize_buttonXactive, "tab.tab_maximize_button.active");
    ADD(tabXtab_maximize_buttonXborder_color, "tab.tab_maximize_button.border_color");
    ADD(tabXtab_maximize_buttonXtext_background, "tab.tab_maximize_button.text_background");
    ADD(tabXtab_maximize_buttonXtext_normal, "tab.tab_maximize_button.text_normal");
    ADD(tabXtab_maximize_buttonXtext_hover, "tab.tab_maximize_button.text_hover");
    ADD(tabXtab_maximize_buttonXtext_active, "tab.tab_maximize_button.text_active");
    ADD(tabXtab_maximize_buttonXpadding, "tab.tab_maximize_button.padding");
    ADD(tabXtab_maximize_buttonXtouch_padding, "tab.tab_maximize_button.touch_padding");
    ADD(tabXtab_maximize_buttonXuserdata, "tab.tab_maximize_button.userdata");
    ADD(tabXtab_maximize_buttonXtext_alignment, "tab.tab_maximize_button.text_alignment");
    ADD(tabXtab_maximize_buttonXborder, "tab.tab_maximize_button.border");
    ADD(tabXtab_maximize_buttonXrounding, "tab.tab_maximize_button.rounding");
    ADD(tabXtab_maximize_buttonXdraw_begin, "tab.tab_maximize_button.draw_begin");
    ADD(tabXtab_maximize_buttonXdraw_end, "tab.tab_maximize_button.draw_end");
    ADD(tabXnode_minimize_buttonXnormal, "tab.node_minimize_button.normal");
    ADD(tabXnode_minimize_buttonXhover, "tab.node_minimize_button.hover");
    ADD(tabXnode_minimize_buttonXactive, "tab.node_minimize_button.active");
    ADD(tabXnode_minimize_buttonXborder_color, "tab.node_minimize_button.border_color");
    ADD(tabXnode_minimize_buttonXtext_background, "tab.node_minimize_button.text_background");
    ADD(tabXnode_minimize_buttonXtext_normal, "tab.node_minimize_button.text_normal");
    ADD(tabXnode_minimize_buttonXtext_hover, "tab.node_minimize_button.text_hover");
    ADD(tabXnode_minimize_buttonXtext_active, "tab.node_minimize_button.text_active");
    ADD(tabXnode_minimize_buttonXpadding, "tab.node_minimize_button.padding");
    ADD(tabXnode_minimize_buttonXtouch_padding, "tab.node_minimize_button.touch_padding");
    ADD(tabXnode_minimize_buttonXuserdata, "tab.node_minimize_button.userdata");
    ADD(tabXnode_minimize_buttonXtext_alignment, "tab.node_minimize_button.text_alignment");
    ADD(tabXnode_minimize_buttonXborder, "tab.node_minimize_button.border");
    ADD(tabXnode_minimize_buttonXrounding, "tab.node_minimize_button.rounding");
    ADD(tabXnode_minimize_buttonXdraw_begin, "tab.node_minimize_button.draw_begin");
    ADD(tabXnode_minimize_buttonXdraw_end, "tab.node_minimize_button.draw_end");
    ADD(tabXnode_maximize_buttonXnormal, "tab.node_maximize_button.normal");
    ADD(tabXnode_maximize_buttonXhover, "tab.node_maximize_button.hover");
    ADD(tabXnode_maximize_buttonXactive, "tab.node_maximize_button.active");
    ADD(tabXnode_maximize_buttonXborder_color, "tab.node_maximize_button.border_color");
    ADD(tabXnode_maximize_buttonXtext_background, "tab.node_maximize_button.text_background");
    ADD(tabXnode_maximize_buttonXtext_normal, "tab.node_maximize_button.text_normal");
    ADD(tabXnode_maximize_buttonXtext_hover, "tab.node_maximize_button.text_hover");
    ADD(tabXnode_maximize_buttonXtext_active, "tab.node_maximize_button.text_active");
    ADD(tabXnode_maximize_buttonXpadding, "tab.node_maximize_button.padding");
    ADD(tabXnode_maximize_buttonXtouch_padding, "tab.node_maximize_button.touch_padding");
    ADD(tabXnode_maximize_buttonXuserdata, "tab.node_maximize_button.userdata");
    ADD(tabXnode_maximize_buttonXtext_alignment, "tab.node_maximize_button.text_alignment");
    ADD(tabXnode_maximize_buttonXborder, "tab.node_maximize_button.border");
    ADD(tabXnode_maximize_buttonXrounding, "tab.node_maximize_button.rounding");
    ADD(tabXnode_maximize_buttonXdraw_begin, "tab.node_maximize_button.draw_begin");
    ADD(tabXnode_maximize_buttonXdraw_end, "tab.node_maximize_button.draw_end");
    ADD(windowXheaderXalign, "window.header.align");
    ADD(windowXheaderXclose_symbol, "window.header.close_symbol");
    ADD(windowXheaderXminimize_symbol, "window.header.minimize_symbol");
    ADD(windowXheaderXmaximize_symbol, "window.header.maximize_symbol");
    ADD(windowXheaderXnormal, "window.header.normal");
    ADD(windowXheaderXhover, "window.header.hover");
    ADD(windowXheaderXactive, "window.header.active");
    ADD(windowXheaderXlabel_normal, "window.header.label_normal");
    ADD(windowXheaderXlabel_hover, "window.header.label_hover");
    ADD(windowXheaderXlabel_active, "window.header.label_active");
    ADD(windowXheaderXlabel_padding, "window.header.label_padding");
    ADD(windowXheaderXpadding, "window.header.padding");
    ADD(windowXheaderXspacing, "window.header.spacing");
    ADD(windowXheaderXclose_buttonXnormal, "window.header.close_button.normal");
    ADD(windowXheaderXclose_buttonXhover, "window.header.close_button.hover");
    ADD(windowXheaderXclose_buttonXactive, "window.header.close_button.active");
    ADD(windowXheaderXclose_buttonXborder_color, "window.header.close_button.border_color");
    ADD(windowXheaderXclose_buttonXtext_background, "window.header.close_button.text_background");
    ADD(windowXheaderXclose_buttonXtext_normal, "window.header.close_button.text_normal");
    ADD(windowXheaderXclose_buttonXtext_hover, "window.header.close_button.text_hover");
    ADD(windowXheaderXclose_buttonXtext_active, "window.header.close_button.text_active");
    ADD(windowXheaderXclose_buttonXpadding, "window.header.close_button.padding");
    ADD(windowXheaderXclose_buttonXtouch_padding, "window.header.close_button.touch_padding");
    ADD(windowXheaderXclose_buttonXuserdata, "window.header.close_button.userdata");
    ADD(windowXheaderXclose_buttonXtext_alignment, "window.header.close_button.text_alignment");
    ADD(windowXheaderXclose_buttonXborder, "window.header.close_button.border");
    ADD(windowXheaderXclose_buttonXrounding, "window.header.close_button.rounding");
    ADD(windowXheaderXclose_buttonXdraw_begin, "window.header.close_button.draw_begin");
    ADD(windowXheaderXclose_buttonXdraw_end, "window.header.close_button.draw_end");
    ADD(windowXheaderXminimize_buttonXnormal, "window.header.minimize_button.normal");
    ADD(windowXheaderXminimize_buttonXhover, "window.header.minimize_button.hover");
    ADD(windowXheaderXminimize_buttonXactive, "window.header.minimize_button.active");
    ADD(windowXheaderXminimize_buttonXborder_color, "window.header.minimize_button.border_color");
    ADD(windowXheaderXminimize_buttonXtext_background, "window.header.minimize_button.text_background");
    ADD(windowXheaderXminimize_buttonXtext_normal, "window.header.minimize_button.text_normal");
    ADD(windowXheaderXminimize_buttonXtext_hover, "window.header.minimize_button.text_hover");
    ADD(windowXheaderXminimize_buttonXtext_active, "window.header.minimize_button.text_active");
    ADD(windowXheaderXminimize_buttonXpadding, "window.header.minimize_button.padding");
    ADD(windowXheaderXminimize_buttonXtouch_padding, "window.header.minimize_button.touch_padding");
    ADD(windowXheaderXminimize_buttonXuserdata, "window.header.minimize_button.userdata");
    ADD(windowXheaderXminimize_buttonXtext_alignment, "window.header.minimize_button.text_alignment");
    ADD(windowXheaderXminimize_buttonXborder, "window.header.minimize_button.border");
    ADD(windowXheaderXminimize_buttonXrounding, "window.header.minimize_button.rounding");
    ADD(windowXheaderXminimize_buttonXdraw_begin, "window.header.minimize_button.draw_begin");
    ADD(windowXheaderXminimize_buttonXdraw_end, "window.header.minimize_button.draw_end");
    ADD(windowXbackground, "window.background");
    ADD(windowXfixed_background, "window.fixed_background");
    ADD(windowXborder_color, "window.border_color");
    ADD(windowXpopup_border_color, "window.popup_border_color");
    ADD(windowXcombo_border_color, "window.combo_border_color");
    ADD(windowXcontextual_border_color, "window.contextual_border_color");
    ADD(windowXmenu_border_color, "window.menu_border_color");
    ADD(windowXgroup_border_color, "window.group_border_color");
    ADD(windowXtooltip_border_color, "window.tooltip_border_color");
    ADD(windowXscaler, "window.scaler");
    ADD(windowXrounding, "window.rounding");
    ADD(windowXspacing, "window.spacing");
    ADD(windowXscrollbar_size, "window.scrollbar_size");
    ADD(windowXmin_size, "window.min_size");
    ADD(windowXcombo_border, "window.combo_border");
    ADD(windowXcontextual_border, "window.contextual_border");
    ADD(windowXmenu_border, "window.menu_border");
    ADD(windowXgroup_border, "window.group_border");
    ADD(windowXtooltip_border, "window.tooltip_border");
    ADD(windowXpopup_border, "window.popup_border");
    ADD(windowXborder, "window.border");
    ADD(windowXmin_row_height_padding, "window.min_row_height_padding");
    ADD(windowXpadding, "window.padding");
    ADD(windowXgroup_padding, "window.group_padding");
    ADD(windowXpopup_padding, "window.popup_padding");
    ADD(windowXcombo_padding, "window.combo_padding");
    ADD(windowXcontextual_padding, "window.contextual_padding");
    ADD(windowXmenu_padding, "window.menu_padding");
    ADD(windowXtooltip_padding, "window.tooltip_padding");
    ADD(textXcolor_factor, "text.color_factor");
    ADD(textXdisabled_factor, "text.disabled_factor");
    ADD(buttonXcolor_factor_background, "button.color_factor_background");
    ADD(buttonXdisabled_factor, "button.disabled_factor");
    ADD(buttonXcolor_factor_text, "button.color_factor_text");
    ADD(contextual_buttonXcolor_factor_background, "contextual_button.color_factor_background");
    ADD(contextual_buttonXdisabled_factor, "contextual_button.disabled_factor");
    ADD(contextual_buttonXcolor_factor_text, "contextual_button.color_factor_text");
    ADD(menu_buttonXcolor_factor_background, "menu_button.color_factor_background");
    ADD(menu_buttonXdisabled_factor, "menu_button.disabled_factor");
    ADD(menu_buttonXcolor_factor_text, "menu_button.color_factor_text");
    ADD(checkboxXcolor_factor, "checkbox.color_factor");
    ADD(checkboxXdisabled_factor, "checkbox.disabled_factor");
    ADD(optionXcolor_factor, "option.color_factor");
    ADD(optionXdisabled_factor, "option.disabled_factor");
    ADD(selectableXcolor_factor, "selectable.color_factor");
    ADD(selectableXdisabled_factor, "selectable.disabled_factor");
    ADD(sliderXcolor_factor, "slider.color_factor");
    ADD(sliderXdisabled_factor, "slider.disabled_factor");
    ADD(sliderXinc_buttonXcolor_factor_background, "slider.inc_button.color_factor_background");
    ADD(sliderXinc_buttonXdisabled_factor, "slider.inc_button.disabled_factor");
    ADD(sliderXinc_buttonXcolor_factor_text, "slider.inc_button.color_factor_text");
    ADD(sliderXdec_buttonXcolor_factor_background, "slider.dec_button.color_factor_background");
    ADD(sliderXdec_buttonXdisabled_factor, "slider.dec_button.disabled_factor");
    ADD(sliderXdec_buttonXcolor_factor_text, "slider.dec_button.color_factor_text");
    ADD(progressXcolor_factor, "progress.color_factor");
    ADD(progressXdisabled_factor, "progress.disabled_factor");
    ADD(scrollhXcolor_factor, "scrollh.color_factor");
    ADD(scrollhXdisabled_factor, "scrollh.disabled_factor");
    ADD(scrollvXcolor_factor, "scrollv.color_factor");
    ADD(scrollvXdisabled_factor, "scrollv.disabled_factor");
    ADD(scrollhXinc_buttonXcolor_factor_background, "scrollh.inc_button.color_factor_background");
    ADD(scrollhXinc_buttonXdisabled_factor, "scrollh.inc_button.disabled_factor");
    ADD(scrollhXinc_buttonXcolor_factor_text, "scrollh.inc_button.color_factor_text");
    ADD(scrollhXdec_buttonXcolor_factor_background, "scrollh.dec_button.color_factor_background");
    ADD(scrollhXdec_buttonXdisabled_factor, "scrollh.dec_button.disabled_factor");
    ADD(scrollhXdec_buttonXcolor_factor_text, "scrollh.dec_button.color_factor_text");
    ADD(scrollvXinc_buttonXcolor_factor_background, "scrollv.inc_button.color_factor_background");
    ADD(scrollvXinc_buttonXdisabled_factor, "scrollv.inc_button.disabled_factor");
    ADD(scrollvXinc_buttonXcolor_factor_text, "scrollv.inc_button.color_factor_text");
    ADD(scrollvXdec_buttonXcolor_factor_background, "scrollv.dec_button.color_factor_background");
    ADD(scrollvXdec_buttonXdisabled_factor, "scrollv.dec_button.disabled_factor");
    ADD(scrollvXdec_buttonXcolor_factor_text, "scrollv.dec_button.color_factor_text");
    ADD(editXcolor_factor, "edit.color_factor");
    ADD(editXdisabled_factor, "edit.disabled_factor");
    ADD(editXscrollbarXcolor_factor, "edit.scrollbar.color_factor");
    ADD(editXscrollbarXdisabled_factor, "edit.scrollbar.disabled_factor");
    ADD(editXscrollbarXinc_buttonXcolor_factor_background, "edit.scrollbar.inc_button.color_factor_background");
    ADD(editXscrollbarXinc_buttonXdisabled_factor, "edit.scrollbar.inc_button.disabled_factor");
    ADD(editXscrollbarXinc_buttonXcolor_factor_text, "edit.scrollbar.inc_button.color_factor_text");
    ADD(editXscrollbarXdec_buttonXcolor_factor_background, "edit.scrollbar.dec_button.color_factor_background");
    ADD(editXscrollbarXdec_buttonXdisabled_factor, "edit.scrollbar.dec_button.disabled_factor");
    ADD(editXscrollbarXdec_buttonXcolor_factor_text, "edit.scrollbar.dec_button.color_factor_text");
    ADD(propertyXcolor_factor, "property.color_factor");
    ADD(propertyXdisabled_factor, "property.disabled_factor");
    ADD(propertyXdec_buttonXcolor_factor_background, "property.dec_button.color_factor_background");
    ADD(propertyXdec_buttonXdisabled_factor, "property.dec_button.disabled_factor");
    ADD(propertyXdec_buttonXcolor_factor_text, "property.dec_button.color_factor_text");
    ADD(propertyXinc_buttonXcolor_factor_background, "property.inc_button.color_factor_background");
    ADD(propertyXinc_buttonXdisabled_factor, "property.inc_button.disabled_factor");
    ADD(propertyXinc_buttonXcolor_factor_text, "property.inc_button.color_factor_text");
    ADD(propertyXeditXcolor_factor, "property.edit.color_factor");
    ADD(propertyXeditXdisabled_factor, "property.edit.disabled_factor");
    ADD(chartXcolor_factor, "chart.color_factor");
    ADD(chartXdisabled_factor, "chart.disabled_factor");
    ADD(comboXcolor_factor, "combo.color_factor");
    ADD(comboXdisabled_factor, "combo.disabled_factor");
    ADD(comboXbuttonXcolor_factor_background, "combo.button.color_factor_background");
    ADD(comboXbuttonXdisabled_factor, "combo.button.disabled_factor");
    ADD(comboXbuttonXcolor_factor_text, "combo.button.color_factor_text");
    ADD(tabXcolor_factor, "tab.color_factor");
    ADD(tabXdisabled_factor, "tab.disabled_factor");
    ADD(tabXtab_minimize_buttonXcolor_factor_background, "tab.tab_minimize_button.color_factor_background");
    ADD(tabXtab_minimize_buttonXdisabled_factor, "tab.tab_minimize_button.disabled_factor");
    ADD(tabXtab_minimize_buttonXcolor_factor_text, "tab.tab_minimize_button.color_factor_text");
    ADD(tabXtab_maximize_buttonXcolor_factor_background, "tab.tab_maximize_button.color_factor_background");
    ADD(tabXtab_maximize_buttonXdisabled_factor, "tab.tab_maximize_button.disabled_factor");
    ADD(tabXtab_maximize_buttonXcolor_factor_text, "tab.tab_maximize_button.color_factor_text");
    ADD(tabXnode_minimize_buttonXcolor_factor_background, "tab.node_minimize_button.color_factor_background");
    ADD(tabXnode_minimize_buttonXdisabled_factor, "tab.node_minimize_button.disabled_factor");
    ADD(tabXnode_minimize_buttonXcolor_factor_text, "tab.node_minimize_button.color_factor_text");
    ADD(tabXnode_maximize_buttonXcolor_factor_background, "tab.node_maximize_button.color_factor_background");
    ADD(tabXnode_maximize_buttonXdisabled_factor, "tab.node_maximize_button.disabled_factor");
    ADD(tabXnode_maximize_buttonXcolor_factor_text, "tab.node_maximize_button.color_factor_text");
    ADD(windowXheaderXclose_buttonXcolor_factor_background, "window.header.close_button.color_factor_background");
    ADD(windowXheaderXclose_buttonXdisabled_factor, "window.header.close_button.disabled_factor");
    ADD(windowXheaderXclose_buttonXcolor_factor_text, "window.header.close_button.color_factor_text");
    ADD(windowXheaderXminimize_buttonXcolor_factor_background, "window.header.minimize_button.color_factor_background");
    ADD(windowXheaderXminimize_buttonXdisabled_factor, "window.header.minimize_button.disabled_factor");
    ADD(windowXheaderXminimize_buttonXcolor_factor_text, "window.header.minimize_button.color_factor_text");
#undef ADD
    }

