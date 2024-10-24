------------------------------------------------------------------------
--  HERETIC THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
--  Adapted for Heretic by Dashodanger
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.SINKS =
{
  -- sky holes --

  sky_plain =
  {
    mat   = "_SKY",
    dz    = 64,
    light = 16,
  },

-- sky ceilings

  sky_ceiling =
  {
    mat   = "_SKY",
    dz    = 48,
    light = 16,

    trim_mat = "_WALL",
    trim_dz  = -9,
    trim_light = 16,
  },

  -- liquid floor --

  liquid_plain =
  {
    mat = "_LIQUID",
    dz  = -12,
  },

  liquid_trim =
  {
    mat   = "_LIQUID",
    dz    = -16,

    trim_mat = "_WALL",
    trim_dz  = -8,
  },

  -- ceiling lights --


  light_plain =
  {
    mat = "_FLOOR",
    dz  = 8,
    light = 32,

    trim_mat = "_WALL",
    trim_dz  = -5,
    trim_light = 16,
  },

-- plain ceilings

  ceiling_plain =
  {
    mat   = "_CEIL",
    dz    = 64,
    light = 16,
  },

-- plain floors

  floor_plain =
  {
    mat = "_FLOOR",
    dz = -16,
    light = 32,

    trim_mat = "_WALL",
    trim_dz = -8,
  },

  -- fantastic floors

  floor_trim_sky =
  {
    mat = "_FLOOR",

    trim_mat = "_SKY",
    trim_dz = -8,
  },

  floor_trim_liquid =
  {
    mat = "_FLOOR",
    dz = -4,

    trim_mat = "_LIQUID",
    trim_dz = -8,
  },

  floor_mixup =
  {
    mat = "_CEIL",
    dz = -8,

    trim_mat = "_WALL",
    trim_dz = -4,
  },

  -- street sink def, do not use for anything else
  floor_default_streets =
  {
    mat = "FLOOR30",
    dz = 2,

    trim_mat = "FLOOR10",
    trim_dz = 2,
  }
}


