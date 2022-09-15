//------------------------------------------------------------------------
//  Argument library
//------------------------------------------------------------------------
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
//------------------------------------------------------------------------

#include "lib_argv.h"

#include "headers.h"
#include "lib_util.h"

std::vector<std::string> argv::list;
std::unordered_set<char> argv::short_flags;

static void Parse_LongArg(std::string_view arg) {
    // long argument, e.g. --foo=bar

    // keep first hyphen
    std::string_view name = arg.substr(1);

    std::string_view value;

    if (auto pos = name.find('='); pos != std::string_view::npos) {
        value = name.substr(pos + 1);
        name = name.substr(0, pos);
    }

    argv::list.emplace_back(name);
    if (!value.empty()) {
        argv::list.emplace_back(value);
    }
}

template <typename It>
const char *IterToPtr(It it) {
    return &*it;
}

template <>
const char *IterToPtr(const char *it) {
    return it;
}

static void Parse_ShortArgs(std::string_view arg) {
    auto it = arg.begin() + 1;

    while (it != arg.end()) {
        char ch = *it++;

        if (argv::short_flags.find(ch) != argv::short_flags.end()) {
            // argument
            argv::list.emplace_back(std::string{"-"} + std::string{&ch, 1});
            std::string_view argument(IterToPtr(it),
                                      static_cast<std::size_t>(arg.end() - it));
            if (!argument.empty()) {
                argv::list.emplace_back(argument);
            }
            // no more to parse
            break;
        } else {
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
void argv::Init(const int argc, const char *const *argv) {
    list.reserve(argc);
    SYS_ASSERT(argv::list.size() >= 0);

    for (int i = 0; i < argc; i++) {
        SYS_NULL_CHECK(argv[i]);
        std::string_view cur = argv[i];

#ifdef __APPLE__
        // ignore MacOS X rubbish
        if (cur == "-psn") {
            continue;
        }
#endif

        // support GNU-style long and short options
        if (cur[0] == '-') {
            if (cur[1] == '-') {
                Parse_LongArg(cur);
            } else {
                Parse_ShortArgs(cur);
            }
        } else {
            list.emplace_back(cur);
        }

        // support DOS-style short options
        if (cur[0] == '/' && (isalnum(cur[1]) || cur[1] == '?') &&
            cur[2] == '\0') {
            list.emplace_back(std::string{"-"} + std::string{&cur[1], 1});
        }
    }
}

int argv::Find(const char shortName, const char *longName, int *numParams) {
    SYS_ASSERT(shortName || longName);

    if (numParams) {
        *numParams = 0;
    }

    size_t p = 0;

    for (; p < list.size(); ++p) {
        if (!IsOption(p)) {
            continue;
        }

        const std::string &str = list[p];

        if (shortName && (shortName == tolower(str[1])) && str[2] == 0) {
            break;
        }

        if (longName &&
            StringCaseCmp(longName,
                          std::string_view{&str[1], (str.size() - 1)}) == 0) {
            break;
        }
    }

    if (p == list.size()) {
        // NOT FOUND
        return -1;
    }

    if (numParams) {
        size_t q = p + 1;

        while (q < list.size() && !IsOption(q)) {
            ++q;
        }

        *numParams = q - p - 1;
    }

    return p;
}

bool argv::IsOption(const int index) { return list.at(index)[0] == '-'; }

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
