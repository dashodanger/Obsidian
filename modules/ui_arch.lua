------------------------------------------------------------------------
--  PANEL: Architecture
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
--  Copyright (C) 2019 Reisal
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

UI_ARCH = { }

UI_ARCH.ZDOOM_VISTA_CHOICES =
{
  "enable",        _("Enable"),
  "sky_gen_smart", _("Sky-gen Smart"),
  "disable",       _("Disable")
}

UI_ARCH.ZDOOM_SKYBOX_CHOICES =
{
  "themed",   _("Per Theme"),
  "episodic", _("Episodic"),
  "random",   _("Random"),
  "generic",  _("Generic"),
  "disable",  _("Disable")
}

UI_ARCH.MIXIN_CHOICES =
{

  "none",   _("None"),
  "mostly", _("Mostly Selected Theme"),
  "less",   _("Mostly Other Themes"),
}


UI_ARCH.RAMP_FACTOR =
{
  "0.5",  _("Very Fast Curve"),
  "0.66", _("Fast Curve"),
  "1",    _("Linear"),
  "1.5",  _("Slow Curve"),
  "2",    _("Very Slow Curve"),
}

UI_ARCH.SIZE_BIAS =
{
  "small",   _("Smaller"),
  "default", _("DEFAULT"),
  "large",   _("Larger"),
}

function UI_ARCH.setup(self)

  module_param_up(self)

  if OB_CONFIG.engine ~= "limit_enforcing" then -- Do I actually need this check? I forget - Dasho
    if OB_CONFIG.batch == "yes" and type(PARAM.float_size) ~= "string" then
      SEED_W = 90
      SEED_H = 90
    else
      if type(PARAM.float_size) == "string" then -- Use upper bound for Mix It Up, Progressive, and Episodic level sizes - Dasho
      -- MSSP: the absolute maximum size is tightened down to the largest
      -- agreed map size for performance's sake. Current agreed maximum is 74 W.
      -- any higher will cause skyboxes and teleporter rooms to start merging with
      -- the main map.

      -- Dasho: This shifts the default value of 90 for SEED_W and SEED_H to here instead of defs.lua. It will remain 90 unless someone
      -- who is using slider overrides sets extremely high values for Level Size, then it is changed to prevent assertion errors later on.
        if (PARAM.float_level_upper_bound > 86) then
          SEED_W = PARAM.float_level_upper_bound + 4
          SEED_H = PARAM.float_level_upper_bound + 4
        else
          SEED_W = 90
          SEED_H = 90
        end
		  else
        if (PARAM.float_size > 86) then
          SEED_W = PARAM.float_size + 4
          SEED_H = PARAM.float_size + 4
        else
          SEED_W = 90
          SEED_H = 90
        end
		  end
	  end
  end
end

