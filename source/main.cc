//------------------------------------------------------------------------
//  Main program
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

#include "main.h"

#include <locale.h>

#include "csg_main.h"
#include "images.h"
#include "lib_argv.h"
#include "lib_util.h"
#include "lib_zip.h"
#include "m_addons.h"
#include "m_cookie.h"
#include "m_lua.h"
#include "m_trans.h"
#include "physfs.h"
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
#define NK_IMPLEMENTATION
#define NK_SDL_RENDERER_SDL_H <SDL3/SDL.h>
#define NK_SDL_RENDERER_IMPLEMENTATION
#include "nuklear.h"
#include "nuklear_sdl_renderer.h"

#define WINDOW_WIDTH 1200
#define WINDOW_HEIGHT 800
#endif

std::string home_dir;
std::string install_dir;
std::string config_file;
std::string options_file;
std::string logging_file;
std::string reference_file;

std::string ob_error_message;
float ob_build_progress;
std::string ob_build_step;

struct UpdateKv
{
    char        section;
    std::string key;
    std::string value;
};

UpdateKv update_kv;

std::string OBSIDIAN_TITLE     = "OBSIDIAN Level Maker";
std::string OBSIDIAN_CODE_NAME = "Unstable";

int screen_w;
int screen_h;

int main_action;

unsigned long long next_rand_seed;

std::string              batch_output_file;
std::string              numeric_locale;
std::vector<std::string> batch_randomize_groups;

// options
int         filename_prefix        = 0;
std::string custom_prefix          = "CUSTOM_";
bool        create_backups         = true;
bool        overwrite_warning      = true;
bool        debug_messages         = false;
bool        limit_break            = false;
bool        preserve_failures      = false;
bool        preserve_old_config    = false;
bool        did_randomize          = false;
bool        randomize_architecture = false;
bool        randomize_monsters     = false;
bool        randomize_pickups      = false;
bool        randomize_misc         = false;
bool        random_string_seeds    = false;
bool        password_mode          = false;
bool        mature_word_lists      = false;
bool        did_specify_seed       = false;
#ifdef OBSIDIAN_ENABLE_GUI
bool        in_file_dialog         = false;
std::string picker_filename;
#endif

std::string default_output_path;

std::string string_seed;

std::string selected_lang = "en"; // Have a default just in case the translation stuff borks

game_interface_c *game_object = NULL;

/* ----- user information ----------------------------- */

static void ShowInfo()
{
    printf("\n"
           "** %s %s \"%s\"\n"
           "** Build %s **\n"
           "** Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted **\n"
           "\n",
           OBSIDIAN_TITLE.c_str(), OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str(), OBSIDIAN_VERSION);

    printf("Usage: Obsidian [options...] [key=value...]\n"
           "\n"
           "Available options:\n"
           "     --version              Display build information\n"
           "     --home     <dir>       Home directory\n"
           "     --install  <dir>       Installation directory\n"
           "\n"
           "     --config   <file>      Config file for GUI\n"
           "     --options  <file>      Options file for GUI\n"
           "     --log      <file>      Log file to create\n"
           "\n"
           "  -o --output   <output>    Specify output filename\n"
           "  -a --addon    <file>...   Addon(s) to use\n"
           "  -l --load     <file>      Load settings from a file\n"
           "  -k --keep                 Keep SEED from loaded settings\n"
           "\n"
           "     --randomize-all        Randomize all options\n"
           "     --randomize-arch       Randomize architecture settings\n"
           "     --randomize-combat     Randomize combat-related settings\n"
           "     --randomize-pickups    Randomize item/weapon settings\n"
           "     --randomize-other      Randomize other settings\n"
           "\n"
           "  -d --debug                Enable debugging\n"
           "  -v --verbose              Print log messages to stdout\n"
           "  -h --help                 Show this help message\n"
           "  -p --printref             Print reference of all keys and values to "
           "REFERENCE.txt\n"
           "     --printref-json        Print reference of all keys and values in "
           "JSON format\n"
           "  -u --update <section> <key> <value>\n"
           "                            Set a key in the config file\n"
           "                            (section should be 'c' or 'o')\n"
           "\n");

    printf("Please visit the web site for complete information:\n"
           "  %s \n"
           "\n",
           OBSIDIAN_WEBSITE);

    printf("This program is free software, under the terms of the GNU General "
           "Public\n"
           "License, and comes with ABSOLUTELY NO WARRANTY.  See the "
           "documentation\n"
           "for more details, or visit http://www.gnu.org/licenses/gpl-2.0.txt\n"
           "\n");

    fflush(stdout);
}

