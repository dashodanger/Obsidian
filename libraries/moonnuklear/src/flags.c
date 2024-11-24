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

#define ADD(c) do { lua_pushinteger(L, NK_##c); lua_setfield(L, -2, #c); } while(0)

/* checkkkflags: accepts a list of strings starting from index=arg
 * pushxxxflags -> pushes a list of strings 
 */

/*----------------------------------------------------------------------*
 | nk_convert_result
 *----------------------------------------------------------------------*/

static nk_flags checkconvertresult(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
        CASE(NK_CONVERT_SUCCESS, "success");
        CASE(NK_CONVERT_INVALID_PARAM, "invalid param");
        CASE(NK_CONVERT_COMMAND_BUFFER_FULL, "command buffer full");
        CASE(NK_CONVERT_VERTEX_BUFFER_FULL, "vertex buffer full");
        CASE(NK_CONVERT_ELEMENT_BUFFER_FULL, "element buffer full");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pushconvertresult(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
        CASE(NK_CONVERT_SUCCESS, "success");
        CASE(NK_CONVERT_INVALID_PARAM, "invalid param");
        CASE(NK_CONVERT_COMMAND_BUFFER_FULL, "command buffer full");
        CASE(NK_CONVERT_VERTEX_BUFFER_FULL, "vertex buffer full");
        CASE(NK_CONVERT_ELEMENT_BUFFER_FULL, "element buffer full");
#undef CASE

    return n;
    }

static int ConvertResult(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pushconvertresult(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkconvertresult(L, 1));
    return 1;
    }

#define Add_ConvertResult(L) \
    ADD(CONVERT_SUCCESS);\
    ADD(CONVERT_INVALID_PARAM);\
    ADD(CONVERT_COMMAND_BUFFER_FULL);\
    ADD(CONVERT_VERTEX_BUFFER_FULL);\
    ADD(CONVERT_ELEMENT_BUFFER_FULL);\

/*----------------------------------------------------------------------*
 | nk_panel_flags 
 *----------------------------------------------------------------------*/

static nk_flags checkpanelflags(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
    CASE(NK_WINDOW_BORDER, "border");
    CASE(NK_WINDOW_MOVABLE, "movable");
    CASE(NK_WINDOW_SCALABLE, "scalable");
    CASE(NK_WINDOW_CLOSABLE, "closable");
    CASE(NK_WINDOW_MINIMIZABLE, "minimizable");
    CASE(NK_WINDOW_NO_SCROLLBAR, "no scrollbar");
    CASE(NK_WINDOW_TITLE, "title");
    CASE(NK_WINDOW_SCROLL_AUTO_HIDE, "scroll auto hide");
    CASE(NK_WINDOW_BACKGROUND, "background");
    CASE(NK_WINDOW_SCALE_LEFT, "scale left");
    CASE(NK_WINDOW_NO_INPUT, "no input");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pushpanelflags(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
    CASE(NK_WINDOW_BORDER, "border");
    CASE(NK_WINDOW_MOVABLE, "movable");
    CASE(NK_WINDOW_SCALABLE, "scalable");
    CASE(NK_WINDOW_CLOSABLE, "closable");
    CASE(NK_WINDOW_MINIMIZABLE, "minimizable");
    CASE(NK_WINDOW_NO_SCROLLBAR, "no scrollbar");
    CASE(NK_WINDOW_TITLE, "title");
    CASE(NK_WINDOW_SCROLL_AUTO_HIDE, "scroll auto hide");
    CASE(NK_WINDOW_BACKGROUND, "background");
    CASE(NK_WINDOW_SCALE_LEFT, "scale left");
    CASE(NK_WINDOW_NO_INPUT, "no input");
#undef CASE

    return n;
    }

static int PanelFlags(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pushpanelflags(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkpanelflags(L, 1));
    return 1;
    }

#define Add_PanelFlags(L) \
    ADD(WINDOW_BORDER);\
    ADD(WINDOW_MOVABLE);\
    ADD(WINDOW_SCALABLE);\
    ADD(WINDOW_CLOSABLE);\
    ADD(WINDOW_MINIMIZABLE);\
    ADD(WINDOW_NO_SCROLLBAR);\
    ADD(WINDOW_TITLE);\
    ADD(WINDOW_SCROLL_AUTO_HIDE);\
    ADD(WINDOW_BACKGROUND);\
    ADD(WINDOW_SCALE_LEFT);\
    ADD(WINDOW_NO_INPUT);\

/*----------------------------------------------------------------------*
 | nk_widget_states 
 *----------------------------------------------------------------------*/

static nk_flags checkwidgetstates(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
    CASE(NK_WIDGET_STATE_MODIFIED, "modified");
    CASE(NK_WIDGET_STATE_INACTIVE, "inactive");
    CASE(NK_WIDGET_STATE_ENTERED, "entered");
    CASE(NK_WIDGET_STATE_HOVER, "hover");
    CASE(NK_WIDGET_STATE_ACTIVED, "actived");
    CASE(NK_WIDGET_STATE_LEFT, "left");
    CASE(NK_WIDGET_STATE_HOVERED, "hovered");
    CASE(NK_WIDGET_STATE_ACTIVE, "active");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pushwidgetstates(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
    CASE(NK_WIDGET_STATE_MODIFIED, "modified");
    CASE(NK_WIDGET_STATE_INACTIVE, "inactive");
    CASE(NK_WIDGET_STATE_ENTERED, "entered");
    CASE(NK_WIDGET_STATE_HOVER, "hover");
    CASE(NK_WIDGET_STATE_ACTIVED, "actived");
    CASE(NK_WIDGET_STATE_LEFT, "left");
    CASE(NK_WIDGET_STATE_HOVERED, "hovered");
    CASE(NK_WIDGET_STATE_ACTIVE, "active");
#undef CASE

    return n;
    }

static int WidgetStates(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pushwidgetstates(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkwidgetstates(L, 1));
    return 1;
    }

#define Add_WidgetStates(L) \
    ADD(WIDGET_STATE_MODIFIED);\
    ADD(WIDGET_STATE_INACTIVE);\
    ADD(WIDGET_STATE_ENTERED);\
    ADD(WIDGET_STATE_HOVER);\
    ADD(WIDGET_STATE_ACTIVED);\
    ADD(WIDGET_STATE_LEFT);\
    ADD(WIDGET_STATE_HOVERED);\
    ADD(WIDGET_STATE_ACTIVE);\

/*----------------------------------------------------------------------*
 | nk_widget_align
 *----------------------------------------------------------------------*/

static nk_flags checkwidgetalign(lua_State *L, int arg)
    {
    const char *s;
    nk_flags flags = 0;

    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
    CASE(NK_WIDGET_ALIGN_LEFT, "align left");
    CASE(NK_WIDGET_ALIGN_CENTERED, "align centered");
    CASE(NK_WIDGET_ALIGN_RIGHT, "align right");
    CASE(NK_WIDGET_ALIGN_TOP, "align top");
    CASE(NK_WIDGET_ALIGN_MIDDLE, "align middle");
    CASE(NK_WIDGET_ALIGN_BOTTOM, "align bottom");
    // flags combinations (nk_widget_alignment):
    CASE(NK_WIDGET_LEFT, "left");
    CASE(NK_WIDGET_CENTERED, "centered");
    CASE(NK_WIDGET_RIGHT, "right");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pushwidgetalign(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
    CASE(NK_WIDGET_ALIGN_LEFT, "align left");
    CASE(NK_WIDGET_ALIGN_CENTERED, "align centered");
    CASE(NK_WIDGET_ALIGN_RIGHT, "align right");
    CASE(NK_WIDGET_ALIGN_TOP, "align top");
    CASE(NK_WIDGET_ALIGN_MIDDLE, "align middle");
    CASE(NK_WIDGET_ALIGN_BOTTOM, "align bottom");
#undef CASE

    return n;
    }

static int WidgetAlign(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pushwidgetalign(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkwidgetalign(L, 1));
    return 1;
    }

#define Add_WidgetAlign(L) \
    ADD(WIDGET_ALIGN_LEFT);\
    ADD(WIDGET_ALIGN_CENTERED);\
    ADD(WIDGET_ALIGN_RIGHT);\
    ADD(WIDGET_ALIGN_TOP);\
    ADD(WIDGET_ALIGN_MIDDLE);\
    ADD(WIDGET_ALIGN_BOTTOM);\
    ADD(WIDGET_LEFT);\
    ADD(WIDGET_CENTERED);\
    ADD(WIDGET_RIGHT);\


/*----------------------------------------------------------------------*
 | nk_text_align
 *----------------------------------------------------------------------*/

static nk_flags checktextalign(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
    CASE(NK_TEXT_ALIGN_LEFT, "align left");
    CASE(NK_TEXT_ALIGN_CENTERED, "align centered");
    CASE(NK_TEXT_ALIGN_RIGHT, "align right");
    CASE(NK_TEXT_ALIGN_TOP, "align top");
    CASE(NK_TEXT_ALIGN_MIDDLE, "align middle");
    CASE(NK_TEXT_ALIGN_BOTTOM, "align bottom");
    // flags combinations (nk_text_alignment):
    CASE(NK_TEXT_LEFT, "left");
    CASE(NK_TEXT_CENTERED, "centered");
    CASE(NK_TEXT_RIGHT, "right");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pushtextalign(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
    CASE(NK_TEXT_ALIGN_LEFT, "align left");
    CASE(NK_TEXT_ALIGN_CENTERED, "align centered");
    CASE(NK_TEXT_ALIGN_RIGHT, "align right");
    CASE(NK_TEXT_ALIGN_TOP, "align top");
    CASE(NK_TEXT_ALIGN_MIDDLE, "align middle");
    CASE(NK_TEXT_ALIGN_BOTTOM, "align bottom");
#undef CASE

    return n;
    }

static int TextAlign(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pushtextalign(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checktextalign(L, 1));
    return 1;
    }

#define Add_TextAlign(L) \
    ADD(TEXT_ALIGN_LEFT);\
    ADD(TEXT_ALIGN_CENTERED);\
    ADD(TEXT_ALIGN_RIGHT);\
    ADD(TEXT_ALIGN_TOP);\
    ADD(TEXT_ALIGN_MIDDLE);\
    ADD(TEXT_ALIGN_BOTTOM);\
    ADD(TEXT_LEFT);\
    ADD(TEXT_CENTERED);\
    ADD(TEXT_RIGHT);\


/*----------------------------------------------------------------------*
 | nk_edit_flags
 *----------------------------------------------------------------------*/

static nk_flags checkeditflags(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
    CASE(NK_EDIT_DEFAULT, "default");
    CASE(NK_EDIT_READ_ONLY, "read only");
    CASE(NK_EDIT_AUTO_SELECT, "auto select");
    CASE(NK_EDIT_SIG_ENTER, "sig enter");
    CASE(NK_EDIT_ALLOW_TAB, "allow tab");
    CASE(NK_EDIT_NO_CURSOR, "no cursor");
    CASE(NK_EDIT_SELECTABLE, "selectable");
    CASE(NK_EDIT_CLIPBOARD, "clipboard");
    CASE(NK_EDIT_CTRL_ENTER_NEWLINE, "ctrl enter newline");
    CASE(NK_EDIT_NO_HORIZONTAL_SCROLL, "no horizontal scroll");
    CASE(NK_EDIT_ALWAYS_INSERT_MODE, "always insert mode");
    CASE(NK_EDIT_MULTILINE, "multiline");
    CASE(NK_EDIT_GOTO_END_ON_ACTIVATE, "goto end on activate");
    // flags combinations (nk_edit_types):
    CASE(NK_EDIT_SIMPLE, "simple");
    CASE(NK_EDIT_FIELD, "field");
    CASE(NK_EDIT_BOX, "box");
    CASE(NK_EDIT_EDITOR, "editor");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pusheditflags(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
    CASE(NK_EDIT_DEFAULT, "default");
    CASE(NK_EDIT_READ_ONLY, "read only");
    CASE(NK_EDIT_AUTO_SELECT, "auto select");
    CASE(NK_EDIT_SIG_ENTER, "sig enter");
    CASE(NK_EDIT_ALLOW_TAB, "allow tab");
    CASE(NK_EDIT_NO_CURSOR, "no cursor");
    CASE(NK_EDIT_SELECTABLE, "selectable");
    CASE(NK_EDIT_CLIPBOARD, "clipboard");
    CASE(NK_EDIT_CTRL_ENTER_NEWLINE, "ctrl enter newline");
    CASE(NK_EDIT_NO_HORIZONTAL_SCROLL, "no horizontal scroll");
    CASE(NK_EDIT_ALWAYS_INSERT_MODE, "always insert mode");
    CASE(NK_EDIT_MULTILINE, "multiline");
    CASE(NK_EDIT_GOTO_END_ON_ACTIVATE, "goto end on activate");
#undef CASE

    return n;
    }

static int EditFlags(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pusheditflags(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkeditflags(L, 1));
    return 1;
    }

#define Add_EditFlags(L) \
    ADD(EDIT_DEFAULT);\
    ADD(EDIT_READ_ONLY);\
    ADD(EDIT_AUTO_SELECT);\
    ADD(EDIT_SIG_ENTER);\
    ADD(EDIT_ALLOW_TAB);\
    ADD(EDIT_NO_CURSOR);\
    ADD(EDIT_SELECTABLE);\
    ADD(EDIT_CLIPBOARD);\
    ADD(EDIT_CTRL_ENTER_NEWLINE);\
    ADD(EDIT_NO_HORIZONTAL_SCROLL);\
    ADD(EDIT_ALWAYS_INSERT_MODE);\
    ADD(EDIT_MULTILINE);\
    ADD(EDIT_GOTO_END_ON_ACTIVATE);\
    ADD(EDIT_SIMPLE);\
    ADD(EDIT_FIELD);\
    ADD(EDIT_BOX);\
    ADD(EDIT_EDITOR);\

/*----------------------------------------------------------------------*
 | nk_edit_events
 *----------------------------------------------------------------------*/

static nk_flags checkeditevents(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
    CASE(NK_EDIT_ACTIVE, "active");
    CASE(NK_EDIT_INACTIVE, "inactive");
    CASE(NK_EDIT_ACTIVATED, "activated");
    CASE(NK_EDIT_DEACTIVATED, "deactivated");
    CASE(NK_EDIT_COMMITED, "commited");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pusheditevents(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
    CASE(NK_EDIT_ACTIVE, "active");
    CASE(NK_EDIT_INACTIVE, "inactive");
    CASE(NK_EDIT_ACTIVATED, "activated");
    CASE(NK_EDIT_DEACTIVATED, "deactivated");
    CASE(NK_EDIT_COMMITED, "commited");
#undef CASE

    return n;
    }

static int EditEvents(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pusheditevents(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkeditevents(L, 1));
    return 1;
    }

#define Add_EditEvents(L) \
    ADD(EDIT_ACTIVE);\
    ADD(EDIT_INACTIVE);\
    ADD(EDIT_ACTIVATED);\
    ADD(EDIT_DEACTIVATED);\
    ADD(EDIT_COMMITED);\

/*----------------------------------------------------------------------*
 | nk_panel_type
 *----------------------------------------------------------------------*/

static nk_flags checkpaneltype(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
    CASE(NK_PANEL_WINDOW, "window");
    CASE(NK_PANEL_GROUP, "group");
    CASE(NK_PANEL_POPUP, "popup");
    CASE(NK_PANEL_CONTEXTUAL, "contextual");
    CASE(NK_PANEL_COMBO, "combo");
    CASE(NK_PANEL_MENU, "menu");
    CASE(NK_PANEL_TOOLTIP, "tooltip");
    // flags combinations (nk_panel_set):
    CASE(NK_PANEL_SET_NONBLOCK, "set nonblock");
    CASE(NK_PANEL_SET_POPUP, "set popup");
    CASE(NK_PANEL_SET_SUB, "set sub");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }


static int pushpaneltype(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
    CASE(NK_PANEL_WINDOW, "window");
    CASE(NK_PANEL_GROUP, "group");
    CASE(NK_PANEL_POPUP, "popup");
    CASE(NK_PANEL_CONTEXTUAL, "contextual");
    CASE(NK_PANEL_COMBO, "combo");
    CASE(NK_PANEL_MENU, "menu");
    CASE(NK_PANEL_TOOLTIP, "tooltip");
#undef CASE

    return n;
    }

static int PanelType(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pushpaneltype(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkpaneltype(L, 1));
    return 1;
    }

#define Add_PanelType(L) \
    ADD(PANEL_WINDOW);\
    ADD(PANEL_GROUP);\
    ADD(PANEL_POPUP);\
    ADD(PANEL_CONTEXTUAL);\
    ADD(PANEL_COMBO);\
    ADD(PANEL_MENU);\
    ADD(PANEL_TOOLTIP);\
    ADD(PANEL_SET_NONBLOCK);\
    ADD(PANEL_SET_POPUP);\
    ADD(PANEL_SET_SUB);\

/*----------------------------------------------------------------------*
 | nk_window_flags
 *----------------------------------------------------------------------*/

static nk_flags checkwindowflags(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
    CASE(NK_WINDOW_PRIVATE, "private");
    CASE(NK_WINDOW_DYNAMIC, "dynamic");
    CASE(NK_WINDOW_ROM, "rom");
    CASE(NK_WINDOW_NOT_INTERACTIVE, "not interactive");
    CASE(NK_WINDOW_HIDDEN, "hidden");
    CASE(NK_WINDOW_CLOSED, "closed");
    CASE(NK_WINDOW_MINIMIZED, "minimized");
    CASE(NK_WINDOW_REMOVE_ROM, "remove rom");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pushwindowflags(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
    CASE(NK_WINDOW_PRIVATE, "private");
    CASE(NK_WINDOW_DYNAMIC, "dynamic");
    CASE(NK_WINDOW_ROM, "rom");
    CASE(NK_WINDOW_NOT_INTERACTIVE, "not interactive");
    CASE(NK_WINDOW_HIDDEN, "hidden");
    CASE(NK_WINDOW_CLOSED, "closed");
    CASE(NK_WINDOW_MINIMIZED, "minimized");
    CASE(NK_WINDOW_REMOVE_ROM, "remove rom");
#undef CASE

    return n;
    }

static int WindowFlags(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pushwindowflags(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkwindowflags(L, 1));
    return 1;
    }

#define Add_WindowFlags(L) \
    ADD(WINDOW_PRIVATE);\
    ADD(WINDOW_DYNAMIC);\
    ADD(WINDOW_ROM);\
    ADD(WINDOW_NOT_INTERACTIVE);\
    ADD(WINDOW_HIDDEN);\
    ADD(WINDOW_CLOSED);\
    ADD(WINDOW_MINIMIZED);\
    ADD(WINDOW_REMOVE_ROM);\

/*----------------------------------------------------------------------*
 | nk_chart_event
 *----------------------------------------------------------------------*/

static nk_flags checkchartevent(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
    CASE(NK_CHART_HOVERING, "hovering");
    CASE(NK_CHART_CLICKED, "clicked");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pushchartevent(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
    CASE(NK_CHART_HOVERING, "hovering");
    CASE(NK_CHART_CLICKED, "clicked");
#undef CASE

    return n;
    }

static int ChartEvent(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pushchartevent(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkchartevent(L, 1));
    return 1;
    }

#define Add_ChartEvent(L) \
    ADD(CHART_HOVERING);\
    ADD(CHART_CLICKED);\

/*----------------------------------------------------------------------*
 | nk_widget_layout_states
 *----------------------------------------------------------------------*/

static nk_flags checkwidgetlayoutstates(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
    CASE(NK_WIDGET_INVALID, "invalid");
    CASE(NK_WIDGET_VALID, "valid");
    CASE(NK_WIDGET_ROM, "rom");
    CASE(NK_WIDGET_DISABLED, "disabled");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pushwidgetlayoutstates(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
    CASE(NK_WIDGET_INVALID, "invalid");
    CASE(NK_WIDGET_VALID, "valid");
    CASE(NK_WIDGET_ROM, "rom");
    CASE(NK_WIDGET_DISABLED, "disabled");
#undef CASE

    return n;
    }

static int WidgetLayoutStates(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pushwidgetlayoutstates(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkwidgetlayoutstates(L, 1));
    return 1;
    }

#define Add_WidgetLayoutStates(L) \
    ADD(WIDGET_INVALID);\
    ADD(WIDGET_VALID);\
    ADD(WIDGET_ROM);\
    ADD(WIDGET_DISABLED);\

/*----------------------------------------------------------------------*
 | nk_style_header_align
 *----------------------------------------------------------------------*/

static nk_flags checkstyleheaderalign(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
        CASE(NK_HEADER_LEFT, "left");
        CASE(NK_HEADER_RIGHT, "right");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pushstyleheaderalign(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
        CASE(NK_HEADER_LEFT, "left");
        CASE(NK_HEADER_RIGHT, "right");
#undef CASE

    return n;
    }

static int StyleHeaderAlign(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pushstyleheaderalign(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkstyleheaderalign(L, 1));
    return 1;
    }

#define Add_StyleHeaderAlign(L) \
    ADD(HEADER_LEFT);\
    ADD(HEADER_RIGHT);\


/*------------------------------------------------------------------------------*
 | Additional utilities                                                         |
 *------------------------------------------------------------------------------*/

static int AddConstants(lua_State *L) /* nk.XXX constants for NK_XXX values */
    {
    Add_ConvertResult(L);
    Add_PanelFlags(L);
    Add_WidgetStates(L);
    Add_WidgetAlign(L);
    Add_TextAlign(L);
    Add_EditFlags(L);
    Add_EditEvents(L);
    Add_PanelType(L);
    Add_WindowFlags(L);
    Add_ChartEvent(L);
    Add_WidgetLayoutStates(L);
    Add_StyleHeaderAlign(L);
    return 0;
    }

static const struct luaL_Reg Functions[] = 
    {
        { "convertresultflags", ConvertResult },
        { "panelflags", PanelFlags },
        { "widgetstatesflags", WidgetStates },
        { "widgetalignflags", WidgetAlign },
        { "textalignflags", TextAlign },
        { "editflags", EditFlags },
        { "editeventsflags", EditEvents },
        { "paneltypeflags", PanelType },
        { "windowflags", WindowFlags },
        { "charteventflags", ChartEvent },
        { "widgetlayoutstatesflags", WidgetLayoutStates },
        { "styleheaderalign", StyleHeaderAlign },
        { NULL, NULL } /* sentinel */
    };


void moonnuklear_open_flags(lua_State *L)
    {
    AddConstants(L);
    luaL_setfuncs(L, Functions, 0);
    }


#if 0 // scaffolding

/*----------------------------------------------------------------------*
 | nk_ 
 *----------------------------------------------------------------------*/

static nk_flags checkzzz(lua_State *L, int arg) 
    {
    const char *s;
    nk_flags flags = 0;
    
    while(lua_isstring(L, arg))
        {
        s = lua_tostring(L, arg++);
#define CASE(CODE,str) if((strcmp(s, str)==0)) do { flags |= CODE; goto done; } while(0)
        CASE(NK_ZZZ_, "");
#undef CASE
        return (nk_flags)luaL_argerror(L, --arg, badvalue(L,s));
        done: ;
        }

    return flags;
    }

static int pushzzz(lua_State *L, nk_flags flags)
    {
    int n = 0;

#define CASE(CODE,str) do { if((flags & CODE)==CODE) { lua_pushstring(L, str); n++; } } while(0)
    CASE(NK_ZZZ_, "");
#undef CASE

    return n;
    }

static int Zzz(lua_State *L)
    {
    if(lua_type(L, 1) == LUA_TNUMBER)
        return pushzzz(L, luaL_checkinteger(L, 1));
    lua_pushinteger(L, checkzzz(L, 1));
    return 1;
    }

    Add_Zzz(L);
        { "zzz", Zzz },
#define Add_Zzz(L) \
    ADD(ZZZ_);\

#endif

