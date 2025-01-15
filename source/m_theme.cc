//----------------------------------------------------------------------
//  Theme Editor
//----------------------------------------------------------------------
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
//----------------------------------------------------------------------

#include <FL/Fl_Color_Chooser.H>
#include <FL/Fl_Native_File_Chooser.H>
#include <FL/Fl_Simple_Counter.H>

#include <algorithm>

#include "lib_argv.h"
#include "lib_util.h"
#include "m_addons.h"
#include "m_cookie.h"
#include "m_trans.h"
#include "main.h"
#include "sys_assert.h"
#include "sys_macro.h"

bool skip_color_picker = false;

//----------------------------------------------------------------------

std::string Theme_OutputFilename()
{
    // save and restore the font height
    // (because FLTK's own browser get totally borked)
    int old_font_h = FL_NORMAL_SIZE;
    FL_NORMAL_SIZE = 14 + KF;

    Fl_Native_File_Chooser chooser;

    chooser.title(_("Select output file"));
    chooser.type(Fl_Native_File_Chooser::BROWSE_SAVE_FILE);

    if (overwrite_warning)
    {
        chooser.options(Fl_Native_File_Chooser::SAVEAS_CONFIRM);
    }

    chooser.filter("Text files\t*.txt");

    std::string theme_dir = PathAppend(install_dir, "theme");
    chooser.directory(SanitizePath(theme_dir).c_str());

    FL_NORMAL_SIZE = old_font_h;

    switch (chooser.show())
    {
    case -1:
        LogPrint("Error choosing output file:\n");
        LogPrint("   %s\n", chooser.errmsg());

        DLG_ShowError(_("Unable to create the file:\n\n%s"), chooser.errmsg());
        return "";

    case 1: // cancelled
        return "";

    default:
        break; // OK
    }

    std::string filename = chooser.filename();
    ReplaceExtension(filename, ".txt");
    // re-check for overwriting
    if (FileExists(filename))
    {
        if (!fl_choice("%s", fl_cancel, fl_ok, NULL, Fl_Native_File_Chooser::file_exists_message))
        {
            return ""; // cancelled
        }
    }

    return filename;
}

std::string Theme_AskLoadFilename()
{
    Fl_Native_File_Chooser chooser;

    chooser.title(_("Select Theme file to load"));
    chooser.type(Fl_Native_File_Chooser::BROWSE_FILE);

    chooser.filter("Text files\t*.txt");

    std::string theme_dir = PathAppend(install_dir, "theme");
    chooser.directory(SanitizePath(theme_dir).c_str());

    int result = chooser.show();

    switch (result)
    {
    case -1:
        LogPrint("Error choosing load file:\n");
        LogPrint("   %s\n", chooser.errmsg());

        DLG_ShowError(_("Unable to load the file:\n\n%s"), chooser.errmsg());
        return "";

    case 1: // cancelled
        return "";

    default:
        break; // OK
    }

    std::string filename = chooser.filename();

    return filename;
}

static void Parse_Theme_Option(std::string name, std::string value)
{
    if (StringCompare(name, "window_scaling") == 0)
    {
        window_scaling = StringToInt(value);
        window_scaling = OBSIDIAN_CLAMP(0, window_scaling, 5);
    }
    else if (StringCompare(name, "font_scaling") == 0)
    {
        font_scaling = StringToInt(value);
    }
    else if (StringCompare(name, "font_theme") == 0)
    {
        font_theme = StringToInt(value);
    }
    else if (StringCompare(name, "widget_theme") == 0)
    {
        widget_theme = StringToInt(value);
    }
    else if (StringCompare(name, "box_theme") == 0)
    {
        box_theme = StringToInt(value);
    }
    else if (StringCompare(name, "button_theme") == 0)
    {
        button_theme = StringToInt(value);
    }
    else if (StringCompare(name, "color_scheme") == 0)
    {
        color_scheme = StringToInt(value);
    }
    else if (StringCompare(name, "text_red") == 0)
    {
        text_red = StringToInt(value);
    }
    else if (StringCompare(name, "text_green") == 0)
    {
        text_green = StringToInt(value);
    }
    else if (StringCompare(name, "text_blue") == 0)
    {
        text_blue = StringToInt(value);
    }
    else if (StringCompare(name, "text2_red") == 0)
    {
        text2_red = StringToInt(value);
    }
    else if (StringCompare(name, "text2_green") == 0)
    {
        text2_green = StringToInt(value);
    }
    else if (StringCompare(name, "text2_blue") == 0)
    {
        text2_blue = StringToInt(value);
    }
    else if (StringCompare(name, "bg_red") == 0)
    {
        bg_red = StringToInt(value);
    }
    else if (StringCompare(name, "bg_green") == 0)
    {
        bg_green = StringToInt(value);
    }
    else if (StringCompare(name, "bg_blue") == 0)
    {
        bg_blue = StringToInt(value);
    }
    else if (StringCompare(name, "bg2_red") == 0)
    {
        bg2_red = StringToInt(value);
    }
    else if (StringCompare(name, "bg2_green") == 0)
    {
        bg2_green = StringToInt(value);
    }
    else if (StringCompare(name, "bg2_blue") == 0)
    {
        bg2_blue = StringToInt(value);
    }
    else if (StringCompare(name, "button_red") == 0)
    {
        button_red = StringToInt(value);
    }
    else if (StringCompare(name, "button_green") == 0)
    {
        button_green = StringToInt(value);
    }
    else if (StringCompare(name, "button_blue") == 0)
    {
        button_blue = StringToInt(value);
    }
    else if (StringCompare(name, "gradient_red") == 0)
    {
        gradient_red = StringToInt(value);
    }
    else if (StringCompare(name, "gradient_green") == 0)
    {
        gradient_green = StringToInt(value);
    }
    else if (StringCompare(name, "gradient_blue") == 0)
    {
        gradient_blue = StringToInt(value);
    }
    else if (StringCompare(name, "border_red") == 0)
    {
        border_red = StringToInt(value);
    }
    else if (StringCompare(name, "border_green") == 0)
    {
        border_green = StringToInt(value);
    }
    else if (StringCompare(name, "border_blue") == 0)
    {
        border_blue = StringToInt(value);
    }
    else if (StringCompare(name, "gap_red") == 0)
    {
        gap_red = StringToInt(value);
    }
    else if (StringCompare(name, "gap_green") == 0)
    {
        gap_green = StringToInt(value);
    }
    else if (StringCompare(name, "gap_blue") == 0)
    {
        gap_blue = StringToInt(value);
    }
    else
    {
        LogPrint("Unknown option: '%s'\n", name.c_str());
    }
}

static bool Theme_Options_ParseLine(std::string buf)
{
    std::string::size_type pos = 0;

    pos = buf.find('=', 0);
    if (pos == std::string::npos)
    {
        // Skip blank lines, comments, etc
        return true;
    }

    while (std::find(buf.begin(), buf.end(), ' ') != buf.end())
    {
        buf.erase(std::find(buf.begin(), buf.end(), ' '));
    }

    if (!(IsAlphaASCII(buf.front()) || buf.front() == '@'))
    {
        LogPrint("Weird theme option line: [%s]\n", buf.c_str());
        return false;
    }

    pos               = buf.find('=', 0); // Fix pos after whitespace deletion
    std::string name  = buf.substr(0, pos);
    std::string value = buf.substr(pos + 1);

    if (name.empty() || value.empty())
    {
        LogPrint("Name or value missing!\n");
        return false;
    }

    Parse_Theme_Option(name, value);
    return true;
}

bool Theme_Options_Load(const std::string &filename)
{
    FILE *option_fp = FileOpen(filename, "r");

    if (!option_fp)
    {
        LogPrint("Missing Theme file -- using defaults.\n\n");
        return false;
    }

    LogPrint("Loading theme file: %s\n", filename.c_str());

    int error_count = 0;

    std::string buffer;
    int         c = EOF;
    for (;;)
    {
        buffer.clear();
        while ((c = fgetc(option_fp)) != EOF)
        {
            if (c == '\n' || c == '\r')
                break;
            else
                buffer.push_back(c);
        }

        if (!Theme_Options_ParseLine(buffer))
        {
            error_count += 1;
        }

        if (feof(option_fp) || ferror(option_fp))
            break;
    }

    if (error_count > 0)
    {
        LogPrint("DONE (found %d parse errors)\n\n", error_count);
    }
    else
    {
        LogPrint("DONE.\n\n");
    }

    fclose(option_fp);

    return true;
}

