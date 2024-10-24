------------------------------------------------------------------------
--  HERETIC LEVELS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.MUSIC =
{
  [1] = "MUS_E1M1",
  [2] = "MUS_E1M2",
  [3] = "MUS_E1M3",
  [4] = "MUS_E1M4",
  [5] = "MUS_E1M5",
  [6] = "MUS_E1M6",
  [7] = "MUS_E1M7",
  [8] = "MUS_E1M8",
  [9] = "MUS_E1M9",
  [10] = "MUS_E2M1",
  [11] = "MUS_E2M2",
  [12] = "MUS_E2M3",
  [13] = "MUS_E2M4",
  [14] = "MUS_E1M4",
  [15] = "MUS_E2M6",
  [16] = "MUS_E2M7",
  [17] = "MUS_E2M8",
  [18] = "MUS_E2M9",
  [19] = "MUS_E1M1",
  [20] = "MUS_E3M2",
  [21] = "MUS_E3M3",
  [22] = "MUS_E1M6",
  [23] = "MUS_E1M3",
  [24] = "MUS_E1M2",
  [25] = "MUS_E1M5",
  [26] = "MUS_E1M9",
  [27] = "MUS_E2M6",
  [28] = "MUS_E1M6",
  [29] = "MUS_E1M2",
  [30] = "MUS_E1M3",
  [31] = "MUS_E1M4",
  [32] = "MUS_E1M5",
  [33] = "MUS_E1M1",
  [34] = "MUS_E1M7",
  [35] = "MUS_E1M8",
  [36] = "MUS_E1M9",
  [37] = "MUS_E2M1",
  [38] = "MUS_E2M2",
  [39] = "MUS_E2M3",
  [40] = "MUS_E2M4",
  [41] = "MUS_E1M4",
  [42] = "MUS_E2M6",
  [43] = "MUS_E2M7",
  [44] = "MUS_E2M8",
  [45] = "MUS_E2M9",
}

HERETIC.SECRET_EXITS =
{
  E1M6 = true,
  E2M4 = true,
  E3M4 = true,
  E4M4 = true,
  E5M3 = true
}


HERETIC.EPISODES =
{
  episode1 =
  {
    ep_index = 1,

    theme = "city",
    boss = "Ironlich",
    sky_patch = "SKY1",
    dark_prob = 10,
    sky_light = 0.65,
  },

  episode2 =
  {
    ep_index = 2,

    theme = "maw",
    boss = "Maulotaur",
    sky_patch = "SKY2",
    dark_prob = 10,
    sky_light = 0.75,
  },

  episode3 =
  {
    ep_index = 3,

    theme = "dome",
    boss = "D_Sparil",
    sky_patch = "SKY3",
    dark_prob = 10,
    sky_light = 0.75,
  },

  episode4 =
  {
    ep_index = 4,

    theme = "ossuary",
    boss = "Ironlich",
    sky_patch = "SKY4",
    dark_prob = 10,
    sky_light = 0.50,
  },

  episode5 =
  {
    ep_index = 5,

    theme = "demense",
    boss = "Maulotaur",
    sky_patch = "SKY5",
    dark_prob = 10,
    sky_light = 0.65,
  },
}

HERETIC.PREBUILT_LEVELS =
{
  E1M8 =
  {
    { prob=50, file="games/heretic/data/boss_maw1.wad", map="E1M8" },
  },

  E2M8 =
  {
    { prob=50, file="games/heretic/data/boss_portal1.wad", map="E2M8" },
  },
}


------------------------------------------------------------

function HERETIC.get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "game",   5, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  -- create episode info...

  for ep_index = 1,5 do
    local ep_info = HERETIC.EPISODES["episode" .. ep_index]
    assert(ep_info)

    local EPI = table.copy(ep_info)

    EPI.levels = { }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  current_map = 1

  for ep_index = 1,EP_NUM do
    local EPI = GAME.episodes[ep_index]

    for map = 1,MAP_NUM do
      -- create level info...
      local ep_along = map / MAP_NUM

      local LEV =
      {
        episode  = EPI,

        name = string.format("E%dM%d", ep_index, map),

          ep_along = ep_along,
        game_along = (ep_index - 1 + ep_along) / EP_NUM
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

      LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

      -- prebuilt levels
      if PARAM.bool_prebuilt_levels == 1 then
        LEV.prebuilt = GAME.PREBUILT_LEVELS[LEV.name]
      end
  
      if LEV.prebuilt then
        LEV.name_class = LEV.prebuilt.name_class or "BOSS"
      end
          -- procedural gotcha management code

    -- Prebuilts are to exist over procedural gotchas
    -- this means procedural gotchas will not override
    -- Icon of Sin for example if prebuilts are still on
    if not LEV.prebuilt then

      --handling for the Final Only option
      if PARAM.gotcha_frequency == "final" then
        if OB_CONFIG.length == "single" then
          if current_map == 1 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "few" then
          if current_map == 4 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "episode" then
          if current_map == 8 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "game" then
          if current_map == 44 then LEV.is_procedural_gotcha = true end
        end
      end

      if PARAM.gotcha_frequency == "epi" then
        if current_map == ep_index * 9 - 1 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "2epi" then
        if current_map == ep_index * 9 - 1 or current_map == ep_index * 9 - 5 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "3epi" then
        if current_map == ep_index * 9 - 1 or current_map == ep_index * 9 - 4 or current_map == ep_index * 9 - 7 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "4epi" then
        if current_map == ep_index * 9 - 1 or current_map == ep_index * 9 - 3 or current_map == ep_index * 9 - 5 or current_map == ep_index * 9 - 7 then
          LEV.is_procedural_gotcha = true
        end
      end

      --5% of maps after map 4,
      if PARAM.gotcha_frequency == "5p" then
        if current_map > 4 and current_map % 9 ~= 0 then
          if rand.odds(5) then LEV.is_procedural_gotcha = true end
        end
      end

      -- 10% of maps after map 4,
      if PARAM.gotcha_frequency == "10p" then
        if current_map > 4 and current_map % 9 ~= 0 then
          if rand.odds(10) then LEV.is_procedural_gotcha = true end
        end
      end

      -- for masochists... or debug testing
      if PARAM.gotcha_frequency == "all" then
        LEV.is_procedural_gotcha = true
      end
    end

    local special_mode = {}

    if PARAM.float_streets_mode and rand.odds(PARAM.float_streets_mode) then
      table.add_unique(special_mode, "streets")
    end
 
    if PARAM.float_linear_mode and rand.odds(PARAM.float_linear_mode) then
      table.add_unique(special_mode, "linear")
    end

    if PARAM.float_nature_mode and rand.odds(PARAM.float_nature_mode) then
      table.add_unique(special_mode, "nature")
    end

    if not table.empty(special_mode) and not LEV.prebuilt then
      local selected_mode = rand.pick(special_mode)
      if selected_mode == "streets" then
        LEV.has_streets = true
        LEV.is_nature = false
      else
        LEV.has_streets = false
        LEV.is_nature = true
      end
    else
      LEV.has_streets = false
      LEV.is_nature = false
    end

    current_map = current_map + 1

    end -- for map

    -- set "dist_to_end" value
    if MAP_NUM >= 9 then
      EPI.levels[7].dist_to_end = 1
      EPI.levels[6].dist_to_end = 2
    end

  end -- for episode

end

