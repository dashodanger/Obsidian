//----------------------------------------------------------------------
//  LUA interface
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

#include "m_lua.h"

#include <algorithm>

#include "ff_main.h"
#include "lib_midi.h"
#include "lib_util.h"
#include "m_trans.h"
#include "main.h"
#include "minilua.h"
#include "physfs.h"
#include "sys_assert.h"
#include "sys_debug.h"
#include "sys_xoshiro.h"

static lua_State *LUA_ST;

static bool has_loaded        = false;
static bool has_added_buttons = false;

static std::vector<std::string> *conf_line_buffer;

static std::string import_dir;

void Script_Load(std::string script_name);

// color maps
color_mapping_t color_mappings[MAX_COLOR_MAPS];

// LUA: format_prefix(levelcount, OB_CONFIG.game, OB_CONFIG.theme, formatstring)
//
int gui_format_prefix(lua_State *L)
{
    const char *levelcount = luaL_checkstring(L, 1);
    const char *game       = luaL_checkstring(L, 2);
    const char *port       = luaL_checkstring(L, 3);
    const char *theme      = luaL_checkstring(L, 4);
    std::string format     = luaL_checkstring(L, 5);

    SYS_ASSERT(levelcount && game && theme && (!format.empty()));

    if (StringCompare(format, "custom") == 0)
    {
        format = custom_prefix.c_str();
    }

    std::string result = ff_main(levelcount, game, port, theme, OBSIDIAN_SHORT_VERSION, format.c_str());

    if (result.empty())
    {
        lua_pushstring(L, "FF_ERROR_"); // Will help people notice issues
        return 1;
    }
    else
    {
        lua_pushstring(L, result.c_str());
        return 1;
    }

    // Hopefully we don't get here
    return 0;
}

// LUA: console_print(str)
//
int gui_console_print(lua_State *L)
{
    int nargs = lua_gettop(L);

    if (nargs >= 1)
    {
        const char *res = luaL_checkstring(L, 1);
        SYS_ASSERT(res);

        // strip off colorizations
        if (res[0] == '@' && IsDigitASCII(res[1]))
        {
            res += 2;
        }

        printf("%s", res);
    }

    return 0;
}

// LUA: ref_print(str)
//
int gui_ref_print(lua_State *L)
{
    int nargs = lua_gettop(L);

    if (nargs >= 1)
    {
        const char *res = luaL_checkstring(L, 1);
        SYS_ASSERT(res);

        // strip off colorizations
        if (res[0] == '@' && IsDigitASCII(res[1]))
        {
            res += 2;
        }

        RefPrint("%s", res);
    }

    return 0;
}

// LUA: raw_log_print(str)
//
int gui_raw_log_print(lua_State *L)
{
    int nargs = lua_gettop(L);

    if (nargs >= 1)
    {
        const char *res = luaL_checkstring(L, 1);
        SYS_ASSERT(res);

        // strip off colorizations
        if (res[0] == '@' && IsDigitASCII(res[1]))
        {
            res += 2;
        }

        LogPrint("%s", res);
    }

    return 0;
}

// LUA: raw_debug_print(str)
//
int gui_raw_debug_print(lua_State *L)
{
    int nargs = lua_gettop(L);

    if (nargs >= 1)
    {
        const char *res = luaL_checkstring(L, 1);
        SYS_ASSERT(res);

        DebugPrint("%s", res);
    }

    return 0;
}

// LUA: gettext(str)
//
int gui_gettext(lua_State *L)
{
    const char *s = luaL_checkstring(L, 1);

    lua_pushstring(L, ob_gettext(s));
    return 1;
}

// LUA: config_line(str)
//
int gui_config_line(lua_State *L)
{
    const char *res = luaL_checkstring(L, 1);

    SYS_ASSERT(conf_line_buffer);

    conf_line_buffer->push_back(res);

    return 0;
}

// LUA: mkdir(dir_name)
//
int gui_mkdir(lua_State *L)
{
    const char *name = luaL_checkstring(L, 1);

    bool result = MakeDirectory(name);

    lua_pushboolean(L, result ? 1 : 0);
    return 1;
}

// LUA: get_filename_base()
//
int gui_get_filename_base(lua_State *L)
{
    std::string base = game_object->Filename();
    lua_pushstring(L, GetStem(base).c_str());
    return 1;
}

// LUA: get_file_extension()
//
int gui_get_file_extension(lua_State *L)
{
    std::string base = luaL_checkstring(L, 1);
    lua_pushstring(L, GetExtension(base).c_str());
    return 1;
}

// LUA: get_save_path()
//
int gui_get_save_path(lua_State *L)
{
    std::string path = game_object->Filename();
    lua_pushstring(L, GetDirectory(path).c_str());
    return 1;
}

// LUA: set_colormap(map, colors)
//
int gui_set_colormap(lua_State *L)
{
    int map_id = luaL_checkinteger(L, 1);

    if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    {
        return luaL_argerror(L, 1, "colmap value out of range");
    }

    if (lua_type(L, 2) != LUA_TTABLE)
    {
        return luaL_argerror(L, 2, "expected a table: colors");
    }

    color_mapping_t *map = &color_mappings[map_id - 1];

    map->size = 0;

    for (int i = 0; i < MAX_COLORS_PER_MAP; i++)
    {
        lua_pushinteger(L, 1 + i);
        lua_gettable(L, 2);

        if (lua_isnil(L, -1))
        {
            lua_pop(L, 1);
            break;
        }

        map->colors[i] = luaL_checkinteger(L, -1);
        map->size      = i + 1;

        lua_pop(L, 1);
    }

    return 0;
}

// LUA: import(script_name)
//
int gui_import(lua_State *L)
{
    if (import_dir.empty())
    {
        return luaL_error(L, "gui.import: no directory set!");
    }

    const char *script_name = luaL_checkstring(L, 1);

    Script_Load(script_name);

    return 0;
}

// LUA: set_import_dir(dir_name)
//
int gui_set_import_dir(lua_State *L)
{
    const char *dir_name = luaL_checkstring(L, 1);

    import_dir = dir_name;

    if (import_dir.empty())
        import_dir = "scripts";

    return 0;
}

// LUA: get_install_dir() --> string
//
int gui_get_install_dir(lua_State *L)
{
    lua_pushstring(L, install_dir.c_str());
    return 1;
}

