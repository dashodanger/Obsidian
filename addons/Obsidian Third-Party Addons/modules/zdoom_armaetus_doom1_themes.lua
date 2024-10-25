----------------------------------------------------------------
--  MODULE: Reisal Doom/Ultimate Doom Themes
----------------------------------------------------------------
--
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
--  Copyright (C) 2019-2022 Reisal
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
------------------------------------------------------------------

-- General room themes are placed here (includes cave rooms)
OBS_RESOURCE_PACK_DOOM1_ROOM_THEMES =
{
  any_ducts_Hallway =
  {
    env   = "hallway",
    group = "ducts",
    prob  = 1,

    walls =
    {
      GRAY5 = 1,
    },

    floors =
    {
      FLAT1 = 1,
    },

    ceilings =
    {
      FLAT1 = 1,
    },
  },

  any_hellcata_Hallway =
  {
    env   = "hallway",
    group = "hellcata",
    prob  = 1,

    walls =
    {
      GRAY5 = 1,
    },

    floors =
    {
      FLAT1 = 1,
    },

    ceilings =
    {
      FLAT1 = 1,
    },
  },

  any_sewers_Hallway =
  {
    env   = "hallway",
    group = "sewers",
    prob  = 1,

    walls =
    {
      GRAY5 = 1,
    },

    floors =
    {
      FLAT1 = 1,
    },

    ceilings =
    {
      FLAT1 = 1,
    },
  },

  any_organs_Hallway =
  {
    env   = "hallway",
    group = "organs",
    prob  = 1,

    walls =
    {
      GRAY5 = 1,
    },

    floors =
    {
      FLAT1 = 1,
    },

    ceilings =
    {
      FLAT1 = 1,
    },
  },

  any_conveyor_Hallway =
  {
    env   = "hallway",
    group = "conveyor",
    prob  = 1,

    walls =
    {
      GRAY5 = 1,
    },

    floors =
    {
      FLAT1 = 1,
    },

    ceilings =
    {
      FLAT1 = 1,
    },
  },

  any_conveyorh_Hallway =
  {
    env   = "hallway",
    group = "conveyorh",
    prob  = 1,

    walls =
    {
      GRAY5 = 1,
    },

    floors =
    {
      FLAT1 = 1,
    },

    ceilings =
    {
      FLAT1 = 1,
    },
  },

  tech_GrayMet =
  {
    env = "building",
    prob = 65,

    walls =
    {
      GRAY6 = 50,
      GRAY8 = 50,

      GRAYMET1 = 20,
      GRAYMET2 = 20,
      GRAYMET3 = 20,
      GRAYMET4 = 20,
      GRAYMET5 = 20,
      GRAYMET6 = 6,
      GRAYMET7 = 6,
      GRAYMET8 = 6,
      GRAYMET9 = 6,
      GRAYMETA = 6,
      GRAYMETB = 6,
      GRAYMETC = 6,

      METAL8 = 25,
      METAL9 = 25,
      METAL10 = 25,
      METAL11 = 25,

      SHAWN4 = 33,
      SHAWN5 = 33,
      HEX01 = 33,

      DARKMET1 = 30,
      DARKM01 = 30,

      STARBR1 = 30,
      STARGRY1 = 30,

      TEKGRBLU = 30,
      TEKGRN01 = 30,
      TEKGRY01 = 30,
      TEKSHAW = 30,

      TEKWALL2 = 15,
      TEKWALL7 = 15,
      TEKWALL8 = 15,
      TEKWALL9 = 15,
      TEKWALLA = 10,
      TEKWALLB = 10,
      TEKWALLC = 10,
      TEKWALLD = 10,
      TEKWALLE = 10,
    },

    floors =
    {
      FLOOR4_8 = 25,
      FLOOR5_1 = 25,
      FLOOR5_3 = 30,
      FLOOR0_3 = 30,
      FLOOR3_3 = 20,
      FLOOR0_2 = 20,
      FLOOR0_1 = 20,
      FLOOR4_6 = 15,
      FLOOR7_1 = 15,
      FLAT4 = 15,
      FLAT14 = 10,
      SLIME15 = 10,
      FLOOR1_6 = 6,
      FLOOR1_1 = 8,
      FLOOR0_5 = 5,
      FLAT5 = 5,

      GRATE1 = 100,
      GRATE2 = 100,
      GRATE3 = 100,
      GRATE5 = 100,
      GRATE6 = 100,
      GRATE7 = 100,

      DARKF01 = 75,
      DARKF02 = 75,
      DARKF03 = 75,

      SHINY01 = 75,
      SHINY02 = 75,
      SHINY03 = 75,
      SHINY04 = 35,
    },

    ceilings =
    {
      CEIL3_1 = 20,
      CEIL3_2 = 20,
      CEIL3_5 = 20,
      CEIL3_3 = 15,
      CEIL4_2 = 10,
      CEIL4_3 = 10,
      CEIL5_1 = 15,

      FLAT9  = 30,
      FLAT19 = 20,
      FLAT4  = 20,
      FLAT9  = 15,
      FLAT23 = 5,
    },
  },

  tech_Computers =
  {
    prob = 70,
    env = "building",

    walls =
    {
      COMPSPAN = 30,
      COMPOHSO = 10,
      COMPTILE = 15,
      COMPBLUE = 10,
    },

    floors =
    {
      FLAT14 = 70,
      FLOOR1_1 = 35,
      FLAT4 = 10,
      CEIL4_1 = 20,
      CEIL4_2 = 20,
      CEIL5_1 = 20,
      CEIL4_4 = 20,
    },

    ceilings =
    {
      CEIL5_1 = 50,
      CEIL4_1 = 20,
      CEIL4_2 = 20,
      CEIL4_4 = 15,
      TEK1    = 7,
      TEK2    = 7,
      QFLAT09 = 5,
      GRATE3  = 5,
    },
  },

  -- Multi colors here!
  tech_ComputersMulti =
  {
    prob = 45,
    env = "building",

    walls =
    {
      COMPSPAN = 20,
      COMPOHSO = 10,
      COMPTILE = 20,
      COMPTIL2 = 20,
      COMPTIL3 = 10,
      COMPTIL4 = 20,
      COMPTIL5 = 20,
      COMPTIL6 = 20,
      COMPBLUE = 10,
      COMPGREN = 10,
      COMPRED  = 10,
    },

    floors =
    {
      FLAT14 = 70,
      FLOOR1_1 = 35,
      FLOOR1_2 = 30,
      GRENFLOR = 20,
      FLAT4 = 10,
      CEIL4_1 = 20,
      CEIL4_2 = 20,
      CEIL5_1 = 20,
      CEIL4_4 = 20,
    },

    ceilings =
    {
      CEIL5_1 = 50,
      CEIL4_1 = 20,
      CEIL4_2 = 20,
      CEIL4_4 = 15,
      TEK1    = 7,
      TEK2    = 7,
      QFLAT09 = 5,
      GRATE3  = 5,
    },
  },

  -- single color comp rooms
  tech_ComputersRed =
  {
    prob = 7,
    env = "building",

    walls =
    {
      COMPSPAN = 20,
      CMPTILE = 20,
      COMPTIL2 = 20,
      COMPRED  = 10,
      TEKWALL8 = 20,
      GRAYMET9 = 20,
    },

    floors =
    {
      -- predominantly red
      FLOOR1_6 = 50,
      FLOOR1_2 = 50,
      FLAT15 = 50,
      STARBR2F = 25,
      STARTANF = 25,

      -- everything else
      FLOOR1_1 = 5,
      FLAT3 = 10,
      FLAT4 = 10,
      FLAT20 = 10,
      CEIL4_1 = 2,
      CEIL4_2 = 2,
      CEIL5_1 = 5,
      CEIL4_4 = 2,
      FLOOR4_8 = 20,
      GRATE1 = 20,
      GRATE2 = 20,
      GRATE5 = 10,
      GRATE6 = 10,
      GRATE7 = 20,
      SHINY01 = 10,
      SHINY03 = 10,
    },

    ceilings =
    {
      CEIL5_1 = 20,
      CEIL5_2 = 20,
      FLOOR1_6 = 10,
      TEK1    = 20,
      QFLAT09 = 5,
      GRATE3  = 5,
    },
  },

  tech_ComputersBlue =
  {
    prob = 7,
    env = "building",

    walls =
    {
      CMPTILE = 15,
      CMPOHSO = 15,
      GRAYBLU1 = 20,
      SILVBLU1 = 20,
      TEKGRBLU = 20,
      COMPBLUE = 10,
      TEKWALLB = 20,
      TEKWALLD = 20,
      GRAYMET6 = 15,
      GRAYMETA = 15,
    },

    floors =
    {
      -- predominantly blue
      CEIL4_1 = 30,
      CEIL4_2 = 30,
      CEIL4_4 = 30,
      FLOOR1_1 = 50,
      FLAT14 = 35,

      FLOOR1_1 = 15,
      FLOOR1_2 = 5,
      FLAT3 = 10,
      FLAT4 = 10,
      FLAT20 = 10,
      CEIL5_1 = 10,
      FLOOR4_8 = 20,
      GRATE1 = 20,
      GRATE2 = 20,
      GRATE5 = 10,
      GRATE6 = 10,
      GRATE7 = 20,
      SHINY01 = 10,
      SHINY03 = 10,
    },

    ceilings =
    {
      CEIL5_1 = 10,
      CEIL5_2 = 10,
      CEIL4_1 = 20,
      CEIL4_2 = 20,
      CEIL4_4 = 20,
      TEK4    = 20,
      TEK6    = 20,
      QFLAT09 = 5,
      GRATE3  = 5,
    },
  },

  tech_ComputersGreen =
  {
    prob = 7,
    env = "building",

    walls =
    {
      TEKWALL9 = 20,
      COMPGREN = 20,
      COMPTIL4 = 20,
      GRAYMET8 = 15,
    },

    floors =
    {
      -- predominantly green
      GRENFLOR = 75,
      STARG1F = 50,

      FLOOR1_1 = 15,
      FLOOR1_2 = 5,
      FLAT3 = 10,
      FLAT4 = 10,
      FLAT20 = 10,
      CEIL4_1 = 2,
      CEIL4_2 = 2,
      CEIL5_1 = 10,
      CEIL4_4 = 2,
      FLOOR4_8 = 20,
      GRATE1 = 20,
      GRATE2 = 20,
      GRATE5 = 10,
      GRATE6 = 10,
      GRATE7 = 20,
      SHINY01 = 10,
      SHINY03 = 10,
    },

    ceilings =
    {
      CEIL5_1 = 20,
      CEIL5_2 = 20,
      TEK2    = 30,
      QFLAT09 = 5,
      GRATE3  = 5,
    },
  },

  tech_ComputersYellowish =
  {
    prob = 7,
    env = "building",

    walls =
    {
      TEKWALLE = 20,
      COMPTIL5 = 20,
      COMPTIL3 = 8,
      COMPBLAK = 8,
      GRAYMETC = 8,
    },

    floors =
    {
      -- predominantly yellow or orange shades
      ORANFLOR = 50,
      STARBR2F = 25,
      STARTANF = 25,
      FLOOR4_1 = 25,
      FLOOR4_5 = 25,
      SLIME16 = 25,

      FLOOR1_1 = 15,
      FLOOR1_2 = 5,
      FLAT3 = 10,
      FLAT4 = 10,
      FLAT20 = 10,
      CEIL5_1 = 10,
      FLOOR4_8 = 20,
      GRATE1 = 20,
      GRATE2 = 20,
      GRATE5 = 10,
      GRATE6 = 10,
      GRATE7 = 20,
      SHINY01 = 10,
      SHINY03 = 10,
    },

    ceilings =
    {
      CEIL5_1 = 15,
      CEIL5_2 = 30,
      TEK7    = 30,
      QFLAT09 = 5,
      GRATE3  = 5,
    },
  },

  tech_ComputersParple =
  {
    prob = 7,
    env = "building",

    walls =
    {
      TEKWALLA = 20,
      TEKWALLC = 20,
      COMPTIL6 = 20,
      COMPTIL3 = 10,
      COMPBLAK = 10,
      GRAYMET7 = 10,
      GRAYMETB = 10,
    },

    floors =
    {
      FLAT14 = 20,
      FLOOR1_1 = 15,
      FLOOR1_2 = 5,
      FLAT3 = 10,
      FLAT4 = 10,
      FLAT20 = 10,
      CEIL4_1 = 5,
      CEIL4_2 = 5,
      CEIL5_1 = 10,
      CEIL4_4 = 5,
      FLOOR4_8 = 20,
      GRATE1 = 20,
      GRATE2 = 20,
      GRATE5 = 10,
      GRATE6 = 10,
      GRATE7 = 20,
      SHINY01 = 10,
      SHINY03 = 10,
    },

    ceilings =
    {
      CEIL5_1 = 50,
      CEIL5_2 = 30,
      TEK3    = 20,
      TEK5    = 20,
      QFLAT09 = 5,
      GRATE3  = 5,
    },
  },

  -- Hooray, CEMENT textures!
  tech_Cement =
  {
    env = "building",
    prob = 60,

    walls =
    {
      CEM01 = 50,
      CEM02 = 50,
      CEM03 = 15,
      CEM04 = 15,
      CEM06 = 50,
      CEM07 = 50,
      CEM09 = 50,
      CEM10 = 50,
      CEM11 = 50,
      BRIKS31 = 50,
      BRIKS32 = 50,
      BRONZEG1 = 15,
      BRONZEG2 = 15,
      BRONZEG3 = 15,
      BROWN2 = 50,
      BROWN3 = 50,
      GRAY6 = 15,
      GRAY8 = 15,
      GRAY9 = 15,
      SNOWWAL1 = 15,
      SNOWWAL2 = 15,
      SNOWWAL3 = 15,
      STON7 = 15,
      STONE10 = 15,
      STONE8 = 15,
    },

    floors =
    {
      FLAT1 = 30,
      FLAT3 = 30,
      FLAT5_4 = 25,
      FLAT19 = 15,
      FLAT20 = 15,
      FLOOR0_3 = 15,
      FLOOR0_5 = 15,
      FLOOR4_7 = 15,
      GRATE1 = 15,
      GRATE2 = 15,
      GRATE5 = 25,
      GRATE6 = 25,
      GRATE7 = 15,
      FLOOR4_8 = 10,
      FLOOR5_1 = 10,
      FLOOR51C = 10,
      FLOOR46D = 15,
      FLOOR46E = 15,
      DARKF01 = 15,
      DARKF02 = 15,
      SHINY01 = 25,
      SHINY02 = 25,
      SHINY04 = 25,
      SLIME14 = 15,
      TILES4 = 20,
      TILES6 = 20,
    },

    ceilings =
    {
      FLAT1 = 15,
      FLAT3 = 5,
      FLAT18 = 30,
      FLAT19 = 40,
      FLOOR0_5 = 30,
      CEIL3_5 = 30,
      FLAT5_4 = 20,
      MFLR8_1 = 15,
      FLAT5_2 = 5,
      CEIL1_1 = 5,
      FLAT5_2 = 5,
      GRATE4  = 10,
    },
  },

  tech_Shiny =
  {
    prob = 75,
    env = "building",

    walls =
    {
      SHAWGRY4 = 15,

      SHAWN2 = 60,
      SHAWN4 = 40,
      SHAWN5 = 40,

      SHAWHOSO = 40,
      SHAWN01C = 15,
      SHAWN01D = 15,
      SHAWN01F = 15,

      TEKSHAW = 25,
      HEX01  = 15,
      STARGR1 = 5,
      STARGR2 = 5,
      STARGRY1 = 8,

      SNOWWAL1 = 15,
      SNOWWAL2 = 15,
      SNOWWAL3 = 15,
      SNOWWAL4 = 15,
    },

    floors =
    {
      FLOOR4_7 = 10,
      FLOOR4_8 = 10,
      FLOOR5_1 = 10,
      FLAT14 = 10,
      FLAT15 = 10,
      FLOOR1_1 = 5,
      FLOOR1_2 = 5,
      FLAT23 = 70,
      SHINY01 = 20,
      SHINY02 = 30,
      SHINY03 = 25,
      TILES4  = 5,
      TILES6  = 5,
    },

    ceilings =
    {
      FLAT23 = 70,
      FLAT1  = 5,
      FLAT19 = 10,
      SHINY02 = 15,
      FLOOR4_7 = 10,
      SHINY03 = 15,
      SHINY04 = 10,
    },
  },

  tech_VeryGray =
  {
    env = "building",
    prob = 80,

    walls =
    {
      GRAY1 = 80,
      GRAY5 = 80,
      GRAY4 = 80,
      GRAY6 = 60,
      GRAY7 = 80,
      GRAY8 = 60,
      ICKWALL1 = 5,
      ICKWALL2 = 5,
      ICKWALL3 = 5,
    },

    floors =
    {
      FLAT4 = 50,
      FLOOR0_3 = 30,
      FLAT5_4 = 25,
      FLAT19 = 15,
      TILES4 = 15,
      TILES5 = 10,
      TILES6 = 10,
      FLOOR0_5 = 10,
      FLOOR4_7 = 15,
      SHINY01 = 5,
      SHINY02 = 5,
      SHINY03 = 10,
      GMET07  = 3,
    },

    ceilings =
    {
      FLAT19 = 40,
      FLAT5_4 = 20,
      FLAT4  = 20,
      FLAT23 = 10,
      FLAT1 = 10,
      FLOOR4_7 = 5,
      SHINY02 = 5,
      RROCK21 = 5,
      SHINY04 = 5,
      SLIME14 = 10,
      SLIME15 = 10,
    },
  },

  tech_VeryBrown =
  {
    env = "building",
    prob = 60,

    walls =
    {
      BROWN1 = 30,
      BROWN3 = 5,
      BROWNGRN = 20,
      BROWNGR2 = 5,
      BROWNGR3 = 5,
      BROWNGR4 = 5,
      BROWN96 = 10,
      BROVINE = 5,
      BROVINE2 = 5,
    },

    floors =
    {
      FLOOR0_1 = 30,
      FLOOR0_2 = 20,
      FLOOR3_3 = 20,
      FLOOR7_1 = 15,
      FLOOR4_5 = 30,
      FLOOR4_6 = 30,
      FLOOR5_2 = 30,
      FLAT5 = 20,
      FLAT14 = 15,
      FLAT5_4 = 10,
      FLOOR46D = 10,
      FLOOR46E = 10,
      DARKF01 = 5,
      DARKF02 = 5,
    },

    ceilings =
    {
      CEIL5_1 = 20,
      CEIL3_3 = 15,
      CEIL3_5 = 50,
      FLAT1 = 20,
      FLOOR4_1 = 30,
      FLAT5_4 = 10,
      FLOOR5_4 = 10,
      QFLAT09 = 5,
    },
  },

  tech_phoboscave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {
      ASH01 = 30,
      ASH02 = 15,
      ASH03 = 30,
      ASH05 = 40,
      ROK02 = 20,
      SP_ROCK1 = 50,
      SP_ROCK2 = 10,
      ROK04 = 20,
      ROK05 = 30,
      ROK06 = 50,
      ROK07 = 15,
      ROK12 = 30,
      ROK13 = 30,
      ROK14 = 60,
      ROK15 = 60,
      ROK20 = 20,
      ROK21 = 25,
      ROK22 = 30,
      ROK23 = 30,
      ROK24 = 10,
      ROK25 = 15,
      ROK26 = 15
    },

    floors =
    {
      FLAT10 = 80,
      MFLR8_3 = 40,
      RROCK03 = 50,
      RROCK09 = 20
    },

    ceilings =
    {
      FLAT10 = 60,
      MFLR8_3 = 50,
      RROCK03 = 40,
      RROCK09 = 40
    },
  },

