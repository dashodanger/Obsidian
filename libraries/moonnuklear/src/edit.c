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

static int freeedit(lua_State *L, ud_t *ud)
    {
    nk_edit_t *edit = (nk_edit_t*)ud->handle;
    int associated_with_context = IsAssociatedWithContext(ud);
    char * buf = ud->buf;
    if(!freeuserdata(L, ud, "edit")) return 0;
    if(buf) Free(L, buf);
    if(associated_with_context) return 0; /* don't free it, because it is owned by Nuklear */
    nk_textedit_free(edit);
    Free(L, edit);
    return 0;
    }


int newedit(lua_State *L, ud_t *ud_context)
/* pushes the edit associated with the context */
    {
    nk_context_t *context = (nk_context_t*)ud_context->handle;
    nk_edit_t *edit = &context->text_edit;
    ud_t *ud = userdata(edit);

    if(ud) /* already in */
        return pushedit(L, edit);
    ud = newuserdata(L, edit, EDIT_MT, "edit");
    ud->parent_ud = ud_context;
    ud->context = context;
    ud->destructor = freeedit;
    MarkAssociatedWithContext(ud);
    return 1;
    }

#if 0
static int New(lua_State *L)
    {
    ud_t *ud;
    nk_edit_t *edit;
    edit = (nk_edit_t*)Malloc(L, sizeof(nk_edit_t));
    nk_textedit_init_default(edit);
    ud = newuserdata(L, edit, EDIT_MT, "edit");
    ud->parent_ud = NULL;
    ud->context = NULL;
    ud->destructor = freeedit;
    return 1;
    }
#endif

static int Edit_text(lua_State *L)
    {
    size_t len;
    nk_edit_t *edit = checkedit(L, 1, NULL);
    const char *s = luaL_checklstring(L, 2, &len);
    nk_textedit_text(edit, s, len);
    return 0;
    }

static int Edit_delete(lua_State *L)
    {
    nk_edit_t *edit = checkedit(L, 1, NULL);
    int where = luaL_checkinteger(L, 2);
    int len = luaL_checkinteger(L, 3);
    nk_textedit_delete(edit, where, len);
    return 0;
    }

static int Edit_delete_selection(lua_State *L)
    {
    nk_edit_t *edit = checkedit(L, 1, NULL);
    nk_textedit_delete_selection(edit);
    return 0;
    }

static int Edit_select_all(lua_State *L)
    {
    nk_edit_t *edit = checkedit(L, 1, NULL);
    nk_textedit_select_all(edit);
    return 0;
    }

static int Edit_cut(lua_State *L)
    {
    nk_edit_t *edit = checkedit(L, 1, NULL);
    lua_pushboolean(L, nk_textedit_cut(edit));
    return 1;
    }

static int Edit_paste(lua_State *L)
    {
    size_t len;
    nk_edit_t *edit = checkedit(L, 1, NULL);
    const char *s = luaL_checklstring(L, 2, &len);
    lua_pushboolean(L, nk_textedit_paste(edit, s, (int)len));
    return 1;
    }

static int Edit_undo(lua_State *L)
    {
    nk_edit_t *edit = checkedit(L, 1, NULL);
    nk_textedit_undo(edit);
    return 0;
    }

static int Edit_redo(lua_State *L)
    {
    nk_edit_t *edit = checkedit(L, 1, NULL);
    nk_textedit_redo(edit);
    return 0;
    }

#if 0 //@@ 8yy
        { "",  },
static int (lua_State *L) //@@
    {
    nk_edit_t *edit = checkedit(L, 1, NULL);
    (void)edit;
    return 0;
    }

//void nk_textedit_init(edit, nk_allocator_t*, nk_size size);
//void nk_textedit_init_fixed(edit, void *memory, nk_size size);

struct nk_text_edit {
    struct nk_clipboard clip;
    struct nk_str string;
    nk_plugin_filter filter;
    struct nk_vec2 scrollbar;

    int cursor;
    int select_start;
    int select_end;
    unsigned char mode;
    unsigned char cursor_at_end_of_line;
    unsigned char initialized;
    unsigned char has_preferred_x;
    unsigned char single_line;
    unsigned char active;
    unsigned char padding1;
    float preferred_x;
    struct nk_text_undo_state undo;
};

#endif


/*-----------------------------------------------------------------------------
  | context->text_edit
 *----------------------------------------------------------------------------*/