static bool scan_dir_process_name(const std::string &name, const std::string &parent, std::string match)
{
    if (name[0] == '.')
    {
        return false;
    }

    // fprintf(stderr, "scan_dir_process_name: '%s'\n", name);

    // check if it is a directory
    // [ generally skip directories, unless match is "DIRS" ]

    std::string temp_name = PathAppend(parent, name);

    PHYSFS_Stat dir_checker;

    PHYSFS_stat(temp_name.c_str(), &dir_checker);

    bool is_it_dir = (dir_checker.filetype == PHYSFS_FILETYPE_DIRECTORY);

    if (match == "DIRS")
    {
        return is_it_dir;
    }

    if (is_it_dir)
    {
        return false;
    }

    // pretend that zero-length files do not exist
    // [ allows a PK3 to _remove_ a file ]

    uint8_t buffer[1];

    PHYSFS_File *fp = PHYSFS_openRead(temp_name.c_str());

    if (!fp)
    {
        return false;
    }

    if (PHYSFS_readBytes(fp, buffer, 1) < 1)
    {
        PHYSFS_close(fp);
        return false;
    }

    PHYSFS_close(fp);

    // lastly, check match
    if (match == "*")
    {
        return true;
    }
    else if (match[0] == '*' && match[1] == '.' && IsAlphanumericASCII(match[2]))
    {
        return GetExtension(name) == "." + std::string{match.begin() + 2, match.end()};
    }

    FatalError("gui.scan_directory: unsupported match expression: %s\n", match.c_str());
    return false; /* NOT REACHED */
}

// LUA: scan_directory(dir, match) --> list
//
// Note: 'match' parameter must be of the form "*" or "*.xxx"
//       or must be "DIRS" to return all the sub-directories
//
int gui_scan_directory(lua_State *L)
{
    const char *dir_name = luaL_checkstring(L, 1);
    const char *match    = luaL_checkstring(L, 2);
    if (!PHYSFS_exists(dir_name))
    {
        lua_pushnil(L);
        lua_pushstring(L, "No such directory");
        return 2;
    }

    char **got_names = PHYSFS_enumerateFiles(dir_name);

    // seems this only happens on out-of-memory error
    if (!got_names)
    {
        return luaL_error(L, "gui.scan_directory: %s", PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
    }

    // transfer matching names into another list

    std::vector<std::string> list;

    char **p;

    for (p = got_names; *p; p++)
    {
        if (scan_dir_process_name(*p, dir_name, match))
        {
            list.push_back(*p);
        }
    }

    PHYSFS_freeList(got_names);

    // create the list of filenames / dirnames

    lua_newtable(L);

    for (unsigned int k = 0; k < list.size(); k++)
    {
        lua_pushstring(L, list[k].c_str());
        lua_rawseti(L, -2, (int)(k + 1));
    }

    return 1;
}

// LUA: get_batch_randomize_groups() --> list
//
// Note: 'match' parameter must be of the form "*" or "*.xxx"
//       or must be "DIRS" to return all the sub-directories
//
int gui_get_batch_randomize_groups(lua_State *L)
{
    lua_newtable(L);

    if (!batch_randomize_groups.empty())
    {
        for (unsigned int k = 0; k < batch_randomize_groups.size(); k++)
        {
            lua_pushstring(L, batch_randomize_groups[k].c_str());
            lua_rawseti(L, -2, (int)(k + 1));
        }
    }
    else
    {
        lua_pushnil(L);
    }

    return 1;
}

// LUA: add_choice(button, id, label)
//
int gui_add_choice(lua_State *L)
{
    std::string button = luaL_optstring(L, 1, "");
    std::string id     = luaL_optstring(L, 2, "");
    std::string label  = luaL_optstring(L, 3, "");

    SYS_ASSERT(!button.empty() && !id.empty() && !label.empty());

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    // only allowed during startup
    if (has_added_buttons)
    {
        FatalError("Script problem: gui.add_choice called late.\n");
    }

    if (!main_win->game_box->AddChoice(button, id, label))
    {
        return luaL_error(L, "add_choice: unknown button '%s'\n", button.c_str());
    }
#endif
    return 0;
}

// LUA: enable_choice(what, id, shown)
//
int gui_enable_choice(lua_State *L)
{
    std::string button = luaL_optstring(L, 1, "");
    std::string id     = luaL_optstring(L, 2, "");

    int enable = lua_toboolean(L, 3) ? 1 : 0;

    SYS_ASSERT(!button.empty() && !id.empty());

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    if (!main_win->game_box->EnableChoice(button, id, enable))
    {
        return luaL_error(L, "enable_choice: unknown button '%s'\n", button.c_str());
    }
#endif
    return 0;
}

// LUA: set_button(button, id)
//
int gui_set_button(lua_State *L)
{
    std::string button = luaL_optstring(L, 1, "");
    std::string id     = luaL_optstring(L, 2, "");

    SYS_ASSERT(!button.empty() && !id.empty());

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    if (!main_win->game_box->SetButton(button, id))
    {
        return luaL_error(L, "set_button: unknown button '%s'\n", button.c_str());
    }
#endif
    return 0;
}

// LUA: add_module(where, id, label, tooltip)
//
int gui_add_module(lua_State *L)
{
    std::string where      = luaL_optstring(L, 1, "");
    std::string id         = luaL_optstring(L, 2, "");
    std::string label      = luaL_optstring(L, 3, "");
    std::string tip        = luaL_optstring(L, 4, "");
    int         red        = luaL_optinteger(L, 5, -1);
    int         green      = luaL_optinteger(L, 6, -1);
    int         blue       = luaL_optinteger(L, 7, -1);
    bool        suboptions = luaL_checkinteger(L, 8);

    SYS_ASSERT(!where.empty() && !id.empty() && !label.empty());

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    // only allowed during startup
    if (has_added_buttons)
    {
        FatalError("Script problem: gui.add_module called late.\n");
    }

    if (StringCompare(where, "arch") == 0)
    {
        if (!main_win->mod_tabs->arch_mods->FindID(id))
        {
            main_win->mod_tabs->arch_mods->AddModule(id, label, tip, red, green, blue, suboptions);
        }
    }
    else if (StringCompare(where, "combat") == 0)
    {
        if (!main_win->mod_tabs->combat_mods->FindID(id))
        {
            main_win->mod_tabs->combat_mods->AddModule(id, label, tip, red, green, blue, suboptions);
        }
    }
    else if (StringCompare(where, "pickup") == 0)
    {
        if (!main_win->mod_tabs->pickup_mods->FindID(id))
        {
            main_win->mod_tabs->pickup_mods->AddModule(id, label, tip, red, green, blue, suboptions);
        }
    }
    else if (StringCompare(where, "other") == 0)
    {
        if (!main_win->mod_tabs->other_mods->FindID(id))
        {
            main_win->mod_tabs->other_mods->AddModule(id, label, tip, red, green, blue, suboptions);
        }
    }
    else if (StringCompare(where, "debug") == 0)
    {
        if (!main_win->mod_tabs->debug_mods->FindID(id))
        {
            main_win->mod_tabs->debug_mods->AddModule(id, label, tip, red, green, blue, suboptions);
        }
    }
    else if (StringCompare(where, "experimental") == 0)
    {
        if (!main_win->mod_tabs->experimental_mods->FindID(id))
        {
            main_win->mod_tabs->experimental_mods->AddModule(id, label, tip, red, green, blue, suboptions);
        }
    }
    else if (StringCompare(where, "links") == 0)
    {
        if (!main_win->mod_tabs->links->FindID(id))
        {
            main_win->mod_tabs->links->AddModule(id, label, tip, red, green, blue, suboptions);
        }
    }

#endif
    return 0;
}

// LUA: set_module(id, bool)
//
int gui_set_module(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");

    int opt_val = lua_toboolean(L, 2) ? 1 : 0;

    SYS_ASSERT(!module.empty());

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    // FIXME : error if module is unknown
    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        if (tab->EnableMod(module, opt_val))
        {
            break;
        }
    }

#endif
    return 0;
}

