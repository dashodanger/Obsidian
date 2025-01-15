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

#include "lib_argv.h"

#ifdef _WIN32
// clang-format off
#include <windows.h>
#include <processenv.h>
#include <shellapi.h>
// clang-format on
#endif

#include "lib_util.h"
#include "sys_assert.h"

std::vector<std::string> argv::list;
std::unordered_set<char> argv::short_flags;

static void Parse_LongArg(std::string_view arg)
{
    // long argument, e.g. --foo=bar

    // keep first hyphen
    std::string_view name = arg.substr(1);

    std::string_view value;

    if (auto pos = name.find('='); pos != std::string_view::npos)
    {
        value = name.substr(pos + 1);
        name  = name.substr(0, pos);
    }

    argv::list.emplace_back(name);
    if (!value.empty())
    {
        argv::list.emplace_back(value);
    }
}

static void Parse_ShortArgs(std::string_view arg)
{
    for (size_t i = 1; i < arg.size(); ++i)
    {
        char ch = arg[i];

        if (argv::short_flags.find(ch) != argv::short_flags.end())
        {
            // argument
            argv::list.emplace_back(std::string{"-"} + std::string{&ch, 1});
            std::string_view argument = arg.substr(i + 1);
            if (!argument.empty())
            {
                argv::list.emplace_back(argument);
            }
            // no more to parse
            break;
        }
        else
        {
            // no argument
            argv::list.emplace_back(std::string{"-"} + std::string{&ch, 1});
        }
    }
}

//
// ArgvInit
//
// Initialise argument list.  Do NOT include the program name
// (usually in argv[0]).  The strings (and array) are copied.
//
// NOTE: doesn't merge multiple uses of an option, hence
//       using ArgvFind() will only return the first usage.
//
#ifdef _WIN32
void argv::Init(const int argc, const char *const *argv)
{

    (void)argc;
    (void)argv;

    int       win_argc = 0;
    size_t    i;
    wchar_t **win_argv = CommandLineToArgvW(GetCommandLineW(), &win_argc);

    SYS_NULL_CHECK(win_argv);

    list.reserve(win_argc);
    SYS_ASSERT(argv::list.size() >= 0);

    std::vector<std::string> argv_block;

    for (i = 0; i < win_argc; i++)
    {
        SYS_NULL_CHECK(win_argv[i]);
        std::wstring arg = win_argv[i];
        argv_block.push_back(WStringToUTF8(arg));
    }

    LocalFree(win_argv);

    for (int i = 0; i < argv_block.size(); i++)
    {

        std::string_view cur = argv_block[i];

        // support GNU-style long and short options
        if (cur[0] == '-')
        {
            if (cur[1] == '-')
            {
                Parse_LongArg(cur);
            }
            else
            {
                Parse_ShortArgs(cur);
            }
        }
        else
        {
            list.emplace_back(cur);
        }

        // support DOS-style short options
        if (cur[0] == '/' && (IsAlphanumericASCII(cur[1]) || cur[1] == '?') && cur[2] == '\0')
        {
            list.emplace_back(std::string{"-"} + std::string{&cur[1], 1});
        }
    }
}
#else
void argv::Init(const int argc, const char *const *argv)
{
    list.reserve(argc);
    SYS_ASSERT(argv::list.size() >= 0);

    for (int i = 0; i < argc; i++)
    {
        SYS_NULL_CHECK(argv[i]);
        std::string_view cur = argv[i];

#ifdef __APPLE__
        // ignore MacOS X rubbish
        if (cur == "-psn")
        {
            continue;
        }
#endif

        // support GNU-style long and short options
        if (cur[0] == '-')
        {
            if (cur[1] == '-')
            {
                Parse_LongArg(cur);
            }
            else
            {
                Parse_ShortArgs(cur);
            }
        }
        else
        {
            list.emplace_back(cur);
        }

        // support DOS-style short options
        if (cur[0] == '/' && (IsAlphanumericASCII(cur[1]) || cur[1] == '?') && cur[2] == '\0')
        {
            list.emplace_back(std::string{"-"} + std::string{&cur[1], 1});
        }
    }
}
#endif

int argv::Find(const char shortName, const char *longName, int *numParams)
{
    SYS_ASSERT(shortName || longName);

    if (numParams)
    {
        *numParams = 0;
    }

    size_t p = 0;

    for (; p < list.size(); ++p)
    {
        if (!IsOption(p))
        {
            continue;
        }

        const std::string &str = list[p];

        if (shortName && (shortName == ToLowerASCII(str[1])) && str[2] == 0)
        {
            break;
        }

        if (longName && StringCompare(longName, std::string_view{&str[1], (str.size() - 1)}) == 0)
        {
            break;
        }
    }

    if (p == list.size())
    {
        // NOT FOUND
        return -1;
    }

    if (numParams)
    {
        size_t q = p + 1;

        while (q < list.size() && !IsOption(q))
        {
            ++q;
        }

        *numParams = q - p - 1;
    }

    return p;
}

bool argv::IsOption(const int index)
{
    return list[index][0] == '-';
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
