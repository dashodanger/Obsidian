//------------------------------------------------------------------------
//  ARCHIVE Handling - ZIP files
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2009-2017 Andrew Apted
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

#include "lib_zip.h"

#include "lib_util.h"
#include "miniz.h"

static mz_zip_archive *zip_writer = nullptr;
static std::string     current_zip;

//------------------------------------------------------------------------
//  ZIP WRITING
//------------------------------------------------------------------------

bool ZIPF_OpenWrite(const std::string &filename)
{
    // Make sure the last ZIPF operation was closed properly and that
    // the target archive doesn't already exist (unlike our WAD stuff
    // there should only ever be one pk3 going on at a time)
    if (FileExists(filename))
    {
        return false;
    }
    if (zip_writer)
    {
        mz_zip_writer_end(zip_writer);
        delete zip_writer;
        zip_writer = nullptr;
    }
    zip_writer = new mz_zip_archive;
    mz_zip_zero_struct(zip_writer);
    if (!mz_zip_writer_init_file(zip_writer, filename.c_str(), 0))
    {
        mz_zip_writer_end(zip_writer);
        delete zip_writer;
        zip_writer = nullptr;
        return false;
    }
    current_zip = filename;
    return true;
}

bool ZIPF_AddFile(const std::string &filename, std::string_view directory)
{
    if (!zip_writer)
    {
        return false;
    }
    return mz_zip_writer_add_file(zip_writer,
                                  !directory.empty() ? PathAppend(directory, GetFilename(filename)).c_str() : GetFilename(filename).c_str(),
                                  filename.c_str(), NULL, 0, MZ_DEFAULT_COMPRESSION);
}

// Calling function is responsible for freeing *data
bool ZIPF_AddMem(const std::string &name, uint8_t *data, size_t length)
{
    if (!zip_writer)
    {
        return false;
    }
    return mz_zip_writer_add_mem(zip_writer, name.c_str(), data, length, MZ_DEFAULT_COMPRESSION);
}

bool ZIPF_CloseWrite(void)
{
    current_zip.clear();
    if (!zip_writer)
    {
        return false;
    }
    bool zip_status = mz_zip_writer_finalize_archive(zip_writer);
    mz_zip_writer_end(zip_writer);
    delete zip_writer;
    zip_writer = nullptr;
    return zip_status;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
