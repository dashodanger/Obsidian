--------------------------------------------------------------------
--  DOOM RESOURCES / GRAFIX
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C)      2011 Reisal
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.RESOURCES = {}

DOOM.RESOURCES.PALETTES =
{
  normal =
  {
    0,  0,  0,  31, 23, 11,  23, 15,  7,  75, 75, 75, 255,255,255,
   27, 27, 27,  19, 19, 19,  11, 11, 11,   7,  7,  7,  47, 55, 31,
   35, 43, 15,  23, 31,  7,  15, 23,  0,  79, 59, 43,  71, 51, 35,
   63, 43, 27, 255,183,183, 247,171,171, 243,163,163, 235,151,151,
  231,143,143, 223,135,135, 219,123,123, 211,115,115, 203,107,107,
  199, 99, 99, 191, 91, 91, 187, 87, 87, 179, 79, 79, 175, 71, 71,
  167, 63, 63, 163, 59, 59, 155, 51, 51, 151, 47, 47, 143, 43, 43,
  139, 35, 35, 131, 31, 31, 127, 27, 27, 119, 23, 23, 115, 19, 19,
  107, 15, 15, 103, 11, 11,  95,  7,  7,  91,  7,  7,  83,  7,  7,
   79,  0,  0,  71,  0,  0,  67,  0,  0, 255,235,223, 255,227,211,
  255,219,199, 255,211,187, 255,207,179, 255,199,167, 255,191,155,
  255,187,147, 255,179,131, 247,171,123, 239,163,115, 231,155,107,
  223,147, 99, 215,139, 91, 207,131, 83, 203,127, 79, 191,123, 75,
  179,115, 71, 171,111, 67, 163,107, 63, 155, 99, 59, 143, 95, 55,
  135, 87, 51, 127, 83, 47, 119, 79, 43, 107, 71, 39,  95, 67, 35,
   83, 63, 31,  75, 55, 27,  63, 47, 23,  51, 43, 19,  43, 35, 15,
  239,239,239, 231,231,231, 223,223,223, 219,219,219, 211,211,211,
  203,203,203, 199,199,199, 191,191,191, 183,183,183, 179,179,179,
  171,171,171, 167,167,167, 159,159,159, 151,151,151, 147,147,147,
  139,139,139, 131,131,131, 127,127,127, 119,119,119, 111,111,111,
  107,107,107,  99, 99, 99,  91, 91, 91,  87, 87, 87,  79, 79, 79,
   71, 71, 71,  67, 67, 67,  59, 59, 59,  55, 55, 55,  47, 47, 47,
   39, 39, 39,  35, 35, 35, 119,255,111, 111,239,103, 103,223, 95,
   95,207, 87,  91,191, 79,  83,175, 71,  75,159, 63,  67,147, 55,
   63,131, 47,  55,115, 43,  47, 99, 35,  39, 83, 27,  31, 67, 23,
   23, 51, 15,  19, 35, 11,  11, 23,  7, 191,167,143, 183,159,135,
  175,151,127, 167,143,119, 159,135,111, 155,127,107, 147,123, 99,
  139,115, 91, 131,107, 87, 123, 99, 79, 119, 95, 75, 111, 87, 67,
  103, 83, 63,  95, 75, 55,  87, 67, 51,  83, 63, 47, 159,131, 99,
  143,119, 83, 131,107, 75, 119, 95, 63, 103, 83, 51,  91, 71, 43,
   79, 59, 35,  67, 51, 27, 123,127, 99, 111,115, 87, 103,107, 79,
   91, 99, 71,  83, 87, 59,  71, 79, 51,  63, 71, 43,  55, 63, 39,
  255,255,115, 235,219, 87, 215,187, 67, 195,155, 47, 175,123, 31,
  155, 91, 19, 135, 67,  7, 115, 43,  0, 255,255,255, 255,219,219,
  255,187,187, 255,155,155, 255,123,123, 255, 95, 95, 255, 63, 63,
  255, 31, 31, 255,  0,  0, 239,  0,  0, 227,  0,  0, 215,  0,  0,
  203,  0,  0, 191,  0,  0, 179,  0,  0, 167,  0,  0, 155,  0,  0,
  139,  0,  0, 127,  0,  0, 115,  0,  0, 103,  0,  0,  91,  0,  0,
   79,  0,  0,  67,  0,  0, 231,231,255, 199,199,255, 171,171,255,
  143,143,255, 115,115,255,  83, 83,255,  55, 55,255,  27, 27,255,
    0,  0,255,   0,  0,227,   0,  0,203,   0,  0,179,   0,  0,155,
    0,  0,131,   0,  0,107,   0,  0, 83, 255,255,255, 255,235,219,
  255,215,187, 255,199,155, 255,179,123, 255,163, 91, 255,143, 59,
  255,127, 27, 243,115, 23, 235,111, 15, 223,103, 15, 215, 95, 11,
  203, 87,  7, 195, 79,  0, 183, 71,  0, 175, 67,  0, 255,255,255,
  255,255,215, 255,255,179, 255,255,143, 255,255,107, 255,255, 71,
  255,255, 35, 255,255,  0, 167, 63,  0, 159, 55,  0, 147, 47,  0,
  135, 35,  0,  79, 59, 39,  67, 47, 27,  55, 35, 19,  47, 27, 11,
    0,  0, 83,   0,  0, 71,   0,  0, 59,   0,  0, 47,   0,  0, 35,
    0,  0, 23,   0,  0, 11,   0, 47, 47, 255,159, 67, 255,231, 75,
  255,123,255, 255,  0,255, 207,  0,207, 159,  0,155, 111,  0,107,
  167,107,107,
  },
}


