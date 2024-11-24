//------------------------------------------------------------------------
//  Debugging support
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

#include "sys_debug.h"

#include <stdarg.h>
#include <time.h>

#include "lib_util.h"
#include "main.h"
#include "sys_assert.h"

static constexpr uint16_t LOG_BUF_LEN = 8192;

static FILE *log_file = nullptr;
static FILE *ref_file = nullptr;
std::string  log_filename;
std::string  ref_filename;

bool debugging = false;
bool terminal  = false;

bool LogInit(const std::string &filename)
{
    if (!filename.empty())
    {
        log_filename = filename;

        log_file = FileOpen(log_filename, "w");

        if (!log_file)
        {
            return false;
        }
    }

    time_t result = time(nullptr);

    LogPrint("====== START OF OBSIDIAN LOGS ======\n\n");

    LogPrint("Initialized on %s", ctime(&result));

    return true;
}

bool RefInit(const std::string &filename)
{
    if (!filename.empty())
    {
        ref_filename = filename;

        // Clear previously generated reference if present
        if (FileExists(ref_filename))
        {
            FileDelete(ref_filename);
        }

        ref_file = FileOpen(ref_filename, "w");

        if (!ref_file)
        {
            return false;
        }
    }

    RefPrint("====== OBSIDIAN REFERENCE for V%s BUILD %s ======\n\n", OBSIDIAN_SHORT_VERSION, OBSIDIAN_VERSION);

    return true;
}

void LogEnableDebug(bool enable)
{
    if (debugging == enable)
    {
        return;
    }

    debugging = enable;

    if (debugging)
    {
        LogPrint("===  DEBUGGING ENABLED  ===\n\n");
    }
    else
    {
        LogPrint("===  DEBUGGING DISABLED  ===\n\n");
    }
}

void LogEnableTerminal(bool enable)
{
    terminal = enable;
}

void LogClose(void)
{
    LogPrint("\n====== END OF OBSIDIAN LOGS ======\n\n");

    fclose(log_file);
    log_file = nullptr;

    log_filename.clear();
}

void RefClose(void)
{
    RefPrint("\n====== END OF REFERENCE ======\n\n");

    fclose(ref_file);
    ref_file = nullptr;

    ref_filename.clear();
}

void LogPrint(const char *message, ...)
{
    if (!log_file && !terminal)
        return;

    char message_buf[LOG_BUF_LEN];

    message_buf[LOG_BUF_LEN-1] = 0;

    // Print the message into a text string
    va_list argptr;

    va_start(argptr, message);
    vsprintf(message_buf, message, argptr);
    va_end(argptr);

    SYS_ASSERT(message_buf[LOG_BUF_LEN-1] == 0);

    if (log_file)
    {
        fprintf(log_file, "%s", message_buf);
        fflush(log_file);
    }

    if (terminal)
    {
        printf("%s", message_buf);
        fflush(stdout);
    }
}

void RefPrint(const char *message, ...)
{
    if (!ref_file && !terminal)
        return;

    char message_buf[LOG_BUF_LEN];

    message_buf[LOG_BUF_LEN-1] = 0;

    // Print the message into a text string
    va_list argptr;

    va_start(argptr, message);
    vsprintf(message_buf, message, argptr);
    va_end(argptr);

    SYS_ASSERT(message_buf[LOG_BUF_LEN-1] == 0);

    if (ref_file)
    {
        fprintf(ref_file, "%s", message_buf);
        fflush(ref_file);
    }

    if (terminal)
    {
        printf("%s", message_buf);
        fflush(stdout);
    }
}

void DebugPrint(const char *message, ...)
{
    if (!debugging || (!log_file && !terminal))
        return;

    char message_buf[LOG_BUF_LEN];

    message_buf[LOG_BUF_LEN-1] = 0;

    // Print the message into a text string
    va_list argptr;

    va_start(argptr, message);
    vsprintf(message_buf, message, argptr);
    va_end(argptr);

    SYS_ASSERT(message_buf[LOG_BUF_LEN-1] == 0);

    if (log_file)
    {
        fprintf(log_file, "DEBUG: %s", message_buf);
        fflush(log_file);
    }

    if (terminal)
    {
        printf("DEBUG: %s", message_buf);
        fflush(stdout);
    }
}

void ProgStatus(const char *message, ...)
{
    char message_buf[LOG_BUF_LEN];

    message_buf[LOG_BUF_LEN-1] = 0;

    // Print the message into a text string
    va_list argptr;

    va_start(argptr, message);
    vsprintf(message_buf, message, argptr);
    va_end(argptr);

    SYS_ASSERT(message_buf[LOG_BUF_LEN-1] == 0);

    if (log_file)
    {
        fprintf(log_file, "%s", message_buf);
        fflush(log_file);
    }

    if (terminal)
    {
        printf("%s", message_buf);
        fflush(stdout);
    }
}

[[noreturn]] void FatalError(const char *message, ...)
{
    char message_buf[LOG_BUF_LEN];

    message_buf[LOG_BUF_LEN-1] = 0;

    // Print the message into a text string
    va_list argptr;

    va_start(argptr, message);
    vsprintf(message_buf, message, argptr);
    va_end(argptr);

    SYS_ASSERT(message_buf[LOG_BUF_LEN-1] == 0);

    if (log_file)
    {
        fprintf(log_file, "ERROR: %s", message_buf);
        fflush(log_file);
    }

    if (terminal)
        printf("ERROR: %s", message_buf);

    ob_error_message = message_buf;

    Main::Shutdown(true);
    exit(9);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
