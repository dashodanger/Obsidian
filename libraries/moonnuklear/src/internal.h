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

/********************************************************************************
 * Internal common header                                                       *
 ********************************************************************************/

#ifndef internalDEFINED
#define internalDEFINED

#include <string.h>
#include <stdlib.h>
#include <time.h>
#include "moonnuklear.h"

#define TOSTR_(x) #x
#define TOSTR(x) TOSTR_(x)

#include "objects.h"
#include "enums.h"

/* Note: all the dynamic symbols of this library (should) start with 'moonnuklear_' .
 * The only exception is the luaopen_moonnuklear() function, which is searched for
 * with that name by Lua.
 * MoonNuklear's string references on the Lua registry also start with 'moonnuklear_'.
 */

#if 0
/* .c */
#define  moonnuklear_
#endif

/* utils.c */
#define noprintf moonnuklear_noprintf
int noprintf(const char *fmt, ...); 
#define notavailable moonnuklear_notavailable
int notavailable(lua_State *L, ...);
#define Malloc moonnuklear_Malloc
void *Malloc(lua_State *L, size_t size);
#define MallocNoErr moonnuklear_MallocNoErr
void *MallocNoErr(lua_State *L, size_t size);
#define Strdup moonnuklear_Strdup
char *Strdup(lua_State *L, const char *s);
#define Free moonnuklear_Free
void Free(lua_State *L, void *ptr);
#define checkboolean moonnuklear_checkboolean
int checkboolean(lua_State *L, int arg);
#define testboolean moonnuklear_testboolean
int testboolean(lua_State *L, int arg, int *err);
#define optboolean moonnuklear_optboolean
int optboolean(lua_State *L, int arg, int d);
#define testindex moonnuklear_testindex
int testindex(lua_State *L, int arg, int *err);
#define checkindex moonnuklear_checkindex
int checkindex(lua_State *L, int arg);
#define optindex moonnuklear_optindex
int optindex(lua_State *L, int arg, int optval);
#define pushindex moonnuklear_pushindex
void pushindex(lua_State *L, int val);
#define checklightuserdata moonnuklear_checklightuserdata
void *checklightuserdata(lua_State *L, int arg);
#define checklightuserdataorzero moonnuklear_checklightuserdataorzero
void *checklightuserdataorzero(lua_State *L, int arg);
#define optlightuserdata moonnuklear_optlightuserdata
void *optlightuserdata(lua_State *L, int arg);
#define checkstringlist moonnuklear_checkstringlist
char** checkstringlist(lua_State *L, int arg, int *count, int *err);
#define freestringlist moonnuklear_freestringlist
void freestringlist(lua_State *L, char** list, int count);
#define pushstringlist moonnuklear_pushstringlist
void pushstringlist(lua_State *L, char** list, int count);
#define checkfloatlist moonnuklear_checkfloatlist
float* checkfloatlist(lua_State *L, int arg, int *count, int *err);
#define freefloatlist moonnuklear_freefloatlist
void freefloatlist(lua_State *L, float* list, int count);
#define pushfloatlist moonnuklear_pushfloatlist
void pushfloatlist(lua_State *L, float *list, int count);
#define checkvec2list moonnuklear_checkvec2list
float* checkvec2list(lua_State *L, int arg, int *count, int *err);
#define freevec2list moonnuklear_freevec2list
void freevec2list(lua_State *L, float* list, int count);
#define checkvec2ilist moonnuklear_checkvec2ilist
float* checkvec2ilist(lua_State *L, int arg, int *count, int *err);
#define freevec2ilist moonnuklear_freevec2ilist
void freevec2ilist(lua_State *L, float* list, int count);
#define checkrunelist moonnuklear_checkrunelist
nk_rune* checkrunelist(lua_State *L, int arg, int *count, int *err);
#define freerunelist moonnuklear_freerunelist
void freerunelist(lua_State *L, nk_rune* list);
#define pushrunelist moonnuklear_pushrunelist
void pushrunelist(lua_State *L, const nk_rune *list);


/* structs.c */
#define echeckvec2 moonnuklear_echeckvec2
int echeckvec2(lua_State *L, int arg, nk_vec2_t *p);
#define pushvec2 moonnuklear_pushvec2
int pushvec2(lua_State *L, nk_vec2_t *p);
#define echeckvec2i moonnuklear_echeckvec2i
int echeckvec2i(lua_State *L, int arg, nk_vec2i_t *p);
#define pushvec2i moonnuklear_pushvec2i
int pushvec2i(lua_State *L, nk_vec2i_t *p);
#define echeckscroll moonnuklear_echecscrollk
int echeckscroll(lua_State *L, int arg, nk_scroll_t *p);
#define pushscroll moonnuklear_pusscrollh
int pushscroll(lua_State *L, nk_scroll_t *p);
#define echeckrect moonnuklear_echeckrect
int echeckrect(lua_State *L, int arg, nk_rect_t *p);
#define pushrect moonnuklear_pushrect
int pushrect(lua_State *L, nk_rect_t *src);
#define echeckcolor moonnuklear_echeckcolor
int echeckcolor(lua_State *L, int arg, nk_color_t *p);
#define pushcolor moonnuklear_pushcolor
int pushcolor(lua_State *L, nk_color_t *p);
#define echeckcolorf moonnuklear_echeckcolorf
int echeckcolorf(lua_State *L, int arg, nk_colorf_t *p);
#define pushcolorf moonnuklear_pushcolorf
int pushcolorf(lua_State *L, nk_colorf_t *p);
#define echeckcolortable moonnuklear_echeckcolortable
int echeckcolortable(lua_State *L, int arg, nk_color_t p[NK_COLOR_COUNT], nk_color_t defcolor);
#define echeckkeytable moonnuklear_echeckkeytable
int echeckkeytable(lua_State *L, int arg, int p[NK_KEY_MAX]);
#define pushmemorystatus moonnuklear_pushmemorystatus
int pushmemorystatus(lua_State *L, nk_memory_status_t *p);
#define echeckdrawvertexlayoutelement moonnuklear_echeckdrawvertexlayoutelement
int echeckdrawvertexlayoutelement(lua_State *L, int arg, nk_draw_vertex_layout_element_t *p);
#define checkstyleitem moonnuklear_checkstyleitem
nk_style_item_t checkstyleitem(lua_State *L, int arg);
#define pushstyleitem moonnuklear_pushstyleitem
int pushstyleitem(lua_State *L, nk_style_item_t *p);
#define pushfontglyph moonnuklear_pushfontglyph
int pushfontglyph(lua_State *L, const nk_font_glyph_t *p);
#define pushcommand moonnuklear_pushcommand
int pushcommand(lua_State *L, nk_command_t *p);
#define pushdrawcommand moonnuklear_pushdrawcommand
int pushdrawcommand(lua_State *L, nk_draw_command_t *p);
#define testpluginfilter moonnuklear_testpluginfilter
nk_plugin_filter testpluginfilter(lua_State *L, int arg);
#define echeckfontconfig moonnuklear_echeckfontconfig
nk_font_config_t *echeckfontconfig(lua_State *L, int arg, float height, int *err);
#define freefontconfig moonnuklear_freefontconfig
void freefontconfig(lua_State *L, nk_font_config_t *p);

