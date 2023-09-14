//----------------------------------------------------------------------
//  Options Editor
//----------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
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

#ifndef CONSOLE_ONLY
#include "hdr_fltk.h"
#include "hdr_ui.h"
#endif
#include "headers.h"
#include "lib_argv.h"
#include "lib_util.h"
#include "m_addons.h"
#include "m_cookie.h"
#include "m_trans.h"
#include "m_lua.h"
#include "main.h"

extern std::filesystem::path BestDirectory();

void Parse_Option(const std::string &name, const std::string &value) {
    if (StringCaseCmpPartial(name, "recent") == 0) {
        Recent_Parse(name, value);
        return;
    }

    if (StringCaseCmp(name, "addon") == 0) {
        VFS_OptParse(value);
    } else if (StringCaseCmp(name, "language") == 0) {
        t_language = value;
    } else if (StringCaseCmp(name, "create_backups") == 0) {
        create_backups = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "overwrite_warning") == 0) {
        overwrite_warning = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "debug_messages") == 0) {
        debug_messages = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "limit_break") == 0) {
        limit_break = StringToInt(value) ? true : false;
        //} else if (StringCaseCmp(name, "preserve_failures") == 0) {
        // preserve_failures = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "preserve_old_config") == 0) {
        preserve_old_config = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_architecture") == 0) {
        randomize_architecture = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_monsters") == 0) {
        randomize_monsters = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_pickups") == 0) {
        randomize_pickups = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_misc") == 0) {
        randomize_misc = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "random_string_seeds") == 0) {
        random_string_seeds = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "password_mode") == 0) {
        password_mode = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "mature_word_lists") == 0) {
        mature_word_lists = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "filename_prefix") == 0) {
        filename_prefix = StringToInt(value);
    } else if (StringCaseCmp(name, "custom_prefix") == 0) {
        custom_prefix = value;
    } else if (StringCaseCmp(name, "default_output_path") == 0) {
        default_output_path = std::filesystem::u8path(value);
    } else if (StringCaseCmp(name, "builds_per_run") == 0) {
        builds_per_run = StringToInt(value);
    } else {
        StdOutPrintf("%s '%s'\n", _("Unknown option: "), name.c_str());
    }
}

static bool Options_ParseLine(std::string buf) {
    std::string::size_type pos = 0;

    pos = buf.find('=', 0);
    if (pos == std::string::npos) {
        // Skip blank lines, comments, etc
        return true;
    }

    // For options file, don't strip whitespace as it can cause issue with addon
    // paths that have whitespace - Dasho

    /*while (std::find(buf.begin(), buf.end(), ' ') != buf.end()) {
        buf.erase(std::find(buf.begin(), buf.end(), ' '));
    }*/

    if (!isalpha(buf.front())) {
        StdOutPrintf("%s [%s]\n", _("Weird option line: "), buf.c_str());
        return false;
    }

    // pos = buf.find('=', 0);  // Fix pos after whitespace deletion
    std::string name = buf.substr(0, pos - 1);
    std::string value = buf.substr(pos + 2);

    if (name.empty() || value.empty()) {
        StdOutPrintf(_("Name or value missing!\n"));
        return false;
    }

    Parse_Option(name, value);
    return true;
}

bool Options_Load(std::filesystem::path filename) {
    std::ifstream option_fp(filename, std::ios::in);

    if (!option_fp.is_open()) {
        StdOutPrintf(_("Missing Options file -- using defaults.\n\n"));
        return false;
    }

    for (std::string line; std::getline(option_fp, line);) {
        Options_ParseLine(line);
    }

    option_fp.close();

    return true;
}

