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

#ifndef enumsDEFINED
#define enumsDEFINED

/* enums.c */
#define enums_free_all moonnuklear_enums_free_all
void enums_free_all(lua_State *L);
#define enums_test moonnuklear_enums_test
uint32_t enums_test(lua_State *L, uint32_t domain, int arg, int *err);
#define enums_check moonnuklear_enums_check
uint32_t enums_check(lua_State *L, uint32_t domain, int arg);
#define enums_push moonnuklear_enums_push
int enums_push(lua_State *L, uint32_t domain, uint32_t code);
#define enums_values moonnuklear_enums_values
int enums_values(lua_State *L, uint32_t domain);
#define enums_checklist moonnuklear_enums_checklist
uint32_t* enums_checklist(lua_State *L, uint32_t domain, int arg, uint32_t *count, int *err);
#define enums_freelist moonnuklear_enums_freelist
void enums_freelist(lua_State *L, uint32_t *list);


/* Enum domains */
#define DOMAIN_HEADING                      1
#define DOMAIN_KEYS                         2
#define DOMAIN_BUTTONS                      3
#define DOMAIN_COLLAPSE_STATES              4
#define DOMAIN_SHOW_STATES                  5
#define DOMAIN_LAYOUT_FORMAT                6
#define DOMAIN_MODIFY                       7
#define DOMAIN_BUTTON_BEHAVIOR              8
#define DOMAIN_ORIENTATION                  9
#define DOMAIN_CHART_TYPE                   10
#define DOMAIN_COLOR_FORMAT                 11
#define DOMAIN_POPUP_TYPE                   12
#define DOMAIN_TREE_TYPE                    13
#define DOMAIN_SYMBOL_TYPE                  14
#define DOMAIN_STYLE_COLORS                 15
#define DOMAIN_STYLE_CURSOR                 16
#define DOMAIN_FONT_COORD_TYPE              17
#define DOMAIN_FONT_ATLAS_FORMAT            18
#define DOMAIN_ALLOCATION_TYPE              19
#define DOMAIN_BUFFER_ALLOCATION_TYPE       20
#define DOMAIN_TEXT_EDIT_TYPE               21
#define DOMAIN_TEXT_EDIT_MODE               22
#define DOMAIN_COMMAND_TYPE                 23
#define DOMAIN_DRAW_LIST_STROKE             24
#define DOMAIN_DRAW_VERTEX_LAYOUT_ATTRIBUTE 25
#define DOMAIN_DRAW_VERTEX_LAYOUT_FORMAT    26
#define DOMAIN_STYLE_ITEM_TYPE              27
#define DOMAIN_PANEL_ROW_LAYOUT_TYPE        28

/* NONNK additions */
#define DOMAIN_NONNK_STYLE                  101
#define DOMAIN_NONNK_FILTER                 102

#define MOONNUKLEAR_FILTER_DEFAULT  1
#define MOONNUKLEAR_FILTER_ASCII    2
#define MOONNUKLEAR_FILTER_FLOAT    3
#define MOONNUKLEAR_FILTER_DECIMAL  4
#define MOONNUKLEAR_FILTER_HEX      5
#define MOONNUKLEAR_FILTER_OCT      6
#define MOONNUKLEAR_FILTER_BINARY   7

#define testheading(L, arg, err) (enum nk_heading)enums_test((L), DOMAIN_HEADING, (arg), (err))
#define checkheading(L, arg) (enum nk_heading)enums_check((L), DOMAIN_HEADING, (arg))
#define pushheading(L, val) enums_push((L), DOMAIN_HEADING, (uint32_t)(val))
#define valuesheading(L) enums_values((L), DOMAIN_HEADING)

#define testkeys(L, arg, err) (enum nk_keys)enums_test((L), DOMAIN_KEYS, (arg), (err))
#define checkkeys(L, arg) (enum nk_keys)enums_check((L), DOMAIN_KEYS, (arg))
#define pushkeys(L, val) enums_push((L), DOMAIN_KEYS, (uint32_t)(val))
#define valueskeys(L) enums_values((L), DOMAIN_KEYS)

