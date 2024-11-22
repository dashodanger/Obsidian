//------------------------------------------------------------------------
//  Debugging support
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

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (main_win)
    {
        main_win->build_box->SetStatus(message_buf);
    }
    else if (batch_mode)
    {
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
#else
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
#endif
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

#ifndef OBSIDIAN_CONSOLE_ONLY
    DLG_ShowError("%s", message_buf);
#endif

    Main::Shutdown(true);
#if defined _WIN32 && !defined OBSIDIAN_CONSOLE_ONLY
    if (batch_mode)
    {
        printf("\nClose window when finished...");
        do
        {
        } while (true);
    }
#endif
    exit(9);
}

void LogReadLines(log_display_func_t display_func, void *priv_data)
{
    if (!log_file)
    {
        return;
    }

    // we close the log file so we can read it, and then open it
    // again when finished.  That is because Windows OSes can be
    // fussy about opening already open files (in Linux it would
    // not be an issue).

    fclose(log_file);
    log_file = nullptr;

    log_file = FileOpen(log_filename, "r");

    // this is very unlikely to happen, but check anyway
    if (!log_file)
    {
        return;
    }

    std::string buffer;
    int         c = EOF;
    for (;;)
    {
        buffer.clear();
        while ((c = fgetc(log_file)) != EOF)
        {
            if (c == '\n' || c == '\r')
                break;
            else
                buffer.push_back(c);
        }

        // remove any DEL characters (mainly to workaround an FLTK bug)
        StringReplaceChar(&buffer, 0x7f, 0);

        buffer.push_back('\n');

        display_func(buffer, priv_data);

        if (feof(log_file) || ferror(log_file))
            break;
    }

    // close the log file after current contents are read
    fclose(log_file);
    log_file = nullptr;

    // open the log file for writing again
    log_file = FileOpen(log_filename, "a");
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
