//----------------------------------------------------------------------
//  Addons Loading and Selection GUI
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

#include "m_addons.h"

#include "lib_argv.h"
#include "lib_util.h"
#include "m_cookie.h"
#include "main.h"
#include "physfs.h"

// need this because the OPTIONS file is loaded *before* the addons
// folder is scanned for valid archives, so remember enabled ones here.
std::map<std::string, int> initial_enabled_addons;

std::vector<addon_info_t> all_addons;

std::vector<std::string> all_presets;

// Will check install, then home directory (if different)
void VFS_AddFolder(std::string name)
{
    std::string path  = PathAppend(install_dir, name);
    std::string mount = StringFormat("/%s", name.c_str());
    if (!PHYSFS_mount(path.c_str(), mount.c_str(), 0))
    {
        FatalError("Failed to mount '%s' folder in PhysFS:\n%s\n", name.c_str(),
                   PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
        return;                                   /* NOT REACHED */
    }
    if (install_dir != home_dir)
    {
        path = PathAppend(home_dir, name);
        PHYSFS_mount(path.c_str(), mount.c_str(), 0); // this one can fail if not present, that's fine
    }

    DebugPrint("mounted folder '%s'\n", name.c_str());
}

bool VFS_AddArchive(std::string filename, bool options_file)
{
    LogPrint("  using: %s\n", filename.c_str());

    // when handling "bare" filenames from the command line (i.e. ones
    // containing no paths or drive spec) and the file does not exist in
    // the current dir, look for it in the standard addons/ folder.
    if ((!FileExists(filename) && GetDirectory(filename).empty()))
    {
        std::string new_name = StringFormat("%s/addons/%s", home_dir.c_str(), filename.c_str());
        if (!FileExists(new_name))
        {
            new_name = StringFormat("%s/addons/%s", install_dir.c_str(), filename.c_str());
        }
        filename = new_name;
    }

    if (!PHYSFS_mount(filename.c_str(), "/", 0))
    {
        if (options_file)
        {
            LogPrint("Failed to mount '%s' archive in PhysFS:\n%s\n", filename.c_str(),
                     PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
        }
        else
        {
            FatalError("Failed to mount '%s' archive in PhysFS:\n%s\n", filename.c_str(),
                       PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
        }

        return false;
    }

    return true; // Ok
}

void VFS_InitAddons()
{
    LogPrint("Initializing VFS...\n");

    VFS_AddFolder("scripts");
    VFS_AddFolder("games");
    VFS_AddFolder("engines");
    VFS_AddFolder("modules");
    VFS_AddFolder("data");
    VFS_AddFolder("ports");
    VFS_AddFolder("presets");
    VFS_AddFolder("addons");
    VFS_AddFolder("temp");

    LogPrint("DONE.\n\n");
}

void VFS_ParseCommandLine()
{
    int arg   = argv::Find('a', "addon");
    int count = 0;

    if (arg < 0)
    {
        return;
    }

    arg++;

    LogPrint("Command-line addons....\n");

    for (; arg < argv::list.size() && !argv::IsOption(arg); arg++, count++)
    {
        VFS_AddArchive(argv::list[arg], false /* options_file */);
    }

    if (!count)
    {
        FatalError("Missing filename for --addon option\n");
    }

    LogPrint("DONE\n\n");
}

void VFS_OptParse(const std::string &name)
{
    // just remember it now
    if (initial_enabled_addons.find(name) == initial_enabled_addons.end())
    {
        initial_enabled_addons[name] = 1;
    }
}

void VFS_OptWrite(FILE *fp)
{
    fprintf(fp, "---- Enabled Addons ----\n\n");

    for (unsigned int i = 0; i < all_addons.size(); i++)
    {
        const addon_info_t *info = &all_addons[i];

        if (info->enabled)
        {
            fprintf(fp, "addon = %s\n", info->name.c_str());
        }
    }

    fprintf(fp, "\n");
}

void VFS_ScanForPresets()
{
    LogPrint("Scanning for presets....\n");

    all_presets.clear();

    char **got_names = PHYSFS_enumerateFiles("presets");

    // seems this only happens on out-of-memory error
    if (!got_names)
    {
        LogPrint("DONE (none found)\n");
    }

    char **p;

    for (p = got_names; *p; p++)
    {
        if (GetExtension(*p) == ".txt")
        {
            all_presets.push_back(*p);
        }
    }

    PHYSFS_freeList(got_names);

    if (all_presets.size() == 0)
    {
        LogPrint("DONE (none found)\n");
    }
    else
    {
        LogPrint("DONE\n");
    }

    LogPrint("\n");
}

void VFS_ScanForAddons()
{
    LogPrint("Scanning for addons....\n");

    all_addons.clear();

    char **got_names = PHYSFS_enumerateFiles("addons");

    // seems this only happens on out-of-memory error
    if (!got_names)
    {
        LogPrint("DONE (none found)\n");
    }

    char **p;

    for (p = got_names; *p; p++)
    {
        PHYSFS_Stat statter;

        if (PHYSFS_stat(PathAppend("/addons", *p).c_str(), &statter) == 0)
        {
            LogPrint("Could not stat %s: %s\n", *p, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
            continue;
        }

        if (statter.filetype == PHYSFS_FILETYPE_DIRECTORY || (statter.filetype == PHYSFS_FILETYPE_REGULAR && GetExtension(*p) == ".zip"))
        {
            addon_info_t info;

            info.name = *p;

            info.enabled = false;

            if (initial_enabled_addons.find(*p) != initial_enabled_addons.end())
            {
                info.enabled = true;
            }

            LogPrint("  found: %s%s\n", info.name.c_str(), info.enabled ? " (Enabled)" : " (Disabled)");

            all_addons.push_back(info);

            // if enabled, install into the VFS
            if (info.enabled)
            {
                VFS_AddArchive(info.name, true /* options_file */);
            }
        }
    }

    PHYSFS_freeList(got_names);

    if (all_addons.size() == 0)
    {
        LogPrint("DONE (none found)\n");
    }
    else
    {
        LogPrint("DONE\n");
    }

    LogPrint("\n");
}

//----------------------------------------------------------------------

uint8_t *VFS_LoadFile(const char *filename, int *length)
{
    *length = 0;

    PHYSFS_File *fp = PHYSFS_openRead(filename);

    if (!fp)
    {
        return NULL;
    }

    *length = (int)PHYSFS_fileLength(fp);

    if (*length < 0)
    {
        PHYSFS_close(fp);
        return NULL;
    }

    uint8_t *data = new uint8_t[*length + 1];

    // ensure buffer is NUL-terminated
    data[*length] = 0;

    if ((PHYSFS_readBytes(fp, data, *length) / *length) != 1)
    {
        VFS_FreeFile(data);
        PHYSFS_close(fp);
        return NULL;
    }

    PHYSFS_close(fp);

    return data;
}

void VFS_FreeFile(const uint8_t *mem)
{
    if (mem)
    {
        delete[] mem;
    }
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
