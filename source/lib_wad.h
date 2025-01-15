//------------------------------------------------------------------------
//  ARCHIVE Handling - WAD files
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

/* WAD reading */

#include <stdint.h>

#include <string>

bool WAD_OpenRead(const std::string &filename);
void WAD_CloseRead();

int         WAD_NumEntries();
int         WAD_FindEntry(const char *name);
int         WAD_EntryLen(int entry);
const char *WAD_EntryName(int entry);

bool WAD_ReadData(int entry, int offset, int length, void *buffer);

/* WAD writing */

bool WAD_OpenWrite(const std::string &filename);
void WAD_CloseWrite();

void WAD_NewLump(std::string_view name);
bool WAD_AppendData(const void *data, int length);
void WAD_FinishLump();

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