#define testbuttons(L, arg, err) (enum nk_buttons)enums_test((L), DOMAIN_BUTTONS, (arg), (err))
#define checkbuttons(L, arg) (enum nk_buttons)enums_check((L), DOMAIN_BUTTONS, (arg))
#define pushbuttons(L, val) enums_push((L), DOMAIN_BUTTONS, (uint32_t)(val))
#define valuesbuttons(L) enums_values((L), DOMAIN_BUTTONS)

#define testcollapsestates(L, arg, err) (enum nk_collapse_states)enums_test((L), DOMAIN_COLLAPSE_STATES, (arg), (err))
#define checkcollapsestates(L, arg) (enum nk_collapse_states)enums_check((L), DOMAIN_COLLAPSE_STATES, (arg))
#define pushcollapsestates(L, val) enums_push((L), DOMAIN_COLLAPSE_STATES, (uint32_t)(val))
#define valuescollapsestates(L) enums_values((L), DOMAIN_COLLAPSE_STATES)

#define testshowstates(L, arg, err) (enum nk_show_states)enums_test((L), DOMAIN_SHOW_STATES, (arg), (err))
#define checkshowstates(L, arg) (enum nk_show_states)enums_check((L), DOMAIN_SHOW_STATES, (arg))
#define pushshowstates(L, val) enums_push((L), DOMAIN_SHOW_STATES, (uint32_t)(val))
#define valuesshowstates(L) enums_values((L), DOMAIN_SHOW_STATES)

#define testlayoutformat(L, arg, err) (enum nk_layout_format)enums_test((L), DOMAIN_LAYOUT_FORMAT, (arg), (err))
#define checklayoutformat(L, arg) (enum nk_layout_format)enums_check((L), DOMAIN_LAYOUT_FORMAT, (arg))
#define pushlayoutformat(L, val) enums_push((L), DOMAIN_LAYOUT_FORMAT, (uint32_t)(val))
#define valueslayoutformat(L) enums_values((L), DOMAIN_LAYOUT_FORMAT)

#define testmodify(L, arg, err) (enum nk_modify)enums_test((L), DOMAIN_MODIFY, (arg), (err))
#define checkmodify(L, arg) (enum nk_modify)enums_check((L), DOMAIN_MODIFY, (arg))
#define pushmodify(L, val) enums_push((L), DOMAIN_MODIFY, (uint32_t)(val))
#define valuesmodify(L) enums_values((L), DOMAIN_MODIFY)

#define testbuttonbehavior(L, arg, err) (enum nk_button_behavior)enums_test((L), DOMAIN_BUTTON_BEHAVIOR, (arg), (err))
#define checkbuttonbehavior(L, arg) (enum nk_button_behavior)enums_check((L), DOMAIN_BUTTON_BEHAVIOR, (arg))
#define pushbuttonbehavior(L, val) enums_push((L), DOMAIN_BUTTON_BEHAVIOR, (uint32_t)(val))
#define valuesbuttonbehavior(L) enums_values((L), DOMAIN_BUTTON_BEHAVIOR)

#define testorientation(L, arg, err) (enum nk_orientation)enums_test((L), DOMAIN_ORIENTATION, (arg), (err))
#define checkorientation(L, arg) (enum nk_orientation)enums_check((L), DOMAIN_ORIENTATION, (arg))
#define pushorientation(L, val) enums_push((L), DOMAIN_ORIENTATION, (uint32_t)(val))
#define valuesorientation(L) enums_values((L), DOMAIN_ORIENTATION)

#define testcharttype(L, arg, err) (enum nk_chart_type)enums_test((L), DOMAIN_CHART_TYPE, (arg), (err))
#define checkcharttype(L, arg) (enum nk_chart_type)enums_check((L), DOMAIN_CHART_TYPE, (arg))
#define pushcharttype(L, val) enums_push((L), DOMAIN_CHART_TYPE, (uint32_t)(val))
#define valuescharttype(L) enums_values((L), DOMAIN_CHART_TYPE)