bool Theme_Options_Save(const std::string &filename)
{
    FILE *option_fp = FileOpen(filename, "w");

    if (!option_fp)
    {
        LogPrint("Error: unable to create file: %s\n(%s)\n\n", filename.c_str(), strerror(errno));
        return false;
    }

    if (main_action != MAIN_SOFT_RESTART)
    {
        LogPrint("Saving theme file...\n");
    }

    fprintf(option_fp, "-- THEME FILE : OBSIDIAN %s \"%s\"\n", OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str());
    fprintf(option_fp, "-- Build %s\n", OBSIDIAN_VERSION);
    fprintf(option_fp, "-- Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n");
    fprintf(option_fp, "-- %s\n\n", OBSIDIAN_WEBSITE);

    fprintf(option_fp, "window_scaling      = %d\n", window_scaling);
    fprintf(option_fp, "font_scaling      = %d\n", font_scaling);
    fprintf(option_fp, "font_theme      = %d\n", font_theme);
    fprintf(option_fp, "widget_theme      = %d\n", widget_theme);
    fprintf(option_fp, "box_theme      = %d\n", box_theme);
    fprintf(option_fp, "button_theme      = %d\n", button_theme);
    fprintf(option_fp, "color_scheme      = %d\n", color_scheme);
    fprintf(option_fp, "text_red      = %d\n", text_red);
    fprintf(option_fp, "text_green      = %d\n", text_green);
    fprintf(option_fp, "text_blue      = %d\n", text_blue);
    fprintf(option_fp, "text2_red      = %d\n", text2_red);
    fprintf(option_fp, "text2_green      = %d\n", text2_green);
    fprintf(option_fp, "text2_blue      = %d\n", text2_blue);
    fprintf(option_fp, "bg_red      = %d\n", bg_red);
    fprintf(option_fp, "bg_green      = %d\n", bg_green);
    fprintf(option_fp, "bg_blue      = %d\n", bg_blue);
    fprintf(option_fp, "bg2_red      = %d\n", bg2_red);
    fprintf(option_fp, "bg2_green      = %d\n", bg2_green);
    fprintf(option_fp, "bg2_blue      = %d\n", bg2_blue);
    fprintf(option_fp, "button_red      = %d\n", button_red);
    fprintf(option_fp, "button_green      = %d\n", button_green);
    fprintf(option_fp, "button_blue      = %d\n", button_blue);
    fprintf(option_fp, "gradient_red      = %d\n", gradient_red);
    fprintf(option_fp, "gradient_green      = %d\n", gradient_green);
    fprintf(option_fp, "gradient_blue      = %d\n", gradient_blue);
    fprintf(option_fp, "border_red      = %d\n", border_red);
    fprintf(option_fp, "border_green      = %d\n", border_green);
    fprintf(option_fp, "border_blue      = %d\n", border_blue);
    fprintf(option_fp, "gap_red      = %d\n", gap_red);
    fprintf(option_fp, "gap_green      = %d\n", gap_green);
    fprintf(option_fp, "gap_blue      = %d\n", gap_blue);
    fprintf(option_fp, "\n\n");

    fclose(option_fp);

    if (main_action != MAIN_SOFT_RESTART)
    {
        LogPrint("DONE.\n\n");
    }

    return true;
}

//----------------------------------------------------------------------

class UI_ThemeWin : public Fl_Window
{
  public:
    bool want_quit;

  private:
    UI_CustomMenu     *opt_window_scaling;
    Fl_Simple_Counter *opt_font_scaling;
    UI_CustomMenu     *opt_font_theme;
    UI_CustomMenu     *opt_widget_theme;
    UI_CustomMenu     *opt_box_theme;
    UI_CustomMenu     *opt_button_theme;

    UI_CustomMenu *opt_color_scheme;
    Fl_Button     *opt_text_color;
    Fl_Button     *opt_text2_color;
    Fl_Button     *opt_bg_color;
    Fl_Button     *opt_bg2_color;
    Fl_Button     *opt_button_color;
    Fl_Button     *opt_gradient_color;
    Fl_Button     *opt_border_color;
    Fl_Button     *opt_gap_color;
    Fl_Button     *load_defaults;
    Fl_Button     *load_theme;
    Fl_Button     *save_theme;

  public:
    UI_ThemeWin(int W, int H, const char *label = NULL);

    virtual ~UI_ThemeWin()
    {
        // nothing needed
    }

    bool WantQuit() const
    {
        return want_quit;
    }

  public:
    // FLTK virtual method for handling input events.
    int handle(int event);

    void PopulateFonts()
    {
        for (auto font : font_menu_items)
        {
            opt_font_theme->add(font.first.c_str());
        }

        opt_font_theme->value(font_theme);
    }

  private:
    static void callback_Quit(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;

        that->want_quit = true;
    }

    static void callback_WindowScaling(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;

        window_scaling = that->opt_window_scaling->value();
        // clang-format off
        fl_alert("%s", _("Windows scaling changes cannot be applied automatically, but will take effect the next time Obsidian is run.\n"));
        // clang-format on

        that->want_quit = true;
    }

    static void callback_FontScaling(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;

        font_scaling = that->opt_font_scaling->value();

        FL_NORMAL_SIZE = font_scaling;

        small_font_size  = FL_NORMAL_SIZE - 2;
        header_font_size = FL_NORMAL_SIZE + 2;

        fl_message_font(font_style, FL_NORMAL_SIZE + 2);
        main_win->menu_bar->textsize(FL_NORMAL_SIZE * .90);
        main_win->menu_bar->labelsize(FL_NORMAL_SIZE * .90);
        main_win->menu_bar->redraw();
        main_win->game_box->heading->labelsize(header_font_size);
        main_win->game_box->engine->labelsize(FL_NORMAL_SIZE);
        main_win->game_box->engine->textsize(FL_NORMAL_SIZE);
        main_win->game_box->engine->copy_label("                                "
                                               "        ");
        main_win->game_box->engine_help->copy_label("");
        main_win->game_box->engine_help->labelsize(FL_NORMAL_SIZE);
        main_win->game_box->game_help->labelsize(FL_NORMAL_SIZE);
        main_win->game_box->game_help->copy_label("");
        main_win->game_box->game->labelsize(FL_NORMAL_SIZE);
        main_win->game_box->game->textsize(FL_NORMAL_SIZE);
        main_win->game_box->game->copy_label("                                "
                                             "        ");
        main_win->game_box->port->labelsize(FL_NORMAL_SIZE);
        main_win->game_box->port->textsize(FL_NORMAL_SIZE);
        main_win->game_box->port->copy_label("                                "
                                             "        ");
        main_win->game_box->port_help->copy_label("");
        main_win->game_box->port_help->labelsize(FL_NORMAL_SIZE);
        main_win->game_box->length->labelsize(FL_NORMAL_SIZE);
        main_win->game_box->length->textsize(FL_NORMAL_SIZE);
        main_win->game_box->length->copy_label("                                "
                                               "        ");
        main_win->game_box->length_help->copy_label("");
        main_win->game_box->length_help->labelsize(FL_NORMAL_SIZE);
        main_win->game_box->theme->labelsize(FL_NORMAL_SIZE);
        main_win->game_box->theme->textsize(FL_NORMAL_SIZE);
        main_win->game_box->theme->copy_label("                                "
                                              "        ");
        main_win->game_box->build->labelsize(header_font_size);
        main_win->game_box->quit->labelsize(FL_NORMAL_SIZE);
        for (int x = 0; x < main_win->game_box->children(); x++)
        {
            main_win->game_box->child(x)->redraw();
        }
        main_win->game_box->engine->copy_label("Engine: ");
        main_win->game_box->game->copy_label("Game: ");
        main_win->game_box->port->copy_label("Port: ");
        main_win->game_box->length->copy_label("Length: ");
        main_win->game_box->theme->copy_label("Theme: ");
        main_win->game_box->engine_help->copy_label("?");
        main_win->game_box->port_help->copy_label("?");
        main_win->game_box->length_help->copy_label("?");
        main_win->game_box->game_help->copy_label("?");
        main_win->build_box->seed_disp->labelsize(small_font_size);
        main_win->build_box->name_disp->labelsize(small_font_size);
        main_win->build_box->status->labelsize(FL_NORMAL_SIZE);
        main_win->build_box->progress->labelsize(header_font_size);
        for (int x = 0; x < main_win->build_box->children(); x++)
        {
            main_win->build_box->child(x)->redraw();
        }
        for (int t = 0; t < main_win->mod_tabs->children(); t++)
        {
            UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
            for (int x = 0; x < tab->mod_pack->children(); x++)
            {
                UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                SYS_ASSERT(M);
                if (!M->Is_UI())
                {
                    M->heading->labelsize(header_font_size);
                    M->redraw();
                }
                std::map<std::string, UI_RChoice *>::const_iterator IT;
                std::map<std::string, UI_RSlide *>::const_iterator  IT2;
                std::map<std::string, UI_RButton *>::const_iterator IT3;
                for (IT = M->choice_map.begin(); IT != M->choice_map.end(); IT++)
                {
                    UI_RChoice *rch = IT->second;
                    rch->mod_label->labelsize(FL_NORMAL_SIZE);
                    rch->mod_menu->textsize(FL_NORMAL_SIZE);
                    rch->mod_help->labelsize(FL_NORMAL_SIZE);
                    rch->mod_reset->labelsize(FL_NORMAL_SIZE);
                    rch->mod_label->redraw();
                }
                for (IT2 = M->choice_map_slider.begin(); IT2 != M->choice_map_slider.end(); IT2++)
                {
                    UI_RSlide *rsl = IT2->second;
                    rsl->mod_label->labelsize(FL_NORMAL_SIZE);
                    rsl->mod_entry->labelsize(FL_NORMAL_SIZE);
                    rsl->mod_help->labelsize(FL_NORMAL_SIZE);
                    rsl->mod_reset->labelsize(FL_NORMAL_SIZE);
                    rsl->unit_label->labelsize(FL_NORMAL_SIZE);
                    if (rsl->nan_choices.size() > 0)
                    {
                        rsl->nan_options->labelsize(FL_NORMAL_SIZE);
                        rsl->nan_options->textsize(FL_NORMAL_SIZE);
                        rsl->nan_options->redraw();
                    }
                    rsl->mod_label->redraw();
                }
                for (IT3 = M->choice_map_button.begin(); IT3 != M->choice_map_button.end(); IT3++)
                {
                    UI_RButton *rbt = IT3->second;
                    rbt->mod_label->labelsize(FL_NORMAL_SIZE);
                    rbt->mod_help->labelsize(FL_NORMAL_SIZE);
                    rbt->mod_reset->labelsize(FL_NORMAL_SIZE);
                    rbt->mod_label->redraw();
                }
            }
        }
        for (int x = 0; x < main_win->mod_tabs->children(); x++)
        {
            UI_CustomMods *M = (UI_CustomMods *)main_win->mod_tabs->child(x);
            M->labelsize(FL_NORMAL_SIZE);
        }
        main_win->mod_tabs->labelsize(FL_NORMAL_SIZE);
        main_win->mod_tabs->redraw();
        main_win->redraw();
    }

