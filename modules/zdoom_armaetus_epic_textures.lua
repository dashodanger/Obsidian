------------------------------------------------------------------------
--  MODULE: Obsidian Epic Resource Pack
------------------------------------------------------------------------
--
--  Copyright (C) 2019-2022 Reisal
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
--  Copyright (C) 2020-2022 Craneo
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
-------------------------------------------------------------------

gui.import("zdoom_armaetus_materials.lua")
gui.import("zdoom_armaetus_themes.lua")
gui.import("zdoom_armaetus_entities.lua")

gui.import("zdoom_armaetus_doom1_themes.lua")

gui.import("zdoom_armaetus_epic_texturex_lump.lua")

gui.import("zdoom_orp_generative_resources.lua")

-- Rename to OBSIDIAN_TEXTURES? I am not the only author putting the
-- texture pack together, includes MSSP and Craneo as well.
OBS_RESOURCE_PACK_EPIC_TEXTURES = { }

OBS_RESOURCE_PACK_EPIC_TEXTURES.SOUCEPORT_CHOICES =
{
  "zs",       _("ZScript"),
  "decorate", _("ACS-Decorate"),
  "no",       _("No"),
}

OBS_RESOURCE_PACK_EPIC_TEXTURES.ENVIRONMENT_THEME_CHOICES =
{
  "random",    _("Random"),
  "episodic",  _("Episodic"),
  "mixed",     _("A Bit Mixed"),
  "snowish",   _("Snow-ish"),
  "desertish", _("Desert-ish"),
  "snow",      _("Always Snow"),
  "desert",    _("Always Desert"),
  "no",        _("No"),
}

