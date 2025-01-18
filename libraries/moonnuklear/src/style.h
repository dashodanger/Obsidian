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

#ifndef styleDEFINED
#define styleDEFINED

/* NOTE: Each nonnk_style enum item represents a terminal field of the
 *       context->style struct.
 *       The field name is obtained by removing the 'nonnk_style_' prefix
 *       and replacing 'X' with '.', eg:
 *       nonnk_style_textXcolor ->  context.style.text.color
 */

enum nonnk_style {
    nonnk_style_textXcolor,
    nonnk_style_textXpadding,
    nonnk_style_textXcolor_factor,
    nonnk_style_textXdisabled_factor,
    nonnk_style_buttonXnormal,
    nonnk_style_buttonXhover,
    nonnk_style_buttonXactive,
    nonnk_style_buttonXborder_color,
    nonnk_style_buttonXtext_background,
    nonnk_style_buttonXtext_normal,
    nonnk_style_buttonXtext_hover,
    nonnk_style_buttonXtext_active,
    nonnk_style_buttonXpadding,
    nonnk_style_buttonXimage_padding,
    nonnk_style_buttonXtouch_padding,
    nonnk_style_buttonXuserdata,
    nonnk_style_buttonXtext_alignment,
    nonnk_style_buttonXborder,
    nonnk_style_buttonXrounding,
    nonnk_style_buttonXdraw_begin,
    nonnk_style_buttonXdraw_end,
    nonnk_style_buttonXcolor_factor_background,
    nonnk_style_buttonXdisabled_factor,
    nonnk_style_buttonXcolor_factor_text,
    nonnk_style_contextual_buttonXnormal,
    nonnk_style_contextual_buttonXhover,
    nonnk_style_contextual_buttonXactive,
    nonnk_style_contextual_buttonXborder_color,
    nonnk_style_contextual_buttonXtext_background,
    nonnk_style_contextual_buttonXtext_normal,
    nonnk_style_contextual_buttonXtext_hover,
    nonnk_style_contextual_buttonXtext_active,
    nonnk_style_contextual_buttonXpadding,
    nonnk_style_contextual_buttonXtouch_padding,
    nonnk_style_contextual_buttonXuserdata,
    nonnk_style_contextual_buttonXtext_alignment,
    nonnk_style_contextual_buttonXborder,
    nonnk_style_contextual_buttonXrounding,
    nonnk_style_contextual_buttonXdraw_begin,
    nonnk_style_contextual_buttonXdraw_end,
    nonnk_style_contextual_buttonXcolor_factor_background,
    nonnk_style_contextual_buttonXdisabled_factor,
    nonnk_style_contextual_buttonXcolor_factor_text,
    nonnk_style_menu_buttonXnormal,
    nonnk_style_menu_buttonXhover,
    nonnk_style_menu_buttonXactive,
    nonnk_style_menu_buttonXborder_color,
    nonnk_style_menu_buttonXtext_background,
    nonnk_style_menu_buttonXtext_normal,
    nonnk_style_menu_buttonXtext_hover,
    nonnk_style_menu_buttonXtext_active,
    nonnk_style_menu_buttonXpadding,
    nonnk_style_menu_buttonXtouch_padding,
    nonnk_style_menu_buttonXuserdata,
    nonnk_style_menu_buttonXtext_alignment,
    nonnk_style_menu_buttonXborder,
    nonnk_style_menu_buttonXrounding,
    nonnk_style_menu_buttonXdraw_begin,
    nonnk_style_menu_buttonXdraw_end,
    nonnk_style_menu_buttonXcolor_factor_background,
    nonnk_style_menu_buttonXdisabled_factor,
    nonnk_style_menu_buttonXcolor_factor_text,
    nonnk_style_checkboxXnormal,
    nonnk_style_checkboxXhover,
    nonnk_style_checkboxXactive,
    nonnk_style_checkboxXcursor_normal,
    nonnk_style_checkboxXcursor_hover,
    nonnk_style_checkboxXuserdata,
    nonnk_style_checkboxXtext_background,
    nonnk_style_checkboxXtext_normal,
    nonnk_style_checkboxXtext_hover,
    nonnk_style_checkboxXtext_active,
    nonnk_style_checkboxXpadding,
    nonnk_style_checkboxXtouch_padding,
    nonnk_style_checkboxXborder_color,
    nonnk_style_checkboxXborder,
    nonnk_style_checkboxXspacing,
    nonnk_style_checkboxXcolor_factor,
    nonnk_style_checkboxXdisabled_factor,
    nonnk_style_optionXnormal,
    nonnk_style_optionXhover,
    nonnk_style_optionXactive,
    nonnk_style_optionXcursor_normal,
    nonnk_style_optionXcursor_hover,
    nonnk_style_optionXuserdata,
    nonnk_style_optionXtext_background,
    nonnk_style_optionXtext_normal,
    nonnk_style_optionXtext_hover,
    nonnk_style_optionXtext_active,
    nonnk_style_optionXpadding,
    nonnk_style_optionXtouch_padding,
    nonnk_style_optionXborder_color,
    nonnk_style_optionXborder,
    nonnk_style_optionXspacing,
    nonnk_style_optionXcolor_factor,
    nonnk_style_optionXdisabled_factor,
    nonnk_style_selectableXnormal,
    nonnk_style_selectableXhover,
    nonnk_style_selectableXpressed,
    nonnk_style_selectableXnormal_active,
    nonnk_style_selectableXhover_active,
    nonnk_style_selectableXpressed_active,
    nonnk_style_selectableXtext_normal,
    nonnk_style_selectableXtext_hover,
    nonnk_style_selectableXtext_pressed,
    nonnk_style_selectableXtext_normal_active,
    nonnk_style_selectableXtext_hover_active,
    nonnk_style_selectableXtext_pressed_active,
    nonnk_style_selectableXpadding,
    nonnk_style_selectableXtouch_padding,
    nonnk_style_selectableXuserdata,
    nonnk_style_selectableXrounding,
    nonnk_style_selectableXdraw_begin,
    nonnk_style_selectableXdraw_end,
    nonnk_style_selectableXcolor_factor,
    nonnk_style_selectableXdisabled_factor,
    nonnk_style_sliderXnormal,
    nonnk_style_sliderXhover,
    nonnk_style_sliderXactive,
    nonnk_style_sliderXbar_normal,
    nonnk_style_sliderXbar_hover,
    nonnk_style_sliderXbar_active,
    nonnk_style_sliderXbar_filled,
    nonnk_style_sliderXcursor_normal,
    nonnk_style_sliderXcursor_hover,
    nonnk_style_sliderXcursor_active,
    nonnk_style_sliderXinc_symbol,
    nonnk_style_sliderXdec_symbol,
    nonnk_style_sliderXcursor_size,
    nonnk_style_sliderXpadding,
    nonnk_style_sliderXspacing,
    nonnk_style_sliderXuserdata,
    nonnk_style_sliderXshow_buttons,
    nonnk_style_sliderXbar_height,
    nonnk_style_sliderXrounding,
    nonnk_style_sliderXdraw_begin,
    nonnk_style_sliderXdraw_end,
    nonnk_style_sliderXcolor_factor,
    nonnk_style_sliderXdisabled_factor,
    nonnk_style_sliderXinc_buttonXnormal,
    nonnk_style_sliderXinc_buttonXhover,
    nonnk_style_sliderXinc_buttonXactive,
    nonnk_style_sliderXinc_buttonXborder_color,
    nonnk_style_sliderXinc_buttonXtext_background,
    nonnk_style_sliderXinc_buttonXtext_normal,
    nonnk_style_sliderXinc_buttonXtext_hover,
    nonnk_style_sliderXinc_buttonXtext_active,
    nonnk_style_sliderXinc_buttonXpadding,
    nonnk_style_sliderXinc_buttonXtouch_padding,
    nonnk_style_sliderXinc_buttonXuserdata,
    nonnk_style_sliderXinc_buttonXtext_alignment,
    nonnk_style_sliderXinc_buttonXborder,
    nonnk_style_sliderXinc_buttonXrounding,
    nonnk_style_sliderXinc_buttonXdraw_begin,
    nonnk_style_sliderXinc_buttonXdraw_end,
    nonnk_style_sliderXinc_buttonXcolor_factor_background,
    nonnk_style_sliderXinc_buttonXdisabled_factor,
    nonnk_style_sliderXinc_buttonXcolor_factor_text,
    nonnk_style_sliderXdec_buttonXnormal,
    nonnk_style_sliderXdec_buttonXhover,
    nonnk_style_sliderXdec_buttonXactive,
    nonnk_style_sliderXdec_buttonXborder_color,
    nonnk_style_sliderXdec_buttonXtext_background,
    nonnk_style_sliderXdec_buttonXtext_normal,
    nonnk_style_sliderXdec_buttonXtext_hover,
    nonnk_style_sliderXdec_buttonXtext_active,
    nonnk_style_sliderXdec_buttonXpadding,
    nonnk_style_sliderXdec_buttonXtouch_padding,
    nonnk_style_sliderXdec_buttonXuserdata,
    nonnk_style_sliderXdec_buttonXtext_alignment,
    nonnk_style_sliderXdec_buttonXborder,
    nonnk_style_sliderXdec_buttonXrounding,
    nonnk_style_sliderXdec_buttonXdraw_begin,
    nonnk_style_sliderXdec_buttonXdraw_end,
    nonnk_style_sliderXdec_buttonXcolor_factor_background,
    nonnk_style_sliderXdec_buttonXdisabled_factor,
    nonnk_style_sliderXdec_buttonXcolor_factor_text,
    nonnk_style_progressXnormal,
    nonnk_style_progressXhover,
    nonnk_style_progressXactive,
    nonnk_style_progressXcursor_normal,
    nonnk_style_progressXcursor_hover,
    nonnk_style_progressXcursor_active,
    nonnk_style_progressXborder_color,
    nonnk_style_progressXcursor_border_color,
    nonnk_style_progressXuserdata,
    nonnk_style_progressXpadding,
    nonnk_style_progressXrounding,
    nonnk_style_progressXborder,
    nonnk_style_progressXcursor_rounding,
    nonnk_style_progressXcursor_border,
    nonnk_style_progressXdraw_begin,
    nonnk_style_progressXdraw_end,
    nonnk_style_progressXcolor_factor,
    nonnk_style_progressXdisabled_factor,
    nonnk_style_scrollhXnormal,
    nonnk_style_scrollhXhover,
    nonnk_style_scrollhXactive,
    nonnk_style_scrollhXcursor_normal,
    nonnk_style_scrollhXcursor_hover,
    nonnk_style_scrollhXcursor_active,
    nonnk_style_scrollhXdec_symbol,
    nonnk_style_scrollhXinc_symbol,
    nonnk_style_scrollhXuserdata,
    nonnk_style_scrollhXborder_color,
    nonnk_style_scrollhXcursor_border_color,
    nonnk_style_scrollhXpadding,
    nonnk_style_scrollhXshow_buttons,
    nonnk_style_scrollhXborder,
    nonnk_style_scrollhXrounding,
    nonnk_style_scrollhXborder_cursor,
    nonnk_style_scrollhXrounding_cursor,
    nonnk_style_scrollhXdraw_begin,
    nonnk_style_scrollhXdraw_end,
    nonnk_style_scrollhXcolor_factor,
    nonnk_style_scrollhXdisabled_factor,
    nonnk_style_scrollvXnormal,
    nonnk_style_scrollvXhover,
    nonnk_style_scrollvXactive,
    nonnk_style_scrollvXcursor_normal,
    nonnk_style_scrollvXcursor_hover,
    nonnk_style_scrollvXcursor_active,
    nonnk_style_scrollvXdec_symbol,
    nonnk_style_scrollvXinc_symbol,
    nonnk_style_scrollvXuserdata,
    nonnk_style_scrollvXborder_color,
    nonnk_style_scrollvXcursor_border_color,
    nonnk_style_scrollvXpadding,
    nonnk_style_scrollvXshow_buttons,
    nonnk_style_scrollvXborder,
    nonnk_style_scrollvXrounding,
    nonnk_style_scrollvXborder_cursor,
    nonnk_style_scrollvXrounding_cursor,
    nonnk_style_scrollvXdraw_begin,
    nonnk_style_scrollvXdraw_end,
    nonnk_style_scrollvXcolor_factor,
    nonnk_style_scrollvXdisabled_factor,
    nonnk_style_scrollhXinc_buttonXnormal,
    nonnk_style_scrollhXinc_buttonXhover,
    nonnk_style_scrollhXinc_buttonXactive,
    nonnk_style_scrollhXinc_buttonXborder_color,
    nonnk_style_scrollhXinc_buttonXtext_background,
    nonnk_style_scrollhXinc_buttonXtext_normal,
    nonnk_style_scrollhXinc_buttonXtext_hover,
    nonnk_style_scrollhXinc_buttonXtext_active,
    nonnk_style_scrollhXinc_buttonXpadding,
    nonnk_style_scrollhXinc_buttonXtouch_padding,
    nonnk_style_scrollhXinc_buttonXuserdata,
    nonnk_style_scrollhXinc_buttonXtext_alignment,
    nonnk_style_scrollhXinc_buttonXborder,
    nonnk_style_scrollhXinc_buttonXrounding,
    nonnk_style_scrollhXinc_buttonXdraw_begin,
    nonnk_style_scrollhXinc_buttonXdraw_end,
    nonnk_style_scrollhXinc_buttonXcolor_factor_background,
    nonnk_style_scrollhXinc_buttonXdisabled_factor,
    nonnk_style_scrollhXinc_buttonXcolor_factor_text,
    nonnk_style_scrollhXdec_buttonXnormal,
    nonnk_style_scrollhXdec_buttonXhover,
    nonnk_style_scrollhXdec_buttonXactive,
    nonnk_style_scrollhXdec_buttonXborder_color,
    nonnk_style_scrollhXdec_buttonXtext_background,
    nonnk_style_scrollhXdec_buttonXtext_normal,
    nonnk_style_scrollhXdec_buttonXtext_hover,
    nonnk_style_scrollhXdec_buttonXtext_active,
    nonnk_style_scrollhXdec_buttonXpadding,
    nonnk_style_scrollhXdec_buttonXtouch_padding,
    nonnk_style_scrollhXdec_buttonXuserdata,
    nonnk_style_scrollhXdec_buttonXtext_alignment,
    nonnk_style_scrollhXdec_buttonXborder,
    nonnk_style_scrollhXdec_buttonXrounding,
    nonnk_style_scrollhXdec_buttonXdraw_begin,
    nonnk_style_scrollhXdec_buttonXdraw_end,
    nonnk_style_scrollhXdec_buttonXcolor_factor_background,
    nonnk_style_scrollhXdec_buttonXdisabled_factor,
    nonnk_style_scrollhXdec_buttonXcolor_factor_text,
    nonnk_style_scrollvXinc_buttonXnormal,
    nonnk_style_scrollvXinc_buttonXhover,
    nonnk_style_scrollvXinc_buttonXactive,
    nonnk_style_scrollvXinc_buttonXborder_color,
    nonnk_style_scrollvXinc_buttonXtext_background,
    nonnk_style_scrollvXinc_buttonXtext_normal,
    nonnk_style_scrollvXinc_buttonXtext_hover,
    nonnk_style_scrollvXinc_buttonXtext_active,
    nonnk_style_scrollvXinc_buttonXpadding,
    nonnk_style_scrollvXinc_buttonXtouch_padding,
    nonnk_style_scrollvXinc_buttonXuserdata,
    nonnk_style_scrollvXinc_buttonXtext_alignment,
    nonnk_style_scrollvXinc_buttonXborder,
    nonnk_style_scrollvXinc_buttonXrounding,
    nonnk_style_scrollvXinc_buttonXdraw_begin,
    nonnk_style_scrollvXinc_buttonXdraw_end,
    nonnk_style_scrollvXinc_buttonXcolor_factor_background,
    nonnk_style_scrollvXinc_buttonXdisabled_factor,
    nonnk_style_scrollvXinc_buttonXcolor_factor_text,
    nonnk_style_scrollvXdec_buttonXnormal,
    nonnk_style_scrollvXdec_buttonXhover,
    nonnk_style_scrollvXdec_buttonXactive,
    nonnk_style_scrollvXdec_buttonXborder_color,
    nonnk_style_scrollvXdec_buttonXtext_background,
    nonnk_style_scrollvXdec_buttonXtext_normal,
    nonnk_style_scrollvXdec_buttonXtext_hover,
    nonnk_style_scrollvXdec_buttonXtext_active,
    nonnk_style_scrollvXdec_buttonXpadding,
    nonnk_style_scrollvXdec_buttonXtouch_padding,
    nonnk_style_scrollvXdec_buttonXuserdata,
    nonnk_style_scrollvXdec_buttonXtext_alignment,
    nonnk_style_scrollvXdec_buttonXborder,
    nonnk_style_scrollvXdec_buttonXrounding,
    nonnk_style_scrollvXdec_buttonXdraw_begin,
    nonnk_style_scrollvXdec_buttonXdraw_end,
    nonnk_style_scrollvXdec_buttonXcolor_factor_background,
    nonnk_style_scrollvXdec_buttonXdisabled_factor,
    nonnk_style_scrollvXdec_buttonXcolor_factor_text,
    nonnk_style_editXnormal,
    nonnk_style_editXhover,
    nonnk_style_editXactive,
    nonnk_style_editXcursor_normal,
    nonnk_style_editXcursor_hover,
    nonnk_style_editXcursor_text_normal,
    nonnk_style_editXcursor_text_hover,
    nonnk_style_editXborder_color,
    nonnk_style_editXtext_normal,
    nonnk_style_editXtext_hover,
    nonnk_style_editXtext_active,
    nonnk_style_editXselected_normal,
    nonnk_style_editXselected_hover,
    nonnk_style_editXselected_text_normal,
    nonnk_style_editXselected_text_hover,
    nonnk_style_editXscrollbar_size,
    nonnk_style_editXpadding,
    nonnk_style_editXrow_padding,
    nonnk_style_editXcursor_size,
    nonnk_style_editXborder,
    nonnk_style_editXrounding,
    nonnk_style_editXcolor_factor,
    nonnk_style_editXdisabled_factor,
    nonnk_style_editXscrollbarXnormal,
    nonnk_style_editXscrollbarXhover,
    nonnk_style_editXscrollbarXactive,
    nonnk_style_editXscrollbarXcursor_normal,
    nonnk_style_editXscrollbarXcursor_hover,
    nonnk_style_editXscrollbarXcursor_active,
    nonnk_style_editXscrollbarXdec_symbol,
    nonnk_style_editXscrollbarXinc_symbol,
    nonnk_style_editXscrollbarXuserdata,
    nonnk_style_editXscrollbarXborder_color,
    nonnk_style_editXscrollbarXcursor_border_color,
    nonnk_style_editXscrollbarXpadding,
    nonnk_style_editXscrollbarXshow_buttons,
    nonnk_style_editXscrollbarXborder,
    nonnk_style_editXscrollbarXrounding,
    nonnk_style_editXscrollbarXborder_cursor,
    nonnk_style_editXscrollbarXrounding_cursor,
    nonnk_style_editXscrollbarXdraw_begin,
    nonnk_style_editXscrollbarXdraw_end,
    nonnk_style_editXscrollbarXcolor_factor,
    nonnk_style_editXscrollbarXdisabled_factor,
    nonnk_style_editXscrollbarXinc_buttonXnormal,
    nonnk_style_editXscrollbarXinc_buttonXhover,
    nonnk_style_editXscrollbarXinc_buttonXactive,
    nonnk_style_editXscrollbarXinc_buttonXborder_color,
    nonnk_style_editXscrollbarXinc_buttonXtext_background,
    nonnk_style_editXscrollbarXinc_buttonXtext_normal,
    nonnk_style_editXscrollbarXinc_buttonXtext_hover,
    nonnk_style_editXscrollbarXinc_buttonXtext_active,
    nonnk_style_editXscrollbarXinc_buttonXpadding,
    nonnk_style_editXscrollbarXinc_buttonXtouch_padding,
    nonnk_style_editXscrollbarXinc_buttonXuserdata,
    nonnk_style_editXscrollbarXinc_buttonXtext_alignment,
    nonnk_style_editXscrollbarXinc_buttonXborder,
    nonnk_style_editXscrollbarXinc_buttonXrounding,
    nonnk_style_editXscrollbarXinc_buttonXdraw_begin,
    nonnk_style_editXscrollbarXinc_buttonXdraw_end,
    nonnk_style_editXscrollbarXinc_buttonXcolor_factor_background,
    nonnk_style_editXscrollbarXinc_buttonXdisabled_factor,
    nonnk_style_editXscrollbarXinc_buttonXcolor_factor_text,
    nonnk_style_editXscrollbarXdec_buttonXnormal,
    nonnk_style_editXscrollbarXdec_buttonXhover,
    nonnk_style_editXscrollbarXdec_buttonXactive,
    nonnk_style_editXscrollbarXdec_buttonXborder_color,
    nonnk_style_editXscrollbarXdec_buttonXtext_background,
    nonnk_style_editXscrollbarXdec_buttonXtext_normal,
    nonnk_style_editXscrollbarXdec_buttonXtext_hover,
    nonnk_style_editXscrollbarXdec_buttonXtext_active,
    nonnk_style_editXscrollbarXdec_buttonXpadding,
    nonnk_style_editXscrollbarXdec_buttonXtouch_padding,
    nonnk_style_editXscrollbarXdec_buttonXuserdata,
    nonnk_style_editXscrollbarXdec_buttonXtext_alignment,
    nonnk_style_editXscrollbarXdec_buttonXborder,
    nonnk_style_editXscrollbarXdec_buttonXrounding,
    nonnk_style_editXscrollbarXdec_buttonXdraw_begin,
    nonnk_style_editXscrollbarXdec_buttonXdraw_end,
    nonnk_style_editXscrollbarXdec_buttonXcolor_factor_background,
    nonnk_style_editXscrollbarXdec_buttonXdisabled_factor,
    nonnk_style_editXscrollbarXdec_buttonXcolor_factor_text,
    nonnk_style_propertyXnormal,
    nonnk_style_propertyXhover,
    nonnk_style_propertyXactive,
    nonnk_style_propertyXborder_color,
    nonnk_style_propertyXlabel_normal,
    nonnk_style_propertyXlabel_hover,
    nonnk_style_propertyXlabel_active,
    nonnk_style_propertyXsym_left,
    nonnk_style_propertyXsym_right,
    nonnk_style_propertyXuserdata,
    nonnk_style_propertyXpadding,
    nonnk_style_propertyXborder,
    nonnk_style_propertyXrounding,
    nonnk_style_propertyXdraw_begin,
    nonnk_style_propertyXdraw_end,
    nonnk_style_propertyXcolor_factor,
    nonnk_style_propertyXdisabled_factor,
    nonnk_style_propertyXdec_buttonXnormal,
    nonnk_style_propertyXdec_buttonXhover,
    nonnk_style_propertyXdec_buttonXactive,
    nonnk_style_propertyXdec_buttonXborder_color,
    nonnk_style_propertyXdec_buttonXtext_background,
    nonnk_style_propertyXdec_buttonXtext_normal,
    nonnk_style_propertyXdec_buttonXtext_hover,
    nonnk_style_propertyXdec_buttonXtext_active,
    nonnk_style_propertyXdec_buttonXpadding,
    nonnk_style_propertyXdec_buttonXtouch_padding,
    nonnk_style_propertyXdec_buttonXuserdata,
    nonnk_style_propertyXdec_buttonXtext_alignment,
    nonnk_style_propertyXdec_buttonXborder,
    nonnk_style_propertyXdec_buttonXrounding,
    nonnk_style_propertyXdec_buttonXdraw_begin,
    nonnk_style_propertyXdec_buttonXdraw_end,
    nonnk_style_propertyXdec_buttonXcolor_factor_background,
    nonnk_style_propertyXdec_buttonXdisabled_factor,
    nonnk_style_propertyXdec_buttonXcolor_factor_text,
    nonnk_style_propertyXinc_buttonXnormal,
    nonnk_style_propertyXinc_buttonXhover,
    nonnk_style_propertyXinc_buttonXactive,
    nonnk_style_propertyXinc_buttonXborder_color,
    nonnk_style_propertyXinc_buttonXtext_background,
    nonnk_style_propertyXinc_buttonXtext_normal,
    nonnk_style_propertyXinc_buttonXtext_hover,
    nonnk_style_propertyXinc_buttonXtext_active,
    nonnk_style_propertyXinc_buttonXpadding,
    nonnk_style_propertyXinc_buttonXtouch_padding,
    nonnk_style_propertyXinc_buttonXuserdata,
    nonnk_style_propertyXinc_buttonXtext_alignment,
    nonnk_style_propertyXinc_buttonXborder,
    nonnk_style_propertyXinc_buttonXrounding,
    nonnk_style_propertyXinc_buttonXdraw_begin,
    nonnk_style_propertyXinc_buttonXdraw_end,
    nonnk_style_propertyXinc_buttonXcolor_factor_background,
    nonnk_style_propertyXinc_buttonXdisabled_factor,
    nonnk_style_propertyXinc_buttonXcolor_factor_text,
    nonnk_style_propertyXeditXnormal,
    nonnk_style_propertyXeditXhover,
    nonnk_style_propertyXeditXactive,
    nonnk_style_propertyXeditXborder_color,
    nonnk_style_propertyXeditXcursor_normal,
    nonnk_style_propertyXeditXcursor_hover,
    nonnk_style_propertyXeditXcursor_text_normal,
    nonnk_style_propertyXeditXcursor_text_hover,
    nonnk_style_propertyXeditXtext_normal,
    nonnk_style_propertyXeditXtext_hover,
    nonnk_style_propertyXeditXtext_active,
    nonnk_style_propertyXeditXselected_normal,
    nonnk_style_propertyXeditXselected_hover,
    nonnk_style_propertyXeditXselected_text_normal,
    nonnk_style_propertyXeditXselected_text_hover,
    nonnk_style_propertyXeditXpadding,
    nonnk_style_propertyXeditXcursor_size,
    nonnk_style_propertyXeditXborder,
    nonnk_style_propertyXeditXrounding,
    nonnk_style_propertyXeditXcolor_factor,
    nonnk_style_propertyXeditXdisabled_factor,
    nonnk_style_chartXbackground,
    nonnk_style_chartXborder_color,
    nonnk_style_chartXselected_color,
    nonnk_style_chartXcolor,
    nonnk_style_chartXpadding,
    nonnk_style_chartXborder,
    nonnk_style_chartXrounding,
    nonnk_style_chartXcolor_factor,
    nonnk_style_chartXdisabled_factor,
    nonnk_style_comboXnormal,
    nonnk_style_comboXhover,
    nonnk_style_comboXactive,
    nonnk_style_comboXborder_color,
    nonnk_style_comboXlabel_normal,
    nonnk_style_comboXlabel_hover,
    nonnk_style_comboXlabel_active,
    nonnk_style_comboXsym_normal,
    nonnk_style_comboXsym_hover,
    nonnk_style_comboXsym_active,
    nonnk_style_comboXcontent_padding,
    nonnk_style_comboXbutton_padding,
    nonnk_style_comboXspacing,
    nonnk_style_comboXborder,
    nonnk_style_comboXrounding,
    nonnk_style_comboXcolor_factor,
    nonnk_style_comboXdisabled_factor,
    nonnk_style_comboXbuttonXnormal,
    nonnk_style_comboXbuttonXhover,
    nonnk_style_comboXbuttonXactive,
    nonnk_style_comboXbuttonXborder_color,
    nonnk_style_comboXbuttonXtext_background,
    nonnk_style_comboXbuttonXtext_normal,
    nonnk_style_comboXbuttonXtext_hover,
    nonnk_style_comboXbuttonXtext_active,
    nonnk_style_comboXbuttonXpadding,
    nonnk_style_comboXbuttonXtouch_padding,
    nonnk_style_comboXbuttonXuserdata,
    nonnk_style_comboXbuttonXtext_alignment,
    nonnk_style_comboXbuttonXborder,
    nonnk_style_comboXbuttonXrounding,
    nonnk_style_comboXbuttonXdraw_begin,
    nonnk_style_comboXbuttonXdraw_end,
    nonnk_style_comboXbuttonXcolor_factor_background,
    nonnk_style_comboXbuttonXdisabled_factor,
    nonnk_style_comboXbuttonXcolor_factor_text,
    nonnk_style_tabXbackground,
    nonnk_style_tabXborder_color,
    nonnk_style_tabXtext,
    nonnk_style_tabXsym_minimize,
    nonnk_style_tabXsym_maximize,
    nonnk_style_tabXpadding,
    nonnk_style_tabXspacing,
    nonnk_style_tabXindent,
    nonnk_style_tabXborder,
    nonnk_style_tabXrounding,
    nonnk_style_tabXcolor_factor,
    nonnk_style_tabXdisabled_factor,
    nonnk_style_tabXtab_minimize_buttonXnormal,
    nonnk_style_tabXtab_minimize_buttonXhover,
    nonnk_style_tabXtab_minimize_buttonXactive,
    nonnk_style_tabXtab_minimize_buttonXborder_color,
    nonnk_style_tabXtab_minimize_buttonXtext_background,
    nonnk_style_tabXtab_minimize_buttonXtext_normal,
    nonnk_style_tabXtab_minimize_buttonXtext_hover,
    nonnk_style_tabXtab_minimize_buttonXtext_active,
    nonnk_style_tabXtab_minimize_buttonXpadding,
    nonnk_style_tabXtab_minimize_buttonXtouch_padding,
    nonnk_style_tabXtab_minimize_buttonXuserdata,
    nonnk_style_tabXtab_minimize_buttonXtext_alignment,
    nonnk_style_tabXtab_minimize_buttonXborder,
    nonnk_style_tabXtab_minimize_buttonXrounding,
    nonnk_style_tabXtab_minimize_buttonXdraw_begin,
    nonnk_style_tabXtab_minimize_buttonXdraw_end,
    nonnk_style_tabXtab_minimize_buttonXcolor_factor_background,
    nonnk_style_tabXtab_minimize_buttonXdisabled_factor,
    nonnk_style_tabXtab_minimize_buttonXcolor_factor_text,
    nonnk_style_tabXtab_maximize_buttonXnormal,
    nonnk_style_tabXtab_maximize_buttonXhover,
    nonnk_style_tabXtab_maximize_buttonXactive,
    nonnk_style_tabXtab_maximize_buttonXborder_color,
    nonnk_style_tabXtab_maximize_buttonXtext_background,
    nonnk_style_tabXtab_maximize_buttonXtext_normal,
    nonnk_style_tabXtab_maximize_buttonXtext_hover,
    nonnk_style_tabXtab_maximize_buttonXtext_active,
    nonnk_style_tabXtab_maximize_buttonXpadding,
    nonnk_style_tabXtab_maximize_buttonXtouch_padding,
    nonnk_style_tabXtab_maximize_buttonXuserdata,
    nonnk_style_tabXtab_maximize_buttonXtext_alignment,
    nonnk_style_tabXtab_maximize_buttonXborder,
    nonnk_style_tabXtab_maximize_buttonXrounding,
    nonnk_style_tabXtab_maximize_buttonXdraw_begin,
    nonnk_style_tabXtab_maximize_buttonXdraw_end,
    nonnk_style_tabXtab_maximize_buttonXcolor_factor_background,
    nonnk_style_tabXtab_maximize_buttonXdisabled_factor,
    nonnk_style_tabXtab_maximize_buttonXcolor_factor_text,
    nonnk_style_tabXnode_minimize_buttonXnormal,
    nonnk_style_tabXnode_minimize_buttonXhover,
    nonnk_style_tabXnode_minimize_buttonXactive,
    nonnk_style_tabXnode_minimize_buttonXborder_color,
    nonnk_style_tabXnode_minimize_buttonXtext_background,
    nonnk_style_tabXnode_minimize_buttonXtext_normal,
    nonnk_style_tabXnode_minimize_buttonXtext_hover,
    nonnk_style_tabXnode_minimize_buttonXtext_active,
    nonnk_style_tabXnode_minimize_buttonXpadding,
    nonnk_style_tabXnode_minimize_buttonXtouch_padding,
    nonnk_style_tabXnode_minimize_buttonXuserdata,
    nonnk_style_tabXnode_minimize_buttonXtext_alignment,
    nonnk_style_tabXnode_minimize_buttonXborder,
    nonnk_style_tabXnode_minimize_buttonXrounding,
    nonnk_style_tabXnode_minimize_buttonXdraw_begin,
    nonnk_style_tabXnode_minimize_buttonXdraw_end,
    nonnk_style_tabXnode_minimize_buttonXcolor_factor_background,
    nonnk_style_tabXnode_minimize_buttonXdisabled_factor,
    nonnk_style_tabXnode_minimize_buttonXcolor_factor_text,
    nonnk_style_tabXnode_maximize_buttonXnormal,
    nonnk_style_tabXnode_maximize_buttonXhover,
    nonnk_style_tabXnode_maximize_buttonXactive,
    nonnk_style_tabXnode_maximize_buttonXborder_color,
    nonnk_style_tabXnode_maximize_buttonXtext_background,
    nonnk_style_tabXnode_maximize_buttonXtext_normal,
    nonnk_style_tabXnode_maximize_buttonXtext_hover,
    nonnk_style_tabXnode_maximize_buttonXtext_active,
    nonnk_style_tabXnode_maximize_buttonXpadding,
    nonnk_style_tabXnode_maximize_buttonXtouch_padding,
    nonnk_style_tabXnode_maximize_buttonXuserdata,
    nonnk_style_tabXnode_maximize_buttonXtext_alignment,
    nonnk_style_tabXnode_maximize_buttonXborder,
    nonnk_style_tabXnode_maximize_buttonXrounding,
    nonnk_style_tabXnode_maximize_buttonXdraw_begin,
    nonnk_style_tabXnode_maximize_buttonXdraw_end,
    nonnk_style_tabXnode_maximize_buttonXcolor_factor_background,
    nonnk_style_tabXnode_maximize_buttonXdisabled_factor,
    nonnk_style_tabXnode_maximize_buttonXcolor_factor_text,
    nonnk_style_windowXheaderXalign,
    nonnk_style_windowXheaderXclose_symbol,
    nonnk_style_windowXheaderXminimize_symbol,
    nonnk_style_windowXheaderXmaximize_symbol,
    nonnk_style_windowXheaderXnormal,
    nonnk_style_windowXheaderXhover,
    nonnk_style_windowXheaderXactive,
    nonnk_style_windowXheaderXlabel_normal,
    nonnk_style_windowXheaderXlabel_hover,
    nonnk_style_windowXheaderXlabel_active,
    nonnk_style_windowXheaderXlabel_padding,
    nonnk_style_windowXheaderXpadding,
    nonnk_style_windowXheaderXspacing,
    nonnk_style_windowXheaderXclose_buttonXnormal,
    nonnk_style_windowXheaderXclose_buttonXhover,
    nonnk_style_windowXheaderXclose_buttonXactive,
    nonnk_style_windowXheaderXclose_buttonXborder_color,
    nonnk_style_windowXheaderXclose_buttonXtext_background,
    nonnk_style_windowXheaderXclose_buttonXtext_normal,
    nonnk_style_windowXheaderXclose_buttonXtext_hover,
    nonnk_style_windowXheaderXclose_buttonXtext_active,
    nonnk_style_windowXheaderXclose_buttonXpadding,
    nonnk_style_windowXheaderXclose_buttonXtouch_padding,
    nonnk_style_windowXheaderXclose_buttonXuserdata,
    nonnk_style_windowXheaderXclose_buttonXtext_alignment,
    nonnk_style_windowXheaderXclose_buttonXborder,
    nonnk_style_windowXheaderXclose_buttonXrounding,
    nonnk_style_windowXheaderXclose_buttonXdraw_begin,
    nonnk_style_windowXheaderXclose_buttonXdraw_end,
    nonnk_style_windowXheaderXclose_buttonXcolor_factor_background,
    nonnk_style_windowXheaderXclose_buttonXdisabled_factor,
    nonnk_style_windowXheaderXclose_buttonXcolor_factor_text,
    nonnk_style_windowXheaderXminimize_buttonXnormal,
    nonnk_style_windowXheaderXminimize_buttonXhover,
    nonnk_style_windowXheaderXminimize_buttonXactive,
    nonnk_style_windowXheaderXminimize_buttonXborder_color,
    nonnk_style_windowXheaderXminimize_buttonXtext_background,
    nonnk_style_windowXheaderXminimize_buttonXtext_normal,
    nonnk_style_windowXheaderXminimize_buttonXtext_hover,
    nonnk_style_windowXheaderXminimize_buttonXtext_active,
    nonnk_style_windowXheaderXminimize_buttonXpadding,
    nonnk_style_windowXheaderXminimize_buttonXtouch_padding,
    nonnk_style_windowXheaderXminimize_buttonXuserdata,
    nonnk_style_windowXheaderXminimize_buttonXtext_alignment,
    nonnk_style_windowXheaderXminimize_buttonXborder,
    nonnk_style_windowXheaderXminimize_buttonXrounding,
    nonnk_style_windowXheaderXminimize_buttonXdraw_begin,
    nonnk_style_windowXheaderXminimize_buttonXdraw_end,
    nonnk_style_windowXheaderXminimize_buttonXcolor_factor_background,
    nonnk_style_windowXheaderXminimize_buttonXdisabled_factor,
    nonnk_style_windowXheaderXminimize_buttonXcolor_factor_text,
    nonnk_style_windowXbackground,
    nonnk_style_windowXfixed_background,
    nonnk_style_windowXborder_color,
    nonnk_style_windowXpopup_border_color,
    nonnk_style_windowXcombo_border_color,
    nonnk_style_windowXcontextual_border_color,
    nonnk_style_windowXmenu_border_color,
    nonnk_style_windowXgroup_border_color,
    nonnk_style_windowXtooltip_border_color,
    nonnk_style_windowXscaler,
    nonnk_style_windowXrounding,
    nonnk_style_windowXspacing,
    nonnk_style_windowXscrollbar_size,
    nonnk_style_windowXmin_size,
    nonnk_style_windowXcombo_border,
    nonnk_style_windowXcontextual_border,
    nonnk_style_windowXmenu_border,
    nonnk_style_windowXgroup_border,
    nonnk_style_windowXtooltip_border,
    nonnk_style_windowXpopup_border,
    nonnk_style_windowXborder,
    nonnk_style_windowXmin_row_height_padding,
    nonnk_style_windowXpadding,
    nonnk_style_windowXgroup_padding,
    nonnk_style_windowXpopup_padding,
    nonnk_style_windowXcombo_padding,
    nonnk_style_windowXcontextual_padding,
    nonnk_style_windowXmenu_padding,
    nonnk_style_windowXtooltip_padding
};


