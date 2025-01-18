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

/*------------------------------------------------------------------------------*
 | Misc utilities                                                               |
 *------------------------------------------------------------------------------*/

int noprintf(const char *fmt, ...) 
    { (void)fmt; return 0; }

int notavailable(lua_State *L, ...) 
    { 
    return luaL_error(L, "function not available in this CL version");
    }

/*------------------------------------------------------------------------------*
 | Malloc                                                                       |
 *------------------------------------------------------------------------------*/

/* We do not use malloc(), free() etc directly. Instead, we inherit the memory 
 * allocator from the main Lua state instead (see lua_getallocf in the Lua manual)
 * and use that.
 *
 * By doing so, we can use an alternative malloc() implementation without recompiling
 * this library (we have needs to recompile lua only, or execute it with LD_PRELOAD
 * set to the path to the malloc library we want to use).
 */
static lua_Alloc Alloc = NULL;
static void* AllocUd = NULL;

static void malloc_init(lua_State *L)
    {
    if(Alloc) unexpected(L);
    Alloc = lua_getallocf(L, &AllocUd);
    }

static void* Malloc_(size_t size)
    { return Alloc ? Alloc(AllocUd, NULL, 0, size) : NULL; }

static void Free_(void *ptr)
    { if(Alloc) Alloc(AllocUd, ptr, 0, 0); }

void *Malloc(lua_State *L, size_t size)
    {
    void *ptr;
    if(size == 0)
        { luaL_error(L, errstring(ERR_MALLOC_ZERO)); return NULL; }
    ptr = Malloc_(size);
    if(ptr==NULL)
        { luaL_error(L, errstring(ERR_MEMORY)); return NULL; }
    memset(ptr, 0, size);
    //DBG("Malloc %p\n", ptr);
    return ptr;
    }

void *MallocNoErr(lua_State *L, size_t size) /* do not raise errors (check the retval) */
    {
    void *ptr = Malloc_(size);
    (void)L;
    if(ptr==NULL)
        return NULL;
    memset(ptr, 0, size);
    //DBG("MallocNoErr %p\n", ptr);
    return ptr;
    }

char *Strdup(lua_State *L, const char *s)
    {
    size_t len = strnlen(s, 256);
    char *ptr = (char*)Malloc(L, len + 1);
    if(len>0)
        memcpy(ptr, s, len);
    ptr[len]='\0';
    return ptr;
    }


void Free(lua_State *L, void *ptr)
    {
    (void)L;
    //DBG("Free %p\n", ptr);
    if(ptr) Free_(ptr);
    }

/*------------------------------------------------------------------------------*
 | Light userdata                                                               |
 *------------------------------------------------------------------------------*/

void *checklightuserdata(lua_State *L, int arg)
    {
    if(lua_type(L, arg) != LUA_TLIGHTUSERDATA)
        { luaL_argerror(L, arg, "expected lightuserdata"); return NULL; }
    return lua_touserdata(L, arg);
    }
    
void *optlightuserdata(lua_State *L, int arg)
    {
    if(lua_isnoneornil(L, arg))
        return NULL;
    return checklightuserdata(L, arg);
    }

void *checklightuserdataorzero(lua_State *L, int arg)
    {
    int val, isnum;
    val = lua_tointegerx(L, arg, &isnum);
    if(!isnum)
        return checklightuserdata(L, arg);
    if(val != 0)
        luaL_argerror(L, arg, "expected lightuserdata or 0");
    return NULL;
    }

/*------------------------------------------------------------------------------*
 | Boolean                                                                      |
 *------------------------------------------------------------------------------*/

int checkboolean(lua_State *L, int arg)
    {
    if(!lua_isboolean(L, arg))
        return (int)luaL_argerror(L, arg, "boolean expected");
    return lua_toboolean(L, arg); // ? nk_true : nk_false;
    }

int testboolean(lua_State *L, int arg, int *err)
    {
    if(!lua_isboolean(L, arg))
        { *err = ERR_TYPE; return 0; }
    *err = 0;
    return lua_toboolean(L, arg); // ? nk_true : nk_false;
    }

int optboolean(lua_State *L, int arg, int d)
    {
    if(!lua_isboolean(L, arg))
        return d;
    return lua_toboolean(L, arg);
    }


/*------------------------------------------------------------------------------*
 | 1-based integer index                                                        |
 *------------------------------------------------------------------------------*/

int testindex(lua_State *L, int arg, int *err)
    {
    int val;
    if(!lua_isinteger(L, arg))
        { *err = ERR_TYPE; return 0; }
    val = lua_tointeger(L, arg);
    if(val < 1)
        { *err = ERR_GENERIC; return 0; }
    *err = 0;
    return val - 1;
    }

