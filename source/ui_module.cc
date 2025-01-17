//------------------------------------------------------------------------
//  Custom Module list
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
#include <locale.h>

#include <stdexcept>

#include "lib_util.h"
#include "m_lua.h"
#include "m_trans.h"
#include "main.h"
#include "sys_assert.h"
#include "sys_macro.h"
#include "sys_xoshiro.h"

UI_Module::UI_Module(int X, int Y, int W, int H, const std::string &id, const std::string &label,
                     const std::string &tip, int red, int green, int blue, bool suboptions)
    : Fl_Group(X, Y, W, H), choice_map(), cur_opt_y(0)
{
    box(box_style);

    id_name = id;

    if ((red >= 0) && (green >= 0) && (blue >= 0))
    {
        color(fl_rgb_color(red, green, blue));
    }

    mod_button = new UI_CustomCheckBox(X + KromulentWidth(6), Y + KromulentHeight(5), W - KromulentWidth(12),
                                       KromulentHeight(24));
    mod_button->box(FL_NO_BOX);
    if (suboptions)
    {
        mod_button->down_box(FL_NO_BOX);
    }
    mod_button->color(WINDOW_BG);

    if (Is_UI())
    {
        mod_button->value(1);
        mod_button->hide();
    }

    int tx = Is_UI() ? 8 : 28;

    if (!Is_UI())
    {
        heading = new Fl_Box(FL_NO_BOX, X + KromulentWidth(tx), Y + KromulentHeight(4), W - KromulentWidth(tx + 4),
                             KromulentHeight(24), "");
        heading->copy_label(label.c_str());
        heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
        heading->labelfont(font_style | FL_BOLD);
    }

    if (!tip.empty())
    {
        mod_button->copy_tooltip(tip.c_str());
        if (!Is_UI())
        {
            heading->copy_tooltip(tip.c_str());
        }
    }

    cur_opt_y += Is_UI() ? KromulentHeight(8) : KromulentHeight(32);

    end();

    resizable(NULL);

    hide();
}

UI_Module::~UI_Module()
{
}

bool UI_Module::Is_UI() const
{
    return (!StringCompare(id_name.substr(0, 3), "ui_"));
}

void UI_Module::AddHeader(const std::string &opt, const std::string &label, int gap)
{
    int nw = this->parent()->w();

    int nx = x() + KromulentWidth(6);
    int ny = y() + cur_opt_y - KromulentHeight(15);

    UI_RHeader *rhead = new UI_RHeader(nx, ny + KromulentHeight(15), nw * .95, KromulentHeight(24));

    rhead->mod_label = new Fl_Box(rhead->x(), rhead->y(), rhead->w() * .95, KromulentHeight(24), "");
    rhead->mod_label->copy_label(label.c_str());
    rhead->mod_label->align((FL_ALIGN_CENTER | FL_ALIGN_INSIDE | FL_ALIGN_CLIP));
    rhead->mod_label->labelfont(font_style + 1);
    rhead->mod_label->labelsize(header_font_size - 2);

    if (!mod_button->value())
    {
        if (collapse_disabled_modules)
            rhead->hide();
        else
            rhead->deactivate();
    }

    add(rhead);

    cur_opt_y += (KromulentHeight(26) + (gap * 10));

    resize(x(), y(), w(), CalcHeight());
    redraw();

    choice_map_header[opt] = rhead;
}

void UI_Module::AddUrl(const std::string &opt, const std::string &label, const std::string &url, int gap)
{
    int nw = this->parent()->w();

    int nx = x() + KromulentWidth(6);
    int ny = y() + cur_opt_y - KromulentHeight(15);

    UI_RLink *rurl = new UI_RLink(nx, ny + KromulentHeight(15), nw * .95, KromulentHeight(24));

    rurl->mod_link = new UI_ModHyperLink(rurl->x(), rurl->y(), rurl->w() * .95, KromulentHeight(24), "", url.c_str());
    rurl->mod_link->copy_label(label.c_str());
    rurl->mod_link->align((FL_ALIGN_CENTER | FL_ALIGN_INSIDE | FL_ALIGN_CLIP));
    rurl->mod_link->labelfont(font_style);
    rurl->mod_link->labelsize(header_font_size - 2);

    if (!mod_button->value())
    {
        if (collapse_disabled_modules)
            rurl->hide();
        else
            rurl->deactivate();
    }

    add(rurl);

    cur_opt_y += (KromulentHeight(26) + (gap * 10));

    resize(x(), y(), w(), CalcHeight());
    redraw();

    choice_map_url[opt] = rurl;
}

void UI_Module::AddOption(const std::string &opt, const std::string &label, const std::string &tip,
                          std::string &longtip, int gap, const std::string &randomize_group,
                          const std::string &default_value)
{
    int nw = this->parent()->w();
    //    int nh = KromulentHeight(30);

    int nx = x() + KromulentWidth(6);
    int ny = y() + cur_opt_y - KromulentHeight(15);

    if (longtip.empty())
    {
        longtip = tip;
    }

    UI_RChoice *rch = new UI_RChoice(nx, ny + KromulentHeight(15), nw * .95, KromulentHeight(24));

    rch->mod_label = new Fl_Box(rch->x(), rch->y(), rch->w() * .40, KromulentHeight(24), "");
    rch->mod_label->copy_label(StringFormat("%s: ", label.c_str()).c_str());
    rch->mod_label->align(FL_ALIGN_RIGHT | FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    rch->mod_label->labelfont(font_style);
    rch->mod_label->copy_tooltip(tip.c_str());

    rch->mod_menu = new UI_RChoiceMenu(rch->x() + (rch->w() * .40), rch->y(), rch->w() * .50, KromulentHeight(24));
    rch->mod_menu->textcolor(FONT2_COLOR);
    rch->mod_menu->selection_color(SELECTION);

    rch->mod_reset = new UI_ResetOption(rch->x() + (rch->w() * .90), rch->y(), rch->w() * .075, KromulentHeight(24));
    rch->mod_reset->box(FL_NO_BOX);
    rch->mod_reset->labelcolor(FONT_COLOR);
    rch->mod_reset->visible_focus(0);

    rch->mod_help = new UI_HelpLink(rch->x() + (rch->w() * .95), rch->y(), rch->w() * .075, KromulentHeight(24));
    rch->mod_help->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER);
    rch->mod_help->labelfont(font_style);
    rch->mod_help->labelcolor(FONT_COLOR);
    rch->mod_help->help_text  = longtip;
    rch->mod_help->help_title = label;
    rch->mod_help->callback(callback_ShowHelp, NULL);

    rch->cb_data           = new opt_change_callback_data_t;
    rch->cb_data->mod      = rch;
    rch->cb_data->opt_name = opt;

    rch->mod_reset->callback(callback_OptChangeDefault, rch->cb_data);
    rch->mod_menu->callback(callback_OptChange, rch->cb_data);

    rch->randomize_group = randomize_group;

    rch->default_value = default_value;

    if (!mod_button->value())
    {
        if (collapse_disabled_modules)
            rch->hide();
        else
        {
            rch->mod_label->deactivate();
            rch->mod_menu->deactivate();
            rch->mod_reset->deactivate();
        }
    }

    add(rch);

    cur_opt_y += (KromulentHeight(26) + (gap * 10));

    resize(x(), y(), w(), CalcHeight());
    redraw();

    choice_map[opt] = rch;
}