-- DEIMOS THEMES --

  deimos_icky =
  {
    env = "building",
    prob = 70,

    walls =
    {
      ICKWALL1 = 60,
      ICKWALL2 = 20,
      ICKWALL3 = 40,
    },

    floors =
    {
      FLAT4 = 30,
      FLOOR0_3 = 50,
      FLAT5_4 = 25,
      FLAT19 = 15,
      TILES4 = 15,
      TILES5 = 10,
      TILES6 = 10,
      FLOOR0_5 = 10,
      FLOOR4_7 = 15,
      SHINY01 = 5,
      SHINY02 = 5,
      SHINY03 = 10,
      GMET07  = 3,
    },

    ceilings =
    {
      FLAT19 = 40,
      FLAT5_4 = 20,
      FLAT4  = 20,
      FLAT23 = 10,
      FLAT1 = 10,
      FLOOR4_7 = 5,
      SHINY02 = 5,
      RROCK21 = 5,
      SHINY04 = 5,
    },
  },

  deimos_Cement =
  {
    env = "building",
    prob = 80,

    walls =
    {
      CEM03 = 15,
      CEM04 = 15,
      CEM06 = 120,
      CEM07 = 120,
      CEM09 = 120,
    },

    floors =
    {
      FLAT1 = 50,
      FLAT5_4 = 40,
      GRATE1  = 15,
      GRATE2  = 15,
      FLOOR4_8 = 10,
      FLOOR5_1 = 10,
      FLOOR51C = 10,
      FLOOR46D = 15,
      FLOOR46E = 15,
      DARKF01 = 15,
      DARKF02 = 15,
    },

    ceilings =
    {
      FLAT19 = 50,
      FLAT5_4 = 20,
      MFLR8_1 = 15,
      FLAT5_2 = 5,
      CEIL1_1 = 5,
      FLAT5_2 = 5,
      GRATE4  = 10,
    },
  },

  deimos_deimoscave =
  {
    env  = "cave",
    prob = 60,

    walls =
    {
    ASH01 = 40,
    ASH02 = 25,
    ASH03 = 30,
    ASH05 = 40,
    ROK02 = 25,
    SP_ROCK1 = 65,
    SP_ROCK2 = 15,
    ROK04 = 20,
    ROK05 = 40,
    ROK06 = 60,
    ROK07 = 20,
    ROK12 = 30,
    ROK13 = 30,
    ROK14 = 80,
    ROK15 = 80,
    ROK20 = 40,
    ROK21 = 35,
    ROK22 = 30,
    ROK23 = 30,
    ROK24 = 20,
    ROK25 = 15,
    ROK26 = 25,
    },

    floors =
    {
     FLAT10 = 40,
     MFLR8_3 = 70,
     RROCK03 = 50,
     RROCK09 = 20,
    },

    ceilings =
    {
     FLAT10 = 30,
     MFLR8_3 = 80,
     RROCK03 = 40,
     RROCK09 = 20,
    },
  },

 -- HELL THEMES --

  hell_ReisalGothic =
  {
    env  = "building",
    prob = 130,

    walls =
    {
      GOTH01 = 15,
      GOTH02 = 15,
      GOTH03 = 15,
      GOTH06 = 15,
      GOTH07 = 15,
      GOTH08 = 15,
      GOTH09 = 15,
      GOTH10 = 15,
      GOTH11 = 15,
      GOTH12 = 15,
      GOTH13 = 15,
      GOTH14 = 15,
      GOTH15 = 15,
      GOTH16 = 15,
      GOTH17 = 15,
      GOTH18 = 15,
      GOTH23 = 15,
      GOTH24 = 15,
      GOTH25 = 15,
      GOTH26 = 15,
      GOTH27 = 15,
      GOTH28 = 15,
      GOTH34 = 15,
      GOTH35 = 15,
      GOTH36 = 15,
      GOTH37 = 15,
      GOTH38 = 15,
      GOTH39 = 15,
      GOTH40 = 15,
      GOTH41 = 15,
      GOTH42 = 15,
      GOTH43 = 15,
      GOTH44 = 15,
      GOTH45 = 15,
      GOTH46 = 15,
      GOTH47 = 15,
      GOTH48 = 15,
      GOTH49 = 15,
    },

    floors =
    {
      GRNROCK  = 30,
      FLAT5_4  = 30,
      FLAT5_1  = 30,
      FLOOR7_1 = 30,
      DEM1_6   = 15,
      FLAT5_1  = 5,
      FLAT5_2  = 5,

      FLAT10   = 10,
      FLOOR6_2 = 10,
      MFLR8_2  = 10,

      G01 = 40,
      G02 = 40,
      G03 = 40,
      G04 = 40,
      G05 = 40,
      G06 = 40,
      G07 = 40,
      G08 = 40,
      G09 = 40,
      G10 = 40,
      G11 = 40,
      G12 = 40,
      G13 = 40,
      G14 = 40,
      G15 = 40,
      G16 = 40,
      G17 = 40,
      G18 = 40,
      G19 = 40,
      G20 = 40,
      G21 = 40,

      GMET01 = 90,
      GMET02 = 90,
      GMET03 = 90,
      GMET04 = 90,
      GMET05 = 90,
      GMET06 = 90,
      GMET07 = 90,
    },

    ceilings =
    {
      FLOOR7_2 = 50,
      DEM1_5   = 20,
      FLOOR6_1 = 20,
      FLOOR6_2 = 20,
      MFLR8_4  = 15,
    },
  },

  hell_Cement =
  {
    env = "building",
    prob = 100,

    walls =
    {
      CEM03 = 25,
      CEM04 = 25,
      CEM06 = 75,
      CEM07 = 75,
      CEM09 = 75,
      DRKCMT01 = 20,
      DRKCMT02 = 20,
      DRKCMT03 = 20,
      DRKCMT04 = 20,
      HELLCMT1 = 20,
      HELLCMT2 = 20,
      HELLCMT3 = 20,
      HELLCMT4 = 20,
      HELLCMT5 = 20,
      HELLCMT6 = 20,
      HELLCMT7 = 15,
      HELLCMT8 = 15,

      BRONZEG1 = 15,
      BRONZEG2 = 15,
      BRONZEG3 = 15,
      KMARBLE1 = 15,
      KMARBLE2 = 15,
      KMARBLE3 = 15,
      REDMARB1 = 15,
      REDMARB2 = 15,
      REDMARB3 = 15,
    },

    floors =
    {
      FLAT1 = 30,
      FLAT5_4 = 20,
      FLAT5_2 = 5,
      FLAT5_1 = 5,
      GRATE1  = 10,
      GRATE2  = 10,
      GRATE7  = 10,
      FLOOR4_8 = 10,
      FLOOR5_1 = 10,
      FLOOR51C = 10,
      FLOOR46D = 10,
      FLOOR46E = 10,
      DARKF01 = 10,
      DARKF02 = 10,

      G04 = 10,
      G05 = 10,
      G06 = 10,
      G07 = 10,
      G08 = 10,
      G09 = 10,
      G10 = 10,
      G12 = 10,
      G13 = 10,
      G14 = 10,
      G15 = 10,
      G18 = 10,
      G20 = 10,
      G21 = 10,
    },

    ceilings =
    {
      FLAT19 = 10,
      FLAT5_4 = 10,
      MFLR8_1 = 15,
      FLAT5_2 = 5,
      CEIL1_1 = 5,
      FLAT5_2 = 5,
      GRATE4  = 10,
      GRATE8  = 10,

      G04 = 10,
      G05 = 10,
      G06 = 10,
      G07 = 10,
      G08 = 10,
      G09 = 10,
      G10 = 10,
      G12 = 10,
      G14 = 10,
      G15 = 10,
      G18 = 10,
      G20 = 10,
      G21 = 10,
    },
  },

  hell_fleshcraft =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SKIN2 = 10,
      SKIN3 = 10,
      SKIN4 = 10,
      SKINMET1 = 30,
      SKINMET2 = 30,
      SKINLOW1 = 30,
      SKINMET3 = 20,
      SKINMET4 = 20,
      SKINMET5 = 30,
      SKINMET6 = 10,
      SKINMET7 = 10,
      SKINTEK1 = 15,
      SKINTEK2 = 15,
    },

    floors =
    {
      FLAT5_1 = 50,
      FLAT5_2 = 50,
      FLAT5 = 30,
      WOODTIL = 30,
      WOODTI2 = 30,
      FLOOR46D = 30,
      FLOOR46E = 30,
      G13 = 20,
    },

    ceilings =
    {
      CEIL1_1 = 50,
      FLAT5_2 = 50,
      G02 = 30,
      G03 = 30,
      FLOOR7_2 = 15,
      FLOOR7_3 = 15,
    },
  },

  hell_blackened =
  {
    env  = "building",
    prob = 40,

    walls =
    {
      KSTONE1 = 50,
      KMARBLE2 = 50,
      KMARBLE3 = 50,
      KMARBLE1 = 20,
    },

    floors =
    {
      BMARB1 = 50,
      BMARB2 = 50,
      BMARB3 = 20,
    },

    ceilings =
    {
      BMARB3 = 100,
      BMARB1 = 30,
    },
  },


  hell_crimson =
  {
    env  = "building",
    prob = 40,

    walls =
    {
      REDMARB1 = 20,
      REDMARB2 = 60,
      REDMARB3 = 60,
    },

    floors =
    {
      RMARB1 = 50,
      RMARB2 = 50,
      RMARB3 = 20,
    },

    ceilings =
    {
      RMARB3 = 100,
      RMARB1 = 30,
    },
  },


  hell_armaetuscave =
  {
    env  = "cave",
    prob = 60,

    walls =
    {
      RDROK1   = 80,
      RDROK2   = 80,
      SP_ROCK1 = 50,
      SP_ROCK2 = 20,
      ASH05    = 50,
      ROK04    = 35,
      ROK05    = 35,
      ROK12    = 35,
      ROK13    = 35,
      ROK14    = 30,
      ROK15    = 30,
      ROK20    = 20,
      ROK21    = 20,
      ROK22    = 20,
      ROK23    = 20,
      ROK24    = 15,
      ROK25    = 15,
      ROK26    = 10,
    },

    floors =
    {
      FLAT10 = 60,
      MFLR8_3 = 50,
      RROCK03 = 50,
      RROCK09 = 30,
    },
  },

  hell_fireycave =
  {
    env  = "cave",
    prob = 70,

    light_adjusts = { 32,48,64 },

    walls =
    {
      ROCKRED1 = 50,
      HELLROK1 = 30,
      RDROK1   = 20,
      RDROK2   = 20,
      CRACKRED = 15,
      CRACKRD2 = 15,
      FIREBLU1 = 15,
      CRAK01 =  5,
      CRAK02 =  5,
      FIREBLK1 =  3,
    },

    floors =
    {
      FLOOR6_2 = 40,
      FLOOR6_1 = 20,

      RROCK01  = 20,
      RROCK05  = 20,
      RROCK03  = 10,
      RROCK02  = 5,
    },
  },

  -- Hell has frozen over!
  hell_icecave =
  {
    env  = "cave",
    prob = 40,

    light_adjusts = { 8,16,24 },

    walls =
    {
    SNOW03 = 50,
    SNOW07 = 100,
    SNOW08 = 100,
    SNOW09 = 100,
    SNOW10 = 100,
    SNOW11 = 100,
    SNOW12 = 100,
    SNOW13 = 100,
    SNOW14 = 100,
    },

    floors =
    {
    SNOW1 = 50,
    SNOW5 = 50,
    SNOW6 = 50,
    SNOW7 = 50,
    SNOW8 = 50,
    },
  },