HERETIC.THEMES =
{
  DEFAULTS =
  {
    -- Note: there is no way to control the order which keys are used

    keys =
    {
      k_yellow = 70,
      k_green  = 50,
      k_blue   = 30,
    },

    barrels =
    {
      barrel = 50,
      pod = 15,
    },

    cave_torches =
    {
      fire_brazier  = 20,
      mercury_lamp  = 10,
    },

    skyboxes =
    {
      -- Heretic needs a 3D skybox, bois
    },

    cage_lights = { 0, 8, 12, 13 },

    pool_depth = 24,

    street_sinks =
    {
      floor_default_streets = 1
    },

    streets_friendly = false,

    slump_config = 
    [[
      ;
      ; Sample SLIGE config file. (Semicolon starts a comment to end of line.)
      ;
      ; This is the SLIGE.CFG as shipped with SLIGE itself.  It contains a
      ; description of the default SLIGE configuration, as hardwired into
      ; the program.  So having this file in the current directory under the
      ; name SLIGE.CFG should produce exactly the same effect as not having
      ; any config file at all.  You can use this file as a base to build
      ; your own config files on (but if you do, you should change these
      ; comments; otherwise they'll be WRONG!).
      ;
      ; Dave Chess, dmchess@aol.com, chess@us.ibm.com

      ; The current implementation ignores everything before the
      ; [THEMES] line also, but that will change.

      [THEMES]        ; Anything after a ; is, remember, a comment

      ; We have three themes, one secret.  They should all be declared
      ; before any textures or flats or anything else.  The only valid
      ; modifier is "secret", which says that that theme should only be
      ; used on secret levels.  There should be at least one "secret"
      ; theme.

      Theme CST ; Castle
      Theme BLU secret

      ; Flats and textures and constructs and stuff are also in the [THEMES] section

      ; Textures are described by "Texture NAME <attributes>".  Obvious
      ; attributes include "wall", "door", and so on.  Some subtler ones:
      ;
      ; "core <theme>" means that this texture should be common in that theme.
      ; "comp <theme>" means that this texture is compatible with that theme, but
      ;    not to be used all that often.
      ; "switch <texture>" means "the given texture is a good switch to use in
      ;    a room that has walls of the current texture"
      ; "isswitch" means "the current texture is a good switch to use on any
      ;    wall in a room with a compatible theme"
      ; "subtle <texture>" means "the given texture is a subtle variant of the
      ;    current texture, suitable for hinting at secrets"
      ; "yhint N" means "when using a vertical misalignment to hint at
      ;    a secret door in a wall of this texture, use a y-offset of N".  If
      ;    N is zero, it means "this wall is too visually complex to hint via a
      ;    y-misalignment at all; hint some other way".  If no "yhint" is given,
      ;    the value 5 is used.
      ;  "noDoom2" means that the texture does not exist in the usual DOOM II
      ;    IWAD.  "noDoom0" means it doesn't exist in the DOOM 1.2 IWAD, and
      ;    "noDoom1" means it's not in the DOOM 1.666 or 1.89 IWAD.  If none
      ;    of these are specified, the texture is assumed to be in all.
      ;  "size <width> <height>" gives the size of the texture.  You can leave
      ;    this out if the height is 128, and the width is some reasonable
      ;    divisor of 256 (except for doors, where you should give the real
      ;    width so SLIGE can make them look nice).

      ; Castle walls
      Texture CSTLRCK size 64 128 wall core CST subtle CSTLMOSS
      Texture GRSTNPB size 64 128 wall comp CST

      ; Heretic only has two switches so make them generic to every theme
      Texture SW1OFF size 64 128 ybias 100 isswitch comp CST comp BLU
      Texture SW2OFF size 64 128 ybias 100 isswitch comp CST comp BLU

      ; And the lift texture
      Texture METL2 size 64 128 lift comp CST comp BLU

      ; BLU walls
      Texture MOSAIC1 size 64 128 wall core BLU subtle MOSAIC2
      Texture MOSAIC3 size 64 128 wall comp BLU subtle MOSAIC2

      ; Doors of all kinds.  "size" gives the width and height of the texture,
      ; and "locked" means that it's a good texture to use on a door that only
      ; opens with a switch, not a touch.
      Texture DOORSTON size 64 128 door comp CST comp BLU
      Texture DOORWOOD size 128 128 door comp CST comp BLU

      ; Heretic only has two switches so make them the exit switches as well
      Texture SW1OFF size 64 128 exitswitch comp CST comp BLU
      Texture SW2OFF size 64 128 exitswitch comp CST comp BLU

      ; Lights, suitable for lighting recesses and stuff.
      Texture WATRWAL1 size 8 128 light comp BLU

      ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
      ; "vtiles" means that it's OK to pile one on top of another, as when
      ;    making the big central pillar in an arena.
      ; "half_plaque" means that the upper half of this texture can be used
      ;    by itself, as well as the whole thing.
      Texture BANNER1 size 64 128 plaque comp CST
      Texture BANNER2 size 64 128 plaque comp CST
      Texture GRSTNPBV size 64 128 plaque comp CST
      Texture GRSTNPBW size 64 128 plaque comp CST
      Texture MOSAIC4 size 64 128 plaque comp BLU
      Texture MOSAIC5 size 64 128 plaque comp BLU

      ; Gratings
      Texture GATMETL2 size 64 32 grating comp CST comp BLU
      Texture GATMETL3 size 64 32 grating comp CST comp BLU
      Texture GATMETL4 size 64 64 grating comp CST comp BLU
      Texture GATMETL5 size 64 128 grating comp CST comp BLU

      ; Colors (suitable for marking key-locked things)
      ; We use the 'red' keyword for Heretic's Green Key
      Texture GRNBLOK1 size 32 128 red comp CST comp BLU 
      Texture DRIPWALL size 32 128 yellow comp CST comp BLU
      Texture BLUEFRAG size 32 128 blue comp CST comp BLU

      ; Step kickplates
      Texture TMBSTON2 size 64 48 step comp CST comp BLU

      ; "Doorjambs"
      Texture METL2 size 16 128 jamb comp CST comp BLU

      ; Support textures, used in various places
      Texture METL1 size 64 128 support comp CST
      Texture WATRWAL1 size 64 128 support comp BLU

      ; Bunch of things for outside patios (no themes applied here)
      Texture MOSSRCK1 size 128 128 outside
      Texture ROOTWALL size 128 128 outside

      ; Misc
      Texture REDWALL size 64 128 error

      ; Now the flats.  Keywords should all be pretty obvious...   *8)

      ; Teleport-gate floors
      Flat FLTTELE1 gate comp CST comp BLU

      ; Floors and ceilings for Castle theme
      Flat FLOOR30 ceiling light comp CST
      Flat FLOOR05 ceiling outside comp CST
      Flat FLAT506 ceiling outside comp CST
      Flat FLOOR03 floor comp CST
      Flat FLOOR03 ceiling comp CST
      Flat FLOOR04 floor comp CST
      Flat FLOOR04 ceiling comp CST
      Flat FLAT523 floor comp CST
      Flat FLAT523 ceiling comp CST
      Flat FLOOR17 floor outside comp CST
      Flat FLAT513 floor outside comp CST

      ; and nukage
      Flat FLTLAVA1 nukage comp CST
      Flat FLTSLUD1 nukage comp CST comp BLU
      Flat FLATHUH1 nukage red comp CST comp BLU

      ; Floors and ceilings for (secret) BLU theme
      Flat FLOOR07 floor comp BLU
      Flat FLOOR07 ceiling comp BLU
      Flat FLAT504 floor comp BLU
      Flat FLAT504 ceiling comp BLU
      Flat FLOOR16 floor comp BLU
      Flat FLOOR16 ceiling comp BLU
      Flat FLTWAWA1 floor outside comp BLU
      Flat FLTWAWA1 ceiling outside comp BLU
      Flat FLAT502 ceiling light comp BLU

      ; Floors for outside areas not yet mentioned
      Flat FLAT506 outside
      Flat FLOOR01 outside

      ; These are the defaults, but we'll list them anyway.
      Flat FLTWAWA1 water
      Flat F_SKY1 sky

      ; Constructs: computers and crates and stuff that stand around in rooms
      ; This is pretty complex!  Fool with it at your peril.

      ; Family 1 is crates of various sizes and kinds
      Construct family 1 height 128 comp CST 
        top FLOOR04
        Primary SAINT1 width 64

      ; Load the hardwired monster and object and so on data (required in
      ; this version of SLIGE; don't remove this!)
      Hardwired1

      ; Say which lamps we like in which themes, and where barrels are allowed
      ; Information like which Doom version each object is in, and which ones
      ; cast light, and which ones explode, is still hardwired.
      Thing 2035 comp CST comp BLU ; pod
      Thing 27  comp CST comp BLU  ; serpent torch
      Thing 76 comp CST comp BLU   ; fire brazier

      ; and that's it!
    ]]
  },


  city =
  {

   style_list =
    {
      caves = { none=60, few=40, some=12, heaps=2 },
      outdoors = { none=10, few=35, some=90, heaps=30 },
      pictures = { few=20, some=80, heaps=30 },
      hallways = { none=30, few=80, some=15, heaps=10 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=30, few=50, some=20, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=25, few=40, some=25, heaps=15 },
      ambushes = { none=5, few=20, some=75, heaps=30 },
      teleporters = { none=20, few=30, some=65, heaps=10 },
      keys = { none=15, few=50, some=50, heaps=20 },
      symmetry = { none=40, few=30, some=35, heaps=25 },
      switches = { none=20, few=60, some=40, heaps=10 },
      secrets = { few=5, some=80, heaps=25 },
      traps   = { none=10, few=40, some=70, heaps=25 },
      barrels = { none=10, few=50, some=20, heaps=5 },
    },

    liquids =
    {
      water2 = 40,
      water  = 50,
      lava   = 10,
      sludge = 15,
      magma  = 10,
    },

    narrow_halls =
    {
      vent = 50,
    },

    wide_halls =
    {
      deuce = 50,
    },

    floor_sinks =
    {
      floor_plain = 50,
      liquid_plain = 40,
      liquid_trim = 40,
      floor_trim_sky = 5,
      floor_trim_liquid = 5,
      floor_mixup = 5,
    },

    ceiling_sinks =
    {
      ceiling_plain = 50,
      --sky_plain = 50,
      --sky_ceiling = 50,
      light_plain = 25,
    },

    fences =
    {
      CSTLRCK = 80,
      GRSTNPB = 40,
    },

    cage_mats =
    {
      CSTLRCK = 80,
      GRSTNPB = 40,
    },

    facades =
    {
      GRSTNPB = 50,
      GRSTNPBV = 15,
      CSTLRCK = 40,
      CTYSTUC4 = 15,
      SPINE2 = 5,
    },

    fence_groups =
    {
      PLAIN = 50,
    },

    fence_posts =
    {
      Post = 50,
    },

    beam_groups =
    {
      beam_metal = 50,
    },

    window_groups = 
    {
      square = 40,
      tall   = 80,
    },

    wall_groups =
    {
      PLAIN = 50,
      torches1 = 12,
    },

    cliff_trees =
    {
      stal_small_F = 50,
      stal_big_F = 25,
      volcano = 5,
      pod = 25
    },

    park_decor =
    {
      stal_small_F = 50,
      stal_big_F = 25,
      fire_brazier = 5,
      pod = 25
    },

    outdoor_torches =
    {
      fire_brazier   = 10,
      mercury_lamp  = 40,
    },

--    ceil_light_prob = 70,

    scenic_fences =
    {
      WDGAT64 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    skyboxes =
    {
      Skybox_city_skybox = 50,
    },

    steps_mat = "CSTLRCK",

    post_mat  = "WOODWL",

    streets_friendly = true

  },

  maw =
  {

   style_list =
    {
      caves = { none=60, few=40, some=12, heaps=2 },
      outdoors = { none=10, few=35, some=90, heaps=30 },
      pictures = { few=20, some=80, heaps=30 },
      hallways = { none=30, few=80, some=15, heaps=10 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=30, few=50, some=20, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=25, few=40, some=25, heaps=15 },
      ambushes = { none=5, few=20, some=75, heaps=30 },
      teleporters = { none=20, few=30, some=65, heaps=10 },
      keys = { none=15, few=50, some=50, heaps=20 },
      symmetry = { none=40, few=30, some=35, heaps=25 },
      switches = { none=20, few=60, some=40, heaps=10 },
      secrets = { few=5, some=80, heaps=25 },
      traps   = { none=10, few=40, some=70, heaps=25 },
      barrels = { none=10, few=50, some=20, heaps=5 },
    },

    liquids =
    {
      lava   = 30,
      magma  = 10,
    },

    narrow_halls =
    {
      vent = 50,
    },

    wide_halls =
    {
      deuce = 50,
    },

    floor_sinks =
    {
      floor_plain = 50,
      liquid_plain = 40,
      liquid_trim = 40,
      floor_trim_sky = 5,
      floor_trim_liquid = 5,
      floor_mixup = 5,
    },

    ceiling_sinks =
    {
      ceiling_plain = 50,
      --sky_plain = 50,
      --sky_ceiling = 50,
      light_plain = 25,
    },

    fences =
    {
      LOOSERCK = 80,
    },

    cage_mats =
    {
      LOOSERCK = 80,
    },

    facades =
    {
      LOOSERCK = 80,
    },

    fence_groups =
    {
      PLAIN = 50,
    },

    fence_posts =
    {
      Post = 50,
    },

    beam_groups =
    {
      beam_metal = 50,
    },

    window_groups = 
    {
      square = 40,
      tall   = 80,
    },

    wall_groups =
    {
      PLAIN = 50,
      torches1 = 12,
    },

    cliff_trees =
    {
      stal_small_F = 50,
      stal_big_F = 25,
      volcano = 5,
      pod = 25
    },

    park_decor =
    {
      stal_small_F = 50,
      stal_big_F = 25,
      fire_brazier = 5,
      pod = 25
    },

    outdoor_torches =
    {
      fire_brazier   = 10,
      mercury_lamp  = 40,
    },

--    ceil_light_prob = 70,

    scenic_fences =
    {
      GATMETL2 = 50,
      GATMETL3 = 50,
      GATMETL4 = 50,
      GATMETL5 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    skyboxes =
    {
      Skybox_maw_skybox = 50,
    },

    steps_mat = "SQPEB1",

    post_mat  = "SQPEB1",

  },

  dome =
  {

   style_list =
    {
      caves = { none=60, few=40, some=12, heaps=2 },
      outdoors = { none=10, few=35, some=90, heaps=30 },
      pictures = { few=20, some=80, heaps=30 },
      hallways = { none=30, few=80, some=15, heaps=10 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=30, few=50, some=20, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=25, few=40, some=25, heaps=15 },
      ambushes = { none=5, few=20, some=75, heaps=30 },
      teleporters = { none=20, few=30, some=65, heaps=10 },
      keys = { none=15, few=50, some=50, heaps=20 },
      symmetry = { none=40, few=30, some=35, heaps=25 },
      switches = { none=20, few=60, some=40, heaps=10 },
      secrets = { few=5, some=80, heaps=25 },
      traps   = { none=10, few=40, some=70, heaps=25 },
      barrels = { none=10, few=50, some=20, heaps=5 },
    },

    liquids =
    {
      water2 = 40,
      water  = 50,
    },

    narrow_halls =
    {
      vent = 50,
    },

    wide_halls =
    {
      deuce = 50,
    },

    floor_sinks =
    {
      floor_plain = 50,
      liquid_plain = 40,
      liquid_trim = 40,
      floor_trim_sky = 5,
      floor_trim_liquid = 5,
      floor_mixup = 5,
    },

    ceiling_sinks =
    {
      ceiling_plain = 50,
      --sky_plain = 50,
      --sky_ceiling = 50,
      light_plain = 25,
    },

    fences =
    {
      GRSTNPB = 80,
      BRWNRCKS = 40,
    },

    cage_mats =
    {
      GRSTNPB = 80,
      BRWNRCKS = 40,
    },

    facades =
    {
      GRSTNPB = 50,
      ROOTWALL = 50,
      CSTLRCK = 50,
      BRWNRCKS = 50,
    },

    fence_groups =
    {
      PLAIN = 50,
    },

    fence_posts =
    {
      Post = 50,
    },

    beam_groups =
    {
      beam_metal = 50,
    },

    window_groups = 
    {
      square = 40,
      tall   = 80,
    },

    wall_groups =
    {
      PLAIN = 50,
      torches1 = 12,
    },

    outdoor_torches =
    {
      fire_brazier   = 10,
      mercury_lamp  = 40,
    },

--    ceil_light_prob = 70,

    scenic_fences =
    {
      GATMETL2 = 50,
      GATMETL3 = 50,
      GATMETL4 = 50,
      GATMETL5 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    steps_mat = "GRSTNPB",

    post_mat  = "WOODWL",

  },

   ossuary =
  {

   style_list =
    {
      caves = { none=60, few=40, some=12, heaps=2 },
      outdoors = { none=10, few=35, some=90, heaps=30 },
      pictures = { few=20, some=80, heaps=30 },
      hallways = { none=30, few=80, some=15, heaps=10 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=30, few=50, some=20, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=25, few=40, some=25, heaps=15 },
      ambushes = { none=5, few=20, some=75, heaps=30 },
      teleporters = { none=20, few=30, some=65, heaps=10 },
      keys = { none=15, few=50, some=50, heaps=20 },
      symmetry = { none=40, few=30, some=35, heaps=25 },
      switches = { none=20, few=60, some=40, heaps=10 },
      secrets = { few=5, some=80, heaps=25 },
      traps   = { none=10, few=40, some=70, heaps=25 },
      barrels = { none=10, few=50, some=20, heaps=5 },
    },

    liquids =
    {
      water2 = 40,
      water  = 50,
    },

    narrow_halls =
    {
      vent = 50,
    },

    wide_halls =
    {
      deuce = 50,
    },

    floor_sinks =
    {
      floor_plain = 50,
      liquid_plain = 40,
      liquid_trim = 40,
      floor_trim_sky = 5,
      floor_trim_liquid = 5,
      floor_mixup = 5,
    },

    ceiling_sinks =
    {
      ceiling_plain = 50,
      --sky_plain = 50,
      --sky_ceiling = 50,
      light_plain = 25,
    },

    fences =
    {
      CSTLRCK = 40,
    },

    cage_mats =
    {
      CSTLRCK = 40,
    },

    facades =
    {
      CSTLMOSS = 50,
      SNDBLCKS = 25,
      CSTLRCK = 40,
      CHAINSD = 15,
      LOOSERCK = 30,
      GRNBLOK1 = 10,
    },

    fence_groups =
    {
      PLAIN = 50,
    },

    fence_posts =
    {
      Post = 50,
    },

    beam_groups =
    {
      beam_metal = 50,
    },

    window_groups = 
    {
      square = 40,
      tall   = 80,
    },

    wall_groups =
    {
      PLAIN = 50,
      torches1 = 12,
    },

    cliff_trees =
    {
      stal_small_F = 50,
      stal_big_F = 25,
      volcano = 5,
      pod = 25
    },

    park_decor =
    {
      stal_small_F = 50,
      stal_big_F = 25,
      fire_brazier = 5,
      pod = 25
    },

    outdoor_torches =
    {
      fire_brazier   = 10,
      mercury_lamp  = 40,
    },

--    ceil_light_prob = 70,

    scenic_fences =
    {
      WDGAT64 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    steps_mat = "SQPEB2",

    post_mat  = "WOODWL",

  },


  demense =
  {

   style_list =
    {
      caves = { none=60, few=40, some=12, heaps=2 },
      outdoors = { none=10, few=35, some=90, heaps=30 },
      pictures = { few=20, some=80, heaps=30 },
      hallways = { none=30, few=80, some=15, heaps=10 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=30, few=50, some=20, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=25, few=40, some=25, heaps=15 },
      ambushes = { none=5, few=20, some=75, heaps=30 },
      teleporters = { none=20, few=30, some=65, heaps=10 },
      keys = { none=15, few=50, some=50, heaps=20 },
      symmetry = { none=40, few=30, some=35, heaps=25 },
      switches = { none=20, few=60, some=40, heaps=10 },
      secrets = { few=5, some=80, heaps=25 },
      traps   = { none=10, few=40, some=70, heaps=25 },
      barrels = { none=10, few=50, some=20, heaps=5 },
    },

    liquids =
    {
      sludge = 50,
    },

    narrow_halls =
    {
      vent = 50,
    },

    wide_halls =
    {
      deuce = 50,
    },

    floor_sinks =
    {
      floor_plain = 50,
      liquid_plain = 40,
      liquid_trim = 40,
      floor_trim_sky = 5,
      floor_trim_liquid = 5,
      floor_mixup = 5,
    },

    ceiling_sinks =
    {
      ceiling_plain = 50,
      --sky_plain = 50,
      --sky_ceiling = 50,
      light_plain = 25,
    },

    fences =
    {
      SQPEB1 = 20,
      GRSTNPB = 20,
    },

    cage_mats =
    {
      SQPEB1 = 20,
      GRSTNPB = 20,
    },

    facades =
    {
      RCKSNMUD = 40,
      BRWNRCKS = 30,
      TRISTON1 = 20,
      LOOSERCK = 40,
      SNDBLCKS = 30,
      CSTLRCK = 20,
      GRSTNPB = 20,
      METL2 = 10,
      SQPEB1 = 20,
      TRISTON2 = 10,
    },

    fence_groups =
    {
      PLAIN = 50,
    },

    fence_posts =
    {
      Post = 50,
    },

    beam_groups =
    {
      beam_metal = 50,
    },

    window_groups = 
    {
      square = 40,
      tall   = 80,
    },

    wall_groups =
    {
      PLAIN = 50,
      torches1 = 12,
    },

    cliff_trees =
    {
      stal_small_F = 50,
      stal_big_F = 25,
      volcano = 5,
      pod = 25
    },

    park_decor =
    {
      stal_small_F = 50,
      stal_big_F = 25,
      fire_brazier = 5,
      pod = 25
    },

    outdoor_torches =
    {
      fire_brazier   = 10,
      mercury_lamp  = 40,
    },

--    ceil_light_prob = 70,

    scenic_fences =
    {
      WDGAT64 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    skyboxes =
    {
      Skybox_demense_skybox = 50,
    },

    steps_mat = "SQPEB1",

    post_mat  = "WOODWL",

  },

}


HERETIC.ROOM_THEMES =
{

  ---- CITY THEME --------------------------------
  -- Combos observed during Episode 1,


  city_Floor03_Floor04 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 20,
      WOODWL = 15,
      SKULLSB1 = 5,
    },

    floors =
    {
      FLOOR03 = 50,
      FLOOR04 = 25,
    },

    ceilings =
    {
      FLOOR03 = 50,
      FLOOR04 = 25,
    },
  },

    city_Floor10_Floor12 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
      WOODWL = 25,
      CTYSTCI2 = 10,
      CTYSTUC4 = 10,
    },

    floors =
    {
      FLOOR10 = 50,
    },

    ceilings =
    {
      FLOOR12 = 50,
    },
  },

  city_Floor06_Floor11 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SNDBLCKS = 50,
      SANDSQ2 = 50,
    },

    floors =
    {
      FLOOR06 = 50,
    },

    ceilings =
    {
      FLOOR11 = 50,
    },
  },

  city_Floor04_Floor19 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SKULLSB1 = 50,
      CHAINSD = 50,
      SANDSQ2 = 25,
    },

    floors =
    {
      FLOOR19 = 50,
      FLOOR04 = 25,
    },

    ceilings =
    {
      FLOOR04 = 50,
      FLOOR19 = 25,
    },
  },

  city_Grstnpb_Misc =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLOOR10 = 50,
      FLOOR00 = 25,
      FLOOR04 = 25,
      METL1 = 15,
    },

    ceilings =
    {
      FLOOR00 = 50,
      FLOOR19 = 25,
      FLOOR03 = 25,
    },
  },

  city_Sndblcks_Misc =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SNDBLCKS = 50,
    },

    floors =
    {
      METL1 = 15,
      FLOOR06 = 50,
    },

    ceilings =
    {
      FLOOR11 = 50,
      FLOOR25 = 50,
    },
  },

  city_Grstnpbv_Misc =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPBV = 50,
    },

    floors =
    {
      FLOOR06 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
    },
  },

  city_Spine2_Misc =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SPINE2 = 50,
    },

    floors =
    {
      FLOOR04 = 50,
    },

    ceilings =
    {
      FLOOR25 = 50,
    },
  },

  city_deuce_Hallway_Floor03 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 50,
      WOODWL = 20,
    },

    floors =
    {
      FLOOR03 = 50,
    },

    ceilings =
    {
      FLOOR03 = 50,
    },

  },

  city_vent_Hallway_Floor03 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 50,
      WOODWL = 20,
    },

    floors =
    {
      FLOOR03 = 50,
    },

    ceilings =
    {
      FLOOR03 = 50,
    },

  },

  city_deuce_Hallway_Floor04 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 50,
    },

    floors =
    {
      FLOOR04 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
    },

  },

  city_vent_Hallway_Floor04 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 50,
    },

    floors =
    {
      FLOOR04 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
    },

  },

  city_deuce_Hallway_Sndchnks =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 15,

    walls =
    {
      SNDCHNKS = 50,
    },

    floors =
    {
      FLOOR06 = 50,
    },

    ceilings =
    {
      FLOOR06 = 20,
    },

  },

  city_vent_Hallway_Sndcnks =
  {
    env   = "hallway",
    group = "vent",
    prob  = 15,

    walls =
    {
      SNDCHNKS = 50,
    },

    floors =
    {
      FLOOR06 = 50,
    },

    ceilings =
    {
      FLOOR06 = 20,
    },

  },

  city_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLOOR00 = 50,
      FLOOR04 = 50,
      FLOOR01 = 50,
      FLOOR10 = 50,
    },

    naturals =
    {
      FLOOR17 = 50,
    },

    porch_floors =
    {
      FLOOR00 = 50,
      FLOOR04 = 50,
      FLOOR01 = 50,
      FLOOR10 = 50,
      FLOOR19 = 10,
    },

  },

  --------- MAW THEME -------------
  -- Combos observed during Episode 2,

  maw_Looserck =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      LOOSERCK = 50,
    },

    floors =
    {
      FLAT516 = 50,
      FLAT510 = 50,
      FLOOR04 = 50,
      FLOOR01 = 50,
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT509 = 50,
      FLOOR01 = 50,
      FLAT510 = 50,
    },

  },

  maw_Misc =
  {
    env  = "building",
    prob = 15,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 25,
    },

    floors =
    {
      FLOOR04 = 50,
      FLAT510 = 50,
    },

    ceilings =
    {
      FLAT509 = 50,
      FLOOR04 = 50,
    },

  },

  maw_deuce_Hallway_Looserck =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      LOOSERCK = 50,
    },

    floors =
    {
      FLAT516 = 50,
    },

    ceilings =
    {
      FLAT509 = 50,
    },

  },

  maw_vent_Hallway_Looserck =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      LOOSERCK = 50,
    },

    floors =
    {
      FLAT516 = 50,
    },

    ceilings =
    {
      FLAT509 = 50,
    },

  },

  maw_deuce_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 25,
    },

    floors =
    {
      FLOOR04 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
    },

  },

  maw_vent_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 25,
    },

    floors =
    {
      FLOOR04 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
    },

  },

  maw_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLAT516 = 20,
    },

    naturals =
    {
      FLAT516 = 20,
    },

    porch_floors =
    {
      FLOOR04 = 20,
      FLOOR01 = 20,
      FLAT503 = 20,
      FLAT521 = 20,
    },

  },

  --------- DOME THEME -------------
  -- Combos observed during Episode 3,


  dome_Grstnpb =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT503 = 50,
      FLAT523 = 50,
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
      FLOOR27 = 50,
      FLAT521 = 50,
    },

  },

  dome_Grnblok1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRNBLOK1 = 50,
    },

    floors =
    {
      FLAT522 = 50,
      FLAT503 = 50,
    },

    ceilings =
    {
      FLAT520 = 50,
      FLAT522 = 50,
      FLAT506 = 50,
    },

  },

  dome_Cstlrck =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      CSTLRCK = 50,
    },

    floors =
    {
      FLOOR04 = 50,
      FLOOR27 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
      FLAT504 = 50,
    },

  },

  dome_Spine2_Sndplain =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SPINE2 = 50,
      SNDPLAIN = 25,
    },

    floors =
    {
      FLAT522 = 50,
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
      FLOOR01 = 50,
      FLAT521 = 50,
    },

  },

  dome_Triston1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      TRISTON1 = 50,
    },

    floors =
    {
      FLAT507 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT508 = 50,
      FLAT521 = 50,
    },

  },

  dome_Mosaic =
  {
    env  = "building",
    prob = 15,

    walls =
    {
      MOSAIC1 = 50,
      MOSAIC3 = 50,
    },

    floors =
    {
      FLAT504 = 50,
      FLAT502 = 50,
      FLOOR04 = 50,
      FLAT517 = 5,
    },

    ceilings =
    {
      FLAT502 = 50,
      FLAT504 = 50,
      FLOOR07 = 50,
    },

  },

  dome_deuce_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT503 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
      FLOOR27 = 50,
    },

  },

  dome_vent_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT503 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
      FLOOR27 = 50,
    },

  },

  dome_deuce_Hallway_Grnblok1 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 25,

    walls =
    {
      GRNBLOK1 = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
    },

  },

  dome_vent_Hallway_Grnblok1 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 25,

    walls =
    {
      GRNBLOK1 = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
    },

  },

  dome_deuce_Hallway_Sndplain =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 25,

    walls =
    {
      SNDPLAIN = 50,
    },

    floors =
    {
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT521 = 50,
    },

  },

  dome_vent_Hallway_Sndplain =
  {
    env   = "hallway",
    group = "vent",
    prob  = 25,

    walls =
    {
      SNDPLAIN = 50,
    },

    floors =
    {
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT521 = 50,
    },

  },

  dome_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLAT503 = 20,
      FLAT523 = 20,
      FLOOR04 = 20,
      FLOOR05 = 20,
    },

    naturals =
    {
      FLAT517 = 20,
    },

    porch_floors =
    {
      FLAT503 = 20,
      FLAT523 = 20,
      FLOOR04 = 20,
      FLOOR05 = 20,
    },

  },