static void ShowVersion()
{
    printf("%s %s \"%s\" Build %s\n", OBSIDIAN_TITLE.c_str(), OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str(),
           OBSIDIAN_VERSION);

    fflush(stdout);
}

void Determine_WorkingPath()
{
#ifdef _WIN32
    home_dir = PHYSFS_getBaseDir();
#else
    home_dir = PHYSFS_getPrefDir("Obsidian Team", "Obsidian");
#endif
    // ensure scratch folder exists
    MakeDirectory(PathAppend(home_dir, "temp"));
}

std::string Resolve_DefaultOutputPath()
{
    if (default_output_path.empty())
    {
        default_output_path = home_dir;
    }
    if (default_output_path[0] == '$')
    {
        const char *var = getenv(default_output_path.c_str() + 1);
        if (var != nullptr)
        {
            return var;
        }
    }
    return default_output_path;
}

static bool Verify_InstallDir(const std::string &path)
{
    const std::string filename = PathAppend(path, "scripts/obsidian.lua");

    return FileExists(filename);
}

void Determine_InstallDir()
{
    install_dir = PHYSFS_getBaseDir();
}

void Determine_ConfigFile()
{
    config_file = PathAppend(home_dir, CONFIG_FILENAME);
}

void Determine_OptionsFile()
{
    options_file = PathAppend(home_dir, OPTIONS_FILENAME);
}

void Determine_LoggingFile()
{
    logging_file = PathAppend(home_dir, LOG_FILENAME);
}

void Determine_ReferenceFile()
{
    if (argv::Find('p', "printref") >= 0)
    {
        reference_file = PathAppend(home_dir, REF_FILENAME);
    }
}

bool Main::BackupFile(const std::string &filename)
{
    if (FileExists(filename))
    {
        std::string backup_name = filename;

        ReplaceExtension(backup_name, StringFormat("%s.%s", GetExtension(backup_name).c_str(), ".bak"));

        LogPrint("Backing up existing file to: %s\n", backup_name.c_str());

        FileDelete(backup_name);
        FileRename(filename, backup_name);
    }

    return true;
}

void Main::Shutdown(const bool error)
{
    // on fatal error we cannot risk calling into the Lua runtime
    // (it's state may be compromised by a script error).
    if (!config_file.empty() && !error)
    {
        if (did_randomize)
        {
            if (!preserve_old_config)
            {
                Cookie_Save(config_file);
            }
        }
        else
        {
            Cookie_Save(config_file);
        }
    }

    if (!FileExists(options_file))
    {
        Options_Save(options_file);
    }

    Script_Close();
    LogClose();
}

void Main_CalcNewSeed()
{
    next_rand_seed = xoshiro_UInt();
}

void Main_SetSeed()
{
    if (random_string_seeds && !did_specify_seed)
    {
        if (string_seed.empty())
        {
            if (password_mode)
            {
                if (next_rand_seed % 2 == 1)
                {
                    string_seed = ob_get_password();
                }
                else
                {
                    string_seed = ob_get_random_words();
                }
            }
            else
            {
                string_seed = ob_get_random_words();
            }
            ob_set_config("string_seed", string_seed.c_str());
            next_rand_seed = StringHash64(string_seed);
        }
    }
    xoshiro_Reseed(next_rand_seed);
    std::string seed = NumToString(next_rand_seed);
    ob_set_config("seed", seed.c_str());
}

static void Module_Defaults()
{
    ob_set_mod_option("sky_generator", "self", "1");
    //ob_set_mod_option("armaetus_epic_textures", "self", "1");
    ob_set_mod_option("music_swapper", "self", "1");
    ob_set_mod_option("compress_output", "self", "1");
}

//------------------------------------------------------------------------

