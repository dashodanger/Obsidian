------------------------------------------------------------------------
--  MODULE: Miscellaneous Stuff
------------------------------------------------------------------------
--
--  Copyright (C) 2009 Enhas
--  Copyright (C) 2009-2017 Andrew Apted
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

MISC_STUFF = { }

MISC_STUFF.YES_NO =
{
  "no",  _("No"),
  "yes", _("Yes"),
}

MISC_STUFF.LIGHTINGS =
{
  "flat",    _("FLAT"),
  "lower",   _("Lower"),
  "normal",  _("Normal"),
  "higher",  _("Higher"),
}

MISC_STUFF.LIGHT_CHOICES =
{
  "-3",   _("Pitch-black"),
  "-2",   _("Gloomy"),
  "-1",   _("Darker"),
  "none", _("NONE"),
  "+1",   _("Brighter"),
  "+2",   _("Vivid"),
  "+3",   _("Radiant"),
}

MISC_STUFF.HEIGHT_CHOICES =
{
  "short",     _("Mostly Short"),
  "short-ish", _("Slightly Short"),
  "normal",    _("Normal"),
  "tall-ish",  _("Slightly Tall"),
  "tall",      _("Mostly Tall"),
  "mixed",     _("Mix It Up"),
}

MISC_STUFF.WINDOW_BLOCKING_CHOICES =
{
  "not_on_vistas", _("Not on Vistas"),
  "never",         _("Never"),
  "all",           _("All"),
}

MISC_STUFF.RAIL_BLOCKING_CHOICES =
{
  "never",       _("Never"),
  "on_occasion", _("Occasional"),
  "all",         _("All"),
}

MISC_STUFF.LIQUID_SINK_OPTIONS =
{
  "yes",          _("Yes"),
  "not_damaging", _("No Damaging"),
  "no",           _("No"),
}

MISC_STUFF.LINEAR_START_CHOICES =
{
  "100",     _("All"),
  "75",      _("75% of All Levels"),
  "50",      _("50% of All Levels"),
  "25",      _("25% of All Levels"),
  "12",      _("12% of All Levels"),
  "default", _("DEFAULT"),
}

MISC_STUFF.OUTDOOR_OPENNESS =
{
  "urbtech", _("Tech and Urban"),
  "urban", _("Urban"),
  "always", _("Always"),
  "none", _("DEFAULT"),
}

MISC_STUFF.ROOM_SIZE_MULTIPLIER_CHOICES =
{
  "0.25", _("x0.25"),
  "0.5", _("x0.5"),
  "0.75", _("x0.75"),
  "1", _("x1"),
  "1.25", _("x1.25"),
  "1.5", _("x1.5"),
  "2", _("x2"),
  "4", _("x4"),
  "6", _("x6"),
  "8", _("x8"),
  "vanilla", _("Vanilla"),
  "mixed", _("Mix It Up")
}

MISC_STUFF.AREA_COUNT_MULTIPLIER_CHOICES =
{
  "0.15", _("x0.15"),
  "0.5", _("x0.5"),
  "0.75", _("x0.75"),
  "1", _("x1"),
  "1.5", _("x1.5"),
  "2", _("x2"),
  "4", _("x4"),
  "vanilla", _("Vanilla"),
  "mixed", _("Mix It Up")
}

MISC_STUFF.ROOM_SIZE_CONSISTENCY_CHOICES =
{
  "normal", _("Vanilla"),
  "bounded", _("Bounded"),
  "strict", _("Strict"),
  "mixed", _("Mix It Up")
}

MISC_STUFF.ROOM_SIZE_MIX_FINE_TUNE_CHOICES =
{
  "smallish", _("Small-ish"),
  "small", _("Small"),
  "large", _("Large"),
  "largeish", _("Large-ish"),
  "normal", _("Normal"),
  "conservative", _("Conservative"),
  "very_conservative", _("Very Conservative"),
  "random", _("Random")
}

MISC_STUFF.ROOM_AREA_MIX_FINE_TUNE_CHOICES =
{
  "lessish", _("Less-ish"),
  "less", _("Less"),
  "more", _("More"),
  "moreish", _("More-ish"),
  "normal", _("Normal"),
  "conservative", _("Conservative"),
  "very_conservative", _("Very Conservative"),
  "random", _("Random")
}

