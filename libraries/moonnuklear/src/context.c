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

#undef userdata /* to avoid clash between context->clip.userdata and moonnuklear_userdata */

static int freecontext(lua_State *L, ud_t *ud)
    {
    nk_context_t *context = (nk_context_t*)ud->handle;
    float *ratio = ud->ratio;   
    int borrowed = IsBorrowed(ud);
    freechildren(L, PANEL_MT, ud);
    freechildren(L, EDIT_MT, ud);
    if(!freeuserdata(L, ud, "context")) return 0;
    if(ratio) Free(L, ratio);
    if(!borrowed)
        {
        nk_free(context);
        Free(L, context);
        }
    return 0;
    }

static int Init(lua_State *L)
    {
    ud_t *ud;
    nk_context_t *context;
    nk_user_font_t *font = testfont(L, 1, NULL);
    context = (nk_context_t*)Malloc(L, sizeof(nk_context_t));
    if(!nk_init_default(context, font))
        {
        Free(L, context);
        return luaL_error(L, "cannot create context");
        }
    //int nk_init(nk_context_t*, nk_allocator_t*, const nk_user_font_t*);
    //int nk_init_fixed(nk_context_t*, void *memory, nk_size size, const nk_user_font_t*);
    //int nk_init_custom(nk_context_t*, nk_buffer_t *cmds, nk_buffer_t *pool, const nk_user_font_t*);
    ud = newuserdata(L, context, CONTEXT_MT, "context");
    ud->parent_ud = NULL;
    ud->destructor = freecontext;
    context->clip.userdata.ptr = ud;
    /* create also the associated edit, but pop its userdata */
    newedit(L, ud);
    lua_pop(L, 1);
    return 1;
    }


static int InitFromPtr(lua_State *L)
    {
    ud_t *ud;
    nk_context_t *context = (nk_context_t*)checklightuserdata(L, 1);
    ud = newuserdata(L, context, CONTEXT_MT, "context (ptr)");
    ud->parent_ud = NULL;
    ud->destructor = freecontext;
    context->clip.userdata.ptr = ud;
    MarkBorrowed(ud);
    /* create also the associated edit, but pop its userdata */
    newedit(L, ud);
    lua_pop(L, 1);
    return 1;
    }


static int Clear(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_clear(context);
    return 0;
    }

static int Edit(lua_State *L)
/* returns the edit associated with this context */
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    pushedit(L, &context->text_edit);
    return 1;
    }

static int Font(lua_State *L)
    {
    nk_context_t *context = checkcontext(L, 1, NULL);
    if(!context->style.font)
        return 0;
    pushfont(L, (void*)context->style.font);
    return 1;
    }

static void PluginPaste(nk_handle handle, nk_edit_t *edit) /* nk_plugin_paste */
    {
#define L moonnuklear_L
    ud_t *ud = (ud_t*)(handle.ptr);
    pushvalue(L, ud->ref1);
    pushedit(L, edit);
    if(lua_pcall(L, 1, 0, 0) != LUA_OK)
        { lua_error(L); return; }
#undef L
    }

static int Set_clipboard_paste(lua_State *L)
    {
    ud_t *ud;
    nk_context_t *context = checkcontext(L, 1, &ud);
    if(!lua_isfunction(L, 2))
        return argerrorc(L, 2, ERR_TYPE);
    unreference(L, ud->ref1);
    lua_pushvalue(L, 2);
    ud->ref1 = luaL_ref(L, LUA_REGISTRYINDEX);
    context->clip.paste = PluginPaste;
    return 0;
    }

static void PluginCopy(nk_handle handle, const char *text, int len) /* nk_plugin_copy */
    {
#define L moonnuklear_L
    ud_t *ud = (ud_t*)(handle.ptr);
    pushvalue(L, ud->ref2);
    lua_pushlstring(L, text, len);
    if(lua_pcall(L, 1, 0, 0) != LUA_OK)
        { lua_error(L); return; }
#undef L
    }

static int Set_clipboard_copy(lua_State *L)
    {
    ud_t *ud;
    nk_context_t *context = checkcontext(L, 1, &ud);
    if(!lua_isfunction(L, 2))
        return argerrorc(L, 2, ERR_TYPE);
    unreference(L, ud->ref2);
    lua_pushvalue(L, 2);
    ud->ref2 = luaL_ref(L, LUA_REGISTRYINDEX);
    context->clip.copy = PluginCopy;
    return 0;
    }

static int Convert(lua_State *L)
    {
    ud_t *ud;
    nk_context_t *context = checkcontext(L, 1, &ud);
    nk_buffer_t *cmds = checkbuffer(L, 2, NULL);
    nk_buffer_t *vertices = checkbuffer(L, 3, NULL);
    nk_buffer_t *elements = checkbuffer(L, 4, NULL);
    //BUFFER_PRINT(vertices, 16);
    //BUFFER_PRINT(elements, 16);
    nk_flags result = nk_convert(context, cmds, vertices, elements, &ud->config);
    pushflags(L, result);
    return 1;
    }

static int Commands(lua_State *L)
    {
    int i = 1;
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_command_t *cmd = (nk_command_t*)nk__begin(context);
    lua_newtable(L);
    while(cmd)
        {
        pushcommand(L, cmd);
        lua_rawseti(L, -2, i++);
        cmd = (nk_command_t*)nk__next(context, cmd);
        }
    return 1;
    }

