//----------------------------------------------------------------
//  Game Panel
//----------------------------------------------------------------
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
//----------------------------------------------------------------

#include "lib_util.h"
#include "m_lua.h"
#include "m_trans.h"
#include "main.h"

//
// Constructor
//
UI_Game::UI_Game(int X, int Y, int W, int H) : Fl_Group(X, Y, W, H)
{
    box(box_style);

    int button_w = W * 0.35;
    int button_h = KromulentHeight(30);
    int button_x = X + KromulentWidth(25);

    int y_step = KromulentHeight(30);

    int cx = X + W * 0.29;
    int cy = Y + KromulentHeight(4);

    heading = new Fl_Box(FL_NO_BOX, X + KromulentWidth(8), cy, W - KromulentWidth(12), KromulentHeight(24),
                         _("Game Settings"));
    heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
    heading->labeltype(FL_NORMAL_LABEL);
    heading->labelfont(font_style | FL_BOLD);
    heading->labelsize(header_font_size);

    cy = Y + KromulentHeight(32);

    int cw = W * 0.50;
    int ch = KromulentHeight(22);

    engine = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    engine->copy_label(_("Engine: "));
    engine->align(FL_ALIGN_LEFT);
    engine->labelfont(font_style);
    engine->textcolor(FONT2_COLOR);
    engine->selection_color(SELECTION);
    engine->callback(callback_Engine, this);
    engine_help = new UI_HelpLink(cx + cw, cy, W * 0.10, ch);
    engine_help->labelfont(font_style);
    engine_help->callback(callback_EngineHelp, this);

    cy += y_step;

    game = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    game->copy_label(_("Game: "));
    game->align(FL_ALIGN_LEFT);
    game->labelfont(font_style);
    game->textcolor(FONT2_COLOR);
    game->selection_color(SELECTION);
    game->callback(callback_Game, this);
    game_help = new UI_HelpLink(cx + cw, cy, W * 0.10, ch);
    game_help->labelfont(font_style);
    game_help->callback(callback_GameHelp, this);

    cy += y_step;

    port = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    port->copy_label(_("Port: "));
    port->align(FL_ALIGN_LEFT);
    port->labelfont(font_style);
    port->textcolor(FONT2_COLOR);
    port->selection_color(SELECTION);
    port->callback(callback_Port, this);
    port_help = new UI_HelpLink(cx + cw, cy, W * 0.10, ch);
    port_help->labelfont(font_style);
    port_help->callback(callback_PortHelp, this);

    cy += y_step;

    length = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    length->copy_label(_("Length: "));
    length->align(FL_ALIGN_LEFT);
    length->labelfont(font_style);
    length->textcolor(FONT2_COLOR);
    length->selection_color(SELECTION);
    length->callback(callback_Length, this);
    length_help = new UI_HelpLink(cx + cw, cy, W * 0.10, ch);
    length_help->labelfont(font_style);
    length_help->callback(callback_LengthHelp, this);

    cy += y_step;

    theme = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    theme->copy_label(_("Theme: "));
    theme->align(FL_ALIGN_LEFT);
    theme->labelfont(font_style);
    theme->textcolor(FONT2_COLOR);
    theme->selection_color(SELECTION);
    theme->callback(callback_Theme, this);

    cy += y_step;

    build = new Fl_Button(button_x, cy, button_w, button_h, _("Build"));
    build->visible_focus(0);
    build->box(button_style);
    build->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    build->color(BUTTON_COLOR);
    build->labelcolor(FONT2_COLOR);
    build->labelfont(font_style | FL_BOLD);
    build->labelsize(header_font_size);
    build->callback(build_callback, this);
    build->shortcut(FL_F + 2);

    quit = new Fl_Button(W - button_x - button_w, cy, button_w, button_h, _("Quit"));
    quit->visible_focus(0);
    quit->box(button_style);
    quit->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    quit->color(BUTTON_COLOR);
    quit->labelcolor(FONT2_COLOR);
    quit->labelfont(font_style);
    quit->callback(quit_callback, this);
    quit->shortcut(FL_COMMAND + 'q');

    end();
}

//
// Destructor
//
UI_Game::~UI_Game()
{
}

