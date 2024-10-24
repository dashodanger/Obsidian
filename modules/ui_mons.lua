------------------------------------------------------------------------
--  PANEL: Monsters
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
--  Copyright (C) 2019-2022 Reisal
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
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

UI_MONS = { }

UI_MONS.BOSSES =
{
  "none",   _("NONE"),
  "easier", _("Easier"),
  "medium", _("Average"),
  "harder", _("Harder"),
}

UI_MONS.TRAP_STYLE =
{
  "default",   _("DEFAULT"),
  "teleports", _("Teleports Only"),
  "closets",   _("Closets Only"),
  "20",        _("20% Closets - 80% Teleports"),
  "40",        _("40% Closets - 60% Teleports"),
  "60",        _("60% Closets - 40% Teleports"),
  "80",        _("80% Closets - 20% Teleports"),
}

UI_MONS.CAGE_STRENGTH =
{
  "weaker",    _("Weaker"),
  "easier",    _("Easier"),
  "default",   _("Average"),
  "tricky",    _("Tricky"),
  "treacherous", _("Treacherous"),
  "dangerous", _("Dangerous"),
  "deadly",    _("Deadly"),
  "lethal",    _("Lethal"),
  "crazy",     _("CRAZY"),
}

UI_MONS.SECRET_MONSTERS =
{
  "yesyes", _("Yes - Full Strength"),
  "yes",    _("Yes - Weak"),
  "no",     _("No"),
}

UI_MONS.MONSTER_KIND_JUMPSTART_CHOICES =
{
  "default", _("DEFAULT"),
  "harder", _("Harder"),
  "tougher", _("Tougher"),
  "fiercer", _("Fiercer"),
  "crazier", _("CRAZIER")
}

UI_MONS.BOSSREGULARS =
{
  "no",  _("Disabled"),
  "minor", _("Minor Bosses Only"),
  "nasty", _("Minor and Nasty Bosses Only"),
  "all", _("All Bosses"),
}

function UI_MONS.setup(self)

  module_param_up(self)

end