-- THY FLESH CONSUMED THEMES --

  flesh_MoreWood =
  {
    env = "building",
    prob = 150,

    walls =
    {
      WOOD1 = 50,
      WOOD3 = 50,
      WOOD5 = 50,
      WD03   = 50,
      WD04   = 50,
      WOOD15 = 50,
      WOOD16 = 50,
      WOOD17 = 50,
      WOOD18 = 30,
    },

    floors =
    {
      FLAT5_1 = 80,
      FLAT5_2 = 80,
      FLAT5_5 = 50,

      CARPET1 = 15,
      CARPET2 = 15,
      CARPET3 = 15,
      CARPET4 = 15,
      CARPET5 = 15,
      CARPET6 = 15,
      CARPET7 = 15,
      CARPET8 = 15,

      WOODTIL = 30,
      WOODTI2 = 30,
      FFLAT01 = 30,
    },

    ceilings =
    {
    CEIL1_1 = 70,
    FLAT5_2 = 50,
    GSTN01  = 30,
    GSTN02  = 30,
    SLIME14 = 20,
    SLIME15 = 20,

    },
  },

  flesh_MoreWood =
  {
    env = "building",
    prob = 150,

    walls =
    {
      WOOD1 = 50,
      WOOD3 = 50,
      WOOD5 = 50,
      WD03   = 50,
      WD04   = 50,
      WOOD15 = 50,
      WOOD16 = 50,
      WOOD17 = 50,
      WOOD18 = 35,
    },

    floors =
    {
      FLAT5_1 = 80,
      FLAT5_2 = 80,
      FLAT5_5 = 50,

      CARPET1 = 15,
      CARPET2 = 15,
      CARPET3 = 15,
      CARPET4 = 15,
      CARPET5 = 15,
      CARPET6 = 15,
      CARPET7 = 15,
      CARPET8 = 15,

      WOODTIL = 30,
      WOODTI2 = 30,
      FFLAT01 = 30,
    },

    ceilings =
    {
    CEIL1_1 = 70,
    FLAT5_2 = 50,
    GSTN01  = 30,
    GSTN02  = 30,
    SLIME14 = 20,
    SLIME15 = 20,

    },
  },

  flesh_armaetuscave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {

    SP_ROCK1 = 60,
    SP_ROCK2 = 20,
    ASH05    = 50,
    ROK04    = 35,
    ROK05    = 35,
    ROK12    = 35,
    ROK13    = 35,
    ROK14    = 30,
    ROK15    = 30,
    ROK20    = 20,
    ROK21    = 20,
    ROK22    = 20,
    ROK23    = 20,
    ROK24    = 15,
    ROK25    = 15,
    ROK26    = 10,
    },

    floors =
    {
     FLAT10 = 60,
     MFLR8_3 = 50,
     RROCK03 = 50,
     RROCK09 = 30,
     FLAT5_4 = 10,
    },
  },

  flesh_ashblack =
  {
    env  = "building",
    prob = 40,

    walls =
    {
      KSTONE1 = 50,
      KMARBLE2 = 50,
      KMARBLE3 = 50,
      KMARBLE1 = 20,
    },

    floors =
    {
      BMARB1 = 50,
      BMARB2 = 50,
      BMARB3 = 20,
    },

    ceilings =
    {
      BMARB3 = 100,
      BMARB1 = 30,
    },
  },


  flesh_bloodred =
  {
    env  = "building",
    prob = 40,

    walls =
    {
      REDMARB1 = 20,
      REDMARB2 = 60,
      REDMARB3 = 60,
    },

    floors =
    {
      RMARB1 = 50,
      RMARB2 = 50,
      RMARB3 = 20,
    },

    ceilings =
    {
      RMARB3 = 100,
      RMARB1 = 30,
    },
  },

  flesh_skincraft =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SKIN2 = 10,
      SKIN3 = 10,
      SKIN4 = 10,
      SKINMET1 = 30,
      SKINMET2 = 30,
      SKINLOW1 = 30,
      SKINMET3 = 20,
      SKINMET4 = 20,
      SKINMET5 = 30,
      SKINMET6 = 10,
      SKINMET7 = 10,
      SKINTEK1 = 15,
      SKINTEK2 = 15,
    },

    floors =
    {
      FLAT5_1 = 50,
      FLAT5_2 = 50,
      FLAT5 = 30,
      WOODTIL = 30,
      WOODTI2 = 30,
      FLOOR46D = 30,
      FLOOR46E = 30,
      G13 = 20,
    },

    ceilings =
    {
      CEIL1_1 = 50,
      FLAT5_2 = 50,
      G02 = 30,
      G03 = 30,
      FLOOR7_2 = 15,
      FLOOR7_3 = 15,
    },
  },
}