static int DrawCommands(lua_State *L)
    {
    int i = 1;
    nk_context_t *context = checkcontext(L, 1, NULL);
    nk_buffer_t *cmds = checkbuffer(L, 2, NULL);
    nk_draw_command_t *cmd = (nk_draw_command_t*)nk__draw_begin(context, cmds);
    lua_newtable(L);
    while(cmd)
        {
        pushdrawcommand(L, cmd);
        lua_rawseti(L, -2, i++);
        cmd = (nk_draw_command_t*)nk__draw_next(cmd, cmds, context);
        }
    return 1;
    }

/*-----------------------------------------------------------------------------
 | nk_convert_config_t
 *-----------------------------------------------------------------------------*/

static int Config_reset(lua_State *L)
    {
    ud_t *ud; (void)checkcontext(L, 1, &ud);
    memset(&ud->config, 0, sizeof(nk_convert_config_t));
    return 0;
    }


static int Global_alpha(lua_State *L)
    {
    ud_t *ud; (void)checkcontext(L, 1, &ud);
    ud->config.global_alpha = luaL_checknumber(L, 2);
    return 0;
    }

static int Line_anti_aliasing(lua_State *L)
    {
    ud_t *ud; (void)checkcontext(L, 1, &ud);
    ud->config.line_AA = checkboolean(L, 2) ? NK_ANTI_ALIASING_ON : NK_ANTI_ALIASING_OFF;
    return 0;
    }

static int Shape_anti_aliasing(lua_State *L)
    {
    ud_t *ud; (void)checkcontext(L, 1, &ud);
    ud->config.shape_AA = checkboolean(L, 2) ? NK_ANTI_ALIASING_ON : NK_ANTI_ALIASING_OFF;
    return 0;
    }

#define F(Func, what)                                   \
static int Func(lua_State *L)                           \
    {                                                   \
    ud_t *ud; (void)checkcontext(L, 1, &ud);            \
    ud->config.what = luaL_checkinteger(L, 2);          \
    return 0;                                           \
    }

F(Circle_segment_count, circle_segment_count)
F(Arc_segment_count, arc_segment_count)
F(Curve_segment_count, curve_segment_count)
F(Vertex_size, vertex_size)
F(Vertex_alignment, vertex_alignment) //@@
#undef F

static int Null_texture(lua_State *L)
    {
    nk_handle_t handle;
    nk_vec2_t uv;
    ud_t *ud; (void)checkcontext(L, 1, &ud);
    if(echeckvec2(L, 3, &uv)) return argerror(L, 3);
    if(lua_isnoneornil(L, 2))
        ud->config.tex_null.texture.id = 0;
    else
        {
        handle.id = luaL_checkinteger(L, 2);
        ud->config.tex_null.texture = handle;
        }
    ud->config.tex_null.uv = uv;
    return 0;
    }

static int Vertex_layout(lua_State *L)
    {
#define element_t nk_draw_vertex_layout_element_t /* too long for me.. */
    int i, n, err;
    ud_t *ud; 
    element_t *layout;
    (void)checkcontext(L, 1, &ud);
    n = luaL_len(L, 2);
    layout =(element_t*)Malloc(L, (n+1)*sizeof(element_t));
    for(i=0; i< n; i++)
        {
        lua_rawgeti(L, 2, i+1);
        err = echeckdrawvertexlayoutelement(L, -1, &(layout[i]));
        if(err)
            { Free(L, layout); return argerror(L, 2); }
        lua_pop(L, 1);
        }
    layout[n].attribute = NK_VERTEX_ATTRIBUTE_COUNT;
    layout[n].format = NK_FORMAT_COUNT;
    layout[n].offset = 0;
    /* free old layout, if any */
    if(ud->config.vertex_layout) Free(L, (void*)ud->config.vertex_layout);
    ud->config.vertex_layout = layout;
    return 0;
#undef element_t
    }

RAW_FUNC(context)
TYPE_FUNC(context)
DELETE_FUNC(context)

static const struct luaL_Reg Methods[] = 
    {
        { "type", Type },
        { "free",  Delete },
        { "raw",  Raw },
        { "edit", Edit },
        { "font", Font },
        { "convert", Convert },
        { "commands", Commands },
        { "draw_commands", DrawCommands },
        { "clear",  Clear },
        { "set_clipboard_paste", Set_clipboard_paste },
        { "set_clipboard_copy", Set_clipboard_copy },
        { "config_reset", Config_reset },
        { "config_global_alpha", Global_alpha },
        { "config_line_aa", Line_anti_aliasing },
        { "config_shape_aa", Shape_anti_aliasing },
        { "config_circle_segment_count", Circle_segment_count },
        { "config_arc_segment_count", Arc_segment_count },
        { "config_curve_segment_count", Curve_segment_count },
        { "config_null_texture", Null_texture },
        { "config_vertex_layout", Vertex_layout },
        { "config_vertex_size", Vertex_size },
        { "config_vertex_alignment", Vertex_alignment },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg MetaMethods[] = 
    {
        { "__gc",  Delete },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg Functions[] = 
    {
        { "init", Init },
        { "init_from_ptr", InitFromPtr },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_context(lua_State *L)
    {
    udata_define(L, CONTEXT_MT, Methods, MetaMethods);
    luaL_setfuncs(L, Functions, 0);
    }