------- OSSUARY THEME -------
-- Combos observed during Episode 4,

   ossuary_Grstnpb =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT503 = 50,
      FLAT523 = 50,
      FLOOR10 = 50,
      FLAT521 = 50,
      FLOOR03 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
      FLAT504 = 50,
      FLOOR10 = 50,
      FLOOR03 = 50,
    },

  },

   ossuary_Spine2 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SPINE2 = 50,
    },

    floors =
    {
      FLOOR19 = 50,
      FLOOR25 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
      FLAT523 = 50,
    },

  },

   ossuary_Chainsd =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      CHAINSD = 50,
    },

    floors =
    {
      FLAT503 = 50,
      FLAT504 = 50,
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
      FLAT504 = 50,
    },

  },

   ossuary_Cstlrck =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      CSTLRCK = 50,
    },

    floors =
    {
      FLAT522 = 50,
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT507 = 50,
      FLOOR12 = 50,
    },

  },

   ossuary_Metl2 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      METL2 = 50,
    },

    floors =
    {
      FLOOR28 = 50,
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT512 = 50,
      FLAT504 = 50,
      FLOOR29 = 50,
    },

  },

   ossuary_Grnblok =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRNBLOK1 = 50,
      GRNBLOK2 = 10,
    },

    floors =
    {
      FLOOR25 = 50,
      FLAT521 = 50,
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLAT521 = 50,
      FLAT522 = 50,
    },

  },

   ossuary_Triston2_Sndplain =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      TRISTON2 = 50,
      SNDPLAIN = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT503 = 50,
    },

  },

   ossuary_Triston1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      TRISTON1 = 50,
    },

    floors =
    {
      FLOOR19 = 50,
      FLOOR28 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLOOR28 = 50,
    },

  },

   ossuary_Grstnpbv =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPBV = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLAT504 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT522 = 50,
    },

  },

   ossuary_Metl1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      METL1 = 50,
    },

    floors =
    {
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR29 = 50,
    },

  },

   ossuary_Woodwl =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      WOODWL = 50,
    },

    floors =
    {
      FLOOR10 = 50,
    },

    ceilings =
    {
      FLOOR11 = 50,
    },

  },

  ossuary_deuce_Hallway_Cstlrck =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      CSTLRCK = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
    },

  },

  ossuary_vent_Hallway_Cstlrck =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      CSTLRCK = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
    },

  },

  ossuary_deuce_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT521 = 50,
    },

    ceilings =
    {
      FLOOR19 = 50,
    },

  },

  ossuary_vent_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT521 = 50,
    },

    ceilings =
    {
      FLOOR19 = 50,
    },

  },

  ossuary_deuce_Hallway_Sndplain =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      SNDPLAIN = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
    },

  },

  ossuary_vent_Hallway_Sndplain =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      SNDPLAIN = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
    },

  },

  ossuary_deuce_Hallway_Woodwl =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      WOODWL = 50,
    },

    floors =
    {
      FLOOR10 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR11 = 50,
      FLOOR10 = 50,
    },

  },

  ossuary_vent_Hallway_Woodwl =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      WOODWL = 50,
    },

    floors =
    {
      FLOOR10 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR11 = 50,
      FLOOR10 = 50,
    },

  },

  ossuary_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLOOR18 = 50,
      FLAT522 = 50,
      FLAT523 = 50,
      SQPEB2 = 25,
    },

    naturals =
    {
      FLOOR17 = 50,
    },

    porch_floors =
    {
      FLOOR18 = 50,
      FLAT522 = 50,
      FLAT523 = 50,
      SQPEB2 = 25,
    },

  },


