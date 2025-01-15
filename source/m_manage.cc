//------------------------------------------------------------------------
//  Manage Config Window
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2014-2017 Andrew Apted
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

#include <FL/Fl_Native_File_Chooser.H>

#include "lib_util.h"
#include "m_cookie.h"
#include "m_lua.h"
#include "m_trans.h"
#include "main.h"
#include "sys_assert.h"

// forward decls
class UI_Manage_Config;

//
// This does the job of scanning a file and extracting any config.
// The text is appended into the given text buffer.
// Returns false if no config can be found in the file.
//
static constexpr uint16_t LOOKAHEAD_SIZE = 1024;

class Lookahead_Stream_c
{
  private:
    FILE *fp;

    char buffer[LOOKAHEAD_SIZE];

    // number of characters in buffer, usually the buffer is full
    int buf_len;

    // read position in buffer, < LOOKAHEAD_SIZE/2 except at EOF
    int pos;

  private:
    void shift_data()
    {
        SYS_ASSERT(pos > 0);
        SYS_ASSERT(pos <= buf_len);

        // compute the new length of buffer
        // (we are eating 'pos' characters at the head)
        buf_len -= pos;

        if (buf_len > 0)
        {
            memmove(buffer, buffer + pos, buf_len);
        }

        pos = 0;
    }

    void read_data()
    {
        int want_len = LOOKAHEAD_SIZE - buf_len;
        SYS_ASSERT(want_len > 0);

        int got_len = fread(buffer + buf_len, 1, want_len, fp);

        if (got_len < 0)
        {
            got_len = 0;
        }

        buf_len = buf_len + got_len;
    }

  public:
    Lookahead_Stream_c(FILE *_fp) : fp(_fp), buf_len(0), pos(0)
    {
        // need an initial packet of data
        read_data();
    }

    virtual ~Lookahead_Stream_c()
    {
    }

  public:
    bool hit_eof()
    {
        return (pos >= buf_len);
    }

    char peek_char(int offset = 0)
    {
        int new_pos = pos + offset;

        if (new_pos >= buf_len)
        {
            return 0;
        }

        return buffer[new_pos];
    }

    char get_char()
    {
        if (hit_eof())
        {
            return 0;
        }

        int ch = buffer[pos++];

        // time to read more from the file?
        if (pos >= LOOKAHEAD_SIZE / 2)
        {
            shift_data();
            read_data();
        }

        return ch;
    }

    bool match(const char *str)
    {
        for (int offset = 0; *str; str++, offset++)
        {
            if (peek_char(offset) != *str)
            {
                return false;
            }
        }

        return true;
    }
};

bool ExtractPresetData(FILE *fp, std::string &buf)
{
    Lookahead_Stream_c stream(fp);

    /* look for a starting string */

    while (1)
    {
        if (stream.hit_eof())
        {
            return false; // not found
        }

        if (stream.match("-- CONFIG FILE : OBSIDIAN ") || stream.match("-- Levels created by OBSIDIAN "))
        {
            break; // found it
        }

        stream.get_char();
    }

    /* copy lines until we hit the end */

    char mini_buf[4];

    while (!stream.hit_eof())
    {
        if (stream.match("-- END"))
        {
            buf.append("-- END --\n\n");
            break;
        }

        int ch = stream.get_char();

        if (ch == 0 || ch == 26)
        {
            break;
        }

        // remove CR (Carriage Return) characters
        if (ch == '\r')
        {
            continue;
        }

        mini_buf[0] = ch;
        mini_buf[1] = 0;

        buf.append(mini_buf);
    }

    return true; // Success!
}

static bool ExtractConfigData(FILE *fp, Fl_Text_Buffer *buf)
{
    Lookahead_Stream_c stream(fp);

    /* look for a starting string */

    while (1)
    {
        if (stream.hit_eof())
        {
            return false; // not found
        }

        if (stream.match("-- CONFIG FILE : OBSIDIAN ") || stream.match("-- Levels created by OBSIDIAN "))
        {
            break; // found it
        }

        stream.get_char();
    }

    /* copy lines until we hit the end */

    char mini_buf[4];

    while (!stream.hit_eof())
    {
        if (stream.match("-- END"))
        {
            buf->append("-- END --\n\n");
            break;
        }

        int ch = stream.get_char();

        if (ch == 0 || ch == 26)
        {
            break;
        }

        // remove CR (Carriage Return) characters
        if (ch == '\r')
        {
            continue;
        }

        mini_buf[0] = ch;
        mini_buf[1] = 0;

        buf->append(mini_buf);
    }

    return true; // Success!
}