void UI_Module::AddSliderOption(const std::string &opt, std::string &label, const std::string &tip,
                                std::string &longtip, int gap, double min, double max, double inc,
                                const std::string &units, const std::string &presets, const std::string &nan,
                                const std::string &randomize_group, const std::string &default_value)
{
    int nw = this->parent()->w();

    int nx = x() + KromulentWidth(6);
    int ny = y() + cur_opt_y - KromulentHeight(15);

    if (longtip.empty())
    {
        longtip = tip;
    }

    label = StringFormat("%s: ", label.c_str());

    UI_RSlide *rsl = new UI_RSlide(nx, ny + KromulentHeight(15), nw * .95, KromulentHeight(24));

    // Populate the nan_options vector
    std::string::size_type oldpos = 0;
    std::string::size_type pos    = 0;
    while (pos != std::string::npos)
    {
        pos                    = nan.find(',', oldpos);
        std::string nan_string = nan.substr(oldpos, (pos == std::string::npos ? nan.size() : pos) - oldpos);
        if (!nan_string.empty())
        {
            rsl->nan_choices.push_back(nan_string);
        }
        if (pos != std::string::npos)
        {
            oldpos = pos + 1;
        }
    }

    rsl->mod_label = new Fl_Box(rsl->x(), rsl->y(), rsl->w() * .40, KromulentHeight(24), "");
    rsl->mod_label->copy_label(label.c_str());
    rsl->mod_label->align(FL_ALIGN_RIGHT | FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    rsl->mod_label->labelfont(font_style);
    rsl->mod_label->copy_tooltip(tip.c_str());

    rsl->prev_button =
        new UI_CustomArrowButton(rsl->x() + (rsl->w() * .40), rsl->y(), rsl->w() * .05, KromulentHeight(24));
    rsl->prev_button->copy_label("@<");
    rsl->prev_button->visible_focus(0);
    rsl->prev_button->box(button_style);
    rsl->prev_button->color(BUTTON_COLOR);
    rsl->prev_button->align(FL_ALIGN_INSIDE);
    rsl->prev_button->labelcolor(SELECTION);
    rsl->prev_button->labelsize(rsl->prev_button->labelsize() * .80);
    rsl->prev_button->callback(callback_SliderPrevious, NULL);

    rsl->mod_slider = new UI_CustomSlider(rsl->x() + (rsl->w() * .45), rsl->y(),
                                          rsl->w() * (rsl->nan_choices.size() > 0 ? .30 : .35), KromulentHeight(24));
    rsl->mod_slider->box(button_style);
    rsl->mod_slider->visible_focus(0);
    rsl->mod_slider->color(BUTTON_COLOR);
    rsl->mod_slider->selection_color(SELECTION);
    rsl->mod_slider->minimum(min);
    rsl->mod_slider->maximum(max);
    rsl->mod_slider->step(inc);
    rsl->mod_slider->callback(callback_PresetCheck, NULL);

    rsl->unit_label = new Fl_Box(rsl->x() + (rsl->w() * .45), rsl->y(),
                                 rsl->w() * (rsl->nan_choices.size() > 0 ? .30 : .35), KromulentHeight(24), "");
    rsl->unit_label->align(FL_ALIGN_CENTER | FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    rsl->unit_label->labelfont(font_style);
    rsl->unit_label->labelcolor(FONT2_COLOR);

    rsl->next_button = new UI_CustomArrowButton(rsl->x() + rsl->w() * (rsl->nan_choices.size() > 0 ? .75 : .80),
                                                rsl->y(), rsl->w() * .05, KromulentHeight(24));
    rsl->next_button->copy_label("@>");
    rsl->next_button->box(button_style);
    rsl->next_button->color(BUTTON_COLOR);
    rsl->next_button->visible_focus(0);
    rsl->next_button->align(FL_ALIGN_INSIDE);
    rsl->next_button->labelcolor(SELECTION);
    rsl->next_button->labelsize(rsl->next_button->labelsize() * .80);
    rsl->next_button->callback(callback_SliderNext, NULL);

    if (rsl->nan_choices.size() > 0)
    {
        rsl->nan_options =
            new UI_CustomMenuButton(rsl->x() + (rsl->w() * .80), rsl->y(), rsl->w() * .075, KromulentHeight(24));
        rsl->nan_options->box(FL_FLAT_BOX);
        rsl->nan_options->color(this->color());
        rsl->nan_options->selection_color(SELECTION);
        rsl->nan_options->add(_("Use Slider Value"));
        for (std::string::size_type x = 0; x < rsl->nan_choices.size(); x++)
        {
            rsl->nan_options->add(rsl->nan_choices[x].c_str());
        }
        rsl->nan_options->callback(callback_NanOptions, NULL);
    }
    else
        rsl->nan_options = nullptr;

    rsl->mod_entry = new UI_ManualEntry(rsl->x() + (rsl->w() * .85), rsl->y(), rsl->w() * .075, KromulentHeight(24));
    rsl->mod_entry->box(FL_NO_BOX);
    rsl->mod_entry->labelcolor(FONT_COLOR);
    rsl->mod_entry->visible_focus(0);
    rsl->mod_entry->callback(callback_ManualEntry, NULL);

    rsl->mod_reset = new UI_ResetOption(rsl->x() + (rsl->w() * .90), rsl->y(), rsl->w() * .075, KromulentHeight(24));
    rsl->mod_reset->box(FL_NO_BOX);
    rsl->mod_reset->labelcolor(FONT_COLOR);
    rsl->mod_reset->visible_focus(0);

    rsl->mod_help = new UI_HelpLink(rsl->x() + (rsl->w() * .95), rsl->y(), rsl->w() * .075, KromulentHeight(24));
    rsl->mod_help->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER);
    rsl->mod_help->labelfont(font_style);
    rsl->mod_help->labelcolor(FONT_COLOR);
    rsl->mod_help->help_text  = longtip;
    rsl->mod_help->help_title = label;
    rsl->mod_help->callback(callback_ShowHelp, NULL);

    rsl->units = units;

    // Populate the preset_choices map
    oldpos = 0;
    pos    = 0;
    setlocale(LC_NUMERIC, "C");

    while (pos != std::string::npos)
    {
        pos                    = presets.find(',', oldpos);
        std::string map_string = presets.substr(oldpos, (pos == std::string::npos ? nan.size() : pos) - oldpos);
        if (!map_string.empty())
        {
            std::string::size_type temp_pos = map_string.find(':');
            if (temp_pos == std::string::npos)
            {
                goto skippreset;
            }
            double key;
            try
            {
                key                      = stod(map_string.substr(0, temp_pos));
                std::string value        = map_string.substr(temp_pos + 1);
                rsl->preset_choices[key] = value;
            }
            catch (std::invalid_argument &e)
            {
                fl_message("Invalid argument for preset slider value!");
                goto skippreset;
            }
            catch (std::out_of_range &e)
            {
                fl_message("Number out of range for preset slider value!");
                goto skippreset;
            }
            catch (std::exception &e)
            {
                fl_message("%s", e.what());
            }
        }
    skippreset:
        if (pos != std::string::npos)
        {
            oldpos = pos + 1;
        }
    }

    setlocale(LC_NUMERIC, numeric_locale.c_str());

    rsl->cb_data           = new opt_change_callback_data_t;
    rsl->cb_data->mod      = rsl;
    rsl->cb_data->opt_name = opt;

    rsl->mod_reset->callback(callback_OptSliderDefault, rsl->cb_data);

    rsl->randomize_group = randomize_group;

    rsl->default_value = default_value;

    if (!mod_button->value())
    {
        if (collapse_disabled_modules)
            rsl->hide();
        else
        {
            rsl->prev_button->deactivate();
            rsl->next_button->deactivate();
            rsl->mod_label->deactivate();
            rsl->mod_reset->deactivate();
            rsl->mod_slider->deactivate();
            rsl->mod_entry->deactivate();
            rsl->unit_label->deactivate();
            if (rsl->nan_options)
                rsl->nan_options->deactivate();
        }
    }

    add(rsl);

    cur_opt_y += (KromulentHeight(26) + (gap * 10));

    resize(x(), y(), w(), CalcHeight());
    redraw();

    choice_map_slider[opt] = rsl;
}

void UI_Module::AddButtonOption(const std::string &opt, const std::string &label, const std::string &tip,
                                std::string &longtip, int gap, const std::string &randomize_group,
                                const std::string &default_value)
{
    int nw = this->parent()->w();
    //    int nh = KromulentHeight(30);

    int nx = x() + KromulentWidth(6);
    int ny = y() + cur_opt_y - KromulentHeight(15);

    if (longtip.empty())
    {
        longtip = tip;
    }

    UI_RButton *rbt = new UI_RButton(nx, ny + KromulentHeight(15), nw * .95, KromulentHeight(24));

    rbt->mod_label = new Fl_Box(rbt->x(), rbt->y(), rbt->w() * .40, KromulentHeight(24), "");
    rbt->mod_label->copy_label(StringFormat("%s: ", label.c_str()).c_str());
    rbt->mod_label->align(FL_ALIGN_RIGHT | FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    rbt->mod_label->labelfont(font_style);
    rbt->mod_label->copy_tooltip(tip.c_str());

    rbt->mod_check =
        new UI_CustomCheckBox(rbt->x() + (rbt->w() * .40), rbt->y(), rbt->w() * .10, KromulentHeight(24), "");
    rbt->mod_check->selection_color(SELECTION);

    rbt->mod_reset = new UI_ResetOption(rbt->x() + (rbt->w() * .90), rbt->y(), rbt->w() * .075, KromulentHeight(24));
    rbt->mod_reset->box(FL_NO_BOX);
    rbt->mod_reset->labelcolor(FONT_COLOR);
    rbt->mod_reset->visible_focus(0);

    rbt->mod_help = new UI_HelpLink(rbt->x() + (rbt->w() * .95), rbt->y(), rbt->w() * .075, KromulentHeight(24));
    rbt->mod_help->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER);
    rbt->mod_help->labelfont(font_style);
    rbt->mod_help->labelcolor(FONT_COLOR);
    rbt->mod_help->help_text  = longtip;
    rbt->mod_help->help_title = label;
    rbt->mod_help->callback(callback_ShowHelp, NULL);

    rbt->cb_data           = new opt_change_callback_data_t;
    rbt->cb_data->mod      = rbt;
    rbt->cb_data->opt_name = opt;

    rbt->mod_reset->callback(callback_OptButtonDefault, rbt->cb_data);

    rbt->randomize_group = randomize_group;

    rbt->default_value = default_value;

    if (!mod_button->value())
    {
        if (collapse_disabled_modules)
            rbt->hide();
        else
        {
            rbt->mod_label->deactivate();
            rbt->mod_check->deactivate();
            rbt->mod_reset->deactivate();
        }
    }

    add(rbt);

    cur_opt_y += (KromulentHeight(26) + (gap * 10));

    resize(x(), y(), w(), CalcHeight());
    redraw();

    choice_map_button[opt] = rbt;
}

int UI_Module::CalcHeight() const
{
    if (collapse_disabled_modules)
    {
        if (mod_button->value())
        {
            return cur_opt_y + KromulentHeight(6);
        }
        else
        {
            return KromulentHeight(34);
        }
    }
    else
        return cur_opt_y + KromulentHeight(6);
}

void UI_Module::update_Enable()
{       
    std::map<std::string, UI_RChoice *>::const_iterator IT;
    std::map<std::string, UI_RSlide *>::const_iterator  IT2;
    std::map<std::string, UI_RButton *>::const_iterator IT3;
    std::map<std::string, UI_RHeader *>::const_iterator IT4;
    std::map<std::string, UI_RLink *>::const_iterator   IT5;

    for (IT = choice_map.begin(); IT != choice_map.end(); IT++)
    {
        UI_RChoice *M = IT->second;

        if (mod_button->value())
        {
            if (collapse_disabled_modules)
                M->show();
            else
            {
                M->mod_label->activate();
                M->mod_menu->activate();
                M->mod_reset->activate();
            }
        }
        else
        {
            if (collapse_disabled_modules)
                M->hide();
            else
            {
                M->mod_label->deactivate();
                M->mod_menu->deactivate();
                M->mod_reset->deactivate();
            }
        }
    }

    for (IT2 = choice_map_slider.begin(); IT2 != choice_map_slider.end(); IT2++)
    {
        UI_RSlide *M = IT2->second;

        if (mod_button->value())
        {
            if (collapse_disabled_modules)
                M->show();
            else
            {
                M->unit_label->activate();
                M->prev_button->activate();
                M->next_button->activate();
                M->mod_label->activate();
                M->mod_reset->activate();
                M->mod_slider->activate();
                M->mod_entry->activate();
                if (M->nan_options)
                    M->nan_options->activate();
            }
        }
        else
        {
            if (collapse_disabled_modules)
                M->hide();
            else
            {
                M->unit_label->deactivate();
                M->prev_button->deactivate();
                M->next_button->deactivate();
                M->mod_label->deactivate();
                M->mod_reset->deactivate();
                M->mod_slider->deactivate();
                M->mod_entry->deactivate();
                if (M->nan_options)
                    M->nan_options->deactivate();
            }
        }
    }

    for (IT3 = choice_map_button.begin(); IT3 != choice_map_button.end(); IT3++)
    {
        UI_RButton *M = IT3->second;

        if (mod_button->value())
        {
            if (collapse_disabled_modules)
                M->show();
            else
            {
                M->mod_label->activate();
                M->mod_check->activate();
                M->mod_reset->activate();
            }
        }
        else
        {
            if (collapse_disabled_modules)
                M->hide();
            else
            {
                M->mod_label->deactivate();
                M->mod_check->deactivate();
                M->mod_reset->deactivate();
            }
        }
    }

    for (IT4 = choice_map_header.begin(); IT4 != choice_map_header.end(); IT4++)
    {
        UI_RHeader *M = IT4->second;

        if (mod_button->value())
        {
            if (collapse_disabled_modules)
                M->show();
            else
                M->activate();
        }
        else
        {
            if (collapse_disabled_modules)
                M->hide();
            else
                M->deactivate();
        }
    }

    for (IT5 = choice_map_url.begin(); IT5 != choice_map_url.end(); IT5++)
    {
        UI_RLink *M = IT5->second;

        if (mod_button->value())
        {
            if (collapse_disabled_modules)
                M->show();
            else
                M->activate();
        }
        else
        {
            if (collapse_disabled_modules)
                M->hide();
            else
                M->deactivate();
        }
    }
}

void UI_Module::randomize_Values(std::vector<std::string> selected_randomize_groups)
{
    std::map<std::string, UI_RChoice *>::const_iterator IT;
    std::map<std::string, UI_RSlide *>::const_iterator  IT2;
    std::map<std::string, UI_RButton *>::const_iterator IT3;

    for (IT = choice_map.begin(); IT != choice_map.end(); IT++)
    {
        UI_RChoice *M = IT->second;
        SYS_ASSERT(M);
        for (auto group : selected_randomize_groups)
        {
            if (StringCompare(group, M->randomize_group) == 0)
            {
                M->mod_menu->value(xoshiro_Between(0, M->mod_menu->size() - 1));
                M->mod_menu->do_callback();
                break;
            }
        }
    }

    for (IT2 = choice_map_slider.begin(); IT2 != choice_map_slider.end(); IT2++)
    {
        UI_RSlide *M = IT2->second;
        SYS_ASSERT(M);
        for (auto group : selected_randomize_groups)
        {
            if (StringCompare(group, M->randomize_group) == 0)
            {
                if (M->nan_choices.size() > 0)
                {
                    M->nan_options->value(0);
                    M->nan_options->do_callback();
                }
                M->mod_slider->value(
                    M->mod_slider->round(xoshiro_Between(M->mod_slider->minimum(), M->mod_slider->maximum())));
                M->mod_slider->do_callback();
                break;
            }
        }
    }

    for (IT3 = choice_map_button.begin(); IT3 != choice_map_button.end(); IT3++)
    {
        UI_RButton *M = IT3->second;
        SYS_ASSERT(M);
        for (auto group : selected_randomize_groups)
        {
            if (StringCompare(group, M->randomize_group) == 0)
            {
                if (xoshiro_Float() < 0.5)
                {
                    M->mod_check->value(0);
                }
                else
                {
                    M->mod_check->value(1);
                }
                M->mod_check->do_callback();
                break;
            }
        }
    }
}

void UI_Module::AddOptionChoice(const std::string &option, const std::string &id, const std::string &label)
{
    UI_RChoice *rch = FindOpt(option);

    if (!rch)
    {
        LogPrint("Warning: module '%s' lacks option '%s' (for choice '%s')\n", id_name.c_str(), option.c_str(),
                 id.c_str());
        return;
    }

    rch->mod_menu->AddChoice(id, label);
    rch->mod_menu->EnableChoice(id, 1);
}

bool UI_Module::SetOption(const std::string &option, const std::string &value)
{
    UI_RChoice *rch = FindOpt(option);

    if (!rch)
    {
        return false;
    }

    rch->mod_menu->ChangeTo(value);

    return true;
}

bool UI_Module::SetSliderOption(const std::string &option, const std::string &value)
{
    UI_RSlide *rsl = FindSliderOpt(option);

    if (!rsl)
    {
        return false;
    }
    double double_value;
    try
    {
        double_value = stod(value);
        if (limit_break)
        {
            rsl->mod_slider->value(double_value);
        }
        else
        {
            rsl->mod_slider->value(rsl->mod_slider->clamp(double_value));
        }
        rsl->mod_slider->do_callback();
        if (rsl->nan_choices.size() > 0)
        {
            rsl->nan_options->value(0);
            rsl->nan_options->do_callback();
        }
    }
    catch (std::invalid_argument &e)
    {
        // If it is a nan value instead
        rsl->nan_options->value(rsl->nan_options->find_index(value.c_str()));
        rsl->nan_options->do_callback();
    }
    catch (std::out_of_range &e)
    {
        // This shouldn't happen
        fl_message("%s", e.what());
    }
    catch (std::exception &e)
    {
        // This shouldn't happen either
        fl_message("%s", e.what());
    }
    return true;
}

bool UI_Module::SetButtonOption(const std::string &option, int value)
{
    UI_RButton *rbt = FindButtonOpt(option);

    if (!rbt)
    {
        return false;
    }

    rbt->mod_check->value(value);
    return true;
}

UI_RChoice *UI_Module::FindOpt(const std::string &option)
{
    if (choice_map.find(option) == choice_map.end())
    {
        return NULL;
    }

    return choice_map[option];
}

UI_RSlide *UI_Module::FindSliderOpt(const std::string &option)
{
    if (choice_map_slider.find(option) == choice_map_slider.end())
    {
        return NULL;
    }

    return choice_map_slider[option];
}

UI_RButton *UI_Module::FindButtonOpt(const std::string &option)
{
    if (choice_map_button.find(option) == choice_map_button.end())
    {
        return NULL;
    }

    return choice_map_button[option];
}

UI_RHeader *UI_Module::FindHeaderOpt(const std::string &option)
{
    if (choice_map_header.find(option) == choice_map_header.end())
    {
        return NULL;
    }

    return choice_map_header[option];
}

UI_RLink *UI_Module::FindUrlOpt(const std::string &option)
{
    if (choice_map_url.find(option) == choice_map_url.end())
    {
        return NULL;
    }

    return choice_map_url[option];
}

void UI_Module::callback_OptChange(Fl_Widget *w, void *data)
{
    UI_RChoiceMenu *rch = (UI_RChoiceMenu *)w;

    opt_change_callback_data_t *cb_data = (opt_change_callback_data_t *)data;

    SYS_ASSERT(rch);
    SYS_ASSERT(cb_data);

    UI_RChoice *M = (UI_RChoice *)cb_data->mod;

    UI_Module *parent = (UI_Module *)M->parent();

    ob_set_mod_option(parent->id_name, cb_data->opt_name, rch->GetID());
}

void UI_Module::callback_OptChangeDefault(Fl_Widget *w, void *data)
{
    UI_RChoiceMenu *rch = (UI_RChoiceMenu *)w;

    opt_change_callback_data_t *cb_data = (opt_change_callback_data_t *)data;

    SYS_ASSERT(rch);
    SYS_ASSERT(cb_data);

    UI_RChoice *M = (UI_RChoice *)cb_data->mod;

    UI_Module *parent = (UI_Module *)M->parent();

    ob_set_mod_option(parent->id_name, cb_data->opt_name, M->default_value);
}

void UI_Module::callback_OptButtonDefault(Fl_Widget *w, void *data)
{
    opt_change_callback_data_t *cb_data = (opt_change_callback_data_t *)data;

    SYS_ASSERT(cb_data);

    UI_RButton *M = (UI_RButton *)cb_data->mod;

    UI_Module *parent = (UI_Module *)M->parent();

    ob_set_mod_option(parent->id_name, cb_data->opt_name, M->default_value);
}

void UI_Module::callback_OptSliderDefault(Fl_Widget *w, void *data)
{
    opt_change_callback_data_t *cb_data = (opt_change_callback_data_t *)data;

    SYS_ASSERT(cb_data);

    UI_RSlide *M = (UI_RSlide *)cb_data->mod;

    UI_Module *parent = (UI_Module *)M->parent();

    ob_set_mod_option(parent->id_name, cb_data->opt_name, M->default_value);
}

void UI_Module::callback_PresetCheck(Fl_Widget *w, void *data)
{
    Fl_Hor_Slider *mod_slider = (Fl_Hor_Slider *)w;

    SYS_ASSERT(mod_slider);

    UI_RSlide *current_slider = (UI_RSlide *)mod_slider->parent();

    double value = mod_slider->value();

    if (value == -0)
    {
        value = 0; // Silly, but keeps "negative zero" from being show on the label
    }

    std::string new_label;

    current_slider->unit_label->label(BLANKOUT);

    // Check against the preset_choices map
    if (current_slider->preset_choices.count(value) == 1)
    {
        new_label = current_slider->preset_choices[value];
        current_slider->unit_label->copy_label(new_label.c_str());
    }
    else
    {
        new_label = StringFormat("%2g", value);
        current_slider->unit_label->copy_label(new_label.append(current_slider->units).c_str());
    }
}

void UI_Module::callback_SliderPrevious(Fl_Widget *w, void *data)
{
    Fl_Button *prev_button = (Fl_Button *)w;

    SYS_ASSERT(prev_button);

    UI_RSlide *current_slider = (UI_RSlide *)prev_button->parent();

    double value = current_slider->mod_slider->value();

    if (current_slider->preset_choices.empty())
    {
        int steps = (int)((current_slider->mod_slider->maximum() / current_slider->mod_slider->step()) * .10);
        if (steps < 1)
        {
            steps = 1;
        }
        double temp_value = current_slider->mod_slider->increment(value, -steps);
        if (temp_value < current_slider->mod_slider->minimum())
        {
            current_slider->mod_slider->value(current_slider->mod_slider->minimum());
            current_slider->mod_slider->do_callback();
        }
        else
        {
            current_slider->mod_slider->value(temp_value);
            current_slider->mod_slider->do_callback();
        }
    }
    else
    {
        int match = 0;
        do
        {
            double temp_value = current_slider->mod_slider->increment(value, -1);
            if (temp_value >= current_slider->mod_slider->minimum())
            {
                value = temp_value;
            }
            else
            {
                break;
            }
            match = current_slider->preset_choices.count(value);
        } while (match == 0);

        if (match == 1)
        {
            current_slider->mod_slider->value(value);
            current_slider->mod_slider->do_callback();
        }
    }
}

void UI_Module::callback_SliderNext(Fl_Widget *w, void *data)
{
    Fl_Button *next_button = (Fl_Button *)w;

    SYS_ASSERT(next_button);

    UI_RSlide *current_slider = (UI_RSlide *)next_button->parent();

    double value = current_slider->mod_slider->value();

    if (current_slider->preset_choices.empty())
    {
        int steps = (int)((current_slider->mod_slider->maximum() / current_slider->mod_slider->step()) * .10);
        if (steps < 1)
        {
            steps = 1;
        }
        double temp_value = current_slider->mod_slider->increment(value, steps);
        if (temp_value > current_slider->mod_slider->maximum())
        {
            current_slider->mod_slider->value(current_slider->mod_slider->maximum());
            current_slider->mod_slider->do_callback();
        }
        else
        {
            current_slider->mod_slider->value(temp_value);
            current_slider->mod_slider->do_callback();
        }
    }
    else
    {
        int match = 0;
        do
        {
            double temp_value = current_slider->mod_slider->increment(value, 1);
            if (temp_value <= current_slider->mod_slider->maximum())
            {
                value = temp_value;
            }
            else
            {
                break;
            }
            match = current_slider->preset_choices.count(value);
        } while (match == 0);

        if (match == 1)
        {
            current_slider->mod_slider->value(value);
            current_slider->mod_slider->do_callback();
        }
    }
}

void UI_Module::callback_ShowHelp(Fl_Widget *w, void *data)
{
    UI_HelpLink *mod_help = (UI_HelpLink *)w;

    SYS_ASSERT(mod_help);
    fl_cursor(FL_CURSOR_DEFAULT);
    Fl_Window       *win  = new Fl_Window(640, 480, mod_help->help_title.c_str());
    Fl_Text_Buffer  *buff = new Fl_Text_Buffer();
    Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40, NULL);
    disp->buffer(buff);
    disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
    win->resizable(*disp);
    win->hotspot(0, 0, 0);
    win->set_modal();
    win->show();
    buff->text(mod_help->help_text.c_str());
}