#define CASE_NONNK_STYLE_FLOAT \
    case nonnk_style_buttonXborder:\
            return &context->style.button.border; \
    case nonnk_style_buttonXrounding:\
            return &context->style.button.rounding; \
    case nonnk_style_contextual_buttonXborder:\
            return &context->style.contextual_button.border; \
    case nonnk_style_contextual_buttonXrounding:\
            return &context->style.contextual_button.rounding; \
    case nonnk_style_menu_buttonXborder:\
            return &context->style.menu_button.border; \
    case nonnk_style_menu_buttonXrounding:\
            return &context->style.menu_button.rounding; \
    case nonnk_style_checkboxXborder:\
            return &context->style.checkbox.border; \
    case nonnk_style_checkboxXspacing:\
            return &context->style.checkbox.spacing; \
    case nonnk_style_optionXborder:\
            return &context->style.option.border; \
    case nonnk_style_optionXspacing:\
            return &context->style.option.spacing; \
    case nonnk_style_selectableXrounding:\
            return &context->style.selectable.rounding; \
    case nonnk_style_sliderXbar_height:\
            return &context->style.slider.bar_height; \
    case nonnk_style_sliderXrounding:\
            return &context->style.slider.rounding; \
    case nonnk_style_sliderXinc_buttonXborder:\
            return &context->style.slider.inc_button.border; \
    case nonnk_style_sliderXinc_buttonXrounding:\
            return &context->style.slider.inc_button.rounding; \
    case nonnk_style_sliderXdec_buttonXborder:\
            return &context->style.slider.dec_button.border; \
    case nonnk_style_sliderXdec_buttonXrounding:\
            return &context->style.slider.dec_button.rounding; \
    case nonnk_style_progressXrounding:\
            return &context->style.progress.rounding; \
    case nonnk_style_progressXborder:\
            return &context->style.progress.border; \
    case nonnk_style_progressXcursor_rounding:\
            return &context->style.progress.cursor_rounding; \
    case nonnk_style_progressXcursor_border:\
            return &context->style.progress.cursor_border; \
    case nonnk_style_scrollhXborder:\
            return &context->style.scrollh.border; \
    case nonnk_style_scrollhXrounding:\
            return &context->style.scrollh.rounding; \
    case nonnk_style_scrollhXborder_cursor:\
            return &context->style.scrollh.border_cursor; \
    case nonnk_style_scrollhXrounding_cursor:\
            return &context->style.scrollh.rounding_cursor; \
    case nonnk_style_scrollvXborder:\
            return &context->style.scrollv.border; \
    case nonnk_style_scrollvXrounding:\
            return &context->style.scrollv.rounding; \
    case nonnk_style_scrollvXborder_cursor:\
            return &context->style.scrollv.border_cursor; \
    case nonnk_style_scrollvXrounding_cursor:\
            return &context->style.scrollv.rounding_cursor; \
    case nonnk_style_scrollhXinc_buttonXborder:\
            return &context->style.scrollh.inc_button.border; \
    case nonnk_style_scrollhXinc_buttonXrounding:\
            return &context->style.scrollh.inc_button.rounding; \
    case nonnk_style_scrollhXdec_buttonXborder:\
            return &context->style.scrollh.dec_button.border; \
    case nonnk_style_scrollhXdec_buttonXrounding:\
            return &context->style.scrollh.dec_button.rounding; \
    case nonnk_style_scrollvXinc_buttonXborder:\
            return &context->style.scrollv.inc_button.border; \
    case nonnk_style_scrollvXinc_buttonXrounding:\
            return &context->style.scrollv.inc_button.rounding; \
    case nonnk_style_scrollvXdec_buttonXborder:\
            return &context->style.scrollv.dec_button.border; \
    case nonnk_style_scrollvXdec_buttonXrounding:\
            return &context->style.scrollv.dec_button.rounding; \
    case nonnk_style_editXrow_padding:\
            return &context->style.edit.row_padding; \
    case nonnk_style_editXcursor_size:\
            return &context->style.edit.cursor_size; \
    case nonnk_style_editXborder:\
            return &context->style.edit.border; \
    case nonnk_style_editXrounding:\
            return &context->style.edit.rounding; \
    case nonnk_style_editXscrollbarXborder:\
            return &context->style.edit.scrollbar.border; \
    case nonnk_style_editXscrollbarXrounding:\
            return &context->style.edit.scrollbar.rounding; \
    case nonnk_style_editXscrollbarXborder_cursor:\
            return &context->style.edit.scrollbar.border_cursor; \
    case nonnk_style_editXscrollbarXrounding_cursor:\
            return &context->style.edit.scrollbar.rounding_cursor; \
    case nonnk_style_editXscrollbarXinc_buttonXborder:\
            return &context->style.edit.scrollbar.inc_button.border; \
    case nonnk_style_editXscrollbarXinc_buttonXrounding:\
            return &context->style.edit.scrollbar.inc_button.rounding; \
    case nonnk_style_editXscrollbarXdec_buttonXborder:\
            return &context->style.edit.scrollbar.dec_button.border; \
    case nonnk_style_editXscrollbarXdec_buttonXrounding:\
            return &context->style.edit.scrollbar.dec_button.rounding; \
    case nonnk_style_propertyXborder:\
            return &context->style.property.border; \
    case nonnk_style_propertyXrounding:\
            return &context->style.property.rounding; \
    case nonnk_style_propertyXdec_buttonXborder:\
            return &context->style.property.dec_button.border; \
    case nonnk_style_propertyXdec_buttonXrounding:\
            return &context->style.property.dec_button.rounding; \
    case nonnk_style_propertyXinc_buttonXborder:\
            return &context->style.property.inc_button.border; \
    case nonnk_style_propertyXinc_buttonXrounding:\
            return &context->style.property.inc_button.rounding; \
    case nonnk_style_propertyXeditXcursor_size:\
            return &context->style.property.edit.cursor_size; \
    case nonnk_style_propertyXeditXborder:\
            return &context->style.property.edit.border; \
    case nonnk_style_propertyXeditXrounding:\
            return &context->style.property.edit.rounding; \
    case nonnk_style_chartXborder:\
            return &context->style.chart.border; \
    case nonnk_style_chartXrounding:\
            return &context->style.chart.rounding; \
    case nonnk_style_comboXborder:\
            return &context->style.combo.border; \
    case nonnk_style_comboXrounding:\
            return &context->style.combo.rounding; \
    case nonnk_style_comboXbuttonXborder:\
            return &context->style.combo.button.border; \
    case nonnk_style_comboXbuttonXrounding:\
            return &context->style.combo.button.rounding; \
    case nonnk_style_tabXindent:\
            return &context->style.tab.indent; \
    case nonnk_style_tabXborder:\
            return &context->style.tab.border; \
    case nonnk_style_tabXrounding:\
            return &context->style.tab.rounding; \
    case nonnk_style_tabXtab_minimize_buttonXborder:\
            return &context->style.tab.tab_minimize_button.border; \
    case nonnk_style_tabXtab_minimize_buttonXrounding:\
            return &context->style.tab.tab_minimize_button.rounding; \
    case nonnk_style_tabXtab_maximize_buttonXborder:\
            return &context->style.tab.tab_maximize_button.border; \
    case nonnk_style_tabXtab_maximize_buttonXrounding:\
            return &context->style.tab.tab_maximize_button.rounding; \
    case nonnk_style_tabXnode_minimize_buttonXborder:\
            return &context->style.tab.node_minimize_button.border; \
    case nonnk_style_tabXnode_minimize_buttonXrounding:\
            return &context->style.tab.node_minimize_button.rounding; \
    case nonnk_style_tabXnode_maximize_buttonXborder:\
            return &context->style.tab.node_maximize_button.border; \
    case nonnk_style_tabXnode_maximize_buttonXrounding:\
            return &context->style.tab.node_maximize_button.rounding; \
    case nonnk_style_windowXheaderXclose_buttonXborder:\
            return &context->style.window.header.close_button.border; \
    case nonnk_style_windowXheaderXclose_buttonXrounding:\
            return &context->style.window.header.close_button.rounding; \
    case nonnk_style_windowXheaderXminimize_buttonXborder:\
            return &context->style.window.header.minimize_button.border; \
    case nonnk_style_windowXheaderXminimize_buttonXrounding:\
            return &context->style.window.header.minimize_button.rounding; \
    case nonnk_style_windowXrounding:\
            return &context->style.window.rounding; \
    case nonnk_style_windowXcombo_border:\
            return &context->style.window.combo_border; \
    case nonnk_style_windowXcontextual_border:\
            return &context->style.window.contextual_border; \
    case nonnk_style_windowXmenu_border:\
            return &context->style.window.menu_border; \
    case nonnk_style_windowXgroup_border:\
            return &context->style.window.group_border; \
    case nonnk_style_windowXtooltip_border:\
            return &context->style.window.tooltip_border; \
    case nonnk_style_windowXpopup_border:\
            return &context->style.window.popup_border; \
    case nonnk_style_windowXborder:\
            return &context->style.window.border; \
    case nonnk_style_windowXmin_row_height_padding:\
            return &context->style.window.min_row_height_padding;\
    case nonnk_style_textXcolor_factor:\
        return &context->style.text.color_factor;\
    case nonnk_style_textXdisabled_factor:\
        return &context->style.text.disabled_factor;\
    case nonnk_style_buttonXcolor_factor_background:\
        return &context->style.button.color_factor_background;\
    case nonnk_style_buttonXdisabled_factor:\
        return &context->style.button.disabled_factor;\
    case nonnk_style_buttonXcolor_factor_text:\
        return &context->style.button.color_factor_text;\
    case nonnk_style_contextual_buttonXcolor_factor_background:\
        return &context->style.contextual_button.color_factor_background;\
    case nonnk_style_contextual_buttonXdisabled_factor:\
        return &context->style.contextual_button.disabled_factor;\
    case nonnk_style_contextual_buttonXcolor_factor_text:\
        return &context->style.contextual_button.color_factor_text;\
    case nonnk_style_menu_buttonXcolor_factor_background:\
        return &context->style.menu_button.color_factor_background;\
    case nonnk_style_menu_buttonXdisabled_factor:\
        return &context->style.menu_button.disabled_factor;\
    case nonnk_style_menu_buttonXcolor_factor_text:\
        return &context->style.menu_button.color_factor_text;\
    case nonnk_style_checkboxXcolor_factor:\
        return &context->style.checkbox.color_factor;\
    case nonnk_style_checkboxXdisabled_factor:\
        return &context->style.checkbox.disabled_factor;\
    case nonnk_style_optionXcolor_factor:\
        return &context->style.option.color_factor;\
    case nonnk_style_optionXdisabled_factor:\
        return &context->style.option.disabled_factor;\
    case nonnk_style_selectableXcolor_factor:\
        return &context->style.selectable.color_factor;\
    case nonnk_style_selectableXdisabled_factor:\
        return &context->style.selectable.disabled_factor;\
    case nonnk_style_sliderXcolor_factor:\
        return &context->style.slider.color_factor;\
    case nonnk_style_sliderXdisabled_factor:\
        return &context->style.slider.disabled_factor;\
    case nonnk_style_sliderXinc_buttonXcolor_factor_background:\
        return &context->style.slider.inc_button.color_factor_background;\
    case nonnk_style_sliderXinc_buttonXdisabled_factor:\
        return &context->style.slider.inc_button.disabled_factor;\
    case nonnk_style_sliderXinc_buttonXcolor_factor_text:\
        return &context->style.slider.inc_button.color_factor_text;\
    case nonnk_style_sliderXdec_buttonXcolor_factor_background:\
        return &context->style.slider.dec_button.color_factor_background;\
    case nonnk_style_sliderXdec_buttonXdisabled_factor:\
        return &context->style.slider.dec_button.disabled_factor;\
    case nonnk_style_sliderXdec_buttonXcolor_factor_text:\
        return &context->style.slider.dec_button.color_factor_text;\
    case nonnk_style_progressXcolor_factor:\
        return &context->style.progress.color_factor;\
    case nonnk_style_progressXdisabled_factor:\
        return &context->style.progress.disabled_factor;\
    case nonnk_style_scrollhXcolor_factor:\
        return &context->style.scrollh.color_factor;\
    case nonnk_style_scrollhXdisabled_factor:\
        return &context->style.scrollh.disabled_factor;\
    case nonnk_style_scrollvXcolor_factor:\
        return &context->style.scrollv.color_factor;\
    case nonnk_style_scrollvXdisabled_factor:\
        return &context->style.scrollv.disabled_factor;\
    case nonnk_style_scrollhXinc_buttonXcolor_factor_background:\
        return &context->style.scrollh.inc_button.color_factor_background;\
    case nonnk_style_scrollhXinc_buttonXdisabled_factor:\
        return &context->style.scrollh.inc_button.disabled_factor;\
    case nonnk_style_scrollhXinc_buttonXcolor_factor_text:\
        return &context->style.scrollh.inc_button.color_factor_text;\
    case nonnk_style_scrollhXdec_buttonXcolor_factor_background:\
        return &context->style.scrollh.dec_button.color_factor_background;\
    case nonnk_style_scrollhXdec_buttonXdisabled_factor:\
        return &context->style.scrollh.dec_button.disabled_factor;\
    case nonnk_style_scrollhXdec_buttonXcolor_factor_text:\
        return &context->style.scrollh.dec_button.color_factor_text;\
    case nonnk_style_scrollvXinc_buttonXcolor_factor_background:\
        return &context->style.scrollv.inc_button.color_factor_background;\
    case nonnk_style_scrollvXinc_buttonXdisabled_factor:\
        return &context->style.scrollv.inc_button.disabled_factor;\
    case nonnk_style_scrollvXinc_buttonXcolor_factor_text:\
        return &context->style.scrollv.inc_button.color_factor_text;\
    case nonnk_style_scrollvXdec_buttonXcolor_factor_background:\
        return &context->style.scrollv.dec_button.color_factor_background;\
    case nonnk_style_scrollvXdec_buttonXdisabled_factor:\
        return &context->style.scrollv.dec_button.disabled_factor;\
    case nonnk_style_scrollvXdec_buttonXcolor_factor_text:\
        return &context->style.scrollv.dec_button.color_factor_text;\
    case nonnk_style_editXcolor_factor:\
        return &context->style.edit.color_factor;\
    case nonnk_style_editXdisabled_factor:\
        return &context->style.edit.disabled_factor;\
    case nonnk_style_editXscrollbarXcolor_factor:\
        return &context->style.edit.scrollbar.color_factor;\
    case nonnk_style_editXscrollbarXdisabled_factor:\
        return &context->style.edit.scrollbar.disabled_factor;\
    case nonnk_style_editXscrollbarXinc_buttonXcolor_factor_background:\
        return &context->style.edit.scrollbar.inc_button.color_factor_background;\
    case nonnk_style_editXscrollbarXinc_buttonXdisabled_factor:\
        return &context->style.edit.scrollbar.inc_button.disabled_factor;\
    case nonnk_style_editXscrollbarXinc_buttonXcolor_factor_text:\
        return &context->style.edit.scrollbar.inc_button.color_factor_text;\
    case nonnk_style_editXscrollbarXdec_buttonXcolor_factor_background:\
        return &context->style.edit.scrollbar.dec_button.color_factor_background;\
    case nonnk_style_editXscrollbarXdec_buttonXdisabled_factor:\
        return &context->style.edit.scrollbar.dec_button.disabled_factor;\
    case nonnk_style_editXscrollbarXdec_buttonXcolor_factor_text:\
        return &context->style.edit.scrollbar.dec_button.color_factor_text;\
    case nonnk_style_propertyXcolor_factor:\
        return &context->style.property.color_factor;\
    case nonnk_style_propertyXdisabled_factor:\
        return &context->style.property.disabled_factor;\
    case nonnk_style_propertyXdec_buttonXcolor_factor_background:\
        return &context->style.property.dec_button.color_factor_background;\
    case nonnk_style_propertyXdec_buttonXdisabled_factor:\
        return &context->style.property.dec_button.disabled_factor;\
    case nonnk_style_propertyXdec_buttonXcolor_factor_text:\
        return &context->style.property.dec_button.color_factor_text;\
    case nonnk_style_propertyXinc_buttonXcolor_factor_background:\
        return &context->style.property.inc_button.color_factor_background;\
    case nonnk_style_propertyXinc_buttonXdisabled_factor:\
        return &context->style.property.inc_button.disabled_factor;\
    case nonnk_style_propertyXinc_buttonXcolor_factor_text:\
        return &context->style.property.inc_button.color_factor_text;\
    case nonnk_style_propertyXeditXcolor_factor:\
        return &context->style.property.edit.color_factor;\
    case nonnk_style_propertyXeditXdisabled_factor:\
        return &context->style.property.edit.disabled_factor;\
    case nonnk_style_chartXcolor_factor:\
        return &context->style.chart.color_factor;\
    case nonnk_style_chartXdisabled_factor:\
        return &context->style.chart.disabled_factor;\
    case nonnk_style_comboXcolor_factor:\
        return &context->style.combo.color_factor;\
    case nonnk_style_comboXdisabled_factor:\
        return &context->style.combo.disabled_factor;\
    case nonnk_style_comboXbuttonXcolor_factor_background:\
        return &context->style.combo.button.color_factor_background;\
    case nonnk_style_comboXbuttonXdisabled_factor:\
        return &context->style.combo.button.disabled_factor;\
    case nonnk_style_comboXbuttonXcolor_factor_text:\
        return &context->style.combo.button.color_factor_text;\
    case nonnk_style_tabXcolor_factor:\
        return &context->style.tab.color_factor;\
    case nonnk_style_tabXdisabled_factor:\
        return &context->style.tab.disabled_factor;\
    case nonnk_style_tabXtab_minimize_buttonXcolor_factor_background:\
        return &context->style.tab.tab_minimize_button.color_factor_background;\
    case nonnk_style_tabXtab_minimize_buttonXdisabled_factor:\
        return &context->style.tab.tab_minimize_button.disabled_factor;\
    case nonnk_style_tabXtab_minimize_buttonXcolor_factor_text:\
        return &context->style.tab.tab_minimize_button.color_factor_text;\
    case nonnk_style_tabXtab_maximize_buttonXcolor_factor_background:\
        return &context->style.tab.tab_maximize_button.color_factor_background;\
    case nonnk_style_tabXtab_maximize_buttonXdisabled_factor:\
        return &context->style.tab.tab_maximize_button.disabled_factor;\
    case nonnk_style_tabXtab_maximize_buttonXcolor_factor_text:\
        return &context->style.tab.tab_maximize_button.color_factor_text;\
    case nonnk_style_tabXnode_minimize_buttonXcolor_factor_background:\
        return &context->style.tab.node_minimize_button.color_factor_background;\
    case nonnk_style_tabXnode_minimize_buttonXdisabled_factor:\
        return &context->style.tab.node_minimize_button.disabled_factor;\
    case nonnk_style_tabXnode_minimize_buttonXcolor_factor_text:\
        return &context->style.tab.node_minimize_button.color_factor_text;\
    case nonnk_style_tabXnode_maximize_buttonXcolor_factor_background:\
        return &context->style.tab.node_maximize_button.color_factor_background;\
    case nonnk_style_tabXnode_maximize_buttonXdisabled_factor:\
        return &context->style.tab.node_maximize_button.disabled_factor;\
    case nonnk_style_tabXnode_maximize_buttonXcolor_factor_text:\
        return &context->style.tab.node_maximize_button.color_factor_text;\
    case nonnk_style_windowXheaderXclose_buttonXcolor_factor_background:\
        return &context->style.window.header.close_button.color_factor_background;\
    case nonnk_style_windowXheaderXclose_buttonXdisabled_factor:\
        return &context->style.window.header.close_button.disabled_factor;\
    case nonnk_style_windowXheaderXclose_buttonXcolor_factor_text:\
        return &context->style.window.header.close_button.color_factor_text;\
    case nonnk_style_windowXheaderXminimize_buttonXcolor_factor_background:\
        return &context->style.window.header.minimize_button.color_factor_background;\
    case nonnk_style_windowXheaderXminimize_buttonXdisabled_factor:\
        return &context->style.window.header.minimize_button.disabled_factor;\
    case nonnk_style_windowXheaderXminimize_buttonXcolor_factor_text:\
        return &context->style.window.header.minimize_button.color_factor_text;\