-- Reisal: Do we really need the template here anymore? I have not
-- seen this in use or was superceded by the Tree/Flora module.
OBS_RESOURCE_PACK_EPIC_TEXTURES.TEMPLATES =
{
   ZS_TREES =
[[class FancyObligeTree : BigTree replaces BigTree
{

    States
    {
        Spawn:
            TRE2 A 0 NoDelay
            {
                StateLabel fstate;

                bool onGrass = false;
                bool onRock = false;
                //snow and sand flats are only available
                //via Epic Textures module.
                bool onSnow = false;
                bool onSand = false;
                bool onHellscape = false;
                bool unknownFlat = false;
                bool indoors = false;

                A_SetSize(10,-1,-1);

                Name onFlat = TexMan.GetName(floorpic);
                Name onCeil = TexMan.GetName(ceilingpic);
                switch(onFlat)
                {
                    case 'GRASS1':
                    case 'GRASS2':
                    case 'GROUND01':
                    case 'GROUND02':
                    case 'GROUND03':
                    case 'GROUND04':
                    case 'FLAT10':
                    case 'QFLAT07': //I think this is dirt?
                    case 'RROCK09':
                    case 'RROCK16':
                    case 'RROCK17':
                    case 'RROCK18':
                    case 'RROCK19':
                    case 'RROCK20':
                        onGrass = true;
                        break;
                    case 'SNOW1':
                    case 'SNOW5':
                    case 'SNOW6':
                    case 'SNOW7':
                    case 'SNOW8':
                    case 'SNOW10F':
                    case 'SNOW11F':
                    case 'SNOW12F':
                    case 'SNOW13F':
                    case 'SNOW14F':
                        onSnow = true;
                        break;
                    case 'SAND1':
                    case 'SAND2':
                    case 'SAND3':
                    case 'SAND4':
                    case 'SAND5':
                    case 'SAND6':
                    case 'SAND7':
                    case 'RROCK09': // Doubles as sand/rock
                        onSand = true;
                        break;
                    case 'RROCK01':
                    case 'RROCK02':
                    case 'RROCK05':
                    case 'RROCK06':
                    case 'RROCK07':
                    case 'RROCK08':
                    case 'FLOOR6_1':
                    case 'SFLR6_1':
                    case 'SFLR6_4':
                    case 'SKINFLT1':
                    case 'SLIME09':
                    case 'SLIME10':
                    case 'SLIME11':
                    case 'SLIME12':
                        onHellscape = true;
                        break;
                    default:
                        unknownFlat = true;
                }

                if(onGrass)
                {
                    if(random(1,100) <= 75) //Trees
                    {
                        switch(random(1,5))
                        {
                            case 1:
                                fstate = "OakTree";
                                break;
                            case 2:
                                fstate = "RedwoodTree";
                                break;
                            case 3:
                                fstate = "SomeThinTree";
                                break;
                            case 4:
                                fstate = "TapwaveTreeA";
                                break;
                            case 5:
                                fstate = "TapwaveTreeB";
                                break;
                        }
                    }
                    else //Bushes
                    {
                        switch(random(1,2))
                        {
                            case 1:
                                fstate = "ShrubA";
                                break;
                            case 2:
                                fstate = "ShrubB";
                                break;
                        }
                    }
                }

                if(onSnow)
                {
                    int index = 1;

                    if(random(1,4) >= 2)
                    {
                        index = random(10,14);
                    }else
                    {
                        index = random(1,9);
                    }

                    switch(index)
                    {
                        case 1:
                            fstate = "SnowTreeDeadA";
                            break;
                        case 2:
                            fstate = "SnowTreeKebab";
                            break;
                        case 3:
                            fstate = "SnowTreePloughed";
                            break;
                        case 4:
                            fstate = "SnowTreeDeadB";
                            break;
                        case 5:
                            fstate = "SnowTreeDeadC";
                            break;
                        case 6:
                            fstate = "SnowPineA";
                            break;
                        case 7:
                            fstate = "SnowPineB";
                            break;
                        case 8:
                            fstate = "SnowPineSmolA";
                            break;
                        case 9:
                            fstate = "SnowPineSmolB";
                            break;
                        case 10:
                            fstate = "CraneoPine1";
                            break;
                        case 11:
                            fstate = "CraneoPine2";
                            break;
                        case 12:
                            fstate = "CraneoPine3";
                            break;
                        case 13:
                            fstate = "CraneoPine4";
                            break;
                        case 14:
                            fstate = "CraneoPine5";
                            break;
                    }
                }

                if(onSand)
                {
                    switch(random(1,5))
                    {
                        case 1:
                            fstate = "PalmTree";
                            break;
                        case 2:
                            fstate = "DesertTreeA";
                            break;
                        case 3:
                            fstate = "DesertTreeB";
                            break;
                        case 4:
                            fstate = "ShrubA";
                            break;
                        case 5:
                            fstate = "ShrubB";
                            break;
                    }
                }

                if(onHellscape)
                {
                    switch(random(1,6))
                    {
                        case 1:
                            fstate = "CraneoEyeTreeA";
                            break;
                        case 2:
                            fstate = "CraneoEyeTreeB";
                            break;
                        case 3:
                            fstate = "CraneoEyeTreeC";
                            break;
                        case 4:
                            fstate = "CraneoWeirwoodTreeA";
                            break;
                        case 5:
                            fstate = "CraneoWeirwoodTreeB";
                            break;
                        case 6:
                            fstate = "CraneoWeirwoodTreeC";
                            break;
                    }
                }

                if(unknownFlat)
                {
                    switch(random(1,3))
                    {
                        case 1:
                            fstate = "CraneoDeadTreeA";
                            break;
                        case 2:
                            fstate = "CraneoDeadTreeB";
                            break;
                        case 3:
                            fstate = "CraneoDeadTreeC";
                            break;
                    }
                }

                if(onCeil != 'F_SKY1')
                {
                    scale.x *= 0.5; //For those occasional indoor planters
                    scale.y *= 0.5; //in urban theme.
                    switch(random(1,2))
                    {
                        case 1:
                            fstate = "ShrubA";
                            break;
                        case 2:
                            fstate = "ShrubB";
                            break;
                    }
                }

                //add a bit of random scaling jazz
                //CraneoPine# set is already 200ish height and doesn't need
                //adjustments
                double randomscale = frandom(0.8, 1.5);
                scale.x *= randomscale;
                scale.y *= randomscale;

                // 50% chance of flippin'
                scale.x *= randompick(-1,1);

                return ResolveState(fstate);
            }

        // temperate plants
        OakTree:
            OAK1 A 1;
            Loop;

        RedwoodTree:
            RED1 A 1;
            Loop;

        SomeThinTree:
            THN1 A 1;
            Loop;

        TapwaveTreeA:
            TWTR A 1;
            Loop;

        TapwaveTreeB:
            TWTR B 1;
            Loop;

        ShrubA:
            SHB1 A 1;
            Loop;

        ShrubB:
            SHB2 A 1;
            Loop;

        // snow world plants
        SnowTreeDeadA:
            XMAS A 1;
            Loop;

        SnowTreeKebab:
            XMAS B 1;
            Loop;

        SnowTreePloughed:
            XMAS C 1;
            Loop;

        SnowTreeDeadB:
            XMAS D 1;
            Loop;

        SnowTreeDeadC:
            XMAS E 1;
            Loop;

        SnowPineA:
            XMAS F 1;
            Loop;

        SnowPineB:
            XMAS G 1;
            Loop;

        SnowPineSmolA:
            XMAS H 1;
            Loop;

        SnowPineSmolB:
            XMAS I 1;
            Loop;

        CraneoPine1:
            XMAS J -1;
            Loop;

        CraneoPine2:
            XMAS K -1;
            Loop;

        CraneoPine3:
            XMAS L -1;
            Loop;

        CraneoPine4:
            XMAS M -1;
            Loop;

        CraneoPine5:
            XMAS N -1;
            Loop;

        // desert assets
        PalmTree:
            PLM1 A 1;
            Loop;

        DesertTreeA:
            DTR1 A 1;
            Loop;

        DesertTreeB:
            DTR2 A 1;
            Loop;

        // hell trees
        // eyeball trees
        CraneoEyeTreeA:
            OBET A 1;
            Loop;

        CraneoEyeTreeB:
            OBET B 1;
            Loop;

        CraneoEyeTreeC:
            OBET C 1;
            Loop;

        // weirwood trees
        CraneoWeirwoodTreeA:
            OBWT A 1;
            Loop;

        CraneoWeirwoodTreeB:
            OBWT B 1;
            Loop;

        CraneoWeirwoodTreeC:
            OBWT C 1;
            Loop;

        // sad, sad, sad dead trees very sad
        CraneoDeadTreeA:
            OBDT A 1;
            Loop;

        CraneoDeadTreeB:
            OBDT B 1;
            Loop;

        CraneoDeadTreeC:
            OBDT C 1;
            Loop;
    }
}

class FancyObligeTree2 : FancyObligeTree replaces TorchTree
{
}]],

  DEC_TREES =
[[
  actor FancyObligeTree replaces BigTree
{
    Radius 16
    Height 128
    ProjectilePassHeight -16
    +SOLID

    States
    {
        Spawn:
      TRE2 A 0
      TRE2 A 0 ACS_NamedExecuteAlways("IsMyAssGrass")
      TRE2 A 5
      Goto Decide

        Decide:
      TRE2 A 1
      TRE2 A 0 A_JumpIfInventory("AssIsGrass", 1, "OnGrass")
      TRE2 A 0 A_JumpIfInventory("AssIsSnow", 1, "OnSnow")
      TRE2 A 0 A_JumpIfInventory("AssIsSand", 1, "OnSand")
      TRE2 A 0 A_JumpIfInventory("AssIsHell", 1, "OnHellflat")
      TRE2 A 0 A_Jump(255, "OnUnknownFlat")

        OnGrass:
      TRE2 A 0 A_Jump(127, "Shrub1", "Shrub2")
      TRE2 A 0 A_Jump(255, "OakTree", "RedwoodTree", "SomeThinTree",
      "TapwaveTreeA", "TapwaveTreeB")

        OnSnow:
      TRE2 A 0 A_Jump(64, "SnowTreeDeadA", "SnowTreeKebab",
      "SnowTreePloughed", "SnowTreeDeadB", "SnowTreeDeadC",
      "SnowPineA", "SnowPineB", "SnowPineSmolA", "SnowPineSmolB")
      TRE2 A 0 A_Jump(255, "CraneoPine1", "CraneoPine2",
      "CraneoPine3", "CraneoPine4", "CraneoPine5")
      // Only Craneo's pine trees now get a height boost

        OnSand:
      TRE2 A 0 A_Jump(255, "PalmTree", "DesertTreeA", "DesertTreeB",
      "Shrub1", "Shrub2")

        OnHellflat:
      TRE2 A 0 A_Jump(255, "CraneoEyeTreeA", "CraneoEyeTreeB",
      "CraneoEyeTreeC", "CraneoWeirwoodTreeA", "CraneoWeirwoodTreeB",
      "CraneoWeirwoodTreeC")

        OnUnknownFlat:
      TRE2 A 0 A_Jump(255, "CraneoDeadTreeA",
      "CraneoDeadTreeB", "CraneoDeadTreeC")

        //temperate trees
        OakTree:
      OAK1 A -1

        RedwoodTree:
      RED1 A -1

        SomeThinTree:
      THN1 A -1

        TapwaveTreeA:
      TWTR A -1

        TapwaveTreeB:
      TWTR B -1

        Shrub1:
      SHB1 A -1

        Shrub2:
      SHB2 A -1

        //snow trees
        SnowTreeDeadA:
      XMAS A -1

        SnowTreeKebab:
      XMAS B -1

        SnowTreePloughed:
      XMAS C -1

        SnowTreeDeadB:
      XMAS D -1

        SnowTreeDeadC:
      XMAS E -1

        SnowPineA:
      XMAS F -1

        SnowPineB:
      XMAS G -1

        SnowPineSmolA:
      XMAS H -1

        SnowPineSmolB:
      XMAS I -1

        CraneoPine1:
      XMAS J -1

        CraneoPine2:
      XMAS K -1

        CraneoPine3:
      XMAS L -1

        CraneoPine4:
      XMAS M -1

        CraneoPine5:
      XMAS N -1

        //desert trees
        PalmTree:
      PLM1 A -1

        DesertTreeA:
      DTR1 A -1

        DesertTreeB:
      DTR2 A -1

        // hell trees
        // eyeball trees
        CraneoEyeTreeA:
      OBET A -1

        CraneoEyeTreeB:
      OBET B -1

        CraneoEyeTreeC:
      OBET C -1

        // weirwood trees
        CraneoWeirwoodTreeA:
      OBWT A -1

        CraneoWeirwoodTreeB:
      OBWT B -1

        CraneoWeirwoodTreeC:
      OBWT C -1

        // sad, sad, sad dead trees very sad
        CraneoDeadTreeA:
      OBDT A -1

        CraneoDeadTreeB:
      OBDT B -1

        CraneoDeadTreeC:
      OBDT C -1
    }
}

actor FancyObligeTreeAndBush : FancyObligeTree replaces TorchTree{}

actor AssIsGrass : Inventory
{
    Inventory.maxAmount 1
}

actor AssIsSnow : Inventory
{
    Inventory.maxAmount 1
}

actor AssIsSand : Inventory
{
    Inventory.maxAmount 1
}

actor AssIsHell : Inventory
{
    Inventory.maxAmount 1
}
]]
}