#define testcolorformat(L, arg, err) (enum nk_color_format)enums_test((L), DOMAIN_COLOR_FORMAT, (arg), (err))
#define checkcolorformat(L, arg) (enum nk_color_format)enums_check((L), DOMAIN_COLOR_FORMAT, (arg))
#define pushcolorformat(L, val) enums_push((L), DOMAIN_COLOR_FORMAT, (uint32_t)(val))
#define valuescolorformat(L) enums_values((L), DOMAIN_COLOR_FORMAT)

#define testpopuptype(L, arg, err) (enum nk_popup_type)enums_test((L), DOMAIN_POPUP_TYPE, (arg), (err))
#define checkpopuptype(L, arg) (enum nk_popup_type)enums_check((L), DOMAIN_POPUP_TYPE, (arg))
#define pushpopuptype(L, val) enums_push((L), DOMAIN_POPUP_TYPE, (uint32_t)(val))
#define valuespopuptype(L) enums_values((L), DOMAIN_POPUP_TYPE)

#define testtreetype(L, arg, err) (enum nk_tree_type)enums_test((L), DOMAIN_TREE_TYPE, (arg), (err))
#define checktreetype(L, arg) (enum nk_tree_type)enums_check((L), DOMAIN_TREE_TYPE, (arg))
#define pushtreetype(L, val) enums_push((L), DOMAIN_TREE_TYPE, (uint32_t)(val))
#define valuestreetype(L) enums_values((L), DOMAIN_TREE_TYPE)

#define testsymboltype(L, arg, err) (enum nk_symbol_type)enums_test((L), DOMAIN_SYMBOL_TYPE, (arg), (err))
#define checksymboltype(L, arg) (enum nk_symbol_type)enums_check((L), DOMAIN_SYMBOL_TYPE, (arg))
#define pushsymboltype(L, val) enums_push((L), DOMAIN_SYMBOL_TYPE, (uint32_t)(val))
#define valuessymboltype(L) enums_values((L), DOMAIN_SYMBOL_TYPE)

#define teststylecolors(L, arg, err) (enum nk_style_colors)enums_test((L), DOMAIN_STYLE_COLORS, (arg), (err))
#define checkstylecolors(L, arg) (enum nk_style_colors)enums_check((L), DOMAIN_STYLE_COLORS, (arg))
#define pushstylecolors(L, val) enums_push((L), DOMAIN_STYLE_COLORS, (uint32_t)(val))
#define valuesstylecolors(L) enums_values((L), DOMAIN_STYLE_COLORS)

#define teststylecursor(L, arg, err) (enum nk_style_cursor)enums_test((L), DOMAIN_STYLE_CURSOR, (arg), (err))
#define checkstylecursor(L, arg) (enum nk_style_cursor)enums_check((L), DOMAIN_STYLE_CURSOR, (arg))
#define pushstylecursor(L, val) enums_push((L), DOMAIN_STYLE_CURSOR, (uint32_t)(val))
#define valuesstylecursor(L) enums_values((L), DOMAIN_STYLE_CURSOR)

#define testfontcoordtype(L, arg, err) (enum nk_font_coord_type)enums_test((L), DOMAIN_FONT_COORD_TYPE, (arg), (err))
#define checkfontcoordtype(L, arg) (enum nk_font_coord_type)enums_check((L), DOMAIN_FONT_COORD_TYPE, (arg))
#define pushfontcoordtype(L, val) enums_push((L), DOMAIN_FONT_COORD_TYPE, (uint32_t)(val))
#define valuesfontcoordtype(L) enums_values((L), DOMAIN_FONT_COORD_TYPE)

#define testfontatlasformat(L, arg, err) (enum nk_font_atlas_format)enums_test((L), DOMAIN_FONT_ATLAS_FORMAT, (arg), (err))
#define checkfontatlasformat(L, arg) (enum nk_font_atlas_format)enums_check((L), DOMAIN_FONT_ATLAS_FORMAT, (arg))
#define pushfontatlasformat(L, val) enums_push((L), DOMAIN_FONT_ATLAS_FORMAT, (uint32_t)(val))
#define valuesfontatlasformat(L) enums_values((L), DOMAIN_FONT_ATLAS_FORMAT)