//------------------------------------------------------------------------

//
// this prevents the text display widget from selecting areas,
// as well as eating the CTRL-A and CTRL-C keyboard events.
//
class Fl_Text_Display_NoSelect : public Fl_Text_Display
{
  public:
    Fl_Text_Display_NoSelect(int X, int Y, int W, int H, const char *label = 0) : Fl_Text_Display(X, Y, W, H, label)
    {
    }

    virtual ~Fl_Text_Display_NoSelect()
    {
    }

    virtual int handle(int e)
    {
        switch (e)
        {
        case FL_KEYBOARD:
        case FL_KEYUP:
        case FL_PUSH:
        case FL_RELEASE:
        case FL_DRAG:
            return Fl_Group::handle(e);
        }

        return Fl_Text_Display::handle(e);
    }
};

class UI_Manage_Config : public Fl_Double_Window
{
  public:
    bool want_quit;

    Fl_Text_Buffer *text_buf;

    Fl_Text_Display_NoSelect *conf_disp;

    Fl_Button *load_but;
    Fl_Button *save_but;
    Fl_Button *use_but;
    Fl_Button *defaults_but;
    Fl_Button *close_but;

    Fl_Button *cut_but;
    Fl_Button *copy_but;
    Fl_Button *paste_but;

  public:
    UI_Manage_Config(int W, int H, const char *label = NULL);

    virtual ~UI_Manage_Config();

    bool WantQuit() const
    {
        return want_quit;
    }

    void MarkSource(const char *where)
    {
        std::string full = StringFormat("[ %s ]", where);

        conf_disp->copy_label(full.c_str());

        redraw();
    }

    void MarkSource_FILE(std::string filename)
    {
        conf_disp->copy_label(StringFormat("[ %s ]", filename.c_str()).c_str());

        redraw();
    }

    void Clear()
    {
        MarkSource("");

        text_buf->select(0, text_buf->length());
        text_buf->remove_selection();

        save_but->deactivate();
        use_but->deactivate();

        cut_but->deactivate();
        copy_but->deactivate();

        redraw();
    }

    void Enable()
    {
        save_but->activate();
        use_but->activate();

        cut_but->activate();
        copy_but->activate();

        redraw();
    }

    void ReadCurrentSettings()
    {
        Clear();

        text_buf->append("-- CONFIG FILE : OBSIDIAN ");
        text_buf->append(OBSIDIAN_SHORT_VERSION);
        text_buf->append("\"");
        text_buf->append(OBSIDIAN_CODE_NAME.c_str());
        text_buf->append("\"\n");
        text_buf->append("-- Build ");
        text_buf->append(OBSIDIAN_VERSION);
        text_buf->append("\n");
        text_buf->append("-- Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n");
        text_buf->append("-- ");
        text_buf->append(OBSIDIAN_WEBSITE);
        text_buf->append("\n\n");

        std::vector<std::string> lines;

        ob_read_all_config(&lines, false /* need_full */);

        for (unsigned int i = 0; i < lines.size(); i++)
        {
            text_buf->append(lines[i].c_str());
            text_buf->append("\n");
        }

        Enable();

        MarkSource(_("CURRENT SETTINGS"));
    }

    void ReplaceWithString(const char *new_text)
    {
        Clear();

        text_buf->append(new_text);

        Enable();
    }

    const char *AskSaveFilename()
    {
        Fl_Native_File_Chooser chooser;

        chooser.title(_("Pick file to save to"));
        chooser.type(Fl_Native_File_Chooser::BROWSE_SAVE_FILE);
        chooser.options(Fl_Native_File_Chooser::SAVEAS_CONFIRM);
        chooser.filter("Text files\t*.txt");

        if (!last_directory.empty())
        {
            chooser.directory(SanitizePath(last_directory).c_str());
        }
        else
        {
            chooser.directory(SanitizePath(install_dir).c_str());
        }

        switch (chooser.show())
        {
        case -1:
            LogPrint("%s\n", _("Error choosing save file:"));
            LogPrint("   %s\n", chooser.errmsg());

            DLG_ShowError(_("Unable to save the file:\n\n%s"), chooser.errmsg());
            return NULL;

        case 1: // cancelled
            return NULL;

        default:
            break; // OK
        }

        static char filename[FL_PATH_MAX + 10];

        strcpy(filename, chooser.filename());

        // if extension is missing then add ".txt"
        char *pos = (char *)fl_filename_ext(filename);
        if (!*pos)
        {
            strcat(filename, ".txt");
        }

        return filename;
    }