// LUA: show_module(module, shown)
//
int gui_show_module(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");

    int shown = lua_toboolean(L, 2) ? 1 : 0;

    SYS_ASSERT(!module.empty());

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    // FIXME : error if module is unknown
    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        if (tab->ShowModule(module, shown))
        {
            break;
        }
    }
#endif
    return 0;
}

// LUA: add_module_option(module, option, label, tooltip, gap, randomize_group)
//
int gui_add_module_header(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");
    std::string option = luaL_optstring(L, 2, "");

    std::string label = luaL_optstring(L, 3, "");

    int gap = luaL_optinteger(L, 4, 0);

    SYS_ASSERT(!module.empty() && !option.empty());
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    // only allowed during startup
    if (has_added_buttons)
    {
        FatalError("Script problem: gui.add_module_header called late.\n");
    }

    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        UI_Module     *mod = tab->FindID(module);
        if (mod)
        {
            if (!mod->FindHeaderOpt(option))
            {
                tab->AddHeader(module, option, label, gap);
            }
            return 0;
        }
    }

    FatalError("Script problem: gui.add_module_header_option called for "
               "non-existent module!\n");
#endif
    return 0;
}

// LUA: add_module_url(module, option, label, tooltip, gap, randomize_group)
//
int gui_add_module_url(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");
    std::string option = luaL_optstring(L, 2, "");

    std::string label = luaL_optstring(L, 3, "");

    std::string url = luaL_optstring(L, 4, "");

    int gap = luaL_optinteger(L, 5, 0);

    SYS_ASSERT(!module.empty() && !option.empty() && !url.empty());
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    // only allowed during startup
    if (has_added_buttons)
    {
        FatalError("Script problem: gui.add_module_url called late.\n");
    }

    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        UI_Module     *mod = tab->FindID(module);
        if (mod)
        {
            if (!mod->FindUrlOpt(option))
            {
                tab->AddUrl(module, option, label, url, gap);
            }
            return 0;
        }
    }

    FatalError("Script problem: gui.add_module_url called for "
               "non-existent module!\n");
#endif
    return 0;
}

// LUA: add_module_option(module, option, label, tooltip, gap, randomize_group)
//
int gui_add_module_option(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");
    std::string option = luaL_optstring(L, 2, "");

    std::string label   = luaL_optstring(L, 3, "");
    std::string tip     = luaL_optstring(L, 4, "");
    std::string longtip = luaL_optstring(L, 5, "");

    int gap = luaL_optinteger(L, 6, 0);

    std::string randomize_group = luaL_optstring(L, 7, "");

    std::string default_value = luaL_checkstring(L, 8);

    SYS_ASSERT(!module.empty() && !option.empty() && !default_value.empty());
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    // only allowed during startup
    if (has_added_buttons)
    {
        FatalError("Script problem: gui.add_module_option called late.\n");
    }

    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        UI_Module     *mod = tab->FindID(module);
        if (mod)
        {
            if (!mod->FindOpt(option))
            {
                tab->AddOption(module, option, label, tip, longtip, gap, randomize_group, default_value);
            }
            return 0;
        }
    }

    FatalError("Script problem: gui.add_module_option called for "
               "non-existent module!\n");
#endif
    return 0;
}

// LUA: add_module_option(module, option, label, tooltip, gap)
//
int gui_add_module_slider_option(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");
    std::string option = luaL_optstring(L, 2, "");

    std::string label   = luaL_optstring(L, 3, "");
    std::string tip     = luaL_optstring(L, 4, "");
    std::string longtip = luaL_optstring(L, 5, "");

    int gap = luaL_optinteger(L, 6, 0);

    double min = luaL_checknumber(L, 7);
    double max = luaL_checknumber(L, 8);
    double inc = luaL_checknumber(L, 9);

    std::string units   = luaL_optstring(L, 10, "");
    std::string presets = luaL_optstring(L, 11, "");
    std::string nan     = luaL_optstring(L, 12, "");

    std::string randomize_group = luaL_optstring(L, 13, "");

    std::string default_value = luaL_checkstring(L, 14);

    SYS_ASSERT(!module.empty() && !option.empty() && !default_value.empty());
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    // only allowed during startup
    if (has_added_buttons)
    {
        FatalError("Script problem: gui.add_module_option called late.\n");
    }

    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        UI_Module     *mod = tab->FindID(module);
        if (mod)
        {
            if (!mod->FindSliderOpt(option))
            {
                tab->AddSliderOption(module, option, label, tip, longtip, gap, min, max, inc, units, presets, nan,
                                     randomize_group, default_value);
            }
            return 0;
        }
    }

    FatalError("Script problem: gui.add_module_slider_option called for "
               "non-existent module!\n");
#endif
    return 0;
}

// LUA: add_module_button_option(module, option, label, tooltip, gap)
//
int gui_add_module_button_option(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");
    std::string option = luaL_optstring(L, 2, "");

    std::string label   = luaL_optstring(L, 3, "");
    std::string tip     = luaL_optstring(L, 4, "");
    std::string longtip = luaL_optstring(L, 5, "");

    int gap = luaL_optinteger(L, 6, 0);

    std::string randomize_group = luaL_optstring(L, 7, "");

    std::string default_value = luaL_checkstring(L, 8);

    SYS_ASSERT(!module.empty() && !option.empty() && !default_value.empty());
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    // only allowed during startup
    if (has_added_buttons)
    {
        FatalError("Script problem: gui.add_module_option called late.\n");
    }

    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        UI_Module     *mod = tab->FindID(module);
        if (mod)
        {
            if (!mod->FindButtonOpt(option))
            {
                tab->AddButtonOption(module, option, label, tip, longtip, gap, randomize_group, default_value);
            }
            return 0;
        }
    }

    FatalError("Script problem: gui.add_module_button_option called for "
               "non-existent module!\n");