--------------------------------------------------------------------

-- Left out the non-level and wolfenstein level music - Dasho
DOOM.RESOURCES.MUSIC_LUMPS = 
{
  "D_RUNNIN",
  "D_STALKS",
  "D_COUNTD",
  "D_BETWEE",
  "D_DOOM",
  "D_THE_DA",
  "D_SHAWN",
  "D_DDTBLU",
  "D_IN_CIT",
  "D_DEAD",
  "D_STLKS2",
  "D_THEDA2",
  "D_DOOM2",
  "D_DDTBL2",
  "D_RUNNI2",
  "D_DEAD2",
  "D_STLKS3",
  "D_ROMERO",
  "D_SHAWN2",
  "D_MESSAG",
  "D_COUNT2",
  "D_DDTBL3",
  "D_AMPIE",
  "D_THEDA3",
  "D_ADRIAN",
  "D_MESSG2",
  "D_ROMER2",
  "D_TENSE",
  "D_SHAWN3",
  "D_OPENIN",
}

DOOM.RESOURCES.SKY_GEN_COLORMAPS =
{
  -- star colors --

  STARS =
  {
    8, 7, 6, 5,
    111, 109, 107, 104, 101,
    98, 95, 91, 87, 83, 4,
  },

  RED_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    191,190,189,188,186,184,182,180,
  },

  BLUE_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    247,246,245,244,243,242,241,240,
    207,206,205,204,203,202,201,200,
  },

  BROWN_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    2,2,1,1, 79,79,78,77,76,75,74,73,71,69,
  },

  GREEN_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    127, 126, 125, 124, 123, 122, 121,
    120, 119, 118, 117, 115, 113, 112,
  },

  -- cloud colors --

  GREY_CLOUDS =
  {
    106, 104, 102, 100,
    98, 96, 94, 92, 90,
    88, 86, 84, 82, 80,
  },

  DARK_CLOUDS =
  {
    7, 6, 5,
    110, 109, 108, 107, 106,
    105, 104, 103, 102, 101,
  },

  BLUE_CLOUDS =
  {
    245, 245, 244, 244, 243, 242, 241,
    240, 206, 205, 204, 204, 203, 203,
  },

  HELL_CLOUDS =
  {
    188, 185, 184, 183, 182, 181, 180,
    179, 178, 177, 176, 175, 174, 173,
  },

  ORANGE_CLOUDS =
  {
    234, 232, 222, 220, 218, 216, 214, 211,
  },

  HELLISH_CLOUDS =
  {
    0, 0, 0, 0, 0, 47, 191, 190, 191, 47, 0, 0,
  },

  BROWN_CLOUDS =
  {
     2, 1,
     79, 78, 77, 76, 75, 74, 73,
     72, 71, 70, 69, 67, 66, 65,
  },

  BROWNISH_CLOUDS =
  {
    239, 238, 237, 236, 143, 142, 141,
    140, 139, 138, 137, 136, 135, 134,
    133, 130, 129, 128,
  },

  YELLOW_CLOUDS =
  {
    167, 166, 165, 164, 163, 162,
    161, 160, 228, 227, 225,
  },

  GREEN_CLOUDS =
  {
    127, 126, 125, 124, 123, 122, 121,
    120, 119, 118, 117, 115, 113, 112,
  },

  JADE_CLOUDS =
  {
    12, 11, 10, 9,
    159, 158, 157, 156, 155, 154, 153, 152,
  },

  DARKRED_CLOUDS =
  {
     47, 46, 45, 44, 43, 42, 41, 40, 39, 37, 36, 34,
  },

  PEACH_CLOUDS =
  {
     68, 66, 64, 62, 60, 58, 57,
  },

  WHITE_CLOUDS =
  {
     99, 98, 97, 96, 95, 94, 93,
     92, 91, 90, 89, 88, 87, 86,
     85, 84, 83, 81,
  },

  SKY_CLOUDS =
  {
    193, 194, 195, 196, 197, 198, 199, 200, 201,
  },

  PURPLE_CLOUDS =
  {
    254, 253, 252, 251, 250, 251, 252, 253, 254,
  },

  RAINBOW_CLOUDS =
  {
    191, 186, 181, 176,
    231, 161, 164, 167,
    242, 207, 204, 199,
    115, 119, 123, 127,
  },

  -- hill colors --

  BLACK_HILLS =
  {
    0, 0, 0,
  },

  BROWN_HILLS =
  {
    0, 2, 2, 1,
    79,78,77,76,75,74,73,72,
    71,70,69,68,67,66,65,64,
  },

  TAN_HILLS =
  {
    239, 238, 237,
    143, 142, 141, 140, 138, 136, 134, 132, 130, 129, 128,
  },

  GREEN_HILLS =
  {
    0, 7,
    127, 126, 125, 124, 123, 122, 121,
    120, 119, 118, 117, 116, 115, 114, 113,
  },

  DARKGREEN_HILLS =
  {
    0, 7, 127, 126, 125, 124,
  },

  HELL_HILLS =
  {
    0, 6, 47, 46, 45, 44, 43, 42, 41, 40,
    39, 38, 37, 36, 35, 34, 33,
  },

  DARKBROWN_HILLS =
  {
    8, 7, 2, 1, 79, 78, 77, 76, 75,
  },

  GREENISH_HILLS =
  {
    0, 7, 12, 11, 10, 9, 15, 14, 13,
    159, 158, 157, 156, 155, 154,
  },

  ICE_HILLS =
  {
    0, 244,
    207, 206, 205, 204, 203, 202, 201,
    200, 198, 197, 195, 194, 193, 192,
  },

  SNOW_HILLS =
  {
    0, 8, 6, 5, 111, 109, 107, 105,
    90, 88, 86, 84, 82, 80, 4,
    --87, 86, 85, 84, 83, 82, 81, 80, 4,
  }
}

