//------------------------------------------------------------------------
//  About Window
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

#include <FL/fl_ask.H>

#include "lib_util.h"
#include "m_trans.h"
#include "main.h"
#include "sys_assert.h"

class UI_About : public Fl_Window
{
  public:
    bool        want_quit;
    const char *Text;

  public:
    UI_About(int W, int H, const char *label = NULL);

    virtual ~UI_About()
    {
        // nothing needed
    }

    bool WantQuit() const
    {
        return want_quit;
    }

  public:
    // FLTK virtual method for handling input events.
    int handle(int event)
    {
        if (event == FL_KEYDOWN || event == FL_SHORTCUT)
        {
            int key = Fl::event_key();

            if (key == FL_Escape)
            {
                want_quit = true;
                return 1;
            }

            // eat all other function keys
            if (FL_F + 1 <= key && key <= FL_F + 12)
            {
                return 1;
            }
        }

        return Fl_Window::handle(event);
    }

  private:
    static void callback_Quit(Fl_Widget *w, void *data)
    {
        UI_About *that = (UI_About *)data;

        that->want_quit = true;
    }

    static const char *URL;
};

const char *UI_About::URL = OBSIDIAN_WEBSITE;

//
// Constructor
//
UI_About::UI_About(int W, int H, const char *label) : Fl_Window(W, H, label), want_quit(false)
{
    // non-resizable
    size_range(W, H, W, H);

    callback(callback_Quit, this);

    int cy = KromulentHeight(6);

    Fl_Box *box = new Fl_Box(0, cy, W, KromulentHeight(50), "");
    box->copy_label(StringFormat("%s %s\n\"%s\" Build %s", OBSIDIAN_TITLE.c_str(), OBSIDIAN_SHORT_VERSION,
                                 OBSIDIAN_CODE_NAME.c_str(), OBSIDIAN_VERSION)
                        .c_str());
    box->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER | FL_ALIGN_WRAP | FL_ALIGN_CLIP);
    box->labelsize(FL_NORMAL_SIZE * 5 / 3);
    box->labelfont(font_style);

    cy += box->h() + KromulentHeight(6);

    // the very informative text
    int pad = KromulentWidth(22);

    int text_h = H * 0.55;
    // clang-format off
    Text =_("OBSIDIAN is a random level generator\nfor classic FPS games like DOOM.\nIt is a continuation of the OBLIGE Level Maker\nCopyright (C) 2006-2017 Andrew Apted, et al.\nThis program is free software, and may be\ndistributed and modified under the terms of\nthe GNU General Public License.\nThere is ABSOLUTELY NO WARRANTY!\nUse at your OWN RISK!");
    // clang-format on

    box = new Fl_Box(pad, cy, W - pad - pad, text_h, Text);
    box->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER | FL_ALIGN_CLIP);
    box->box(FL_UP_BOX);
    box->color(BUTTON_COLOR);
    box->labelfont(font_style);
    box->labelcolor(FONT2_COLOR);

    cy += box->h() + KromulentHeight(10);

    // website address
    pad = KromulentWidth(8);

    UI_HyperLink *link = new UI_HyperLink(pad, cy, W - pad * 2, KromulentHeight(30), URL, URL);
    link->align(FL_ALIGN_CENTER);
    link->labelsize(FL_NORMAL_SIZE);
    link->labelfont(font_style);

    cy += link->h() + KromulentHeight(16);

    SYS_ASSERT(cy < H);

    // finally add an "OK" button
    Fl_Group *darkish = new Fl_Group(0, cy, W, H - cy);
    darkish->box(FL_FLAT_BOX);
    {
        int bw = KromulentWidth(60);
        int bh = KromulentHeight(30);
        int by = H - (H - cy + bh) / 2;

        Fl_Button *button = new Fl_Button(W - bw * 2, by, bw, bh, fl_ok);
        button->box(button_style);
        button->visible_focus(0);
        button->color(BUTTON_COLOR);
        button->callback(callback_Quit, this);
        button->labelfont(font_style);
        button->labelcolor(FONT2_COLOR);
    }
    darkish->end();

    end();
}

void DLG_AboutText(void)
{
    int about_w = KromulentWidth(400);
    int about_h = KromulentHeight(400) + KF * 20;

    UI_About *about_window = new UI_About(about_w, about_h, _("About OBSIDIAN"));

    about_window->want_quit = false;
    about_window->set_modal();
    about_window->show();

    // run the GUI until the user closes
    while (!about_window->WantQuit())
    {
        Fl::wait();
    }

    delete about_window;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