#endif
    return 0;
}

// LUA: add_option_choice(module, option, id, label)
//
int gui_add_option_choice(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");
    std::string option = luaL_optstring(L, 2, "");

    std::string id    = luaL_optstring(L, 3, "");
    std::string label = luaL_optstring(L, 4, "");

    SYS_ASSERT(!module.empty() && !option.empty());

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    // only allowed during startup
    if (has_added_buttons)
    {
        FatalError("Script problem: gui.add_option_choice called late.\n");
    }

    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        if (tab->AddOptionChoice(module, option, id, label))
        {
            break;
        }
    }
#endif
    return 0;
}

// LUA: set_module_option(module, option, value)
//
int gui_set_module_option(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");
    std::string option = luaL_optstring(L, 2, "");
    std::string value  = luaL_optstring(L, 3, "");

    SYS_ASSERT(!module.empty() && !option.empty() && !value.empty());

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    if (!StringCompare(option, "self"))
    {
        return luaL_error(L, "set_module_option: cannot use 'self' here\n", option.c_str());
    }

    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        if (tab->SetOption(module, option, value))
        {
            return 0;
        }
    }

    return luaL_error(L, "set_module_option: unknown option '%s.%s'\n", module.c_str(), option.c_str());
#endif
    return 0;
}

// LUA: set_module_option(module, option, value)
//
int gui_set_module_slider_option(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");
    std::string option = luaL_optstring(L, 2, "");
    std::string value  = luaL_optstring(L, 3, "");

    SYS_ASSERT(!module.empty() && !option.empty() && !value.empty());
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    if (!StringCompare(option, "self"))
    {
        return luaL_error(L, "set_module_option: cannot use 'self' here\n", option.c_str());
    }

    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        if (tab->SetSliderOption(module, option, value))
        {
            return 0;
        }
    }

    return luaL_error(L, "set_module_option: unknown option '%s.%s'\n", module.c_str(), option.c_str());
#endif
    return 0;
}

// LUA: set_module_option(module, option, value)
//
int gui_set_module_button_option(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");
    std::string option = luaL_optstring(L, 2, "");
    int         value  = luaL_checkinteger(L, 3);

    SYS_ASSERT(!module.empty() && !option.empty());
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    if (!StringCompare(option, "self"))
    {
        return luaL_error(L, "set_module_option: cannot use 'self' here\n", option.c_str());
    }

    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        if (tab->SetButtonOption(module, option, value))
        {
            return 0;
        }
    }

    return luaL_error(L, "set_module_option: unknown option '%s.%s'\n", module.c_str(), option.c_str());
#endif
    return 0;
}

// LUA: get_module_slider_value(module, option)
int gui_get_module_slider_value(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");
    std::string option = luaL_optstring(L, 2, "");

    SYS_ASSERT(!module.empty() && !option.empty());

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        UI_Module     *mod = tab->FindID(module);
        if (mod)
        {
            UI_RSlide *slider = mod->FindSliderOpt(option);
            if (slider)
            {
                if (slider->nan_choices.size() > 0)
                {
                    if (slider->nan_options->value() > 0)
                    {
                        lua_pushstring(L, slider->nan_options->text(slider->nan_options->value()));
                    }
                    else
                    {
                        lua_pushnumber(L, slider->mod_slider->value());
                    }
                }
                else
                {
                    lua_pushnumber(L, slider->mod_slider->value());
                }
                return 1;
            }
        }
    }

    return luaL_error(L, "get_module_slider_value: unknown option '%s.%s'\n", module.c_str(), option.c_str());
#else
    return 0;
#endif
}

// LUA: get_module_button_value(module, option)
int gui_get_module_button_value(lua_State *L)
{
    std::string module = luaL_optstring(L, 1, "");
    std::string option = luaL_optstring(L, 2, "");

    SYS_ASSERT(!module.empty() && !option.empty());

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (!main_win)
    {
        return 0;
    }

    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        UI_Module     *mod = tab->FindID(module);
        if (mod)
        {
            UI_RButton *button = mod->FindButtonOpt(option);
            if (button)
            {
                lua_pushnumber(L, button->mod_check->value());
                return 1;
            }
        }
    }

    return luaL_error(L, "get_module_slider_value: unknown option '%s.%s'\n", module.c_str(), option.c_str());
#else
    return 0;
#endif
}

// LUA: at_level(name, idx, total)
//
int gui_at_level(lua_State *L)
{
    std::string name = luaL_optstring(L, 1, "");

    int index = luaL_checkinteger(L, 2);
    int total = luaL_checkinteger(L, 3);

    ProgStatus("%s %s", _("Making"), name.c_str());
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (main_win)
    {
        main_win->build_box->Prog_AtLevel(index, total);
    }
#endif
    return 0;
}

// LUA: prog_step(step_name)
//
int gui_prog_step(lua_State *L)
{
    const char *name = luaL_checkstring(L, 1);
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (main_win)
    {
        main_win->build_box->Prog_Step(name);
    }
#endif
    return 0;
}

// LUA: ticker()
//
int gui_ticker(lua_State * /*L*/)
{
#ifndef OBSIDIAN_CONSOLE_ONLY
    Main::Ticker();
#endif
    return 0;
}

// LUA: abort() --> boolean
//
int gui_abort(lua_State *L)
{
    int value = (main_action >= MAIN_CANCEL) ? 1 : 0;
#ifndef OBSIDIAN_CONSOLE_ONLY
    Main::Ticker();
#endif
    lua_pushboolean(L, value);
    return 1;
}

// LUA: random() --> number
//
int gui_random(lua_State *L)
{
    lua_Number value = xoshiro_Double();
    lua_pushnumber(L, value);
    return 1;
}

int gui_random_int(lua_State *L)
{
    lua_Integer value = xoshiro_UInt();
    lua_pushnumber(L, value);
    return 1;
}

int gui_reseed_rng(lua_State *L)
{
    int seed = luaL_checkinteger(L, 1);
    xoshiro_Reseed(seed);
    return 0;
}