bool Build_Cool_Shit()
{
    const std::string format = ob_game_format();

    if (format.empty())
    {
        FatalError("ERROR: missing 'format' for game?!?\n");
    }

    // create game object
    {
        if (StringCompare(format, "doom") == 0)
        {
            game_object = Doom_GameObject();
        }
        else if (StringCompare(format, "wolf3d") == 0)
        {
            game_object = Wolf_GameObject();
        }
        else
        {
            FatalError("ERROR: unknown format: '%s'\n", format.c_str());
        }
    }

    const std::string def_filename = batch_output_file;

    const uint32_t start_time = TimeGetMillies();
    bool           was_ok     = false;
    // this will ask for output filename (among other things)
    if (StringCompare(format, "wolf3d") == 0)
    {
        std::string current_game = ob_get_param("game");
        if (StringCompare(current_game, "wolf") == 0)
        {
            was_ok = game_object->Start("WL6");
        }
        else if (StringCompare(current_game, "spear") == 0)
        {
            was_ok = game_object->Start("SOD");
        }
        else if (StringCompare(current_game, "noah") == 0)
        {
            was_ok = game_object->Start("N3D");
        }
        else if (StringCompare(current_game, "obc") == 0)
        {
            was_ok = game_object->Start("BC");
        }
    }
    else
    {
        was_ok = game_object->Start(def_filename.c_str());
    }

    if (was_ok)
    {
        // run the scripts Scotty!
        was_ok = ob_build_cool_shit();

        was_ok = game_object->Finish(was_ok);
    }
    if (was_ok)
    {
        ProgStatus("%s", _("Success"));

        const uint32_t end_time   = TimeGetMillies();
        const uint32_t total_time = end_time - start_time;

        LogPrint("\nTOTAL TIME: %g seconds\n\n", total_time / 1000.0);

        string_seed.clear();
    }
    else
    {
        string_seed.clear();
    }

    if (main_action == MAIN_CANCEL)
    {
        main_action = 0;
        ProgStatus("%s", _("Cancelled"));
    }

    // Insurance in case the build process errored/cancelled
    ZIPF_CloseWrite();
    if (!was_ok)
    {
        if (FileExists(game_object->Filename()))
        {
            FileDelete(game_object->Filename());
        }
        if (FileExists(game_object->ZIP_Filename()))
        {
            FileDelete(game_object->ZIP_Filename());
        }
    }

    // don't need game object anymore
    delete game_object;
    game_object = NULL;

    return was_ok;
}

void Options_ParseArguments()
{

    if (argv::Find(0, "randomize-all") >= 0)
    {
        batch_randomize_groups.push_back("architecture");
        batch_randomize_groups.push_back("monsters");
        batch_randomize_groups.push_back("pickups");
        batch_randomize_groups.push_back("misc");
        goto skiprest;
    }

    if (argv::Find(0, "randomize-arch") >= 0)
    {
        batch_randomize_groups.push_back("architecture");
    }

    if (argv::Find(0, "randomize-monsters") >= 0)
    {
        batch_randomize_groups.push_back("monsters");
    }

    if (argv::Find(0, "randomize-pickups") >= 0)
    {
        batch_randomize_groups.push_back("pickups");
    }

    if (argv::Find(0, "randomize-other") >= 0)
    {
        batch_randomize_groups.push_back("misc");
    }

skiprest:;
}

/* ----- main program ----------------------------- */

