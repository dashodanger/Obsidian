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

#include "fastPRNG.h"
#include "Rand.h"

fastPRNG::fastXS64 xoshiro;

void xoshiro_Reseed(uint64_t newseed)
{
    xoshiro.seed(newseed);
    // proc gen MIDI uses its own RNG, but let's at least
    // match the seeds
    steve::Rand::reseed(newseed);
}

uint64_t xoshiro_UInt()
{
    return xoshiro.xoshiro256p();
}

float xoshiro_Float()
{
    return xoshiro.xoshiro256p_UNI<float>();
}

double xoshiro_Double()
{
    return xoshiro.xoshiro256p_UNI<double>();
}

int xoshiro_Between(int low, int high)
{
    return (int)xoshiro.xoshiro256p_Range<float>(low, high);
}

double xoshiro_Between(double low, double high)
{
    return xoshiro.xoshiro256p_Range<double>(low, high);
}
