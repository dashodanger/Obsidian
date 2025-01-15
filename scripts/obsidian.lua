------------------------------------------------------------------------
--  OBSIDIAN  :  INTERFACE WITH GUI CODE
------------------------------------------------------------------------
--
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2019-2023 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

gui.import("defs")
gui.import("shapes")
gui.import("util")
gui.import("brush")
gui.import("prefab")
gui.import("autodetail")

gui.import("seed")
--gui.import("shapes")
gui.import("grower")
gui.import("area")
gui.import("connect")
gui.import("quest")

gui.import("automata")
gui.import("cave")
gui.import("layout")
gui.import("render")
gui.import("room")

gui.import("fight")
gui.import("monster")
gui.import("item")
gui.import("naming")
gui.import("title_gen")
gui.import("level")

gui.import("script_manager")

gui.set_import_dir("data/text/")

gui.import("random_words_en.lua")
gui.import("random_words_en_m.lua")
gui.import("dialogues.lua")

gui.set_import_dir("")

gui.import("094/oblige_v094.lua")

function ob_ref_table(op, t)
  if not gui.___REFS then
    gui.___REFS = {}
  end

  if op == "clear" then
    gui.___REFS = {}
    collectgarbage("collect")
    return
  end

  if op == "store" then
    if t == _G then return 0 end
    local id = 1 + #gui.___REFS
    gui.___REFS[id] = t    -- t == table
    return id
  end

  if op == "lookup" then
    if t == 0 then return _G end
    return gui.___REFS[t]  -- t == id number
  end

  error("ob_ref_table: unknown op: " .. tostring(op))
end


------------------------------------------------------------------------

function ob_datetime_format_string()
  local current_date = os.date("*t")

  local formatstring

  if current_date.month < 10 then
    formatstring = "0%M"
  else
    formatstring = "%M"
  end
  if current_date.day < 10 then
    formatstring = formatstring .. "-0%D"
  else
    formatstring = formatstring .. "-%D"
  end
  
  formatstring = "%Y-" .. formatstring .. "-"

  if current_date.hour < 10 then
    formatstring = formatstring .. "0%h"
  else
    formatstring = formatstring .. "%h"
  end

  if current_date.min < 10 then
    formatstring = formatstring .. "0%m"
  else
    formatstring = formatstring .. "%m"
  end

  return formatstring
end

function ob_check_ui_module(def)
  return string.match(def.name, "^ui") ~= nil
end



function ob_match_word_or_table(tab, conf)
  if type(tab) == "table" then
    return tab[conf] and tab[conf] > 0
  else
    return tab == conf
  end
end



function ob_match_game(T)
  if not T.game then return true end
  if T.game == "any" then return true end

  -- special check: if required game is "doomish" then allow any
  -- of the DOOM games to match.
  if T.game == "doomish" then
     T.game = { doom1=1, doom2=1 }
  end

  local game   = T.game
  local result = true

  -- negated check?
  if type(game) == "string" and string.sub(game, 1, 1) == '!' then
    game   = string.sub(game, 2)
    result = not result
  end

  -- normal check
  if ob_match_word_or_table(game, OB_CONFIG.game) then
    return result
  end

  -- handle extended games
  local game_def = OB_GAMES[OB_CONFIG.game]

  while game_def do
    if not game_def.extends then
      break;
    end

    if ob_match_word_or_table(game, game_def.extends) then
      return result
    end

    game_def = OB_GAMES[game_def.extends]
  end

  return not result
end


function ob_match_engine(T)
  if not T.engine then return true end
  if T.engine == "any" then return true end

  local engine = T.engine
  local result = true

  -- negated check?
  if type(engine) == "string" and string.sub(engine, 1, 1) == '!' then
    engine = string.sub(engine, 2)
    result = not result
  end

  -- normal check
  if ob_match_word_or_table(engine, OB_CONFIG.engine) then
    return result
  end
  
  

  -- handle extended engines

  local engine_def = OB_ENGINES[OB_CONFIG.engine]

  while engine_def do
    if not engine_def.extends then
      break;
    end

    if ob_match_word_or_table(engine, engine_def.extends) then
      return result
    end

    engine_def = OB_ENGINES[engine_def.extends]
  end

  return not result
end

function ob_match_port(T)
  if not T.port then return true end
  if T.port == "any" then return true end

  local port = T.port
  local result = true

  -- negated check?
  if type(port) == "string" and string.sub(port, 1, 1) == '!' then
    port = string.sub(port, 2)
    result = not result
  end

  -- normal check
  if ob_match_word_or_table(port, OB_CONFIG.port) then
    return result
  end
  
  

  -- handle extended ports

  local port_def = OB_PORTS[OB_CONFIG.port]

  while port_def do
    if not port_def.extends then
      break;
    end

    if ob_match_word_or_table(port, port_def.extends) then
      return result
    end

    port_def = OB_PORTS[port_def.extends]
  end

  return not result
end

function ob_match_port2(T)
  if not T.port2 then return true end
  if T.port2 == "any" then return true end

  local port = T.port2
  local result = true

  -- negated check?
  if type(port) == "string" and string.sub(port, 1, 1) == '!' then
    port = string.sub(port, 2)
    result = not result
  end

  -- normal check
  if ob_match_word_or_table(port, OB_CONFIG.port) then
    return result
  end
  
  

  -- handle extended ports

  local port_def = OB_PORTS[OB_CONFIG.port]

  while port_def do
    if not port_def.extends then
      break;
    end

    if ob_match_word_or_table(port, port_def.extends) then
      return result
    end

    port_def = OB_PORTS[port_def.extends]
  end

  return not result
end

function ob_match_port3(T)
  if not T.port3 then return true end
  if T.port3 == "any" then return true end

  local port = T.port3
  local result = true

  -- negated check?
  if type(port) == "string" and string.sub(port, 1, 1) == '!' then
    port = string.sub(port, 2)
    result = not result
  end

  -- normal check
  if ob_match_word_or_table(port, OB_CONFIG.port) then
    return result
  end


  -- handle extended ports

  local port_def = OB_PORTS[OB_CONFIG.port]

  while port_def do
    if not port_def.extends then
      break;
    end

    if ob_match_word_or_table(port, port_def.extends) then
      return result
    end

    port_def = OB_PORTS[port_def.extends]
  end

  return not result
end

function ob_match_port4(T)
  if not T.port4 then return true end
  if T.port4 == "any" then return true end

  local port = T.port4
  local result = true

  -- negated check?
  if type(port) == "string" and string.sub(port, 1, 1) == '!' then
    port = string.sub(port, 2)
    result = not result
  end

  -- normal check
  if ob_match_word_or_table(port, OB_CONFIG.port) then
    return result
  end
  
  

  -- handle extended ports

  local port_def = OB_PORTS[OB_CONFIG.port]

  while port_def do
    if not port_def.extends then
      break;
    end

    if ob_match_word_or_table(port, port_def.extends) then
      return result
    end

    port_def = OB_PORTS[port_def.extends]
  end

  return not result
end

function ob_match_level_theme(LEVEL, T, override)
  if not T.theme then return true end
  if T.theme == "any" then return true end

  -- if match theme toggle is disabled, everything qualifies
  if PARAM.bool_fab_match_theme == 0 then return true end

  local level_theme_name = LEVEL.theme_name
  if override then
    level_theme_name = override
  end

  local theme  = T.theme
  local result = true

  -- negated check?
  if type(theme) == "string" and string.sub(theme, 1, 1) == '!' then
    theme  = string.sub(theme, 2)
    result = not result
  end

  -- MSSP-REVIEW: These hack fixes should probably be more generalized elsewhere
  -- for future-proofing.

  -- hack fix for Deimos theme. It is now to use tech and hell defs altogether.
  if level_theme_name == "deimos"
    and (theme == "tech"
    or theme == "hell"
    or theme == "any"
    or not theme) then
    return result
  end

  -- hack fix for Thy Flesh theme too. Basically combine urban and hell fabs.
  if level_theme_name == "flesh"
    and (theme == "urban"
    or theme == "hell"
    or theme == "any"
    or not theme) then
    return result
  end

  -- hack fix for TNT's Egypt theme, sigh
  if level_theme_name == "egypt"
    and (theme == "any"
    or theme == "hell"
    or not theme) then
    return result
  end

  -- normal check
  if ob_match_word_or_table(theme, level_theme_name) then
    return result
  end

  return not result
end


function ob_match_module(T)
  if not T.module then return true end

  local mod_tab = T.module

  if type(mod_tab) ~= "table" then
    mod_tab  = { [T.module]=1 }
    T.module = mod_tab
  end

  -- require ALL specified modules to be present and enabled

  for _,name in pairs(mod_tab) do
    local def = OB_MODULES[name]

    if not (def and def.shown and def.enabled) then
      return false
    end
  end

  return true
end


function ob_match_feature(T)
  if not T.feature then return true end

  local feat_tab = T.feature

  if type(feat_tab) ~= "table" then
    feat_tab  = { [T.feature]=1 }
    T.feature = feat_tab
  end

  -- require ALL specified features to be available

  for _,name in pairs(feat_tab) do
    local param = PARAM[name]

    if param == nil or param == false then
      return false
    end
  end

  return true