-- Some ideas for Doom/Ultimate Doom if going with a theme to make it like "Original" theming:
-- Phobos: White/Gray/Dark skies, brown/brown-green/ice hills/mountains
-- Deimos: Red/Orange/Dark skies, brown/black/ice hills/mountains
-- Hell: Red/Orange/Yellow/Green skies, any hill/mountain type goes
-- E4: Orange/Yellow/White/Gray/Dark skies, any hill/mountain type goes


DOOM.RESOURCES.SKY_GEN_THEMES =
{
  urban =
  {
    clouds =
    {
      SKY_CLOUDS = 130,
      BLUE_CLOUDS = 80,

      WHITE_CLOUDS = 40, --80
      GREY_CLOUDS = 50, --100
      DARK_CLOUDS = 50, -- 100

      BROWN_CLOUDS = 30, --60
      BROWNISH_CLOUDS = 30, --40

      PEACH_CLOUDS = 40,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      GREEN_CLOUDS = 25,
      JADE_CLOUDS = 25
    },

    hills =
    {
      TAN_HILLS = 30,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      GREENISH_HILLS = 30,
      ICE_HILLS = 12,
      BLACK_HILLS = 5,
      SNOW_HILLS = 20
    },

    dark_hills =
    {
      DARKGREEN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      ICE_HILLS = 25
    }
  },

  tech =
  {
    clouds =
    {
      SKY_CLOUDS = 130,
      BLUE_CLOUDS = 80,

      WHITE_CLOUDS = 40, --80
      GREY_CLOUDS = 50, --100
      DARK_CLOUDS = 50, --100

      BROWN_CLOUDS = 30, --60
      BROWNISH_CLOUDS = 30, --40

      PEACH_CLOUDS = 40,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      GREEN_CLOUDS = 25,
      JADE_CLOUDS = 25
    },

    hills =
    {
      TAN_HILLS = 30,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      GREENISH_HILLS = 30,
      ICE_HILLS = 12,
      BLACK_HILLS = 5,
      SNOW_HILLS = 20
    },

    dark_hills =
    {
      DARKGREEN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      ICE_HILLS = 25
    }
  },

  hell =
  {
    clouds =
    {
      HELL_CLOUDS = 45, --100
      DARKRED_CLOUDS = 40, --70
      HELLISH_CLOUDS = 35, --55

      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      JADE_CLOUDS = 35,
      GREEN_CLOUDS = 30,
      PEACH_CLOUDS = 20,
      WHITE_CLOUDS = 30,
      GREY_CLOUDS = 30,
      DARK_CLOUDS = 40
    },

    hills =
    {
      HELL_HILLS = 50,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      BLACK_HILLS = 25,
      SNOW_HILLS = 25
    },

    dark_hills =
    {
      HELL_HILLS = 50,
      DARKBROWN_HILLS = 20
    }
  },

  deimos =
  {
    clouds =
    {
      HELL_CLOUDS = 100,
      DARKRED_CLOUDS = 70,
      HELLISH_CLOUDS = 55,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      JADE_CLOUDS = 35,
      GREEN_CLOUDS = 30,
      WHITE_CLOUDS = 30,
      GREY_CLOUDS = 30,
      PEACH_CLOUDS = 20,
      DARK_CLOUDS = 40
    },

    hills =
    {
      HELL_HILLS = 50,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      BLACK_HILLS = 25,
      SNOW_HILLS = 25
    },

    dark_hills =
    {
      HELL_HILLS = 50,
      DARKBROWN_HILLS = 20
    }
  },

  flesh =
  {
    clouds =
    {
      HELL_CLOUDS = 100,
      DARKRED_CLOUDS = 70,
      HELLISH_CLOUDS = 55,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      JADE_CLOUDS = 35,
      GREEN_CLOUDS = 30,
      WHITE_CLOUDS = 30,
      GREY_CLOUDS = 30,
      PEACH_CLOUDS = 20,
      DARK_CLOUDS = 40
    },

    hills =
    {
      HELL_HILLS = 50,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      BLACK_HILLS = 25,
      SNOW_HILLS = 25
    },

    dark_hills =
    {
      HELL_HILLS = 50,
      DARKBROWN_HILLS = 20
    }
  },

  egypt =
  {
    clouds =
    {
      HELL_CLOUDS = 100,
      DARKRED_CLOUDS = 70,
      HELLISH_CLOUDS = 55,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      JADE_CLOUDS = 35,
      GREEN_CLOUDS = 30,
      WHITE_CLOUDS = 30,
      GREY_CLOUDS = 30,
      PEACH_CLOUDS = 20,
      DARK_CLOUDS = 40
    },

    hills =
    {
      HELL_HILLS = 50,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      BLACK_HILLS = 25,
      SNOW_HILLS = 25
    },

    dark_hills =
    {
      HELL_HILLS = 50,
      DARKBROWN_HILLS = 20
    }
  },

  psycho =
  {
    clouds =
    {
      PURPLE_CLOUDS  = 90,
      YELLOW_CLOUDS  = 70,
      HELLISH_CLOUDS = 20,
      RAINBOW_CLOUDS = 10,

      GREEN_CLOUDS = 70,
      BLUE_CLOUDS  = 70,
      WHITE_CLOUDS = 30,
      GREY_CLOUDS  = 30
    },

    hills =
    {
      BLUE_CLOUDS = 50,
      GREEN_HILLS = 50,
      RAINBOW_CLOUDS = 50,
      PURPLE_CLOUDS = 30,
      YELLOW_CLOUDS = 30,
      ORANGE_CLOUDS = 30,
      WHITE_CLOUDS = 30,
      HELLISH_CLOUDS = 20
    }

    -- no dark_hills
  }

}