function OBS_RESOURCE_PACK_EPIC_TEXTURES.setup(self)

  PARAM.obsidian_resource_pack_active = true
  module_param_up(self)
  OBS_RESOURCE_PACK_EPIC_TEXTURES.put_new_materials()
  OBS_RESOURCE_PACK_EPIC_TEXTURES.synthesize_procedural_themes()
end


function OBS_RESOURCE_PACK_EPIC_TEXTURES.synthesize_procedural_themes()
  if PARAM.bool_orp_room_theme_synthesizer == false then
    return
  end

  local function pick_element(lev_theme, texture_type)
    local t, RT = {}
    local result
    RT = table.copy(GAME.ROOM_THEMES)
    table.name_up(RT)

    -- collect all viable room themes
    for _,RX in pairs(RT) do
      if string.match(RX.name, lev_theme .. "_") and
      RX.env == "building" then
        table.insert(t, RX.name)
      end
    end

    -- pick one theme
    local room_theme_pick = rand.pick(t)

    -- pick one texture from a group in theme
    result = rand.key_by_probs(RT[room_theme_pick][texture_type])
    return result
  end

  local function create_theme(lev_theme, name)
    local theme = lev_theme
    local t = {}
    t.floors = {} 
    t.walls = {}
    t.ceilings = {}

    if theme == "any" then
      name = "any_" .. name
      theme = rand.pick({"tech","urban","hell"})
    else
      name = theme .. "_" .. name
    end

    t.env = "building"
    t.prob = rand.pick({20,30,40,50,60}) * PARAM.float_orp_room_theme_synth_mult

    t.floors[pick_element(theme, "floors")] = 5
    t.floors[pick_element(theme, "floors")] = 5
    t.walls[pick_element(theme, "walls")] = 5
    t.ceilings[pick_element(theme, "ceilings")] = 5
    t.ceilings[pick_element(theme, "ceilings")] = 5

    t.name = name

    GAME.ROOM_THEMES[t.name] = t
  end

  local function synthesize_themes(y)    
    for x = 1, y do
      create_theme("tech", "synth_room_theme_" .. x)
      create_theme("urban", "synth_room_theme_" .. x)
      create_theme("hell", "synth_room_theme_" .. x)
      create_theme("any", "synth_room_theme_" .. x)
    end
  end

  synthesize_themes(5)
end


function OBS_RESOURCE_PACK_EPIC_TEXTURES.get_levels_after_themes()


  OBS_RESOURCE_PACK_EPIC_TEXTURES.decide_environment_themes()

  table.deep_merge(GAME.ENTITIES, ORP_ENTITIES.ENTITIES)

  if PARAM.bool_include_custom_actors ~= 1 then
    if not THEME.entity_remap then
      THEME.entity_remap = {}
    end
    THEME.entity_remap[27000] = 0
    THEME.entity_remap[27001] = 0
    THEME.entity_remap[27002] = 0
    THEME.entity_remap["orp_blood_pack"] = 0
    THEME.entity_remap["orp_burning_top"] = 0
    THEME.entity_remap["orp_burning_debris"] = 0
  end
