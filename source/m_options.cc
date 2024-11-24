//----------------------------------------------------------------------
//  Options Editor
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

#include <string.h>

#include "lib_argv.h"
#include "lib_util.h"
#include "m_addons.h"
#include "m_cookie.h"
#include "m_lua.h"
#include "m_trans.h"
#include "main.h"
#include "sys_macro.h"

extern std::string BestDirectory();

void Parse_Option(const std::string &name, const std::string &value)
{
    if (StringCompare(name, "addon") == 0)
    {
        VFS_OptParse(value);
    }
    else if (StringCompare(name, "language") == 0)
    {
        t_language = value;
    }
    else if (StringCompare(name, "create_backups") == 0)
    {
        create_backups = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "overwrite_warning") == 0)
    {
        overwrite_warning = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "debug_messages") == 0)
    {
        debug_messages = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "limit_break") == 0)
    {
        limit_break = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "preserve_old_config") == 0)
    {
        preserve_old_config = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "randomize_architecture") == 0)
    {
        randomize_architecture = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "randomize_monsters") == 0)
    {
        randomize_monsters = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "randomize_pickups") == 0)
    {
        randomize_pickups = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "randomize_misc") == 0)
    {
        randomize_misc = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "random_string_seeds") == 0)
    {
        random_string_seeds = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "password_mode") == 0)
    {
        password_mode = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "mature_word_lists") == 0)
    {
        mature_word_lists = StringToInt(value) ? true : false;
    }
    else if (StringCompare(name, "filename_prefix") == 0)
    {
        filename_prefix = StringToInt(value);
    }
    else if (StringCompare(name, "custom_prefix") == 0)
    {
        custom_prefix = value;
    }
#ifndef OBSIDIAN_CONSOLE_ONLY
    else if (StringCompare(name, "collapse_disabled_modules") == 0)
    {
        collapse_disabled_modules = StringToInt(value) ? true : false;
    }
#endif
    else if (StringCompare(name, "default_output_path") == 0)
    {
        default_output_path = value;
    }
}

static bool Options_ParseLine(const std::string &buf)
{
    std::string::size_type pos = 0;

    pos = buf.find('=', 0);
    if (pos == std::string::npos)
    {
        // Skip blank lines, comments, etc
        return true;
    }

    if (!IsAlphaASCII(buf.front()))
    {
        return false;
    }

    std::string name  = buf.substr(0, pos - 1);
    std::string value = buf.substr(pos + 2);

    if (name.empty() || value.empty())
    {
        printf("%s\n", _("Name or value missing!"));
        return false;
    }

    Parse_Option(name, value);
    return true;
}

bool Options_Load(const std::string &filename)
{
    FILE *option_fp = FileOpen(filename, "r");

    if (!option_fp)
    {
        printf("%s\n\n", _("Missing Options file -- using defaults."));
        return false;
    }

    std::string buffer;
    int         c = EOF;
    for (;;)
    {
        buffer.clear();
        while ((c = fgetc(option_fp)) != EOF)
        {
            if (c == '\n' || c == '\r')
                break;
            else
                buffer.push_back(c);
        }

        Options_ParseLine(buffer);

        if (feof(option_fp) || ferror(option_fp))
            break;
    }

    fclose(option_fp);

    return true;
}

bool Options_Save(const std::string &filename)
{
    FILE *option_fp = FileOpen(filename, "w");

    if (!option_fp)
    {
        LogPrint("Error: unable to create file: %s\n(%s)\n\n", filename.c_str(), strerror(errno));
        return false;
    }

    LogPrint("Saving options file...\n");

    fprintf(option_fp, "-- OPTIONS FILE : OBSIDIAN %s \"%s\"\n", OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str());
    fprintf(option_fp, "-- Build %s\n", OBSIDIAN_VERSION);
    fprintf(option_fp, "-- Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n");
    fprintf(option_fp, "-- %s\n\n", OBSIDIAN_WEBSITE);

    fprintf(option_fp, "language = %s\n\n", t_language.c_str());

    fprintf(option_fp, "create_backups = %d\n", (create_backups ? 1 : 0));
    fprintf(option_fp, "overwrite_warning = %d\n", (overwrite_warning ? 1 : 0));
    fprintf(option_fp, "debug_messages = %d\n", (debug_messages ? 1 : 0));
    fprintf(option_fp, "limit_break = %d\n", (limit_break ? 1 : 0));
    fprintf(option_fp, "preserve_old_config = %d\n", (preserve_old_config ? 1 : 0));
    fprintf(option_fp, "randomize_architecture = %d\n", (randomize_architecture ? 1 : 0));
    fprintf(option_fp, "randomize_monsters = %d\n", (randomize_monsters ? 1 : 0));
    fprintf(option_fp, "randomize_pickups = %d\n", (randomize_pickups ? 1 : 0));
    fprintf(option_fp, "randomize_misc = %d\n", (randomize_misc ? 1 : 0));
    fprintf(option_fp, "random_string_seeds = %d\n", (random_string_seeds ? 1 : 0));
    fprintf(option_fp, "password_mode = %d\n", (password_mode ? 1 : 0));
    fprintf(option_fp, "mature_word_lists = %d\n", (mature_word_lists ? 1 : 0));
    fprintf(option_fp, "filename_prefix = %d\n", filename_prefix);
    fprintf(option_fp, "custom_prefix = %s\n", custom_prefix.c_str());
#ifndef OBSIDIAN_CONSOLE_ONLY
    fprintf(option_fp, "collapse_disabled_modules = %d\n", (collapse_disabled_modules ? 1 : 0));
#endif
    fprintf(option_fp, "%s", StringFormat("default_output_path = %s\n\n", default_output_path.c_str()).c_str());

    VFS_OptWrite(option_fp);

    fclose(option_fp);

    LogPrint("DONE.\n\n");

    return true;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