void UI_Game::callback_Engine(Fl_Widget *w, void *data)
{
    UI_Game *that = (UI_Game *)data;

    ob_set_config("engine", that->engine->GetID());

    if (StringCompare(that->engine->GetID(), "idtech_0") == 0)
    {
        that->theme->deactivate();
    }
    else
    {
        that->theme->activate();
    }
}

void UI_Game::callback_Game(Fl_Widget *w, void *data)
{
    UI_Game *that = (UI_Game *)data;

    ob_set_config("game", that->game->GetID());
}

void UI_Game::callback_GameHelp(Fl_Widget *w, void *data)
{
    fl_cursor(FL_CURSOR_DEFAULT);
    Fl_Window       *win  = new Fl_Window(640, 480, _("Game"));
    Fl_Text_Buffer  *buff = new Fl_Text_Buffer();
    Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
    disp->buffer(buff);
    disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
    win->resizable(*disp);
    win->hotspot(0, 0, 0);
    win->set_modal();
    win->show();
    // clang-format off
    buff->text(_("Available Games:\n\nid Tech 0:\n\nWolfenstein 3D\n\nSpear of Destiny\n\nNoah's Ark 3D\n\nOperation Body Count: Note, this game is less stable than its other id Tech 0 counterparts!\n\nid Tech 1:\n\nDoom 2\n\nDoom\n\nThe Ultimate Doom\n\nPlutonia: Part of Final Doom\n\nTNT: Evilution: Part of Final Doom\n\nHeretic\n\nChex 3 Vanilla: Unofficial repackaging of Chex Quest 3 for non-ZDoom derived engines. SLUMP support only.\n\nHacX 1.2: SLUMP support only.\n\nREKKR: SLUMP support only.\n\nHarmony Compat: Harmony re-release for non-ZDoom derived engines. Must be run as a PWAD in conjuction with the Doom 2/Freedoom 2 IWAD. SLUMP support only.\n\nStrife: SLUMP support only."));
    // clang-format on
}

void UI_Game::callback_Port(Fl_Widget *w, void *data)
{
    UI_Game *that = (UI_Game *)data;

    ob_set_config("port", that->port->GetID());

    if (StringCompare(that->engine->GetID(), "idtech_0") == 0)
    {
        that->theme->deactivate();
    }
    else
    {
        that->theme->activate();
    }
}

void UI_Game::callback_Length(Fl_Widget *w, void *data)
{
    UI_Game *that = (UI_Game *)data;

    ob_set_config("length", that->length->GetID());
}

void UI_Game::callback_Theme(Fl_Widget *w, void *data)
{
    UI_Game *that = (UI_Game *)data;

    ob_set_config("theme", that->theme->GetID());
}

void UI_Game::callback_EngineHelp(Fl_Widget *w, void *data)
{
    fl_cursor(FL_CURSOR_DEFAULT);
    Fl_Window       *win  = new Fl_Window(640, 480, _("Engine"));
    Fl_Text_Buffer  *buff = new Fl_Text_Buffer();
    Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
    disp->buffer(buff);
    disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
    win->resizable(*disp);
    win->hotspot(0, 0, 0);
    win->set_modal();
    win->show();
    // clang-format off
    buff->text(_("id Tech 0: Powered Wolfenstein-3D and similar games\n\nid Tech 1: Powered Doom, Doom 2, Heretic, etc"));
    // clang-format on
}

void UI_Game::callback_PortHelp(Fl_Widget *w, void *data)
{
    fl_cursor(FL_CURSOR_DEFAULT);
    Fl_Window       *win  = new Fl_Window(640, 480, _("Port"));
    Fl_Text_Buffer  *buff = new Fl_Text_Buffer();
    Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
    disp->buffer(buff);
    disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
    win->resizable(*disp);
    win->hotspot(0, 0, 0);
    win->set_modal();
    win->show();
    // clang-format off
    buff->text(_("Available Ports:\n\nid Tech 0:\n\nVanilla: Works with the original executables\n\nid Tech 1:\n\nGZDoom: GZDoom and variants (LZDoom, QZDoom, etc)\n\nVanilla: Works with the original program or ports that enforce the original limits. Examples: Doom within DOSBox, Chocolate Doom. NOTE: This option will use SLUMP as the map builder.\n\nBoom-Compatible: Ports that are able to use the entire suite of Boom types and features. Most modern source ports fall into this category at a minimum.\n\nEDGE-Classic: Boom-compatible, plus UDMF support, additional specials and other advanced features."));
    // clang-format on
}

