----------------------------------------------------------------
--  MODULE: ZDoom Special Addons for Heretic
----------------------------------------------------------------
--
--  Copyright (C) 2019 MsrSgtShooterPerson
--  Adapted for Heretic by Dashodanger
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
-------------------------------------------------------------------

ZDOOM_SPECIALS_HERETIC = { }

ZDOOM_SPECIALS_HERETIC.MUSIC_SHUFFLER_CHOICES =
{
  "yes", _("Yes"),
  "no", _("No"),
}

ZDOOM_SPECIALS_HERETIC.FOG_GEN_CHOICES =
{
  "per_sky_gen",    _("Per Sky Generator"),
  "random", _("Random"),
  "natural", _("Natural"),
  "no",     _("No"),
}

ZDOOM_SPECIALS_HERETIC.FOG_ENV_CHOICES =
{
  "all",     _("All"),
  "outdoor", _("Outdoors Only"),
}

ZDOOM_SPECIALS_HERETIC.FOG_DENSITY_CHOICES =
{
  "subtle",  _("Subtle"),
  "misty",  _("Misty"),
  "smoky",  _("Smoky"),
  "foggy",  _("Foggy"),
  "dense",  _("Dense"),
  "mixed",  _("Mix It Up"),
}

ZDOOM_SPECIALS_HERETIC.STORY_CHOICES =
{
  "generic", _("Generic"),
  "proc",    _("Generated"),
  "none",    _("NONE"),
}

ZDOOM_SPECIALS_HERETIC.MUSIC =
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

ZDOOM_SPECIALS_HERETIC.MAP_NOMENCLATURE =
{
  [1] = "E1M1",
  [2] = "E1M2",
  [3] = "E1M3",
  [4] = "E1M4",
  [5] = "E1M5",
  [6] = "E1M6",
  [7] = "E1M7",
  [8] = "E1M8",
  [9] = "E1M9",
  [10] = "E2M1",
  [11] = "E2M2",
  [12] = "E2M3",
  [13] = "E2M4",
  [14] = "E2M5",
  [15] = "E2M6",
  [16] = "E2M7",
  [17] = "E2M8",
  [18] = "E2M9",
  [19] = "E3M1",
  [20] = "E3M2",
  [21] = "E3M3",
  [22] = "E3M4",
  [23] = "E3M5",
  [24] = "E3M6",
  [25] = "E3M7",
  [26] = "E3M8",
  [27] = "E3M9",
  [28] = "E4M1",
  [29] = "E4M2",
  [30] = "E4M3",
  [31] = "E4M4",
  [32] = "E4M5",
  [33] = "E4M6",
  [34] = "E4M7",
  [35] = "E4M8",
  [36] = "E4M9",
  [37] = "E5M1",
  [38] = "E5M2",
  [39] = "E5M3",
  [40] = "E5M4",
  [41] = "E5M5",
  [42] = "E5M6",
  [43] = "E5M7",
  [44] = "E5M8",
  [45] = "E5M9",
}

-- Attempting to make episode-specific Interpics
-- Interpics 1-5 are for Episodes 1-5,
-- Interpics 6-10 are the secret level for each episode
-- For now, I've only made one picture, which is a tiled version
-- of the regular level transition background
ZDOOM_SPECIALS_HERETIC.INTERPICS =
{
  [1] = "HERETIC1",
  [2] = "HERETIC1",
  [3] = "HERETIC1",
  [4] = "HERETIC1",
  [5] = "HERETIC1",
  [6] = "HERETIC1",
  [7] = "HERETIC1",
  [8] = "HERETIC1",
  [9] = "HERETIC1",
  [10] = "HERETIC1",
}

ZDOOM_SPECIALS_HERETIC.INTERPIC_MUSIC =
{
  "MUS_INTR", _("Universal Intermission")
}

ZDOOM_SPECIALS_HERETIC.MUSIC_SELECTION = {}

