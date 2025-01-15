//----------------------------------------------------------------
//  Custom FLTK Widgets
//----------------------------------------------------------------
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
//----------------------------------------------------------------

#include "lib_util.h"
#include "m_lua.h"
#include "m_trans.h"
#include "main.h"
#include "sys_assert.h"

choice_data_c::choice_data_c(std::string_view _id, std::string_view _label) : enabled(false), mapped(-1), widget(NULL)
{
    if (!_id.empty())
    {
        id = _id;
    }
    if (!_label.empty())
    {
        label = _label;
    }
}

choice_data_c::~choice_data_c()
{
    // ignore 'widget' field when enabled, we assume it exists in
    // an Fl_Group and hence FLTK will take care to delete it.
    if (!enabled)
    {
        delete widget;
    }
}

//----------------------------------------------------------------

UI_RChoiceMenu::UI_RChoiceMenu(int x, int y, int w, int h, const std::string &label)
    : UI_CustomMenu(x, y, w, h, label), opt_list()
{
    visible_focus(0);
    labelfont(font_style);
    textfont(font_style);
}

UI_RChoiceMenu::~UI_RChoiceMenu()
{
    for (unsigned int i = 0; i < opt_list.size(); i++)
    {
        delete opt_list[i];
    }
}

void UI_RChoiceMenu::AddChoice(const std::string &id, const std::string &label)
{
    choice_data_c *opt = FindID(id);

    if (opt)
    {
        opt->label = label;

        if (opt->enabled)
        {
            Recreate();
        }
    }
    else
    {
        opt = new choice_data_c(id, label);

        opt_list.push_back(opt);
    }
}

bool UI_RChoiceMenu::EnableChoice(const std::string &id, bool enable_it)
{
    SYS_ASSERT(!id.empty());

    choice_data_c *P = FindID(id);

    if (!P)
    {
        return false;
    }

    if (P->enabled != enable_it)
    {
        P->enabled = enable_it;
        Recreate();
    }

    return true;
}

std::string UI_RChoiceMenu::GetID() const
{
    choice_data_c *P = FindMapped();

    return P ? P->id : "";
}

std::string UI_RChoiceMenu::GetLabel() const
{
    choice_data_c *P = FindMapped();

    return P ? P->label : "";
}

bool UI_RChoiceMenu::ChangeTo(const std::string &id)
{
    SYS_ASSERT(!id.empty());

    choice_data_c *P = FindID(id);

    if (!P || P->mapped < 0)
    {
        return false;
    }

    value(P->mapped);

    return true;
}

//----------------------------------------------------------------

void UI_RChoiceMenu::Recreate()
{
    // recreate the choice list

    choice_data_c *LAST = FindMapped();

    clear();

    for (unsigned int j = 0; j < opt_list.size(); j++)
    {
        choice_data_c *P = opt_list[j];

        // is it just a separator?
        if (P->label == "_")
        {
            P->mapped = -1;
            add("", 0, 0, 0, FL_MENU_DIVIDER | FL_MENU_INACTIVE);
            continue;
        }

        if (!P->enabled)
        {
            P->mapped = -1;
            continue;
        }

        P->mapped = add(P->label.c_str(), 0, 0, 0, 0);
    }

    // update the currently selected choice

    if (LAST && LAST->mapped >= 0)
    {
        value(LAST->mapped);
        return;
    }

    value(0);
}

choice_data_c *UI_RChoiceMenu::FindID(std::string_view id) const
{
    for (unsigned int j = 0; j < opt_list.size(); j++)
    {
        choice_data_c *P = opt_list[j];

        if (P->id == id)
        {
            return P;
        }
    }

    return NULL;
}

choice_data_c *UI_RChoiceMenu::FindMapped() const
{
    for (unsigned int j = 0; j < opt_list.size(); j++)
    {
        choice_data_c *P = opt_list[j];

        if (P->mapped >= 0 && P->mapped == value())
        {
            return P;
        }
    }

    return NULL;
}

void UI_RChoiceMenu::GotoPrevious()
{
    int v = value();

    if (v > 0)
    {
        v--;
        value(v);

        // skip dividers
        while (v > 0 && (mvalue()->flags & FL_MENU_INACTIVE))
        {
            v--;
            value(v);
        }

        do_callback();
    }
}

