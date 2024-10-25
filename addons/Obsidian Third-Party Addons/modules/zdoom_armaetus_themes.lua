----------------------------------------------------------------
--  MODULE: Obsidian Resource Pack Themes
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
OBS_RESOURCE_PACK_ROOM_THEMES =
{
-- START OF HALLWAY THEMES
  any_ducts_Hallway =
  {
    env   = "hallway",
    group = "ducts",
    prob  = 1,

    walls =
    {
      GRAY5 = 1
    },

    floors =
    {
      FLAT1 = 1
    },

    ceilings =
    {
      FLAT1 = 1
    }
  },

  any_pipeline_Hallway =
  {
    env   = "hallway",
    group = "pipeline",
    prob  = 1,

    walls =
    {
      GRAY5 = 1
    },

    floors =
    {
      FLAT1 = 1
    },

    ceilings =
    {
      FLAT1 = 1
    }
  },

  any_hellcata_Hallway =
  {
    env   = "hallway",
    group = "hellcata",
    prob  = 1,

    walls =
    {
      GRAY5 = 1
    },

    floors =
    {
      FLAT1 = 1
    },

    ceilings =
    {
      FLAT1 = 1
    }
  },

  any_sewers_Hallway =
  {
    env   = "hallway",
    group = "sewers",
    prob  = 1,

    walls =
    {
      GRAY5 = 1
    },

    floors =
    {
      FLAT1 = 1
    },

    ceilings =
    {
      FLAT1 = 1
    }
  },

  any_organs_Hallway =
  {
    env   = "hallway",
    group = "organs",
    prob  = 1,

    walls =
    {
      GRAY5 = 1
    },

    floors =
    {
      FLAT1 = 1
    },

    ceilings =
    {
      FLAT1 = 1
    }
  },

  any_conveyor_Hallway =
  {
    env   = "hallway",
    group = "conveyor",
    prob  = 1,

    walls =
    {
      GRAY5 = 1
    },

    floors =
    {
      FLAT1 = 1
    },

    ceilings =
    {
      FLAT1 = 1
    }
  },

  any_conveyorh_Hallway =
  {
    env   = "hallway",
    group = "conveyorh",
    prob  = 1,

    walls =
    {
      GRAY5 = 1
    },

    floors =
    {
      FLAT1 = 1
    },

    ceilings =
    {
      FLAT1 = 1
    }
  },

-- ALL-THEMES

  any_greyBlocks =
  {
    env = "building",
    prob = 10,

    walls =
    {
      GOTH18 = 10,
      GOTH36 = 10,
      GOTH42 = 10,
      GOTH43 = 30,
      SPACEW5 = 30,
      SPACEW6 = 30
    },

    floors =
    {
      GRATE7 = 10,

      G09 = 10,
      G10 = 10,
      G14 = 10,
      G15 = 10,
      G16 = 10,
      G17 = 10,
      G18 = 10,

      SLIME14 = 10,
      SLIME15 = 10,
      SLIME16 = 10,

      STARG1F = 7,
      STARGRF = 7
    },

    ceilings =
    {
      G09 = 10,
      G10 = 10,
      G14 = 10,
      G15 = 10,
      G16 = 10,
      G17 = 10,
      G18 = 10,

      SLIME14 = 10,
      SLIME15 = 10,
      SLIME16 = 10,

      STARG1F = 7,
      STARGRF = 7
    }
  },

-- START OF TECH THEMES

  tech_GrayMet = --120
  {
    env = "building",
    prob = 120,

    walls =
    {
      GRAY6 = 50,
      GRAY8 = 50,

      GRAYMET1 = 20,
      GRAYMET2 = 20,
      GRAYMET3 = 20,
      GRAYMET4 = 20,
      GRAYMET5 = 20,

      METAL8 = 25,
      METAL9 = 25,
      METAL10 = 25,
      METAL11 = 25,

      SHAWGRY4 = 25,
      SHAWN01C = 25,
      SHAWN01E = 25,
      SHAWN01F = 25,
      SHAWSH04 = 25,

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

      PIPEWAL2 = 10,
      PIPES = 10,
      BROWNPIP = 10,
      PIPE2 = 10,

      PIPEDRK1 = 15,
      PIPESV1 = 10,
      PIPESV2 = 10,
      PIPESV3 = 10,
      PIPEWAL5 = 15,

      TEKWALL8 = 15,
      TEKWALL9 = 15,
      TEKWALLA = 10,
      TEKWALLB = 10,
      TEKWALLC = 10,
      TEKWALLD = 10,
      TEKWALLE = 10,

      OBTBSLV1 = 30,
      OBTBSLV2 = 20,
      OBTBSLV3 = 20,
      OBTBSLV4 = 30,
      OBTBSLV5 = 30,

      OBTBSTX1 = 30,
      OBTBSTX2 = 30,
      OBTBSTX3 = 30,

      OBTBSLB1 = 30,
      OBTBSLB1 = 30,

      G8_BR1GY = 20,
      G8_BR2GY = 20,
      G8_BR3GY = 20,

      OBTSBGRE = 10,

      OBTSVBZ1 = 20,
      OBTSVBZ2 = 20,
      OBTSVBZ3 = 20
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
      SLIME16 = 10,
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

      OBTBSFL3 = 20,

      OBTSVBF1 = 20,
      OBTSVBF2 = 20,
      OBTSVBF3 = 20
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

      OBTBSFL3 = 10
    }
  },

  tech_Computers = --15
  {
    prob = 15,
    env = "building",

    walls =
    {
      COMPSPAN = 30,
      CMPOHSO = 10,
      CMPTILE = 15,
      COMPBLUE = 10
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

      OBTBSFL1 = 5,
      OBTBSFL2 = 5,
      OBTBSFL3 = 5
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

      OBTBSFL3 = 10
    },

    keep_prob = 10
  },

  -- Multi colors here!
  --[[tech_ComputersMulti =
  {
    prob = 2,
    env = "building",

    walls =
    {
      COMPSPAN = 20,
      CMPOHSO = 10,
      CMPTILE = 20,
      COMPTIL2 = 20,
      COMPTIL3 = 10,
      COMPTIL4 = 20,
      COMPTIL5 = 20,
      COMPTIL6 = 20,
      COMPBLUE = 10,
      COMPGREN = 10,
      COMPRED  = 10
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
      CEIL4_4 = 20
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
      GRATE3  = 5
    },

    keep_prob = 10
  },

  -- single color comp rooms
  tech_ComputersRed =
  {
    prob = 3,
    env = "building",

    walls =
    {
      COMPSPAN = 20,
      CMPTILE = 20,
      COMPTIL2 = 20,
      COMPRED  = 10,
      TEKWALL8 = 20,
      GRAYMET9 = 20
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

      OBTBSFL1 = 15,
      OBTBSFL2 = 15,
      OBTBSFL3 = 15
    },

    ceilings =
    {
      CEIL5_1 = 20,
      CEIL5_2 = 20,
      FLOOR1_6 = 10,
      TEK1    = 20,
      QFLAT09 = 5,
      GRATE3  = 5,

      OBTBSFL3 = 10
    },

    keep_prob = 10
  },

  tech_ComputersBlue =
  {
    prob = 3,
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
      GRAYMETA = 15
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

      OBTBSFL1 = 15,
      OBTBSFL2 = 15,
      OBTBSFL3 = 15
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

      OBTBSFL3 = 10
    },

    keep_prob = 10
  },

  tech_ComputersGreen =
  {
    prob = 3,
    env = "building",

    walls =
    {
      TEKWALL9 = 20,
      COMPGREN = 20,
      COMPTIL4 = 20,
      GRAYMET8 = 15,

      OBTSTX1G = 10
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

      OBTBSFL1 = 15,
      OBTBSFL2 = 15,
      OBTBSFL3 = 15
    },

    ceilings =
    {
      CEIL5_1 = 20,
      CEIL5_2 = 20,
      TEK2    = 30,
      QFLAT09 = 5,
      GRATE3  = 5,

      OBTBSFL3 = 10
    },

    keep_prob = 10
  },

  tech_ComputersYellowish =
  {
    prob = 3,
    env = "building",

    walls =
    {
      TEKWALLE = 20,
      COMPTIL5 = 20,
      COMPTIL3 = 8,
      COMPBLAK = 8,
      GRAYMETC = 8,

      OBTSTX1B = 10
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

      OBTBSFL1 = 15,
      OBTBSFL2 = 15,
      OBTBSFL3 = 15
    },

    ceilings =
    {
      CEIL5_1 = 15,
      CEIL5_2 = 30,
      TEK7    = 30,
      QFLAT09 = 5,
      GRATE3  = 5,

      OBTBSFL3 = 10
    },

    keep_prob = 10
  },

  tech_ComputersParple =
  {
    prob = 3,
    env = "building",

    walls =
    {
      TEKWALLA = 20,
      TEKWALLC = 20,
      COMPTIL6 = 20,
      COMPTIL3 = 10,
      COMPBLAK = 10,
      GRAYMET7 = 10,
      GRAYMETB = 10
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
      SHINY03 = 10
    },

    ceilings =
    {
      CEIL5_1 = 50,
      CEIL5_2 = 30,
      TEK3    = 20,
      TEK5    = 20,
      QFLAT09 = 5,
      GRATE3  = 5
    },

    keep_prob = 10
  },]]

  -- Hooray, CEMENT textures!
  tech_Cement = --50
  {
    env = "building",
    prob = 50,

    walls =
    {
      CEM03 = 15,
      CEM04 = 15,
      CEM06 = 120,
      CEM07 = 120,
      CEM09 = 120,

      OBTBCEM1 = 120,
      OBTBCEM2 = 120,
      OBTBCEM3 = 120
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
      DARKF02 = 15
    },

    ceilings =
    {
      FLAT19 = 50,
      FLAT5_4 = 20,
      MFLR8_1 = 15,
      FLAT5_2 = 5,
      CEIL1_1 = 5,
      FLAT5_2 = 5,
      GRATE4  = 10
    }
  },

  tech_Shiny = --100
  {
    prob = 100,
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

      OBTBSLV1 = 15,
      OBTBSLV2 = 9,
      OBTBSLV3 = 9,
      OBTBSLV4 = 15,
      OBTBSLV5 = 10,

      OBTBSTX1 = 15,
      OBTBSTX2 = 15,
      OBTBSTX3 = 15,

      OBTSVBZ1 = 15,
      OBTSVBZ2 = 15,
      OBTSVBZ3 = 15
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
      FLAT23 = 40,
      SHINY01 = 20,
      SHINY02 = 30,
      SHINY03 = 25,
      TILES4  = 5,
      TILES6  = 5,

      OBTBSFL1 = 15,
      OBTBSFL2 = 15,
      OBTBSFL3 = 15
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

      OBTBSFL3 = 10
    }
  },

  tech_HeavyMetal = --120
  {
    env = "building",
    prob = 120,

    walls =
    {
      METAL2 = 70,
      METAL8 = 70,
      METAL9 = 70,
      METAL10 = 50,
      BRONZE1 = 30,
      BRONZE3 = 30,
      METAL1 = 25,
      RUSTWALL = 20,

      OBTSTX1B = 20,
      OBTSTX1G = 20,

      OBTBSLB1 = 15,
      OBTBSLB2 = 15,
      OBTBSLB3 = 15,
      OBTBSLB4 = 15,
      OBTBSLB5 = 15,

      G8_BRNW1 = 10,
      G8_BRNW2 = 10,
      G8_BRNW3 = 10,
      G8_BR1GY = 10,
      G8_BR2GY = 10,
      G8_BR3GY = 10,

      OBTSBGRE = 8,

      OBTSVBZ1 = 10,
      OBTSVBZ2 = 10,
      OBTSVBZ3 = 10
    },

    floors =
    {
      FLAT3 = 50,
      FLOOR0_1 = 30,
      GRATE1 = 30,
      GRATE2 = 30,
      GRATE3 = 30,
      FLOOR4_5 = 20,
      FLOOR4_6 = 20,
      FLOOR4_8 = 20,
      FLOOR5_1 = 15,
      FLOOR7_1 = 15,
      GRATE7 = 15,
      MFLR8_2  = 20,
      SLIME15 = 20,
      SLIME14 = 20,
      GRATE4 = 10,
      CEIL4_1 = 5,
      CEIL4_2 = 5,
      QFLAT09 = 10,
      MEM01   = 10,
      DARKF01 = 15,
      DARKF02 = 15,
      DARKF03 = 15,
      FLOOR46E = 10,
      GMET06   = 10,
      GMET07   = 10,
      GMET05   = 15,

      OBTBSFL1 = 15,
      OBTBSFL2 = 15,
      OBTBSFL3 = 10,

      OBTSVBF1 = 20,
      OBTSVBF2 = 20,
      OBTSVBF3 = 20,

      G8_BRNF1 = 20,
      G8_BRNF2 = 20,
      G8_BRNF3 = 20
    },

    ceilings =
    {
      CEIL5_1 = 30,
      CEIL5_2 = 15,
      GRATE4  = 25,
      SLIME15 = 40,
      CEIL4_1 = 20,
      SLIME14 = 30,
      SLIME16 = 20,
      GRATE3  = 20,
      GRATE5  = 15,
      GRATE6  = 15,
      GRATE8  = 20,
      G15     = 10,
      GMET02  = 15,
      GMET03  = 15,
      GMET04  = 20,

      OBTBSFL3 = 20,

      G8_BRNF1 = 20,
      G8_BRNF2 = 20,
      G8_BRNF3 = 20
    },
  },

  tech_VeryGray = --100
  {
    env = "building",
    prob = 100,

    walls =
    {
      GRAY1 = 80,
      GRAY5 = 80,
      GRAY4 = 80,
      GRAY6 = 60,
      GRAY7 = 80,
      GRAY8 = 60,
      ICKWALL1 = 10,
      ICKWALL2 = 10,
      ICKWALL3 = 10,
      TEKGRY01 = 10,

      OBTBSLV1 = 20,
      OBTBSLV2 = 20,
      OBTBSLV3 = 20,
      OBTBSLV4 = 20,
      OBTBSLV5 = 20,

      OBTBSTX1 = 20,
      OBTBSTX2 = 20,
      OBTBSTX3 = 20,

      OBTBSLB1 = 20,
      OBTBSLB2 = 20,
      OBTBSLB3 = 20,
      OBTBSLB4 = 20,
      OBTBSLB5 = 20,

      G8_BR1GY = 20,
      G8_BR2GY = 20,
      G8_BR3GY = 20,

      OBTSBGRE = 8,

      OBTSVBZ1 = 15,
      OBTSVBZ2 = 15,
      OBTSVBZ3 = 15,

      OBTBCEM1 = 30,
      OBTBCEM2 = 30,
      OBTBCEM3 = 30
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

      OBTBSFL1 = 15,
      OBTBSFL2 = 15,
      OBTBSFL3 = 10,

      OBTSVBF1 = 15,
      OBTSVBF2 = 15,
      OBTSVBF3 = 15
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

      OBTBSFL3 = 10
    },
  },

  tech_VeryBrown = --60
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
      BRVINE = 5,
      BROVINE2 = 5,

      OBTSTX1B = 10,

      OBTBSB2B = 15,
      OBTBSB3B = 15,
      OBTBSB4B = 15,

      G8_BRNW1 = 20,
      G8_BRNW2 = 20,
      G8_BRNW3 = 20,

      OBTSVBZ1 = 10,
      OBTSVBZ2 = 10,
      OBTSVBZ3 = 10
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

      OBTSBF1B = 15,
      OBTSBF2B = 15,
      OBTSBF3B = 15,

      G8_BRNF1 = 15,
      G8_BRNF2 = 15,
      G8_BRNF3 = 15
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

      G8_BRNF1 = 10,
      G8_BRNF2 = 10,
      G8_BRNF3 = 10
    },
  },

  tech_darkBronze = --40
  {
    env = "building",
    prob = 40,

    walls =
    {
      BRONZEG1 = 10,
      BRONZEG2 = 10,
      BRONZEG3 = 10,

      BROWN2 = 8,
      BROWN3 = 8,

      COMPBLAK = 1,
      COMPTIL3 = 1,

      DARKMET1 = 5,
      GOTH17 = 5,
      GOTH24 = 5,
      GOTH31 = 5,
      GOTH37 = 5,
      GOTH38 = 5,

      METAL8 = 7,
      METAL9 = 7,
      METAL10 = 7,
    },

    floors =
    {
      FLAT1 = 5,
      FLOOR4_8 = 5,

      SLIME14 = 5,
      SLIME15 = 5,

      DARKF03 = 8,
      DARKM01 = 8,
      G06 = 5,
      G10 = 5,
      G15 = 8,
      GMET03 = 5,
      GMET05 = 5,
      GRATE2 = 5,
      GRATE3 = 5,
      GRATE4 = 5,
      GRATE7 = 5,
      GRATE8 = 5,
      QFLAT09 = 5,
      MEM01 = 5
    },

    ceilings =
    {
      MFLR8_1 = 5,
      FLOOR4_8 = 5,

      DARKF03 = 8,
      DARKM01 = 8,
      G06 = 5,
      G10 = 5,
      G15 = 8,
      GMET03 = 5,
      GMET05 = 5,
      GRATE2 = 5,
      GRATE3 = 5,
      GRATE4 = 5,
      GRATE7 = 5,
      GRATE8 = 5,
      QFLAT09 = 5,
      MEM01 = 5,

      SLIME14 = 5,
      SLIME15 = 5
    }
  },

  tech_redFloorsBrownWalls = --25
  {
    env = "building",
    prob = 25,

    walls =
    {
      BRONZE1 = 50,
      BRONZE2 = 50,
      BRONZE3 = 50,

      BROWN1 = 30,
      BROWN144 = 30,
      BROWN96 = 30,
      BROWNHUG = 30,

      BRIKS31 = 50,
      BRONZE5 = 50,
      BRONZE6 = 50,

      CEM11 = 20,

      GOTH38 = 20,
      GOTH39 = 20,
      GOTH40 = 20,
      GOTH41 = 20,
      GOTH42 = 20,

      HELMET1 = 20,
      HELMET2 = 20,

      STUC01 = 20,

      URBAN5 = 50,
      URBAN6 = 50,

      ZIMMER3 = 50,
      ZIMMER4 = 50
    },

    floors =
    {
      FLAT5_3 = 50,
      FLOOR1_6 = 50,
      FLAT15 = 50,
      FLOOR1_2 = 25,
    },

    ceilings =
    {
      FLAT5_3 = 50,
      FLOOR1_6 = 50,
      FLAT15 = 50,
      FLOOR1_2 = 25,

      FLAT1 = 50,
      FLAT18 = 50,
      FLAT19 = 50,
      FLAT3 = 50,
      FLAT9 = 50,
      FLOOR0_3 = 50,
      FLOOR0_5 = 50,
      FLOOR4_8 = 25,
      SLIME14 = 50,
    }
  },

  tech_Outdoors_generic = --50
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      BROWN1 = 10,
      FLAT1 = 40,
      SLIME14 = 5,
      SLIME15 = 6,

      BROWN144 = 85,
      GRASS1 = 25,
      GRASS2 = 25,
      RROCK19 = 15,

      --

      FLOOR4_7 = 20,
      FLOOR46D = 20,
      G09 = 20,
      G10 = 20,

      GMET02 = 10,
      GMET03 = 10,
      GMET04 = 10,
      GMET05 = 10,
      GMET06 = 10,

      GRATE1 = 40,
      GRATE2 = 40,
      GRATE3 = 40,
      GRATE4 = 40,
      GRATE5 = 40,
      GRATE6 = 40,
      GRATE7 = 40,
      GRATE8 = 40,

      GROUND01 = 30,
      GROUND02 = 30,
      GROUND03 = 30,
      GROUND04 = 30,

      MEM01 = 15,

      SHINY01 = 20,
      SHINY02 = 20,
      SHINY03 = 20,
      SHINY04 = 20,

      STARBR2F = 20,
      STARG1F = 20,
      STARGRF = 20,
      STARTANF = 20,

      TILES4 = 20,
      TILES6 = 20,

      --

      G8_BRNF1 = 20,
      G8_BRNF2 = 20,
      G8_BRNF3 = 20
    },

    naturals =
    {
      RROCK17  = 50,
      RROCK18  = 50,
      RROCK19  = 50,
      RROCK20  = 50,
      ASHWALL2 = 20,
      ASHWALL3 = 20,
      ASHWALL4 = 20,
      SP_ROCK1 = 70,
      ZIMMER1  = 10,
      ZIMMER2  = 10,
      ZIMMER3  = 10,
      ZIMMER4  = 10,
      ZIMMER5  = 10,
      ZIMMER7  = 10,
      ROCK5    = 20,

      GRASS1 = 50,
      GRASS2 = 50,

      GROUND01 = 50,
      GROUND02 = 50,
      GROUND03 = 50,
      GROUND04 = 50,

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

      GREEN01 = 20,
    },

    porch_floors =
    {
      FLAT1 = 10,
      FLAT3 = 10,
      FLAT5 = 5,
      FLAT5_4 = 10,
      FLAT19 = 10,
      FLAT20 = 15,
      CEIL5_2 = 15,
      FLOOR0_3 = 10,
      FLOOR0_5 = 10,
      FLOOR3_3 = 8,
      FLOOR4_1 = 8,
      FLOOR4_5 = 8,
      FLOOR5_3 = 10,
      FLOOR7_1 = 15,
      SLIME14 = 10,
      SLIME15 = 10,
      SLIME16 = 10,

      --

      FLOOR4_7 = 20,
      FLOOR46D = 20,
      G09 = 20,
      G10 = 20,

      GMET02 = 10,
      GMET03 = 10,
      GMET04 = 10,
      GMET05 = 10,
      GMET06 = 10,

      GRATE1 = 40,
      GRATE2 = 40,
      GRATE3 = 40,
      GRATE4 = 40,
      GRATE5 = 40,
      GRATE6 = 40,
      GRATE7 = 40,
      GRATE8 = 40,

      MEM01 = 15,

      SHINY01 = 20,
      SHINY02 = 20,
      SHINY03 = 20,
      SHINY04 = 20,

      STARBR2F = 20,
      STARG1F = 20,
      STARGRF = 20,
      STARTANF = 20,

      TILES4 = 20,
      TILES6 = 20,

      G8_BRNF1 = 20,
      G8_BRNF2 = 20,
      G8_BRNF3 = 20,

      OBTBSFL1 = 20,
      OBTBSFL3 = 20,
      OBTSVBF1 = 20,
      OBTSVBF2 = 20,
      OBTSVBF3 = 20,

      OBTSBF1B = 20,
      OBTSBF2B = 20,
      OBTSBF3B = 20
    },
  },


