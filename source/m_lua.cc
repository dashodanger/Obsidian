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

#include <string.h>

#include <algorithm>

#include "ff_main.h"
#include "lib_midi.h"
#include "lib_util.h"
#include "luaalloc.h"
#include "m_trans.h"
#include "main.h"
#include "minilua.h"
#include "physfs.h"
#include "sys_assert.h"
#include "sys_debug.h"
#include "sys_xoshiro.h"

#ifdef OBSIDIAN_ENABLE_GUI
#include <SDL3/SDL.h>
#define NK_INCLUDE_FIXED_TYPES
#define NK_INCLUDE_STANDARD_IO
#define NK_INCLUDE_STANDARD_VARARGS
#define NK_INCLUDE_DEFAULT_ALLOCATOR
#define NK_INCLUDE_VERTEX_BUFFER_OUTPUT
#define NK_INCLUDE_FONT_BAKING
#define NK_INCLUDE_DEFAULT_FONT
#include "nuklear.h"
#include "moonnuklear_extern.h"
#endif

static lua_State *LUA_ST;

static bool has_loaded        = false;

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

// TODO: Have the new GUI use this
static float plan_progress = 0.0f;

// LUA: at_level(name, idx, total)
//
int gui_at_level(lua_State *L)
{
    std::string name = luaL_optstring(L, 1, "");

    int index = luaL_checkinteger(L, 2);
    int total = luaL_checkinteger(L, 3);

    ProgStatus("%s %s", _("Making"), name.c_str());
    plan_progress = (float)index / (float)total;
    ob_build_step = _("Plan");
    return 0;
}

// LUA: prog_step(step_name)
//
int gui_prog_step(lua_State *L)
{
    const char *name = luaL_checkstring(L, 1);
    ob_build_step = name;
    return 0;
}

// LUA: abort() --> boolean
//
int gui_abort(lua_State *L)
{
    int value = (main_action >= MAIN_CANCEL) ? 1 : 0;
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

#ifdef OBSIDIAN_ENABLE_GUI
static void gui_file_picker_callback(void *userdata, const char * const *filelist, int filter)
{
    bool *in_dialog = (bool *)userdata;
    if (!filelist) {
        LogPrint("An error occured: %s", SDL_GetError());
        *in_dialog = false;
        return;
    } else if (!*filelist) {
        LogPrint("The user did not select any file.");
        LogPrint("Most likely, the dialog was canceled.");
        *in_dialog = false;
        return;
    }
    picker_filename = *filelist;
    if (!picker_filename.empty())
        lua_pushlstring(LUA_ST, picker_filename.c_str(), picker_filename.size());
    else
        lua_pushlstring(LUA_ST, NULL, 0);
    lua_setglobal(LUA_ST, "OB_NK_PICKED_FILE");
    *in_dialog = false;
    return;
}

int gui_spawn_file_picker(lua_State *L)
{
    //const char *picked = tinyfd_openFileDialog("PICK FILE", install_dir.c_str(), 0, NULL, NULL, 0);
    picker_filename.clear();
    in_file_dialog = true;
    SDL_ShowOpenFileDialog(gui_file_picker_callback, &in_file_dialog, NULL, NULL, 0, install_dir.c_str(), false);
    return 0;
}
#endif

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

    {"get_batch_randomize_groups", gui_get_batch_randomize_groups},

    {"at_level", gui_at_level},
    {"prog_step", gui_prog_step},
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
#ifdef OBSIDIAN_ENABLE_GUI
    {"spawn_file_picker", gui_spawn_file_picker},
#endif

    // CSG functions
    {"begin_level", CSG_begin_level},
    {"end_level", CSG_end_level},
    {"property", CSG_property},
    {"tex_property", CSG_tex_property},
    {"add_brush", CSG_add_brush},
    {"add_entity", CSG_add_entity},
    {"trace_ray", CSG_trace_ray},

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
#ifdef OBSIDIAN_ENABLE_GUI
        luaopen_moonnuklear(L);
        lua_setglobal(L, "nk");
#endif
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

        LogPrint("ERROR MESSAGE: %s\n", err_msg);
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
    LogPrint("\n--- OPENING LUA VM ---\n\n");

    // create Lua state

    LUA_ST = lua_newstate(luaalloc, luaalloc_create(NULL, NULL));

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

    LogPrint("Loading initial script: init.lua\n");

    Script_Load("init.lua");

    LogPrint("Loading main script: obsidian.lua\n");

    Script_Load("obsidian.lua");

    has_loaded = true;

    LogPrint("DONE.\n\n");

    // ob_init() will load all the game-specific scripts, engine scripts, and
    // module scripts.

    if (!Script_CallFunc("ob_init"))
    {
        FatalError("The ob_init script failed.\n");
    }
}