end



function ob_match_conf(T)
  assert(OB_CONFIG.engine)
  assert(OB_CONFIG.game)
  assert(OB_CONFIG.port)

  if not ob_match_engine(T)     then return false end
  if not ob_match_game(T)     then return false end
  if not ob_match_port(T)   then return false end
  if not ob_match_port2(T)  then return false end
  if not ob_match_port3(T)  then return false end
  if not ob_match_port4(T)  then return false end
  if not ob_match_module(T)   then return false end

  return true --OK--
end



function ob_resolve_theme_keyword(T)
  local keys =
  {
    deimos =
    {
      "tech",
      "hell"
    },

    industrial =
    {
      "tech",
      "urban"
    },

    flesh =
    {
      "hell",
      "urban"
    }
  }

  if keys[T] then
    return rand.pick(keys[T])
  end

  return T
end




function ob_update_games()
  local need_new = false

  for name,def in pairs(OB_GAMES) do
    local shown = ob_match_conf(def)

    if not shown and (OB_CONFIG.game == name) then
      need_new = true
    end

    gui.enable_choice("game", name, shown)
  end

  if need_new then
    if OB_CONFIG.engine == "idtech_0" then
      OB_CONFIG.game = "wolf"
    else
      OB_CONFIG.game = "doom2"
    end
    gui.set_button("game", OB_CONFIG.game)
  end
end

function ob_update_ports()
  local need_new = false

  for name,def in pairs(OB_PORTS) do
    local shown = ob_match_conf(def)

    if not shown and (OB_CONFIG.port == name) then
      need_new = true
    end

    gui.enable_choice("port", name, shown)
  end

  if need_new then
    if OB_CONFIG.engine == "idtech_0" then
      OB_CONFIG.port = "vanilla"
    elseif OB_CONFIG.engine == "idtech_1" then
      if OB_CONFIG.game == "chex1" or OB_CONFIG.game == "hacx" or OB_CONFIG.game == "harmony" or OB_CONFIG.game == "strife" or OB_CONFIG.game == "rekkr" then  -- Ugh
        OB_CONFIG.port = "limit_enforcing"
      else
        OB_CONFIG.port = "boom"
      end
    else -- shouldn't get here - Dasho
      OB_CONFIG.port = "vanilla"
    end
    gui.set_button("port", OB_CONFIG.port)
  end
end

function ob_update_themes()
  local new_label

  for name,def in pairs(OB_THEMES) do
    local shown = ob_match_conf(def)

    if not shown and (OB_CONFIG.theme == name) then
      new_label = def.label
    end

    def.shown = shown
    gui.enable_choice("theme", name, def.shown)
  end

  -- try to keep the same GUI label
  if new_label then
    for name,def in pairs(OB_THEMES) do
      local shown = ob_match_conf(def)

      if shown and def.label == new_label then
        OB_CONFIG.theme = name
        gui.set_button("theme", OB_CONFIG.theme)
        return
      end
    end

    -- otherwise revert to As Original
    if OB_CONFIG.port == "limit_enforcing" then
      OB_CONFIG.theme = "default"
    else
      OB_CONFIG.theme = "original"
    end
    gui.set_button("theme", OB_CONFIG.theme)
  end
end



function ob_update_modules()
  -- modules may depend on other modules, hence we may need
  -- to repeat this multiple times until all the dependencies
  -- have flowed through.

  for loop = 1,100 do
    local changed = false

    for name,def in pairs(OB_MODULES) do
      local shown = ob_match_conf(def)

      if shown ~= def.shown then
        changed = true
      end

      def.shown = shown
      gui.show_module(name, def.shown)
    end

    if not changed then break; end
  end
end



function ob_update_all()
  ob_update_games()
  ob_update_ports()
  ob_update_modules()
  ob_update_themes()
end



function ob_find_mod_option(mod, opt_name)
  if not mod.options then return nil end

  -- if 'options' is a list, search it one-by-one
  if mod.options[1] then
    for _,opt in pairs(mod.options) do
      if opt.name == opt_name then
        return opt
      end
    end
  end

  return mod.options[opt_name]
end


function ob_defs_conflict(def1, def2)
  if not def1.conflicts then return false end
  if not def2.conflicts then return false end

  for name,_ in pairs(def1.conflicts) do
    if def2.conflicts[name] then
      return true
    end
  end

  return false
end


function ob_set_mod_option(name, option, value)
  local mod = OB_MODULES[name]
  if not mod then
    gui.printf("Ignoring unknown module: %s\n", name)
    return
  end

  if option == "self" then
    -- convert 'value' from string to a boolean
    value = not (value == "false" or value == "0")

    if mod.enabled == value then
      return -- no change
    end

    mod.enabled = value

    -- handle conflicting modules (like Radio buttons)
    if value then
      for other,odef in pairs(OB_MODULES) do
        if odef ~= mod and ob_defs_conflict(mod, odef) then
          odef.enabled = false
          gui.set_module(other, odef.enabled)
        end
      end
    end

    -- this is required for parsing the CONFIG.TXT file
    -- [but redundant when the user merely changed the widget]
    gui.set_module(name, mod.enabled)

    ob_update_all()
    return
  end


  local opt = ob_find_mod_option(mod, option)
  if not opt then
    gui.printf("Ignoring unknown option: %s.%s\n", name, option)
    return
  end

  -- this can only happen while parsing the CONFIG.TXT file
  -- (containing some no-longer-used value).
  if not opt.valuator then 
    if not opt.avail_choices[value] then
      warning("invalid choice: %s (for option %s.%s)\n", value, name, option)
      return
    end
  end

  opt.value = value
  
  if not opt.valuator then
    gui.set_module_option(name, option, value)
  else
    if opt.valuator == "slider" then
      gui.set_module_slider_option(name, option, value)
    elseif opt.valuator == "button" then
      gui.set_module_button_option(name, option, tonumber(value))
    end
  end

  -- no need to call ob_update_all
  -- (nothing ever depends on custom options)
end

function ob_mod_enabled(name)
  local mod = OB_MODULES[name]
  if not mod then
    gui.printf("ob_mod_enabled: Ignoring unknown module: %s\n", name)
    return 0
  else
    if mod.enabled and mod.shown then return 1 else return 0 end
  end
end

function ob_set_config(name, value)
  -- See the document 'doc/Config_Flow.txt' for a good
  -- description of the flow of configuration values
  -- between the C++ GUI and the Lua scripts.

  assert(name and value)

  if name == "seed" then
    OB_CONFIG[name] = value or 0
    return
  end
  
  if name == "filename_prefix" then
    OB_CONFIG[name] = value
    return
  end
  
  if name == "string_seed" then
    OB_CONFIG[name] = value
    return
  end   

  -- check all the UI modules for a matching option
  -- [ this is only needed when parsing the CONFIG.txt file ]
  for _,mod in pairs(OB_MODULES) do
    if ob_check_ui_module(mod) then
      for _,opt in pairs(mod.options) do
        if opt.name == name then
          ob_set_mod_option(mod.name, name, value)
          if OB_CONFIG.batch == "yes" then
            OB_CONFIG[name] = value
          end
          return
        end
      end
    end
  end


  if OB_CONFIG[name] and OB_CONFIG[name] == value then
    return -- no change
  end


  -- validate some important variables
  if name == "engine" then
    assert(OB_CONFIG.engine)
    if not OB_ENGINES[value] then
      gui.printf("Ignoring unknown engine: %s\n", value)
      return
    end
  elseif name == "game" then
      assert(OB_CONFIG.game)
      if not OB_GAMES[value] then
        gui.printf("Ignoring unknown game: %s\n", value)
        return
      end
  elseif name == "port" then
    assert(OB_CONFIG.port)
    if not OB_PORTS[value] then
      gui.printf("Ignoring unknown port: %s\n", value)
      return
    end
  elseif name == "theme" then
    assert(OB_CONFIG.theme)
    if not OB_THEMES[value] then
      gui.printf("Ignoring unknown theme: %s\n", value)
      return
    end
  end

  OB_CONFIG[name] = value

  if name == "engine" or name == "game" or name == "port" then
    ob_update_all()
  end

  -- this is required for parsing the CONFIG.TXT file
  -- [ but redundant when the user merely changed the widget ]
  if name == "game"  or name == "engine" or name == "port"
     or name == "theme" or name == "length"
  then
    gui.set_button(name, OB_CONFIG[name])
  end
end