OB_MODULES["ui_mons"] =
{

  name = "ui_mons",

  label = _("Combat"),

  hooks =
  {
    setup = UI_MONS.setup,
  },

  where = "combat",
  priority = 103,
  engine = "!idtech_0",
  port = "!limit_enforcing",
  options =
  {
    {
      name="float_mons",
      label=_("Monster Quantity"),
      valuator = "slider",
      min = 0,
      max = 10.00,
      increment = .05,
      default = 1.0,
      nan = _("Mix It Up,Progressive"),
      presets = _("0:None,0.15:0.15 (Trivial),0.35:0.35 (Sporadic),0.7:0.7 (Meager),1.0:1.0 (Normal),1.3:1.3 (Modest),1.5:1.5 (Bearable),2.0:2.0 (Rough),2.5:2.5 (Strenuous),3.0:3.0 (Formidable),3.5:3.5 (Harsh),4.0:4.0 (Painful),4.5:4.5 (Ferocious),5.0:5.0 (Unforgiving),5.5:5.5 (Punishing),6.0:6.0 (Murderous),6.5:6.5 (Grueling),7.0:7.0 (Unrelenting),7.5:7.5 (Arduous),8.0:8.0 (Barbaric),8.5:8.5 (Savage),9.0:9.0 (Brutal),9.5:9.5 (Draconian),10.0:10.00 (Merciless)"),
      tooltip=_("Changes the number of monsters placed in a map. Scales with level size."),
      longtip=_("For reference: Obsidian's default for normal is 1.0.\n\nMix It Up: Selects quantities specified between Upper and Lower Bound choices on a chosen by the user.\n\nProgressive: creates a curve of increasing monster population also based on the Fine Tune options below.\n\nIt does not matter if your Upper/Lower Bound selections are reversed. Progressive will pick the min VS max quantities selected.\n\nNone: No monsters. Why would you choose this option? \nTrivial: Very, very few monsters. Almost nothing to kill.\nSporadic: Very few monsters. Not many things to kill.\nMeager: Fewer monsters. Not challenging for the average player.\nEasy: Obsidian default quantity. Not too bad for casual players.\nModest: Slightly above default. Still pretty easy for most. \nBearable: Above average opposition. Getting warmer! \nRough: Slightly difficult. Equivalent to late 90s megawads. \nStrenuous: Baby steps into big boy difficulty. Lots to kill! \nFormidable/Harsh: 'Easy' level of difficult. Considerable opposition. \nPainful/Ferocious: Getting into slaughterwad territory. Difficult! \nUnforgiving/Punishing: Slaughterwad level difficulty. Skill needed. \nMurderous/Grueling: Extremely high monster count. \nUnrelenting/Arduous: An uphill battle. Expect to reload saves often! \nBarbaric/Savage: Up into the hardest slaughterwads out there. \nBrutal/Draconian: Legions of demons await you on this setting. \nMerciless: Hell will throw everything at you at this setting, you masochist."),
      randomize_group="monsters",
    },
    {
      name="float_mix_it_up_upper_range",
      label=_("Upper Bound"),
      valuator = "slider",
      min = 0,
      max = 10.00,
      increment = .05,
      default = 10,
      presets = _("0:None,0.15:0.15 (Trivial),0.35:0.35 (Sporadic),0.7:0.7 (Meager),1.0:1.0 (Normal),1.3:1.3 (Modest),1.5:1.5 (Bearable),2.0:2.0 (Rough),2.5:2.5 (Strenuous),3.0:3.0 (Formidable),3.5:3.5 (Harsh),4.0:4.0 (Painful),4.5:4.5 (Ferocious),5.0:5.0 (Unforgiving),5.5:5.5 (Punishing),6.0:6.0 (Murderous),6.5:6.5 (Grueling),7.0:7.0 (Unrelenting),7.5:7.5 (Arduous),8.0:8.0 (Barbaric),8.5:8.5 (Savage),9.0:9.0 (Brutal),9.5:9.5 (Draconian),10.0:10.00 (Merciless)"),
      longtip=_("For reference: Obsidian's default for normal is 1.0.\n\nMix It Up: Selects quantities specified between Upper and Lower Bound choices on a chosen by the user.\n\nProgressive: creates a curve of increasing monster population also based on the Fine Tune options below.\n\nIt does not matter if your Upper/Lower Bound selections are reversed. Progressive will pick the min VS max quantities selected.\n\nNone: No monsters. Why would you choose this option? \nTrivial: Very, very few monsters. Almost nothing to kill.\nSporadic: Very few monsters. Not many things to kill.\nMeager: Fewer monsters. Not challenging for the average player.\nEasy: Obsidian default quantity. Not too bad for casual players.\nModest: Slightly above default. Still pretty easy for most. \nBearable: Above average opposition. Getting warmer! \nRough: Slightly difficult. Equivalent to late 90s megawads. \nStrenuous: Baby steps into big boy difficulty. Lots to kill! \nFormidable/Harsh: 'Easy' level of difficult. Considerable opposition. \nPainful/Ferocious: Getting into slaughterwad territory. Difficult! \nUnforgiving/Punishing: Slaughterwad level difficulty. Skill needed. \nMurderous/Grueling: Extremely high monster count. \nUnrelenting/Arduous: An uphill battle. Expect to reload saves often! \nBarbaric/Savage: Up into the hardest slaughterwads out there. \nBrutal/Draconian: Legions of demons await you on this setting. \nMerciless: Hell will throw everything at you at this setting, you masochist."),
      tooltip=_("If you have Mix It Up or Progressive selected, you can define the upper bound here. Otherwise, this option is simply ignored."),
    },
    {
      name="float_mix_it_up_lower_range",
      label=_("Lower Bound"),
      valuator = "slider",
      min = 0,
      max = 10.00,
      increment = .05,
      default = 0,
      presets = _("0:None,0.15:0.15 (Trivial),0.35:0.35 (Sporadic),0.7:0.7 (Meager),1.0:1.0 (Normal),1.3:1.3 (Modest),1.5:1.5 (Bearable),2.0:2.0 (Rough),2.5:2.5 (Strenuous),3.0:3.0 (Formidable),3.5:3.5 (Harsh),4.0:4.0 (Painful),4.5:4.5 (Ferocious),5.0:5.0 (Unforgiving),5.5:5.5 (Punishing),6.0:6.0 (Murderous),6.5:6.5 (Grueling),7.0:7.0 (Unrelenting),7.5:7.5 (Arduous),8.0:8.0 (Barbaric),8.5:8.5 (Savage),9.0:9.0 (Brutal),9.5:9.5 (Draconian),10.0:10.00 (Merciless)"),
      longtip=_("For reference: Obsidian's default for normal is 1.0.\n\nMix It Up: Selects quantities specified between Upper and Lower Bound choices on a chosen by the user.\n\nProgressive: creates a curve of increasing monster population also based on the Fine Tune options below.\n\nIt does not matter if your Upper/Lower Bound selections are reversed. Progressive will pick the min VS max quantities selected.\n\nNone: No monsters. Why would you choose this option? \nTrivial: Very, very few monsters. Almost nothing to kill.\nSporadic: Very few monsters. Not many things to kill.\nMeager: Fewer monsters. Not challenging for the average player.\nEasy: Obsidian default quantity. Not too bad for casual players.\nModest: Slightly above default. Still pretty easy for most. \nBearable: Above average opposition. Getting warmer! \nRough: Slightly difficult. Equivalent to late 90s megawads. \nStrenuous: Baby steps into big boy difficulty. Lots to kill! \nFormidable/Harsh: 'Easy' level of difficult. Considerable opposition. \nPainful/Ferocious: Getting into slaughterwad territory. Difficult! \nUnforgiving/Punishing: Slaughterwad level difficulty. Skill needed. \nMurderous/Grueling: Extremely high monster count. \nUnrelenting/Arduous: An uphill battle. Expect to reload saves often! \nBarbaric/Savage: Up into the hardest slaughterwads out there. \nBrutal/Draconian: Legions of demons await you on this setting. \nMerciless: Hell will throw everything at you at this setting, you masochist."),
      tooltip=_("If you have Mix It Up or Progressive selected, you can define the lower bound here. Otherwise, this option is simply ignored."),
      gap = 1,
    },

    {
      name="float_strength",
      label=_("Monster Strength"),
      valuator = "slider",
      min = 0.55,
      max = 12,
      increment = .05,
      default = 1,
      tooltip = _("Affects level of selected monsters for a level's monster palette."),
      presets = _("0.55:0.55 (Weak),0.75:0.75 (Easier),1:1 (Average),1.3:1.3 (Harder),1.7:1.7 (Tough),2.5:2.5 (Fierce),12:12 (CRAZY)"),
      randomize_group="monsters",
    },
    {
      name="float_ramp_up",
      label=_("Ramp Up"),
      valuator = "slider",
      min = 0.5,
      max = 3,
      increment = .05,
      default = 1,
      nan = _("Episodic"),
      presets = _("0.5:0.5 (Very Slow),0.75:0.75 (Slow),1:1 (Average),1.5:1.5 (Fast),2:2 (Very Fast),3:3 (Extra Fast)"),
      tooltip = _("Rate at which monster strength increases as you progress through levels."),
      gap = 1,
      randomize_group="monsters",
      
    },

    {
      name="bool_pistol_starts",
      label=_("Default Weapon Starts"),
      valuator = "button",
      default = 1,
      tooltip=_("Ensure every map can be completed with only the default weapon (ignore weapons obtained from earlier maps)"),
      
    },
    {
      name="bool_quiet_start",
      label=_("Quiet Start"),
      valuator = "button",
      default = 0,
      tooltip=_("Makes start rooms mostly safe - no enemies and all outlooking windows are removed. (windows are retained on Procedural Gotchas) Default Obsidian behavior is 'no'."),
    },
    {
      name="mon_variety",
      label=_("Monster Variety"),
      choices=STYLE_CHOICES,
      tooltip= _("Affects how many different monster types can appear in each room.\nSetting this to NONE will make each level use a single monster type"),
      
    },
    {
      name="mon_variety_jumpstart",
      label=_("Monster Variety Jumpstart"),
      choices=UI_MONS.MONSTER_KIND_JUMPSTART_CHOICES,
      default = "default",
      tooltip = _("Affects how many monster variations initially appear at the very first map."),
      gap = 1
    },

    {
      name="bosses",
      label=_("Bosses"),
      tooltip=_("Affects likelihood and difficulty of boss encounters."),
      choices=UI_MONS.BOSSES,  randomize_group="monsters", },
    {
      name="bossesnormal",
      label=_("Bosses As Regulars"),
      choices=UI_MONS.BOSSREGULARS,
      default="no",
      tooltip=_("Normally Archviles/Barons/Cyberdemons and other big monsters are excluded from normal monster pool and only can appear as guard for important objective e.g. key. With this option enabled they are allowed to(rarely) spawn as a regular monster. \n\n WARNING: This CAN make maps much more difficult than normal."),
      gap = 1,
      randomize_group="monsters",
    },

    {
      name="traps",
      label=_("Traps"),
      tooltip = _("Control the number of traps."),
      choices=STYLE_CHOICES, randomize_group="monsters", },
    {
      name="trap_style",
      label=_("Trap Style"),
      choices=UI_MONS.TRAP_STYLE,
      default="default",
      tooltip=_("This option selects between using only teleport or closet traps. DEFAULT means both are used."),
      randomize_group="monsters",
      
    },
    {
      name="trap_qty",
      label=_("Trap Monsters"),
      choices=UI_MONS.CAGE_STRENGTH,
      default="default",
      tooltip=_("Changes the quantity of ambushing monsters from traps."),
      gap = 1,
      randomize_group="monsters",
      
    },

    { name="cages",
      label=_("Cages"),
      tooltip = _("Control the number of cages."),
      choices=STYLE_CHOICES, randomize_group="monsters", },
    {
      name="cage_qty",
      label=_("Cage Monsters"),
      choices=UI_MONS.CAGE_STRENGTH,
      default="default",
      tooltip=_("Changes the quantity of monsters in cages."),
      gap=1,
      randomize_group="monsters",
      
    },

    {
      name="secret_monsters",
      label=_("Monsters in Secrets"),
      choices=UI_MONS.SECRET_MONSTERS,
      tooltip=_("I'm in your secret rooms, placing some monsters. Note: default is none."),
      default="no",
      randomize_group="monsters",
    },
    {
      name="bool_enemy_drops",
      label=_("Enemy Drop Compensation"),
      valuator = "button",
      default = 0,
      tooltip=_("Decides whether monster drops (i.e. magazines from zombiemen) influence map pickup spawns or not.\n\nYes - Ignore extra ammunition and weapons dropped by monsters when calculating pickups.\nNo (DEFAULT) - Removes extra pickups from the map based on items dropped by monsters (i.e. less shells on the ground if shotgunners carry them)."),
      
    },

  },
}