void UI_Module::callback_ManualEntry(Fl_Widget *w, void *data)
{
    UI_ManualEntry *mod_entry = (UI_ManualEntry *)w;

    UI_RSlide *current_slider = (UI_RSlide *)mod_entry->parent();

    std::string float_buf;
    double      new_value = 0;
    std::string string_value;

    float_buf = StringFormat("%2g", current_slider->mod_slider->value());

tryagain:

    const char *value_buf = fl_input("%s", float_buf.c_str(), _("Enter Value:"));

    // cancelled?
    if (!value_buf)
    {
        goto end;
    }

    string_value = value_buf;

    try
    {
        new_value = stod(string_value);
    }
    catch (std::invalid_argument &e)
    {
        fl_message("Invalid argument! Try again!");
        goto tryagain;
    }
    catch (std::out_of_range &e)
    {
        fl_message("Number out of range! Try again!");
        goto tryagain;
    }
    catch (std::exception &e)
    {
        fl_message("%s", e.what());
    }

    if (limit_break)
    {
        current_slider->mod_slider->value(current_slider->mod_slider->round(new_value));
    }
    else
    {
        current_slider->mod_slider->value(
            current_slider->mod_slider->clamp(current_slider->mod_slider->round(new_value)));
    }
    current_slider->mod_slider->do_callback();

end:;
}

