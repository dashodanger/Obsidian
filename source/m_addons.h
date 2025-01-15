//------------------------------------------------------------------------
//  Addons Loading and Selection GUI
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
#include <stdio.h>

#include <map>
#include <string>
#include <vector>

void VFS_InitAddons();
void VFS_ParseCommandLine();
void VFS_ScanForAddons();
void VFS_ScanForPresets();

void VFS_OptParse(const std::string &name);
void VFS_OptWrite(FILE *fp);

// util functions
uint8_t *VFS_LoadFile(const char *filename, int *length);
void     VFS_FreeFile(const uint8_t *mem);

typedef struct
{
    std::string name; // base filename, includes extension

    bool enabled;

} addon_info_t;

extern std::vector<addon_info_t> all_addons;

extern std::vector<std::string> all_presets;

extern std::map<std::string, int> initial_enabled_addons;

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