DOOM.RESOURCES.DYNAMIC_LIGHT_DECORATE =
[[// ObAddon dynamic light actors
actor ObLightWhite 14999
{
  Scale 0 //Should really use a nice corona sprite but whatever
  Height 16

  +NOGRAVITY
  +SPAWNCEILING

  States{
    Spawn:
      CAND A -1
  }
}
actor ObLightRed : ObLightWhite 14998 {}
actor ObLightOrange : ObLightWhite 14997 {}
actor ObLightYellow : ObLightWhite 14996 {}
actor ObLightBlue : ObLightWhite 14995 {}
actor ObLightGreen : ObLightWhite 14994 {}
actor ObLightBeige : ObLightWhite 14993 {}
actor ObLightPurple : ObLightWhite 14992 {}
]]

DOOM.RESOURCES.DYNAMIC_LIGHT_GLDEFS =
[[
PointLight WhiteLight
{
  color 0.85 0.9 1
  size 128
  offset 0 -48 0
}

PointLight RedLight
{
  color 1 0 0
  size 128
  offset 0 -48 0
}

PointLight YellowLight
{
  color 1 0.8 0
  size 128
  offset 0 -48 0
}

PointLight OrangeLight
{
  color 1 0.5 0
  size 128
  offset 0 -48 0
}

PointLight BlueLight
{
  color 0.1 0.1 1
  size 128
  offset 0 -48 0
}

PointLight GreenLight
{
  color 0 0.8 0
  size 128
  offset 0 -48 0
}

PointLight BeigeLight
{
  color 1 0.8 0.5
  size 128
  offset 0 -48 0
}

PointLight PurpleLight
{
  color 0.7 0 0.95
  size 128
  offset 0 -48 0
}

object ObLightWhite
{
  frame CAND { light WhiteLight }
}

object ObLightRed
{
  frame CAND { light RedLight }
}

object obLightOrange
{
  frame CAND { light OrangeLight }
}

object obLightYellow
{
  frame CAND { light YellowLight }
}

object obLightBlue
{
  frame CAND { light BlueLight }
}

object obLightGreen
{
  frame CAND { light GreenLight }
}

object ObLightBeige
{
  frame CAND { light BeigeLight }
}

object ObLightPurple
{
  frame CAND { light PurpleLight }
}
]]