--------- DEMENSE THEME -------------
-- Combos observed during Episode 5,

  demense_Sqpeb2 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SQPEB2 = 50,
    },

    floors =
    {
      FLOOR01 = 50,
      FLOOR05 = 50,
    },

    ceilings =
    {
      FLOOR05 = 50,
    },

  },

  demense_Mossrck1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      MOSSRCK1 = 50,
    },

    floors =
    {
      FLOOR01 = 50,
      FLAT523 = 50,
      FLOOR10 = 50,
    },

    ceilings =
    {
      FLOOR01 = 50,
      FLAT522 = 50,
      FLAT521 = 50,
    },

  },

  demense_Looserck =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      LOOSERCK = 50,
    },

    floors =
    {
      FLOOR03 = 50,
    },

    ceilings =
    {
      FLOOR01 = 50,
      FLOOR03 = 50,
    },

  },

  demense_Sndplain =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SNDPLAIN = 50,
    },

    floors =
    {
      FLOOR06 = 50,
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
    },

  },

  demense_Cstlrck =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      CSTLRCK = 50,
    },

    floors =
    {
      FLAT521 = 50,
      FLAT523 = 50,
      FLOOR19 = 50,
      FLOOR28 = 50,
    },

    ceilings =
    {
      FLAT521 = 50,
      FLAT522 = 50,
      FLOOR04 = 50,
    },

  },

  demense_Grskull_Chainsd =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSKULL1 = 50,
      GRSKULL2 = 50,
      CHAINSD = 50,
    },

    floors =
    {
      FLAT521 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
      FLAT521 = 50,
    },

  },

  demense_Spine2_Sndchnks =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SPINE2 = 50,
      SNDCHNKS = 50,
    },

    floors =
    {
      FLAT522 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLOOR19 = 50,
    },

  },

  demense_Triston1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      TRISTON1 = 50,
    },

    floors =
    {
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLOOR19 = 50,
    },

  },

  demense_Sqpeb1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SQPEB1 = 50,
    },

    floors =
    {
      FLOOR17 = 50,
    },

    ceilings =
    {
      FLOOR27 = 50,
    },

  },

  demense_Grstnpb =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
    },

  },

  demense_deuce_Hallway_Sqpeb1 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      SQPEB1 = 50,
    },

    floors =
    {
      FLOOR17 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR27 = 50,
      FLAT523 = 50,
    },

  },

  demense_vent_Hallway_Sqpeb1 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      SQPEB1 = 50,
    },

    floors =
    {
      FLOOR17 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR27 = 50,
      FLAT523 = 50,
    },

  },

  demense_deuce_Hallway_Sndplain_Sndblcks =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      SNDPLAIN = 50,
      SNDBLCKS = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLOOR06 = 50,
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
      FLAT521 = 50,
    },

  },

  demense_vent_Hallway_Sndplain_Sndblcks =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      SNDPLAIN = 50,
      SNDBLCKS = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLOOR06 = 50,
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
      FLAT521 = 50,
    },

  },

  demense_deuce_Hallway_Metl2 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      METL2 = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLAT522 = 50,
      FLOOR28 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT521 = 50,
    },

  },

  demense_vent_Hallway_Metl2 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      METL2 = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLAT522 = 50,
      FLOOR28 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT521 = 50,
    },

  },

  demense_deuce_Hallway_Cstlrck_Grstnpb =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      CSTLRCK = 50,
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT504 = 50,
    },

  },

  demense_vent_Hallway_Cstlrck_Grstnpb =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      CSTLRCK = 50,
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT504 = 50,
    },

  },

  demense_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLAT513 = 50,
      FLOOR04 = 50,
      FLOOR18 = 50,
      FLAT522 = 50,
      FLOOR05 = 50,
    },

    naturals =
    {
      FLAT513 = 20,
    },

    porch_floors =
    {
      FLOOR19 = 20,
      FLAT523 = 20,
    },

  },


