------------------------------------------------------------------------
--  HERETIC RESOURCES and GFX
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.RESOURCES = {}

HERETIC.RESOURCES.PALETTES =
{
  normal =
  {
    0,  0,  0,   2,  2,  2,  16, 16, 16,  24, 24, 24,  31, 31, 31,
   36, 36, 36,  44, 44, 44,  48, 48, 48,  55, 55, 55,  63, 63, 63,
   70, 70, 70,  78, 78, 78,  86, 86, 86,  93, 93, 93, 101,101,101,
  108,108,108, 116,116,116, 124,124,124, 131,131,131, 139,139,139,
  146,146,146, 154,154,154, 162,162,162, 169,169,169, 177,177,177,
  184,184,184, 192,192,192, 200,200,200, 207,207,207, 210,210,210,
  215,215,215, 222,222,222, 228,228,228, 236,236,236, 245,245,245,
  255,255,255,  50, 50, 50,  59, 60, 59,  69, 72, 68,  78, 80, 77,
   88, 93, 86,  97,100, 95, 109,112,104, 116,123,112, 125,131,121,
  134,141,130, 144,151,139, 153,161,148, 163,171,157, 172,181,166,
  181,189,176, 189,196,185,  20, 16, 36,  24, 24, 44,  36, 36, 60,
   52, 52, 80,  68, 68, 96,  88, 88,116, 108,108,136, 124,124,152,
  148,148,172, 164,164,184, 180,184,200, 192,196,208, 208,208,216,
  224,224,224,  27, 15,  8,  38, 20, 11,  49, 27, 14,  61, 31, 14,
   65, 35, 18,  74, 37, 19,  83, 43, 19,  87, 47, 23,  95, 51, 27,
  103, 59, 31, 115, 67, 35, 123, 75, 39, 131, 83, 47, 143, 91, 51,
  151, 99, 59, 160,108, 64, 175,116, 74, 180,126, 81, 192,135, 91,
  204,143, 93, 213,151,103, 216,159,115, 220,167,126, 223,175,138,
  227,183,149, 230,190,161, 233,198,172, 237,206,184, 240,214,195,
   62, 40, 11,  75, 50, 16,  84, 59, 23,  95, 67, 30, 103, 75, 38,
  110, 83, 47, 123, 95, 55, 137,107, 62, 150,118, 75, 163,129, 84,
  171,137, 92, 180,146,101, 188,154,109, 196,162,117, 204,170,125,
  208,176,133,  37, 20,  4,  47, 24,  4,  57, 28,  6,  68, 33,  4,
   76, 36,  3,  84, 40,  0,  97, 47,  2, 114, 54,  0, 125, 63,  6,
  141, 75,  9, 155, 83, 17, 162, 95, 21, 169,103, 26, 180,113, 32,
  188,124, 20, 204,136, 24, 220,148, 28, 236,160, 23, 244,172, 47,
  252,187, 57, 252,194, 70, 251,201, 83, 251,208, 97, 251,214,110,
  251,221,123, 250,228,136, 157, 51,  4, 170, 65,  2, 185, 86,  4,
  213,118,  4, 236,164,  3, 248,190,  3, 255,216, 43, 255,255,  0,
   67,  0,  0,  79,  0,  0,  91,  0,  0, 103,  0,  0, 115,  0,  0,
  127,  0,  0, 139,  0,  0, 155,  0,  0, 167,  0,  0, 179,  0,  0,
  191,  0,  0, 203,  0,  0, 215,  0,  0, 227,  0,  0, 239,  0,  0,
  255,  0,  0, 255, 52, 52, 255, 74, 74, 255, 95, 95, 255,123,123,
  255,155,155, 255,179,179, 255,201,201, 255,215,215,  60, 12, 88,
   80,  8,108, 104,  8,128, 128,  0,144, 152,  0,176, 184,  0,224,
  216, 44,252, 224,120,240,  37,  6,129,  60, 33,147,  82, 61,165,
  105, 88,183, 128,116,201, 151,143,219, 173,171,237, 196,198,255,
    2,  4, 41,   2,  5, 49,   6,  8, 57,   2,  5, 65,   2,  5, 79,
    0,  4, 88,   0,  4, 96,   0,  4,104,   2,  5,121,   2,  5,137,
    6,  9,159,  12, 16,184,  32, 40,200,  56, 60,220,  80, 80,253,
   80,108,252,  80,136,252,  80,164,252,  80,196,252,  72,220,252,
   80,236,252,  84,252,252, 152,252,252, 188,252,244,  11, 23,  7,
   19, 35, 11,  23, 51, 15,  31, 67, 23,  39, 83, 27,  47, 99, 35,
   55,115, 43,  63,131, 47,  67,147, 55,  75,159, 63,  83,175, 71,
   91,191, 79,  95,207, 87, 103,223, 95, 111,239,103, 119,255,111,
   23, 31, 23,  27, 35, 27,  31, 43, 31,  35, 51, 35,  43, 55, 43,
   47, 63, 47,  51, 71, 51,  59, 75, 55,  63, 83, 59,  67, 91, 67,
   75, 95, 71,  79,103, 75,  87,111, 79,  91,115, 83,  95,123, 87,
  103,131, 95, 255,223,  0, 255,191,  0, 255,159,  0, 255,127,  0,
  255, 95,  0, 255, 63,  0, 244, 14,  3,  55,  0,  0,  47,  0,  0,
   39,  0,  0,  23,  0,  0,  15, 15, 15,  11, 11, 11,   7,  7,  7,
  255,255,255,
  },
}

