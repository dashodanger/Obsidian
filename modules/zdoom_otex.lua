------------------------------------------------------------------------
--  MODULE: OTEX Theme Generator
------------------------------------------------------------------------
--
--  Copyright (C) 2024-2024 MsrSgtShooterPerson
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
gui.import("zdoom_otex_db.lua")


OTEX_PROC_MODULE = { }

OTEX_MATERIALS = { }
OTEX_ROOM_THEMES = { }

OTEX_EXCLUSIONS = 
{
  -- animated textures
  WRNG = "textures",
  CHAN = "all",
  COMP = "all",

  -- textures with transparency
  EXIT = "all",
  FENC = "all",
  SWTC = "all",
  WARP = "all",
  VINE = "all",
  SOLI = "all",
  DOOR = "all",
  GATE = "all",
  FLAG = "all",
  RAIL = "all",
  LASR = "all",

  -- VFX
  FIRE = "all",

  -- liquids
  FALL = "all",
  BLOD = "all",
  GOOP = "all",
  LAVA = "all",
  ICYW = "all",
  NUKE = "all",
  SLUD = "all",
  TAR_ = "all",
  WATE = "all",
  POOP = "all", -- I am sad this has to be excluded... for now.

  -- skies
  SKY0 = "all",
  SKY1 = "all",
  SKY2 = "all",
  SKY3 = "all",
  SKY4 = "all",
  SKY5 = "all",
  SKY6 = "all",

  -- teleporter flats
  TLPT = "all",

  LGHT = "all",

  -- outdoors
  GRSS = "all",
  ICE_ = "all",

  -- just plain weird
  CRPT = "textures",
  TRAK = "all",
  KEYS = "all",
  EFCT = "all",

  -- too colorful
  TECH = "textures",
  FADE = "all"
}

-- some textures that must be removed manually from the DB
OTEX_DIRECT_REMOVALS =
{
  MRBL =
  {
    textures =
    {
      "OMRBLA90",
      "OMRBLA91",
      "OMBRLA92",
      "OMBRLA93",
      "OMBRLA94",
  
      "OMBRLC90",
  
      "OMBRLF29",
      "OMBRLF38",
      "OMBRLF90",
  
      "OMBRLG90",
  
      "OMRBLI92",
      "OMRBLI93",
  
      "OMRBLJ90",
      "OMRBLJ93",
  
      "OMRBLK90",
  
      "OMRBLO28",
      "OMRBLO29",
  
      "OMBRLP90",
      "OMBRLP91",
  
      "OMBRLR90",
      "OMBRLR94"  
    }
  },

  BRCK =
  {
    textures =
    {
      "OBRCKB10",
      "OBRCKB11",
      "OBRCKB12",
      "OBRCKB13",
      "OBRCKB20",
      "OBRCKB21",
      "OBRCKB22",
      "OBRCKB23",

      "OBRCKF11",
      "OBRCKF12",
      "OBRCKF13",
      "OBRCKF14",
      "OBRCKF21",
      "OBRCKF22",
      "OBRCKF23",
      "OBRCKF24",

      "OBRCKL10",
      "OBRCKL11",
      "OBRCKL21",

      "OBRCKU03",
      "OBRCKU04",
      "OBRCKU05",
      "OBRCKU06",

      "OBRCKU13",
      "OBRCKU14",
      "OBRCKU15",
      "OBRCKU16",

      "OBRCKU23",
      "OBRCKU24",
      "OBRCKU25",
      "OBRCKU26",

      "OBRCKU3D",
      "OBRCKU3E",
      "OBRCKU3F",
      "OBRCKU3G",
      "OBRCKU3H",
      "OBRCKU3I",

      "OTUDRB80",
      "OTUDRB81"
    }
  },

  BKMT =
  {
    textures =
    {
      "OBKMTD90",
      "OBKMTD91",
      "OBKMTD92",
      "OBKMTD95",
      "OBKMTD96",
      "OBKMTD97"
    }
  },

  BOOK =
  {
    textures =
    {
      "OBOOKA01",
      "OBOOKA02",
      "OBOOKA05",
      "OBOOKA10",
      "OBOOKA11",
      "OBOOKA12"
    }
  },

  VENT =
  {
    textures =
    {
      "OVENTE01",
      "OVENTE02",
      "OVENTE03",
      "OVENTE04",
      "OVENTE13",
      "OVENTE14"
    }
  },

  METL =
  {
    textures =
    {
      "OMETLC96",
      "OMETLC97",
      "OMETLC98",
      "OMETLC99",

      "OMETLC92",
      "OMETLC93",
      "OMETLC94",
      "OMETLC95",

      "OMETLN37",
      "OMETLO37",
      "OEMTLP37",
      "ONDSTJ91",
      "ONDSTJ93",
      "ONDSTJ94"
    }
  },

  TUDR =
  {
    textures =
    {
      "OTUDRA80",
      "OTUDRA81",
      "OTUDRB80",
      "OTUDRB81"
    }
  }
}

