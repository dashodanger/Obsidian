//------------------------------------------------------------------------
//  Hyperlinks
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2011-2017 Andrew Apted
//  Copyright (C) 2002 Jason Bryan
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

#include <FL/Fl_Button.H>

#include <string>

class UI_HyperLink : public Fl_Button
{
  private:
    // true when mouse is over this widget
    bool hover;

    // area containing the label
    int label_X, label_Y, label_W, label_H;

    // the URL to visit when clicked
    std::string url;

  public:
    UI_HyperLink(int x, int y, int w, int h, const char *label, const char *_url);
    virtual ~UI_HyperLink() = default;

  public:
    // FLTK overrides

    int handle(int event);

    void draw();

  private:
    void checkLink();

    static void callback_Link(Fl_Widget *w, void *data);
};

class UI_ModHyperLink : public Fl_Button
{
  private:
    // the URL to visit when clicked
    std::string url;

  public:
    UI_ModHyperLink(int x, int y, int w, int h, const char *label, const char *_url);
    virtual ~UI_ModHyperLink() = default;

  public:
    // FLTK overrides

    int handle(int event);

  private:
    static void callback_Link(Fl_Widget *w, void *data);
};

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