function ob_read_all_config(need_full, log_only)
   
  local function do_line(fmt, ...)
    if log_only then
      gui.printf(fmt .. "\n", ...)
    else
      gui.config_line(string.format(fmt, ...))
    end
  end

  local function do_value(name, value)
    do_line("%s = %s", name, value or "XXX")
  end

  local function do_mod_value(name, value)
    do_line("  %s = %s", name, value or "XXX")
  end

  ---| ob_read_all_config |---

  -- workaround for a limitation in C++ code
  if need_full == "" then
     need_full = false
  end

  do_line("-- Obsidian (C) 2018-2023")
  do_line("-- MsrSgtShooterPerson")
  do_line("-- Reisal")
  do_line("-- Garrett")
  do_line("-- Caligari87")
  do_line("-- Frozsoul")
  do_line("-- Simon-v")
  do_line("-- Beed28")
  do_line("-- Craneo")
  do_line("-- MogWaltz")
  do_line("-- EpicTyphlosion")
  do_line("-- Tapwave")
  do_line("-- Swedra")
  do_line("-- Demios")
  do_line("-- Scionox")
  do_line("-- josh771")
  do_line("-- dashodanger")
  do_line("-- Phytolizer")
  do_line("-- HugLifeTiZ\n")
  do_line("-- Cubebert\n")
  do_line("-- Morthimer McMare\n")
  do_line("-- ika707\n")
  do_line("-- Chameleon_111\n")
  do_line("-- hytalego\n")
  do_line("-- Twin Galaxy\n")
  do_line("-- WolVexus\n")
  do_line("-- username\n")
  do_line("-- Dan_The_Noob\n")
  do_line("-- Il Str\n")
  do_line("-- VoidRunner\n")
  do_line("-- 4ffy\n")
  do_line("-- DasCake\n")
  do_line("-- Baysha\n")
  do_line("-- Arcterezion\n")
  do_line("-- Xenamta\n")
  do_line("-- KadKad1\n")
  do_line("-- DaveFriedLiver\n")
  do_line("-- https://github.com/obsidian-level-maker/Obsidian/\n")

  if OB_CONFIG.seed and OB_CONFIG.seed ~= 0 then
    if OB_CONFIG.string_seed then
      do_line("seed = " .. OB_CONFIG.string_seed)
      do_line("")
    else
      do_line("seed = " .. OB_CONFIG.seed)
      do_line("")
    end
  end

  do_line("---- Game Settings ----")
  do_line("")

  do_value("engine",   OB_CONFIG.engine)
  do_value("game",     OB_CONFIG.game)
  do_value("port",     OB_CONFIG.port)
  do_value("length",   OB_CONFIG.length)
  do_value("theme",    OB_CONFIG.theme)

  do_line("")

  -- the UI modules/panels use bare option names
  for _,name in pairs(table.keys_sorted(OB_MODULES)) do
    local def = OB_MODULES[name]

    if ob_check_ui_module(def) then
      do_line("---- %s ----", def.label)
      do_line("")

      for _,opt in pairs(def.options) do
        if string.match(opt.name, "header_") then goto justaheader end
        if string.match(opt.name, "url_") then goto justaheader end
        if string.match(opt.name, "float_") then
            if OB_CONFIG.batch == "yes" then
              if OB_CONFIG[opt.name] then
                do_value(opt.name, OB_CONFIG[opt.name])
              else
                do_value(opt.name, opt.default)
                ob_set_config(opt.name, opt.default)
              end
            else
              do_value(opt.name, gui.get_module_slider_value(name, opt.name))
            end
        elseif string.match(opt.name, "bool_") then
            if OB_CONFIG.batch == "yes" then
              if OB_CONFIG[opt.name] then
                do_value(opt.name, OB_CONFIG[opt.name])
              else
                do_value(opt.name, opt.default)
                ob_set_config(opt.name, opt.default)
              end
            else
              do_value(opt.name, gui.get_module_button_value(name, opt.name))
            end
        else
          if OB_CONFIG.batch == "yes" then
            if OB_CONFIG[opt.name] then
              do_value(opt.name, OB_CONFIG[opt.name])
            else
              do_value(opt.name, opt.default)
              ob_set_config(opt.name, opt.default)
            end
          else
            do_value(opt.name, opt.value)
          end
        end
        ::justaheader::
      end

      do_line("")
    end
  end

  do_line("---- Other Modules ----")
  do_line("")

  for _,name in pairs(table.keys_sorted(OB_MODULES)) do
    local def = OB_MODULES[name]

    if ob_check_ui_module(def) then goto continue end

    if not need_full and not def.shown then goto continue end

    do_line("@%s = %s", name, sel(def.enabled, "1", "0"))

    -- module options
    if need_full or def.enabled then
      if def.options and not table.empty(def.options) then
        if def.options[1] then
          for _,opt in pairs(def.options) do
            if string.match(opt.name, "header_") then goto justaheader end
            if string.match(opt.name, "url_") then goto justaheader end
            if string.match(opt.name, "float_") then
                if OB_CONFIG.batch == "yes" then
                  if OB_CONFIG[opt.name] then
                    do_mod_value(opt.name, OB_CONFIG[opt.name])
                  else
                    do_mod_value(opt.name, opt.default)
                    ob_set_config(opt.name, opt.default)
                  end
                else
                  do_mod_value(opt.name, gui.get_module_slider_value(name, opt.name))
                end
            elseif string.match(opt.name, "bool_") then
                if OB_CONFIG.batch == "yes" then
                  if OB_CONFIG[opt.name] then
                    do_mod_value(opt.name, OB_CONFIG[opt.name])
                  else
                    do_mod_value(opt.name, opt.default)
                    ob_set_config(opt.name, opt.default)
                  end
                else
                  do_mod_value(opt.name, gui.get_module_button_value(name, opt.name))
                end
            else
              if OB_CONFIG.batch == "yes" then
                if OB_CONFIG[opt.name] then
                  do_mod_value(opt.name, OB_CONFIG[opt.name])
                else
                  do_mod_value(opt.name, opt.default)
                  ob_set_config(opt.name, opt.default)
                end
              else
                do_mod_value(opt.name, opt.value)
              end
            end
            ::justaheader::
          end
        else
          for o_name,opt in pairs(def.options) do
            if string.match(o_name, "float_") then
                if OB_CONFIG.batch == "yes" then
                  if OB_CONFIG[opt.name] then
                    do_mod_value(o_name, OB_CONFIG[opt.name])
                  else
                    do_mod_value(o_name, opt.default)
                    ob_set_config(o_name, opt.default)
                  end
                else
                  do_mod_value(o_name, gui.get_module_slider_value(name, opt.name))
                end
            elseif string.match(o_name, "bool_") then
                if OB_CONFIG.batch == "yes" then
                  if OB_CONFIG[opt.name] then
                    do_mod_value(o_name, OB_CONFIG[opt.name])
                  else
                    do_mod_value(o_name, opt.default)
                    ob_set_config(o_name, opt.default)
                  end
                else
                  do_mod_value(o_name, gui.get_module_button_value(name, opt.name))
                end
            else
              if OB_CONFIG.batch == "yes" then
                if OB_CONFIG[opt.name] then
                  do_mod_value(o_name, OB_CONFIG[opt.name])
                else
                  do_mod_value(o_name, opt.default)
                  ob_set_config(o_name, opt.default)
                end
              else
                do_mod_value(o_name, opt.value)
              end
            end
          end
        end
      end
    end

    do_line("")
    ::continue::
  end

  do_line("-- END --")
end



function ob_load_game(game)
  -- 'game' parameter must be a sub-directory of the games/ folder

  -- ignore the template game -- it is only instructional
  if game == "template" then return end

  gui.debugf("  %s\n", game)

  gui.set_import_dir("games/" .. game)

  -- the base script will import even more script files
  gui.import("base")

  gui.set_import_dir("")
end


function ob_load_all_games()

  local list = gui.scan_directory("games", "DIRS")

  if not list then
    error("Failed to scan 'games' directory")
  end

  if OB_CONFIG.only_game then
    gui.printf("Only loading one game: '%s'\n", OB_CONFIG.only_game)
    ob_load_game(OB_CONFIG.only_game)
  else
    for _,game in pairs(list) do
      ob_load_game(game)
    end
  end

  if table.empty(OB_GAMES) then
    error("Failed to load any games at all")
  end
end


function ob_load_all_engines()

  local list = gui.scan_directory("engines", "*.lua")

  if not list then
    gui.printf("FAILED: scan 'engines' directory\n")
    return
  end

  gui.set_import_dir("engines")

  for _,filename in pairs(list) do
    gui.debugf("  %s\n", filename)
    gui.import(filename)
  end

  gui.set_import_dir("")
end

function ob_load_all_ports()

  local list = gui.scan_directory("ports", "*.lua")

  if not list then
    gui.printf("FAILED: scan 'ports' directory\n")
    return
  end

  gui.set_import_dir("ports")

  for _,filename in pairs(list) do
    gui.debugf("  %s\n", filename)
    gui.import(filename)
  end

  gui.set_import_dir("")
end

function ob_load_all_modules()

  local list = gui.scan_directory("modules", "*.lua")
  local subdirs = gui.scan_directory("modules", "DIRS")

  if not list then
    gui.printf("FAILED: scan 'modules' directory\n")
    return
  end

  gui.set_import_dir("modules")

  for  _,filename in pairs(list) do
    gui.debugf("  %s\n", filename)
    gui.import(filename)
  end

  if subdirs then
    for _,directory in pairs(subdirs) do
      list = gui.scan_directory("modules/" .. directory, "*.lua")
      if not list then
        gui.printf("FAILED: scan 'modules' subdirectory\n")
        return
      end
      gui.set_import_dir("modules/" .. directory)
      for _,filename in pairs(list) do
        gui.debugf("  %s\n", filename)
        gui.import(filename)
      end
    end
  end

  gui.set_import_dir("")