void Script_Close()
{
    if (LUA_ST)
    {
        lua_close(LUA_ST);
    }

    LogPrint("\n--- CLOSED LUA VM ---\n\n");

    LUA_ST = NULL;
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
        ProgStatus("%s", _("Script Error"));
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

#ifdef OBSIDIAN_ENABLE_GUI
bool ob_gui_init_ctx(void *context)
{
    SYS_ASSERT(context);

    lua_getglobal(LUA_ST, "nk");

    lua_pushstring(LUA_ST, "init_from_ptr");

    lua_gettable(LUA_ST, -2);

    if (lua_type(LUA_ST, -1) == LUA_TNIL)
    {
        FatalError("Script problem: missing function 'nk.init_from_ptr'");
    }

    lua_pushlightuserdata(LUA_ST, context);

    int status = lua_pcall(LUA_ST, 1, 1, -2);

    if (status != 0)
    {
        // error, better quit
        return false;
    }

    lua_setglobal(LUA_ST, "OB_NK_CTX");

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    return true;
}

bool ob_gui_init_fonts(void *atlas, float font_scale)
{
    SYS_ASSERT(atlas);

    lua_getglobal(LUA_ST, "nk");

    lua_pushstring(LUA_ST, "font_atlas_from_ptr");

    lua_gettable(LUA_ST, -2);

    if (lua_type(LUA_ST, -1) == LUA_TNIL)
    {
        LogPrint("Script problem: missing function 'nk.font_atlas_from_ptr'");
        return false;
    }

    lua_pushlightuserdata(LUA_ST, atlas);

    int status = lua_pcall(LUA_ST, 1, 1, -2);

    if (status != 0)
    {
        // error, better quit
        return false;
    }

    lua_setglobal(LUA_ST, "OB_NK_ATLAS");

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    lua_getglobal(LUA_ST, "ob_gui_init_fonts");

    if (lua_type(LUA_ST, -1) == LUA_TNIL)
    {
        LogPrint("Script problem: missing function 'ob_gui_init_fonts'");
        return false;
    }

    lua_pushnumber(LUA_ST, font_scale);

    status = lua_pcall(LUA_ST, 1, 1, -2);

    if (status != 0)
    {
        // error, better quit
        return false;
    }

    const char *res = lua_tolstring(LUA_ST, -1, NULL);

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    if (!res)
    {
        return false;
    }

    if (StringCompare(res, "bork") == 0)
    {
        return false;
    }

    return true;
}

bool ob_gui_frame(int width, int height)
{
    lua_getglobal(LUA_ST, "ob_gui_frame");

    if (lua_type(LUA_ST, -1) == LUA_TNIL)
    {
        FatalError("Script problem: missing function 'ob_gui_frame'");
    }

    lua_pushinteger(LUA_ST, width);

    lua_pushinteger(LUA_ST, height);

    int status = lua_pcall(LUA_ST, 2, 1, -3);

    if (status != 0)
    {
        // error, better quit
        return false;
    }

    const char *res = lua_tolstring(LUA_ST, -1, NULL);

    // remove result from lua stack
    lua_pop(LUA_ST, 1);

    if (!res)
    {
        return false;
    }

    if (StringCompare(res, "quit") == 0)
    {
        return false;
    }

    return true;
}
#endif

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
