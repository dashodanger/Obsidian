//------------------------------------------------------------------------
//  Main defines
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

#include <stddef.h>

#include <map>
#include <string>
#include <vector>

#ifndef OBSIDIAN_CONSOLE_ONLY
#include "ui_window.h"
#endif
#include "lib_util.h"
#include "sys_debug.h"

extern std::string OBSIDIAN_TITLE;

#ifdef OBSIDIAN_TIMESTAMP
constexpr const char *OBSIDIAN_VERSION = OBSIDIAN_TIMESTAMP;
#else
// Fallback in case the CMake timestamp stuff fails for some reason, but this
// shouldn't be used in practice
constexpr const char *OBSIDIAN_VERSION = __DATE__;
#endif

constexpr const char *OBSIDIAN_SHORT_VERSION = "21";
extern std::string    OBSIDIAN_CODE_NAME;

constexpr const char *OBSIDIAN_WEBSITE = "https://obsidian-level-maker.github.io";

constexpr const char *CONFIG_FILENAME  = "CONFIG.txt";
constexpr const char *OPTIONS_FILENAME = "OPTIONS.txt";
constexpr const char *THEME_FILENAME   = "THEME.txt";
constexpr const char *LOG_FILENAME     = "LOGS.txt";
constexpr const char *REF_FILENAME     = "REFERENCE.txt";

#if !defined OBSIDIAN_CONSOLE_ONLY && !defined __APPLE__
extern int v_unload_private_font(const char *path);
#endif

extern std::string home_dir;
extern std::string install_dir;
extern std::string config_file;
extern std::string options_file;
extern std::string theme_file;
extern std::string logging_file;
extern std::string reference_file;

extern bool batch_mode;

extern std::string batch_output_file;

extern unsigned long long next_rand_seed;

// this records the user action, e.g. Cancel or Quit buttons
enum main_action_kind_e
{
    MAIN_NONE = 0,
    MAIN_BUILD,
    MAIN_CANCEL,
    MAIN_QUIT,
    MAIN_HARD_RESTART,
    MAIN_SOFT_RESTART
};

extern int main_action;

// Misc Options
#ifndef OBSIDIAN_CONSOLE_ONLY
extern uchar                                    text_red;
extern uchar                                    text_green;
extern uchar                                    text_blue;
extern uchar                                    text2_red;
extern uchar                                    text2_green;
extern uchar                                    text2_blue;
extern uchar                                    bg_red;
extern uchar                                    bg_green;
extern uchar                                    bg_blue;
extern uchar                                    bg2_red;
extern uchar                                    bg2_green;
extern uchar                                    bg2_blue;
extern uchar                                    button_red;
extern uchar                                    button_green;
extern uchar                                    button_blue;
extern uchar                                    gradient_red;
extern uchar                                    gradient_green;
extern uchar                                    gradient_blue;
extern uchar                                    border_red;
extern uchar                                    border_green;
extern uchar                                    border_blue;
extern uchar                                    gap_red;
extern uchar                                    gap_green;
extern uchar                                    gap_blue;
extern Fl_Boxtype                               box_style;
extern Fl_Boxtype                               button_style;
extern Fl_Font                                  font_style;
extern Fl_Color                                 FONT_COLOR;
extern Fl_Color                                 FONT2_COLOR;
extern Fl_Color                                 WINDOW_BG;
extern Fl_Color                                 SELECTION;
extern Fl_Color                                 GAP_COLOR;
extern Fl_Color                                 GRADIENT_COLOR;
extern Fl_Color                                 BUTTON_COLOR;
extern Fl_Color                                 BORDER_COLOR;
extern int                                      color_scheme;
extern int                                      font_theme;
extern int                                      box_theme;
extern int                                      button_theme;
extern int                                      widget_theme;
extern int                                      window_scaling;
extern int                                      font_scaling;
extern int                                      num_fonts;
extern std::vector<std::pair<std::string, int>> font_menu_items;
#endif
extern int         filename_prefix;
extern std::string custom_prefix;
extern bool        create_backups;
extern bool        overwrite_warning;
extern bool        debug_messages;
extern bool        limit_break;
extern bool        preserve_failures;
extern bool        preserve_old_config;
extern bool        did_randomize;
extern bool        randomize_architecture;
extern bool        randomize_monsters;
extern bool        randomize_pickups;
extern bool        randomize_misc;
extern bool        random_string_seeds;
extern bool        password_mode;
extern bool        mature_word_lists;
extern bool        did_specify_seed;