void UI_RChoiceMenu::GotoNext()
{
    int v    = value();
    int last = size() - 2;

    if (v < last)
    {
        v++;
        value(v);

        // skip dividers
        while (v < last && (mvalue()->flags & FL_MENU_INACTIVE))
        {
            v++;
            value(v);
        }

        do_callback();
    }
}

//----------------------------------------------------------------

UI_RHeader::UI_RHeader(int x, int y, int w, int h) : Fl_Group(x, y, w, h)
{
    visible_focus(0);
    labelfont(font_style);
}

UI_RHeader::~UI_RHeader()
{
}

//----------------------------------------------------------------

UI_RLink::UI_RLink(int x, int y, int w, int h) : Fl_Group(x, y, w, h)
{
    visible_focus(0);
    labelfont(font_style);
}

UI_RLink::~UI_RLink()
{
}

//----------------------------------------------------------------

UI_RChoice::UI_RChoice(int x, int y, int w, int h) : Fl_Group(x, y, w, h)
{
    visible_focus(0);
    labelfont(font_style);
}

UI_RChoice::~UI_RChoice()
{
    if (cb_data)
    {
        delete cb_data;
    }
}

//----------------------------------------------------------------

UI_CustomSlider::UI_CustomSlider(int x, int y, int w, int h) : Fl_Hor_Slider(x, y, w, h, NULL)
{
}

// Skips normal FL_PUSH handling which hides the value if you click and hold
// the slider handle without moving it - Dasho
int UI_CustomSlider::handle(int event)
{
    return Fl_Slider::handle(event, x() + Fl::box_dx(box()), y() + Fl::box_dy(box()), w() - Fl::box_dw(box()),
                             h() - Fl::box_dh(box()));
}

UI_CustomSlider::~UI_CustomSlider()
{
}

//----------------------------------------------------------------

UI_RSlide::UI_RSlide(int x, int y, int w, int h) : Fl_Group(x, y, w, h)
{
    visible_focus(0);
    labelfont(font_style);
}

UI_RSlide::~UI_RSlide()
{
    if (cb_data)
    {
        delete cb_data;
    }
}

//----------------------------------------------------------------

UI_RButton::UI_RButton(int x, int y, int w, int h) : Fl_Group(x, y, w, h)
{
    visible_focus(0);
    box(FL_NO_BOX);
}

UI_RButton::~UI_RButton()
{
    if (cb_data)
    {
        delete cb_data;
    }
}

//----------------------------------------------------------------

UI_CustomCheckBox::UI_CustomCheckBox(int x, int y, int w, int h, const std::string &label)
    : Fl_Check_Button(x, y, w, h, label.empty() ? "" : label.c_str())
{
    visible_focus(0);
    box(FL_NO_BOX);
    down_box(button_style);
}

UI_CustomCheckBox::~UI_CustomCheckBox()
{
}

// Custom draw function to use the checkmark style regardless of box type and
// respect custom colors
// Will also, in the absence of a down box, revert to drawing +/- instead.
// This is for modules that expand into a series of options
void UI_CustomCheckBox::draw()
{
    int W  = labelsize();
    int bx = Fl::box_dx(box()); // box frame width
    int dx = bx + 2;            // relative position of check mark etc.
    int dy = (h() - W) / 2;     // neg. offset o.k. for vertical centering
    int lx = 0;                 // relative label position (STR #3237)

    if (down_box())
    {
        draw_box(down_box(), x() + dx, y() + dy, W, W, BUTTON_COLOR);
        if (value())
        {
            fl_color(SELECTION);
            int tx = x() + dx + 3;
            int tw = W - 6;
            int d1 = tw / 3;
            int d2 = tw - d1;
            int ty = y() + dy + (W + d2) / 2 - d1 - 2;
            for (int n = 0; n < 3; n++, ty++)
            {
                fl_line(tx, ty, tx + d1, ty + d1);
                fl_line(tx + d1, ty + d1, tx + tw - 1, ty + d1 - d2 + 1);
            }
        }
    }
    else
    {
        if (value())
        {
            fl_color(FONT_COLOR);
            int tx = x() + dx + 3;
            int tw = W - 6;
            int ty = y() + dy + W / 2 - 2;
            fl_xyline(tx, ty, tx + tw);
        }
        else
        {
            fl_color(FONT_COLOR);
            int tx = x() + dx + 3;
            int tw = W - 6;
            int d1 = tw / 3;
            int d2 = tw - d1;
            int ty = y() + dy + (W + d2) / 2 - d1 - 2;
            fl_xyline(tx, ty, tx + tw);
            fl_yxline(tx + d1 + 2, ty - d1 - 2, ty + d1 + 2);
        }
    }
    lx = dx + W + 2;
    draw_label(x() + lx, y(), w() - lx - bx, h());
    if (Fl::focus() == this)
    {
        draw_focus();
    }
}

