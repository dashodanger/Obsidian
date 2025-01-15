//------------------------------------------------------------------------
//  Custom FLTK Widgets
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

#include <map>
#include <string>
#include <vector>

#include "FL/Fl_Box.H"
#include "FL/Fl_Button.H"
#include "FL/Fl_Check_Button.H"
#include "FL/Fl_Choice.H"
#include "FL/Fl_Double_Window.H"
#include "FL/Fl_Group.H"
#include "FL/Fl_Hor_Slider.H"
#include "FL/Fl_Menu_Button.H"
#include "FL/Fl_Repeat_Button.H"
#include "FL/Fl_Text_Buffer.H"
#include "FL/Fl_Text_Display.H"
#include "ui_hyper.h"

//
// DESCRIPTION:
//   A sub-classed Fl_Choice widget which remembers an 'id'
//   string associated with each selectable value, and allows
//   these ids and labels to be updated at any time.
//

class choice_data_c
{
    friend class UI_RChoice; // Don't know if the 'group' for the menu needs to
                             // be a friend as well
    friend class UI_RChoiceMenu;

  public:
    std::string id;    // terse identifier
    std::string label; // description (for the UI)

    bool enabled;      // shown to the user

    // the index in the current list, or -1 if not present
    int mapped;

    Fl_Check_Button *widget;

  public:
    choice_data_c(std::string_view _id, std::string_view _label);
    ~choice_data_c();
};

typedef struct
{
    void       *mod;
    std::string opt_name;
} opt_change_callback_data_t;

class UI_ResetOption : public Fl_Button
{
  private:
    // true when mouse is over this widget
    bool hover;

    // area containing the label
    int label_X, label_Y, label_W, label_H;

  public:
    UI_ResetOption(int x, int y, int w, int h);
    virtual ~UI_ResetOption();

  public:
    // FLTK overrides

    int handle(int event);

    void draw();

  private:
    void checkLink();
};

class UI_HelpLink : public Fl_Button
{
  private:
    // true when mouse is over this widget
    bool hover;

    // area containing the label
    int label_X, label_Y, label_W, label_H;

  public:
    UI_HelpLink(int x, int y, int w, int h);
    virtual ~UI_HelpLink();

    std::string help_text;
    std::string help_title;

  public:
    // FLTK overrides

    int handle(int event);

    void draw();

  private:
    void checkLink();
};

class UI_ManualEntry : public Fl_Button
{
  private:
    // true when mouse is over this widget
    bool hover;

    // area containing the label
    int label_X, label_Y, label_W, label_H;

  public:
    UI_ManualEntry(int x, int y, int w, int h);
    virtual ~UI_ManualEntry();

  public:
    // FLTK overrides

    int handle(int event);

    void draw();

  private:
    void checkLink();
};

class UI_CustomMenu : public Fl_Choice
{
  private:
  public:
    UI_CustomMenu(int x, int y, int w, int h, const std::string &label = "");
    virtual ~UI_CustomMenu();

  private:
    void draw();
};

class UI_RChoiceMenu : public UI_CustomMenu
{
  private:
    std::vector<choice_data_c *> opt_list;

  public:
    UI_RChoiceMenu(int x, int y, int w, int h, const std::string &label = "");
    virtual ~UI_RChoiceMenu();

  public:
    // add a new choice to the list.  If a choice with the same 'id'
    // already exists, it is just replaced instead.
    // The choice will begin disabled (shown == false).
    void AddChoice(const std::string &id, const std::string &label);

    // finds the option with the given ID, and update its 'enabled'
    // value.  Returns true if successful, or false if no such
    // option exists.  Any change will call Recreate().
    bool EnableChoice(const std::string &id, bool enable_it);

    // get the id string for the currently shown value.
    // Returns the string "none" if there are no choices.
    std::string GetID() const;

    // change the currently shown value via the new 'id'.
    // If does not exist, returns false and nothing was changed.
    bool ChangeTo(const std::string &id);

    std::string GetLabel() const;

    choice_data_c *FindID(std::string_view id) const;