-- START OF HELL THEMES

  hell_ReisalGothic = --150
  {
    env  = "building",
    prob = 150,

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
      MMT208 = 15,
      MMT209 = 15,
      MMT210 = 15,

      --
      BRIC9GRN = 15,
      BRIC9GRY = 15,
      BRIC9TAN = 15,
      BRICEGRN = 15,
      BRICEGRY = 15,

      --
      OBTBSLB3 = 15,
      OBTBSLB4 = 15,

      G8_BRNW1 = 10,
      G8_BRNW3 = 10,
      G8_BR1GY = 10,
      G8_BR2GY = 10,

      G7_GOGN1 = 20,
      G7_GOGN2 = 20,
      G7_GOGN3 = 20
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

      OBTSVBF1 = 40,
      OBTSVBF2 = 40,
      OBTSVBF3 = 40,

      OBTSBF1B = 40,
      OBTSBF2B = 40,
      OBTSBF3B = 40,

      OBTSBF1R = 30,
      OBTSBF2R = 30,
      OBTSBF3R = 30,

      G8_BRNF1 = 10,
      G8_BRNF2 = 10,
      G8_BRNF3 = 10
    },

    ceilings =
    {
      FLOOR7_2 = 50,
      DEM1_5   = 20,
      FLOOR6_1 = 20,
      FLOOR6_2 = 20,
      MFLR8_4  = 15,

      OBTSVBF1 = 15,
      OBTSVBF2 = 15,
      OBTSVBF3 = 15,

      G8_BRNW1 = 15,
      G8_BRNW2 = 15,
      G8_BRNW3 = 15
    },
  },

  hell_CementCautionlines = --20
  {
    env = "building",
    prob = 20,

    theme_override = "tech",

    walls =
    {
      CEM01 = 20,
      CEM02 = 20,
      CEM03 = 20,
      CEM04 = 20,
      CEM06 = 20,
      CEM07 = 20,
      CEM09 = 20,
      DRKCMT01 = 10,
      DRKCMT02 = 10,
      DRKCMT03 = 10,
      DRKCMT04 = 10,
      DRKCMT05 = 10,
      DRKCMT06 = 10,
      HELLCMT1 = 20,
      HELLCMT2 = 20,
      HELLCMT3 = 20,
      HELLCMT4 = 20,
      HELLCMT5 = 20,
      HELLCMT6 = 20,
      HELLCMT7 = 15,
      HELLCMT8 = 15,

      OBTBCEM1 = 30,
      OBTBCEM3 = 30,

      OBTBCMR1 = 30,
      OBTBCMR3 = 30,
    },

    floors =
    {
      FLAT1 = 50,
      FLAT5_4 = 40,
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

      OBTSBF1R = 10,
      OBTSBF2R = 10,
      OBTSBF3R = 10,

      G8_BRNF1 = 10,
      G8_BRNF2 = 10,
      G8_BRNF3 = 10
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
      GRATE8  = 10,

      G8_BRNF1 = 10,
      G8_BRNF2 = 10,
      G8_BRNF3 = 10
    },

    keep_prob = 10,
  },

  hell_CementCautionless = --20
  {
    env = "building",
    prob = 20,

    walls =
    {
      CEM01 = 20,
      CEM02 = 20,
      CEM09 = 20,
      DRKCMT05 = 10,
      DRKCMT06 = 10,
      HELLCMT1 = 20,
      HELLCMT2 = 20,
      HELLCMT7 = 15,
      HELLCMT8 = 15,

      OBTSVBZ1 = 15,
      OBTSVBZ2 = 15,
      OBTSVBZ3 = 15,

      OBTBCEM1 = 30,
      OBTBCEM2 = 30,
      OBTBCEM3 = 30,

      OBTBCMR1 = 30,
      OBTBCMR2 = 30,
      OBTBCMR3 = 30,
    },

    floors =
    {
      FLAT1 = 50,
      FLAT5_4 = 40,
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

      OBTSBF1R = 20,
      OBTSBF2R = 20,
      OBTSBF3R = 20
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
      GRATE8  = 10,
    },

    keep_prob = 20,
  },

  hell_fleshcraft = --50
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
      SKTEK01 = 15,
      SKTEK02 = 15,

      CREYEWLL = 30,
      CRFSHWLL = 30,
      CRGRSWLL = 30,
      CRHRTWLL = 30,
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

      CREYEWLL = 10,
      CRFSHWLL = 10,
      CRGRSWLL = 10,
      CRHRTWLL = 10,

      G8_BRNF1 = 10,
      G8_BRNF2 = 10,
      G8_BRNF3 = 10
    },

    ceilings =
    {
      CEIL1_1 = 50,
      FLAT5_2 = 50,
      G02 = 30,
      G03 = 30,
      FLOOR7_2 = 15,
      FLOOR7_3 = 15,

      CREYEWLL = 7,
      CRFSHWLL = 7,
      CRGRSWLL = 7,
      CRHRTWLL = 7,

      G8_BRNF1 = 7,
      G8_BRNF2 = 7,
      G8_BRNF3 = 7
    },
  },

  hell_blackened = --40
  {
    env  = "building",
    prob = 40,

    walls =
    {
      KSTONE1 = 50,
      KMARBLE2 = 50,
      KMARBLE3 = 50,
      KMARBLE1 = 20,

      OBTBSLB2 = 8,
      OBTBSLB3 = 8,
      OBTBSLB4 = 8,
      OBTBSLB5 = 8,

      G8_BR1GY = 8,
      G8_BR3GY = 8,

      MARB5BL = 50,
    },

    floors =
    {
      BMARB1 = 50,
      BMARB2 = 50,
      BMARB3 = 20,

      GSTN01 = 20,
      GSTN02 = 20,

      OBTSVBF1 = 20,
      OBTSVBF2 = 20,
      OBTSVBF3 = 20
    },

    ceilings =
    {
      BMARB3 = 100,
      BMARB1 = 30,
    },
  },

  hell_crimson = --40
  {
    env  = "building",
    prob = 40,

    walls =
    {
      REDMARB1 = 40,
      REDMARB2 = 60,
      REDMARB3 = 60,
      MARB5BL = 40,

      OBTBCMR1 = 30,
      OBTBCMR2 = 30,
      OBTBCMR3 = 30,
    },

    floors =
    {
      RMARB1 = 50,
      RMARB2 = 50,
      RMARB3 = 20,

      OBTSBF1R = 20,
      OBTSBF2R = 20,
      OBTSBF3R = 20
    },

    ceilings =
    {
      RMARB3 = 100,
      RMARB1 = 30,

      OBTSBF1R = 15,
      OBTSBF2R = 15,
      OBTSBF3R = 15
    },
  },

  -- MSSP
  hell_egyptish = --60
  {
    env = "building",
    prob = 60,

    walls =
    {
      BRIKS03 = 15,
      BRIKS06 = 15,
      BRIKS12 = 15,
      BRIKS14 = 15,

      DESBRIK1 = 50,
      DESBRIK2 = 50,
      DESBRIK3 = 50,
      DESBRIK4 = 50,
      DESBRIK5 = 50,
      DESBRIK6 = 50,
      DESBRIK7 = 50,

      DESMARB1 = 25,
      DESMARB2 = 50,

      EGYPT03 = 50,
      EGYPT04 = 50,
      EGYPT05 = 50,
      EGYPT06 = 50,

      BRIC9TAN = 50,
    },

    floors =
    {
      BRIK01 = 50,
      EG01 = 50,
      EG02 = 50,
      EG03 = 50,
      EG04 = 50,
      EG05 = 15,
      EG06 = 50,

      GSTN03 = 50,
      GSTN04 = 50,
      GSTN05 = 50,

      FLOOR0_1 = 20,
      FLOOR3_3 = 20,
      RROCK09 = 15,
      RROCK10 = 15,
      RROCK12 = 15,
      RROCK15 = 15,
    },

    ceilings =
    {
      EG01 = 50,
      EG03 = 50,
      EG06 = 50,
      FLOOR0_1 = 50,
      FLOOR3_3 = 50,
      RROCK09 = 20,
      RROCK10 = 20,
      RROCK12 = 20,
      RROCK15 = 20,
    },
  },

  hell_greenBrick = --20
  {
    env = "building",
    prob = 20,

    walls =
    {
      BRIKS25 = 15,
      BRVINE = 5,

      MARBLE = 8,
      MARBLE4 = 8,
      MARBLE5 = 8,
      MARBLE6 = 8,
      MARBLE7 = 8,
      MARBLE8 = 8,

      MM206 = 10,
      MM207 = 10,

      TEKGREN2 = 15,

      ZIMMER1 = 5,
      ZIMMER2 = 5,
      ZIMMER7 = 5,
    },

    floors =
    {
      FLOOR7_2 = 5,
      SLIME13 = 5,

      FLOOR51C = 5,

      GRASS1 = 2,
      GRASS2 = 2,

      G20 = 5,
      GRNROCK = 5,

      GROUND03 = 5,
      GROUND04 = 5,

      RROCK20 = 5,
      STARG1F = 5,
    },

    ceilings =
    {
      FLOOR7_2 = 5,
      SLIME13 = 5,

      FLOOR51C = 5,

      GRASS1 = 2,
      GRASS2 = 2,

      G20 = 5,
      GRNROCK = 5,

      GROUND03 = 5,
      GROUND04 = 5,

      RROCK20 = 5,
      STARG1F = 5,
    },
  },

  hell_metal = --50
  {
    env = "building",
    prob = 50,

    walls =
    {
      BRONZE1 = 5,
      BRONZE2 = 5,
      BRONZE3 = 5,
      BROWN144 = 5,
      BROWN96 = 5,

      METAL2 = 5,
      SPACEW4 = 5,

      BRONZE5 = 5,
      BRONZE6 = 5,
      BRONZEG1 = 5,
      BRONZEG2 = 5,
      BRONZEG3 = 5,
      BROWN2 = 5,
      BROWN3 = 5,

      BRIKS35 = 2,
      BRIKS36 = 2,

      DRKCMT05 = 4,
      DRKCMT06 = 4,

      GOTH15 = 5,
      GOTH16 = 5,
      GOTH18 = 5,
      GOTH23 = 5,
      GOTH24 = 5,
      GOTH25 = 5,
      GOTH26 = 5,
      GOTH27 = 5,
      GOTH31 = 5,
      GOTH32 = 5,
      GOTH36 = 5,
      GOTH37 = 5,
      GOTH38 = 5,
      GOTH39 = 5,
      GOTH40 = 5,
      GOTH41 = 5,
      GOTH42 = 5,
      GOTH43 = 5,
      GOTH44 = 5,

      HELMET1 = 5,
      HELMET2 = 5,
      MET2 = 5,
      METAL10 = 2,
      METAL8 = 2,
      METAL9 = 2,
      METL02 = 5,
      METL03 = 5,

      MM205 = 5,
      PIPEDRK1 = 5,
      RUSTWALL = 5,

      -- MSSP stuff

      OBTBSLB2 = 5,
      OBTBSLB3 = 5,
      OBTBSLB4 = 5,
      OBTBSLB5 = 5,

      OBTBSB2B = 5,
      OBTBSB3B = 5,
      OBTBSB4B = 5,
      OBTBSB5B = 5,

      G8_BRNW1 = 10,
      G8_BRNW3 = 10,
      G8_BR1GY = 10,
      G8_BR3GY = 10,

      OBTSBGRE = 10,

      G7_GOGN1 = 10,
      G7_GOGN2 = 10,
      G7_GOGN3 = 10,

      OBTSVBZ1 = 10,
      OBTSVBZ2 = 10,
      OBTSVBZ3 = 10,
    },

    floors =
    {
      FLOOR0_1 = 5,
      FLOOR0_3 = 5,
      FLOOR0_5 = 5,
      FLOOR4_1 = 5,
      FLOOR4_5 = 5,
      FLOOR4_6 = 5,
      FLOOR5_3 = 2,
      FLOOR5_4 = 4,
      FLOOR7_2 = 8,

      SLIME14 = 5,
      SLIME15 = 5,

      BMARB1 = 5,
      BMARB2 = 5,
      BMARB3 = 5,

      FLOOR46D = 5,
      FLOOR46E = 5,
      FLOOR51C = 5,
      FLOOR7_3 = 5,

      DARKF01 = 5,
      DARKF02 = 5,
      DARKF03 = 5,
      DARKM01 = 5,

      G04 = 5,
      G05 = 5,
      G06 = 5,
      G07 = 5,
      G08 = 5,
      G09 = 5,
      G10 = 5,
      G14 = 5,
      G15 = 5,
      G18 = 5,
      G19 = 5,
      G21 = 5,

      GMET01 = 5,
      GMET02 = 5,
      GMET03 = 5,
      GMET04 = 5,
      GMET05 = 5,
      GMET06 = 5,
      GMET07 = 5,

      GRATE1 = 8,
      GRATE2 = 8,
      GRATE3 = 8,
      GRATE4 = 8,
      GRATE5 = 8,
      GRATE6 = 8,
      GRATE7 = 8,
      GRATE8 = 8,

      GRATE3 = 5,
      GRATE4 = 5,

      QFLAT05 = 5,
      QFLAT06 = 5,
      QFLAT09 = 5,

      TILES4 = 5,
      TILES5 = 5,
      TILES6 = 5,

      OBTSVBF1 = 10,
      OBTSVBF2 = 10,
      OBTSVBF3 = 10,

      OBTSBF1B = 10,
      OBTSBF2B = 10,
      OBTSBF3B = 10
    },

    ceilings =
    {
      CEIL3_2 = 5,
      CEIL3_3 = 5,
      CEIL3_5 = 5,
      CEIL5_1 = 5,
      CEIL5_2 = 5,
      SLIME14 = 5,
      SLIME15 = 5,
      FLOOR7_2 = 8,

      BMARB1 = 5,
      BMARB2 = 5,
      BMARB3 = 5,
      DARKF01 = 5,
      DARKF02 = 5,
      DARKF03 = 5,
      DARKM01 = 5,

      G04 = 5,
      G05 = 5,
      G06 = 5,
      G07 = 5,
      G08 = 5,
      G09 = 5,
      G10 = 5,
      G14 = 5,
      G15 = 5,
      G18 = 5,
      G19 = 5,
      G21 = 5,

      GMET01 = 5,
      GMET02 = 5,
      GMET03 = 5,
      GMET04 = 5,
      GMET05 = 5,
      GMET06 = 5,
      GMET07 = 5,

      GRATE3 = 5,
      GRATE4 = 5,

      QFLAT05 = 5,
      QFLAT06 = 5,
      QFLAT10 = 5,

      TILES4 = 5,
      TILES5 = 5,
      TILES6 = 5,

      OBTSVBF1 = 5,
      OBTSVBF2 = 5,
      OBTSVBF3 = 5,

      G8_BRNF1 = 5,
      G8_BRNF2 = 5,
      G8_BRNF3 = 5
    },
  },

  hell_rocky_ruins = --45
  {
    env = "building",
    prob = 45,

    walls =
    {
      ASHWALL2 = 5,
      ASHWALL3 = 5,
      ASHWALL4 = 5,
      ASHWALL6 = 5,
      ASHWALL7 = 5,

      BROVINE2 = 5,

      BSTONE1 = 5,
      BSTONE2 = 5,
      GSTVINE1 = 5,
      GSTVINE2 = 5,
      ROCK2 = 5,
      ROCK3 = 5,

      STONE6 = 5,
      TANROCK2 = 5,
      TANROCK3 = 5,
      TANROCK4 = 5,
      TANROCK5 = 5,
      TANROCK7 = 5,
      TANROCK8 = 5,

      ZIMMER3 = 5,
      ZIMMER4 = 5,
      ZIMMER5 = 5,
      ZIMMER8 = 5,

      --

      ASHWALL1 = 7,
      BRIKS11 = 7,
      BRIKS13 = 7,
      BRIKS29 = 7,
      BRIKS30 = 7,
      BRIKS39 = 7,
      CATACMB3 = 7,
      CATACMB6 = 7,
      DESBRIK7 = 7,
      EGYPT03 = 7,
      EGYPT05 = 7,
      GOTH12 = 7,
      GOTH13 = 7,
      GOTH14 = 7,
      GOTH30 = 7,
      GOTH46 = 7,
      GOTH47 = 7,
      GOTH48 = 7,
      GOTH49 = 7,
      MM205 = 7,
      MM206 = 7,
      RDROK2 = 7,
      ROK03 = 7,
      ROK07 = 7,
      ROK08 = 7,
      ROK09 = 7,
      ROK10 = 7,
      ROK12 = 7,
      ROK16 = 7,
      ROK21 = 7,

      WOOD13 = 7,
      WOOD14 = 7,
      WOOD15 = 7,
      WOOD16 = 7,
      WOOD17 = 7,
      WOOD18 = 7,

      MMT208 = 10,
      MMT209 = 10,
      MMT210 = 10,
    },

    floors =
    {
      FLAT1_1 = 5,
      FLAT5_7 = 5,
      FLOOR6_2 = 5,
      FLOOR7_2 = 5,
      GRNROCK = 5,
      MFLR8_2 = 5,
      RROCK11 = 5,
      RROCK12 = 5,
      RROCK13 = 5,
      RROCK15 = 5,

      --

      FLOOR7_3 = 7,
      G11 = 7,
      G12 = 7,
      G20 = 7,
      GMET02 = 7,
      GMET03 = 7,
      GMET04 = 7,
      GMET05 = 7,
      GMET06 = 7,
      GMET07 = 7,
      QFLAT03 = 7,
      QFLAT04 = 7,
      QFLAT05 = 7,
      QFLAT06 = 7,
      QFLAT07 = 7
    },

    ceilings =
    {
      FLAT1_1 = 5,
      FLAT5_7 = 5,
      FLOOR6_2 = 5,
      FLOOR7_2 = 5,
      GRNROCK = 5,
      MFLR8_2 = 5,
      RROCK11 = 5,
      RROCK12 = 5,
      RROCK13 = 5,
      RROCK15 = 5,

      --

      FLOOR7_3 = 7,
      G11 = 7,
      G12 = 7,
      G20 = 7,
      GMET02 = 7,
      GMET03 = 7,
      GMET04 = 7,
      GMET05 = 7,
      GMET06 = 7,
      GMET07 = 7,
      QFLAT03 = 7,
      QFLAT04 = 7,
      QFLAT05 = 7,
      QFLAT06 = 7,
      QFLAT07 = 7
    }
  },

  -- Hell has frozen over!
  hell_icecave = --50
  {
    env  = "cave",
    prob = 50,

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
      SNOW15 = 100
    },

    floors =
    {
      SNOW1 = 50,
      SNOW5 = 50,
      SNOW6 = 50,
      SNOW7 = 50,
      SNOW8 = 50
    }
  },

  hell_Outdoors_generic =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLOOR6_2 = 12,
      FLAT5_7 = 20,
      FLAT5_8 = 10,
      RROCK03 = 30,
      RROCK04 = 30,
      RROCK09 = 15,
      MFLR8_3 = 15,
      SLIME13 = 10,
      RROCK11 = 10,
      RROCK12 = 10,
      RROCK13 = 5,
      RROCK01 = 5,
      RROCK02 = 3,

      BLACK0 = 10,
      BMARB1 = 10,
      BMARB2 = 10,
      BMARB3 = 10,

      DARKF01 = 10,
      DARKF02 = 10,

      FFLAT01 = 10,

      FLOOR46D = 10,
      FLOOR46E = 10,

      G01 = 10,
      G02 = 10,
      G03 = 10,
      G04 = 10,
      G05 = 10,
      G06 = 10,
      G07 = 10,
      G08 = 10,
      G09 = 10,
      G10 = 10,
      G11 = 10,
      G12 = 10,
      G13 = 10,
      G14 = 10,
      G15 = 10,
      G16 = 10,
      G17 = 10,
      G18 = 10,
      G19 = 10,
      G20 = 10,
      G21 = 10,

      GMET02 = 10,
      GMET03 = 10,
      GMET04 = 10,
      GMET05 = 10,
      GMET06 = 10,
      GMET07 = 10,
      GRATE4 = 10,

      GROUND01 = 10,
      GROUND02 = 10,

      GSTN01 = 10,
      GSTN02 = 10,
      GSTN03 = 10,
      GSTN04 = 10,
      GSTN05 = 10,

      GWOD01 = 10,
      GWOD02 = 10,
      GWOD03 = 10,
      GWOD04 = 10,

      MEM01 = 10,

      QFLAT01 = 10,
      QFLAT02 = 10,
      QFLAT03 = 10,
      QFLAT04 = 10,
      QFLAT05 = 10,
      QFLAT06 = 10,
      QFLAT07 = 10,
      QFLAT09 = 10,
      QFLAT10 = 10,

      RMARB1 = 10,
      RMARB2 = 10,
      RMARB3 = 10,

      URB1 = 10,

      WOODTI2 = 10,
      WOODTIL = 10
    },

    naturals =
    {
      ROCKRED1 = 50,
      SP_ROCK1 = 30,
      ASHWALL2 = 30,
      ASHWALL3  = 25,
      ASHWALL6  = 20,
      ASHWALL7  = 15,
      ASHWALL4 = 30,
      SKIN2 = 10,
      SKSNAKE1 = 30,
      SKSNAKE2 = 30,

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

      CREYEWLL = 5,
      CRFSHWLL = 5,
      CRGRSWLL = 5,
      CRHRTWLL = 5,

      ROKGRN = 20,
      GREEN02 = 15,
      GREEN03 = 15,
    },

    porch_floors =
    {
      CEIL3_5 = 10,
      DEM1_5 = 35,
      DEM1_6 = 35,
      FLAT1_1 = 10,
      FLAT1_2 = 10,
      FLAT5_1 = 35,
      FLAT5_2 = 35,
      FLOOR4_6 = 10,
      FLOOR5_4 = 10,
      MFLR8_1 = 10,
      RROCK09 = 10,
      RROCK12 = 10,
      RROCK13 = 10,
      RROCK14 = 10,

      BLACK0 = 10,
      BMARB1 = 10,
      BMARB2 = 10,
      BMARB3 = 10,

      DARKF01 = 10,
      DARKF02 = 10,

      FFLAT01 = 10,

      FLOOR46D = 10,
      FLOOR46E = 10,

      G01 = 10,
      G02 = 10,
      G03 = 10,
      G04 = 10,
      G05 = 10,
      G06 = 10,
      G07 = 10,
      G08 = 10,
      G09 = 10,
      G10 = 10,
      G11 = 10,
      G12 = 10,
      G13 = 10,
      G14 = 10,
      G15 = 10,
      G16 = 10,
      G17 = 10,
      G18 = 10,
      G19 = 10,
      G20 = 10,
      G21 = 10,

      GMET02 = 10,
      GMET03 = 10,
      GMET04 = 10,
      GMET05 = 10,
      GMET06 = 10,
      GMET07 = 10,
      GRATE4 = 10,

      GROUND01 = 10,
      GROUND02 = 10,

      GSTN01 = 10,
      GSTN02 = 10,
      GSTN03 = 10,
      GSTN04 = 10,
      GSTN05 = 10,

      GWOD01 = 10,
      GWOD02 = 10,
      GWOD03 = 10,
      GWOD04 = 10,

      MEM01 = 10,

      QFLAT01 = 10,
      QFLAT02 = 10,
      QFLAT03 = 10,
      QFLAT04 = 10,
      QFLAT05 = 10,
      QFLAT06 = 10,
      QFLAT07 = 10,
      QFLAT09 = 10,
      QFLAT10 = 10,

      RMARB1 = 10,
      RMARB2 = 10,
      RMARB3 = 10,

      URB1 = 10,

      WOODTI2 = 10,
      WOODTIL = 10,
    }
  },

