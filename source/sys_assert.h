//----------------------------------------------------------------------------
//  Assertions
//----------------------------------------------------------------------------
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
//----------------------------------------------------------------------------

#pragma once

// -------- the macros --------

#ifdef SYS_NDEBUG
#define SYS_ASSERT(cond) ((void)0)

#elif defined(__GNUC__)
#define SYS_ASSERT(cond)                                                                                               \
    ((cond) ? (void)0                                                                                                  \
            : AssertFail("Assertion (%s) failed\nIn function %s (%s:%d)\n", #cond, __func__, __FILE__, __LINE__))

#else
#define SYS_ASSERT(cond)                                                                                               \
    ((cond) ? (void)0 : AssertFail("Assertion (%s) failed\nIn file %s:%d\n", #cond, __FILE__, __LINE__))

#endif // NDEBUG

#ifdef SYS_NDEBUG
#define SYS_ASSERT_MSG(cond, arglist) ((void)0)
#else
#define SYS_ASSERT_MSG(cond, arglist) ((cond) ? (void)0 : AssertFail arglist)
#endif

#define SYS_NULL_CHECK(ptr)   SYS_ASSERT((ptr) != NULL)
#define SYS_ZERO_CHECK(value) SYS_ASSERT((value) != 0)

// -------- the support code --------

#ifdef __GNUC__
__attribute__((noreturn))
#endif
void AssertFail(const char *msg, ...);
// throw an assertion exception with the given message.

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