OBS_RESOURCE_PACK_DOOM1_THEMES =
{
  tech =
  {
    ceiling_sinks =
    {
      light_TLITE5_1 = 7,
      light_TLITE5_2 = 7,
      light_TLITE5_3 = 7,
      light_TLITE65B = 7,
      light_TLITE65G = 7,
      light_TLITE65O = 7,
      light_TLITE65W = 7,
      light_TLITE65Y = 7,
      light_LIGHTS1 = 7,
      light_LIGHTS2 = 7,
      light_LIGHTS3 = 7,
      light_LIGHTS4 = 7,
    },

    facades =
    {
      STARTAN3 = 50,
      STARG3 = 50,

      GRAY6 = 25,
      GRAY8 = 25,
      GRAY9 = 25,

      STONE  = 20,
      STONE2 = 20,
      STONE3 = 20,

      BROWN1 = 20,
      BROWNGRN = 20,
      BROVINE = 25,
      BROVINE2 = 20,
      BROWNGR2 = 10,
      BROWNGR3 = 10,
      BROWNGR4 = 10,
      GRAYVINE = 20,

      TEKSHAW  = 15,
      TEKGRY01 = 15,
      TEKGRY02 = 10,

      GRAYMET2 = 10,
      GRAYMET3 = 10,
      GRAYMET4 = 10,
      GRAYMET5 = 10,
      BROWN2   = 10,
      BROWN3   = 10,

      SHAWN4 = 15,
      SHAWN5 = 15,
      HEX01 = 15,
    },

    floor_sinks =
    {
      liquid_warning_strip = 10,
    },

    wall_groups =
    {
      gtd_wall_server_room2 = 25,
      gtd_collite_set_green = 7,
      gtd_collite_set_orange = 7,
      gtd_collite_set_blue = 7,
      gtd_collite_set_red = 7,
      gtd_wall_lit_box_blue = 9,
      gtd_wall_lit_box_red = 9,
      gtd_wall_lit_box_white = 9,
      gtd_wall_metal_warning = 15,
      gtd_wall_vertical_light_1 = 8,
      gtd_wall_vertical_light_2 = 8,
      gtd_wall_vertical_light_3 = 8,
      gtd_wall_hydroponics = 15,
      gtd_computers_shawn = 10,
      gtd_computers_compsta = 10,
    },

    scenic_fences =
    {
      FENCE1 = 10,
      FENCE2 = 10,
      FENCE3 = 7,
      FENCE6 = 5,
      FENCE7 = 5,
      FENCE8 = 5,
      FENCE9 = 3,
      FENCEA = 5,
      FENCEB = 3,
      FENCEC = 3,
      RAIL1 = 10,
      BARBWIRE = 2,
      MIDWIND4 = 3,
      MIDWIND6 = 3,
      MIDSPAC2 = 2,
      MIDSPAC4 = 5,
      MIDSPAC5 = 5,
      MIDSPAC8 = 3,
      MIDVINE1 = 1,
      MIDVINE2 = 1,
    },

    skyboxes =
    {
      Skybox_tech_ffvii_EPIC = 50,
      Skybox_craneo_fishing_village_EPIC = 50,
      Skybox_hellish_city_EPIC = 50,
    },
  },

  deimos =
  {
    ceiling_sinks =
    {
      light_TLITE5_1 = 7,
      light_TLITE5_2 = 7,
      light_TLITE5_3 = 7,
      light_TLITE65B = 7,
      light_TLITE65G = 7,
      light_TLITE65O = 7,
      light_TLITE65W = 7,
      light_TLITE65Y = 7,
      light_LIGHTS1 = 7,
      light_LIGHTS2 = 7,
      light_LIGHTS3 = 7,
      light_LIGHTS4 = 7,
    },

    facades =
    {
      STARTAN3 = 40,
      STARG3 = 40,

      GRAY6 = 15,
      GRAY8 = 15,
      GRAY9 = 15,

      STONE  = 20,
      STONE2 = 30,
      STONE3 = 30,

      BROWN1 = 30,
      BROWNGRN = 20,
      BROVINE = 50,
      BROVINE2 = 20,
      BROWNGR2 = 10,
      BROWNGR3 = 10,
      BROWNGR4 = 10,
      GRAYVINE = 20,

      TEKSHAW  = 15,
      TEKGRY01 = 15,
      TEKGRY02 = 10,

      BROWN2   = 10,
      BROWN3   = 10,
    },

    floor_sinks =
    {
      liquid_warning_strip = 10,
    },

    wall_groups =
    {
      gtd_wall_server_room2 = 25,
      gtd_collite_set_green = 7,
      gtd_collite_set_orange = 7,
      gtd_collite_set_blue = 7,
      gtd_collite_set_red = 7,
      gtd_wall_churchy_glass = 25,
      gtd_wall_lit_box_blue = 9,
      gtd_wall_lit_box_red = 9,
      gtd_wall_lit_box_white = 9,
      gtd_g99 = 15,
      gtd_wall_metal_warning = 15,
      gtd_wall_vertical_light_1 = 8,
      gtd_wall_vertical_light_2 = 8,
      gtd_wall_vertical_light_3 = 8,
      gtd_computers_shawn = 10,
      gtd_computers_compsta = 10,
    },

    scenic_fences =
    {
      FENCE1 = 10,
      FENCE2 = 10,
      FENCE3 = 7,
      FENCE6 = 5,
      FENCE7 = 5,
      FENCE8 = 5,
      FENCE9 = 3,
      FENCEA = 5,
      FENCEB = 3,
      FENCEC = 4,
      RAIL1 = 10,
      BARBWIRE = 2,
      MIDWIND4 = 3,
      MIDWIND6 = 3,
      MIDSPAC2 = 2,
      MIDSPAC4 = 5,
      MIDSPAC5 = 5,
      MIDSPAC8 = 3,
      MIDVINE1 = 1,
      MIDVINE2 = 1,
    },

    skyboxes =
    {
      Skybox_tech_ffvii_EPIC = 50,
      Skybox_generic_EPIC = 50,
      Skybox_hellish_city_EPIC = 50,
    },
  },

  hell =
  {
    ceiling_sinks =
    {
      light_GLITE01 = 10,
      light_GLITE02 = 10,
      light_GLITE03 = 10,
      light_GLITE04 = 10,
      light_GLITE05 = 10,
      light_GLITE06 = 10,
      light_GLITE07 = 10,
      light_GLITE08 = 10,
      light_GLITE09 = 10,

      light_GLITE05_BLUE = 8,
      light_GLITE05_GREEN = 8,
      light_GLITE05_RED = 8,
      light_GLITE05_WHITE = 8,
      light_GLITE05_YELLOW = 8,
    },

    facades =
    {
      GSTONE1 = 50,
      WOOD5   = 50,
      WOOD3   = 50,

      MARBLE  = 25,
      MARBLE1 = 25,
      MARBLE2 = 25,
      MARBLE3 = 25,
      MBGRY = 25,
      BLAKMBGY = 20,

      SP_HOT1 = 20,
      SP_HOT2 = 20,
      SP_HOT3 = 20,
      STONE   = 20,
      STON4  = 15,
      STON6  = 15,
      STONE8  = 5,
      STONE9  = 5,

      GOTH08 = 20,
      GOTH09 = 20,
      GOTH10 = 20,
      GOTH11 = 20,
      GOTH28 = 10,
      GOTH29 = 20,
      GOTH30 = 20,
      GOTH31 = 20,
      BRIKS35 = 15,
      BRIKS36 = 15,
      GSTONE3 = 10,

      MARBLE4 = 15,
      MARBLE5 = 15,
      MARBLE6 = 15,
      MARBLE7 = 10,
      MARBLE8 = 10,
      MM203   = 10,
      MM204   = 10,
      MM205   = 15,
      MM206   = 10,
      MM207   = 10,
      MMT208  = 10,
      MMT209  = 10,
      MMT210  = 10,

      HELMET1 = 20,
      HELMET2 = 20,
      CATACMB3 = 10,
      CATACMB6 = 10,

      HELLCMT1 = 15,
      HELLCMT8 = 15,
      SKINTEK1 = 15,
      SKINTEK2 = 15,
      KSTONE1 = 10,
      KMARBLE2 = 5,
      KMARBLE3 = 5,
      KMARBLE1 = 5,

      SKINMET3 = 15,
      SKINMET4 = 15,
      SKINMET5 = 15,
      SKINMET6 = 5,
      SKINMET7 = 5,
      VINES1   = 5,
      VINES2   = 5,
      VINES3   = 5,
      VINES4   = 5,
      WDMET03  = 5,

      BROWN1   = 5,
      BROVINE   = 10,
    },

    wall_groups =
    {
      gtd_tall_glass_epic_yellow = 15,
      gtd_tall_glass_epic_orange = 15,
      gtd_tall_glass_epic_red = 15,
      gtd_tall_glass_epic_blue = 15,
      gtd_wall_churchy_glass = 25,
      armaetus_catacomb_wall_set = 40,
      gtd_winglass_wall = 25,
      gtd_collite_set_green = 7,
      gtd_collite_set_orange = 7,
      gtd_collite_set_blue = 7,
      gtd_collite_set_red = 7,
      gtd_g99 = 25,
      armaetus_wallbodies = 8,
      armaetus_wallbodies_bloody = 8,
      armaetus_wallbodies_old = 8,
      armaetus_wallbodies_bones = 8,
      gtd_wall_metal_warning = 20,
      gtd_wall_vertical_light_1 = 7,
      gtd_wall_vertical_light_2 = 7,
      gtd_wall_vertical_light_3 = 7,
    },

    window_groups =
    {
      gtd_window_gothic_epic = 80,
    },

    scenic_fences =
    {
      FENCE2 = 5,
      FENCE4 = 10,
      FENCE5 = 10,
      FENCE8 = 2,
      FENCE9 = 4,
      FENCEA = 2,
      FENCEB = 4,
      FENCEC = 2,
      RAIL1 = 4,
      BARBWIRE = 2,
      MIDVINE1 = 4,
      MIDVINE2 = 4,
      MIDWIND1 = 7,
      MIDWIND2 = 10,
      MIDWIND3 = 7,
      MIDWIND4 = 4,
      MIDWIND5 = 8,
      MIDWIND6 = 5,
      MIDWIND7 = 7,
      MIDSPAC2 = 5,
      MIDSPAC3 = 5,
      MIDSPAC6 = 5,
      MIDSPAC7 = 2,
      MIDSPAC8 = 4,
    },

    skyboxes =
    {
      Skybox_hellish_city_EPIC = 50,
      Skybox_garrett_hell_EPIC = 50,
    },
  },

  flesh =
  {
    ceiling_sinks =
    {
      light_GLITE01 = 10,
      light_GLITE02 = 10,
      light_GLITE03 = 10,
      light_GLITE04 = 10,
      light_GLITE05 = 10,
      light_GLITE06 = 10,
      light_GLITE07 = 10,
      light_GLITE08 = 10,
      light_GLITE09 = 10,
    },

    facades =
    {
      WOOD5   = 90,
      WOOD3   = 90,
      WOOD1   = 90,
      GSTONE1 = 75,
      WOOD16  = 70,
      WOOD17  = 70,
      WOOD18  = 40,
      WD04    = 65,
      SP_HOT1 = 40,
      SP_HOT3 = 20,

      GOTH01 = 25,
      GOTH02 = 25,
      GOTH08 = 25,
      GOTH15 = 25,
      GOTH25 = 25,
      GOTH26 = 25,
      GOTH28 = 25,
      GOTH29 = 25,
      GOTH30 = 25,
      GOTH31 = 31,

      MARBLE  = 20,
      MARBLE1 = 20,
      MARBLE2 = 20,
      MARBLE3 = 20,

      STONE   = 20,
      SKINTEK1 = 20,
      SKINTEK2 = 20,

      BRIKS35 = 15,
      BRIKS36 = 15,
      GSTONE3 = 10,

      MM205   = 15,
      MM206   = 10,
      MM207   = 10,
      MMT208  = 10,
      MMT209  = 10,
      MMT210  = 10,

      CATACMB3 = 10,
      CATACMB6 = 10,

      HELLCMT1 = 15,
      HELLCMT8 = 15,
      KSTONE1 = 10,
      KMARBLE2 = 5,
      KMARBLE3 = 5,
      KMARBLE1 = 5,

      BROWN1   = 5,
      BROVINE  = 10,
    },

    wall_groups =
    {
      gtd_tall_glass_epic_yellow = 15,
      gtd_tall_glass_epic_orange = 15,
      gtd_tall_glass_epic_red = 15,
      gtd_tall_glass_epic_blue = 15,
      gtd_wall_churchy_glass = 30,
      armaetus_catacomb_wall_set = 40,
      armaetus_catacombs_brown = 40,
      gtd_winglass_wall = 25,
      gtd_collite_set_green = 7,
      gtd_collite_set_orange = 7,
      gtd_collite_set_blue = 7,
      gtd_collite_set_red = 7,
      gtd_g99 = 25,
      armaetus_wallbodies = 8,
      armaetus_wallbodies_bloody = 8,
      armaetus_wallbodies_old = 8,
      armaetus_wallbodies_bones = 8,
      gtd_wall_vertical_light_1 = 6,
      gtd_wall_vertical_light_2 = 6,
      gtd_wall_vertical_light_3 = 6,
    },

    window_groups =
    {
      gtd_window_gothic_epic = 80,
    },

    scenic_fences =
    {
      FENCE2 = 5,
      FENCE4 = 10,
      FENCE5 = 10,
      FENCE8 = 2,
      FENCE9 = 4,
      FENCEA = 2,
      FENCEB = 4,
      FENCEC = 4,
      RAIL1 = 4,
      BARBWIRE = 3,
      MIDVINE1 = 4,
      MIDVINE2 = 4,
      MIDWIND1 = 7,
      MIDWIND2 = 10,
      MIDWIND3 = 7,
      MIDWIND4 = 4,
      MIDWIND5 = 8,
      MIDWIND6 = 5,
      MIDWIND7 = 7,
      MIDSPAC2 = 5,
      MIDSPAC3 = 5,
      MIDSPAC6 = 5,
      MIDSPAC7 = 2,
      MIDSPAC8 = 4,
    },

    skyboxes =
    {
      Skybox_craneo_fishing_village_EPIC = 50,
      Skybox_generic_EPIC = 50,
      Skybox_hellish_city_EPIC = 50,
      Skybox_garrett_hell_EPIC = 50,
    },
  },
}