    void SaveToFile(const char *filename)
    {
        // looking at FLTK code, the file is opened in "w" mode, so
        // it should handle end-of-line in an OS-appropriate way.
        int res = text_buf->savefile(filename);

        int err_no = errno;

        if (res)
        {
            const char *reason = (res == 1 && err_no) ? strerror(err_no) : _("Error writing to file.");

            DLG_ShowError(_("Unable to save the file:\n\n%s"), reason);
        }
        else
        {
            Recent_AddFile(RECG_Config, filename);
        }
    }

    std::string AskLoadFilename()
    {
        Fl_Native_File_Chooser chooser;

        chooser.title(_("Select file to load"));
        chooser.type(Fl_Native_File_Chooser::BROWSE_FILE);

        if (!last_directory.empty())
        {
            chooser.directory(SanitizePath(last_directory).c_str());
        }
        else
        {
            chooser.directory(SanitizePath(install_dir).c_str());
        }

        switch (chooser.show())
        {
        case -1:
            LogPrint("%s\n", _("Error choosing load file:"));
            LogPrint("   %s\n", chooser.errmsg());

            DLG_ShowError(_("Unable to load the file:\n\n%s"), chooser.errmsg());
            return "";

        case 1: // cancelled
            return "";

        default:
            break; // OK
        }

        std::string filename = chooser.filename();

        return filename;
    }

    bool LoadFromFile(std::string filename)
    {
        FILE *fp = FileOpen(filename, "rb");

        if (!fp)
        {
            DLG_ShowError(_("Cannot open: %s\n\n%s"), filename.c_str(), strerror(errno));
            return false;
        }

        Clear();

        if (!ExtractConfigData(fp, text_buf))
        {
            DLG_ShowError(_("No config found in file."));
            fclose(fp);
            return false;
        }

        fclose(fp);

        Enable();

        MarkSource_FILE(filename);

        return true;
    }

  private:
    // FLTK virtual method for handling input events
    int handle(int event)
    {
        if (event == FL_PASTE)
        {
            const char *text = Fl::event_text();
            SYS_ASSERT(text);

            if (strlen(text) == 0)
            {
                fl_beep();
            }
            else
            {
                ReplaceWithString(text);
                MarkSource(_("PASTED TEXT"));
            }
            return 1;
        }

        return Fl_Double_Window::handle(event);
    }

  private:
    static void callback_Defaults(Fl_Widget *w, void *data)
    {
        UI_Manage_Config *that = (UI_Manage_Config *)data;
        if (FileExists(config_file))
        {
            FileDelete(config_file);
        }
        config_file.clear();
        main_action     = MAIN_HARD_RESTART; // MAIN_SOFT_RESTART???
        that->want_quit = true;
    }

    /* Loading stuff */

    static void callback_Load(Fl_Widget *w, void *data)
    {
        UI_Manage_Config *that = (UI_Manage_Config *)data;

        // save and restore the font height
        // (because FLTK's own browser gets totally borked)
        int old_font_h = FL_NORMAL_SIZE;
        FL_NORMAL_SIZE = 14 + KF;

        std::string filename = that->AskLoadFilename();

        FL_NORMAL_SIZE = old_font_h;

        if (filename.empty())
        {
            return;
        }

        that->LoadFromFile(filename);
    }

    /* Saving and Using */

    static void callback_Save(Fl_Widget *w, void *data)
    {
        UI_Manage_Config *that = (UI_Manage_Config *)data;

        if (that->text_buf->length() == 0)
        {
            fl_beep();
            return;
        }

        // save and restore the font height
        // (because FLTK's own browser gets totally borked)
        int old_font_h = FL_NORMAL_SIZE;
        FL_NORMAL_SIZE = 14 + KF;

        const char *filename = that->AskSaveFilename();

        FL_NORMAL_SIZE = old_font_h;

        if (!filename)
        {
            return;
        }

        that->SaveToFile(filename);
    }