    static void callback_FontTheme(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;

        font_theme = that->opt_font_theme->value();
        font_style = font_menu_items[font_theme].second;
        fl_font(font_style, FL_NORMAL_SIZE);
        fl_message_font(font_style, FL_NORMAL_SIZE);
        main_win->menu_bar->textfont(font_style);
        main_win->menu_bar->redraw();
        main_win->game_box->heading->labelfont(font_style | FL_BOLD);
        main_win->game_box->engine->labelfont(font_style);
        main_win->game_box->engine->textfont(font_style);
        main_win->game_box->engine->copy_label("                                "
                                               "        ");
        main_win->game_box->engine_help->copy_label("");
        main_win->game_box->engine_help->labelfont(font_style);
        main_win->game_box->game_help->labelfont(font_style);
        main_win->game_box->game_help->copy_label("");
        main_win->game_box->game->labelfont(font_style);
        main_win->game_box->game->textfont(font_style);
        main_win->game_box->game->copy_label("                                "
                                             "        ");
        main_win->game_box->port->labelfont(font_style);
        main_win->game_box->port->textfont(font_style);
        main_win->game_box->port->copy_label("                                "
                                             "        ");
        main_win->game_box->port_help->copy_label("");
        main_win->game_box->port_help->labelfont(font_style);
        main_win->game_box->length->labelfont(font_style);
        main_win->game_box->length->textfont(font_style);
        main_win->game_box->length->copy_label("                                "
                                               "        ");
        main_win->game_box->length_help->copy_label("");
        main_win->game_box->length_help->labelfont(font_style);
        main_win->game_box->theme->labelfont(font_style);
        main_win->game_box->theme->textfont(font_style);
        main_win->game_box->theme->copy_label("                                "
                                              "        ");
        main_win->game_box->build->labelfont(font_style | FL_BOLD);
        main_win->game_box->quit->labelfont(font_style);
        for (int x = 0; x < main_win->game_box->children(); x++)
        {
            main_win->game_box->child(x)->redraw();
        }
        main_win->game_box->engine->copy_label("Engine: ");
        main_win->game_box->game->copy_label("Game: ");
        main_win->game_box->port->copy_label("Port: ");
        main_win->game_box->length->copy_label("Length: ");
        main_win->game_box->theme->copy_label("Theme: ");
        main_win->game_box->engine_help->copy_label("?");
        main_win->game_box->port_help->copy_label("?");
        main_win->game_box->length_help->copy_label("?");
        main_win->game_box->game_help->copy_label("?");
        main_win->build_box->seed_disp->labelfont(font_style);
        main_win->build_box->name_disp->labelfont(font_style);
        main_win->build_box->status->labelfont(font_style);
        main_win->build_box->progress->labelfont(font_style);
        for (int x = 0; x < main_win->build_box->children(); x++)
        {
            main_win->build_box->child(x)->redraw();
        }
        for (int t = 0; t < main_win->mod_tabs->children(); t++)
        {
            UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
            for (int x = 0; x < tab->mod_pack->children(); x++)
            {
                UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                SYS_ASSERT(M);
                if (!M->Is_UI())
                {
                    M->heading->labelfont(font_style | FL_BOLD);
                    M->redraw();
                }
                std::map<std::string, UI_RChoice *>::const_iterator IT;
                std::map<std::string, UI_RSlide *>::const_iterator  IT2;
                std::map<std::string, UI_RButton *>::const_iterator IT3;
                for (IT = M->choice_map.begin(); IT != M->choice_map.end(); IT++)
                {
                    UI_RChoice *rch = IT->second;
                    rch->mod_label->labelfont(font_style);
                    rch->mod_menu->textfont(font_style);
                    rch->mod_help->labelfont(font_style);
                    rch->mod_label->redraw();
                }
                for (IT2 = M->choice_map_slider.begin(); IT2 != M->choice_map_slider.end(); IT2++)
                {
                    UI_RSlide *rsl = IT2->second;
                    rsl->mod_label->labelfont(font_style);
                    rsl->mod_entry->labelfont(font_style);
                    rsl->mod_help->labelfont(font_style);
                    rsl->unit_label->labelfont(font_style);
                    rsl->mod_label->redraw();
                }
                for (IT3 = M->choice_map_button.begin(); IT3 != M->choice_map_button.end(); IT3++)
                {
                    UI_RButton *rbt = IT3->second;
                    rbt->mod_label->labelfont(font_style);
                    rbt->mod_help->labelfont(font_style);
                    rbt->mod_label->redraw();
                }
            }
        }
        for (int x = 0; x < main_win->mod_tabs->children(); x++)
        {
            UI_CustomMods *M = (UI_CustomMods *)main_win->mod_tabs->child(x);
            M->labelfont(font_style);
        }
        main_win->mod_tabs->labelfont(font_style);
        main_win->mod_tabs->redraw();
        main_win->redraw();
    }