//----------------------------------------------------------------

UI_CustomArrowButton::UI_CustomArrowButton(int x, int y, int w, int h) : Fl_Repeat_Button(x, y, w, h)
{
    visible_focus(0);
}

UI_CustomArrowButton::~UI_CustomArrowButton()
{
}

void UI_CustomArrowButton::draw()
{
    if (type() == FL_HIDDEN_BUTTON)
    {
        return;
    }
    Fl_Color col = value() ? selection_color() : color();
    draw_box(value() ? (down_box() ? down_box() : fl_down(box())) : box(), col);
    draw_backdrop();
    draw_label();
    if (Fl::focus() == this)
    {
        draw_focus();
    }
}

//----------------------------------------------------------------

UI_CustomMenuButton::UI_CustomMenuButton(int x, int y, int w, int h)
    : Fl_Menu_Button(x, y, w, h, "@2>"), hover(false), label_X(0), label_Y(0), label_W(0), label_H(0)
{
}

UI_CustomMenuButton::~UI_CustomMenuButton()
{
}

void UI_CustomMenuButton::draw()
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

    fl_color(labelcolor());
    fl_draw(label(), x() + label_X, y() + label_Y, label_W, label_H, FL_ALIGN_LEFT);
}

void UI_CustomMenuButton::checkLink()
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

int UI_CustomMenuButton::handle(int event)
{
    if (!active_r())
    {
        return Fl_Menu_Button::handle(event);
    }

    switch (event)
    {
    case FL_MOVE: {
        checkLink();
        return 1;
    }

    case FL_ENTER: {
        checkLink();
        return 1;
    }

    case FL_LEAVE: {
        checkLink();
        return 1;
    }

    default:
        break;
    }

    return Fl_Menu_Button::handle(event);
}

//----------------------------------------------------------------

UI_ResetOption::UI_ResetOption(int x, int y, int w, int h)
    : Fl_Button(x, y, w, h, "@-2undo"), hover(false), label_X(0), label_Y(0), label_W(0), label_H(0)
{
    box(FL_NO_BOX);
}

UI_ResetOption::~UI_ResetOption()
{
}

void UI_ResetOption::checkLink()
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

int UI_ResetOption::handle(int event)
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
        return 1;
    }

    case FL_LEAVE: {
        checkLink();
        return 1;
    }

    default:
        break;
    }

    return Fl_Button::handle(event);
}

void UI_ResetOption::draw()
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

    /*
       if (Fl::focus() == this)
       draw_focus();
     */
}

//----------------------------------------------------------------

UI_HelpLink::UI_HelpLink(int x, int y, int w, int h)
    : Fl_Button(x, y, w, h, "?"), hover(false), label_X(0), label_Y(0), label_W(0), label_H(0)
{
    box(FL_NO_BOX);
}

UI_HelpLink::~UI_HelpLink()
{
}

void UI_HelpLink::checkLink()
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

int UI_HelpLink::handle(int event)
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
        return 1;
    }

    case FL_LEAVE: {
        checkLink();
        return 1;
    }

    default:
        break;
    }

    return Fl_Button::handle(event);
}

void UI_HelpLink::draw()
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

    /*
       if (Fl::focus() == this)
       draw_focus();
     */
}

//----------------------------------------------------------------

