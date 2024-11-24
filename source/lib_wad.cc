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

#include "lib_wad.h"

#include <string.h>

#include <list>

#include "lib_util.h"
#include "main.h"
#include "physfs.h"
#include "raw_def.h"
#include "sys_assert.h"
#include "sys_endian.h"

//------------------------------------------------------------------------
//  WAD READING
//------------------------------------------------------------------------

static PHYSFS_File     *wad_R_fp;
static raw_wad_header_t wad_R_header;
static raw_wad_entry_t *wad_R_dir;

bool WAD_OpenRead(const std::string &filename)
{

    wad_R_fp = PHYSFS_openRead(filename.c_str());

    if (!wad_R_fp)
    {
        LogPrint("WAD_OpenRead: no such file: %s\n", filename.c_str());
        return false;
    }

    LogPrint("Opened WAD file: %s\n", filename.c_str());

    if ((PHYSFS_readBytes(wad_R_fp, &wad_R_header, sizeof(wad_R_header)) / sizeof(wad_R_header)) != 1)
    {
        LogPrint("WAD_OpenRead: failed reading header\n");
        PHYSFS_close(wad_R_fp);
        return false;
    }

    if (0 != memcmp(wad_R_header.ident + 1, "WAD", 3))
    {
        LogPrint("WAD_OpenRead: not a WAD file!\n");
        PHYSFS_close(wad_R_fp);
        return false;
    }

    wad_R_header.num_entries = LE_U32(wad_R_header.num_entries);
    wad_R_header.dir_start   = LE_U32(wad_R_header.dir_start);

    /* read directory */

    if (wad_R_header.num_entries >= 5000) // sanity check
    {
        LogPrint("WAD_OpenRead: bad header (%u entries?)\n", static_cast<unsigned int>(wad_R_header.num_entries));
        PHYSFS_close(wad_R_fp);
        return false;
    }

    if (!PHYSFS_seek(wad_R_fp, wad_R_header.dir_start))
    {
        LogPrint("WAD_OpenRead: cannot seek to directory (at 0x%u)\n",
                 static_cast<unsigned int>(wad_R_header.dir_start));
        PHYSFS_close(wad_R_fp);
        return false;
    }

    wad_R_dir = new raw_wad_entry_t[wad_R_header.num_entries + 1];

    for (int i = 0; i < (int)wad_R_header.num_entries; i++)
    {
        raw_wad_entry_t *L = &wad_R_dir[i];

        size_t res = (PHYSFS_readBytes(wad_R_fp, L, sizeof(raw_wad_entry_t)) / sizeof(raw_wad_entry_t));
        if (res != 1)
        {
            if (i == 0)
            {
                LogPrint("WAD_OpenRead: could not read any dir-entries!\n");
                WAD_CloseRead();
                return false;
            }

            LogPrint("WAD_OpenRead: hit EOF reading dir-entry %d\n", i);

            // truncate directory
            wad_R_header.num_entries = i;
            break;
        }

        L->pos  = LE_U32(L->pos);
        L->size = LE_U32(L->size);
    }

    return true; // OK
}

void WAD_CloseRead(void)
{
    PHYSFS_close(wad_R_fp);

    LogPrint("Closed WAD file\n");

    delete[] wad_R_dir;
    wad_R_dir = NULL;
}

int WAD_NumEntries(void)
{
    return (int)wad_R_header.num_entries;
}

int WAD_FindEntry(const char *name)
{
    for (unsigned int i = 0; i < wad_R_header.num_entries; i++)
    {
        char buffer[16];
        strncpy(buffer, wad_R_dir[i].name, 8);
        buffer[8] = 0;

        if (StringCompare(name, buffer) == 0)
        {
            return i;
        }
    }

    return -1; // not found
}

int WAD_EntryLen(int entry)
{
    SYS_ASSERT(entry >= 0 && entry < (int)wad_R_header.num_entries);

    return wad_R_dir[entry].size;
}

const char *WAD_EntryName(int entry)
{
    static char name_buf[16];

    SYS_ASSERT(entry >= 0 && entry < (int)wad_R_header.num_entries);

    // entries are often not NUL terminated, hence return a static copy
    strncpy(name_buf, wad_R_dir[entry].name, 8);
    name_buf[8] = 0;

    return name_buf;
}