#define F(Func, func) /* int func(edit, rune) */        \
static int Func(lua_State *L)                           \
    {                                                   \
    nk_edit_t *edit = checkedit(L, 1, NULL);    \
    nk_rune unicode = luaL_checkinteger(L, 2);          \
    lua_pushboolean(L, func(edit, unicode));            \
    return 1;                                           \
    }

F(Filter_default, nk_filter_default)
F(Filter_ascii, nk_filter_ascii)
F(Filter_float, nk_filter_float)
F(Filter_decimal, nk_filter_decimal)
F(Filter_hex, nk_filter_hex)
F(Filter_oct, nk_filter_oct)
F(Filter_binary, nk_filter_binary)

#undef F

static int Filter(const nk_edit_t *edit, nk_rune unicode) /* nk_plugin_filter */
    {
#define L moonnuklear_L
    int rc;
    ud_t *ud = userdata((void*)edit);
    pushvalue(L, ud->ref1);
    pushedit(L, (nk_edit_t*)edit);
    lua_pushinteger(L, unicode);
    if(lua_pcall(L, 2, 1, 0) != LUA_OK)
        { lua_error(L); return 0; }
    rc = checkboolean(L, -1);
    lua_pop(L, 1);
    return rc;
#undef L
    }

int edit_string(lua_State *L)
    {
    size_t in_len;
    nk_plugin_filter filter = NULL;
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_edit_t *edit = &context->text_edit;
    ud_t *ud = userdata(edit);
    nk_flags flags = checkflags(L, 2); /* editflags */
    const char *in_text = luaL_checklstring(L, 3, &in_len);
    int max = luaL_checkinteger(L, 4);
    int len = (int)in_len;
    int custom_filter = 0;
    if(lua_isfunction(L, 5))
        custom_filter = 1;
    else
        filter = testpluginfilter(L, 5);

    if(max == 0 || max < len) return argerrorc(L, 4, ERR_VALUE); /* too small */
    /* allocate or reallocate the internal buffer, if needed */
    if(!ud->buf || ud->bufsize < max)
        {
        if(ud->buf) Free(L, ud->buf);
        ud->buf = (char*)Malloc(L, max);
        ud->bufsize = max;
        }
    if(in_len>0) 
        memcpy(ud->buf, in_text, in_len);

    if(custom_filter)
        {
        /* get the plugin filter */
        if(!lua_isfunction(L, 5))
            return argerrorc(L, 5, ERR_TYPE);
        unreference(L, ud->ref1);
        lua_pushvalue(L, 5);
        ud->ref1 = luaL_ref(L, LUA_REGISTRYINDEX);
        }
    /* eventually execute the function */
    flags = nk_edit_string(context, flags, ud->buf, &len, max, custom_filter ? Filter : filter);
    if(len == 0)
        lua_pushstring(L, "");
    else
        lua_pushlstring(L, ud->buf, len);
    pushflags(L, flags); /* widgetlayoutstates */
    return 2;
    }

//nk_flags nk_edit_buffer(nk_context_t*, nk_flags, nk_edit_t*, nk_plugin_filter);
int edit_buffer(lua_State *L) //@@ serve?
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    (void)context;
    return 0;
    }

int edit_focus(lua_State *L)
    {
    nk_flags flags;
    nk_context_t *context = checkcontext(L, 1, NULL);
    flags = checkflags(L, 2);
    nk_edit_focus(context, flags); /* editflags */
    return 0;
    }

int edit_unfocus(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_edit_unfocus(context);
    return 0;
    }

TYPE_FUNC(edit)
DELETE_FUNC(edit)

static const struct luaL_Reg Methods[] = 
    {
        { "type", Type },
//      { "free",  Delete }, @@ serve ?
        { "text", Edit_text },
        { "delete", Edit_delete },
        { "delete_selection", Edit_delete_selection },
        { "select_all", Edit_select_all },
        { "cut", Edit_cut },
        { "paste", Edit_paste },
        { "undo", Edit_undo },
        { "redo", Edit_redo },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg MetaMethods[] = 
    {
        { "__gc",  Delete },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg Functions[] = 
    {
//      { "new_edit", New }, @@ serve?
        // built-in plugin filters:
        { "filter_default", Filter_default },
        { "filter_ascii", Filter_ascii },
        { "filter_float", Filter_float },
        { "filter_decimal", Filter_decimal },
        { "filter_hex", Filter_hex },
        { "filter_oct", Filter_oct },
        { "filter_binary", Filter_binary },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_edit(lua_State *L)
    {
    udata_define(L, EDIT_MT, Methods, MetaMethods);
    luaL_setfuncs(L, Functions, 0);
    }

