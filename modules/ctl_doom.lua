---------------------------------------------------------------
--  MODULE: Doom Control
----------------------------------------------------------------
--
--  Copyright (C) 2009-2010 Andrew Apted
--  Copyright (C) 2020-2021 MsrSgtShooterPerson
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

CTL_DOOM = {}

function CTL_DOOM.monster_setup(self)

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


OB_MODULES["doom_mon_control"] =
{

  name = "doom_mon_control",

  label = _("Doom Monster Control"),

  game = "doomish",
  engine = "idtech_1",
  port = "!limit_enforcing",
  where = "combat",

  hooks =
  {
    setup = CTL_DOOM.monster_setup
  },

  options =
  {

     {
      name = "float_zombie",
      label = _("Zombieman"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Zombiemen."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_shooter",
      label = _("Shotgun Guy"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Shotgunners."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_gunner",
      label = _("Chaingunner"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Chaingunners."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_ss_nazi",
      label = _("SS Nazi"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of SS troops."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_imp",
      label = _("Imp"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Imps."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_skull",
      label = _("Lost Soul"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Lost Souls."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_demon",
      label = _("Demon"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Pinkies."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_spectre",
      label = _("Spectre"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Spectres."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_pain",
      label = _("Pain Elemental"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Pain Elementals."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_caco",
      label = _("Cacodemon"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Cacodemons."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_knight",
      label = _("Hell Knight"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Hell Knights."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_revenant",
      label = _("Revenant"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Revenants."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_mancubus",
      label = _("Mancubus"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Mancubi."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_arach",
      label = _("Arachnotron"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Arachnotrons."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_vile",
      label = _("Arch-Vile"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Arch-Viles."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_baron",
      label = _("Baron of Hell"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Barons of Hell."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_Cyberdemon",
      label = _("Cyberdemon"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Cyberdemons."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },

     {
      name = "float_Spiderdemon",
      label = _("Spiderdemon"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Spider Masterminds."),  
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     }
  },
}

CTL_DOOM.ID24_MONSTERS = 
{
  id24_ghoul =
  {
    id = 3007,
    r = 16,
    h = 40,
    level = 1,
    prob = 140,
    health = 50,
    damage = 3,
    attack = "missile",
    density = 1.0,
    room_size = "any"
  },
  id24_banshee =
  {
    id = 3008,
    r = 20,
    h = 56,
    level = 1,
    prob = 140,
    health = 100,
    damage = 128,
    attack = "melee",
    density = 1.0,
    room_size = "any"
  },
  id24_mindweaver =
  {
    id = 3009,
    r = 64,
    h = 64,
    level = 1,
    prob = 140,
    health = 500,
    damage = 5.5,
    attack = "hitscan",
    density = 1.0,
    room_size = "any"
  },
  id24_shocktrooper =
  {
    id = 3010,
    r = 20,
    h = 56,
    level = 1,
    prob = 140,
    health = 100,
    damage = 10.7,
    attack = "missile",
    density = 1.0,
    room_size = "any"
  },
  id24_vassago =
  {
    id = 3011,
    r = 24,
    h = 64,
    level = 1,
    prob = 140,
    boss_type = "minor",
    boss_prob = 50,
    health = 1000,
    damage = 25,
    attack = "missile",
    density = 1.0,
    room_size = "any"
  },
  id24_tyrant =
  {
    id = 3012,
    r = 40,
    h = 110,
    level = 1,
    prob = 140,
    boss_type = "minor",
    boss_prob = 50,
    health = 1000,
    damage = 125,
    attack = "missile",
    density = 1.0,
    room_size = "any"
  },
}

function CTL_DOOM.id24_monster_setup(self)

  module_param_up(self)

  table.merge_missing(GAME.MONSTERS, CTL_DOOM.ID24_MONSTERS)

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

OB_MODULES["doom_mon_control_id24"] =
{

  name = "doom_mon_control_id24",

  label = _("ID24 Monster Control"),

  game = "doomish",
  engine = "idtech_1",
  port = "!limit_enforcing",
  where = "experimental",

  hooks =
  {
    setup = CTL_DOOM.id24_monster_setup
  },

  options =
  {
     {
      name = "float_id24_ghoul",
      label = _("Ghoul"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Ghouls."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },
     {
      name = "float_id24_banshee",
      label = _("Banshee"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Banshees."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },
     {
      name = "float_id24_mindweaver",
      label = _("Mindweaver"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Mindweavers."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },
     {
      name = "float_id24_shocktrooper",
      label = _("Shocktrooper"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Shocktroopers."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },
     {
      name = "float_id24_vassago",
      label = _("Vassago"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Vassago."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },
     {
      name = "float_id24_tyrant",
      label = _("Tyrant"),
      valuator = "slider",
      min = 0,
      max = 20,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Tyrants."), 
      presets = _("0:0 (None at all),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),20:20 (INSANE)"),
      randomize_group="monsters",
     },
  },
}

----------------------------------------------------------------

CTL_DOOM.WEAPON_PREF_CHOICES =
{
  "normal",  _("Normal"),
  "vanilla", _("Vanilla"),
  "none",    _("NONE"),
}


function CTL_DOOM.weapon_setup(self)

  module_param_up(self)

  for _,opt in pairs(self.options) do

    if opt.name == "float_saw" then 
      if PARAM["float_saw"] and PARAM["float_saw"] ~= gui.gettext("Default") then
        local info = GAME.NICE_ITEMS.saw
        local mult = PARAM["float_saw"] or 0
  
        if info.add_prob then info.add_prob = info.add_prob * mult end
        if info.start_prob then info.start_prob = info.start_prob * mult end
        if info.crazy_prob then info.crazy_prob = info.crazy_prob * mult end
        if info.closet_prob then info.closet_prob = info.closet_prob * mult end
        if info.secret_prob then info.secret_prob = info.secret_prob * mult end
        if info.storage_prob then info.storage_prob = info.storage_prob * mult end
      end    
      goto skip
    end

    local W = GAME.WEAPONS[string.sub(opt.name, 7)] -- Strip the float_ prefix from the weapon name for table lookup

    if W and PARAM[opt.name] ~= gui.gettext("Default") then
      W.add_prob = PARAM[opt.name] * 100
      W.pref     = W.add_prob * 0.28 + 1 -- Complete guesswork right now - Dasho

      -- loosen some of the normal restrictions
      W.level = 1
    end

    ::skip::

  end -- for opt

  -- specific instructions for the weapon_pref choices
  if PARAM.weapon_prefs == "vanilla"
  or PARAM.weapon_prefs == "none" then
    for _,mon in pairs(GAME.MONSTERS) do
      mon.weapon_prefs = nil
    end
  end

  if PARAM.weapon_prefs == "vanilla" then
    GAME.MONSTERS["Cyberdemon"].weap_prefs = { bfg = 10.0 }
    GAME.MONSTERS["Spiderdemon"].weap_prefs = { bfg = 10.0 }
    GAME.MONSTERS["demon"].weap_prefs = { launch = 0.3 }
    GAME.MONSTERS["skull"].weap_prefs = { launch = 0.1 }
    GAME.MONSTERS["spectre"].weap_prefs = { launch = 0.3 }

    if OB_CONFIG.game == "doom2" then
      GAME.MONSTERS["pain"].weap_prefs = { launch = 0.1 }
    end
  end

end


OB_MODULES["doom_weapon_control"] =
{

  name = "doom_weapon_control",

  label = _("Doom Weapon Control"),

  game = "doomish",
  engine = "idtech_1",
  port = "!limit_enforcing",
  where = "pickup",

  hooks =
  {
    setup = CTL_DOOM.weapon_setup
  },

  options =
  {

    {
     name = "float_saw",
     label = _("Chainsaw"),
     valuator = "slider",
     min = 0,
     max = 10,
     increment = .02,
     default = _("Default"),
     nan = _("Default"),
     tooltip = _("Control the likelihood of finding a Chainsaw."),  
     presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
     randomize_group="pickups",
    },

     {
      name = "float_shotty",
      label = _("Shotgun"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Shotguns."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

     {
      name = "float_super",
      label = _("Super Shotgun"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Super Shotguns."), 
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

     {
      name = "float_chain",
      label = _("Chaingun"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Chainguns."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

     {
      name = "float_launch",
      label = _("Rocket Launcher"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Rocket Launchers."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

     {
      name = "float_plasma",
      label = _("Plasma Rifle"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Plasma Rifles."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

     {
      name = "float_bfg",
      label = _("BFG 9000"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of BFG 9000s."), 
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

    {
      name="weapon_prefs",
      label=_("Weapon Preferences"),
      choices=CTL_DOOM.WEAPON_PREF_CHOICES,
      tooltip=_("Alters selection of weapons that are prefered to show up depending on enemy palette for a chosen map.\n\nNormal: Monsters have weapon preferences. Stronger weapons and ammo are more likely to appear directly with stronger enemies.\n\nVanilla: Vanilla Oblige-style preferences. Reduces rocket launchers if the map has more pain elementals, lost souls, demons/specters while increases BFG's for cyberdemons and spider masterminds. No other weapon preferences.\n\nNONE: No preferences at all. For those who like to live life dangerously with lost souls and only rockets."),
      default="normal",
    },
  },
}


--

function CTL_DOOM.item_setup(self)

  module_param_up(self)

  local function change_probz(name, info)
    if PARAM[name] and PARAM[name] ~= gui.gettext("Default") then
      local mult = PARAM[name] or 0

      if info.add_prob then info.add_prob = info.add_prob * mult end
      if info.start_prob then info.start_prob = info.start_prob * mult end
      if info.crazy_prob then info.crazy_prob = info.crazy_prob * mult end
      if info.closet_prob then info.closet_prob = info.closet_prob * mult end
      if info.secret_prob then info.secret_prob = info.secret_prob * mult end
      if info.storage_prob then info.storage_prob = info.storage_prob * mult end
    end
  end

  for name, info in pairs(GAME.PICKUPS) do
    float_name = "float_" .. name
    change_probz(float_name, info)
  end

  for name, info in pairs(GAME.NICE_ITEMS) do
    float_name = "float_" .. name
    change_probz(float_name, info)
  end

end

OB_MODULES["doom_item_control"] =
{

  name = "doom_item_control",

  label = _("Doom Item Control"),

  game = "doomish",
  engine = "idtech_1",
  port = "!limit_enforcing",
  where = "pickup",

  hooks =
  {
    get_levels = CTL_DOOM.item_setup
  },

  options =
  {

     {
      name = "float_potion",
      label = _("Health Bonus"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Health Potions."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      priority = 100,
      randomize_group="pickups",
     },
     
     {
      name = "float_stimpack",
      label = _("Stimpack"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Stimpacks."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      priority = 99,
      randomize_group="pickups",
     },
     
     {
      name = "float_medikit",
      label = _("Medikit"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Medikits."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      priority = 98,
      gap = 1,
      randomize_group="pickups",
     },
     
     {
      name = "float_helmet",
      label = _("Armor Bonus"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Helmets."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      priority = 95,
      randomize_group="pickups",
     },    

    -- nice items
    
     {
      name = "float_green_armor",
      label = _("Green Armor"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Green Armor."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      priority = 94,
      randomize_group="pickups",
     },

     {
      name = "float_blue_armor",
      label = _("Blue Armor"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Blue Armor."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      priority = 93,
      gap = 1,
      randomize_group="pickups",
     },

     {
      name = "float_soul",
      label = _("Soulsphere"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Soulspheres."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

     {
      name = "float_backpack",
      label = _("Backpack"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Backpacks."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

     {
      name = "float_berserk",
      label = _("Berserk Pack"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Berserk Packs."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

     {
      name = "float_invis",
      label = _("Invisibility"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Invisibility Spheres."), 
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },
     
     {
      name = "float_invul",
      label = _("Invulnerability"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Invulnerability Spheres."), 
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

     {
      name = "float_allmap",
      label = _("Map Computer"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Map Computers."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

     {
      name = "float_goggles",
      label = _("Light Goggles"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Light Goggles."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

     {
      name = "float_mega",
      label = _("Megasphere"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Megaspheres."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
     },

    -- ammo
    
     {
      name = "float_bullets",
      label = _("Clips"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Clips."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
      priority = 75,
     },

     {
      name = "float_bullet_box",
      label = _("Bullet Box"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Bullet Boxes."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
      priority = 74,
     },

     {
      name = "float_shells",
      label = _("Shells"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Shells."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
      priority = 73,
     },

     {
      name = "float_shell_box",
      label = _("Shell Box"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Shell Boxes."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
      priority = 72,
     },

     {
      name = "float_rocket",
      label = _("Rocket"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Rockets."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
      priority = 71,
     },

     {
      name = "float_rocket_box",
      label = _("Rocket Box"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Rocket Boxes."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
      priority = 70,
     },

     {
      name = "float_cells",
      label = _("Cell"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Cells."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      randomize_group="pickups",
      priority = 69,
     },

     {
      name = "float_cell_pack",
      label = _("Cell Pack"),
      valuator = "slider",
      min = 0,
      max = 10,
      increment = .02,
      default = _("Default"),
      nan = _("Default"),
      tooltip = _("Control the amount of Cell Packs."),  
      presets = _("0:0 (None),.02:0.02 (Scarce),.14:0.14 (Less),.5:0.5 (Plenty),1.2:1.2 (More),3:3 (Heaps),10:10 (I LOVE IT)"),
      priority = 68,
      randomize_group="pickups",
      gap = 1,
     }
  },
}
