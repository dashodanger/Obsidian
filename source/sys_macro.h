//------------------------------------------------------------------------
//  Macros
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
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

#include <math.h>
#include <stdint.h>

// basic constants
constexpr uint16_t OBSIDIAN_MSG_BUF_LEN  = 2000;
constexpr double   OBSIDIAN_POLY_EPSILON = (1.0 / 128.0);
constexpr double   OBSIDIAN_DIST_EPSILON = (1.0 / 1024.0);
constexpr double   OBSIDIAN_ANG_EPSILON  = (1.0 / 1024.0);
constexpr double   OBSIDIAN_PI           = 3.14159265358979323846;

// basic math
template <typename A, typename B,
          typename = std::enable_if_t<std::is_convertible_v<B, A>>>
constexpr A OBSIDIAN_MAX(A a, B b) {
    if (a > b) {
        return a;
    }
    return (A)b;
}

template <typename A, typename B,
          typename = std::enable_if_t<std::is_convertible_v<B, A>>>
constexpr A OBSIDIAN_MIN(A a, B b) {
    if (a < b) {
        return a;
    }
    return (A)b;
}

template <typename T>
constexpr T OBSIDIAN_ABS(T a) {
    if (a < 0) {
        return -a;
    }
    return a;
}

template <typename T>
constexpr int OBSIDIAN_I_ROUND(T x) {
    if (x < 0) {
        return x - 0.5;
    }
    return x + 0.5;
}

template <typename T, typename L, typename U,
          typename = std::enable_if_t<std::conjunction_v<
              std::is_convertible<L, T>, std::is_convertible<U, T>>>>
constexpr T OBSIDIAN_CLAMP(L low, T x, U high) {
    if (x < low) {
        return (T)low;
    }
    if (x > high) {
        return (T)high;
    }
    return x;
}

// colors
inline uint32_t OBSIDIAN_MAKE_RGBA(int r, int g, int b, int a)
{
    return (((r) << 24) | ((g) << 16) | ((b) << 8) | (a));
}

// these return wider on purpose as some functions will multiply/add/etc beyond 255
inline uint32_t OBSIDIAN_RGB_RED(uint32_t col)
{
    return ((col >> 24) & 255);
}
inline uint32_t OBSIDIAN_RGB_GREEN(uint32_t col)
{
    return ((col >> 16) & 255);
}
inline uint32_t OBSIDIAN_RGB_BLUE(uint32_t col)
{
    return ((col >> 8) & 255);
}
inline uint32_t OBSIDIAN_RGB_ALPHA(uint32_t col)
{
    return ((col) & 255);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