--------- GENERIC ITEMS ----------

  any_Cave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {
      LOOSERCK=20, BRWNRCKS=20, ROOTWALL=20,
    },

    floors =
    {
      FLAT516=20, FLAT506=20, FLOOR01=20,
    },
  },

}

function HERETIC.slump_setup()
  if ob_match_game({game = {heretic=1}}) then
    if OB_CONFIG.theme == "default" then
      PARAM.slump_config = HERETIC.THEMES.DEFAULTS.slump_config
    elseif OB_CONFIG.theme == "jumble" then
      local possible_configs = {}
      for _,tab in pairs(HERETIC.THEMES) do
        if tab.slump_config then
          table.insert(possible_configs, tab.slump_config)
        end
      end
      PARAM.slump_config = rand.pick(possible_configs)
    elseif HERETIC.THEMES[OB_CONFIG.theme].slump_config then
      PARAM.slump_config = HERETIC.THEMES[OB_CONFIG.theme].slump_config
    else
      PARAM.slump_config = HERETIC.THEMES.DEFAULTS.slump_config
    end
  end
end

--------------------------------------------------------------------

HERETIC.TITLE_MAIN_STYLES =
{
  --- Solid styles ---

  solid_blue =
  {
    prob = 25,

    font_mode = "solid",

    font_colors = { "#00f" },

    font_outline_mode = "shadow2",
    font_outlines = { "#00c", "#009", "#006", "#000" },

    narrow = 0.6,

    alt =
    {
      font_mode = "solid",
      font_colors = { "#ccf" },
      font_outline_mode = "zoom",
      font_outlines = { "#77f", "#00f", "#000" },
    },
  },

  solid_red =
  {
    prob = 25,

    font_mode = "solid",

    font_colors = { "#f00" },

    font_outline_mode = "shadow2",
    font_outlines = { "#c00", "#900", "#600", "#000" },

    narrow = 0.6,

    alt =
    {
      font_mode = "solid",
      font_colors = { "#fff" },
      font_outline_mode = "surround",
      font_outlines = { "#f44", "#900", "#000" },
    },
  },

  solid_green =
  {
    prob = 25,

    font_mode = "solid",

    font_colors = { "#0f0" },

    font_outline_mode = "shadow",
    font_outlines = { "#0c0", "#090", "#060", "#000" },

    narrow = 0.4,
  },

  solid_black_lightblue =
  {
    prob = 25,

    font_mode = "solid",

    font_colors = { "#000" },

    font_outlines = { "#009", "#99f", "#ddd" },

    narrow = 0.7,
  },

  shaded_white_n_blue =
  {
    font_mode = "solid",

    font_colors = { "#fff" },

    font_outline_mode = "shadow",
    font_outlines = { "#bbf", "#99f", "#55f", "#22f", "#00f", "#009", "#004", "#000" },

    narrow = 0.4,
  },

  shaded_white_n_red =
  {
    font_mode = "solid",

    font_colors = { "#fff" },

    font_outline_mode = "zoom",
    font_outlines = { "#f99", "#f66", "#e00", "#b00", "#800", "#400", "#000" },

    narrow = 0.4,
  },

  --- Gradient styles ---

  gradient_white_black =
  {
    font_mode = "gradient",

    font_colors = { "#fff", "#000" },

    font_outlines = { "#000", "#555" },
  },

  gradient_green_black =
  {
    font_mode = "gradient",

    font_colors = { "#7e6", "#000" },

    font_outlines = { "#231", "#342" },
  },

  gradient_pink_black =
  {
    font_mode = "gradient3",

    font_colors = { "#c77", "#611", "#000" },

    font_outlines = { "#000", "#933" },
  },

  gradient_black_brown =
  {
    font_mode = "gradient3",

    font_colors = { "#000", "#752", "#fb8" },

    font_outlines = { "#432", "#000" },
  },

  grad3_white_red_black =
  {
    font_mode = "gradient3",

    font_colors = { "#fff", "#f00", "#000" },

    font_outlines = { "#c00" },
  },

  grad3_white_blue_black =
  {
    font_mode = "gradient3",

    font_colors = { "#fff", "#00f", "#000" },

    font_outlines = { "#00c" },
  },

  grad3_white_orange_black =
  {
    font_mode = "gradient3",

    font_colors = { "#fff", "#720", "#000" },

    font_outlines = { "#000" },
  },

  gradmirror_orange_white =
  {
    font_mode = "gradient3",

    font_colors = { "#720", "#fff", "#720" },

    font_outlines = { "#000" },
  },

  gradmirror_yellow_orange =
  {
    font_mode = "gradient3",

    font_colors = { "#ff7", "#620", "#ff7" },

    font_outlines = { "#000", "#000", "#000" },

    narrow = 0.7,
  },

  --- Textured styles ---

  textured_brick =
  {
    font_mode = "gradient",

    font_colors = { "#7e6", "#000" },

    font_outlines = { "#231", "#342" },

    background = "brickwall",

    props = 
    {
      barrel_1 =
      {
        image = "barrel1",
        x = 40,
        y = 160
      },
      barrel_2 =
      {
        image = "barrel1",
        x = 245,
        y = 160
      },
    },
  },
}


