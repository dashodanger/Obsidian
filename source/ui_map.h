//------------------------------------------------------------------------
//  Mini Map
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

#include <stdint.h>

#include "FL/Fl_Box.H"
#include "FL/Fl_Image.H"

class UI_MiniMap : public Fl_Box
{
  private:
    Fl_RGB_Image *cur_image;

  public:
    int map_W, map_H;

    uint8_t *pixels;

  public:
    UI_MiniMap(int x, int y, int w, int h, const char *label = NULL);
    virtual ~UI_MiniMap();

  public:
    int GetWidth() const
    {
        return map_W;
    }
    int GetHeight() const
    {
        return map_H;
    }

    void EmptyMap();

    void MapBegin();
    void MapFinish();

    void DrawPixel(int x, int y, uint8_t r, uint8_t g, uint8_t b);
    void DrawBox(int x1, int y1, int x2, int y2, uint8_t r, uint8_t g, uint8_t b);
    void DrawLine(int x1, int y1, int x2, int y2, uint8_t r, uint8_t g, uint8_t b);

    void MapClear();

  private:
    inline void RawPixel(int x, int y, uint8_t r, uint8_t g, uint8_t b)
    {
        uint8_t *pos = pixels + ((map_H - 1 - y) * map_W + x) * 3;

        *pos++ = r;
        *pos++ = g;
        *pos   = b;
    }

    enum outcode_flags_e
    {
        O_TOP    = 1,
        O_BOTTOM = 2,
        O_LEFT   = 4,
        O_RIGHT  = 8,
    };

    int Calc_Outcode(int x, int y)
    {
        return ((y < 0) ? O_BOTTOM : 0) | ((y > map_H - 1) ? O_TOP : 0) | ((x < 0) ? O_LEFT : 0) |
               ((x > map_W - 1) ? O_RIGHT : 0);
    }
};

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