end

function OBS_RESOURCE_PACK_EPIC_TEXTURES.decide_night_replacement_textures(LEVEL)
  if LEVEL.episode and LEVEL.episode.dark_prob == 100
  or LEVEL.is_dark then
    GAME.MATERIALS["CITY04"].t = "CITY04N"
    GAME.MATERIALS["CITY05"].t = "CITY05N"
    GAME.MATERIALS["CITY06"].t = "CITY06N"
    GAME.MATERIALS["CITY07"].t = "CITY07N"
    GAME.MATERIALS["CITY11"].t = "CITY11N"
    GAME.MATERIALS["CITY12"].t = "CITY12N"
    GAME.MATERIALS["CITY13"].t = "CITY13N"
    GAME.MATERIALS["CITY14"].t = "CITY14N"
  else
    GAME.MATERIALS["CITY04"].t = "CITY04"
    GAME.MATERIALS["CITY05"].t = "CITY05"
    GAME.MATERIALS["CITY06"].t = "CITY06"
    GAME.MATERIALS["CITY07"].t = "CITY07"
    GAME.MATERIALS["CITY11"].t = "CITY11"
    GAME.MATERIALS["CITY12"].t = "CITY12"
    GAME.MATERIALS["CITY13"].t = "CITY13"
    GAME.MATERIALS["CITY14"].t = "CITY14"
  end
end

function OBS_RESOURCE_PACK_EPIC_TEXTURES.decide_environment_themes()
  --------------------
  -- Outdoor Themes --
  --------------------
  -- Outdoor themes are essentially 'mutator' style inserts
  -- to replace the flats of outdoor rooms to match a specific
  -- theme - particularly snow and sand. Currently, there are three
  -- themes:
  --
  -- 1) Snow - emphasis on cold and snow, white textures.
  -- 2) Desert - emphasis on bright sand.
  -- 3) Temperate - technically not actually a theme, but a catch-all
  --                for the default circumstances of using ordinary
  --                grass, rock, etc. in temperate regions as is the
  --                norm for vanilla Doom-ish games.
  --
  -- Essentially, when "Temperate" is the selected theme, the
  -- environment theme code simply just doesn't run.

  if PARAM.environment_themes == "no" then return end

  -- pick a random environment
  if PARAM.environment_themes == "random" then
    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = rand.pick({"temperate","snow","desert"})
    end
  end

  -- just like a bit mixed - every 2-6 levels, the theme will change
  if PARAM.environment_themes == "mixed" then
    local previous_theme
    local outdoor_theme_along

    for _,L in pairs(GAME.levels) do
      if L.id == 1 then
        L.outdoor_theme = rand.pick({"temperate","snow","desert"})
        previous_theme = L.outdoor_theme
        outdoor_theme_along = rand.irange(2,4)
      elseif L.id > 1 then
        -- continue the same theme until the countdown ends
        if outdoor_theme_along > 0 then
          L.outdoor_theme = previous_theme
          outdoor_theme_along = outdoor_theme_along - 1
        -- decide a new theme when the countdown ends
        -- logic goes that deserts cannot go to snow immediately
        -- and vice versa
        elseif outdoor_theme_along <= 0 then
          if previous_theme == "temperate" then
            L.outdoor_theme = rand.pick({"snow","desert"})
          else
            L.outdoor_theme = "temperate"
          end
          previous_theme = L.outdoor_theme
          outdoor_theme_along = rand.irange(2,4)
        end
      end
    end
  end

  -- -ish environment themes
  if PARAM.environment_themes == "snowish" then
    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = rand.pick({"temperate","snow"})
    end
  elseif PARAM.environment_themes == "desertish" then
    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = rand.pick({"temperate","desert"})
    end
  end

  -- absolutes
  if PARAM.environment_themes == "snow" then
    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = "snow"
    end
  elseif PARAM.environment_themes == "desert" then
    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = "desert"
    end
  end

  if PARAM.environment_themes == "episodic" then
    local prev_theme

    for _,E in pairs(GAME.episodes) do
      if not prev_theme then
        E.outdoor_theme = rand.pick({"temperate","desert","snow"})
        prev_theme = E.outdoor_theme
      else
        if prev_theme ~= "temperate" then
          E.outdoor_theme = "temperate"
          prev_theme = E.outdoor_theme
        else
          E.outdoor_theme = rand.pick({"snow","desert"})
          prev_theme = E.outdoor_theme
        end
      end
    end

    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = L.episode.outdoor_theme
    end
  end

  if PARAM.bool_no_env_theme_for_hell == 1 then
    for _,L in pairs(GAME.levels) do
      if L.theme_name == "hell" then
        L.outdoor_theme = "temperate"
      end
    end
  end

  gui.printf("\n--==| Environment Outdoor Themes |==--\n\n")
  for _,L in pairs(GAME.levels) do
    if L.outdoor_theme then
      gui.printf("Outdoor theme for " .. L.name .. ": " .. L.outdoor_theme .. "\n")
    end
  end
end