    static void callback_WidgetTheme(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;

        widget_theme = that->opt_widget_theme->value();

        switch (widget_theme)
        {
        case 0:
            Fl::scheme("gtk+");
            break;
        case 1:
            Fl::scheme("gleam");
            break;
        case 2:
            Fl::scheme("base");
            break;
        case 3:
            Fl::scheme("plastic");
            break;
#if FL_MINOR_VERSION > 3
        case 4:
            Fl::scheme("oxy");
            break;
#endif
        // Shouldn't be reached, but still
        default:
            Fl::scheme("gtk+");
            break;
        }
        // clang-format off
        if (widget_theme == 3) {
            fl_alert("%s", _("Plastic widget theme requires a restart.\nOBSIDIAN will now restart."));
            // clang-format on

            main_action = MAIN_HARD_RESTART;

            that->want_quit = true;
        }
        else
        {
            Fl::reload_scheme();
            switch (box_theme)
            {
            case 0:
                box_style = FL_FLAT_BOX;
                break;
            case 1:
                box_style = FL_SHADOW_BOX;
                break;
            case 2:
                box_style = FL_EMBOSSED_BOX;
                break;
            case 3:
                box_style = FL_ENGRAVED_BOX;
                break;
            case 4:
                switch (widget_theme)
                {
                case 0:
                    box_style = FL_GTK_DOWN_BOX;
                    break;
                case 1:
                    box_style = FL_GLEAM_DOWN_BOX;
                    break;
                case 2:
                    box_style = FL_DOWN_BOX;
                    break;
                case 3:
                    box_style = FL_PLASTIC_DOWN_BOX;
                    break;
#if FL_MINOR_VERSION > 3
                case 4:
                    box_style = FL_OXY_DOWN_BOX;
                    break;
#endif
                default:
                    box_style = FL_GTK_DOWN_BOX;
                    break;
                }
                break;
            case 5:
                switch (widget_theme)
                {
                case 0:
                    box_style = FL_GTK_THIN_UP_BOX;
                    break;
                case 1:
                    box_style = FL_GLEAM_THIN_UP_BOX;
                    break;
                case 2:
                    box_style = FL_THIN_UP_BOX;
                    break;
                case 3:
                    box_style = FL_PLASTIC_THIN_UP_BOX;
                    break;
#if FL_MINOR_VERSION > 3
                case 4:
                    box_style = FL_OXY_THIN_UP_BOX;
                    break;
#endif
                default:
                    box_style = FL_GTK_THIN_UP_BOX;
                    break;
                }
                break;
            // Shouldn't be reached, but still
            default:
                box_style = FL_FLAT_BOX;
                break;
            }
            switch (button_theme)
            {
            case 0:
                switch (widget_theme)
                {
                case 0:
                    button_style = FL_GTK_DOWN_BOX;
                    break;
                case 1:
                    button_style = FL_GLEAM_DOWN_BOX;
                    break;
                case 2:
                    button_style = FL_DOWN_BOX;
                    break;
                case 3:
                    button_style = FL_PLASTIC_DOWN_BOX;
                    break;
#if FL_MINOR_VERSION > 3
                case 4:
                    button_style = FL_OXY_DOWN_BOX;
                    break;
#endif
                default:
                    button_style = FL_GTK_DOWN_BOX;
                    break;
                }
                break;
            case 1:
                switch (widget_theme)
                {
                case 0:
                    button_style = FL_GTK_UP_BOX;
                    break;
                case 1:
                    button_style = FL_GLEAM_UP_BOX;
                    break;
                case 2:
                    button_style = FL_UP_BOX;
                    break;
                case 3:
                    button_style = FL_PLASTIC_UP_BOX;
                    break;
#if FL_MINOR_VERSION > 3
                case 4:
                    button_style = FL_OXY_UP_BOX;
                    break;
#endif
                default:
                    button_style = FL_GTK_UP_BOX;
                    break;
                }
                break;
            case 2:
                button_style = static_cast<Fl_Boxtype>(FL_FREE_BOXTYPE + 2);
                break;
            case 3:
                button_style = FL_EMBOSSED_BOX;
                break;
            case 4:
                button_style = FL_FREE_BOXTYPE;
                break;
            // Shouldn't be reached, but still
            default:
                button_style = FL_DOWN_BOX;
                break;
            }
            main_win->menu_bar->box(box_style);
            main_win->redraw();
            main_win->game_box->box(box_style);
            main_win->game_box->redraw();
            main_win->build_box->box(box_style);
            main_win->build_box->redraw();
            for (int t = 0; t < main_win->mod_tabs->children(); t++)
            {
                UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
                for (int x = 0; x < tab->mod_pack->children(); x++)
                {
                    UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                    SYS_ASSERT(M);
                    M->box(box_style);
                    M->redraw();
                }
            }
            main_win->mod_tabs->box(box_style);
            main_win->mod_tabs->redraw();
            main_win->game_box->build->box(button_style);
            main_win->game_box->quit->box(button_style);
            for (int x = 0; x < main_win->game_box->children(); x++)
            {
                main_win->game_box->child(x)->redraw();
            }
            for (int t = 0; t < main_win->mod_tabs->children(); t++)
            {
                UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
                tab->sbar->slider(button_style);
                tab->redraw();
                for (int x = 0; x < tab->mod_pack->children(); x++)
                {
                    UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                    SYS_ASSERT(M);
                    M->mod_button->down_box(button_style);
                    M->redraw();
                    std::map<std::string, UI_RSlide *>::const_iterator  IT;
                    std::map<std::string, UI_RButton *>::const_iterator IT2;
                    for (IT = M->choice_map_slider.begin(); IT != M->choice_map_slider.end(); IT++)
                    {
                        UI_RSlide *rsl = IT->second;
                        rsl->prev_button->box(button_style);
                        rsl->mod_slider->box(button_style);
                        rsl->next_button->box(button_style);
                        rsl->redraw();
                    }
                    for (IT2 = M->choice_map_button.begin(); IT2 != M->choice_map_button.end(); IT2++)
                    {
                        UI_RButton *rbt = IT2->second;
                        rbt->mod_check->down_box(button_style);
                        rbt->redraw();
                    }
                }
            }
            that->load_defaults->box(button_style);
            that->load_theme->box(button_style);
            that->save_theme->box(button_style);
            for (int x = 0; x < that->children(); x++)
            {
                that->child(x)->redraw();
            }
        }
    }

    static void callback_BoxTheme(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;

        box_theme = that->opt_box_theme->value();

        switch (box_theme)
        {
        case 0:
            box_style = FL_FLAT_BOX;
            break;
        case 1:
            box_style = FL_SHADOW_BOX;
            break;
        case 2:
            box_style = FL_EMBOSSED_BOX;
            break;
        case 3:
            box_style = FL_ENGRAVED_BOX;
            break;
        case 4:
            switch (widget_theme)
            {
            case 0:
                box_style = FL_GTK_DOWN_BOX;
                break;
            case 1:
                box_style = FL_GLEAM_DOWN_BOX;
                break;
            case 2:
                box_style = FL_DOWN_BOX;
                break;
            case 3:
                box_style = FL_PLASTIC_DOWN_BOX;
                break;
#if FL_MINOR_VERSION > 3
            case 4:
                box_style = FL_OXY_DOWN_BOX;
                break;
#endif
            default:
                box_style = FL_GTK_DOWN_BOX;
                break;
            }
            break;
        case 5:
            switch (widget_theme)
            {
            case 0:
                box_style = FL_GTK_THIN_UP_BOX;
                break;
            case 1:
                box_style = FL_GLEAM_THIN_UP_BOX;
                break;
            case 2:
                box_style = FL_THIN_UP_BOX;
                break;
            case 3:
                box_style = FL_PLASTIC_THIN_UP_BOX;
                break;
#if FL_MINOR_VERSION > 3
            case 4:
                box_style = FL_OXY_THIN_UP_BOX;
                break;
#endif
            default:
                box_style = FL_GTK_THIN_UP_BOX;
                break;
            }
            break;
        // Shouldn't be reached, but still
        default:
            box_style = FL_FLAT_BOX;
            break;
        }
        main_win->menu_bar->box(box_style);
        main_win->redraw();
        main_win->game_box->box(box_style);
        main_win->game_box->redraw();
        main_win->build_box->box(box_style);
        main_win->build_box->redraw();
        for (int t = 0; t < main_win->mod_tabs->children(); t++)
        {
            UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
            for (int x = 0; x < tab->mod_pack->children(); x++)
            {
                UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                SYS_ASSERT(M);
                M->box(box_style);
                M->redraw();
            }
        }
        main_win->mod_tabs->box(box_style);
        main_win->mod_tabs->redraw();
    }