-- Custom liquids
OBS_RESOURCE_PACK_DOOM1_LIQUIDS =
{
  tech =
  {
    liquids =
    {
      hotlava = 3,
      magma   = 3,
      qlava   = 3,
      purwater = 15,
      bsludge  = 40,
      gwater  = 50,
      ice     = 20,
      ice2    = 20,
    },
  },

  deimos =
  {
    liquids =
    {
      hotlava = 3,
      magma   = 3,
      qlava   = 3,
      purwater = 15,
      bsludge  = 15,
      gwater  = 40,
      ice     = 20,
      ice2    = 20,
    },
  },

  hell =
  {
    liquids =
    {
      hotlava = 80,
      magma   = 80,
      qlava   = 80,
      purwater = 5,
      bsludge  = 20,
      gwater  = 25,
      ice     = 40,
      ice2    = 40,
    },
  },

  flesh =
  {
    liquids =
    {
      hotlava = 80,
      magma   = 60,
      qlava   = 60,
      purwater = 10,
      bsludge  = 30,
      gwater  = 25,
      ice     = 30,
      ice2    = 30,
    },
  },
}

-- MSSP-TODO: Could probably use an update with some of the more ceiling sink types
-- defined from the main Epic themes table. Maybe unify the sink defs
-- from the Doom2 tables with these ones?