function OBS_RESOURCE_PACK_EPIC_TEXTURES.generate_environment_themes(self, LEVEL)
  --------------------------------------
  -- Style Update for Custom Elements --
  --------------------------------------

  -- covers hallways only for now
  -- MSSP-TODO: revise this code to be more generic for future expansion
  if THEME.wide_halls then
    if LEVEL.theme_name == "hell" then
      THEME.wide_halls.hellcata = 50 * style_sel("liquids", 0.3, 0.7, 1.2, 1.5)
                                    * style_sel("traps", 0.3, 0.7, 1.2, 1.5)
    elseif LEVEL.theme_name == "tech" or LEVEL.theme_name == "urban" then
      THEME.wide_halls.sewers = 50 * style_sel("liquids", 0.3, 0.7, 1.2, 1.5)
    end
  end

  if PARAM.bool_jump_crouch == 0 then
    if THEME.wide_halls then
      THEME.wide_halls.organs = 0
      THEME.wide_halls.conveyorh = 0
    end
  end

  -- initialize default tables
  if not PARAM.default_environment_themes_init then
    -- Doom 2
    if OB_CONFIG.game == "doom2" then
      -- floors
      PARAM.def_tech_floors = GAME.ROOM_THEMES.tech_Outdoors_generic.floors
      PARAM.def_urban_floors = GAME.ROOM_THEMES.urban_Outdoors_generic.floors
      PARAM.def_hell_floors = GAME.ROOM_THEMES.hell_Outdoors_generic.floors
      -- naturals
      PARAM.def_tech_naturals = GAME.ROOM_THEMES.tech_Outdoors_generic.naturals
      PARAM.def_urban_naturals = GAME.ROOM_THEMES.urban_Outdoors_generic.naturals
      PARAM.def_hell_naturals = GAME.ROOM_THEMES.hell_Outdoors_generic.naturals

    -- Doom 1
    elseif OB_CONFIG.game == "doom1"
    or OB_CONFIG.game == "ultdoom" then
      -- floors
      PARAM.def_tech_floors = GAME.ROOM_THEMES.tech_Outdoors.floors
      PARAM.def_deimos_floors = GAME.ROOM_THEMES.deimos_Outdoors.floors
      PARAM.def_hell_floors = GAME.ROOM_THEMES.hell_Outdoors.floors
      PARAM.def_flesh_floors = GAME.ROOM_THEMES.flesh_Outdoors.floors
      -- naturals
      PARAM.def_tech_naturals = GAME.ROOM_THEMES.tech_Outdoors.naturals
      PARAM.def_deimos_naturals = GAME.ROOM_THEMES.deimos_Outdoors.naturals
      PARAM.def_hell_naturals = GAME.ROOM_THEMES.hell_Outdoors.naturals
      PARAM.def_flesh_naturals = GAME.ROOM_THEMES.flesh_Outdoors.naturals
    end

    PARAM.default_environment_themes_init = true
  end

  -- checking in on custom outdoors
  -- snow
  local snow_tech_floors = OBS_RESOURCE_PACK_SNOW_OUTDOORS.tech.floors
  local snow_urban_floors = OBS_RESOURCE_PACK_SNOW_OUTDOORS.urban.floors
  local snow_hell_floors = OBS_RESOURCE_PACK_SNOW_OUTDOORS.hell.floors

  local snow_naturals = OBS_RESOURCE_PACK_SNOW_OUTDOORS.naturals
  local snow_facades = OBS_RESOURCE_PACK_SNOW_FACADE

  --sand
  local sand_tech_floors = OBS_RESOURCE_PACK_DESERT_OUTDOORS.tech.floors
  local sand_urban_floors = OBS_RESOURCE_PACK_DESERT_OUTDOORS.urban.floors
  local sand_hell_floors = OBS_RESOURCE_PACK_DESERT_OUTDOORS.hell.floors

  local sand_naturals = OBS_RESOURCE_PACK_DESERT_OUTDOORS.naturals
  local sand_facades = OBS_RESOURCE_PACK_DESERT_FACADE

  if OB_CONFIG.game == "doom2" then
    if LEVEL.outdoor_theme == "snow" then
      GAME.ROOM_THEMES.tech_Outdoors_generic.floors = snow_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors_generic.naturals = snow_naturals
      GAME.ROOM_THEMES.urban_Outdoors_generic.floors = snow_urban_floors
      GAME.ROOM_THEMES.urban_Outdoors_generic.naturals = snow_naturals
      GAME.ROOM_THEMES.hell_Outdoors_generic.floors = snow_hell_floors
      GAME.ROOM_THEMES.hell_Outdoors_generic.naturals = snow_naturals
    elseif LEVEL.outdoor_theme == "desert" then
      GAME.ROOM_THEMES.tech_Outdoors_generic.floors = sand_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors_generic.naturals = sand_naturals
      GAME.ROOM_THEMES.urban_Outdoors_generic.floors = sand_urban_floors
      GAME.ROOM_THEMES.urban_Outdoors_generic.naturals = sand_naturals
      GAME.ROOM_THEMES.hell_Outdoors_generic.floors = sand_hell_floors
      GAME.ROOM_THEMES.hell_Outdoors_generic.naturals = sand_naturals
    elseif LEVEL.outdoor_theme == "temperate" then
      GAME.ROOM_THEMES.tech_Outdoors_generic.floors = PARAM.def_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors_generic.naturals = PARAM.def_tech_naturals
      GAME.ROOM_THEMES.urban_Outdoors_generic.floors = PARAM.def_urban_floors
      GAME.ROOM_THEMES.urban_Outdoors_generic.naturals = PARAM.def_urban_naturals
      GAME.ROOM_THEMES.hell_Outdoors_generic.floors = PARAM.def_hell_floors
      GAME.ROOM_THEMES.hell_Outdoors_generic.naturals = PARAM.def_hell_naturals
    end
  -- MSSP-TODO: check cliff mats for Doom1
  elseif OB_CONFIG.game == "doom1"
  or OB_CONFIG.game == "ultdoom" then
    if LEVEL.outdoor_theme == "snow" then
      GAME.ROOM_THEMES.tech_Outdoors.floors = snow_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors.naturals = snow_naturals
      GAME.ROOM_THEMES.deimos_Outdoors.floors = snow_tech_floors
      GAME.ROOM_THEMES.deimos_Outdoors.naturals = snow_naturals
      GAME.ROOM_THEMES.hell_Outdoors.floors = sand_hell_floors
      GAME.ROOM_THEMES.hell_Outdoors.naturals = snow_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.floors = snow_urban_floors
      GAME.ROOM_THEMES.flesh_Outdoors.naturals = snow_naturals
    elseif LEVEL.outdoor_theme == "desert" then
      GAME.ROOM_THEMES.tech_Outdoors.floors = sand_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors.naturals = sand_naturals
      GAME.ROOM_THEMES.deimos_Outdoors.floors = snow_tech_floors
      GAME.ROOM_THEMES.deimos_Outdoors.naturals = sand_naturals
      GAME.ROOM_THEMES.hell_Outdoors.floors = sand_hell_floors
      GAME.ROOM_THEMES.hell_Outdoors.naturals = sand_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.floors = snow_urban_floors
      GAME.ROOM_THEMES.flesh_Outdoors.naturals = sand_naturals
    elseif LEVEL.outdoor_theme == "temperate" then
      GAME.ROOM_THEMES.tech_Outdoors.floors = PARAM.def_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors.naturals = PARAM.def_tech_naturals
      GAME.ROOM_THEMES.deimos_Outdoors.floors = PARAM.def_deimos_floors
      GAME.ROOM_THEMES.deimos_Outdoors.naturals = PARAM.def_deimos_naturals
      GAME.ROOM_THEMES.hell_Outdoors.floors = PARAM.def_hell_naturals
      GAME.ROOM_THEMES.hell_Outdoors.naturals = PARAM.def_hell_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.floors = PARAM.def_flesh_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.naturals = PARAM.def_flesh_naturals
    end
  end

  OBS_RESOURCE_PACK_EPIC_TEXTURES.decide_night_replacement_textures(LEVEL)
