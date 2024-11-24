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

#ifndef objectsDEFINED
#define objectsDEFINED

#include "tree.h"
#include "udata.h"

/* nk_ redefinitions for internal use */
#define nk_allocator_t struct nk_allocator
#define nk_canvas_t struct nk_command_buffer
#define nk_draw_command_t struct nk_draw_command
#define nk_convert_config_t struct nk_convert_config
#define nk_edit_t struct nk_text_edit
#define nk_draw_list_t struct nk_draw_list
#define nk_user_font_t struct nk_user_font
#define nk_user_font_glyph_t struct nk_user_font_glyph
#define nk_panel_t struct nk_panel
#define nk_context_t struct nk_context
#define nk_draw_vertex_layout_element_t struct nk_draw_vertex_layout_element
#define nk_style_item_t struct nk_style_item
#define nk_style_t struct nk_style
#define nk_style_button_t struct nk_style_button
#define nk_style_toggle_t struct nk_style_toggle
#define nk_style_selectable_t struct nk_style_selectable
#define nk_style_slider_t struct nk_style_slider
#define nk_style_progress_t struct nk_style_progress
#define nk_style_scrollbar_t struct nk_style_scrollbar
#define nk_style_edit_t struct nk_style_edit
#define nk_style_property_t struct nk_style_property
#define nk_style_chart_t struct nk_style_chart
#define nk_style_combo_t struct nk_style_combo
#define nk_style_tab_t struct nk_style_tab
#define nk_style_window_header_t struct nk_style_window_header
#define nk_style_window_t struct nk_style_window
#define nk_style_text_t struct nk_style_text
#define nk_color_t struct nk_color
#define nk_colorf_t struct nk_colorf
#define nk_vec2_t struct nk_vec2
#define nk_vec2i_t struct nk_vec2i
#define nk_rect_t struct nk_rect
#define nk_recti_t struct nk_recti
#define nk_handle_t nk_handle  /* union */
#define nk_image_t struct nk_image
#define nk_nine_slice_t struct nk_nine_slice
#define nk_cursor_t struct nk_cursor
#define nk_scroll_t struct nk_scroll
#define nk_window_t struct nk_window
#define nk_command_t struct nk_command
#define nk_command_scissor_t struct nk_command_scissor
#define nk_command_line_t struct nk_command_line
#define nk_command_curve_t struct nk_command_curve
#define nk_command_rect_t struct nk_command_rect
#define nk_command_rect_filled_t struct nk_command_rect_filled
#define nk_command_rect_multi_color_t struct nk_command_rect_multi_color
#define nk_command_triangle_t struct nk_command_triangle
#define nk_command_triangle_filled_t struct nk_command_triangle_filled
#define nk_command_circle_t struct nk_command_circle
#define nk_command_circle_filled_t struct nk_command_circle_filled
#define nk_command_arc_t struct nk_command_arc
#define nk_command_arc_filled_t struct nk_command_arc_filled
#define nk_command_polygon_t struct nk_command_polygon
#define nk_command_polygon_filled_t struct nk_command_polygon_filled
#define nk_command_polyline_t struct nk_command_polyline
#define nk_command_image_t struct nk_command_image
#define nk_command_custom_t struct nk_command_custom
#define nk_command_text_t struct nk_command_text
#define nk_mouse_button_t struct nk_mouse_button
#define nk_mouse_t struct nk_mouse
#define nk_key_t struct nk_key
#define nk_keyboard_t struct nk_keyboard
#define nk_input_t struct nk_input
#define nk_baked_font_t struct nk_baked_font
#define nk_font_config_t struct nk_font_config
#define nk_font_glyph_t struct nk_font_glyph
#define nk_font_t struct nk_font
#define nk_atlas_t struct nk_font_atlas
#define nk_draw_null_texture_t struct nk_draw_null_texture
#define nk_list_view_t struct nk_list_view
#define nk_buffer_t struct nk_buffer
#define nk_buffer_marker_t struct nk_buffer_marker
#define nk_memory_status_t struct nk_memory_status
#define nk_memory_t struct nk_memory
#define nk_clipboard_t struct nk_clipboard
#define nk_text_undo_record_t struct nk_text_undo_record
#define nk_text_undo_state_t struct nk_text_undo_state
#define nk_str_t struct nk_str
#define nk_chart_slot_t struct nk_chart_slot
#define nk_chart_t struct nk_chart
#define nk_row_layout_t struct nk_row_layout
#define nk_popup_buffer_t struct nk_popup_buffer
#define nk_popup_state_t struct nk_popup_state
#define nk_menu_state_t struct nk_menu_state
#define nk_table_t struct nk_table
#define nk_edit_state_t struct nk_edit_state
#define nk_property_state_t struct nk_property_state
#define nk_configuration_stacks_t struct nk_configuration_stacks
#define nk_page_element_t struct nk_page_element
#define nk_page_t struct nk_page
#define nk_pool_t struct nk_pool


