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

#pragma once

#include <stdint.h>

#include "m_lua.h"

void SKY_AddStars(unsigned long long seed, uint8_t *pixels, int W, int H, color_mapping_t *map, double powscale,
                  double thresh);

void SKY_AddClouds(unsigned long long seed, uint8_t *pixels, int W, int H, color_mapping_t *map, double powscale,
                   double thresh, double fracdim, double squish);

void SKY_AddHills(unsigned long long seed, uint8_t *pixels, int W, int H, color_mapping_t *map, double min_h,
                  double max_h, double powscale, double fracdim);

void SKY_AddBuilding(unsigned long long seed, uint8_t *pixels, int W, int H, std::vector<uint8_t> &colors, int pos_x,
                     int width, int base_h, int top_h = 0, int win_prob = 50, int win_w = 2, int win_h = 2,
                     int antenna = 0);

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