function MISC_STUFF.setup(self)
  
  module_param_up(self)

  --Brightness sliders
  PARAM["wad_minimum_brightness"] = math.min(PARAM.float_minimum_brightness, PARAM.float_maximum_brightness)
  PARAM["wad_maximum_brightness"] = math.max(PARAM.float_minimum_brightness, PARAM.float_maximum_brightness)
end

function MISC_STUFF.begin_level(self, LEVEL)
  for _,opt in pairs(self.options) do
    if opt.valuator then goto continue end

    local name  = assert(opt.name)
    local value = opt.value

    if opt.choices == STYLE_CHOICES then
      if value ~= "mixed" then
        STYLE[name] = value
      end

    else
      -- pistol_starts, or other YES/NO stuff
      if opt.name == "liquid_sinks" then
        PARAM[name] = value
      end
      if value ~= "no" then
        PARAM[name] = value
      end
    end

    ::continue::
  end

  if PARAM.outdoor_openness then
    if PARAM.outdoor_openness == "urbtech"
    and LEVEL.theme_name == "urban" 
    or LEVEL.theme_name == "tech" then
      LEVEL.outdoor_openness = true
    elseif PARAM.outdoor_openness == "urban"
    and LEVEL.theme_name == "urban" then
      LEVEL.outdoor_openness = true
    elseif PARAM.outdoor_openness == "always" then
      LEVEL.outdoor_openness = true
    end
  end
end