#define CASE_NONNK_STYLE_VEC2 \
    case nonnk_style_textXpadding:\
            return &context->style.text.padding; \
    case nonnk_style_buttonXpadding:\
            return &context->style.button.padding; \
    case nonnk_style_buttonXimage_padding:\
            return &context->style.button.image_padding; \
    case nonnk_style_buttonXtouch_padding:\
            return &context->style.button.touch_padding; \
    case nonnk_style_contextual_buttonXpadding:\
            return &context->style.contextual_button.padding; \
    case nonnk_style_contextual_buttonXtouch_padding:\
            return &context->style.contextual_button.touch_padding; \
    case nonnk_style_menu_buttonXpadding:\
            return &context->style.menu_button.padding; \
    case nonnk_style_menu_buttonXtouch_padding:\
            return &context->style.menu_button.touch_padding; \
    case nonnk_style_checkboxXpadding:\
            return &context->style.checkbox.padding; \
    case nonnk_style_checkboxXtouch_padding:\
            return &context->style.checkbox.touch_padding; \
    case nonnk_style_optionXpadding:\
            return &context->style.option.padding; \
    case nonnk_style_optionXtouch_padding:\
            return &context->style.option.touch_padding; \
    case nonnk_style_selectableXpadding:\
            return &context->style.selectable.padding; \
    case nonnk_style_selectableXtouch_padding:\
            return &context->style.selectable.touch_padding; \
    case nonnk_style_sliderXcursor_size:\
            return &context->style.slider.cursor_size; \
    case nonnk_style_sliderXpadding:\
            return &context->style.slider.padding; \
    case nonnk_style_sliderXspacing:\
            return &context->style.slider.spacing; \
    case nonnk_style_sliderXinc_buttonXpadding:\
            return &context->style.slider.inc_button.padding; \
    case nonnk_style_sliderXinc_buttonXtouch_padding:\
            return &context->style.slider.inc_button.touch_padding; \
    case nonnk_style_sliderXdec_buttonXpadding:\
            return &context->style.slider.dec_button.padding; \
    case nonnk_style_sliderXdec_buttonXtouch_padding:\
            return &context->style.slider.dec_button.touch_padding; \
    case nonnk_style_progressXpadding:\
            return &context->style.progress.padding; \
    case nonnk_style_scrollhXpadding:\
            return &context->style.scrollh.padding; \
    case nonnk_style_scrollvXpadding:\
            return &context->style.scrollv.padding; \
    case nonnk_style_scrollhXinc_buttonXpadding:\
            return &context->style.scrollh.inc_button.padding; \
    case nonnk_style_scrollhXinc_buttonXtouch_padding:\
            return &context->style.scrollh.inc_button.touch_padding; \
    case nonnk_style_scrollhXdec_buttonXpadding:\
            return &context->style.scrollh.dec_button.padding; \
    case nonnk_style_scrollhXdec_buttonXtouch_padding:\
            return &context->style.scrollh.dec_button.touch_padding; \
    case nonnk_style_scrollvXinc_buttonXpadding:\
            return &context->style.scrollv.inc_button.padding; \
    case nonnk_style_scrollvXinc_buttonXtouch_padding:\
            return &context->style.scrollv.inc_button.touch_padding; \
    case nonnk_style_scrollvXdec_buttonXpadding:\
            return &context->style.scrollv.dec_button.padding; \
    case nonnk_style_scrollvXdec_buttonXtouch_padding:\
            return &context->style.scrollv.dec_button.touch_padding; \
    case nonnk_style_editXscrollbar_size:\
            return &context->style.edit.scrollbar_size; \
    case nonnk_style_editXpadding:\
            return &context->style.edit.padding; \
    case nonnk_style_editXscrollbarXpadding:\
            return &context->style.edit.scrollbar.padding; \
    case nonnk_style_editXscrollbarXinc_buttonXpadding:\
            return &context->style.edit.scrollbar.inc_button.padding; \
    case nonnk_style_editXscrollbarXinc_buttonXtouch_padding:\
            return &context->style.edit.scrollbar.inc_button.touch_padding; \
    case nonnk_style_editXscrollbarXdec_buttonXpadding:\
            return &context->style.edit.scrollbar.dec_button.padding; \
    case nonnk_style_editXscrollbarXdec_buttonXtouch_padding:\
            return &context->style.edit.scrollbar.dec_button.touch_padding; \
    case nonnk_style_propertyXpadding:\
            return &context->style.property.padding; \
    case nonnk_style_propertyXdec_buttonXpadding:\
            return &context->style.property.dec_button.padding; \
    case nonnk_style_propertyXdec_buttonXtouch_padding:\
            return &context->style.property.dec_button.touch_padding; \
    case nonnk_style_propertyXinc_buttonXpadding:\
            return &context->style.property.inc_button.padding; \
    case nonnk_style_propertyXinc_buttonXtouch_padding:\
            return &context->style.property.inc_button.touch_padding; \
    case nonnk_style_propertyXeditXpadding:\
            return &context->style.property.edit.padding; \
    case nonnk_style_chartXpadding:\
            return &context->style.chart.padding; \
    case nonnk_style_comboXcontent_padding:\
            return &context->style.combo.content_padding; \
    case nonnk_style_comboXbutton_padding:\
            return &context->style.combo.button_padding; \
    case nonnk_style_comboXspacing:\
            return &context->style.combo.spacing; \
    case nonnk_style_comboXbuttonXpadding:\
            return &context->style.combo.button.padding; \
    case nonnk_style_comboXbuttonXtouch_padding:\
            return &context->style.combo.button.touch_padding; \
    case nonnk_style_tabXpadding:\
            return &context->style.tab.padding; \
    case nonnk_style_tabXspacing:\
            return &context->style.tab.spacing; \
    case nonnk_style_tabXtab_minimize_buttonXpadding:\
            return &context->style.tab.tab_minimize_button.padding; \
    case nonnk_style_tabXtab_minimize_buttonXtouch_padding:\
            return &context->style.tab.tab_minimize_button.touch_padding; \
    case nonnk_style_tabXtab_maximize_buttonXpadding:\
            return &context->style.tab.tab_maximize_button.padding; \
    case nonnk_style_tabXtab_maximize_buttonXtouch_padding:\
            return &context->style.tab.tab_maximize_button.touch_padding; \
    case nonnk_style_tabXnode_minimize_buttonXpadding:\
            return &context->style.tab.node_minimize_button.padding; \
    case nonnk_style_tabXnode_minimize_buttonXtouch_padding:\
            return &context->style.tab.node_minimize_button.touch_padding; \
    case nonnk_style_tabXnode_maximize_buttonXpadding:\
            return &context->style.tab.node_maximize_button.padding; \
    case nonnk_style_tabXnode_maximize_buttonXtouch_padding:\
            return &context->style.tab.node_maximize_button.touch_padding; \
    case nonnk_style_windowXheaderXlabel_padding:\
            return &context->style.window.header.label_padding; \
    case nonnk_style_windowXheaderXpadding:\
            return &context->style.window.header.padding; \
    case nonnk_style_windowXheaderXspacing:\
            return &context->style.window.header.spacing; \
    case nonnk_style_windowXheaderXclose_buttonXpadding:\
            return &context->style.window.header.close_button.padding; \
    case nonnk_style_windowXheaderXclose_buttonXtouch_padding:\
            return &context->style.window.header.close_button.touch_padding; \
    case nonnk_style_windowXheaderXminimize_buttonXpadding:\
            return &context->style.window.header.minimize_button.padding; \
    case nonnk_style_windowXheaderXminimize_buttonXtouch_padding:\
            return &context->style.window.header.minimize_button.touch_padding; \
    case nonnk_style_windowXspacing:\
            return &context->style.window.spacing; \
    case nonnk_style_windowXscrollbar_size:\
            return &context->style.window.scrollbar_size; \
    case nonnk_style_windowXmin_size:\
            return &context->style.window.min_size; \
    case nonnk_style_windowXpadding:\
            return &context->style.window.padding; \
    case nonnk_style_windowXgroup_padding:\
            return &context->style.window.group_padding; \
    case nonnk_style_windowXpopup_padding:\
            return &context->style.window.popup_padding; \
    case nonnk_style_windowXcombo_padding:\
            return &context->style.window.combo_padding; \
    case nonnk_style_windowXcontextual_padding:\
            return &context->style.window.contextual_padding; \
    case nonnk_style_windowXmenu_padding:\
            return &context->style.window.menu_padding; \
    case nonnk_style_windowXtooltip_padding:\
            return &context->style.window.tooltip_padding; \

