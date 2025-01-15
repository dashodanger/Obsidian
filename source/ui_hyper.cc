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
//
//  Used some code from Jason Bryan's FLU (FLTK Utility Widgets),
//  which is under the the GNU LGPL license (same as FLTK itself).
//
//------------------------------------------------------------------------

#include <FL/filename.H>

#include "lib_util.h"
#include "main.h"

UI_HyperLink::UI_HyperLink(int x, int y, int w, int h, const char *label, const char *_url)
    : Fl_Button(x, y, w, h, label), hover(false), label_X(0), label_Y(0), label_W(0), label_H(0)
{
    // copy the URL string
    url = _url;

    box(FL_NO_BOX);

    // setup the callback
    callback(callback_Link, NULL);
}

void UI_HyperLink::checkLink()
{
    // change the cursor if the mouse is over the link.
    // the 'hover' variable reduces the number of times fl_cursor()
    // needs to be called (since it can be expensive).

    if (Fl::event_inside(x() + label_X, y() + label_Y, label_W, label_H))
    {
        if (!hover)
        {
            fl_cursor(FL_CURSOR_HAND);
        }

        hover = true;
    }
    else
    {
        if (hover)
        {
            fl_cursor(FL_CURSOR_DEFAULT);
        }

        hover = false;
    }
}

int UI_HyperLink::handle(int event)
{
    if (!active_r())
    {
        return Fl_Button::handle(event);
    }

    switch (event)
    {
    case FL_MOVE: {
        checkLink();
        return 1;
    }

    case FL_ENTER: {
        checkLink();
        redraw();
        return 1;
    }

    case FL_LEAVE: {
        checkLink();
        redraw();
        return 1;
    }

    default:
        break;
    }

    return Fl_Button::handle(event);
}

void UI_HyperLink::draw()
{
    if (type() == FL_HIDDEN_BUTTON)
    {
        return;
    }

    // determine where to draw the label

    label_X = label_Y = label_W = label_H = 0;

    fl_font(labelfont(), labelsize());
    fl_measure(label(), label_W, label_H, 1);

    if (align() & FL_ALIGN_LEFT)
    {
        label_X = 2;
    }
    else if (align() & FL_ALIGN_RIGHT)
    {
        label_X = w() - label_W - 2;
    }
    else
    {
        label_X = (w() - label_W) / 2;
    }

    label_Y += h() / 2 - labelsize() / 2 - 2;

    // draw the link text

    fl_draw_box(box(), x(), y(), w(), h(), color());

    fl_color(labelcolor());
    fl_draw(label(), x() + label_X, y() + label_Y, label_W, label_H, FL_ALIGN_LEFT);

    // draw the underline

    if (!value())
    {
        int yy = y() + label_Y + label_H - 2;

        fl_line_style(FL_SOLID);
        fl_line(x() + label_X, yy, x() + label_X + label_W, yy);
        fl_line_style(0);
    }
}

void UI_HyperLink::callback_Link(Fl_Widget *w, void *data)
{
    UI_HyperLink *link = (UI_HyperLink *)w;

    if (!fl_open_uri(link->url.c_str()))
    {
        LogPrint("\nOpen URL failed: %s\n\n", link->url.c_str());
    }
}

UI_ModHyperLink::UI_ModHyperLink(int x, int y, int w, int h, const char *label, const char *_url)
    : Fl_Button(x, y, w, h, label)
{
    // copy the URL string
    url = _url;

    box(FL_NO_BOX);

    // setup the callback
    callback(callback_Link, NULL);
}

int UI_ModHyperLink::handle(int event)
{

    switch (event)
    {
    case FL_ENTER: {
        fl_cursor(FL_CURSOR_HAND);
        return 1;
    }

    case FL_LEAVE: {
        fl_cursor(FL_CURSOR_DEFAULT);
        return 1;
    }

    default:
        break;
    }

    return Fl_Button::handle(event);
}

void UI_ModHyperLink::callback_Link(Fl_Widget *w, void *data)
{
    UI_ModHyperLink *link = (UI_ModHyperLink *)w;

    if (!fl_open_uri(link->url.c_str()))
    {
        LogPrint("\nOpen URL failed: %s\n\n", link->url.c_str());
    }
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
