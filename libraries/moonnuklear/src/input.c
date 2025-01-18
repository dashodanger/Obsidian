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


/*-----------------------------------------------------------------------------
 | Context functions for input mirroring (back-end)
 *----------------------------------------------------------------------------*/

static int InputBegin(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_input_begin(context);
    return 0;
    }

static int InputEnd(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_input_end(context);
    return 0;
    }

static int InputMotion(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    int x = luaL_checkinteger(L, 2);
    int y = luaL_checkinteger(L, 3);
    nk_input_motion(context, x, y);
    return 0;
    }

static int InputKey(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_keys key = checkkeys(L, 2);
    int down = optboolean(L, 3, nk_false);
    nk_input_key(context, key, down);
    return 0;
    }

static int InputKeys(lua_State *L)
    {
    int key;
    int down[NK_KEY_MAX];
    nk_context_t *context = checkcontext(L, 1, NULL);
    if(echeckkeytable(L, 2, down)) return argerror(L, 2);
    for(key = 0; key < NK_KEY_MAX; key++)
        nk_input_key(context, (enum nk_keys)key, down[key]);
    return 0;
    }

static int InputButton(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    enum nk_buttons button = checkbuttons(L, 2);
    int x = luaL_checkinteger(L, 3);
    int y = luaL_checkinteger(L, 4);
    int down = optboolean(L, 5, nk_false);
    nk_input_button(context, button, x, y, down);
    return 0;
    }

static int InputScroll(lua_State *L)
    {
    nk_vec2_t scroll;
    nk_context_t *context = checkcontext(L, 1, NULL);
    scroll.x = luaL_checknumber(L, 2);
    scroll.y = luaL_checknumber(L, 3);
    nk_input_scroll(context, scroll);
    return 0;
    }

static int InputChar(lua_State *L)
    {
    int arg = 2;
    nk_context_t *context = checkcontext(L, 1, NULL);
    while(!lua_isnoneornil(L, arg))
        nk_input_char(context, luaL_checkinteger(L, arg++));
    return 0;
    }

static int InputGlyph(lua_State *L)
    {
    size_t len;
    nk_glyph glyph;
    nk_context_t *context = checkcontext(L, 1, NULL);
    const char* s = luaL_checklstring(L, 2, &len);
    if(len == 0 || len > NK_UTF_SIZE)
        return argerrorc(L, 2, ERR_LENGTH);
    memcpy(glyph, s, len);
    nk_input_glyph(context, glyph);
    return 0;
    }

static int InputUnicode(lua_State *L)
    {
    int arg = 2;
    nk_context_t *context = checkcontext(L, 1, NULL);
    while(!lua_isnoneornil(L, arg))
        nk_input_unicode(context, luaL_checkinteger(L, arg++));
    return 0;
    }

/*-----------------------------------------------------------------------------
 | Context methods for input retrieval (front-end)
 *----------------------------------------------------------------------------*/

static nk_input_t* checkinput(lua_State *L, int arg)
    {
    nk_context_t *context = checkcontext(L, arg, NULL);
    return context ? &context->input : NULL;
    }

#define F(Func, func) /* boolean = func(input, button) */       \
static int Func(lua_State *L)                                   \
    {                                                           \
    const nk_input_t *input = checkinput(L, 1);                 \
    enum nk_buttons button = checkbuttons(L, 2);                \
    lua_pushboolean(L, func(input, button));                    \
    return 1;                                                   \
    }
F(Has_mouse_click, nk_input_has_mouse_click)
F(Is_mouse_down, nk_input_is_mouse_down)
F(Is_mouse_pressed, nk_input_is_mouse_pressed)
F(Is_mouse_released, nk_input_is_mouse_released)
#undef F

#define F(Func, func) /* boolean = func(input, button, rect) */ \
static int Func(lua_State *L)                                   \
    {                                                           \
    nk_rect_t rect;                                             \
    const nk_input_t *input = checkinput(L, 1);                 \
    enum nk_buttons button = checkbuttons(L, 2);                \
    if(echeckrect(L, 3, &rect)) return argerror(L, 3);          \
    lua_pushboolean(L, func(input, button, rect));              \
    return 1;                                                   \
    }
F(Has_mouse_click_in_rect, nk_input_has_mouse_click_in_rect)
F(Is_mouse_click_in_rect, nk_input_is_mouse_click_in_rect)
F(Mouse_clicked, nk_input_mouse_clicked)
F(Has_mouse_click_in_button_rect, nk_input_has_mouse_click_in_button_rect)
#undef F

#define F(Func, func) /* boolean = func(input, button, rect, down) */   \
static int Func(lua_State *L)                                   \
    {                                                           \
    int down;                                                   \
    nk_rect_t rect;                                             \
    const nk_input_t *input = checkinput(L, 1);                 \
    enum nk_buttons button = checkbuttons(L, 2);                \
    if(echeckrect(L, 3, &rect)) return argerror(L, 3);          \
    down = optboolean(L, 4, nk_false);                          \
    lua_pushboolean(L, func(input, button, rect, down));        \
    return 1;                                                   \
    }
F(Has_mouse_click_down_in_rect, nk_input_has_mouse_click_down_in_rect)
F(Is_mouse_click_down_in_rect, nk_input_is_mouse_click_down_in_rect)
#undef F