    static void callback_Use(Fl_Widget *w, void *data)
    {
        UI_Manage_Config *that = (UI_Manage_Config *)data;

        if (that->text_buf->length() == 0)
        {
            fl_beep();
            return;
        }

        const char *str = that->text_buf->text();

        Cookie_LoadString(str, true /* keep_seed */);

        free((void *)str);

        did_specify_seed = true; // User likely wants to use the seed from a
                                 // loaded config - Dasho
    }

    /* Leaving */

    static void callback_Quit(Fl_Widget *w, void *data)
    {
        UI_Manage_Config *that = (UI_Manage_Config *)data;

        that->want_quit = true;
    }

    /* Clipboard stuff */

    static void callback_Copy(Fl_Widget *w, void *data)
    {
        UI_Manage_Config *that = (UI_Manage_Config *)data;

        if (that->text_buf->length() == 0)
        {
            fl_beep();
            return;
        }

        const char *str = that->text_buf->text();

        Fl::copy(str, strlen(str), 1);

        free((void *)str);
    }

    static void callback_Cut(Fl_Widget *w, void *data)
    {
        UI_Manage_Config *that = (UI_Manage_Config *)data;

        callback_Copy(w, data);

        if (that->text_buf->length() > 0)
        {
            that->Clear();
        }
    }

    static void callback_Paste(Fl_Widget *w, void *data)
    {
        UI_Manage_Config *that = (UI_Manage_Config *)data;

        Fl::paste(*that, 1);
    }
};

