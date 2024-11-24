//------------------------------------------------------------------------
//  COOKIE : Save/Load user settings
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

#include <stdio.h>

#include <string>

bool Cookie_Load(const std::string &filename);
bool Cookie_Save(const std::string &filename);

bool Cookie_LoadString(std::string_view str, bool _keep_seed);

void Cookie_ParseArguments(void);

/* option stuff */

void Parse_Option(const std::string &name, const std::string &value);
bool Options_Load(const std::string &filename);
bool Options_Save(const std::string &filename);

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