OB_MODULES["ui_arch"] =
{
  name = "ui_arch",

  label = _("Architecture"),
    
  side = "left",
  priority = 104,
  engine = "!idtech_0",
  port = "!limit_enforcing",
  where = "arch",

  hooks = 
  {
    setup = UI_ARCH.setup,
  },

  options =
  {

    { 
      name="float_size", 
      label=_("Level Size"),
      valuator = "slider",
      min = 10,
      max = 75,
      increment = 1,
      default = 36,
      nan = _("Mix It Up,Episodic,Progressive"),
      presets = _("10:10 (Microscopic),16:16 (Miniature),22:22 (Tiny),30:30 (Small),36:36 (Average),42:42 (Large),48:48 (Huge),58:58 (Colossal),66:66 (Gargantuan),75:75 (Transcendent)"),
      tooltip = _("Determines size of map (Width x Height) in grid squares."),
      longtip = _("If you are planning to generate Binary format maps at sizes of 50 and above, Autodetailing will be enabled by default. The stability of maps with sizes 60 and beyond is not predictable unless using UDMF map format (supported engines only)."),
      priority = 100,
      randomize_group="architecture"
    },


    {
      name = "float_level_upper_bound",
      label = _("Upper Bound"),
      valuator = "slider",
      min = 10,
      max = 75,
      increment = 1,
      default = 75,
      presets = _("10:10 (Microscopic),16:16 (Miniature),22:22 (Tiny),30:30 (Small),36:36 (Average),42:42 (Large),48:48 (Huge),58:58 (Colossal),66:66 (Gargantuan),75:75 (Transcendent)"),
      tooltip = _("Fine tune upper limit when Level Size is set to Episodic, Progressive or Mixed."),
      priority = 99,
    },


    {
      name = "float_level_lower_bound",
      label = _("Lower Bound"),
      valuator = "slider",
      min = 10,
      max = 75,
      increment = 1,
      default = 10,
      presets = _("10:10 (Microscopic),16:16 (Miniature),22:22 (Tiny),30:30 (Small),36:36 (Average),42:42 (Large),48:48 (Huge),58:58 (Colossal),66:66 (Gargantuan),75:75 (Transcendent)"),
      tooltip = _("Fine tune lower limit when Level Size is set to Episodic, Progressive or Mixed."),
      priority = 98,
      gap = 1,
    },


    {
      name = "level_size_ramp_factor",
      label = _("Ramp Factor"),
      tooltip = _("Determines how fast or slow larger level sizes are reached in Progressive/Episodic mode."),
      longtip = _("Very Fast Curve: Reach half-size at 1/4th of the game.\nFast Curve: Reach half-size at 1/3rds.\nLinear: Reach half-size at half the game.\nSlow Curve: Reach half-size at 2/3rds.\nVery Slow Curve: Reach half-size at 3/4ths.\n\nObsidian default is Fast Curve."),
      choices = UI_ARCH.RAMP_FACTOR,
      default = "0.66",
      priority = 97,
      randomize_group="architecture",
      
    },


    {
      name = "level_size_bias",
      label = _("Level Size Bias"),
      tooltip = _("Alters probability skew when using Mix It Up for level sizes."),
      longtip = _("DEFAULT is a normal curve where Average is the most common size while smaller or larger sizes become rarer.\n\nCombine with Level Upper and Lower Bounds for greater control."),
      choices = UI_ARCH.SIZE_BIAS,
      default = "default",
      priority = 96,
      randomize_group="architecture",
      
    },


    {
      name = "mixin_type",
      label = _("Theme Mix-in Type"),
      tooltip = _("Occasionally mix-in themes other than the selected one."),
      longtip = _("This replaces the legacy \"-ish\" theme choices. By selecting Mostly Selected Theme, this means your selected theme is occasionally littered by other themes while setting it to Mostly Other Themes means the original selected theme is what's littered in instead. Default behavior is None."),
      choices = UI_ARCH.MIXIN_CHOICES,
      default = "none",
      priority = 88,
      gap = 1,
      randomize_group="architecture",
      
    },
  

    {
      name="bool_prebuilt_levels",
      label=_("Prebuilt Levels"),
      valuator = "button",
      default = 1,
      tooltip = _("Enable or disable prebuilt maps. When disabled, are replaced with generated maps instead."),
      longtip = _("Prebuilt levels are useful when, for example, a boss encounter like the Icon of Sin is desired. This sort of level would be very difficult to generate procedurally, and thus a handmade map is used instead."),
      priority = 81,
      gap = 1
    },

    {
      name = "float_overall_lighting_mult",
      label = _("Lighting Multiplier"),
      valuator = "slider",
      units = _("x"),
      min = 0.5,
      max = 1.5,
      increment = .05,
      default = 1.0,
      priority = 80,
      randomize_group="architecture",
      tooltip = _("Adjust overall map lighting"),
      longtip = _("This will apply a multiplier to the values in the default lighting tables when determining the brightness level of a room. If control over the minimum or maximum brightness values is desired, please use the Minimum/Maximum Brightness sliders in the Advanced Architecture module.")
    },

    { name="outdoors",     
    label=_("Outdoors"),   choices=STYLE_CHOICES, priority = 78, randomize_group="architecture", 
    tooltip = _("Control the number of outdoor areas.")
    },
    { name="caves",        
    label=_("Caves"),      choices=STYLE_CHOICES, priority = 77, randomize_group="architecture", 
    tooltip = _("Control the number of caves.") 
    },
    { name="liquids",      
    label=_("Liquids"),    choices=STYLE_CHOICES, priority = 76, randomize_group="architecture", 
    tooltip = _("Control the amount of liquids.") 
    },
    { name="hallways",     
    label=_("Hallways"),   choices=STYLE_CHOICES, priority = 75, randomize_group="architecture", 
    tooltip = _("Control the number of hallways.")
    },
    { name="teleporters",  
    label=_("Teleports"),  choices=STYLE_CHOICES, priority = 74, randomize_group="architecture", 
    tooltip = _("Control the number of teleporters.") 
    },
    {
      name="bool_allow_teleporter_emergency_breaks",
      label=_("Teleporter Emergency Breaks"),
      valuator = "button",
      default = 1,
      tooltip = _("Allow/disallow teleporter emergency breaks."),
      longtip = _("Teleporters are sometimes used when performing an emergency room break in order to continue level growth. With this setting disabled, teleports will never be used in an emergency break. This could result in truncated level growth or, in the worst case, a script error."),
      priority = 81,
      gap = 1,
      
    },
    { name="steepness",    
    label=_("Steepness"),  choices=STYLE_CHOICES, gap=1, priority = 73, randomize_group="architecture", 
    tooltip = _("Control the height difference of stairs, lifts, and joiners throughout levels.") 
    },


    {
      name = "zdoom_vista",
      label = _("Bottomless Vistas"),
      choices=UI_ARCH.ZDOOM_VISTA_CHOICES,
      default="disable",
      tooltip = _("This feature allows for vistas that show more of the skybox below the horizon. This does not prevent skybox tiling."),
      longtip = _("Enable - Bottomless vistas can always show. Pick this choice when using 3D Skyboxes.\n\nSky-gen Smart - Bottomless vistas appear only on episodes with no mountain backdrop based on the Sky Generator.\n\nDisable - Old Oblige behavior - no bottomless vistas."),
      priority = 50
    },


    {
      name = "zdoom_skybox",
      label = _("3D Skyboxes"),
      choices=UI_ARCH.ZDOOM_SKYBOX_CHOICES,
      default="disable",
      tooltip = _("Choose if 3D Skyboxes are rendered into levels and their style."),
      longtip = _("This is highly recommended when Bottomless Vistas are enabled."),
      priority = 49
    }
  },
}

