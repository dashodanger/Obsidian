//------------------------------------------------------------------------
//  SKY GENERATION
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2008-2017 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "tx_skies.h"

#include "lib_util.h"
#include "main.h"
#include "sys_assert.h"
#include "sys_macro.h"
#include "sys_xoshiro.h"
#include "tx_forge.h"

uint8_t *SKY_GenGradient(int W, int H, std::vector<uint8_t> &colors)
{
    int numcol = (int)colors.size();

    SYS_ASSERT(numcol > 0);

    uint8_t *pixels = new uint8_t[W * H];

    for (int y = 0; y < H; y++)
    {
        // we assume that (in general) top is light, bottom is dark
        int idx = (H - 1 - y) * numcol / H;

        uint8_t color = colors[idx];

        uint8_t *dest  = &pixels[y * W];
        uint8_t *d_end = dest + W;

        while (dest < d_end)
        {
            *dest++ = color;
        }
    }

    return pixels;
}

void SKY_AddClouds(unsigned long long seed, uint8_t *pixels, int W, int H, color_mapping_t *map, double powscale,
                   double thresh, double fracdim, double squish)
{
    // SYS_ASSERT(is_power_of_two(W))

    SYS_ASSERT(W >= H);

    SYS_ASSERT(map->size > 0);
    SYS_ASSERT(squish > 0);
    SYS_ASSERT(powscale > 0);

    float *synth = new float[W * W];

    TX_SpectralSynth(seed, synth, W, fracdim, powscale);

    for (int y = 0; y < H; y++)
    {
        int sy = (int)(y * squish) & (W - 1); // yes 'W'

        const float *src = &synth[sy * W];

        uint8_t *dest  = &pixels[y * W];
        uint8_t *d_end = dest + W;

        while (dest < d_end)
        {
            float v = *src++;

            if (v < thresh)
            {
                dest++;
                continue;
            }

            v = (v - thresh) / (1.0 - thresh);

            int idx = (int)(v * map->size);
            idx     = OBSIDIAN_CLAMP(0, idx, map->size - 1);

            *dest++ = map->colors[idx];
        }
    }

    delete[] synth;
}

void SKY_AddStars(unsigned long long seed, uint8_t *pixels, int W, int H, color_mapping_t *map, double powscale,
                  double thresh)
{
    SYS_ASSERT(map->size >= 1);
    SYS_ASSERT(powscale > 0);
    SYS_ASSERT(thresh < 0.99);

    for (int y = 0; y < H; y++)
    {
        uint8_t *dest  = &pixels[y * W];
        uint8_t *d_end = dest + W;

        while (dest < d_end)
        {
            double v = xoshiro_Double();
            v *= xoshiro_Double();
            v *= xoshiro_Double();

            v = pow(v, powscale);

            if (v < thresh)
            {
                dest++;
                continue;
            }

            v = (v - thresh) / (1.0 - thresh);

            int idx = (int)(v * map->size);
            idx     = OBSIDIAN_CLAMP(0, idx, map->size - 1);

            *dest++ = map->colors[idx];
        }
    }
}

void SKY_AddHills(unsigned long long seed, uint8_t *pixels, int W, int H, color_mapping_t *map, double min_h,
                  double max_h, double powscale, double fracdim)
{
    SYS_ASSERT(map->size >= 2);
    SYS_ASSERT(min_h <= max_h);
    SYS_ASSERT(powscale > 0);

    float *height_map = new float[W * W];

    TX_SpectralSynth(seed, height_map, W, fracdim, powscale);

    bool use_slope_z = (xoshiro_UInt() & 255) < 20;

    // convert range from 0.0 .. 1.0 to min_h . max_h
    int x, z;

    for (z = 0; z < W; z++)
    {
        for (x = 0; x < W; x++)
        {
            float &f = height_map[z * W + x];

            f = min_h + f * (max_h - min_h);
        }
    }

    // modify heightmap so that all values at Z=0 are negative
    float z0_max_h = -99;

    for (x = 0; x < W; x++)
    {
        z0_max_h = OBSIDIAN_MAX(z0_max_h, height_map[x]);
    }

    if (z0_max_h > -0.05)
    {
        z0_max_h = (z0_max_h + 0.10) * 1.1;

        for (z = 0; z < W; z++)
        {
            float factor = (W - z) / (float)W;

            float sub_h = factor * factor * z0_max_h;

            for (x = 0; x < W; x++)
            {
                float &f = height_map[z * W + x];

                f = f - sub_h;
            }
        }
    }

    // -- render each column --

    // since every column begins with a negative value (below the
    // camera) we can merely process the height array from front to
    // back, and incrementally add pixels to the top of each column.

    for (x = 0; x < W; x++)
    {
        // remember the highest span for this column
        int high_span = 0;

        int x2 = x + 1;
        if (x2 >= W)
        {
            x2 = 0;
        }

        for (int z = 0; z < W - 1; z++)
        {
            float f = height_map[z * W + x];

            int span = int(f * H);

            // hidden by previous spans?
            if (span <= high_span)
            {
                continue;
            }

            if (span >= H)
            {
                span = H - 1;
            }

            // determine slopes at current point
            float slope_x = height_map[z * W + x2] - f;
            float slope_z = height_map[(z + 1) * W + x] - f;

            float ity = 0.75 - (max_h - f);

            if (use_slope_z)
            {
                ity += fabs(slope_z) * 60 - 0.25;
            }
            else
            {
                ity += slope_x * 50;
            }

            int col_idx = (int)(ity * map->size);
            col_idx     = OBSIDIAN_CLAMP(0, col_idx, map->size - 1);

            uint8_t col = map->colors[col_idx];

            for (int y = high_span; y < span; y++)
            {
                pixels[(H - 1 - y) * W + x] = col;
            }

            high_span = span;
        }
    }

    delete[] height_map;
}

void SKY_AddBuilding(unsigned long long seed, uint8_t *pixels, int W, int H, std::vector<uint8_t> &colors, int pos_x,
                     int width, int base_h, int top_h, int win_prob, int win_w, int win_h, int antenna)
{
    int numcol = (int)colors.size();
    SYS_ASSERT(numcol >= 2);

    win_prob = win_prob * 65535 / 100;

    int x, y;

    int win_x;
    int win_y = 1 + win_h;

    uint8_t bg = colors[0];

    for (y = 0; y < base_h + top_h; y++)
    {
        if (y >= H)
        {
            break;
        }

        int x1 = pos_x;
        int x2 = pos_x + width - 1;

        if (y >= base_h)
        {
            x1 = x1 + width / 8;
            x2 = x2 - width / 8;
        }

        for (x = x1; x <= x2; x++)
        {
            pixels[(H - 1 - y) * W + (x % W)] = bg;
        }

        // Windows
        if (y == win_y && y < base_h + top_h - 2)
        {
            for (win_x = x1 + 2; win_x + win_w <= x2 - 2; win_x += win_w + 1)
            {
                uint8_t fg = colors[1];

                if (((int)xoshiro_UInt() & 0xFFFF) > win_prob)
                {
                    fg = (numcol >= 3) ? colors[2] : bg;
                }

                for (int dx = 0; dx < win_w; dx++)
                {
                    for (int dy = 0; dy < win_h; dy++)
                    {
                        pixels[(H - 1 - win_y + dy) * W + ((win_x + dx) % W)] = fg;
                    }
                }
            }

            win_y += win_h + 1;

            if (base_h <= win_y && win_y <= base_h + win_h)
            {
                win_y = base_h + win_h + 1;
            }
        }
    }
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