end

function OBS_RESOURCE_PACK_EPIC_TEXTURES.table_insert(table1, table2)
  for x,y in pairs(table1) do
    table2[x] = y
  end
end

function OBS_RESOURCE_PACK_EPIC_TEXTURES.put_new_materials()
  -- MSSP-TODO - redo all this code to just use a single deep merge table operation
  if OB_CONFIG.game == "doom2" or OB_CONFIG.game == "plutonia"
  or OB_CONFIG.game == "tnt" then

    -- remove old skybox tables
    GAME.THEMES["tech"].skyboxes = nil
    GAME.THEMES["urban"].skyboxes = nil
    GAME.THEMES["hell"].skyboxes = nil

    -- material definitions
    OBS_RESOURCE_PACK_EPIC_TEXTURES.table_insert(OBS_RESOURCE_PACK_MATERIALS,
      GAME.MATERIALS)
    OBS_RESOURCE_PACK_EPIC_TEXTURES.table_insert(OBS_RESOURCE_PACK_LIQUID_DEFS,
      GAME.LIQUIDS)

    -- put the custom theme definitions in the themes table!!!
    -- LIQUIDZ
    if PARAM.bool_custom_liquids == 1 then
      GAME.THEMES = table.deep_merge(GAME.THEMES, OBS_RESOURCE_PACK_LIQUIDS, 2)
    end

    -- ROOM THEMES
    GAME.ROOM_THEMES = table.deep_merge(GAME.ROOM_THEMES, OBS_RESOURCE_PACK_ROOM_THEMES, 2)

    -- definitions
    GAME.SINKS = table.deep_merge(GAME.SINKS, OBS_RESOURCE_PACK_SINK_DEFS, 2)
    GAME.THEMES = table.deep_merge(GAME.THEMES, OBS_RESOURCE_PACK_THEMES, 2)
  end

  if OB_CONFIG.game == "doom1" or OB_CONFIG.game == "ultdoom" then
    -- material definitions
    OBS_RESOURCE_PACK_EPIC_TEXTURES.table_insert(OBS_RESOURCE_PACK_MATERIALS,
      GAME.MATERIALS)
    OBS_RESOURCE_PACK_EPIC_TEXTURES.table_insert(OBS_RESOURCE_PACK_LIQUID_DEFS,
      GAME.LIQUIDS)

    -- put the custom theme definitions in the themes table!!!
    -- LIQUIDZ
    if PARAM.bool_custom_liquids == 1 then
      GAME.THEMES = table.deep_merge(GAME.THEMES, OBS_RESOURCE_PACK_DOOM1_LIQUIDS, 2)
    end

    GAME.THEMES = table.deep_merge(GAME.THEMES, OBS_RESOURCE_PACK_DOOM1_THEMES, 2)

    -- ROOM THEMES
    GAME.ROOM_THEMES = table.deep_merge(GAME.ROOM_THEMES,
      OBS_RESOURCE_PACK_DOOM1_ROOM_THEMES, 2)

    -- NATURALS
    OBS_RESOURCE_PACK_EPIC_TEXTURES.table_insert(
      GAME.ROOM_THEMES.tech_Outdoors.naturals,
      OBS_RESOURCE_PACK_DOOM1_TECH_NATURALS)
    OBS_RESOURCE_PACK_EPIC_TEXTURES.table_insert(
      GAME.ROOM_THEMES.deimos_Outdoors.naturals,
      OBS_RESOURCE_PACK_DOOM1_DEIMOS_NATURALS)
    OBS_RESOURCE_PACK_EPIC_TEXTURES.table_insert(
      GAME.ROOM_THEMES.hell_Outdoors.naturals,
      OBS_RESOURCE_PACK_DOOM1_HELL_NATURALS)
    OBS_RESOURCE_PACK_EPIC_TEXTURES.table_insert(
      GAME.ROOM_THEMES.flesh_Outdoors.naturals,
      OBS_RESOURCE_PACK_DOOM1_FLESH_NATURALS)

    -- SINKS
    GAME.SINKS = table.deep_merge(GAME.SINKS, OBS_RESOURCE_PACK_DOOM1_SINK_DEFS, 2)

    -- inserts for hallways
    GAME.THEMES.tech.wide_halls = OBS_RESOURCE_PACK_TECH_WIDE_HALLS
    GAME.THEMES.deimos.wide_halls = OBS_RESOURCE_PACK_TECH_WIDE_HALLS
    GAME.THEMES.hell.wide_halls = OBS_RESOURCE_PACK_HELL_WIDE_HALLS
    GAME.THEMES.flesh.wide_halls = OBS_RESOURCE_PACK_HELL_WIDE_HALLS
  end

  if PARAM.bool_include_generative_AI_textures == 1 then
    GAME.MATERIALS = table.deep_merge(GAME.MATERIALS, OBS_RESOURCE_PACK_GENAI_MATERIALS, 2)
    GAME.ROOM_THEMES = table.deep_merge(GAME.ROOM_THEMES, OBS_RESOURCE_PACK_GENAI_ROOM_THEMES, 2)
    GAME.THEMES = table.deep_merge(GAME.THEMES, OBS_RESOURCE_PACK_GENAI_THEMES, 2)
  end
