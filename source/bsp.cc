//------------------------------------------------------------------------
//
//  AJ-BSP  Copyright (C) 2023-2025 The OBSIDIAN Team
//			Copyright (C) 2001-2022  Andrew Apted
//          Copyright (C) 1994-1998  Colin Reed
//          Copyright (C) 1997-1998  Lee Killough
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

#include "bsp.h"

#include <string.h>

#include "bsp_wad.h"
#include "g_doom.h"
#include "lib_util.h"
#include "raw_def.h"
#include "sys_debug.h"

namespace ajbsp
{

bool opt_backup  = false;
bool opt_help    = false;
bool opt_version = false;

int total_failed_files = 0;
int total_empty_files  = 0;
int total_built_maps   = 0;
int total_failed_maps  = 0;

struct map_range_t
{
    const char *low;
    const char *high;
};

std::vector<map_range_t> map_list;

// this is > 0 when ShowMap() is used and the current line
// has not been terminated with a new-line ('\n') character.
int hanging_pos;

void StopHanging()
{
    if (hanging_pos > 0)
    {
        hanging_pos = 0;

        printf("\n");
        fflush(stdout);
    }
}

//------------------------------------------------------------------------

bool CheckMapInRange(const map_range_t *range, const char *name)
{
    if (strlen(name) != strlen(range->low))
        return false;

    if (StringCompare(name, range->low) < 0)
        return false;

    if (StringCompare(name, range->high) > 0)
        return false;

    return true;
}

bool CheckMapInMaplist(int lev_idx)
{
    // when --map is not used, allow everything
    if (map_list.empty())
        return true;

    const char *name = ajbsp::GetLevelName(lev_idx);

    for (unsigned int i = 0; i < map_list.size(); i++)
        if (CheckMapInRange(&map_list[i], name))
            return true;

    return false;
}

build_result_e BuildFile(buildinfo_t *build_info)
{
    int num_levels = ajbsp::LevelsInWad();

    if (num_levels == 0)
    {
        LogPrint("  No levels in wad\n");
        total_empty_files += 1;
        return BUILD_OK;
    }

    int visited  = 0;
    int failures = 0;

    build_result_e res = BUILD_OK;

    // loop over each level in the wad
    for (int n = 0; n < num_levels; n++)
    {
        if (!CheckMapInMaplist(n))
            continue;

        visited += 1;

        Doom::Send_Prog_Nodes(visited, num_levels);

        res = ajbsp::BuildLevel(n);

        // handle a failed map (due to lump overflow)
        if (res == BUILD_LumpOverflow)
        {
            res = BUILD_OK;
            failures += 1;
            continue;
        }

        if (res != BUILD_OK)
            break;

        total_built_maps += 1;
    }

    StopHanging();

    if (res == BUILD_Cancelled)
        return res;

    if (visited == 0)
    {
        LogPrint("  No matching levels\n");
        total_empty_files += 1;
        return BUILD_OK;
    }

    LogPrint("\n");

    total_failed_maps += failures;

    if (failures > 0)
    {
        LogPrint("  Failed maps: %d (out of %d)\n", failures, visited);

        // allow building other files
        total_failed_files += 1;
    }

    return BUILD_OK;
}

static void VisitFile(const std::string &filename, buildinfo_t *build_info)
{
    LogPrint("\n");
    LogPrint("Building %s\n", filename.c_str());

    // this will fatal error if it fails
    ajbsp::OpenWad(filename);

    build_result_e res = BuildFile(build_info);

    ajbsp::CloseWad();

    if (res == BUILD_Cancelled)
        FatalError("CANCELLED\n");
}

// ----- user information -----------------------------

void ShowBanner()
{
    printf("+-----------------------------------------------+\n");
    printf("|   AJBSP %s   (C) 2022 Andrew Apted, et al   |\n", AJBSP_VERSION);
    printf("+-----------------------------------------------+\n");

    fflush(stdout);
}

bool ValidateMapName(char *name)
{
    if (strlen(name) < 2 || strlen(name) > 8)
        return false;

    if (!isalpha(name[0]))
        return false;

    for (const char *p = name; *p; p++)
    {
        if (!(isalnum(*p) || *p == '_'))
            return false;
    }

    // Ok, convert to upper case
    for (char *s = name; *s; s++)
    {
        *s = ToUpperASCII(*s);
    }

    return true;
}

void ParseMapRange(char *tok, buildinfo_t *build_info)
{
    char *low  = tok;
    char *high = tok;

    // look for '-' separator
    char *p = strchr(tok, '-');

    if (p)
    {
        *p++ = 0;

        high = p;
    }

    if (!ValidateMapName(low))
        FatalError("illegal map name: '%s'\n", low);

    if (!ValidateMapName(high))
        FatalError("illegal map name: '%s'\n", high);

    if (strlen(low) < strlen(high))
        FatalError("bad map range (%s shorter than %s)\n", low, high);

    if (strlen(low) > strlen(high))
        FatalError("bad map range (%s longer than %s)\n", low, high);

    if (low[0] != high[0])
        FatalError("bad map range (%s and %s start with different letters)\n", low, high);

    if (StringCompare(low, high) > 0)
        FatalError("bad map range (wrong order, %s > %s)\n", low, high);

    // Ok

    map_range_t range;

    range.low  = low;
    range.high = high;

    map_list.push_back(range);
}

void ParseMapList(const char *from_arg, buildinfo_t *build_info)
{
    // create a mutable copy of the string
    // [ we will keep long-term pointers into this buffer ]
    char *buf = CStringDup(from_arg);

    char *arg = buf;

    while (*arg)
    {
        if (*arg == ',')
            FatalError("bad map list (empty element)\n");

        // find next comma
        char *tok = arg;
        arg++;

        while (*arg && *arg != ',')
            arg++;

        if (*arg == ',')
        {
            *arg++ = 0;
        }

        ParseMapRange(tok, build_info);
    }
}

//
// sanity checks for the sizes and properties of certain types.
// useful when porting.
//
#define AJBSP_ASSERT_SIZE(type, size)                                                                                  \
    do                                                                                                                 \
    {                                                                                                                  \
        if (sizeof(type) != size)                                                                                      \
            FatalError("sizeof " #type " is %d (should be " #size ")\n", (int)sizeof(type));                           \
    } while (0)

void CheckTypeSizes(buildinfo_t *build_info)
{
    AJBSP_ASSERT_SIZE(uint8_t, 1);
    AJBSP_ASSERT_SIZE(int8_t, 1);
    AJBSP_ASSERT_SIZE(uint16_t, 2);
    AJBSP_ASSERT_SIZE(int16_t, 2);
    AJBSP_ASSERT_SIZE(uint32_t, 4);
    AJBSP_ASSERT_SIZE(int32_t, 4);

    AJBSP_ASSERT_SIZE(raw_linedef_t, 14);
    AJBSP_ASSERT_SIZE(raw_sector_s, 26);
    AJBSP_ASSERT_SIZE(raw_sidedef_t, 30);
    AJBSP_ASSERT_SIZE(raw_thing_t, 10);
    AJBSP_ASSERT_SIZE(raw_vertex_t, 4);
}

int BuildNodes(const std::string &filename, buildinfo_t *build_info)
{
    // need this early, especially for fatal errors in utility/wad code
    ajbsp::SetInfo(build_info);

    // sanity check on type sizes (useful when porting)
    CheckTypeSizes(build_info);

    if (filename.empty())
    {
        FatalError("no files to process\n");
        return 0;
    }

    ShowBanner();

    // validate file before processing it
    if (!FileExists(filename))
        FatalError("no such file: %s\n", filename.c_str());

    VisitFile(filename, build_info);

    LogPrint("\n");

    if (total_failed_files > 0)
    {
        LogPrint("FAILURES occurred on %d map%s in %d file%s.\n", total_failed_maps, total_failed_maps == 1 ? "" : "s",
                 total_failed_files, total_failed_files == 1 ? "" : "s");

        LogPrint("Rerun with --verbose to see more details.\n");

        return 2;
    }
    else if (total_built_maps == 0)
    {
        LogPrint("NOTHING was built!\n");

        return 1;
    }
    else if (total_empty_files == 0)
    {
        LogPrint("Ok, built all files.\n");
    }
    else
    {
        int built = 1 - total_empty_files;
        int empty = total_empty_files;

        LogPrint("Ok, built %d file%s, %d file%s empty.\n", built, (built == 1 ? "" : "s"), empty,
                 (empty == 1 ? " was" : "s were"));
    }

    // that's all folks!
    return 0;
}

} // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
