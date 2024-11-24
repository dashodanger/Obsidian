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

#ifndef debugDEFINED
#define debugDEFINED

/* Debug macros that can be used also in nuklear/nuklear.h */

#define PRINT_CONFIG(config) do { \
    printf("\n[%s(%d)] global_alpha = %.2f AA=(%d,%d) circle=%d, segment=%d, curve=%d\n"\
        "id:%d, uv={%.5f, %.5f}, vertex_size=%lu, vertex_alignment=%lu\n",              \
    __FILE__, __LINE__, (config)->global_alpha, (config)->line_AA, (config)->shape_AA,  \
    (config)->circle_segment_count, (config)->arc_segment_count, (config)->curve_segment_count, \
    (config)->null.texture.id,  (config)->null.uv.x, (config)->null.uv.y, (config)->vertex_size, \
    (config)->vertex_alignment); } while(0)

#define BUFFER_PRINT_MEM(buffer, n) do {        \
    nk_size i__, j__;                           \
    for(j__=0; j__< 16*n; j__+= 16)             \
        {                                       \
        printf("%3lu:", j__);                   \
        for(i__=0; i__<16; i__++)               \
            printf(" %.2x ", ((unsigned char*)((buffer)->memory.ptr))[j__+i__]);    \
        printf("\n");                           \
        }                                       \
} while(0)

#define BUFFER_PTR(buffer) buffer->memory.ptr
#define BUFFER_SIZE(buffer) buffer->memory.size
#define BUFFER_PRINT_PTR(buffer) do { \
    printf("[%s(%d)] ptr=%p size=%lu\n", __FILE__, __LINE__, BUFFER_PTR(buffer), BUFFER_SIZE(buffer));\
} while(0)
#define BUFFER_PRINT(buffer, n) do {    \
    BUFFER_PRINT_PTR(buffer);           \
    BUFFER_PRINT_MEM((buffer), (n));    \
} while(0)

#endif

