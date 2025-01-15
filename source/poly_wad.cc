//------------------------------------------------------------------------
//
//  AJ-Polygonator
//  (C) 2021-2025 The OBSIDIAN Team
//  (C) 2000-2013 Andrew Apted
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "lib_util.h"
#include "poly.h"
#include "poly_wad.h"
#include "poly_util.h"
#include "raw_def.h"
#include "sys_debug.h"
#include "sys_endian.h"

#define AJPOLY_DEBUG_WAD 0

namespace ajpoly
{

const char *level_lumps[] = {
    "THINGS",  "LINEDEFS", "SIDEDEFS", "VERTEXES", "SEGS",    "SSECTORS", "NODES",
    "SECTORS", "REJECT",   "BLOCKMAP", "BEHAVIOR", "TEXTMAP", "ZNODES",

    NULL // end of list
};

int CheckMagic(const char type[4])
{
    if ((type[0] == 'I' || type[0] == 'P') && type[1] == 'W' && type[2] == 'A' && type[3] == 'D')
    {
        return true;
    }

    return false;
}

int CheckLevelLump(const char *name)
{
    for (int i = 0; level_lumps[i]; i++)
    {
        if (StringCompare(name, level_lumps[i]) == 0)
        {
            return 1 + i;
        }
    }

    return 0;
}

wad_c::~wad_c()
{
    if (fp)
    {
        PHYSFS_close(fp);
    }

    FreeData();

    for (unsigned int i = 0; i < lumps.size(); i++)
    {
        delete lumps[i];
    }
}

uint8_t *wad_c::AllocateData(int length)
{
    if (data_block && length <= data_len)
    {
        return data_block;
    }

    FreeData();

    data_len   = length;
    data_block = new uint8_t[length + 1];

    return data_block;
}

void wad_c::FreeData()
{
    if (data_block)
    {
        delete[] data_block;
    }

    data_block = NULL;
    data_len   = -1;
}

bool wad_c::ReadDirEntry()
{
    raw_wad_entry_t entry;

    int len = (int)(PHYSFS_readBytes(fp, &entry, sizeof(entry)) / sizeof(entry));
    if (len != 1)
    {
        SetErrorMsg("Trouble reading wad directory --> %s", PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
        return false;
    }

    int start  = LE_U32(entry.pos);
    int length = LE_U32(entry.size);

    // ensure name gets NUL terminated
    char name_buf[10];
    memset(name_buf, 0, sizeof(name_buf));
    memcpy(name_buf, entry.name, 8);

    lump_c *lump = new lump_c(name_buf, start, length);

#if AJPOLY_DEBUG_WAD
    LogPrint("Read dir... %s\n", lump->name);
#endif

    lumps.push_back(lump);

    return true; // OK
}

bool wad_c::ReadDirectory()
{
    raw_wad_header_t header;

    int len = (int)(PHYSFS_readBytes(fp, &header, sizeof(header)) / sizeof(header));
    if (len != 1)
    {
        SetErrorMsg("Error reading wad header --> %s", PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
        return false;
    }

    if (!CheckMagic(header.ident))
    {
        SetErrorMsg("File is not a WAD file.");
        return false;
    }

    int num_entries = LE_U32(header.num_entries);
    int dir_start   = LE_U32(header.dir_start);

    LogPrint("Reading %d dir entries at 0x%X\n", num_entries, dir_start);

    PHYSFS_seek(fp, dir_start);

    for (int i = 0; i < num_entries; i++)
    {
        if (!ReadDirEntry())
        {
            return false;
        }
    }

    return true; // OK
}

void wad_c::DetermineLevels()
{
    for (unsigned int k = 0; k < lumps.size(); k++)
    {
        lump_c *L = lumps[k];

        // skip known lumps (these are never valid level names)
        if (CheckLevelLump(L->name))
        {
            continue;
        }

        // check if the next four lumps after the current lump match the
        // level-lump names.  Order doesn't matter, but repeats do.
        int matched = 0;

        for (unsigned int i = 1; i <= 4; i++)
        {
            if (k + i >= lumps.size())
            {
                break;
            }

            lump_c *N = lumps[k + i];

            int idx = CheckLevelLump(N->name);

            if (!idx || idx > 8 /* SECTORS */ || (matched & (1 << idx)))
            {
                break;
            }

            matched |= (1 << idx);
        }

        if ((matched & 0xF) == 0xF)
        {
            continue;
        }

#if AJPOLY_DEBUG_WAD
        LogPrint("Found level name: %s\n", L->name);
#endif

        // collect the children lumps
        L->children = 4;

        for (unsigned int j = 5; j < 16; j++)
        {
            if (k + j >= lumps.size())
            {
                break;
            }

            lump_c *N = lumps[k + j];

            if (!CheckLevelLump(N->name))
            {
                break;
            }

            L->children = j;
        }
    }
}

wad_c *wad_c::Open(const char *filename)
{

    PHYSFS_File *in_file = PHYSFS_openRead(filename);

    if (!in_file)
    {
        SetErrorMsg("Cannot open WAD file: %s --> %s", filename, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
        return NULL;
    }

    LogPrint("Opened WAD file : %s\n", filename);

    wad_c *wad = new wad_c();

    wad->fp = in_file;

    if (!wad->ReadDirectory())
    {
        delete wad;

        return NULL;
    }

    wad->DetermineLevels();

    return wad;
}

int wad_c::FindLump(const char *name, int level)
{
    int first = (level < 0) ? 0 : level + 1;
    int last  = (level < 0) ? (int)lumps.size() - 1 : level + lumps[level]->children;

    for (int i = first; i <= last; i++)
    {
        lump_c *L = lumps[i];

        if (StringCompare(L->name, name) == 0 && L->children == 0)
        {
            return i;
        }
    }

    return -1; // NOT FOUND
}

int wad_c::FindLevel(const char *name)
{
    for (int i = 0; i < (int)lumps.size(); i++)
    {
        lump_c *L = lumps[i];

        if (L->children == 0)
        {
            continue;
        }

        if (name[0] == '*' || (StringCompare(L->name, name) == 0))
        {
            return i;
        }
    }

    return -1; // NOT FOUND
}

uint8_t *wad_c::ReadLump(const char *name, int *length, int level)
{
    int index = FindLump(name, level);

    if (index < 0)
    {
        SetErrorMsg("Missing %slump: '%s'", level ? "level " : "", name);
        return NULL;
    }

    lump_c *L = lumps[index];

#if AJPOLY_DEBUG_WAD
    LogPrint("Reading lump: %s (%d bytes)\n", L->name, L->length);
#endif

    if (length)
    {
        (*length) = L->length;
    }

    uint8_t *data = AllocateData(L->length);

    if (L->length > 0)
    {
        PHYSFS_seek(fp, L->start);

        int len = (int)(PHYSFS_readBytes(fp, data, L->length) / L->length);
        if (len != 1)
        {
            SetErrorMsg("Trouble reading lump '%s' --> %s", name, PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
            return NULL;
        }
    }

    return data;
}

//------------------------------------------------------------------------
//   API FUNCTIONS
//------------------------------------------------------------------------

wad_c *the_wad;

bool LoadWAD(const char *wad_filename)
{
    FreeWAD();

    the_wad = wad_c::Open(wad_filename);

    if (!the_wad)
    {
        return false; // error will be set
    }

    the_wad->the_file = wad_filename;

    return true; // OK
}

void FreeWAD()
{
    if (the_wad)
    {
        delete the_wad;
    }

    the_wad = NULL;
}

} // namespace ajpoly

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