  private:
    choice_data_c *FindMapped() const;

    // call this to update the available choices to reflect their
    // 'shown' values.  If the previous selected item is still
    // valid, it remains set, otherwise we try and find a shown
    // value with the same label, and failing that: select the
    // first entry.
    void Recreate();

    void GotoPrevious();
    void GotoNext();
};

class UI_RHeader : public Fl_Group
{
  private:
  public:
    UI_RHeader(int x, int y, int w, int h);
    virtual ~UI_RHeader();

  public:
    Fl_Box *mod_label;

  private:
};

class UI_RLink : public Fl_Group
{
  private:
  public:
    UI_RLink(int x, int y, int w, int h);
    virtual ~UI_RLink();

  public:
    UI_ModHyperLink *mod_link;

  private:
};

class UI_RChoice : public Fl_Group
{

  public:
    UI_RChoice(int x, int y, int w, int h);
    virtual ~UI_RChoice();

  public:
    Fl_Box *mod_label;

    UI_HelpLink *mod_help;

    UI_RChoiceMenu *mod_menu;

    UI_ResetOption *mod_reset;

    std::string randomize_group;

    std::string default_value;

    opt_change_callback_data_t *cb_data;
};

class UI_CustomArrowButton : public Fl_Repeat_Button
{
  private:
  public:
    UI_CustomArrowButton(int x, int y, int w, int h);
    virtual ~UI_CustomArrowButton();

  private:
    void draw();
};

class UI_CustomMenuButton : public Fl_Menu_Button
{
  private:
    // true when mouse is over this widget
    bool hover;

    // area containing the label
    int label_X, label_Y, label_W, label_H;

  public:
    UI_CustomMenuButton(int x, int y, int w, int h);
    virtual ~UI_CustomMenuButton();

  public:
    // FLTK overrides

    int handle(int event);

  private:
    void draw();

    void checkLink();
};

class UI_CustomSlider : public Fl_Hor_Slider
{
  private:
  public:
    UI_CustomSlider(int x, int y, int w, int h);
    virtual ~UI_CustomSlider();

  private:
    int handle(int event);
};

class UI_RSlide : public Fl_Group
{

  public:
    UI_RSlide(int x, int y, int w, int h);
    virtual ~UI_RSlide();

    Fl_Box *mod_label;

    Fl_Box *unit_label;

    UI_ResetOption *mod_reset;

    UI_HelpLink *mod_help;

    UI_ManualEntry *mod_entry;

    UI_CustomSlider *mod_slider;

    UI_CustomArrowButton *prev_button;

    UI_CustomArrowButton *next_button;

    UI_CustomMenuButton *nan_options;

    std::string units;

    std::map<double, std::string> preset_choices;

    std::vector<std::string> nan_choices;

    std::string randomize_group;

    std::string default_value;

    opt_change_callback_data_t *cb_data;
};

class UI_CustomCheckBox : public Fl_Check_Button
{
  private:
  public:
    UI_CustomCheckBox(int x, int y, int w, int h, const std::string &label = "");
    virtual ~UI_CustomCheckBox();

  private:
    void draw();
};

class UI_RButton : public Fl_Group
{
  private:
  public:
    UI_RButton(int x, int y, int w, int h);
    virtual ~UI_RButton();

    UI_CustomCheckBox *mod_check;

    UI_ResetOption *mod_reset;

    Fl_Box *mod_label;

    UI_HelpLink *mod_help;

    std::string randomize_group;

    std::string default_value;

    opt_change_callback_data_t *cb_data;
};

class UI_Clippy : public Fl_Double_Window
{

  public:
    UI_Clippy();
    virtual ~UI_Clippy();

    Fl_Box *background;

    Fl_Text_Buffer *buff;

    Fl_Text_Display *disp;

    Fl_Button *showme_another;

    Fl_Button *closeme;

    void ShowAdvice(void);

  private:
    int handle(int event);

    static void callback_MoreAdvice(Fl_Widget *w, void *data);

    static void callback_CloseMe(Fl_Widget *w, void *data);

    int xoff;

    int yoff;
};

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
