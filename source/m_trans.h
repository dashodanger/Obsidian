//------------------------------------------------------------------------
//  TRANSLATION / INTERNATIONALIZATION
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2016-2017 Andrew Apted
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

#include <string>

// current selected language, default is "AUTO"
extern std::string t_language;

void Trans_Init();

void Trans_SetLanguage();

void Trans_UnInit();

// these are for the UI:
std::string Trans_GetAvailCode(int idx);
std::string Trans_GetAvailLanguage(int idx);

#define _(s) ob_gettext(s)

const char *ob_gettext(const char *s);

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
