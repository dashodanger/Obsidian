//------------------------------------------------------------------------
//  Custom Mod list
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

#include "FL/Fl_Check_Button.H"
#include "FL/Fl_Group.H"
#include "FL/Fl_Scrollbar.H"
#include "FL/Fl_Tabs.H"
#include "ui_widgets.h"

class UI_Module : public Fl_Group
{
    friend class UI_CustomMods;

    // NOTES:
    // -  module is "enabled" when mod_button->value() == 1
    // -  module is "shown" when visible() == true

  public:
    Fl_Box *heading;

    std::map<std::string, UI_RChoice *> choice_map;

    std::map<std::string, UI_RSlide *> choice_map_slider;

    std::map<std::string, UI_RButton *> choice_map_button;

    std::map<std::string, UI_RHeader *> choice_map_header;

    std::map<std::string, UI_RLink *> choice_map_url;

    UI_CustomCheckBox *mod_button;

    std::string id_name;

    // only used while positioning the options (as they are added)
    int cur_opt_y;

  public:
    UI_Module(int X, int Y, int W, int H, const std::string &id, const std::string &label, const std::string &tip, int red, int green,
              int blue, bool suboptions);
    virtual ~UI_Module();

    void AddOption(const std::string &option, const std::string &label, const std::string &tip, std::string &longtip, int gap,
                   const std::string &randomize_group, const std::string &default_value);

    void AddHeader(const std::string &option, const std::string &label, int gap);

    void AddUrl(const std::string &option, const std::string &label, const std::string &url, int gap);

    void AddSliderOption(const std::string &option, std::string &label, const std::string &tip, std::string &longtip, int gap,
                         double min, double max, double inc, const std::string &units, const std::string &presets, const std::string &nan,
                         const std::string &randomize_group, const std::string &default_value);

    void AddButtonOption(const std::string &opt, const std::string &label, const std::string &tip, std::string &longtip, int gap,
                         const std::string &randomize_group, const std::string &default_value);

    void AddOptionChoice(const std::string &option, const std::string &id, const std::string &label);

    bool SetOption(const std::string &option, const std::string &value);

    bool SetSliderOption(const std::string &option, const std::string &value);

    bool SetButtonOption(const std::string &option, int value);

    bool Is_UI() const;

  public:
    int CalcHeight() const;

    void update_Enable();

    void randomize_Values(std::vector<std::string> selected_randomize_groups);

    UI_RChoice *FindOpt(const std::string &opt);       // const;

    UI_RSlide *FindSliderOpt(const std::string &opt);  // const;

    UI_RButton *FindButtonOpt(const std::string &opt); // const;

    UI_RHeader *FindHeaderOpt(const std::string &opt); // const;

    UI_RLink *FindUrlOpt(const std::string &opt);      // const;

  protected:
  private:
    void resize(int X, int Y, int W, int H);

    static void callback_OptChange(Fl_Widget *w, void *data);
    static void callback_OptChangeDefault(Fl_Widget *w, void *data);
    static void callback_OptButtonDefault(Fl_Widget *w, void *data);
    static void callback_OptSliderDefault(Fl_Widget *w, void *data);
    static void callback_PresetCheck(Fl_Widget *w, void *data);
    static void callback_SliderPrevious(Fl_Widget *w, void *data);
    static void callback_SliderNext(Fl_Widget *w, void *data);
    static void callback_ShowHelp(Fl_Widget *w, void *data);
    static void callback_ManualEntry(Fl_Widget *w, void *data);
    static void callback_NanOptions(Fl_Widget *w, void *data);
};

class UI_CustomMods : public Fl_Group
{
  public:
    Fl_Group *mod_pack;

    Fl_Scrollbar *sbar;

  private:
    // area occupied by module list
    int mx, my, mw, mh;

    // number of pixels "lost" above the top of the module area
    int offset_y;

    // total height of all shown modules
    int total_h;

  public:
    UI_CustomMods(int X, int Y, int W, int H, const std::string &label);
    virtual ~UI_CustomMods();

  public:
    void AddModule(const std::string &id, const std::string &label, const std::string &tip, int red, int green, int blue, bool suboptions);

    // these return false if module is unknown
    bool ShowModule(const std::string &id, bool new_shown);
    bool EnableMod(const std::string &id, bool enable);

    bool AddHeader(const std::string &module, const std::string &option, const std::string &label, int gap);

    bool AddUrl(const std::string &module, const std::string &option, const std::string &label, const std::string &url, int gap);

    bool AddOption(const std::string &module, const std::string &option, const std::string &label, const std::string &tip, std::string &longtip,
                   int gap, const std::string &randomize_group, const std::string &default_value);

    bool AddSliderOption(const std::string &module, const std::string &option, std::string &label, const std::string &tip,
                         std::string &longtip, int gap, double min, double max, double inc, const std::string &units,
                         const std::string &presets, const std::string &nan, const std::string &randomize_group, const std::string &default_value);

    bool AddButtonOption(const std::string &module, const std::string &option, const std::string &label, const std::string &tip,
                         std::string &longtip, int gap, const std::string &randomize_group, const std::string &default_value);

    bool AddOptionChoice(const std::string &module, const std::string &option, const std::string &id, const std::string &label);

    bool SetOption(const std::string &module, const std::string &option, const std::string &value);

    bool SetSliderOption(const std::string &module, const std::string &option, const std::string &value);

    bool SetButtonOption(const std::string &module, const std::string &option, int value);

    void Locked(bool value);

    void SurpriseMe();

    UI_Module *FindID(const std::string &id) const;

  private:
    void PositionAll(UI_Module *focus = NULL);

    void resize(int X, int Y, int W, int H);

    static void callback_Scroll(Fl_Widget *w, void *data);
    static void callback_ModEnable(Fl_Widget *w, void *data);
};

class UI_CustomTabs : public Fl_Tabs
{
  public:
    UI_CustomMods *arch_mods;
    UI_CustomMods *combat_mods;
    UI_CustomMods *pickup_mods;
    UI_CustomMods *other_mods;
    UI_CustomMods *debug_mods;
    UI_CustomMods *experimental_mods;
    UI_CustomMods *links;

  private:
  public:
    UI_CustomTabs(int X, int Y, int W, int H);
    virtual ~UI_CustomTabs();

  public:
};

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