OTEX_THEME_RESTRICTIONS =
{
  MRBL = {"tech"},
  BONE = {"tech", "urban"},
  FLSH = {"tech", "urban"},
  HELL = {"tech", "urban"},
  SKIN = {"tech"},
  CMBD = {"tech"},

  FNCY = {"tech"},
  PALC = {"tech"},
  STCC = {"tech"},

  BRCK = {"tech"},
  BOOK = {"tech"},
  WOOD = {"tech"},
  TUDR = {"tech"},
 
  STON = {"tech"},
  SOIL = {"tech"},
  ROCK = {"tech", "urban"},
  SAND = {"tech", "urban"},
  DIRT = {"tech", "urban"}
}

OTEX_SPECIAL_RESOURCES =
{
  rail_materials =
  {
    OFENCA01 = {t="OFENCA01", rail_h=128},
    OFENCA02 = {t="OFENCA02", rail_h=128},
    OFENCB01 = {t="OFENCB01", rail_h=56},
    OFENCB02 = {t="OFENCB02", rail_h=64},
    OFENCC01 = {t="OFENCC01", rail_h=128},
    OFENCC64 = {t="OFENCC64", rail_h=64},
    OFENCC96 = {t="OFENCC96", rail_h=96},
    OFENCD01 = {t="OFENCD01", rail_h=128},
    OFENCE01 = {t="OFENCE01", rail_h=128},

    OFENCF01 = {t="OFENCF01", rail_h=128},
    OFENCF02 = {t="OFENCF02", rail_h=64},
    OFENCF03 = {t="OFENCF03", rail_h=128},
    OFENCF04 = {t="OFENCF04", rail_h=64},
    OFENCF05 = {t="OFENCF05", rail_h=128},
    OFENCF06 = {t="OFENCF06", rail_h=96},
    OFENCF07 = {t="OFENCF07", rail_h=32},
    OFENCF08 = {t="OFENCF08", rail_h=32},
    OFENCF09 = {t="OFENCF09", rail_h=128},
    OFENCF10 = {t="OFENCF10", rail_h=96},
    OFENCF11 = {t="OFENCF11", rail_h=64},
    OFENCF12 = {t="OFENCF12", rail_h=32},
    OFENCF13 = {t="OFENCF13", rail_h=64},
    OFENCF14 = {t="OFENCF14", rail_h=64},

    OFENCF20 = {t="OFENCF20", rail_h=128},
    OFENCF21 = {t="OFENCF21", rail_h=64},

    OFENCG01 = {t="OFENCG01", rail_h=128},
    OFENCG02 = {t="OFENCG02", rail_h=64},
    OFENCH01 = {t="OFENCH01", rail_h=96},
    OFENCH02 = {t="OFENCH02", rail_h=96},
  
    OFENCJ11 = {t="OFENCJ11", rail_h=128},

    OFENCK01 = {t="OFENCK01", rail_h=128},
    OFENCL01 = {t="OFENCL01", rail_h=128},
    OFENCL02 = {t="OFENCL02", rail_h=128},
    OFENCM01 = {t="OFENCM01", rail_h=128},
    OFENCM02 = {t="OFENCM02", rail_h=64},
    OFENCM11 = {t="OFENCM11", rail_h=128},
    OFENCM12 = {t="OFENCM12", rail_h=128},

    OFENCN01 = {t="OFENCN01", rail_h=128},
    OFENCN02 = {t="OFENCN02", rail_h=128},
    OFENCN11 = {t="OFENCN11", rail_h=128},
    OFENCN12 = {t="OFENCN12", rail_h=128},

    ORAILA01 = {t="ORAILA01", rail_h=32},
    ORAILA02 = {t="ORAILA02", rail_h=32},
    ORAILA03 = {t="ORAILA03", rail_h=32},
    ORAILB01 = {t="ORAILB01", rail_h=32},

    OBKMTA92 = {t="OBKMTA92", rail_h=128},
    OBKMTA93 = {t="OBKMTA93", rail_h=128},
    OBKMTA94 = {t="OBKMTA94", rail_h=128},
    OBKMTA97 = {t="OBKMTA97", rail_h=64},

    OBKMTD32 = {t="OBKMTD32", rail_h=128},
    OBKMTD33 = {t="OBKMTD33", rail_h=128},
    OBKMTD37 = {t="OBKMTD37", rail_h=64},
    OBKMTD38 = {t="OBKMTD38", rail_h=64},
    OBKMTD39 = {t="OBKMTD39", rail_h=64}
  },

  rail_scenic_fences =
  {
    tech =
    {
      OFENCA01 = 20,
      OFENCA02 = 20,

      OFENCC01 = 20,
      OFENCC64 = 20,
      OFENCC96 = 20,
      OFENCD01 = 20,
      OFENCE01 = 20,
      OFENCF01 = 20,
      OFENCF02 = 20,
      OFENCF03 = 20,
      OFENCF04 = 20,
      OFENCF05 = 20,
      OFENCF06 = 20,
      OFENCF07 = 20,
      OFENCF08 = 20,
      OFENCF09 = 20,
      OFENCF10 = 20,
      OFENCF11 = 20,
      OFENCF12 = 20,
      OFENCF13 = 20,
      OFENCF14 = 20,

      OFENCJ11 = 25,
      OFENCL01 = 25,
      OFENCL02 = 25,
      OFENCM11 = 25,
      OFENCN01 = 25,
      OFENCN02 = 25,
      OFENCN11 = 25,
      OFENCN12 = 25,

      ORAILA01 = 35,
      ORAILA02 = 35,
      ORAILA03 = 35
    },

    gothic =
    {
      OFENCB01 = 30,
      OFENCB02 = 30,
      OFENCG01 = 30,
      OFENCG02 = 30,
      OFENCH01 = 15,
      OFENCH02 = 15,
      OFENCK01 = 30,
      OFENCM01 = 30,
      OFENCM02 = 30,
      OFENCM11 = 30,
      OFENCM12 = 30,

      OBKMTD32 = 30,
      OBKMTD33 = 30,
      OBKMTD37 = 30,
      OBKMTD38 = 30,
      OBKMTD39 = 30
    }
  },

  liquid_materials =
  {
    OBLODA01 = { t="OFALLB01", f="0BLODA01"},
    OGOOPY01 = { t="OFALLG01", f="0POOPY01"},
    OICYWA01 = { t="OFALLW11", f="0ICYWA01"},

    OLAVAA01 = { t="OFALLL01", f="0LAVAA01"},
    OLAVAA02 = { t="OFALLM01", f="0LAVAA02"},
    OLAVAB01 = { t="OFALLL01", f="0LAVAB01"},
    OLAVAC01 = { t="OFALLL01", f="0LAVAC01"},
    OLAVAD01 = { t="OFALLM01", f="0LAVAD01"},
    OLAVAE01 = { t="OFALLL11", f="0LAVAE01"},
    OLAVAF01 = { t="OFALLL11", f="0LAVAF01"},

    ONUKEA01 = { t="OFALLN01", f="0NUKEA01"},
    OSLUDG01 = { t="OFALLS01", f="0SLUDG01"},
    OPOOPY01 = { t="OFALLP01", f="0POOPY01"},
    OTAR__01 = { t="OFALLT01", f="0TAR__01"},
    OWATER01 = { t="OFALLW01", f="0WATER01"}
  },

  liquid_defs =
  {
    otex_blood = { mat="OBLODA01", special=0},
    otex_goop = { mat="OGOOPY01", special=0},
    otex_ice = { mat="OICYWA01", special=0},
   
    otex_lavaA1 = { mat="OLAVAA01", light_add=24, special=5, damage=10},
    otex_lavaA2 = { mat="OLAVAA02", light_add=24, special=5, damage=10},
    otex_lavaB1 = { mat="OLAVAB01", light_add=24, special=5, damage=10},
    otex_lavaC1 = { mat="OLAVAC01", light_add=24, special=5, damage=10},
    otex_lavaD1 = { mat="OLAVAD01", light_add=24, special=5, damage=10},
    otex_lavaE1 = { mat="OLAVAE01", light_add=24, special=5, damage=10},
    otex_lavaF1 = { mat="OLAVAF01", light_add=24, special=5, damage=10},
  
    otex_nukage = { mat="ONUKEA01", light_add=16, special=7, damage=5},
   
    otex_sludge = { mat="OSLUDG01", special=0},
    otex_poop = { mat="OPOOPY01", special=0},
    otex_tar = { mat="OTAR__01", special=0},
    otex_water = { mat="OWATER01", special=0}
  },

  liquid_themes =
  {
    tech =
    {
      otex_goop = 10,
      otex_ice = 20,

      otex_lavaA1 = 3,
      otex_lavaA2 = 3,
      otex_lavaB1 = 3,
      otex_lavaC1 = 3,
      otex_lavaD1 = 3,
      otex_lavaE1 = 3,
      otex_lavaF1 = 3,

      otex_nukage = 50,
      otex_sludge = 30,
      otex_poop = 10,
      otex_tar = 40,
      otex_water = 20
    },

    urban =
    {
      otex_blood = 20,
      otex_goop = 10,
      otex_ice = 20,

      otex_lavaA1 = 2,
      otex_lavaA2 = 2,
      otex_lavaB1 = 2,
      otex_lavaC1 = 2,
      otex_lavaD1 = 2,
      otex_lavaE1 = 2,
      otex_lavaF1 = 2,

      otex_nukage = 10,
      otex_sludge = 20,
      otex_poop = 50,
      otex_tar = 40,
      otex_water = 20
    },

    hell =
    {
      otex_blood = 70,
      otex_goop = 10,
      otex_ice = 20,

      otex_lavaA1 = 12,
      otex_lavaA2 = 12,
      otex_lavaB1 = 12,
      otex_lavaC1 = 12,
      otex_lavaD1 = 12,
      otex_lavaE1 = 12,
      otex_lavaF1 = 12,

      otex_sludge = 30,
      otex_tar = 40,
      otex_poop = 40
    }
  }
}