/* Objects' metatable names */
#define CONTEXT_MT "moonnuklear_context"
#define ATLAS_MT "moonnuklear_atlas"
#define FONT_MT "moonnuklear_font"
#define IMAGE_MT "moonnuklear_image"
#define NINE_SLICE_MT "moonnuklear_nine_slice"
#define CURSOR_MT "moonnuklear_cursor"
#define BUFFER_MT "moonnuklear_buffer"
#define EDIT_MT "moonnuklear_edit"
#define PANEL_MT "moonnuklear_panel"
#define CANVAS_MT "moonnuklear_canvas"

/* Userdata memory associated with objects */
#define ud_t moonnuklear_ud_t
typedef struct moonnuklear_ud_s ud_t;

struct moonnuklear_ud_s {
    void *handle; /* the object handle bound to this userdata */
    int (*destructor)(lua_State *L, ud_t *ud);  /* self destructor */
    ud_t *parent_ud; /* the ud of the parent object */
    nk_context_t *context;
    nk_font_t *font;
    nk_convert_config_t config; /* used by context only */
    nk_font_config_t *font_config; /* used by font only */
    uint32_t marks;
    int ref1, ref2; /* general purpose references on the Lua registry, 
                       automatically unreferenced by freeuserdata */
    float *ratio; /* used by context (see layout.c) */
    char *buf; int bufsize; /* used by edit */
    void *info; /* object specific info (ud_info_t, subject to Free() at destruction, if not NULL) */
};
    
/* Marks.  m_ = marks word (uint32_t) , i_ = bit number (0 .. 31)  */
#define MarkGet(m_,i_)  (((m_) & ((uint32_t)1<<(i_))) == ((uint32_t)1<<(i_)))
#define MarkSet(m_,i_)  do { (m_) = ((m_) | ((uint32_t)1<<(i_))); } while(0)
#define MarkReset(m_,i_) do { (m_) = ((m_) & (~((uint32_t)1<<(i_)))); } while(0)

#define IsValid(ud)                     MarkGet((ud)->marks, 0)
#define MarkValid(ud)                   MarkSet((ud)->marks, 0) 
#define CancelValid(ud)                 MarkReset((ud)->marks, 0)

#define IsAssociatedWithContext(ud)     MarkGet((ud)->marks, 1)
#define MarkAssociatedWithContext(ud)   MarkSet((ud)->marks, 1) 
#define CancelAssociatedWithContext(ud) MarkReset((ud)->marks, 1)

#define IsFixed(ud)                     MarkGet((ud)->marks, 2)
#define MarkFixed(ud)                   MarkSet((ud)->marks, 2) 
#define CancelFixed(ud)                 MarkReset((ud)->marks, 2)

#define IsInitialized(ud)               MarkGet((ud)->marks, 3)
#define MarkInitialized(ud)             MarkSet((ud)->marks, 3) 
#define CancelInitialized(ud)           MarkReset((ud)->marks, 3)

#define IsAtlasCursor(ud)               MarkGet((ud)->marks, 4)
#define MarkAtlasCursor(ud)             MarkSet((ud)->marks, 4) 
#define CancelAtlasCursor(ud)           MarkReset((ud)->marks, 4)

#define IsAllocated(ud)                 MarkGet((ud)->marks, 5)
#define MarkAllocated(ud)               MarkSet((ud)->marks, 5) 
#define CancelAllocated(ud)             MarkReset((ud)->marks, 5)

