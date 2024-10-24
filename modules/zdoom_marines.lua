----------------------------------------------------------------
--  MODULE: ZDoom Marines
----------------------------------------------------------------
--
--  Copyright (C) 2009 Enhas
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
----------------------------------------------------------------

ZDOOM_MARINE = { }

ZDOOM_MARINE.MONSTERS =
{
  -- None of these drop anything.

  -- The damage values below are not accurate,
  -- to keep too much health from spawning in the map.  May need more tweaking.

  -- Marines of all types (well, except the fist) are extremely dangerous,
  -- hence the low probabilities, low densities and nasty flag.
  -- We want them all to be rare.

  marine_fist =
  {
    id = 9101,
    r = 16,
    h = 56,
    prob = 1,
    health = 100,
    damage = 4,
    attack = "melee",
    nasty = true,
    density = 0.2,
  },

  marine_berserk =
  {
    id = 9102,
    r = 16,
    h = 56,
    prob = 6,
    health = 100,
    damage = 40,
    attack = "melee",
    nasty = true,
    density = 0.2,
  },

  marine_saw =
  {
    id = 9103,
    r = 16,
    h = 56,
    prob = 4,
    health = 100,
    damage = 15,
    attack = "melee",
    nasty = true,
    density = 0.2,
  },

  marine_pistol =
  {
    id = 9104,
    r = 16,
    h = 56,
    prob = 12,
    health = 100,
    damage = 8,
    attack = "hitscan",
    nasty = true,
    density = 0.5,
  },

  marine_shotty =
  {
    id = 9105,
    r = 16,
    h = 56,
    prob = 4,
    health = 100,
    damage = 10,
    attack = "hitscan",
    nasty = true,
    density = 0.4,
  },

  marine_ssg =
  {
    id = 9106,
    r = 16,
    h = 56,
    prob = 6,
    health = 100,
    damage = 65,
    attack = "hitscan",
    nasty = true,
    density = 0.3,
  },

  marine_chain =
  {
    id = 9107,
    r = 16,
    h = 56,
    prob = 6,
    health = 100,
    damage = 50,
    attack = "hitscan",
    nasty = true,
    density = 0.3,
  },

  marine_rocket =
  {
    id = 9108,
    r = 16,
    h = 56,
    prob = 4,
    crazy_prob = 10,
    health = 100,
    damage = 100,
    attack = "missile",
    nasty = true,
    density = 0.2,
  },

  marine_plasma =
  {
    id = 9109,
    r = 16,
    h = 56,
    prob = 4,
    crazy_prob = 6,
    health = 100,
    damage = 70,
    attack = "missile",
    nasty = true,
    density = 0.2,
  },

  marine_rail =
  {
    id = 9110,
    r = 16,
    h = 56,
    prob = 2,
    health = 100,
    damage = 100,
    attack = "hitscan",
    nasty = true,
    density = 0.1,
  },

  marine_bfg =
  {
    id = 9111,
    r = 16,
    h = 56,
    prob = 2,
    health = 100,
    damage = 100,
    attack = "missile",
    nasty = true,
    density = 0.1,
  },
}


ZDOOM_MARINE.CHOICES =
{
  "plenty", _("Plenty"),
  "scarce", _("Scarce"),
  "heaps",  _("Heaps"),
}

ZDOOM_MARINE.FACTORS =
{
  scarce = 0.4,
  plenty = 1.0,
  heaps  = 2.5,
}


function ZDOOM_MARINE.setup(self)

  module_param_up(self)

  local factor = ZDOOM_MARINE.FACTORS[PARAM["zdoom_marine_qty"]]

  for name,_ in pairs(ZDOOM_MARINE.MONSTERS) do
    local M = GAME.MONSTERS[name]

    if M and factor then
      M.prob = M.prob * factor
      M.crazy_prob = (M.crazy_prob or M.prob) * factor
    end
  end

  if not ob_match_game({game = {doom2=1, tnt=1, plutonia=1}}) then
    GAME.MONSTERS["marine_ssg"] = nil
  end

end


-- Monster / Weapon prefs may go here eventually

OB_MODULES["zdoom_marines"] =
{
  name = "zdoom_marines",

  label = _("Hostile Marines"),

  game = "doomish",

  port = "zdoom",

  where = "combat",

  tables =
  {
    ZDOOM_MARINE
  },

  tooltip = _("WARNING! ZDoom Marines are hostile by default unless their behavior is altered by another mod!"),

  hooks =
  {
    setup = ZDOOM_MARINE.setup
  },

  options =
  {
    {
      name = "zdoom_marine_qty",
      label = _("Default Quantity"),
      choices = ZDOOM_MARINE.CHOICES,
      randomize_group = "monsters",
      tooltip = _("Control the appearance of hostile ZDoom Marines.") 
    },
  },
}


----------------------------------------------------------------

function ZDOOM_MARINE.control_setup(self)

  module_param_up(self)

  for _,opt in pairs(self.options) do

    local M = GAME.MONSTERS[string.sub(opt.name, 7)]

    if M and PARAM[opt.name] ~= gui.gettext("Default") then
      M.prob    = PARAM[opt.name] * 100
      M.density = M.prob * .006 + .1

      -- allow Spectres to be controlled individually
      M.replaces = nil

      -- loosen some of the normal restrictions
      M.skip_prob = nil
      M.crazy_prob = nil

      if M.prob > 40 then
        M.level = 1
        M.weap_min_damage = nil
      end

      if M.prob > 200 then
        M.boss_type = nil
      end
    end
  end

end


OB_MODULES["zdoom_marine_control"] =
{
  name = "zdoom_marine_control",

  label = _("Hostile Marines Fine Tuning"),

  game = "doomish",

  port = "zdoom",

  where = "combat",

  tables =
  {
    ZDOOM_MARINE
  },

  hooks =
  {
    setup = ZDOOM_MARINE.control_setup
  },

  options =
  {
    {
      name = "float_marine_fist",
      label = _("Fist Marine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the number of Fist-wielding ZDoom Marines."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
    },

    {
      name = "float_marine_berserk",
      label = _("Berserk Marine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the number of Berserked ZDoom Marines."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
    },

    {
      name = "float_marine_saw",
      label = _("Chainsaw Marine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the number of Chainsaw-wielding ZDoom Marines."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
    },

    {
      name = "float_marine_pistol",
      label = _("Pistol Marine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the number of Pistol-wielding ZDoom Marines."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
    },

    {
      name = "float_marine_shotty",
      label = _("Shotgun Marine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the number of Shotgun-wielding ZDoom Marines."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
    },

    {
      name = "float_marine_ssg",
      label = _("SSG Marine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the number of Super Shotgun-wielding ZDoom Marines."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
    },

    {
      name = "float_marine_chain",
      label = _("Chaingun Marine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the number of Chaingun-wielding ZDoom Marines."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
    },

    {
      name = "float_marine_rocket",
      label = _("Rocket Marine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the number of Rocket Launcher-wielding ZDoom Marines."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
    },

    {
      name = "float_marine_plasma",
      label = _("Plasma Marine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the number of Plasma Rifle-wielding ZDoom Marines."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
    },

    {
      name = "float_marine_rail",
      label = _("Railgun Marine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the number of Railgun-wielding ZDoom Marines."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
    },

    {
      name = "float_marine_bfg",
      label = _("BFG Marine"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the number of BFG 9000-wielding ZDoom Marines."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
    },
  },
}

