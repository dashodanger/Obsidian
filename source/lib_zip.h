//------------------------------------------------------------------------
//  ARCHIVE Handling : ZIP files
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2009-2017 Andrew Apted
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

/* ZIP writing */

bool ZIPF_OpenWrite(const std::string &filename);
bool ZIPF_AddFile(const std::string &filename, std::string_view directory);
bool ZIPF_AddMem(const std::string &name, uint8_t *data, size_t length);
bool ZIPF_CloseWrite();

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