#define IsBorrowed(ud)                  MarkGet((ud)->marks, 6)
#define MarkBorrowed(ud)                MarkSet((ud)->marks, 6)
#define CancelBorrowed(ud)              MarkReset((ud)->marks, 6)

#define IsImageId(ud)                   MarkGet((ud)->marks, 7)
#define MarkImageId(ud)                 MarkSet((ud)->marks, 7) 
#define CancelImageId(ud)               MarkReset((ud)->marks, 7)
#define IsImagePtr(ud)                  (!IsImageId(ud))
#define MarkImagePtr(ud)                CancelImageId(ud)
#define CancelImagePtr(ud)              MarkImageId(ud)

#define IsSubImage(ud)                  MarkGet((ud)->marks, 8)
#define MarkSubImage(ud)                MarkSet((ud)->marks, 8) 
#define CancelSubImage(ud)              MarkReset((ud)->marks, 8)

#define IsNineSliceId(ud)               MarkGet((ud)->marks, 9)
#define MarkNineSliceId(ud)             MarkSet((ud)->marks, 9) 
#define CancelNineSliceId(ud)           MarkReset((ud)->marks, 9)
#define IsNineSlicePtr(ud)              (!IsNineSliceId(ud))
#define MarkNineSlicePtr(ud)            CancelNineSliceId(ud)
#define CancelNineSlicePtr(ud)          MarkNineSliceId(ud)

#define IsSubNineSlice(ud)              MarkGet((ud)->marks, 10)
#define MarkSubNineSlice(ud)            MarkSet((ud)->marks, 10) 
#define CancelSubNineSlice(ud)          MarkReset((ud)->marks, 10)

#if 0
/* .c */
#define  moonnuklear_
#endif

#define newuserdata moonnuklear_newuserdata
ud_t *newuserdata(lua_State *L, void *handle, const char *mt, const char *tracename);
#define freeuserdata moonnuklear_freeuserdata
int freeuserdata(lua_State *L, ud_t *ud, const char *tracename);
#define pushuserdata moonnuklear_pushuserdata 
int pushuserdata(lua_State *L, ud_t *ud);

#define userdata_unref(L, handle) udata_unref((L),(handle))

#define UD(handle) userdata((handle)) /* dispatchable objects only */
#define userdata moonnuklear_userdata
ud_t *userdata(void *handle);
#define testxxx moonnuklear_testxxx
void *testxxx(lua_State *L, int arg, ud_t **udp, const char *mt);
#define checkxxx moonnuklear_checkxxx
void *checkxxx(lua_State *L, int arg, ud_t **udp, const char *mt);
#define pushxxx moonnuklear_pushxxx
int pushxxx(lua_State *L, void *handle);
#define checkxxxlist moonnuklear_checkxxxlist
void** checkxxxlist(lua_State *L, int arg, int *count, int *err, const char *mt);

#define freechildren moonnuklear_freechildren
int freechildren(lua_State *L,  const char *mt, ud_t *parent_ud);

/* context.c */
#define checkcontext(L, arg, udp) (nk_context_t*)checkxxx((L), (arg), (udp), CONTEXT_MT)
#define testcontext(L, arg, udp) (nk_context_t*)testxxx((L), (arg), (udp), CONTEXT_MT)
#define pushcontext(L, handle) pushxxx((L), (handle))

/* atlas.c */
#define checkatlas(L, arg, udp) (nk_atlas_t*)checkxxx((L), (arg), (udp), ATLAS_MT)
#define testatlas(L, arg, udp) (nk_atlas_t*)testxxx((L), (arg), (udp), ATLAS_MT)
#define pushatlas(L, handle) pushxxx((L), (handle))

/* font.c */
#define checkfont(L, arg, udp) (nk_user_font_t*)checkxxx((L), (arg), (udp), FONT_MT)
#define testfont(L, arg, udp) (nk_user_font_t*)testxxx((L), (arg), (udp), FONT_MT)
#define pushfont(L, handle) pushxxx((L), (handle))
#define pushatlasfont moonnuklear_pushatlasfont
int pushatlasfont(lua_State *L, ud_t *atlas_ud, nk_font_t *atlas_font, nk_font_config_t *cfg);