HERETIC.RESOURCES.MUSIC_LUMPS = 
{
  "MUS_E1M1", 
  "MUS_E1M2",
  "MUS_E1M3",
  "MUS_E1M4",
  "MUS_E1M5",
  "MUS_E1M6",
  "MUS_E1M7",
  "MUS_E1M8",
  "MUS_E1M9", 
  "MUS_E2M1",
  "MUS_E2M2",
  "MUS_E2M3",
  "MUS_E2M4",
  "MUS_E2M6",
  "MUS_E2M7",
  "MUS_E2M8",
  "MUS_E2M9",
  "MUS_E3M2",
  "MUS_E3M3",
}

HERETIC.RESOURCES.SKY_GEN_COLORMAPS =
{
  -- star colors --

  STARS =
  {
    0, 1, 2, 3,
    6, 9, 11, 13, 15,
    16, 19, 21, 23, 25, 255,
  },

  RED_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    145,146,147,148,150,152,154,156,
  },

  BLUE_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    185,186,187,188,189,190,191,192,
    193,194,195,196,197,198,199,200,
  },

  BROWN_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    3,3,4,4, 67,67,68,69,70,71,72,73,75,77,
  },

  GREEN_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    209, 210, 211, 212, 213, 214, 215,
    216, 217, 218, 219, 221, 223, 224,
  },

  -- cloud colors --

  GREY_CLOUDS =
  {
    11, 13, 15, 17,
    19, 21, 23, 25, 27,
    29, 31, 33,
  },

  DARK_CLOUDS =
  {
    1, 2, 3,
    4, 5, 6, 7, 8,
    9, 10, 11, 12, 13,
  },

  BLUE_CLOUDS =
  {
    185, 185, 186, 186, 187, 188, 189,
    190, 192, 193, 194, 194, 195, 195,
  },

  HELL_CLOUDS =
  {
    148, 149, 150, 151, 152, 153, 154,
    155, 156, 157, 158, 159, 160, 161,
  },

  ORANGE_CLOUDS =
  {
    137, 138, 139, 140, 127, 128, 130, 132,
  },

  HELLISH_CLOUDS =
  {
    0, 0, 0, 0, 0, 145, 146, 147, 146, 145, 0, 0,
  },

  BROWN_CLOUDS =
  {
     3, 4,
     68, 69, 70, 71, 72, 73, 74,
     75, 76, 77, 78, 80, 81, 82,
  },

  BROWNISH_CLOUDS =
  {
    95, 96, 97, 98, 99, 100, 101,
    102, 103, 104, 105, 106, 107, 108,
    109, 110,
  },

  YELLOW_CLOUDS =
  {
    118, 119, 121, 123, 125, 131,
    132, 133, 144, 136,
  },

  GREEN_CLOUDS =
  {
    209, 210, 211, 212, 213, 214, 215,
    216, 217, 218, 219, 221, 223, 224,
  },

  JADE_CLOUDS =
  {
    229, 230, 231, 232,
    233, 234, 235, 236, 237, 238, 239, 240,
  },

  DARKRED_CLOUDS =
  {
     145, 146, 147, 148, 149, 150, 151, 152,
  },

  PEACH_CLOUDS =
  {
     80, 82, 84, 86, 88, 89,
  },

  WHITE_CLOUDS =
  {
     12, 13, 14, 15, 16, 17, 18,
     19, 20, 21, 22, 23, 24, 25,
     26, 27, 28, 30, 32,
  },

  SKY_CLOUDS =
  {
    200, 199, 198, 197,
  },

  PURPLE_CLOUDS =
  {
    171, 172, 173, 174, 175, 174, 173, 172, 171,
  },

  RAINBOW_CLOUDS =
  {
    145, 150, 154, 158,
    144, 143, 140, 137,
    187, 192, 196, 199,
    219, 215, 213, 211,
  },

  -- hill colors --

  BLACK_HILLS =
  {
    0, 0, 0,
  },

  BROWN_HILLS =
  {
    0, 3, 3, 4,
    96,97,98,99,100,76,77,78,
    79,80,81,82,83,84,123,122,
  },

  TAN_HILLS =
  {
    96, 97, 98,
    99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110,
  },

  GREEN_HILLS =
  {
    0, 1,
    210, 211, 212, 213, 214, 215, 216,
    217, 218, 219, 220, 221, 222, 223, 224,
  },

  DARKGREEN_HILLS =
  {
    0, 1, 210, 211, 212, 213,
  },

  HELL_HILLS =
  {
    0, 2, 145, 146, 147, 148, 149, 150, 151, 152,
    153,
  },

  DARKBROWN_HILLS =
  {
    1, 2, 3, 4, 95, 96, 97, 98,
  },

  GREENISH_HILLS =
  {
    0, 1, 225, 226, 227, 228, 96, 97, 98,
    232, 233, 234, 235, 236, 237,
  },

  ICE_HILLS =
  {
    0, 185,
    193, 194, 195, 196, 197, 198, 199,
    200, 201, 202,
  },
}