end

function OBS_RESOURCE_PACK_EPIC_TEXTURES.put_the_texture_wad_in()
  local wad_file = "games/doom/data/ObAddon_Textures.wad"
  local wad_file_2 = "games/doom/data/ObAddon_Textures_2.wad"
  local wad_file_3 = "games/doom/data/ObAddon_Textures_3.wad"

  if PARAM.bool_include_package == 1 then
    SCRIPTS.animdefs = ScriptMan_combine_script(SCRIPTS.animdefs, OBS_RESOURCE_PACK_ANIMDEFS)

    gui.wad_transfer_lump(wad_file, "CREDITS", "CREDITS")
    gui.wad_merge_sections(wad_file)
    gui.wad_merge_sections(wad_file_2)
    gui.wad_merge_sections(wad_file_3)

    local dir = "games/doom/data/"
    gui.wad_add_binary_lump("HI_START",{})
    gui.wad_insert_file(dir .. "ARCD2.png", "ARCD2")
    gui.wad_insert_file(dir .. "ARCD3.png", "ARCD3")
    gui.wad_insert_file(dir .. "ARCD4.png", "ARCD4")
    gui.wad_insert_file(dir .. "ARCD5.png", "ARCD5")
    gui.wad_insert_file(dir .. "ARCD6.png", "ARCD6")
    gui.wad_insert_file(dir .. "ARCD7.png", "ARCD7")
    gui.wad_insert_file(dir .. "ARCD8.png", "ARCD8")
    gui.wad_insert_file(dir .. "ARCD9.png", "ARCD9")
    gui.wad_insert_file(dir .. "ARCD10.png", "ARCD10")
    gui.wad_insert_file(dir .. "ARCD11.png", "ARCD11")
    gui.wad_insert_file(dir .. "OBVNMCH1.png", "OBVNMCH1")
    gui.wad_insert_file(dir .. "OBVNMCH2.png", "OBVNMCH2")
    gui.wad_insert_file(dir .. "OBVNMCH3.png", "OBVNMCH3")
    gui.wad_insert_file(dir .. "OBVNMCH4.png", "OBVNMCH4")
    gui.wad_insert_file(dir .. "OBVNMCH5.png", "OBVNMCH5")
    gui.wad_insert_file(dir .. "CRATJOKE.png", "CRATJOKE")
    gui.wad_insert_file(dir .. "G7DODSLS.png", "G7DODSLS")
    gui.wad_insert_file(dir .. "ADVCR1.png", "ADVCR1")
    gui.wad_insert_file(dir .. "ADVCR2.png", "ADVCR2")
    gui.wad_insert_file(dir .. "ADVCR3.png", "ADVCR3")
    gui.wad_insert_file(dir .. "ADVCR4.png", "ADVCR4")
    gui.wad_insert_file(dir .. "ADVCR5.png", "ADVCR5")
    gui.wad_insert_file(dir .. "ADVDE1.png", "ADVDE1")
    gui.wad_insert_file(dir .. "ADVDE2.png", "ADVDE2")
    gui.wad_insert_file(dir .. "ADVDE3.png", "ADVDE3")
    gui.wad_insert_file(dir .. "ADVDE4.png", "ADVDE4")
    gui.wad_insert_file(dir .. "ADVDE5.png", "ADVDE5")
    gui.wad_insert_file(dir .. "ADVDE6.png", "ADVDE6")
    gui.wad_insert_file(dir .. "ADVDE7.png", "ADVDE7")
    gui.wad_insert_file(dir .. "TAG1.png", "TAG1")
    gui.wad_insert_file(dir .. "TAG2.png", "TAG2")
    gui.wad_insert_file(dir .. "TAG3.png", "TAG3")
    gui.wad_insert_file(dir .. "TAG4.png", "TAG4")
    gui.wad_insert_file(dir .. "TAG5.png", "TAG5")
    gui.wad_insert_file(dir .. "TAG6.png", "TAG6")
    gui.wad_insert_file(dir .. "TAG7.png", "TAG7")
    gui.wad_insert_file(dir .. "TAG8.png", "TAG8")
    gui.wad_insert_file(dir .. "TAG9.png", "TAG9")
    gui.wad_insert_file(dir .. "TAG10.png", "TAG10")
    gui.wad_insert_file(dir .. "TAG11.png", "TAG11")
    gui.wad_insert_file(dir .. "TAGS1.png", "TAGS1")
    gui.wad_insert_file(dir .. "TAGS2.png", "TAGS2")
    gui.wad_insert_file(dir .. "TAGS3.png", "TAGS3")
    gui.wad_insert_file(dir .. "TAGS4.png", "TAGS4")
    gui.wad_insert_file(dir .. "TAGCR1.png", "TAGCR1")
    gui.wad_insert_file(dir .. "TAGCR2.png", "TAGCR2")
    gui.wad_insert_file(dir .. "TAGCR3.png", "TAGCR3")
    gui.wad_insert_file(dir .. "TAGCR4.png", "TAGCR4")
    gui.wad_insert_file(dir .. "TAGCR5.png", "TAGCR5")
    gui.wad_insert_file(dir .. "TAGCR6.png", "TAGCR6")
    gui.wad_insert_file(dir .. "TAGCR7.png", "TAGCR7")
    gui.wad_insert_file(dir .. "TAGCR8.png", "TAGCR8")
    gui.wad_insert_file(dir .. "TAGCR9.png", "TAGCR9")
    gui.wad_insert_file(dir .. "TAGCR10.png", "TAGCR10")
    gui.wad_insert_file(dir .. "TAGCR11.png", "TAGCR11")
    gui.wad_insert_file(dir .. "TAGCR12.png", "TAGCR12")
    gui.wad_insert_file(dir .. "TAGCR13.png", "TAGCR13")
    gui.wad_insert_file(dir .. "TAGCR14.png", "TAGCR14")
    gui.wad_insert_file(dir .. "TAGCR15.png", "TAGCR15")
    gui.wad_insert_file(dir .. "TAGCR16.png", "TAGCR16")
    gui.wad_insert_file(dir .. "NAHIDA.png", "NAHIDA")
    gui.wad_add_binary_lump("HI_END",{})
  end

  if PARAM.custom_trees ~= "no" then
    wad_file = "modules/zdoom_internal_scripts/ObAddon_trees.wad"
    gui.wad_merge_sections(wad_file)
  end

  if PARAM.bool_include_brightmaps == 1 then
    wad_file = "games/doom/data/ObAddon_Textures_Brightmaps.wad"
    gui.wad_merge_sections(wad_file)
  end

  if PARAM.bool_include_custom_actors == 1 then
    SCRIPTS.decorate = ScriptMan_combine_script(SCRIPTS.decorate, ORP_ENTITIES.DECORATE)
    wad_file = "games/doom/data/blood_pack.wad"
    gui.wad_merge_sections(wad_file)
    wad_file = "games/doom/data/burning_top.wad"
    gui.wad_merge_sections(wad_file)
    wad_file = "games/doom/data/burning_debris.wad"
    gui.wad_merge_sections(wad_file)
    SCRIPTS.gldefs = ScriptMan_combine_script(SCRIPTS.gldefs, ORP_ENTITIES.GLDEFS)
  end
