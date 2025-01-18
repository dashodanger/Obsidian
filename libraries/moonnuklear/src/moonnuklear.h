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

#ifndef moonnuklearDEFINED
#define moonnuklearDEFINED

#include "minilua.h"
#include "compat-5.3.h"

#define MOONNUKLEAR_NK_VERSION  "4.12.0" /* @@ See Changelog in nuklear/nuklear.h */
#define MOONNUKLEAR_VERSION     "0.4"

extern lua_State *moonnuklear_L;
#define NK_ASSERT(x) do {                                                                       \
    /* (void)nk_sin; (void)nk_cos; (void)nk_sqrt; to avoid -Wunused-function void warnings */   \
    if(!(x)) {                                                                                  \
        lua_pushfstring(moonnuklear_L, "NK_ASSERT failed: %s line %d\n", __FILE__, __LINE__);   \
        lua_error(moonnuklear_L);                                                               \
    }                                                                                           \
} while(0)

#if defined(DEBUG)
#include "debug.h"
#endif

#define NK_INCLUDE_FIXED_TYPES
#define NK_INCLUDE_STANDARD_IO
#define NK_INCLUDE_STANDARD_VARARGS
#define NK_INCLUDE_DEFAULT_ALLOCATOR
#define NK_INCLUDE_VERTEX_BUFFER_OUTPUT
#define NK_INCLUDE_FONT_BAKING
#define NK_INCLUDE_DEFAULT_FONT
#define NK_SIN sinf
#define NK_COS cosf
#define NK_SQRT sqrtf
//#define NK_INV_SQRT @@need to redefine this?
#include <math.h>
#include "nuklear.h"


#endif /* moonnuklearDEFINED */