#define F(Func, func) /* boolean = func(input, rect) */         \
static int Func(lua_State *L)                                   \
    {                                                           \
    nk_rect_t rect;                                             \
    const nk_input_t *input = checkinput(L, 1);                 \
    if(echeckrect(L, 2, &rect)) return argerror(L, 2);          \
    lua_pushboolean(L, func(input, rect));                      \
    return 1;                                                   \
    }

F(Any_mouse_click_in_rect, nk_input_any_mouse_click_in_rect)
F(Is_mouse_prev_hovering_rect, nk_input_is_mouse_prev_hovering_rect)
F(Is_mouse_hovering_rect, nk_input_is_mouse_hovering_rect)
#undef F

#define F(Func, func) /* boolean = func(input, key) */          \
static int Func(lua_State *L)                                   \
    {                                                           \
    const nk_input_t *input = checkinput(L, 1);                 \
    enum nk_keys key = checkkeys(L, 2);                         \
    lua_pushboolean(L, func(input, key));                       \
    return 1;                                                   \
    }
F(Is_key_pressed, nk_input_is_key_pressed)
F(Is_key_released, nk_input_is_key_released)
F(Is_key_down, nk_input_is_key_down)
#undef F

static int Mouse_delta(lua_State *L)
    {
    const nk_input_t *input = checkinput(L, 1);
    lua_pushnumber(L, input->mouse.delta.x);
    lua_pushnumber(L, input->mouse.delta.y);
    return 2;
    }

static int Mouse_scroll_delta(lua_State *L)
    {
    const nk_input_t *input = checkinput(L, 1);
    lua_pushnumber(L, input->mouse.scroll_delta.x);
    lua_pushnumber(L, input->mouse.scroll_delta.y);
    return 2;
    }

static int Input_mouse_pos(lua_State *L)
    {
    nk_input_t *input = checkinput(L, 1);
    float x = luaL_checknumber(L, 2);
    float y = luaL_checknumber(L, 3);
    input->mouse.pos.x = x;
    input->mouse.pos.y = y;
    return 0;
    }

static int Mouse_pos(lua_State *L)
    {
    const nk_input_t *input = checkinput(L, 1);
    lua_pushnumber(L, input->mouse.pos.x);
    lua_pushnumber(L, input->mouse.pos.y);
    return 2;
    }

static int Mouse_prev(lua_State *L)
    {
    const nk_input_t *input = checkinput(L, 1);
    lua_pushnumber(L, input->mouse.prev.x);
    lua_pushnumber(L, input->mouse.prev.y);
    return 2;
    }


#define F(Func, what)                           \
static int Mouse_##what(lua_State *L)           \
    {                                           \
    const nk_input_t *input = checkinput(L, 1); \
    lua_pushboolean(L, input->mouse.what);      \
    return 1;                                   \
    }

F(Mouse_grabbed, grabbed)
F(Mouse_grab, grab)
F(Mouse_ungrab, ungrab)

#undef F

static const struct luaL_Reg Methods[] = 
    {
        { "has_mouse_click", Has_mouse_click },
        { "has_mouse_click_in_rect", Has_mouse_click_in_rect },
        { "has_mouse_click_down_in_rect", Has_mouse_click_down_in_rect },
        { "has_mouse_click_in_button_rect", Has_mouse_click_in_button_rect },
        { "is_mouse_click_in_rect", Is_mouse_click_in_rect },
        { "is_mouse_click_down_in_rect", Is_mouse_click_down_in_rect },
        { "any_mouse_click_in_rect", Any_mouse_click_in_rect },
        { "is_mouse_prev_hovering_rect", Is_mouse_prev_hovering_rect },
        { "is_mouse_hovering_rect", Is_mouse_hovering_rect },
        { "mouse_clicked", Mouse_clicked },
        { "is_mouse_down", Is_mouse_down },
        { "is_mouse_pressed", Is_mouse_pressed },
        { "is_mouse_released", Is_mouse_released },
        { "mouse_delta", Mouse_delta },
        { "mouse_scroll_delta", Mouse_scroll_delta },
        { "mouse_pos", Mouse_pos },
        { "mouse_prev", Mouse_prev },
        { "is_key_pressed", Is_key_pressed },
        { "is_key_released", Is_key_released },
        { "is_key_down", Is_key_down },
        { "mouse_grabbed", Mouse_grabbed },
        { "mouse_grab", Mouse_grab },
        { "mouse_ungrab", Mouse_ungrab },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg Functions[] = 
    {
        /* input mirroring */
        { "input_begin", InputBegin },
        { "input_end", InputEnd },
        { "input_motion", InputMotion },
        { "input_mouse_pos", Input_mouse_pos },
        { "input_key", InputKey },
        { "input_keys", InputKeys },
        { "input_button", InputButton },
        { "input_scroll", InputScroll },
        { "input_char", InputChar },
        { "input_glyph", InputGlyph },
        { "input_unicode", InputUnicode },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_input(lua_State *L)
    {
    udata_addmethods(L, CONTEXT_MT, Methods);
    luaL_setfuncs(L, Functions, 0);
    }