-- START OF URBAN THEMES

  --  18 through 20 don't tile horizontally well so I removed them. 14 and 30 seems more like it works for exterior.
  urban_ReisalBricks = --100
  {
    env = "building",
    prob = 100,

    walls =
    {
      BRIKS01 = 15,
      BRIKS02 = 15,
      BRIKS03 = 15,
      BRIKS04 = 15,
      BRIKS05 = 15,
      BRIKS06 = 15,
      BRIKS07 = 15,
      BRIKS08 = 15,
      BRIKS09 = 15,
      BRIKS10 = 15,
      BRIKS11 = 15,
      BRIKS12 = 15,
      BRIKS14 = 15,
      BRIKS15 = 15,
      BRIKS16 = 15,
      BRIKS17 = 15,
      BRIKS21 = 15,
      BRIKS22 = 15,
      BRIKS23 = 15,
      BRIKS24 = 15,
      BRIKS25 = 15,
      BRIKS26 = 15,
      BRIKS27 = 15,
      BRIKS28 = 15,
      BRIKS29 = 15,
      BRIKS33 = 15,
      BRIKS34 = 15,
      BRIKS35 = 15,
      BRIKS36 = 15,
      BRIKS40 = 15,
      BRIKS43 = 15,

      URBAN1 = 15,
      URBAN2 = 15,
      URBAN3 = 15,

      OBTBSLB2 = 10,
      OBTBSLB3 = 10,
      OBTBSLB4 = 10,
      OBTBSLB5 = 10,

      OBTBSB2B = 10,
      OBTBSB3B = 10,
      OBTBSB4B = 10,
      OBTBSB5B = 10,

      OBTSBGRE = 8,

      MMT208 = 10,
      MMT209 = 10,
      MMT210 = 10
    },

    floors =
    {
      FLAT1_1 = 25,
      FLAT1_2 = 30,
      FLAT1   = 30,
      FLAT5   = 15,
      FLAT5_1 = 25,
      FLAT5_2 = 30,
      FLAT5_4 = 20,
      FLAT5_5 = 25,
      FLAT8   = 30,

      FLOOR0_1 = 20,
      FLOOR0_2 = 20,
      FLOOR0_3 = 20,
      FLOOR4_6 = 20,
      FLOOR5_3 = 25,
      FLOOR5_4 = 10,

      TILES1 = 80,
      TILES2 = 80,
      TILES3 = 80,
      TILES4 = 80,
      TILES5 = 80,
      TILES6 = 80,

      GMET04 = 80,
      GMET05 = 80,

      CARPET1 = 15,
      CARPET2 = 15,
      CARPET3 = 15,
      CARPET4 = 15,
      CARPET5 = 15,
      CARPET6 = 15,
      CARPET7 = 15,
      CARPET8 = 15,

      FFLAT01 = 80,

      OBTSVBF1 = 20,
      OBTSVBF2 = 20,
      OBTSVBF3 = 20,

      OBTSBF1R = 20,
      OBTSBF2R = 20,
      OBTSBF3R = 20,
    },

    ceilings =
    {
      FLAT1   = 50,
      FLAT5_4 = 20,
      FLAT5_5 = 15,
      RROCK10 = 20,
      RROCK14 = 20,
      CEIL1_1 = 30,
      FLAT5_2 = 10,
      MFLR8_1 = 10,
      SLIME13 = 5
    },
  },

  urban_Wood = -- 20: -- this is an override of the urban wood theme with
               -- a theme override
  {
    env  = "building",
    prob = 20,

    theme_override = "flesh",

    walls =
    {
      WOOD1 = 30,
      WOOD3 = 20,
      WOOD5 = 20,
      WOOD12 = 20,
      WOODVERT = 8,

      WODCRAT3 = 50,
      WODCRAT4 = 50,
      WODCRAT5 = 50,
      WD03   = 50,
      WD04   = 50,
      WOOD13 = 50,
      WOOD14 = 50,
      WOOD15 = 50,
      WOOD16 = 50,
      WOOD17 = 50,
      WOOD18 = 30
    },

    floors =
    {
      FLAT5_1 = 30,
      FLAT5_2 = 30,
      FLOOR7_1 = 20,
      FLAT5_4 = 8,
      FLAT5_5 = 20,
      FLOOR4_6 = 10,
      FLAT5_5  = 15,
      DEM1_5   = 10,
      DEM1_6   = 15,

      GSTN03 = 15,
      GSTN04 = 15,
      GSTN05 = 15,
      GWOD01 = 30,
      GWOD02 = 30,
      GWOD03 = 30,
      GWOD04 = 30,

      CARPET1 = 7,
      CARPET2 = 7,
      CARPET3 = 7,
      CARPET4 = 7,
      CARPET5 = 7,
      CARPET6 = 7,
      CARPET7 = 7,
      CARPET8 = 7,

      WOODTIL = 30,
      WOODTI2 = 30,
      FFLAT01 = 30
    },

    ceilings =
    {
      FLOOR7_2 = 50,
      RROCK14 = 40,
      CEIL1_1 = 30,
      FLAT5_2 = 10,
      FLAT5_7 = 10,
      RROCK10 = 10,
      RROCK11 = 10,
      RROCK12 = 10,
      FLOOR7_1 = 5
    }
  },

  urban_MoreWood = --75
  {
    env = "building",
    prob = 75,

    walls =
    {
      WOOD1 = 50,
      WOOD3 = 50,
      WOOD5 = 50,
      WOOD12 = 50,
      WOODVERT = 50,
      WD03   = 50,
      WD04   = 50,
      WOOD15 = 50,
      WOOD16 = 50,
      WOOD17 = 50,
      WOOD18 = 30
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
      FFLAT01 = 30
    },

    ceilings =
    {
      CEIL1_1 = 70,
      FLAT5_2 = 50,
      GSTN01  = 30,
      GSTN02  = 30,
      SLIME14 = 20,
      SLIME15 = 20
    }
  },

  urban_BlackBrick = --30
  {
    env = "building",
    prob = 30,

    walls =
    {
      BIGSTON2 = 5,
      BIGSTON3 = 5,
      BRIKS09 = 5,
      BRIKS10 = 5,
      BRIKS11 = 5,
      BRIKS35 = 5,
      BRIKS36 = 5,
      BRIKS43 = 5,
      BRONZEG1 = 5,
      BRONZEG2 = 5,
      BRONZEG3 = 5,
      GOTH06 = 5,
    },

    floors =
    {
      BLACK0 = 5,
      BMARB1 = 5,
      BMARB2 = 5,
      BMARB3 = 5,

      DARKF03 = 5,
      GSTN02 = 5,

      FLAT1 = 2,
      MFLR8_1 = 2,

      -- brights
      FLOOR4_7 = 5,
      G21 = 5,
      SHINY02 = 5,
      STARGRF = 5,
      TILES1 = 5,
      TILES4 = 5,
      TILES6 = 5,

      FLAT18 = 2,
      FLAT19 = 2,
      FLAT3 = 2,
      FLAT20 = 2,
      FLAT5_4 = 2,
      FLOOR0_3 = 2,
      FLOOR0_5 = 2,
    },

    ceilings =
    {
      BLACK0 = 5,
      BMARB1 = 5,
      BMARB2 = 5,
      BMARB3 = 5,

      DARKF03 = 5,
      GSTN02 = 5,

      FLAT1 = 2,
      MFLR8_1 = 2,

      -- brights
      FLOOR4_7 = 5,
      G21 = 5,
      SHINY02 = 5,
      STARGRF = 5,
      TILES1 = 5,
      TILES4 = 5,
      TILES6 = 5,

      FLAT18 = 2,
      FLAT19 = 2,
      FLAT3 = 2,
      FLAT20 = 2,
      FLAT5_4 = 2,
      FLOOR0_3 = 2,
      FLOOR0_5 = 2,
    }
  },

  -- MSSP: anything that vaguely looks like cement
  urban_Cement = --100
  {
    env = "building",
    prob = 100,

    walls =
    {
      CEM01 = 5,
      CEM02 = 5,
      CEM06 = 5,
      CEM07 = 5,
      CEM09 = 5,
      CEM10 = 10,
      CEM11 = 10,
      STON7 = 10,
      STONE10 = 10,
      STONE8 = 10,
      STONE9 = 7.5,

      BRONZEG1 = 5,
      BRONZEG2 = 5,
      BRONZEG3 = 5,
      BROWN2 = 5,
      BROWN3 = 5,

      GRAY6 = 5,
      GRAY8 = 5,
      GRAY9 = 5,
      SHAWN01C = 5,
      SHAWN01D = 5,
      SHAWN01E = 5,
      SHAWN01F = 5,
      SHAWN4 = 2.5,
      SHAWN5 = 5,

      OBTBSLV1 = 5,
      OBTBSLV2 = 5,

      OBTBSTX1 = 5,

      OBTBCEM1 = 12,
      OBTBCEM2 = 12,
      OBTBCEM3 = 12
    },

    floors =
    {
      FFLAT01 = 100,
      SHINY01 = 50,
      SHINY02 = 50,
      STARGRF = 50,
      TILES4 = 100,
      TILES5 = 100,
      TILES6 = 100,
      FLOOR4_7 = 100,

      FLOOR1_6 = 75,
      FLAT14 = 75,

      FLAT3 = 25,
      FLAT4 = 15,
      FLAT18 = 25,
      FLAT19 = 25,
      FLAT20 = 25,
      FLAT1 = 50,
      FLOOR0_5 = 75,
      FLOOR0_3 = 75,

      OBTBSFL3 = 70,

      OBTSVBF1 = 50,
      OBTSVBF2 = 50,
      OBTSVBF3 = 50
    },

    ceilings =
    {
      FLAT1 = 50,
      FLAT18 = 50,
      FLAT19 = 50,
      FLAT3 = 25,
      FLAT5_4 = 50
    }
  },

  -- MSSP: emphasis on a sort of dilapitated, grimy, semi-industrial look
  urban_darkGrimyIndustrial = --75
  {
    env = "building",
    prob = 75,

    walls =
    {
      BRONZEG1 = 30,
      BRONZEG2 = 30,
      BRONZEG3 = 30,
      BROWNGR2 = 18,
      BROWNGR3 = 18,
      BROWNGR4 = 18,
      DRKCMT01 = 20,
      DRKCMT02 = 20,
      DRKCMT03 = 20,
      DRKCMT04 = 20,
      DRKCMT05 = 40,
      DRKCMT06 = 40,
      GOTH15 = 15,
      GOTH17 = 15,
      GOTH18 = 15,
      GOTH31 = 50,
      GOTH36 = 15,
      GOTH37 = 15,
      METAL8 = 20,
      METAL9 = 20,
      METL01 = 10,
      METL02 = 25,
      METL03 = 25,
      RUSTWALL = 60,
      RUSTWAL2 = 60,

      OBTBSLB1 = 15,
      OBTBSLB2 = 15,
      OBTBSLB3 = 15,
      OBTBSLB4 = 15,
      OBTBSLB5 = 15,

      OBTBSB2B = 15,
      OBTBSB3B = 15,
      OBTBSB4B = 15,
      OBTBSB5B = 15,

      G8_BRNW1 = 10,
      G8_BRNW2 = 10,
      G8_BRNW3 = 10,
      G8_BR1GY = 10,
      G8_BR2GY = 10,
      G8_BR3GY = 10,

      OBTSVBZ1 = 10,
      OBTSVBZ2 = 10,
      OBTSVBZ3 = 10,

      OBTBCEM1 = 30,
      OBTBCEM2 = 30,
      OBTBCEM3 = 30
    },

    floors =
    {
      FLAT1 = 40,

      BLACK0 = 25,
      BMARB1 = 25,
      DARKF01 = 50,
      DARKF02 = 50,
      DARKF03 = 50,
      DARKM01 = 50,
      G06 = 50,
      G09 = 50,
      G10 = 50,
      G14 = 25,
      G15 = 50,
      G18 = 50,
      GMET02 = 50,
      GMET04 = 50,
      GMET05 = 50,
      GMET06 = 50,
      FLOOR46D = 50,
      FLOOR46E = 50,
      FLOOR51C = 50,
      GRATE2 = 50,
      GRATE3 = 75,
      GRATE4 = 50,
      GRATE7 = 50,
      GRATE8 = 50,
      MEM01 = 50,
      QFLAT09 = 50,
      QFLAT10 = 50,
      TILES5 = 45,

      OBTSVBF1 = 25,
      OBTSVBF2 = 25,
      OBTSVBF3 = 25,

      G8_BRNF1 = 25,
      G8_BRNF2 = 25,
      G8_BRNF3 = 25
    },

    ceilings =
    {
      CEIL3_5 = 50,
      CEIL5_1 = 50,

      BLACK0 = 50,
      BMARB1 = 50,
      DARKF01 = 50,
      DARKF02 = 50,
      DARKF03 = 50,
      DARKM01 = 50,
      G15 = 50,
      GMET01 = 50,
      GMET02 = 20,
      GMET03 = 50,
      GMET04 = 50,
      GMET05 = 50,
      GMET06 = 15,
      GRATE4 = 50,
      MEM01 = 50,
      QFLAT06 = 50,
      QFLAT09 = 50,

      OBTSVBF1 = 25,
      OBTSVBF2 = 25,
      OBTSVBF3 = 25,

      G8_BRNF1 = 25,
      G8_BRNF2 = 25,
      G8_BRNF3 = 25
    }
  },

  urban_blueBrick = --25
  {
    env = "building",
    prob = 25,

    walls =
    {
      BRIKS37 = 5,
      BRIKS38 = 5,
    },

    floors =
    {
      FLAT1 = 5,
      FLAT3 = 5,
      FLOOR0_3 = 5,
      FLOOR0_5 = 5,
      MFLR8_1 = 5,
      FLAT19 = 5,
      SLIME14 = 5,
      SLIME15 = 5,

      -- explicitly blue flats
      FLAT14 = 15,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      FLOOR1_1 = 15,

      FFLAT01 = 5,
      FLOOR4_7 = 5,
      GSTN01 = 5,
      STARGRF = 5,
      TILES4 = 5,
      TILES6 = 5
    },

    ceilings =
    {
      FLAT1 = 5,
      FLAT3 = 5,
      FLOOR0_3 = 5,
      FLOOR0_5 = 5,
      MFLR8_1 = 5,
      FLAT19 = 5,
      SLIME14 = 5,
      SLIME15 = 5,

      -- explicitly blue flats
      FLAT14 = 15,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      FLOOR1_1 = 15,

      FFLAT01 = 5,
      FLOOR4_7 = 5,
      GSTN01 = 5,
      STARGRF = 5,
      TILES4 = 5,
      TILES6 = 5
    }
  },

  urban_brownyMcBrown = --40
  {
    env = "building",
    prob = 40,

    walls =
    {
      BRICK1 = 10,
      BRICK2 = 10,
      BRICK5 = 10,
      BRICK6 = 10,
      BRICK7 = 10,
      BRICK8 = 10,
      BRICK12 = 10,

      BRONZE1 = 25,
      BRONZE2 = 25,
      BRONZE3 = 25,
      BROWN144 = 25,
      BROWN96 = 25,
      BROWNHUG = 15,

      SPACEW4 = 25,
      STARTAN2 = 30,
      STARBR2 = 30,
      STUCCO = 25,

      BIGSTON4 = 40,
      BRIKS16 = 10,

      BRONZE5 = 40,
      BRONZE6 = 40,

      DRKCMT01 = 15,
      DRKCMT02 = 15,
      DRKCMT03 = 15,
      DRKCMT04 = 15,
      DRKCMT05 = 25,
      DRKCMT06 = 25,

      GOTH38 = 40,
      GOTH39 = 40,
      GOTH40 = 40,
      GOTH41 = 40,
      GOTH42 = 40,

      HELMET1 = 15,
      HELMET2 = 15,

      URBAN5 = 40,
      URBAN7 = 40,

      G8_BRNW1 = 40,
      G8_BRNW2 = 40,
      G8_BRNW3 = 40,

      MMT208 = 40,
      MMT209 = 40,
      MMT210 = 40
    },

    floors =
    {
      CEIL3_1 = 20,
      CEIL3_2 = 20,
      CEIL3_3 = 20,
      CEIL5_2 = 20,

      FLAT5 = 20,
      FLAT9 = 20,
      FLOOR0_1 = 20,
      FLOOR0_2 = 20,

      FLOOR3_3 = 20,
      FLOOR4_1 = 20,
      FLOOR4_5 = 20,
      FLOOR4_6 = 20,
      FLOOR5_3 = 20,

      FLOOR7_1 = 20,

      BRIK01 = 40,
      DARKF01 = 40,
      EG02 = 40,
      EG03 = 40,
      EG06 = 40,

      FLOOR46D = 40,
      FLOOR46E = 40,

      G09 = 40,
      G10 = 40,
      G14 = 40,
      G16 = 40,
      G17 = 40,
      G18 = 20,

      GMET02 = 30,
      GMET03 = 30,
      GMET04 = 30,

      GSTN03 = 40,
      GSTN04 = 40,
      GSTN05 = 40,

      QFLAT05 = 40,
      QFLAT09 = 40,

      STARBR2F = 40,
      STARTANF = 40,

      G8_BRNF1 = 35,
      G8_BRNF2 = 35,
      G8_BRNF3 = 35,
    },

    ceilings =
    {
      CEIL3_1 = 20,
      CEIL3_2 = 20,
      CEIL3_3 = 20,
      CEIL5_2 = 20,

      FLAT5 = 20,
      FLAT9 = 20,
      FLOOR0_1 = 20,
      FLOOR0_2 = 20,

      FLOOR3_3 = 20,
      FLOOR4_1 = 20,
      FLOOR4_5 = 20,
      FLOOR4_6 = 20,
      FLOOR5_3 = 20,

      FLOOR7_1 = 20,

      BRIK01 = 40,
      DARKF01 = 40,
      EG02 = 40,
      EG03 = 40,
      EG06 = 40,

      FLOOR46D = 40,
      FLOOR46E = 40,

      G09 = 40,
      G10 = 40,
      G14 = 40,
      G16 = 40,
      G17 = 40,
      G18 = 20,

      GMET02 = 30,
      GMET03 = 30,
      GMET04 = 30,

      GSTN03 = 40,
      GSTN04 = 40,
      GSTN05 = 40,

      QFLAT05 = 40,
      QFLAT09 = 40,

      STARBR2F = 40,
      STARTANF = 40,

      G8_BRNF1 = 35,
      G8_BRNF2 = 35,
      G8_BRNF3 = 35,
    }
  },

  -- MSSP: inspired by Return to Castle Wolfenstein!
  -- Emphasis on grey/dark bricks and wood floors/ceilings
  urban_returnToCastleWolf = --50
  {
    env = "building",
    prob = 50,

    walls =
    {
      -- black/grey
      ROCK1 = 25,
      ROCK3 = 25,

      BRIKS01 = 35,
      BRIKS02 = 20,
      BRIKS04 = 25,
      BRIKS05 = 25,
      BRIKS07 = 20,
      BRIKS09 = 25,
      BRIKS10 = 50,
      BRIKS11 = 50,
      BRIKS13 = 50,
      BRIKS18 = 75,
      BRIKS21 = 50,
      BRIKS23 = 50,
      BRIKS26 = 25,
      BRIKS27 = 25,
      BRIKS29 = 75,
      BRIKS30 = 75,
      BRIKS32 = 25,
      BRIKS33 = 50,
      BRIKS35 = 50,
      BRIKS36 = 50,
      BRIKS39 = 50,
      BRIKS43 = 50,
      BRONZEG1 = 50,
      BRONZEG2 = 50,
      BRONZEG3 = 50,
      BROWN2 = 25,
      BROWN3 = 25,
      CATACMB3 = 50,
      KSTONE1 = 50,
      ROK03 = 50,
      ROK17 = 50,
      ROK18 = 50
    },

    floors =
    {
      CEIL1_1 = 50,
      FLAT5_1 = 50,
      FLAT5_2 = 50,
      G02 = 50,
      G03 = 50,
      GWOD01 = 50,
      GWOD02 = 50,
      GWOD03 = 50,
      GWOD04 = 50,
      WOODTI2 = 50,
      WOODTIL = 50

      -- deliberately no stone floors
    },

    ceilings =
    {
      -- woods (same as floors)
      CEIL1_1 = 50,
      FLAT5_1 = 50,
      FLAT5_2 = 50,
      G02 = 50,
      G03 = 50,
      GWOD01 = 50,
      GWOD02 = 50,
      GWOD03 = 50,
      GWOD04 = 50,
      WOODTI2 = 50,
      WOODTIL = 50,

      -- stone (dark also)
      FLAT5 = 50,
      FLAT5_7 = 25,
      FLAT5_8 = 25,

      BMARB1 = 15,
      BMARB2 = 25,
      BMARB3 = 15,
      RROCK13 = 25,
      BLACK0 = 25,
      DARKF03 = 25,
      FFLAT01 = 25,
      G04 = 15,
      G05 = 15,
      G06 = 15,
      G07 = 15,
      G08 = 15,
      G11 = 15,
      G12 = 50,
      G19 = 50,
      GMET02 = 10,
      GMET03 = 10,
      GMET04 = 10,
      GMET05 = 10,
      GMET06 = 10,
      GSTN02 = 25,
      MEM01 = 50,
      QFLAT10 = 50,
      RROCK13 = 25,
      TILES5 = 25
    }
  },

  urban_armaetuscave = --60
  {
    env  = "cave",
    prob = 60,

    is_generative = true,

    walls =
    {
      SP_ROCK1 = 30,
      ASHWALL2 = 50,
      ASHWALL3 = 50,
      ASHWALL4 = 50,
      ASHWALL6 = 50,
      ASHWALL7 = 50,
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
      ROK26    = 10
    },

    floors =
    {
      FLAT10 = 60,
      MFLR8_3 = 50,
      RROCK03 = 50,
      RROCK09 = 30
    }
  }
