//------------------------------------------------------------------------
//  Utility functions
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

#pragma once

#include <stdint.h>

#include <string>

/* file utilities */

std::string GetFilename(std::string_view path);
std::string GetStem(std::string_view path);
std::string GetDirectory(std::string_view path);
std::string GetExtension(std::string_view path);
std::string PathAppend(std::string_view parent, std::string_view child);
bool        IsPathAbsolute(std::string_view path);
void        ReplaceExtension(std::string &path, std::string_view ext);
std::string SanitizePath(std::string_view path);

std::string CurrentDirectoryGet();
bool        MakeDirectory(std::string_view dir);

bool  FileExists(std::string_view name);
FILE *FileOpen(std::string_view name, std::string_view mode);
bool  FileRename(std::string_view oldname, std::string_view newname);
bool  FileDelete(std::string_view name);

/* string utilities */

#ifdef _WIN32
// Technically these are to and from UTF-16, but since these are only for
// Windows "wide" APIs I think we'll be ok - Dasho
std::string  WStringToUTF8(std::wstring_view instring);
std::wstring UTF8ToWString(std::string_view instring);
#endif

inline bool IsUpperASCII(int character)
{
    return (character > '@' && character < '[');
}
inline bool IsLowerASCII(int character)
{
    return (character > '`' && character < '{');
}
inline bool IsAlphaASCII(int character)
{
    return ((character > '@' && character < '[') || (character > '`' && character < '{'));
}
inline bool IsAlphanumericASCII(int character)
{
    return ((character > '@' && character < '[') || (character > '`' && character < '{') ||
            (character > '/' && character < ':'));
}
inline bool IsDigitASCII(int character)
{
    return (character > '/' && character < ':');
}
inline bool IsXDigitASCII(int character)
{
    return ((character > '@' && character < 'G') || (character > '`' && character < 'g') ||
            (character > '/' && character < ':'));
}
inline bool IsPrintASCII(int character)
{
    return (character > 0x1F && character < 0x7F);
}
inline bool IsSpaceASCII(int character)
{
    return ((character > 0x8 && character < 0xE) || character == 0x20);
}
inline int ToLowerASCII(int character)
{
    if (character > '@' && character < '[')
        return character ^ 0x20;
    else
        return character;
}
inline int ToUpperASCII(int character)
{
    if (character > '`' && character < '{')
        return character ^ 0x20;
    else
        return character;
}

char *CStringNew(int length);
char *CStringDup(const char *original, int limit = -1);
char *CStringUpper(const char *name);
void  CStringFree(const char *string);

int StringCompare(std::string_view A, std::string_view B);
int StringPrefixCompare(std::string_view A, std::string_view B);

int StringCaseCompare(std::string_view A, std::string_view B);
int StringPrefixCaseCompare(std::string_view A, std::string_view B);

void StringReplaceChar(std::string *str, char old_ch, char new_ch);

std::string StringFormat(std::string_view fmt, ...);

std::string NumToString(int value);
std::string NumToString(unsigned long long int value);
std::string NumToString(double value);
int         StringToInt(const std::string &value);
double      StringToDouble(const std::string &value);

char *mem_gets(char *buf, int size, const char **str_ptr);

/* time utilities */

uint32_t TimeGetMillies();

/* memory utilities */

void *UtilCalloc(int size);
void *UtilRealloc(void *old, int size);
void  UtilFree(void *data);

/* math utilities */

uint32_t IntHash(uint32_t key);
uint32_t StringHash(const std::string &str);
uint64_t StringHash64(const std::string &str);

double PerpDist(double x, double y, double x1, double y1, double x2, double y2);
double AlongDist(double x, double y, double x1, double y1, double x2, double y2);

double CalcAngle(double sx, double sy, double ex, double ey);
double DiffAngle(double A, double B); // A + result = B

double ComputeDist(double sx, double sy, double ex, double ey);
double ComputeDist(double sx, double sy, double sz, double ex, double ey, double ez);

double PointLineDist(double x, double y, double x1, double y1, double x2, double y2);

void CalcIntersection(double nx1, double ny1, double nx2, double ny2, double px1, double py1, double px2, double py2,
                      double *x, double *y);

std::pair<double, double> AlongCoord(double along, double px1, double py1, double px2, double py2);

bool VectorSameDir(double dx1, double dy1, double dx2, double dy2);

int    RoundPOW2(int x);
double ComputeAngle(double dx, double dy);

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