#define CASE_NONNK_STYLE_FLAGS \
    case nonnk_style_buttonXtext_alignment:\
            return &context->style.button.text_alignment; \
    case nonnk_style_contextual_buttonXtext_alignment:\
            return &context->style.contextual_button.text_alignment; \
    case nonnk_style_menu_buttonXtext_alignment:\
            return &context->style.menu_button.text_alignment; \
    case nonnk_style_sliderXinc_buttonXtext_alignment:\
            return &context->style.slider.inc_button.text_alignment; \
    case nonnk_style_sliderXdec_buttonXtext_alignment:\
            return &context->style.slider.dec_button.text_alignment; \
    case nonnk_style_scrollhXinc_buttonXtext_alignment:\
            return &context->style.scrollh.inc_button.text_alignment; \
    case nonnk_style_scrollhXdec_buttonXtext_alignment:\
            return &context->style.scrollh.dec_button.text_alignment; \
    case nonnk_style_scrollvXinc_buttonXtext_alignment:\
            return &context->style.scrollv.inc_button.text_alignment; \
    case nonnk_style_scrollvXdec_buttonXtext_alignment:\
            return &context->style.scrollv.dec_button.text_alignment; \
    case nonnk_style_editXscrollbarXinc_buttonXtext_alignment:\
            return &context->style.edit.scrollbar.inc_button.text_alignment; \
    case nonnk_style_editXscrollbarXdec_buttonXtext_alignment:\
            return &context->style.edit.scrollbar.dec_button.text_alignment; \
    case nonnk_style_propertyXdec_buttonXtext_alignment:\
            return &context->style.property.dec_button.text_alignment; \
    case nonnk_style_propertyXinc_buttonXtext_alignment:\
            return &context->style.property.inc_button.text_alignment; \
    case nonnk_style_comboXbuttonXtext_alignment:\
            return &context->style.combo.button.text_alignment; \
    case nonnk_style_tabXtab_minimize_buttonXtext_alignment:\
            return &context->style.tab.tab_minimize_button.text_alignment; \
    case nonnk_style_tabXtab_maximize_buttonXtext_alignment:\
            return &context->style.tab.tab_maximize_button.text_alignment; \
    case nonnk_style_tabXnode_minimize_buttonXtext_alignment:\
            return &context->style.tab.node_minimize_button.text_alignment; \
    case nonnk_style_tabXnode_maximize_buttonXtext_alignment:\
            return &context->style.tab.node_maximize_button.text_alignment; \
    case nonnk_style_windowXheaderXclose_buttonXtext_alignment:\
            return &context->style.window.header.close_button.text_alignment; \
    case nonnk_style_windowXheaderXminimize_buttonXtext_alignment:\
            return &context->style.window.header.minimize_button.text_alignment; \
    case nonnk_style_windowXheaderXalign:\
            return (nk_flags*)&context->style.window.header.align;\