-- END OF THEMES TABLES
}

-- Custom liquids
OBS_RESOURCE_PACK_LIQUIDS =
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
      ice2    = 20
    }
  },

  urban =
  {
    liquids =
    {
      hotlava = 5,
      magma   = 5,
      qlava   = 5,
      purwater = 20,
      bsludge  = 60,
      gwater  = 60,
      ice     = 20,
      ice2    = 20
    }
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
      ice2    = 40
    }
  },

  exclusions =
  {
    desert =
    {
      "ice",
      "ice2"
    }
  }
}

-- Custom sink definitions as well as probability tables.
OBS_RESOURCE_PACK_SINK_DEFS =
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
  },
  --

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

  light_COLLITE1 = -- green
  {
    mat = "LITES04",
    dz = 62,
    light = 32,

    trim_mat = "COLLITE1",
    trim_dz = -2,
    trim_light = 24,
  },

  light_COLLITE2 = -- orange
  {
    mat = "LITES03",
    dz = 62,
    light = 32,

    trim_mat = "COLLITE2",
    trim_dz = -2,
    trim_light = 24,
  },

  light_COLLITE3 = -- blue
  {
    mat = "LITES02",
    dz = 62,
    light = 32,

    trim_mat = "COLLITE3",
    trim_dz = -2,
    trim_light = 24,
  },

  light_RDWAL01 = -- red
  {
    mat = "LITES01",
    dz = 62,
    light = 32,

    trim_mat = "RDWAL01",
    trim_dz = -2,
    trim_light = 24,
  },

  ceiling_sink_TEKWALL8 = -- red
  {
    mat = "TEKWALL8",
    dz = 8,
    light = 32,

    trim_mat = "METAL7",
    trim_dz = -8,
    light = 16,
  },

  ceiling_sink_TEKWALL9 = -- green
  {
    mat = "TEKWALL9",
    dz = 8,
    light = 32,

    trim_mat = "METAL7",
    trim_dz = -8,
    light = 16,
  },

  ceiling_sink_TEKWALLA = -- purple
  {
    mat = "TEKWALLA",
    dz = 8,
    light = 32,

    trim_mat = "METAL7",
    trim_dz = -8,
    light = 16,
  },

  ceiling_sink_TEKWALLB = -- blue
  {
    mat = "TEKWALLB",
    dz = 8,
    light = 32,

    trim_mat = "METAL7",
    trim_dz = -8,
    light = 16,
  },

  ceiling_sink_TEKWALLC = -- pink
  {
    mat = "TEKWALLC",
    dz = 8,
    light = 32,

    trim_mat = "METAL7",
    trim_dz = -8,
    light = 16,
  },

  ceiling_sink_TEKWALLD = -- cyan
  {
    mat = "TEKWALLD",
    dz = 8,
    light = 32,

    trim_mat = "METAL7",
    trim_dz = -8,
    light = 16,
  },

  ceiling_sink_TEKWALLE = -- orange
  {
    mat = "TEKWALLE",
    dz = 8,
    light = 32,

    trim_mat = "METAL7",
    trim_dz = -8,
    light = 16,
  },

  ceiling_sink_SILVER2R = -- silver lights red
  {
    mat = "LITES01",
    dz = 48,
    light = 32,

    trim_mat = "SILVER2R",
    trim_dz = -16,
    light = 16,
  },

  ceiling_sink_SILVER2O = -- silver lights orange
  {
    mat = "LITES03",
    dz = 48,
    light = 32,

    trim_mat = "SILVER2O",
    trim_dz = -16,
    light = 16,
  },

  ceiling_sink_SILVER2Y = -- silver lights yellow
  {
    mat = "LITES03",
    dz = 48,
    light = 32,

    trim_mat = "SILVER2Y",
    trim_dz = -16,
    light = 16,
  },

  ceiling_sink_SILVER2W = -- silver lights white
  {
    mat = "LIGHTS3",
    dz = 48,
    light = 32,

    trim_mat = "SILVER2W",
    trim_dz = -16,
    light = 16,
  },

  ceiling_sink_SILVER2G = -- silver lights green
  {
    mat = "LITES04",
    dz = 48,
    light = 32,

    trim_mat = "SILVER2G",
    trim_dz = -16,
    light = 16,
  },

  -- hell cielings

  ceiling_sink_SKINLOW1 =
  {
    mat = "SKINFLT1",
    dz = 112,
    light = 16,

    trim_mat = "SKINLOW1",
    trim_dz = -16,
    light = 8,
  },

  ceiling_sink_SKINMET3 =
  {
    mat = "SKINFLT1",
    dz = 112,
    light = 16,

    trim_mat = "SKINMET3",
    trim_dz = -16,
    light = 8,
  },

  ceiling_sink_SKINMET4 =
  {
    mat = "SKINFLT1",
    dz = 112,
    light = 16,

    trim_mat = "SKINMET4",
    trim_dz = -16,
    light = 8,
  },

  ceiling_sink_SKINMET5 =
  {
    mat = "SKINFLT1",
    dz = 112,
    light = 16,

    trim_mat = "SKINMET5",
    trim_dz = -16,
    light = 8,
  },

  ceiling_sink_SKINMET6 =
  {
    mat = "SKINFLT1",
    dz = 112,
    light = 16,

    trim_mat = "SKINMET6",
    trim_dz = -16,
    light = 8,
  },

  ceiling_sink_SKINMET7 =
  {
    mat = "FLAT5_3",
    dz = 112,
    light = 16,

    trim_mat = "SKINMET7",
    trim_dz = -16,
    light = 8,
  },

  ceiling_sink_GOTH18 = -- metal tiles
  {
    mat = "DARKF03",
    dz = 64,
    light = 16,

    trim_mat = "GOTH18",
    trim_dz = 0,
    light = 8,
  },

  ceiling_sink_GOTH19 = -- tall red cross
  {
    mat = "GLITE04",
    dz = 128,
    light = 16,

    trim_mat = "GOTH19",
    trim_dz = 0,
    light = 8,
  },

  ceiling_sink_GOTH20 = -- small red cross
  {
    mat = "GLITE03",
    dz = 96,
    light = 16,

    trim_mat = "GOTH20",
    trim_dz = 0,
    light = 8,
  },

  ceiling_sink_GOTH21 = -- horizontal red line
  {
    mat = "GLITE04",
    dz = 32,
    light = 16,

    trim_mat = "GOTH21",
    trim_dz = 0,
    light = 8,
  },

  -- based on composite textures from GOTH21,
  ceiling_sink_GOTH21Y =
  {
    mat = "T_GHFLY",
    dz = 32,
    light = 16,

    trim_mat = "T_GTHLY",
    trim_dz = 0,
    light = 8,
  },

  ceiling_sink_GOTH21G =
  {
    mat = "T_GHFLG",
    dz = 32,
    light = 16,

    trim_mat = "T_GTHLG",
    trim_dz = 0,
    light = 8,
  },

  ceiling_sink_GOTH21B =
  {
    mat = "T_GHFLB",
    dz = 32,
    light = 16,

    trim_mat = "T_GTHLB",
    trim_dz = 0,
    light = 8,
  },

  ceiling_sink_GOTH21P =
  {
    mat = "T_GHFLP",
    dz = 32,
    light = 16,

    trim_mat = "T_GTHLP",
    trim_dz = 0,
    light = 8,
  },

  ceiling_sink_GOTH15 = -- double dark trimmed
  {
    mat = "DARKM01",
    dz = 128,

    trim_mat = "GOTH15",
    trim_dz = 0,
  },

  ceiling_sink_GOTH17 = -- wide beam
  {
    mat = "DARKF03",
    dz = 32,

    trim_mat = "GOTH17",
    trim_dz = 0,
  },

  ceiling_sink_GOTH28 = -- scary faces
  {
    mat = "G05",
    dz = 128,

    trim_mat = "GOTH28",
    trim_dz = 0,
  },

  ceiling_sink_GOTH47 = -- small brown skulls
  {
    mat = "G09",
    dz = 48,

    trim_mat = "GOTH47",
    trim_dz = -16,
  },

  ceiling_sink_GOTH48 = -- large brown skulls
  {
    mat = "GMET02",
    dz = 48,

    trim_mat = "GOTH48",
    trim_dz = -16,
  },

  ceiling_sink_GOTH49 = -- inset brown skulls
  {
    mat = "G14",
    dz = 48,

    trim_mat = "GOTH49",
    trim_dz = -16,
  },

  -- hell floors
  floor_sink_GOTH22 =
  {
    mat = "GMET04",
    dz = -16,

    trim_mat = "GOTH22",
    trim_dz = 0,
  },

  -- urban-ish carpets -MSSP
  floor_sink_CARPET1 =
  {
    mat = "CARPET1",
    dz = 0,

    trim_mat = "ORANFLOR",
    trim_dz = 0,
  },

  floor_sink_CARPET1 =
  {
    mat = "CARPET1",
    dz = 0,

    trim_mat = "ORANFLOR",
    trim_dz = 0,
  },

  floor_sink_CARPET1 =
  {
    mat = "CARPET1",
    dz = 0,

    trim_mat = "ORANFLOR",
    trim_dz = 0,
  },

  floor_sink_CARPET2 =
  {
    mat = "CARPET2",
    dz = 0,

    trim_mat = "ORANFLOR",
    trim_dz = 0,
  },

  floor_sink_CARPET2 =
  {
    mat = "CARPET2",
    dz = 0,

    trim_mat = "CEIL5_1",
    trim_dz = 0,
  },

  floor_sink_CARPET3 =
  {
    mat = "CARPET3",
    dz = 0,

    trim_mat = "ORANFLOR",
    trim_dz = 0,
  },

  floor_sink_CARPET4 =
  {
    mat = "CARPET4",
    dz = 0,

    trim_mat = "CEIL5_1",
    trim_dz = 0,
  },

  floor_sink_CARPET5 =
  {
    mat = "CARPET5",
    dz = 0,

    trim_mat = "CEIL5_1",
    trim_dz = 0,
  },

  floor_sink_CARPET6 =
  {
    mat = "CARPET6",
    dz = 0,

    trim_mat = "CEIL5_1",
    trim_dz = 0,
  },

  floor_sink_CARPET7 =
  {
    mat = "CARPET7",
    dz = 0,

    trim_mat = "ORANFLOR",
    trim_dz = 0,
  },

  floor_sink_CARPET8 =
  {
    mat = "CARPET8",
    dz = 0,

    trim_mat = "FLAT19",
    trim_dz = 0,
  },

  -- tech carpets
  floor_sink_carpet_FLAT15 = --red
  {
    mat = "FLAT15",
    dz = 0,

    trim_mat = "CEIL5_2",
    trim_dz = 0,
  },

  floor_sink_carpet_FLOOR1_1 = --red with UAC logo
  {
    mat = "FLOOR1_1",
    dz = 0,

    trim_mat = "CEIL5_2",
    trim_dz = 0,
  },

  floor_sink_carpet_FLOOR1_2 = --blue with UAC logo
  {
    mat = "FLOOR1_2",
    dz = 0,

    trim_mat = "CEIL5_1",
    trim_dz = 0,
  },

  -- generic sinks based from CEIL4_3, recolored composites
  floor_c43_red =
  {
    mat = "T_CL43R",
    dz  = -8,
  },

  floor_c43_yellow =
  {
    mat = "T_CL43Y",
    dz  = -8,
  },

  floor_c43_green =
  {
    mat = "T_CL43G",
    dz  = -8,
  },

  floor_c43_purple =
  {
    mat = "T_CL43P",
    dz  = -8,
  },

  light_side1_red =
  {
    mat = "T_CL43R",
    dz  = 16,
    light = 32,

    trim_mat = "LITE5",
    trim_dz  = 0,
  },

  light_side1_yellow =
  {
    mat = "T_CL43Y",
    dz  = 16,
    light = 32,

    trim_mat = "LITE5",
    trim_dz  = 0,
  },

  light_side1_green =
  {
    mat = "T_CL43G",
    dz  = 16,
    light = 32,

    trim_mat = "LITE5",
    trim_dz  = 0,
  },

  light_side1_purple =
  {
    mat = "T_CL43P",
    dz  = 16,
    light = 32,

    trim_mat = "LITE5",
    trim_dz  = 0,
  },

  light_lite5_red =
  {
    mat = "CEIL5_1",
    dz  = 16,
    light = 32,

    trim_mat = "T_VSLTER",
    trim_dz  = 0,
  },

  light_lite5_orange =
  {
    mat = "CEIL5_1",
    dz  = 16,
    light = 32,

    trim_mat = "T_VSLTEO",
    trim_dz  = 0,
  },

  light_lite5_yellow =
  {
    mat = "CEIL5_1",
    dz  = 16,
    light = 32,

    trim_mat = "T_VSLTEY",
    trim_dz  = 0,
  },

  light_lite5_green =
  {
    mat = "FLAT23",
    dz  = 16,
    light = 32,

    trim_mat = "T_VSLTEG",
    trim_dz  = 0,
  },

  light_lite5_purple =
  {
    mat = "FLAT23",
    dz  = 16,
    light = 32,

    trim_mat = "T_VSLTEP",
    trim_dz  = 0,
  },

  -- more weird ceiling liquids for hell

  ceil_purple_water =
  {
    mat = "PURW1",
    dz    = 64,

    trim_mat = "BROWN2",
    trim_dz  = -8,
  },

  ceil_emagma =
  {
    mat = "MAGMA1",
    dz    = 64,

    trim_mat = "BRIKS39",
    trim_dz  = -8,
  },

  ceil_qlava2 =
  {
    mat = "QLAVA1",
    dz    = 64,

    trim_mat = "BRIKS40",
    trim_dz  = -8,
  },

  ceil_esludge =
  {
    mat = "SLUDGE01",
    dz    = 64,

    trim_mat = "DRKCMT05",
    trim_dz  = -8,
  },

  ceil_liquid_snow =
  {
    mat = "SNOW9",
    dz    = 64,

    trim_mat = "URBAN3",
    trim_dz  = -8,
  },

  floor_warn_streets =
  {
    mat = "CEIL5_1",
    dz = 2,

    trim_mat = "WARN1",
    trim_dz = 2,
  },

  floor_asphalt_streets =
  {
    mat = "ROAD1",
    dz = 2,

    trim_mat = "WARN1",
    trim_dz = 2,
  },

  floor_cobble1_streets =
  {
    mat = "ROAD2",
    dz = 2,

    trim_mat = "FLAT1",
    trim_dz = 2,
  },

  floor_cobble2_streets =
  {
    mat = "ROAD3",
    dz = 2,

    trim_mat = "FLAT5_4",
    trim_dz = 2,
  },

  floor_cobble3_streets =
  {
    mat = "ROAD4",
    dz = 2,

    trim_mat = "FLAT5_5",
    trim_dz = 2,
  },
}