ZDOOM_SPECIALS_HERETIC.FOG_COLORS = 
{
  SKY_CLOUDS = "00 00 ff",
  BLUE_CLOUDS = "00 00 ff",
  WHITE_CLOUDS = "ff ff ff",
  GREY_CLOUDS = "ff ff ff",
  DARK_CLOUDS = "ff ff ff",
  BROWN_CLOUDS = "ff a8 5c", 
  BROWNISH_CLOUDS = "ff d2 a6",
  PEACH_CLOUDS = "ff a4 63",
  YELLOW_CLOUDS = "ff cb 3d",
  ORANGE_CLOUDS = "ff 6b 08",
  GREEN_CLOUDS = "7a ff 5c",
  JADE_CLOUDS = "df ff 9e",
  DARKRED_CLOUDS = "ff 4c 4c",
  HELLISH_CLOUDS = "ff 00 00",
  HELL_CLOUDS = "ff 00 00",
  PURPLE_CLOUDS = "ff 00 ff",
  RAINBOW_CLOUDS = "ff 00 ff"
}

function ZDOOM_SPECIALS_HERETIC.setup(self)
  gui.printf("\n--== ZDoom Special Addons module active ==--\n\n")

  module_param_up(self)
end

function ZDOOM_SPECIALS_HERETIC.shuffle_music()

  local music_table = ZDOOM_SPECIALS_HERETIC.MUSIC

  if PARAM.mapinfo_music_shuffler_heretic ~= "no" then
    rand.shuffle(music_table)
  end

  ZDOOM_SPECIALS_HERETIC.MUSIC_SELECTION = music_table

end