OB_MODULES["misc"] =
{

  name = "misc",

  label = _("Advanced Architecture"),

  engine = "!idtech_0",
  port = "!limit_enforcing",

  where = "arch",
  priority = 101,

  hooks =
  {
    setup = MISC_STUFF.setup,
    begin_level = MISC_STUFF.begin_level
  },

  options =
  {

    {
      name = "float_layout_absurdity",
      label = _("Layout Consistency"),
      valuator = "slider",
      units = _("% Chance Per Level"),
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      tooltip = _("Chance that a level will be built with a layout from random set of prefered shape rules."),
      longtip = _("Layout consistency attempts to cause levels to overprefer specific shape rules from the ruleset in order to create odd but more consistent combinations of pieces to build the general layout. The effect will be more prominent in certain combinations and levels than others."),
      gap = 1,
      priority = 99,
      randomize_group="architecture"
    },

    {
      name = "float_nature_mode",
      label = _("Nature Mode"),
      valuator = "slider",
      units = _("% Chance Per Level"),
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      tooltip = _("Forces most of the map to be composed of naturalistic areas (parks and caves). The ratio is decided by Outdoors style setting while competing styles are ignored."),
      randomize_group="architecture",
      priority = 97
    },

    {
      name = "float_streets_mode",
      label = _("Streets Mode"),
      valuator = "slider",
      units = _("% Chance Per Level"),
      min = 0,
      max = 100,
      increment = 1,
      default = 15,
      tooltip = _("Allows Obsidian to create large street-like outdoor rooms."),
      randomize_group="architecture",
      priority = 96
    },

    {
      name = "bool_appropriate_street_themes",
      label=_("Streets-Friendly Themes Only"),
      valuator = "button",
      default = 1,
      tooltip = _("Only allow Streets Mode slider to affect levels with the following themes:\n\nDoom 2 - Urban\nHeretic - City"),
      priority = 95,
      gap = 1,
    },

    {
      name="room_size_multiplier", 
      label=_("Room Size Multiplier"),
      choices = MISC_STUFF.ROOM_SIZE_MULTIPLIER_CHOICES,
      default = "mixed",
      tooltip = _("Alters the general size and ground coverage of rooms.\n\nVanilla: No room size multipliers.\n\nMix It Up: All multiplier ranges are randomly used with highest and lowest multipliers being rarest."),
      priority = 94,
      randomize_group="architecture",
    },
    {
      name="room_area_multiplier", label=_("Area Count Multiplier"),
      choices = MISC_STUFF.AREA_COUNT_MULTIPLIER_CHOICES,
      default = "mixed",
      tooltip = _("Alters the number of areas in a room. Influences the amount rooms are divided into different elevations or simply different ceilings if a level has no steepness.\n\nVanilla: No area quantity multipliers.\n\nMix It Up: All multiplier ranges are randomly used with highest and lowest multipliers being rarest."),
      priority = 93,
      randomize_group="architecture",
    },
    {
      name="room_size_consistency", 
      label=_("Size Consistency"),
      choices = MISC_STUFF.ROOM_SIZE_CONSISTENCY_CHOICES,
      default = "mixed",
      tooltip = _("Changes whether rooms follow a strict single size or not. Can be paired with above choices for more enforced results.\n\nVanilla: Original behavior. Rooms in a level have vary in size from each other. Big Rooms options are respected.\n\nBounded: Rooms vary in size but not radically from each other.\n\nStrict: All rooms in the level have a single set size/coverage.\n\nMix It Up: A mixture of 75% Vanilla, 25% Strict."),
      priority = 92,
      randomize_group="architecture",
    },
    {
      name="room_size_mix_type", 
      label=_("Room Size Mix Fine Tune"),
      choices = MISC_STUFF.ROOM_SIZE_MIX_FINE_TUNE_CHOICES,
      default = "normal",
      tooltip = _("Alters the behavior of Mix It Up for Room Size Multiplier options.\n\nNormal: Mix it up uses a normal curve distribution. Traditional-sized rooms are common and smaller or larger sizes are slightly less so.\n\nSmall-ish: Only smaller room sizes, but biased towards normal sizes.\n\nSmall: Biased towards smaller room sizes with no larger room sizes.\n\nLarge: Biased towards large rooms sizes with no smaller room sizes..\n\nLarge-ish: Only larger room sizes, but biased towards normal sizes.\n\nConservative: Probability is biased more towards regular room sizes, making much smaller or much larger rooms significantly rarer.\n\nVery Conservative: Bias is even stronger towards regular and smaller rooms sizes, while larger rooms are very rare.\n\nRandom: No curve distribution - room sizes and room area counts are picked completely randomly."),
      priority = 91,
      randomize_group="architecture",
      
    },
    {
      name="room_area_mix_type", 
      label=_("Room Area Mix Fine Tune"),
      choices = MISC_STUFF.ROOM_AREA_MIX_FINE_TUNE_CHOICES,
      default = "normal",
      tooltip = _("Alters the behavior of Mix It Up for Room Area Multiplier options.\n\nNormal: Mix it up uses a normal curve distribution.\n\nLess-ish: Only rooms with less floors and simple ceilings, but biased towards normal counts.\n\nLess: Biased towards rooms with less floors and simple ceilings.\n\nMore: Biased towards rooms with more floors and complex ceilings.\n\nMore-ish: Only rooms with more floors and complex ceilings, but biased towards normal counts.\n\nConservative: Biased towards normal area counts.\n\nVery Conservative: Further biased towards normal area counts.\n\nRandom: No curve distribution - room area counts are picked completely randomly."),
      priority = 90,
      gap = 1,
      randomize_group="architecture",
      
    },

    { name="big_rooms",   
      label=_("Big Rooms"), 
      tooltip=_("Raises upper limits on individual room growth"), 
      choices=STYLE_CHOICES, priority = 89, randomize_group="architecture", 
    },
    { name="big_outdoor_rooms", 
      label=_("Big Outdoors"), 
      tooltip=_("Raises upper limits on outdoor area growth"), 
      choices=STYLE_CHOICES, priority = 88, randomize_group="architecture",
    },
    { name="sub_rooms", 
      label=_("Sub Rooms"), 
      tooltip=_("Controls number of small sub rooms. Actually controls the degree at which ungrown rooms are left instead of culled."), 
      choices=STYLE_CHOICES, priority = 87.5, randomize_group="architecture",
      
    },
    {
      name="room_heights",
      label=_("Room Heights"),
      choices=MISC_STUFF.HEIGHT_CHOICES,
      tooltip=_("Determines if rooms should have a height limit or should exaggerate their height. Short means room areas strictly have at most 128 units of height, tall means rooms immediately have doubled heights. Normal is the default Oblige behavior."),
      default="mixed",
      priority = 87,
      gap=1,
      randomize_group="architecture",
    },


    { name="parks",       
    label=_("Parks"), 
    tooltip = _("Control the number of parks."), 
    choices=STYLE_CHOICES, priority = 86, randomize_group="architecture", },
    {
      name="natural_parks",
      label=_("Natural Cliffs"),
      tooltip=_("Percentage of parks that use completely naturalistic walls."),
      choices=STYLE_CHOICES,
      default="none",
      priority = 85,
      randomize_group="architecture",
      
    },
    { name="park_detail",
      label=_("Park Detail"),
      tooltip=_("Reduces or increases the probability of park decorations such as trees on park rooms."),
      choices=STYLE_CHOICES,
      priority = 84,
      gap=1,
      randomize_group="architecture",
      
    },

    { name="windows",     
    label=_("Windows"), 
    tooltip = _("Control the number of windows."), 
    choices=STYLE_CHOICES, priority = 83, randomize_group="architecture", },
    {
      name="passable_windows",
      label=_("Passable Windows"),
      choices=MISC_STUFF.WINDOW_BLOCKING_CHOICES,
      tooltip=_("Sets the preferences for passability on certain windows. On Vistas Only means only windows that look out to vistas/map border scenics have a blocking line."),
      default="never",
      priority = 82,
      
    },
    {
      name="passable_railings",
      label=_("Passable Railings"),
      choices=MISC_STUFF.RAIL_BLOCKING_CHOICES,
      tooltip=_("Sets the passability of railing junctions between full impassability or the 3D midtex flag. Occasional means 3D midtex is only used on railings between areas the player is supposed to circumvent. Always means the inclusion of cages and scenic rails, allowing flying monsters to potentially escape.\n\nNote: 3D midtex lines currently *block* projectiles as well."),
      default="never",
      priority = 81, 
      gap=1,
      
    },

    { name="symmetry",    
    label=_("Symmetry"), 
    tooltip = _("Affects amount of symmetry when growing levels."), 
    choices=STYLE_CHOICES, priority = 80, randomize_group="architecture", },
    { name="beams",       
    label=_("Beams"),          
    choices=STYLE_CHOICES,
    tooltip = _("Allows the appearance of thin pillars to appear between the borders of different elevations."),
    priority = 79,
    randomize_group="architecture",
    },
    { name="fences",      
    label=_("Fences"),         
    choices=STYLE_CHOICES,
    tooltip = _("Creates thick solid fences and fence posts between areas of varying height for outdoor rooms."),
    priority = 78,
    randomize_group="architecture",
    },
    { name="porches",     
    label=_("Porches\\Gazebos"),        
    choices=STYLE_CHOICES,
    tooltip = _("Occasional outdoor areas with a lowered indoor-ish ceiling."),
    priority = 77,
    randomize_group="architecture",
    },
    { name="pictures",     
    label=_("Pictures"),          
    choices=STYLE_CHOICES,
    tooltip = _("Controls the large wall setpieces in a map. Works on a chance per room basis."),
    priority = 76.5,
    randomize_group="architecture",
    },
    { name="scenics",     
    label=_("Scenics"),          
    choices=STYLE_CHOICES,
    tooltip = _("Controls the number of fancy scenics visible at room bordering the maps."),
    priority = 76,
    gap = 1,
    randomize_group="architecture",
    },

    {
      name = "liquid_sinks",
      label=_("Liquid Sinks"),
      choices=MISC_STUFF.LIQUID_SINK_OPTIONS,
      tooltip = _("Enables or disables liquid sinks. Liquid sinks are walkable floors that are often converted into depressions with the level's liquid. May greatly inconvenience the player but default Oblige behavior is 'Yes'."),
      default = "yes",
      priority = 74,
      gap = 1,
    },

    { name="darkness",    
    label=_("Dark Outdoors"),  
    tooltip=_("Affects the chance of a level having darker skies."), 
    choices=STYLE_CHOICES, priority = 73 },

    { 
      name="float_minimum_brightness", 
      label=_("Minimum Brightness"),
      valuator = "slider",
      min = 0,
      max = 256,
      increment = 16,
      default = 0,
      tooltip = _("Sets the minimum brightness for the map."),
      priority = 72,
      
    },

    { 
      name="float_maximum_brightness", 
      label=_("Maximum Brightness"),
      valuator = "slider",
      min = 0,
      max = 256,
      increment = 16,
      default = 256,
      tooltip = _("Sets the maximum brightness for the map."),
      priority = 71,
      
    },

    { name="barrels",     
    label=_("Explosive Decor"),        
    choices=STYLE_CHOICES, gap=1,
    tooltip = _("Controls the presence of barrels, pods, canisters, etc."),
    priority = 70,
    randomize_group="architecture",
    },

    { name="doors",       
    label=_("Doors"), 
    tooltip = _("Control the number of doors."), 
    choices=STYLE_CHOICES, priority = 69, randomize_group="architecture", },
    { name="keys",        
    label=_("Keyed Doors"), 
    tooltip = _("Control the number of keyed doors."), 
    choices=STYLE_CHOICES, priority = 68, randomize_group="architecture", },
    { name="trikeys",     
    label=_("Triple-Keyed Doors"),          
    choices=STYLE_CHOICES,
    tooltip = _("Controls the chance to get three key door whenever three keys are present."),
    priority = 67,
    randomize_group="architecture",
    },
    { name="switches",    label=_("Switch Goals"), choices=STYLE_CHOICES, 
      tooltip = _("Controls the chance for long-distance switch and lock quests."),
      priority = 66,
      randomize_group="architecture",
    },
    { name="local_switches",    label=_("Switch Rooms"), choices=STYLE_CHOICES, 
      tooltip = _("Controls the chance same-room switches and locks."),
      priority = 65,
      gap=1,
      randomize_group="architecture",
    },

    {
      name="bool_road_markings",
      label=_("Road Markings"),
      valuator = "button",
      default = 1,
      tooltip = _("Adds street markings to roads."),
      priority = 64,
      
    },
    {
      name="street_traffic",
      label=_("Street Traffic"),
      choices=STYLE_CHOICES,
      tooltip = _("If Street Mode is enabled, changes the density of prefabs such as cars, barriers, crates, and relevant items on the roads."),
      priority = 63,
      gap = 1,
      randomize_group="architecture",
      
    },

    {
      name="bool_exit_signs",
      label=_("Exit Signs"),
      valuator = "button",
      default = 1,
      tooltip=_("Places exit signs by exiting room"),
      priority = 62,
      gap=1,
    },

    {
      name="linear_start",
      label=_("Linear Start"),
      choices=MISC_STUFF.LINEAR_START_CHOICES,
      tooltip=_("Stops start rooms from having more than one external room connection. Can help reduce being overwhelmed by attacks from multiple directions when multiple neighboring rooms connect into the start room. Default means no control, and levels can have linear starts at random based on shape grammars as per original Oblige 7.7 behavior."),
      default = "default",
      priority = 61,
      
    },
    {
      name="outdoor_openness",
      label=_("Open Outdoors"),
      choices=MISC_STUFF.OUTDOOR_OPENNESS,
      tooltip=_("Disables shape rules that involve obstructive geometry such as pillars for outdoors based on theme."),
      default="none",
      priority = 60,
      
    },
    {
      name="dead_ends",
      label=_("Dead Ends"),
      choices=STYLE_CHOICES,
      tooltip=_("Cleans up and removes areas with staircases that lead to nowhere.\nNONE means all dead ends are removed.\nHeaps means all dead ends are preserved (Oblige default)."),
      default = "heaps",
      priority = 59,
      gap = 1,
      randomize_group="architecture",
      
    },

---- PLANNED (UNFINISHED) STUFF ----

-- already done: -- MSSP
--  { name="light_level",  label=_("Lighting"),   choices=MISC_STUFF.LIGHTINGS },
--  { name="detail_level", label=_("Detail"),     choices=MISC_STUFF.LIGHTINGS, gap=1 },

--  pictures    = { label=_("Pictures"),       choices=STYLE_CHOICES },
--  cycles      = { label=_("Multiple Paths"), choices=STYLE_CHOICES },
--  ex_floors   = { label=_("3D Floors"),      choices=STYLE_CHOICES },

--  lakes       = { label=_("Lakes"),          choices=STYLE_CHOICES },
  },
}