UI_ManualEntry::UI_ManualEntry(int x, int y, int w, int h)
    : Fl_Button(x, y, w, h, "[ ]"), hover(false), label_X(0), label_Y(0), label_W(0), label_H(0)
{
    box(FL_NO_BOX);
}

UI_ManualEntry::~UI_ManualEntry()
{
}

void UI_ManualEntry::checkLink()
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

int UI_ManualEntry::handle(int event)
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
        return 1;
    }

    case FL_LEAVE: {
        checkLink();
        return 1;
    }

    default:
        break;
    }

    return Fl_Button::handle(event);
}

void UI_ManualEntry::draw()
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

    /*
       if (Fl::focus() == this)
       draw_focus();
     */
}

//----------------------------------------------------------------

UI_CustomMenu::UI_CustomMenu(int x, int y, int w, int h, const std::string &label)
    : Fl_Choice(x, y, w, h, label.empty() ? "" : label.c_str())
{
    visible_focus(0);
}

UI_CustomMenu::~UI_CustomMenu()
{
}

// Custom draw function to use selected button style
void UI_CustomMenu::draw()
{
    Fl_Boxtype btype = button_style;

    int dx = Fl::box_dx(btype);
    int dy = Fl::box_dy(btype);

    // Arrow area
    int H = h() - 2 * dy;
    int W = Fl::is_scheme("gtk+") ? 20 :                        // gtk+  -- fixed size
                Fl::is_scheme("gleam") ? 20
                                       :                        // gleam -- fixed size
                Fl::is_scheme("plastic") ? ((H > 20) ? 20 : H)  // plastic: shrink if H<20
                                         : ((H > 20) ? 20 : H); // default: shrink if H<20
    int X = x() + w() - W - dx;
    int Y = y() + dy;

    // Arrow object
    int w1 = (W - 4) / 3;
    if (w1 < 1)
    {
        w1 = 1;
    }
    int x1 = X + (W - 2 * w1 - 1) / 2;
    int y1 = Y + (H - w1 - 1) / 2;

    if (Fl::scheme())
    {
        // NON-DEFAULT SCHEME

        // Draw widget box
        draw_box(btype, BUTTON_COLOR);

        // Draw arrow area
        fl_color(active_r() ? SELECTION : fl_inactive(SELECTION));
        if (Fl::is_scheme("plastic"))
        {
            // Show larger up/down arrows...
            fl_polygon(x1, y1 + 3, x1 + w1, y1 + w1 + 3, x1 + 2 * w1, y1 + 3);
            fl_polygon(x1, y1 + 1, x1 + w1, y1 - w1 + 1, x1 + 2 * w1, y1 + 1);
        }
        else
        {
            // Show smaller up/down arrows with a divider...
            x1 = x() + w() - 13 - dx;
            y1 = y() + h() / 2;
            fl_polygon(x1, y1 - 2, x1 + 3, y1 - 5, x1 + 6, y1 - 2);
            fl_polygon(x1, y1 + 2, x1 + 3, y1 + 5, x1 + 6, y1 + 2);

            fl_color(fl_darker(color()));
            fl_yxline(x1 - 7, y1 - 8, y1 + 8);

            fl_color(fl_lighter(color()));
            fl_yxline(x1 - 6, y1 - 8, y1 + 8);
        }
    }
    else
    {
        // DEFAULT SCHEME

        // Draw widget box
        draw_box(btype, color());

        // Draw arrow area
        draw_box(FL_UP_BOX, X, Y, W, H, BUTTON_COLOR);
        fl_color(active_r() ? SELECTION : fl_inactive(SELECTION));
        fl_polygon(x1, y1, x1 + w1, y1 + w1, x1 + 2 * w1, y1);
    }

    W += 2 * dx;

    // Draw menu item's label
    if (mvalue())
    {
        Fl_Menu_Item m = *mvalue();
        if (active_r())
        {
            m.activate();
        }
        else
        {
            m.deactivate();
        }

        // Clip
        int xx = x() + dx, yy = y() + dy + 1, ww = w() - W, hh = H - 2;
        fl_push_clip(xx, yy, ww, hh);

        if (Fl::scheme())
        {
            Fl_Label l;
            l.value   = m.text;
            l.image   = 0;
            l.deimage = 0;
            l.type    = m.labeltype_;
            l.font    = m.labelsize_ || m.labelfont_ ? m.labelfont_ : textfont();
            l.size    = m.labelsize_ ? m.labelsize_ : textsize();
            l.color   = m.labelcolor_ ? m.labelcolor_ : textcolor();
            if (!m.active())
            {
                l.color = fl_inactive((Fl_Color)l.color);
            }
            fl_draw_shortcut = 2; // hack value to make '&' disappear
            l.draw(xx + 3, yy, ww > 6 ? ww - 6 : 0, hh, FL_ALIGN_LEFT);
            fl_draw_shortcut = 0;
            if (Fl::focus() == this)
            {
                draw_focus(box(), xx, yy, ww, hh);
            }
        }
        else
        {
            fl_draw_shortcut = 2; // hack value to make '&' disappear
            m.draw(xx, yy, ww, hh, this, Fl::focus() == this);
            fl_draw_shortcut = 0;
        }

        fl_pop_clip();
    }

    // Widget's label
    draw_label();
}