HERETIC.TITLE_SUB_STYLES =
{
  white =
  {
    font_mode = "solid",
    font_colors = { "#ddd" },
    font_outlines = { "#000" },
  },

  yellow =
  {
    prob = 25,
    font_mode = "solid",
    font_colors = { "#ff7" },
    font_outlines = { "#431" },
  },

  yellow_outline =
  {
    font_mode = "solid",
    font_colors = { "#000" },
    font_outlines = { "#ff7" },
  },

  red_outline =
  {
    font_mode = "solid",
    font_colors = { "#000" },
    font_outlines = { "#f44" },
  },

  lightbrown =
  {
    font_mode = "solid",
    font_colors = { "#ea7" },
    font_outlines = { "#431" },
  },

  green =
  {
    font_mode = "solid",
    font_colors = { "#6d5" },
    font_outlines = { "#242" },
  },

  purple =
  {
    font_mode = "solid",
    font_colors = { "#f0f" },
    font_outlines = { "#505" },
  },
}


HERETIC.TITLE_SPACE_STYLES =
{
  red_nebula =
  {
    hue1   = "#300",
    hue2   = "#f00",
    hue3   = "#fff",
    thresh = 0.5,
  },

  blue_nebula =
  {
    hue1   = "#000",
    hue2   = "#00f",
    hue3   = "#99f",
    thresh = 0.5,
  },

  green_nebula =
  {
    hue1   = "#000",
    hue2   = "#363",
    hue3   = "#6f6",
    thresh = 0.5,
  },

  brown_nebula =
  {
    hue1   = "#000000",
    hue2   = "#ab6f43",
    hue3   = "#ffebdf",
    thresh = 0.25,
    power  = 3.0,
  },

  firey_nebula =
  {
    prob = 100,

    hue1   = "#300",
    hue2   = "#732",
    hue3   = "#ff8",
    thresh = 0.2,
    power  = 1.5,
  },

  grey_nebula =
  {
    prob   = 5,

    hue1   = "#000",
    hue2   = "#aaa",
    hue3   = "#000",
    power  = 4,
  },

  purple_nebula =
  {
    prob = 5,

    hue1   = "#707",
    hue2   = "#f0f",
    hue3   = "#fff",
    thresh = 0.3,
    power  = 2,
  },
}