void UI_Module::callback_NanOptions(Fl_Widget *w, void *data)
{
    UI_CustomMenuButton *nan_options    = (UI_CustomMenuButton *)w;
    UI_RSlide           *current_slider = (UI_RSlide *)nan_options->parent();

    int temp_value = nan_options->value();

    if (temp_value > 0)
    {
        std::string new_label;
        current_slider->unit_label->label(BLANKOUT);
        new_label = nan_options->text(temp_value);
        current_slider->unit_label->copy_label(new_label.c_str());
        current_slider->prev_button->deactivate();
        current_slider->mod_slider->deactivate();
        current_slider->next_button->deactivate();
        current_slider->mod_entry->deactivate();
    }
    else
    {
        current_slider->prev_button->activate();
        current_slider->mod_slider->activate();
        current_slider->next_button->activate();
        current_slider->mod_entry->activate();
        current_slider->mod_slider->do_callback();
    }
}

//----------------------------------------------------------------

UI_CustomMods::UI_CustomMods(int X, int Y, int W, int H, const std::string &label) : Fl_Group(X, Y, W, H)
{

    box(FL_FLAT_BOX);

    copy_label(label.c_str());

    labelfont(font_style | FL_BOLD);

    color(GAP_COLOR, GAP_COLOR);

    int cy = Y;

    // area for module list
    mx = X;
    my = cy;
    mw = W - Fl::scrollbar_size();
    mh = Y + H - cy;

    offset_y = 0;
    total_h  = 0;

    sbar = new Fl_Scrollbar(mx + mw, my, Fl::scrollbar_size(), mh);
    sbar->callback(callback_Scroll, this);
    sbar->slider(button_style);
    sbar->color(GAP_COLOR, BUTTON_COLOR);
    sbar->labelcolor(SELECTION);

    mod_pack = new Fl_Group(mx, my, mw, mh);
    mod_pack->box(FL_FLAT_BOX);
    mod_pack->color(GAP_COLOR);
    mod_pack->resizable(mod_pack);
    mod_pack->clip_children(1);
    mod_pack->end();

    end();

    resizable(mod_pack);

    end();
}

