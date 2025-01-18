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


static int freebuffer(lua_State *L, ud_t *ud)
    {
    nk_buffer_t *buffer = (nk_buffer_t*)ud->handle;
    int is_initialized = IsInitialized(ud);
    if(!freeuserdata(L, ud, "buffer")) return 0;
    if(is_initialized) nk_buffer_free(buffer);
    Free(L, buffer);
    return 0;
    }

static ud_t *new_buffer(lua_State *L, nk_buffer_t *buffer)
    {
    ud_t *ud;
    ud = newuserdata(L, buffer, BUFFER_MT, "buffer");
    ud->parent_ud = NULL;
    ud->destructor = freebuffer;
    return ud;
    }

static int CreateDefault(lua_State *L)
    {
    nk_buffer_t *buffer = (nk_buffer_t*)Malloc(L, sizeof(nk_buffer_t));
    nk_buffer_init_default(buffer);
    //void nk_buffer_init(nk_buffer_t*, const nk_allocator_t*, nk_size size);
    new_buffer(L, buffer);
    return 1;
    }

static int CreateFixed(lua_State *L)
    {
    ud_t *ud;
    nk_size size;
    void *ptr = NULL;
    nk_buffer_t *buffer;
    if(!lua_isnoneornil(L, 2))
        {
        ptr = checklightuserdata(L, 2);
        size = luaL_checkinteger(L, 3);
        if(size <= 0) return argerrorc(L, 3, ERR_VALUE);
        }
    buffer = (nk_buffer_t*)Malloc(L, sizeof(nk_buffer_t));
    if(ptr) nk_buffer_init_fixed(buffer, ptr, size);
    ud = new_buffer(L, buffer);
    MarkFixed(ud);
    if(ptr) MarkInitialized(ud);
    return 1;
    }

static int New(lua_State *L)
    {
    enum nk_allocation_type type = checkallocationtype(L, 1);
    switch(type)
        {
        case NK_BUFFER_DYNAMIC: return CreateDefault(L);
        case NK_BUFFER_FIXED: return CreateFixed(L);
        default: break;
        }
    return unexpected(L);
    }

static int Init(lua_State *L)
    {
    ud_t *ud;
    nk_buffer_t *buffer = checkbuffer(L, 1, &ud);
    void *ptr = checklightuserdata(L, 2);
    nk_size size = luaL_checkinteger(L, 3);
    if(size <= 0) return argerrorc(L, 3, ERR_VALUE);
    if(!IsFixed(ud))
        return luaL_argerror(L, 1, "not a fixed buffer");
    if(IsInitialized(ud))
        nk_buffer_free(buffer);
    nk_buffer_init_fixed(buffer, ptr, size);
    MarkInitialized(ud);
    return 0;
    }

TYPE_FUNC(buffer)
DELETE_FUNC(buffer)

static int Buffer_clear(lua_State *L)
    {
    nk_buffer_t *buffer = checkbuffer(L, 1, NULL);
    nk_buffer_clear(buffer);
    return 0;
    }

static int Clear_buffers(lua_State *L)
    {
    nk_buffer_t *buffer;
    int arg = 1;
    while(!lua_isnoneornil(L, arg))
        {
        buffer = checkbuffer(L, arg++, NULL);
        nk_buffer_clear(buffer);
        }
    return 0;
    }

static int Buffer_ptr(lua_State *L)
    {
    nk_buffer_t *buffer = checkbuffer(L, 1, NULL);
    void *ptr = nk_buffer_memory(buffer);
    if(!ptr) return 0;
    lua_pushlightuserdata(L, ptr);
    return 1;
    }

#if 0
static int Buffer_info(lua_State *L)
    {
    nk_memory_status_t status;
    nk_buffer_t *buffer = checkbuffer(L, 1, NULL);
    nk_buffer_info(&status, buffer);
    return pushmemorystatus(L, &status);
    }

static int Buffer_push(lua_State *L)
    {
    size_t len;
    nk_buffer_t *buffer = checkbuffer(L, 1, NULL);
    enum nk_buffer_allocation_type type = checkbufferallocationtype(L, 2);
    const char *data = luaL_checklstring(L, 3, &len);
    nk_size align = luaL_checkinteger(L, 4);
    nk_buffer_push(buffer, type, data, (nk_size)len, align);
    return 0;
    }

static int Buffer_mark(lua_State *L)
    {
    nk_buffer_t *buffer = checkbuffer(L, 1, NULL);
    enum nk_buffer_allocation_type type = checkbufferallocationtype(L, 2);
    nk_buffer_mark(buffer, type);
    return 0;
    }

static int Buffer_reset(lua_State *L)
    {
    nk_buffer_t *buffer = checkbuffer(L, 1, NULL);
    enum nk_buffer_allocation_type type = checkbufferallocationtype(L, 2);
    nk_buffer_reset(buffer, type);
    return 0;
    }

static int Buffer_total(lua_State *L)
    {
    nk_buffer_t *buffer = checkbuffer(L, 1, NULL);
    lua_pushinteger(L, nk_buffer_total(buffer));
    return 1;
    }
#endif

static const struct luaL_Reg Methods[] = 
    {
        { "type", Type },
        { "free",  Delete },
        { "clear", Buffer_clear },
        { "init",  Init },
        { "ptr", Buffer_ptr },
#if 0 // not needed
        { "info", Buffer_info },
        { "push", Buffer_push },
        { "mark", Buffer_mark },
        { "reset", Buffer_reset },
        { "total", Buffer_total },
#endif
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg MetaMethods[] = 
    {
        { "__gc",  Delete },
        { NULL, NULL } /* sentinel */
    };

static const struct luaL_Reg Functions[] = 
    {
        { "new_buffer", New },
        { "clear_buffers", Clear_buffers },
        { NULL, NULL } /* sentinel */
    };

void moonnuklear_open_buffer(lua_State *L)
    {
    udata_define(L, BUFFER_MT, Methods, MetaMethods);
    luaL_setfuncs(L, Functions, 0);
    }