    static void callback_ButtonTheme(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;

        button_theme = that->opt_button_theme->value();

        switch (button_theme)
        {
        case 0:
            switch (widget_theme)
            {
            case 0:
                button_style = FL_GTK_DOWN_BOX;
                break;
            case 1:
                button_style = FL_GLEAM_DOWN_BOX;
                break;
            case 2:
                button_style = FL_DOWN_BOX;
                break;
            case 3:
                button_style = FL_PLASTIC_DOWN_BOX;
                break;
#if FL_MINOR_VERSION > 3
            case 4:
                button_style = FL_OXY_DOWN_BOX;
                break;
#endif
            default:
                button_style = FL_GTK_DOWN_BOX;
                break;
            }
            break;
        case 1:
            switch (widget_theme)
            {
            case 0:
                button_style = FL_GTK_UP_BOX;
                break;
            case 1:
                button_style = FL_GLEAM_UP_BOX;
                break;
            case 2:
                button_style = FL_UP_BOX;
                break;
            case 3:
                button_style = FL_PLASTIC_UP_BOX;
                break;
#if FL_MINOR_VERSION > 3
            case 4:
                button_style = FL_OXY_UP_BOX;
                break;
#endif
            default:
                button_style = FL_GTK_UP_BOX;
                break;
            }
            break;
        case 2:
            button_style = static_cast<Fl_Boxtype>(FL_FREE_BOXTYPE + 2);
            break;
        case 3:
            button_style = FL_EMBOSSED_BOX;
            break;
        case 4:
            button_style = FL_FREE_BOXTYPE;
            break;
        // Shouldn't be reached, but still
        default:
            button_style = FL_DOWN_BOX;
            break;
        }
        main_win->game_box->build->box(button_style);
        main_win->game_box->quit->box(button_style);
        for (int x = 0; x < main_win->game_box->children(); x++)
        {
            main_win->game_box->child(x)->redraw();
        }
        for (int t = 0; t < main_win->mod_tabs->children(); t++)
        {
            UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
            tab->sbar->slider(button_style);
            tab->redraw();
            for (int x = 0; x < tab->mod_pack->children(); x++)
            {
                UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                SYS_ASSERT(M);
                M->mod_button->down_box(button_style);
                M->redraw();
                std::map<std::string, UI_RSlide *>::const_iterator  IT;
                std::map<std::string, UI_RButton *>::const_iterator IT2;
                for (IT = M->choice_map_slider.begin(); IT != M->choice_map_slider.end(); IT++)
                {
                    UI_RSlide *rsl = IT->second;
                    rsl->prev_button->box(button_style);
                    rsl->mod_slider->box(button_style);
                    rsl->next_button->box(button_style);
                    rsl->redraw();
                }
                for (IT2 = M->choice_map_button.begin(); IT2 != M->choice_map_button.end(); IT2++)
                {
                    UI_RButton *rbt = IT2->second;
                    rbt->mod_check->down_box(button_style);
                    rbt->redraw();
                }
            }
        }
        that->load_defaults->box(button_style);
        that->load_theme->box(button_style);
        that->save_theme->box(button_style);
        for (int x = 0; x < that->children(); x++)
        {
            that->child(x)->redraw();
        }
    }

    static void callback_ColorScheme(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;

        color_scheme = that->opt_color_scheme->value();

        skip_color_picker = true;
        that->opt_text_color->do_callback();
        that->opt_text2_color->do_callback();
        that->opt_bg_color->do_callback();
        that->opt_bg2_color->do_callback();
        that->opt_button_color->do_callback();
        that->opt_gradient_color->do_callback();
        that->opt_border_color->do_callback();
        that->opt_gap_color->do_callback();
        skip_color_picker = false;
    }

    static void callback_TextColor(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;
        if (!skip_color_picker)
        {
            if (fl_color_chooser((const char *)_("Select Panel Text Color"), text_red, text_green, text_blue, 1))
            {
                that->opt_text_color->color(fl_rgb_color(text_red, text_green, text_blue));
                that->opt_text_color->redraw();
            }
        }
        if (color_scheme == 0)
        {
            FONT_COLOR = fl_rgb_color(225, 225, 225);
            Fl::foreground(225, 225, 225);
            that->opt_text_color->color(FONT_COLOR);
            that->opt_text_color->redraw();
        }
        else
        {
            FONT_COLOR = fl_rgb_color(text_red, text_green, text_blue);
            Fl::foreground(text_red, text_green, text_blue);
        }
        main_win->menu_bar->textcolor(FONT_COLOR);
        main_win->menu_bar->redraw();
        main_win->game_box->heading->labelcolor(FONT_COLOR);
        main_win->game_box->engine->labelcolor(FONT_COLOR);
        main_win->game_box->engine_help->labelcolor(FONT_COLOR);
        main_win->game_box->game->labelcolor(FONT_COLOR);
        main_win->game_box->game_help->labelcolor(FONT_COLOR);
        main_win->game_box->port->labelcolor(FONT_COLOR);
        main_win->game_box->port_help->labelcolor(FONT_COLOR);
        main_win->game_box->length->labelcolor(FONT_COLOR);
        main_win->game_box->length_help->labelcolor(FONT_COLOR);
        main_win->game_box->theme->labelcolor(FONT_COLOR);
        for (int x = 0; x < main_win->game_box->children(); x++)
        {
            main_win->game_box->child(x)->redraw();
            main_win->game_box->child(x)->redraw_label();
        }
        main_win->build_box->seed_disp->labelcolor(FONT_COLOR);
        main_win->build_box->name_disp->labelcolor(FONT_COLOR);
        main_win->build_box->status->labelcolor(FONT_COLOR);
        main_win->build_box->progress->labelcolor(FONT_COLOR);
        for (int x = 0; x < main_win->build_box->children(); x++)
        {
            main_win->build_box->child(x)->redraw();
        }
        main_win->mod_tabs->labelcolor(FONT_COLOR);
        main_win->mod_tabs->redraw();
        for (int t = 0; t < main_win->mod_tabs->children(); t++)
        {
            UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
            for (int x = 0; x < tab->mod_pack->children(); x++)
            {
                UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                SYS_ASSERT(M);
                if (!M->Is_UI())
                {
                    M->heading->labelcolor(FONT_COLOR);
                    M->redraw();
                }
                std::map<std::string, UI_RChoice *>::const_iterator IT;
                std::map<std::string, UI_RSlide *>::const_iterator  IT2;
                std::map<std::string, UI_RButton *>::const_iterator IT3;
                for (IT = M->choice_map.begin(); IT != M->choice_map.end(); IT++)
                {
                    UI_RChoice *rch = IT->second;
                    rch->mod_label->labelcolor(FONT_COLOR);
                    rch->mod_help->labelcolor(FONT_COLOR);
                    rch->mod_reset->labelcolor(FONT_COLOR);
                    rch->mod_label->redraw();
                }
                for (IT2 = M->choice_map_slider.begin(); IT2 != M->choice_map_slider.end(); IT2++)
                {
                    UI_RSlide *rsl = IT2->second;
                    rsl->mod_label->labelcolor(FONT_COLOR);
                    rsl->mod_entry->labelcolor(FONT_COLOR);
                    rsl->mod_help->labelcolor(FONT_COLOR);
                    rsl->mod_reset->labelcolor(FONT_COLOR);
                    if (rsl->nan_choices.size() > 0)
                    {
                        rsl->nan_options->textcolor(FONT_COLOR);
                        rsl->nan_options->labelcolor(FONT_COLOR);
                        rsl->nan_options->redraw();
                    }
                    rsl->mod_label->redraw();
                }
                for (IT3 = M->choice_map_button.begin(); IT3 != M->choice_map_button.end(); IT3++)
                {
                    UI_RButton *rbt = IT3->second;
                    rbt->mod_label->labelcolor(FONT_COLOR);
                    rbt->mod_help->labelcolor(FONT_COLOR);
                    rbt->mod_reset->labelcolor(FONT_COLOR);
                    rbt->mod_label->redraw();
                }
            }
        }
        for (int x = 0; x < main_win->mod_tabs->children(); x++)
        {
            UI_CustomMods *M = (UI_CustomMods *)main_win->mod_tabs->child(x);
            M->labelcolor(FONT_COLOR);
        }
        main_win->redraw();
    }

    static void callback_Text2Color(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;
        if (!skip_color_picker)
        {
            if (fl_color_chooser((const char *)_("Select Button Text Color"), text2_red, text2_green, text2_blue, 1))
            {
                that->opt_text2_color->color(fl_rgb_color(text2_red, text2_green, text2_blue));
                that->opt_text2_color->redraw();
            }
        }
        if (color_scheme == 0)
        {
            FONT2_COLOR = fl_rgb_color(225, 225, 225);
            that->opt_text2_color->color(FONT2_COLOR);
            that->opt_text2_color->redraw();
        }
        else
        {
            FONT2_COLOR = fl_rgb_color(text2_red, text2_green, text2_blue);
        }
        main_win->game_box->engine->textcolor(FONT2_COLOR);
        main_win->game_box->game->textcolor(FONT2_COLOR);
        main_win->game_box->port->textcolor(FONT2_COLOR);
        main_win->game_box->length->textcolor(FONT2_COLOR);
        main_win->game_box->theme->textcolor(FONT2_COLOR);
        main_win->game_box->build->labelcolor(FONT2_COLOR);
        main_win->game_box->quit->labelcolor(FONT2_COLOR);
        for (int x = 0; x < main_win->game_box->children(); x++)
        {
            main_win->game_box->child(x)->redraw();
            main_win->game_box->child(x)->redraw_label();
        }
        for (int t = 0; t < main_win->mod_tabs->children(); t++)
        {
            UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
            for (int x = 0; x < tab->mod_pack->children(); x++)
            {
                UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                SYS_ASSERT(M);
                std::map<std::string, UI_RChoice *>::const_iterator IT;
                for (IT = M->choice_map.begin(); IT != M->choice_map.end(); IT++)
                {
                    UI_RChoice *rch = IT->second;
                    rch->mod_menu->textcolor(FONT2_COLOR);
                    rch->mod_label->redraw();
                    rch->mod_label->redraw_label();
                }
                std::map<std::string, UI_RSlide *>::const_iterator IT2;
                for (IT2 = M->choice_map_slider.begin(); IT2 != M->choice_map_slider.end(); IT2++)
                {
                    UI_RSlide *rsl = IT2->second;
                    rsl->unit_label->labelcolor(FONT2_COLOR);
                    rsl->unit_label->redraw();
                    rsl->unit_label->redraw_label();
                }
            }
        }
    }