UI_CustomMods::~UI_CustomMods()
{
}

typedef struct
{
    UI_Module     *mod;
    UI_CustomMods *parent;
} mod_enable_callback_data_t;

void UI_CustomMods::AddModule(const std::string &id, const std::string &label, const std::string &tip, int red,
                              int green, int blue, bool suboptions)
{
    UI_Module *M = new UI_Module(mx, my, mw - 4, KromulentHeight(34), id, label, tip, red, green, blue, suboptions);

    mod_enable_callback_data_t *cb_data = new mod_enable_callback_data_t;
    cb_data->mod                        = M;
    cb_data->parent                     = this;

    if (!M->Is_UI())
    {
        M->mod_button->callback(callback_ModEnable, cb_data);
    }

    mod_pack->add(M);

    PositionAll();
}

bool UI_CustomMods::AddHeader(const std::string &module, const std::string &option, const std::string &label, int gap)
{
    UI_Module *M = FindID(module);

    if (!M)
    {
        return false;
    }

    M->AddHeader(option, label, gap);

    PositionAll();

    return true;
}

bool UI_CustomMods::AddUrl(const std::string &module, const std::string &option, const std::string &label,
                           const std::string &url, int gap)
{
    UI_Module *M = FindID(module);

    if (!M)
    {
        return false;
    }

    M->AddUrl(option, label, url, gap);

    PositionAll();

    return true;
}