DOOM.RESOURCES.GLOWING_FLATS_GLDEFS =
[[
Glow
{
  Flats
  {
    // vanilla ceiling lights
    CEIL1_2
    CEIL1_3
    CEIL3_4
    CEIL3_6
    CEIL4_1
    CEIL4_2
    CEIL4_3
    FLAT17
    FLAT2
    FLAT22
    FLOOR1_7
    TLITE6_1
    TLITE6_4
    TLITE6_5
    TLITE6_6
    GATE1
    GATE2
    GATE3
    GATE4
    GRNLITE1

    // vanilla liquids
    BLOOD1
    BLOOD2
    BLOOD3
    LAVA1
    LAVA2
    LAVA3
    LAVA4
    NUKAGE1
    NUKAGE2
    NUKAGE3
    SLIME01
    SLIME02
    SLIME03
    SLIME04
    SLIME05
    SLIME06
    SLIME07
    SLIME08

    // epic textures liquids
    SLUDGE01
    SLUDGE02
    SLUDGE03
    SLUDGE04
    QLAVA1
    QLAVA2
    QLAVA3
    QLAVA4
    MAGMA1
    MAGMA2
    MAGMA3
    MAGMA4
    MAGMA5
    PURW1
    PURW2
    XLAV1
    XLAV2
    SNOW2
    SNOW9 // it's a liquid, trust me

    // epic textures lights
    LIGHTS1
    LIGHTS2
    LIGHTS3
    LIGHTS4
    TLITE5_1
    TLITE5_2
    TLITE5_3
    TLITE65B
    TLITE65G
    TLITE65O
    TLITE65W
    TLITE65Y
    LITE4F1
    LITE4F2
    LITES01
    LITES02
    LITES03
    LITES04
    LITBL3F1
    LITBL3F2
    GLITE01
    GLITE02
    GLITE03
    GLITE04
    GLITE05
    GLITE06
    GLITE07
    GLITE08
    GLITE09
    PLITE1
    RROCK01
    RROCK02
    GGLAS01
    GGLAS02
    TEK1
    TEK2
    TEK3
    TEK4
    TEK5
    TEK6
    TEK7
    TLIT65OF

    //teleporter gate textures
    GATE1
    GATE2
    GATE3
    GATE4

    //composite flats
    T_GHFLY
    T_GHFLG
    T_GHFLB
    T_GHFLP

    T_CL43R
    T_CL43Y
    T_CL43G
    T_CL43P

    GLOWFLTS
  }

  Texture "FWATER1", 0a0ac4, 128
  Texture "FWATER2", 0a0ac4, 128
  Texture "FWATER3", 0a0ac4, 128
  Texture "FWATER4", 0a0ac4, 128
  Texture "F_SKY1", 404040, 384
}
]]