OTEX_GLOWING_FLATS =
[[
OBLODA01
    OGOOPY01
    OICYWA01
    OLAVAA01
    OLAVAA02
    OLAVAB01
    OLAVAC01
    OLAVAD01
    OLAVAE01
    OLAVAF01
    ONUKEA01
    OSLUDG01
    OPOOPY01
    OTAR__01
    OWATER01
]]

function OTEX_PROC_MODULE.setup(self)
  PARAM.OTEX_module_activated = true
  module_param_up(self)
  OTEX_PROC_MODULE.synthesize_procedural_themes()
end


function OTEX_PROC_MODULE.synthesize_procedural_themes()
  local resource_tab = {}

  local function pick_unique_texture(table, tex_group, total_tries)
    local tex
    local tries = 0

    tex = rand.pick(tex_group)
    while not table[tex] and tries < (total_tries or 5) do
      tex = rand.pick(tex_group)
      tries = tries + 1
    end

    return tex
  end

  local function check_elem(t, v)
    for _,val in pairs(t) do
      if val == v then 
        return true
      end
    end
    return false
  end

  resource_tab = table.copy(OTEX_RESOURCE_DB)
  table.name_up(resource_tab)

  -- create pick list
  local validity_list = {}
  local group_pick_list = {
    tech = {textures = {}, flats = {}},
    urban = {textures = {}, flats = {}},
    hell = {textures = {}, flats = {}},
    any = {textures = {}, flats = {}}
  }
  local av_themes = {"hell","urban","tech","any"}

  for group,_ in pairs(resource_tab) do
    for _,theme in pairs(av_themes) do

      -- do textures
      if OTEX_EXCLUSIONS[group] and OTEX_EXCLUSIONS[group] == "all" then
        -- do nothing
      else
        if OTEX_THEME_RESTRICTIONS then
          if OTEX_THEME_RESTRICTIONS[group] 
          and check_elem(OTEX_THEME_RESTRICTIONS[group], theme) then
            -- do nothing
          else
            if resource_tab[group].has_textures == true 
            and not OTEX_EXCLUSIONS[group] then
              local prob = table.size(resource_tab[group].textures)
              group_pick_list[theme].textures[group] = prob
            end

            if resource_tab[group].has_flats == true
            and not OTEX_EXCLUSIONS[group] then
              local prob = table.size(resource_tab[group].flats)
              group_pick_list[theme].flats[group] = prob
            end          
          end
        else
          if resource_tab[group].has_textures == true 
          and not OTEX_EXCLUSIONS[group] then
            local prob = table.size(resource_tab[group].textures)
            group_pick_list[theme].textures[group] = prob
          end

          if resource_tab[group].has_flats == true
          and not OTEX_EXCLUSIONS[group] then
            local prob = table.size(resource_tab[group].flats)
            group_pick_list[theme].flats[group] = prob
          end          
      end

      end
  
    end
  end

  -- special handling for DMD floors
  local generic_floors_list = {}
  for G,_ in pairs(resource_tab) do
    if string.find(G, "DMD") then
      for _,T in pairs(resource_tab[G].flats) do
        local prob = table.size(resource_tab[G].flats)
        generic_floors_list[T] = prob
      end
    end
  end

  -- direct removals
  for theme_group,_ in pairs(OTEX_DIRECT_REMOVALS) do
    for img_group,_ in pairs(OTEX_DIRECT_REMOVALS[theme_group]) do
      for _,tex in pairs(OTEX_DIRECT_REMOVALS[theme_group][img_group]) do
        table.kill_elem(resource_tab[theme_group][img_group], tex)
      end
    end
  end

  -- create material mappings
  for group_name,resource_group in pairs(resource_tab) do
    if resource_group.has_all then
      for _,T in pairs(resource_group.textures) do
        OTEX_MATERIALS[T]=
        {
          t=T,
          f=rand.pick(resource_group.flats)
        }
      end
      for _,F in pairs(resource_group.flats) do
        OTEX_MATERIALS[F]=
        {
          f=F,
          t=rand.pick(resource_group.textures)
        }
      end
    end

    if resource_group.has_textures and
    not resource_group.has_flats then
      for _,T in pairs(resource_group.textures) do
        OTEX_MATERIALS[T]=
        {
          t=T,
          f="CEIL5_2"
        }
      end
    end

    if resource_group.has_flats and
    not resource_group.has_textures then
      for _,F in pairs(resource_group.flats) do
        local side_tex, group_pick
        -- hack fix to assign DMD flats a side texture rather than just a default
        if not OTEX_MATERIALS[F] then
          group_pick = rand.key_by_probs(group_pick_list["urban"].textures)
          side_tex = rand.pick(resource_tab[group_pick].textures)
        end
        OTEX_MATERIALS[F] =
        {
          f=F,
          t=side_tex
        }
      end
    end
  end
 
  -- resource_tab exclusions
  for k,v in pairs(OTEX_EXCLUSIONS) do
    if v == "textures" then
      resource_tab[k].textures = {}
      resource_tab[k].has_textures = false
      resource_tab[k].has_all = false
    elseif v == "flats" then
      resource_tab[k].flats = {}
      resource_tab[k].has_flats = false
      resource_tab[k].has_all = false
    else
      resource_tab[k] = {}
      resource_tab[k] = nil
    end
  end

  -- try to create a consistent theme
  local themes =
  {
    "tech","hell","urban"
  }
  for i = 1, PARAM.float_otex_num_themes * 0.75 do
    for _,T in pairs(themes) do
      local grouping, room_theme = {}
      local tab_pick, tex_pick, RT_name

      RT_name = T .. "_OTEX_cons_" .. i .. "_"
      room_theme =
      {
        env = "building",
        prob = rand.pick({40,50,60}) * PARAM.float_otex_rt_prob_mult,
        name = RT_name
      }
      room_theme.walls = {}
      room_theme.floors = {}
      room_theme.ceilings = {}

      tab_pick = rand.key_by_probs(group_pick_list[T].textures)
      for j = 1, 3 do
        tex_pick = rand.pick(resource_tab[tab_pick].textures)
        room_theme.walls[tex_pick] = 5
      end
      RT_name = RT_name .. tex_pick .. "_"

      if rand.odds(25) or resource_tab[tab_pick].has_flats == false then
        tab_pick = rand.key_by_probs(group_pick_list[T].flats)
      end
      for j = 1, 3 do
        tex_pick = rand.pick(resource_tab[tab_pick].flats)
        room_theme.floors[tex_pick] = 5
      end
      RT_name = RT_name .. tex_pick .. "_"

      if rand.odds(25) or resource_tab[tab_pick].has_flats == false then
        tab_pick = rand.key_by_probs(group_pick_list[T].flats)
      end
      for j = 1, 3 do
        tex_pick = rand.pick(resource_tab[tab_pick].flats)
        room_theme.ceilings[tex_pick] = 5
      end
      RT_name = RT_name .. tex_pick

      room_theme.name = RT_name
      OTEX_ROOM_THEMES[RT_name] = room_theme
    end
  end

  -- try a completely random theme
  for i = 1, PARAM.float_otex_num_themes * 0.25 do
    local RT_name = "any_OTEX_random_" .. i .. "_"
    local room_theme, tab_pick = {}
    local tex_pick

    room_theme =
    {
      env = "building",
      prob = rand.pick({40,50,60}),
    }
    room_theme.walls = {}
    room_theme.floors = {}
    room_theme.ceilings = {}

    tab_pick = rand.key_by_probs(group_pick_list["any"].textures)
    tex_pick = rand.pick(resource_tab[tab_pick].textures)
    room_theme.walls[tex_pick] = 5
    RT_name = RT_name .. tex_pick .. "_"

    tab_pick = rand.key_by_probs(group_pick_list["any"].flats)
    tex_pick = rand.pick(resource_tab[tab_pick].flats)
    room_theme.floors[tex_pick] = 5
    RT_name = RT_name .. tex_pick .. "_"

    tab_pick = rand.key_by_probs(group_pick_list["any"].flats)
    tex_pick = rand.pick(resource_tab[tab_pick].flats)
    room_theme.ceilings[tex_pick] = 5
    RT_name = RT_name .. tex_pick

    room_theme.name = RT_name
    OTEX_ROOM_THEMES[RT_name] = room_theme
  end

  -- insert into outdoor facades
  for theme,table_group in pairs(GAME.THEMES) do
    local tab_pick, tex_pick, pick_num = 0

    if GAME.THEMES[theme].facades then
      for i = 1, 50 do
        local pick_num
        pick_num = 0
        tex_pick = "none"

        tab_pick = rand.key_by_probs(group_pick_list[theme].textures)
        while not GAME.THEMES[theme].facades[tex_pick] and pick_num < 5 do
          tex_pick = rand.pick(resource_tab[tab_pick].textures)
          GAME.THEMES[theme].facades[tex_pick] = rand.pick({15,20,25,30})
          pick_num = pick_num + 1
        end
      end
    end

  end

  -- create scenic fences
  local rail_tab = table.copy(OTEX_SPECIAL_RESOURCES.rail_materials)
  for rail_mat,_ in pairs(rail_tab) do
    GAME.MATERIALS[rail_mat]={t=_.t, rail_h=_.rail_h}
  end
  local scenic_fence_tab = table.copy(OTEX_SPECIAL_RESOURCES.rail_scenic_fences)
  for fence,prob in pairs(scenic_fence_tab.tech) do
    GAME.THEMES.tech.scenic_fences[fence] = math.floor(prob * 0.75)
    GAME.THEMES.urban.scenic_fences[fence] = math.floor(prob * 0.75)
  end
  for fence,prob in pairs(scenic_fence_tab.gothic) do
    GAME.THEMES.hell.scenic_fences[fence] = math.floor(prob * 0.75)
    GAME.THEMES.urban.scenic_fences[fence] = math.floor(prob * 0.75)
  end

  -- create liquid attachments
  local liquid_tab = table.copy(OTEX_SPECIAL_RESOURCES.liquid_materials)
  for liquid_mat,_ in pairs(liquid_tab) do
    GAME.MATERIALS[liquid_mat]={t=_.t, f=_.f}
  end
  local liquid_defs = table.copy(OTEX_SPECIAL_RESOURCES.liquid_defs)
  for liquid,_ in pairs(liquid_defs) do
    GAME.LIQUIDS[liquid]=liquid_defs[liquid]
  end
  local liquid_themes = table.copy(OTEX_SPECIAL_RESOURCES.liquid_themes)
  for theme,l_tab in pairs(liquid_themes) do
    for liquid,prob in pairs(l_tab) do
      GAME.THEMES[theme].liquids[liquid] = prob
    end
  end