OBS_RESOURCE_PACK_THEMES =
{
  tech =
  {
    wide_halls =
    {
      deuce = 50,
      metro = 25,
      ducts = 50,
      conveyor = 50,
      pipeline = 50,
    },

    facades =
    {
      STARTAN3 = 50,
      STARG3 = 50,
      BRONZE1 = 25,
      BRONZE3 = 25,
      BRONZE5 = 15,
      BRONZE6 = 10,
      BRONZEG3 = 10,

      GRAY6 = 25,
      GRAY8 = 25,
      GRAY9 = 25,

      STONE  = 20,
      STONE2 = 20,
      STONE3 = 20,

      BROWN1 = 20,
      BROWNGRN = 20,
      BRVINE = 20,
      BROVINE2 = 20,
      BROWNGR2 = 10,
      BROWNGR3 = 10,
      BROWNGR4 = 10,
      GRAYVINE = 10,

      TEKGREN2 = 15,
      TEKSHAW  = 15,
      TEKGRY01 = 15,
      TEKGRY02 = 10,

      GRAYMET2 = 10,
      GRAYMET3 = 10,
      GRAYMET4 = 10,
      GRAYMET5 = 10,
      BROWN2   = 10,
      BROWN3   = 10,

      METAL8 = 12,
      METAL9 = 12,
      METAL10 = 12,

      SHAWN4 = 15,
      SHAWN5 = 15,
      HEX01 = 15,

      OBTBSLV1 = 15,
      OBTBSLV2 = 15,
      OBTBSLV3 = 15,
      OBTBSLV4 = 15,
      OBTBSLV5 = 10,

      OBTBSTX1 = 20,
      OBTBSTX2 = 20,
      OBTBSTX3 = 20,

      OBTSTX1B = 15,
      OBTSTX1G = 15,

      OBTBSLB1 = 20,
      OBTBSLB2 = 20,
      OBTBSLB3 = 20,
      OBTBSLB4 = 20,
      OBTBSLB5 = 20,

      OBTBSB2B = 15,
      OBTBSB3B = 15,
      OBTBSB4B = 15,
      OBTBSB5B = 15,

      G8_BRNW1 = 10,
      G8_BRNW2 = 10,
      G8_BRNW3 = 10,
      G8_BR1GY = 10,
      G8_BR2GY = 10,
      G8_BR3GY = 10,

      OBTSVBZ1 = 15,
      OBTSVBZ2 = 15,
      OBTSVBZ3 = 15,

      OBTBCEM1 = 25,
      OBTBCEM2 = 25,
      OBTBCEM3 = 25
    },

    fences =
    {
      BRIKS31 = 30,
      BRIKS32 = 30,

      BRONZE5 = 30,
      BRONZE6 = 30,

      BRONZEG1 = 30,
      BRONZEG2 = 30,
      BRONZEG3 = 30,
      BROWN2 = 30,
      BROWN3 = 30,
      BROWNGR2 = 30,
      BROWNGR4 = 30,

      CEM09 = 20,
      CEM10 = 20,
      CEM11 = 20,

      DRKCMT05 = 10,
      DRKCMT06 = 10,

      GOTH15 = 15,
      GOTH38 = 15,
      GOTH39 = 15,

      GOTH42 = 15,

      GRAY6 = 30,
      GRAY8 = 30,
      GRAY9 = 30,

      GRAYMET2 = 30,
      GRAYMET3 = 30,
      GRAYMET4 = 30,
      GRAYMET5 = 30,

      METAL10 = 20,
      METAL8 = 20,
      METAL9 = 20,
      METL01 = 20,
      METL02 = 20,
      METL03 = 20,

      SHAWGRY4 = 25,
      SHAWN01C = 25,
      SHAWN01D = 25,
      SHAWN01E = 25,
      SHAWN01F = 25,

      SHAWN4 = 25,
      SHAWN5 = 25,
      SHAWSH04 = 25,

      SNOWWAL1 = 30,
      SNOWWAL2 = 30,
      SNOWWAL3 = 30,
      SNOWWAL4 = 30,

      STON7 = 15,
      STONE10 = 30,

      TEKGRN01 = 25,
      TEKGRY01 = 25,
      TEKGRY02 = 25,
      TEKSHAW = 25,

      URBAN5 = 25,
      URBAN6 = 25,
      URBAN7 = 25,
      URBAN8 = 25
    },

    fence_groups =
    {
      fence_firestorm_red = 25,
      fence_firestorm_blue = 25,
      fence_construction = 20,
      fence_highway_bars_warnstep = 20,
      fence_park_bars = 20,
      fence_park_bars_round = 20
    },

    wall_groups =
    {
      gtd_wall_server_room2 = 50,
      --
      gtd_storage_shawn = 50,
      --
      gtd_wall_cafeteria_set = 50,
      --
      gtd_collite_set_green = 13,
      gtd_collite_set_orange = 13,
      gtd_collite_set_blue = 13,
      gtd_collite_set_red = 13,
      --
      gtd_wall_lit_box_blue = 13,
      gtd_wall_lit_box_red = 13,
      gtd_wall_lit_box_white = 13,
      gtd_wall_lit_box_yellow = 13,
      --
      gtd_wall_metal_warning = 13,
      gtd_wall_metal_warning_bottom = 13,
      --
      gtd_wall_vertical_light_1 = 16,
      gtd_wall_vertical_light_2 = 16,
      gtd_wall_vertical_light_3 = 16,
      --
      gtd_wall_hydroponics = 50,
      --
      gtd_computers_shawn = 17,
      gtd_computers_compsta = 17,
      --
      gtd_wall_teklitecomp_red = 16,
      gtd_wall_teklitecomp_orange = 16,
      gtd_wall_teklitecomp_blue = 16,
      --
      gtd_wall_grated_machines_epic = 50,
      --
      gtd_wall_tech_oven = 35,
      gtd_wall_tech_freezer = 35,
      gtd_wall_air_vents = 35,
      --
      gtd_wall_of_guns = 50,
      --
      gtd_comp_set_yellow_EPIC = 35,
      gtd_comp_set_green_EPIC = 35,
      gtd_comp_set_red_EPIC = 35,
      --
      gtd_comptil_plain_red = 13,
      gtd_comptil_plain_green = 13,
      gtd_comptil_plain_yellow = 13,
      gtd_comptil_plain_purple = 13,
      gtd_comptil_plain_blue = 13,
      --
      gtd_comptil_lite_red = 13,
      gtd_comptil_lite_green = 13,
      gtd_comptil_lite_yellow = 13,
      gtd_comptil_lite_purple = 13,
      gtd_comptil_lite_blue = 13,
      --
      gtd_comp_graymet_blue = 13,
      gtd_comp_graymet_green = 13,
      gtd_comp_graymet_red = 13,
      gtd_comp_graymet_orange = 13,
      gtd_comp_graymet_purple = 13,
      --
      gtd_comp_grntek_blue = 26,
      --
      gtd_wall_lit_h_window_tall_collite_blue = 25,
      gtd_wall_lit_h_window_tall_collite_orange = 10,
      --
      wall_collite_flat_green = 25,
      wall_collite_flat_blue = 25,
      --
      gtd_green_shipping_containers = 50,
      --
      gtd_power_plant_red_set = 40,
      --
      gtd_bathwater = 30,
      gtd_mscottpaper = 30
    },

    window_groups =
    {
      gtd_window_chainlinks = 40,
      gtd_window_bulletproof_glass = 15,
      gtd_window_bulletproof_glass_green = 15,
      gtd_window_bulletproof_glass_orange = 15,
      gtd_window_tall_and_glassy = 10,
      gtd_window_goffik = 2.5,
      gtd_window_goffik_gold = 2.5,
      gtd_window_octo_glass = 30,
    },

    street_sinks =
    {
      floor_asphalt_streets = 10,
      floor_warn_streets = 10,
    },

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

      light_COLLITE1 = 15,
      light_COLLITE2 = 15,
      light_COLLITE3 = 15,
      light_RDWAL01 = 15,

      light_side1_red = 15,
      light_side1_yellow = 15,
      light_side1_green = 15,
      light_side1_purple = 5,

      light_lite5_red = 15,
      light_lite5_orange = 15,
      light_lite5_yellow = 15,
      light_lite5_green = 15,
      light_lite5_purple = 5,

      ceiling_sink_TEKWALL8 = 8,
      ceiling_sink_TEKWALL9 = 8,
      --ceiling_sink_TEKWALLA = 8,
      ceiling_sink_TEKWALLB = 8,
      --ceiling_sink_TEKWALLC = 8,
      ceiling_sink_TEKWALLD = 8,
      ceiling_sink_TEKWALLE = 8,

      ceiling_sink_SILVER2R = 5,
      ceiling_sink_SILVER2O = 5,
      ceiling_sink_SILVER2Y = 5,
      ceiling_sink_SILVER2W = 5,
      ceiling_sink_SILVER2G = 5,

      ceiling_sink_GOTH21 = 5,
      ceiling_sink_GOTH21Y = 5,
      ceiling_sink_GOTH21G = 5,
      ceiling_sink_GOTH21B = 5,
      -- ceiling_sink_GOTH21P = 5,
    },

    floor_sinks =
    {
      liquid_warning_strip = 40,

      floor_sink_carpet_FLAT15 = 10,
      floor_sink_carpet_FLOOR1_1 = 10,
      floor_sink_carpet_FLOOR1_2 = 10,

      floor_c43_red = 10,
      floor_c43_yellow = 10,
      floor_c43_green = 10,
      -- floor_c43_purple = 2,
    },

    scenic_fences =
    {
      FENCE1 = 10,
      FENCE2 = 10,
      FENCE3 = 7,
      FENCE6 = 5,
      FENCE7 = 5,
      FENCEC = 2,
      RAIL1 = 10,
      BARBWIRE = 3,
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
      Skybox_garrett_city_EPIC = 25,
      Skybox_tech_ffvii_EPIC = 50,
      Skybox_generic_EPIC = 50,
      Skybox_craneo_fishing_village_EPIC = 25,
      Skybox_garrett_winterfall_EPIC = 12,
      Skybox_craneo_space_shuttle_EPIC = 50,
      Skybox_city_bridge_EPIC = 35,
      Skybox_urban_cyber_EPIC = 35,
      Skybox_char_EPIC = 50,
    },
  },

  urban =
  {
    wide_halls =
    {
      deuce = 50,
      metro = 50,
      ducts = 50,
    },

    facades =
    {
      BIGBRIK1 = 50,
      BIGBRIK2 = 50,
      STUCCO   = 50,
      STUCCO1  = 20,
      STUCCO3  = 20,

      BSTONE1 = 25,
      BSTONE2 = 25,

      BRICK1 = 25,
      BRICK10 = 25,
      BRICK11 = 25,
      BRICK12 = 25,
      BRICK5  = 25,
      BRICK6  = 25,
      BRICK7  = 25,
      BRICK8  = 25,
      BRICK9  = 25,

      STONE    = 25,
      BIGSTONE = 25,
      BIGSTON2 = 25,
      BIGSTON3 = 25,
      BIGSTON4 = 25,
      STONE2   = 15,
      STONE3   = 15,

      BRIKS01 = 20,
      BRIKS02 = 20,
      BRIKS04 = 20,
      BRIKS05 = 20,
      BRIKS06 = 20,
      BRIKS10 = 20,
      BRIKS12 = 20,
      BRIKS13 = 20,
      BRIKS14 = 20,
      BRIKS15 = 20,
      BRIKS16 = 20,
      BRIKS17 = 20,
      BRIKS21 = 20,
      BRIKS22 = 20,
      BRIKS23 = 20,
      BRIKS24 = 20,
      --BRIKS25 = 10,
      BRIKS26 = 20,
      BRIKS27 = 20,
      BRIKS28 = 10,
      BRIKS29 = 15,
      BRIKS30 = 10,
      BRIKS31 = 10,
      BRIKS32 = 10,
      BRIKS33 = 15,
      BRIKS34 = 20,
      BRIKS35 = 15,
      BRIKS36 = 15,
      BRIKS37 = 10,
      BRIKS38 = 10,
      BRIKS39 = 15,
      BRIKS40 = 10,
      BRIKS41 = 10,
      BRIKS42 = 15,
      BRIKS43 = 20,
      GOTH45  = 20,
      ROK17   = 20,
      ROK18   = 20,
      ROK19   = 15,

      URBAN1 = 20,
      URBAN2 = 20,
      URBAN3 = 20,
      URBAN4 = 20,

      METAL2 = 15,
      BRONZE1 = 10,
      BRONZE3 = 10,

      --
      BRIC9GRN = 3,
      BRIC9GRY = 15,
      BRIC9TAN = 15,
      BRICEGRN = 3,
      BRICEGRY = 15,

      --
      OBTBSTX1 = 15,
      OBTBSTX3 = 15,

      OBTBSLB1 = 20,
      OBTBSLB2 = 20,
      OBTBSLB3 = 20,
      OBTBSLB4 = 20,

      OBTBSB2B = 15,
      OBTBSB3B = 15,
      OBTBSB4B = 15,

      OBTSVBZ1 = 15,
      OBTSVBZ2 = 15,
      OBTSVBZ3 = 15,

      OBTBCEM1 = 25,
      OBTBCEM2 = 25,
      OBTBCEM3 = 25
    },

    fences =
    {
      BIGSTONE = 30,
      BIGSTON2 = 30,
      BIGSTON3 = 30,
      BIGSTON4 = 30,

      BRIKS01 = 15,
      BRIKS02 = 15,
      BRIKS03 = 15,
      BRIKS04 = 15,
      BRIKS05 = 15,
      BRIKS06 = 15,
      BRIKS07 = 15,
      BRIKS08 = 15,
      BRIKS09 = 15,
      BRIKS10 = 15,
      BRIKS11 = 15,
      BRIKS12 = 15,
      BRIKS13 = 15,
      BRIKS14 = 15,
      BRIKS15 = 15,
      BRIKS16 = 15,
      BRIKS17 = 15,
      BRIKS18 = 15,
      BRIKS19 = 15,
      BRIKS20 = 15,
      BRIKS21 = 15,
      BRIKS22 = 15,
      BRIKS23 = 15,
      BRIKS24 = 15,
      --BRIKS25 = 15,
      BRIKS26 = 15,
      BRIKS27 = 15,
      BRIKS28 = 8,
      BRIKS29 = 15,
      BRIKS30 = 15,
      BRIKS31 = 15,
      BRIKS32 = 15,
      BRIKS33 = 15,
      BRIKS34 = 15,
      BRIKS35 = 15,
      BRIKS36 = 15,
      BRIKS37 = 15,
      BRIKS38 = 15,
      BRIKS39 = 15,
      BRIKS40 = 15,
      BRIKS41 = 15,
      BRIKS42 = 15,
      BRIKS43 = 15,

      BRONZE5 = 30,
      BRONZE6 = 30,
      BRONZEG1 = 30,
      BRONZEG2 = 30,
      BRONZEG3 = 30,
      BROWN2 = 30,
      BROWN3 = 30,
      BROWNGR2 = 30,
      BROWNGR3 = 30,
      BROWNGR4 = 30,

      CEM10 = 30,
      CEM11 = 30,

      EGYPT03 = 15,
      EGYPT04 = 15,
      EGYPT06 = 15,

      GOTH01 = 15,
      GOTH02 = 15,
      GOTH03 = 15,

      GOTH17 = 15,
      GOTH18 = 15,

      GOTH29 = 15,
      GOTH30 = 15,
      GOTH31 = 15,
      GOTH32 = 15,
      GOTH34 = 15,
      GOTH36 = 15,
      GOTH37 = 15,
      GOTH38 = 15,
      GOTH39 = 15,

      GOTH42 = 15,
      GOTH45 = 15,

      GRAY6 = 30,
      GRAY8 = 30,
      GRAY9 = 30,

      GRAYMET2 = 10,
      GRAYMET3 = 10,
      GRAYMET4 = 10,
      GRAYMET5 = 10,

      METAL10 = 10,
      METAL8 = 10,
      METAL9 = 10,
      METL01 = 10,
      METL02 = 10,

      MM205 = 10,

      ROK03 = 20,
      ROK16 = 20,
      ROK17 = 20,
      ROK18 = 20,
      ROK19 = 20,

      SHAWSH04 = 15,

      SNOWWAL1 = 20,
      SNOWWAL2 = 20,
      SNOWWAL3 = 20,
      SNOWWAL4 = 20,

      TEKGRN01 = 20,
      TEKGRY01 = 20,
      TEKGRY02 = 20,

      URBAN1 = 30,
      URBAN2 = 30,
      URBAN3 = 30,
      URBAN4 = 30,
      URBAN5 = 30,
      URBAN6 = 30,
      URBAN7 = 30,
      URBAN8 = 30,

      WD01 = 15,
      WD02 = 15,
      WD03 = 15,
      WD04 = 15,

      WOOD13 = 15,
      WOOD14 = 15,
      WOOD15 = 15,
      WOOD16 = 15,
      WOOD17 = 15,

      OBTBSLB2 = 20,
      OBTBSLB3 = 20,
      OBTBSLB4 = 20,
      OBTBSLB5 = 20
    },

    fence_groups =
    {
      fence_construction = 50,
      fence_highway_bars_warnstep = 25,
      dem_wall_graveyard = 25,
      fence_park_bars = 20,
      fence_park_bars_round = 20
    },

    wall_groups =
    {
      dem_wall_commercial = 50,
      dem_wall_hospital = 50,
      gtd_grocery = 25,
      gtd_grocery_2 = 25,
      --
      gtd_wall_cafeteria_set = 50,
      --
      gtd_storage_shawn = 50,
      --
      gtd_tall_glass_epic_yellow = 8,
      gtd_tall_glass_epic_orange = 8,
      gtd_tall_glass_epic_red = 8,
      gtd_tall_glass_epic_blue = 8,
      gtd_wall_churchy_glass = 5,
      gtd_winglass_wall = 5,
      --
      gtd_collite_set_green = 12,
      gtd_collite_set_orange = 12,
      gtd_collite_set_blue = 12,
      gtd_collite_set_red = 12,
      --
      gtd_wall_lit_box_blue = 12,
      gtd_wall_lit_box_red = 12,
      gtd_wall_lit_box_white = 12,
      gtd_wall_lit_box_yellow = 12,
      --
      gtd_wall_metal_warning = 25,
      gtd_wall_metal_warning_bottom = 25,
      --
      gtd_wall_vertical_light_1 = 16,
      gtd_wall_vertical_light_2 = 16,
      gtd_wall_vertical_light_3 = 16,
      --
      gtd_epic_craneo_paintings = 40,
      --
      gtd_computers_shawn = 12,
      gtd_computers_compsta = 12,
      --
      gtd_wall_gothic_bottom_glass = 25,
      --
      gtd_wall_arcade = 50,
      --
      gtd_wall_teklitecomp_red = 8,
      gtd_wall_teklitecomp_orange = 8,
      gtd_wall_teklitecomp_blue = 8,
      --
      gtd_wall_grated_machines_epic = 25,
      --
      gtd_library_tall = 35,
      --
      gtd_wall_air_vents = 50,
      --
      gtd_wall_of_guns = 50,
      --
      gtd_wall_hell_engraving_1 = 8,
      gtd_wall_hell_engraving_2 = 8,
      gtd_wall_hell_engraving_3 = 8,
      --
      gtd_wall_hell_engraving_dark = 25,
      gtd_wall_hell_engraving_arch = 25,
      --
      gtd_comp_grntek_blue = 20,
      --
      gtd_wall_lit_h_window_tall_collite_blue = 10,
      gtd_wall_lit_h_window_tall_collite_orange = 25,
      --
      gtd_green_shipping_containers = 50,
      --
      gtd_power_plant_red_set = 20,
      --
      gtd_bathwater = 30,
      gtd_mscottpaper = 30,
      --
      gtd_pools = 30
    },

    window_groups =
    {
      gtd_window_gothic_epic = 30,
      gtd_window_chainlinks = 40,
      gtd_window_bulletproof_glass = 10,
      gtd_window_bulletproof_glass_green = 10,
      gtd_window_bulletproof_glass_orange = 10,
      gtd_window_tall_and_glassy = 60,
      gtd_window_goffik = 5,
      gtd_window_goffik_gold = 5,
      gtd_window_octo_glass = 20,
    },

    street_sinks =
    {
      floor_asphalt_streets = 10,
      floor_warn_streets = 10,
    },

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

      light_COLLITE1 = 15,
      light_COLLITE2 = 15,
      light_COLLITE3 = 15,
      light_RDWAL01 = 15,

      light_side1_red = 15,
      light_side1_yellow = 15,
      light_side1_green = 15,
      light_side1_purple = 5,

      light_lite5_red = 15,
      light_lite5_orange = 15,
      light_lite5_yellow = 15,
      light_lite5_green = 15,
      light_lite5_purple = 5,

      ceiling_sink_TEKWALL8 = 7,
      ceiling_sink_TEKWALL9 = 7,
      --ceiling_sink_TEKWALLA = 7,
      ceiling_sink_TEKWALLB = 7,
      --ceiling_sink_TEKWALLC = 7,
      ceiling_sink_TEKWALLD = 7,
      ceiling_sink_TEKWALLE = 7,

      ceiling_sink_GOTH15 = 20,
      ceiling_sink_GOTH17 = 20,

      ceiling_sink_GOTH21 = 5,
      ceiling_sink_GOTH21Y = 5,
      ceiling_sink_GOTH21G = 5,
      ceiling_sink_GOTH21B = 5,
      ceiling_sink_GOTH21P = 5,
    },

    floor_sinks =
    {
      liquid_warning_strip = 10,

      floor_sink_CARPET1 = 7,
      floor_sink_CARPET2 = 7,
      floor_sink_CARPET3 = 7,
      floor_sink_CARPET4 = 7,
      floor_sink_CARPET5 = 7,
      floor_sink_CARPET6 = 7,
      floor_sink_CARPET7 = 7,
      floor_sink_CARPET8 = 7,
    },

    scenic_fences =
    {
      FENCE1 = 2,
      FENCE2 = 2,
      FENCE3 = 5,
      FENCE6 = 10,
      FENCE7 = 10,
      FENCE8 = 4,
      FENCE9 = 4,
      FENCEA = 4,
      FENCEB = 4,
      FENCEC = 5,
      RAIL1 = 10,
      BARBWIRE = 3,
      MIDSPAC2 = 4,
      MIDSPAC3 = 1,
      MIDSPAC5 = 2,
      MIDSPAC8 = 3,
      MIDWIND1 = 10,
      MIDWIND2 = 2,
      MIDWIND3 = 2,
      MIDWIND4 = 10,
      MIDWIND5 = 2,
      MIDWIND6 = 10,
      MIDWIND7 = 2,
      MIDVINE1 = 3,
      MIDVINE2 = 3,
    },

    skyboxes =
    {
      Skybox_hellish_city_EPIC = 50,
      Skybox_garrett_city_EPIC = 50,
      Skybox_craneo_fishing_village_EPIC = 50,
      Skybox_garrett_winterfall_EPIC = 25,
      Skybox_craneo_egypt_EPIC = 35,
      Skybox_craneo_space_shuttle_EPIC = 15,
      Skybox_city_bridge_EPIC = 50,
      Skybox_g99_hell_tower_EPIC = 15,
      Skybox_urban_cyber_EPIC = 50,
      Skybox_char_EPIC = 30,
    },
  },

  hell =
  {
    wide_halls =
    {
      deuce = 50,
      --metro = 20,
      organs = 50,
      conveyorh = 50,
      -- hellcata = 50 -- because this is dependent on styles
                       -- insertion process is a bit more complicated
                       -- and initial prob is instead done via style prob bias -MSSP
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
      MARBGRAY = 25,
      BLAKMBGY = 20,

      SP_HOT1 = 20,
      SP_HOT2 = 20,
      SP_HOT3 = 20,
      STONE   = 20,
      STONE4  = 15,
      STONE6  = 15,
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
      HELLCMT2 = 15,
      SKTEK01 = 15,
      SKTEK02 = 15,
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
      BRVINE   = 10,

      CREYEWLL = 7,
      CRFSHWLL = 7,
      CRGRSWLL = 7,
      CRHRTWLL = 7,

      --
      BRIC9GRN = 5,
      BRIC9GRY = 15,
      BRIC9TAN = 15,
      BRICEGRN = 15,
      BRICEGRY = 15,

      -- MSSP stuff
      OBTBSLB2 = 15,
      OBTBSLB3 = 15,
      OBTBSLB4 = 15,

      G8_BRNW1 = 15,
      G8_BRNW3 = 15,
      G8_BR2GY = 15,
      G8_BR3GY = 15,

      G7_GOGN1 = 25,
      G7_GOGN2 = 25,
      G7_GOGN3 = 25
    },

    fences =
    {
      BIGSTON4 = 25,
      BIGSTONE = 25,

      BLAKMBGY = 25,

      BRIKS01 = 15,
      BRIKS02 = 15,
      BRIKS03 = 15,
      BRIKS07 = 15,

      BRIKS10 = 10,
      BRIKS11 = 10,
      BRIKS15 = 10,
      BRIKS16 = 10,
      BRIKS17 = 10,

      BRIKS22 = 10,
      BRIKS24 = 10,
      BRIKS26 = 10,
      BRIKS27 = 10,
      BRIKS28 = 10,

      BRIKS33 = 10,
      BRIKS35 = 10,
      BRIKS36 = 10,

      BRIKS39 = 10,
      BRIKS40 = 10,
      BRIKS41 = 10,
      BRIKS42 = 10,

      BRONZE5 = 25,
      BRONZE6 = 25,
      BRONZEG1 = 25,
      BRONZEG2 = 25,
      BRONZEG3 = 25,
      BROWN2 = 25,
      BROWN3 = 25,

      DESBRIK1 = 10,
      DESBRIK2 = 10,
      DESBRIK3 = 10,
      DESBRIK4 = 10,
      DESBRIK5 = 10,
      DESBRIK6 = 10,
      DESBRIK7 = 10,

      DESMARB2 = 10,

      DRKCMT04 = 10,
      DRKCMT05 = 15,
      DRKCMT06 = 15,

      GOTH06 = 20,
      GOTH07 = 20,
      GOTH08 = 20,
      GOTH09 = 20,
      GOTH10 = 20,
      GOTH11 = 20,
      GOTH12 = 20,
      GOTH13 = 20,
      GOTH14 = 20,
      GOTH15 = 20,
      GOTH16 = 20,
      GOTH17 = 20,
      GOTH18 = 20,

      GOTH23 = 20,
      GOTH24 = 20,
      GOTH25 = 20,
      GOTH26 = 20,
      GOTH27 = 20,
      GOTH29 = 20,
      GOTH30 = 20,
      GOTH31 = 20,
      GOTH32 = 20,

      GOTH34 = 20,
      GOTH35 = 20,
      GOTH36 = 20,
      GOTH37 = 20,
      GOTH38 = 20,
      GOTH39 = 20,
      GOTH40 = 20,
      GOTH41 = 20,
      GOTH42 = 20,
      GOTH43 = 20,
      GOTH44 = 20,
      GOTH45 = 20,
      GOTH46 = 20,
      GOTH47 = 20,
      GOTH48 = 20,
      GOTH49 = 20,

      HELLCMT7 = 10,
      HELLCMT8 = 10,

      HELMET1 = 20,
      HELMET2 = 20,

      KMARBLE1 = 25,
      KMARBLE2 = 25,
      KMARBLE3 = 25,

      MARBLE4 = 25,
      MARBLE5 = 25,
      MARBLE6 = 25,
      MARBLE7 = 25,
      MARBLE8 = 25,

      METL02 = 20,
      METL03 = 20,

      MM205 = 20,
      MM206 = 10,
      MM207 = 10,
      MMT208  = 10,
      MMT209  = 10,
      MMT210  = 10,

      REDMARB1 = 15,
      REDMARB2 = 15,
      REDMARB3 = 15,

      ROK03 = 20,
      ROK05 = 20,
      ROK07 = 20,
      ROK13 = 20,
      ROK18 = 20,
      ROK19 = 20,

      RUSTWAL2 = 25,
      RUSTWALL = 25,

      VINES1 = 20,
      VINES2 = 20,

      WD01 = 20,
      WD02 = 20,
      WD03 = 20,
      WDMET01 = 20,
      WDMET02 = 20,
      WDMET03 = 20,

      WOOD13 = 20,
      WOOD14 = 20,
      WOOD15 = 20,
      WOOD16 = 20,
      WOOD17 = 20,
    },

    fence_groups =
    {
      dem_wall_graveyard = 50,
      fence_park_bars = 20,
      fence_park_bars_round = 20
    },

    wall_groups =
    {
      gtd_tall_glass_epic_yellow = 15,
      gtd_tall_glass_epic_orange = 15,
      gtd_tall_glass_epic_red = 15,
      gtd_tall_glass_epic_blue = 15,
      gtd_wall_churchy_glass = 30,
      --
      armaetus_catacomb_wall_set = 50,
      armaetus_catacombs_brown = 50,
      --
      gtd_winglass_wall = 50,
      gtd_collite_set_green = 6,
      gtd_collite_set_orange = 6,
      gtd_collite_set_blue = 6,
      gtd_collite_set_red = 6,
      gtd_g99 = 50,
      --
      armaetus_wallbodies = 12,
      armaetus_wallbodies_bloody = 12,
      armaetus_wallbodies_old = 12,
      armaetus_wallbodies_bones = 12,
      --
      gtd_wall_metal_warning = 13,
      gtd_wall_metal_warning_bottom = 13,
      --
      gtd_wall_vertical_light_1 = 16,
      gtd_wall_vertical_light_2 = 16,
      gtd_wall_vertical_light_3 = 16,
      --
      gtd_wall_gothic_bottom_glass = 45,
      --
      gtd_library_tall = 35,
      --
      gtd_wall_hell_engraving_1 = 20,
      gtd_wall_hell_engraving_2 = 20,
      gtd_wall_hell_engraving_3 = 20,
      --
      gtd_wall_candles = 50,
      --
      gtd_wall_lit_h_window_tall_collite_blue = 10,
      gtd_wall_lit_h_window_tall_collite_orange = 10
    },

    window_groups =
    {
      gtd_window_gothic_epic = 50,
      gtd_window_chainlinks = 30,
      gtd_window_goffik = 25,
      gtd_window_goffik_gold = 25,
    },

    street_sinks =
    {
      floor_cobble1_streets = 10,
      floor_cobble2_streets = 10,
      floor_cobble3_streets = 10,
    },

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

      ceiling_sink_SKINLOW1 = 13,
      ceiling_sink_SKINMET3 = 13,
      ceiling_sink_SKINMET4 = 13,
      ceiling_sink_SKINMET5 = 13,
      ceiling_sink_SKINMET6 = 13,
      ceiling_sink_SKINMET7 = 13,

      ceiling_sink_GOTH15 = 20,
      ceiling_sink_GOTH17 = 20,
      ceiling_sink_GOTH18 = 20,
      ceiling_sink_GOTH19 = 20,
      ceiling_sink_GOTH20 = 20,
      ceiling_sink_GOTH28 = 20,

      ceiling_sink_GOTH47 = 20,
      ceiling_sink_GOTH48 = 20,
      ceiling_sink_GOTH49 = 20,

      ceil_purple_water = 25,
      ceil_emagma = 25,
      ceil_qlava2 = 25,
      ceil_esludge = 25,
      ceil_liquid_snow = 25,
    },

    floor_sinks =
    {
      floor_sink_GOTH22 = 10,

      floor_sink_CARPET1 = 7,
      floor_sink_CARPET2 = 7,
      floor_sink_CARPET3 = 7,
      floor_sink_CARPET4 = 7,
      floor_sink_CARPET5 = 7,
      floor_sink_CARPET6 = 7,
      floor_sink_CARPET7 = 7,
      floor_sink_CARPET8 = 7,
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
      FENCEC = 3,
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
      Skybox_garrett_winterfall_EPIC = 35,
      Skybox_craneo_egypt_EPIC = 35,
      Skybox_city_bridge_EPIC = 15,
      Skybox_g99_hell_tower_EPIC = 50,
      Skybox_city_hell_bloodfalls_EPIC = 50,
      Skybox_char_EPIC = 50,
    },
  },
}