int checkindex(lua_State *L, int arg)
    {
    int val = luaL_checkinteger(L, arg);
    if(val < 1)
        return luaL_argerror(L, arg, "expected 1-based index");
    return val - 1;
    }

int optindex(lua_State *L, int arg, int optval /* 0-based */)
    {
    int val = luaL_optinteger(L, arg, optval + 1);
    if(val < 1)
        return luaL_argerror(L, arg, "expected 1-based index");
    return val - 1;
    }

void pushindex(lua_State *L, int val)
    { lua_pushinteger((L), (val) + 1); }

/*------------------------------------------------------------------------------*
 | String List                                                                  |
 *------------------------------------------------------------------------------*/

char** checkstringlist(lua_State *L, int arg, int *count, int *err)
    {
    int t;
    char** list;
    const char* s;
    int i;
    *count = 0;
    *err = 0;
    if(lua_isnoneornil(L, arg))
        { *err = ERR_NOTPRESENT; return NULL; }
    if(lua_type(L, arg) != LUA_TTABLE)
        { *err = ERR_TABLE; return NULL; }
    *count = luaL_len(L, arg);
    if(*count == 0)
        { *err = ERR_EMPTY; return NULL; }
    list = (char**)MallocNoErr(L, sizeof(char*) * (*count + 1));
    if(!list)
        { *err = ERR_MEMORY; return NULL; }
    for(i=0; i<*count; i++)
        {
        t = lua_rawgeti(L, arg, i+1);
        if(t != LUA_TSTRING)
            {
            lua_pop(L, 1);
            freestringlist(L, list, *count);
            *count = 0;
            *err = ERR_TYPE;
            return NULL;
            }
        s = lua_tostring(L, -1);
        list[i] = Strdup(L, s);
        lua_pop(L, 1);
        }
    /* list[*count]=NULL; */
    return list;
    }

void freestringlist(lua_State *L, char** list, int count)
    {
    int i;
    if(!list)
        return;
    for(i=0; i<count; i++)
        Free(L, list[i]);
    Free(L, list);
    }

void pushstringlist(lua_State *L, char** list, int count)
    {
    int i;
    lua_newtable(L);
    for(i=0; i<count; i++)
        {
        lua_pushstring(L, list[i]);
        lua_rawseti(L, -2, i+1);
        }
    }

/*------------------------------------------------------------------------------*
 | float List                                                                   |
 *------------------------------------------------------------------------------*/

float* checkfloatlist(lua_State *L, int arg, int *count, int *err)
    {
    float* list;
    int i;

    *count = 0;
    *err = 0;
    if(lua_isnoneornil(L, arg))
        { *err = ERR_NOTPRESENT; return NULL; }
    if(lua_type(L, arg) != LUA_TTABLE)
        { *err = ERR_TABLE; return NULL; }

    *count = luaL_len(L, arg);
    if(*count == 0)
        { *err = ERR_EMPTY; return NULL; }

    list = (float*)MallocNoErr(L, sizeof(float) * (*count));
    if(!list)
        { *count = 0; *err = ERR_MEMORY; return NULL; }

    for(i=0; i<*count; i++)
        {
        lua_rawgeti(L, arg, i+1);
        if(!lua_isnumber(L, -1))
            { lua_pop(L, 1); Free(L, list); *count = 0; *err = ERR_TYPE; return NULL; }
        list[i] = lua_tonumber(L, -1);
        lua_pop(L, 1);
        }
    return list;
    }

void freefloatlist(lua_State *L, float* list, int count)
    {
    (void)count;
    Free(L, list);
    }

void pushfloatlist(lua_State *L, float *list, int count)
    {
    int i;
    lua_newtable(L);
    for(i=0; i<count; i++)
        {
        lua_pushnumber(L, list[i]);
        lua_rawseti(L, -2, i+1);
        }
    }

/*------------------------------------------------------------------------------*
 | vec2 List                                                                   |
 *------------------------------------------------------------------------------*/

float* checkvec2list(lua_State *L, int arg, int *count, int *err)
    {
    nk_vec2_t* list;
    int i;

    *count = 0;
    *err = 0;
    if(lua_isnoneornil(L, arg))
        { *err = ERR_NOTPRESENT; return NULL; }
    if(lua_type(L, arg) != LUA_TTABLE)
        { *err = ERR_TABLE; return NULL; }

    *count = luaL_len(L, arg);
    if(*count == 0)
        { *err = ERR_EMPTY; return NULL; }

    list = (nk_vec2_t*)MallocNoErr(L, sizeof(nk_vec2_t)*(*count));
    if(!list)
        { *count = 0; *err = ERR_MEMORY; return NULL; }

    for(i=0; i<*count; i++)
        {
        lua_rawgeti(L, arg, i+1);
        *err = echeckvec2(L, -1, &list[i]);
        if(*err)
            { lua_pop(L, 2); Free(L, list); *count = 0; *err=ERR_TYPE; return NULL; }
        lua_pop(L, 1);
        }
    return (float*)list;
    }