    static void callback_BgColor(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;
        if (!skip_color_picker)
        {
            if (fl_color_chooser((const char *)_("Select Panel Color"), bg_red, bg_green, bg_blue, 1))
            {
                that->opt_bg_color->color(fl_rgb_color(bg_red, bg_green, bg_blue));
                that->opt_bg_color->redraw();
            }
        }
        if (color_scheme == 0)
        {
            WINDOW_BG = fl_rgb_color(56, 56, 56);
            Fl::background(56, 56, 56);
            Fl::background2(56, 56, 56);
            that->opt_bg_color->color(WINDOW_BG);
            that->opt_bg_color->redraw();
        }
        else
        {
            WINDOW_BG = fl_rgb_color(bg_red, bg_green, bg_blue);
            Fl::background(bg_red, bg_green, bg_blue);
            Fl::background2(bg_red, bg_green, bg_blue);
        }
        main_win->menu_bar->color(WINDOW_BG);
        main_win->menu_bar->redraw();
        main_win->game_box->color(WINDOW_BG);
        main_win->game_box->redraw();
        main_win->build_box->color(WINDOW_BG);
        main_win->build_box->redraw();
        for (int t = 0; t < main_win->mod_tabs->children(); t++)
        {
            UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
            for (int x = 0; x < tab->mod_pack->children(); x++)
            {
                UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                SYS_ASSERT(M);
                M->color(WINDOW_BG);
                M->redraw();
                std::map<std::string, UI_RSlide *>::const_iterator IT;
                for (IT = M->choice_map_slider.begin(); IT != M->choice_map_slider.end(); IT++)
                {
                    UI_RSlide *rsl = IT->second;
                    if (rsl->nan_choices.size() > 0)
                    {
                        rsl->nan_options->color(WINDOW_BG);
                    }
                    rsl->redraw();
                }
            }
        }
        main_win->mod_tabs->color(GAP_COLOR, WINDOW_BG);
        main_win->mod_tabs->redraw();
    }

    static void callback_Bg2Color(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;
        if (!skip_color_picker)
        {
            if (fl_color_chooser((const char *)_("Select Highlight Color"), bg2_red, bg2_green, bg2_blue, 1))
            {
                that->opt_bg2_color->color(fl_rgb_color(bg2_red, bg2_green, bg2_blue));
                that->opt_bg2_color->redraw();
            }
        }
        if (color_scheme == 0)
        {
            SELECTION = fl_rgb_color(83, 121, 180);
            that->opt_bg2_color->color(SELECTION);
            that->opt_bg2_color->redraw();
        }
        else
        {
            SELECTION = fl_rgb_color(bg2_red, bg2_green, bg2_blue);
        }
        main_win->color(GAP_COLOR, SELECTION);
        main_win->menu_bar->selection_color(SELECTION);
        main_win->redraw();
        main_win->game_box->engine->selection_color(SELECTION);
        main_win->game_box->game->selection_color(SELECTION);
        main_win->game_box->port->selection_color(SELECTION);
        main_win->game_box->length->selection_color(SELECTION);
        main_win->game_box->theme->selection_color(SELECTION);
        for (int x = 0; x < main_win->game_box->children(); x++)
        {
            main_win->game_box->child(x)->redraw();
        }
        for (int t = 0; t < main_win->mod_tabs->children(); t++)
        {
            UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
            tab->sbar->labelcolor(SELECTION);
            tab->redraw();
            for (int x = 0; x < tab->mod_pack->children(); x++)
            {
                UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                SYS_ASSERT(M);
                M->mod_button->selection_color(SELECTION);
                M->redraw();
                std::map<std::string, UI_RSlide *>::const_iterator  IT;
                std::map<std::string, UI_RButton *>::const_iterator IT2;
                for (IT = M->choice_map_slider.begin(); IT != M->choice_map_slider.end(); IT++)
                {
                    UI_RSlide *rsl = IT->second;
                    rsl->prev_button->labelcolor(SELECTION);
                    rsl->mod_slider->selection_color(SELECTION);
                    rsl->next_button->labelcolor(SELECTION);
                    if (rsl->nan_choices.size() > 0)
                    {
                        rsl->nan_options->selection_color(SELECTION);
                    }
                    rsl->redraw();
                }
                for (IT2 = M->choice_map_button.begin(); IT2 != M->choice_map_button.end(); IT2++)
                {
                    UI_RButton *rbt = IT2->second;
                    rbt->mod_check->selection_color(SELECTION);
                    rbt->redraw();
                }
            }
        }
    }

    static void callback_ButtonColor(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;
        if (!skip_color_picker)
        {
            if (fl_color_chooser((const char *)_("Select Button Color"), button_red, button_green, button_blue, 1))
            {
                that->opt_button_color->color(fl_rgb_color(button_red, button_green, button_blue));
                that->opt_button_color->redraw();
            }
        }
        if (color_scheme == 0)
        {
            BUTTON_COLOR = fl_rgb_color(89, 89, 89);
            that->opt_button_color->color(BUTTON_COLOR);
            that->opt_button_color->redraw();
        }
        else
        {
            BUTTON_COLOR = fl_rgb_color(button_red, button_green, button_blue);
        }
        main_win->game_box->build->color(BUTTON_COLOR);
        main_win->game_box->quit->color(BUTTON_COLOR);
        for (int x = 0; x < main_win->game_box->children(); x++)
        {
            main_win->game_box->child(x)->redraw();
        }
        main_win->mod_tabs->color(BUTTON_COLOR, WINDOW_BG);
        main_win->mod_tabs->redraw();
        for (int t = 0; t < main_win->mod_tabs->children(); t++)
        {
            UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
            tab->sbar->color(GAP_COLOR, BUTTON_COLOR);
            for (int x = 0; x < tab->mod_pack->children(); x++)
            {
                UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                SYS_ASSERT(M);
                std::map<std::string, UI_RSlide *>::const_iterator IT;
                for (IT = M->choice_map_slider.begin(); IT != M->choice_map_slider.end(); IT++)
                {
                    UI_RSlide *rsl = IT->second;
                    rsl->prev_button->color(BUTTON_COLOR);
                    rsl->mod_slider->color(BUTTON_COLOR);
                    rsl->next_button->color(BUTTON_COLOR);
                    rsl->prev_button->redraw();
                    rsl->mod_slider->redraw();
                    rsl->prev_button->redraw();
                }
            }
        }
    }

    static void callback_GradientColor(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;
        if (!skip_color_picker)
        {
            if (fl_color_chooser((const char *)_("Select Gradient Color"), gradient_red, gradient_green, gradient_blue,
                                 1))
            {
                that->opt_gradient_color->color(fl_rgb_color(gradient_red, gradient_green, gradient_blue));
                that->opt_gradient_color->redraw();
            }
        }
        if (color_scheme == 0)
        {
            GRADIENT_COLOR = fl_rgb_color(221, 221, 221);
            that->opt_gradient_color->color(GRADIENT_COLOR);
            that->opt_gradient_color->redraw();
        }
        else
        {
            GRADIENT_COLOR = fl_rgb_color(gradient_red, gradient_green, gradient_blue);
        }
        main_win->redraw();
        main_win->game_box->redraw();
        main_win->build_box->redraw();
        for (int t = 0; t < main_win->mod_tabs->children(); t++)
        {
            UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
            for (int x = 0; x < tab->mod_pack->children(); x++)
            {
                UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                SYS_ASSERT(M);
                M->redraw();
            }
        }
    }