#define testallocationtype(L, arg, err) (enum nk_allocation_type)enums_test((L), DOMAIN_ALLOCATION_TYPE, (arg), (err))
#define checkallocationtype(L, arg) (enum nk_allocation_type)enums_check((L), DOMAIN_ALLOCATION_TYPE, (arg))
#define pushallocationtype(L, val) enums_push((L), DOMAIN_ALLOCATION_TYPE, (uint32_t)(val))
#define valuesallocationtype(L) enums_values((L), DOMAIN_ALLOCATION_TYPE)

#define testbufferallocationtype(L, arg, err) (enum nk_buffer_allocation_type)enums_test((L), DOMAIN_BUFFER_ALLOCATION_TYPE, (arg), (err))
#define checkbufferallocationtype(L, arg) (enum nk_buffer_allocation_type)enums_check((L), DOMAIN_BUFFER_ALLOCATION_TYPE, (arg))
#define pushbufferallocationtype(L, val) enums_push((L), DOMAIN_BUFFER_ALLOCATION_TYPE, (uint32_t)(val))
#define valuesbufferallocationtype(L) enums_values((L), DOMAIN_BUFFER_ALLOCATION_TYPE)

#define testtextedittype(L, arg, err) (enum nk_text_edit_type)enums_test((L), DOMAIN_TEXT_EDIT_TYPE, (arg), (err))
#define checktextedittype(L, arg) (enum nk_text_edit_type)enums_check((L), DOMAIN_TEXT_EDIT_TYPE, (arg))
#define pushtextedittype(L, val) enums_push((L), DOMAIN_TEXT_EDIT_TYPE, (uint32_t)(val))
#define valuestextedittype(L) enums_values((L), DOMAIN_TEXT_EDIT_TYPE)

#define testtexteditmode(L, arg, err) (enum nk_text_edit_mode)enums_test((L), DOMAIN_TEXT_EDIT_MODE, (arg), (err))
#define checktexteditmode(L, arg) (enum nk_text_edit_mode)enums_check((L), DOMAIN_TEXT_EDIT_MODE, (arg))
#define pushtexteditmode(L, val) enums_push((L), DOMAIN_TEXT_EDIT_MODE, (uint32_t)(val))
#define valuestexteditmode(L) enums_values((L), DOMAIN_TEXT_EDIT_MODE)

#define testcommandtype(L, arg, err) (enum nk_command_type)enums_test((L), DOMAIN_COMMAND_TYPE, (arg), (err))
#define checkcommandtype(L, arg) (enum nk_command_type)enums_check((L), DOMAIN_COMMAND_TYPE, (arg))
#define pushcommandtype(L, val) enums_push((L), DOMAIN_COMMAND_TYPE, (uint32_t)(val))
#define valuescommandtype(L) enums_values((L), DOMAIN_COMMAND_TYPE)

#define testdrawliststroke(L, arg, err) (enum nk_draw_list_stroke)enums_test((L), DOMAIN_DRAW_LIST_STROKE, (arg), (err))
#define checkdrawliststroke(L, arg) (enum nk_draw_list_stroke)enums_check((L), DOMAIN_DRAW_LIST_STROKE, (arg))
#define pushdrawliststroke(L, val) enums_push((L), DOMAIN_DRAW_LIST_STROKE, (uint32_t)(val))
#define valuesdrawliststroke(L) enums_values((L), DOMAIN_DRAW_LIST_STROKE)