// LUA: bit_and(A, B) --> number
//
int gui_bit_and(lua_State *L)
{
    int A = luaL_checkinteger(L, 1);
    int B = luaL_checkinteger(L, 2);

    lua_pushinteger(L, A & B);
    return 1;
}

// LUA: bit_test(val) --> boolean
//
int gui_bit_test(lua_State *L)
{
    int A = luaL_checkinteger(L, 1);
    int B = luaL_checkinteger(L, 2);

    lua_pushboolean(L, (A & B) != 0);
    return 1;
}

// LUA: bit_or(A, B) --> number
//
int gui_bit_or(lua_State *L)
{
    int A = luaL_checkinteger(L, 1);
    int B = luaL_checkinteger(L, 2);

    lua_pushinteger(L, A | B);
    return 1;
}

// LUA: bit_xor(A, B) --> number
//
int gui_bit_xor(lua_State *L)
{
    int A = luaL_checkinteger(L, 1);
    int B = luaL_checkinteger(L, 2);

    lua_pushinteger(L, A ^ B);
    return 1;
}

// LUA: bit_not(val) --> number
//
int gui_bit_not(lua_State *L)
{
    int A = luaL_checkinteger(L, 1);

    // do not make the result negative
    lua_pushinteger(L, (~A) & 0x7FFFFFFF);
    return 1;
}

int gui_minimap_enable(lua_State *L)
{
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (main_win)
    {
        main_win->build_box->alt_disp->label("");
    }
#endif
    return 0;
}

int gui_minimap_disable(lua_State *L)
{
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (main_win)
    {
        main_win->build_box->mini_map->EmptyMap();
        std::string genny = luaL_checkstring(L, 1);
        // clang-format off
        main_win->build_box->alt_disp->copy_label(StringFormat("%s %s -\n%s", 
            _("Using"),
            genny.c_str(), _("Preview Not Available")).c_str());
        // clang-format on
    }
#endif
    return 0;
}

int gui_minimap_begin(lua_State *L)
{
    // dummy size when running in batch mode
    int map_W = 50;
    int map_H = 50;
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (main_win)
    {
        map_W = main_win->build_box->mini_map->GetWidth();
        map_H = main_win->build_box->mini_map->GetHeight();

        main_win->build_box->mini_map->MapBegin();
    }
#endif
    lua_pushinteger(L, map_W);
    lua_pushinteger(L, map_H);

    return 2;
}

int gui_minimap_finish(lua_State *L)
{
#ifndef OBSIDIAN_CONSOLE_ONLY
    if (main_win)
    {
        main_win->build_box->mini_map->MapFinish();
    }
#endif
    return 0;
}

int gui_minimap_draw_line(lua_State *L)
{
    int x1 = luaL_checkinteger(L, 1);
    int y1 = luaL_checkinteger(L, 2);

    int x2 = luaL_checkinteger(L, 3);
    int y2 = luaL_checkinteger(L, 4);

    const char *color_str = luaL_checkstring(L, 5);

    int r = 255;
    int g = 255;
    int b = 255;

    sscanf(color_str, "#%2x%2x%2x", &r, &g, &b);

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (main_win)
    {
        main_win->build_box->mini_map->DrawLine(x1, y1, x2, y2, (uint8_t)r, (uint8_t)g, (uint8_t)b);
    }
#endif

    return 0;
}

int gui_minimap_fill_box(lua_State *L)
{
    int x1 = luaL_checkinteger(L, 1);
    int y1 = luaL_checkinteger(L, 2);

    int x2 = luaL_checkinteger(L, 3);
    int y2 = luaL_checkinteger(L, 4);

    const char *color_str = luaL_checkstring(L, 5);

    int r = 255;
    int g = 255;
    int b = 255;

    sscanf(color_str, "#%2x%2x%2x", &r, &g, &b);

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (main_win)
    {
        main_win->build_box->mini_map->DrawBox(x1, y1, x2, y2, (uint8_t)r, (uint8_t)g, (uint8_t)b);
    }
#endif

    return 0;
}

int generate_midi_track(lua_State *L)
{
    const char *midi_config = luaL_checkstring(L, 1);
    const char *midi_file   = luaL_checkstring(L, 2);

    int value = steve_generate(midi_config, midi_file) ? 1 : 0;
    lua_pushinteger(L, value);

    return 1;
}

int remove_temp_file(lua_State *L)
{
    std::string path = PathAppend(home_dir, "temp");

    const char *temp_file = luaL_checkstring(L, 1);

    path = PathAppend(path, GetFilename(temp_file));

    if (FileExists(path))
        FileDelete(path);

    return 0;
}

//------------------------------------------------------------------------

extern int SPOT_begin(lua_State *L);
extern int SPOT_draw_line(lua_State *L);
extern int SPOT_fill_poly(lua_State *L);
extern int SPOT_fill_box(lua_State *L);
extern int SPOT_apply_brushes(lua_State *L);
extern int SPOT_dump(lua_State *L);
extern int SPOT_get_mons(lua_State *L);
extern int SPOT_get_items(lua_State *L);
extern int SPOT_end(lua_State *L);

extern int CSG_begin_level(lua_State *L);
extern int CSG_end_level(lua_State *L);
extern int CSG_property(lua_State *L);
extern int CSG_tex_property(lua_State *L);
extern int CSG_add_brush(lua_State *L);
extern int CSG_add_entity(lua_State *L);
extern int CSG_trace_ray(lua_State *L);

extern int WF_wolf_block(lua_State *L);
extern int WF_wolf_read(lua_State *L);
extern int v094_begin_wolf_level(lua_State *L);
extern int v094_end_wolf_level(lua_State *L);

namespace Doom
{
extern int wad_name_gfx(lua_State *L);
extern int wad_logo_gfx(lua_State *L);

extern int wad_add_text_lump(lua_State *L);
extern int wad_add_binary_lump(lua_State *L);
extern int wad_insert_file(lua_State *L);
extern int wad_transfer_lump(lua_State *L);
extern int wad_transfer_map(lua_State *L);
extern int wad_merge_sections(lua_State *L);
extern int wad_read_text_lump(lua_State *L);

extern int pk3_insert_file(lua_State *L);

extern int fsky_create(lua_State *L);
extern int fsky_write(lua_State *L);
extern int fsky_free(lua_State *L);
extern int fsky_solid_box(lua_State *L);
extern int fsky_add_stars(lua_State *L);
extern int fsky_add_clouds(lua_State *L);
extern int fsky_add_hills(lua_State *L);

extern int title_create(lua_State *L);
extern int title_free(lua_State *L);
extern int title_write(lua_State *L);
extern int title_set_palette(lua_State *L);
extern int title_property(lua_State *L);
extern int title_draw_line(lua_State *L);
extern int title_draw_rect(lua_State *L);
extern int title_draw_disc(lua_State *L);
extern int title_draw_clouds(lua_State *L);
extern int title_draw_planet(lua_State *L);
extern int title_load_image(lua_State *L);
extern int v094_begin_level(lua_State *L);
extern int v094_end_level(lua_State *L);
extern int v094_add_thing(lua_State *L);
extern int v094_add_vertex(lua_State *L);
extern int v094_add_linedef(lua_State *L);
extern int v094_add_sidedef(lua_State *L);
extern int v094_add_sector(lua_State *L);
} // namespace Doom