HERETIC.RESOURCES.SKY_GEN_THEMES =
{
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
      GREY_CLOUDS  = 30,
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
      HELLISH_CLOUDS = 20,
    },
  },

  city =
  {
    clouds =
    {
      SKY_CLOUDS = 130,
      BLUE_CLOUDS = 80,
      WHITE_CLOUDS = 80,
      GREY_CLOUDS = 100,
      DARK_CLOUDS = 100,

      BROWN_CLOUDS = 60,
      BROWNISH_CLOUDS = 40,
      PEACH_CLOUDS = 40,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      GREEN_CLOUDS = 25,
      JADE_CLOUDS = 25,
    },

    hills =
    {
      TAN_HILLS = 30,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      GREENISH_HILLS = 30,
      ICE_HILLS = 12,
      BLACK_HILLS = 5,
    },

    dark_hills =
    {
      DARKGREEN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      ICE_HILLS = 25,
    },
  },

  maw =
  {
    clouds =
    {
      SKY_CLOUDS = 130,
      BLUE_CLOUDS = 80,
      WHITE_CLOUDS = 80,
      GREY_CLOUDS = 100,
      DARK_CLOUDS = 100,

      BROWN_CLOUDS = 60,
      BROWNISH_CLOUDS = 40,
      PEACH_CLOUDS = 40,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      GREEN_CLOUDS = 25,
      JADE_CLOUDS = 25,
    },

    hills =
    {
      TAN_HILLS = 30,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      GREENISH_HILLS = 30,
      ICE_HILLS = 12,
      BLACK_HILLS = 5,
    },

    dark_hills =
    {
      DARKGREEN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      ICE_HILLS = 25,
    },
  },

  ossuary =
  {
    clouds =
    {
      SKY_CLOUDS = 130,
      BLUE_CLOUDS = 80,
      WHITE_CLOUDS = 80,
      GREY_CLOUDS = 100,
      DARK_CLOUDS = 100,

      BROWN_CLOUDS = 60,
      BROWNISH_CLOUDS = 40,
      PEACH_CLOUDS = 40,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      GREEN_CLOUDS = 25,
      JADE_CLOUDS = 25,
    },

    hills =
    {
      TAN_HILLS = 30,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      GREENISH_HILLS = 30,
      ICE_HILLS = 12,
      BLACK_HILLS = 5,
    },

    dark_hills =
    {
      DARKGREEN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      ICE_HILLS = 25,
    },
  },

  dome =
  {
    clouds =
    {
      SKY_CLOUDS = 130,
      BLUE_CLOUDS = 80,
      WHITE_CLOUDS = 80,
      GREY_CLOUDS = 100,
      DARK_CLOUDS = 100,

      BROWN_CLOUDS = 60,
      BROWNISH_CLOUDS = 40,
      PEACH_CLOUDS = 40,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      GREEN_CLOUDS = 25,
      JADE_CLOUDS = 25,
    },

    hills =
    {
      TAN_HILLS = 30,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      GREENISH_HILLS = 30,
      ICE_HILLS = 12,
      BLACK_HILLS = 5,
    },

    dark_hills =
    {
      DARKGREEN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      ICE_HILLS = 25,
    },
  },

  demense =
  {
    clouds =
    {
      SKY_CLOUDS = 130,
      BLUE_CLOUDS = 80,
      WHITE_CLOUDS = 80,
      GREY_CLOUDS = 100,
      DARK_CLOUDS = 100,

      BROWN_CLOUDS = 60,
      BROWNISH_CLOUDS = 40,
      PEACH_CLOUDS = 40,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      GREEN_CLOUDS = 25,
      JADE_CLOUDS = 25,
    },

    hills =
    {
      TAN_HILLS = 30,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      GREENISH_HILLS = 30,
      ICE_HILLS = 12,
      BLACK_HILLS = 5,
    },

    dark_hills =
    {
      DARKGREEN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      ICE_HILLS = 25,
    },
  },

}