-- exclude tables for specific environment themes
OBS_RESOURCE_PACK_SKYBOX_EXCLUSIONS =
{
  desert =
  {
    "Skybox_garrett_winterfall_EPIC",
  },

  snow =
  {
    "Skybox_craneo_egypt_EPIC",
    "Skybox_craneo_space_shuttle_EPIC",
  },
}

-- intercepts for the new environment theme feature

OBS_RESOURCE_PACK_SNOW_OUTDOORS =
{
  tech =
  {
    floors =
    {
      SNOW1 = 2,
      SNOW5 = 2,
      SNOW6 = 2,
      SNOW7 = 2,
      SNOW8 = 2,
      SNOW10F = 2,
      SNOW11F = 2,
      SNOW12F = 2,
      SNOW13F = 2,
      SNOW14F = 2,
      SNOW03 = 2,
      SNOW04 = 2,
      SNOW06 = 2,
      SNOW07 = 2,
      SNOW08 = 2,
      SNOW09 = 2,
      SNOW10 = 2,
      SNOW11 = 2,
      SNOW12 = 2,
      SNOW13 = 2,
      SNOW14 = 2,
      SNOW15 = 2,
      SNWTF1 = 8,
      SNWTF2 = 8,
      SNWTF3 = 8,
      SNWTF4 = 8,
      SNWTF5 = 8,
      SNWTF6 = 8,
      SNWTF7 = 8,
      SNWTF8 = 8,
    },
  },

  urban =
  {
    floors =
    {
      SNOW1 = 2,
      SNOW5 = 2,
      SNOW6 = 2,
      SNOW7 = 2,
      SNOW8 = 2,
      SNOW10F = 2,
      SNOW11F = 2,
      SNOW12F = 2,
      SNOW13F = 2,
      SNOW14F = 2,
      SNOWBRIK = 10,
      SNOWROCK = 10,
      SNOWSTON = 10,
      SNOW03 = 2,
      SNOW04 = 2,
      SNOW06 = 2,
      SNOW07 = 2,
      SNOW08 = 2,
      SNOW09 = 2,
      SNOW10 = 2,
      SNOW11 = 2,
      SNOW12 = 2,
      SNOW13 = 2,
      SNOW14 = 2,
      SNOW15 = 2,
    },
  },

  hell =
  {
    floors =
    {
      SNOW1 = 2,
      SNOW5 = 2,
      SNOW6 = 2,
      SNOW7 = 2,
      SNOW8 = 2,
      SNOW10F = 5,
      SNOW11F = 5,
      SNOW12F = 5,
      SNOW13F = 5,
      SNOW14F = 5,
      SNOWBRIK = 10,
      SNOWROCK = 10,
      SNOWSTON = 10,
      SNOW03 = 2,
      SNOW04 = 2,
      SNOW06 = 2,
      SNOW07 = 2,
      SNOW08 = 2,
      SNOW09 = 2,
      SNOW10 = 2,
      SNOW11 = 2,
      SNOW12 = 2,
      SNOW13 = 2,
      SNOW14 = 2,
      SNOW15 = 2,
    },
  },

  floors =
  {

  },

  naturals =
  {
   SNOW03 = 5,
   SNOW06 = 5,
   SNOW07 = 5,
   SNOW08 = 5,
   SNOW09 = 5,
   SNOW10 = 5,
   SNOW11 = 5,
   SNOW12 = 5,
   SNOW13 = 3,
   SNOW14 = 3,
   SNOW15 = 5,
  },
}