//----------------------------------------------------------------

void UI_Clippy::callback_MoreAdvice(Fl_Widget *w, void *data)
{
    UI_Clippy *clip = (UI_Clippy *)data;
    clip->buff->text(ob_random_advice().c_str());
}

void UI_Clippy::callback_CloseMe(Fl_Widget *w, void *data)
{
    UI_Clippy *clip = (UI_Clippy *)data;
    clip->hide();
}

UI_Clippy::UI_Clippy() : Fl_Double_Window(476, 225, NULL)
{
    shape(clippy);
    xoff       = 0;
    yoff       = 0;
    background = new Fl_Box(0, 0, 476, 225, NULL);
    background->image(clippy);
    buff = new Fl_Text_Buffer();
    disp = new Fl_Text_Display(165, 10, 300, 165, NULL);
    disp->box(FL_FLAT_BOX);
    disp->color(fl_rgb_color(255, 255, 203));
    disp->buffer(buff);
    disp->textcolor(FL_BLACK);
    disp->textsize(20);
    disp->textfont(8);
    disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
    showme_another = new Fl_Button(200, 180, 100, 20, _("Next"));
    showme_another->box(FL_ROUNDED_FRAME);
    showme_another->labelcolor(FL_BLACK);
    showme_another->labelfont(9);
    showme_another->align(FL_ALIGN_CENTER | FL_ALIGN_INSIDE);
    showme_another->down_box(FL_ROUNDED_FRAME);
    showme_another->down_color(fl_rgb_color(255, 255, 203));
    showme_another->callback(callback_MoreAdvice, this);
    showme_another->visible_focus(0);
    closeme = new Fl_Button(320, 180, 100, 20, _("Close"));
    closeme->box(FL_ROUNDED_FRAME);
    closeme->labelcolor(FL_BLACK);
    closeme->labelfont(9);
    closeme->align(FL_ALIGN_CENTER | FL_ALIGN_INSIDE);
    closeme->down_box(FL_ROUNDED_FRAME);
    closeme->down_color(fl_rgb_color(255, 255, 203));
    closeme->callback(callback_CloseMe, this);
    closeme->visible_focus(0);
    visible_focus(0);
    hide();
}

void UI_Clippy::ShowAdvice()
{
    if (!shown())
    {
        hotspot(0, 0, 0);
    }
    if (buff->length() == 0)
    {
        buff->text(ob_random_advice().c_str());
    }
    show();
}

int UI_Clippy::handle(int event)
{
    int ret = Fl_Window::handle(event);
    switch (event)
    {
    case FL_PUSH:
        xoff = x() - Fl::event_x_root();
        yoff = y() - Fl::event_y_root();
        ret  = 1;

    case FL_DRAG:
        position(xoff + Fl::event_x_root(), yoff + Fl::event_y_root());
        redraw();
        ret = 1;

    case FL_RELEASE:
        show();
        ret = 1;
    }
    return (ret);
}

UI_Clippy::~UI_Clippy()
{
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