end

function ob_restart()

  -- the missing print functions
  gui.printf = function (fmt, ...)
    if fmt then gui.raw_log_print(string.format(fmt, ...)) end
  end

  gui.debugf = function (fmt, ...)
    if fmt then gui.raw_debug_print(string.format(fmt, ...)) end
  end

  -- load definitions for all games
  
  ob_load_all_engines()
  ob_load_all_games()
  ob_load_all_ports()
  ob_load_all_modules()

  table.name_up(OB_ENGINES)
  table.name_up(OB_GAMES)
  table.name_up(OB_PORTS)
  table.name_up(OB_THEMES)
  table.name_up(OB_MODULES)


  local function preinit_all(DEFS)
    local removed = {}

    for name,def in pairs(DEFS) do
      if def.preinit_func then
        if def.preinit_func(def) == REMOVE_ME then
          table.insert(removed, name)
        end
      end
    end

    for _,name in pairs(removed) do
      DEFS[name] = nil
    end
  end

  preinit_all(OB_ENGINES)
  preinit_all(OB_GAMES)
  preinit_all(OB_PORTS)
  preinit_all(OB_THEMES)
  preinit_all(OB_MODULES)


  local function button_sorter(A, B)
    if A.priority or B.priority then
      return (A.priority or 50) > (B.priority or 50)
    end

    return A.label < B.label
  end


  local function create_buttons(what, DEFS)
    assert(DEFS)

    local list = {}

    local min_priority = 999

    for name,def in pairs(DEFS) do
      assert(def.name and def.label)
      table.insert(list, def)
      min_priority = math.min(min_priority, def.priority or 50)
    end

    -- add separators for the Theme menus
    if what == "theme" and min_priority < 79 then
      table.insert(list, { priority=79, name="_", label="_" })
    end

    table.sort(list, button_sorter)

    for _,def in pairs(list) do
      if what == "module" then
        local where = def.where or "other"
        local suboptions
        assert(def.name and def.label)
        if where == "links" then
          suboptions = 1
        else
          suboptions = 0
        end
        if def.color then
          gui.add_module(where, def.name, def.label, def.tooltip, def.color["red"], def.color["green"], def.color["blue"], suboptions)
        else
          gui.add_module(where, def.name, def.label, def.tooltip, nil, nil, nil, suboptions)
        end
      else
        gui.add_choice(what, def.name, def.label)
      end

      -- TODO : review this, does it belong HERE ?
      if what == "engine" then
        assert(def.name)
        gui.enable_choice("engine", def.name, true)
      end
    end

    -- set the current value
    if what ~= "module" then
      local default = list[1] and list[1].name

      OB_CONFIG[what] = default
    end
  end


  local function simple_buttons(what, choices, default)
    for i = 1,#choices,2 do
      local id    = choices[i]
      local label = choices[i+1]

      gui.   add_choice(what, id, label)
      gui.enable_choice(what, id, true)
    end

    OB_CONFIG[what] = default
  end


  local function create_mod_options()

    for _,mod in pairs(OB_MODULES) do
      if not mod.options then
        mod.options = {}
      else
        local list = mod.options

        -- handle lists (for UI modules) different from key/value tables
        if list[1] == nil then
          list = {}

          for name,opt in pairs(mod.options) do
            opt.name = name
            table.insert(list, opt)
          end

          table.sort(list, button_sorter)
        end

        for _,opt in pairs(list) do
          assert(opt.label)
          if string.match(opt.name, "header_") then
            gui.add_module_header(mod.name, opt.name, opt.label, opt.gap)
            goto justaheader
          end
          if string.match(opt.name, "url_") then
            assert(opt.url)
            gui.add_module_url(mod.name, opt.name, opt.label, opt.url, opt.gap)
            goto justaheader
          end
          if not opt.valuator then
            assert(opt.choices)
          end
                  
          if opt.valuator then
            if opt.valuator == "slider" then
              if not opt.default then
                opt.default = (opt.min + opt.max) / 2
              end
              gui.add_module_slider_option(mod.name, opt.name, opt.label, opt.tooltip, opt.longtip, opt.gap, opt.min, opt.max, opt.increment, opt.units or "", opt.presets or "", opt.nan or "", opt.randomize_group or "", tostring(opt.default))
              opt.value = opt.default
              gui.set_module_slider_option(mod.name, opt.name, opt.value)
            elseif opt.valuator == "button" then
              if not opt.default then
                opt.default = 0
              end
              gui.add_module_button_option(mod.name, opt.name, opt.label, opt.tooltip, opt.longtip, opt.gap, opt.randomize_group or "", tostring(opt.default))
              opt.value = opt.default
              gui.set_module_button_option(mod.name, opt.name, opt.value)
            end
          else
            -- select a default value
            if not opt.default then
              if table.has_elem(opt.choices, "default") then opt.default = "default"
              elseif table.has_elem(opt.choices, "normal")  then opt.default = "normal"
              elseif table.has_elem(opt.choices, "medium")  then opt.default = "medium"
              elseif table.has_elem(opt.choices, "mixed")   then opt.default = "mixed"
              else   opt.default = opt.choices[1]
              end
            end
            gui.add_module_option(mod.name, opt.name, opt.label, opt.tooltip, opt.longtip, opt.gap, opt.randomize_group or "", opt.default)
            opt.avail_choices = {}

            for i = 1,#opt.choices,2 do
              local id    = opt.choices[i]
              local label = opt.choices[i+1]

              gui.add_option_choice(mod.name, opt.name, id, label)
              opt.avail_choices[id] = 1
            end
            opt.value = opt.default
            gui.set_module_option(mod.name, opt.name, opt.value)
          end
          ::justaheader::
        end -- for opt
      end
    end -- for mod
  end


  OB_CONFIG.seed = 0,

  create_buttons("engine",   OB_ENGINES)
  create_buttons("game",   OB_GAMES)
  create_buttons("port", OB_PORTS)
  create_buttons("theme",  OB_THEMES)

  simple_buttons("length",   LENGTH_CHOICES,   "game")

  create_buttons("module", OB_MODULES)
  create_mod_options()

  ob_update_all()

  gui.set_button("engine",   OB_CONFIG.engine)
  gui.set_button("game",     OB_CONFIG.game)
  gui.set_button("port",   OB_CONFIG.port)
  gui.set_button("length",   OB_CONFIG.length)
  gui.set_button("theme",    OB_CONFIG.theme)
end