#define CASE_NONNK_STYLE_COLOR \
    case nonnk_style_textXcolor:\
            return &context->style.text.color; \
    case nonnk_style_buttonXborder_color:\
            return &context->style.button.border_color; \
    case nonnk_style_buttonXtext_background:\
            return &context->style.button.text_background; \
    case nonnk_style_buttonXtext_normal:\
            return &context->style.button.text_normal; \
    case nonnk_style_buttonXtext_hover:\
            return &context->style.button.text_hover; \
    case nonnk_style_buttonXtext_active:\
            return &context->style.button.text_active; \
    case nonnk_style_contextual_buttonXborder_color:\
            return &context->style.contextual_button.border_color; \
    case nonnk_style_contextual_buttonXtext_background:\
            return &context->style.contextual_button.text_background; \
    case nonnk_style_contextual_buttonXtext_normal:\
            return &context->style.contextual_button.text_normal; \
    case nonnk_style_contextual_buttonXtext_hover:\
            return &context->style.contextual_button.text_hover; \
    case nonnk_style_contextual_buttonXtext_active:\
            return &context->style.contextual_button.text_active; \
    case nonnk_style_menu_buttonXborder_color:\
            return &context->style.menu_button.border_color; \
    case nonnk_style_menu_buttonXtext_background:\
            return &context->style.menu_button.text_background; \
    case nonnk_style_menu_buttonXtext_normal:\
            return &context->style.menu_button.text_normal; \
    case nonnk_style_menu_buttonXtext_hover:\
            return &context->style.menu_button.text_hover; \
    case nonnk_style_menu_buttonXtext_active:\
            return &context->style.menu_button.text_active; \
    case nonnk_style_checkboxXtext_background:\
            return &context->style.checkbox.text_background; \
    case nonnk_style_checkboxXtext_normal:\
            return &context->style.checkbox.text_normal; \
    case nonnk_style_checkboxXtext_hover:\
            return &context->style.checkbox.text_hover; \
    case nonnk_style_checkboxXtext_active:\
            return &context->style.checkbox.text_active; \
    case nonnk_style_checkboxXborder_color:\
            return &context->style.checkbox.border_color; \
    case nonnk_style_optionXtext_background:\
            return &context->style.option.text_background; \
    case nonnk_style_optionXtext_normal:\
            return &context->style.option.text_normal; \
    case nonnk_style_optionXtext_hover:\
            return &context->style.option.text_hover; \
    case nonnk_style_optionXtext_active:\
            return &context->style.option.text_active; \
    case nonnk_style_optionXborder_color:\
            return &context->style.option.border_color; \
    case nonnk_style_selectableXtext_normal:\
            return &context->style.selectable.text_normal; \
    case nonnk_style_selectableXtext_hover:\
            return &context->style.selectable.text_hover; \
    case nonnk_style_selectableXtext_pressed:\
            return &context->style.selectable.text_pressed; \
    case nonnk_style_selectableXtext_normal_active:\
            return &context->style.selectable.text_normal_active; \
    case nonnk_style_selectableXtext_hover_active:\
            return &context->style.selectable.text_hover_active; \
    case nonnk_style_selectableXtext_pressed_active:\
            return &context->style.selectable.text_pressed_active; \
    case nonnk_style_sliderXbar_normal:\
            return &context->style.slider.bar_normal; \
    case nonnk_style_sliderXbar_hover:\
            return &context->style.slider.bar_hover; \
    case nonnk_style_sliderXbar_active:\
            return &context->style.slider.bar_active; \
    case nonnk_style_sliderXbar_filled:\
            return &context->style.slider.bar_filled; \
    case nonnk_style_sliderXinc_buttonXborder_color:\
            return &context->style.slider.inc_button.border_color; \
    case nonnk_style_sliderXinc_buttonXtext_background:\
            return &context->style.slider.inc_button.text_background; \
    case nonnk_style_sliderXinc_buttonXtext_normal:\
            return &context->style.slider.inc_button.text_normal; \
    case nonnk_style_sliderXinc_buttonXtext_hover:\
            return &context->style.slider.inc_button.text_hover; \
    case nonnk_style_sliderXinc_buttonXtext_active:\
            return &context->style.slider.inc_button.text_active; \
    case nonnk_style_sliderXdec_buttonXborder_color:\
            return &context->style.slider.dec_button.border_color; \
    case nonnk_style_sliderXdec_buttonXtext_background:\
            return &context->style.slider.dec_button.text_background; \
    case nonnk_style_sliderXdec_buttonXtext_normal:\
            return &context->style.slider.dec_button.text_normal; \
    case nonnk_style_sliderXdec_buttonXtext_hover:\
            return &context->style.slider.dec_button.text_hover; \
    case nonnk_style_sliderXdec_buttonXtext_active:\
            return &context->style.slider.dec_button.text_active; \
    case nonnk_style_progressXborder_color:\
            return &context->style.progress.border_color; \
    case nonnk_style_progressXcursor_border_color:\
            return &context->style.progress.cursor_border_color; \
    case nonnk_style_scrollhXborder_color:\
            return &context->style.scrollh.border_color; \
    case nonnk_style_scrollhXcursor_border_color:\
            return &context->style.scrollh.cursor_border_color; \
    case nonnk_style_scrollvXborder_color:\
            return &context->style.scrollv.border_color; \
    case nonnk_style_scrollvXcursor_border_color:\
            return &context->style.scrollv.cursor_border_color; \
    case nonnk_style_scrollhXinc_buttonXborder_color:\
            return &context->style.scrollh.inc_button.border_color; \
    case nonnk_style_scrollhXinc_buttonXtext_background:\
            return &context->style.scrollh.inc_button.text_background; \
    case nonnk_style_scrollhXinc_buttonXtext_normal:\
            return &context->style.scrollh.inc_button.text_normal; \
    case nonnk_style_scrollhXinc_buttonXtext_hover:\
            return &context->style.scrollh.inc_button.text_hover; \
    case nonnk_style_scrollhXinc_buttonXtext_active:\
            return &context->style.scrollh.inc_button.text_active; \
    case nonnk_style_scrollhXdec_buttonXborder_color:\
            return &context->style.scrollh.dec_button.border_color; \
    case nonnk_style_scrollhXdec_buttonXtext_background:\
            return &context->style.scrollh.dec_button.text_background; \
    case nonnk_style_scrollhXdec_buttonXtext_normal:\
            return &context->style.scrollh.dec_button.text_normal; \
    case nonnk_style_scrollhXdec_buttonXtext_hover:\
            return &context->style.scrollh.dec_button.text_hover; \
    case nonnk_style_scrollhXdec_buttonXtext_active:\
            return &context->style.scrollh.dec_button.text_active; \
    case nonnk_style_scrollvXinc_buttonXborder_color:\
            return &context->style.scrollv.inc_button.border_color; \
    case nonnk_style_scrollvXinc_buttonXtext_background:\
            return &context->style.scrollv.inc_button.text_background; \
    case nonnk_style_scrollvXinc_buttonXtext_normal:\
            return &context->style.scrollv.inc_button.text_normal; \
    case nonnk_style_scrollvXinc_buttonXtext_hover:\
            return &context->style.scrollv.inc_button.text_hover; \
    case nonnk_style_scrollvXinc_buttonXtext_active:\
            return &context->style.scrollv.inc_button.text_active; \
    case nonnk_style_scrollvXdec_buttonXborder_color:\
            return &context->style.scrollv.dec_button.border_color; \
    case nonnk_style_scrollvXdec_buttonXtext_background:\
            return &context->style.scrollv.dec_button.text_background; \
    case nonnk_style_scrollvXdec_buttonXtext_normal:\
            return &context->style.scrollv.dec_button.text_normal; \
    case nonnk_style_scrollvXdec_buttonXtext_hover:\
            return &context->style.scrollv.dec_button.text_hover; \
    case nonnk_style_scrollvXdec_buttonXtext_active:\
            return &context->style.scrollv.dec_button.text_active; \
    case nonnk_style_editXcursor_normal:\
            return &context->style.edit.cursor_normal; \
    case nonnk_style_editXcursor_hover:\
            return &context->style.edit.cursor_hover; \
    case nonnk_style_editXcursor_text_normal:\
            return &context->style.edit.cursor_text_normal; \
    case nonnk_style_editXcursor_text_hover:\
            return &context->style.edit.cursor_text_hover; \
    case nonnk_style_editXborder_color:\
            return &context->style.edit.border_color; \
    case nonnk_style_editXtext_normal:\
            return &context->style.edit.text_normal; \
    case nonnk_style_editXtext_hover:\
            return &context->style.edit.text_hover; \
    case nonnk_style_editXtext_active:\
            return &context->style.edit.text_active; \
    case nonnk_style_editXselected_normal:\
            return &context->style.edit.selected_normal; \
    case nonnk_style_editXselected_hover:\
            return &context->style.edit.selected_hover; \
    case nonnk_style_editXselected_text_normal:\
            return &context->style.edit.selected_text_normal; \
    case nonnk_style_editXselected_text_hover:\
            return &context->style.edit.selected_text_hover; \
    case nonnk_style_editXscrollbarXborder_color:\
            return &context->style.edit.scrollbar.border_color; \
    case nonnk_style_editXscrollbarXcursor_border_color:\
            return &context->style.edit.scrollbar.cursor_border_color; \
    case nonnk_style_editXscrollbarXinc_buttonXborder_color:\
            return &context->style.edit.scrollbar.inc_button.border_color; \
    case nonnk_style_editXscrollbarXinc_buttonXtext_background:\
            return &context->style.edit.scrollbar.inc_button.text_background; \
    case nonnk_style_editXscrollbarXinc_buttonXtext_normal:\
            return &context->style.edit.scrollbar.inc_button.text_normal; \
    case nonnk_style_editXscrollbarXinc_buttonXtext_hover:\
            return &context->style.edit.scrollbar.inc_button.text_hover; \
    case nonnk_style_editXscrollbarXinc_buttonXtext_active:\
            return &context->style.edit.scrollbar.inc_button.text_active; \
    case nonnk_style_editXscrollbarXdec_buttonXborder_color:\
            return &context->style.edit.scrollbar.dec_button.border_color; \
    case nonnk_style_editXscrollbarXdec_buttonXtext_background:\
            return &context->style.edit.scrollbar.dec_button.text_background; \
    case nonnk_style_editXscrollbarXdec_buttonXtext_normal:\
            return &context->style.edit.scrollbar.dec_button.text_normal; \
    case nonnk_style_editXscrollbarXdec_buttonXtext_hover:\
            return &context->style.edit.scrollbar.dec_button.text_hover; \
    case nonnk_style_editXscrollbarXdec_buttonXtext_active:\
            return &context->style.edit.scrollbar.dec_button.text_active; \
    case nonnk_style_propertyXborder_color:\
            return &context->style.property.border_color; \
    case nonnk_style_propertyXlabel_normal:\
            return &context->style.property.label_normal; \
    case nonnk_style_propertyXlabel_hover:\
            return &context->style.property.label_hover; \
    case nonnk_style_propertyXlabel_active:\
            return &context->style.property.label_active; \
    case nonnk_style_propertyXdec_buttonXborder_color:\
            return &context->style.property.dec_button.border_color; \
    case nonnk_style_propertyXdec_buttonXtext_background:\
            return &context->style.property.dec_button.text_background; \
    case nonnk_style_propertyXdec_buttonXtext_normal:\
            return &context->style.property.dec_button.text_normal; \
    case nonnk_style_propertyXdec_buttonXtext_hover:\
            return &context->style.property.dec_button.text_hover; \
    case nonnk_style_propertyXdec_buttonXtext_active:\
            return &context->style.property.dec_button.text_active; \
    case nonnk_style_propertyXinc_buttonXborder_color:\
            return &context->style.property.inc_button.border_color; \
    case nonnk_style_propertyXinc_buttonXtext_background:\
            return &context->style.property.inc_button.text_background; \
    case nonnk_style_propertyXinc_buttonXtext_normal:\
            return &context->style.property.inc_button.text_normal; \
    case nonnk_style_propertyXinc_buttonXtext_hover:\
            return &context->style.property.inc_button.text_hover; \
    case nonnk_style_propertyXinc_buttonXtext_active:\
            return &context->style.property.inc_button.text_active; \
    case nonnk_style_propertyXeditXborder_color:\
            return &context->style.property.edit.border_color; \
    case nonnk_style_propertyXeditXcursor_normal:\
            return &context->style.property.edit.cursor_normal; \
    case nonnk_style_propertyXeditXcursor_hover:\
            return &context->style.property.edit.cursor_hover; \
    case nonnk_style_propertyXeditXcursor_text_normal:\
            return &context->style.property.edit.cursor_text_normal; \
    case nonnk_style_propertyXeditXcursor_text_hover:\
            return &context->style.property.edit.cursor_text_hover; \
    case nonnk_style_propertyXeditXtext_normal:\
            return &context->style.property.edit.text_normal; \
    case nonnk_style_propertyXeditXtext_hover:\
            return &context->style.property.edit.text_hover; \
    case nonnk_style_propertyXeditXtext_active:\
            return &context->style.property.edit.text_active; \
    case nonnk_style_propertyXeditXselected_normal:\
            return &context->style.property.edit.selected_normal; \
    case nonnk_style_propertyXeditXselected_hover:\
            return &context->style.property.edit.selected_hover; \
    case nonnk_style_propertyXeditXselected_text_normal:\
            return &context->style.property.edit.selected_text_normal; \
    case nonnk_style_propertyXeditXselected_text_hover:\
            return &context->style.property.edit.selected_text_hover; \
    case nonnk_style_chartXborder_color:\
            return &context->style.chart.border_color; \
    case nonnk_style_chartXselected_color:\
            return &context->style.chart.selected_color; \
    case nonnk_style_chartXcolor:\
            return &context->style.chart.color; \
    case nonnk_style_comboXborder_color:\
            return &context->style.combo.border_color; \
    case nonnk_style_comboXlabel_normal:\
            return &context->style.combo.label_normal; \
    case nonnk_style_comboXlabel_hover:\
            return &context->style.combo.label_hover; \
    case nonnk_style_comboXlabel_active:\
            return &context->style.combo.label_active; \
    case nonnk_style_comboXbuttonXborder_color:\
            return &context->style.combo.button.border_color; \
    case nonnk_style_comboXbuttonXtext_background:\
            return &context->style.combo.button.text_background; \
    case nonnk_style_comboXbuttonXtext_normal:\
            return &context->style.combo.button.text_normal; \
    case nonnk_style_comboXbuttonXtext_hover:\
            return &context->style.combo.button.text_hover; \
    case nonnk_style_comboXbuttonXtext_active:\
            return &context->style.combo.button.text_active; \
    case nonnk_style_tabXborder_color:\
            return &context->style.tab.border_color; \
    case nonnk_style_tabXtext:\
            return &context->style.tab.text; \
    case nonnk_style_tabXtab_minimize_buttonXborder_color:\
            return &context->style.tab.tab_minimize_button.border_color; \
    case nonnk_style_tabXtab_minimize_buttonXtext_background:\
            return &context->style.tab.tab_minimize_button.text_background; \
    case nonnk_style_tabXtab_minimize_buttonXtext_normal:\
            return &context->style.tab.tab_minimize_button.text_normal; \
    case nonnk_style_tabXtab_minimize_buttonXtext_hover:\
            return &context->style.tab.tab_minimize_button.text_hover; \
    case nonnk_style_tabXtab_minimize_buttonXtext_active:\
            return &context->style.tab.tab_minimize_button.text_active; \
    case nonnk_style_tabXtab_maximize_buttonXborder_color:\
            return &context->style.tab.tab_maximize_button.border_color; \
    case nonnk_style_tabXtab_maximize_buttonXtext_background:\
            return &context->style.tab.tab_maximize_button.text_background; \
    case nonnk_style_tabXtab_maximize_buttonXtext_normal:\
            return &context->style.tab.tab_maximize_button.text_normal; \
    case nonnk_style_tabXtab_maximize_buttonXtext_hover:\
            return &context->style.tab.tab_maximize_button.text_hover; \
    case nonnk_style_tabXtab_maximize_buttonXtext_active:\
            return &context->style.tab.tab_maximize_button.text_active; \
    case nonnk_style_tabXnode_minimize_buttonXborder_color:\
            return &context->style.tab.node_minimize_button.border_color; \
    case nonnk_style_tabXnode_minimize_buttonXtext_background:\
            return &context->style.tab.node_minimize_button.text_background; \
    case nonnk_style_tabXnode_minimize_buttonXtext_normal:\
            return &context->style.tab.node_minimize_button.text_normal; \
    case nonnk_style_tabXnode_minimize_buttonXtext_hover:\
            return &context->style.tab.node_minimize_button.text_hover; \
    case nonnk_style_tabXnode_minimize_buttonXtext_active:\
            return &context->style.tab.node_minimize_button.text_active; \
    case nonnk_style_tabXnode_maximize_buttonXborder_color:\
            return &context->style.tab.node_maximize_button.border_color; \
    case nonnk_style_tabXnode_maximize_buttonXtext_background:\
            return &context->style.tab.node_maximize_button.text_background; \
    case nonnk_style_tabXnode_maximize_buttonXtext_normal:\
            return &context->style.tab.node_maximize_button.text_normal; \
    case nonnk_style_tabXnode_maximize_buttonXtext_hover:\
            return &context->style.tab.node_maximize_button.text_hover; \
    case nonnk_style_tabXnode_maximize_buttonXtext_active:\
            return &context->style.tab.node_maximize_button.text_active; \
    case nonnk_style_windowXheaderXlabel_normal:\
            return &context->style.window.header.label_normal; \
    case nonnk_style_windowXheaderXlabel_hover:\
            return &context->style.window.header.label_hover; \
    case nonnk_style_windowXheaderXlabel_active:\
            return &context->style.window.header.label_active; \
    case nonnk_style_windowXheaderXclose_buttonXborder_color:\
            return &context->style.window.header.close_button.border_color; \
    case nonnk_style_windowXheaderXclose_buttonXtext_background:\
            return &context->style.window.header.close_button.text_background; \
    case nonnk_style_windowXheaderXclose_buttonXtext_normal:\
            return &context->style.window.header.close_button.text_normal; \
    case nonnk_style_windowXheaderXclose_buttonXtext_hover:\
            return &context->style.window.header.close_button.text_hover; \
    case nonnk_style_windowXheaderXclose_buttonXtext_active:\
            return &context->style.window.header.close_button.text_active; \
    case nonnk_style_windowXheaderXminimize_buttonXborder_color:\
            return &context->style.window.header.minimize_button.border_color; \
    case nonnk_style_windowXheaderXminimize_buttonXtext_background:\
            return &context->style.window.header.minimize_button.text_background; \
    case nonnk_style_windowXheaderXminimize_buttonXtext_normal:\
            return &context->style.window.header.minimize_button.text_normal; \
    case nonnk_style_windowXheaderXminimize_buttonXtext_hover:\
            return &context->style.window.header.minimize_button.text_hover; \
    case nonnk_style_windowXheaderXminimize_buttonXtext_active:\
            return &context->style.window.header.minimize_button.text_active; \
    case nonnk_style_windowXbackground:\
            return &context->style.window.background; \
    case nonnk_style_windowXborder_color:\
            return &context->style.window.border_color; \
    case nonnk_style_windowXpopup_border_color:\
            return &context->style.window.popup_border_color; \
    case nonnk_style_windowXcombo_border_color:\
            return &context->style.window.combo_border_color; \
    case nonnk_style_windowXcontextual_border_color:\
            return &context->style.window.contextual_border_color; \
    case nonnk_style_windowXmenu_border_color:\
            return &context->style.window.menu_border_color; \
    case nonnk_style_windowXgroup_border_color:\
            return &context->style.window.group_border_color; \
    case nonnk_style_windowXtooltip_border_color:\
            return &context->style.window.tooltip_border_color; \


