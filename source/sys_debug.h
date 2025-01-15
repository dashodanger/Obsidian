//------------------------------------------------------------------------
//  Debugging support
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

extern bool terminal;
extern bool debugging;

bool LogInit(const std::string &filename); // NULL for none
void LogClose(void);
bool RefInit(const std::string &filename); // NULL for none
void RefClose(void);

void LogEnableDebug(bool enable);
void LogEnableTerminal(bool enable);

#ifdef __GNUC__
void              LogPrint(const char *message, ...) __attribute__((format(printf, 1, 2)));
void              RefPrint(const char *message, ...) __attribute__((format(printf, 1, 2)));
void              DebugPrint(const char *message, ...) __attribute__((format(printf, 1, 2)));
void              ProgStatus(const char *message, ...) __attribute__((format(printf, 1, 2)));
[[noreturn]] void FatalError(const char *message, ...) __attribute__((format(printf, 1, 2)));
#else
void              LogPrint(const char *message, ...);
void              RefPrint(const char *message, ...);
void              DebugPrint(const char *message, ...);
void              ProgStatus(const char *message, ...);
[[noreturn]] void FatalError(const char *message, ...);
#endif

using log_display_func_t = void (*)(std::string_view line, void *priv_data);

void LogReadLines(log_display_func_t display_func, void *priv_data);

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