-- WOLF 3D ENGINE MODULE

UI_ARCH_WOLF_3D = { }

UI_ARCH_WOLF_3D.RAMP_FACTOR =
{
  "0.5",  _("Very Fast Curve"),
  "0.66", _("Fast Curve"),
  "1",    _("Linear"),
  "1.5",  _("Slow Curve"),
  "2",    _("Very Slow Curve"),
}

UI_ARCH_WOLF_3D.SIZE_BIAS =
{
  "small",   _("Smaller"),
  "default", _("DEFAULT"),
  "large",   _("Larger"),
}

function UI_ARCH_WOLF_3D.setup(self)

  module_param_up(self)

end

OB_MODULES["ui_arch_wolf_3d"] =
{
  name = "ui_arch_wolf_3d",

  label = _("Architecture"),
    
  -- color = { red = 125, green = 125, blue = 125 }, -- This is an example of setting a custom per-module color - Dasho

  side = "left",
  priority = 104,
  engine = "idtech_0",
  where = "arch",

  hooks = 
  {
    setup = UI_ARCH_WOLF_3D.setup,
  },

  options =
  {

    { 
      name="float_size_wolf_3d", 
      label=_("Level Size"),
      valuator = "slider",
      min = 10,
      max = 75,
      increment = 1,
      default = 36,
      nan = _("Mix It Up,Episodic,Progressive"),
      presets = _("10:10 (Microscopic),16:16 (Miniature),22:22 (Tiny),30:30 (Small),36:36 (Average),42:42 (Large),48:48 (Huge),58:58 (Colossal),66:66 (Gargantuan),75:75 (Transcendent)"),
      tooltip = _("Determines size of map (Width x Height) in grid squares."),
      longtip = _("If you are planning to generate Binary format maps at sizes of 50 and above, Autodetailing will be enabled by default. The stability of maps with sizes 60 and beyond is not predictable unless using UDMF map format (supported engines only)."),
      priority = 100,
      randomize_group="architecture"
    },


    {
      name = "float_level_upper_bound_wolf_3d",
      label = _("Upper Bound"),
      valuator = "slider",
      min = 10,
      max = 75,
      increment = 1,
      default = 75,
      presets = _("10:10 (Microscopic),16:16 (Miniature),22:22 (Tiny),30:30 (Small),36:36 (Average),42:42 (Large),48:48 (Huge),58:58 (Colossal),66:66 (Gargantuan),75:75 (Transcendent)"),
      tooltip = _("Fine tune upper limit when Level Size is set to Episodic, Progressive or Mixed."),
      priority = 99,
    },


    {
      name = "float_level_lower_bound_wolf_3d",
      label = _("Lower Bound"),
      valuator = "slider",
      min = 10,
      max = 75,
      increment = 1,
      default = 10,
      presets = _("10:10 (Microscopic),16:16 (Miniature),22:22 (Tiny),30:30 (Small),36:36 (Average),42:42 (Large),48:48 (Huge),58:58 (Colossal),66:66 (Gargantuan),75:75 (Transcendent)"),
      tooltip = _("Fine tune lower limit when Level Size is set to Episodic, Progressive or Mixed."),
      priority = 98,
      gap = 1,
    },


    {
      name = "level_size_ramp_factor_wolf_3d",
      label = _("Ramp Factor"),
      tooltip = _("Determines how fast or slow larger level sizes are reached in Progressive/Episodic mode."),
      longtip = _("Very Fast Curve: Reach half-size at 1/4th of the game.\nFast Curve: Reach half-size at 1/3rds.\nLinear: Reach half-size at half the game.\nSlow Curve: Reach half-size at 2/3rds.\nVery Slow Curve: Reach half-size at 3/4ths.\n\nObsidian default is Fast Curve."),
      choices = UI_ARCH_WOLF_3D.RAMP_FACTOR,
      default = "0.66",
      priority = 97,
      randomize_group="architecture"
    },


    {
      name = "level_size_bias_wolf_3d",
      label = _("Level Size Bias"),
      tooltip = _("Alters probability skew when using Mix It Up for level sizes."),
      longtip = _("DEFAULT is a normal curve where Average is the most common size while smaller or larger sizes become rarer.\n\nCombine with Level Upper and Lower Bounds for greater control."),
      choices = UI_ARCH_WOLF_3D.SIZE_BIAS,
      default = "default",
      priority = 96,
      randomize_group="architecture"
    },
  },
}