int main(int argc, char **argv)
{
    // initialise argument parser (skipping program name)

    // these flags take at least one argument
    argv::short_flags.emplace('b');
    argv::short_flags.emplace('a');
    argv::short_flags.emplace('l');
    argv::short_flags.emplace('u');

    // parse the flags
    argv::Init(argc, argv);

    if (!PHYSFS_init(argv::list[0].c_str()))
    {
        FatalError("Failed to init PhysFS:\n%s\n", PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
    }

    if (argv::Find('?', NULL) >= 0 || argv::Find('h', "help") >= 0)
    {
        ShowInfo();
        exit(EXIT_SUCCESS);
    }
    else if (argv::Find(0, "version") >= 0)
    {
        ShowVersion();
        exit(EXIT_SUCCESS);
    }

    int batch_arg = argv::Find('o', "output");
    if (batch_arg >= 0)
    {
        if (batch_arg + 1 >= argv::list.size() || argv::IsOption(batch_arg + 1))
        {
            FatalError("OBSIDIAN ERROR: missing filename for --output\n");
            exit(EXIT_FAILURE);
        }

        batch_output_file = argv::list[batch_arg + 1];
    }

    if (int update_arg = argv::Find('u', "update"); update_arg >= 0)
    {
        if (update_arg + 3 >= argv::list.size() || argv::IsOption(update_arg + 1) || argv::IsOption(update_arg + 2) ||
            argv::IsOption(update_arg + 3))
        {
            FatalError("OBSIDIAN ERROR: missing one or more args for --update "
                       "<section> <key> <value>\n");
            exit(EXIT_FAILURE);
        }
        if (argv::list[update_arg + 1].length() > 1)
        {
            FatalError("OBSIDIAN ERROR: section name must be one character\n");
            exit(EXIT_FAILURE);
        }
        char section = argv::list[update_arg + 1][0];
        if (section != 'c' && section != 'o')
        {
            FatalError("OBSIDIAN ERROR: section name must be 'c' or 'o'\n");
            exit(EXIT_FAILURE);
        }
        update_kv.section = section;
        update_kv.key     = argv::list[update_arg + 2];
        update_kv.value   = argv::list[update_arg + 3];
    }

    Determine_WorkingPath();
    Determine_InstallDir();
    Trans_Init();
    Determine_ConfigFile();
    Determine_OptionsFile();
    Determine_LoggingFile();
    Determine_ReferenceFile();

    Options_Load(options_file);

    Options_ParseArguments();

    LogInit(logging_file);

    if (argv::Find('p', "printref") >= 0)
    {
        RefInit(reference_file);
    }

    // accept -t and --terminal for backwards compatibility
    if (argv::Find('v', "verbose") >= 0 || argv::Find('t', "terminal") >= 0)
    {
        LogEnableTerminal(true);
    }

    LogPrint("\n");
    LogPrint("********************************************************\n");
    LogPrint("** %s %s \"%s\" **\n", OBSIDIAN_TITLE.c_str(), OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str());
    LogPrint("** Build %s **\n", OBSIDIAN_VERSION);
    LogPrint("********************************************************\n");
    LogPrint("\n");

    LogPrint("home_dir: %s\n", home_dir.c_str());
    LogPrint("install_dir: %s\n", install_dir.c_str());
    LogPrint("config_file: %s\n\n", config_file.c_str());

    if (argv::Find('d', "debug") >= 0)
    {
        debug_messages = true;
    }
    // Grab current numeric locale
    numeric_locale = setlocale(LC_NUMERIC, NULL);

    LogEnableDebug(debug_messages);

    Main_CalcNewSeed();

    std::string load_file;

    VFS_InitAddons();

    if (const int load_arg = argv::Find('l', "load"); load_arg >= 0)
    {
        if (load_arg + 1 >= argv::list.size() || argv::IsOption(load_arg + 1))
        {
            FatalError("OBSIDIAN ERROR: missing filename for --load\n");
            exit(EXIT_FAILURE);
        }

        load_file = argv::list[load_arg + 1];
    }

    VFS_ParseCommandLine();

    Script_Open();

    if (mature_word_lists)
    {
        ob_set_config("mature_words", "yes");
    }
    else
    {
        ob_set_config("mature_words", "no");
    }

    Module_Defaults();

    if (argv::Find('p', "printref") >= 0)
    {
        ob_print_reference();
        RefClose();
        Main::Shutdown(false);
        return 0;
    }

    if (argv::Find(0, "printref-json") >= 0)
    {
        ob_print_reference_json();
        Main::Shutdown(false);
        return 0;
    }

    if (!load_file.empty())
    {
        if (!Cookie_Load(load_file))
        {
            FatalError(_("No such config file: %s\n"), load_file.c_str());
        }
    }
    else
    {
        if (!FileExists(config_file))
        {
            Cookie_Save(config_file);
        }
        if (!Cookie_Load(config_file))
        {
            FatalError(_("No such config file: %s\n"), config_file.c_str());
        }
    }

    Cookie_ParseArguments();

    if (argv::Find('u', "update") >= 0)
    {
        switch (update_kv.section)
        {
        case 'c':
            ob_set_config(update_kv.key, update_kv.value);
            break;
        case 'o':
            Parse_Option(update_kv.key, update_kv.value);
            break;
        }
        Options_Save(options_file);
        Cookie_Save(config_file);
        Main::Shutdown(false);
        return 0;
    }

    if (batch_output_file.empty())
    {
        switch (filename_prefix)
        {
        case 0:
            ob_set_config("filename_prefix", "datetime");
            break;
        case 1:
            ob_set_config("filename_prefix", "numlevels");
            break;
        case 2:
            ob_set_config("filename_prefix", "game");
            break;
        case 3:
            ob_set_config("filename_prefix", "port");
            break;
        case 4:
            ob_set_config("filename_prefix", "theme");
            break;
        case 5:
            ob_set_config("filename_prefix", "version");
            break;
        case 6:
            ob_set_config("filename_prefix", "custom");
            break;
        case 7:
            ob_set_config("filename_prefix", "none");
            break;
        default:
            ob_set_config("filename_prefix", "datetime");
            break;
        }
        batch_output_file = ob_default_filename();
    }

#ifdef OBSIDIAN_ENABLE_GUI
    /* Platform */
    SDL_Window *win;
    SDL_Renderer *renderer;
    bool running = true;
    float font_scale = 1;
    int render_w = 0;
    int render_h = 0;

    /* GUI */
    struct nk_context *ctx;
    struct nk_colorf bg;

    /* SDL setup */
    SDL_Init(SDL_INIT_VIDEO);

    std::string win_title = StringFormat("%s v%s \"%s\"", OBSIDIAN_TITLE.c_str(), OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str());

    win = SDL_CreateWindow(win_title.c_str(), WINDOW_WIDTH, WINDOW_HEIGHT, SDL_WINDOW_HIGH_PIXEL_DENSITY|SDL_WINDOW_RESIZABLE);

    if (win == NULL) {
        SDL_Log("Error SDL_CreateWindow %s", SDL_GetError());
        exit(-1);
    }

    renderer = SDL_CreateRenderer(win, NULL);

    if (renderer == NULL) {
        SDL_Log("Error SDL_CreateRenderer %s", SDL_GetError());
        exit(-1);
    }

    /* scale the renderer output for High-DPI displays */
    {
        int render_w, render_h;
        int window_w, window_h;
        float scale_x, scale_y;
        SDL_GetCurrentRenderOutputSize(renderer, &render_w, &render_h);
        SDL_GetWindowSize(win, &window_w, &window_h);
        scale_x = (float)(render_w) / (float)(window_w);
        scale_y = (float)(render_h) / (float)(window_h);
        SDL_SetRenderScale(renderer, scale_x, scale_y);
        font_scale = scale_y;
    }

    /* GUI */
    ctx = nk_sdl_init(win, renderer);

    if (!ob_gui_init_ctx(ctx))
    {
        goto cleanup;
    }

    {
        struct nk_font_atlas *atlas;

        /* set up the font atlas and add desired font; note that font sizes are
         * multiplied by font_scale to produce better results at higher DPIs */
        nk_sdl_font_stash_begin(&atlas);

        if (!ob_gui_init_fonts(atlas, font_scale))
        {
            // Fallback to default font
            struct nk_font_config config = nk_font_config(0);
            struct nk_font *font = nk_font_atlas_add_default(atlas, 22 * font_scale, &config);
            nk_sdl_font_stash_end();
            font->handle.height /= font_scale;
            nk_style_set_font(ctx, &font->handle);
        }
        else
            nk_sdl_font_stash_end();
    }

    bg.r = 0.10f, bg.g = 0.18f, bg.b = 0.24f, bg.a = 1.0f;
    while (running)
    {
        /* Input */
        SDL_Event evt;
        nk_input_begin(ctx);
        while (SDL_PollEvent(&evt)) {
            if (evt.type == SDL_EVENT_QUIT)
                goto cleanup;
            if (!in_file_dialog)
                nk_sdl_handle_event(&evt);
        }
        nk_sdl_handle_grab(); /* optional grabbing behavior */
        nk_input_end(ctx);

        SDL_GetCurrentRenderOutputSize(renderer, &render_w, &render_h);

        running = ob_gui_frame(render_w, render_h);

        SDL_SetRenderDrawColor(renderer, bg.r * 255, bg.g * 255, bg.b * 255, bg.a * 255);
        SDL_RenderClear(renderer);

        nk_sdl_render(NK_ANTI_ALIASING_ON);

        SDL_RenderPresent(renderer);
    }

cleanup:
    nk_sdl_shutdown();
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(win);
    SDL_Quit();
    return 0;
#endif

    Main_SetSeed();
    if (!Build_Cool_Shit())
    {
        FatalError("FAILED!\n");
        LogPrint("FAILED!\n");

        Main::Shutdown(false);
        return EXIT_FAILURE;
    }
    Main::Shutdown(false);
    return 0;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