bool UI_CustomMods::AddOption(const std::string &module, const std::string &option, const std::string &label,
                              const std::string &tip, std::string &longtip, int gap, const std::string &randomize_group,
                              const std::string &default_value)
{
    UI_Module *M = FindID(module);

    if (!M)
    {
        return false;
    }

    M->AddOption(option, label, tip, longtip, gap, randomize_group, default_value);

    PositionAll();

    return true;
}

bool UI_CustomMods::AddSliderOption(const std::string &module, const std::string &option, std::string &label,
                                    const std::string &tip, std::string &longtip, int gap, double min, double max,
                                    double inc, const std::string &units, const std::string &presets,
                                    const std::string &nan, const std::string &randomize_group,
                                    const std::string &default_value)
{
    UI_Module *M = FindID(module);

    if (!M)
    {
        return false;
    }

    M->AddSliderOption(option, label, tip, longtip, gap, min, max, inc, units, presets, nan, randomize_group,
                       default_value);

    PositionAll();

    return true;
}

bool UI_CustomMods::AddButtonOption(const std::string &module, const std::string &option, const std::string &label,
                                    const std::string &tip, std::string &longtip, int gap,
                                    const std::string &randomize_group, const std::string &default_value)
{
    UI_Module *M = FindID(module);

    if (!M)
    {
        return false;
    }

    M->AddButtonOption(option, label, tip, longtip, gap, randomize_group, default_value);

    PositionAll();

    return true;
}

bool UI_CustomMods::AddOptionChoice(const std::string &module, const std::string &option, const std::string &id,
                                    const std::string &label)
{
    UI_Module *M = FindID(module);

    if (!M)
    {
        return false;
    }

    M->AddOptionChoice(option, id, label);

    return true;
}

bool UI_CustomMods::ShowModule(const std::string &id, bool new_shown)
{
    SYS_ASSERT(!id.empty());

    UI_Module *M = FindID(id);

    if (!M)
    {
        return false;
    }

    if ((M->visible() ? 1 : 0) == (new_shown ? 1 : 0))
    {
        return true;
    }

    if (new_shown)
    {
        M->show();
    }
    else
    {
        M->hide();
    }

    PositionAll();

    return true;
}

bool UI_CustomMods::SetOption(const std::string &module, const std::string &option, const std::string &value)
{
    UI_Module *M = FindID(module);

    if (!M)
    {
        return false;
    }

    return M->SetOption(option, value);
}

bool UI_CustomMods::SetSliderOption(const std::string &module, const std::string &option, const std::string &value)
{
    UI_Module *M = FindID(module);

    if (!M)
    {
        return false;
    }

    return M->SetSliderOption(option, value);
}

bool UI_CustomMods::SetButtonOption(const std::string &module, const std::string &option, int value)
{
    UI_Module *M = FindID(module);

    if (!M)
    {
        return false;
    }

    return M->SetButtonOption(option, value);
}

bool UI_CustomMods::EnableMod(const std::string &id, bool enable)
{
    SYS_ASSERT(!id.empty());

    UI_Module *M = FindID(id);

    if (!M)
    {
        return false;
    }

    if ((M->mod_button->value() ? 1 : 0) == (enable ? 1 : 0))
    {
        return true; // no change
    }

    M->mod_button->value(enable ? 1 : 0);
    M->update_Enable();

    // no options => no height change => no need to reposition
    if (M->choice_map.size() > 0 || M->choice_map_slider.size() > 0 || M->choice_map_button.size() > 0 ||
        M->choice_map_header.size() > 0 || M->choice_map_url.size() > 0)
    {
        PositionAll();
    }

    return true;
}