function ZDOOM_SPECIALS_HERETIC.do_special_stuff()

  local fog_color

  local level_count = #GAME.levels

  local function pick_sky_color_from_skygen_map(epi_num)
    local color = "00 00 00"

    local skyname = PARAM.episode_sky_color[epi_num]

    if ZDOOM_SPECIALS_HERETIC.FOG_COLORS[skyname] then
      color = ZDOOM_SPECIALS_HERETIC.FOG_COLORS[skyname] 
    end

    return color
  end

  local function pick_random_fog_color()
    local function give_random_hex()
      return rand.pick({'0','1','2','3','4','5','6','8','9','a','b','c','d','e','f'})
    end
    local octet1 = give_random_hex() .. give_random_hex()
    local octet2 = give_random_hex() .. give_random_hex()
    local octet3 = give_random_hex() .. give_random_hex()
    return octet1 .. " " .. octet2 .. " " .. octet3
  end

  local function add_languagelump()
  end

  local function add_gamedef()
    gamedef_lines = {}

    local x = 1
    local quit_msg_line = ""
    quit_msg_line = quit_msg_line .. "quitmessages = "
    for _,lines in pairs(GAME.STORIES.QUIT_MESSAGES) do
      quit_msg_line = quit_msg_line .. '"$QUITMSG' .. x .. '"'
      if x <= #GAME.STORIES.QUIT_MESSAGES - 1 then
        quit_msg_line = quit_msg_line .. ', '
      end
      if x%3 == 0 then
        quit_msg_line = quit_msg_line .. "\n  "
      end
      x = x + 1
    end
    table.insert(gamedef_lines, quit_msg_line)

    return gamedef_lines
  end

  local function add_mapinfo(mapinfo_tab)

    -- mapinfo table requires color for fog and map number
    local fog_color = mapinfo_tab.fog_color
    local map_num = mapinfo_tab.map_num
    local interpic = mapinfo_tab.interpic

    local music_list = ZDOOM_SPECIALS_HERETIC.MUSIC

    local music_line = ''

    if music_list then
      music_line = '  Music = "' .. music_list[map_num] .. '"\n'
    else
      music_line = ''
    end

    -- resolve map MAPINFO linkages
    map_id = ZDOOM_SPECIALS_HERETIC.MAP_NOMENCLATURE[map_num]
    map_id_next = ZDOOM_SPECIALS_HERETIC.MAP_NOMENCLATURE[map_num + 1]

    local sky_texture

    -- resolve proper episodic sky texture assignments
    if not PARAM.episode_sky_color then
      if map_num <= 9 then
        sky_texture = "SKY1"
      elseif map_num <= 18 then
        sky_texture = "SKY2"
      elseif map_num <= 27 then
        sky_texture = "SKY3"
      elseif map_num <= 36 then
        sky_texture = "SKY1"
      else
        sky_texture = "SKY3"
      end
    else
      if map_num <= 9 then
        sky_texture = "SKY1"
      elseif map_num <= 18 then
        sky_texture = "SKY2"
      elseif map_num <= 27 then
        sky_texture = "SKY3"
      elseif map_num <= 36 then
        sky_texture = "SKY4"
      else
        sky_texture = "SKY5"
      end
    end

    -- produce endtitle screen end of game
    if (map_num + 1 > level_count) then
      map_id_next = 'EndPic, "TITLE"'
    end

    local secret_level_line

    local next_level_line = '  next = ' .. map_id_next .. '\n'

      -- secret entrances
    if map_num == 6 then
      secret_level_line = '  secretnext = E1M9\n'
    elseif map_num == 13 then
      secret_level_line = '  secretnext = E2M9\n'
    elseif map_num == 22 then
      secret_level_line = '  secretnext = E3M9\n'
    elseif map_num == 31 then
      secret_level_line = '  secretnext = E4M9\n'
    elseif map_num == 39 then
      secret_level_line = '  secretnext = E5M9\n'
    else
      secret_level_line = ''
    end

      -- next maps for secret levels
      if map_num == 9 then
        next_level_line = '  next = ' .. ZDOOM_SPECIALS_HERETIC.MAP_NOMENCLATURE[7] .. "\n"
      elseif map_num == 18 then
        next_level_line = '  next = ' .. ZDOOM_SPECIALS_HERETIC.MAP_NOMENCLATURE[14] .. "\n"
      elseif map_num == 27 then
        next_level_line = '  next = ' .. ZDOOM_SPECIALS_HERETIC.MAP_NOMENCLATURE[23] .. "\n"
      elseif map_num == 36 then
        next_level_line = '  next = ' .. ZDOOM_SPECIALS_HERETIC.MAP_NOMENCLATURE[32] .. "\n"
      elseif map_num == 45 then
        next_level_line = '  next = ' .. ZDOOM_SPECIALS_HERETIC.MAP_NOMENCLATURE[40] .. "\n"
      end

     -- skip for secret levels
      if map_num == 8 then
        next_level_line = '  next = "EndGame1"\n'
      elseif map_num == 17 then
        next_level_line = '  next = "EndGameW"\n'
      elseif map_num == 26 then
        next_level_line = '  next = "EndDemon"\n'
      elseif map_num == 35 then
        next_level_line = '  next = "EndGame4"\n'
      end

      -- final level
      if map_num == 44 then
        next_level_line = '  next = "EndGame1"\n'
      end

    local fog_color_line = '  fade = "' .. fog_color .. '"\n'

    local fog_intensity = "48"

    -- resolve fog intensity
    if PARAM.fog_intensity_heretic == "subtle" then
      fog_intensity = "16"
    elseif PARAM.fog_intensity_heretic == "misty" then
      fog_intensity = "48"
    elseif PARAM.fog_intensity_heretic == "smoky" then
      fog_intensity = "128"
    elseif PARAM.fog_intensity_heretic == "foggy" then
      fog_intensity = "255"
    elseif PARAM.fog_intensity_heretic == "dense" then
      fog_intensity = "368"
    elseif PARAM.fog_intensity_heretic == "mixed" then
      fog_intensity = "" .. rand.irange(16,368)
    end

    local fog_intensity_line = '  fogdensity = ' .. fog_intensity .. '\n'

    -- fog forced to outdoors only
    if PARAM.fog_env_heretic == "outdoor" then
      fog_color_line = '  OutsideFog  = "' .. fog_color .. '"\n'
      fog_intensity_line = '  outsidefogdensity = ' .. fog_intensity .. '\n'
    end

    -- if fog tints sky, based on ZDoom GL specs
    if PARAM.bool_fog_affects_sky_heretic == 1 then
      fog_intensity_line = fog_intensity_line .. '  skyfog = ' .. fog_intensity + 16 .. '\n'
    end

    -- no fog in MAPINFO at all if the fog generator is off
    if PARAM.fog_generator_heretic == "no" then
      fog_color_line = ""
      fog_intensity_line = ""
    end

    -- add cluster linking, 2 clusters per episode and one for each secret level
    local cluster_line = ''

    if map_num >= 1 and map_num <= 4 then
      cluster_line = "  Cluster = 1\n"
    elseif map_num > 4 and map_num <= 8 then
      cluster_line = "  Cluster = 2\n"
    elseif map_num > 9 and map_num <= 13 then
      cluster_line = "  Cluster = 3\n"
    elseif map_num > 13 and map_num <= 17 then
      cluster_line = "  Cluster = 4\n"
    elseif map_num > 18 and map_num <= 22 then
      cluster_line = "  Cluster = 5\n"
    elseif map_num > 22 and map_num <= 26 then
      cluster_line = "  Cluster = 6\n"
    elseif map_num > 27 and map_num <= 31 then
      cluster_line = "  Cluster = 7\n"
    elseif map_num > 31 and map_num <= 35 then
      cluster_line = "  Cluster = 8\n"
    elseif map_num > 36 and map_num <= 40 then
      cluster_line = "  Cluster = 9\n"
    elseif map_num > 40 and map_num <= 44 then
      cluster_line = "  Cluster = 10\n"
    elseif map_num == 9 then
      cluster_line = "  Cluster = 11\n"
    elseif map_num == 18 then
      cluster_line = "  Cluster = 12\n"
    elseif map_num == 27 then
      cluster_line = "  Cluster = 13\n"
    elseif map_num == 36 then
      cluster_line = "  Cluster = 14\n"
    elseif map_num == 45 then
      cluster_line = "  Cluster = 15\n"
    end


    local name_string_map_id = map_id

    -- special tags for Heretic stuff
    local special_attributes = ''
    if map_id == "E1M8" then
      special_attributes = '  nointermission\n'
      if GAME.levels[map_num].prebuilt then
        special_attributes = special_attributes .. '  nosoundclipping\n'
        special_attributes = special_attributes .. '  ironlichspecial\n'
        special_attributes = special_attributes .. '  specialaction_lowerfloortohighest\n'
      end
    elseif map_id == "E2M8" then
      special_attributes = '  nointermission\n'
      if GAME.levels[map_num].prebuilt then
        special_attributes = special_attributes .. '  nosoundclipping\n'
        special_attributes = special_attributes .. '  minotaurspecial\n'
        special_attributes = special_attributes .. '  specialaction_lowerfloortohighest\n'
        special_attributes = special_attributes .. '  specialaction_killmonsters\n'
      end
    elseif map_id == "E3M8" then
      special_attributes = '  nointermission\n'
      if GAME.levels[map_num].prebuilt then
        special_attributes = special_attributes .. '  nosoundclipping\n'
        special_attributes = special_attributes .. '  dsparilspecial\n'
        special_attributes = special_attributes .. '  specialaction_lowerfloortohighest\n'
        special_attributes = special_attributes .. '  specialaction_killmonsters\n'
      end
    elseif map_id == "E4M8" then
      special_attributes = '  nointermission\n'
      if GAME.levels[map_num].prebuilt then
        special_attributes = special_attributes .. '  nosoundclipping\n'
        special_attributes = special_attributes .. '  ironlichspecial\n'
        special_attributes = special_attributes .. '  specialaction_lowerfloortohighest\n'
        special_attributes = special_attributes .. '  specialaction_killmonsters\n'
      end
    elseif map_id == "E5M8" then
      special_attributes = '  nointermission\n'
      if GAME.levels[map_num].prebuilt then
        special_attributes = special_attributes .. '  nosoundclipping\n'
        special_attributes = special_attributes .. '  minotaurspecial\n'
        special_attributes = special_attributes .. '  specialaction_lowerfloortohighest\n'
        special_attributes = special_attributes .. '  specialaction_killmonsters\n'
      end
    else
      special_attributes = ''
    end

    if PARAM.bool_no_intermission_heretic == 1 then
      special_attributes = special_attributes .. '  nointermission\n'
    end

    special_attributes = special_attributes .. '  ClipMidTextures\n'

    local mapinfo =
    {
      'map ' .. map_id .. ' lookup HHUSTR_'.. name_string_map_id ..'\n',
      '{\n',
      '  cluster = 1\n',
      '  sky1 = "' .. sky_texture .. '"\n',
      '' .. cluster_line .. '',
      '' .. fog_color_line .. '',
      '' .. fog_intensity_line .. '',
      '' .. next_level_line .. '',
      '' .. secret_level_line .. '',
      '' .. music_line .. '',
      '  EnterPic = "' .. interpic .. '"\n',
      '  ExitPic = "' .. interpic .. '"\n',
      '' .. special_attributes .. '',
      '}\n'
    }

    return mapinfo
  end

  local function add_clusterdef(interpic)
    local clusterdef = {''}

    local cluster_music_line = '  music = "' .. PARAM.generic_intermusic_heretic .. '"\n'

    if PARAM.story_generator_heretic == "generic" then


      clusterdef =
      {
        'cluster 1\n', -- E1M1-E1M4,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext =\n',
        '    "The land before you is filled",\n',
        '    "with peril...",\n',
        '    " ",\n',
        '    "Wand at the ready, you venture",\n',
        '    "forth to find the source",\n',
        '    "of this scourge."\n',
        '}\n',
        'cluster 2\n', -- E1M5-E1M8,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext =\n',
        '    "The enemy is relentless",\n',
        '    "and their numbers seem to",\n',
        '    "have no end.",\n',
        '    " ",\n',
        '    "Spellbook in hand,",\n',
        '    "you continue the battle",\n',
        '    "against the evil forces",\n',
        '    "arrayed before you..."\n',
        '}\n',
        'cluster 3\n', -- E2M1-E2M4,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext =\n',
        '    "You approach the next stronghold,",\n',
        '    "weary but determined...",\n',
        '    " ",\n',
        '    "The forces of darkness will not",\n',
        '    "win this day!"\n',
        '}\n',
        'cluster 4\n', -- E2M5-E2M8,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext =\n',
        '    "In slaying the lord of this foul",\n',
        '    "domain, you have struck a telling",\n',
        '    "blow against the enemy.",\n',
        '    " ",\n',
        '    "Alas, there is no rest until the",\n',
        '    "true master of this hellish army",\n',
        '    "is slain..."\n',
        '}\n',
        'cluster 5\n', -- E3M1-E3M4,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext =\n',
        '    "You have nearly exhausted the",\n',
        '    "fell legions that were sent to",\n',
        '    "destroy you.",\n',
        '    " ",\n',
        '    "The final test approaches,",\n',
        '    "and the greatest battle is yet",\n',
        '    "to be fought..."\n',
        '}\n',
        'cluster 6\n', -- E3M5-E3M8,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext =\n',
        '    "You have emerged as the victor",\n',
        '    "in a clash truly beyond reckoning.",\n',
        '    " ",\n',
        '    "Your quest is not over, however.",\n',
        '    "The desolation left in your wake must",\n',
        '    "be rebuilt...",\n',
        '    " ",\n',
        '    "After a well deserved rest."\n',
        '}\n',
        'cluster 7\n', -- E4M1-E4M4,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext =\n',
        '    "Filler text!"\n',
        '}\n',
        'cluster 8\n', -- E4M5-E4M8,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext =\n',
        '    "Can Oblige even make this many levels?"\n',
        '}\n',
        'cluster 9\n', -- E5M1-E5M4,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext =\n',
        '    "Seriously, how did you get here?"\n',
        '}\n',
        'cluster 10\n', -- E5M5-E5M8,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext =\n',
        '    "It\'s over...go home!"\n',
        '}\n',
        'cluster 11\n', -- E1M9,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  entertext =\n',
        '    "You have found a secret zone!",\n',
        '    "It seems the hellspawn have barricaded",\n',
        '    "themselves within its confines with to",\n',
        '    "gestate their hellish infection.",\n',
        '    " ",\n',
        '    "You are about to prove them otherwise."\n',
        '}\n',
        'cluster 12\n', -- E2M9,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  entertext =\n',
        '    "It seems this secret trail",\n',
        '    "goes further than expected.",\n',
        '    "It is time to finish this",\n',
        '    "once and for all and eradicate",\n',
        '    "this hidden pocket of hellish infestation."\n',
        '}\n',
        'cluster 13\n', -- E3M9,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  entertext =\n',
        '    "It seems this secret trail",\n',
        '    "goes further than expected.",\n',
        '    "It is time to finish this",\n',
        '    "once and for all and eradicate",\n',
        '    "this hidden pocket of hellish infestation."\n',
        '}\n',
        'cluster 14\n', -- E4M9,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  entertext =\n',
        '    "It seems this secret trail",\n',
        '    "goes further than expected.",\n',
        '    "It is time to finish this",\n',
        '    "once and for all and eradicate",\n',
        '    "this hidden pocket of hellish infestation."\n',
        '}\n',
        'cluster 15\n', -- E5M9,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  entertext =\n',
        '    "It seems this secret trail",\n',
        '    "goes further than expected.",\n',
        '    "It is time to finish this",\n',
        '    "once and for all and eradicate",\n',
        '    "this hidden pocket of hellish infestation."\n',
        '}\n'
      }
    end

    if PARAM.story_generator_heretic == "proc" then
      -- create cluster information
      clusterdef =
      {
        'cluster 1\n', -- E1M1-E1M4,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext = lookup, "STORYSTART1"\n',
        '}\n',
        'cluster 2\n', -- E1M5-E1M8,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext = lookup, "STORYEND1"\n',
        '}\n',
        'cluster 3\n', -- E2M1-E2M4,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext = lookup, "STORYSTART2"\n',
        '}\n',
        'cluster 4\n', -- E2M5-E2M8,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext = lookup, "STORYEND2"\n',
        '}\n',
        'cluster 5\n', -- E3M1-E3M4,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext = lookup, "STORYSTART3"\n',
        '}\n',
        'cluster 6\n', -- E3M5-E3M8,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext = lookup, "STORYEND3"\n',
        '}\n',
        'cluster 7\n', -- E4M1-E4M4,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext = lookup, "STORYSTART4"\n',
        '}\n',
        'cluster 8\n', -- E4M5-E4M8,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  entertext = lookup, "STORYEND4"\n',
        '}\n',
        'cluster 9\n', -- E5M1-E5M4,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  entertext = lookup, "STORYSTART5"\n',
        '}\n',
        'cluster 10\n', -- E5M5-E5M8,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  entertext = lookup, "STORYEND5"\n',
        '}\n',
        'cluster 11\n', -- E1M9,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext = lookup, "SECRET"\n',
        '}\n',
        'cluster 12\n', -- E2M9,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  exittext = lookup, "SECRET"\n',
        '}\n',
        'cluster 13\n', -- E3M9,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  entertext = lookup, "SECRET"\n',
        '}\n',
        'cluster 14\n', -- E4M9,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  entertext = lookup, "SECRET"\n',
        '}\n',
        'cluster 15\n', -- E5M9,
        '{\n',
        '' .. cluster_music_line .. '',
        '  pic = "' .. interpic .. '"\n',
        '  entertext = lookup, "SECRET"\n',
        '}\n'
      }
    end

    return clusterdef
  end

  local function add_episodedef(map_num)
    local episodedef = {''}
    local map_string = ZDOOM_SPECIALS_HERETIC.MAP_NOMENCLATURE[map_num]

    if not map_string then
      return nil
    end

    episodedef =
    {
      'episode ' .. map_string .. '\n',
      '{\n',
      '  name = "' .. GAME.levels[map_num].episode.description .. '"\n',
      '}\n'
    }

    return episodedef
  end

  local info = {}