extern int wadfab_load(lua_State *L);
extern int wadfab_free(lua_State *L);
extern int wadfab_get_polygon(lua_State *L);
extern int wadfab_get_sector(lua_State *L);
extern int wadfab_get_side(lua_State *L);
extern int wadfab_get_line(lua_State *L);
extern int wadfab_get_line_hexen(lua_State *L);
extern int wadfab_get_3d_floor(lua_State *L);
extern int wadfab_get_thing(lua_State *L);
extern int wadfab_get_thing_hexen(lua_State *L);

static const luaL_Reg gui_script_funcs[] = {

    {"format_prefix", gui_format_prefix},
    {"console_print", gui_console_print},
    {"ref_print", gui_ref_print},
    {"raw_log_print", gui_raw_log_print},
    {"raw_debug_print", gui_raw_debug_print},

    {"gettext", gui_gettext},
    {"config_line", gui_config_line},
    {"set_colormap", gui_set_colormap},

    {"add_choice", gui_add_choice},
    {"enable_choice", gui_enable_choice},
    {"set_button", gui_set_button},

    {"add_module", gui_add_module},
    {"show_module", gui_show_module},
    {"set_module", gui_set_module},

    {"add_module_header", gui_add_module_header},
    {"add_module_url", gui_add_module_url},
    {"add_module_option", gui_add_module_option},
    {"add_module_slider_option", gui_add_module_slider_option},
    {"add_module_button_option", gui_add_module_button_option},
    {"add_option_choice", gui_add_option_choice},
    {"set_module_option", gui_set_module_option},
    {"set_module_slider_option", gui_set_module_slider_option},
    {"set_module_button_option", gui_set_module_button_option},
    {"get_module_slider_value", gui_get_module_slider_value},
    {"get_module_button_value", gui_get_module_button_value},

    {"get_batch_randomize_groups", gui_get_batch_randomize_groups},

    {"at_level", gui_at_level},
    {"prog_step", gui_prog_step},
    {"ticker", gui_ticker},
    {"abort", gui_abort},
    {"random", gui_random},
    {"random_int", gui_random_int},
    {"reseed_rng", gui_reseed_rng},

    // file & directory functions
    {"import", gui_import},
    {"set_import_dir", gui_set_import_dir},
    {"get_install_dir", gui_get_install_dir},
    {"scan_directory", gui_scan_directory},
    {"mkdir", gui_mkdir},
    {"get_filename_base", gui_get_filename_base},
    {"get_file_extension", gui_get_file_extension},
    {"get_save_path", gui_get_save_path},

    // CSG functions
    {"begin_level", CSG_begin_level},
    {"end_level", CSG_end_level},
    {"property", CSG_property},
    {"tex_property", CSG_tex_property},
    {"add_brush", CSG_add_brush},
    {"add_entity", CSG_add_entity},
    {"trace_ray", CSG_trace_ray},

    // Mini-Map functions
    {"minimap_disable", gui_minimap_disable},
    {"minimap_enable", gui_minimap_enable},
    {"minimap_begin", gui_minimap_begin},
    {"minimap_finish", gui_minimap_finish},
    {"minimap_draw_line", gui_minimap_draw_line},
    {"minimap_fill_box", gui_minimap_fill_box},

    // Wolf-3D functions
    {"wolf_block", WF_wolf_block},
    {"wolf_read", WF_wolf_read},
    {"v094_begin_wolf_level", v094_begin_wolf_level},
    {"v094_end_wolf_level", v094_end_wolf_level},

    // Doom/Heretic/Hexen functions
    {"wad_name_gfx", Doom::wad_name_gfx},
    {"wad_logo_gfx", Doom::wad_logo_gfx},
    {"wad_add_text_lump", Doom::wad_add_text_lump},
    {"wad_add_binary_lump", Doom::wad_add_binary_lump},

    {"wad_insert_file", Doom::wad_insert_file},
    {"wad_transfer_lump", Doom::wad_transfer_lump},
    {"wad_transfer_map", Doom::wad_transfer_map},
    {"wad_merge_sections", Doom::wad_merge_sections},
    {"wad_read_text_lump", Doom::wad_read_text_lump},

    {"pk3_insert_file", Doom::pk3_insert_file},

    {"fsky_create", Doom::fsky_create},
    {"fsky_write", Doom::fsky_write},
    {"fsky_free", Doom::fsky_free},
    {"fsky_solid_box", Doom::fsky_solid_box},
    {"fsky_add_stars", Doom::fsky_add_stars},
    {"fsky_add_clouds", Doom::fsky_add_clouds},
    {"fsky_add_hills", Doom::fsky_add_hills},

    {"title_create", Doom::title_create},
    {"title_free", Doom::title_free},
    {"title_write", Doom::title_write},
    {"title_set_palette", Doom::title_set_palette},
    {"title_prop", Doom::title_property},
    {"title_draw_line", Doom::title_draw_line},
    {"title_draw_rect", Doom::title_draw_rect},
    {"title_draw_disc", Doom::title_draw_disc},
    {"title_draw_clouds", Doom::title_draw_clouds},
    {"title_draw_planet", Doom::title_draw_planet},
    {"title_load_image", Doom::title_load_image},

    {"wadfab_load", wadfab_load},
    {"wadfab_free", wadfab_free},
    {"wadfab_get_polygon", wadfab_get_polygon},
    {"wadfab_get_sector", wadfab_get_sector},
    {"wadfab_get_side", wadfab_get_side},
    {"wadfab_get_line", wadfab_get_line},
    {"wadfab_get_line_hexen", wadfab_get_line_hexen},
    {"wadfab_get_3d_floor", wadfab_get_3d_floor},
    {"wadfab_get_thing", wadfab_get_thing},
    {"wadfab_get_thing_hexen", wadfab_get_thing_hexen},

    // SPOT functions
    {"spots_begin", SPOT_begin},
    {"spots_draw_line", SPOT_draw_line},
    {"spots_fill_poly", SPOT_fill_poly},
    {"spots_fill_box", SPOT_fill_box},
    {"spots_apply_brushes", SPOT_apply_brushes},
    {"spots_dump", SPOT_dump},
    {"spots_get_mons", SPOT_get_mons},
    {"spots_get_items", SPOT_get_items},
    {"spots_end", SPOT_end},

    // v094 functions
    {"v094_begin_level", Doom::v094_begin_level},
    {"v094_end_level", Doom::v094_end_level},
    {"v094_add_thing", Doom::v094_add_thing},
    {"v094_add_vertex", Doom::v094_add_vertex},
    {"v094_add_linedef", Doom::v094_add_linedef},
    {"v094_add_sidedef", Doom::v094_add_sidedef},
    {"v094_add_sector", Doom::v094_add_sector},

    // MIDI generation
    {"generate_midi_track", generate_midi_track},

    // Miscellany
    {"remove_temp_file", remove_temp_file},

    {NULL, NULL} // the end
};