void UI_CustomMods::PositionAll(UI_Module *focus)
{
    // determine focus [closest to top without going past it]
    if (!focus)
    {
        int best_dist = 9999;

        for (int j = 0; j < mod_pack->children(); j++)
        {
            UI_Module *M = (UI_Module *)mod_pack->child(j);
            SYS_ASSERT(M);

            if (!M->visible() || M->y() < my || M->y() >= my + mh)
            {
                continue;
            }

            int dist = M->y() - my;

            if (dist < best_dist)
            {
                focus     = M;
                best_dist = dist;
            }
        }
    }

    // calculate new total height
    int new_height = 0;
    int spacing    = 4;

    for (int k = 0; k < mod_pack->children(); k++)
    {
        UI_Module *M = (UI_Module *)mod_pack->child(k);
        SYS_ASSERT(M);

        if (M->visible())
        {
            new_height += M->CalcHeight() + spacing;
        }
    }

    // determine new offset_y
    if (new_height <= mh)
    {
        offset_y = 0;
    }
    else if (focus)
    {
        int focus_oy = focus->y() - my;

        int above_h = 0;
        for (int k = 0; k < mod_pack->children(); k++)
        {
            UI_Module *M = (UI_Module *)mod_pack->child(k);
            if (M->visible() && M->y() < focus->y())
            {
                above_h += M->CalcHeight() + spacing;
            }
        }

        offset_y = above_h - focus_oy;

        offset_y = OBSIDIAN_MAX(offset_y, 0);
        offset_y = OBSIDIAN_MIN(offset_y, new_height - mh);
    }
    else
    {
        // when not shrinking, offset_y will remain valid
        if (new_height < total_h)
        {
            offset_y = 0;
        }
    }

    total_h = new_height;

    SYS_ASSERT(offset_y >= 0);
    SYS_ASSERT(offset_y <= total_h);

    // reposition all the modules
    int ny = my - offset_y;

    for (int j = 0; j < mod_pack->children(); j++)
    {
        UI_Module *M = (UI_Module *)mod_pack->child(j);
        SYS_ASSERT(M);

        int nh = M->visible() ? M->CalcHeight() : 1;

        if (ny != M->y() || nh != M->h())
        {
            M->resize(M->x(), ny, M->w(), nh);
        }

        if (M->visible())
        {
            ny += M->CalcHeight() + spacing;
        }
    }

    // p = position, first line displayed
    // w = window, number of lines displayed
    // t = top, number of first line
    // l = length, total number of lines
    sbar->value(offset_y, mh, 0, total_h);

    mod_pack->redraw();
}

// Normal FLTK resize except it will resize the module options as well
void UI_Module::resize(int X, int Y, int W, int H)
{
    int dx = X - x();
    int dy = Y - y();
    int dw = W - w();
    int dh = H - h();

    int *p = sizes();              // save initial sizes and positions

    Fl_Widget::resize(X, Y, W, H); // make new xywh values visible for children

    if (!resizable() || (dw == 0 && dh == 0))
    {
        if (type() < FL_WINDOW)
        {
            Fl_Widget *const *a = array();
            for (int i = children(); i--;)
            {
                Fl_Widget *o = *a++;
                o->resize(o->x() + dx, o->y() + dy, o->w(), o->h());
            }
        }
    }
    else if (children())
    {
        // get changes in size/position from the initial size:
        dx = X - p[0];
        dw = W - (p[1] - p[0]);
        dy = Y - p[2];
        dh = H - (p[3] - p[2]);
        if (type() >= FL_WINDOW)
        {
            dx = dy = 0;
        }
        p += 4;

        // get initial size of resizable():
        int IX = *p++;
        int IR = *p++;
        int IY = *p++;
        int IB = *p++;

        Fl_Widget *const *a = array();
        for (int i = children(); i--;)
        {
            Fl_Widget *o = *a++;
#if 1
            int XX = *p++;
            if (XX >= IR)
            {
                XX += dw;
            }
            else if (XX > IX)
            {
                XX = IX + ((XX - IX) * (IR + dw - IX) + (IR - IX) / 2) / (IR - IX);
            }
            int R = *p++;
            if (R >= IR)
            {
                R += dw;
            }
            else if (R > IX)
            {
                R = IX + ((R - IX) * (IR + dw - IX) + (IR - IX) / 2) / (IR - IX);
            }

            int YY = *p++;
            if (YY >= IB)
            {
                YY += dh;
            }
            else if (YY > IY)
            {
                YY = IY + ((YY - IY) * (IB + dh - IY) + (IB - IY) / 2) / (IB - IY);
            }
            int B = *p++;
            if (B >= IB)
            {
                B += dh;
            }
            else if (B > IY)
            {
                B = IY + ((B - IY) * (IB + dh - IY) + (IB - IY) / 2) / (IB - IY);
            }
#else // much simpler code from Francois Ostiguy:
            int XX = *p++;
            if (XX >= IR)
                XX += dw;
            else if (XX > IX)
                XX += dw * (XX - IX) / (IR - IX);
            int R = *p++;
            if (R >= IR)
                R += dw;
            else if (R > IX)
                R = R + dw * (R - IX) / (IR - IX);

            int YY = *p++;
            if (YY >= IB)
                YY += dh;
            else if (YY > IY)
                YY = YY + dh * (YY - IY) / (IB - IY);
            int B = *p++;
            if (B >= IB)
                B += dh;
            else if (B > IY)
                B = B + dh * (B - IY) / (IB - IY);
#endif
            o->resize(XX + dx, YY + dy, R - XX, B - YY);
        }
    }

    for (int i = 0; i < this->children(); i++)
    {
        this->child(i)->resize(this->child(i)->x(), this->child(i)->y(), w() * .95, this->child(i)->h());
        this->child(i)->redraw();
    }
}