    static void callback_BorderColor(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;
        if (!skip_color_picker)
        {
            if (fl_color_chooser((const char *)_("Select Border Color"), border_red, border_green, border_blue, 1))
            {
                that->opt_border_color->color(fl_rgb_color(border_red, border_green, border_blue));
                that->opt_border_color->redraw();
            }
        }
        if (color_scheme == 0)
        {
            BORDER_COLOR = fl_rgb_color(62, 61, 57);
            that->opt_border_color->color(BORDER_COLOR);
            that->opt_border_color->redraw();
        }
        else
        {
            BORDER_COLOR = fl_rgb_color(border_red, border_green, border_blue);
        }
        main_win->redraw();
        main_win->game_box->redraw();
        main_win->build_box->redraw();
        for (int t = 0; t < main_win->mod_tabs->children(); t++)
        {
            UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(t);
            for (int x = 0; x < tab->mod_pack->children(); x++)
            {
                UI_Module *M = (UI_Module *)tab->mod_pack->child(x);
                SYS_ASSERT(M);
                M->redraw();
            }
        }
    }

    static void callback_GapColor(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;
        if (!skip_color_picker)
        {
            if (fl_color_chooser((const char *)_("Select Gap Color"), gap_red, gap_green, gap_blue, 1))
            {
                that->opt_gap_color->color(fl_rgb_color(gap_red, gap_green, gap_blue));
                that->opt_gap_color->redraw();
            }
        }
        if (color_scheme == 0)
        {
            GAP_COLOR = fl_rgb_color(35, 35, 35);
            that->opt_gap_color->color(GAP_COLOR);
            that->opt_gap_color->redraw();
        }
        else
        {
            GAP_COLOR = fl_rgb_color(gap_red, gap_green, gap_blue);
        }
        main_win->color(GAP_COLOR, SELECTION);
        main_win->redraw();
        main_win->build_box->progress->color(GAP_COLOR, GAP_COLOR);
        main_win->build_box->redraw();
    }

    static void callback_LoadDefaults(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;

        window_scaling = 0;
        font_scaling   = 18;
        font_theme     = 0;
        widget_theme   = 0;
        box_theme      = 0;
        button_theme   = 0;
        color_scheme   = 0;
        text_red       = 225;
        text_green     = 225;
        text_blue      = 225;
        text2_red      = 225;
        text2_green    = 225;
        text2_blue     = 225;
        bg_red         = 56;
        bg_green       = 56;
        bg_blue        = 56;
        bg2_red        = 83;
        bg2_green      = 121;
        bg2_blue       = 180;
        button_red     = 89;
        button_green   = 89;
        button_blue    = 89;
        gradient_red   = 221;
        gradient_green = 221;
        gradient_blue  = 221;
        border_red     = 62;
        border_green   = 61;
        border_blue    = 57;
        gap_red        = 35;
        gap_green      = 35;
        gap_blue       = 35;

        fl_alert("%s", _("Defaults loaded.\nOBSIDIAN will now restart."));
        main_action     = MAIN_HARD_RESTART;
        that->want_quit = true;
    }

    static void callback_LoadTheme(Fl_Widget *w, void *data)
    {
        UI_ThemeWin *that = (UI_ThemeWin *)data;

        std::string theme_file = Theme_AskLoadFilename();
        if (!theme_file.empty())
        {
            Theme_Options_Load(theme_file);
            // clang-format off
            fl_alert("%s", _("Theme loading requires a restart.\nOBSIDIAN will now restart."));
            // clang-format on

            main_action = MAIN_HARD_RESTART;

            that->want_quit = true;
        }
    }

    static void callback_SaveTheme(Fl_Widget *w, void *data)
    {
        std::string new_theme_file = Theme_OutputFilename();
        if (!new_theme_file.empty())
        {
            Theme_Options_Save(new_theme_file);
        }
    }
};