bool Options_Save(std::filesystem::path filename) {
    std::ofstream option_fp(filename, std::ios::out);

    if (!option_fp.is_open()) {
        LogPrintf("Error: unable to create file: %s\n(%s)\n\n",
                  filename.u8string().c_str(), strerror(errno));
        return false;
    }

    if (main_action != MAIN_SOFT_RESTART) {
        LogPrintf("Saving options file...\n");
    }

    option_fp << "-- OPTIONS FILE : OBSIDIAN " << OBSIDIAN_SHORT_VERSION
              << " \"" << OBSIDIAN_CODE_NAME << "\"\n";
    option_fp << "-- Build " << OBSIDIAN_VERSION << "\n";
    option_fp << "-- Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n";
    option_fp << "-- " << OBSIDIAN_WEBSITE << "\n\n";

    option_fp << "language = " << t_language << "\n";
    option_fp << "\n";

    option_fp << "create_backups = " << (create_backups ? 1 : 0) << "\n";
    option_fp << "overwrite_warning = " << (overwrite_warning ? 1 : 0) << "\n";
    option_fp << "debug_messages = " << (debug_messages ? 1 : 0) << "\n";
    option_fp << "limit_break = " << (limit_break ? 1 : 0) << "\n";
    // option_fp << "preserve_failures = " << (preserve_failures ? 1 : 0) <<
    // "\n";
    option_fp << "preserve_old_config = " << (preserve_old_config ? 1 : 0)
              << "\n";
    option_fp << "randomize_architecture = " << (randomize_architecture ? 1 : 0)
              << "\n";
    option_fp << "randomize_monsters = " << (randomize_monsters ? 1 : 0)
              << "\n";
    option_fp << "randomize_pickups = " << (randomize_pickups ? 1 : 0) << "\n";
    option_fp << "randomize_misc = " << (randomize_misc ? 1 : 0) << "\n";
    option_fp << "random_string_seeds = " << (random_string_seeds ? 1 : 0)
              << "\n";
    option_fp << "password_mode = " << (password_mode ? 1 : 0) << "\n";
    option_fp << "mature_word_lists = " << (mature_word_lists ? 1 : 0) << "\n";
    option_fp << "filename_prefix = " << filename_prefix << "\n";
    option_fp << "custom_prefix = " << custom_prefix << "\n";
    std::string dop = StringFormat(
        "default_output_path = %s\n",
        StringToUTF8(default_output_path.generic_u16string()).c_str());
    option_fp.write(dop.c_str(), dop.size());
    option_fp << "builds_per_run = " << builds_per_run << "\n";

    option_fp << "\n";

    VFS_OptWrite(option_fp);

    Recent_Write(option_fp);

    option_fp.close();

    if (main_action != MAIN_SOFT_RESTART) {
        LogPrintf("DONE.\n\n");
    }

    return true;
}

//----------------------------------------------------------------------
#ifndef CONSOLE_ONLY
class UI_OptionsWin : public Fl_Window {
   public:
    bool want_quit;

   private:
    UI_CustomMenu *opt_language;
    UI_CustomMenu *opt_filename_prefix;

    Fl_Button *opt_custom_prefix;
    UI_HelpLink *custom_prefix_help;
    Fl_Button *opt_default_output_path;
    Fl_Box *opt_current_output_path;

    UI_CustomCheckBox *opt_random_string_seeds;
    UI_HelpLink *random_string_seeds_help;
    UI_CustomCheckBox *opt_password_mode;
    UI_HelpLink *password_mode_help;
    UI_CustomCheckBox *opt_mature_words;
    UI_HelpLink *mature_words_help;
    UI_CustomCheckBox *opt_backups;
    UI_CustomCheckBox *opt_overwrite;
    UI_CustomCheckBox *opt_debug;
    UI_CustomCheckBox *opt_limit_break;
    Fl_Simple_Counter *opt_builds_per_run;
    // UI_CustomCheckBox *opt_preserve_failures;

   public:
    UI_OptionsWin(int W, int H, const char *label = NULL);

    virtual ~UI_OptionsWin() {
        // nothing needed
    }

    bool WantQuit() const { return want_quit; }

   public:
    // FLTK virtual method for handling input events.
    int handle(int event);