bool WAD_ReadData(int entry, int offset, int length, void *buffer)
{
    SYS_ASSERT(entry >= 0 && entry < (int)wad_R_header.num_entries);
    SYS_ASSERT(offset >= 0);
    SYS_ASSERT(length > 0);

    raw_wad_entry_t *L = &wad_R_dir[entry];

    if ((uint32_t)offset + (uint32_t)length > L->size)
    { // EOF
        return false;
    }

    if (!PHYSFS_seek(wad_R_fp, L->pos + offset))
    {
        return false;
    }

    return ((PHYSFS_readBytes(wad_R_fp, buffer, length) / length) == 1);
}

//------------------------------------------------------------------------
//  WAD WRITING
//------------------------------------------------------------------------

static FILE *wad_W_fp;

static std::list<raw_wad_entry_t> wad_W_directory;

static raw_wad_entry_t wad_W_lump;

bool WAD_OpenWrite(const std::string &filename)
{
    wad_W_fp = FileOpen(filename, "wb");

    if (!wad_W_fp)
    {
        LogPrint("WAD_OpenWrite: cannot create file: %s\n", filename.c_str());
        return false;
    }

    LogPrint("Created WAD file: %s\n", filename.c_str());

    // write out a dummy header
    raw_wad_header_t header;
    memset(&header, 0, sizeof(header));

    fwrite(&header, sizeof(raw_wad_header_t), 1, wad_W_fp);
    fflush(wad_W_fp);

    return true;
}

void WAD_CloseWrite(void)
{
    fflush(wad_W_fp);

    // write the directory

    LogPrint("Writing WAD directory\n");

    raw_wad_header_t header;

    memcpy(header.ident, "PWAD", sizeof(header.ident));

    header.dir_start   = ftell(wad_W_fp);
    header.num_entries = 0;

    std::list<raw_wad_entry_t>::iterator WDI;

    for (WDI = wad_W_directory.begin(); WDI != wad_W_directory.end(); ++WDI)
    {
        raw_wad_entry_t *L = &(*WDI);

        fwrite(L, sizeof(raw_wad_entry_t), 1, wad_W_fp);
        fflush(wad_W_fp);

        header.num_entries++;
    }

    fflush(wad_W_fp);

    // finally write the _real_ WAD header

    header.dir_start   = LE_U32(header.dir_start);
    header.num_entries = LE_U32(header.num_entries);

    fseek(wad_W_fp, 0, SEEK_SET);

    fwrite(&header, sizeof(header), 1, wad_W_fp);

    fflush(wad_W_fp);
    fclose(wad_W_fp);
    wad_W_fp = nullptr;

    LogPrint("Closed WAD file\n");

    wad_W_directory.clear();
}

void WAD_NewLump(std::string_view name)
{
    if (name.size() > 8)
    {
        FatalError("WAD_NewLump: name too long: '%s'\n", std::string(name).c_str());
    }

    memset(&wad_W_lump, 0, sizeof(wad_W_lump));

    memcpy(wad_W_lump.name, name.data(), name.size());

    wad_W_lump.pos = ftell(wad_W_fp);
}

bool WAD_AppendData(const void *data, int length)
{
    if (length == 0)
    {
        return true;
    }

    SYS_ASSERT(length > 0);

    return fwrite(data, length, 1, wad_W_fp);
}

void WAD_FinishLump(void)
{
    const int len = ftell(wad_W_fp) - wad_W_lump.pos;

    // pad lumps to a multiple of four bytes
    int padding = (((len) + 3) & ~3) - len;

    if (padding > 0)
    {
        static uint8_t zeros[4] = {0, 0, 0, 0};

        fwrite(zeros, padding, 1, wad_W_fp);
        fflush(wad_W_fp);
    }

    // fix endianness
    wad_W_lump.pos  = LE_U32(wad_W_lump.pos);
    wad_W_lump.size = LE_U32(len);

    wad_W_directory.push_back(wad_W_lump);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