#define CASE_NONNK_STYLE_ITEM   \
    case nonnk_style_buttonXnormal:\
            return &context->style.button.normal; \
    case nonnk_style_buttonXhover:\
            return &context->style.button.hover; \
    case nonnk_style_buttonXactive:\
            return &context->style.button.active; \
    case nonnk_style_contextual_buttonXnormal:\
            return &context->style.contextual_button.normal; \
    case nonnk_style_contextual_buttonXhover:\
            return &context->style.contextual_button.hover; \
    case nonnk_style_contextual_buttonXactive:\
            return &context->style.contextual_button.active; \
    case nonnk_style_menu_buttonXnormal:\
            return &context->style.menu_button.normal; \
    case nonnk_style_menu_buttonXhover:\
            return &context->style.menu_button.hover; \
    case nonnk_style_menu_buttonXactive:\
            return &context->style.menu_button.active; \
    case nonnk_style_checkboxXnormal:\
            return &context->style.checkbox.normal; \
    case nonnk_style_checkboxXhover:\
            return &context->style.checkbox.hover; \
    case nonnk_style_checkboxXactive:\
            return &context->style.checkbox.active; \
    case nonnk_style_checkboxXcursor_normal:\
            return &context->style.checkbox.cursor_normal; \
    case nonnk_style_checkboxXcursor_hover:\
            return &context->style.checkbox.cursor_hover; \
    case nonnk_style_optionXnormal:\
            return &context->style.option.normal; \
    case nonnk_style_optionXhover:\
            return &context->style.option.hover; \
    case nonnk_style_optionXactive:\
            return &context->style.option.active; \
    case nonnk_style_optionXcursor_normal:\
            return &context->style.option.cursor_normal; \
    case nonnk_style_optionXcursor_hover:\
            return &context->style.option.cursor_hover; \
    case nonnk_style_selectableXnormal:\
            return &context->style.selectable.normal; \
    case nonnk_style_selectableXhover:\
            return &context->style.selectable.hover; \
    case nonnk_style_selectableXpressed:\
            return &context->style.selectable.pressed; \
    case nonnk_style_selectableXnormal_active:\
            return &context->style.selectable.normal_active; \
    case nonnk_style_selectableXhover_active:\
            return &context->style.selectable.hover_active; \
    case nonnk_style_selectableXpressed_active:\
            return &context->style.selectable.pressed_active; \
    case nonnk_style_sliderXnormal:\
            return &context->style.slider.normal; \
    case nonnk_style_sliderXhover:\
            return &context->style.slider.hover; \
    case nonnk_style_sliderXactive:\
            return &context->style.slider.active; \
    case nonnk_style_sliderXcursor_normal:\
            return &context->style.slider.cursor_normal; \
    case nonnk_style_sliderXcursor_hover:\
            return &context->style.slider.cursor_hover; \
    case nonnk_style_sliderXcursor_active:\
            return &context->style.slider.cursor_active; \
    case nonnk_style_sliderXinc_buttonXnormal:\
            return &context->style.slider.inc_button.normal; \
    case nonnk_style_sliderXinc_buttonXhover:\
            return &context->style.slider.inc_button.hover; \
    case nonnk_style_sliderXinc_buttonXactive:\
            return &context->style.slider.inc_button.active; \
    case nonnk_style_sliderXdec_buttonXnormal:\
            return &context->style.slider.dec_button.normal; \
    case nonnk_style_sliderXdec_buttonXhover:\
            return &context->style.slider.dec_button.hover; \
    case nonnk_style_sliderXdec_buttonXactive:\
            return &context->style.slider.dec_button.active; \
    case nonnk_style_progressXnormal:\
            return &context->style.progress.normal; \
    case nonnk_style_progressXhover:\
            return &context->style.progress.hover; \
    case nonnk_style_progressXactive:\
            return &context->style.progress.active; \
    case nonnk_style_progressXcursor_normal:\
            return &context->style.progress.cursor_normal; \
    case nonnk_style_progressXcursor_hover:\
            return &context->style.progress.cursor_hover; \
    case nonnk_style_progressXcursor_active:\
            return &context->style.progress.cursor_active; \
    case nonnk_style_scrollhXnormal:\
            return &context->style.scrollh.normal; \
    case nonnk_style_scrollhXhover:\
            return &context->style.scrollh.hover; \
    case nonnk_style_scrollhXactive:\
            return &context->style.scrollh.active; \
    case nonnk_style_scrollhXcursor_normal:\
            return &context->style.scrollh.cursor_normal; \
    case nonnk_style_scrollhXcursor_hover:\
            return &context->style.scrollh.cursor_hover; \
    case nonnk_style_scrollhXcursor_active:\
            return &context->style.scrollh.cursor_active;\
    case nonnk_style_scrollvXnormal:\
            return &context->style.scrollv.normal;\
    case nonnk_style_scrollvXhover:\
            return &context->style.scrollv.hover;\
    case nonnk_style_scrollvXactive:\
            return &context->style.scrollv.active;\
    case nonnk_style_scrollvXcursor_normal:\
            return &context->style.scrollv.cursor_normal;\
    case nonnk_style_scrollvXcursor_hover:\
            return &context->style.scrollv.cursor_hover;\
    case nonnk_style_scrollvXcursor_active:\
            return &context->style.scrollv.cursor_active;\
    case nonnk_style_scrollhXinc_buttonXnormal:\
            return &context->style.scrollh.inc_button.normal;\
    case nonnk_style_scrollhXinc_buttonXhover:\
            return &context->style.scrollh.inc_button.hover;\
    case nonnk_style_scrollhXinc_buttonXactive:\
            return &context->style.scrollh.inc_button.active;\
    case nonnk_style_scrollhXdec_buttonXnormal:\
            return &context->style.scrollh.dec_button.normal;\
    case nonnk_style_scrollhXdec_buttonXhover:\
            return &context->style.scrollh.dec_button.hover;\
    case nonnk_style_scrollhXdec_buttonXactive:\
            return &context->style.scrollh.dec_button.active;\
    case nonnk_style_scrollvXinc_buttonXnormal:\
            return &context->style.scrollv.inc_button.normal;\
    case nonnk_style_scrollvXinc_buttonXhover:\
            return &context->style.scrollv.inc_button.hover;\
    case nonnk_style_scrollvXinc_buttonXactive:\
            return &context->style.scrollv.inc_button.active;\
    case nonnk_style_scrollvXdec_buttonXnormal:\
            return &context->style.scrollv.dec_button.normal;\
    case nonnk_style_scrollvXdec_buttonXhover:\
            return &context->style.scrollv.dec_button.hover;\
    case nonnk_style_scrollvXdec_buttonXactive:\
            return &context->style.scrollv.dec_button.active;\
    case nonnk_style_editXnormal:\
            return &context->style.edit.normal;\
    case nonnk_style_editXhover:\
            return &context->style.edit.hover;\
    case nonnk_style_editXactive:\
            return &context->style.edit.active;\
    case nonnk_style_editXscrollbarXnormal:\
            return &context->style.edit.scrollbar.normal;\
    case nonnk_style_editXscrollbarXhover:\
            return &context->style.edit.scrollbar.hover;\
    case nonnk_style_editXscrollbarXactive:\
            return &context->style.edit.scrollbar.active;\
    case nonnk_style_editXscrollbarXcursor_normal:\
            return &context->style.edit.scrollbar.cursor_normal;\
    case nonnk_style_editXscrollbarXcursor_hover:\
            return &context->style.edit.scrollbar.cursor_hover;\
    case nonnk_style_editXscrollbarXcursor_active:\
            return &context->style.edit.scrollbar.cursor_active;\
    case nonnk_style_editXscrollbarXinc_buttonXnormal:\
            return &context->style.edit.scrollbar.inc_button.normal;\
    case nonnk_style_editXscrollbarXinc_buttonXhover:\
            return &context->style.edit.scrollbar.inc_button.hover;\
    case nonnk_style_editXscrollbarXinc_buttonXactive:\
            return &context->style.edit.scrollbar.inc_button.active;\
    case nonnk_style_editXscrollbarXdec_buttonXnormal:\
            return &context->style.edit.scrollbar.dec_button.normal;\
    case nonnk_style_editXscrollbarXdec_buttonXhover:\
            return &context->style.edit.scrollbar.dec_button.hover;\
    case nonnk_style_editXscrollbarXdec_buttonXactive:\
            return &context->style.edit.scrollbar.dec_button.active;\
    case nonnk_style_propertyXnormal:\
            return &context->style.property.normal;\
    case nonnk_style_propertyXhover:\
            return &context->style.property.hover;\
    case nonnk_style_propertyXactive:\
            return &context->style.property.active;\
    case nonnk_style_propertyXdec_buttonXnormal:\
            return &context->style.property.dec_button.normal;\
    case nonnk_style_propertyXdec_buttonXhover:\
            return &context->style.property.dec_button.hover;\
    case nonnk_style_propertyXdec_buttonXactive:\
            return &context->style.property.dec_button.active;\
    case nonnk_style_propertyXinc_buttonXnormal:\
            return &context->style.property.inc_button.normal;\
    case nonnk_style_propertyXinc_buttonXhover:\
            return &context->style.property.inc_button.hover;\
    case nonnk_style_propertyXinc_buttonXactive:\
            return &context->style.property.inc_button.active;\
    case nonnk_style_propertyXeditXnormal:\
            return &context->style.property.edit.normal;\
    case nonnk_style_propertyXeditXhover:\
            return &context->style.property.edit.hover;\
    case nonnk_style_propertyXeditXactive:\
            return &context->style.property.edit.active;\
    case nonnk_style_chartXbackground:\
            return &context->style.chart.background;\
    case nonnk_style_comboXnormal:\
            return &context->style.combo.normal;\
    case nonnk_style_comboXhover:\
            return &context->style.combo.hover;\
    case nonnk_style_comboXactive:\
            return &context->style.combo.active;\
    case nonnk_style_comboXbuttonXnormal:\
            return &context->style.combo.button.normal;\
    case nonnk_style_comboXbuttonXhover:\
            return &context->style.combo.button.hover;\
    case nonnk_style_comboXbuttonXactive:\
            return &context->style.combo.button.active;\
    case nonnk_style_tabXbackground:\
            return &context->style.tab.background;\
    case nonnk_style_tabXtab_minimize_buttonXnormal:\
            return &context->style.tab.tab_minimize_button.normal;\
    case nonnk_style_tabXtab_minimize_buttonXhover:\
            return &context->style.tab.tab_minimize_button.hover;\
    case nonnk_style_tabXtab_minimize_buttonXactive:\
            return &context->style.tab.tab_minimize_button.active;\
    case nonnk_style_tabXtab_maximize_buttonXnormal:\
            return &context->style.tab.tab_maximize_button.normal;\
    case nonnk_style_tabXtab_maximize_buttonXhover:\
            return &context->style.tab.tab_maximize_button.hover;\
    case nonnk_style_tabXtab_maximize_buttonXactive:\
            return &context->style.tab.tab_maximize_button.active;\
    case nonnk_style_tabXnode_minimize_buttonXnormal:\
            return &context->style.tab.node_minimize_button.normal;\
    case nonnk_style_tabXnode_minimize_buttonXhover:\
            return &context->style.tab.node_minimize_button.hover;\
    case nonnk_style_tabXnode_minimize_buttonXactive:\
            return &context->style.tab.node_minimize_button.active;\
    case nonnk_style_tabXnode_maximize_buttonXnormal:\
            return &context->style.tab.node_maximize_button.normal;\
    case nonnk_style_tabXnode_maximize_buttonXhover:\
            return &context->style.tab.node_maximize_button.hover;\
    case nonnk_style_tabXnode_maximize_buttonXactive:\
            return &context->style.tab.node_maximize_button.active;\
    case nonnk_style_windowXheaderXnormal:\
            return &context->style.window.header.normal;\
    case nonnk_style_windowXheaderXhover:\
            return &context->style.window.header.hover;\
    case nonnk_style_windowXheaderXactive:\
            return &context->style.window.header.active;\
    case nonnk_style_windowXheaderXclose_buttonXnormal:\
            return &context->style.window.header.close_button.normal;\
    case nonnk_style_windowXheaderXclose_buttonXhover:\
            return &context->style.window.header.close_button.hover;\
    case nonnk_style_windowXheaderXclose_buttonXactive:\
            return &context->style.window.header.close_button.active;\
    case nonnk_style_windowXheaderXminimize_buttonXnormal:\
            return &context->style.window.header.minimize_button.normal;\
    case nonnk_style_windowXheaderXminimize_buttonXhover:\
            return &context->style.window.header.minimize_button.hover;\
    case nonnk_style_windowXheaderXminimize_buttonXactive:\
            return &context->style.window.header.minimize_button.active;\
    case nonnk_style_windowXfixed_background:\
            return &context->style.window.fixed_background;\
    case nonnk_style_windowXscaler:\
            return &context->style.window.scaler;