#define checkflags(L, arg) (nk_flags)luaL_checkinteger((L), (arg))
#define pushflags(L, val) lua_pushinteger((L), (val))

/* Internal error codes */
#define ERR_NOTPRESENT       1
#define ERR_SUCCESS          0
#define ERR_GENERIC         -1
#define ERR_TYPE            -2
#define ERR_VALUE           -3
#define ERR_TABLE           -4
#define ERR_EMPTY           -5
#define ERR_MEMORY          -6
#define ERR_MALLOC_ZERO     -7
#define ERR_LENGTH          -8
#define ERR_POOL            -9
#define ERR_BOUNDARIES      -10
#define ERR_UNKNOWN         -11
#define ERR_FAILED          -12
#define ERR_COUNT           -13
#define ERR_RANGE           -14
#define errstring moonnuklear_errstring
const char* errstring(int err);

/* tracing.c */
#define trace_objects moonnuklear_trace_objects
extern int trace_objects;

/* main.c */
extern lua_State *moonnuklear_L;
int luaopen_moonnuklear(lua_State *L);
void moonnuklear_open_versions(lua_State *L);
void moonnuklear_open_enums(lua_State *L);
void moonnuklear_utils_init(lua_State *L);
void moonnuklear_open_flags(lua_State *L);
void moonnuklear_open_tracing(lua_State *L);
void moonnuklear_open_input(lua_State *L);
void moonnuklear_open_window(lua_State *L);
void moonnuklear_open_layout(lua_State *L);
void moonnuklear_open_widgets(lua_State *L);
void moonnuklear_open_style(lua_State *L);
void moonnuklear_open_context(lua_State *L);
void moonnuklear_open_atlas(lua_State *L);
void moonnuklear_open_font(lua_State *L);
void moonnuklear_open_buffer(lua_State *L);
void moonnuklear_open_image(lua_State *L);
void moonnuklear_open_nine_slice(lua_State *L);
void moonnuklear_open_cursor(lua_State *L);
void moonnuklear_open_edit(lua_State *L);
void moonnuklear_open_canvas(lua_State *L);
void moonnuklear_open_panel(lua_State *L);

/*------------------------------------------------------------------------------*
 | Debug and other utilities                                                    |
 *------------------------------------------------------------------------------*/

#define argerror(L, arg) luaL_argerror((L), (arg), lua_tostring((L), -1))
#define argerrorc(L, arg, err_code) luaL_argerror((L), (arg), errstring(err_code))
#define errorc(L, err_code) luaL_error((L), errstring(err_code))

/* If this is printed, it denotes a suspect bug: */
#define UNEXPECTED_ERROR "unexpected error (%s, %d)", __FILE__, __LINE__
#define unexpected(L) luaL_error((L), UNEXPECTED_ERROR)

#define notsupported(L) luaL_error((L), "operation not supported")

#define badvalue(L,s)   lua_pushfstring((L), "invalid value '%s'", (s))

/* Dynamic referencing on the Lua registry */

#define reference(L, dst, arg) do {                 \
    lua_pushvalue((L), (arg));                      \
    (dst) = luaL_ref((L), LUA_REGISTRYINDEX);       \
} while(0)

#define unreference(L, ref) do {                    \
    if((ref)!=LUA_NOREF) {                          \
        luaL_unref((L), LUA_REGISTRYINDEX, (ref));  \
        (ref) = LUA_NOREF; }                        \
} while(0)

#define pushvalue(L, ref) /* returns LUA_TXXX */    \
    lua_rawgeti((L), LUA_REGISTRYINDEX, (ref)) 


/* DEBUG -------------------------------------------------------- */
#if defined(DEBUG)

#define DBG printf
#define TR() do { printf("trace %s %d\n",__FILE__,__LINE__); } while(0)
#define BK() do { printf("break %s %d\n",__FILE__,__LINE__); getchar(); } while(0)

#else 

#define DBG noprintf
#define TR()
#define BK()

#endif /* DEBUG ------------------------------------------------- */

#endif /* internalDEFINED */