static const luaL_Reg bit_functions[] = {
    {"band", gui_bit_and}, {"btest", gui_bit_test}, {"bor", gui_bit_or}, {"bxor", gui_bit_xor}, {"bnot", gui_bit_not},

    {NULL, NULL} // the end
};

static int p_init_lua(lua_State *L)
{
    /* stop collector during initialization */
    lua_gc(L, LUA_GCSTOP, 0);
    {
        luaL_openlibs(L); /* open libraries */
        luaL_newlib(L, gui_script_funcs);
        lua_setglobal(L, "gui");
        luaL_newlib(L, bit_functions);
        lua_setglobal(L, "bit");
    }
    lua_gc(L, LUA_GCRESTART, 0);

    return 0;
}

static bool Script_CallFunc(const std::string &func_name, int nresult = 0, const std::vector<std::string> &params = {})
{
    // Note: the results of the function will be on the Lua stack

    lua_getglobal(LUA_ST, "ob_traceback");

    if (lua_type(LUA_ST, -1) == LUA_TNIL)
    {
        FatalError("Script problem: missing function 'ob_traceback'");
    }

    lua_getglobal(LUA_ST, func_name.c_str());

    if (lua_type(LUA_ST, -1) == LUA_TNIL)
    {
        FatalError("Script problem: missing function '%s'", func_name.c_str());
    }

    int nargs = 0;
    for (const std::string &param : params)
    {
        lua_pushstring(LUA_ST, param.c_str());
        nargs++;
    }

    int status = lua_pcall(LUA_ST, nargs, nresult, -2 - nargs);
    if (status != 0)
    {
        const char *msg = lua_tolstring(LUA_ST, -1, NULL);

        // skip the filename
        const char *err_msg = strstr(msg, ": ");
        if (err_msg)
        {
            err_msg += 2;
        }
        else
        {
            err_msg = msg;
        }

        if (batch_mode)
        {
            LogPrint("ERROR MESSAGE: %s\n", err_msg);
        }

// this will appear in the log file too
#ifndef OBSIDIAN_CONSOLE_ONLY
        if (main_win)
        {
            main_win->label(StringFormat("%s %s %s \"%s\"", _("[ ERROR ]"), OBSIDIAN_TITLE.c_str(),
                                         OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str())
                                .c_str());
            DLG_ShowError("%s: %s", _("Script Error: "), err_msg);
            main_win->label(
                StringFormat("%s %s \"%s\"", OBSIDIAN_TITLE.c_str(), OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str())
                    .c_str());
        }
#endif
        lua_pop(LUA_ST, 2); // ob_traceback, message
        return false;
    }

    // remove the traceback function
    lua_remove(LUA_ST, -1 - nresult);

    return true;
}

typedef struct load_info_t
{
    PHYSFS_File *fp;
    std::string  error_msg;
    char         buffer[2048];

} load_info_t;

static const char *my_reader(lua_State *L, void *ud, size_t *size)
{
    (void)L;

    load_info_t *info = (load_info_t *)ud;

    if (PHYSFS_eof(info->fp))
    {
        return NULL;
    }

    PHYSFS_sint64 len = PHYSFS_readBytes(info->fp, info->buffer, sizeof(info->buffer));

    // negative result indicates a "complete failure"
    if (len < 0)
    {
        info->error_msg = PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode());
        len             = 0;
    }

    *size = (size_t)len;

    if (!size)
    {
        return NULL;
    }

    return info->buffer; // OK
}