#define CASE_NONNK_STYLE_BOOL /* bool */ \
    case nonnk_style_sliderXshow_buttons:\
            return &context->style.slider.show_buttons;\
    case nonnk_style_scrollhXshow_buttons:\
            return &context->style.scrollh.show_buttons;\
    case nonnk_style_scrollvXshow_buttons:\
            return &context->style.scrollv.show_buttons;\
    case nonnk_style_editXscrollbarXshow_buttons:\
            return &context->style.edit.scrollbar.show_buttons;\


#define CASE_NONNK_STYLE_HANDLE_PTR /* nk_handle_ptr */ \
    case nonnk_style_buttonXuserdata:\
            return &context->style.button.userdata;\
    case nonnk_style_contextual_buttonXuserdata:\
            return &context->style.contextual_button.userdata;\
    case nonnk_style_menu_buttonXuserdata:\
            return &context->style.menu_button.userdata;\
    case nonnk_style_checkboxXuserdata:\
            return &context->style.checkbox.userdata;\
    case nonnk_style_optionXuserdata:\
            return &context->style.option.userdata;\
    case nonnk_style_selectableXuserdata:\
            return &context->style.selectable.userdata;\
    case nonnk_style_sliderXuserdata:\
            return &context->style.slider.userdata;\
    case nonnk_style_sliderXinc_buttonXuserdata:\
            return &context->style.slider.inc_button.userdata;\
    case nonnk_style_sliderXdec_buttonXuserdata:\
            return &context->style.slider.dec_button.userdata;\
    case nonnk_style_progressXuserdata:\
            return &context->style.progress.userdata;\
    case nonnk_style_scrollhXuserdata:\
            return &context->style.scrollh.userdata;\
    case nonnk_style_scrollvXuserdata:\
            return &context->style.scrollv.userdata;\
    case nonnk_style_scrollhXinc_buttonXuserdata:\
            return &context->style.scrollh.inc_button.userdata;\
    case nonnk_style_scrollhXdec_buttonXuserdata:\
            return &context->style.scrollh.dec_button.userdata;\
    case nonnk_style_scrollvXinc_buttonXuserdata:\
            return &context->style.scrollv.inc_button.userdata;\
    case nonnk_style_scrollvXdec_buttonXuserdata:\
            return &context->style.scrollv.dec_button.userdata;\
    case nonnk_style_editXscrollbarXuserdata:\
            return &context->style.edit.scrollbar.userdata;\
    case nonnk_style_editXscrollbarXinc_buttonXuserdata:\
            return &context->style.edit.scrollbar.inc_button.userdata;\
    case nonnk_style_editXscrollbarXdec_buttonXuserdata:\
            return &context->style.edit.scrollbar.dec_button.userdata;\
    case nonnk_style_propertyXuserdata:\
            return &context->style.property.userdata;\
    case nonnk_style_propertyXdec_buttonXuserdata:\
            return &context->style.property.dec_button.userdata;\
    case nonnk_style_propertyXinc_buttonXuserdata:\
            return &context->style.property.inc_button.userdata;\
    case nonnk_style_comboXbuttonXuserdata:\
            return &context->style.combo.button.userdata;\
    case nonnk_style_tabXtab_minimize_buttonXuserdata:\
            return &context->style.tab.tab_minimize_button.userdata;\
    case nonnk_style_tabXtab_maximize_buttonXuserdata:\
            return &context->style.tab.tab_maximize_button.userdata;\
    case nonnk_style_tabXnode_minimize_buttonXuserdata:\
            return &context->style.tab.node_minimize_button.userdata;\
    case nonnk_style_tabXnode_maximize_buttonXuserdata:\
            return &context->style.tab.node_maximize_button.userdata;\
    case nonnk_style_windowXheaderXclose_buttonXuserdata:\
            return &context->style.window.header.close_button.userdata;\
    case nonnk_style_windowXheaderXminimize_buttonXuserdata:\
            return &context->style.window.header.minimize_button.userdata;\