-- Custom sink definitions as well as probability tables.
OBS_RESOURCE_PACK_DOOM1_SINK_DEFS =
{
  liquid_warning_strip =
  {
    mat = "_LIQUID",
    dz  = -8,

    trim_mat = "WARN1",
    trim_dz  = 0,
  },

  light_TLITE5_1 =
  {
    mat = "TLITE5_1",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_TLITE5_2 =
  {
    mat = "TLITE5_2",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_TLITE5_3 =
  {
    mat = "TLITE5_3",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_TLITE65B =
  {
    mat = "TLITE65B",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_TLITE65G =
  {
    mat = "TLITE65G",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_TLITE65O =
  {
    mat = "TLITE65O",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_TLITE65W =
  {
    mat = "TLITE65W",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_TLITE65Y =
  {
    mat = "TLITE65Y",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_LIGHTS1 =
  {
    mat = "LIGHTS1",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_LIGHTS2 =
  {
    mat = "LIGHTS2",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_LIGHTS3 =
  {
    mat = "LIGHTS3",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_LIGHTS4 =
  {
    mat = "LIGHTS4",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE01 =
  {
    mat = "GLITE01",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE02 =
  {
    mat = "GLITE02",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE03 =
  {
    mat = "GLITE03",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE04 =
  {
    mat = "GLITE04",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE05 =
  {
    mat = "GLITE05",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE06 =
  {
    mat = "GLITE06",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE07 =
  {
    mat = "GLITE07",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE08 =
  {
    mat = "GLITE08",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE09 =
  {
    mat = "GLITE09",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  --
  light_GLITE05_BLUE =
  {
    mat = "T_GLT5BL",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE05_BLUE =
  {
    mat = "T_GLT5BL",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE05_GREEN =
  {
    mat = "T_GLT5GN",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE05_RED =
  {
    mat = "T_GLT5RD",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE05_WHITE =
  {
    mat = "T_GLT5WT",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  },

  light_GLITE05_YELLOW =
  {
    mat = "T_GLT5YL",
    dz  = 8,
    light = 32,

    trim_mat = "METAL",
    trim_dz  = -5,
    trim_light = 16,
  }
}

-- Natural textures for outdoor parks.
OBS_RESOURCE_PACK_DOOM1_TECH_NATURALS =
{
  ALTASH = 20,
  ASH05 = 20,
  ROK04 = 30,
  ROK05 = 10,
  ROK06 = 30,
  ROK12 = 50,
  ROK13 = 30,
  ROK14 = 30,
  ROK15 = 30,
  ROK20 = 20,
  ROK21 = 50,
  ROK22 = 30,
  ROK23 = 20,
  VINES1 = 10,
  VINES2 = 10,
  VINES3 = 10,
  VINES4 = 10,
  MOSROK3 = 10,
}

OBS_RESOURCE_PACK_DOOM1_DEIMOS_NATURALS =
{
  ALTASH = 20,
  ASH05 = 20,
  ROK04 = 30,
  ROK05 = 10,
  ROK06 = 30,
  ROK12 = 50,
  ROK13 = 30,
  ROK14 = 30,
  ROK15 = 30,
  ROK20 = 20,
  ROK21 = 50,
  ROK22 = 30,
  ROK23 = 20,
  VINES1 = 10,
  VINES2 = 10,
  VINES3 = 10,
  VINES4 = 10,
  MOSROK3 = 10,
}

OBS_RESOURCE_PACK_DOOM1_HELL_NATURALS =
{
  ALTASH = 20,
  ASH05 = 40,
  ASHWALL1 = 10,
  ROK05 = 15,
  ROK12 = 10,
  ROK21 = 15,
  HELLROK1 = 40,
  RDROK1 = 30,
  RDROK2 = 35,
  SKIN3 = 6,
  SKIN4 = 6,
  VINES1 = 3,
  VINES2 = 3,
  VINES3 = 3,
  VINES4 = 3,
}

OBS_RESOURCE_PACK_DOOM1_FLESH_NATURALS =
{
  ALTASH = 20,
  ASH05 = 40,
  ASHWALL1 = 10,
  ROK05 = 15,
  ROK12 = 10,
  ROK21 = 15,
  MOSROK3 = 10,
  HELLROK1 = 40,
  RDROK1 = 30,
  RDROK2 = 35,
  SKIN3 = 6,
  SKIN4 = 6,
  VINES1 = 3,
  VINES2 = 3,
  VINES3 = 3,
  VINES4 = 3,
}

OBS_RESOURCE_PACK_NARROW_HALLWAYS =
{
}

OBS_RESOURCE_PACK_WIDE_HALLWAYS =
{
  ducts = 50,
}