//
// Constructor
//
UI_ThemeWin::UI_ThemeWin(int W, int H, const char *label) : Fl_Window(W, H, label), want_quit(false)
{
    // non-resizable
    size_range(W, H, W, H);

    callback(callback_Quit, this);

    box(FL_FLAT_BOX);

    int y_step = KromulentHeight(9);
    int pad    = KromulentWidth(6);

    int cx = x() + KromulentWidth(24);
    int cy = y() + (y_step * 2);

    int listwidth = KromulentWidth(160); // [McM]: Some font names was shown truncated.

    Fl_Box *heading;

    opt_window_scaling = new UI_CustomMenu(cx + W * .38, cy, listwidth, KromulentHeight(24), "");
    opt_window_scaling->copy_label(_("Window Scaling: "));
    opt_window_scaling->align(FL_ALIGN_LEFT);
    opt_window_scaling->add(_("AUTO|Tiny|Small|Medium|Large|Huge"));
    opt_window_scaling->callback(callback_WindowScaling, this);
    opt_window_scaling->value(window_scaling);
    opt_window_scaling->labelfont(font_style);
    opt_window_scaling->textfont(font_style);
    opt_window_scaling->textcolor(FONT2_COLOR);
    opt_window_scaling->selection_color(SELECTION);

    cy += opt_window_scaling->h() + y_step;

    opt_font_scaling = new Fl_Simple_Counter(cx + W * .38, cy, listwidth, KromulentHeight(24), "");
    opt_font_scaling->copy_label(_("Font Size: "));
    opt_font_scaling->align(FL_ALIGN_LEFT);
    opt_font_scaling->step(2);
    opt_font_scaling->bounds(6, 100);
    opt_font_scaling->callback(callback_FontScaling, this);
    opt_font_scaling->value(font_scaling);
    opt_font_scaling->labelfont(font_style);
    opt_font_scaling->textfont(font_style);
    opt_font_scaling->textcolor(FONT2_COLOR);
    opt_font_scaling->selection_color(SELECTION);
    opt_font_scaling->visible_focus(0);
    opt_font_scaling->color(BUTTON_COLOR);

    cy += opt_font_scaling->h() + y_step;

    opt_font_theme = new UI_CustomMenu(cx + W * .38, cy, listwidth, KromulentHeight(24), "");
    opt_font_theme->copy_label(_("Font: "));
    opt_font_theme->align(FL_ALIGN_LEFT);
    opt_font_theme->callback(callback_FontTheme, this);
    opt_font_theme->value(font_theme);
    opt_font_theme->labelfont(font_style);
    opt_font_theme->textfont(font_style); // Change this to 0 to set a safe fallback instead
    opt_font_theme->textcolor(FONT2_COLOR);
    opt_font_theme->selection_color(SELECTION);

    PopulateFonts();

    cy += opt_font_theme->h() + y_step;

    opt_widget_theme = new UI_CustomMenu(cx + W * .38, cy, listwidth, KromulentHeight(24), "");
    opt_widget_theme->copy_label(_("Widget Theme: "));
    opt_widget_theme->align(FL_ALIGN_LEFT);
#if FL_MINOR_VERSION > 3
    opt_widget_theme->add(_("Default|Gleam|Win95|Plastic|Oxy"));
#else
    opt_widget_theme->add(_("Default|Gleam|Win95|Plastic"));
#endif
    opt_widget_theme->callback(callback_WidgetTheme, this);
    opt_widget_theme->value(widget_theme);
    opt_widget_theme->labelfont(font_style);
    opt_widget_theme->textfont(font_style);
    opt_widget_theme->textcolor(FONT2_COLOR);
    opt_widget_theme->selection_color(SELECTION);

    cy += opt_widget_theme->h() + y_step;

    opt_box_theme = new UI_CustomMenu(cx + W * .38, cy, listwidth, KromulentHeight(24), "");
    opt_box_theme->copy_label(_("Box Theme: "));
    opt_box_theme->align(FL_ALIGN_LEFT);
    opt_box_theme->add(_("Default|Shadow|Embossed|Engraved|Inverted|Raised"));
    opt_box_theme->callback(callback_BoxTheme, this);
    opt_box_theme->value(box_theme);
    opt_box_theme->labelfont(font_style);
    opt_box_theme->textfont(font_style);
    opt_box_theme->textcolor(FONT2_COLOR);
    opt_box_theme->selection_color(SELECTION);

    cy += opt_box_theme->h() + y_step;

    opt_button_theme = new UI_CustomMenu(cx + W * .38, cy, listwidth, KromulentHeight(24), "");
    opt_button_theme->copy_label(_("Button Theme: "));
    opt_button_theme->align(FL_ALIGN_LEFT);
    opt_button_theme->add(_("Default|Raised|Engraved|Embossed|Flat"));
    opt_button_theme->callback(callback_ButtonTheme, this);
    opt_button_theme->value(button_theme);
    opt_button_theme->labelfont(font_style);
    opt_button_theme->textfont(font_style);
    opt_button_theme->textcolor(FONT2_COLOR);
    opt_button_theme->selection_color(SELECTION);

    cy += opt_button_theme->h() + y_step;

    opt_color_scheme = new UI_CustomMenu(cx + W * .38, cy, listwidth, KromulentHeight(24), "");
    opt_color_scheme->copy_label(_("Color Scheme: "));
    opt_color_scheme->align(FL_ALIGN_LEFT);
    opt_color_scheme->add(_("Default|Custom"));
    opt_color_scheme->callback(callback_ColorScheme, this);
    opt_color_scheme->value(color_scheme);
    opt_color_scheme->labelfont(font_style);
    opt_color_scheme->textfont(font_style);
    opt_color_scheme->textcolor(FONT2_COLOR);
    opt_color_scheme->selection_color(SELECTION);

    cy += opt_color_scheme->h() + y_step;

    opt_text_color = new Fl_Button(cx + W * .05, cy, W * .15, KromulentHeight(24), _("Panel Font"));
    opt_text_color->visible_focus(0);
    opt_text_color->box(FL_BORDER_BOX);
    opt_text_color->color(fl_rgb_color(text_red, text_green, text_blue));
    opt_text_color->align(FL_ALIGN_BOTTOM);
    opt_text_color->callback(callback_TextColor, this);
    opt_text_color->labelfont(font_style);

    opt_text2_color = new Fl_Button(cx + W * .05 + opt_text_color->w() + (5 * pad), cy, W * .15, KromulentHeight(24),
                                    _("Button Font"));
    opt_text2_color->visible_focus(0);
    opt_text2_color->box(FL_BORDER_BOX);
    opt_text2_color->color(fl_rgb_color(text2_red, text2_green, text2_blue));
    opt_text2_color->align(FL_ALIGN_BOTTOM);
    opt_text2_color->callback(callback_Text2Color, this);
    opt_text2_color->labelfont(font_style);

    opt_bg_color = new Fl_Button(cx + W * .05 + (opt_text_color->w() + (5 * pad)) * 2, cy, W * .15, KromulentHeight(24),
                                 _("Panels"));
    opt_bg_color->visible_focus(0);
    opt_bg_color->box(FL_BORDER_BOX);
    opt_bg_color->color(fl_rgb_color(bg_red, bg_green, bg_blue));
    opt_bg_color->align(FL_ALIGN_BOTTOM);
    opt_bg_color->callback(callback_BgColor, this);
    opt_bg_color->labelfont(font_style);

    opt_bg2_color = new Fl_Button(cx + W * .05 + (opt_text_color->w() + (5 * pad)) * 3, cy, W * .15,
                                  KromulentHeight(24), _("Highlights"));
    opt_bg2_color->visible_focus(0);
    opt_bg2_color->box(FL_BORDER_BOX);
    opt_bg2_color->color(fl_rgb_color(bg2_red, bg2_green, bg2_blue));
    opt_bg2_color->align(FL_ALIGN_BOTTOM);
    opt_bg2_color->callback(callback_Bg2Color, this);
    opt_bg2_color->labelfont(font_style);

    cy += opt_text_color->h() + y_step * 3;

    opt_button_color = new Fl_Button(cx + W * .05, cy, W * .15, KromulentHeight(24), _("Buttons"));
    opt_button_color->visible_focus(0);
    opt_button_color->box(FL_BORDER_BOX);
    opt_button_color->color(fl_rgb_color(button_red, button_green, button_blue));
    opt_button_color->align(FL_ALIGN_BOTTOM);
    opt_button_color->callback(callback_ButtonColor, this);
    opt_button_color->labelfont(font_style);

    opt_gradient_color =
        new Fl_Button(cx + W * .05 + opt_text_color->w() + (5 * pad), cy, W * .15, KromulentHeight(24), _("Gradient"));
    opt_gradient_color->visible_focus(0);
    opt_gradient_color->box(FL_BORDER_BOX);
    opt_gradient_color->color(fl_rgb_color(gradient_red, gradient_green, gradient_blue));
    opt_gradient_color->align(FL_ALIGN_BOTTOM);
    opt_gradient_color->callback(callback_GradientColor, this);
    opt_gradient_color->labelfont(font_style);

    opt_border_color = new Fl_Button(cx + W * .05 + (opt_text_color->w() + (5 * pad)) * 2, cy, W * .15,
                                     KromulentHeight(24), _("Borders"));
    opt_border_color->visible_focus(0);
    opt_border_color->box(FL_BORDER_BOX);
    opt_border_color->color(fl_rgb_color(border_red, border_green, border_blue));
    opt_border_color->align(FL_ALIGN_BOTTOM);
    opt_border_color->callback(callback_BorderColor, this);
    opt_border_color->labelfont(font_style);

    opt_gap_color = new Fl_Button(cx + W * .05 + (opt_text_color->w() + (5 * pad)) * 3, cy, W * .15,
                                  KromulentHeight(24), _("Gaps"));
    opt_gap_color->visible_focus(0);
    opt_gap_color->box(FL_BORDER_BOX);
    opt_gap_color->color(fl_rgb_color(gap_red, gap_green, gap_blue));
    opt_gap_color->align(FL_ALIGN_BOTTOM);
    opt_gap_color->callback(callback_GapColor, this);
    opt_gap_color->labelfont(font_style);

    cy += opt_text_color->h() + y_step * 3;

    load_defaults = new Fl_Button(cx + W * .05, cy, W * .25, KromulentHeight(24), _("Load Defaults"));
    load_defaults->visible_focus(0);
    load_defaults->box(button_style);
    load_defaults->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    load_defaults->color(BUTTON_COLOR);
    load_defaults->callback(callback_LoadDefaults, this);
    load_defaults->labelfont(font_style);
    load_defaults->labelcolor(FONT2_COLOR);

    load_theme =
        new Fl_Button(cx + W * .05 + (load_defaults->w() + pad), cy, W * .25, KromulentHeight(24), _("Load Theme"));
    load_theme->visible_focus(0);
    load_theme->box(button_style);
    load_theme->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    load_theme->color(BUTTON_COLOR);
    load_theme->callback(callback_LoadTheme, this);
    load_theme->labelfont(font_style);
    load_theme->labelcolor(FONT2_COLOR);

    save_theme = new Fl_Button(cx + W * .05 + (load_defaults->w() + pad) + (load_theme->w() + pad), cy, W * .25,
                               KromulentHeight(24), _("Save Theme"));
    save_theme->visible_focus(0);
    save_theme->box(button_style);
    save_theme->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    save_theme->color(BUTTON_COLOR);
    save_theme->callback(callback_SaveTheme, this);
    save_theme->labelfont(font_style);
    save_theme->labelcolor(FONT2_COLOR);

    //----------------

    int dh = KromulentHeight(60);

    int bw = KromulentWidth(60);
    int bh = KromulentHeight(30);
    int bx = W - KromulentWidth(40) - bw;
    int by = H - dh / 2 - bh / 2;

    Fl_Group *darkish = new Fl_Group(0, H - dh, W, dh);
    darkish->box(FL_FLAT_BOX);
    {
        // finally add an "Close" button

        Fl_Button *button = new Fl_Button(bx, by, bw, bh, fl_close);
        button->box(button_style);
        button->visible_focus(0);
        button->color(BUTTON_COLOR);
        button->callback(callback_Quit, this);
        button->labelfont(font_style);
        button->labelcolor(FONT2_COLOR);
    }
    darkish->end();

    // restart needed warning
    heading = new Fl_Box(FL_NO_BOX, x() + pad - KromulentWidth(5), H - dh - KromulentHeight(3), W - pad * 2,
                         KromulentHeight(16), _("Note: Most settings will only affect tabs after a restart."));
    heading->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    heading->labelsize(small_font_size);
    heading->labelfont(font_style);

    end();

    resizable(NULL);
}

int UI_ThemeWin::handle(int event)
{
    if (event == FL_KEYDOWN || event == FL_SHORTCUT)
    {
        int key = Fl::event_key();

        switch (key)
        {
        case FL_Escape:
            want_quit = true;
            return 1;

        default:
            break;
        }

        // eat all other function keys
        if (FL_F + 1 <= key && key <= FL_F + 12)
        {
            return 1;
        }
    }

    return Fl_Window::handle(event);
}

void DLG_ThemeEditor(void)
{
    int theme_w = KromulentWidth(500);
    int theme_h = KromulentHeight(450);

    UI_ThemeWin *theme_window = new UI_ThemeWin(theme_w, theme_h, _("OBSIDIAN Theme Options"));

    theme_window->want_quit = false;
    theme_window->set_modal();
    theme_window->show();

    // run the GUI until the user closes
    while (!theme_window->WantQuit())
    {
        Fl::wait();
    }

    // save the options now
    Theme_Options_Save(theme_file);

    delete theme_window;

    main_win->redraw();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