    void PopulateLanguages() {
        opt_language->add(_("AUTO"));
        opt_language->value(0);

        for (int i = 0;; i++) {
            std::string fullname = Trans_GetAvailLanguage(i);

            if (fullname.empty()) {
                break;
            }

            opt_language->add(fullname.c_str());

            // check for match against current language
            std::string lc = Trans_GetAvailCode(i);

            if (lc == t_language) {
                opt_language->value(i + 1);
            }
        }
    }

   private:
    static void callback_Quit(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        that->want_quit = true;
    }

    static void callback_Language(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        int val = that->opt_language->value();

        if (val == 0) {
            t_language = "AUTO";
        } else {
            t_language = Trans_GetAvailCode(val - 1);

            // this should not happen
            if (t_language.empty()) {
                t_language = "AUTO";
            }
        }
        // clang-format off
        fl_alert("%s", _("Obsidian will now restart to apply language changes.\nObsidian will be in your selected language after restarting."));
        // clang-format on

        Trans_UnInit();

        main_action = MAIN_HARD_RESTART;

        that->want_quit = true;
    }

    static void callback_BuildsPerRun(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        builds_per_run = that->opt_builds_per_run->value();
    }

    static void callback_Random_String_Seeds(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        random_string_seeds =
            that->opt_random_string_seeds->value() ? true : false;

        if (!random_string_seeds) {
            that->opt_password_mode->deactivate();
        } else {
            that->opt_password_mode->activate();
        }
    }

    static void callback_RandomStringSeedsHelp(Fl_Widget *w, void *data) {
        fl_cursor(FL_CURSOR_DEFAULT);
        Fl_Window *win = new Fl_Window(640, 480, _("Random String Seeds"));
        Fl_Text_Buffer *buff = new Fl_Text_Buffer();
        Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
        disp->buffer(buff);
        disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
        win->resizable(*disp);
        win->hotspot(0, 0, 0);
        win->set_modal();
        win->show();
        // clang-format off
        buff->text(_("Will randomly pull 1 to 3 words from Obsidian's random word list and use those as input for the map generation seed. Purely for cosmetic/entertainment value."));
        // clang-format on
    }

    static void callback_Password_Mode(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        password_mode = that->opt_password_mode->value() ? true : false;
    }

    static void callback_PasswordModeHelp(Fl_Widget *w, void *data) {
        fl_cursor(FL_CURSOR_DEFAULT);
        Fl_Window *win = new Fl_Window(640, 480, _("Password Mode"));
        Fl_Text_Buffer *buff = new Fl_Text_Buffer();
        Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
        disp->buffer(buff);
        disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
        win->resizable(*disp);
        win->hotspot(0, 0, 0);
        win->set_modal();
        win->show();
        // clang-format off
        buff->text(_("Will produce a pseudo-random sequence of characters as input for the map generation seed. Random String Seeds must be enabled to use this option."));
        // clang-format on
    }

    static void callback_MatureWords(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        mature_word_lists = that->opt_mature_words->value() ? true : false;

        if (mature_word_lists) {
            ob_set_config("mature_words", "yes");
        } else {
            ob_set_config("mature_words", "no");
        }
    }

    static void callback_MatureWordsHelp(Fl_Widget *w, void *data) {
        fl_cursor(FL_CURSOR_DEFAULT);
        Fl_Window *win = new Fl_Window(640, 480, _("Mature Wordlists"));
        Fl_Text_Buffer *buff = new Fl_Text_Buffer();
        Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
        disp->buffer(buff);
        disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
        win->resizable(*disp);
        win->hotspot(0, 0, 0);
        win->set_modal();
        win->show();
        // clang-format off
        buff->text(_("When enabled, will use a random wordlist that can result in obscene or otherwise offensive language being used for seed, map and WAD title elements."));
        // clang-format on
    }

    static void callback_Backups(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        create_backups = that->opt_backups->value() ? true : false;
    }

    static void callback_Overwrite(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        overwrite_warning = that->opt_overwrite->value() ? true : false;
    }