-- Snowed-in building facades, per map theme type

--[[OBS_RESOURCE_PACK_SNOW_TECH_FACADES =
{
  SNOWWAL1 = 50,
  SNOWWAL2 = 50,
  SNOWWAL3 = 50,
  SNOWWAL4 = 50,
  STONE2   = 35,
  STONE10  = 30,
  BIGSTONE = 20,
  BRIKS01   = 30,
  BRIKS11   = 20,
  BRIKS32   = 60,
  BRIKS34   = 35,
  BRIKS36   = 25,
  BRIKS43   = 40,
  BRONZEG3  = 20,
  CEM10     = 30,
},

OBS_RESOURCE_PACK_SNOW_URBAN_FACADES =
{
  SNOW01 = 50,
  SNOW02 = 20,
  SNOW05 = 10,
  SNOWWAL1 = 50,
  SNOWWAL2 = 50,
  SNOWWAL3 = 30,
  SNOWWAL4 = 20,
  STONE2   = 30,
  BIGSTONE = 20,
  BRIKS01   = 30,
  BRIKS11   = 20,
  BRIKS32   = 60,
  BRIKS34   = 35,
  BRIKS36   = 25,
  BRIKS39   = 20,
  BRIKS43   = 40,
  BRONZEG3  = 20,
  CEM10     = 30,
  GOTHJ1    = 15,
  STONE10   = 20,
},

OBS_RESOURCE_PACK_SNOW_HELL_FACADES =
{
  SNOWWAL1 = 70,
  SNOWWAL2 = 70,
  SNOWWAL3 = 70,
  SNOWWAL4 = 70,
  STONE2   = 50,
  STONE3   = 40,
  BIGSTONE = 30,
  BRIKS01   = 30,
  BRIKS11   = 20,
  BRIKS32   = 60,
  BRIKS34   = 35,
  BRIKS36   = 25,
  BRIKS43   = 40,
  BRONZEG3  = 20,
  CEM10     = 30,
  GOTH09    = 20,
  GOTH11    = 30,
  GOTH12    = 10,
  GOTH15    = 20,
  GOTH26    = 30,
  GOTH27    = 20,
  GOTH28    = 25,
  GOTH31    = 35,
  GOTH36    = 20,
  GOTH37    = 20,
  KSTONE1   = 20,
  METAL2    = 15,
  ROK17     = 25,
  ROK18     = 25,
  SNOW02    = 20,
  SNOW05    = 20,
  STONE10   = 15,
}]]