-- WOLF 3D MODULE

UI_MONS_WOLF_3D = { }

function UI_MONS_WOLF_3D.setup(self)

  module_param_up(self)

end

OB_MODULES["ui_mons_wolf_3d"] =
{

  name = "ui_mons_wolf_3d",

  label = _("Combat"),

  hooks =
  {
    setup = UI_MONS_WOLF_3D.setup,
  },

  where = "combat",
  priority = 103,
  engine = "idtech_0",
  options =
  {
    {
      name="float_mons_wolf_3d",
      label=_("Monster Quantity"),
      valuator = "slider",
      min = 0,
      max = 10.00,
      increment = .05,
      default = 1.0,
      nan = _("Mix It Up,Progressive"),
      presets = _("0:None,0.15:0.15 (Trivial),0.35:0.35 (Sporadic),0.7:0.7 (Meager),1.0:1.0 (Easy),1.3:1.3 (Modest),1.5:1.5 (Bearable),2.0:2.0 (Rough),2.5:2.5 (Strenuous),3.0:3.0 (Formidable),3.5:3.5 (Harsh),4.0:4.0 (Painful),4.5:4.5 (Ferocious),5.0:5.0 (Unforgiving),5.5:5.5 (Punishing),6.0:6.0 (Murderous),6.5:6.5 (Grueling),7.0:7.0 (Unrelenting),7.5:7.5 (Arduous),8.0:8.0 (Barbaric),8.5:8.5 (Savage),9.0:9.0 (Brutal),9.5:9.5 (Draconian),10.0:10.00 (Merciless)"),
      tooltip=_("Changes the number of monsters placed in a map. Scales with level size."),
      longtip=_("For reference: Obsidian's default for normal is 1.0.\n\nMix It Up: Selects quantities specified between Upper and Lower Bound choices on a chosen by the user.\n\nProgressive: creates a curve of increasing monster population also based on the Fine Tune options below.\n\nIt does not matter if your Upper/Lower Bound selections are reversed. Progressive will pick the min VS max quantities selected.\n\nNone: No monsters. Why would you choose this option? \nTrivial: Very, very few monsters. Almost nothing to kill.\nSporadic: Very few monsters. Not many things to kill.\nMeager: Fewer monsters. Not challenging for the average player.\nEasy: Obsidian default quantity. Not too bad for casual players.\nModest: Slightly above default. Still pretty easy for most. \nBearable: Above average opposition. Getting warmer! \nRough: Slightly difficult. Equivalent to late 90s megawads. \nStrenuous: Baby steps into big boy difficulty. Lots to kill! \nFormidable/Harsh: 'Easy' level of difficult. Considerable opposition. \nPainful/Ferocious: Getting into slaughterwad territory. Difficult! \nUnforgiving/Punishing: Slaughterwad level difficulty. Skill needed. \nMurderous/Grueling: Extremely high monster count. \nUnrelenting/Arduous: An uphill battle. Expect to reload saves often! \nBarbaric/Savage: Up into the hardest slaughterwads out there. \nBrutal/Draconian: Legions of demons await you on this setting. \nMerciless: Hell will throw everything at you at this setting, you masochist."),
      randomize_group="monsters",
    },

    {
      name="float_mix_it_up_upper_range_wolf_3d",
      label=_("Upper Bound"),
      valuator = "slider",
      min = 0,
      max = 10.00,
      increment = .05,
      default = 10,
      presets = _("0:None,0.15:0.15 (Trivial),0.35:0.35 (Sporadic),0.7:0.7 (Meager),1.0:1.0 (Easy),1.3:1.3 (Modest),1.5:1.5 (Bearable),2.0:2.0 (Rough),2.5:2.5 (Strenuous),3.0:3.0 (Formidable),3.5:3.5 (Harsh),4.0:4.0 (Painful),4.5:4.5 (Ferocious),5.0:5.0 (Unforgiving),5.5:5.5 (Punishing),6.0:6.0 (Murderous),6.5:6.5 (Grueling),7.0:7.0 (Unrelenting),7.5:7.5 (Arduous),8.0:8.0 (Barbaric),8.5:8.5 (Savage),9.0:9.0 (Brutal),9.5:9.5 (Draconian),10.0:10.00 (Merciless)"),
      tooltip=_("If you have Mix It Up or Progressive selected, you can define the upper bound here. Otherwise, this option is simply ignored."),
      longtip=_("For reference: Obsidian's default for normal is 1.0.\n\nMix It Up: Selects quantities specified between Upper and Lower Bound choices on a chosen by the user.\n\nProgressive: creates a curve of increasing monster population also based on the Fine Tune options below.\n\nIt does not matter if your Upper/Lower Bound selections are reversed. Progressive will pick the min VS max quantities selected.\n\nNone: No monsters. Why would you choose this option? \nTrivial: Very, very few monsters. Almost nothing to kill.\nSporadic: Very few monsters. Not many things to kill.\nMeager: Fewer monsters. Not challenging for the average player.\nEasy: Obsidian default quantity. Not too bad for casual players.\nModest: Slightly above default. Still pretty easy for most. \nBearable: Above average opposition. Getting warmer! \nRough: Slightly difficult. Equivalent to late 90s megawads. \nStrenuous: Baby steps into big boy difficulty. Lots to kill! \nFormidable/Harsh: 'Easy' level of difficult. Considerable opposition. \nPainful/Ferocious: Getting into slaughterwad territory. Difficult! \nUnforgiving/Punishing: Slaughterwad level difficulty. Skill needed. \nMurderous/Grueling: Extremely high monster count. \nUnrelenting/Arduous: An uphill battle. Expect to reload saves often! \nBarbaric/Savage: Up into the hardest slaughterwads out there. \nBrutal/Draconian: Legions of demons await you on this setting. \nMerciless: Hell will throw everything at you at this setting, you masochist."),
    },

    {
      name="float_mix_it_up_lower_range_wolf_3d",
      label=_("Lower Bound"),
      valuator = "slider",
      min = 0,
      max = 10.00,
      increment = .05,
      default = 0,
      presets = _("0:None,0.15:0.15 (Trivial),0.35:0.35 (Sporadic),0.7:0.7 (Meager),1.0:1.0 (Easy),1.3:1.3 (Modest),1.5:1.5 (Bearable),2.0:2.0 (Rough),2.5:2.5 (Strenuous),3.0:3.0 (Formidable),3.5:3.5 (Harsh),4.0:4.0 (Painful),4.5:4.5 (Ferocious),5.0:5.0 (Unforgiving),5.5:5.5 (Punishing),6.0:6.0 (Murderous),6.5:6.5 (Grueling),7.0:7.0 (Unrelenting),7.5:7.5 (Arduous),8.0:8.0 (Barbaric),8.5:8.5 (Savage),9.0:9.0 (Brutal),9.5:9.5 (Draconian),10.0:10.00 (Merciless)"),
      tooltip=_("If you have Mix It Up or Progressive selected, you can define the lower bound here. Otherwise, this option is simply ignored."),
      longtip=_("For reference: Obsidian's default for normal is 1.0.\n\nMix It Up: Selects quantities specified between Upper and Lower Bound choices on a chosen by the user.\n\nProgressive: creates a curve of increasing monster population also based on the Fine Tune options below.\n\nIt does not matter if your Upper/Lower Bound selections are reversed. Progressive will pick the min VS max quantities selected.\n\nNone: No monsters. Why would you choose this option? \nTrivial: Very, very few monsters. Almost nothing to kill.\nSporadic: Very few monsters. Not many things to kill.\nMeager: Fewer monsters. Not challenging for the average player.\nEasy: Obsidian default quantity. Not too bad for casual players.\nModest: Slightly above default. Still pretty easy for most. \nBearable: Above average opposition. Getting warmer! \nRough: Slightly difficult. Equivalent to late 90s megawads. \nStrenuous: Baby steps into big boy difficulty. Lots to kill! \nFormidable/Harsh: 'Easy' level of difficult. Considerable opposition. \nPainful/Ferocious: Getting into slaughterwad territory. Difficult! \nUnforgiving/Punishing: Slaughterwad level difficulty. Skill needed. \nMurderous/Grueling: Extremely high monster count. \nUnrelenting/Arduous: An uphill battle. Expect to reload saves often! \nBarbaric/Savage: Up into the hardest slaughterwads out there. \nBrutal/Draconian: Legions of demons await you on this setting. \nMerciless: Hell will throw everything at you at this setting, you masochist."),
      gap = 1,
    },

  },
}