end


function OTEX_PROC_MODULE.get_levels_after_themes()
  table.deep_merge(GAME.MATERIALS, OTEX_MATERIALS, 2)
  table.deep_merge(GAME.ROOM_THEMES, OTEX_ROOM_THEMES, 2)
end


function OTEX_PROC_MODULE.all_done()
  GAME.RESOURCES.GLOWING_FLATS_GLDEFS = string.gsub(
    GAME.RESOURCES.GLOWING_FLATS_GLDEFS,
    "GLOWFLTS",
    OTEX_GLOWING_FLATS
  )
end

----------------------------------------------------------------

OB_MODULES["otex_proc_module"] =
{

  name = "otex_proc_module",

  label = _("OTEX Resource Pack [PRE-ALPHA]"),

  where = "other",
  priority = 75,

  port = "zdoom",

  game = "doomish",

  hooks =
  {
    setup = OTEX_PROC_MODULE.setup,
    get_levels_after_themes = OTEX_PROC_MODULE.get_levels_after_themes,
    all_done = OTEX_PROC_MODULE.all_done
  },

  tooltip = _("If enabled, generates room themes using OTEX based on a resource table. ".. 
  "OTEX WAD (not pk3 version) must be manually loaded in the sourceport. " ..
  "Includes textures and flats only, no patches.\n\n" ..
  "Currently does not make any kind of sensibly curated room themes."),

  options =
  {
    {
      name="float_otex_num_themes",
      label=_("Room Themes Count"),
      valuator = "slider",
      min = 2,
      max = 40,
      increment = 2,
      default = 8,
      tooltip = _("How many OTEX room themes to synthesize."),
      longtip = _("Not all room themes may show up in levels as appearance " ..
      "is reliant on use probability. Use multipler below to increase " ..
      "or decrease further"),
      priority = 2
    },
    {
      name="float_otex_rt_prob_mult",
      label=_("Probability Multiplier"),
      valuator="slider",
      units="x",
      min = 0,
      max = 20,
      increment = 0.1,
      default = 1,
      tooltip = _("Multiplier for all synthesized OTEX room themes."),
      priority = 1
    }
  }
}