--  local ipic = ZDOOM_SPECIALS_HERETIC.INTERPICS[cluster_num]

  -- collect lines for MAPINFO lump
  PARAM.mapinfolump = {}
  PARAM.gameinfolump = {}

  if PARAM.bool_heretic_quit_messages == 1 then
    local gamedef_lines = add_gamedef()
    for _,line in pairs(gamedef_lines) do
      table.insert(PARAM.gameinfolump,line)
    end
    ZStoryGen_quitmessages()
  end

  for i=1, #GAME.levels do

    info.map_num = i
    if i >= 1 and i <= 8 then
      info.interpic = ZDOOM_SPECIALS_HERETIC.INTERPICS[1]
    elseif i > 9 and i <= 17 then
      info.interpic = ZDOOM_SPECIALS_HERETIC.INTERPICS[2]
    elseif i > 18 and i <= 26 then
      info.interpic = ZDOOM_SPECIALS_HERETIC.INTERPICS[3]
    elseif i > 27 and i <= 35 then
      info.interpic = ZDOOM_SPECIALS_HERETIC.INTERPICS[4]
    elseif i > 36 and i <= 44 then
      info.interpic = ZDOOM_SPECIALS_HERETIC.INTERPICS[5]
    elseif i == 9 then
      info.interpic = ZDOOM_SPECIALS_HERETIC.INTERPICS[6]
    elseif i == 18 then
      info.interpic = ZDOOM_SPECIALS_HERETIC.INTERPICS[7]
    elseif i == 27 then
      info.interpic = ZDOOM_SPECIALS_HERETIC.INTERPICS[8]
    elseif i == 36 then
      info.interpic = ZDOOM_SPECIALS_HERETIC.INTERPICS[9]
    elseif i == 45 then
      info.interpic = ZDOOM_SPECIALS_HERETIC.INTERPICS[10]
    end

    if PARAM.fog_generator_heretic == "per_sky_gen" then
      if not PARAM.episode_sky_color then
        gui.printf("WARNING: User set fog color to be set by Sky Generator " ..
        "but Sky Generator is turned off! Fog color will now match vanilla skies.\n")
        if i <= 9 then
          info.fog_color = "ff ff ff"
        elseif i <= 18 then
          info.fog_color = "ff 00 00"
        elseif i <= 27 then
          info.fog_color = "00 00 ff"
        elseif i <= 36 then
          info.fog_color = "ff ff ff"
        else
          info.fog_color = "00 00 ff"
        end
      else
        if i <= 9 then
          info.fog_color = pick_sky_color_from_skygen_map(1)
        elseif i <= 18 then
          info.fog_color = pick_sky_color_from_skygen_map(2)
        elseif i <= 27 then
          info.fog_color = pick_sky_color_from_skygen_map(3)
        elseif i <= 36 then
          info.fog_color = pick_sky_color_from_skygen_map(4)
        else
          info.fog_color = pick_sky_color_from_skygen_map(5)
        end
      end
    elseif PARAM.fog_generator_heretic == "random" then
      info.fog_color = pick_random_fog_color()
    elseif PARAM.fog_generator_heretic == "natural" then
      local shades = 
      {
        "ff ff ff",
        "ea ea ea",
        "da da da",
        "bb bb bb",
        "a1 a1 a1",
      }
      info.fog_color = rand.pick(shades)
    else
      info.fog_color = ""
    end

    local mapinfo_lines = add_mapinfo(info)
    for _,line in pairs(mapinfo_lines) do
      table.insert(PARAM.mapinfolump,line)
    end

  end

  -- lines for episode definition

    table.insert(PARAM.mapinfolump,"clearepisodes\n")

    local episode_info = add_episodedef(1)
    for _,line in pairs(episode_info) do
      table.insert(PARAM.mapinfolump,line)
    end

    if #GAME.levels > 9 then
      episode_info = add_episodedef(10)
      for _,line in pairs(episode_info) do
        table.insert(PARAM.mapinfolump,line)
      end
    end

    if #GAME.levels > 18 then
      episode_info = add_episodedef(19)
      for _,line in pairs(episode_info) do
        table.insert(PARAM.mapinfolump,line)
      end
    end

    if #GAME.levels > 27 then
      episode_info = add_episodedef(28)
      for _,line in pairs(episode_info) do
        table.insert(PARAM.mapinfolump,line)
      end
    end

    if #GAME.levels > 36 then
      episode_info = add_episodedef(37)
      for _,line in pairs(episode_info) do
        table.insert(PARAM.mapinfolump,line)
      end
    end

  -- collect lines for the cluster information in MAPINFO
  local clusterinfo_lines = add_clusterdef(info.interpic)
  if clusterinfo_lines then
    for _,line in pairs(clusterinfo_lines) do
      table.insert(PARAM.mapinfolump,line)
    end
  end

  -- FIX-ME!!! Redo all code here to use strings as per original Doom ZDoom Specials Module.
  local lines_as_string = ''
  for _,line in pairs(PARAM.mapinfolump,line) do
    lines_as_string = lines_as_string .. line
  end
  SCRIPTS.mapinfolump = ScriptMan_combine_script(SCRIPTS.mapinfolump, lines_as_string)

  if PARAM.story_generator_heretic == "proc" then
    -- language lump is written inside the story generator
    ZStoryGen_init()
  end

  gui.wad_merge_sections("games/heretic/data/loading/loading_screens.wad")