// Normal FLTK resize except it will reset the scrollbar to the top
void UI_CustomMods::resize(int X, int Y, int W, int H)
{
    int dx = X - x();
    int dy = Y - y();
    int dw = W - w();
    int dh = H - h();

    int *p = sizes();              // save initial sizes and positions

    Fl_Widget::resize(X, Y, W, H); // make new xywh values visible for children

    if (!resizable() || (dw == 0 && dh == 0))
    {
        if (type() < FL_WINDOW)
        {
            Fl_Widget *const *a = array();
            for (int i = children(); i--;)
            {
                Fl_Widget *o = *a++;
                o->resize(o->x() + dx, o->y() + dy, o->w(), o->h());
            }
        }
    }
    else if (children())
    {
        // get changes in size/position from the initial size:
        dx = X - p[0];
        dw = W - (p[1] - p[0]);
        dy = Y - p[2];
        dh = H - (p[3] - p[2]);
        if (type() >= FL_WINDOW)
        {
            dx = dy = 0;
        }
        p += 4;

        // get initial size of resizable():
        int IX = *p++;
        int IR = *p++;
        int IY = *p++;
        int IB = *p++;

        Fl_Widget *const *a = array();
        for (int i = children(); i--;)
        {
            Fl_Widget *o = *a++;
#if 1
            int XX = *p++;
            if (XX >= IR)
            {
                XX += dw;
            }
            else if (XX > IX)
            {
                XX = IX + ((XX - IX) * (IR + dw - IX) + (IR - IX) / 2) / (IR - IX);
            }
            int R = *p++;
            if (R >= IR)
            {
                R += dw;
            }
            else if (R > IX)
            {
                R = IX + ((R - IX) * (IR + dw - IX) + (IR - IX) / 2) / (IR - IX);
            }

            int YY = *p++;
            if (YY >= IB)
            {
                YY += dh;
            }
            else if (YY > IY)
            {
                YY = IY + ((YY - IY) * (IB + dh - IY) + (IB - IY) / 2) / (IB - IY);
            }
            int B = *p++;
            if (B >= IB)
            {
                B += dh;
            }
            else if (B > IY)
            {
                B = IY + ((B - IY) * (IB + dh - IY) + (IB - IY) / 2) / (IB - IY);
            }
#else // much simpler code from Francois Ostiguy:
            int XX = *p++;
            if (XX >= IR)
                XX += dw;
            else if (XX > IX)
                XX += dw * (XX - IX) / (IR - IX);
            int R = *p++;
            if (R >= IR)
                R += dw;
            else if (R > IX)
                R = R + dw * (R - IX) / (IR - IX);

            int YY = *p++;
            if (YY >= IB)
                YY += dh;
            else if (YY > IY)
                YY = YY + dh * (YY - IY) / (IB - IY);
            int B = *p++;
            if (B >= IB)
                B += dh;
            else if (B > IY)
                B = B + dh * (B - IY) / (IB - IY);
#endif
            o->resize(XX + dx, YY + dy, R - XX, B - YY);
        }
    }

    // calculate new total height
    int new_height = 0;
    int spacing    = 4;

    for (int k = 0; k < this->mod_pack->children(); k++)
    {
        UI_Module *M = (UI_Module *)mod_pack->child(k);
        SYS_ASSERT(M);

        if (M->visible())
        {
            new_height += M->CalcHeight() + spacing;
        }
    }

    // determine new offset_y
    if (new_height <= mh)
    {
        offset_y = 0;
    }

    total_h = new_height;

    SYS_ASSERT(offset_y >= 0);
    SYS_ASSERT(offset_y <= total_h);

    // reposition all the modules
    int ny = my - offset_y;

    for (int j = 0; j < mod_pack->children(); j++)
    {
        UI_Module *M = (UI_Module *)mod_pack->child(j);
        SYS_ASSERT(M);

        int nh = M->visible() ? M->CalcHeight() : 1;

        if (ny != M->y() || nh != M->h())
        {
            M->resize(M->x(), ny, M->w(), nh);
        }

        if (M->visible())
        {
            ny += M->CalcHeight() + spacing;
        }
    }

    // p = position, first line displayed
    // w = window, number of lines displayed
    // t = top, number of first line
    // l = length, total number of lines
    this->sbar->value(offset_y, mh, 0, total_h);

    this->mod_pack->redraw();
}

void UI_CustomMods::callback_Scroll(Fl_Widget *w, void *data)
{
    UI_CustomMods *that = (UI_CustomMods *)data;

    Fl_Scrollbar *sbar = (Fl_Scrollbar *)w;

    int previous_y = that->offset_y;

    that->offset_y = sbar->value();

    int dy = that->offset_y - previous_y;

    // simply reposition all the UI_Module widgets
    for (int j = 0; j < that->mod_pack->children(); j++)
    {
        Fl_Widget *F = that->mod_pack->child(j);
        SYS_ASSERT(F);

        F->resize(F->x(), F->y() - dy, F->w(), F->h());
    }

    that->mod_pack->redraw();
}

void UI_CustomMods::callback_ModEnable(Fl_Widget *w, void *data)
{
    mod_enable_callback_data_t *cb_data = (mod_enable_callback_data_t *)data;
    SYS_ASSERT(cb_data);

    UI_Module *M = cb_data->mod;

    M->update_Enable();

    // no options => no height change => no need to reposition
    if (M->choice_map.size() > 0 || M->choice_map_slider.size() > 0 || M->choice_map_button.size() > 0 ||
        M->choice_map_url.size() > 0)
    {
        cb_data->parent->PositionAll(M);
    }

    ob_set_mod_option(M->id_name, "self", M->mod_button->value() ? "true" : "false");
}

UI_Module *UI_CustomMods::FindID(const std::string &id) const
{
    for (int j = 0; j < mod_pack->children(); j++)
    {
        UI_Module *M = (UI_Module *)mod_pack->child(j);
        SYS_ASSERT(M);

        if (!StringCompare(M->id_name, id))
        {
            return M;
        }
    }

    return NULL;
}

void UI_CustomMods::Locked(bool value)
{
    if (value)
    {
        for (int j = 0; j < mod_pack->children(); j++)
        {
            UI_Module *M = (UI_Module *)mod_pack->child(j);
            SYS_ASSERT(M);
            M->deactivate();
        }
    }
    else
    {
        for (int j = 0; j < mod_pack->children(); j++)
        {
            UI_Module *M = (UI_Module *)mod_pack->child(j);
            SYS_ASSERT(M);
            M->activate();
        }
    }
}

void UI_CustomMods::SurpriseMe()
{
    for (int j = 0; j < mod_pack->children(); j++)
    {
        UI_Module *M = (UI_Module *)mod_pack->child(j);
        SYS_ASSERT(M);
        std::vector<std::string> selected_randomize_groups;
        if (randomize_architecture)
        {
            selected_randomize_groups.push_back("architecture");
        }
        if (randomize_monsters)
        {
            selected_randomize_groups.push_back("monsters");
        }
        if (randomize_pickups)
        {
            selected_randomize_groups.push_back("pickups");
        }
        if (randomize_misc)
        {
            selected_randomize_groups.push_back("misc");
        }
        M->randomize_Values(selected_randomize_groups);
    }
}

UI_CustomTabs::UI_CustomTabs(int X, int Y, int W, int H) : Fl_Tabs(X, Y, W, H)
{

    box(box_style);

    color(BUTTON_COLOR, WINDOW_BG);

    visible_focus(0);

    arch_mods = new UI_CustomMods(X, Y + KromulentHeight(22), W, H - KromulentHeight(22), _("Architecture"));
    arch_mods->color(BUTTON_COLOR, BUTTON_COLOR);
    arch_mods->end();
    combat_mods = new UI_CustomMods(X, Y + KromulentHeight(22), W, H - KromulentHeight(22), _("Combat"));
    combat_mods->color(BUTTON_COLOR, BUTTON_COLOR);
    combat_mods->end();
    pickup_mods = new UI_CustomMods(X, Y + KromulentHeight(22), W, H - KromulentHeight(22), _("Pickups"));
    pickup_mods->color(BUTTON_COLOR, BUTTON_COLOR);
    pickup_mods->end();
    other_mods = new UI_CustomMods(X, Y + KromulentHeight(22), W, H - KromulentHeight(22), _("Other"));
    other_mods->color(BUTTON_COLOR, BUTTON_COLOR);
    other_mods->end();
    debug_mods = new UI_CustomMods(X, Y + KromulentHeight(22), W, H - KromulentHeight(22), _("Debug"));
    debug_mods->color(BUTTON_COLOR, BUTTON_COLOR);
    debug_mods->end();
    experimental_mods = new UI_CustomMods(X, Y + KromulentHeight(22), W, H - KromulentHeight(22), _("Experimental"));
    experimental_mods->color(BUTTON_COLOR, BUTTON_COLOR);
    experimental_mods->end();
    links = new UI_CustomMods(X, Y + KromulentHeight(22), W, H - KromulentHeight(22), _("Links"));
    links->color(BUTTON_COLOR, BUTTON_COLOR);
    links->end();

    end();

    resizable(arch_mods);
}

UI_CustomTabs::~UI_CustomTabs()
{
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