#define CASE_NONNK_STYLE_SYMBOL_TYPE /* nk_symbol_type */ \
    case nonnk_style_sliderXinc_symbol:\
            return &context->style.slider.inc_symbol;\
    case nonnk_style_sliderXdec_symbol:\
            return &context->style.slider.dec_symbol;\
    case nonnk_style_scrollhXdec_symbol:\
            return &context->style.scrollh.dec_symbol;\
    case nonnk_style_scrollhXinc_symbol:\
            return &context->style.scrollh.inc_symbol;\
    case nonnk_style_scrollvXdec_symbol:\
            return &context->style.scrollv.dec_symbol;\
    case nonnk_style_scrollvXinc_symbol:\
            return &context->style.scrollv.inc_symbol;\
    case nonnk_style_editXscrollbarXdec_symbol:\
            return &context->style.edit.scrollbar.dec_symbol;\
    case nonnk_style_editXscrollbarXinc_symbol:\
            return &context->style.edit.scrollbar.inc_symbol;\
    case nonnk_style_propertyXsym_left:\
            return &context->style.property.sym_left;\
    case nonnk_style_propertyXsym_right:\
            return &context->style.property.sym_right;\
    case nonnk_style_comboXsym_normal:\
            return &context->style.combo.sym_normal;\
    case nonnk_style_comboXsym_hover:\
            return &context->style.combo.sym_hover;\
    case nonnk_style_comboXsym_active:\
            return &context->style.combo.sym_active;\
    case nonnk_style_tabXsym_minimize:\
            return &context->style.tab.sym_minimize;\
    case nonnk_style_tabXsym_maximize:\
            return &context->style.tab.sym_maximize;\
    case nonnk_style_windowXheaderXclose_symbol:\
            return &context->style.window.header.close_symbol;\
    case nonnk_style_windowXheaderXminimize_symbol:\
            return &context->style.window.header.minimize_symbol;\
    case nonnk_style_windowXheaderXmaximize_symbol:\
            return &context->style.window.header.maximize_symbol;\




#define CASE_NONNK_STYLE_CALLBACK /* void(*CALLBACK)(nk_canvas_t*, nk_handle userdata)*/ \
    case nonnk_style_buttonXdraw_begin:\
            return &context->style.button.draw_begin;\
    case nonnk_style_buttonXdraw_end:\
            return &context->style.button.draw_end;\
    case nonnk_style_contextual_buttonXdraw_begin:\
            return &context->style.contextual_button.draw_begin;\
    case nonnk_style_contextual_buttonXdraw_end:\
            return &context->style.contextual_button.draw_end;\
    case nonnk_style_menu_buttonXdraw_begin:\
            return &context->style.menu_button.draw_begin;\
    case nonnk_style_menu_buttonXdraw_end:\
            return &context->style.menu_button.draw_end;\
    case nonnk_style_selectableXdraw_begin:\
            return &context->style.selectable.draw_begin;\
    case nonnk_style_selectableXdraw_end:\
            return &context->style.selectable.draw_end;\
    case nonnk_style_sliderXdraw_begin:\
            return &context->style.slider.draw_begin;\
    case nonnk_style_sliderXdraw_end:\
            return &context->style.slider.draw_end;\
    case nonnk_style_sliderXinc_buttonXdraw_begin:\
            return &context->style.slider.inc_button.draw_begin;\
    case nonnk_style_sliderXinc_buttonXdraw_end:\
            return &context->style.slider.inc_button.draw_end;\
    case nonnk_style_sliderXdec_buttonXdraw_begin:\
            return &context->style.slider.dec_button.draw_begin;\
    case nonnk_style_sliderXdec_buttonXdraw_end:\
            return &context->style.slider.dec_button.draw_end;\
    case nonnk_style_progressXdraw_begin:\
            return &context->style.progress.draw_begin;\
    case nonnk_style_progressXdraw_end:\
            return &context->style.progress.draw_end;\
    case nonnk_style_scrollhXdraw_begin:\
            return &context->style.scrollh.draw_begin;\
    case nonnk_style_scrollhXdraw_end:\
            return &context->style.scrollh.draw_end;\
    case nonnk_style_scrollvXdraw_begin:\
            return &context->style.scrollv.draw_begin;\
    case nonnk_style_scrollvXdraw_end:\
            return &context->style.scrollv.draw_end;\
    case nonnk_style_scrollhXinc_buttonXdraw_begin:\
            return &context->style.scrollh.inc_button.draw_begin;\
    case nonnk_style_scrollhXinc_buttonXdraw_end:\
            return &context->style.scrollh.inc_button.draw_end;\
    case nonnk_style_scrollhXdec_buttonXdraw_begin:\
            return &context->style.scrollh.dec_button.draw_begin;\
    case nonnk_style_scrollhXdec_buttonXdraw_end:\
            return &context->style.scrollh.dec_button.draw_end;\
    case nonnk_style_scrollvXinc_buttonXdraw_begin:\
            return &context->style.scrollv.inc_button.draw_begin;\
    case nonnk_style_scrollvXinc_buttonXdraw_end:\
            return &context->style.scrollv.inc_button.draw_end;\
    case nonnk_style_scrollvXdec_buttonXdraw_begin:\
            return &context->style.scrollv.dec_button.draw_begin;\
    case nonnk_style_scrollvXdec_buttonXdraw_end:\
            return &context->style.scrollv.dec_button.draw_end;\
    case nonnk_style_editXscrollbarXdraw_begin:\
            return &context->style.edit.scrollbar.draw_begin;\
    case nonnk_style_editXscrollbarXdraw_end:\
            return &context->style.edit.scrollbar.draw_end;\
    case nonnk_style_editXscrollbarXinc_buttonXdraw_begin:\
            return &context->style.edit.scrollbar.inc_button.draw_begin;\
    case nonnk_style_editXscrollbarXinc_buttonXdraw_end:\
            return &context->style.edit.scrollbar.inc_button.draw_end;\
    case nonnk_style_editXscrollbarXdec_buttonXdraw_begin:\
            return &context->style.edit.scrollbar.dec_button.draw_begin;\
    case nonnk_style_editXscrollbarXdec_buttonXdraw_end:\
            return &context->style.edit.scrollbar.dec_button.draw_end;\
    case nonnk_style_propertyXdraw_begin:\
            return &context->style.property.draw_begin;\
    case nonnk_style_propertyXdraw_end:\
            return &context->style.property.draw_end;\
    case nonnk_style_propertyXdec_buttonXdraw_begin:\
            return &context->style.property.dec_button.draw_begin;\
    case nonnk_style_propertyXdec_buttonXdraw_end:\
            return &context->style.property.dec_button.draw_end;\
    case nonnk_style_propertyXinc_buttonXdraw_begin:\
            return &context->style.property.inc_button.draw_begin;\
    case nonnk_style_propertyXinc_buttonXdraw_end:\
            return &context->style.property.inc_button.draw_end;\
    case nonnk_style_comboXbuttonXdraw_begin:\
            return &context->style.combo.button.draw_begin;\
    case nonnk_style_comboXbuttonXdraw_end:\
            return &context->style.combo.button.draw_end;\
    case nonnk_style_tabXtab_minimize_buttonXdraw_begin:\
            return &context->style.tab.tab_minimize_button.draw_begin;\
    case nonnk_style_tabXtab_minimize_buttonXdraw_end:\
            return &context->style.tab.tab_minimize_button.draw_end;\
    case nonnk_style_tabXtab_maximize_buttonXdraw_begin:\
            return &context->style.tab.tab_maximize_button.draw_begin;\
    case nonnk_style_tabXtab_maximize_buttonXdraw_end:\
            return &context->style.tab.tab_maximize_button.draw_end;\
    case nonnk_style_tabXnode_minimize_buttonXdraw_begin:\
            return &context->style.tab.node_minimize_button.draw_begin;\
    case nonnk_style_tabXnode_minimize_buttonXdraw_end:\
            return &context->style.tab.node_minimize_button.draw_end;\
    case nonnk_style_tabXnode_maximize_buttonXdraw_begin:\
            return &context->style.tab.node_maximize_button.draw_begin;\
    case nonnk_style_tabXnode_maximize_buttonXdraw_end:\
            return &context->style.tab.node_maximize_button.draw_end;\
    case nonnk_style_windowXheaderXclose_buttonXdraw_begin:\
            return &context->style.window.header.close_button.draw_begin;\
    case nonnk_style_windowXheaderXclose_buttonXdraw_end:\
            return &context->style.window.header.close_button.draw_end;\
    case nonnk_style_windowXheaderXminimize_buttonXdraw_begin:\
            return &context->style.window.header.minimize_button.draw_begin;\
    case nonnk_style_windowXheaderXminimize_buttonXdraw_end:\
            return &context->style.window.header.minimize_button.draw_end;\

#endif /* styleDEFINED */