HERETIC.RESOURCES.DYNAMIC_LIGHT_DECORATE =
[[// ObAddon dynamic light actors
actor ObLightWhite 14999
{
  Scale 0 //Should really use a nice corona sprite but whatever
  Height 16

  +NOGRAVITY
  +SPAWNCEILING

  States{
    Spawn:
      TRCH A -1
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

HERETIC.RESOURCES.DYNAMIC_LIGHT_GLDEFS =
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
  frame TRCH { light WhiteLight }
}

object ObLightRed
{
  frame TRCH { light RedLight }
}

object obLightOrange
{
  frame TRCH { light OrangeLight }
}

object obLightYellow
{
  frame TRCH { light YellowLight }
}

object obLightBlue
{
  frame TRCH { light BlueLight }
}

object obLightGreen
{
  frame TRCH { light GreenLight }
}

object ObLightBeige
{
  frame TRCH { light BeigeLight }
}

object ObLightPurple
{
  frame TRCH { light PurpleLight }
}
]]

HERETIC.RESOURCES.GLOWING_FLATS_GLDEFS =
[[
Glow
{
  Flats
  {

    // vanilla liquids - I prefer that only the 'dangerous' liquids be glowing, but uncomment the first six below for all liquids
//    FLTFLWW1
//    FLTFLWW2
//    FLTFLWW3
//    FLTWAWA1
//    FLTWAWA2
//    FLTWAWA3
    FLTSLUD1
    FLTSLUD2
    FLTSLUD3
    FLATHUH1
    FLATHUH2
    FLATHUH3
    FLATHUH4
    FLTLAVA1
    FLTLAVA2
    FLTLAVA3
    FLTLAVA4

    //teleporter gate textures
    FLTTELE1
    FLTTELE2
    FLTTELE3
    FLTTELE4

    GLOWFLTS
  }

//  Texture "FLTWAWA1", 0a0ac4, 128
//  Texture "FLTWAWA2", 0a0ac4, 128
//  Texture "FLTWAWA3", 0a0ac4, 128
  Texture "F_SKY1", 808080, 128
}
]]

------------------------------------------------------------------------

function HERETIC.make_cool_gfx()
  local GREEN =
  {
    0, 209, 211, 213, 215, 217, 218,
  }

  local BROWN =
  {
    0, 66, 68, 70, 73, 76, 79, 82, 86, 90,
  }

  local RED =
  {
    0, 251, 253, 145, 147, 149, 151, 153, 155, 157,
  }

  local WHITE =
  {
    0,2,4,6,8,10,12, 14,16,18,20,22,24,
  }

  local BLUE =
  {
    0, 185, 187, 189, 191, 194, 197, 199, 202,
  }


  local colmaps =
  {
    GREEN, BROWN, RED, BLUE
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, WHITE)

  local carve = "RELIEF"
  local c_map = 3

  if rand.odds(33) then
    carve = "CARVE"
    c_map = 4
  end

  -- patches for SKULLSB2, CHAINSD

---#  gui.wad_logo_gfx("WALL41", "p", "PILL",  128,128, 1)
---#  gui.wad_logo_gfx("WALL42", "p", carve,    64,128, c_map)

  -- flats
  gui.wad_logo_gfx("O_BOLT",  "f", "BOLT",  64,64, 2)

---#  gui.wad_logo_gfx("O_PILL",  "f", "PILL",  64,64, 1)
---#  gui.wad_logo_gfx("O_CARVE", "f", carve,   64,64, c_map)
end


function HERETIC.all_done()
  HERETIC.make_cool_gfx()
end