static int my_loadfile(lua_State *L, const std::string &filename)
{
    /* index of filename on the stack */
    int fnameindex = lua_gettop(L) + 1;

    lua_pushfstring(L, "@%s", filename.c_str());

    load_info_t info;

    info.fp = PHYSFS_openRead(filename.c_str());
    info.error_msg.clear();

    if (!info.fp)
    {
        lua_pushfstring(L, "file open error: %s", PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
        lua_remove(L, fnameindex);

        return LUA_ERRFILE;
    }

    int status = lua_load(L, my_reader, &info, lua_tostring(L, -1), "bt");

    // int status = lua_load(L, my_reader, &info, lua_tostring(L, -1));

    /* close file (even in case of errors) */
    PHYSFS_close(info.fp);

    if (!info.error_msg.empty())
    {
        /* ignore results from 'lua_load' */
        lua_settop(L, fnameindex);
        status = LUA_ERRFILE;

        lua_pushstring(L, StringFormat("file read error: %s", info.error_msg.c_str()).c_str());
    }

    lua_remove(L, fnameindex);

    return status;
}

void Script_Load(std::string script_name)
{
    SYS_ASSERT(!import_dir.empty());

    // add extension if missing
    if (GetExtension(script_name).empty())
    {
        ReplaceExtension(script_name, ".lua");
    }

    std::string filename = PathAppend(import_dir, script_name);

    DebugPrint("  loading script: '%s'\n", filename.c_str());

    int status = my_loadfile(LUA_ST, filename);

    if (status == 0)
    {
        status = lua_pcall(LUA_ST, 0, 0, 0);
    }

    if (status != 0)
    {
        const char *msg = lua_tolstring(LUA_ST, -1, NULL);

        FatalError("Unable to load script '%s'\n%s", filename.c_str(), msg);
    }
}

void Script_Open()
{
    if (main_action != MAIN_SOFT_RESTART)
    {
        LogPrint("\n--- OPENING LUA VM ---\n\n");
    }

    // create Lua state

    LUA_ST = luaL_newstate();
    if (!LUA_ST)
    {
        FatalError("LUA Init failed: cannot create new state");
    }

    int status = p_init_lua(LUA_ST);
    if (status != 0)
    {
        FatalError("LUA Init failed: cannot load standard libs (%d)", status);
    }

    // load main scripts

    import_dir = "scripts";

    if (main_action != MAIN_SOFT_RESTART)
    {
        LogPrint("Loading initial script: init.lua\n");
    }

    Script_Load("init.lua");

    if (main_action != MAIN_SOFT_RESTART)
    {
        LogPrint("Loading main script: obsidian.lua\n");
    }

    Script_Load("obsidian.lua");

    has_loaded = true;
    if (main_action != MAIN_SOFT_RESTART)
    {
        LogPrint("DONE.\n\n");
    }

    // ob_init() will load all the game-specific scripts, engine scripts, and
    // module scripts.

    if (main_action == MAIN_SOFT_RESTART)
    {
        if (!Script_CallFunc("ob_restart"))
        {
            FatalError("The ob_init script failed.\n");
        }
    }
    else
    {
        if (!Script_CallFunc("ob_init"))
        {
            FatalError("The ob_init script failed.\n");
        }
    }

    has_added_buttons = true;
}

void Script_Close()
{
    if (LUA_ST)
    {
        lua_close(LUA_ST);
    }

    if (main_action != MAIN_SOFT_RESTART)
    {
        LogPrint("\n--- CLOSED LUA VM ---\n\n");
    }

    LUA_ST = NULL;

    has_added_buttons = false; // Needed if doing live restart
}

//------------------------------------------------------------------------
// WRAPPERS TO LUA FUNCTIONS
//------------------------------------------------------------------------

bool ob_set_config(const std::string &key, const std::string &value)
{
    // See the document 'doc/Config_Flow.txt' for a good
    // description of the flow of configuration values
    // between the C++ GUI and the Lua scripts.

    if (!has_loaded)
    {
        DebugPrint("ob_set_config(%s) called before loaded!\n", key.c_str());
        return false;
    }

    return Script_CallFunc("ob_set_config", 0, {key, value});
}

bool ob_set_mod_option(const std::string &module, const std::string &option, const std::string &value)
{
    if (!has_loaded)
    {
        DebugPrint("ob_set_mod_option() called before loaded!\n");
        return false;
    }

    return Script_CallFunc("ob_set_mod_option", 0, {module, option, value});
}

bool ob_read_all_config(std::vector<std::string> *lines, bool need_full)
{
    if (!has_loaded)
    {
        DebugPrint("ob_read_all_config() called before loaded!\n");
        return false;
    }

    conf_line_buffer = lines;

    std::vector<std::string> params;

    if (need_full)
        params.push_back("need_full");

    bool result = Script_CallFunc("ob_read_all_config", 0, params);

    conf_line_buffer = NULL;

    return result;
}

std::string ob_get_password()
{
    if (!Script_CallFunc("ob_get_password", 1))
    {
        return "";
    }

    std::string res = luaL_optlstring(LUA_ST, -1, "", NULL);

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    return res;
}

std::string ob_get_random_words()
{
    if (!Script_CallFunc("ob_get_random_words", 1))
    {
        return "";
    }

    std::string res = luaL_optlstring(LUA_ST, -1, "", NULL);

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    return res;
}

std::string ob_game_format()
{
    if (!Script_CallFunc("ob_game_format", 1))
    {
        return "";
    }

    std::string res = luaL_optlstring(LUA_ST, -1, "", NULL);

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    return res;
}

std::string ob_get_param(const std::string &parameter)
{
    if (!Script_CallFunc("ob_get_param", 1, {parameter}))
    {
        return "";
    }

    std::string param = luaL_optlstring(LUA_ST, -1, "", NULL);

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    return param;
}

bool ob_hexen_ceiling_check(int thing_id)
{
    if (!Script_CallFunc("ob_hexen_ceiling_check", 1, {NumToString(thing_id)}))
    {
        return false;
    }

    std::string param = luaL_optlstring(LUA_ST, -1, "", NULL);

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    return StringToInt(param);
}

bool ob_mod_enabled(const std::string &module_name)
{
    if (!Script_CallFunc("ob_mod_enabled", 1, {module_name}))
    {
        return false;
    }

    int param = luaL_optinteger(LUA_ST, -1, 0);

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    return param;
}

std::string ob_default_filename()
{
    if (!Script_CallFunc("ob_default_filename", 1))
    {
        return "";
    }

    std::string res = luaL_optlstring(LUA_ST, -1, "", NULL);

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    return res;
}

std::string ob_random_advice()
{
    if (!Script_CallFunc("ob_random_advice", 1))
    {
        return "";
    }

    std::string res = luaL_optlstring(LUA_ST, -1, "", NULL);

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    return res;
}

void ob_print_reference()
{
    if (!Script_CallFunc("ob_print_reference", 1))
    {
        // clang-format off
        printf("%s\n", _("ob_print_reference: Error creating REFERENCE.txt!"));
        // clang-format on
    }
    // clang-format off
    printf("\n%s %s\n", _("A copy of this output can be found at"), reference_file.c_str());
    // clang-format on
}

void ob_print_reference_json()
{
    if (!Script_CallFunc("ob_print_reference_json", 1))
    {
        // clang-format off
        printf("%s\n", _("ob_print_reference_json: Error printing json reference!"));
        // clang-format on
    }
}

void ob_invoke_hook(const std::string &hookname)
{
    if (!Script_CallFunc("ob_invoke_hook", 0, {hookname}))
    {
        ProgStatus("%s", _("Script Error"));
    }
}

bool ob_build_cool_shit()
{
    if (!Script_CallFunc("ob_build_cool_shit", 1))
    {
#ifndef OBSIDIAN_CONSOLE_ONLY
        if (main_win)
        {
            main_win->label(StringFormat("%s %s %s \"%s\"", _("[ ERROR ]"), OBSIDIAN_TITLE.c_str(),
                                         OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str())
                                .c_str());
        }
#endif
        ProgStatus("%s", _("Script Error"));
#ifndef OBSIDIAN_CONSOLE_ONLY
        if (main_win)
        {
            main_win->label(
                StringFormat("%s %s \"%s\"", OBSIDIAN_TITLE.c_str(), OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str())
                    .c_str());
#ifdef _WIN32
            Main::Blinker();
#endif
        }
#endif
        return false;
    }

    const char *res = lua_tolstring(LUA_ST, -1, NULL);

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    if (res && StringCompare(res, "ok") == 0)
    {
        return true;
    }

    ProgStatus("%s", _("Cancelled"));
    return false;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