HERETIC.TITLE_INTERMISSION_STYLES =
{
  brown_box =
  {
    hue1 = "#332b13",
    hue2 = "#774f2b",
    hue3 = "#ab6f43",

    fracdim = 2.8
  },

  blue_box =
  {
    hue1 = "#005",
    hue2 = "#00c",
    hue3 = "#33f",

    fracdim = 2.8
  },

  pink_box =
  {
    hue1 = "#600",
    hue2 = "#933",
    hue3 = "#b55",

    fracdim = 2.8
  },

  green_box =
  {
    hue1 = "#13230b",
    hue2 = "#27551b",
    hue3 = "#448822",

    fracdim = 2.8
  },

  dark_box =
  {
    hue1 = "#111",
    hue2 = "#222",
    hue3 = "#333",

    fracdim = 2.9
  }
}


HERETIC.TITLE_COLOR_RAMPS =
{
  white =
  {
    { 0,0,0 },
    { 255,255,255 }
  },

  light_grey =
  {
    { 0,0,0 },
    { 168,168,168 }
  },

  mid_grey =
  {
    { 0,0,0 },
    { 128,128,128 }
  },

  dark_grey =
  {
    { 0,0,0 },
    { 96,96,96 }
  },

  blue =
  {
    { 0,0,0 },
    { 0,0,255 }
  },

  blue_white =
  {
    { 0,0,0 },
    { 0,0,255 },
    { 231,231,255 }
  },

  red =
  {
    { 60,0,0 },
    { 255,0,0 }
  },

  red_white =
  {
    { 60,0,0 },
    { 255,0,0 },
    { 255,224,224 }
  },

  green =
  {
    { 8,23,8 },
    { 62,147,62 },
    { 115,255,115 }
  },

  mid_green =
  {
    { 8,23,8 },
    { 62,147,62 }
  },

  orange_white =
  {
    {43,35,15},
    {135,40,5},
    {215,95,11},
    {243,115,23},
    {255,235,219}
  },

  pink =
  {
    {60,5,5},
    {107,15,15},
    {155,51,51},
    {203,107,107},
    {255,183,183}
  },

  light_brown =
  {
    {0,0,0},
    {75,55,27},
    {119,79,43},
    {191,123,75},
    {255,179,131},
    {255,235,223}
  },

  brown_yellow =
  {
    {0,0,0},
    {115,43,0},
    {255,255,115}
  }
}

