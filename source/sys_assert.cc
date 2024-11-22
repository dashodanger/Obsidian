//----------------------------------------------------------------------------
//  Assertions
//----------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
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
//----------------------------------------------------------------------------

#include "main.h"
#include "sys_macro.h"

#include <stdarg.h>

//----------------------------------------------------------------------------

void AssertFail(const char *msg, ...)
{
    static char buffer[OBSIDIAN_MSG_BUF_LEN];

    va_list argptr;

    va_start(argptr, msg);
    vsnprintf(buffer, OBSIDIAN_MSG_BUF_LEN - 1, msg, argptr);
    va_end(argptr);

    buffer[OBSIDIAN_MSG_BUF_LEN - 2] = 0;

    FatalError("Sorry, an internal error occurred.\n%s", buffer);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