void freevec2list(lua_State *L, float* list, int count)
    {
    (void)count;
    Free(L, list);
    }

/*------------------------------------------------------------------------------*
 | vec2i List                                                                   |
 *------------------------------------------------------------------------------*/

float* checkvec2ilist(lua_State *L, int arg, int *count, int *err)
    {
    nk_vec2i_t* list;
    int i;

    *count = 0;
    *err = 0;
    if(lua_isnoneornil(L, arg))
        { *err = ERR_NOTPRESENT; return NULL; }
    if(lua_type(L, arg) != LUA_TTABLE)
        { *err = ERR_TABLE; return NULL; }

    *count = luaL_len(L, arg);
    if(*count == 0)
        { *err = ERR_EMPTY; return NULL; }

    list = (nk_vec2i_t*)MallocNoErr(L, sizeof(nk_vec2i_t)*(*count));
    if(!list)
        { *count = 0; *err = ERR_MEMORY; return NULL; }

    for(i=0; i<*count; i++)
        {
        lua_rawgeti(L, arg, i+1);
        *err = echeckvec2i(L, -1, &list[i]);
        if(*err)
            { lua_pop(L, 2); Free(L, list); *count = 0; *err=ERR_TYPE; return NULL; }
        lua_pop(L, 1);
        }
    return (float*)list;
    }

void freevec2ilist(lua_State *L, float* list, int count)
    {
    (void)count;
    Free(L, list);
    }

/*------------------------------------------------------------------------------*
 | nk_rune List                                                                 |
 *------------------------------------------------------------------------------*/

nk_rune* checkrunelist(lua_State *L, int arg, int *count, int *err)
    {
    nk_rune* list;
    int i, isnum;

    *count = 0;
    *err = 0;
    if(lua_isnoneornil(L, arg))
        { *err = ERR_NOTPRESENT; return NULL; }
    if(lua_type(L, arg) != LUA_TTABLE)
        { *err = ERR_TABLE; return NULL; }

    *count = luaL_len(L, arg);
    if(*count == 0)
        { *err = ERR_EMPTY; return NULL; }

    list = (nk_rune*)MallocNoErr(L, sizeof(nk_rune) * (*count + 1));
    if(!list)
        { *count = 0; *err = ERR_MEMORY; return NULL; }

    for(i=0; i<*count; i++)
        {
        lua_rawgeti(L, arg, i+1);
        list[i] = lua_tointegerx(L, -1, &isnum);
        lua_pop(L, 1);
        if(!isnum)
            { Free(L, list); *count = 0; *err = ERR_TYPE; return NULL; }
        }
    list[*count] = 0; /* terminating rune */
    return list;
    }

void freerunelist(lua_State *L, nk_rune* list)
    {
    if(list) Free(L, list);
    }

void pushrunelist(lua_State *L, const nk_rune *list)
    {
    int i = 0;
    lua_newtable(L);
    if(!list) return; /* empty table */
    while(list[i]!=0)
        {
        lua_pushinteger(L, list[i]);
        lua_rawseti(L, -2, ++i);
        }
    }


/*------------------------------------------------------------------------------*
 | Internal error codes                                                         |
 *------------------------------------------------------------------------------*/

const char* errstring(int err)
    {
    switch(err)
        {
        case 0: return "success";
        case ERR_GENERIC: return "generic error";
        case ERR_TABLE: return "not a table";
        case ERR_EMPTY: return "empty list";
        case ERR_TYPE: return "invalid type";
        case ERR_VALUE: return "invalid value";
        case ERR_NOTPRESENT: return "missing";
        case ERR_MEMORY: return "out of memory";
        case ERR_MALLOC_ZERO: return "zero bytes malloc";
        case ERR_LENGTH: return "invalid length";
        case ERR_POOL: return "elements are not from the same pool";
        case ERR_BOUNDARIES: return "invalid boundaries";
        case ERR_UNKNOWN: return "unknown field name";
        case ERR_FAILED: return "operation failed";
        case ERR_COUNT: return "invalid no. of items";
        case ERR_RANGE: return "out of range";
        default:
            return "???";
        }
    return NULL; /* unreachable */
    }

/*------------------------------------------------------------------------------*
 | Inits                                                                        |
 *------------------------------------------------------------------------------*/

void moonnuklear_utils_init(lua_State *L)
    {
    malloc_init(L);
    }

