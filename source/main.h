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
constexpr const char *LOG_FILENAME     = "LOGS.txt";
constexpr const char *REF_FILENAME     = "REFERENCE.txt";

extern std::string home_dir;
extern std::string install_dir;
extern std::string config_file;
extern std::string options_file;
extern std::string logging_file;
extern std::string reference_file;

extern std::string batch_output_file;

extern unsigned long long next_rand_seed;

// this records the user action, e.g. Cancel or Quit buttons
enum main_action_kind_e
{
    MAIN_NONE = 0,
    MAIN_BUILD,
    MAIN_CANCEL,
    MAIN_QUIT,
};

extern int main_action;

extern std::string ob_error_message;
extern float ob_build_progress;
extern std::string ob_build_step;

// Misc Options
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
#ifdef OBSIDIAN_ENABLE_GUI
extern bool        in_file_dialog;
extern std::string picker_filename;
#endif

extern std::string def_filename;

extern std::string              last_directory;
extern std::string              numeric_locale;
extern std::vector<std::string> batch_randomize_groups;

extern std::string default_output_path;

extern std::string Resolve_DefaultOutputPath();

extern std::string string_seed;
extern std::string selected_lang;

namespace Main
{

void Shutdown(bool error);
bool BackupFile(const std::string &filename);

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
