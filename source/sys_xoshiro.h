//------------------------------------------------------------------------
//  RANDOM NUMBER GENERATION (Xoshiro256)
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2020-2025 The OBSIDIAN Team
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

void xoshiro_Reseed(uint64_t newseed);

uint64_t xoshiro_UInt();

// These return in the range of 0.0f-1.0f/0.0-1.0
float xoshiro_Float();
double xoshiro_Double();

int xoshiro_Between(int low, int high);
double xoshiro_Between(double low, double high);