DOOM.RESOURCES.LEVEL_GFX_COLORS =
{
  gold   = { 0,47,44, 167,166,165,164,163,162,161,160, 225 },
  silver = { 0,246,243,240, 205,202,200,198, 196,195,194,193,192, 4 },
  bronze = { 0,2, 191,188, 235,232, 221,218,215,213,211,209 },
  iron   = { 0,7,5, 111,109,107,104,101,98,94,90,86,81 },

  red    = { 0,2, 191,189,187,185,183,181,179 },
  black  = { 0,0,0,0, 0,0,0,0 },
}


function DOOM.make_cool_gfx()
  local GREEN =
  {
    0, 7, 127, 126, 125, 124, 123,
    122, 120, 118, 116, 113,
  }

  local BRONZE_2 =
  {
    0, 2, 191, 189, 187, 235, 233,
    223, 221, 219, 216, 213, 210,
  }

  local RED =
  {
    0, 2, 188,185,184,183,182,181,
    180,179,178,177,176,175,174,173,172,
  }


  local colmaps =
  {
    BRONZE_2, GREEN, RED,

    DOOM.RESOURCES.LEVEL_GFX_COLORS.gold,
    DOOM.RESOURCES.LEVEL_GFX_COLORS.silver,
    DOOM.RESOURCES.LEVEL_GFX_COLORS.iron,
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, DOOM.RESOURCES.LEVEL_GFX_COLORS.iron)
  gui.set_colormap(5, DOOM.RESOURCES.LEVEL_GFX_COLORS.black)

  -- patches (CEMENT1 .. CEMENT4)
  gui.wad_logo_gfx("WALL52_1", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("WALL53_1", "p", "BOLT",   128,128, 2)
  gui.wad_logo_gfx("WALL55_1", "p", "RELIEF", 128,128, 3)
--gui.wad_logo_gfx("WALL54_1", "p", "CARVE",  128,128, 4)
  gui.wad_logo_gfx("WALL52_2", "p", "CARVE",  128,128, 5) -- O_BLACK

  -- flats
  gui.wad_logo_gfx("O_PILL",   "f", "PILL",   64,64, 1)
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 2)
  gui.wad_logo_gfx("O_RELIEF", "f", "RELIEF", 64,64, 3)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 4)
  gui.wad_logo_gfx("O_BLACK",  "f", "CARVE",  64,64, 5)
