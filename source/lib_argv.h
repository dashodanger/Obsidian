//------------------------------------------------------------------------
//  Argument library
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

#include <string>
#include <unordered_set>
#include <vector>

namespace argv
{

extern std::vector<std::string> list;
// for parsing disambiguation
extern std::unordered_set<char> short_flags;

void Init(int argc, const char *const *argv);

int  Find(char shortName, const char *longName, int *numParams = nullptr);
bool IsOption(int index);

} // namespace argv

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