    static void callback_Debug(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        debug_messages = that->opt_debug->value() ? true : false;
        LogEnableDebug(debug_messages);
    }

    static void callback_FilenamePrefix(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        filename_prefix = that->opt_filename_prefix->value();
        // clang-format off
        fl_alert("%s", _("File prefix changes require a restart.\nOBSIDIAN will now restart."));
        // clang-format on

        main_action = MAIN_HARD_RESTART;

        that->want_quit = true;
    }

    static void callback_LimitBreak(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;
        if (that->opt_limit_break->value()) {
            // clang-format off
            if (fl_choice("%s",
                        _("Cancel"),
                        _("Yes, break Obsidian"), 0,
                _("WARNING! This option will allow you to manually enter values in excess of the \n(usually) stable slider limits for Obsidian.\nAny bugs, crashes, or errors as a result of this will not be addressed by the developers.\nYou must select Yes for this option to be applied."))) {
                // clang-format on
                limit_break = true;
            } else {
                limit_break = false;
                that->opt_limit_break->value(0);
            }
        } else {
            limit_break = false;
            // clang-format off
            fl_alert("%s", _("Restoring slider limits requires a restart.\nObsidian will now restart."));
            // clang-format on

            main_action = MAIN_HARD_RESTART;

            that->want_quit = true;
        }
    }

    /*static void callback_PreserveFailures(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        preserve_failures = that->opt_preserve_failures->value() ? true : false;
    }*/

    static void callback_PrefixHelp(Fl_Widget *w, void *data) {
        fl_cursor(FL_CURSOR_DEFAULT);
        Fl_Window *win = new Fl_Window(640, 480, _("Custom Prefix"));
        Fl_Text_Buffer *buff = new Fl_Text_Buffer();
        Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
        disp->buffer(buff);
        disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
        win->resizable(*disp);
        win->hotspot(0, 0, 0);
        win->set_modal();
        win->show();
        // clang-format off
        buff->text(_("Custom prefixes can use any of the special format strings listed below. Anything else is used as-is.\n\n%year or %Y: The current year.\n\n%month or %M: The current month.\n\n%day or %D: The current day.\n\n%hour or %h: The current hour.\n\n%minute or %m: The current minute.\n\n%second or %s: The current second.\n\n%version or %v: The current Obsidian version.\n\n%game or %g: Which game the WAD is for.\n\n%port or %p: Which port the WAD is for.\n\n%theme or %t: Which theme was selected from the game's choices.\n\n%count or %c: The number of levels in the generated WAD."));
        // clang-format on
    }

    static void callback_SetCustomPrefix(Fl_Widget *w, void *data) {
    tryagain:
        const char *user_buf = fl_input("%s", custom_prefix.c_str(),
                                        _("Enter Custom Prefix Format:"));

        if (user_buf) {
            custom_prefix = user_buf;
            if (custom_prefix.empty()) {
                fl_alert("%s", _("Custom prefix cannot be blank!"));
                goto tryagain;
            }
        }
    }

    static void callback_SetDefaultOutputPath(Fl_Widget *w, void *data) {
        // save and restore the font height
        // (because FLTK's own browser get totally borked)
        int old_font_h = FL_NORMAL_SIZE;
        FL_NORMAL_SIZE = 14 + KF;

        Fl_Native_File_Chooser chooser;

        chooser.title(_("Select default save directory"));
        chooser.type(Fl_Native_File_Chooser::BROWSE_DIRECTORY);
        chooser.directory(BestDirectory().generic_u8string().c_str());

        int result = chooser.show();

        FL_NORMAL_SIZE = old_font_h;

        switch (result) {
            case -1:
                LogPrintf(_("Error choosing directory:\n"));
                LogPrintf("   %s\n", chooser.errmsg());

                return;

            case 1:  // cancelled
                return;

            default:
                break;  // OK
        }

        std::filesystem::path dir_name =
            std::filesystem::u8path(chooser.filename());

        if (dir_name.empty()) {
            LogPrintf(_("Empty default directory provided???:\n"));
            return;
        }

        default_output_path = dir_name;
        UI_OptionsWin *that = (UI_OptionsWin *)data;
        std::string blanker;
        blanker.append(250, ' ');
        that->opt_current_output_path->copy_label(blanker.c_str());
        that->opt_current_output_path->redraw_label();
        that->opt_current_output_path->copy_label(
            StringFormat("%s: %s", _("Current Path"),
                         BestDirectory().u8string().c_str())
                .c_str());
        that->opt_current_output_path->redraw_label();
    }
};