extern std::string def_filename;

extern std::string              last_directory;
extern std::string              numeric_locale;
extern std::vector<std::string> batch_randomize_groups;

#ifndef OBSIDIAN_CONSOLE_ONLY
// Dialog Windows
void DLG_ShowError(const char *msg, ...);

std::string DLG_OutputFilename(const char *ext, const char *preset = nullptr);
#endif

extern std::string default_output_path;

extern std::string Resolve_DefaultOutputPath();

extern std::string string_seed;
extern std::string selected_lang;

// Clippy/program menu stuff
#ifndef OBSIDIAN_CONSOLE_ONLY
extern Fl_Pixmap *clippy;

void DLG_AboutText();
void DLG_OptionsEditor();
void DLG_ThemeEditor();

void DLG_EditSeed();
void DLG_ViewLogs();
void DLG_ViewGlossary();
void DLG_ManageConfig();
#endif

namespace Main
{

void Shutdown(bool error);
bool BackupFile(const std::string &filename);

#if defined _WIN32 && !defined OBSIDIAN_CONSOLE_ONLY
void Blinker();
#endif

#if !defined(OBSIDIAN_CONSOLE_ONLY) && !defined(__APPLE__)
bool LoadInternalFont(const char *fontpath, int fontnum, const char *fontname);
#endif

#ifndef OBSIDIAN_CONSOLE_ONLY
void SetupFLTK();
int  DetermineScaling();
void PopulateFontMap();
void Ticker();
#endif

} // namespace Main

class game_interface_c
{
    /* this is an abstract base class */

  public:
    game_interface_c() = default;

    virtual ~game_interface_c()                           = default;
    game_interface_c(const game_interface_c &)            = default;
    game_interface_c &operator=(const game_interface_c &) = default;
    game_interface_c(game_interface_c &&)                 = default;
    game_interface_c &operator=(game_interface_c &&)      = default;

    /*** MAIN ***/

    // this selects an output filename or directory and prepares
    // for building a set of levels.  Returns false if an error
    // occurs (or the user simply Cancel'd).
    //
    // when 'preset' parameter is not NULL, it is a filename to
    // use in the save dialog.
    virtual bool Start(const char *preset) = 0;

    // this is called after all levels are done.  The 'build_ok'
    // value is the result from the LUA script, and is false if
    // an error occurred or the user clicked Abort.
    //
    // For idTech 1 games this will run the AJBSP node builder.
    //
    // Returns false on error.  Note that Finish() is never
    // called if Start() fails.
    virtual bool Finish(bool build_ok) = 0;

    /*** CSG2 ***/

    // this will set things up in preparation for the next level
    // being built.  It is called after the CSG2 code sets itself
    // up and hence could alter some CSG2 parameters, other than
    // that there is lttle need to do anything here.
    virtual void BeginLevel() = 0;

    // called when all the brushes and entities have been added
    // but before the CSG2 performs a cleanup.  Typically the
    // game-specific code will call CSG_BSP() and convert
    // the result to the game-specific level format.
    virtual void EndLevel() = 0;

    // sets a certain property, especially "level_name" which is
    // required by most games (like DOOM and QUAKE).  Unknown
    // properties are ignored.  May be called during startup too.
    virtual void Property(std::string key, std::string value) = 0;

    virtual std::string Filename() = 0;

    virtual std::string ZIP_Filename() = 0;

    // likely only useful for Doom, but informs the program if it needs to package
    // each map in its own native format (WAD, etc)
    bool file_per_map = false;
};

extern game_interface_c *game_object;

/* interface for each game format */

game_interface_c *Doom_GameObject();
game_interface_c *Wolf_GameObject();

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