void UI_Game::callback_LengthHelp(Fl_Widget *w, void *data)
{
    fl_cursor(FL_CURSOR_DEFAULT);
    Fl_Window       *win  = new Fl_Window(640, 480, _("Length"));
    Fl_Text_Buffer  *buff = new Fl_Text_Buffer();
    Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
    disp->buffer(buff);
    disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
    win->resizable(*disp);
    win->hotspot(0, 0, 0);
    win->set_modal();
    win->show();
    // clang-format off
    buff->text(_("Available Game Lengths:\n\nSingle Level: One map.\n\nA Few Maps: Four maps.\n\nOne Episode: The length of an episode in the original game. For Doom 2 and other games which normally doesn't have episodes, this number is determined by Obsidian.\n\nFull Game: The length of a full game in the original program."));
    // clang-format on
}

void UI_Game::Locked(bool value)
{
    if (value)
    {
        engine->deactivate();
        game->deactivate();
        port->deactivate();
        length->deactivate();
        theme->deactivate();
        build->deactivate();
    }
    else
    {
        engine->activate();
        game->activate();
        port->activate();
        length->activate();
        theme->activate();
        build->activate();
    }
}

bool UI_Game::AddChoice(const std::string &button, const std::string &id, const std::string &label)
{
    if (!StringCompare(button, "engine"))
    {
        engine->AddChoice(id, label);
        return true;
    }
    if (!StringCompare(button, "game"))
    {
        game->AddChoice(id, label);
        return true;
    }
    if (!StringCompare(button, "port"))
    {
        if (StringCompare(id, "advanced"))
        {
            port->AddChoice(id, label);
        }
        return true;
    }
    if (!StringCompare(button, "length"))
    {
        length->AddChoice(id, label);
        return true;
    }
    if (!StringCompare(button, "theme"))
    {
        theme->AddChoice(id, label);
        return true;
    }

    return false; // unknown button
}

bool UI_Game::EnableChoice(const std::string &button, const std::string &id, bool enable_it)
{
    if (!StringCompare(button, "engine"))
    {
        engine->EnableChoice(id, enable_it);
        return true;
    }
    if (!StringCompare(button, "game"))
    {
        game->EnableChoice(id, enable_it);
        return true;
    }
    if (!StringCompare(button, "port"))
    {
        port->EnableChoice(id, enable_it);
        return true;
    }
    if (!StringCompare(button, "length"))
    {
        length->EnableChoice(id, enable_it);
        return true;
    }
    if (!StringCompare(button, "theme"))
    {
        theme->EnableChoice(id, enable_it);
        return true;
    }

    return false; // unknown button
}

bool UI_Game::SetButton(const std::string &button, const std::string &id)
{
    if (!StringCompare(button, "engine"))
    {
        engine->ChangeTo(id);
        return true;
    }
    if (!StringCompare(button, "game"))
    {
        game->ChangeTo(id);
        return true;
    }
    if (!StringCompare(button, "port"))
    {
        port->ChangeTo(id);
        return true;
    }
    if (!StringCompare(button, "length"))
    {
        length->ChangeTo(id);
        return true;
    }
    if (!StringCompare(button, "theme"))
    {
        theme->ChangeTo(id);
        return true;
    }

    return false; // unknown button
}

void UI_Game::SetAbortButton(bool abort)
{
    if (abort)
    {
        quit->label(_("Cancel"));
        quit->labelcolor(fl_color_cube(3, 1, 1));
        quit->labelfont(font_style | FL_BOLD);

        quit->callback(stop_callback, this);

        build->labelfont(font_style);
    }
    else
    {
        quit->label(_("Quit"));
        quit->labelcolor(FL_FOREGROUND_COLOR);
        quit->labelfont(font_style);

        quit->callback(quit_callback, this);

        build->labelfont(font_style | FL_BOLD);
    }
}

void UI_Game::build_callback(Fl_Widget *w, void *data)
{
    if (main_action == 0)
    {
        main_action = MAIN_BUILD;
    }
}

void UI_Game::stop_callback(Fl_Widget *w, void *data)
{
    if (main_action != MAIN_QUIT)
    {
        main_action = MAIN_CANCEL;
    }
}

void UI_Game::quit_callback(Fl_Widget *w, void *data)
{
    main_action = MAIN_QUIT;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