//
// Constructor
//
UI_OptionsWin::UI_OptionsWin(int W, int H, const char *label)
    : Fl_Window(W, H, label), want_quit(false) {
    // non-resizable
    size_range(W, H, W, H);

    callback(callback_Quit, this);

    box(FL_FLAT_BOX);

    int y_step = kf_h(9);
    int pad = kf_w(6);

    int cx = x() + kf_w(24);
    int cy = y() + (y_step * 3);

    int listwidth = kf_w(160);

    opt_language = new UI_CustomMenu(cx + W * .38, cy, listwidth, kf_h(24), "");
    opt_language->copy_label(_("Language: "));
    opt_language->align(FL_ALIGN_LEFT);
    opt_language->callback(callback_Language, this);
    opt_language->labelfont(font_style);
    opt_language->textcolor(FONT2_COLOR);
    opt_language->textfont(font_style);
    opt_language->selection_color(SELECTION);

    PopulateLanguages();

    cy += opt_language->h() + y_step;

    opt_filename_prefix =
        new UI_CustomMenu(cx + W * .38, cy, listwidth, kf_h(24), "");
    opt_filename_prefix->copy_label(_("Filename Prefix: "));
    opt_filename_prefix->align(FL_ALIGN_LEFT);
    opt_filename_prefix->callback(callback_FilenamePrefix, this);
    // clang-format off
    opt_filename_prefix->add(
        _("Date and Time|Number of Levels|Game|Port|Theme|Version|Custom|Nothing"));
    // clang-format on
    opt_filename_prefix->labelfont(font_style);
    opt_filename_prefix->textfont(font_style);
    opt_filename_prefix->textcolor(FONT2_COLOR);
    opt_filename_prefix->selection_color(SELECTION);
    opt_filename_prefix->value(filename_prefix);

    cy += opt_filename_prefix->h() + y_step;

    opt_custom_prefix = new Fl_Button(cx + W * .38, cy, listwidth, kf_h(24),
                                      _("Set Custom Prefix..."));
    opt_custom_prefix->box(button_style);
    opt_custom_prefix->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    opt_custom_prefix->visible_focus(0);
    opt_custom_prefix->color(BUTTON_COLOR);
    opt_custom_prefix->callback(callback_SetCustomPrefix, this);
    opt_custom_prefix->labelfont(font_style);
    opt_custom_prefix->labelcolor(FONT2_COLOR);

    custom_prefix_help = new UI_HelpLink(
        cx + W * .38 + this->opt_custom_prefix->w(), cy, W * 0.10, kf_h(24));
    custom_prefix_help->labelfont(font_style);
    custom_prefix_help->callback(callback_PrefixHelp, this);

    cy += opt_custom_prefix->h() + y_step;

    opt_default_output_path = new Fl_Button(
        cx + W * .38, cy, listwidth, kf_h(24), _("Set Default Output Path"));
    opt_default_output_path->box(button_style);
    opt_default_output_path->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    opt_default_output_path->visible_focus(0);
    opt_default_output_path->color(BUTTON_COLOR);
    opt_default_output_path->callback(callback_SetDefaultOutputPath, this);
    opt_default_output_path->labelfont(font_style);
    opt_default_output_path->labelcolor(FONT2_COLOR);

    cy += opt_default_output_path->h() + y_step;

    opt_current_output_path = new Fl_Box(cx, cy, W - cx - pad, kf_h(36), "");
    opt_current_output_path->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER |
                                   FL_ALIGN_WRAP);
    opt_current_output_path->visible_focus(0);
    opt_current_output_path->color(BUTTON_COLOR);
    opt_current_output_path->labelfont(font_style);
    opt_current_output_path->labelcolor(FONT2_COLOR);
    // clang-format off
    opt_current_output_path->copy_label(StringFormat("%s: %s", _("Current Path"), BestDirectory().u8string().c_str()).c_str());
    // clang-format on

    cy += opt_current_output_path->h() + y_step;

    opt_random_string_seeds =
        new UI_CustomCheckBox(cx + W * .38, cy, listwidth, kf_h(24), "");
    opt_random_string_seeds->copy_label(_(" Random String Seeds"));
    opt_random_string_seeds->value(random_string_seeds ? 1 : 0);
    opt_random_string_seeds->callback(callback_Random_String_Seeds, this);
    opt_random_string_seeds->labelfont(font_style);
    opt_random_string_seeds->selection_color(SELECTION);
    opt_random_string_seeds->down_box(button_style);

    random_string_seeds_help = new UI_HelpLink(
        cx + W * .38 + this->opt_custom_prefix->w(), cy, W * 0.10, kf_h(24));
    random_string_seeds_help->labelfont(font_style);
    random_string_seeds_help->callback(callback_RandomStringSeedsHelp, this);

    cy += opt_random_string_seeds->h() + y_step * .5;

    opt_password_mode =
        new UI_CustomCheckBox(cx + W * .38, cy, listwidth, kf_h(24), "");
    opt_password_mode->copy_label(_(" Password Mode"));
    opt_password_mode->value(password_mode ? 1 : 0);
    opt_password_mode->callback(callback_Password_Mode, this);
    opt_password_mode->labelfont(font_style);
    opt_password_mode->selection_color(SELECTION);
    opt_password_mode->down_box(button_style);
    if (!random_string_seeds) {
        opt_password_mode->deactivate();
    }

    password_mode_help = new UI_HelpLink(
        cx + W * .38 + this->opt_custom_prefix->w(), cy, W * 0.10, kf_h(24));
    password_mode_help->labelfont(font_style);
    password_mode_help->callback(callback_PasswordModeHelp, this);

    cy += opt_password_mode->h() + y_step * .5;

    opt_mature_words =
        new UI_CustomCheckBox(cx + W * .38, cy, listwidth, kf_h(24), "");
    opt_mature_words->copy_label(_(" Use Mature Wordlists"));
    opt_mature_words->value(mature_word_lists ? 1 : 0);
    opt_mature_words->callback(callback_MatureWords, this);
    opt_mature_words->labelfont(font_style);
    opt_mature_words->selection_color(SELECTION);
    opt_mature_words->down_box(button_style);

    mature_words_help = new UI_HelpLink(
        cx + W * .38 + this->opt_custom_prefix->w(), cy, W * 0.10, kf_h(24));
    mature_words_help->labelfont(font_style);
    mature_words_help->callback(callback_MatureWordsHelp, this);

    cy += opt_mature_words->h() + y_step * .5;

    opt_backups =
        new UI_CustomCheckBox(cx + W * .38, cy, listwidth, kf_h(24), "");
    opt_backups->copy_label(_(" Create Backups"));
    opt_backups->value(create_backups ? 1 : 0);
    opt_backups->callback(callback_Backups, this);
    opt_backups->labelfont(font_style);
    opt_backups->selection_color(SELECTION);
    opt_backups->down_box(button_style);

    cy += opt_backups->h() + y_step * .5;

    opt_overwrite =
        new UI_CustomCheckBox(cx + W * .38, cy, listwidth, kf_h(24), "");
    opt_overwrite->copy_label(_(" Overwrite File Warning"));
    opt_overwrite->value(overwrite_warning ? 1 : 0);
    opt_overwrite->callback(callback_Overwrite, this);
    opt_overwrite->labelfont(font_style);
    opt_overwrite->selection_color(SELECTION);
    opt_overwrite->down_box(button_style);

    cy += opt_overwrite->h() + y_step * .5;

    opt_debug =
        new UI_CustomCheckBox(cx + W * .38, cy, listwidth, kf_h(24), "");
    opt_debug->copy_label(_(" Debugging Messages"));
    opt_debug->value(debug_messages ? 1 : 0);
    opt_debug->callback(callback_Debug, this);
    opt_debug->labelfont(font_style);
    opt_debug->selection_color(SELECTION);
    opt_debug->down_box(button_style);

    cy += opt_debug->h() + y_step * .5;

    opt_limit_break =
        new UI_CustomCheckBox(cx + W * .38, cy, listwidth, kf_h(24), "");
    opt_limit_break->copy_label(_(" Ignore Slider Limits"));
    opt_limit_break->value(limit_break ? 1 : 0);
    opt_limit_break->callback(callback_LimitBreak, this);
    opt_limit_break->labelfont(font_style);
    opt_limit_break->selection_color(SELECTION);
    opt_limit_break->down_box(button_style);

    cy += opt_limit_break->h() + y_step * .5;

    opt_builds_per_run =
        new Fl_Simple_Counter(cx + W * .38, cy, listwidth, kf_h(24), "");
    opt_builds_per_run->copy_label(_("Builds Per Run "));
    opt_builds_per_run->align(FL_ALIGN_LEFT);
    opt_builds_per_run->step(1);
    opt_builds_per_run->bounds(1, 25);
    opt_builds_per_run->callback(callback_BuildsPerRun, this);
    opt_builds_per_run->value(builds_per_run);
    opt_builds_per_run->labelfont(font_style);
    opt_builds_per_run->textfont(font_style);
    opt_builds_per_run->textcolor(FONT2_COLOR);
    opt_builds_per_run->selection_color(SELECTION);
    opt_builds_per_run->visible_focus(0);
    opt_builds_per_run->color(BUTTON_COLOR);

    cy += opt_builds_per_run->h() + y_step * .5;

    /*opt_preserve_failures =
        new UI_CustomCheckBox(cx + W * .38, cy, listwidth, kf_h(24),, "");
    opt_preserve_failures->copy_label(_(" Preserve Failed Builds"));
    opt_preserve_failures->value(preserve_failures ? 1 : 0);
    opt_preserve_failures->callback(callback_PreserveFailures, this);
    opt_preserve_failures->labelfont(font_style);
    opt_preserve_failures->selection_color(SELECTION);
    opt_preserve_failures->down_box(button_style);

    cy += opt_preserve_failures->h() + y_step * .5;*/

    //----------------

    int dh = kf_h(60);

    int bw = kf_w(60);
    int bh = kf_h(30);
    int bx = W - kf_w(40) - bw;
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

    end();

    resizable(NULL);
}

int UI_OptionsWin::handle(int event) {
    if (event == FL_KEYDOWN || event == FL_SHORTCUT) {
        int key = Fl::event_key();

        switch (key) {
            case FL_Escape:
                want_quit = true;
                return 1;

            default:
                break;
        }

        // eat all other function keys
        if (FL_F + 1 <= key && key <= FL_F + 12) {
            return 1;
        }
    }

    return Fl_Window::handle(event);
}

void DLG_OptionsEditor(void) {
    int opt_w = kf_w(500);
    int opt_h = kf_h(475);

    UI_OptionsWin *option_window =
        new UI_OptionsWin(opt_w, opt_h, _("OBSIDIAN Misc Options"));

    option_window->want_quit = false;
    option_window->set_modal();
    option_window->show();

    // run the GUI until the user closes
    while (!option_window->WantQuit()) {
        Fl::wait();
    }

    // save the options now
    Options_Save(options_file.c_str());

    delete option_window;
}
#endif
//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