end
----------------------------------------------------------------

OB_MODULES["armaetus_epic_textures"] =
{

  name = "armaetus_epic_textures",

  label = _("Obsidian Epic Resource Pack"), --Shortened name to prevent some text overrun issues in Dual Pane mode (Dasho)

  where = "other",
  priority = 75,

  port = "zdoom",

  game = "doomish",

  hooks =
  {
    setup = OBS_RESOURCE_PACK_EPIC_TEXTURES.setup,
    get_levels_after_themes = OBS_RESOURCE_PACK_EPIC_TEXTURES.get_levels_after_themes,
    begin_level = OBS_RESOURCE_PACK_EPIC_TEXTURES.generate_environment_themes,
    level_layout_finished = OBS_RESOURCE_PACK_EPIC_TEXTURES.create_environment_themes,
    all_done = OBS_RESOURCE_PACK_EPIC_TEXTURES.put_the_texture_wad_in
  },

  tooltip = _("If enabled, adds textures and content from the Obsidian Epic Resource Pack, which also includes new exclusive prefabs."),

  options =
  {

    {
      name = "bool_custom_liquids",
      label = _("Custom Liquids"),
      valuator = "button",
      default = 1,
      tooltip = _("Utilize custom liquid flats or not."),
      priority=4
    },


    {
      name = "custom_trees",
      label = _("Custom Trees"),
      choices = OBS_RESOURCE_PACK_EPIC_TEXTURES.SOUCEPORT_CHOICES,
      default = "zs",
      tooltip = _("Adds custom flat-depedendent tree sprites into the game. Currently only replaces trees on specific grass flats and will be expanded in the future to accomnodate custom Textures and more. If you are playing a mod that already does its own trees, it may be better to leave this off."),
      priority=3
    },


    {
      name = "environment_themes",
      label = _("Environment Theme"),
      choices = OBS_RESOURCE_PACK_EPIC_TEXTURES.ENVIRONMENT_THEME_CHOICES,
      default = "random",
      tooltip = _("Influences outdoor environments with different textures such as desert sand or icey snow."),
      priority=2,
    },


    {
      name = "bool_include_package",
      label = _("Merge Textures WAD"),
      valuator = "button",
      default = 1,
      tooltip = _("Allows the trimming down of resulting WAD by not merging the custom texture WAD.\n\nThis will require you to extract and load up the WAD manually in your preferred sourceport installation.\n\nThis is the preferrable option for multiplayer situations and server owners and have each client obtain a copy of the texture pack instead.\n"),
      priority=1


    },
    {
      name = "bool_include_generative_AI_textures",
      label = _("AI Textures"),
      valuator = "button",
      default = 1,
      tooltip = _("Whether to include textures fully or partially created through generative AI software."),
      priority = 0,
      gap = 1,
    },


    {
      name = "bool_include_brightmaps",
      label = _("Include Brightmaps"),
      valuator = "button",
      default = 1,
      tooltip = _("Allows merging Obsidian Textures brightmaps into the WAD. Does not include brightmaps for base resources from any of the games."),
      priority = -1
    },


    {
      name = "bool_include_custom_actors",
      label = _("Custom Actors"),
      valuator = "button",
      default = 1,
      tooltip = _("Merges some custom sprites and replacers for various decorations."),
      priority = -2
    },
  

    {
      name = "bool_no_env_theme_for_hell",
      label = _("No Hell Environment Themes"),
      valuator = "button",
      default = 0,
      tooltip = _("Renders hell theme maps to never use snow or desert environment themes regardless of theme assignment."),
      priority= -3,
      gap = 1
    },

    {
      name = "bool_orp_room_theme_synthesizer",
      label = _("Room Theme Synthesizer [Experimental]"),
      valuator = "button",
      default = 1,
      priority = -4,
      tooltip = _("Creates synthetic room themes by combining walls and flats from existing entries.")
    },
    {
      name = "float_orp_room_theme_synth_mult",
      label = _("Synth Room Theme Multiplier"),
      valuator = "slider",
      units="x",
      min=0,
      max=20,
      increment = 0.1,
      default = 1,
      tooltip = _("Multiplier for all synthesized Resource Pack room themes."),
      priority = -5,
    }
  }
}