#define testdrawvertexlayoutattribute(L, arg, err) (enum nk_draw_vertex_layout_attribute)enums_test((L), DOMAIN_DRAW_VERTEX_LAYOUT_ATTRIBUTE, (arg), (err))
#define checkdrawvertexlayoutattribute(L, arg) (enum nk_draw_vertex_layout_attribute)enums_check((L), DOMAIN_DRAW_VERTEX_LAYOUT_ATTRIBUTE, (arg))
#define pushdrawvertexlayoutattribute(L, val) enums_push((L), DOMAIN_DRAW_VERTEX_LAYOUT_ATTRIBUTE, (uint32_t)(val))
#define valuesdrawvertexlayoutattribute(L) enums_values((L), DOMAIN_DRAW_VERTEX_LAYOUT_ATTRIBUTE)

#define testdrawvertexlayoutformat(L, arg, err) (enum nk_draw_vertex_layout_format)enums_test((L), DOMAIN_DRAW_VERTEX_LAYOUT_FORMAT, (arg), (err))
#define checkdrawvertexlayoutformat(L, arg) (enum nk_draw_vertex_layout_format)enums_check((L), DOMAIN_DRAW_VERTEX_LAYOUT_FORMAT, (arg))
#define pushdrawvertexlayoutformat(L, val) enums_push((L), DOMAIN_DRAW_VERTEX_LAYOUT_FORMAT, (uint32_t)(val))
#define valuesdrawvertexlayoutformat(L) enums_values((L), DOMAIN_DRAW_VERTEX_LAYOUT_FORMAT)

#define teststyleitemtype(L, arg, err) (enum nk_style_item_type)enums_test((L), DOMAIN_STYLE_ITEM_TYPE, (arg), (err))
#define checkstyleitemtype(L, arg) (enum nk_style_item_type)enums_check((L), DOMAIN_STYLE_ITEM_TYPE, (arg))
#define pushstyleitemtype(L, val) enums_push((L), DOMAIN_STYLE_ITEM_TYPE, (uint32_t)(val))
#define valuesstyleitemtype(L) enums_values((L), DOMAIN_STYLE_ITEM_TYPE)

#define testpanelrowlayouttype(L, arg, err) (enum nk_panel_row_layout_type)enums_test((L), DOMAIN_PANEL_ROW_LAYOUT_TYPE, (arg), (err))
#define checkpanelrowlayouttype(L, arg) (enum nk_panel_row_layout_type)enums_check((L), DOMAIN_PANEL_ROW_LAYOUT_TYPE, (arg))
#define pushpanelrowlayouttype(L, val) enums_push((L), DOMAIN_PANEL_ROW_LAYOUT_TYPE, (uint32_t)(val))
#define valuespanelrowlayouttype(L) enums_values((L), DOMAIN_PANEL_ROW_LAYOUT_TYPE)

#define teststylefield(L, arg, err) (enum nonnk_style)enums_test((L), DOMAIN_NONNK_STYLE, (arg), (err))
#define checkstylefield(L, arg) (enum nonnk_style)enums_check((L), DOMAIN_NONNK_STYLE, (arg))
#define pushstylefield(L, val) enums_push((L), DOMAIN_NONNK_STYLE, (uint32_t)(val))
#define valuesstylefield(L) enums_values((L), DOMAIN_NONNK_STYLE)

#define testfilter(L, arg, err) (int)enums_test((L), DOMAIN_NONNK_FILTER, (arg), (err))
#define checkfilter(L, arg) (int)enums_check((L), DOMAIN_NONNK_FILTER, (arg))
#define pushfilter(L, val) enums_push((L), DOMAIN_NONNK_FILTER, (uint32_t)(val))
#define valuesfilter(L) enums_values((L), DOMAIN_NONNK_FILTER)

#if 0 /* scaffolding 6yy */
#define testxxx(L, arg, err) (enum nk_xxx)enums_test((L), DOMAIN_XXX, (arg), (err))
#define checkxxx(L, arg) (enum nk_xxx)enums_check((L), DOMAIN_XXX, (arg))
#define pushxxx(L, val) enums_push((L), DOMAIN_XXX, (uint32_t)(val))
#define valuesxxx(L) enums_values((L), DOMAIN_XXX)
    CASE(xxx);

#endif

#endif /* enumsDEFINED */