OBS_RESOURCE_PACK_DESERT_OUTDOORS =
{
  tech =
  {
    floors =
    {
      SAND1 = 3,
      SAND2 = 3,
      SAND3 = 3,
      SAND4 = 3,
      SAND5 = 3,
      SAND6 = 3,
      SAND7 = 3,
      GRATE3 = 2,
      GRATE8 = 2,
      STARTANF = 2,
      MEM01 = 2,
      SLIME16 = 1,
      T_SDTCH1 = 5,
      T_SDTCH2 = 5,
      T_SDTCH3 = 5,
      T_SDTCH4 = 5,
      T_SDTCH5 = 5
    }
  },

  urban =
  {
    floors =
    {
      SAND1 = 100,
      SAND2 = 100,
      SAND3 = 100,
      SAND4 = 100,
      SAND5 = 100,
      SAND6 = 100,
      SAND7 = 100,
      EG06  = 15,
      EG05  = 10,
      EG03  = 15,
      EG02  = 10,
      EG01  = 15
    }
  },

  hell =
  {
    floors =
    {
      SAND1 = 100,
      SAND2 = 100,
      SAND3 = 100,
      SAND4 = 100,
      SAND5 = 100,
      SAND6 = 100,
      SAND7 = 100,
      EG06  = 15,
      EG05  = 10,
      EG03  = 15,
      EG02  = 10,
      EG01  = 15
    }
  },

  naturals =
  {
    ESAND1 = 45,
    ESAND2 = 45,
    DESROCK1 = 20,
    DESROCK2 = 20,
    DESROCK3 = 20,
    DESROCK4 = 25,
    DESROCK5 = 20
  }
}

--[[OBS_RESOURCE_PACK_DESERT_FACADES =
{
  BSTONE1 = 15,
  BSTONE2 = 15,
  STUCCO  = 15,
  DESBRIK1 = 80,
  DESBRIK2 = 80,
  DESBRIK3 = 80,
  DESBRIK4 = 80,
  DESBRIK5 = 80,
  DESBRIK6 = 80,
  DESBRIK7 = 80,
  DESMARB1 = 50,
  DESMARB2 = 50,
  EGYPT04  = 25,
  EGYPT05  = 25,
  EGYPT06  = 25,
},

OBS_RESOURCE_PACK_DESERT_URBAN_FACADES =
{
  BSTONE1 = 20,
  BSTONE2 = 20,
  STUCCO  = 20,
  DESBRIK1 = 60,
  DESBRIK2 = 60,
  DESBRIK3 = 60,
  DESBRIK4 = 60,
  DESBRIK5 = 60,
  DESBRIK6 = 60,
  DESBRIK7 = 60,
  DESMARB1 = 35,
  DESMARB2 = 35,
  EGYPT04  = 15,
  EGYPT05  = 15,
  EGYPT06  = 15,
},

OBS_RESOURCE_PACK_DESERT_HELL_FACADES =
{
  BSTONE1 = 25,
  BSTONE2 = 25,
  STUCCO  = 25,
  BRIKS12 = 10,
  BRIKS14 = 10,
  BRIKS15 = 10,
  DESBRIK1 = 80,
  DESBRIK2 = 80,
  DESBRIK3 = 80,
  DESBRIK4 = 80,
  DESBRIK5 = 80,
  DESBRIK6 = 80,
  DESBRIK7 = 80,
  DESMARB1 = 55,
  DESMARB2 = 55,
  EGYPT04  = 35,
  EGYPT05  = 35,
  EGYPT06  = 35,
}]]