end


function DOOM.make_level_gfx(LEVEL)
  -- decide color set
  if not GAME.level_gfx_colors then
    local kind = rand.key_by_probs(
    {
      gold=12, silver=3, bronze=8, iron=10,
    })

    GAME.level_gfx_colors = assert(DOOM.RESOURCES.LEVEL_GFX_COLORS[kind])
  end

  gui.set_colormap(1, GAME.level_gfx_colors)

  if LEVEL.patch and LEVEL.description then
    gui.wad_name_gfx(LEVEL.patch, LEVEL.description, 1)
  end
end


function DOOM.make_episode_gfx()
  -- this is for Doom 1 / Ultimate Doom.
  -- does nothing for Doom 2 / Final Doom (they lack "name_patch" field).

  local colors = assert(DOOM.RESOURCES.LEVEL_GFX_COLORS["red"])

  gui.set_colormap(2, colors)

  for _,EPI in pairs(GAME.episodes) do
    if EPI.name_patch and EPI.description then
      gui.wad_name_gfx(EPI.name_patch, EPI.description, 2)
    end
  end
end


function DOOM.end_level(LEVEL)
  DOOM.make_level_gfx(LEVEL)
end


function DOOM.all_done()
  DOOM.make_cool_gfx()
  DOOM.make_episode_gfx()

  local dir = "games/doom/data/"

  gui.wad_merge_sections(dir .. "doom_falls.wad")
  gui.wad_merge_sections(dir .. "lift_flat.wad")
  gui.wad_merge_sections(dir .. "metal_step.wad")
  gui.wad_merge_sections(dir .. "vine_dude.wad")
  gui.wad_merge_sections(dir .. "logos.wad")
  gui.wad_merge_sections(dir .. "invisible_wall.wad")

  if OB_CONFIG.game == "doom1" or OB_CONFIG.game == "ultdoom" then
    gui.wad_merge_sections(dir .. "short_bars.wad")
  end

  if ob_mod_enabled("compress_output") == 1 and OB_CONFIG.port ~= "dsda" then -- DSDA (I think) needs everything in the WAD still
    gui.pk3_insert_file("data/endoom/ENDOOM.bin", "ENDOOM.bin")
  else
    gui.wad_insert_file("data/endoom/ENDOOM.bin", "ENDOOM")
  end

-- Honestly, this really should be an option
  if OB_CONFIG.length == "game" then
    gui.wad_merge_sections(dir .. "freedoom_face.wad")
  end
end
