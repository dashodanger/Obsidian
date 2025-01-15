//------------------------------------------------------------------------
//  LUA interface
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

#include <stdint.h>

#include <string>
#include <vector>

void Script_Open();
void Script_Close();

constexpr uint8_t  MAX_COLOR_MAPS     = 9; // 1 to 9 (from Lua)
constexpr uint16_t MAX_COLORS_PER_MAP = 260;

typedef struct
{
    uint8_t colors[MAX_COLORS_PER_MAP];
    int     size;
} color_mapping_t;

extern color_mapping_t color_mappings[MAX_COLOR_MAPS];

// Wrappers which call Lua functions:

bool ob_set_config(const std::string &key, const std::string &value);
bool ob_set_mod_option(const std::string &module, const std::string &option, const std::string &value);

bool ob_read_all_config(std::vector<std::string> *lines, bool need_full);

std::string ob_get_param(const std::string &parameter);
bool        ob_mod_enabled(const std::string &module_name);
bool        ob_hexen_ceiling_check(int thing_id);
void        ob_invoke_hook(const std::string &hookname);
void        ob_print_reference();
void        ob_print_reference_json();

std::string ob_game_format();
std::string ob_default_filename();
std::string ob_random_advice();
std::string ob_get_random_words();
std::string ob_get_password();

bool ob_build_cool_shit();

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