//
// Constructor
//
UI_Manage_Config::UI_Manage_Config(int W, int H, const char *label) : Fl_Double_Window(W, H, label), want_quit(false)
{
    size_range(W, H);

    callback(callback_Quit, this);

    text_buf = new Fl_Text_Buffer();

    int conf_w = KromulentWidth(420);
    int conf_h = H * 0.75;
    int conf_x = W - conf_w - KromulentWidth(10);
    int conf_y = KromulentHeight(30);

    conf_disp = new Fl_Text_Display_NoSelect(conf_x, conf_y, conf_w, conf_h, "");
    conf_disp->align(Fl_Align(FL_ALIGN_TOP));
    conf_disp->color(WINDOW_BG);
    conf_disp->box(button_style);
    conf_disp->textcolor(FONT_COLOR);
    conf_disp->buffer(text_buf);
    conf_disp->textsize(small_font_size);
    conf_disp->labelfont(font_style);
    conf_disp->textfont(font_style);

    /* Main Buttons */

    int button_x = KromulentWidth(20);
    int button_w = KromulentWidth(100);
    int button_h = KromulentHeight(35);

    Fl_Box *o;
    Fl_Box *use_warn;
    Fl_Box *defaults_warn;

    {
        Fl_Group *g = new Fl_Group(0, 0, conf_disp->x(), conf_disp->h());
        g->resizable(NULL);

        load_but = new Fl_Button(button_x, KromulentHeight(25), button_w, button_h, _("Load WAD/TXT"));
        load_but->box(button_style);
        load_but->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
        load_but->visible_focus(0);
        load_but->color(BUTTON_COLOR);
        load_but->callback(callback_Load, this);
        load_but->shortcut(FL_CTRL + 'l');
        load_but->labelfont(font_style);
        load_but->labelcolor(FONT2_COLOR);

        save_but = new Fl_Button(button_x, KromulentHeight(75), button_w, button_h, _("Save"));
        save_but->box(button_style);
        save_but->visible_focus(0);
        save_but->color(BUTTON_COLOR);
        save_but->callback(callback_Save, this);
        save_but->shortcut(FL_CTRL + 's');
        save_but->labelfont(font_style);
        save_but->labelcolor(FONT2_COLOR);

        use_but = new Fl_Button(button_x, KromulentHeight(125), button_w, button_h, _("Use"));
        use_but->box(button_style);
        use_but->visible_focus(0);
        use_but->color(BUTTON_COLOR);
        use_but->callback(callback_Use, this);
        use_but->labelfont(font_style);
        use_but->labelcolor(FONT2_COLOR);

        use_warn = new Fl_Box(0, KromulentHeight(165), KromulentWidth(140), KromulentHeight(50),
                              _("Note: This will replace\nall current settings!"));
        use_warn->align(Fl_Align(FL_ALIGN_TOP | FL_ALIGN_INSIDE | FL_ALIGN_CLIP));
        use_warn->labelsize(small_font_size);
        use_warn->labelfont(font_style);

        defaults_but = new Fl_Button(button_x, KromulentHeight(200), button_w, button_h, _("Reset to Default"));
        defaults_but->box(button_style);
        defaults_but->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
        defaults_but->visible_focus(0);
        defaults_but->color(BUTTON_COLOR);
        defaults_but->callback(callback_Defaults, this);
        defaults_but->labelfont(font_style);
        defaults_but->labelcolor(FONT2_COLOR);
        // clang-format off
        defaults_warn = new Fl_Box(0, KromulentHeight(240), KromulentWidth(140), KromulentHeight(50),
                                   _("Note: This will delete\nthe current CONFIG.txt\nand restart Obsidian!"));
        // clang-format on
        defaults_warn->align(Fl_Align(FL_ALIGN_TOP | FL_ALIGN_INSIDE | FL_ALIGN_CLIP));
        defaults_warn->labelsize(small_font_size);
        defaults_warn->labelfont(font_style);

        g->end();
    }

    close_but = new Fl_Button(button_x, H - KromulentHeight(50), button_w, button_h + 5, fl_close);
    close_but->box(button_style);
    close_but->visible_focus(0);
    close_but->color(BUTTON_COLOR);
    close_but->labelfont(font_style | FL_BOLD);
    close_but->labelcolor(FONT2_COLOR);
    close_but->labelsize(FL_NORMAL_SIZE + 2);
    close_but->callback(callback_Quit, this);
    close_but->shortcut(FL_CTRL + 'w');

    /* Clipboard buttons */

    {
        int cx = conf_x + KromulentWidth(40);

        int base_y = conf_y + conf_h + 1;

        Fl_Group *g = new Fl_Group(conf_x, base_y, conf_w, H - base_y);
        g->resizable(NULL);

        o = new Fl_Box(cx, base_y, W - cx - 10, KromulentHeight(30), _(" Clipboard Operations"));
        o->align(Fl_Align(FL_ALIGN_CENTER | FL_ALIGN_INSIDE));
        o->labelsize(small_font_size);
        o->labelfont(font_style);

        cx += KromulentWidth(30);
        base_y += KromulentHeight(30);

        button_w = KromulentWidth(80);
        button_h = KromulentHeight(25);

        cut_but = new Fl_Button(cx, base_y, button_w, button_h, _("Cut"));
        cut_but->box(button_style);
        cut_but->visible_focus(0);
        cut_but->color(BUTTON_COLOR);
        cut_but->labelsize(small_font_size);
        cut_but->labelfont(font_style);
        cut_but->labelcolor(FONT2_COLOR);
        cut_but->shortcut(FL_CTRL + 'x');
        cut_but->callback(callback_Cut, this);

        cx += KromulentWidth(115);

        copy_but = new Fl_Button(cx, base_y, button_w, button_h, _("Copy"));
        copy_but->box(button_style);
        copy_but->visible_focus(0);
        copy_but->color(BUTTON_COLOR);
        copy_but->labelsize(small_font_size);
        copy_but->labelfont(font_style);
        copy_but->labelcolor(FONT2_COLOR);
        copy_but->shortcut(FL_CTRL + 'c');
        copy_but->callback(callback_Copy, this);

        cx += KromulentWidth(115);

        paste_but = new Fl_Button(cx, base_y, button_w, button_h, _("Paste"));
        paste_but->box(button_style);
        paste_but->visible_focus(0);
        paste_but->color(BUTTON_COLOR);
        paste_but->labelsize(small_font_size);
        paste_but->labelfont(font_style);
        paste_but->labelcolor(FONT2_COLOR);
        paste_but->shortcut(FL_CTRL + 'v');
        paste_but->callback(callback_Paste, this);

        g->end();
    }

    end();

    resizable(conf_disp);
}

//
// Destructor
//
UI_Manage_Config::~UI_Manage_Config()
{
}

void DLG_ManageConfig(void)
{
    int manage_w = KromulentWidth(600);
    int manage_h = KromulentHeight(380);

    UI_Manage_Config *config_window = new UI_Manage_Config(manage_w, manage_h, _("OBSIDIAN Config Manager"));

    config_window->want_quit = false;
    config_window->set_modal();
    config_window->show();

    config_window->ReadCurrentSettings();

    // run the window until the user closes it
    while (!config_window->WantQuit())
    {
        Fl::wait();
    }

    delete config_window;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