function ob_init()

  -- the missing print functions
  gui.printf = function (fmt, ...)
    if fmt then gui.raw_log_print(string.format(fmt, ...)) end
  end

  gui.debugf = function (fmt, ...)
    if fmt then gui.raw_debug_print(string.format(fmt, ...)) end
  end

  gui.printf("****************************\n")
  gui.printf("** Obsidian (C) 2018-2025 **\n")
  gui.printf("****************************\n")
  gui.printf("|    A Creation of the     |\n")
  gui.printf("|        Community         |\n")
  gui.printf("\\__________________________/\n\n")
  gui.printf("    MsrSgtShooterPerson\n")
  gui.printf("          Reisal\n")
  gui.printf("          Garrett\n")
  gui.printf("         Caligari87\n")
  gui.printf("          Frozsoul\n")
  gui.printf("          Simon-v\n")
  gui.printf("           Beed28\n")
  gui.printf("          Craneo\n")
  gui.printf("          MogWaltz\n")
  gui.printf("      EpicTyphlosion\n")
  gui.printf("          Tapwave\n")
  gui.printf("          Swedra\n")
  gui.printf("          Demios\n")
  gui.printf("          Scionox\n")
  gui.printf("          josh771\n")
  gui.printf("        dashodanger\n")
  gui.printf("        Phytolizer\n")
  gui.printf("        HugLifeTiZ\n")
  gui.printf("         Cubebert\n")
  gui.printf("     Morthimer McMare\n")
  gui.printf("          ika707\n")
  gui.printf("       Chameleon_111\n")
  gui.printf("         hytalego\n")
  gui.printf("        Twin Galaxy\n")
  gui.printf("         WolVexus\n")
  gui.printf("         username\n")
  gui.printf("       Dan_The_Noob\n")
  gui.printf("         Il Str\n")
  gui.printf("        VoidRunner\n")
  gui.printf("          4ffy\n")
  gui.printf("         DasCake\n")
  gui.printf("         Baysha\n")
  gui.printf("        Arcterezion\n")
  gui.printf("         Xenamta\n")
  gui.printf("         KadKad1\n")
  gui.printf("         DaveFriedLiver\n")
  gui.printf("    And All of Our Fans!\n\n")
  gui.printf("--------------------------------------------\n")
  gui.printf("-- https://github.com/obsidian-level-maker/Obsidian/ --\n")
  gui.printf("--------------------------------------------\n\n")

  gui.printf("~~ Obsidian Lua initialization begun ~~\n\n")


  -- load definitions for all games

  gui.printf("Loading all engines...\n")
  ob_load_all_engines()
  gui.printf("Loading all games...\n")
  ob_load_all_games()
  gui.printf("Loading all ports...\n")
  ob_load_all_ports()
  gui.printf("Loading all modules...\n")
  ob_load_all_modules()

  table.name_up(OB_ENGINES)
  table.name_up(OB_GAMES)
  table.name_up(OB_PORTS)
  table.name_up(OB_THEMES)
  table.name_up(OB_MODULES)


  local function preinit_all(DEFS)
    local removed = {}

    for name,def in pairs(DEFS) do
      if def.preinit_func then
        if def.preinit_func(def) == REMOVE_ME then
          table.insert(removed, name)
        end
      end
    end

    for _,name in pairs(removed) do
      DEFS[name] = nil
    end
  end

  preinit_all(OB_ENGINES)
  preinit_all(OB_GAMES)
  preinit_all(OB_PORTS)
  preinit_all(OB_THEMES)
  preinit_all(OB_MODULES)


  local function button_sorter(A, B)
    if A.priority or B.priority then
      return (A.priority or 50) > (B.priority or 50)
    end

    return A.label < B.label
  end


  local function create_buttons(what, DEFS)
    assert(DEFS)
    gui.debugf("creating buttons for %s\n", what)

    local list = {}

    local min_priority = 999

    for name,def in pairs(DEFS) do
      assert(def.name and def.label)
      table.insert(list, def)
      min_priority = math.min(min_priority, def.priority or 50)
    end

    -- add separators for the Theme menus
    if what == "theme" and min_priority < 79 then
      table.insert(list, { priority=79, name="_", label="_" })
    end

    table.sort(list, button_sorter)

    for _,def in pairs(list) do
      if what == "module" then
        assert(def.name and def.label)
        local where = def.where or "other"
        local suboptions
        if where == "links" then
          suboptions = 1
        else
          suboptions = 0
        end
        if def.color then
          gui.add_module(where, def.name, def.label, def.tooltip, def.color["red"], def.color["green"], def.color["blue"], suboptions)
        else
          gui.add_module(where, def.name, def.label, def.tooltip, nil, nil, nil, suboptions)
        end
      else
        assert(def.name and def.label)
        gui.add_choice(what, def.name, def.label)
      end

      -- TODO : review this, does it belong HERE ?
      if what == "engine" then
        assert(def.name)
        gui.enable_choice("engine", def.name, true)
      end
    end

    -- set the current value
    if what ~= "module" then
      local default = list[1] and list[1].name

      OB_CONFIG[what] = default
    end
  end


  local function simple_buttons(what, choices, default)
    for i = 1,#choices,2 do
      local id    = choices[i]
      local label = choices[i+1]

      gui.   add_choice(what, id, label)
      gui.enable_choice(what, id, true)
    end

    OB_CONFIG[what] = default
  end


  local function create_mod_options()
    gui.debugf("creating module options\n", what)

    for _,mod in pairs(OB_MODULES) do
      if not mod.options then
        mod.options = {}
      else
        local list = mod.options

        -- handle lists (for UI modules) different from key/value tables
        if list[1] == nil then
          list = {}

          for name,opt in pairs(mod.options) do
            opt.name = name
            table.insert(list, opt)
          end

          table.sort(list, button_sorter)
        end

        for _,opt in pairs(list) do
          assert(opt.label)
          if string.match(opt.name, "header_") then
            gui.add_module_header(mod.name, opt.name, opt.label, opt.gap)
            goto justaheader
          end
          if string.match(opt.name, "url_") then
            assert(opt.url)
            gui.add_module_url(mod.name, opt.name, opt.label, opt.url, opt.gap)
            goto justaheader
          end
          if not opt.valuator then
            assert(opt.choices)
          end
                  
          if opt.valuator then
            if opt.valuator == "slider" then
              if not opt.default then
                opt.default = (opt.min + opt.max) / 2
              end
              gui.add_module_slider_option(mod.name, opt.name, opt.label, opt.tooltip, opt.longtip, opt.gap, opt.min, opt.max, opt.increment, opt.units or "", opt.presets or "", opt.nan or "", opt.randomize_group or "", tostring(opt.default))
              opt.value = opt.default
              gui.set_module_slider_option(mod.name, opt.name, opt.value)
            elseif opt.valuator == "button" then
              if not opt.default then
                opt.default = 0
              end
              gui.add_module_button_option(mod.name, opt.name, opt.label, opt.tooltip, opt.longtip, opt.gap, opt.randomize_group or "", tostring(opt.default))
              opt.value = opt.default
              gui.set_module_button_option(mod.name, opt.name, opt.value)
            end
          else
            -- select a default value
            if not opt.default then
              if table.has_elem(opt.choices, "default") then opt.default = "default"
              elseif table.has_elem(opt.choices, "normal")  then opt.default = "normal"
              elseif table.has_elem(opt.choices, "medium")  then opt.default = "medium"
              elseif table.has_elem(opt.choices, "mixed")   then opt.default = "mixed"
              else   opt.default = opt.choices[1]
              end
            end
            gui.add_module_option(mod.name, opt.name, opt.label, opt.tooltip, opt.longtip, opt.gap, opt.randomize_group or "", opt.default)
            opt.avail_choices = {}

            for i = 1,#opt.choices,2 do
              local id    = opt.choices[i]
              local label = opt.choices[i+1]

              gui.add_option_choice(mod.name, opt.name, id, label)
              opt.avail_choices[id] = 1
            end
            opt.value = opt.default
            gui.set_module_option(mod.name, opt.name, opt.value)
          end
          ::justaheader::
        end -- for opt
      end
    end -- for mod
  end


  OB_CONFIG.seed = 0,

  create_buttons("engine", OB_ENGINES)
  create_buttons("game",   OB_GAMES)
  create_buttons("port", OB_PORTS)
  create_buttons("theme",  OB_THEMES)

  simple_buttons("length",   LENGTH_CHOICES,   "game")

  create_buttons("module", OB_MODULES)
  create_mod_options()

  OB_CONFIG.engine = "idtech_1"

  ob_update_all()

  gui.set_button("engine",   OB_CONFIG.engine)
  gui.set_button("game",     OB_CONFIG.game)
  gui.set_button("port",   OB_CONFIG.port)
  gui.set_button("length",   OB_CONFIG.length)
  gui.set_button("theme",    OB_CONFIG.theme)

  gui.printf("\n~~ Completed Lua initialization ~~\n\n")
end



function ob_game_format()
  assert(OB_CONFIG)
  assert(OB_CONFIG.game)

  local game = OB_GAMES[OB_CONFIG.game]

  assert(game)

  if game.extends then
    game = assert(OB_GAMES[game.extends])
  end

  return assert(game.format)
end

function ob_get_param(parameter)

  assert(parameter)

  local param

  if PARAM[parameter] then
    param = PARAM[parameter]
  elseif OB_CONFIG[parameter] then
    param = OB_CONFIG[parameter]
  else
    if OB_CONFIG.batch == "yes" then
      print("MISSING PARAMETER: " .. parameter)
    else
      print("WARNING! " .. parameter .. " not found in config!")
      return ""
    end
  end
  
  if type(param) == "string" then
    return param
  else
    return tostring(param)
  end
  
end

function ob_hexen_ceiling_check(thing_id)

  assert(thing_id)

  local on_ceiling = 0

  for _, ent in pairs(GAME.ENTITIES) do 
    if ent.id == tonumber(thing_id) then
        if ent.ceil and ent.ceil == true then
          on_ceiling = 1
        end
        goto continue
    end
  end
  ::continue::
  
  return on_ceiling

end

function ob_get_password()

  local pass_chars = 
  {
    "1","2","3","4","5","6","7","8","9","0","q","w","e","r","t","y","u","i","o","p","[","]","\\",
    "a","s","d","f","g","h","j","k","l",";","'","z","x","c","v","b","n","m",",",".","/","!","@",
    "#","$","^","&","*","(",")","_","+","Q","W","E","R","T","Y","U","I","O","P","{","}","|",
    "A","S","D","F","G","H","J","K","L",":","Z","X","C","V","B","N","M","<",">","?","\""
  }

  pass_string = ""
  for i=1,20 do
    pass_string = pass_string .. rand.pick(pass_chars)
  end
  return pass_string

end

function ob_get_random_words()
  
  RANDOM_WORDS = {}

  if OB_CONFIG.mature_words == "yes" then
    RANDOM_WORDS = RANDOM_WORDS_EN_M
  else 
    RANDOM_WORDS = RANDOM_WORDS_EN
  end

  local function case_randomizer(random_word)

    local case_odds =
    {
      default = 40,
      capitalized = 30,
      all_caps = 15,
      alternating = 5
    }
    
    local case_pick = rand.key_by_probs(case_odds)

    if case_pick == "default" then
      return random_word
    elseif case_pick == "capitalized" then
      return string.upper(string.sub(random_word, 1, 1)) .. string.sub(random_word, 2)
    elseif case_pick == "all_caps" then
      return string.upper(random_word)
    else
      local alt_string = ""
      for i = 1, #random_word do
        local c = string.sub(random_word, i,i)
        if i % 2 == 0 then
          alt_string = alt_string .. string.upper(c)
        else
          alt_string = alt_string .. c
        end
      end
      return alt_string
    end 
  end

  local numwords = rand.irange(1, 3)

  if numwords == 1 then
    return case_randomizer(rand.pick(RANDOM_WORDS))
  elseif numwords == 2 then
    return case_randomizer(rand.pick(RANDOM_WORDS)) .. " " .. case_randomizer(rand.pick(RANDOM_WORDS))
  else
    return case_randomizer(rand.pick(RANDOM_WORDS)) .. " " .. case_randomizer(rand.pick(RANDOM_WORDS)) .. " " .. case_randomizer(rand.pick(RANDOM_WORDS))
  end
