------------------------------------------------------------------------
--  LEVEL MANAGEMENT
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2020-2022 MsrSgtShooterPerson
--  Copyright (C) 2020 Reisal
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


--class EPISODE
--[[
    id : number       -- index number (in GAME.episodes)

    description       -- a name generated for this episode

    levels : list(LEVEL)  -- all the levels to generate (may be empty)

    used_keys : table  -- for hubs, remember keys which have been used
                       -- on any level in the hub (cannot use them again)

--]]


--class LEVEL
--[[
    id : number    -- index number (in GAME.levels)

    name : string  -- engine name for this level, e.g. MAP01,

    description : string  -- level name or title (optional)

    kind  -- keyword: "NORMAL", "BOSS", "SECRET",

    episode : EPISODE

      ep_along  -- how far along in the episode:    0.0 --> 1.0,
    game_along  -- how far along in the whole game: 0.0 --> 1.0,

    is_secret   -- true if level is a secret level
    prebuilt    -- true if level will is prebuilt (not generated)

    is_procedural_gotcha -- true if this level is a special Procedural Gotcha arena
    is_nature   -- true if this level is entirely parks and caves

    has_streets -- true if this level contains Street Mode streets

    === General planning ===

    liquid : table  -- the main liquid in the level (can be nil)

    is_dark : bool  -- true if outdoor rooms will be dark

    special : keyword  -- normally nil
                       -- [ not used at the moment ]


    === Monster planning ===

    monster_level   -- the maximum level of a monster usable here [ except bosses ]

    new_monsters    -- monsters which player has not encountered yet

    global_pal      -- global palette, can ONLY use these monsters [ except for bosses ]

    boss_fights : list(BOSS_FIGHT)   -- boss fights, from biggest to smallest


    === Weapon planning ===

    weapon_quota    -- number of weapons to add in this level [ except secrets ]

      new_weapons   -- weapons which player does not have yet [ may overlap with start_weapons ]
    start_weapons   -- a weapon or two for the start room
    other_weapons   -- the weapons for rest of map (#start + #other == quota)

    secret_weapon   -- an unseen weapon, for usage in a secret room


    === Item planning ===

    usable_keys : prob table  -- if present, can only use these keys


    === Other stuff ===

    ids     : table  -- used for allocating tag numbers (etc)

    rooms   : list(ROOM)
    areas   : list(AREA)
    conns   : list(CONN)

    quests  : list(QUEST)
    zones   : list(ZONE)
    locks   : list(LOCK)

    start_room : ROOM  -- the starting room
     exit_room : ROOM  -- the exit room

    junctions[id1 + id2] : JUNCTION

    corners : array_2D(CORNER)

    -- TODO: lots of other fields : document important ones
--]]


--class BOSS_FIGHT
--[[
    mon    -- name of monster
    count  -- number of them to use
    boss_type -- keyword: guard / minor / nasty / tough
--]]


--class HUB_INFO
--[[
    hub_key    : name   -- goal of this level must be this key
    hub_weapon : name   -- weapon to place on this level
    hub_piece  : name   -- weapon PIECE for this level
--]]

-- Map size stuff

function Level_determine_map_size(LEV)
  --
  -- Determines size of map (Width x Height) in grid squares,
  -- based on the user's settings and how far along in the
  -- episode or game we are.
  --

  -- Named sizes --

  -- Since we have other sizes and Auto-Detail, we can have these bigger sizes
  -- now. -Reisal, July 9th, 2019,
  
  local ob_size = PARAM.float_size

  local W, H

  if LEV.custom_size then
    ob_size = LEV.custom_size
    W = ob_size
    goto customsize
  end

  if LEV.custom_w then
    if LEV.custom_h then
      return LEV.custom_w, LEV.custom_h
    else
      ob_size = LEV.custom_size
      W = ob_size
      goto customsize
    end
  end

  -- there is no real "progression" when making a single level.
  -- hence use the average size instead.
  if OB_CONFIG.length == "single" then
    if ob_size == gui.gettext("Episodic") or 
    ob_size == gui.gettext("Progressive") then
      ob_size = (PARAM.float_level_lower_bound
      + PARAM.float_level_upper_bound) / 2
      or 36
    end
  end

  -- Mix It Up --

  -- Readjusted probabilities once again, added "Micro" size as suggested by activity
  -- in the Discord server. -Reisal, June 30th, 2019,
  if ob_size == gui.gettext("Mix It Up") then

    local result_skew = 1.0
    local low = PARAM.float_level_lower_bound or 10
    local high = PARAM.float_level_upper_bound or 75

    if OB_CONFIG.level_size_bias then
      if OB_CONFIG.level_size_bias == "small" then
        result_skew = .80
      elseif OB_CONFIG.level_size_bias == "large" then
        result_skew = 1.20
      end
    end

    ob_size = math.clamp(low, math.floor(rand.irange(low, high) * result_skew), high)
  end

  if ob_size == gui.gettext("Episodic") or 
  ob_size == gui.gettext("Progressive") then

    -- Progressive --

    local ramp_factor = 0.66

    if OB_CONFIG.level_size_ramp_factor then
      ramp_factor = tonumber(OB_CONFIG.level_size_ramp_factor)
    end

    local along = LEV.game_along ^ ramp_factor

    if ob_size == gui.gettext("Episodic") then along = LEV.ep_along end

    along = math.clamp(0, along, 1)

    -- Level Control fine tune for Prog/Epi

    -- default when Level Control is off: ramp from "small" --> "large",
    local def_small = PARAM.float_level_lower_bound or 30
    local def_large = PARAM.float_level_upper_bound - def_small or 42

    -- this basically ramps up
    W = math.floor(def_small + along * def_large)
  else

    -- Single Size --

    W = ob_size
  end

  ::customsize::

  if not W then
    error("Invalid value for size : " .. tostring(ob_size))
  end

  -- Try to prevent grower failures with Micro levels
  if LEV.is_nature then
    W = math.max(W, 16)
  end

  gui.printf("Initial size for " .. LEV.name .. ": " .. W .. "\n")

  local H = 1 + math.floor(W * 0.8)

  return W, H
end



function Episode_determine_map_sizes()
  for _,LEV in pairs(GAME.levels) do
    local W, H = Level_determine_map_size(LEV)

    if LEV.is_procedural_gotcha == true then
      W = 26 -- defualt for proc gotchas
      if PARAM.gotcha_map_size then
        W = PROC_GOTCHA_MAP_SIZES[PARAM.gotcha_map_size]
      end
      if PARAM.bool_boss_gen == 1 then W = 16 end
      H = W
    end

    assert(W + 4 <= SEED_W)
    assert(H + 4 <= SEED_H)

    LEV.map_W = W
    LEV.map_H = H

    -- part of the experimental size multiplier experiments
    LEV.size_multiplier = 1
    LEV.area_multiplier = 1
    LEV.size_consistency = "normal"
    local mix_type = "normal"
    
    if PARAM.room_size_multiplier then
      if PARAM.room_size_multiplier ~= "vanilla"
      and PARAM.room_size_multiplier ~= "mixed" then
        LEV.size_multiplier = tonumber(PARAM.room_size_multiplier)
      end
    end

    if PARAM.room_area_multiplier then
      if PARAM.room_area_multiplier ~= "vanilla"
      and PARAM.room_area_multiplier ~= "mixed" then
        LEV.area_multiplier = tonumber(PARAM.room_area_multiplier)
      end
    end

    if PARAM.room_size_mix_type and PARAM.room_size_multiplier == "mixed" then
      LEV.size_multiplier = rand.key_by_probs(ROOM_SIZE_MULTIPLIER_MIXED_PROBS[PARAM.room_size_mix_type])
    end

    if PARAM.room_area_mix_type and PARAM.room_area_multiplier == "mixed" then
      LEV.area_multiplier = rand.key_by_probs(ROOM_AREA_MULTIPLIER_MIXED_PROBS[PARAM.room_area_mix_type])
    end

    if PARAM.room_size_consistency then
      if PARAM.room_size_consistency == "mixed" then
        LEV.size_consistency = rand.key_by_probs(SIZE_CONSISTENCY_MIXED_PROBS)
      else
        LEV.size_consistency = PARAM.room_size_consistency
      end
    end

    gui.printf(
      "size_multiplier: " .. LEV.size_multiplier .. "\n" ..
      "area_multiplier: " .. LEV.area_multiplier .. "\n" ..
      "size_consistency: " .. LEV.size_consistency .. "\n\n"
    )
  end
end



function Episode_pick_names()
--== Name Generator Test ==-- MSSP

  -- game name (for title screen)
  if not GAME.title then
    GAME.title = Naming_grab_one("TITLE")
  end

  if not GAME.sub_title then
    GAME.sub_title = Naming_grab_one("SUB_TITLE")
  end

  gui.printf("Game title: %s\n\n", GAME.title)
  gui.printf("Game sub-title: %s\n\n", GAME.sub_title)

  for index,EPI in pairs(GAME.episodes) do
    -- only generate names for used episodes
    if table.empty(EPI.levels) then goto continue end

    EPI.description = Naming_grab_one("EPISODE")

    gui.printf("Episode %d title: %s\n\n", index, EPI.description)
    ::continue::
  end
end



function Episode_decide_specials()


  ---| Episode_decide_specials |---

  for _,EPI in pairs(GAME.episodes) do
    -- TODO
  end

  -- dump the results

  local count = 0,

  gui.printf("\nSpecial levels:\n")

  for _,LEV in pairs(GAME.levels) do
    if LEV.special then
      gui.printf("  %s : %s\n", LEV.name, LEV.special)
      count = count + 1
    end
  end

  if count == 0 then
    gui.printf("  none\n")
  end
end



function Episode_plan_monsters()
  --
  -- Decides various monster stuff :
  --
  -- (1) monster palette for each level
  -- (2) the end-of-level boss of each level
  -- (3) guarding monsters (aka "mini bosses")
  -- (4) one day: boss fights for special levels
  --

  local used_types  = {}
  local used_bosses = {}
  local used_guards = {}

  local BOSS_AHEAD = 2.2


  local function default_level(info)
    local hp = info.health

    if hp < 45  then return 1 end
    if hp < 130 then return 3 end
    if hp < 450 then return 5 end

    return 7
  end


  local function init_monsters()

    for name,info in pairs(GAME.MONSTERS) do
      if not info.id then
        error(string.format("Monster '%s' lacks an id field", name))
      end

      -- default probability
      if not info.prob and not info.replaces then -- Try to keep replacement-only monsters from being added to the palette - Dasho
        info.prob = 50
      end

      -- default level
      if not info.level then
        info.level = default_level(info)
      end
    end
  end


  local function calc_monster_level(LEV)
  
    local mon_strength = PARAM.float_strength
    
    if mon_strength == 12 then
      LEV.monster_level = mon_strength
      return
    end

    local mon_along = LEV.game_along

    local ramp_up = PARAM.float_ramp_up or 1

    -- this is for Doom 1 / Ultimate Doom / Heretic
    if PARAM.episodic_monsters or ramp_up == gui.gettext("Episodic") then
      mon_along = (LEV.ep_along + LEV.game_along) / 2
    end

    if LEV.is_secret then
      -- secret levels are easier
      mon_along = mon_along * 0.75

    elseif OB_CONFIG.length == "single" then
      -- for single level, use skew to occasionally make extremes
      mon_along = rand.skew(0.6, 0.3)

    elseif OB_CONFIG.length == "game" then
      -- reach peak strength about 2/3rds along
      mon_along = mon_along * 1.7
    end

    assert(mon_along >= 0)

    -- apply the user Ramp-up setting
    -- [ and some tweaks for the Strength setting ]

    local factor

    if ramp_up ~= gui.gettext("Episodic") then
      factor = ramp_up
    else
      factor = 1.0
    end

    mon_along = mon_along * factor

    -- New adjustments for Monster Strength slider...may need to tune
    mon_along = mon_along + (mon_strength / 10)

    mon_along = 1.0 + (PARAM.mon_along_factor or 8.0) * mon_along

    -- add some randomness
    mon_along = mon_along + 0.7 * (gui.random() ^ 2)

    if LEV.is_procedural_gotcha then
      local gotcha_strength = 2

      if PARAM.bool_boss_gen == 1 then
        if PARAM.boss_gen_reinforce == "weaker" then
          gotcha_strength = math.max(8, mon_along * 0.9) * -1
        elseif PARAM.boss_gen_reinforce == "default" then
          gotcha_strength = math.max(4, mon_along * 0.75) * -1
        elseif PARAM.boss_gen_reinforce == "harder" then
          gotcha_strength = math.max(2, mon_along * 0.5) * -1
        elseif PARAM.boss_gen_reinforce == "tougher" then
          gotcha_strength = 2
        elseif PARAM.boss_gen_reinforce == "nightmare" then
          gotcha_strength = 16
        end
      elseif PARAM.float_gotcha_strength then
        gotcha_strength = PARAM.float_gotcha_strength
      end

      LEV.monster_level = mon_along + gotcha_strength
      if LEV.monster_level < 1 then
        LEV.monster_level = 1
      end

    else

    -- used by standard levels
      LEV.monster_level = mon_along
    end

  end


  local function check_theme(LEV, info)
    -- if no theme specified, monster is usable in all themes
    if not info.theme then return true end

    -- anything goes in CRAZY mode
    if PARAM.float_strength == 12 then return true end

    return info.theme == LEV.theme_name
  end


  local function is_monster_usable(LEV, mon, info)
    if not info.prob or info.prob <= 0 then return false end

    if info.level > LEV.monster_level 
    + (MONSTER_KIND_JUMPSTART_LEVELS[OB_CONFIG.mon_variety_jumpstart] or 0)
    then return false end

    if info.weap_min_damage and info.weap_min_damage > LEV.weap_max_damage then return false end

    if not check_theme(LEV, info) then return false end

    return true
  end


  local function mark_new_monsters()
    -- for each level, determine what monsters can be used, and also
    -- which ones are NEW for that level.
    local seen_monsters = {}

    for _,LEV in pairs(GAME.levels) do
      LEV.new_monsters = {}

      if not (LEV.prebuilt or LEV.is_secret) then
        for mon,info in pairs(GAME.MONSTERS) do
          if not seen_monsters[mon] and is_monster_usable(LEV, mon, info) then
            table.insert(LEV.new_monsters, mon)
            seen_monsters[mon] = true
          end
        end
      end

      LEV.seen_monsters = table.copy(seen_monsters)
    end
  end


  local function pick_single_for_level(LEV)
    local tab = {}

    if not LEV.episode.single_mons then
      LEV.episode.single_mons = {}
    end

    for name,_ in pairs(LEV.seen_monsters) do
      local info = GAME.MONSTERS[name]
      tab[name] = info.prob

      -- prefer monsters which have not been used before
      if LEV.episode.single_mons[name] then
        tab[name] = tab[name] / 100
      end
    end

    if table.empty(tab) then
      return
    end

    local name = rand.key_by_probs(tab)

    LEV.global_pal[name] = 1

    -- mark it as used
    LEV.episode.single_mons[name] = 1
  end


  local function pick_global_palette(LEV)
    --
    -- decides which monsters we will use on this level.
    -- easiest way is to pick some monsters NOT to use.
    --
    -- Note: we exclude BOSS monsters here, except in CRAZY mode.
    --

    LEV.global_pal = {}

    -- only one kind of monster in this level?
    if STYLE.mon_variety == "none" then
      pick_single_for_level(LEV)
      return
    end

    for name,_ in pairs(LEV.seen_monsters) do
      local info = GAME.MONSTERS[name]
      if not info.boss_type or PARAM.float_strength == 12 or LEV.is_procedural_gotcha then
        LEV.global_pal[name] = 1
      elseif info.boss_type and OB_CONFIG.bossesnormal ~= "no" then
        if info.boss_type == "minor" then
          LEV.global_pal[name] = 1
        elseif info.boss_type == "nasty" then
          if OB_CONFIG.bossesnormal == "nasty" or OB_CONFIG.bossesnormal == "all" then
            LEV.global_pal[name] = 1
          end
        elseif info.boss_type == "tough" and OB_CONFIG.bossesnormal == "all" then
          LEV.global_pal[name] = 1
        end
      end

      if PARAM.bool_enemy_drops and PARAM.bool_enemy_drops == true then
        if LEV.global_pal[name].give then
          LEV.global_pal[name].give = nil
        end
      end
    end

    -- actually skip some monsters (esp. when # is high)

    LEV.skip_monsters = {}

    local skip_num = (table.size(LEV.global_pal) - 9) / 6

    skip_num = rand.int(skip_num + LEV.game_along + 0.02)

    -- MSSP: Sometimes, *don't* skip monsters later on in the map
    -- because it's perfectly fine to have the whole kitchen sink
    if LEV.game_along > 0.5 then
      if rand.odds(50 * (LEV.game_along + 0.25)) then
        skip_num = rand.irange(0, skip_num)
      end
    end

    for i = 1, skip_num do
      local mon = rand.key_by_probs(LEV.global_pal)

      LEV.global_pal[mon] = nil

      table.insert(LEV.skip_monsters, mon)
    end

    -- Another attempt to really truly respect 0 prob in a theme's monster prefs
    if LEV.theme.monster_prefs then
      if LEV.theme.monster_prefs[mon] and LEV.theme.monster_prefs[mon] == 0 then
        LEV.global_pal[mon] = nil
      end
    end

  end


  local function is_boss_usable(LEV, mon, info)
    if LEV.is_procedural_gotcha then return true end

    if info.prob <= 0 then return false end
    if info.boss_prob == 0 then return false end

    if info.level > LEV.monster_level + BOSS_AHEAD then return false end

    if info.weap_min_damage and info.weap_min_damage > LEV.weap_max_damage then return false end

    return true
  end


  local function collect_usable_bosses(LEV, what)
    assert(what)

    local tab = {}

    for name,info in pairs(GAME.MONSTERS) do
      if LEV.theme.monster_prefs and LEV.theme.monster_prefs[name] and LEV.theme.monster_prefs[name] == 0 then goto skipboss end
      if LEV.is_procedural_gotcha and PARAM.bool_boss_gen == 1 then
        local bprob = 80
        if PARAM.boss_gen_typelimit ~= "nolimit" then
          local boss_diff = PARAM.boss_gen_diff
          local lolevel
          local hilevel
          if boss_diff == "easier" then
            lolevel = 1
            hilevel = 4
          elseif boss_diff == "default" then
            lolevel = 2
            hilevel = 6
          elseif boss_diff == "harder" then
            lolevel = 3
            hilevel = 8
          elseif boss_diff == "nightmare" then
            lolevel = 7
            hilevel = 9
          end
          if OB_CONFIG.length == "game" then
            if LEV.game_along < 0.4 then
              lolevel = math.max(1,lolevel-2)
              hilevel = hilevel-2
            elseif LEV.game_along < 0.7 then
              hilevel = hilevel-1
            else
              lolevel = math.min(9,lolevel+4)
              hilevel = math.min(9,hilevel+1)
            end
          end
          if PARAM.boss_gen_typelimit == "softlimit" then
            if info.level < lolevel then
              bprob = bprob/(lolevel-info.level+1)
            end
            if info.level > hilevel then
              bprob = bprob/(info.level-hilevel+1)
            end
            elseif PARAM.boss_gen_typelimit == "hardlimit" then
            if info.level < lolevel then
              bprob = 0
            end
            if info.level > hilevel then
              bprob = 0
            end
          end
        end
        if info.attack == "hitscan" then
          local hitred = PARAM.boss_gen_hitscan
          if hitred == "less" then
            bprob = bprob/2
          elseif hitred == "muchless" then
            bprob = bprob/5
          elseif hitred == "none" then
            bprob = 0
          end
        end
        if PARAM.bool_boss_gen_types == 1 and info.prob == 0 then
          bprob = 0
        end
        tab[name] = bprob
      else
        if info.boss_type == what and is_boss_usable(LEV, name, info) then
          tab[name] = info.boss_prob or 50
        end
      end
      ::skipboss::
    end

    return tab
  end


  local function prob_for_guard(LEV, info)
    if not info.prob or info.prob <= 0 then return 0 end

    -- simply too weak
    if info.health < 45 then return 0 end

    if info.weap_min_damage and info.weap_min_damage > LEV.weap_max_damage then return 0 end

    if info.level > LEV.monster_level + BOSS_AHEAD then return 0 end

    -- ignore theme-specific monsters (SS NAZI)
    if info.theme then return 0 end

    -- already used on this map?
    if LEV.seen_guards[info.name] then return 0 end

    -- base probability : this value is designed to take into account
    -- the settings of the monster control module
    local prob = (info.damage or 1)

    if OB_CONFIG.bosses == "easier" then
      prob = prob ^ 0.3
    elseif OB_CONFIG.bosses == "harder" then
      prob = prob ^ 1.2
    else
      prob = prob ^ 0.6
    end

    if LEV.seen_monsters[info.name] then
      prob = prob / 10
    elseif not used_guards[info.name] then
      prob = prob * 5
    end

    return prob
  end


  local function collect_usable_guards(LEV)
    local tab = {}

    for name,info in pairs(GAME.MONSTERS) do
      -- skip the real boss monsters
      if info.boss_type then
        if OB_CONFIG.bossesnormal == "no" then goto continue
        elseif info.boss_type == "nasty" and OB_CONFIG.bossesnormal == "minor" then goto continue
        elseif info.boss_type == "tough" and OB_CONFIG.bossesnormal ~= "all" then goto continue end
      end

      if LEV.theme.monster_prefs and LEV.theme.monster_prefs[name] and LEV.theme.monster_prefs[name] == 0 then goto continue end

      local prob = prob_for_guard(LEV, info)

      if prob > 0 then
        tab[name] = prob
      end
      ::continue::
    end

    return tab
  end


  local function count_boss_type(LEV, what)
    return table.size(collect_usable_bosses(LEV, what))
  end


  local function pick_boss_quotas(LEV)
    local c_minor = count_boss_type(LEV, "minor")
    local c_nasty = count_boss_type(LEV, "nasty")
    local c_tough = count_boss_type(LEV, "tough")

    local user_factor = BOSS_FACTORS[OB_CONFIG.bosses]
    assert(user_factor)

    -- Tough quota

    local prob1 = 0

    if LEV.dist_to_end then
      local factor = sel(c_tough < 2, 40, 20)
      prob1 = 100 - (LEV.dist_to_end - 1) * factor
      prob1 = prob1 * user_factor
    end

    if c_tough > 0 and rand.odds(prob1) then
      LEV.boss_quotas.tough = 1

      prob1 = prob1 * LEV.game_along * user_factor

      if rand.odds(prob1) and used_types["tough"] then
        LEV.boss_quotas.tough = 2
      end
    end

    if LEV.boss_quotas.tough > 0 then
      used_types["tough"] = true
    end


    -- Nasty quota

    local prob2 = sel(c_nasty < 2, 25, 40)

    if LEV.dist_to_end == 2 then
      prob2 = 90
    end

    prob2 = prob2 * user_factor

    if c_nasty > 0 and rand.odds(prob2) then
      LEV.boss_quotas.nasty = 1

      prob2 = prob2 * LEV.game_along * user_factor

      if rand.odds(prob2) and used_types["nasty"] then
        LEV.boss_quotas.nasty = 2
      end
    end

    if LEV.boss_quotas.nasty > 0 then
      used_types["nasty"] = true
    end


    -- Minor quota

    local prob3 = sel(c_minor < 2, 40, 70)

    if LEV.dist_to_end == 3 then
      prob3 = 99
    end

    prob3 = prob3 * user_factor

    if c_minor > 0 and rand.odds(prob3) then
      LEV.boss_quotas.minor = 1

      prob3 = prob3 * LEV.game_along * user_factor

      if rand.odds(prob3) and used_types["minor"] then
        LEV.boss_quotas.minor = 2
      end
    end

    if LEV.boss_quotas.minor > 0 then
      used_types["minor"] = true
    end


    -- Guard quota

    local total = LEV.boss_quotas.tough +
                  LEV.boss_quotas.nasty +
                  LEV.boss_quotas.minor

    LEV.boss_quotas.guard = math.clamp(2, 4 - total, 4)
  end


  local function create_fight(LEV, boss_type, along)
    local bosses = collect_usable_bosses(LEV, boss_type)

    if table.empty(bosses) then return end

    local mon  = rand.key_by_probs(bosses)
    local info = GAME.MONSTERS[mon]

    -- select how many

    local count = 1 + LEV.game_along

    if boss_type ~= "tough" then count = count ^ 1.5 end

    -- user quantity setting
    local factor = MONSTER_QUANTITIES[OB_CONFIG.mons] or 1
    if factor > 1 then factor = (factor + 1) / 2 end

    count = count * factor

    if OB_CONFIG.bosses == "easier" then count = count / 1.6 end
    if OB_CONFIG.bosses == "harder" then count = count * 1.6 end

    count = rand.int(count)

    if boss_type == "tough" then
      count = math.clamp(1, count, 2)
    elseif boss_type == "nasty" then
      count = math.clamp(1, count, 4)
    else
      count = math.clamp(1, count, 6)
    end

    -- secondary boss fights should be weaker than primary one
    if along >= 3 then
      count = 1
    elseif along == 2 then
      if count == 2 or count == 3 then
        count = rand.sel(75, 1, 2)
      elseif count > 1 then
        count = rand.sel(50, 2, math.ceil(count / 2))
      end
    end

    -- this is to prevent Masterminds infighting
    if info.boss_limit then
      count = math.min(count, info.boss_limit)
    end

    -- ensure first encounter with a boss only uses a single one
    count = math.min(count, 1 + (used_bosses[mon] or 0))

    if LEV.is_procedural_gotcha and PARAM.bool_boss_gen == 1 then
      count = 1
    end

--  stderrf("  count %1.2f for '%s'\n", count, mon)

    local FIGHT =
    {
      mon = mon,
      count = count,
      boss_type = boss_type
    }

    table.insert(LEV.boss_fights, FIGHT)

    used_bosses[mon] = math.max(used_bosses[mon] or 0, count)

    return true  -- ok
  end


  local function create_guard(LEV, along)
    local guards = collect_usable_guards(LEV)

--- stderrf("%s Usable guards:\n%s\n", LEV.name, table.tostr(guards))

    if table.empty(guards) then return end

    local mon  = rand.key_by_probs(guards)
    local info = GAME.MONSTERS[mon]

    -- select how many

    local count = 2 * (1.5 + LEV.game_along)

    -- user quantity setting
    local factor = MONSTER_QUANTITIES[OB_CONFIG.mons] or 1
    if factor > 1 then factor = (factor + 1) / 2 end

    count = count * factor

    if OB_CONFIG.bosses == "easier" then count = count / 1.6 end
    if OB_CONFIG.bosses == "harder" then count = count * 1.6 end

    -- secondary boss fights should be weaker than primary one
    count = count / (1.8 ^ (along - 1))

    -- bump large monsters down a bit
    if info.r > 32 then count = count / 1.6 end

--stderrf("   raw: %1.2f x %s\n", count, mon)

    count = rand.int(count)
    count = math.clamp(1, count, 8)

    -- ensure first encounter with a guard only uses a single one
    count = math.min(count, 1 + (used_guards[mon] or 0))

    local FIGHT =
    {
      mon = mon,
      count = count,
      boss_type = "guard"
    }

    table.insert(LEV.boss_fights, FIGHT)

    LEV.seen_guards[mon] = true

    used_guards[mon] = math.max(used_guards[mon] or 0, count)
  end


  local function decide_boss_fights()
    for _,LEV in pairs(GAME.levels) do
      LEV.boss_fights = {}
      LEV.seen_guards = {}

      LEV.boss_quotas = { minor=0, nasty=0, tough=0 }

      if LEV.is_procedural_gotcha and PARAM.bool_boss_gen == 1 then
        create_fight(LEV, "tough", 1)
        goto continue
      end

      if LEV.prebuilt  then goto continue end
      if LEV.is_secret then goto continue end

      if PARAM.float_strength == 12 then goto continue end
      if OB_CONFIG.bosses   == "none"  then goto continue end

      pick_boss_quotas(LEV)

      -- hax for procedural gotchas
      if LEV.is_procedural_gotcha and PARAM.bool_gotcha_boss_fight == 1 then
        if LEV.game_along <= 0.33 then
          if LEV.boss_quotas.minor < 1 then LEV.boss_quotas.minor = 1 end
        elseif LEV.game_along > 0.33 and LEV.game_along <= 0.66 then
          if LEV.boss_quotas.nasty < 1 then LEV.boss_quotas.nasty = 1 end
        elseif LEV.game_along > 0.66 then
          if LEV.boss_quotas.tough < 1 then LEV.boss_quotas.tough = 1 end
        end

        if LEV.boss_quotas.guard < 2 then
          LEV.boss_quotas.guard = rand.int(2, 4)
        end
      end

      for i = 1, LEV.boss_quotas.tough do create_fight(LEV, "tough", i) end
      for i = 1, LEV.boss_quotas.nasty do create_fight(LEV, "nasty", i) end
      for i = 1, LEV.boss_quotas.minor do create_fight(LEV, "minor", i) end

      for k = 1, LEV.boss_quotas.guard do create_guard(LEV, k) end
      ::continue::
    end
  end


  local function palette_str(LEV)
    local names = table.keys_sorted(LEV.global_pal)

    return table.list_str(names)
  end


  local function boss_quota_str(LEV)
    local list = {}

    table.insert(list, LEV.boss_quotas.minor)
    table.insert(list, LEV.boss_quotas.nasty)
    table.insert(list, LEV.boss_quotas.tough)

    return table.list_str(list)
  end


  local function boss_fight_str(LEV)
    local names = {}

    for _,F in pairs(LEV.boss_fights) do
      local s = F.mon
      if F.count > 1 then
        s = string.format("%dx %s", F.count, F.mon)
      end
      table.insert(names, s)
    end

    return table.list_str(names)
  end


  local function dump_monster_info()
    gui.debugf("\nPlanned monsters:\n\n")

    for _,LEV in pairs(GAME.levels) do
      gui.debugf("%s\n", LEV.name)
      gui.debugf("  level = %1.2f\n", LEV.monster_level)
      if LEV.dist_to_end then
        gui.debugf("  dist_to_end = %d\n", LEV.dist_to_end)
      end
      gui.debugf("  new  = %s\n", table.list_str(LEV.new_monsters))
      gui.debugf("  pal  = %s\n", palette_str(LEV))
      gui.debugf("  skip = %s\n", table.list_str(LEV.skip_monsters))
      gui.debugf("  b_quotas = %s\n", boss_quota_str(LEV))
      gui.debugf("  bosses = %s\n", boss_fight_str(LEV))
    end
  end


  ---| Episode_plan_monsters |---

  init_monsters()

  if OB_CONFIG.bosses == "easier" then BOSS_AHEAD = 1.9 end
  if OB_CONFIG.bosses == "harder" then BOSS_AHEAD = 2.7 end

  for _,LEV in pairs(GAME.levels) do
    calc_monster_level(LEV)
  end

  mark_new_monsters()

  for _,LEV in pairs(GAME.levels) do
    pick_global_palette(LEV)
  end

  decide_boss_fights()

  dump_monster_info()
end



function Episode_plan_weapons()
  --
  -- Decides weapon stuff :
  --
  -- (1) which levels the weapons are first used on
  -- (2) the starting weapon(s) of a level
  -- (3) other must-give weapons of a level
  -- (4) a earlier-than-normal weapon for secrets
  --

  local QUOTA_ADJUSTS = { very_late=0.55, later=0.70, sooner=1.50, very_soon=2.00 }
  local PLACE_ADJUSTS = { very_late=1.70, later=1.30, sooner=0.50, very_soon=0.20 }

  local function calc_weapon_quota(LEV)
    -- decide how many weapons to give

    -- normal quota should give 1-2 in small maps, 2-3 in regular maps, and 3-4,
    -- in large maps (where 4 is rare).

    if OB_CONFIG.weapons == "none" then
      LEV.weapon_quota = 0
      return
    end

    local lev_size = math.clamp(30, LEV.map_W + LEV.map_H, 100)

    local quota = (lev_size - 12) / 25 + gui.random()

    quota = quota * (QUOTA_ADJUSTS[OB_CONFIG.weapons] or 1.0)

    if OB_CONFIG.weapons == "mixed" then
      quota = quota * rand.pick({ 0.6, 1.0, 1.6 })
    end

    -- more as game progresses
    if PARAM.bool_pistol_starts == 1 then
      quota = quota + math.clamp(0, LEV.game_along, 0.5) * 3.1
    else
      quota = quota + math.clamp(0, LEV.game_along, 0.5) * 6.1
    end

    quota = quota * (PARAM.weapon_factor or 1)
    quota = math.floor(quota)

    if quota < 1 then quota = 1 end

    -- be more generous in the very first level
    if LEV.id <= 2 and quota == 1 and
       not (OB_CONFIG.weapons == "later" or OB_CONFIG.weapons == "very_late")
    then
      quota = 2
    end

    if PARAM.bool_scale_items_with_map_size and PARAM.bool_scale_items_with_map_size == 1 then
      quota = math.min(1, math.round(quota * (1 + (LEV.map_W / 75))))
    end    

    LEV.weapon_quota = quota
  end


  local function next_level_in_episode(lev_idx)
    while true do
      local LEV = GAME.levels[lev_idx + 1]

      if not LEV then return nil end

      if LEV.episode ~= GAME.levels[lev_idx].episode then return nil end

      lev_idx = lev_idx + 1

      if LEV.is_secret then goto continue end
      if LEV.prebuilt  then goto continue end

      if LEV then return LEV end
      ::continue::
    end
  end


  local function next_next_level(lev_idx)
    local NL = next_level_in_episode(lev_idx)
    if not NL then return nil end

    for i = 1,3 do
      local PL = next_level_in_episode(lev_idx + i)
      if PL and PL ~= NL then return PL end
    end

    return nil
  end


  local function dump_weapon_info()
    gui.debugf("\nPlanned weapons:\n\n")

    for _,LEV in pairs(GAME.levels) do
      gui.debugf("%s\n", LEV.name)

      gui.debugf("  new    = %s\n", table.list_str(LEV.new_weapons))
      gui.debugf("  start  = %s\n", table.list_str(LEV.start_weapons))
      gui.debugf("  other  = %s\n", table.list_str(LEV.other_weapons))

      gui.debugf("  secret = %s\n", LEV.secret_weapon or "NONE")
      gui.debugf("  quota  = %d\n", LEV.weapon_quota)
    end
  end


  local function should_swap(name1, name2)
    local info1 = GAME.WEAPONS[name1]
    local info2 = GAME.WEAPONS[name2]

    if info1.upgrades and info1.upgrades == info2.name then
      return true
    end

    return false
  end


  local function swap_upgraded_weapons(L1, L2)
    for idx1 = 1, #L1.new_weapons do
    for idx2 = 1, #L2.new_weapons do
      local name1 = L1.new_weapons[idx1]
      local name2 = L2.new_weapons[idx2]

      if should_swap(name1, name2) then
        L1.new_weapons[idx1] = name2
        L2.new_weapons[idx2] = name1

        gui.debugf("swapped weapon '%s' in %s <--> '%s' in %s\n", name1, L1.name, name2, L2.name)
      end
    end
    end
  end


  local function summarize_weapons_on_map(LEV)
    if LEV.prebuilt  then return "#" end
    if LEV.is_secret then return "#" end

    if table.empty(LEV.new_weapons) then return "-" end

    local str = ""

    for _,name in pairs(LEV.new_weapons) do
      local letter = string.sub(name, 1, 1)
      if name == "super" then letter = 'D' end
      if name == "bfg"   then letter = 'B' end
      str = str .. letter
    end

    return str
  end


  local function summarize_new_weapon_placement()
    local line = ""

    for _,LEV in pairs(GAME.levels) do
      if LEV.id > 1 then line = line .. "/" end
      line = line .. summarize_weapons_on_map(LEV)
    end

    return line
  end


  local function calc_new_weapon_place(info, level_list)
    -- transform 'level' value into an index into level_list[]

    -- handle short list of maps
    -- [ OB_CONFIG.length == "single" or "few" ]
    if #level_list <= 5 then
      return rand.pick(level_list)
    end

    local lev_idx = info.level
    assert(lev_idx)

    if lev_idx > 1 then
      -- apply the user Weapons setting
      local factor = (PLACE_ADJUSTS[OB_CONFIG.weapons] or 1.0)

      -- less spread out when building a single episode
      if OB_CONFIG.length == "episode" then
        factor = factor * 0.75
      end

      lev_idx = 1 + (lev_idx - 1) * factor

      if rand.odds(30) then lev_idx = lev_idx + 1 end

      lev_idx = math.floor(lev_idx * rand.pick({ 1.0, 1.3, 1.6 }))
    end

    -- ensure it is valid
    lev_idx = math.clamp(1, lev_idx, #level_list)

    return level_list[lev_idx]
  end


  local function check_new_weapon_at_start()
    -- ensure the very first level has a new weapon
    local LEV = GAME.levels[1]

    if not table.empty(LEV.new_weapons) then return end

    for i = 2, #GAME.levels do
      local NEXT = GAME.levels[i]

      if not table.empty(NEXT.new_weapons) then
        local weap = table.remove(NEXT.new_weapons, 1)
        table.insert(LEV.new_weapons, weap)
        return
      end
    end
  end


  local function eval_push_away_offset(level_list, idx, ofs)
    local LEV = level_list[idx]

    idx = idx + ofs

    -- no such map?
    if idx < 1 or idx > #level_list then
      return -1
    end

    -- prevent moving too far when user wants lots of weapons
    if math.abs(ofs) >= 2 and
       (OB_CONFIG.weapons == "sooner" or OB_CONFIG.weapons == "very_soon")
    then
      return -1
    end

    local NEXT = level_list[idx]
    assert(NEXT)

    -- no point moving when destination is just as full as source
    local  src_count = table.size( LEV.new_weapons)
    local dest_count = table.size(NEXT.new_weapons)

    if dest_count >= src_count - 1 then
      return -2
    end

    -- best places have no weapons at all
    local score = 90 - math.min(dest_count, 5) * 10

    -- check if destination is in middle of a run of empty maps
    if idx-1 >= 1 and idx+1 <= #level_list and
       dest_count == 0 and
       table.empty(level_list[idx-1].new_weapons) and
       table.empty(level_list[idx+1].new_weapons)
    then
      score = score + 2

    elseif math.abs(ofs) < 2 then
      score = score + 1
    end

    -- tie breaker
    return score + gui.random()
  end


  local function push_away_a_weapon(level_list, idx)
    local LEV = level_list[idx]

    assert(not table.empty(LEV.new_weapons))

    local best_ofs
    local best_score = 0

    for ofs = -2, 2 do
      if ofs ~= 0 then
        local score = eval_push_away_offset(level_list, idx, ofs)

        if score > best_score then
          best_ofs   = ofs
          best_score = score
        end
      end
    end

    if best_ofs == nil then return end

    -- ok --

    local NEXT = level_list[idx + best_ofs]
    assert(NEXT)

    local weap = table.remove(LEV.new_weapons, 1)

    table.insert(NEXT.new_weapons, weap)
    rand.shuffle(NEXT.new_weapons)
  end


  local function spread_new_weapons(level_list)
    -- prefer not to introduce multiple new weapons per map

    if OB_CONFIG.weapons == "very_soon" then return end

    for idx = 1, #level_list do
      for loop = 1,5 do
        if table.size(level_list[idx].new_weapons) >= 2 then
          push_away_a_weapon(level_list, idx)
        end
      end
    end
  end


  local function detect_a_weapon_gap(level_list, start)
    -- returns size of gap, possibly 0, or -1 if there is no gap
    -- (e.g. if the given map is the last non-empty one).

    if table.empty(level_list[start].new_weapons) then return -1 end

    local finish = start + 1

    while true do
      if finish > #level_list then return -1 end

      if not table.empty(level_list[finish].new_weapons) then break; end

      finish = finish + 1
    end

    return finish - start - 1
  end


  local function shift_new_weapons_down(level_list, start)
    while start < #level_list do
      local LEV  = level_list[start]
      assert(LEV)

      local NEXT = level_list[start + 1]
      assert(NEXT)

      table.append(LEV.new_weapons, NEXT.new_weapons)
      NEXT.new_weapons = {}

      start = start + 1
    end
  end


  local function reduce_weapon_gaps(level_list)
    local max_gap = 2

    max_gap = max_gap + math.floor(#level_list / 20)

    if OB_CONFIG.weapons == "very_late" then max_gap = max_gap + 2 end
    if OB_CONFIG.weapons == "later"     then max_gap = max_gap + 1 end

    if OB_CONFIG.weapons == "sooner"    then max_gap = 1 end
    if OB_CONFIG.weapons == "very_soon" then max_gap = 1 end

    for start = 1, #level_list do
      local gap = detect_a_weapon_gap(level_list, start)

      -- lesser gaps near start
      local max_gap2 = max_gap
      if max_gap2 >= 2 and start <= 4 then
         max_gap2 = max_gap2 - 1
      end

      while gap > max_gap2 do
        shift_new_weapons_down(level_list, start + 1)
        gap = gap - 1
      end
    end
  end


  local function check_upgraded_weapons()
    -- ensure certain weapon pairs occur in the expected order
    -- [ e.g. regular shotgun comes before the super-shotgun ]

    for idx1 = 1, #GAME.levels do
    for idx2 = idx1 + 1, #GAME.levels do
      local L1 = GAME.levels[idx1]
      local L2 = GAME.levels[idx2]

      swap_upgraded_weapons(L1, L2)
    end
    end
  end


  local function place_new_weapons()
    local level_list = {}

    for _,LEV in pairs(GAME.levels) do
      LEV.new_weapons = {}

      if LEV.prebuilt  then goto continue end
      if LEV.is_secret then goto continue end

      table.insert(level_list, LEV)
      ::continue::
    end

    assert(#level_list >= 1)

    for name,info in pairs(GAME.WEAPONS) do
      -- skip non-item and disabled weapons
      if (info.add_prob or 0) == 0 then goto continue end

      local LEV = calc_new_weapon_place(info, level_list)
      assert(LEV)

      table.insert(LEV.new_weapons, name)
      rand.shuffle(LEV.new_weapons)
      ::continue::
    end

    spread_new_weapons(level_list)

    check_new_weapon_at_start()

    check_upgraded_weapons()

    reduce_weapon_gaps(level_list)

--  stderrf("%s\n", summarize_new_weapon_placement())
  end


  local function calc_max_damage(LEV)
    local max_damage = 5

    max_damage = MONSTER_KIND_JUMPSTART[OB_CONFIG.mon_variety_jumpstart] or 0

    for name,_ in pairs(LEV.seen_weapons) do
      local info = GAME.WEAPONS[name]

      local W_damage = info.rate * info.damage

      max_damage = math.max(max_damage, W_damage)
    end

    LEV.weap_max_damage = max_damage
  end


  local function determine_seen_weapons()
    -- "seen" means weapons which have been given in some previous map
    -- (and does not include secret weapons)
    local seen_weapons = {}

    for _,LEV in pairs(GAME.levels) do
      LEV.seen_weapons = table.copy(seen_weapons)

      for _,name in pairs(LEV.new_weapons) do
        seen_weapons[name] = true
      end

      calc_max_damage(LEV)
    end
  end


  local function choose_hidden_weapon(LEV)
    local tab = {}

    tab.NONE = 100

    for name,info in pairs(GAME.WEAPONS) do
      if not LEV.seen_weapons[name] then goto continue end

      local prob = info.hide_prob or 0

      if prob > 0 then
        tab[name] = prob
      end
      ::continue::
    end

    local weapon = rand.key_by_probs(tab)

    if weapon ~= "NONE" then
      LEV.secret_weapon = weapon
    end
  end


  local function pick_secret_weapons()
    local last_one

    for index,LEV in pairs(GAME.levels) do
      local NL = next_level_in_episode(index)
      local PL = next_next_level(index)

      -- build up a probability table
      local tab = {}

      if NL then for _,name in pairs(NL.new_weapons) do tab[name] = 200 end end
      if PL then for _,name in pairs(PL.new_weapons) do tab[name] = 100 end end

      if last_one and tab[last_one] then
        tab[last_one] = tab[last_one] / 100
      end

      if not table.empty(tab) then
        LEV.secret_weapon = rand.key_by_probs(tab)

        last_one = LEV.secret_weapon
      else
        choose_hidden_weapon(LEV)
      end
    end
  end


  local function prob_for_weapon(LEV, name, info, is_start)
    local prob  = info.add_prob or 0
    local level = info.level or 1

    -- ignore weapons which lack a pick-up item
    if prob <= 0 then return 0 end

    -- must be NEW or given in a previous map
    if not table.has_elem(LEV.new_weapons, name) and
       not LEV.seen_weapons[name]
    then
      return 0
    end

    -- must not be used already in this map
    if LEV.start_weapons and table.has_elem(LEV.start_weapons, name) then return 0 end
    if LEV.other_weapons and table.has_elem(LEV.other_weapons, name) then return 0 end

    if name == LEV.secret_weapon then return 0 end

    -- prefer simpler weapons for start rooms
    -- [ except in crazy monsters mode, player may need a bigger weapon! ]
    if is_start and PARAM.float_strength < 12 or LEV.is_procedural_gotcha ~= "true" then
      if level <= 2 then prob = prob * 4 end
      if level == 3 then prob = prob * 2 end

      -- also want NEW weapons to appear elsewhere in the level
      if level >= 3 and table.has_elem(LEV.new_weapons, name) then
        prob = prob / 1000
      end
    end

    return prob
  end


  local function decide_weapon(LEV, is_start, last_ones)
    -- determine probabilities
    local tab = {}

    for name,info in pairs(GAME.WEAPONS) do
      local prob = prob_for_weapon(LEV, name, info, is_start)

      if prob > 0 then
        tab[name] = prob
      end
    end

--DEBUG
--  stderrf("decide_weapon list in %s:\n%s\n", LEV.name, table.tostr(tab))

    -- nothing is possible? ok...
    if table.empty(tab) then return nil end

    return rand.key_by_probs(tab)
  end


  local function pick_start_weapons()
    -- decide how many we want, either 1, 2 or 3.
    -- should be more in later levels.

    local prev_ones

    for _,LEV in pairs(GAME.levels) do
      LEV.start_weapons = {}

      local want_num = 1

      local extra_prob1 = 15 + 85 * math.clamp(0, LEV.game_along, 1)
      local extra_prob2 =  5 + 45 * math.clamp(0, LEV.game_along, 1)

      if rand.odds(extra_prob1) then want_num = want_num + 1 end
      if rand.odds(extra_prob2) then want_num = want_num + 1 end

      -- in very first few maps, only give a single start weapon
      if (LEV.id <= 2 or LEV.game_along < 0.2) and LEV.new_weapons[1] then
        want_num = 1
      end

      if want_num > LEV.weapon_quota then
         want_num = LEV.weapon_quota
      end

--[[
      -- skip one sometimes
      -- [ but never in the first few maps ]
      local skip_prob = 1,

      if OB_CONFIG.weapons == "very_late" then skip_prob = 40 end
      if OB_CONFIG.weapons == "later"     then skip_prob = 20 end
      if OB_CONFIG.weapons == "normal"    then skip_prob = 10 end

      if LEV.id >= 3 and LEV.ep_along >= 0.2 and rand.odds(skip_prob) then
        want_num = want_num - 1,
      end
--]]

      for i = 1, want_num do
        local name = decide_weapon(LEV, "is_start", prev_ones)

        if name then
          table.insert(LEV.start_weapons, name)
        end
      end

      prev_ones = LEV.start_weapons
    end
  end


  local function pick_other_weapons()
    local prev_ones

    for _,LEV in pairs(GAME.levels) do
      -- collect the ones we *must* give
      LEV.other_weapons = table.copy(LEV.new_weapons)

      -- subtract the ones already given
      for _,w in pairs(LEV.start_weapons) do
        table.kill_elem(LEV.other_weapons, sw)
      end

      -- note that it is possible to exceed the quota
      -- (it does not happen very often and is not a show-stopper)

      local extra_num = LEV.weapon_quota - (#LEV.start_weapons + #LEV.other_weapons)

      for i = 1, extra_num do
        local name = decide_weapon(LEV, nil, prev_ones)

        if name then
          table.insert(LEV.other_weapons, name)
        end
      end

      prev_ones = LEV.other_weapons
    end
  end


  ---| Episode_plan_weapons |---

  for _,LEV in pairs(GAME.levels) do
    calc_weapon_quota(LEV)
  end

  place_new_weapons()

  determine_seen_weapons()

  pick_secret_weapons()
  pick_start_weapons()
  pick_other_weapons()

  dump_weapon_info()
end



function Episode_plan_items()
  --
  -- Handles certain items that should only appear quite rarely and
  -- not clumped together, e.g. the DOOM invulnerability sphere.
  --

  ---| Episode_plan_items |---
  -- TODO
end


------------------------------------------------------------------------

function Episode_plan_game()
  --
  -- This plans stuff for the whole game, e.g. what weapons will
  -- appear on each level, etc....
  --

  table.name_up(GAME.MONSTERS)
  table.name_up(GAME.WEAPONS)
  table.name_up(GAME.PICKUPS)

  Episode_decide_specials()

  Episode_determine_map_sizes()

  Episode_pick_names()

  Episode_plan_weapons()
  Episode_plan_items()
  Episode_plan_monsters()
end


------------------------------------------------------------------------


function Level_choose_themes()
  local theme_tab = {}

  local do_mostly = false
  local do_less = false

  local function collect_mixed_themes()
    for name,info in pairs(OB_THEMES) do
      if info.shown and info.mixed_prob then
        theme_tab[name] = info.mixed_prob
      end
    end

    if table.empty(theme_tab) then
      error("Game is missing usable themes.")
    end
  end


  local function set_a_theme(LEV, name)
    assert(name)

    -- don't overwrite theme of special levels
    if LEV.theme_name then
      name = LEV.theme_name
    end

    -- special handling for Psychedelic theme
    if name == "psycho" then
      LEV.psychedelic = true

      if not LEV.name_class and ((LEV.id % 2) == 1) then
        LEV.name_class = "PSYCHO"
      end

      -- pick a real theme to use
      name = rand.key_by_probs(theme_tab)
    end

    local info = OB_THEMES[name]

    if not info then
      error("Internal error : unknown OB_THEME: " .. tostring(name))
    end

    LEV.theme_name = name

    LEV.theme = GAME.THEMES[name]

    if not LEV.theme then
      error("Unknown theme : " .. name)
    end

    -- this is optional (may be nil)
    LEV.name_class = LEV.name_class or info.name_class

    gui.printf("Theme for level %s = %s\n", LEV.name, LEV.theme_name)
  end


  local function decide_mixins(EPI, main_theme, mixins, mode)
    if not theme_tab[main_theme] then
      --error("Broken code handling mostly_xxx themes")
    end

    local new_tab = table.copy(theme_tab)

    new_tab[main_theme] = nil

    if table.empty(new_tab) then return end

    if mode == "mostly" then
      local pos = rand.pick({ 3,4,4,5,5,6 })

      while pos <= #EPI.levels do
        local LEV = EPI.levels[pos]

        mixins[LEV.name] = rand.key_by_probs(new_tab)

        pos = pos + rand.pick({ 3,4,4,5,5 })
      end
    elseif mode == "less" then
      local pos = 1
      local countdown = rand.irange( 0,3 )
      local prev_theme = rand.key_by_probs(new_tab)
      new_tab[prev_theme] = new_tab[prev_theme] / 10

      while pos <= #EPI.levels do
        local LEV = EPI.levels[pos]

        if countdown > 0 then
          mixins[LEV.name] = prev_theme
          countdown = countdown - 1
        elseif countdown <= 0 then
          mixins[LEV.name] = main_theme
          countdown = rand.pick({ 2,3,3,4,4,5 })
          prev_theme = rand.key_by_probs(new_tab)
          new_tab[prev_theme] = new_tab[prev_theme] / 10
        end

        pos = pos + 1
      end
    end
  end


  local function grow_episode_list(list)
    if #list == 1 then
      table.insert(list, list[1])
      table.insert(list, list[1])
    end

    if #list == 2 then
      local dist = rand.sel(70, 0, 1)
      table.insert(list, list[1 + dist])
      table.insert(list, list[2 - dist])
    end

    assert(#list >= 3)

    -- concatenate a shuffled copy of the list, doubling its size
    local shuffled = table.copy(list)

    rand.shuffle(shuffled)

    table.append(list, shuffled)
  end


  local function create_episode_list(want_num)
    local list = {}

    local tab   = table.copy(theme_tab)
    local total = table.size(theme_tab)

    while not table.empty(tab) do
      local name = rand.key_by_probs(tab)
      tab[name] = nil

      table.insert(list, name)
    end

    gui.debugf("Initial episode list = \n%s\n", table.tostr(list))

    -- grow list until it is large enough
    while #list < want_num do
      grow_episode_list(list)
    end

    gui.debugf("Grown episode list = \n%s\n", table.tostr(list))

    return list
  end


  local function set_an_episode(EPI, name)
    local mixins = {}

    if do_mostly then
      decide_mixins(EPI, name, mixins, "mostly")
    end

    if do_less then
      decide_mixins(EPI, name, mixins, "less")
    end

    for _,LEV in pairs(EPI.levels) do
      set_a_theme(LEV, mixins[LEV.name] or name)
    end
  end


  local function set_single_theme(theme_name)
    for _,episode in pairs(GAME.episodes) do
      set_an_episode(episode, theme_name)
    end
  end


  local function set_jumbled_themes()
    local last_theme

    for _,LEV in pairs(GAME.levels) do
      local tab = table.copy(theme_tab)

      -- prefer a different theme than the last one
      if last_theme then
        tab[last_theme] = tab[last_theme] / 10
      end

      last_theme = rand.key_by_probs(tab)

      set_a_theme(LEV, last_theme)
    end
  end


  local function set_original_themes()
    for _,EPI in pairs(GAME.episodes) do
      if not EPI.theme then
        error("Broken episode def : missing 'theme' field")
      end

      set_an_episode(EPI, EPI.theme)
    end
  end


  local function set_episodic_themes()
    local num_eps = #GAME.episodes

    local episode_list = create_episode_list(num_eps)

    for _,EPI in pairs(GAME.episodes) do
      set_an_episode(EPI, episode_list[EPI.id])
    end
  end


  local function set_bit_mixed_themes()
    -----------------------   1   2   3   4,
    local BIT_MIXED_PROBS = { 0, 30, 60, 40 }

    local num_levels = #GAME.levels

    local episode_list = create_episode_list(num_levels)

    local pos = 1

    while pos <= num_levels do
      local name = table.remove(episode_list, 1)
      assert(name)

      local info = OB_THEMES[name]

      local length = rand.index_by_probs(BIT_MIXED_PROBS)

      if info.bit_limited then
        length = 1
      end

      for i = 1, length do
        local LEV = GAME.levels[pos]
        set_a_theme(LEV, name)

        pos = pos + 1

        if pos > num_levels then break; end
      end
    end
  end



  ---| Level_choose_themes |---

  gui.printf("\n")

  -- need to do this first
  collect_mixed_themes()


  local theme = OB_CONFIG.theme

  -- extract the part after the "mostly_" or "less_" prefix
  local mostly_theme = string.match(theme, "mostly_(%w+)")


  if mostly_theme then
    do_mostly = true
    theme = mostly_theme
  end

  if OB_CONFIG.mixin_type == "mostly" then
    do_mostly = true
  elseif OB_CONFIG.mixin_type == "less" then
    do_less = true
  end

  -- As Original : follow the original game
  if theme == "original" then
    set_original_themes()
    return
  end

  -- Episodic : each episode is a single (random) theme
  if theme == "epi" then
    set_episodic_themes()
    return
  end

  -- Bit Mixed : theme changes every 3-4 maps or so
  if theme == "bit_mixed" then
    set_bit_mixed_themes()
    return
  end

  -- Jumbled Up : every level is purely random
  if theme == "jumble" then
    set_jumbled_themes()
    return
  end


  -- the user has specified the main theme
  set_single_theme(theme)
end



function Level_do_styles(LEVEL)
  local style_tab

  style_tab = table.copy(GLOBAL_STYLE_LIST)

  -- game, level and theme specific style_lists
  if GAME.STYLE_LIST then
    table.merge(style_tab, GAME.STYLE_LIST)
  end
  if LEVEL.style_list then
    table.merge(style_tab, LEVEL.style_list)
  end
  if THEME.style_list then
    table.merge(style_tab, THEME.style_list)
  end

  --ob_invoke_hook_with_table("override_level_style", style_tab, LEVEL.name)

  -- decide the values
  STYLE = {}

  for name,prob_tab in pairs(style_tab) do
    STYLE[name] = rand.key_by_probs(prob_tab)
  end

  -- apply user settings
  for name,_ in pairs(GLOBAL_STYLE_LIST) do
    if OB_CONFIG[name] and OB_CONFIG[name] ~= "mixed" then
      STYLE[name] = OB_CONFIG[name]
    end
  end

  if LEVEL.psychedelic then
    Mat_prepare_trip(LEVEL)
  end

  if LEVEL.is_procedural_gotcha then
    STYLE.hallways = "none"
    STYLE.doors = "heaps"
    STYLE.switches = "heaps"
    STYLE.big_rooms = "heaps"
    STYLE.traps = "none"
    STYLE.ambushes = "none"
    STYLE.caves = "none"
    STYLE.parks = "none"
    STYLE.symmetry = "more"
    STYLE.teleporters = "none"

    if PARAM.bool_boss_gen == 1 then
      if PARAM.boss_gen_steepness then

        if PARAM.boss_gen_steepness == "mixed" then
          STYLE.steepness = rand.key_by_probs(
            {
              none = 5,
              rare = 5,
              few = 4,
              less = 3,
              some = 2,
            }
          )
        else
          STYLE.steepness = PARAM.boss_gen_steepness
        end

      end
    end
  end

end


function Level_choose_liquid(LEVEL)
  -- always have a '_LIQUID' material.
  -- this is the default, it usually gets set to a proper material
  GAME.MATERIALS["_LIQUID"] = GAME.MATERIALS["_ERROR"]

  LEVEL.liquid_usage = 0

  if not THEME.liquids then
    gui.printf("Liquid: disabled by theme.\n\n")
    return
  end

  local usage     = style_sel("liquids", 0, 25, 50, 90)
  local skip_prob = style_sel("liquids", 100, 30, 10, 0)

  if rand.odds(skip_prob) then
    gui.printf("Liquid: skipped for level (by style).\n\n")
    return
  end

  -- allow liquids, but control how much we use
  LEVEL.liquid_usage = usage

  -- pick the liquid to use
  local liq_tab = THEME.liquids

  -- exclude liquids from certain environment themes
  if LEVEL.outdoor_theme then
    local exclusions
    if OBS_RESOURCE_PACK_LIQUIDS then
      exclusions = OBS_RESOURCE_PACK_LIQUIDS.exclusions[LEVEL.outdoor_theme]
      if exclusions then
        for _,L in pairs(exclusions) do
          liq_tab[L] = 0
        end
      end
    end
  end

  local name = rand.key_by_probs(liq_tab)
  local liquid = GAME.LIQUIDS[name]

  if not liquid then
    error("No such liquid: " .. name)
  end

  LEVEL.liquid = liquid

  gui.printf("Liquid: " .. name .. ", usage: " .. LEVEL.liquid_usage .. "%%\n\n")

  -- setup the special '_LIQUID' material
  assert(liquid.mat)
  assert(GAME.MATERIALS[liquid.mat])

  GAME.MATERIALS["_LIQUID"] = GAME.MATERIALS[liquid.mat]
end


function Level_choose_darkness(LEVEL)
  local prob = EPISODE.dark_prob or 0

  -- NOTE: this style is only set via the Level Control module
  -- MSSP: This can now be overriden (ignored) by the Sky Generator option.
  if STYLE.darkness and PARAM.bool_influence_map_darkness == 0 then
    prob = style_sel("darkness", 0, 15, 35, 100) -- 0, 15, 35, 97,
    --prob = style_sel("darkness", 0, 10, 30, 90) --Original
  end

  LEVEL.sky_light  = math.floor(rand.pick(SKY_LIGHT_NORMAL) * PARAM.float_overall_lighting_mult)
  LEVEL.sky_shadow = 32

  if rand.odds(prob) then
    gui.printf("Level is dark.\n")

    LEVEL.is_dark = true
    LEVEL.sky_light = math.floor(rand.pick(SKY_LIGHT_DARK) * PARAM.float_overall_lighting_mult)
    LEVEL.sky_shadow = 32
  end

  if OB_CONFIG.port ~= "zdoom" and OB_CONFIG.port ~= "edge" then
    local rounder = LEVEL.sky_light % 16
    if rounder ~= 0 then
      if rounder > 8 then
        LEVEL.sky_light = LEVEL.sky_light + (16 - rounder)
      else
        LEVEL.sky_light = LEVEL.sky_light - rounder
      end
    end
  end

  LEVEL.sky_light = math.clamp(PARAM.wad_minimum_brightness or 0, 
    LEVEL.sky_light, PARAM.wad_maximum_brightness or 255)

    if (LEVEL.sky_light - LEVEL.sky_shadow) <= (PARAM.wad_minimum_brightness or 0) then
    LEVEL.sky_shadow = LEVEL.sky_light - (PARAM.wad_minimum_brightness or 0)
  end
end


function Level_choose_misc(LEVEL)
  LEVEL.squareishness = rand.pick({ 0,25,50,75,90 })

  LEVEL.room_height_style = PARAM.room_heights or "mixed"

  if rand.odds(style_sel("outdoors", 0, 33, 66, 100)) then
    LEVEL.has_outdoors = true

    if rand.odds(style_sel("outdoors", 0, 15, 25, 0)) then
      LEVEL.alternating_outdoors = true
      gui.printf("-- Alternating Outdoors! --\n\n")
    end
  end

  LEVEL.room_height_style_tab = 
  {
    tall = rand.pick({0.8, 0.9, 1, 1.1, 1.2}),
    normal = rand.pick({1, 1.5, 2, 3, 4, 6}),
    short = rand.pick({0.8, 0.9, 1, 1.1, 1.2})
  }

  if PARAM.room_heights == "tall" then
    LEVEL.room_height_style_tab["normal"] = LEVEL.room_height_style_tab["normal"] / 8
    LEVEL.room_height_style_tab["short"] = 0
  elseif PARAM.room_heights == "short" then
    LEVEL.room_height_style_tab["tall"] = 0
    LEVEL.room_height_style_tab["normal"] = LEVEL.room_height_style_tab["normal"] / 8
  elseif PARAM.room_heights == "tall-ish" then
    LEVEL.room_height_style_tab["short"] = 0
  elseif PARAM.room_heights == "short-ish" then
    LEVEL.room_height_style_tab["tall"] = 0
  end

  LEVEL.shape_transform_mode = rand.pick({"linear","random"})

  if LEVEL.is_procedural_gotcha then LEVEL.shape_transform_mode = "random" end

  LEVEL.shape_transform_possiblities =
  {
    {0, 0, 0},
    {0, 0, 1},
    {0, 1, 0},
    {0, 1, 1},
    {1, 0, 0},
    {1, 0, 1},
    {1, 1, 0},
    {1, 1, 1},
  }

  gui.printf("Level shape transform mode: %s\n", LEVEL.shape_transform_mode)
  rand.shuffle(LEVEL.shape_transform_possiblities)
end


function Level_choose_skybox(LEVEL)
  local skyfab

  local function Choose_episodic_skybox(LEVEL, force_pick)
    if not LEVEL.episode.skybox or force_pick then
      return PREFABS[rand.key_by_probs(THEME.skyboxes)]
    else
      return LEVEL.episode.skybox
    end
  end

  local function Choose_skybox(mode)
    if mode == "random" then
      local reqs =
      {
        kind = "skybox",
        where = "point",
        size = 1,
      }
      local def = Fab_pick(LEVEL, reqs)
      return assert(def)

    elseif mode == "themed" then
      return PREFABS[rand.key_by_probs(THEME.skyboxes)]

    elseif mode == "generic" then
      if PARAM.obsidian_resource_pack_active then
        return PREFABS["Skybox_hellish_city_EPIC"]
      else
        return PREFABS["Skybox_hellish_city"]
      end
    end
  end

  if table.empty(THEME.skyboxes) then
    gui.printf("WARNING! No skybox table for theme: " .. LEVEL.theme_name .. "\n")
    return
  end

  if OB_CONFIG.zdoom_skybox == "disable" then return end

  local same_skyfab = "yes"

  if OB_CONFIG.zdoom_skybox == "episodic" then
    LEVEL.episode.skybox = Choose_episodic_skybox(LEVEL)
    skyfab = LEVEL.episode.skybox
  else
    LEVEL.skybox = Choose_skybox(OB_CONFIG.zdoom_skybox)
    skyfab = LEVEL.skybox
  end

  -- check against exclusions
  if LEVEL.outdoor_theme and LEVEL.outdoor_theme ~= "temperate"
  and OBS_RESOURCE_PACK_SKYBOX_EXCLUSIONS then

    local pick_attempts = 0
    local ex_list = OBS_RESOURCE_PACK_SKYBOX_EXCLUSIONS[LEVEL.outdoor_theme]
    while same_skyfab == "yes" do

      if OB_CONFIG.zdoom_skybox == "episodic" then
        if table.has_elem(ex_list, LEVEL.episode.skybox.name) then
          same_skyfab = "yes"
        else same_skyfab = "no" end
      elseif OB_CONFIG.zdoom_skybox ~= "disable" then
        if table.has_elem(ex_list, LEVEL.skybox.name) == ex then
          same_skyfab = "yes"
        else same_skyfab = "no" end
      end

      if same_skyfab == "yes" then
        if OB_CONFIG.zdoom_skybox == "episodic" then
          LEVEL.episode.skybox = Choose_episodic_skybox(LEVEL, "force_it")
          skyfab = LEVEL.episode.skybox
        else
          LEVEL.skybox = Choose_skybox(OB_CONFIG.zdoom_skybox)
          skyfab = LEVEL.skybox
        end
      end

      pick_attempts = pick_attempts + 1
      if pick_attempts > 10 then 
        gui.printf(table.tostr(OBS_RESOURCE_PACK_SKYBOX_EXCLUSIONS[LEVEL.outdoor_theme]))
        error("Skybox pick repeated too many times!!!! Global warming is real and " ..
        "a billion pigs have been killed by swine flu!!!!") 
      end

    end
  end

  if skyfab then
    gui.printf("Level skybox: " .. skyfab.name .. "\n")
  else
    gui.printf("WARNING: Could not find a proper skybox for theme '" .. LEVEL.theme_name .. "'\n")
  end
end


function Level_init(LEVEL)
  LEVEL.ids = {}

  LEVEL.areas = {}
  LEVEL.rooms = {}
  LEVEL.conns = {}

  LEVEL.map_borders = {}
  LEVEL.depots = {}

  LEVEL.unplaced_weapons = {}

  Level_choose_liquid(LEVEL)
  Level_choose_darkness(LEVEL)
  Level_choose_misc(LEVEL)

  Level_choose_skybox(LEVEL)

  Ambient_reset()
end


function Level_build_it(LEVEL, SEEDS)
  Level_init(LEVEL)

  -- Can just uncomment and manuall set an ID to match if we really need this - Dasho

  --[[if PARAM.float_build_levels then
    if PARAM.float_build_levels ~= 0 then
      if LEVEL.id ~= PARAM.float_build_levels then return "nope" end
    end
  end]]--

  Area_create_rooms(LEVEL, SEEDS)
    if gui.abort() then return "abort" end

  Quest_make_quests(LEVEL)
  -- do some prefab pre-filtering
  -- remove prefabs that have no expectation to ever be used
  Fab_trim_list(LEVEL)
    if gui.abort() then return "abort" end

  Room_build_all(LEVEL, SEEDS)
    if gui.abort() then return "abort" end

  Monster_make_battles(LEVEL, SEEDS)
    if gui.abort() then return "abort" end

  Item_add_pickups(LEVEL)
    if gui.abort() then return "abort" end

  return "ok"
end


function Level_handle_prebuilt(LEVEL)
  -- randomly pick one
  local probs = {}

  for index,info in pairs(LEVEL.prebuilt) do
    probs[index] = info.prob or 50
  end

  local info = LEVEL.prebuilt[rand.index_by_probs(probs)]

  assert(info)
  assert(info.file)
  assert(info.map)

  if GAME.format == "doom" then
    gui.wad_transfer_map(info.file, info.map, LEVEL.name)
  else
    -- FIXME: support other games (Wolf3d, etc)
  end

  return "ok"
end

function Level_make_level(LEV)
  assert(LEV)
  assert(LEV.name)

  local index = LEV.id
  local total = #GAME.levels

  -- debugging aid : ability to build only a particular level
  if OB_CONFIG.only and
     string.lower(OB_CONFIG.only) ~= string.lower(LEV.name)
  then
    gui.printf("\nSkipping level: %s....\n\n", LEV.name)
    return
  end

  -- must create the description before the copy (else games/modules won't see it)
  if not LEV.description and LEV.name_class then
    LEV.description = Naming_grab_one(LEV.name_class)
  end

  if LEV.is_procedural_gotcha then
    LEV.description = Naming_grab_one("BOSS")
  end

  if LEV.description then
    gui.printf("Level " .. LEV.id .. " title: " .. LEV.description)
  end

  -- copy level info, so that all new information added into the LEVEL
  -- object by the generator can be garbage collected once this level is
  -- finished.

  local LEVEL = table.copy(LEV)
  local SEEDS = Seed_init(LEVEL)
  local res = "ok'"
  local retry_counter = 0
  local retry_target = 3
  local error_mat = assert(GAME.MATERIALS["_ERROR"])
  local coverage_target = 0

  ::retryafterfailure::

  gui.at_level(LEVEL.name, index, total)

  gui.printf("\n\n~~~~~~| %s |~~~~~~\n", LEVEL.name)

  LEVEL.ids  = {}

  THEME = table.copy(assert(LEVEL.theme))

  if GAME.THEMES.DEFAULTS then
    table.merge_missing(THEME, GAME.THEMES.DEFAULTS)
  end

  -- use a pre-built level ?

  if LEVEL.prebuilt then
    ob_invoke_hook_with_table("begin_level", LEVEL)

    local pb_res = Level_handle_prebuilt(LEVEL)
    if pb_res ~= "ok" then
      for _,k in pairs (LEVEL) do
        LEVEL[k] = nil
      end
      for _,k in pairs (SEEDS) do
        SEEDS[k] = nil
      end
      LEVEL = nil
      SEEDS = nil
      collectgarbage("collect")
      collectgarbage("collect")
      return pb_res
    end
    ob_invoke_hook_with_table("end_level", LEVEL)
    for _,k in pairs (LEVEL) do
      LEVEL[k] = nil
    end
    for _,k in pairs (SEEDS) do
      SEEDS[k] = nil
    end
    LEVEL = nil
    SEEDS = nil
    collectgarbage("collect")
    collectgarbage("collect")
    return "ok"
  end

  LEVEL.secondary_importants = {}

  gui.begin_level()
  gui.property("level_name", LEVEL.name);

  Level_do_styles(LEVEL)

  -- skip_probs for fabs are now evaluated on a per-level basis.
  Fab_update_skip_prob()

  ob_invoke_hook_with_table("begin_level", LEVEL)

  gui.printf("\nStyles = \n%s\n\n", table.tostr(STYLE, 1))

  gui.property("error_tex",  error_mat.t)
  gui.property("error_flat", error_mat.f or error_mat.t)

  if LEVEL.description then
    if OB_CONFIG.batch ~= "yes" then
      gui.property("description", LEVEL.description)
    end
  end

  LEVEL.PREFABS = table.copy(PREFABS)

  res = Level_build_it(LEVEL, SEEDS)

  if coverage_target == 0 then coverage_target = LEVEL.min_coverage end

  if not SHAPE_GRAMMAR.ignore_coverage then
    if LEVEL.cur_coverage < coverage_target then
      res = "runt"
    end
  end

  if LEVEL.is_procedural_gotcha then
    local exit_R = LEVEL.exit_room
    local start_R = LEVEL.start_room

    if exit_R ~= start_R and start_R.svolume > exit_R.svolume then
      res = "runt"
    end
  end

  if res == "runt" then
    print("STUNTED LEVEL!\nCOVERAGE: " .. LEVEL.cur_coverage 
    .. "\nMIN COVERAGE: " .. coverage_target .. "\nROOMS: " 
    .. #LEVEL.rooms .. "\nMIN ROOMS: " .. LEVEL.min_rooms .. "\n")
  end

  if res ~= "ok" then
    for _,k in pairs (LEVEL) do
      LEVEL[k] = nil
    end
    for _,k in pairs (SEEDS) do
      SEEDS[k] = nil
    end
    LEVEL = nil
    SEEDS = nil
    collectgarbage("collect")
    collectgarbage("collect")
    if res == "abort" then return res end
    retry_counter = retry_counter + 1
    if retry_counter > retry_target then -- just move on I guess
      res = "ok"
    else
      coverage_target = coverage_target * 0.75
      LEVEL = table.copy(LEV)
      SEEDS = Seed_init(LEVEL)
      print("RETRYING MAP " .. LEVEL.name)
      gui.reseed_rng(gui.random_int())
      goto retryafterfailure
    end
  end

  ob_invoke_hook_with_table("end_level", LEVEL)

  gui.end_level()

  if LEVEL then
    for _,k in pairs (LEVEL) do
      LEVEL[k] = nil
    end
  end
  if SEEDS then
    for _,k in pairs (SEEDS) do
      SEEDS[k] = nil
    end
  end
  LEVEL = nil
  SEEDS = nil

  collectgarbage("collect")
  collectgarbage("collect")

  if gui.abort() then return "abort" end

  return "ok"
end

function Level_make_all()
  GAME.levels   = {}
  GAME.episodes = {}

  ob_invoke_hook("get_levels")

  if #GAME.levels == 0 then
    error("Level list is empty!")
  end

  table.index_up(GAME.levels)
  table.index_up(GAME.episodes)

  Level_choose_themes()

  ob_invoke_hook("get_levels_after_themes")

  for k,v in pairs(GAME.PICKUPS) do
    if not v.name then v.name = k end
  end

  for k,v in pairs(GAME.NICE_ITEMS) do
    if not v.name then v.name = k end
  end

  Episode_plan_game()
 
  if PARAM.title_screen_source then
    if PARAM.title_screen_source == "filename" then
      local str = string.lower(OB_CONFIG.title)
      str = string.gsub(str, "%p", "")
      str = string.gsub(str, " ", "_")
      str = string.gsub(str, ":", "")
      str = string.gsub(str, "'", "")
      str = string.gsub(str, ",", "")
      if not string.match(gui.get_filename_base(), str) then
        GAME.title = gui.get_filename_base()
      end
    elseif PARAM.title_screen_source == "randomwords" then
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
        GAME.title = case_randomizer(rand.pick(RANDOM_WORDS_EN))
      elseif numwords == 2 then
        GAME.title = case_randomizer(rand.pick(RANDOM_WORDS_EN)) .. " " .. case_randomizer(rand.pick(RANDOM_WORDS_EN))
      else
        GAME.title = case_randomizer(rand.pick(RANDOM_WORDS_EN)) .. " " .. case_randomizer(rand.pick(RANDOM_WORDS_EN)) .. " " .. case_randomizer(rand.pick(RANDOM_WORDS_EN))
      end
    end
  end

  if PARAM.bool_sub_titles and PARAM.bool_sub_titles == 1 then
    GAME.sub_title = nil
  end

  Title_generate()

  for _,EPI in pairs(GAME.episodes) do
    EPISODE = EPI

    EPISODE.seen_weapons = {}

    for _,LEV in pairs(EPI.levels) do
      LEV.allowances = {}

      if PARAM.float_historical_oblige_v2 and rand.odds(PARAM.float_historical_oblige_v2) then
        LEV.description = Naming_grab_one(LEV.name_class)
        gui.minimap_disable(gui.gettext("Oblige V2"))
        if v094_create_LEVEL(GAME.FACTORY.all_levels[LEV.id], LEV.id, #GAME.levels) == "abort" then
          return "abort"
        end
      else
        gui.minimap_enable()
        if Level_make_level(LEV) == "abort" then
          return "abort"
        end
      end
    end
  end

  ob_invoke_hook("all_done")

  ScriptMan_init()

  return "ok"
end