/* buffer.c */
#define checkbuffer(L, arg, udp) (nk_buffer_t*)checkxxx((L), (arg), (udp), BUFFER_MT)
#define testbuffer(L, arg, udp) (nk_buffer_t*)testxxx((L), (arg), (udp), BUFFER_MT)
#define pushbuffer(L, handle) pushxxx((L), (handle))

/* image.c */
#define checkimage(L, arg, udp) (nk_image_t*)checkxxx((L), (arg), (udp), IMAGE_MT)
#define testimage(L, arg, udp) (nk_image_t*)testxxx((L), (arg), (udp), IMAGE_MT)
#define pushimage(L, handle) pushxxx((L), (handle))

/* nine_slice.c */
#define checknine_slice(L, arg, udp) (nk_nine_slice_t*)checkxxx((L), (arg), (udp), NINE_SLICE_MT)
#define testnine_slice(L, arg, udp) (nk_nine_slice_t*)testxxx((L), (arg), (udp), NINE_SLICE_MT)
#define pushnine_slice(L, handle) pushxxx((L), (handle))

/* cursor.c */
#define checkcursor(L, arg, udp) (nk_cursor_t*)checkxxx((L), (arg), (udp), CURSOR_MT)
#define testcursor(L, arg, udp) (nk_cursor_t*)testxxx((L), (arg), (udp), CURSOR_MT)
#define pushcursor(L, handle) pushxxx((L), (handle))
#define pushatlascursor moonnuklear_pushatlascursor
int pushatlascursor(lua_State *L, ud_t* atlas_ud, nk_cursor_t *cursor);

/* edit.c */
#define checkedit(L, arg, udp) (nk_edit_t*)checkxxx((L), (arg), (udp), EDIT_MT)
#define testedit(L, arg, udp) (nk_edit_t*)testxxx((L), (arg), (udp), EDIT_MT)
#define pushedit(L, handle) pushxxx((L), (handle))
#define newedit moonnuklear_newedit
int newedit(lua_State *L, ud_t *ud_context);
#define edit_string moonnuklear_edit_string
int edit_string(lua_State *L);
#define edit_buffer moonnuklear_edit_buffer
int edit_buffer(lua_State *L);
#define edit_focus moonnuklear_edit_focus
int edit_focus(lua_State *L);
#define edit_unfocus moonnuklear_edit_unfocus
int edit_unfocus(lua_State *L);

/* panel.c */
#define checkpanel(L, arg, udp) (nk_panel_t*)checkxxx((L), (arg), (udp), PANEL_MT)
#define testpanel(L, arg, udp) (nk_panel_t*)testxxx((L), (arg), (udp), PANEL_MT)
#define pushpanel(L, handle) pushxxx((L), (handle))
#define newpanel moonnuklear_newpanel

/* canvas.c */
#define checkcanvas(L, arg, udp) (nk_canvas_t*)checkxxx((L), (arg), (udp), CANVAS_MT)
#define testcanvas(L, arg, udp) (nk_canvas_t*)testxxx((L), (arg), (udp), CANVAS_MT)
#define pushcanvas(L, handle) pushxxx((L), (handle))
#define newcanvas moonnuklear_newanvasc
int newcanvas(lua_State *L, nk_canvas_t *canvas);

#define RAW_FUNC(xxx)                       \
static int Raw(lua_State *L)                \
    {                                       \
    /*lua_pushinteger(L, (uintptr_t)check##xxx(L, 1, NULL));*/  \
    lua_pushlightuserdata(L, check##xxx(L, 1, NULL));  \
    return 1;                               \
    }

#define DELETE_FUNC(xxx)                    \
static int Delete(lua_State *L)             \
    {                                       \
    ud_t *ud;                               \
    (void)test##xxx(L, 1, &ud);             \
    if(!ud) return 0; /* already deleted */ \
    return ud->destructor(L, ud);           \
    }

#define TYPE_FUNC(xxx) /* NONCL */          \
static int Type(lua_State *L)               \
    {                                       \
    (void)check##xxx(L, 1, NULL);           \
    lua_pushstring(L, ""#xxx);              \
    return 1;                               \
    }

#endif /* objectsDEFINED */