function HERETIC.setup()
  GAME.TITLE_MAIN_STYLES = HERETIC.TITLE_MAIN_STYLES 
  GAME.TITLE_SUB_STYLES = HERETIC.TITLE_SUB_STYLES 
  GAME.TITLE_SPACE_STYLES = HERETIC.TITLE_SPACE_STYLES
  GAME.TITLE_INTERMISSION_STYLES = HERETIC.TITLE_INTERMISSION_STYLES
  GAME.TITLE_COLOR_RAMPS = HERETIC.TITLE_COLOR_RAMPS
  GAME.title_screen_asset_dir = "games/heretic/data/title"
end

------------------------------------------------------------------------

OB_THEMES["city"] =
{
  label = _("City"),
  game = "heretic",
  name_class = "GOTHIC",
  mixed_prob = 50,
}

OB_THEMES["maw"] =
{
  label = _("Maw"),
  game = "heretic",
  name_class = "GOTHIC",
  mixed_prob = 50,
}

OB_THEMES["dome"] =
{
  label = _("Dome"),
  game = "heretic",
  name_class = "GOTHIC",
  mixed_prob = 50,
}

OB_THEMES["ossuary"] =
{
  label = _("Ossuary"),
  game = "heretic",
  name_class = "GOTHIC",
  mixed_prob = 50,
}

OB_THEMES["demense"] =
{
  label = _("Demense"),
  game = "heretic",
  name_class = "GOTHIC",
  mixed_prob = 50,
}