end

local last_Clippy_advice_index = -1       -- Like "static last_Clippy_advice_index = -1;"...
function ob_random_advice()
  if #HELPFUL_ADVICE == 0 then
    return nil
  end

  if last_Clippy_advice_index < 0 then
    -- Randomize first index:
    last_Clippy_advice_index = rand.irange(1, #HELPFUL_ADVICE)
  else
    -- Avoiding previous advice index:
    last_Clippy_advice_index = 1 + ( (last_Clippy_advice_index + rand.irange(1, #HELPFUL_ADVICE - 2)) % #HELPFUL_ADVICE )
  end

  return HELPFUL_ADVICE[ last_Clippy_advice_index ]
end

function ob_default_filename()
  -- create a default filename [ WITHOUT any extension ]

  if OB_CONFIG.batch == "yes" then goto continue end

  assert(OB_CONFIG)
  assert(OB_CONFIG.game)
  
  -- I don't like doing this, but I'd rather not try to reorder
  -- the normal GAME table merge stuff - Dasho
  if ob_match_game({game = {wolf=1, spear=1, noah=1, obc=1}}) then
    return "unused.filename"
  else
    local name_tab = {}
    if OB_CONFIG.game == "chex1" then
      name_tab = CHEX1.NAMES
    elseif ob_match_game({game = "doomish"}) then
      name_tab = DOOM.NAMES
    elseif OB_CONFIG.game == "hacx" then
      name_tab = HACX.NAMES
    elseif OB_CONFIG.game == "harmony" then
      name_tab = HARMONY.NAMES
    elseif OB_CONFIG.game == "heretic" then
      name_tab = HERETIC.NAMES
    elseif OB_CONFIG.game == "strife" then
      name_tab = STRIFE.NAMES
    elseif OB_CONFIG.game == "rekkr" then
      name_tab = REKKR.NAMES
    end
    Naming_init(name_tab)
  end

  OB_CONFIG.title = Naming_grab_one("TITLE")
  GAME.title = OB_CONFIG.title

  -- massage into a usable filename
  local str = string.lower(OB_CONFIG.title)

  str = string.gsub(str, "%p", "")
  str = string.gsub(str, " ", "_")
  str = string.gsub(str, ":", "")
  str = string.gsub(str, "'", "")
  str = string.gsub(str, ",", "")
  
  if OB_CONFIG.filename_prefix == "none" then
    return str
  else
    local formatstring
    local levelcount
    
    if OB_CONFIG.length == "single" then
      levelcount = "1"
    elseif OB_CONFIG.length == "few" then
      levelcount = "4"
    elseif OB_CONFIG.length == "episode" then
      if ob_match_game({game = {doom2=1,tnt=1,plutonia=1,hacx=1}}) then
        levelcount = "11"
      else
        levelcount = "9"
      end
    else
     levelcount = "FULL"
    end
        
    if OB_CONFIG.filename_prefix == "datetime" then
      formatstring = ob_datetime_format_string() .. "_"
    elseif OB_CONFIG.filename_prefix == "numlevels" then
      formatstring = "ob" .. levelcount .. "_"
    elseif OB_CONFIG.filename_prefix == "game" then
      formatstring = OB_CONFIG.game .. "_"
    elseif OB_CONFIG.filename_prefix == "port" then
      formatstring = OB_CONFIG.port .. "_"
    elseif OB_CONFIG.filename_prefix == "theme" then
      formatstring = OB_CONFIG.theme .. "_"   
    elseif OB_CONFIG.filename_prefix == "version" then
      formatstring = "%v_"
    elseif OB_CONFIG.filename_prefix == "custom" then
      formatstring = "custom"
   end
   
   return gui.format_prefix(levelcount, OB_CONFIG.game, OB_CONFIG.port, OB_CONFIG.theme, formatstring) .. str .. ".wad"
   
 end
 
 ::continue::
 
end


------------------------------------------------------------------------


function ob_merge_tab(name, tab)
  assert(name and tab)

  if not GAME[name] then
    GAME[name] = table.deep_copy(tab)
    return
  end

  -- support replacing _everything_
  -- [ needed mainly for Doom 1 themes ]
  if tab.replace_all then
    GAME[name] = {}
  end

  table.merge_w_copy(GAME[name], tab)

  GAME[name].replace_all = nil
end


function ob_merge_table_list(tab_list)
  for _,GT in ipairs(tab_list) do
    assert(GT)
    for name,tab in pairs(GT) do
      -- upper-case names should always be tables to copy
      if string.match(name, "^[A-Z]") then
        if type(tab) ~= "table" then
          error("Game field not a table: " .. tostring(name))
        end
        ob_merge_tab(name, tab)
      end
    end
  end
end



function ob_add_current_game()
  local function recurse(name, child)
    local def = OB_GAMES[name]

    if not def then
      error("UNKNOWN GAME: " .. name)
    end

    -- here is the tricky bit : by recursing now, we can process all the
    -- definitions in the correct order (children after parents).

    if def.extends then
      recurse(def.extends, def)
    end

    if def.tables then
      ob_merge_table_list(def.tables)
    end

    if child and def.hooks then
      child.hooks = table.merge_missing(child.hooks or {}, def.hooks)
    end

    for _,keyword in pairs({ "format", "sub_format", "game_dir" }) do
      if def[keyword] ~= nil then
        GAME[keyword] = def[keyword]
      end
    end

    return def
  end

  table.insert(GAME.modules, 1, recurse(OB_CONFIG.game))
end



function ob_add_current_port()
  local function recurse(name, child)
    local def = OB_PORTS[name]

    if not def then
      error("UNKNOWN PORT: " .. name)
    end

    if def.extends then
      recurse(def.extends, def)
    end

    if def.tables then
      ob_merge_table_list(def.tables)
    end

    if child and def.hooks then
      child.hooks = table.merge_missing(child.hooks or {}, def.hooks)
    end

    return def
  end

  table.insert(GAME.modules, 2, recurse(OB_CONFIG.port))
end



function ob_sort_modules()
  GAME.modules = {}

  -- find all the visible & enabled modules
  -- [ ignore the special UI modules/panels ]

  for _,mod in pairs(OB_MODULES) do
    if mod.enabled and mod.shown and not ob_check_ui_module(mod) then
      table.insert(GAME.modules, mod)
    end
  end

  -- sort them : lowest -> highest priority, because later
  -- entries can override things done by earlier ones.

  local function module_sorter(A, B)
    if A.priority or B.priority then
      return (A.priority or 50) < (B.priority or 50)
    end

    return A.label < B.label
  end

  if #GAME.modules > 1 then
    table.sort(GAME.modules, module_sorter)
  end
end



function ob_invoke_hook(name, ...)
  -- two passes, for example: setup and setup2,
  for pass = 1,2 do
    if string.match(name, "^pre_setup") then goto skip end
    for _,mod in pairs(GAME.modules) do
      local func = mod.hooks and mod.hooks[name]
      if func then
        func(mod, ...)
      end
    end
    ::skip::
    for _,mod in pairs(OB_MODULES) do
      if ob_check_ui_module(mod) then
       local func = mod.hooks and mod.hooks[name]

        if func then
          func(mod, ...)
        end
      end
    end
    name = name .. "2"
  end
end

function ob_invoke_hook_with_table(name, local_table)
  for _,mod in pairs(GAME.modules) do
    local func = mod.hooks and mod.hooks[name]
    if func then
      func(mod, local_table)
    end
  end
  
  for _,mod in pairs(OB_MODULES) do
    if ob_check_ui_module(mod) then
      local func = mod.hooks and mod.hooks[name]
      if func then
        func(mod, local_table)
      end
    end
  end
end


function ob_transfer_ui_options()
  for _,mod in pairs(OB_MODULES) do
    if ob_check_ui_module(mod) then
      for _,opt in pairs(mod.options) do
        OB_CONFIG[opt.name] = opt.value or "UNSET"
      end
    end
  end

  -- fixes for backwards compatibility
  if OB_CONFIG.length == "full" then
     OB_CONFIG.length = "game"
  end

  if OB_CONFIG.theme == "mixed" then
     OB_CONFIG.theme = "epi"
  end
end

function ob_build_setup()
  ob_clean_up()

  if OB_CONFIG.title then
    GAME.title = OB_CONFIG.title
  end

  ob_transfer_ui_options()

  ob_sort_modules()

  -- first entry in module list *must* be the game def, and second entry
  -- must be the engine definition.  NOTE: neither are real modules!
  ob_add_current_game()
  ob_add_current_port()

  -- merge tables from each module
  -- [ but skip GAME and PORT, which are already merged ]

  for index,mod in pairs(GAME.modules) do
    if index > 2 and mod.tables then
      ob_merge_table_list(mod.tables)
    end
  end


  PARAM = assert(GAME.PARAMETERS)

  table.merge_missing(PARAM, GLOBAL_PARAMETERS)

  -- load all the prefab definitions
  if OB_CONFIG.batch == "yes" then
    RANDOMIZE_GROUPS = gui.get_batch_randomize_groups()
  end

  if not ob_match_game({game = {wolf=1,spear=1,noah=1,obc=1}}) then
    Naming_init(GAME.NAMES)
  end

  ob_invoke_hook("setup")
  ob_invoke_hook("factory_setup") -- Some historical versions of Oblige use this

  Fab_load_all_definitions()

  table.name_up(GAME.THEMES)
  table.name_up(GAME.ROOM_THEMES)

  for _,grammar in pairs(SHAPES) do
    Grower_preprocess_grammar(grammar)
  end

  if GAME.sub_format then
    gui.property("sub_format", GAME.sub_format)
  end

  gui.property("spot_low_h",  PARAM.spot_low_h)
  gui.property("spot_high_h", PARAM.spot_high_h)
end



function ob_clean_up()
  for _,k in pairs (GAME) do
    GAME[k] = nil
  end
  for _,k in pairs (THEME) do
    THEME[k] = nil
  end
  for _,k in pairs (PARAM) do
    PARAM[k] = nil
  end
  for _,k in pairs (STYLE) do
    STYLE[k] = nil
  end
  for _,k in pairs (SCRIPTS) do
    SCRIPTS[k] = nil
  end
  GAME   = nil
  THEME  = nil
  PARAM  = nil
  STYLE  = nil
  SCRIPTS = nil
  EPISODE = nil
  PREFABS = nil
  PREFABS_FULL = nil
  SEEN_ROOM_THEMES = nil
  SEEN_WALL_GROUPS = nil
  AMBIENT_SOUND_DEFS = nil

  if OB_CONFIG.string_seed then
    table.remove(OB_CONFIG, string_seed)
  end

  collectgarbage("collect")
  collectgarbage("collect")
  GAME   = {}
  THEME  = {}
  PARAM  = {}
  STYLE  = {}
  SCRIPTS = {}
  SEEN_ROOM_THEMES = {}
  SEEN_WALL_GROUPS = {}
  if OB_MODULES["sky_generator"].enabled and OB_MODULES["sky_generator"].visible then
    gui.fsky_free()
  end
  AMBIENT_SOUND_DEFS = {}
end

local function ob_get_module_refs()
  local module_refs = {}
  for _,v in pairs(OB_MODULES) do
    local option_refs = {}
    for _,vv in pairs(v.options) do
      if not string.match(vv.name, "header_") and not string.match(vv.name, "url_") then
        option_refs[vv.name] = {}
        if not vv.tooltip then
          option_refs[vv.name].tooltip = "No help yet written for this option!"
        else
          option_refs[vv.name].tooltip = gui.gettext(vv.tooltip)
        end
        if vv.randomize_group then option_refs[vv.name].random_group = vv.randomize_group end
        if not v.engine then
          option_refs[vv.name].engine = {}
          table.add_unique(option_refs[vv.name].engine, "ALL")
        else
          if type(v.engine) == "string" then
            option_refs[vv.name].engine = {}
            table.add_unique(option_refs[vv.name].engine, v.engine)
          else
            option_refs[vv.name].engine = {}
            for engine,_ in pairs(v.engine) do
              table.add_unique(option_refs[vv.name].engine, engine)
            end
          end
        end
        if not v.game then
          option_refs[vv.name].game = {}
          table.add_unique(option_refs[vv.name].game, "ALL")
        else
          if type(v.game) == "string" then
            option_refs[vv.name].game = {}
            table.add_unique(option_refs[vv.name].game, v.game)
          else
            option_refs[vv.name].game = {}
            for game,_ in pairs(v.game) do
              table.add_unique(option_refs[vv.name].game, game)
            end
          end
        end
        if not v.port then
          option_refs[vv.name].port = {}
          table.add_unique(option_refs[vv.name].port, "ALL")
        else
          if type(v.port) == "string" then
            option_refs[vv.name].port = {}
            table.add_unique(option_refs[vv.name].port, v.port)
          else
            option_refs[vv.name].port = {}
            for port,_ in pairs(v.port) do
              table.add_unique(option_refs[vv.name].port, port)
            end
          end
        end
        if not vv.valuator then
          option_refs[vv.name].choices = {}
          for num,choice in pairs(vv.choices) do
            if num % 2 == 1 then
              table.add_unique(option_refs[vv.name].choices, choice)
            end
          end
        else
          if vv.valuator == "slider" then
            option_refs[vv.name].slider = {}
            option_refs[vv.name].slider.min = vv.min
            option_refs[vv.name].slider.max = vv.max
            option_refs[vv.name].slider.default = vv.default
            if vv.nan then
              option_refs[vv.name].slider.nan = vv.nan
            end
          else
            option_refs[vv.name].button = {}
            option_refs[vv.name].button.default = vv.default
          end
        end
      end
    end
    module_refs[v.name] = option_refs
  end
  module_refs["main_build_settings"] = {
    engine = {
      tooltip = _("Choose which engine to build maps for:\n  id Tech 0: Wolfenstein 3D and similar games\n  id Tech 1: Doom and similar games\n"),
      engine = {_("ALL")},
      game = {_("ALL")},
      port = {_("ALL")},
      choices = {
        "idtech_0",
        "idtech_1",
      },
      default = "idtech_1",
    },
    game = {
      tooltip = _("Choose which game to build maps for."),
      engine = {_("ALL")},
      game = {_("ALL")},
      port = {_("ALL")},
      choices = {
        "chex1",
        "doom1",
        "doom2",
        "ultdoom",
        "tnt",
        "plutonia",
        "hacx",
        "harmony",
        "heretic",
        "rekkr",
        "strife",
        "wolf3d",
        "spear",
        "noah",
        "obc",
      },
      default = "doom2",
    },
    port = {
      tooltip = _("Choose which port to build maps for.\n  Vanilla is the only option for id Tech 0; the remaining options are for id Tech 1.\n"),
      engine = {_("ALL")},
      game = {_("ALL")},
      port = {_("ALL")},
      choices = {
        "vanilla",
        "limit_enforcing",
        "boom",
        "zdoom",
        "edge",
      },
      default = "boom",
    },
    length = {
      tooltip = _("Choose how many levels to create."),
      engine = {_("ALL")},
      game = {_("ALL")},
      port = {_("ALL")},
      choices = {
        "single",
        "few",
        "episode",
        "game",
      },
      default = "game",
    },
    theme = {
      tooltip = _("The following values are game-specific:\n  Ultimate Doom/Doom 1: deimos,flesh\n  Ultimate Doom/Doom 1/Doom 2/TNT/Plutonia: tech,urban,hell\n  TNT: egypt\n  HacX: hacx_urban\n  Heretic: city,maw,dome,ossuary,demense\n\n  Note: This setting currently does nothing for id Tech 0 games!\n"),
      engine = {_("ALL")},
      game = {_("ALL")},
      port = {_("ALL")},
      choices = {
        "original",
        "epi",
        "jumble",
        "bit_mixed",
        "psycho",
        "tech",
        "urban",
        "hell",
        "deimos",
        "flesh",
        "egypt",
        "hacx_urban",
        "city",
        "maw",
        "dome",
        "ossuary",
        "demense"
      },
      default = "original",
    },
  }
  return module_refs
end

function ob_print_reference()
  local module_refs = ob_get_module_refs()
  local sorted_entries = table.keys_sorted(module_refs)
  for _,module_entry in ipairs(sorted_entries) do
    gui.console_print("\n[[ " .. module_entry .. " ]]\n")
    gui.ref_print("\n[[ " .. module_entry .. " ]]\n")
    for name,option in pairs(module_refs[module_entry]) do
      gui.console_print("\n" .. gui.gettext("option: ") .. name .. "\n")
      gui.ref_print("\n" .. gui.gettext("option: ") .. name .. "\n")
      gui.console_print(gui.gettext("comment: ") .. option.tooltip .. "\n")
      gui.ref_print(gui.gettext("comment: ") .. option.tooltip .. "\n")
      gui.console_print(gui.gettext("engine: "))
      gui.ref_print(gui.gettext("engine: "))
      for _,engine in pairs(option.engine) do
        gui.console_print(engine .. " ")
        gui.ref_print(engine .. " ")
      end
      gui.console_print("\n")
      gui.ref_print("\n")
      gui.console_print(gui.gettext("game: "))
      gui.ref_print(gui.gettext("game: "))
      for _,game in pairs(option.game) do
        gui.console_print(game .. " ")
        gui.ref_print(game .. " ")
      end
      gui.console_print("\n")
      gui.ref_print("\n")
      gui.console_print(gui.gettext("port: "))
      gui.ref_print(gui.gettext("port: "))
      for _,port in pairs(option.port) do
        gui.console_print(port .. " ")
        gui.ref_print(port .. " ")
      end
      if (option.slider) then
        gui.console_print("\n" .. gui.gettext("values: ") .. option.slider.min .. "-" .. option.slider.max)
        gui.ref_print("\n" .. gui.gettext("values: ") .. option.slider.min .. "-" .. option.slider.max)
        if option.slider.nan then
          gui.console_print("," .. option.slider.nan)
          gui.ref_print("," .. option.slider.nan)
        end
        gui.console_print("\n" .. gui.gettext("default: ") .. option.slider.default)
        gui.ref_print("\n" .. gui.gettext("default: ") .. option.slider.default)
      elseif (option.button) then
        gui.console_print("\n" .. gui.gettext("values: ")
         .. "0/1\n" .. gui.gettext("default: ") .. option.button.default)
        gui.ref_print("\n" .. gui.gettext("values: ")
        .. "0/1\n" .. gui.gettext("default: ") .. option.button.default)
      else
        gui.console_print("\n" .. gui.gettext("values: "))
        gui.ref_print("\n" .. gui.gettext("values: "))
        for num,choice in ipairs(option.choices) do
          if num ~= #option.choices then
            gui.console_print(choice .. ",")
            gui.ref_print(choice .. ",")
          else
            gui.console_print(choice)
            gui.ref_print(choice)
          end
        end
      end
      if (option.random_group) then
        gui.console_print("\n" .. gui.gettext("randomize_group: ") .. option.random_group)
        gui.ref_print("\n" .. gui.gettext("randomize_group: ") .. option.random_group)
      end
      gui.console_print("\n")
      gui.ref_print("\n")
    end
  end
end

local function split_commas(inputstr)
  local t = {}
  for str in string.gmatch(inputstr, "([^,]+)") do
    table.insert(t, str)
  end
  return t
end

function ob_print_reference_json()
  local module_refs = ob_get_module_refs()
  local sorted_entries = table.keys_sorted(module_refs)
  gui.console_print("{\n")
  for i,module_entry in ipairs(sorted_entries) do
    gui.console_print("  \"" .. module_entry .. "\": {\n")
    local first = true
    for name,option in pairs(module_refs[module_entry]) do
      if not first then
        gui.console_print(",\n")
      else
        gui.console_print("\n")
        first = false
      end
      gui.console_print("    \"" .. name .. "\": {\n")
      local tooltip = option.tooltip
      tooltip = tooltip:gsub("\n", "\\n")
      gui.console_print("      \"" .. gui.gettext("tooltip") .. "\": \"" .. tooltip .. "\",\n")
      gui.console_print("      \"" .. gui.gettext("engine") .. "\": ")
      if #option.engine == 1 and option.engine[1] == "ALL" then
        gui.console_print("\"" .. gui.gettext("ALL") .. "\",\n")
      else
        gui.console_print("[")
        for j,engine in pairs(option.engine) do
          if j ~= #option.engine then
            gui.console_print("\"" .. engine .. "\", ")
          else
            gui.console_print("\"" .. engine .. "\"")
          end
        end
        gui.console_print("],\n")
      end
      gui.console_print("    \"" .. gui.gettext("game") .. "\": ")
      if #option.game == 1 and option.game[1] == gui.gettext("ALL") then
        gui.console_print("\"" .. gui.gettext("ALL") .. "\",\n")
      else
        gui.console_print("[")
        for j,game in pairs(option.game) do
          if j ~= #option.game then
            gui.console_print("\"" .. game .. "\", ")
          else
            gui.console_print("\"" .. game .. "\"")
          end
        end
        gui.console_print("],\n")
      end
      gui.console_print("    \"" .. gui.gettext("port") .. "\": ")
      if #option.port == 1 and option.port[1] == gui.gettext("ALL") then
        gui.console_print("\"" .. gui.gettext("ALL") .. "\",\n")
      else
        gui.console_print("[")
        for j,port in pairs(option.port) do
          if j ~= #option.port then
            gui.console_print("\"" .. port .. "\", ")
          else
            gui.console_print("\"" .. port .. "\"")
          end
        end
        gui.console_print("],\n")
      end
      if (option.slider) then
        gui.console_print("    \"" .. gui.gettext("type") .. "\": \"" ..
          gui.gettext("slider") .. "\",\n")
        gui.console_print("    \"" .. gui.gettext("values") .. "\": {\n")
        gui.console_print("      \"" .. gui.gettext("min") .. "\": " .. option.slider.min .. ",\n")
        gui.console_print("      \"" .. gui.gettext("max") .. "\": " .. option.slider.max .. ",\n")
        local default = option.slider.default
        if tonumber(default) == nil then
          default = "\"" .. default .. "\""
        end
        gui.console_print("      \"" .. gui.gettext("default") .. "\": " .. default)
        if option.slider.nan then
          local nans = split_commas(option.slider.nan)
          gui.console_print(",\n      \"nan\": [\n")
          for i,nan in ipairs(nans) do
            gui.console_print("        \"" .. nan .. "\"")
            if i ~= #nans then
              gui.console_print(",")
            end
            gui.console_print("\n")
          end
          gui.console_print("      ]")
        end
        gui.console_print("\n")
        gui.console_print("    }")
      elseif (option.button) then
        gui.console_print("    \"" .. gui.gettext("type") .. "\": \"" ..
          gui.gettext("boolean") .. "\",\n")
        gui.console_print("    \"" .. gui.gettext("default") .. "\": " .. option.button.default .. "\n")
      else
        gui.console_print("    \"" .. gui.gettext("type") .. "\": \"" ..
          gui.gettext("choice") .. "\",\n")
        gui.console_print("    \"" .. gui.gettext("values") .. "\": [\n")
        for num,choice in ipairs(option.choices) do
          gui.console_print("      \"" .. choice .. "\"")
          if num ~= #option.choices then
            gui.console_print(",")
          end
          gui.console_print("\n")
        end
        gui.console_print("    ]")
      end
      if (option.random_group) then
        gui.console_print(",\n    \"" .. gui.gettext("randomize_group") .. "\": \"" .. option.random_group .. "\"\n")
      else
        gui.console_print("\n")
      end
      gui.console_print("  }")
    end
    gui.console_print("  }")
    if i ~= #sorted_entries then
      gui.console_print(",")
    end
    gui.console_print("\n")
  end
  gui.console_print("}\n")
end

local PROFILING = false

function ob_build_cool_shit()
  local profiler
  if PROFILING then
    package.path = package.path .. ";./scripts/?.lua"
    profiler = require("profiler")
    profiler.start()
  end

  assert(OB_CONFIG)
  assert(OB_CONFIG.game)

  gui.printf("\n\n")
  gui.printf(gui.gettext("~~~~~~~ Making Levels ~~~~~~~\n\n"))
  gui.printf("-- CONFIG FILE : OBSIDIAN Beta\n\n") -- Do not translate; needed by config parser
    
  ob_read_all_config(false, "log_only")

  if OB_CONFIG.engine == "idtech_1" and OB_CONFIG.port == "limit_enforcing" then
    ob_clean_up()
    ob_transfer_ui_options()
    ob_sort_modules()
    ob_add_current_game()
    ob_add_current_port()
    for index,mod in pairs(GAME.modules) do
      if index > 2 and mod.tables then
        ob_merge_table_list(mod.tables)
      end
    end
    ob_invoke_hook("slump_setup")
    ob_invoke_hook("setup")
    assert(PARAM.slump_config)
    gui.minimap_disable(gui.gettext("SLUMP"))
    return "ok" 
  end -- Skip the rest if using Vanilla Doom/SLUMP

  gui.ticker()
  
  ob_build_setup()

  -- Hijack here if Wolf3D is selected

  if OB_CONFIG.engine == "idtech_0" then
    gui.minimap_disable(gui.gettext("id Tech 0"))
    local result = v094_build_wolf3d_shit()
    ob_clean_up()
    return result
  end

  if PARAM["bool_save_gif"] == 1 then
    -- Set frame delay based on how detailed the live minimap is - Dasho
    if PARAM["live_minimap"] == "step" then
      gui.minimap_gif_start(10)
    elseif PARAM["live_minimap"] == "room" then
      gui.minimap_gif_start(75)
    else
      gui.minimap_gif_start(175)
    end
  end

  status = Level_make_all()

  if PARAM["bool_save_gif"] == 1 then
    gui.minimap_gif_finish()
  end

  ob_clean_up()

  gui.printf("\n")

  if status == "abort" then
    gui.printf("\n")
    gui.printf(gui.gettext("~~~~~~~ Build Aborted! ~~~~~~~\n\n"))
    return "abort"
  end

  gui.printf("\n")
  gui.printf(gui.gettext("~~~~~~ Finished Making Levels ~~~~~~\n\n"))

  if PROFILING then
    profiler.stop()
    profiler.report("profile.log")
  end

  return "ok"
end
