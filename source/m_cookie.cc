//----------------------------------------------------------------------
//  COOKIE : Save/Load user settings
//----------------------------------------------------------------------
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
//----------------------------------------------------------------------

#include "m_cookie.h"

#include <locale.h>
#include <string.h>

#include "lib_argv.h"
#include "lib_util.h"
#include "m_lua.h"
#include "main.h"
#include "sys_assert.h"

enum struct cookie_context_e
{
    Load,
    Save,
    Arguments
};

static cookie_context_e context;

static std::string active_module;

static bool keep_seed;

static void Cookie_SetValue(std::string name, const std::string &value)
{
    if (context == cookie_context_e::Load)
    {
        DebugPrint("CONFIG: Name: [%s] Value: [%s]\n", name.c_str(), value.c_str());
    }
    else if (context == cookie_context_e::Arguments)
    {
        DebugPrint("ARGUMENT: Name: [%s] Value: [%s]\n", name.c_str(), value.c_str());
    }

    // the new style module syntax
    if (name.front() == '@')
    {
        active_module = name.substr(1);
        name          = "self";
    }

    if (!active_module.empty())
    {
        ob_set_mod_option(active_module, name, value);
        ob_set_config(name, value);
        return;
    }

    // need special handling for the 'seed' value
    if (StringCompare(name, "seed") == 0)
    {
        // ignore seed when loading a config file
        // unless the -k / --keep option is given.

        if (context == cookie_context_e::Arguments || keep_seed)
        {
            size_t converted = 0;
            next_rand_seed = stoull(value, &converted);

            if (converted != value.size())
            {
                string_seed = value;
                ob_set_config("string_seed", value.c_str());
                next_rand_seed = StringHash64(string_seed);
            }
        }

        return;
    }

    ob_set_config(name, value);
}

static bool Cookie_ParseLine(std::string_view buf)
{
    if (buf.find('=') == std::string_view::npos)
    {
        // Skip blank lines, comments, etc
        return true;
    }

    while (!buf.empty() && IsSpaceASCII(buf.front()))
    {
        buf.remove_prefix(1);
    }

    if (buf.empty() || !(IsAlphaASCII(buf.front()) || buf.front() == '@'))
    {
        LogPrint("Weird config line: [%s]\n", std::string(buf).c_str());
        return false;
    }

    std::string_view::size_type pos = buf.find('=');

    // Shouldn't happen but still
    if (pos == std::string_view::npos)
    {
        LogPrint("Malformed config line: [%s]\n", std::string(buf).c_str());
        return false;
    }

    std::string name = std::string(buf.substr(0, pos));

    if (pos + 1 >= buf.size())
    {
        LogPrint("Value missing!\n");
        return false;
    }

    std::string value = std::string(buf.substr(pos + 1));

    while (!name.empty() && IsSpaceASCII(name.back()))
    {
        name.pop_back();
    }
    while (!value.empty() && IsSpaceASCII(value.front()))
    {
        value.erase(value.begin());
    }
    while (!value.empty() && IsSpaceASCII(value.back()))
    {
        value.pop_back();
    }
    if (name.empty() || value.empty())
    {
        LogPrint("Name or value missing!\n");
        return false;
    }

    Cookie_SetValue(name, value);
    return true;
}

//----------------------------------------------------------------------

bool Cookie_Load(const std::string &filename)
{
    context = cookie_context_e::Load;

    keep_seed = (argv::Find('k', "keep") >= 0);

    active_module.clear();

    setlocale(LC_NUMERIC, "C");

    FILE *cookie_fp = FileOpen(filename, "r");

    if (!cookie_fp)
    {
        return false;
    }

    LogPrint("Loading config file: %s\n", filename.c_str());

    int error_count = 0;

    std::string buffer;
    int         c = EOF;
    for (;;)
    {
        buffer.clear();
        while ((c = fgetc(cookie_fp)) != EOF)
        {
            if (c == '\n' || c == '\r')
                break;
            else
                buffer.push_back(c);
        }

        if (!Cookie_ParseLine(buffer))
        {
            error_count += 1;
        }

        if (feof(cookie_fp) || ferror(cookie_fp))
            break;
    }

    fclose(cookie_fp);

    if (error_count > 0)
    {
        LogPrint("DONE (found %d parse errors)\n\n", error_count);
    }
    else
    {
        LogPrint("DONE.\n\n");
    }

    setlocale(LC_NUMERIC, numeric_locale.c_str());
    return true;
}