end

OB_MODULES["zdoom_specials_heretic"] =
{

  name = "zdoom_specials_heretic",

  label = _("ZDoom Special Addons"),

  game = "heretic",

  priority = 68,

  engine = "idtech_1",
  port = "zdoom",
  where = "other",

  hooks =
  {
    setup = ZDOOM_SPECIALS_HERETIC.setup,
    get_levels = ZDOOM_SPECIALS_HERETIC.shuffle_music,
    all_done = ZDOOM_SPECIALS_HERETIC.do_special_stuff
  },

  tooltip = _("This module adds new ZDoom-exclusive features such as fog. More ZDoom-specific features will be included soon."),

  options =
  {
    {
      name = "fog_generator_heretic",
      label = _("Fog Generator"),
      priority = 12,
      choices = ZDOOM_SPECIALS_HERETIC.FOG_GEN_CHOICES,
      default = "no",
      tooltip = _("Generates fog colors based on the Sky Generator or generate completely randomly."),
      randomize_group = "misc"
    },

    {
      name = "fog_env_heretic",
      label = _("Fog Environment"),
      priority = 11,
      choices = ZDOOM_SPECIALS_HERETIC.FOG_ENV_CHOICES,
      default = "all",
      tooltip = _("Limits fog to outdoors (sectors with exposed sky ceilings) or allows for all."),
      randomize_group = "misc"
    },

    {
      name = "fog_intensity_heretic",
      label = _("Fog Intensity"),
      priority = 10,
      choices = ZDOOM_SPECIALS_HERETIC.FOG_DENSITY_CHOICES,
      default = "subtle",
      tooltip = _("Determines thickness and intensity of fog, if the Fog Generator is enabled. Subtle or Misty is recommended."),
      randomize_group = "misc"
    },

    {
      name = "bool_fog_affects_sky_heretic",
      label = _("Sky Fog"),
      valuator = "button",
      priority = 9,
      default = 1,
      tooltip = _("Tints the sky texture with the fog color, intensity is based on the Fog Intensity selection."),
      gap = 1,
      randomize_group = "misc"
    },

    {
      name = "mapinfo_music_shuffler_heretic",
      label = _("Shuffle Music"),
      priority = 6,
      choices = ZDOOM_SPECIALS_HERETIC.MUSIC_SHUFFLER_CHOICES,
      default = "no",
      tooltip = _("Shuffles music in the MAPINFO lump."),
    },

    {
      name = "story_generator_heretic",
      label = _("Story Generator"),
      priority = 5,
      choices = ZDOOM_SPECIALS_HERETIC.STORY_CHOICES,
      default = "proc",
      tooltip = _("Adds cluster information with generic or randomized story text into the MAPINFO structure!"),
    },

    {
      name = "bool_heretic_quit_messages",
      label = _("Quit Messages"),
      valuator = "button",
      priority = 4,
      default = 1,
      tooltip = _("Adds custom quit messages into the MAPINFO game definition."),
    },

    {
      name = "generic_intermusic_heretic",
      label = _("Intermission Music"),
      priority = 3,
      choices = ZDOOM_SPECIALS_HERETIC.INTERPIC_MUSIC,
      default = "MUS_INTR",
      tooltip = _("Changes the music playing during intermission screens."),
    },

    {
      name = "bool_no_intermission_heretic",
      label = _("Disable Intermissions"),
      valuator = "button",
      priority = 1,
      default = 0,
      tooltip = _("Removes end-level Intermission Screens (containing map completion data) but retains Text Screens with story."),
    },
  },
}