bool Cookie_LoadString(std::string_view str, bool _keep_seed)
{
    context   = cookie_context_e::Load;
    keep_seed = _keep_seed;

    active_module.clear();

    LogPrint("Reading config data...\n");

    std::string_view::size_type oldpos = 0;
    std::string_view::size_type pos    = 0;
    while (pos != std::string::npos)
    {
        pos = str.find('\n', oldpos);
        if (pos != std::string_view::npos)
        {
            Cookie_ParseLine(str.substr(oldpos, pos - oldpos));
            oldpos = pos + 1;
        }
    }

    LogPrint("DONE.\n\n");
    return true;
}

bool Cookie_Save(const std::string &filename)
{
    context = cookie_context_e::Save;
    setlocale(LC_NUMERIC, "C");

    FILE *cookie_fp = FileOpen(filename, "w");

    if (!cookie_fp)
    {
        LogPrint("Error: unable to create file: %s\n(%s)\n\n", filename.c_str(), strerror(errno));
        return false;
    }

    LogPrint("Saving config file...\n");

    // header...
    fprintf(cookie_fp, "-- CONFIG FILE : OBSIDIAN %s \"%s\"\n", OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str());
    fprintf(cookie_fp, "-- Build %s\n", OBSIDIAN_VERSION);
    fprintf(cookie_fp, "-- Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n");
    fprintf(cookie_fp, "-- %s\n\n", OBSIDIAN_WEBSITE);

    // settings...
    std::vector<std::string> lines;

    ob_read_all_config(&lines, true /* need_full */);

    for (unsigned int i = 0; i < lines.size(); i++)
    {
        fprintf(cookie_fp, "%s\n", lines[i].c_str());
    }

    LogPrint("DONE.\n\n");

    fclose(cookie_fp);
    setlocale(LC_NUMERIC, numeric_locale.c_str());
    return true;
}

void Cookie_ParseArguments(void)
{
    context = cookie_context_e::Arguments;

    active_module.clear();

    for (int i = 0; i < argv::list.size(); i++)
    {
        const std::string &arg = argv::list[i];

        if (arg[0] == '-')
        {
            continue;
        }

        if (arg[0] == '{' || arg[0] == '}')
        {
            continue;
        }

        if (StringCompare(arg.c_str(), "@@") == 0)
        {
            active_module.clear();
            continue;
        }

        // support an isolated "=", like in: FOO = 3
        if (i + 2 < argv::list.size() && StringCompare(argv::list[i + 1].c_str(), "=") == 0 &&
            argv::list[i + 2][0] != '-')
        {
            Cookie_SetValue(arg, argv::list[i + 2]);
            i += 2;
            continue;
        }

        const char *eq_pos = strchr(arg.c_str(), '=');
        if (!eq_pos)
        {
            // allow module names to omit the (rather useless) value
            if (arg[0] == '@')
            {
                Cookie_SetValue(arg, "1");
            }

            continue;
        }

        // split argument into name/value pair
        int eq_offset = (eq_pos - arg.c_str());

        std::string name  = arg;
        const char *value = name.c_str() + eq_offset + 1;

        name[eq_offset] = 0;

        if (name[0] == 0 || value[0] == 0)
        {
            FatalError("Bad setting on command line: '%s'\n", arg.c_str());
        }

        Cookie_SetValue(name.c_str(), value);
    }
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab