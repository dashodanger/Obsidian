--------------------------------------------------------------------
--  DOOM 1 / ULTIMATE DOOM
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2011,2019, 2021-2022 Reisal
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------
--
--  NOTE:
--    Doom 1 and Ultimate Doom are treated here somewhat like a
--    mod of Doom 2.  Hence the MONSTERS table here removes all
--    the Doom 2 monsters and weapons (etc...)
--
--    This is not ideal, but seems better than the previous way
--    of mixing the two games in one file (DOOM1 vs DOOM2 tables)
--    which was probably very confusing to most people.
--

ULTDOOM = { }

ULTDOOM.VANILLA_MATS = 
{
  replace_all = true,
    -- There are always added by Obsidian regardless of Engine selected
    "LIFTFLAT",
    "O_BOLT",
    "O_BLACK",
    "O_PILL",
    "O_RELIEF",
    "O_CARVE",
    "O_NEON",
    "O_INVIST",
    --SetLine special mats
    "13131C",
    "4548BA",
    "041C08",
    "1F4525",
    "281F11",
	"473618",
    -- Vanilla Flats
    "BLOOD1",
    "BLOOD2",
    "BLOOD3",
    "CEIL1_1",
    "CEIL1_2",
    "CEIL1_3",
    "CEIL3_1",
    "CEIL3_2",
    "CEIL3_3",
    "CEIL3_4",
    "CEIL3_5",
    "CEIL3_6",
    "CEIL4_1",
    "CEIL4_2",
    "CEIL4_3",
    "CEIL5_1",
    "CEIL5_2",
    "COMP01",
    "CONS1_1",
    "CONS1_5",
    "CONS1_7",
    "CRATOP1",
    "CRATOP2",
    "DEM1_1",
    "DEM1_2",
    "DEM1_3",
    "DEM1_4",
    "DEM1_5",
    "DEM1_6",
    "FLAT1",
    "FLAT10",
    "FLAT14",
    "FLAT17",
    "FLAT18",
    "FLAT19",
    "FLAT1_1",
    "FLAT1_2",
    "FLAT1_3",
    "FLAT2",
    "FLAT20",
    "FLAT22",
    "FLAT23",
    "FLAT3",
    "FLAT4",
    "FLAT5",
    "FLAT5_1",
    "FLAT5_2",
    "FLAT5_3",
    "FLAT5_4",
    "FLAT5_5",
    "FLAT5_6",
    "FLAT5_7",
    "FLAT5_8",
    "FLAT8",
    "FLAT9",
    "FLOOR0_1",
    "FLOOR0_2",
    "FLOOR0_3",
    "FLOOR0_5",
    "FLOOR0_6",
    "FLOOR0_7",
    "FLOOR1_1",
    "FLOOR1_6",
    "FLOOR1_7",
    "FLOOR3_3",
    "FLOOR4_1",
    "FLOOR4_5",
    "FLOOR4_6",
    "FLOOR4_8",
    "FLOOR5_1",
    "FLOOR5_2",
    "FLOOR5_3",
    "FLOOR5_4",
    "FLOOR6_1",
    "FLOOR6_2",
    "FLOOR7_1",
    "FLOOR7_2",
    "FWATER1",
    "FWATER2",
    "FWATER3",
    "FWATER4",
    "F_SKY1",
    "GATE1",
    "GATE2",
    "GATE3",
    "GATE4",
    "LAVA1",
    "LAVA2",
    "LAVA3",
    "LAVA4",
    "MFLR8_1",
    "MFLR8_2",
    "MFLR8_3",
    "MFLR8_4",
    "NUKAGE1",
    "NUKAGE2",
    "NUKAGE3",
    "SFLR6_1",
    "SFLR6_4",
    "SFLR7_1",
    "SFLR7_4",
    "STEP1",
    "STEP2",
    "TLITE6_1",
    "TLITE6_4",
    "TLITE6_5",
    "TLITE6_6",
    -- Vanilla textures
    "AASTINKY",
    "ASHWALL",
    "BIGDOOR1",
    "BIGDOOR2",
    "BIGDOOR3",
    "BIGDOOR4",
    "BIGDOOR5",
    "BIGDOOR6",
    "BIGDOOR7",
    "BLODGR1",
    "BLODGR2",
    "BLODGR3",
    "BLODGR4",
    "BLODRIP1",
    "BLODRIP2",
    "BLODRIP3",
    "BLODRIP4",
    "BRNPOIS",
    "BRNPOIS2",
    "BRNSMAL1",
    "BRNSMAL2",
    "BRNSMALC",
    "BRNSMALL",
    "BRNSMALR",
    "BROVINE",
    "BROVINE2",
    "BROWN1",
    "BROWN144",
    "BROWN96",
    "BROWNGRN",
    "BROWNHUG",
    "BROWNPIP",
    "BROWNWEL",
    "CEMENT1",
    "CEMENT2",
    "CEMENT3",
    "CEMENT4",
    "CEMENT5",
    "CEMENT6",
    "CEMPOIS",
    "COMP2",
    "COMPBLUE",
    "COMPOHSO",
    "COMPSPAN",
    "COMPSTA1",
    "COMPSTA2",
    "COMPTALL",
    "COMPTILE",
    "COMPUTE1",
    "COMPUTE2",
    "COMPUTE3",
    "COMPWERD",
    "CRATE1",
    "CRATE2",
    "CRATELIT",
    "CRATINY",
    "CRATWIDE",
    "DOOR1",
    "DOOR3",
    "DOORBLU",
    "DOORBLU2",
    "DOORHI",
    "DOORRED",
    "DOORRED2",
    "DOORSTOP",
    "DOORTRAK",
    "DOORYEL",
    "DOORYEL2",
    "EXITDOOR",
    "EXITSIGN",
    "EXITSTON",
    "FIREBLU1",
    "FIREBLU2",
    "FIRELAV2",
    "FIRELAV3",
    "FIRELAVA",
    "FIREMAG1",
    "FIREMAG2",
    "FIREMAG3",
    "FIREWALA",
    "FIREWALB",
    "FIREWALL",
    "GRAY1",
    "GRAY2",
    "GRAY4",
    "GRAY5",
    "GRAY7",
    "GRAYBIG",
    "GRAYDANG",
    "GRAYPOIS",
    "GRAYTALL",
    "GRAYVINE",
    "GSTFONT1",
    "GSTFONT2",
    "GSTFONT3",
    "GSTGARG",
    "GSTLION",
    "GSTONE1",
    "GSTONE2",
    "GSTSATYR",
    "GSTVINE1",
    "GSTVINE2",
    "ICKWALL1",
    "ICKWALL2",
    "ICKWALL3",
    "ICKWALL4",
    "ICKWALL5",
    "ICKWALL7",
    "LITE2",
    "LITE3",
    "LITE4",
    "LITE5",
    "LITE96",
    "LITEBLU1",
    "LITEBLU2",
    "LITEBLU3",
    "LITEBLU4",
    "LITEMET",
    "LITERED",
    "LITESTON",
    "MARBFAC2",
    "MARBFAC3",
    "MARBFACE",
    "MARBLE1",
    "MARBLE2",
    "MARBLE3",
    "MARBLOD1",
    "METAL",
    "METAL1",
    "MIDBRN1",
    "MIDGRATE",
    "MIDVINE1",
    "MIDVINE2",
    "NUKE24",
    "NUKEDGE1",
    "NUKEPOIS",
    "NUKESLAD",
    "PIPE1",
    "PIPE2",
    "PIPE4",
    "PIPE6",
    "PLANET1",
    "PLAT1",
    "REDWALL",
    "REDWALL1",
    "ROCKRED1",
    "ROCKRED2",
    "ROCKRED3",
    "SHAWN1",
    "SHAWN2",
    "SHAWN3",
    "SKIN2",
    "SKINBORD",
    "SKINCUT",
    "SKINEDGE",
    "SKINFACE",
    "SKINLOW",
    "SKINMET1",
    "SKINMET2",
    "SKINSCAB",
    "SKINSYMB",
    "SKINTEK1",
    "SKINTEK2",
    "SKSNAKE1",
    "SKSNAKE2",
    "SKSPINE1",
    "SKSPINE2",
    "SKY1",
    "SKY2",
    "SKY3",
    "SKY4",
    "SLADPOIS",
    "SLADRIP1",
    "SLADRIP2",
    "SLADRIP3",
    "SLADSKUL",
    "SLADWALL",
    "SP_DUDE1",
    "SP_DUDE2",
    "SP_DUDE3",
    "SP_DUDE4",
    "SP_DUDE5",
    "SP_FACE1",
    "SP_HOT1",
    "SP_ROCK1",
    "SP_ROCK2",
    "STARBR2",
    "STARG1",
    "STARG2",
    "STARG3",
    "STARGR1",
    "STARGR2",
    "STARTAN2",
    "STARTAN3",
    "STEP1",
    "STEP2",
    "STEP3",
    "STEP4",
    "STEP5",
    "STEP6",
    "STEPLAD1",
    "STEPTOP",
    "STONE",
    "STONE2",
    "STONE3",
    "STONGARG",
    "STONPOIS",
    "SUPPORT2",
    "SUPPORT3",
    "SW1BLUE",
    "SW1BRCOM",
    "SW1BRN1",
    "SW1BRN2",
    "SW1BRNGN",
    "SW1BROWN",
    "SW1CMT",
    "SW1COMM",
    "SW1COMP",
    "SW1DIRT",
    "SW1EXIT",
    "SW1GARG",
    "SW1GRAY",
    "SW1GRAY1",
    "SW1GSTON",
    "SW1HOT",
    "SW1LION",
    "SW1METAL",
    "SW1PIPE",
    "SW1SATYR",
    "SW1SKIN",
    "SW1SLAD",
    "SW1STARG",
    "SW1STON1",
    "SW1STON2",
    "SW1STONE",
    "SW1STRTN",
    "SW1VINE",
    "SW1WOOD",
    "SW2BLUE",
    "SW2BRCOM",
    "SW2BRN1",
    "SW2BRN2",
    "SW2BRNGN",
    "SW2BROWN",
    "SW2CMT",
    "SW2COMM",
    "SW2COMP",
    "SW2DIRT",
    "SW2EXIT",
    "SW2GARG",
    "SW2GRAY",
    "SW2GRAY1",
    "SW2GSTON",
    "SW2HOT",
    "SW2LION",
    "SW2METAL",
    "SW2PIPE",
    "SW2SATYR",
    "SW2SKIN",
    "SW2SLAD",
    "SW2STARG",
    "SW2STON1",
    "SW2STON2",
    "SW2STONE",
    "SW2STRTN",
    "SW2VINE",
    "SW2WOOD",
    "TEKWALL1",
    "TEKWALL2",
    "TEKWALL3",
    "TEKWALL4",
    "TEKWALL5",
    "WOOD1",
    "WOOD3",
    "WOOD4",
    "WOOD5",
    "WOODGARG",
    "WOODSKUL"
}

ULTDOOM.PARAMETERS =
{
  skip_monsters = { 15,25,35 },

  episodic_monsters = true,

  doom2_monsters = false,
  doom2_weapons  = false,
  doom2_skies    = false,
  episode_length = 9
}


ULTDOOM.MATERIALS =
{
  -- These materials are unique to DOOM I / Ultimate DOOM...


  -- walls --

  ASHWALL  = { t="ASHWALL",  f="FLOOR6_2" },
  BROVINE  = { t="BROVINE",  f="FLOOR0_1" },
  BRNPOIS2 = { t="BRNPOIS2", f="FLOOR7_1" },
  BROWNWEL = { t="BROWNWEL", f="FLOOR7_1" },

  COMP2    = { t="COMP2",    f="CEIL5_1" },
  COMPOHSO = { t="COMPOHSO", f="FLOOR7_1" },
  COMPTILE = { t="COMPTILE", f="CEIL5_1" },
  COMPUTE1 = { t="COMPUTE1", f="FLAT19" },
  COMPUTE2 = { t="COMPUTE2", f="CEIL5_1" },
  COMPUTE3 = { t="COMPUTE3", f="CEIL5_1" },

  DOORHI   = { t="DOORHI",   f="FLAT19" },
  GRAYDANG = { t="GRAYDANG", f="FLAT19" },
  GSTVINE1 = { t="GSTVINE1", f="FLOOR7_2" },
  ICKDOOR1 = { t="ICKDOOR1", f="FLAT19" },
  ICKWALL6 = { t="ICKWALL6", f="FLAT18" },

  LITE2    = { t="LITE2",    f="FLOOR0_1" },
  LITE4    = { t="LITE4",    f="FLAT19" },
  LITE96   = { t="LITE96",   f="FLOOR7_1" },
  LITEBLU2 = { t="LITEBLU2", f="FLAT23" },
  LITEBLU3 = { t="LITEBLU3", f="FLAT23" },
  LITEMET  = { t="LITEMET",  f="FLOOR4_8" },
  LITERED  = { t="LITERED",  f="FLOOR1_6" },
  LITESTON = { t="LITESTON", f="MFLR8_1" },

  NUKESLAD = { t="NUKESLAD", f="FLOOR7_1" },
  PLANET1  = { t="PLANET1",  f="FLAT23" },
  REDWALL1 = { t="REDWALL1", f="FLOOR1_6" },
  SKINBORD = { t="SKINBORD", f="FLAT5_5" },
  SKINTEK1 = { t="SKINTEK1", f="FLAT5_5" },
  SKINTEK2 = { t="SKINTEK2", f="FLAT5_5" },
  SKULWAL3 = { t="SKULWAL3", f="FLAT5_6" },
  SKULWALL = { t="SKULWALL", f="FLAT5_6" },
  SLADRIP1 = { t="SLADRIP1", f="FLOOR7_1" },

  SP_DUDE6 = { t="SP_DUDE6", f="DEM1_5" },
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3" },
  SP_ROCK2 = { t="SP_ROCK2", f="MFLR8_3" },
  STARTAN1 = { t="STARTAN1", f="FLOOR4_1" },
  STONGARG = { t="STONGARG", f="MFLR8_1" },
  STONPOIS = { t="STONPOIS", f="FLAT5_4" },
  TEKWALL2 = { t="TEKWALL2", f="CEIL5_1" },
  TEKWALL3 = { t="TEKWALL3", f="CEIL5_1" },
  TEKWALL5 = { t="TEKWALL5", f="CEIL5_1" },
  WOODSKUL = { t="WOODSKUL", f="FLAT5_2" },


  -- switches --

  SW1BRN1  = { t="SW1BRN1",  f="FLOOR0_1" },
  SW1STARG = { t="SW1STARG", f="FLAT23" },
  SW1STONE = { t="SW1STONE", f="FLAT1" },
  SW1STON2 = { t="SW1STON2", f="MFLR8_1" },


  -- floors --

  FLAT5_6  = { f="FLAT5_6", t="SKULWALL" },
  FLAT5_7  = { f="FLAT5_7", t="ASHWALL" },
  FLAT5_8  = { f="FLAT5_8", t="ASHWALL" },
  FLOOR6_2 = { f="FLOOR6_2", t="ASHWALL" },
  MFLR8_4  = { f="MFLR8_4",  t="ASHWALL" },


  -- flats with different side textures --

  CONS1_1  = { f="CONS1_1", t="COMPWERD" },
  CONS1_5  = { f="CONS1_5", t="COMPWERD" },
  CONS1_7  = { f="CONS1_7", t="COMPWERD" },

  FLAT8    = { f="FLAT8",   t="BROWN1" },
  FLAT10   = { f="FLAT10",  t="BROWNHUG" },
  FLAT1_1  = { f="FLAT1_1", t="BROWN1" },
  FLAT1_2  = { f="FLAT1_2", t="BROWN1" },
  FLAT1_3  = { f="FLAT1_3", t="BROWN1" },
  FLAT5_5  = { f="FLAT5_5", t="BROWN1" },


  -- rails --

  BRNBIGC  = { t="BRNBIGC",  rail_h=128 },

  MIDVINE1 = { t="MIDVINE1", rail_h=128 },
  MIDVINE2 = { t="MIDVINE2", rail_h=128 },

  -- this is the MIDBARS3 texture from FreeDoom
  MIDBARS3 = { t="SP_DUDE3", rail_h=72 },


  -- liquid stuff (using new patches)
  BFALL1   = { t="BLODGR1",  f="BLOOD1", sane=1 },
  BLOOD1   = { t="BLODGR1",  f="BLOOD1", sane=1 },

  SFALL1   = { t="SLADRIP1", f="NUKAGE1", sane=1 },
  NUKAGE1  = { t="SLADRIP1", f="NUKAGE1", sane=1 },


  --------------------------------------------------------------------
  --
  -- Compatibility section
  --
  -- These allow prefabs containing DOOM 2 specific flats or textures
  -- to at least work in DOOM / Ultimate DOOM (a bit mucked up though).
  --
  -- Big thanks to Reisal for doing the grunt work.
  --

  -- flats
  GRASS1   = { f="DEM1_5",   t="MARBLE1" },
  GRASS2   = { f="DEM1_5",   t="MARBLE1" },
  GRNLITE1 = { f="TLITE6_6", t="METAL" },
  GRNROCK  = { f="MFLR8_3",  t="SP_ROCK1" },

  RROCK01  = { f="FLOOR6_1", t="REDWALL" },
  RROCK02  = { f="LAVA1",    t="FIREMAG1" },
  RROCK03  = { f="FLOOR6_2", t="ASHWALL" },
  RROCK04  = { f="FLOOR6_2", t="ASHWALL" },
  RROCK05  = { f="FLOOR6_1", t="REDWALL" },
  RROCK06  = { f="FLOOR6_1", t="REDWALL" },
  RROCK07  = { f="FLOOR6_1", t="REDWALL" },
  RROCK08  = { f="FLOOR6_1", t="REDWALL" },
  RROCK09  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK10  = { f="FLAT5",    t="BROWNHUG" },
  RROCK11  = { f="FLAT5",    t="BROWNHUG" },
  RROCK12  = { f="FLAT5",    t="BROWNHUG" },
  RROCK13  = { f="MFLR8_3",  t="SP_ROCK1" },
  RROCK14  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK15  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK16  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK17  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK18  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK19  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK20  = { f="FLOOR7_2", t="MARBLE1" },

  SLIME01  = { f="NUKAGE1",  t="SLADRIP1" },
  SLIME02  = { f="NUKAGE1",  t="SLADRIP1" },
  SLIME03  = { f="NUKAGE1",  t="SLADRIP1" },
  SLIME04  = { f="NUKAGE1",  t="SLADRIP1" },
  SLIME05  = { f="BLOOD1",   t="BLODGR1" },
  SLIME06  = { f="BLOOD1",   t="BLODGR1" },
  SLIME07  = { f="BLOOD1",   t="BLODGR1" },
  SLIME08  = { f="BLOOD1",   t="BLODGR1" },
  SLIME09  = { f="FLOOR6_1", t="REDWALL" },
  SLIME10  = { f="FLOOR6_1", t="REDWALL" },
  SLIME11  = { f="FLOOR6_1", t="REDWALL" },
  SLIME12  = { f="FLOOR6_1", t="REDWALL" },
  SLIME13  = { f="FLOOR7_2", t="MARBLE1" },
  SLIME14  = { f="FLOOR4_8", t="METAL1" },
  SLIME15  = { f="FLOOR4_8", t="METAL1" },
  SLIME16  = { f="FLAT1_1",  t="BROWN1" },

  -- textures
  ASHWALL2 = { t="ASHWALL",  f="FLOOR6_2" },
  ASHWALL3 = { t="BROWNHUG", f="FLOOR7_1" },
  ASHWALL4 = { t="BROWNHUG", f="FLOOR7_1" },
  ASHWALL6 = { t="PIPE2",    f="FLOOR4_5" },
  ASHWALL7 = { t="PIPE4",    f="FLOOR4_5" },
  BIGBRIK1 = { t="BROWN96",  f="FLOOR7_1" },
  BIGBRIK2 = { t="STONE2",   f="MFLR8_1" },
  BIGBRIK3 = { t="LITE3",    f="FLAT19" },
  BLAKWAL1 = { t="COMPSPAN", f="CEIL5_1" },
  BLAKWAL2 = { t="COMPSPAN", f="CEIL5_1" },

  BRICK1   = { t="BROWN1",   f="FLOOR0_1" },
  BRICK10  = { t="BROWNGRN", f="FLOOR7_1" },
  BRICK11  = { t="REDWALL",  f="FLAT5_3" },
  BRICK12  = { t="BROWN1",   f="FLOOR0_1" },
  BRICK2   = { t="BROWN1",   f="FLOOR0_1" },
  BRICK3   = { t="BROWN1",   f="FLOOR0_1" },
  BRICK4   = { t="BROVINE",  f="FLOOR0_1" },
  BRICK5   = { t="BROVINE2", f="FLOOR7_1" },
  BRICK6   = { t="BROWN1",   f="FLOOR0_1" },
  BRICK7   = { t="BROWN96",  f="FLOOR7_1" },
  BRICK8   = { t="BROWN96",  f="FLOOR7_1" },
  BRICK9   = { t="BROWN144", f="FLOOR7_1" },
  BRICKLIT = { t="LITEMET",  f="CEIL5_1" },
  BRONZE1  = { t="BROWN96",  f="FLOOR7_1" },
  BRONZE2  = { t="BROWN96",  f="FLOOR7_1" },
  BRONZE3  = { t="BROWN96",  f="FLOOR7_1" },
  BRONZE4  = { t="LITE96",   f="FLOOR7_1" },
  BRWINDOW = { t="BROWN1",   f="FLOOR0_1" },
  BSTONE1  = { t="SLADWALL", f="FLOOR7_1" },
  BSTONE2  = { t="SLADWALL", f="FLOOR7_1" },
  BSTONE3  = { t="LITE3",    f="FLAT19" },

  CEMENT7  = { t="GRAY1",    f="FLAT18" },
  CEMENT8  = { t="GRAY5",    f="FLAT18" },
  CEMENT9  = { t="GRAYVINE", f="FLAT1" },
  CRACKLE2 = { t="ROCKRED1", f="FLOOR6_1" },
  CRACKLE4 = { t="ROCKRED1", f="FLOOR6_1" },
  CRATE3   = { t="CRATELIT", f="CRATOP1" },
  DBRAIN1  = { t="FIREBLU1", f="FLOOR6_1" },
  DBRAIN2  = { t="FIREBLU1", f="FLOOR6_1" },
  DBRAIN3  = { t="FIREBLU1", f="FLOOR6_1" },
  DBRAIN4  = { t="FIREBLU1", f="FLOOR6_1" },
  MARBFAC4 = { t="SP_DUDE6", f="DEM1_5" },
  MARBGRAY = { t="GSTONE1",  f="FLOOR7_2" },

  METAL2   = { t="METAL1",   f="FLOOR4_8" },
  METAL3   = { t="METAL1",   f="FLOOR4_8" },
  METAL4   = { t="METAL1",   f="FLOOR4_8" },
  METAL5   = { t="METAL1",   f="FLOOR4_8" },
  METAL6   = { t="METAL1",   f="FLOOR4_8" },
  METAL7   = { t="LITE3",    f="FLAT19" },
  MODWALL1 = { t="ICKWALL1", f="FLAT19" },
  MODWALL2 = { t="ICKWALL1", f="FLAT19" },
  MODWALL3 = { t="ICKWALL3", f="FLAT19" },
  MODWALL4 = { t="ICKWALL3", f="FLAT19" },

  PANBLACK = { t="LITE5",    f="FLAT19" },
  PANBLUE  = { t="LITEBLU4", f="FLAT1" },
  PANBOOK  = { t="WOODSKUL", f="FLAT5_2" },
  PANBORD1 = { t="WOOD1",    f="FLAT5_2" },
  PANBORD2 = { t="WOOD1",    f="FLAT5_2" },
  PANCASE1 = { t="WOOD1",    f="FLAT5_2" },
  PANCASE2 = { t="WOOD1",    f="FLAT5_2" },
  PANEL1   = { t="SKINMET1", f="CEIL5_2" },
  PANEL2   = { t="SKINMET1", f="CEIL5_2" },
  PANEL3   = { t="SKINMET1", f="CEIL5_2" },
  PANEL4   = { t="WOOD1",    f="FLAT5_2" },
  PANEL5   = { t="WOODGARG", f="FLAT5_2" },
  PANEL6   = { t="WOOD3",    f="FLAT5_1" },
  PANEL7   = { t="WOOD3",    f="FLAT5_1" },
  PANEL8   = { t="WOOD3",    f="FLAT5_1" },
  PANEL9   = { t="WOOD3",    f="FLAT5_1" },
  PANRED   = { t="LITERED",  f="FLOOR1_6" },
  PIPES    = { t="BROWNPIP", f="FLOOR0_1" },
  PIPEWAL1 = { t="PIPE2",    f="FLOOR4_5" },
  PIPEWAL2 = { t="PIPE2",    f="FLOOR4_5" },
  ROCK1    = { t="STONE2",   f="MFLR8_1" },
  ROCK2    = { t="STONE3",   f="MFLR8_1" },
  ROCK3    = { t="STONE2",   f="MFLR8_1" },
  ROCK4    = { t="SP_ROCK1", f="MFLR8_3" },
  ROCK5    = { t="SP_ROCK1", f="MFLR8_3" },

  SILVER1  = { t="SHAWN2",   f="FLAT23" },
  SILVER2  = { t="COMPUTE1", f="FLAT23" },
  SILVER3  = { t="PLANET1",  f="FLAT23" },
  SPACEW2  = { t="TEKWALL4", f="CEIL5_1" },
  SPACEW3  = { t="COMPUTE1", f="FLAT1" },
  SPACEW4  = { t="TEKWALL1", f="CEIL5_1" },
  SPCDOOR1 = { t="BIGDOOR4", f="FLOOR3_3" },
  SPCDOOR2 = { t="BIGDOOR2", f="FLAT1" },
  SPCDOOR3 = { t="BIGDOOR2", f="FLAT1" },
  SPCDOOR4 = { t="BIGDOOR4", f="FLOOR3_3" },

  SK_LEFT  = { t="SKULWAL3", f="FLAT5_6" },
  SK_RIGHT = { t="SKULWAL3", f="FLAT5_6" },
  SLOPPY1  = { t="SKULWAL3", f="FLAT5_6" },
  SLOPPY2  = { t="SKULWAL3", f="FLAT5_6" },
  SP_DUDE7 = { t="SKULWAL3", f="FLAT5_6" },
  SP_DUDE8 = { t="SKULWALL", f="FLAT5_6" },
  SP_FACE2 = { t="SKULWAL3", f="FLAT5_6" },

  STONE4   = { t="STONE",    f="FLAT5_4" },
  STONE5   = { t="STONE",    f="FLAT5_4" },
  STONE6   = { t="BROWNHUG", f="FLOOR7_1" },
  STONE7   = { t="BROWNHUG", f="FLOOR7_1" },
  STUCCO   = { t="SKINTEK1", f="FLAT5_5" },
  STUCCO1  = { t="SKINTEK1", f="FLAT5_5" },
  STUCCO2  = { t="SKINTEK2", f="FLAT5_5" },
  STUCCO3  = { t="SKINTEK2", f="FLAT5_5" },

  SW1BRIK  = { t="SW1STONE", f="FLAT1" },
  SW1MARB  = { t="SW1GSTON", f="FLOOR7_2" },
  SW1MET2  = { t="SW1GARG",  f="CEIL5_2" },
  SW1MOD1  = { t="SW1GRAY1", f="FLAT19" },
  SW1PANEL = { t="SW1WOOD",  f="FLAT5_2" },
  SW1ROCK  = { t="SW1SATYR", f="CEIL5_2" },
  SW1SKULL = { t="SW1SKIN",  f="CRATOP2" },
  SW1STON6 = { t="SW1DIRT",  f="FLOOR7_1" },
  SW1TEK   = { t="SW1STRTN", f="FLOOR4_1" },
  SW1WDMET = { t="SW1LION",  f="CEIL5_2" },
  SW1ZIM   = { t="SW1SLAD",  f="FLOOR7_1" },

  TANROCK2 = { t="BROWNHUG", f="FLOOR7_1" },
  TANROCK3 = { t="BROWNHUG", f="FLOOR7_1" },
  TANROCK4 = { t="BROWNHUG", f="FLOOR7_1" },
  TANROCK5 = { t="BROWNHUG", f="FLOOR7_1" },
  TANROCK7 = { t="BROWN144", f="FLOOR7_1" },
  TANROCK8 = { t="BROVINE",  f="FLOOR0_1" },
  TEKBRON1 = { t="TEKWALL4", f="CEIL5_1" },
  TEKBRON2 = { t="TEKWALL4", f="CEIL5_1" },
  TEKGREN1 = { t="STARG1",   f="FLAT23" },
  TEKGREN2 = { t="STARG1",   f="FLAT23" },
  TEKGREN3 = { t="STARG1",   f="FLAT23" },
  TEKGREN4 = { t="STARG2",   f="FLAT23" },
  TEKGREN5 = { t="LITE3",    f="FLAT19" },
  TEKLITE  = { t="LITE3",    f="FLAT19" },
  TEKLITE2 = { t="LITE4",    f="FLAT19" },
  TEKWALL6 = { t="TEKWALL4", f="CEIL5_1" },

  WOOD6    = { t="WOOD5",    f="CEIL5_2" },
  WOOD7    = { t="WOOD3",    f="FLAT5_1" },
  WOOD8    = { t="WOOD3",    f="FLAT5_1" },
  WOOD9    = { t="WOOD1",    f="FLAT5_2" },
  WOOD10   = { t="WOOD1",    f="FLAT5_2" },
  WOOD12   = { t="WOOD1",    f="FLAT5_2" },
  WOODMET1 = { t="WOOD5",    f="CEIL5_2" },
  WOODMET2 = { t="WOOD5",    f="CEIL5_2" },
  WOODMET3 = { t="WOOD5",    f="CEIL5_2" },
  WOODMET4 = { t="WOOD5",    f="CEIL5_2" },
  WOODVERT = { t="WOOD3",    f="FLAT5_1" },

  ZDOORB1  = { t="SHAWN2",   f="FLAT23" },
  ZDOORF1  = { t="SHAWN2",   f="FLAT23" },
  ZELDOOR  = { t="BIGDOOR2", f="FLAT1" },

  ZIMMER1  = { t="SP_ROCK1", f="MFLR8_3" },
  ZIMMER2  = { t="SP_ROCK1", f="MFLR8_3" },
  ZIMMER3  = { t="BROWNHUG", f="FLOOR7_1" },
  ZIMMER4  = { t="BROWNHUG", f="FLOOR7_1" },
  ZIMMER5  = { t="ASHWALL",  f="FLOOR6_2" },
  ZIMMER7  = { t="ASHWALL",  f="FLOOR6_2" },
  ZIMMER8  = { t="SP_ROCK1", f="MFLR8_3" },

  ZZZFACE4 = { t="MARBFACE", f="DEM1_5" },

  -- rails
  MIDBARS1 = { t="MIDGRATE", rail_h=128 },
  MIDBRONZ = { t="MIDGRATE", rail_h=128 },
  MIDSPACE = { t="MIDGRATE", rail_h=128 },

  -- extra remapping due to some changes to Doom 2 materials
  FLOOR4_5 = { t="BROWN1", f="FLOOR4_5" },
  FLOOR5_4 = { t="BROWN1", f="FLOOR5_4" },
  FLAT18 = { t="GRAY1", f="FLAT18" },
  FLAT18 = { t="GRAY7", f="FLAT20" },

  -- hex colors used in some Set Line specials - these are NOT actually usable materials
  -- and are just here to suppress warnings regarding them
  ["13131C"] = { t="13131C", f="13131C" },
  ["4548BA"] = { t="4548BA", f="4548BA" },
  ["041C08"] = { t="041C08", f="041C08" },
  ["1F4525"] = { t="1F4525", f="1F4525" },
  ["281F11"] = { t="281F11", f="281F11" },
  ["473618"] = { t="473618", f="473618" },
}

ULTDOOM.MUSIC_LUMPS = 
{
  "D_E1M1",
  "D_E1M2",
  "D_E1M3",
  "D_E1M4",
  "D_E1M5",
  "D_E1M6",
  "D_E1M7",
  "D_E1M8",
  "D_E1M9",
  "D_E2M1",
  "D_E2M2",
  "D_E2M3",
  "D_E2M4",
  "D_E2M5",
  "D_E2M6",
  "D_E2M7",
  "D_E2M8",
  "D_E2M9",
  "D_E3M1",
  "D_E3M2",
  "D_E3M3",
  "D_E3M4",
  "D_E3M5",
  "D_E3M6",
  "D_E3M7",
  "D_E3M8",
  "D_E3M9",
}

ULTDOOM.PREFAB_FIELDS =
{
  -- Doom 2 -> Doom 1 converstions
  thing_73 = 59,
  thing_74 = 60,
  thing_75 = 61,
  thing_76 = 62,
  thing_77 = 63,
  thing_78 = 60,
  thing_79 = 24,
  thing_80 = 24,
  thing_81 = 24,
  thing_85 = 2028,
  thing_86 = 2028,
}

--------------------------------------------------------------------

ULTDOOM.WEAPONS =
{
  super = REMOVE_ME
}


ULTDOOM.NICE_ITEMS =
{
  mega = REMOVE_ME
}


ULTDOOM.MONSTERS =
{
  gunner   = REMOVE_ME,
  revenant = REMOVE_ME,
  knight   = REMOVE_ME,
  mancubus = REMOVE_ME,
  arach    = REMOVE_ME,
  vile     = REMOVE_ME,
  pain     = REMOVE_ME,
  ss_nazi  = REMOVE_ME
}


ULTDOOM.ENTITIES =
{
  -- compatible replacements for things lacking in DOOM 1 / Ultimate DOOM

  mercury_lamp  = { id=2028, r=16, h=48 },
  mercury_small = { id=2028, r=16, h=48 },

  gutted_victim1 = { id=59, r=20, h=84, ceil=true, pass=true },
  gutted_victim2 = { id=61, r=20, h=52, ceil=true, pass=true },

  gutted_torso1  = { id=59, r=20, h=84, ceil=true, pass=true },
  gutted_torso2  = { id=61, r=20, h=52, ceil=true, pass=true },
  gutted_torso3  = { id=63, r=20, h=68, ceil=true, pass=true },
  gutted_torso4  = { id=63, r=20, h=68, ceil=true, pass=true },

  pool_blood_1  = { id=24, r=20, h=16, pass=true },
  pool_blood_2  = { id=24, r=20, h=16, pass=true },
  pool_brains   = { id=10, r=20, h=16, pass=true },
}

--------------------------------------------------------------------

ULTDOOM.THEMES =
{
  DEFAULTS =
  {
    keys =
    {
      k_red    = 50,
      k_blue   = 50,
      k_yellow = 50,
    },

    window_groups =
    {
      square = 90,
      tall   = 30,
      grate  = 10,
    },

    narrow_halls =
    {
      vent = 50,
    },

    wide_halls =
    {
      deuce = 50,
      metro = 20,
    },

    barrels =
    {
      barrel = 50,
    },

    passable_decor =
    {
      gibs = 40,

      gibbed_player = 10,
      dead_player = 10,
      dead_zombie = 3,
      dead_shooter = 3,
      dead_imp = 3,
      dead_demon = 1,
      dead_caco  = 1,
    },

    cave_torches =
    {
      red_torch   = 60,
      green_torch = 40,
      blue_torch  = 20,
    },

    cliff_trees =
    {
      burnt_tree = 80,
      brown_stub = 40,
        big_tree = 20,
    },

    park_decor =
    {
      burnt_tree = 80,
      brown_stub = 40,
        big_tree = 20,
    },

    fences =
    {
      BROWN144 = 60,
      WOOD5    = 40,
      STONE    = 30,
      SLADWALL = 20,

      BROVINE  = 15,
      GRAYVINE = 15,
      GSTVINE2 = 15,
      SP_ROCK1 =  5,
    },

    cage_mats =
    {
      METAL1   = 60,
      BROWN144 = 60,
      ICKWALL3 = 60,

      STONE    = 20,
      SLADWALL = 20,
      WOOD1    = 20,
    },

    --  8 = oscillates
    -- 12 = flashes @ 1 hz
    -- 13 = flashes @ 2 hz
    -- 17 = flickering
    cage_lights = { 0, 8, 12, 13, 17 },

    wall_groups =
    {
      PLAIN = 100,
    },

    ceil_light_prob = 60,

    streets_friendly = false,

    slump_config = 
    [[
      ;
      ; This is a copy of the main SLIGE.CFG file, with a new "BLU"
      ; theme added, to show how to add themes.
      ;
      
      [THEMES]
      
      Theme WOD
      Theme MIL
      Theme MARB
      ; Added the theme to the list here...
      Theme BLU
      Theme RED secret
      
      ;
      ; Scroll down quite a bit to see the other BLU-related additions
      ;
      
      ; Main WOD walls.
      Texture WOOD9 wall core WOD subtle WOOD7 yhint 0 noDoom0 noDoom1
      Texture WOOD5 wall core WOD subtle WOOD1
      Texture WOOD3 wall core WOD subtle WOOD1 yhint 3
      Texture WOOD1 wall core WOD subtle WOOD3
      Texture WOOD12 wall comp WOD yhint 3 noDoom0 noDoom1
      Texture SLOPPY2 wall comp WOD subtle SLOPPY1 yhint 0 noDoom0 noDoom1 gross
      Texture SKULWALL wall comp WOD subtle SKULWAL3 yhint 0 noDoom2 gross
      Texture SKINSYMB wall comp WOD subtle SKINMET1
      Texture SKINMET2 wall comp WOD subtle SKINMET1
      Texture SKINMET1 wall comp WOD subtle SKINMET2
      Texture PIPE2 wall comp WOD subtle PIPE4 yhint 0
      Texture WOODVINE wall comp WOD subtle WOOD9 yhint 0 noDoom0 noDoom1 custom
      Texture WOOD4 wall comp WOD yhint 64
      
      ; And generic WOD switches
      Texture SW1WOOD isswitch comp WOD
      Texture SW1SATYR isswitch comp WOD
      Texture SW1LION isswitch comp WOD
      Texture SW1GARG isswitch comp WOD
      
      ; MIL walls ; note that in MIL the walls all have explicit switches
      Texture BRONZE4 wall core MIL subtle BRONZE3 switch SW1TEK noDoom0 noDoom1
      Texture STARTAN1 wall core MIL subtle STARTAN2 switch SW1STRTN noDoom2
      Texture STARTAN3 wall core MIL subtle STARG3 switch SW1STRTN
      Texture STARTAN2 wall core MIL subtle STARBR2 switch SW1STRTN
      Texture STARG3 wall core MIL subtle STARGR1 switch SW1STRTN
      Texture STARG2 wall core MIL subtle STARG1 switch SW1STRTN
      Texture STARG1 wall core MIL subtle STARG2 switch SW1STRTN
      Texture BROWN96 wall core MIL subtle BROWN144 switch SW1DIRT
      Texture BROWN1 wall core MIL switch SW1BRN2
      Texture BROWNGRN wall core MIL subtle SLADWALL switch SW1BRNGN
      Texture SLADWALL wall core MIL subtle BROWNGRN switch SW1SLAD
      Texture GRAYALT wall core MIL switch SW1GRAY noDoom0 noDoom1 custom
      Texture TEKVINE wall comp MIL subtle TEKGREN3 switch SW1TEK yhint 0 noDoom0 noDoom1 custom
      Texture SPACEW4 wall comp MIL switch SW1TEK noDoom0 noDoom1
      Texture SW1MET2 ybias 64
      Texture METAL5 wall comp MIL subtle METAL3 switch SW1MET2 noDoom0 noDoom1
      Texture METAL3 noDoom0 noDoom1
      Texture PIPE2 wall comp MIL subtle PIPE4 switch SW1WOOD yhint 0
      Texture COMPUTE3 wall comp MIL switch SW1STRTN noDoom2
      Texture TEKWALL4 wall comp MIL subtle COMPWERD switch SW1COMP yhint 0
      Texture TEKWALL1 wall comp MIL subtle COMPWERD switch SW1COMP yhint 0
      Texture GRAY1 wall comp MIL subtle ICKWALL3 switch SW1GRAY
      Texture BROVINE2 wall comp MIL switch SW1SLAD yhint 24
      Texture METAL1 wall comp MIL subtle LITEMET switch SW1METAL
      Texture LITEMET noDoom2
      Texture STARBR2 wall comp MIL subtle STARTAN2 switch SW1STRTN
      ; And the lift texture
      Texture PLAT1 size 128 128 lift comp MIL
      
      ; MARB walls
      Texture MARBLE2 wall core MARB subtle MARBLE3
      Texture MARBLE3 wall core MARB subtle MARBLE1
      Texture MARBLE1 wall core MARB subtle MARBLE3 yhint 0
      Texture GSTVINE1 wall comp MARB subtle GSTVINE2
      Texture MARBGRAY wall comp MARB subtle GRAY5 noDoom0 noDoom1
      Texture GSTONE1 wall comp MARB subtle GSTGARG
      Texture MARBGARG wall comp MARB subtle MARBLE1 noDoom0 noDoom1 custom
      
      ; and MARB switches; these are generic, like in WOD
      Texture SW1MARB isswitch comp MARB noDoom0 noDoom1
      Texture SW1GSTON isswitch comp MARB
      ; Note that SW1WOOD was mentioned above in WOD also; this just adds
      ; the "comp MARB" to it
      Texture SW1WOOD isswitch comp MARB
      
      ; RED walls
      Texture SP_HOT1 wall core RED
      Texture REDWALL wall core RED
      Texture FIREBLU1 wall core RED subtle FIREMAG1 yhint 0
      Texture SW1HOT isswitch comp RED
      ; a wall version of SKY3, just for fun.  You can comment this
      ; out if you think it looks ugly.
      Texture SKY3_W wall comp RED realname SKY3
      
      ; Doors of all kinds.  "size" gives the width and height of the texture,
      ; and "locked" means that it's a good texture to use on a door that only
      ; opens with a switch, not a touch.
      Texture TEKBRON2 size 64 128 door comp MIL comp MARB noDoom0 noDoom1
      Texture SPCDOOR4 size 64 128 door comp MIL noDoom0 noDoom1
      Texture SPCDOOR3 size 64 128 door comp MIL noDoom0 noDoom1
      Texture SPCDOOR2 size 64 128 door comp MIL noDoom0 noDoom1
      Texture SPCDOOR1 size 64 128 door comp MIL noDoom0 noDoom1
      Texture DOORHI size 64 128 door comp MIL noDoom2
      Texture DOOR3 size 64 72 door comp MIL
      Texture DOOR1 size 64 72 door comp MIL
      Texture WOODSKUL size 64 128 door comp WOD comp MARB comp RED noDoom2
      Texture WOODMET2 size 64 128 door comp WOD comp MARB comp RED noDoom0 noDoom1
      Texture WOODGARG size 64 128 door comp WOD comp MARB comp RED
      Texture BIGDOOR4 size 128 128 door comp MIL
      Texture BIGDOOR3 size 128 128 door comp MIL
      Texture BIGDOOR2 size 128 128 door comp MIL
      Texture BIGDOOR1 size 128 96 door comp MIL
      Texture BIGDOOR7 size 128 128 door comp WOD comp MARB comp RED
      Texture BIGDOOR6 size 128 112 door comp WOD comp MARB comp RED
      Texture BIGDOOR5 size 128 128 door comp WOD comp MARB comp RED
      Texture METAL size 64 128 door comp WOD comp MARB comp RED
      ; Our two custom locked-door textures
      Texture DOORSKUL size 64 72 door locked comp MIL comp MARB noDoom0 noDoom1 custom
      Texture SLDOOR1 size 64 128 door locked comp MIL comp MARB realname SP_DUDE5 custom
      
      ; Exit switches, suitable for use on any level-ending switch.  All are
      ; custom, and Doom2-only.
      Texture EXITSWIR exitswitch comp RED noDoom0 noDoom1 custom
      Texture EXITSWIW exitswitch comp WOD comp MARB noDoom0 noDoom1 custom
      Texture EXITSWIT exitswitch comp MIL noDoom0 noDoom1 custom
      
      ; Lights, suitable for lighting recesses and stuff.
      Texture BFALL1 size 8 128 light comp RED noDoom0 noDoom1
      Texture LITEREDL size 8 128 light comp RED realname LITERED noDoom2
      Texture TEKLITE light comp MIL noDoom0 noDoom1
      Texture LITE4 light comp MIL comp MARB noDoom2
      Texture LITE5 light comp MIL comp MARB
      Texture LITE3 light comp MIL comp MARB
      
      ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
      ; "vtiles" means that it's OK to pile one on top of another, as when
      ;    making the big central pillar in an arena.
      ; "half_plaque" means that the upper half of this texture can be used
      ;    by itself, as well as the whole thing.
      Texture SILVER3 plaque vtiles comp MIL noDoom0 noDoom1
      Texture SPACEW3 plaque vtiles comp MIL noDoom0 noDoom1
      Texture COMPSTA2 plaque vtiles half_plaque comp MIL
      Texture COMPSTA1 plaque vtiles half_plaque comp MIL
      Texture COMPTALL plaque vtiles comp MIL
      Texture COMPUTE1 plaque vtiles half_plaque comp MIL noDoom2
      Texture PLANET1 plaque vtiles half_plaque comp MIL noDoom2
      Texture PANBOOK plaque comp WOD noDoom0 noDoom1
      Texture SKIN2 plaque vtiles comp RED
      Texture GSTFONT1 plaque comp RED
      Texture SKY1 plaque comp WOD comp MARB
      Texture SKY3 plaque comp MARB comp RED
      Texture MARBFAC3 plaque vtiles comp WOD comp MARB
      Texture MARBFAC2 plaque vtiles comp WOD comp MARB
      Texture MARBFACE plaque vtiles comp WOD comp MARB
      Texture FIREMAG1 plaque comp MARB
      
      ; Gratings
      Texture BRNBIGC grating comp MIL noDoom2
      Texture MIDSPACE grating comp MIL noDoom0 noDoom1
      Texture MIDVINE1 grating comp WOD comp MIL comp MARB comp RED noDoom2
      Texture MIDBARS1 grating comp WOD comp MIL comp MARB comp RED noDoom0 noDoom1
      Texture MIDGRATE grating comp WOD comp MIL comp MARB comp RED
      
      ; Colors (suitable for marking key-locked things)
      Texture LITERED size 8 128 red comp MIL comp MARB noDoom2
      Texture DOORRED size 8 128 red comp MIL comp MARB
      Texture DOORRED2 size 16 128 red comp WOD comp RED
      Texture DOORYEL size 8 128 yellow comp MIL comp MARB
      Texture DOORYEL2 size 16 128 yellow comp WOD comp RED
      Texture LITEBLU4 size 16 128 blue comp MIL comp MARB
      Texture LITEBLU1 size 8 128 blue comp MIL comp MARB
      Texture DOORBLU size 8 128 blue comp MIL comp MARB
      Texture DOORBLU2 size 16 128 blue comp WOD comp RED
      
      ; Step kickplates
      Texture STEP6 size 256 16 step comp WOD comp MIL comp MARB
      Texture STEP5 size 256 16 step comp WOD comp MIL comp MARB
      Texture STEP4 size 256 16 step comp WOD comp MIL comp MARB
      Texture STEP3 size 256 8 step comp WOD comp MIL comp MARB
      Texture STEP2 size 256 8 step comp WOD comp MIL comp MARB
      Texture STEP1 size 256 8 step comp WOD comp MIL comp MARB
      
      ; "Doorjambs"
      Texture FIRELAVA jamb comp RED
      Texture DOORTRAK jamb comp WOD comp MIL comp MARB
      Texture DOORSTOP jamb comp WOD comp MIL comp MARB
      Texture PIPE2 jamb comp MIL comp WOD  ; PIPE2 is also a wall texture
      
      ; Support textures
      Texture SKSNAKE2 support comp RED
      Texture ROCKRED1 support comp RED
      Texture ZIMMER7 support comp MARB noDoom0 noDoom1
      Texture BRICK10 support comp MARB noDoom0 noDoom1
      Texture COMPSPAN support comp MIL
      Texture SUPPORT2 support comp MIL comp MARB
      Texture SHAWN2 support comp MIL comp MARB
      Texture ASHWALL3 support comp WOD noDoom0 noDoom1
      Texture ASHWALL support comp WOD noDoom2
      Texture BROWNHUG support comp WOD comp MIL comp MARB
      Texture SUPPORT3 support comp WOD comp MARB
      Texture METAL support comp WOD comp MARB comp RED
      
      ; Bunch of things for outside patios (no themes applied here)
      Texture ZZWOLF1 outside noDoom0 noDoom1
      Texture ZIMMER3 outside noDoom0 noDoom1
      Texture ZIMMER5 outside noDoom0 noDoom1
      Texture TANROCK5 outside noDoom0 noDoom1
      Texture TANROCK4 outside noDoom0 noDoom1
      Texture TANROCK2 outside noDoom0 noDoom1
      Texture STUCCO outside noDoom0 noDoom1
      Texture STONE6 outside noDoom0 noDoom1
      Texture ROCK1 outside noDoom0 noDoom1
      Texture MODWALL1 outside noDoom0 noDoom1
      Texture BSTONE1 outside noDoom0 noDoom1
      Texture BRICK5 outside noDoom0 noDoom1
      Texture BRICK4 outside noDoom0 noDoom1
      Texture ASHWALL7 outside noDoom0 noDoom1
      Texture ASHWALL6 outside noDoom0 noDoom1
      Texture ASHWALL4 outside noDoom0 noDoom1
      Texture ASHWALL2 outside noDoom0 noDoom1
      Texture STONE3 outside
      Texture SP_ROCK1 outside
      Texture GRAYVINE outside
      Texture GRAYBIG outside
      Texture ICKWALL3 outside
      Texture BROWN144 outside
      Texture GSTONE1 outside
      Texture GSTVINE1 outside
      Texture BRICK10 outside
      Texture ASHWALL3 outside
      Texture ASHWALL outside
      Texture BROWNHUG outside
      
      ; Misc
      Texture EXITSIGN gateexitsign
      Texture REDWALL error
      
      ; This silly texture has the switch in the wrong half!
      Texture SW1DIRT ybias 72
      
      ; Now the flats.  Keywords should all be pretty obvious...   *8)
      
      ; Teleport-gate floors
      Flat SLGATE1 gate comp WOD comp MIL comp MARB comp RED custom
      Flat GATE4 gate comp WOD comp MIL comp MARB comp RED
      Flat GATE3 gate comp WOD comp MIL comp MARB comp RED
      Flat GATE2 gate comp WOD comp MIL comp MARB comp RED
      Flat GATE1 gate comp WOD comp MIL comp MARB comp RED
      
      ; Floors and ceilings for WOD theme
      Flat FLOOR5_4 ceiling outside comp WOD
      Flat FLOOR4_6 ceiling comp WOD
      Flat CEIL3_3 ceiling comp WOD
      Flat CEIL1_1 ceiling comp WOD
      Flat FLAT8 floor comp WOD
      Flat FLAT5_2 floor comp WOD
      Flat FLAT5_1 floor ceiling comp WOD comp MARB
      Flat FLAT1_1 floor outside comp WOD
      Flat CEIL5_2 floor outside comp WOD
      Flat MFLR8_1 floor comp WOD
      ; and nukages
      Flat SLIME09 nukage comp WOD noDoom0 noDoom1
      Flat BLOOD1 nukage red comp WOD
      
      ; Floors and ceilings for MIL theme
      Flat SLLITE1 ceiling light comp MIL custom
      Flat TLITE6_6 ceiling light comp MIL
      Flat FLOOR7_1 ceiling outside comp MIL
      Flat FLOOR5_2 ceiling comp MIL
      Flat FLOOR5_1 ceiling comp MIL
      Flat CEIL3_1 ceiling comp MIL
      Flat FLOOR4_1 floor comp MIL
      Flat FLOOR3_3 floor ceiling comp MIL comp MARB
      Flat FLOOR0_2 floor comp MIL
      Flat FLOOR0_1 floor outside comp MIL
      Flat FLAT1_2 floor outside comp MIL
      Flat FLAT5 floor comp MIL
      ; and nukage
      Flat NUKAGE1 nukage comp MIL
      
      ; Floors and ceilings for MARB theme (not yet mentioned elsewhere)
      Flat GRNLITE1 ceiling light comp MARB noDoom0 noDoom1
      Flat FLOOR7_2 ceiling comp MARB
      Flat SLFLAT01 floor comp MARB custom
      Flat FLAT1 floor comp MARB
      Flat DEM1_6 floor comp MARB
      Flat DEM1_5 floor ceiling comp MARB
      ; and mukage
      Flat BLOOD1 nukage red comp MARB
      Flat NUKAGE1 nukage comp MARB
      
      ; Floors and ceilings for (secret) RED theme
      Flat SLSPARKS floor comp RED custom
      Flat SFLR6_4 floor ceiling comp RED
      Flat TLITE6_5 ceiling light comp RED
      Flat FLOOR6_1 floor ceiling red comp RED
      Flat FLOOR1_7 ceiling light comp RED
      Flat FLOOR1_6 floor ceiling red comp RED
      Flat FLAT5_3 floor ceiling red comp RED
      Flat LAVA1 nukage comp RED
      Flat BLOOD1 nukage red comp RED
      
      ; Floors for outside areas not yet mentioned
      Flat SLGRASS1 outside custom
      Flat SLIME13 outside noDoom0 noDoom1
      Flat RROCK19 outside noDoom0 noDoom1
      Flat RROCK16 outside noDoom0 noDoom1
      Flat RROCK11 outside noDoom0 noDoom1
      Flat GRNROCK outside noDoom0 noDoom1
      Flat GRASS2 outside noDoom0 noDoom1
      Flat GRASS1 outside noDoom0 noDoom1
      Flat MFLR8_4 outside
      Flat MFLR8_3 outside
      Flat MFLR8_2 outside
      Flat FLAT5_7 outside
      Flat FLAT10 outside
      
      ;
      ; OK, here are the main BLU-related additions!
      ;
      
      ; A small selection of walls
      Texture COMPBLUE wall core BLU yhint 0
      Texture COMPOHSO wall core BLU NoDoom2
      Texture COMPTILE wall core BLU NoDoom2
      Texture BLAKWAL2 wall comp BLU NoDoom0 NoDoom1
      Texture TEKGREN3 wall comp BLU NoDoom0 NoDoom1
      Texture ZZWOLF9 wall comp BLU NoDoom0 NoDoom1
      
      ; All the same doors as MIL
      Texture TEKBRON2 size 64 128 door comp BLU noDoom0 noDoom1
      Texture SPCDOOR4 size 64 128 door comp BLU noDoom0 noDoom1
      Texture SPCDOOR3 size 64 128 door comp BLU noDoom0 noDoom1
      Texture SPCDOOR2 size 64 128 door comp BLU noDoom0 noDoom1
      Texture SPCDOOR1 size 64 128 door comp BLU noDoom0 noDoom1
      Texture DOORHI size 64 128 door comp BLU noDoom2
      Texture DOOR3 size 64 72 door comp BLU
      Texture DOOR1 size 64 72 door comp BLU
      Texture BIGDOOR4 size 128 128 door comp BLU
      Texture BIGDOOR3 size 128 128 door comp BLU
      Texture BIGDOOR2 size 128 128 door comp BLU
      Texture BIGDOOR1 size 128 96 door comp BLU
      Texture DOORSKUL size 64 72 door locked comp BLU noDoom0 noDoom1 custom
      Texture SLDOOR1 size 64 128 door locked comp BLU realname SP_DUDE5 custom
      
      ; support and kickplates and jambs and misc
      Texture COMPSPAN support comp BLU
      Texture SHAWN2 support comp BLU
      Texture COMP2 plaque NoDoom2
      Texture COMPUTE1 plaque NoDoom2
      Texture STEP6 size 256 16 step comp BLU
      Texture STEP5 size 256 16 step comp BLU
      Texture STEP4 size 256 16 step comp BLU
      Texture STEP3 size 256 8 step comp BLU
      Texture STEP2 size 256 8 step comp BLU
      Texture STEP1 size 256 8 step comp BLU
      Texture DOORTRAK jamb comp BLU
      Texture DOORSTOP jamb comp BLU
      Texture PLAT1 size 128 128 lift comp BLU
      Texture BRNBIGC grating comp BLU noDoom2
      Texture MIDSPACE grating comp BLU noDoom0 noDoom1
      Texture SW1BLUE isswitch comp BLU
      Texture FIREP plaque comp BLU realname FIREBLU1
      Texture EXITSWIT exitswitch comp BLU noDoom0 noDoom1 custom
      Texture TEKLITE light comp BLU noDoom0 noDoom1
      Texture LITE4 light comp BLU noDoom2
      Texture LITE5 light comp BLU
      Texture LITE3 light comp BLU
      Texture DOORRED size 8 128 red comp BLU
      Texture DOORYEL size 8 128 yellow comp BLU
      Texture DOORBLU size 8 128 blue comp BLU
      
      ; Floor and ceiling flats
      Flat FLAT22 gate comp BLU
      Flat CEIL4_2 ceiling floor comp BLU
      Flat CEIL4_3 ceiling floor comp BLU
      Flat FLAT14 ceiling floor comp BLU
      Flat FLOOR1_1 ceiling floor comp BLU
      Flat NUKAGE1 nukage comp BLU
      
      ;
      ; and that's mostly it for BLU, except for a few "comp BLU"s on
      ; one construct family and some lamps, below.  You can make your
      ; own new themes in the same way.  Enjoy!
      ;
      
      Flat FWATER1 water
      Flat F_SKY1 sky
      
      ; Family 1 is silver-colored computers; short ones and tall ones
      Construct family 1 height 64 comp MIL comp MARB
        top FLAT9 top FLAT4 top FLAT23 top FLAT19 top FLAT18 top CRATOP1 top COMP01
        Primary COMPUTE1 yoffsets 0 64
        Primary COMPSTA2
        Primary COMPSTA1
        Secondary SUPPORT2 width 16
        Secondary SHAWN2 width 16
      Construct family 1 height 128 comp MIL comp MARB
        top FLAT9 top FLAT4 top FLAT23 top FLAT19 top FLAT18 top CRATOP1 top COMP01
        Primary SILVER3
        Primary COMPUTE1 yoffsets 0 64
        Secondary SILVER2 width 64
        Secondary SILVER1 width 64
        Secondary SUPPORT2 width 16
        Secondary SHAWN2 width 16
      
      ; Family 2 is dark-colored computers; short and tall
      Construct family 2 height 64 comp MIL comp BLU
        top CEIL5_1 top FLAT4 top TLITE6_1
        Primary SPACEW3 yoffsets 0 64 width 64
        Primary COMPTALL yoffsets 0 64 width 256
        Primary COMP2 yoffsets 0 64 width 256
        Secondary METAL7 yoffsets 0 64 width 64
        Secondary METAL6 yoffsets 0 64 width 64
        Secondary METAL5 yoffsets 0 64 width 64
        Secondary METAL3 yoffsets 0 64 width 64
        Secondary METAL2 yoffsets 0 64 width 64
        Secondary COMPWERD width 64
        Secondary COMPSPAN width 16
      Construct family 2 height 128 comp MIL
        top CEIL5_1 top FLAT4 top TLITE6_1
        Primary SPACEW3 width 64
        Primary COMPTALL width 256
        Primary COMP2 width 256
        Secondary METAL7 yoffsets 0 64 width 64
        Secondary METAL6 yoffsets 0 64 width 64
        Secondary METAL5 yoffsets 0 64 width 64
        Secondary METAL3 yoffsets 0 64 width 64
        Secondary METAL2 yoffsets 0 64 width 64
        Secondary COMPWERD width 64
        Secondary COMPSPAN width 16
      
      ; Family 3 is crates of various sizes and kinds
      Construct family 3 height 64 comp WOD comp MIL
        top CRATOP2
        Primary CRATWIDE yoffsets 64 64
        Primary CRATE1 width 64
      Construct family 3 height 64 comp WOD comp MIL
        top CRATOP1
        Primary CRATWIDE
        Primary CRATE2 width 64
      Construct family 3 height 64 comp WOD comp MIL
        top CRATOP1
        Primary CRATELIT width 32
      Construct family 3 height 32 comp WOD comp MIL
        top CRATOP1
        Primary CRATELIT width 32
      Construct family 3 height 16 comp WOD comp MIL
        top CRATOP1
        Primary CRATINY width 16
      
      ; And Family 4 is bookcases; works only in Doom2
      Construct family 4 height 128 comp WOD comp MARB noDoom0 noDoom1
        top FLAT5_1 top CRATOP2 top CEIL5_2 top CEIL3_3 top CEIL1_1
        Secondary PANEL5 width 64
        Secondary PANCASE2 width 64
        Secondary PANCASE1 width 64
        Secondary PANBORD2 width 16
        Secondary PANBORD1 width 32
        Primary PANBOOK width 64
      
      ; Mask-adjustments for the construct textures that need it
      Texture PANEL5 noDoom0 noDoom1
      Texture PANCASE2 noDoom0 noDoom1
      Texture PANCASE1 noDoom0 noDoom1
      Texture PANBORD2 noDoom0 noDoom1
      Texture PANBORD1 noDoom0 noDoom1
      Texture METAL7 noDoom0 noDoom1
      Texture METAL6 noDoom0 noDoom1
      Texture METAL2 noDoom0 noDoom1
      Texture COMP2 noDoom2
      Texture SILVER2 noDoom0 noDoom1
      Texture SILVER1 noDoom0 noDoom1
      
      Hardwired1
      
      Thing 2035 comp MIL  ; barrel
      Thing 34 comp WOD comp MIL comp MARB   ; candle
      Thing 44 comp WOD comp MARB comp BLU   ; tall blue torch
      Thing 45 comp WOD comp MARB   ; tall green torch
      Thing 46 comp WOD comp MARB comp RED  ; tall red torch
      Thing 55 comp WOD comp MARB comp BLU  ; short blue torch
      Thing 56 comp WOD comp MARB   ; short green torch
      Thing 57 comp WOD comp MARB comp RED  ; short red torch
      Thing 48 comp MIL comp BLU    ; electric pillar
      Thing 2028 comp MIL comp BLU
      Thing 85 comp MIL comp BLU
      Thing 86 comp MIL comp BLU
      Thing 70 comp MIL comp WOD    ; flaming barrel
      Thing 35 comp WOD             ; candelabra
      
      ; and that's it;
      ]]
  },


---- Episode 1 ----

  tech =
  {
    liquids =
    {
      nukage = 80,
      water  = 30,
      lava   = 10,
    },

    facades =
    {
      BROWN1 = 50,
      BROWNGRN = 20,
      BROWN96 = 5,
      STONE2 = 10,
      STONE3 = 10,
      STARTAN3 = 30,
      STARG3 = 20,
      BROVINE2 = 5,
      BROVINE  = 5,
    },

    prefab_remap =
    {
    },

    floor_sinks =
    {
      liquid_plain = 10,
      liquid_shiny = 5,
      liquid_metal = 5,
      floor_blue  = 10,
      floor_blue3 = 5,
    },

    ceiling_sinks =
    {
      sky_shiny = 20,
      sky_metal = 10,
      sky_tech3 = 2,
      light_red_shiny = 20,
      light_orange_shiny = 7,
      light_brightred_metal = 7,
      light_brightred_metal2 = 5,
      light_diamond = 3,
      light_side1 = 5,
      light_side4 = 5,
    },

    street_sinks =
    {
      floor_default_streets = 1,
    },

    beam_groups =
    {
      beam_shiny = 75,
      beam_quakeish = 50,
      beam_lights = 50,
      beam_lights_white = 50,
      beam_lights_vertical_tech = 50,
      beam_textured = 50,
    },

    wall_groups =
    {
      low_gap = 40,
      mid_band = 40,
      --
      torches6 = 15,
      torches7 = 40,
      torches11 = 20,
      --
      lite1 = 40,
      lite2 = 40,
      --
      gtd_wall_urban_storage = 50,
      gtd_full_storage = 50,
      --
      gtd_wall_tech_top_corner_light_set = 50,
      gtd_wall_server_room = 50,
      gtd_wall_sewer = 50,
      --
      gtd_generic_beamed_inset = 25,
      gtd_generic_beamed_green_inset = 25,
      gtd_generic_beamed_brown_inset = 25,
      --
      gtd_computers = 32,
      gtd_computers_lite5 = 32,
      gtd_computers_blue_shawn = 32,
      --
      gtd_writhing_mass = 10,
      gtd_wall_octagon_insets = 50,
      gtd_wall_grated_machines = 50,
      --
      gtd_wall_quakish_insets = 25,
      gtd_wall_quakish_insets_2 = 25,
      --
      gtd_ribbed_lights = 18,
      gtd_ribbed_lights_no3d = 18,
      gtd_ribbed_lights_slump = 18,
      gtd_ribbed_lights_slump_two_color = 18,
      gtd_ribbed_lights_tekmachine = 9,
      gtd_ribbed_lights_tekmachine_alt = 9,
      gtd_ribbed_lights_very_blue = 18,
      --
      gtd_wall_high_gap_set = 25,
      gtd_wall_high_gap_alt_set = 25,
      --
      gtd_generic_half_floor = 20,
      gtd_generic_half_floor_no_trim = 20,
      gtd_generic_half_floor_inverted_braced = 20,
      --
      gtd_wall_urban_cement_frame = 10,
      --
      gtd_generic_ceilwall = 30,
      gtd_generic_ceilwall_2 = 30,
      gtd_generic_ceilwall_3 = 30,
      gtd_generic_ceilwall_silver_frame = 30,
      gtd_generic_ceilwall_double_silver_frame = 30,
      --
      gtd_generic_glow_wall = 50,
      gtd_generic_double_banded_ceil = 50,
      --
      gtd_generic_frame_light_band = 50,
      gtd_generic_frame_metal = 50,
      --
      gtd_generic_d64_1x = 8,
      gtd_generic_d64_1x_yellow = 8,
      gtd_generic_d64_1x_blue = 8,
      gtd_generic_d64_2x = 8,
      gtd_generic_d64_2x_yellow = 8,
      gtd_generic_d64_2x_blue = 8,
      --
      gtd_generic_tek_grate = 25,
      gtd_generic_tek_grate_bottom_slope = 25,
      gtd_generic_tek_grate_xit_machine = 25,
      --
      gtd_generic_artsy_bedazzled = 5,
      gtd_generic_alt_colors = 20,
      gtd_generic_mid_band = 20,
      gtd_generic_artsy_center_braced_ind = 20,
      gtd_generic_artsy_step1_banded = 20,
      gtd_generic_artsy_slope_y_inset = 20,
      gtd_generic_artsy_base_braced = 20,
      gtd_generic_artsy_sloped_bump = 20,
      gtd_generic_small_lite = 20,
      gtd_generic_artsy_lite_box = 20,
      gtd_generic_artsy_chequered = 20,
      --
      gtd_ind_modwall_1 = 20,
      gtd_ind_modwall_2 = 20,
      gtd_ind_modwall_3 = 20,
      --
      gtd_greywall_1 = 25,
      gtd_greytall_trim = 25,
      --
      gtd_modquake_set = 18,
      gtd_modquake_jawlike = 18,
      gtd_modquake_top_heavy_brace = 18,
      gtd_modquake_tek_slope_brace = 18,
      gtd_modquake_ex_light_slope_brace = 18,
      gtd_modquake_round_braced_lit_pillar = 18,
      gtd_modquake_hexagon_inset_braced = 18,
      --
      gtd_wall_lamp_stubby = 16,
      gtd_wall_lamp_thin = 16,
      gtd_wall_lamp_thicc = 16,
      --
      gtd_sunderfall = 13,
      gtd_sunderfall_barred = 13,
      --
      gtd_door_storage = 20
    },

    outdoor_wall_groups =
    {
      PLAIN = 2,
      tech_o_caution_strip = 1,
      tech_o_orange_light_stack = 1,
      tech_o_lite_strip_white = 0.5,
      tech_o_lite_strip_blue = 0.5,
      tech_o_inset_teklite = 0.5,
      tech_o_inset_teklite2 = 0.5,
      tech_o_halfbase_green_light = 0.5,
      tech_o_halfbase_blue_triangle = 0.5,
      tech_o_giant_UAC_sign = 1,
      tech_o_double_hanging_vents = 1,
      tech_o_overhanging_braced_vent = 1,
      tech_o_overhanging_lite_platform = 1,
      tech_o_pipe_junctions = 1,
      tech_o_hadleys_hope = 1,
      tech_o_overhanging_lights = 1,
      tech_o_shiny_silver_overhang = 1,
      tech_o_silver_scaffolding = 1,
      tech_o_concrete_base = 1,
      tech_o_fence_lights_uac_thing = 1,
      tech_o_hex_inset = 1,
      tech_o_grated_greenwall = 1,
      tech_o_everyone_likes_sewers = 1,
      tech_o_red_wall = 0.5,
      tech_o_blue_wall = 0.5,
      tech_o_lots_of_cement = 1,
      tech_o_tekgren_grates_thing = 1,
      tech_o_black_mesa_overlook = 1,
      tech_o_compblue_tall = 1,
      tech_o_grey_metal_sloped = 1,
      tech_o_tall_light = 0.5,
      tech_o_tall_light_alt = 0.5,
      tech_o_hexagon_uac_spotlights = 1,
      tech_o_orange_oct_white_binding = 1,
      tech_o_g_blakwall = 1,
      tech_o_g_modwall1 = 1,
      tech_o_g_modwall2 = 1,
      tech_o_yellow_compsil = 1
    },

    fence_groups =
    {
      PLAIN = 50,
      gappy = 50,
      fence_tech_lit = 50,
    },

    fence_posts =
    {
      Post_metal = 50,
      Post_tech_1 = 50,
      Post_tech_2 = 50,
      Post_tech_simple = 50,
    },

    cage_mats =
    {
      METAL1   = 60,
      BROWN144 = 60,
      STONE    = 50,
      SHAWN2   = 40,
      TEKWALL1 = 40,
      TEKWALL4 = 40,
      STONE2   = 20,
    },

    fences =
    {
      METAL1   = 60,
      STONE    = 60,
      STARG1   = 30,
      STONE2   = 20,
      STONE3   = 30,
      BROVINE  = 20,
      BROVINE2 = 20,
      GRAY1    = 20,
    },

    passable_decor =
    {
      gibs = 60,
      gibbed_player = 20,
      dead_player = 35,
    },

    park_decor =
    {
      burnt_tree = 95,
      brown_stub = 55,
      big_tree = 30,
    },

    window_groups =
    {
      square = 90,
      tall   = 90,
      grate  = 40,
      barred = 10,
      round  = 5,
      supertall = 70,
      gtd_window_cage_highbars = 20,
      gtd_window_cage_lowbars = 10,
      gtd_window_full_open = 15,
      gtd_window_full_open_tall = 15,
      gtd_window_bay = 20,
      gtd_window_absurdly_open = 25,
      gtd_window_quakeish = 20,
      gtd_window_low = 10,
      gtd_window_weabdows = 20,
      gtd_window_metal_frames = 20,
      gtd_window_construction_frames = 20,
    },

    cave_torches =
    {
      lamp        = 25,
      red_torch   = 70,
    },

    outdoor_torches =
    {
      lamp   = 40,
      red_torch = 15,
    },

    style_list =
    {
      caves = { none=70, few=30 },
      outdoors = { few=70, some=30, heaps=10 },
      big_rooms = { none=50, few=25, some=10, heaps=5 },
      big_outdoor_rooms = { none=25, few=30, some=70, heaps=10 },
      hallways = { none=20, few=45, some=20, heaps=10 },
      windows = { few=15, some=85, heaps=40 },
      pictures = { few=20, some=75, heaps=45 },
      liquids = { none=50, few=35, some=10, heaps=5 },
      doors = { few=25, some=75, heaps=30 },
      teleporters = { none=75, few=30, some=10, heaps=3 },
      keys = { none=15, few=40, some=70, heaps=30 },
      trikeys = { none=15, few=70, some=30, heaps=10 },
      switches = { none=25, few=75, some=40, heaps=15 },
      secrets = { few=15, some=80, heaps=30 },
      symmetry = { none=50, few=50, some=50, heaps=50 },
      steepness = { few=30, some=70, heaps=40 },
      scenics = { none=3, few=10, some=80, heaps=25 },
      cages = { none=70, few=20, some=10, heaps=2 },
      traps = { few=60, some=40, heaps=15 },
      barrels = { few=5, some=85, heaps=60 },
      ambushes = { few=35, some=65, heaps=20 },
      beams  = { none=10, few=15, some=40, heaps=5 },
      porches = { none=15, few=40, some=60, heaps=30 },
      fences = { none=5, few=40, some=60, heaps=15 },
    },

    scenic_fences =
    {
      MIDGRATE = 50,
    },

    monster_prefs =
    {
      zombie  = 2.0,
      shooter = 1.25,
      imp     = 1.5,
      demon   = 1.25,
      caco    = 0.5,
      baron   = 0.35,
      skull   = 0.2,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    skyboxes =
    {
      Skybox_generic = 50,
    },

    ceil_light_prob = 70,

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

      Theme MIL
      Theme RED secret


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

      ; MIL walls ; note that in MIL the walls all have explicit switches
      Texture BRONZE4 wall core MIL subtle BRONZE3 switch SW1TEK noDoom0 noDoom1
      Texture STARTAN1 wall core MIL subtle STARTAN2 switch SW1STRTN noDoom2
      Texture STARTAN3 wall core MIL subtle STARG3 switch SW1STRTN
      Texture STARTAN2 wall core MIL subtle STARBR2 switch SW1STRTN
      Texture STARG3 wall core MIL subtle STARGR1 switch SW1STRTN
      Texture STARG2 wall core MIL subtle STARG1 switch SW1STRTN
      Texture STARG1 wall core MIL subtle STARG2 switch SW1STRTN
      Texture BROWN96 wall core MIL subtle BROWNGRN switch SW1DIRT
      Texture TEKGREN2 wall core MIL subtle TEKGREN1 switch SW1TEK noDoom0 noDoom1
      Texture BROWN1 wall core MIL switch SW1BRN2
      Texture STONE wall core MIL subtle GRAY1 switch SW1GRAY
      Texture STONE6 wall comp MIL subtle STONE7 switch SW1STON6 noDoom0 noDoom1
      Texture BROWNGRN wall core MIL subtle BROWN96 switch SW1BRNGN
      Texture SLADWALL wall core MIL subtle BROWNGRN switch SW1SLAD
      Texture PIPEWAL2 wall comp MIL subtle PIPEWAL1 switch SW1COMP noDoom0 noDoom1
      Texture GRAYALT wall core MIL switch SW1GRAY noDoom0 noDoom1 custom
      Texture TEKVINE wall comp MIL subtle TEKWALL1 switch SW1TEK yhint 0 noDoom0 noDoom1 custom
      Texture SPACEW4 wall comp MIL switch SW1TEK noDoom0 noDoom1
      Texture METAL5 wall comp MIL subtle METAL3 switch SW1MET2 noDoom0 noDoom1
      Texture METAL2 switch SW1MET2 noDoom0 noDoom1
      Texture COMPUTE3 wall comp MIL switch SW1STRTN noDoom2
      Texture TEKWALL4 wall comp MIL subtle COMPWERD switch SW1COMP yhint 2
      Texture TEKWALL1 wall comp MIL subtle COMPWERD switch SW1COMP yhint 2
      Texture GRAY1 wall comp MIL subtle ICKWALL3 switch SW1GRAY
      Texture GRAY7 wall comp MIL subtle GRAY1 switch SW1GRAY1
      Texture ICKWALL3 wall comp MIL subtle ICKWALL7 switch SW2GRAY
      Texture BROVINE2 wall comp MIL switch SW1SLAD yhint 2
      Texture METAL1 wall comp MIL switch SW1METAL
      Texture STARBR2 wall comp MIL subtle STARTAN2 switch SW1STRTN


      ; And the lift texture
      Texture PLAT1 size 128 128 lift comp MIL


      ; RED walls
      Texture SP_HOT1 wall core RED
      Texture REDWALL wall core RED
      Texture FIREBLU1 wall core RED subtle FIREMAG1 yhint 0
      Texture SW1HOT isswitch comp RED
      ; a wall version of SKY3, just for fun.  You can comment this
      ; out if you think it looks ugly.
      Texture SKY3_W wall comp RED realname SKY3

      ; Doors of all kinds.  "size" gives the width and height of the texture,
      ; and "locked" means that it's a good texture to use on a door that only
      ; opens with a switch, not a touch.
      Texture TEKBRON2 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture SPCDOOR4 size 64 128 door comp MIL noDoom0 noDoom1
      Texture SPCDOOR3 size 64 128 door comp MIL noDoom0 noDoom1
      Texture SPCDOOR2 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture SPCDOOR1 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture DOORHI size 64 128 door comp MIL noDoom2
      Texture DOOR3 size 64 72 door comp MIL 
      Texture DOOR1 size 64 72 door comp MIL 
      Texture WOODSKUL size 64 128 door comp RED noDoom2
      Texture WOODMET2 size 64 128 door comp RED noDoom0 noDoom1
      Texture WOODGARG size 64 128 door comp RED
      Texture BIGDOOR4 size 128 128 door comp MIL 
      Texture BIGDOOR3 size 128 128 door comp MIL 
      Texture BIGDOOR2 size 128 128 door comp MIL 
      Texture BIGDOOR1 size 128 96 door comp MIL
      Texture BIGDOOR7 size 128 128 door comp RED 
      Texture BIGDOOR6 size 128 112 door comp RED 
      Texture BIGDOOR5 size 128 128 door comp RED
      Texture METAL size 64 128 door comp RED
      ; Our two custom locked-door textures
      Texture DOORSKUL size 64 72 door locked comp MIL noDoom0 noDoom1 custom
      Texture SLDOOR1 size 64 128 door locked comp MIL realname SP_DUDE5 custom

      ; Exit switches, suitable for use on any level-ending switch.  All are
      ; custom, and Doom2-only.
      Texture EXITSWIR exitswitch comp RED noDoom0 noDoom1 custom
      Texture EXITSWIT exitswitch comp MIL noDoom0 noDoom1 custom

      ; Lights, suitable for lighting recesses and stuff.
      Texture BFALL1 size 8 128 light comp RED noDoom0 noDoom1
      Texture LITEREDL size 8 128 light comp RED realname LITERED noDoom2
      Texture TEKLITE light comp MIL noDoom0 noDoom1
      Texture LITE4 light comp MIL noDoom2
      Texture LITE5 light comp MIL
      Texture LITE3 light comp MIL

      ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
      ; "vtiles" means that it's OK to pile one on top of another, as when
      ;    making the big central pillar in an arena.
      ; "half_plaque" means that the upper half of this texture can be used
      ;    by itself, as well as the whole thing.
      Texture SILVER3 plaque vtiles comp MIL noDoom0 noDoom1
      Texture SPACEW3 plaque vtiles comp MIL noDoom0 noDoom1
      Texture COMPSTA2 plaque vtiles half_plaque comp MIL
      Texture COMPSTA1 plaque vtiles half_plaque comp MIL
      Texture COMP2 plaque vtiles half_plaque comp MIL
      Texture COMPTALL plaque vtiles comp MIL
      Texture COMPUTE1 plaque vtiles half_plaque comp MIL noDoom2
      Texture PLANET1 plaque vtiles half_plaque comp MIL noDoom2
      Texture SKIN2 plaque vtiles comp RED
      Texture GSTFONT1 plaque comp RED
      Texture FIREMAG1 plaque comp red
      ; Some people think these next two look silly;
      ; you can comment them out if you want to.
      ; Texture SKY1 plaque  
      ; Texture SKY3 plaque comp RED

      ; Gratings
      Texture BRNBIGC grating comp MIL noDoom2
      Texture MIDSPACE grating comp MIL noDoom0 noDoom1
      Texture MIDVINE1 grating comp MIL comp RED noDoom2
      Texture MIDBARS1 grating comp MIL comp RED  noDoom0 noDoom1
      Texture MIDGRATE grating comp MIL comp RED 

      ; Colors (suitable for marking key-locked things)
      Texture LITERED size 8 128 red comp MIL noDoom2
      Texture DOORRED size 8 128 red comp MIL 
      Texture DOORRED2 size 16 128 red  comp RED 
      Texture DOORYEL size 8 128 yellow comp MIL 
      Texture DOORYEL2 size 16 128 yellow comp RED 
      Texture LITEBLU4 size 16 128 blue comp MIL
      Texture LITEBLU1 size 8 128 blue comp MIL
      Texture DOORBLU size 8 128 blue comp MIL 
      Texture DOORBLU2 size 16 128 blue comp RED 

      ; Step kickplates
      Texture STEP6 size 256 16 step comp MIL 
      Texture STEP5 size 256 16 step comp MIL 
      Texture STEP4 size 256 16 step comp MIL
      Texture STEP3 size 256 8 step comp MIL 
      Texture STEP2 size 256 8 step comp MIL
      Texture STEP1 size 256 8 step comp MIL 

      ; "Doorjambs"
      Texture FIRELAVA jamb comp RED
      Texture DOORTRAK jamb comp MIL
      Texture DOORSTOP jamb comp MIL
      ; Texture PIPE2 jamb comp MIL   ; PIPE2 is also a wall texture

      ; Support textures, used in various places
      Texture SKSNAKE2 support comp RED
      Texture ROCKRED1 support comp RED
      Texture COMPSPAN support comp MIL 
      Texture SUPPORT2 support comp MIL 
      Texture SHAWN2 support comp MIL  
      Texture ASHWALL3 support  noDoom0 noDoom1
      Texture ASHWALL support  noDoom2
      Texture BROWNHUG support  comp MIL  
      Texture METAL support comp RED

      ; Bunch of things for outside patios (no themes applied here)
      Texture ZIMMER1 outside noDoom0 noDoom1
      Texture ZIMMER2 outside noDoom0 noDoom1
      Texture ZIMMER3 outside noDoom0 noDoom1
      Texture ZIMMER4 outside noDoom0 noDoom1
      Texture ZIMMER5 outside noDoom0 noDoom1
      Texture ZIMMER7 outside noDoom0 noDoom1
      Texture ZIMMER8 outside noDoom0 noDoom1
      Texture TANROCK5 outside noDoom0 noDoom1
      Texture TANROCK4 outside noDoom0 noDoom1
      Texture TANROCK2 outside noDoom0 noDoom1
      Texture STUCCO outside noDoom0 noDoom1
      Texture STONE6 outside noDoom0 noDoom1
      Texture ROCK1 outside noDoom0 noDoom1
      Texture MODWALL1 outside noDoom0 noDoom1
      Texture BSTONE1 outside noDoom0 noDoom1
      Texture BRICK4 outside noDoom0 noDoom1
      Texture ASHWALL7 outside noDoom0 noDoom1
      Texture ASHWALL6 outside noDoom0 noDoom1
      Texture ASHWALL4 outside noDoom0 noDoom1
      Texture ASHWALL2 outside noDoom0 noDoom1
      Texture SP_ROCK1 outside
      Texture GRAYVINE outside
      Texture ICKWALL3 outside
      Texture BROWN144 outside
      Texture GSTONE1 outside
      Texture GSTVINE1 outside
      Texture BRICK10 outside NoDoom0 NoDoom1
      Texture ASHWALL3 outside NoDoom0 NoDoom1
      Texture ASHWALL outside NoDoom2
      Texture BROWNHUG outside

      ; Misc
      Texture EXITSIGN gateexitsign
      Texture REDWALL error

      ; This silly texture has the switch in the wrong half!
      Texture SW1DIRT ybias 72
      Texture SW1MET2 ybias 64

      ; Now the flats.  Keywords should all be pretty obvious...   *8)

      ; Teleport-gate floors
      Flat SLGATE1 gate  comp MIL  comp RED custom
      Flat GATE4 gate comp MIL comp RED 
      Flat GATE3 gate comp MIL comp RED 
      Flat GATE2 gate comp MIL comp RED 
      Flat GATE1 gate comp MIL comp RED 

      ; Floors and ceilings for MIL theme
      Flat SLLITE1 ceiling light comp MIL custom
      Flat TLITE6_6 ceiling light comp MIL
      Flat TLITE6_5 ceiling light comp MIL
      Flat FLOOR7_1 ceiling outside comp MIL
      Flat FLOOR5_2 ceiling comp MIL
      Flat CEIL3_1 ceiling comp MIL
      Flat CEIL3_2 ceiling comp MIL
      Flat CEIL3_5 ceiling comp MIL
      Flat FLAT14 floor comp MIL
      Flat FLOOR4_1 floor comp MIL
      Flat FLOOR4_8 floor comp MIL
      Flat FLOOR5_1 floor comp MIL
      Flat FLOOR3_3 floor ceiling comp MIL 
      Flat FLOOR0_2 floor comp MIL
      Flat FLOOR0_1 floor comp MIL
      Flat FLAT1_2 floor outside comp MIL
      Flat FLAT5 floor comp MIL
      Flat SLIME14 floor comp MIL noDoom0 noDoom1
      Flat SLIME15 floor comp MIL noDoom0 noDoom1
      Flat SLIME16 floor comp MIL noDoom0 noDoom1
      ; and nukage
      Flat NUKAGE1 nukage comp MIL
      Flat SLIME01 nukage comp MIL noDoom0 noDoom1

      ; Floors and ceilings for (secret) RED theme
      Flat SLSPARKS floor comp RED custom
      Flat SFLR6_4 floor ceiling comp RED
      Flat TLITE6_5 ceiling light comp RED
      Flat FLOOR6_1 floor ceiling red comp RED
      Flat FLOOR1_7 ceiling light comp RED
      Flat FLOOR1_6 floor ceiling red comp RED
      Flat FLAT5_3 floor ceiling red comp RED
      Flat LAVA1 nukage comp RED
      Flat BLOOD1 nukage red comp RED
      Flat RROCK05 nukage comp RED noDoom0 noDoom1

      ; Floors for outside areas not yet mentioned
      Flat SLGRASS1 outside custom
      Flat SLIME13 outside noDoom0 noDoom1
      Flat RROCK19 outside noDoom0 noDoom1
      Flat RROCK16 outside noDoom0 noDoom1
      Flat RROCK11 outside noDoom0 noDoom1
      Flat GRNROCK outside noDoom0 noDoom1
      Flat GRASS2 outside noDoom0 noDoom1
      Flat GRASS1 outside noDoom0 noDoom1
      Flat MFLR8_4 outside
      Flat MFLR8_3 outside
      Flat MFLR8_2 outside
      Flat FLAT5_7 outside
      Flat FLAT10 outside

      ; These are the defaults, but we'll list them anyway.
      Flat FWATER1 water
      Flat F_SKY1 sky

      ; Constructs: computers and crates and stuff that stand around in rooms
      ; This is pretty complex!  Fool with it at your peril.

      ; Family 1 is silver-colored computers; short ones and tall ones
      Construct family 1 height 64 comp MIL 
        top FLAT9 top FLAT4 top FLAT23 top FLAT19 top FLAT18 top CRATOP1 top COMP01
        Primary COMPUTE1 yoffsets 0 64
        Primary COMPSTA2
        Primary COMPSTA1
        Secondary SUPPORT2 width 16
        Secondary SHAWN2 width 16
      Construct family 1 height 128 comp MIL 
        top FLAT9 top FLAT4 top FLAT23 top FLAT19 top FLAT18 top CRATOP1 top COMP01
        Primary SILVER3
        Primary COMPUTE1 yoffsets 0 64
        Secondary SILVER2 width 64
        Secondary SILVER1 width 64
        Secondary SUPPORT2 width 16
        Secondary SHAWN2 width 16

      ; Family 2 is dark-colored computers; short and tall
      Construct family 2 height 64 comp MIL
        top CEIL5_1 top FLAT4 top TLITE6_1
        Primary SPACEW3 yoffsets 0 64 width 64
        Primary COMPTALL yoffsets 0 64 width 256
        Primary COMP2 yoffsets 0 64 width 256
        Secondary METAL7 yoffsets 0 64 width 64
        Secondary METAL6 yoffsets 0 64 width 64
        Secondary METAL5 yoffsets 0 64 width 64
        Secondary METAL3 yoffsets 0 64 width 64
        Secondary METAL2 yoffsets 0 64 width 64
        Secondary COMPWERD width 64
        Secondary COMPSPAN width 16
      Construct family 2 height 128 comp MIL
        top CEIL5_1 top FLAT4 top TLITE6_1
        Primary SPACEW3 width 64
        Primary COMPTALL width 256
        Primary COMP2 width 256
        Secondary METAL7 yoffsets 0 64 width 64
        Secondary METAL6 yoffsets 0 64 width 64
        Secondary METAL5 yoffsets 0 64 width 64
        Secondary METAL3 yoffsets 0 64 width 64
        Secondary METAL2 yoffsets 0 64 width 64
        Secondary COMPWERD width 64
        Secondary COMPSPAN width 16

      ; Family 3 is crates of various sizes and kinds
      Construct family 3 height 64  comp MIL 
        top CRATOP2
        Primary CRATWIDE yoffsets 64 64
        Primary CRATE1 width 64
      Construct family 3 height 64  comp MIL 
        top CRATOP1
        Primary CRATWIDE
        Primary CRATE2 width 64
      Construct family 3 height 64  comp MIL 
        top CRATOP1
        Primary CRATELIT width 32
      Construct family 3 height 32  comp MIL 
        top CRATOP1
        Primary CRATELIT width 32
      Construct family 3 height 16  comp MIL 
        top CRATOP1
        Primary CRATINY width 16

      ; And Family 4 is bookcases; works only in Doom2
      Construct family 4 height 128 noDoom0 noDoom1
        top FLAT5_1 top CRATOP2 top CEIL5_2 top CEIL3_3 top CEIL1_1
        Secondary PANEL5 width 64
        Secondary PANCASE2 width 64
        Secondary PANCASE1 width 64
        Secondary PANBORD2 width 16
        Secondary PANBORD1 width 32
        Primary PANBOOK width 64

      ; Mask-adjustments for the construct textures that need it
      Texture PANEL5 noDoom0 noDoom1
      Texture PANCASE2 noDoom0 noDoom1
      Texture PANCASE1 noDoom0 noDoom1
      Texture PANBORD2 noDoom0 noDoom1
      Texture PANBORD1 noDoom0 noDoom1
      Texture METAL7 noDoom0 noDoom1
      Texture METAL6 noDoom0 noDoom1
      Texture METAL2 noDoom0 noDoom1
      Texture COMP2 noDoom2
      Texture SILVER2 noDoom0 noDoom1
      Texture SILVER1 noDoom0 noDoom1

      ; Load the hardwired monster and object and so on data (required in
      ; this version of SLIGE; don't remove this!)
      Hardwired1

      ; Say which lamps we like in which themes, and where barrels are allowed
      ; Information like which Doom version each object is in, and which ones
      ; cast light, and which ones explode, is still hardwired.
      Thing 2035 comp MIL  ; barrel
      Thing 34  comp MIL    ; candle
      ;Thing 44     ; tall blue torch
      ;Thing 45     ; tall green torch
      Thing 46 comp RED  ; tall red torch
      ;Thing 55 comp RED    ; short blue torch
      ;Thing 56 comp RED    ; short green torch
      Thing 57 comp RED  ; short red torch
      Thing 48 comp MIL             ; electric pillar
      Thing 2028 comp MIL
      Thing 85 comp MIL
      Thing 86 comp MIL
      Thing 70 comp MIL     ; flaming barrel
      ;Thing 35              ; candelabra

      ; and that's it!
    ]]

  },


---- Episode 2 ----
-- Deimos theme by Reisal

  deimos =
  {
    liquids =
    {
      nukage = 60,
      blood  = 20,
      water  = 10,
      lava   = 3,
    },

    -- Best facades would be STONE/2/3, BROVINE/2, BROWN1 and maybe a few others as I have not seen many
    -- other textures on the episode 2 exterior.
    facades =
    {
      STONE2 = 40,
      STONE3 = 60,
      BROVINE = 30,
      BROVINE2 = 25,
      BROWN1 = 50,
      BROWNGRN = 20,
      STONE    = 15,
    },

    prefab_remap =
    {
    },

    floor_sinks =
    {
      liquid_plain = 10,
      liquid_shiny = 5,
      liquid_metal = 5,
      floor_green = 5,
      floor_blue  = 10,
      floor_blue2 = 5,
      floor_blue3 = 5,
    },

    ceiling_sinks =
    {
      sky_shiny = 20,
      sky_metal = 10,
      light_red_shiny = 20,
      light_orange_shiny = 7,
      light_brightred_metal = 7,
      ceil_icky = 4,
      ceil_vdark2 = 3,
      light_side1 = 4,
      light_side2 = 4,
      light_side3 = 4,
    },

    street_sinks =
    {
      floor_default_streets = 1,
    },

    park_decor =
    {
      burnt_tree = 95,
      brown_stub = 55,
      big_tree = 40,
    },

    wall_groups =
    {
      torches2 = 30, --red
      torches3 = 30, --blue
      torches1 = 30, --green
      torches6 = 10, --candelabra
      torches8 = 10, --evil eye
      torches10 = 7, --skull rock
      --
      lowhell1 = 16,
      lowhell2 = 16,
      lowhell3 = 16,
      --
      runes1 = 10,
      runes2 = 10,
      runes3 = 10,
      runes4 = 10,
      runes5 = 10,
      --
      cross1 = 7, --7
      cross2 = 15, --15
      cross3 = 7, --7
      cross4 = 10, --5
      cross5 = 15, --10
      --
      mid_band_hell = 25,
      --
      gtd_wall_hell_bloodgutters = 25,
      gtd_wall_tech_top_corner_light_set = 50,
      --
      gtd_generic_beamed_inset = 35,
      gtd_generic_beamed_brown_inset = 35,
      --
      gtd_writhing_mass = 50,
      gtd_library = 50,
      --
      gtd_furnace = 20,
      gtd_furnace_face = 20,
      gtd_furnace_water = 20,
      --
      gtd_wall_marbface = 50,
      gtd_wall_quakish_insets = 50,
      gtd_wall_hell_ossuary = 50,
      --
      gtd_wall_high_gap_set = 25,
      gtd_wall_high_gap_alt_set = 25,
      --
      gtd_generic_half_floor = 20,
      gtd_generic_half_floor_no_trim = 20,
      gtd_generic_half_floor_inverted_braced = 20,
      --
      gtd_woodframe = 15,
      gtd_woodframe_green = 15,
      gtd_woodframe_alt = 15,
      gtd_woodframe_alt_green = 15,
      --
      gtd_round_inset = 50,
      --
      gtd_generic_ceilwall = 30,
      gtd_generic_ceilwall_2 = 30,
      gtd_generic_ceilwall_3 = 30,
      gtd_generic_ceilwall_silver_frame = 30,
      gtd_generic_ceilwall_double_silver_frame = 30,
      --
      gtd_generic_glow_wall = 30,
      gtd_generic_double_banded_ceil = 30,
      --
      gtd_wall_hell_vaults = 50,
      gtd_wall_hell_vaults_ftex = 50,
      --
      gtd_generic_frame_light_band = 50,
      gtd_generic_frame_metal = 50,
      --
      gtd_generic_d64_1x = 10,
      gtd_generic_d64_1x_yellow = 10,
      gtd_generic_d64_1x_blue = 10,
      gtd_generic_d64_2x = 10,
      gtd_generic_d64_2x_yellow = 10,
      gtd_generic_d64_2x_blue = 10,
      --
      gtd_generic_tek_grate = 25,
      gtd_generic_tek_grate_bottom_slope = 25,
      gtd_generic_tek_grate_xit_machine = 25,
      --
      gtd_generic_artsy_bedazzled = 20,
      gtd_generic_alt_colors = 20,
      gtd_generic_mid_band = 20,
      gtd_generic_artsy_center_braced_hell = 20,
      gtd_generic_artsy_step1_banded = 20,
      gtd_generic_artsy_slope_y_inset = 20,
      gtd_generic_artsy_base_braced = 20,
      gtd_generic_artsy_sloped_bump = 20,
      gtd_generic_small_lite = 20,
      gtd_generic_artsy_lite_box = 20,
      gtd_generic_artsy_chequered = 20,
      --
      gtd_ind_modwall_1 = 20,
      gtd_ind_modwall_2 = 20,
      gtd_ind_modwall_3 = 20,
      --
      gtd_greywall_1 = 25,
      gtd_greytall_trim = 25,
      --
      gtd_modquake_set = 11,
      gtd_modquake_jawlike = 11,
      gtd_modquake_top_heavy_brace = 11,
      gtd_modquake_tek_slope_brace = 11,
      gtd_modquake_ex_light_slope_brace = 11,
      gtd_modquake_round_braced_lit_pillar = 11,
      gtd_modquake_hexagon_inset_braced = 11,
      --
      gtd_wall_candalebra = 12,
      gtd_wall_blue_torch = 12,
      gtd_wall_green_torch = 12,
      gtd_wall_red_torch = 12,
      --
      gtd_wall_hell_mindscrew = 25,
      gtd_wall_hell_mindscrew_skywall = 25,
      --
      gtd_gothic_ceilwall_arch = 18,
      gtd_gothic_ceilwall_doublet_arch = 18,
      gtd_gothic_ceilwall_braced_arch = 18,
      gtd_gothic_ceilwall_xzibit_arch = 18,
      gtd_gothic_ceilwall_inner_framed_arch = 18,
      --
      gtd_sunderfall = 25,
      gtd_sunderfall_barred = 25,
      --
      gtd_door_storage = 15
    },

    outdoor_wall_groups =
    {
      PLAIN = 2,
      tech_o_caution_strip = 1,
      tech_o_orange_light_stack = 1,
      tech_o_lite_strip_white = 0.5,
      tech_o_lite_strip_blue = 0.5,
      tech_o_inset_teklite = 0.5,
      tech_o_inset_teklite2 = 0.5,
      tech_o_halfbase_green_light = 0.5,
      tech_o_halfbase_blue_triangle = 0.5,
      tech_o_giant_UAC_sign = 1,
      tech_o_double_hanging_vents = 1,
      tech_o_overhanging_braced_vent = 1,
      tech_o_overhanging_lite_platform = 1,
      tech_o_pipe_junctions = 1,
      tech_o_hadleys_hope = 1,
      tech_o_overhanging_lights = 1,
      tech_o_shiny_silver_overhang = 1,
      tech_o_silver_scaffolding = 1,
      tech_o_concrete_base = 1,
      tech_o_fence_lights_uac_thing = 1,
      tech_o_hex_inset = 1,
      tech_o_grated_greenwall = 1,
      tech_o_everyone_likes_sewers = 1,
      tech_o_red_wall = 0.5,
      tech_o_blue_wall = 0.5,
      tech_o_lots_of_cement = 1,
      tech_o_tekgren_grates_thing = 1,
      tech_o_black_mesa_overlook = 1,
      tech_o_compblue_tall = 1,
      tech_o_grey_metal_sloped = 1,
      tech_o_tall_light = 0.5,
      tech_o_tall_light_alt = 0.5,
      tech_o_hexagon_uac_spotlights = 1,
      tech_o_orange_oct_white_binding = 1
    },

    fences =
    {
      METAL1   = 90,
      BROVINE  = 60,
      STONE3   = 40,
      STONE2   = 40,
      BROVINE2 = 30,
      GRAY1    = 20,
      ICKWALL3 = 20,
    },

    sink_style =
    {
      curved = 1,
      sharp = 1,
    },

    skyboxes =
    {
      Skybox_generic = 50,
      Skybox_garrett_hell = 50,
    },

    beam_groups =
    {
      beam_gothic = 50,
      beam_shiny = 25,
      beam_quakeish = 50,
      beam_lights = 25,
      beam_lights_white = 25,
      beam_lights_vertical_tech = 25,
      beam_lights_vertical_hell = 25,
      beam_textured = 50,
    },

   -- This is because of the slow Hellification of the Deimos base, hence a few Hell wall prefabs are here.
    wall_groups =
    {
      low_gap = 7,
      mid_band = 5,
      lite2 = 5,
      torches1 = 5,
      torches2 = 5,
      torches3 = 3,
      torches6 = 10,
      torches7 = 50,
      torches8 = 10,
      torches11 = 15,
      runes1 = 1,
      runes2 = 1,
      runes3 = 1,
      runes4 = 1,
      runes5 = 1,
      cross1 = 1,
      cross2 = 3,
      cross3 = 1,
      cross4 = 1,
      cross5 = 3,
      mid_band_hell = 1,
      gtd_wall_urban_storage = 20,
      gtd_wall_tech_top_corner_light_set = 30,
      gtd_wall_server_room = 30,
      gtd_wall_sewer = 10,
      gtd_generic_beamed_inset = 10,
      gtd_computers = 45,
      gtd_writhing_mass = 4,
      gtd_wall_octagon_insets = 25,
      gtd_wall_grated_machines = 20,
      gtd_wall_quakish_insets = 25,
      gtd_ribbed_lights = 15,
      gtd_wall_high_gap_set = 8,
      gtd_wall_high_gap_alt_set = 8,
      gtd_generic_half_floor = 15,
      gtd_wall_urban_cement_frame = 10,
      gtd_generic_ceilwall = 25,
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 50,
      gappy = 50,
      fence_tech_lit = 50,
      fence_gothic = 50,
    },

    fence_posts =
    {
      Post_metal = 50,
      Post_tech_1 = 40,
      Post_tech_2 = 40,
      Post_gothic_blue = 10,
      Post_gothic_green = 10,
      Post_gothic_red = 10,
      Post_gothic_blue_2 = 10,
      Post_gothic_green_2 = 10,
      Post_gothic_red_2 = 10,
    },

    -- Copied from the Tech theme and altered a bit.
    window_groups =
    {
      square = 70,
      tall   = 90,
      grate  = 40,
      barred = 5,
      round  = 10,
      supertall = 70,
      gtd_window_cage_highbars = 20,
      gtd_window_cage_lowbars = 10,
      gtd_window_full_open = 15,
      gtd_window_full_open_tall = 15,
      gtd_window_bay = 20,
      gtd_window_absurdly_open = 40,
      gtd_window_quakeish = 20,
      gtd_window_low = 10,
      gtd_window_weabdows = 20,
      gtd_window_metal_frames = 20,
      gtd_window_construction_frames = 20,
    },

    ceil_light_prob = 65,

    style_list =
    {
      caves = { none=60, few=40 },
      outdoors = { few=40, some=70, heaps=10 },
      big_rooms = { none=40, few=35, some=15, heaps=5 },
      hallways = { none=15, few=45, some=20, heaps=10 },
      windows = { few=15, some=85, heaps=40 },
      pictures = { few=20, some=75, heaps=45 },
      liquids = { none=60, few=30, some=12, heaps=5 },
      doors = { few=25, some=75, heaps=30 },
      teleporters = { none=55, few=40, some=15, heaps=3 },
      keys = { none=15, few=60, some=70, heaps=40 },
      trikeys = { few=40, some=80, heaps=20 },
      switches = { none=20, few=65, some=50, heaps=15 },
      secrets = { few=12, some=80, heaps=30 },
      symmetry = { none=50, few=50, some=50, heaps=50 },
      steepness = { few=40, some=80, heaps=35 },
      scenics = { few=20, some=50, heaps=85},
      cages = { none=55, few=35, some=10, heaps=5 },
      traps = { few=40, some=60, heaps=30 },
      barrels = { few=10, some=55, heaps=30 },
      ambushes = { few=20, some=95, heaps=30 },
      beams  = { none=10, few=15, some=40, heaps=5 },
      porches = { none=15, few=20, some=80, heaps=45 },
      fences = { none=10, few=20, some=80, heaps=30 },
    },

    scenic_fences =
    {
      MIDGRATE = 50,
      MIDBRN1  = 10,
    },
  },


---- Episode 3 ----

  hell =
  {
    --  Water is seen in a few locations in episode 3 -Reisal

    liquids =
    {
      lava   = 90,
      blood  = 30,
      water  = 10,
      nukage = 5,
    },

    entity_remap =
    {
      k_red    = "ks_red",
      k_blue   = "ks_blue",
      k_yellow = "ks_yellow",
    },

    facades =
    {
      STONE2 = 10,
      STONE3 = 15,
      WOOD1 = 50,
      GSTONE1 = 50,
      MARBLE1 = 30,
      BROWN1 = 5,
      BROWNGRN = 5,
      WOOD5 = 30,
      SP_HOT1 = 15,
      SKINMET1 = 10,
      SKINMET2 = 10,
      SKINTEK1 = 10,
      SKINTEK2 = 10,
      STONE = 5,
    },

    fences =
    {
      WOOD5 = 50,
      WOOD3 = 50,
      STONE3 = 40,
      STONE2 = 35,
      MARBLE2 = 30,
      GSTONE1 = 30,
      ASHWALL = 20,
      SKIN2   = 20,
      SKINFACE = 20,
      FIREBLU1 = 20,
      ICKWALL3 = 15,
    },

    prefab_remap =
    {
      DOORBLU  = "DOORBLU2",
      DOORRED  = "DOORRED2",
      DOORYEL  = "DOORYEL2",

      BIGDOOR1 = "BIGDOOR6",
      BIGDOOR2 = "BIGDOOR7",
      BIGDOOR3 = "BIGDOOR7",
      BIGDOOR4 = "BIGDOOR5",

      SW1COMP  = "SW1LION",
      SW1PIPE  = "SW1BROWN",
      SILVER3  = "MARBFACE",
    },

    floor_sinks =
    {
      liquid_plain = 10,
      liquid_blood = 10,
      floor_skulls = 20,
      floor_glowingrock = 10,
      floor_snakes = 5,
      floor_red = 5,
      liquid_firelava = 5,
      liquid_ash = 4,
      liquid_marble = 4,
    },

    ceiling_sinks =
    {
      sky_metal = 20,
      sky_plain = 20,
      light_diamond = 10,
      light_hell_red = 20,
      light_hell_lava = 5,
      ceil_redash = 5,
      ceil_hotrock = 5,
      ceil_hotrock2 = 5,
      ceil_blood = 7,
      ceil_sprock = 4,
      ceil_water = 4,
      ceil_icky = 10,
      sky_hell_10 = 3,
      sky_hell_11 = 3,
      sky_hell_12 = 3,
      sky_hell_13 = 3,
    },

    street_sinks =
    {
      floor_default_streets = 1,
    },

    beam_groups =
    {
      beam_gothic = 50,
      beam_quakeish = 50,
      beam_lights_vertical_hell = 50,
      beam_wood = 50,
      beam_textured = 50,
    },

    wall_groups =
    {
      torches2 = 30, --red
      torches3 = 30, --blue
      torches1 = 30, --green
      torches6 = 10, --candelabra
      torches8 = 10, --evil eye
      torches10 = 7, --skull rock
      --
      lowhell1 = 16,
      lowhell2 = 16,
      lowhell3 = 16,
      --
      runes1 = 10,
      runes2 = 10,
      runes3 = 10,
      runes4 = 10,
      runes5 = 10,
      --
      cross1 = 7, --7
      cross2 = 15, --15
      cross3 = 7, --7
      cross4 = 10, --5
      cross5 = 15, --10
      --
      mid_band_hell = 25,
      --
      gtd_wall_hell_bloodgutters = 25,
      gtd_wall_tech_top_corner_light_set = 50,
      --
      gtd_generic_beamed_inset = 35,
      gtd_generic_beamed_brown_inset = 35,
      --
      gtd_writhing_mass = 50,
      gtd_library = 50,
      --
      gtd_furnace = 20,
      gtd_furnace_face = 20,
      gtd_furnace_water = 20,
      --
      gtd_wall_marbface = 50,
      gtd_wall_quakish_insets = 50,
      gtd_wall_hell_ossuary = 50,
      --
      gtd_wall_high_gap_set = 25,
      gtd_wall_high_gap_alt_set = 25,
      --
      gtd_generic_half_floor = 20,
      gtd_generic_half_floor_no_trim = 20,
      gtd_generic_half_floor_inverted_braced = 20,
      --
      gtd_woodframe = 15,
      gtd_woodframe_green = 15,
      gtd_woodframe_alt = 15,
      gtd_woodframe_alt_green = 15,
      --
      gtd_round_inset = 50,
      --
      gtd_generic_ceilwall = 30,
      gtd_generic_ceilwall_2 = 30,
      gtd_generic_ceilwall_3 = 30,
      gtd_generic_ceilwall_silver_frame = 30,
      gtd_generic_ceilwall_double_silver_frame = 30,
      --
      gtd_generic_glow_wall = 30,
      gtd_generic_double_banded_ceil = 30,
      --
      gtd_wall_hell_vaults = 50,
      gtd_wall_hell_vaults_ftex = 50,
      --
      gtd_generic_frame_light_band = 50,
      gtd_generic_frame_metal = 50,
      --
      gtd_generic_d64_1x = 10,
      gtd_generic_d64_1x_yellow = 10,
      gtd_generic_d64_1x_blue = 10,
      gtd_generic_d64_2x = 10,
      gtd_generic_d64_2x_yellow = 10,
      gtd_generic_d64_2x_blue = 10,
      --
      gtd_generic_tek_grate = 25,
      gtd_generic_tek_grate_bottom_slope = 25,
      gtd_generic_tek_grate_xit_machine = 25,
      --
      gtd_generic_artsy_bedazzled = 20,
      gtd_generic_alt_colors = 20,
      gtd_generic_mid_band = 20,
      gtd_generic_artsy_center_braced_hell = 20,
      gtd_generic_artsy_step1_banded = 20,
      gtd_generic_artsy_slope_y_inset = 20,
      gtd_generic_artsy_base_braced = 20,
      gtd_generic_artsy_sloped_bump = 20,
      gtd_generic_small_lite = 20,
      gtd_generic_artsy_lite_box = 20,
      gtd_generic_artsy_chequered = 20,
      --
      gtd_ind_modwall_1 = 20,
      gtd_ind_modwall_2 = 20,
      gtd_ind_modwall_3 = 20,
      --
      gtd_greywall_1 = 25,
      gtd_greytall_trim = 25,
      --
      gtd_modquake_set = 11,
      gtd_modquake_jawlike = 11,
      gtd_modquake_top_heavy_brace = 11,
      gtd_modquake_tek_slope_brace = 11,
      gtd_modquake_ex_light_slope_brace = 11,
      gtd_modquake_round_braced_lit_pillar = 11,
      gtd_modquake_hexagon_inset_braced = 11,
      --
      gtd_wall_candalebra = 12,
      gtd_wall_blue_torch = 12,
      gtd_wall_green_torch = 12,
      gtd_wall_red_torch = 12,
      --
      gtd_wall_hell_mindscrew = 25,
      gtd_wall_hell_mindscrew_skywall = 25,
      --
      gtd_gothic_ceilwall_arch = 18,
      gtd_gothic_ceilwall_doublet_arch = 18,
      gtd_gothic_ceilwall_braced_arch = 18,
      gtd_gothic_ceilwall_xzibit_arch = 18,
      gtd_gothic_ceilwall_inner_framed_arch = 18,
      --
      gtd_sunderfall = 25,
      gtd_sunderfall_barred = 25,
    },

    outdoor_wall_groups =
    {
      PLAIN = 2,
      hell_o_stone_brace = 1,
      hell_o_wood_brace = 1,
      hell_o_metal_framed_skin = 1,
      hell_o_caged_up_corpses = 1,
      hell_o_giant_stone_faces = 1,
      hell_o_rising_spfaces = 1,
      hell_o_lava_falls = 1,
      hell_o_huge_overhang = 1,
      hell_o_spiny_overhang = 1,
      hell_o_red_glass_tall = 1,
      hell_o_rising_energy = 1,
      hell_o_wooden_palisades = 1,
      hell_o_flying_alcoves = 1,
      hell_o_torch_fenced = 1,
      hell_o_dark_banners = 1,
      hell_o_dark_cathedral_windows = 1,
      hell_o_extruded_arch = 1,
      hell_o_egyptish_triwindows = 1,
      hell_o_destroyed_city_facade = 1,
      hell_o_alt_cathedral_windows = 1,
      hell_o_wood_panel_red_banners = 1,
      hell_o_pencil_arch = 1,
      hell_o_hereticish_arch = 1,
      hell_o_gothic_skin_red = 1,
      hell_o_marb_icon_bfalls = 1,
      hell_o_egyptish = 1,
      hell_o_blood_ocatgon = 1,
      hell_o_catamet = 1,
      hell_o_crematorium_windows = 1,
      hell_o_orange_arch_window = 1,
      hell_o_marble_gargle_stone_pyramid = 1,
      hell_o_round_red_window = 0.65,
      hell_o_round_red_window_greened = 0.65,
      hell_o_stone_braced_red_skull_window = 1
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 50,
      gappy = 25,
      fence_gothic = 50,
    },

    fence_posts =
    {
      Post_metal = 25,
      Post_gothic_blue = 10,
      Post_gothic_green = 10,
      Post_gothic_red = 15,
      Post_gothic_blue_2 = 10,
      Post_gothic_green_2 = 10,
      Post_gothic_red_2 = 15,
    },

    window_groups =
    {
      round  = 80, --80,
      tall   = 65, --65,
      barred = 20, --20,
      grate  = 40, --40,
      square = 30, --30,
      supertall = 60,
      gtd_window_cage_highbars = 20,
      gtd_window_cage_lowbars = 20,
      gtd_window_cage_hell = 50,
      gtd_window_arched = 50,
      gtd_window_arched_tall = 50,
      gtd_window_full_open = 30,
      gtd_window_full_open_tall = 30,
      gtd_window_absurdly_open = 40,
      gtd_window_quakeish = 20,
      gtd_window_low = 25,
      gtd_window_arrowslit = 40,
      gtd_window_metal_frames = 40,
      gtd_window_construction_frames = 35,
    },

    cave_torches =
    {
      red_torch   = 50,
      green_torch = 50,
      blue_torch  = 50,
      blue_torch_sm = 15,
      green_torch_sm = 15,
      red_torch_sm = 15,

      candelabra = 15,
      skull_rock = 15,
      skull_cairn = 20,
      evil_eye   = 10,
    },

    outdoor_torches =
    {
      blue_torch = 70,
      red_torch  = 70,
      green_torch = 70,
      candelabra = 30,
      skull_rock = 30,
      blue_torch_sm = 15,
      red_torch_sm  = 15,
      green_torch_sm = 15,
    },

    passable_decor =
    {
      gibs = 70,
      gibbed_player = 30,
      dead_player = 40,
      dead_zombie = 2,
      dead_shooter = 2,
      dead_imp = 1,
      dead_demon = 1,
      dead_caco  = 1,
    },

    park_decor =
    {
      burnt_tree = 95,
      brown_stub = 55,
      big_tree = 40,
      evil_eye   = 15,
      skull_rock = 10,
      skull_cairn = 15,
      skull_pole = 10,
      skull_kebab = 10,
      green_pillar = 5,
      green_column  = 5,
      green_column_hrt = 3,
      red_pillar = 5,
      red_column = 5,
      red_column_skl = 3,
    },

    style_list =
    {
      doors = { none=15, few=30, some=65, heaps=25 },
      outdoors = { none=10, few=35, some=60, heaps=15 },
      steepness = { few=35, some=70, heaps=30 },
      pictures = { few=50, some=50, heaps=70 },
      big_rooms = { none=25, few=60, some=15, heaps=10 },
      big_outdoor_rooms = { none=5, few=50, some=80, heaps=25},
      ambushes = { none=10, few=15, some=55, heaps=35 },
      hallways = { none=20, few=60, some=15, heaps=5 },
      teleporters = { none=15, few=25, some=60, heaps=10 },
      keys = { none=15, few=40, some=60, heaps=25 },
      trikeys = { none=10, few=40, some=70, heaps=35 },
      liquids = { none=20, few=45, some=25, heaps=15 },
      traps = { few=20, some=70, heaps=40 },
      switches = { none=25, few=60, some=35, heaps=10 },
      cages    = { none=15, few=25, some=65, heaps=10 },
      symmetry = { none=55, few=25, some=40, heaps=20 },
      secrets = { few=65, some=40, heaps=10 },
      caves = { none=60, few=35, some=8, heaps=3 },
      barrels = { none=45, few=15, some=5, heaps=4 },
      fences = { none=30, few=20, some=90, heaps=40 },
      porches = { none=10, few=40, some=30, heaps=75 },
      beams = { none=15, few=40, some=20, heaps=5 },
    },

    monster_prefs =
    {
      zombie  = 0.5,
      shooter = 0.75,
      imp     = 1.5,
      demon   = 1.3,
      spectre = 1.3,
      skull   = 2.0,
      Cyberdemon = 1.25,
      Mastermind = 1.5,
    },

    scenic_fences =
    {
      MIDBRN1 = 3,
      MIDGRATE = 12,
    },

    sink_style =
    {
      sharp = 0.1,
      curved = 1,
    },

    skyboxes =
    {
      Skybox_garrett_hell = 50,
    },

    ceil_light_prob = 35,
  },


---- Episode 4 ----

-- Thy Flesh Consumed by Reisal
-- Basically a modified version of "hell" to match id's E4 better

  flesh =
  {
    liquids =
    {
      blood  = 60,
      lava   = 30,
      water  = 20,
      nukage = 10,
    },

    entity_remap =
    {
      k_red    = "ks_red",
      k_blue   = "ks_blue",
      k_yellow = "ks_yellow",
    },

    facades =
    {
      STONE2 = 20,
      STONE3 = 15,
      WOOD1 = 50,
      GSTONE1 = 30,
      MARBLE1 = 20,
      BROWN1 = 10,
      BROWNGRN = 10,
      WOOD5 = 40,
      SP_HOT1 = 5,
      SKINMET1 = 10,
      SKINMET2 = 10,
    },

    fences =
    {
     WOOD5 = 50,
     WOOD3 = 50,
     STONE = 50,
     STONE3 = 50,
     ICKWALL3 = 30,
     BROVINE = 30,
     ASHWALL = 30,
     SKIN2 = 20,
     SKINFACE = 20,
    },

    prefab_remap =
    {
      DOORBLU  = "DOORBLU2",
      DOORRED  = "DOORRED2",
      DOORYEL  = "DOORYEL2",

      BIGDOOR1 = "BIGDOOR6",
      BIGDOOR2 = "BIGDOOR7",
      BIGDOOR3 = "BIGDOOR7",
      BIGDOOR4 = "BIGDOOR5",

      SW1COMP  = "SW1GARG",
      SW1PIPE  = "SW1BROWN",
      SILVER3  = "STONGARG",
    },

    floor_sinks =
    {
      liquid_plain = 10,
      liquid_blood = 10,
      floor_skulls = 15,
      floor_glowingrock = 10,
      floor_snakes = 5,
      liquid_firelava = 5,
      floor_snakes2 = 5,
    },

    ceiling_sinks =
    {
      sky_metal = 20,
      sky_plain = 20,
      light_diamond = 10,
      light_hell_red = 20,
      light_hell_lava = 5,
      ceil_redash = 5,
      sky_urban_1 = 5,
      sky_urban_3 = 4,
      sky_hell_2 = 4,
      sky_hell_9 = 3,
      light_side4 = 3,
      ceil_vdark2 = 6,
      ceil_icky = 5,
      ceil_water = 4,
      ceil_blood = 4,
      ceil_sprock = 3,
      sky_hell_13 = 3,
      sky_hell_14 = 4,
      sky_hell_15 = 4,
    },

    street_sinks =
    {
      floor_default_streets = 1,
    },

    beam_groups =
    {
      beam_gothic = 50,
      beam_quakeish = 50,
      beam_lights_white = 25,
      beam_lights_vertical_tech = 25,
      beam_lights_vertical_hell = 50,
      beam_wood = 80,
      beam_textured = 50,
    },

    wall_groups =
    {
      torches2 = 30, --red
      torches3 = 30, --blue
      torches1 = 30, --green
      torches6 = 10, --candelabra
      torches8 = 10, --evil eye
      torches10 = 7, --skull rock
      --
      lowhell1 = 16,
      lowhell2 = 16,
      lowhell3 = 16,
      --
      runes1 = 10,
      runes2 = 10,
      runes3 = 10,
      runes4 = 10,
      runes5 = 10,
      --
      cross1 = 7, --7
      cross2 = 15, --15
      cross3 = 7, --7
      cross4 = 10, --5
      cross5 = 15, --10
      --
      mid_band_hell = 25,
      --
      gtd_wall_hell_bloodgutters = 25,
      gtd_wall_tech_top_corner_light_set = 50,
      --
      gtd_generic_beamed_inset = 35,
      gtd_generic_beamed_brown_inset = 35,
      --
      gtd_writhing_mass = 50,
      gtd_library = 50,
      --
      gtd_furnace = 20,
      gtd_furnace_face = 20,
      gtd_furnace_water = 20,
      --
      gtd_wall_marbface = 50,
      gtd_wall_quakish_insets = 50,
      gtd_wall_hell_ossuary = 50,
      --
      gtd_wall_high_gap_set = 25,
      gtd_wall_high_gap_alt_set = 25,
      --
      gtd_generic_half_floor = 20,
      gtd_generic_half_floor_no_trim = 20,
      gtd_generic_half_floor_inverted_braced = 20,
      --
      gtd_woodframe = 15,
      gtd_woodframe_green = 15,
      gtd_woodframe_alt = 15,
      gtd_woodframe_alt_green = 15,
      --
      gtd_round_inset = 50,
      --
      gtd_generic_ceilwall = 30,
      gtd_generic_ceilwall_2 = 30,
      gtd_generic_ceilwall_3 = 30,
      gtd_generic_ceilwall_silver_frame = 30,
      gtd_generic_ceilwall_double_silver_frame = 30,
      --
      gtd_generic_glow_wall = 30,
      gtd_generic_double_banded_ceil = 30,
      --
      gtd_wall_hell_vaults = 50,
      gtd_wall_hell_vaults_ftex = 50,
      --
      gtd_generic_frame_light_band = 50,
      gtd_generic_frame_metal = 50,
      --
      gtd_generic_d64_1x = 10,
      gtd_generic_d64_1x_yellow = 10,
      gtd_generic_d64_1x_blue = 10,
      gtd_generic_d64_2x = 10,
      gtd_generic_d64_2x_yellow = 10,
      gtd_generic_d64_2x_blue = 10,
      --
      gtd_generic_tek_grate = 25,
      gtd_generic_tek_grate_bottom_slope = 25,
      gtd_generic_tek_grate_xit_machine = 25,
      --
      gtd_generic_artsy_bedazzled = 20,
      gtd_generic_alt_colors = 20,
      gtd_generic_mid_band = 20,
      gtd_generic_artsy_center_braced_hell = 20,
      gtd_generic_artsy_step1_banded = 20,
      gtd_generic_artsy_slope_y_inset = 20,
      gtd_generic_artsy_base_braced = 20,
      gtd_generic_artsy_sloped_bump = 20,
      gtd_generic_small_lite = 20,
      gtd_generic_artsy_lite_box = 20,
      gtd_generic_artsy_chequered = 20,
      --
      gtd_ind_modwall_1 = 20,
      gtd_ind_modwall_2 = 20,
      gtd_ind_modwall_3 = 20,
      --
      gtd_greywall_1 = 25,
      gtd_greytall_trim = 25,
      --
      gtd_modquake_set = 11,
      gtd_modquake_jawlike = 11,
      gtd_modquake_top_heavy_brace = 11,
      gtd_modquake_tek_slope_brace = 11,
      gtd_modquake_ex_light_slope_brace = 11,
      gtd_modquake_round_braced_lit_pillar = 11,
      gtd_modquake_hexagon_inset_braced = 11,
      --
      gtd_wall_candalebra = 12,
      gtd_wall_blue_torch = 12,
      gtd_wall_green_torch = 12,
      gtd_wall_red_torch = 12,
      --
      gtd_wall_hell_mindscrew = 25,
      gtd_wall_hell_mindscrew_skywall = 25,
      --
      gtd_gothic_ceilwall_arch = 18,
      gtd_gothic_ceilwall_doublet_arch = 18,
      gtd_gothic_ceilwall_braced_arch = 18,
      gtd_gothic_ceilwall_xzibit_arch = 18,
      gtd_gothic_ceilwall_inner_framed_arch = 18,
      --
      gtd_sunderfall = 25,
      gtd_sunderfall_barred = 25,
    },

    outdoor_wall_groups =
    {
      PLAIN = 2,
      hell_o_stone_brace = 1,
      hell_o_wood_brace = 1,
      hell_o_metal_framed_skin = 1,
      hell_o_caged_up_corpses = 1,
      hell_o_giant_stone_faces = 1,
      hell_o_rising_spfaces = 1,
      hell_o_lava_falls = 1,
      hell_o_huge_overhang = 1,
      hell_o_spiny_overhang = 1,
      hell_o_red_glass_tall = 1,
      hell_o_rising_energy = 1,
      hell_o_wooden_palisades = 1,
      hell_o_flying_alcoves = 1,
      hell_o_torch_fenced = 1,
      hell_o_dark_banners = 1,
      hell_o_dark_cathedral_windows = 1,
      hell_o_extruded_arch = 1,
      hell_o_egyptish_triwindows = 1,
      hell_o_destroyed_city_facade = 1,
      hell_o_alt_cathedral_windows = 1,
      hell_o_wood_panel_red_banners = 1,
      hell_o_pencil_arch = 1,
      hell_o_hereticish_arch = 1,
      hell_o_gothic_skin_red = 1,
      hell_o_marb_icon_bfalls = 1,
      hell_o_egyptish = 1,
      hell_o_blood_ocatgon = 1,
      hell_o_catamet = 1,
      hell_o_crematorium_windows = 1,
      hell_o_orange_arch_window = 1,
      hell_o_marble_gargle_stone_pyramid = 1,
      hell_o_round_red_window = 0.65,
      hell_o_round_red_window_greened = 0.65,
      hell_o_stone_braced_red_skull_window = 1
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 50,
      fence_gothic = 50,
    },

    fence_posts =
    {
      Post_metal = 50,
      Post_tech_1 = 20,
      Post_tech_2 = 20,
      Post_gothic_blue = 20,
      Post_gothic_green = 20,
      Post_gothic_red = 20,
      Post_gothic_blue_2 = 20,
      Post_gothic_green_2 = 20,
      Post_gothic_red_2 = 20,
    },

    passable_decor =
    {
      gibs = 70,
      gibbed_player = 30,
      dead_player = 40,
      dead_zombie = 2,
      dead_shooter = 2,
      dead_imp = 1,
      dead_demon = 1,
      dead_caco  = 1,
    },

    park_decor =
    {
      burnt_tree = 95,
      brown_stub = 55,
      big_tree = 45,
      evil_eye   = 7,
      skull_rock = 5,
      skull_cairn = 7,
      skull_pole = 5,
      skull_kebab = 5,
      green_pillar = 3,
      green_column  = 3,
      green_column_hrt = 2,
      red_pillar = 3,
      red_column = 3,
      red_column_skl = 2,
    },

    monster_prefs =
    {
      zombie  = 0.8,
      shooter = 1.25,
      imp     = 2.0,
      demon   = 1.1,
      spectre = 1.1,
      skull   = 0.7,
      Cyberdemon = 1.5,
      Mastermind = 1.5,
    },

    window_groups =
    {
      round  = 20,
      tall   = 90,
      barred = 15,
      grate  = 25,
      square = 50,
      supertall = 75,
      gtd_window_cage_highbars = 30,
      gtd_window_cage_lowbars = 20,
      gtd_window_cage_hell = 40,
      gtd_window_arched = 60,
      gtd_window_arched_tall = 60,
      gtd_window_full_open = 30,
      gtd_window_full_open_tall = 30,
      gtd_window_absurdly_open = 30,
      gtd_window_low = 20,
      gtd_window_arrowslit = 40,
      gtd_window_weabdows = 15,
      gtd_window_metal_frames = 30,
      gtd_window_construction_frames = 30,
    },

    style_list =
    {
      doors = { none=10, few=30, some=65, heaps=20 },
      outdoors = { none=10, few=35, some=60, heaps=15 },
      steepness = { few=25, some=75, heaps=30 },
      pictures = { few=30, some=50, heaps=70 },
      big_rooms = { none=25, few=40, some=15, heaps=10 },
      ambushes = { few=5, some=25, heaps=65 },
      hallways = { none=20, few=60, some=15, heaps=5 },
      teleporters = { none=15, few=25, some=60, heaps=10 },
      keys = { none=15, few=40, some=60, heaps=25 },
      trikeys  = { none=10, few=40, some=85, heaps=20 },
      liquids = { none=20, few=45, some=25, heaps=15 },
      traps = { few=20, some=40, heaps=80 },
      switches = { none=25, few=60, some=35, heaps=10 },
      cages    = { none=15, few=25, some=65, heaps=10 },
      symmetry = { none=55, few=25, some=40, heaps=20 },
      secrets = { few=45, some=40, heaps=10 },
      scenics = { few=15, some=60, heaps=80},
      caves = { none=60, few=35, some=8, heaps=3 },
      barrels = { none=45, few=15, some=5, heaps=4 },
      beams = { none=10, few=40, some=50, heaps=15 },
      porches = { few=10, some=60, heaps=80 },
      fences = { none=5, few=20, some=80, heaps=40 },
    },

    scenic_fences =
    {
      MIDGRATE = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 1,
    },

    skyboxes =
    {
      Skybox_garrett_city = 50,
      Skybox_hellish_city = 50,
    },

    ceil_light_prob = 45,
  },
}



ULTDOOM.ROOM_THEMES =
{
  -- this ensures the following room themes REPLACE those of Doom 2.
  replace_all = true,


-----  GENERIC STUFF  ------------------------------

  any_vent_Hallway =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRAY1 = 50,
    },

    floors =
    {
      FLAT1 = 30,
    },

    ceilings =
    {
      CEIL3_5 = 30,
    },
  },

  -- For Limit-Removing/generics - Dasho
  any_deuce_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 1,

    walls =
    {
      GRAY1 = 50,
    },

    floors =
    {
      FLAT1 = 30,
    },

    ceilings =
    {
      CEIL3_5 = 30,
    },
  },


------ EPISODE 1 : Tech Bases ----------------------

  tech_Room =
  {
    env  = "building",
    prob = 90,

    walls =
    {
      STARTAN3 = 25,
      STARTAN2 = 12,
      STARTAN1 = 5,
      STARG1 = 5,
      STARG2 = 15,
      STARG3 = 15,
      STARBR2 = 5,
      STARGR2 = 10,
      METAL1 = 2,
    },

    floors =
    {
      FLOOR0_1 = 30,
      FLOOR0_2 = 20,
      FLOOR0_3 = 30,
      FLOOR0_7 = 20,
      FLOOR3_3 = 15,
      FLOOR7_1 = 10,
      FLOOR4_5 = 30,
      FLOOR4_6 = 20,
      FLOOR4_8 = 50,
      FLOOR5_1 = 35,
      FLOOR5_2 = 30,
      FLAT1 = 10,
      FLAT5 = 20,
      FLAT14 = 20,
      FLAT5_4 = 15,
    },

    ceilings =
    {
      CEIL5_1 = 20,
      CEIL3_3 = 15,
      CEIL3_5 = 50,
      FLAT1 = 20,
      FLAT4 = 15,
      FLAT18 = 20,
      FLOOR0_2 = 10,
      FLOOR4_1 = 30,
      FLOOR5_1 = 15,
      FLOOR5_4 = 10,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
    },
  },


  tech_Brown =
  {
    env  = "building",
    prob = 70,

    walls =
    {
      BROWN1 = 30,
      BROWNGRN = 20,
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
    },
  },


  tech_Computer =
  {
    env = "building",
    prob = 25,

    walls =
    {
      COMPSPAN = 30,
      COMPOHSO = 10,
      COMPTILE = 15,
      COMPBLUE = 15,
      TEKWALL4 = 3,
    },

    floors =
    {
      FLAT14 = 50,
      FLOOR1_1 = 15,
      FLAT4 = 10,
      CEIL4_1 = 20,
      CEIL4_2 = 20,
      CEIL5_1 = 20,
    },

    ceilings =
    {
      CEIL5_1 = 50,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
    },
  },

  tech_Shiny =
  {
    env = "building",
    prob = 15,

    walls =
    {
      SHAWN2 = 50,
      METAL1 = 5,
    },

    floors =
    {
      FLOOR4_8 = 10,
      FLAT14 = 10,
      FLOOR1_1 = 5,
      FLAT23 = 60,
    },

    ceilings =
    {
      FLAT23 = 50,
    },
  },


  tech_Gray =
  {
    env = "building",
    prob = 40,

    walls =
    {
      GRAY1 = 50,
      GRAY4 = 30,
      GRAY7 = 30,
      ICKWALL1 = 40,
      ICKWALL3 = 20,
    },

    floors =
    {
      FLAT4 = 50,
      FLOOR0_3 = 30,
      FLAT5_4 = 25,
      FLAT19 = 15,
      FLAT1 = 15,
      FLOOR0_5 = 10,
    },

    ceilings =
    {
      FLAT19 = 40,
      FLAT5_4 = 20,
      FLAT4  = 20,
      FLAT23 = 10,
      FLAT1 = 10,
    },
  },

  tech_metro_Hallway =
  {
    env   = "hallway",
    group = "metro",
    prob  = 25,

    walls =
    {
      BROWN1 = 50,
      SHAWN2 = 50,
      STARTAN3 = 50,
      STARG3 = 50,
      BROWNGRN = 50,
      BROWN96 = 50,
      GSTONE1 = 50,
      SP_HOT1 = 50,
    },

    floors =
    {
      FLAT1 = 50,
      FLAT4 = 50,
      FLAT19 = 50,
      FLAT20 = 50,
      FLAT3 = 50,
      FLAT5 = 50,
      FLOOR0_1 = 50,
      FLOOR0_2 = 50,
      FLOOR0_3 = 50,
      FLOOR1_1 = 50,
      FLOOR1_6 = 50,
      FLOOR3_3 = 50,
      FLOOR4_1 = 50,
      FLOOR4_5 = 50,
      FLOOR4_6 = 50,
      FLOOR4_8 = 50,
      FLOOR5_3 = 50,
    },

    ceilings =
    {
      CEIL3_2 = 50,
      CEIL3_3 = 50,
      CEIL3_5 = 50,
      FLAT1 = 50,
      FLAT18 = 50,
      FLAT19 = 50,
      FLAT20 = 50,
      FLAT3 = 50,
      FLOOR3_3 = 50,
      FLOOR4_1 = 50,
      FLOOR4_6 = 50,
      FLOOR4_8 = 50,
      FLOOR5_3 = 50,
      FLOOR5_4 = 50,
    },
  },


  tech_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      BROWN1 = 33,
      BROWNGRN = 50,
      STARBR2 = 15,
      STARTAN3 = 30,
      STARG3 = 30,
      TEKWALL4 = 5,
    },

    floors =
    {
      FLOOR0_1 = 30,
      FLOOR0_2 = 20,
      FLOOR0_3 = 30,
      FLOOR0_7 = 20,
      FLOOR3_3 = 15,
      FLOOR7_1 = 15,
      FLOOR4_5 = 30,
      FLOOR4_6 = 20,
      FLOOR4_8 = 30,
      FLOOR5_1 = 35,
      FLOOR5_2 = 30,
      FLAT1 = 10,
      FLAT4 = 20,
      FLAT5 = 20,
      FLAT9 = 5,
      FLAT14 = 20,
      FLAT5_4 = 20,
      CEIL5_1 = 30,
      CEIL4_1 = 10,
      CEIL4_2 = 10,
    },

    ceilings =
    {
      FLAT4 = 20,
      CEIL5_1 = 35,
      CEIL3_5 = 50,
      CEIL3_3 = 20,
      FLAT19 = 20,
      FLAT23 = 20,
      FLAT5_4 = 15,
      CEIL4_1 = 20,
      CEIL4_2 = 20,
    },
  },


  tech_Cave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {
      ASHWALL = 30,
      SP_ROCK1 = 60,
      BROWNHUG = 20,
    },

    floors =
    {
      ASHWALL = 30,
      SP_ROCK1 = 60,
      FLOOR7_1 = 20,
    },
  },


  tech_Outdoors =
  {
    env = "outdoor",
    prob = 50,

    floors =
    {
      BROWN144 = 30,
      BROWN1 = 20,
      STONE = 20,
      ASHWALL = 5,
      FLAT10 = 5,
    },

    naturals =
    {
      ASHWALL = 35,
      SP_ROCK1 = 70,
      GRAYVINE = 20,
      STONE = 30,
    },

    porch_floors =
    {
      FLAT1 = 10,
      CEIL5_2 = 10,
      FLAT19 = 5,
      FLAT3 = 10,
      FLOOR0_5 = 10,
      FLOOR5_3 = 10,
      FLOOR5_4 = 10,
      FLOOR7_1 = 10,
    },
  },


------ EPISODE 2 ------------------------------

  deimos_Room =
  {
    env = "building",
    prob = 70,

    walls =
    {
      STARTAN3 = 10,
      STARTAN2 = 5,
      STARTAN1 = 5,
      STARG2 = 15,
      ICKWALL1 = 15,
      STARBR2 = 15,
      STARGR2 = 10,
      STARG1 = 5,
      STARG2 = 5,
      STARG3 = 7,
      ICKWALL3 = 30,
      GRAY7 = 20,
      GRAY5 = 15,
      GRAY1 = 15,
      BROWN1 = 5,
      BROWNGRN = 10,
      BROWN96 = 5,
      STONE2 = 30,
      STONE3 = 20,
    },

    floors =
    {
      FLOOR0_1 = 30,
      FLOOR0_2 = 40,
      FLOOR0_3 = 30,
      CEIL4_1 = 5,
      FLOOR0_7 = 10,
      FLOOR3_3 = 20,
      FLOOR7_1 = 20,
      CEIL4_2 = 10,
      FLOOR4_1 = 30,
      FLOOR4_6 = 20,
      FLOOR4_8 = 50,
      FLOOR5_2 = 35,
      FLAT1 = 40,
      FLAT5 = 30,
      FLAT14 = 10,
      FLAT1_1 = 30,
      FLOOR1_6 = 3,
      FLAT1_2 = 30,
      FLOOR5_1 = 50,
      FLAT3 = 15,
      FLAT5_4 = 15,
    },

    ceilings =
    {
      CEIL5_1 = 30,
      CEIL3_3 = 70,
      CEIL3_5 = 50,
      CEIL4_1 = 10,
      CEIL4_2 = 10,
      FLAT1 = 30,
      FLAT4 = 20,
      FLAT19 = 30,
      FLAT8 = 15,
      FLAT5_4 = 20,
      FLOOR0_2 = 20,
      FLOOR4_1 = 50,
      FLOOR5_1 = 50,
      FLOOR5_4 = 10,
    },
  },


  deimos_Hellish =
  {
    env = "building",
    prob = 50,

    walls =
    {
      MARBLE1 = 15,
      MARBLE2 = 15,
      MARBLE3 = 15,
      BROWNGRN = 15,
      COMPTILE = 15,
      BROWN1 = 15,
      STARTAN3 = 15,
      STARG3 = 15,
      WOOD1 = 15,
      WOOD3 = 15,
      WOOD5 = 15,
      BROVINE = 15,
      BROVINE2 = 15,
      ICKWALL3 = 15,
      GRAY7 = 15,
    },

    floors =
    {
      DEM1_5 = 30,
      DEM1_6 = 50,
      FLAT10 = 5,
      FLOOR7_1 = 5,
      FLOOR7_2 = 50,
      FLOOR4_1 = 30,
      FLOOR4_6 = 20,
      FLOOR4_8 = 50,
      FLOOR5_2 = 35,
      FLAT1 = 40,
      FLAT5 = 30,
      FLAT14 = 10,
    },

    ceilings =
    {
      FLOOR7_2 = 50,
      DEM1_5 = 50,
      DEM1_6 = 30,
      FLOOR6_2 = 5,
      CEIL5_1 = 30,
      CEIL3_3 = 50,
      CEIL3_5 = 30,
      CEIL4_1 = 10,
      CEIL4_2 = 10,
    },
  },


  deimos_Lab =
  {
    env = "building",
    prob = 15,

    walls =
    {
      COMPTILE = 40,
      COMPBLUE = 10,
      COMPSPAN = 15,
      METAL1 = 20,
    },

    floors =
    {
      FLOOR4_8 = 15,
      FLOOR5_1 = 15,
      FLAT14 = 40,
      FLOOR1_1 = 30,
      CEIL4_2 = 20,
      CEIL4_1 = 20,
    },

    ceilings =
    {
      CEIL5_1 = 30,
      CEIL4_1 = 10,
      CEIL4_2 = 15,
      FLOOR4_8 = 15,
      FLAT14 = 10,
    },
  },

  deimos_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      BROWN1 = 33,
      BROWNGRN = 50,
      BROVINE = 20,
      BROVINE2 = 15,
      GRAY1 = 50,
      GRAY5 = 33,
      ICKWALL1 = 30,
      ICKWALL3 = 30,
      STONE2 = 40,
      STONE3 = 50,
      METAL1 = 30,
    },

    floors =
    {
      FLAT4 = 30,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      FLAT14 = 20,
      FLAT5_4 = 20,
      FLOOR3_3 = 30,
      FLOOR4_8 = 40,
      FLOOR5_1 = 25,
      FLOOR5_2 = 10,
      FLAT5 = 20,
      FLOOR1_6 = 4,
      FLOOR7_2 = 3,
      FLAT5_1 = 3,
      FLAT5_2 = 3,
      DEM1_5 = 3,
      DEM1_6 = 3,
    },

    ceilings =
    {
      FLAT4 = 20,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      CEIL3_5 = 25,
      CEIL3_3 = 50,
      FLAT18 = 15,
      FLAT19 = 20,
      FLAT5_4 = 10,
      FLOOR4_8 = 25,
      FLOOR5_1 = 20,
      FLOOR7_1 = 15,
      FLOOR7_2 = 2,
      FLAT5_1 = 2,
      FLAT5_2 = 2,
      DEM1_5 = 2,
      DEM1_6 = 2,
    },
  },

  deimos_Hallway_hell =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      MARBLE1 = 20,
      MARBLE2 = 20,
      MARBLE3 = 20,
      GSTONE1 = 20,
      BROVINE = 20,
      COMPTILE = 20,
    },

    floors =
    {
      FLAT4 = 30,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      FLAT14 = 20,
      FLAT5_4 = 20,
      FLOOR3_3 = 30,
      FLOOR4_8 = 40,
      FLOOR5_1 = 25,
      FLOOR5_2 = 10,
      FLAT5 = 20,
      FLOOR1_6 = 4,
      FLOOR7_2 = 15,
      FLAT5_1 = 15,
      FLAT5_2 = 15,
      DEM1_5 = 15,
      DEM1_6 = 15,
    },

    ceilings =
    {
      FLAT4 = 20,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      CEIL3_5 = 25,
      CEIL3_3 = 20,
      FLAT18 = 15,
      FLAT19 = 20,
      FLAT5_4 = 10,
      FLOOR4_8 = 15,
      FLOOR5_1 = 20,
      FLOOR7_1 = 15,
      FLOOR7_2 = 15,
      FLAT5_1 = 15,
      FLAT5_2 = 15,
      DEM1_5 = 15,
      DEM1_6 = 15,
    },
  },


  deimos_Cave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {
      SP_ROCK1 = 90,
      ASHWALL = 20,
      BROWNHUG = 15,
      GRAYVINE = 10,
    },

    floors =
    {
      SP_ROCK1 = 90,
      ASHWALL = 20,
      BROWNHUG = 15,
      GRAYVINE = 10,
    },
  },


  deimos_Outdoors =
  {
    env = "outdoor",
    prob = 50,

--Makes sense for high prob for SP_ROCK1 because the intermission screen shows
--Deimos has a desolate, gray ground.
    floors =
    {
      BROWN144 = 30,
      BROWN1 = 10,
      STONE = 10,
    },

    naturals =
    {
      SP_ROCK1 = 60,
      ASHWALL = 2,
      FLAT10 = 3,
    },

    porch_floors =
    {
      CEIL5_2 = 10,
      FLAT1 = 10,
      FLAT5_3 = 10,
      FLAT5_4 = 10,
      FLAT5_5 = 10,
      FLAT8 = 10,
      FLOOR0_5 = 10,
      FLOOR4_6 = 10,
      DEM1_5 = 20,
      FLOOR7_2 = 20,
      DEM1_6 = 20,
      FLAT1_1 = 5,
      FLAT1_2 = 5,
      MFLR8_1 = 10,
    },
  },

  deimos_metro_Hallway =
  {
    env   = "hallway",
    group = "metro",
    prob  = 25,

    walls =
    {
      BROWN1 = 50,
      SHAWN2 = 50,
      STARTAN3 = 50,
      STARG3 = 50,
      BROWNGRN = 50,
      BROWN96 = 50,
      ICKWALL3 = 50,
      ICKWALL1 = 50,
      BROVINE = 50,
      BROVINE2 = 50,
    },

    floors =
    {
      FLAT1 = 50,
      FLAT4 = 50,
      FLAT19 = 50,
      FLAT20 = 50,
      FLAT3 = 50,
      FLAT5 = 50,
      FLOOR0_1 = 50,
      FLOOR0_2 = 50,
      FLOOR0_3 = 50,
      FLOOR1_1 = 50,
      FLOOR1_6 = 50,
      FLOOR3_3 = 50,
      FLOOR4_1 = 50,
      FLOOR4_5 = 50,
      FLOOR4_6 = 50,
      FLOOR4_8 = 50,
      FLOOR5_3 = 50,
    },

    ceilings =
    {
      CEIL3_2 = 50,
      CEIL3_3 = 50,
      CEIL3_5 = 50,
      FLAT1 = 50,
      FLAT18 = 50,
      FLAT19 = 50,
      FLAT20 = 50,
      FLAT3 = 50,
      FLOOR3_3 = 50,
      FLOOR4_1 = 50,
      FLOOR4_6 = 50,
      FLOOR4_8 = 50,
      FLOOR5_3 = 50,
      FLOOR5_4 = 50,
    },
  },


----- EPISODE 3 : Hell ---------------------------

  hell_Marble =
  {
    env = "building",
    prob = 90,

    walls =
    {
      MARBLE1 = 30,
      MARBLE2 = 15,
      MARBLE3 = 20,
      GSTVINE1 = 20,
      GSTVINE2 = 20,
      SKINMET1 = 3,
      SKINMET2 = 3,
      SKINTEK1 = 5,
      SKINTEK2 = 5,
    },

    floors =
    {
      DEM1_5 = 30,
      DEM1_6 = 30,
      FLAT5_7 = 10,
      FLAT5_8 = 5,
      FLAT10 = 10,
      FLOOR7_1 = 10,
      FLOOR7_2 = 30,
      FLAT1 = 10,
      FLAT5 = 5,
      FLAT8 = 5,
      FLOOR5_2 = 10,
    },

    ceilings =
    {
      FLAT1 = 10,
      FLAT10 = 10,
      FLAT5_5 = 5,
      FLOOR7_2 = 30,
      DEM1_5 = 30,
      DEM1_6 = 30,
      FLOOR6_2 = 5,
      FLAT5_1 = 5,
      FLAT5_2 = 5,
      CEIL1_1 = 5,
    },
  },


  hell_Wood =
  {
    env = "building",
    prob = 45,

    walls =
    {
      WOOD1 = 50,
      WOOD3 = 30,
      WOOD5 = 20,
    },

    floors =
    {
      FLAT5_1 = 30,
      FLAT5_2 = 50,
      FLAT5_5 = 15,
    },

    ceilings =
    {
      CEIL1_1 = 50,
      FLAT5_2 = 30,
      FLAT5_1 = 15,
    },
  },


  hell_Skin =
  {
    env = "building",
    prob = 25,

    walls =
    {
      SKIN2 = 15,
      SKINFACE = 20,
      SKSNAKE2 = 20,
      SKINTEK1 = 10,
      SKINTEK2 = 10,
      SKINMET1 = 50,
      SKINMET2 = 40,
      SKINCUT = 10,
      SKINSYMB = 5,
    },

    floors =
    {
      SFLR6_1 = 10,
      FLOOR7_1 = 20,
      FLAT5_5 = 10,
      FLOOR6_1 = 40,
      MFLR8_2 = 10,
      MFLR8_4 = 10,
    },

    ceilings =
    {
      SFLR6_1 = 30,
      SFLR6_4 = 10,
      FLOOR6_1 = 20,
      FLAT5_2 = 5,
    },
  },


  hell_Hot =
  {
    env = "building",
    prob = 60,

    walls =
    {
      SP_HOT1 = 70,
      GSTVINE1 = 15,
      GSTVINE2 = 15,
      STONE = 10,
      STONE3 = 5,
      SKINMET2 = 5,
      BROWN1 = 2,
      SKINCUT = 2,
      SKINTEK1 = 5,
      SKINTEK2 = 5,
    },

    floors =
    {
      FLAT5_7 = 10,
      FLAT5_8 = 10,
      FLAT10 = 10,
      FLAT5_3 = 30,
      FLOOR7_1 = 15,
      FLAT1 = 10,
      FLOOR5_2 = 10,
      FLOOR6_1 = 35,
      FLAT8 = 15,
      FLAT5 = 15,
      FLAT5_1 = 5,
      FLAT5_2 = 5,
    },

    ceilings =
    {
      FLAT1 = 15,
      FLOOR6_1 = 30,
      FLOOR6_2 = 15,
      FLAT10 = 10,
      FLAT8 = 5,
      FLAT5_3 = 20,
      FLAT5_1 = 5,
      FLAT5_2 = 5,
      CEIL1_1 = 5,
    },
  },

  hell_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      FIREBLU1 = 50,
      FIREWALL = 50,
      SKSPINE2 = 50,
      SKIN2    = 50,
      SKINSYMB = 50,
      MARBGRAY = 50,
    },

    floors =
    {
      BLOOD1 = 50,
      FLAT4 = 30,
      CEIL4_1 = 15,
      CEIL5_1 = 30,
      FLAT14 = 20,
      FLAT5_4 = 20,
      FLOOR5_2 = 10,
      FLAT5 = 20,
      FLOOR7_2 = 3,
      FLAT5_2 = 3,
      DEM1_5 = 3,
      DEM1_6 = 3,
    },

    ceilings =
    {
      BLOOD1 = 50,
      LAVA1 = 20,
      FLAT4 = 20,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      CEIL3_3 = 50,
      FLAT19 = 20,
      FLAT5_4 = 10,
      FLOOR7_1 = 2,
      FLAT5_1 = 2,
      DEM1_6 = 2,
    },

    y_offsets =
    {
      SKSPINE2 = 13,
      SKINSYMB = 30,
      MARBGRAY = 24,
    },
  },


  hell_Outdoors =
  {
    env = "outdoor",
    prob = 50,

    floors =
    {
      ASHWALL = 30,
      FLAT5_4 = 5,
      FLAT10 = 20,
      FLOOR6_1 = 40,
      SFLR6_1 = 10,
      SFLR6_4 = 10,
      MFLR8_2 = 15,
      MFLR8_4 = 10,
      FLAT5_2 = 5,
      FLAT5 = 5,
    },

    naturals =
    {
      ASHWALL = 50,
      GRAYVINE = 20,
      SP_ROCK1 = 50,
      ROCKRED1 = 90,
      SKSNAKE1 = 10,
      SKSNAKE2 = 10,
    },

    porch_floors =
    {
      CEIL5_2 = 10,
      DEM1_5 = 30,
      DEM1_6 = 30,
      FLAT1_1 = 10,
      FLAT1_2 = 10,
      FLAT5_1 = 20,
      FLAT5_2 = 20,
      FLAT5_3 = 10,
      FLAT5_5 = 10,
      FLOOR0_2 = 10,
      FLOOR4_6 = 10,
      FLOOR7_1 = 10,
      FLOOR7_2 = 30,
    },
  },


  hell_Outdoors_hot =
  {
    env = "outdoor",
    prob = 50,

    floors =
    {
      FLAT5_6 = 5,
      ASHWALL = 10,
      FLAT10 = 20,
      DEM1_5 = 15,
      DEM1_6 = 15,
      FLOOR7_2 = 20,
      FLOOR7_1 = 15,
      SFLR6_1 = 10,
      SFLR6_4 = 15,
      MFLR8_2 = 10,
      FLAT5_2 = 5,
    },

    naturals =
    {
      ASHWALL = 30,
      GRAYVINE = 15,
      SP_ROCK1 = 50,
      ROCKRED1 = 90,
      SKSNAKE1 = 10,
      SKSNAKE2 = 10,
      FIREBLU1 = 70,
    },

    porch_floors =
    {
      CEIL3_5 = 10,
      CEIL5_2 = 10,
      FLAT1_1 = 10,
      FLAT1_2 = 10,
      FLAT5_3 = 5,
      FLAT5_3 = 10,
    },
  },


  hell_Cave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {
      ROCKRED1 = 90,
      SKIN2 = 30,
      SKINFACE = 25,
      SKSNAKE1 = 35,
      SKSNAKE2 = 35,
      FIREBLU1 = 50,
      FIRELAVA = 50,
      ASHWALL  = 20,
    },

    floors =
    {
      ROCKRED1 = 90,
      SKIN2 = 30,
      SKINFACE = 25,
      SKSNAKE1 = 35,
      SKSNAKE2 = 35,
      FIREBLU1 = 50,
      FIRELAVA = 50,
      ASHWALL  = 20,
    },
  },

  hell_metro_Hallway =
  {
    env   = "hallway",
    group = "metro",
    prob  = 12,

    walls =
    {
      BROWN1 = 50,
      WOOD1 = 50,
      MARBLE1 = 50,
      FIREBLU1 = 50,
      ASHWALL = 50,
      METAL = 50,
      BROWNHUG = 50,
    },

    floors =
    {
      FLOOR7_1 = 50,
      FLOOR7_2 = 50,
      FLOOR5_4 = 50,
      MFLR8_1 = 50,
      MFLR8_2 = 50,
      MFLR8_3 = 50,
      MFLR8_4 = 50,
      FLAT5_1 = 50,
      FLAT5_2 = 50,
      FLAT1_1 = 50,
      FLAT1_2 = 50,
      DEM1_5 = 50,
      DEM1_6 = 50,
    },

    ceilings =
    {
      CEIL3_5 = 50,
      LAVA1 = 50,
      FLOOR6_1 = 50,
      FLOOR6_2 = 50,
      FLOOR7_1 = 50,
      FLOOR7_2 = 50,
      FLAT5_3 = 50,
      FLAT5_4 = 50,
      FLAT5_5 = 50,
      FLAT5_6 = 50,
      FLAT5_7 = 50,
      FLAT5_8 = 50,
      FLAT1_1 = 50,
      FLAT1_2 = 50,
      DEM1_5 = 50,
      DEM1_6 = 50,
      CEIL3_2 = 50,
      CEIL3_5 = 50,
    },
  },



----- EPISODE 4 -------------------------------

  flesh_Room =
  {
    env = "building",
    prob = 110,

    walls =
    {
      BROWNGRN = 20,
      BROVINE2 = 15,
      WOOD5 = 10,
      GSTONE1 = 20,
      STONE = 10,
      STONE2 = 5,
      STONE3 = 10,
    },

    floors =
    {
      DEM1_5 = 10,
      DEM1_6 = 10,
      FLAT5_5 = 10,
      FLAT5_7 = 7,
      FLAT5_8 = 7,
      FLAT10 = 12,
      FLOOR7_1 = 10,
      FLOOR7_2 = 10,
      FLOOR5_2 = 10,
      FLOOR5_3 = 10,
      FLOOR5_4 = 10,
      FLAT5 = 10,
      FLAT8 = 10,
      SFLR6_1 = 5,
      SFLR6_4 = 5,
      MFLR8_1 = 5,
      MFLR8_2 = 10,
    },

    ceilings =
    {
      FLAT1 = 10,
      FLAT10 = 10,
      FLAT5_5 = 10,
      FLOOR7_2 = 15,
      DEM1_6 = 10,
      FLOOR6_1 = 10,
      FLOOR6_2 = 10,
      MFLR8_1 = 12,
      FLAT5_4 = 10,
      SFLR6_1 = 5,
      SFLR6_4 = 5,
      CEIL1_1 = 10,
      FLAT5_1 = 5,
      FLAT5_2 = 5,
      FLAT8 = 8,
    },
  },


  flesh_Wood =
  {
    env = "building",
    prob = 80,

    walls =
    {
      WOOD1 = 70,
      WOOD3 = 50,
      WOOD5 = 40,
      SKINMET1 = 15,
      SKINMET2 = 15,
      SKINTEK1 = 6,
      SKINTEK2 = 6,
    },

    floors =
    {
      FLAT5_1 = 30,
      FLAT5_2 = 50,
      FLAT5_5 = 15,
      FLAT5 = 7,
      FLAT8 = 7,
    },

    ceilings =
    {
      CEIL1_1 = 50,
      FLAT5_2 = 30,
      FLAT5_1 = 15,
      FLOOR7_1 = 10,
    },
  },


  flesh_Marble =
  {
    env = "building",
    prob = 40,

    walls =
    {
      MARBLE1 = 50,
      MARBLE2 = 25,
      MARBLE3 = 20,
    },

    floors =
    {
      DEM1_5 = 30,
      DEM1_6 = 50,
      FLAT10 = 5,
      FLOOR7_1 = 5,
      FLOOR7_2 = 50,
    },

    ceilings =
    {
      FLOOR7_2 = 50,
      DEM1_5 = 50,
      DEM1_6 = 50,
      FLOOR6_2 = 5,
    },
  },


  -- andrewj: this is a straight copy of deimos_Hallway_hell

  flesh_Hallway_hell =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      MARBLE1 = 20,
      MARBLE2 = 20,
      MARBLE3 = 20,
      GSTONE1 = 20,
      BROVINE = 20,
      COMPTILE = 20,
    },

    floors =
    {
      FLAT4 = 30,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      FLAT14 = 20,
      FLAT5_4 = 20,
      FLOOR3_3 = 30,
      FLOOR4_8 = 40,
      FLOOR5_1 = 25,
      FLOOR5_2 = 10,
      FLAT5 = 20,
      FLOOR1_6 = 4,
      FLOOR7_2 = 15,
      FLAT5_1 = 15,
      FLAT5_2 = 15,
      DEM1_5 = 15,
      DEM1_6 = 15,
    },

    ceilings =
    {
      FLAT4 = 20,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      CEIL3_5 = 25,
      CEIL3_3 = 20,
      FLAT18 = 15,
      FLAT19 = 20,
      FLAT5_4 = 10,
      FLOOR4_8 = 15,
      FLOOR5_1 = 20,
      FLOOR7_1 = 15,
      FLOOR7_2 = 15,
      FLAT5_1 = 15,
      FLAT5_2 = 15,
      DEM1_5 = 15,
      DEM1_6 = 15,
    },
  },


  flesh_Cave =
  {
    env = "cave",
    prob = 50,

    walls =
    {
      ROCKRED1 = 70,
      SP_ROCK1 = 50,
      BROWNHUG = 15,
      SKIN2 = 10,
      SKINFACE = 20,
      SKSNAKE1 = 5,
      SKSNAKE2 = 5,
      FIREBLU1 = 10,
      FIRELAVA = 10,
    },

    floors =
    {
      ROCKRED1 = 70,
      SP_ROCK1 = 50,
      BROWNHUG = 15,
      SKIN2 = 10,
      SKINFACE = 20,
      SKSNAKE1 = 5,
      SKSNAKE2 = 5,
      FIREBLU1 = 10,
      FIRELAVA = 10,
    },
  },


  flesh_Outdoors =
  {
    env = "outdoor",
    prob = 50,

    floors =
    {
      ASHWALL = 12,
      FLAT1_1 = 15,
      FLAT5_4 = 10,
      FLAT10 = 20,
      FLAT5_7 = 10,
      FLAT5_8 = 10,
      MFLR8_4 = 10,
      FLOOR7_1 = 15,
      SFLR6_1 = 8,
      SFLR6_4 = 8,
      FLAT5 = 7,
      MFLR8_2 = 5,
      FLAT1_1 = 10,
      FLAT1_2 = 10,
      MFLR8_3 = 10,
      FLAT5_2 = 20,
    },

    naturals =
    {
      ASHWALL = 30,
      GRAYVINE = 20,
      SP_ROCK1 = 70,
      ROCKRED1 = 70,
      BROWNHUG = 20,
      SKSNAKE1 = 10,
      SKSNAKE2 = 10,
    },

    porch_floors =
    {
      CEIL1_1 = 50,
      FLAT5_1 = 50,
      FLAT5_2 = 50,

      FLOOR7_1 = 30,
      FLAT8 = 20,
      FLOOR0_2 = 20,

      DEM1_5 = 10,
      DEM1_6 = 10,
      FLOOR7_2 = 10,
    },
  },

  flesh_metro_Hallway =
  {
    env   = "hallway",
    group = "metro",
    prob  = 20,

    walls =
    {
      BROWN1 = 50,
      WOOD1 = 50,
      WOOD3 = 50,
      WOOD5 = 50,
      WOODMET1 = 50,
      BIGDOOR5 = 50,
    },

    floors =
    {
      FLAT5_1 = 50,
      FLAT5_2 = 50,
      FLOOR7_1 = 50,
    },

    ceilings =
    {
      FLAT5_1 = 50,
      FLAT5_2 = 50,
      CEIL1_1 = 50,
      FLOOR7_1 = 50,
    },
  },


}


--------------------------------------------------------------------

ULTDOOM.EPISODES =
{
  episode1 =
  {
    ep_index = 1,

    theme = "tech",
    sky_patch = "SKY1",
    dark_prob = 10,

    name_patch = "M_EPI1",
    description = "Knee-Deep in the Dead",
    bex_end_name = "E1TEXT",
  },

  episode2 =
  {
    ep_index = 2,

    theme = "deimos",
    sky_patch = "SKY2",
    dark_prob = 40,

    name_patch = "M_EPI2",
    description = "The Shores of Hell",
    bex_end_name = "E2TEXT",
  },

  episode3 =
  {
    ep_index = 3,

    theme = "hell",
    sky_patch = "SKY3",
    dark_prob = 10,

    name_patch = "M_EPI3",
    description = "Inferno",
    bex_end_name = "E3TEXT",
  },

  episode4 =
  {
    ep_index = 4,

    theme = "flesh",
    sky_patch = "SKY4",
    dark_prob = 10,

    name_patch = "M_EPI4",
    description  = "Thy Flesh Consumed",
    bex_end_name = "E4TEXT",
  },
}


ULTDOOM.PREBUILT_LEVELS =
{
  E1M8 =
  {
    { prob=50,  file="games/doom/data/boss1/anomaly1.wad", map="E1M8" },
    { prob=50,  file="games/doom/data/boss1/anomaly2.wad", map="E1M8" },
    { prob=100, file="games/doom/data/boss1/anomaly3.wad", map="E1M8" },
    { prob=50,  file="games/doom/data/boss1/ult_anomaly.wad",  map="E1M8" },
    { prob=100, file="games/doom/data/boss1/ult_anomaly2.wad", map="E1M8" },
  },

  E2M8 =
  {
    { prob=40,  file="games/doom/data/boss1/tower1.wad", map="E2M8" },
    { prob=60,  file="games/doom/data/boss1/tower2.wad", map="E2M8" },
    { prob=100, file="games/doom/data/boss1/ult_tower.wad", map="E2M8" },
  },

  E3M8 =
  {
    { prob=50,  file="games/doom/data/boss1/dis1.wad", map="E3M8" },
    { prob=100, file="games/doom/data/boss1/ult_dis.wad", map="E3M8" },
  },

  E4M6 =
  {
    { prob=50, file="games/doom/data/boss1/tower1.wad", map="E2M8" },
  },

  E4M8 =
  {
    { prob=50, file="games/doom/data/boss1/dis1.wad", map="E3M8" },
  },
}

function ULTDOOM.get_levels()
  local EP_MAX  = sel(OB_CONFIG.game   == "ultdoom", 4, 3)
  local EP_NUM  = sel(OB_CONFIG.length == "game", EP_MAX, 1)

  local MAP_LEN_TAB = { single=1, few=4 }

  local MAP_NUM = MAP_LEN_TAB[OB_CONFIG.length] or 9

  -- this accounts for last two levels are BOSS and SECRET level
  local LEV_MAX = MAP_NUM
  if LEV_MAX == 9 then LEV_MAX = 7 end

  -- create episode info...

  for ep_index = 1,4 do
    local ep_info = GAME.EPISODES["episode" .. ep_index]
    assert(ep_info)

    local EPI = table.copy(ep_info)

    EPI.levels = { }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  current_map = 1

  for ep_index = 1,EP_NUM do
    local EPI = GAME.episodes[ep_index]

    for map = 1,MAP_NUM do
      local ep_along = map / MAP_NUM

      local LEV =
      {
        episode = EPI,

        name  = string.format("E%dM%d",   ep_index,   map),
        patch = string.format("WILV%d%d", ep_index-1, map-1),

        ep_along = ep_along,
        game_along = (ep_index - 1 + ep_along) / EP_NUM
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

      LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

      if map == 9 then
        LEV.is_secret = true
      end

      -- prebuilt levels
      if PARAM.bool_prebuilt_levels == 1 then
        LEV.prebuilt = GAME.PREBUILT_LEVELS[LEV.name]
      end

      if LEV.prebuilt then
        LEV.name_class = LEV.prebuilt.name_class or "BOSS"
      end

      -- procedural gotcha management code

      -- Prebuilts are to exist over procedural gotchas
      -- this means procedural gotchas will not override
      -- Icon of Sin for example if prebuilts are still on
      if not LEV.prebuilt then

        --handling for the Final Only option
        if PARAM.gotcha_frequency == "final" then
          if OB_CONFIG.length == "single" then
            if current_map == 1 then LEV.is_procedural_gotcha = true end
          elseif OB_CONFIG.length == "few" then
            if current_map == 4 then LEV.is_procedural_gotcha = true end
          elseif OB_CONFIG.length == "episode" then
            if current_map == 8 then LEV.is_procedural_gotcha = true end
          elseif OB_CONFIG.length == "game" then
            if current_map == 35 then LEV.is_procedural_gotcha = true end
          end
        end
  
        if PARAM.gotcha_frequency == "epi" then
          if current_map == ep_index * 9 - 1 then
            LEV.is_procedural_gotcha = true
          end
        end
        if PARAM.gotcha_frequency == "2epi" then
          if current_map == ep_index * 9 - 1 or current_map == ep_index * 9 - 5 then
            LEV.is_procedural_gotcha = true
          end
        end
        if PARAM.gotcha_frequency == "3epi" then
          if current_map == ep_index * 9 - 1 or current_map == ep_index * 9 - 4 or current_map == ep_index * 9 - 7 then
            LEV.is_procedural_gotcha = true
          end
        end
        if PARAM.gotcha_frequency == "4epi" then
          if current_map == ep_index * 9 - 1 or current_map == ep_index * 9 - 3 or current_map == ep_index * 9 - 5 or current_map == ep_index * 9 - 7 then
            LEV.is_procedural_gotcha = true
          end
        end
  
        --5% of maps after map 4,
        if PARAM.gotcha_frequency == "5p" then
          if current_map > 4 and current_map % 9 ~= 0 then
            if rand.odds(5) then LEV.is_procedural_gotcha = true end
          end
        end
  
        -- 10% of maps after map 4,
        if PARAM.gotcha_frequency == "10p" then
          if current_map > 4 and current_map % 9 ~= 0 then
            if rand.odds(10) then LEV.is_procedural_gotcha = true end
          end
        end
  
        -- for masochists... or debug testing
        if PARAM.gotcha_frequency == "all" then
          LEV.is_procedural_gotcha = true
        end
      end
  
      -- handling for street mode
      -- actual handling for urban percentages are done
      if PARAM.float_streets_mode then
        if not LEV.is_procedural_gotcha or not LEV.prebuilt then
          if rand.odds(PARAM.float_streets_mode) then
            LEV.has_streets = true
          end
        end
      end
  
      if not LEV.prebuilt then
        -- nature mode
        if PARAM.float_nature_mode then
          if rand.odds(PARAM.float_nature_mode) then
            if LEV.has_streets then
              if rand.odds(50) then
                LEV.has_streets = false
                LEV.is_nature = true
              end
            else
              LEV.is_nature = true
            end
          end
        end
  
      end

      if MAP_NUM == 1 or map == 3 then
        LEV.demo_lump = string.format("DEMO%d", ep_index)
      end

      current_map = current_map + 1

    end -- for map

    -- set "dist_to_end" value
    if MAP_NUM >= 9 then
      EPI.levels[7].dist_to_end = 1
      EPI.levels[6].dist_to_end = 2
      EPI.levels[5].dist_to_end = 3

    elseif MAP_NUM == 4 then
      EPI.levels[4].dist_to_end = 1
      EPI.levels[3].dist_to_end = 3
    end

  end -- for episode
end

ULTDOOM.FACTORY = {}

ULTDOOM.FACTORY.PREFABS =
{

-- Note: texture names (like STARTAN3) are never used here.
-- Instead the names here (like "beam_w") are looked-up in a
-- SKIN table.  This allows the same prefab to be used with
-- different textures (which are game-dependent).

PLAIN =
{
  scale=64,

  structure = { "." },

  elements = { },
},

PLAIN_BIG =
{
  scale=64,

  structure =
  {
    "..",
    "..",
  },
  
  elements = { },
},

SOLID =
{
  scale=64,

  structure = { "#" },

  elements = { },
},

SOLID_WIDE =
{
  scale=64,

  structure = { "##" },

  elements = { },
},

SOLID_BIG =
{
  scale=64,

  structure =
  {
    "##",
    "##",
  },

  elements = { },
},


------ Arches ------------------------------------

ARCH =
{
  structure =
  {
    "##aaaaaaaa##",
    "##aaaaaaaa##",
    "##aaaaaaaa##",
    "##aaaaaaaa##",
  },

  elements =
  {
    a = { f_h=0, c_rel="door_top", c_h=0, },
  },
},

ARCH_EDGE =
{
  copy="ARCH",

  mirror=true,

  structure =
  {
    "#aaa",
    "#aaa",
    "#aaa",
    "#aaa",
  },
},

ARCH_NARROW =
{
  copy="ARCH",

  structure =
  {
    "#aaaaaa#",
    "#aaaaaa#",
    "#aaaaaa#",
    "#aaaaaa#",
  },
},

ARCH_ARCHED =
{
  structure =
  {
    "##cbaaaabc##",
    "##cbaaaabc##",
    "##cbaaaabc##",
    "##cbaaaabc##",
  },

  elements =
  {
    a = { f_h=0, c_rel="door_top", c_h=0, },

    b = { copy="a", c_h=-16 },
    c = { copy="a", c_h=-32 },
  },
},

ARCH_HOLE1 =
{
  structure =
  {
    "##cbaaaabc##",
    "##cbaaaabc##",
    "##cbaaaabc##",
    "##cbaaaabc##",
  },

  elements =
  {
    a = { f_h=0, c_rel="door_top", c_h=0, },

    b = { copy="a", f_h=12, c_h=-12 },
    c = { copy="a", f_h=24, c_h=-24 },
  },
},

ARCH_TRUSS =
{
  structure =
  {
    "##BaaaaaaB##",
    "##CaaaaaaC##",
    "##CaaaaaaC##",
    "##BaaaaaaB##",
  },

  elements =
  {
    a = { f_h=0, c_rel="door_top", c_h=0, },

    B = { f_rel="door_top", f_h=0, c_rel="door_top", c_h=0,
          l_tex="beam_w",  f_tex="beam_c",
        },

    C = { f_h=0, c_rel="door_top", c_h=-8,
          u_tex="beam_w",  c_tex="beam_c", u_peg="top",
        }
  },
},

ARCH_RUSSIAN =
{
  structure =
  {
    "##aaaaaaaa##",
    "##BssssssB##",
    "##BssssssB##",
    "##aaaaaaaa##",
  },

  elements =
  {
    a = { f_h=0, c_rel="door_top", c_h=16, },

    s = { f_h=0, c_rel="door_top", c_h=0,
          u_tex="beam_w", c_tex="beam_c", u_peg="top"
        },

    B = { solid="beam_w" },
  },
},

ARCH_BEAMS =
{
  copy="ARCH_RUSSIAN",

  structure =
  {
    "#aaaaaaaaaa#",
    "#aaaaaaaaaa#",
    "#aBaaaaaaBa#",
    "#aaaaaaaaaa#",
  },
},

ARCH_BEAM_WIDE =
{
  copy="ARCH_BEAMS",

  structure =
  {
    "##aaaaaaaaaaaa##",
    "##aBBaaaaaaBBa##",
    "##aBBaaaaaaBBa##",
    "##aaaaaaaaaaaa##",
  },
},

ARCH_CURVY =
{
  structure =
  {
    "##aaaaaaaa##",
    "#RaaaaaaaaS#",
    "#TaaaaaaaaU#",
    "##aaaaaaaa##",
  },

  elements =
  {
    a = { f_h=0, c_rel="door_top", c_h=0, },

    R = { solid="wall", [9]={ dx= 16,dy=0 }, [3]={ dx= 20,dy=0 } },
    S = { solid="wall", [7]={ dx=-16,dy=0 }, [1]={ dx=-20,dy=0 } },

    T = { solid="wall", [3]={ dx= 16,dy=0 } },
    U = { solid="wall", [1]={ dx=-16,dy=0 } },
  },
},


ARCH_FENCE =
{
  structure =
  {
    "fed......def",
    "fed......def",
    "fed......def",
    "fed......def",
  },

  elements =
  {
    c = { f_h= 8, f_rel="floor_h" },
    d = { f_h=16, f_rel="floor_h" },

    e = { f_h=32, f_rel="floor_h",
          [4] = { impassible=true },
          [6] = { impassible=true },
        },

    f = { f_h=0, f_rel="low_h", },

    B = { f_h=16, f_rel="low_h", f_add="beam_h",
          l_tex="beam_w", f_tex="beam_f", l_peg="top"
        },
  },
},

ARCH_FENCE_NARROW =
{
  copy="ARCH_FENCE",

  structure =
  {
    "fe....ef",
    "fe....ef",
    "fe....ef",
    "fe....ef",
  },
},

ARCH_FENCE_WIDE =
{
  copy="ARCH_FENCE",

  structure =
  {
    "feddcc........ccddef",
    "feddcc........ccddef",
    "feddcc........ccddef",
    "feddcc........ccddef",
  },
},

ARCH_WIRE_FENCE =
{
  copy="ARCH_FENCE",

  structure =
  {
    "f..........f",
    "BB........BB",
    "BB........BB",
    "f..........f",
  },
},

ARCH_WIRE_FENCE_NARROW =
{
  copy="ARCH_FENCE",

  structure =
  {
    "f......f",
    "BB....BB",
    "BB....BB",
    "f......f",
  },
},

ARCH_WIRE_FENCE_WIDE =
{
  copy="ARCH_FENCE",

  structure =
  {
    "f..................f",
    "BB................BB",
    "BB................BB",
    "f..................f",
  },
},


------ Windows ------------------------------------

WINDOW_NARROW =
{
  structure =
  {
    "#ww#",
    "#ww#",
    "#ww#",
    "#ww#",
  },

  elements =
  {
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },
  }
},

WINDOW_EDGE =
{
  mirror=true,

  structure =
  {
    "#www",
    "#www",
    "#www",
    "#www",
  },

  elements =
  {
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },
  }
},

WINDOW_ARCHED =
{
  structure =
  {
    "#abwwba#",
    "#abwwba#",
    "#abwwba#",
    "#abwwba#",
  },

  elements =
  {
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },

    a = { copy="w", f_h=12, c_h=-12 },
    b = { copy="w", f_h=24, c_h=-24 },
  }
},

WINDOW_ARCHED_BIG =
{
  copy="WINDOW_ARCHED",

  structure =
  {
    "#abbwwwwbba#",
    "#abbwwwwbba#",
    "#abbwwwwbba#",
    "#abbwwwwbba#",
  },
},

WINDOW_CROSS =
{
  structure =
  {
    "#aawwaa#",
    "#aawwaa#",
    "#aawwaa#",
    "#aawwaa#",
  },

  elements =
  {
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },

    a = { f_h=-32, f_rel="mid_h", c_h=32, c_rel="mid_h" },
  }
},

WINDOW_CROSS_BIG =
{
  copy="WINDOW_CROSS",

  structure =
  {
    "#aaaawwaaaa#",
    "#aaaawwaaaa#",
    "#aaaawwaaaa#",
    "#aaaawwaaaa#",
  },
},

WINDOW_BARRED =
{
  structure =
  {
    "#wwwwwwwww##",
    "#wBwwwBwww##",
    "#wwwBwwwBw##",
    "#wwwwwwwww##",
  },

  elements =
  {
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },

    B = { solid="bar_w" },
  }
},

WINDOW_RAIL =
{
  structure =
  {
    "#wwwwwwwwww#",
    "#RRRRRRRRRR#",
    "#wwwwwwwwww#",
    "#wwwwwwwwww#",
  },

  elements =
  {
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },

    R = { copy="w", mark=1,
          [2] = { rail="rail_w", l_peg="bottom", impassible=true } },
  }
},

WINDOW_RAIL_NARROW =
{
  copy="WINDOW_RAIL",

  structure =
  {
    "#wwwwww#",
    "#RRRRRR#",
    "#wwwwww#",
    "#wwwwww#",
  },
},

------ Doors ------------------------------------

DOOR =
{
  structure =
  {
    "##ssssssss##",
    "#TddddddddT#",
    "#TddddddddT#",
    "##ssssssss##",
  },

  elements =
  {
    -- steps
    s = { f_h=8, c_rel="floor_h", c_add="door_h", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top",
        },

    -- door
    d = { f_h=8, c_rel="floor_h", c_h=8,
          f_tex="frame_f", c_tex="door_c",
          u_tex="door_w", u_peg="bottom", l_peg="bottom",
          kind="door_kind", tag="tag",
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },
  },
},

DOOR_NARROW =
{
  copy="DOOR",

  structure =
  {
    "##ssss##",
    "#TddddT#",
    "#TddddT#",
    "##ssss##",
  },
},

DOOR_SUPER_NARROW =
{
  copy="DOOR",

  structure =
  {
    "#ss#",
    "TddT",
    "TddT",
    "#ss#",
  },

  elements =
  {
    -- steps
    s = { f_h=8, c_rel="floor_h", c_add="door_h", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top",

          [1] = { dx=-12,dy=0 }, [3] = { dx=12,dy=0 },
          [7] = { dx=-12,dy=0 }, [9] = { dx=12,dy=0 },
        },

    -- door
    d = { f_h=8, c_rel="floor_h", c_h=8,
          f_tex="frame_f", c_tex="door_c",
          u_tex="door_w", u_peg="bottom", l_peg="bottom",
          kind="door_kind", tag="tag",
          [2] = { x_offset=4 }, [8] = { x_offset=4 },
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },
  }
},

DOOR_LIT =
{
  structure =
  {
    "#LssssssssM#",
    "#TddddddddT#",
    "#TddddddddT#",
    "#LssssssssM#",
  },

  elements =
  {
    -- steps
    s = { f_h=8, c_rel="floor_h", c_add="door_h", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top",
          light=224
        },

    -- door
    d = { f_h=8, c_rel="floor_h", c_h=8,
          f_tex="frame_f", c_tex="door_c", u_tex="door_w",
          u_peg="bottom", l_peg="bottom",
          kind="door_kind", tag="tag",
          light=224
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },

    -- lights
    L = { solid="wall", [6]={ l_tex="lite_w", l_peg="bottom" }},
    M = { solid="wall", [4]={ l_tex="lite_w", l_peg="bottom" }},
  },
},

DOOR_LIT_NARROW =
{
  copy="DOOR_LIT",

  structure =
  {
    "#LssssM#",
    "#TddddT#",
    "#TddddT#",
    "#LssssM#",
  },
},

DOOR_LIT_LOCKED =
{
  structure =
  {
    "KKssssssssKK",
    "KTddddddddTK",
    "KTddddddddTK",
    "KKssssssssKK",
  },

  elements =
  {
    -- steps
    s = { f_h=8, c_rel="floor_h", c_add="door_h", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top",
          light=224
        },

    -- door
    d = { f_h=8, c_rel="floor_h", c_h=8,
          f_tex="frame_f", c_tex="door_c", u_tex="door_w",
          u_peg="bottom", l_peg="bottom",
          kind="door_kind", tag="tag",
          light=224
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },

    -- key
    K = { solid="key_w" },
  },
},

DOOR_WOLFY =
{
  structure =
  {
    "#TssssssssT#",
    "#TssssssssT#",
    "#TddddddddT#",
    "#TssssssssT#",
  },

  elements =
  {
    -- step
    s = { f_h=0, c_rel="floor_h", c_add="door_h", c_h=0,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top",
        },

    -- door
    d = { f_h=0, c_rel="floor_h", c_h=0,
          f_tex="frame_f", c_tex="door_c",
          u_tex="door_w", u_peg="bottom", l_peg="bottom",
          kind="door_kind", tag="tag",

          [8] = { u_tex="back_w", u_peg="bottom" },

          [1] = { dx=0, dy=12 }, [7] = { dx=0, dy=4 },
          [3] = { dx=0, dy=12 }, [9] = { dx=0, dy=4 },
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },
  },
},


BARS_1 =
{
  structure =
  {
    "##ssssssss##",
    "##sBBssBBs##",
    "##sBBssBBs##",
    "##ssssssss##",
  },

  elements =
  {
    -- step
    s = { c_rel="door_top", c_h=0 },

    -- bars
    B = { f_rel="door_top", f_h=0, f_tex="bar_f",
          c_rel="door_top", c_h=0, c_tex="bar_f",
          u_tex="bar_w", u_peg="bottom",
          l_tex="bar_w", l_peg="bottom",

          kind="door_kind", tag="tag",
        },
  },
},

BARS_2 =
{
  copy="BARS_1",

  structure =
  {
    "##sssssssss#",
    "##sssssssss#",
    "##sBsBsBsBs#",
    "##sssssssss#",
  },
},

BARS_NARROW =
{
  copy="BARS_1",

  structure =
  {
    "#ssssss#",
    "#ssBBss#",
    "#ssBBss#",
    "#ssssss#",
  },
},

BARS_FENCE =
{
  structure =
  {
    "f..........f",
    "f.BB.BB.BB.f",
    "f.BB.BB.BB.f",
    "f..........f",
  },

  elements =
  {
    f = { f_h=0, f_rel="low_h", },

    B = { f_h=128, f_rel="floor_h",
          l_tex="beam_w", f_tex="beam_f", l_peg="top",
          kind="door_kind", tag="tag",
        },
  },
},

BARS_FENCE_DOOR =
{
  structure =
  {
    "f..........f",
    "f.DDDDDDDD.f",
    "f..........f",
    "f..........f",
  },

  elements =
  {
    f = { f_h=0, f_rel="low_h", },

    D = { f_h=128, f_rel="floor_h",
          l_tex="side_w", f_tex="door_f", l_peg="top",
          kind="door_kind", tag="tag",

          [2] = { l_tex="door_w" },
          [8] = { l_tex="door_w" },
        },
  },
},


------ Exit Stuff ------------------------------------

EXIT_DOOR =
{
  structure =
  {
    "#MssssL#",
    "#TddddT#",
    "#LssssM#",
    "##ssss##",
  },

  elements =
  {
    -- steps
    s = { f_h=8, c_rel="door_top", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top", light=224
        },

    -- door
    d = { copy="s", c_rel="floor_h", c_h=8, u_tex="door_w", c_tex = "door_c",
          kind="door_kind", tag="tag", u_peg="bottom", l_peg="bottom"
        },

    -- sign
    X = { copy="s", u_tex="exit_w", c_rel="door_top", c_h=-8,
          c_tex="exit_c", u_peg="top",
          [4] = { x_offset=32 }, [6] = { x_offset=32 },
        },

    -- front sign
    F = { solid="front_w", l_peg="bottom" },

    -- track
    T = { solid="track_w", l_peg="bottom" },

    -- light
    L = { solid="wall", l_peg="bottom",
          [4] = { l_tex="door_w", x_offset=72 },
          [6] = { l_tex="door_w", x_offset=72 }
        },

    M = { solid="wall", l_peg="bottom",
          [4] = { l_tex="door_w", x_offset=88 },
          [6] = { l_tex="door_w", x_offset=88 }
        },
  },
},

EXIT_DOOR_WIDE =
{
  copy="EXIT_DOOR",

  structure =
  {
    "###MssssL###",
    "###TddddT###",
    "###LssssM###",
    "FFFFssssFFFF",
  },
},

EXIT_DOOR_W_SIGN =
{
  copy="EXIT_DOOR",

  structure =
  {
    "##ssss##",
    "##sXXs##",
    "#MssssL#",
    "#TddddT#",
    "#LssssM#",
    "##ssss##",
    "##sXXs##",
    "##ssss##",
  },
},

EXIT_SIGN_CEIL =
{
  region="ceil",
--  environment="indoor",
--  height_range={ 80,160 },

  structure =
  {
    "....",
    "....",
    ".XX.",
    "....",
  },

  elements =
  {
    -- sign
    X = { c_h=-16, u_tex="exit_w", c_tex="exit_c", u_peg="top",
          [4] = { x_offset=32 }, [6] = { x_offset=32 },
        },
  },
},

EXIT_SIGN_FLOOR =
{
  region="floor",

  structure =
  {
    "....",
    "....",
    ".XX.",
    "....",
  },

  elements =
  {
    -- sign
    X = { f_h=16, l_tex="exit_w", f_tex="exit_c", l_peg="top",
          [4] = { x_offset=32 }, [6] = { x_offset=32 },
        },
  },
},

EXIT_HOLE_ROUND =
{
  structure =
  {
    "............",
    "............",
    "............",
    "............",
    "....jihg....",
    "....kzzf....",
    "....mzze....",
    "....abcd....",
    "............",
    "............",
    "............",
    "............",
  },

  elements =
  {
    z = { f_tex="hole_f", f_h=-16, },

    a = { copy="z",
          [1] = { dx=-12, dy=-12 }, [7] = { dx=-24, dy=-8 },
          [2] = { x_offset=336 }, [4] = { x_offset=313 },
        },
    b = { copy="z",
          [1] = { dx=-8, dy=-24 },
          [2] = { x_offset=359 },
        },
    c = { copy="z",
          [1] = { dx=  0, dy=-29 },
          [2] = { x_offset=  0 },
        },

    d = { copy="z",
          [3] = { dx=12, dy=-12 }, [1] = { dx=8, dy=-24 },
          [6] = { x_offset= 48 }, [2] = { x_offset= 25 },
        },
    e = { copy="z",
          [3] = { dx=24, dy=-8 },
          [6] = { x_offset= 71 },
        },
    f = { copy="z",
          [3] = { dx=29, dy= 0 },
          [6] = { x_offset= 96 },
        },

    g = { copy="z",
          [9] = { dx=12, dy=12 }, [3] = { dx=24, dy=8 },
          [8] = { x_offset=144 }, [6] = { x_offset=121 },
        },
    h = { copy="z",
          [9] = { dx=8, dy=24 },
          [8] = { x_offset=167 },
        },
    i = { copy="z",
          [9] = { dx= 0, dy=29 },
          [8] = { x_offset=192 },
        },

    j = { copy="z",
          [7] = { dx=-12, dy=12 }, [9] = { dx=-8, dy=24 },
          [4] = { x_offset=240 }, [8] = { x_offset=217 },
        },
    k = { copy="z",
          [7] = { dx=-24, dy=8 },
          [4] = { x_offset=263 },
        },
    m = { copy="z",
          [7] = { dx=-29, dy= 0 },
          [4] = { x_offset=288 },
        },
  },
},

EXIT_DEATHMATCH =
{
  structure =
  {
    "############",
    "##iiWWWWii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "####ssss####",
    "###TddddT###",
    "FFFFssssFFFF",
  },

  elements =
  {
    -- inside area
    i = { f_h=0, c_rel="floor_h", c_add="inside_h", c_h=0, },

    -- step
    s = { f_h=8, c_rel="floor_h", c_add="door_h", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top", light=224
        },

    -- front sign
    F = { solid="front_w", l_peg="bottom" },

    -- door
    d = { f_h=8, c_rel="floor_h", c_h=8,
          f_tex="frame_f", l_tex="step_w", l_peg="bottom",
          c_tex="door_c", u_tex="door_w",  u_peg="bottom",
          light=224, kind="door_kind", tag="tag",
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },

    -- switch
    W = { copy="i", f_h=72, f_tex="switch_f",
          l_tex="side_w", l_peg="top",

          [2] = { l_tex="switch_w", l_peg="top", y_offset="switch_yo",
                  kind="switch_kind", tag="tag" },
        },
  },
},


------ Switches ------------------------------------

SWITCH_PILLAR =
{
  scale=64,
  add_mode="island",
--FIXME  height_range={ 128,384 },

  structure =
  {
    "P"
  },

  elements =
  {
    P = { solid="side_w",

          [2] = { l_tex="switch_w", l_peg="bottom", kind="kind", tag="tag" }
        },
  },
},

SWITCH_WIDE =
{
  scale=64,

  structure =
  {
    "ss"
  },

  elements =
  {
    s = { solid="wall",
          [2] = { l_tex="switch_w", l_peg="bottom", kind="kind", tag="tag" }
        },
  },
},

SWITCH_FLUSH =
{
  scale=64,

  structure =
  {
    "LsR"
  },

  elements =
  {
    s = { solid="wall",
          [2] = { l_tex="switch_w", l_peg="bottom", kind="kind", tag="tag" }
        },

    L = { solid="wall", [2] = { l_tex="left_w",  l_peg="bottom" }},
    R = { solid="wall", [2] = { l_tex="right_w", l_peg="bottom" }},
  },
},

SWITCH_FLOOR =
{
  region="floor",
--FIXME  height_range={ 96,999 },

  structure =
  {
    "....",
    "ssss",
    "....",
    "....",
  },

  elements =
  {
    s = { f_add="switch_h", f_h=0,
          l_tex="side_w", f_tex="switch_f", l_peg="top",

          [2] = { l_tex="switch_w", l_peg="top", kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset"
                }
        },

    -- beam
    B = { f_add="switch_h", f_h=12,
          l_tex="beam_w", f_tex="beam_f", l_peg="top"
        },
  },
},

SWITCH_FLOOR_BEAM =
{
  copy="SWITCH_FLOOR",

  structure =
  {
    "........",
    ".BssssB.",
    "........",
    "........",
  },
},

SWITCH_FLOOR_TINY =
{
  region="floor",
--FIXME  height_range={ 64,512 },

  structure =
  {
    "....",
    ".ss.",
    "....",
    "....",
  },

  elements =
  {
    s = { f_add="switch_h", f_h=0,
          l_tex="side_w", f_tex="switch_f", l_peg="top",

          [2] = { l_tex="switch_w", l_peg="top", kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset"
                }
        },
  },
},

SWITCH_FLOOR_TINY_PED =
{
  region="floor",
--FIXME  height_range={ 64,512 },

  structure =
  {
    "pppp",
    "pssp",
    "pppp",
    "....",
  },

  elements =
  {
    s = { f_h=20, f_add="switch_h",
          l_tex="side_w", f_tex="switch_f", l_peg="top",

          [2] = { l_tex="switch_w", l_peg="top", kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset"
                },

        },

    p = { f_h=20,
          l_tex="ped_w", f_tex="ped_f", l_peg="top",
        }
  },
},

SWITCH_CEILING =
{
  add_mode="island",
--FIXME  height_range={ 96,256 },

  structure =
  {
    "bbbb",
    "ssss",
    "bbbb",
    "....",
  },

  elements =
  {
    s = { c_rel="floor_h", c_h=24, f_h=0,
          u_tex="side_w", c_tex="switch_c", u_peg="top",

          [2] = { u_tex="switch_w", u_peg="top", kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset"
                }
        },

    -- beam coming down from ceiling
    b = { c_rel="floor_h", c_add="switch_h", c_h=24, f_h=0,
          c_tex="beam_c", u_tex="beam_w", u_peg="bottom",
        }
  },
},

SWITCH_NICHE =
{
  structure =
  {
    "########",
    "########",
    "##ssss##",
    "#LnnnnL#",
  },

  elements =
  {
    -- niche
    n = { f_h=0, c_rel="floor_h", c_add="switch_h", c_h=0,
          f_tex="frame_f", c_tex="frame_c",
          light=192
        },

    -- switch
    s = { solid="switch_w", l_peg="top",
          [2] = { kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset"
                }
        },

    -- light
    L = { solid="wall", light=192,
          [4] = { l_tex="lite_w" },
          [6] = { l_tex="lite_w" },
        },
  },
},

SWITCH_NICHE_TINY =
{
  structure =
  {
    "####",
    "####",
    "#ss#",
    "LnnM",
  },

  elements =
  {
    -- niche
    n = { f_h=32, c_rel="floor_h", c_add="switch_h", c_h=32,
          f_tex="frame_f", c_tex="frame_c",
          [2] = { x_offset=16, l_peg="bottom", u_peg="top" },
        },

    -- switch
    s = { solid="switch_w", l_peg="top",
          [2] = { kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset" }
        },

    -- sides
    L = { solid="wall", [6] = { l_tex="frame_w" },
          [2] = { x_offset=0, l_peg="top" }
        },
    M = { solid="wall", [4] = { l_tex="frame_w" },
          [2] = { x_offset=48, l_peg="top" }
        },
  },
},

SWITCH_NICHE_TINY_DEEP =
{
  copy="SWITCH_NICHE_TINY",

  structure =
  {
    "####",
    "#ss#",
    "LnnM",
    "LnnM",
  },
},

SWITCH_NICHE_HEXEN =
{
  structure =
  {
    "###ss###",
    "###nn###",
    "LLL..RRR",
    "........",
  },

  elements =
  {
    -- niche
    n = { f_h=32, c_rel="floor_h", c_add="switch_h", c_h=32,
          f_tex="frame_f", c_tex="frame_c",
        },

    -- switch
    s = { solid="wall",
          [2] = { kind="kind", tag="tag", l_tex="switch_w",
                  x_offset="x_offset", y_offset="y_offset" },

          [1] = { dx=0, dy=-8 },
          [3] = { dx=0, dy=-8 },
        },

    -- diagonals
    L = { solid="wall", mark=7, [3] = { VDEL=true }},
    R = { solid="wall", mark=8, [1] = { VDEL=true }},
  },
},


------ Wall Stuff ------------------------------------

WALL_LAMP_NARROW =
{
  structure =
  {
    "####",
    "#ii#",
    "#ii#",
    "#ii#",
  },

  elements =
  {
    i = { f_rel="low_h", f_h=0, c_rel="high_h", c_h=0,
          light=224
        },
  },

  things =
  {
    { kind="lamp_t", x = 32, y = 24 },
  },
},

WALL_LAMP =
{
  structure =
  {
    "########",
    "##iiii##",
    "##iiii##",
    "##iiii##",
  },

  elements =
  {
    i = { f_rel="low_h", f_h=0, c_rel="high_h", c_h=0,
          light=224
        },
  },

  things =
  {
    { kind="lamp_t", x = 64, y = 24 },
  },
},

WALL_PIC =
{
  structure =
  {
    "############",
    "##pppppppp##",
    "#LiiiiiiiiL#",
    "#LiiiiiiiiL#",
  },

  elements =
  {
    i = { f_rel="low_h", f_h=0, c_rel="low_h", c_h=0, c_add="pic_h",
          light=192,
        },

    p = { solid="pic_w" },

    L = { solid="wall",
          [4] = { l_tex="lite_w" }, 
          [6] = { l_tex="lite_w" }, 
        },
  },
},

WALL_PIC_SHALLOW =
{
  copy="WALL_PIC",

  structure =
  {
    "############",
    "############",
    "##pppppppp##",
    "#LiiiiiiiiL#",
  },
},

WALL_PIC_SCROLLER =
{
  structure =
  {
    "############",
    "############",
    "##pppppppp##",
    "##iiiiiiii##",
  },

  elements =
  {
    i = { f_rel="low_h", f_h=0, c_rel="low_h", c_h=0, c_add="pic_h",
          light=182,
        },

    p = { solid="pic_w", [2] = { kind="kind" } },
  },
},

WALL_PIC_NARROW =
{
  copy="WALL_PIC",

  structure =
  {
    "########",
    "########",
    "##pppp##",
    "#LiiiiL#",
  },
},

WALL_PIC_TWO_SIDED =
{
  copy="WALL_PIC",

  structure =
  {
    "#LiiiiiiiiL#",
    "##pppppppp##",
    "##pppppppp##",
    "#LiiiiiiiiL#",
  },
},

WALL_PIC_FOUR_SIDED =
{
  structure =
  {
    "#LiiiiiiiiL#",
    "MppppppppppM",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "MppppppppppM",
    "#LiiiiiiiiL#",
  },

  elements =
  {
    i = { f_rel="high_h", f_h=-128, c_rel="high_h", c_h=0,
          light=192,
        },

    p = { solid="pic_w" },

    L = { solid="wall", [4] = { l_tex="lite_w" }, [6] = { l_tex="lite_w" }}, 
    M = { solid="wall", [2] = { l_tex="lite_w" }, [8] = { l_tex="lite_w" }}, 
  },
},

WALL_CROSS =
{
  structure =
  {
    "############",
    "############",
    "##BBBBBBBB##",
    "#LaaawwaaaL#",
  },

  elements =
  {
    B = { solid="back_w" },

    L = { solid="wall",
          [4]={ l_tex="cross_w" },
          [6]={ l_tex="cross_w" },
        },

    a = { f_h=-24, f_rel="mid_h", c_h=0, c_rel="mid_h",
          f_tex="cross_f", c_tex="cross_f",
          light="cross_lt", kind="kind",
          [4]={ l_tex="cross_w", u_tex="cross_w" },
          [6]={ l_tex="cross_w", u_tex="cross_w" },
        },

    w = { copy="a", f_h=-78, c_h=78 },
  }
},

WALL_LIGHTS_THIN =
{
  structure =
  {
    "########",
    "########",
    "##B##B##",
    "#LsRLsR#",
  },

  elements =
  {
    s = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h",
          f_tex="frame_f", c_tex="frame_f",
          light="wall_lt", kind="kind",
        },

    B = { solid="lite_w" },

    L = { solid="wall", [6] = { l_tex="lite_side" }},
    R = { solid="wall", [4] = { l_tex="lite_side" }},
  },
},

WALL_LIGHTS_WIDE =
{
  copy="WALL_LIGHTS_THIN",

  structure =
  {
    "############",
    "#BB##BB##BB#",
    "LssRLssRLssR",
    "LssRLssRLssR",
  },
},


FENCE_RAIL =
{
  structure =
  {
    "ffff",
    "RRRR",
    "ffff",
    "ffff",
  },

  elements =
  {
    f = { f_h=0, f_rel="low_h" },

    R = { copy="f", mark=2,
          [2] = { rail="rail_w", l_peg="bottom", impassible=true } },
  }
},

FENCE_BEAM_W_LAMP =
{
  structure =
  {
    "ffff",
    "BffB",
    "BffB",
    "ffff",
  },

  elements =
  {
    f = { f_h=0, f_rel="low_h" },

    B = { copy="f", f_h=0, f_add="beam_h",
          l_tex="beam_w", f_tex="beam_f", l_peg="top" },
  },

  things =
  {
    { kind="lamp_t", x=32, y=32 },
  },
},


------ Pickup & Players ------------------------------------

TECH_PICKUP_SMALL =
{
--  height_range={ 160,256 },

  structure =
  {
    "####aaaaaaaa####",
    "####bbbbbbbb####",
    "##LLccccccccLL##",
    "##L#dddddddd#L##",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "##L#dddddddd#L##",
    "##LLccccccccLL##",
    "####bbbbbbbb####",
    "####aaaaaaaa####",
  },

  elements =
  {
    -- steps
    a = { l_tex="step_w", light=128, c_h=-48, l_peg="top" },

    b = { copy="a", f_h= -8, c_h=-56 },
    c = { copy="a", f_h=-16, c_h=-64, light=192 },
    d = { copy="a", f_h=-24, c_h=-56 },

    e = { copy="a", f_h=-32, c_h=0, light=160, f_tex="carpet_f", c_tex="sky_c" },

    -- light
    L = { solid="lite_w" },
  },

  things =
  {
    { kind="pickup_spot", x=128, y=128 },
  },
},

TECH_PICKUP_LARGE =
{
  copy="TECH_PICKUP_SMALL",

  structure =
  {
    "####aaaaaaaaaaaa####",
    "####bbbbbbbbbbbb####",
    "##LLccccccccccccLL##",
    "##L#dddddddddddd#L##",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "##L#dddddddddddd#L##",
    "##LLccccccccccccLL##",
    "####bbbbbbbbbbbb####",
    "####aaaaaaaaaaaa####",
  },

  things =
  {
    { kind="pickup_spot", x=160, y=160 },
  },
},

LAUNCH_PAD_LARGE =
{
  region="floor",

  structure =
  {
    "........................",
    "........dddddddd........",
    "........bbbbbbbb........",
    "...OOOOOOOOOOOOOOOOOO...",
    "...OssssssssssssssssO...",
    "...OssssssssssssssssO...",
    "...OssssssssssssssssO...",
    "...OssssTssssssTssssO...",
    ".caOssssTssssssTssssOac.",
    ".caOssssTssssssTssssOac.",
    ".caOssssTssssssTssssOac.",
    ".caOssssTTTTTTTTssssOac.",
    ".caOssssTssssssTssssOac.",
    ".caOssssTssssssTssssOac.",
    ".caOssssTssssssTssssOac.",
    ".caOssssTssssssTssssOac.",
    "...OssssssssssssssssO...",
    "...OssssssssssssssssO...",
    "...OssssssssssssssssO...",
    "...OssssssssssssssssO...",
    "...OOOOOOOOOOOOOOOOOO...",
    "........bbbbbbbb........",
    "........dddddddd........",
    "........................",
  },

  elements =
  {
    s = { f_h=16, f_tex="pad_f" },
    T = { f_h=16, f_tex="letter_f" },

    O = { f_h=24, f_tex="outer_f", l_tex="outer_w", l_peg="top" },

    a = { f_h=16, f_tex="step_f", l_tex="side_w", l_peg="top",
          [4] = { l_tex="step_w" }, [6] = { l_tex="step_w" },
        },

    b = { f_h=16, f_tex="step_f", l_tex="side_w", l_peg="top",
          [2] = { l_tex="step_w" }, [8] = { l_tex="step_w" },
        },

    c = { copy="a", f_h=8 },
    d = { copy="b", f_h=8 },
  },

  things =
  {
    { kind="pickup_spot", x=192, y=192 },
  },
},

LAUNCH_PAD_MEDIUM =
{
  copy="LAUNCH_PAD_LARGE",

  structure =
  {
    "....................",
    ".......dddddd.......",
    ".......bbbbbb.......",
    "...OOOOOOOOOOOOOO...",
    "...OssssssssssssO...",
    "...OssssssssssssO...",
    ".caOssTTTTTTTTssOac.",
    ".caOssTsssssssssOac.",
    ".caOssTsssssssssOac.",
    ".caOssTsssssssssOac.",
    ".caOssTTTTTTTTssOac.",
    ".caOssTsssssssssOac.",
    ".caOssTsssssssssOac.",
    ".caOssTsssssssssOac.",
    "...OssssssssssssO...",
    "...OssssssssssssO...",
    "...OOOOOOOOOOOOOO...",
    ".......bbbbbb.......",
    ".......dddddd.......",
    "....................",
  },

  things =
  {
    { kind="pickup_spot", x=160, y=160 },
  },
},

LAUNCH_PAD_SMALL =
{
  copy="LAUNCH_PAD_LARGE",

  structure =
  {
    ".....dddddd.....",
    ".....bbbbbb.....",
    "..OOOOOOOOOOOO..",
    "..OssssssssssO..",
    "..OssTTTTTTssO..",
    "caOssTsssssssOac",
    "caOssTsssssssOac",
    "caOssTTTTTTssOac",
    "caOsssssssTssOac",
    "caOsssssssTssOac",
    "caOssTTTTTTssOac",
    "..OssssssssssO..",
    "..OssssssssssO..",
    "..OOOOOOOOOOOO..",
    ".....bbbbbb.....",
    ".....dddddd.....",
  },

  things =
  {
    { kind="pickup_spot", x=128, y=128 },
  },
},

LIQUID_PICKUP =
{
  structure =
  {
    "##ssssssssssss##",
    "##ssssssssssss##",
    "ssbLLLLccLLLLbss",
    "ssbbbbbccbbbbbss",
    "ssbLLLLccLLLLbss",
    "ssbbbbbccbbbbbss",
    "ssbLLLLccLLLLbss",
    "ssccccccccccccss",
    "ssccccccccccccss",
    "ssbLLLLccLLLLbss",
    "ssbbbbbccbbbbbss",
    "ssbLLLLccLLLLbss",
    "ssbbbbbccbbbbbss",
    "ssbLLLLccLLLLbss",
    "##ssssssssssss##",
    "##ssssssssssss##",
  },

  elements =
  {
    s = { f_h=16, c_h=-12 },

    c = { copy="s" },

    b = { copy="s", f_h=8 },

    L = { f_h= 0, f_tex="liquid_f", c_h=12, c_tex="sky_c",
          light=208,

          [1] = { dx=-4,dy=-4 }, [3] = { dx= 4,dy=-4 },
          [7] = { dx=-4,dy= 4 }, [9] = { dx= 4,dy= 4 },
        },
  },

  things =
  {
    { kind="pickup_spot", x=128, y=128 },
  },
},

PEDESTAL =
{
  scale=64,
  region="floor",

  structure =
  {
    "p",
  },

  elements =
  {
    p = { f_h=0, f_add="ped_h",
          f_tex = "ped_f", l_tex = "ped_side",
          l_peg = "top",
        }
  },
},

PEDESTAL_PLUT =
{
--  environment="outdoor",

  structure =
  {
    "pppp",
    "pppp",
    "pTpp",
    "pppp",
  },

  elements =
  {
    p = { f_h=16, f_tex="ped_f", l_tex="ped_w", l_peg="top",
          light=80,
        },

    T = { f_h=28, f_tex="ped_f2", l_tex="ped_w2", l_peg="top",

          light=255, kind="kind",

          [1] = { dx=16, dy=-6 },
          [3] = { dx=22, dy=16 },
          [7] = { dx=-6, dy= 0 },
          [9] = { dx= 0, dy=22 },
        },
  },
},

PEDESTAL_PLUT_DOUBLE =
{
  copy="PEDESTAL_PLUT",

--  environment="indoor",
--  height_range={ 112,999 },

  elements =
  {
    p = { f_h= 16, f_tex="ped_f", l_tex="ped_w", l_peg="top",
          c_h=-16, c_tex="ped_f", u_tex="ped_w", u_peg="bottom",
          light=80,
        },

    T = { f_h= 28, f_tex="ped_f2", l_tex="ped_w2", l_peg="top",
          c_h=-28, c_tex="ped_f2", u_tex="ped_w2", u_peg="bottom",

          light=255, kind="kind",

          [1] = { dx=16, dy=-6 },
          [3] = { dx=22, dy=16 },
          [7] = { dx=-6, dy= 0 },
          [9] = { dx= 0, dy=22 },
        },
  },

},


------ Decorative I ------------------------------------

STATUE_TECH_1 =
{
  structure =
  {
    "....................",
    "....................",
    "..aaaaaaaaaaaaaaaa..",
    "..aaaaaaaaaaaaaaaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aaffffggggffffaa..",
    "..aaffffggggffffaa..",
    "..aaffffggggffffaa..",
    "..aaffffggggffffaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aaaaaaaaaaaaaaaa..",
    "..aaaaaaaaaaaaaaaa..",
    "....................",
    "....................",
  },

  elements =
  {
    a = { f_h=8, c_rel="floor_h", c_h=256,
          l_tex="step_w", l_peg="top"
        },

    b = { f_h=16, c_rel="floor_h", c_h=192,
          l_tex="step_w", f_tex="carpet_f",
          u_tex="span_w", c_tex="lite_c",
          light=192
        },

    c = { f_h=64, c_rel="floor_h", c_h=256,
          f_tex="comp_f", l_tex="comp_w",
        },

    f = { copy="c", f_h=128, l_tex="comp2_w", x_offset=128 },

    g = { copy="c", f_h=192, l_tex="wall" },
  },

  things =
  {
    { kind="lamp_t", x = 96, y = 96 },
    { kind="lamp_t", x =224, y = 96 },
    { kind="lamp_t", x = 96, y =224 },
    { kind="lamp_t", x =224, y =224 },
  },
},

STATUE_TECH_2 =
{
  structure =
  {
    "................",
    ".OOOOOOOOOOOOOO.",
    ".OccccccccccccO.",
    ".OcccsssssscccO.",
    ".OcccsddddscccO.",
    ".OcsscaaaacsscO.",
    ".OcsdbMMMMbdscO.",
    ".OcsdbMMMMbdscO.",
    ".OcsdbMMMMbdscO.",
    ".OcsdbMMMMbdscO.",
    ".OcsscaaaacsscO.",
    ".OcccsddddscccO.",
    ".OcccsssssscccO.",
    ".OccccccccccccO.",
    ".OOOOOOOOOOOOOO.",
    "................",
  },

  elements =
  {
    O = { l_tex="outer_w", l_peg="top",
          u_tex="outer_w", u_peg="bottom",
        },

    c = { f_h=-8, c_h=8, f_tex="carpet_f", c_tex="lite_c",
          l_peg="top", light=208,
        },

    M = { copy="c", f_h=112, f_tex="tv_f", l_tex="tv_w",    
        },

    a = { copy="M", f_h=64, l_tex="span_w",
          [2]={ l_tex="tv_w", y_offset=23 },
          [8]={ l_tex="tv_w", y_offset=23 }
        },
    b = { copy="M", f_h=64, l_tex="span_w",
          [4]={ l_tex="tv_w", y_offset=23 },
          [6]={ l_tex="tv_w", y_offset=23 }
        },

    d = { copy="M", f_h=16, l_tex="span_w", f_tex="span_f" },
    s = { copy="M", f_h=8,  l_tex="span_w" },
  },
},

STATUE_TECH_JR =
{
  structure =
  {
    "............",
    "....dddd....",
    "..BjjjjjkB..",
    "..kmmmmmms..",
    ".csmLmmLmsc.",
    ".csmmTTmmsc.",
    ".csmmTTmmsc.",
    ".csmLmmLmsc.",
    "..smmmmmmk..",
    "..BkjjjjjB..",
    "....dddd....",
    "............",
  },

  elements =
  {
    -- inside
    m = { f_h=32, f_tex="tech_f", 
          c_h=0,  c_tex="tech_c",
          light="tech_lt", kind="kind"
        },
    
    T = { solid="tech_w" },
    
    L = { f_h=12, f_rel="mid_h", f_tex="lite_f",
          l_tex="lite_w", c_tex="tech_c",
          light="tech_lt"
        },

    -- outside
    B = { solid="beam_w" },

    k = { f_h= 64, f_tex="outer_f", l_tex="outer_w",
          c_h=-64, c_tex="outer_f", u_tex="outer_w",
          light="outer_lt",
        },

    j = { copy="k", [2] = { x_offset=16 }, [8] = { x_offset=16 }},
    s = { copy="k", [4] = { x_offset=16 }, [6] = { x_offset=16 }},

    -- shiny decoration
    c = { f_h= 16, f_tex="shine_f", l_tex="shine_w", l_peg="top",
          c_h=-16, c_tex="shine_f", u_tex="shine_w", u_peg="top",
          light="shine_lt",
          [2] = { l_tex="shine_side", u_tex="shine_side" },
          [8] = { l_tex="shine_side", u_tex="shine_side" },
        },
    d = { f_h= 16, f_tex="shine_f", l_tex="shine_w", l_peg="top",
          c_h=-16, c_tex="shine_f", u_tex="shine_w", u_peg="top",
          light="shine_lt",
          [4] = { l_tex="shine_side", u_tex="shine_side" },
          [6] = { l_tex="shine_side", u_tex="shine_side" },
        },
  },
},

STATUE_CHAIR_DUDE =
{
  region="floor",
--  height_range={ 136,999 },

  structure =
  {
    "........",
    ".b....b.",
    ".bbbbbb.",
    "SSSHHSSS",
    ".aBBBBa.",
    ".aLccLa.",
    "..L..L..",
    "..F..F..",
  },

  elements =
  {
    -- chair seat, back, armrest
    c = { f_h=24, f_tex="chair_f", l_tex="chair_w" },
    b = { copy="c", f_h=96 },
    a = { copy="c", f_h=48 },

    -- body, head, shoulders
    B = { f_h=56, f_tex="body_f", l_tex="body_w" },
    H = { copy="B", f_h=108 },
    S = { copy="B", f_h=72 },

    -- legs, feet
    L = { copy="B", f_h=32 },
    F = { copy="B", f_h=12 },
  },
},

MACHINE_PUMP =
{
  structure =
  {
    "ZZZZZZZZZZZZZZZZ",
    "ZZZZZZZZZZZZZZZZ",
    "ZZZZZZZZZZZZZZZZ",
    "ZbbbbbbccccddddZ",
    "ZbaaaabccccdLddZ",
    "ZbaPQabccccddddZ",
    "ZbaRSabccccddddZ",
    "ZbaaaabccccdLddZ",
    "ZbbbbbbccccddddZ",
    "ZZZZZZZZZZZZZZZZ",
    "ZZZZZZZZZZZZZZZZ",
    "ZZZZZZZZZZZZZZZZ",
  },

  elements =
  {
    -- outside
    Z = { f_h=0, c_rel="floor_h", c_h=216 },
    
    c = { f_h=112, c_rel="floor_h", c_h=176,
          f_tex="metal_f", l_tex="metal4_w", l_peg="top",
          c_tex="metal_c", u_tex="metal5_w", u_peg="bottom",
        },

    d = { copy="c", l_tex="metal3_w" },

    b = { copy="c", f_h=48, l_tex="metal4_w" },

    a = { copy="b", f_h=80, l_tex="metal5_w",
          c_rel="floor_h", c_h=144
        },

    -- supports
    L = { solid="beam_w" },

    -- pump
--- P = { f_h=56, c_h=-64,
---       f_tex="metal_f", l_tex="metal5_w", l_peg="top",
---       c_tex="pump_c",  u_tex="pump_w",   u_peg="bottom",
---       kind="tag",
---     },

    P = { solid="pump_w", [7] = { dx= 2, dy=-2 }, [9] = { dx= 0, dy= 4 },
          [8] = { x_offset= 64, kind="kind" },
          [4] = { x_offset= 80, kind="kind" },
        },
    Q = { solid="pump_w", [9] = { dx=-2, dy=-2 }, [3] = { dx= 4, dy= 0 },
          [6] = { x_offset= 32, kind="kind" },
          [8] = { x_offset= 48, kind="kind" },
        },
    R = { solid="pump_w", [7] = { dx=-4, dy= 0 }, [1] = { dx= 2, dy= 2 },
          [4] = { x_offset= 96, kind="kind" },
          [2] = { x_offset=112, kind="kind" },
        },
    S = { solid="pump_w", [1] = { dx= 0, dy=-4 }, [3] = { dx=-2, dy= 2 },
          [2] = { x_offset=  0, kind="kind" },
          [6] = { x_offset= 16, kind="kind" },
        },
  },
},


DRINKS_BAR =
{
  region="floor",

  structure =
  {
    "............",
    "bbbbbbbbbbbb",
    "bbbbbbbbbbbb",
    "............",
  },

  elements =
  {
    b = { f_h=32, f_tex="bar_f", l_tex="bar_w", l_peg="top" },
  },

  things =
  {
    { kind="drink_t", x= 16, y=32 },
    { kind="drink_t", x= 36, y=32 },
    { kind="drink_t", x= 56, y=32 },
    { kind="drink_t", x= 76, y=32 },
    { kind="drink_t", x= 96, y=32 },
    { kind="drink_t", x=116, y=32 },
    { kind="drink_t", x=136, y=32 },
    { kind="drink_t", x=156, y=32 },
    { kind="drink_t", x=176, y=32 },
  },
},

GROUND_LIGHT =
{
  region="floor",

  structure =
  {
    "aaaaaaa.",
    "abbbbba.",
    "abcccba.",
    "abcdcba.",
    "abcccba.",
    "abbbbba.",
    "aaaaaaa.",
    "........",
  },

  elements =
  {
    a = { f_h=0 },

    b = { f_h=8, l_tex="shawn_w", f_tex="shawn_f", l_peg="top", },

    c = { copy="b", f_h=40, light=192 },

    d = { f_h=64, l_tex="lite_w", f_tex="lite_f", light=200 },
  },
},

STREET_LAMP_TWO_SIDED =
{
  structure =
  {
    "........................",
    "........................",
    "........ttffffuu........",
    "...oggggffffffffggggp...",
    "..ogLLLLdddffcccLLLLgp..",
    "..ggLLLLeeeMMeeeLLLLgg..",
    "..ggLLLLeeeMMeeeLLLLgg..",
    "..mgLLLLbbbffaaaLLLLgn..",
    "...mggggffffffffggggn...",
    "........rrffffss........",
    "........................",
    "........................",
  },

  elements =
  {
    -- central pillar and arms
    M = { solid="beam_w" },

    f = { f_h =12, f_tex="arm_f", l_tex="arm_w",
          light=208,
        },

    r = { copy="f", mark=1, [1] = { VDEL=true }},
    s = { copy="f", mark=2, [3] = { VDEL=true }},
    t = { copy="f", mark=3, [7] = { VDEL=true }},
    u = { copy="f", mark=4, [9] = { VDEL=true }},

    e = { copy="f",
          c_h=-16, c_tex="arm_c", u_tex="arm_u", u_peg="bottom",
        },

    a = { copy="e", [1] = { VDEL=true }},
    b = { copy="e", [3] = { VDEL=true }},
    c = { copy="e", [7] = { VDEL=true }},
    d = { copy="e", [9] = { VDEL=true }},

    -- lights and glow
    L = { c_h=-40, c_tex="lite_c", u_tex="lite_w",
          light=255,
        },

    g = { light=255 },

    m = { copy="g", mark=1, [1]={ VDEL=true }},
    n = { copy="g", mark=2, [3]={ VDEL=true }},
    o = { copy="g", mark=3, [7]={ VDEL=true }},
    p = { copy="g", mark=4, [9]={ VDEL=true }},
  },
},


BOOKCASE_WIDE =
{
  scale=64,
  region="floor",

  structure =
  {
    "cc",
  },

  elements =
  {
    c = { f_h=128, f_tex="book_f", l_tex="side_w", l_peg="top",
          [2] = { l_tex="book_w" },
          [8] = { l_tex="book_w" },
        }
  },
},

FOUNTAIN_SQUARE =
{
  region="floor",

  structure =
  {
    "................",
    ".eeeeeeeeeeeeee.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLsFFsLLLLe.",
    ".eLLLLFppFLLLLe.",
    ".eLLLLFppFLLLLe.",
    ".eLLLLsFFsLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eeeeeeeeeeeeee.",
    "................",
  },

  elements =
  {
    e = { f_h=28, f_tex="edge_f", l_tex="edge_w", l_peg="top" },
    p = { f_h=76, f_tex="beam_f", l_tex="beam_w", l_peg="top" },
    s = { copy="p", f_h=64 },

    L = { f_h=20, f_tex="liquid_f", l_tex="liquid_w" },
    F = { copy="L", f_h=56 },
  },
},


------ Ceiling Lights --------------------------------

SKYLIGHT_MEGA_1 =
{
  region="ceil",

  structure =
  {
    "ffffffffffffffffffff",
    "ffffffffffffffffffff",
    "ffssBBBBBBBBBBBBssff",
    "ffssBBBBBBBBBBBBssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssBBBBBBBBBBBBssff",
    "ffssBBBBBBBBBBBBssff",
    "ffffffffffffffffffff",
    "ffffffffffffffffffff",
  },

  elements =
  {
    s = { c_h=12, c_tex="sky_c", light=192 },

    f = { c_h=-20, c_tex="frame_c", u_tex="frame_w" },

    B = { c_h=-4, c_tex="beam_c", u_tex="beam_w" },

    C = { copy="B", c_h=4 },
  },
},

SKYLIGHT_MEGA_2 =
{
  copy="SKYLIGHT_MEGA_1",

  structure =
  {
    "ffffffffffffffff",
    "ffffffffffffffff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffBBBBBBBBBBBBff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffBBBBBBBBBBBBff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffffffffffffffff",
    "ffffffffffffffff",
  },
},

SKYLIGHT_MEGA_3 =
{
  copy="SKYLIGHT_MEGA_1",

  structure =
  {
    "ffffffffffffffff",
    "ffffffffffffffff",
    "ffssBssBBssBssff",
    "ffssBssBBssBssff",
    "ffBBBBBBBBBBBBff",
    "ffssBssBBssBssff",
    "ffssBssssssBssff",
    "ffBBBBssssBBBBff",
    "ffBBBBssssBBBBff",
    "ffssBssssssBssff",
    "ffssBssBBssBssff",
    "ffBBBBBBBBBBBBff",
    "ffssBssBBssBssff",
    "ffssBssBBssBssff",
    "ffffffffffffffff",
    "ffffffffffffffff",
  },
},

SKYLIGHT_CROSS_SMALL =
{
  region="ceil",

  structure =
  {
    "fffffff.",
    "fffSfff.",
    "fffffff.",
    "fTfffUf.",
    "fffffff.",
    "fffXfff.",
    "fffffff.",
    "........",
  },

  elements =
  {
    f = { c_h=-8, c_tex="frame_c", u_tex="frame_w" },

--  B = { c_h=-4, c_tex="beam_c", u_tex="beam_w" },

    S = { c_h=8, c_tex="sky_c", light=208,
          [1] = { dx= 8, dy=-16 },
          [3] = { dx=24, dy=16 },
          [7] = { dx=-24,dy= 0 },
        },
    T = { c_h=8, c_tex="sky_c", light=208,
          [9] = { dx=16, dy=-8 },
          [3] = { dx=-16,dy=-24 },
          [7] = { dx= 0, dy=24 },
        },
    U = { c_h=8, c_tex="sky_c", light=208,
          [1] = { dx=-16,dy= 8 },
          [7] = { dx=16, dy=24 },
          [3] = { dx= 0, dy=-24 },
        },
    X = { c_h=8, c_tex="sky_c", light=208,
          [9] = { dx=-8, dy=16 },
          [7] = { dx=-24,dy=-16 },
          [3] = { dx=24, dy= 0 },
        },
  },
},

LIGHT_GROOVY =
{
  structure =
  {
    "..bmmmmmma..",
    "..mmtLLumm..",
    "..mmLLLLmm..",
    "..mtLLLLum..",
    "..mrLLLLsm..",
    "..mmLLLLmm..",
    "..mmLLLLmm..",
    "..mtLLLLum..",
    "..mrLLLLsm..",
    "..mmLLLLmm..",
    "..mmLLLLmm..",
    "..mtLLLLum..",
    "..mrLLLLsm..",
    "..mmLLLLmm..",
    "..mmrLLsmm..",
    "..dmmmmmmc..",
  },

  elements =
  {
    -- light area
    L = { c_h=0, c_tex="lite_c",
          light="lite_lt", kind="kind",
        },

    -- frame
    m = { c_h=-8, c_tex="frame_c", u_tex="frame_w", u_peg="top",
          light="frame_lt",
        },
 
    r = { copy="L", mark=1, [1] = { VDEL=true }},
    s = { copy="L", mark=2, [3] = { VDEL=true }},
    t = { copy="L", mark=3, [7] = { VDEL=true }},
    u = { copy="L", mark=4, [9] = { VDEL=true }},

    -- outside
    a = { [1] = { VDEL=true }},
    b = { [3] = { VDEL=true }},
    c = { [7] = { VDEL=true }},
    d = { [9] = { VDEL=true }},
  },
},


------ Decorative II ------------------------------------

BILLBOARD =
{
  structure =
  {
    "................",
    ".DCCssssssssCCE.",
    ".CCrpppppppprCC.",
    ".CCCssssssssCCC.",
  },

  elements =
  {
    -- corner
    C = { f_h=0, f_add="corn_h",
          l_tex="corn_w", f_tex="corn_f", l_peg="top", },

    D = { copy="C", mark=1, [7] = { VDEL=true }},
    E = { copy="C", mark=2, [9] = { VDEL=true }},

    -- pic
    r = { f_h=8, f_add="pic_h",
          l_tex="pic_back", f_tex="pic_f", l_peg="top",
        },

    p = { copy="r", [2] = { l_tex="pic_w" }},

    -- step
    s = { f_h=8, l_tex="step_w", f_tex="step_f", l_peg="top" },
  }
},

BILLBOARD_LIT =
{
  region="floor",

  structure =
  {
    "................",
    ".CCC........DDD.",
    ".CLEppppppppELD.",
    ".CtEssssssssEtD.",
  },

  elements =
  {
    -- corner
    E = { f_h=0, f_add="corn_h",
          l_tex="corn2_w", f_tex="corn_f", l_peg="top", },

    C = { copy="E",
          [4] = { l_tex="corn_w" },
          [8] = { l_tex="corn_w" },
        },

    D = { copy="E",
          [6] = { l_tex="corn_w" },
          [8] = { l_tex="corn_w" },
        },

    -- light
    L = { copy="E", [2] = { l_tex="lite_w" }, },

    -- pic
    p = { f_h=8, f_add="pic_h",
          l_tex="pic_back", [2] = { l_tex="pic_w" },
          f_tex="pic_f", l_peg="top",
        },

    -- step
    s = { f_h=8, l_tex="step_w", f_tex="step_f", l_peg="top" },

    t = { copy="s", f_h=16, light=208 },
  },
},

BILLBOARD_ON_STILTS =
{
  structure =
  {
    "............",
    ".CrrrrrrrrC.",
    ".BppppppppB.",
    "............",
  },

  elements =
  {
    -- picture
    p = { mark = 1,
          [8] = { rail="pic_w", l_peg="bottom",
                  x_offset=8, y_offset="pic_offset_h" },
        },

    r = { mark = 2, [2] = { x_offset=8 }},

    -- beams
    B = { f_add="pic_offset_h", f_h=140,
          l_tex="beam_w", f_tex="beam_f", l_peg="top",
        },

    C = { copy="B",
          [1] = { dx=-8, dy=0 },
          [3] = { dx= 8, dy=0 },
        },
  },
},

BILLBOARD_STILTS_HUGE =
{
  structure =
  {
    ".CrrrrrrrrC.",
    ".BppppppppB.",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".BqqqqqqqqB.",
    ".DrrrrrrrrD.",
  },

  elements =
  {
    -- picture
    p = { mark = 1,
          [8] = { rail="pic_w", l_peg="bottom",
                  x_offset=8, y_offset="pic_offset_h" },
        },

    q = { mark = 1,
          [2] = { rail="pic_w", l_peg="bottom",
                  x_offset=8, y_offset="pic_offset_h" },
        },

    r = { mark = 2,
          [2] = { x_offset=8 }, [8] = { x_offset=8 } },

    s = { mark = 3,
          [6] = { rail="pic_w", l_peg="bottom",
                  y_offset="pic_offset_h" },
        },

    -- beams
    B = { f_add="pic_offset_h", f_h=140,
          l_tex="beam_w", f_tex="beam_f", l_peg="top",
        },

    C = { copy="B",
          [1] = { dx=-8, dy=0 },
          [3] = { dx= 8, dy=0 },
        },

    D = { copy="B",
          [7] = { dx=-8, dy=0 },
          [9] = { dx= 8, dy=0 },
        },
  },

  things =
  {
    { kind="pickup_spot", x=96, y=96 },
  },
},

COMPUTER_TALL =
{
  scale=64,
  region="floor",

  structure =
  {
    "cc",
  },

  elements =
  {
    c = { f_h=80, f_tex="comp_f", l_tex="side_w", l_peg="top",
          [2] = { l_tex="comp_w" },
          [8] = { l_tex="comp_w" },
        }
  },
},

COMPUTER_TALL_THIN =
{
  copy="COMPUTER_TALL",

  scale=16,

  structure =
  {
    "cccccccc",
    "cccccccc",
    "........",
    "........",
  },
},

COMPUTER_DESK =
{
  scale=64,
  region="floor",

  structure =
  {
    "cc",
  },

  elements =
  {
    c = { f_h=28, f_tex="comp_f", l_tex="side_w", l_peg="top", }
  },
},

COMPUTER_DESK_U_SHAPE =
{
  scale=64,
  region="floor",

  structure =
  {
    "aa",
    ".b",
    "dd",
  },

  elements =
  {
    a = { f_h=28, f_tex="comp_Sf", l_tex="side_w", l_peg="top", },
    b = { f_h=28, f_tex="comp_Wf", l_tex="side_w", l_peg="top", },
    d = { f_h=28, f_tex="comp_Nf", l_tex="side_w", l_peg="top", },

    -- corner
    c = { f_h=28, f_tex="comp_cf", l_tex="side_w", l_peg="top", },
  },

  things =
  {
    { kind="pickup_spot", x=36, y=96 },
  },
},

COMPUTER_DESK_HUGE =
{
  copy="COMPUTER_DESK_U_SHAPE",

  structure =
  {
    "aac",
    "..b",
    "..b",
    "ddc",
  },

  things =
  {
    { kind="pickup_spot", x=80, y=128 },
  },
},

PENTAGRAM =
{
  region="floor",

  structure =
  {
    "............",
    "............",
    "............",
    "............",
    "....ttt.....",
    "....ttt.....",
    "..llppprr...",
    "....b.c.....",
    "....b.c.....",
    "............",
    "............",
    "............",
  },

  elements =
  {
    -- pentagram
    p = { f_add="gram_h", f_h=0,
          f_tex="gram_f", l_tex="gram_w", l_peg="top",
          light="gram_lt", kind="kind",
        },
 
    t = { copy="p",
          [7] = { dx= 22, dy= 32 },
          [9] = { dx=-22, dy= 32 },
          [1] = { dx= 12, dy= 12 },
          [3] = { dx=-12, dy= 12 },
        },

    l = { copy="p",
          [7] = { dx=-20, dy= 18 },
          [1] = { dx=-20, dy= 30 },
          [3] = { dx=  0, dy=  0 },
          [9] = { dx=  0, dy=  0 },
        },
 
    r = { copy="p",
          [9] = { dx= 20, dy= 18 },
          [3] = { dx= 20, dy= 30 },
          [1] = { dx=  0, dy=  0 },
          [7] = { dx=  0, dy=  0 },
        },
 
    b = { copy="p",
          [1] = { dx=-26, dy=-24 },
          [3] = { dx=-38, dy=-24 },
          [7] = { dx=  0, dy= -4 },
          [9] = { dx=  6, dy=-16 },
        },
 
    c = { copy="p",
          [3] = { dx= 26, dy=-24 },
          [1] = { dx= 38, dy=-24 },
          [9] = { dx=  0, dy= -4 },
          [7] = { dx= -6, dy=-16 },
        },
 
    -- outside
    x = { l_tex="outer_w" },
  },

  things =
  {
    { kind="gram_t", x=88,    y=88+54 },
    { kind="gram_t", x=88-54, y=88+18 },
    { kind="gram_t", x=88+54, y=88+18 },
    { kind="gram_t", x=88-32, y=88-40 },
    { kind="gram_t", x=88+32, y=88-40 },
  },
},


------ Nature Stuff ----------------------------------

POND_LARGE =
{
  region="floor",

  structure =
  {
    "xxxxxxxxxxxxxxxxxxxxxxxx",
    "xxxxxxxxxxxxxxxxxxxxxxxx",
    "xxxxxxxxxxxcccddxxxxxxxx",
    "xxxxxcccppppppppdxxxxxxx",
    "xxxxcbbwwwwwwwwwapddxxxx",
    "xxxcbwwwwwwwwwwwwwwadxxx",
    "xxcbwwwccppwwwwwwwwwadxx",
    "xcpwwwwpppbwwwwwwwwwwadx",
    "xcpwwwwwwwwwwwwwwwwwwwdx",
    "xapwwwwwwwwwwwwwwwwwwwpx",
    "xxawwwwwwccddwwwwwwwwwcx",
    "xxadwwwcppppppdwwwwwcpcx",
    "xxxapppbbxxxxxaaapppbbxx",
    "xxxxabcxxxxxxxxxxxxxxxxx",
    "xxxxxxxxxxxxxxxxxxxxxxxx",
    "xxxxxxxxxxxxxxxxxxxxxxxx",
  },
 
  elements =
  {
    -- pool boundary
    p = { f_h=-14, f_tex="pond_f", l_tex="pond_w", l_peg="top" },

    a = { copy="p", mark=1, [1] = { VDEL=true }},
    b = { copy="p", mark=2, [3] = { VDEL=true }},
    c = { copy="p", mark=3, [7] = { VDEL=true }},
    d = { copy="p", mark=4, [9] = { VDEL=true }},

    -- water
    w = { f_h=-24, f_tex="liquid_f", light=192, kind="kind" },

    -- outside area
    x = { l_tex="outer_w", l_peg="top" },
  },

  --FIXME: pickup spot (on island)
},

POND_SMALL =
{
  region="floor",

  structure =
  {
    "xxxxxxxxxxxx",
    "xxccppddxxxx",
    "xcbwwwwappdx",
    "xpwwwwwwwwpx",
    "xpwwwwwwwwpx",
    "xppdwccddwbx",
    "xaxaapppppbx",
    "xxxxxxxxxxxx",
  },

  elements =
  {
    -- water
    w = { f_h=-16, f_tex="liquid_f", light=192, kind="kind" },

    -- pool boundary
    p = { f_h=-9, f_tex="pond_f", l_tex="pond_w", l_peg="top" },

    a = { copy="p", mark=1, [1] = { VDEL=true }},
    b = { copy="p", mark=2, [3] = { VDEL=true }},
    c = { copy="p", mark=3, [7] = { VDEL=true }},
    d = { copy="p", mark=4, [9] = { VDEL=true }},

    -- outside area
    x = { l_tex="outer_w", l_peg="top" },
  },
},

POND_MEDIUM =
{
  region="floor",

  structure =
  {
    "xxxxxxxxxxxxxxxx",
    "xxxxxgssssshhxxx",
    "xxxggsppppppshxx",
    "xsssspbwwwwasshx",
    "xessspwwwwwapphx",
    "xxesspwwwwwwwpsx",
    "xxxespwwwwwwwpsx",
    "xxxespddwwwccpsx",
    "xxxxeespppppsffx",
    "xxxxxxeessssfxxx",
    "xxxxxxxxxxxxxxxx",
    "xxxxxxxxxxxxxxxx",
  },

  elements =
  {
    -- water
    w = { f_h=-22, f_tex="liquid_f", light=192, kind="kind" },

    -- pool inner
    p = { f_h=-16, f_tex="pond_f", l_tex="pond_w", l_peg="top" },

    a = { copy="p", mark=1, [1] = { VDEL=true }},
    b = { copy="p", mark=2, [3] = { VDEL=true }},
    c = { copy="p", mark=3, [7] = { VDEL=true }},
    d = { copy="p", mark=4, [9] = { VDEL=true }},

    -- pool outer
    s = { f_h=-8, f_tex="pond_f2", l_tex="pond_w2", l_peg="top" },

    e = { copy="s", mark=5, [1] = { VDEL=true }},
    f = { copy="s", mark=6, [3] = { VDEL=true }},
    g = { copy="s", mark=7, [7] = { VDEL=true }},
    h = { copy="s", mark=8, [9] = { VDEL=true }},

    -- outside area
    x = { l_tex="outer_w", l_peg="top" },
  },
},

ROCK_PIECES =
{
  structure =
  {
    "xxxxxxxxxxxx",
    "xxxxxxxxxxxx",
    "xxxxxxxxxxxx",
    "xxxxxxxmxnxx",
    "xxxxxxxmxnxx",
    "xxxxhhxjepxx",
    "xccceexjepxx",
    "xccceexjekkx",
    "xxxxbbxjekkx",
    "xxxxbbxxxxxx",
    "xxxxxxxxxxxx",
    "xxxxxxxxxxxx",
  },

  elements =
  {
    x = { l_tex="outer_w" },
    
    e = { f_h=0, f_add="rock_h", f_tex="rock_f", l_tex="rock_w" },

    b = { copy="e",
          [1] = { dx=-40, dy= 44 }, [3] = { dx=-56, dy=  8 },
          [7] = { dx= -8, dy= 26 }, [9] = { dx=-24, dy=-16 },
        },

    c = { copy="e",
          [1] = { dx= 24, dy= 72 }, [7] = { dx= 56, dy= 86 },
        },

    h = { copy="e",
          [1] = { dx= 24, dy= 22 }, [3] = { dx=-20, dy=-18 },
          [7] = { dx= 40, dy=  6 }, [9] = { dx= 00, dy=-10 },
        },

    j = { copy="e",
          [1] = { dx= -4, dy= 24 }, [7] = { dx= 24, dy=  8 },
          [3] = { dx=-20, dy=  4 },
        },

    k = { copy="e",
          [1] = { dx= -8, dy=  0 }, [3] = { dx=-26, dy=-10 },
          [7] = { dx= -4, dy=  8 }, [9] = { dx= -6, dy=-24 },
        },

    m = { copy="e",
          [1] = { dx= 00, dy= 00 }, [3] = { dx= 26, dy= -6 },
          [7] = { dx= 56, dy= -8 }, [9] = { dx= 40, dy=-24 },
        },

    n = { copy="e",
          [1] = { dx= 14, dy=-12 }, [3] = { dx= 00, dy= 00 },
          [7] = { dx= 44, dy=-24 }, [9] = { dx= 24, dy=-38 },
        },

    p = { copy="e",
          [3] = { dx= 00, dy= 00 }, [9] = { dx= 00, dy=-30 },
        },
  },
},

--[[
ROCK_VOLCANO =
{
  structure =
  {
    "..wwhzppzz..",
    ".wwwhzzzzzz.",
    "wwffkwwwwizz",
    "wkkkeyyyywwz",
    "wkkkeyyyywwz",
    "gwkyyxccydwz",
    "gwwyaxxxxdwz",
    ".jjeaxxxyyh.",
    ".jjeyybbywh.",
    ".njjjooyyw..",
    ".zzzzzzzzz..",
    "...zzzzmm...",
  },

  elements =
  {
    x = { f_h=248, f_tex="rock_f", l_tex="rock_w" },

    y = { copy="x", f_h=192, f_tex="liquid_f" },

    w = { copy="y", f_h=120 },
    k = { copy="y", f_h=160 },
    j = { copy="y", f_h=96  },
    z = { copy="y", f_h=64  },

    a = { copy="x", l_tex="liquid_w" },
    b = { copy="x", l_tex="liquid_w", [3] = { VDEL=true }},
    c = { copy="x", l_tex="liquid_w", [9] = { VDEL=true }},

    d = { copy="y", l_tex="liquid_w" },
    e = { copy="y", l_tex="liquid_w" },
    o = { copy="y", l_tex="liquid_w" },
    f = { copy="k", l_tex="liquid_w", [7] = { VDEL=true }},

    g = { copy="w", l_tex="liquid_w", [1] = { dx=0, dy=12 }},
    i = { copy="w", l_tex="liquid_w", [9] = { VDEL=true }},
    h = { copy="w", [6] = { l_tex="liquid_w" }},

    m = { copy="z", [2] = { l_tex="liquid_w" }, [3] = { dx=-8, dy=0 }},
    p = { copy="z", l_tex="liquid_w" },

    n = { copy="j", l_tex="liquid_w", [1] = { VDEL=true }},
  },

---    a = { copy="x", [4] = { l_tex="liquid_w" }},
---    b = { copy="x", [2] = { l_tex="liquid_w" }},
---    c = { copy="x", [8] = { l_tex="liquid_w" }},
---
---    d = { copy="y", [6] = { l_tex="liquid_w" }},
---    e = { copy="y", [4] = { l_tex="liquid_w" }},
---    o = { copy="y", [2] = { l_tex="liquid_w" }},
---    f = { copy="k", [8] = { l_tex="liquid_w" }},
---
---    g = { copy="w", [4] = { l_tex="liquid_w" }},
---    i = { copy="w", [8] = { l_tex="liquid_w" }, [6] = { l_tex="liquid_w" }},
},
--]]

STALAGMITE =
{
  structure =
  {
    "........",
    ".jjjjjk.",
    ".mdbbbk.",
    ".md##ck.",
    ".meeeck.",
    ".mnnnnn.",
    "........",
    "........",
  },

  elements =
  {
    -- inside column (# = WALL)

    -- middle column
    b = { f_h=36, c_h=-56, l_peg="top", c_peg="bottom",
          [1] = { dx = -2, dy =  0 },
          [7] = { dx =  8, dy =  0 },
          [9] = { dx = -6, dy = -6 },
          [3] = { dx = 00, dy = 00 },
        },
    c = { f_h=36, c_h=-56, l_peg="top", c_peg="bottom",
          [1] = { dx = 00, dy = 00 },
          [7] = { dx =  2, dy = -6 },
          [9] = { dx =  0, dy = -8 },
          [3] = { dx = -8, dy =  4 },
        },
    d = { f_h=36, c_h=-56, l_peg="top", c_peg="bottom",
          [1] = { dx =  0, dy =  8 },
          [7] = { dx =  2, dy = -6 },
          [9] = { dx = 00, dy = 00 },
          [3] = { dx =  0, dy =  6 },
        },
    e = { f_h=36, c_h=-56, l_peg="top", c_peg="bottom",
          [1] = { dx = 10, dy =  4 },
          [7] = { dx = 00, dy = 00 },
          [9] = { dx = -4, dy =  0 },
          [3] = { dx = -8, dy =  0 },
        },
    
    -- outer column
    j = { f_h=16, c_h=-24, l_peg="top", c_peg="bottom",
          [1] = { dx = 00, dy = 00 },
          [7] = { dx =  8, dy = -8 },
          [9] = { dx =-24, dy =  0 },
          [3] = { dx = 00, dy = 00 },
        },
    k = { f_h=16, c_h=-24, l_peg="top", c_peg="bottom",
          [1] = { dx = 00, dy = 00 },
          [7] = { dx = 00, dy = 00 },
          [9] = { dx =-12, dy =-10 },
          [3] = { dx =  0, dy = 24 },
        },
    m = { f_h=16, c_h=-24, l_peg="top", c_peg="bottom",
          [1] = { dx =  6, dy = 12 },
          [7] = { dx =  0, dy =-24 },
          [9] = { dx = 00, dy = 00 },
          [3] = { dx = 00, dy = 00 },
        },
    n = { f_h=16, c_h=-24, l_peg="top", c_peg="bottom",
          [1] = { dx = 24, dy =  0 },
          [7] = { dx = 00, dy = 00 },
          [9] = { dx = 00, dy = 00 },
          [3] = { dx = -6, dy = 12 },
        },
  },
},

STALAGMITE_HUGE =
{
  structure =
  {
    "................",
    ".jjjjjjkkkkkkkk.",
    ".jjooooooooookk.",
    ".jjoddddffffokk.",
    ".jjoddeeeeffokk.",
    ".hhocce##effokk.",
    ".hhocceeeebbogg.",
    ".hhoccccbbbbogg.",
    ".hhoooooooooogg.",
    ".hhhhhhhhgggggg.",
    "................",
    "................",
  },

  elements =
  {
    e = { f_rel="mid_h", c_rel="mid_h", f_h=-16, c_h=16 },

    b = { f_rel="mid_h", c_rel="mid_h", f_h=-32, c_h=32,
          [1] = { dx=1* -2, dy=1* -8 },
          [7] = { dx=1*  8, dy=1* -4 },
          [9] = { dx=1*  6, dy=1* 10 },
          [3] = { dx=1* -4, dy=1*  6 },
        },
    c = { f_rel="mid_h", c_rel="mid_h", f_h=-32, c_h=32,
          [1] = { dx=0*  8, dy=0*  6 },
          [7] = { dx=0*  6, dy=0*  4 },
          [9] = { dx=0*  4, dy=0* -8 },
          [3] = { dx=0* -8, dy=0* -4 },
        },
    d = { f_rel="mid_h", c_rel="mid_h", f_h=-32, c_h=32,
          [1] = { dx=1* -2, dy=1* -2 },
          [7] = { dx=1* -4, dy=1*-10 },
          [9] = { dx=1*  0, dy=1* -6 },
          [3] = { dx=1*  8, dy=1*  4 },
        },
    f = { f_rel="mid_h", c_rel="mid_h", f_h=-32, c_h=32,
          [1] = { dx=0* -6, dy=0*  8 },
          [7] = { dx=0*  4, dy=0*  2 },
          [9] = { dx=0*  8, dy=0* -4 },
          [3] = { dx=0* -8, dy=0*  6 },
        },

    o = { f_rel="mid_h", c_rel="mid_h", f_h=-48, c_h=48 },

    g = { f_rel="mid_h", c_rel="mid_h", f_h=-64, c_h=64,
          [1] = { dx=0*  2, dy=0*-10 },
          [7] = { dx=0* -6, dy=0*  8 },
          [9] = { dx=0*  6, dy=0* -8 },
          [3] = { dx=0*  4, dy=0*  6 },
        },
    h = { f_rel="mid_h", c_rel="mid_h", f_h=-64, c_h=64,
          [1] = { dx=1*  2, dy=1* -8 },
          [7] = { dx=1* -8, dy=1*  6 },
          [9] = { dx=1* -2, dy=1*  0 },
          [3] = { dx=1*  6, dy=1*-20 },
        },
    j = { f_rel="mid_h", c_rel="mid_h", f_h=-64, c_h=64,
          [1] = { dx=0* -4, dy=0* -6 },
          [7] = { dx=1*  0, dy=1*-10 },
          [9] = { dx=0* -8, dy=0*  8 },
          [3] = { dx=0* 10, dy=0*  2 },
        },
    k = { f_rel="mid_h", c_rel="mid_h", f_h=-64, c_h=64,
          [1] = { dx=1* -6, dy=1* -8 },
          [7] = { dx=1*  6, dy=1*  2 },
          [9] = { dx=1*-10, dy=1*-10 },
          [3] = { dx=1*  4, dy=1* -4 },
        },
  },
},

CAVE_IN_SMALL =
{
  structure =
  {
    ".qq...rrr...",
    ".qq.ctrrr...",
    "qqq.sttttd..",
    "....sttttsss",
    "..cssttccsss",
    ".csssssssuuu",
    "ssssuuuusuuc",
    "sttadduusuuc",
    "stttssssssss",
    "sttcsbttssb.",
    "aasssttx.ab.",
    "..mmmdtx....",
  },

  elements =
  {
    -- sky
    s = { c_h=16, c_tex="sky_c", light=192 },

    a = { copy="s", [1] = { VDEL=true }},
    b = { copy="s", [3] = { VDEL=true }},
    c = { copy="s", [7] = { VDEL=true }},
    d = { copy="s", [9] = { VDEL=true }},

    m = { copy="s", [1] = { dx=20, dy=8 }},

    -- rocks
    r = { f_h=10, f_tex="rock_f", l_tex="rock_w" },
    q = { copy="r", f_h=8, [1]={ dx=0, dy=8 } },

    t = { copy="r", c_h=16, c_tex="sky_c", light=192 },
    u = { copy="t", f_h=6 },

    x = { copy="r", [7] = { VDEL=true }},
  },
},

LEAKAGE_POOL =
{
  structure =
  {
    "................",
    "................",
    "................",
    "......twwu......",
    ".....twwwwu.....",
    ".....twwwwwu....",
    "....twohhpwwuu..",
    ".twwwwhcdhwwww..",
    ".wwwwwhabhwws...",
    "....rwmhhnws....",
    ".....wwwwws.....",
    ".....rrwww......",
    ".......wwww.....",
    ".......rwws.....",
    "........rw......",
    "................",
  },

  elements =
  {
    -- pool
    w = { f_h=-12, f_tex="liquid_f", l_tex="liquid_w",
          light=192, kind="kind",
        },

    r = { copy="w", mark=1, [1]={ VDEL=true }},
    s = { copy="w", mark=2, [3]={ VDEL=true }},
    t = { copy="w", mark=3, [7]={ VDEL=true }},
    u = { copy="w", mark=4, [9]={ VDEL=true }},

    -- pipe
    h = { copy="w", c_rel="floor_h", c_h=116 },

    m = { copy="h", mark=1, [1]={ VDEL=true }},
    n = { copy="h", mark=2, [3]={ VDEL=true }},
    o = { copy="h", mark=3, [7]={ VDEL=true }},
    p = { copy="h", mark=4, [9]={ VDEL=true }},

    -- failing liquid
    a = { copy="h", mark=5,
          [2] = { rail="liquid_w", x_offset=84 },
          [4] = { rail="liquid_w", x_offset=72 },
          [1]={ dx=4,dy=4 },
        },
    b = { copy="h", mark=6,
          [2] = { rail="liquid_w", x_offset=0 },
          [6] = { rail="liquid_w", x_offset=12 },
          [3]={ dx=-4,dy=4 },
        },
    c = { copy="h", mark=7,
          [8] = { rail="liquid_w", x_offset=48 },
          [4] = { rail="liquid_w", x_offset=60 },
          [7]={ dx=4,dy=-4 },
        },
    d = { copy="h", mark=8,
          [8] = { rail="liquid_w", x_offset=36 },
          [6] = { rail="liquid_w", x_offset=24 },
          [9]={ dx=-4,dy=-4 },
        },
  },
},

PUMP_INTO_VAT =
{
  structure =
  {
    "............",
    "..CCZZZZDD..",
    ".CBwwwwwwAD.",
    ".CwwwwwwwwD.",
    ".ZwwohhpwwZ.",
    ".ZwwhcdhwwZ.",
    ".ZwwhabhwwZ.",
    ".ZwwmhhnwwZ.",
    ".AwwwwwwwwB.",
    ".ADwwwwwwCB.",
    "..AAZZZZBB..",
    "............",
  },

  elements =
  {
    -- vat
    Z = { f_h=26, f_tex="vat_f", l_tex="vat_w", l_peg="top" },

    A = { copy="Z", mark=1, [1]={ VDEL=true }},
    B = { copy="Z", mark=2, [3]={ VDEL=true }},
    C = { copy="Z", mark=3, [7]={ VDEL=true }},
    D = { copy="Z", mark=4, [9]={ VDEL=true }},

    -- pool
    w = { f_h=16, f_tex="liquid_f", l_tex="liquid_w", kind="kind" },

    r = { copy="w", mark=1, [1]={ VDEL=true }},
    s = { copy="w", mark=2, [3]={ VDEL=true }},
    t = { copy="w", mark=3, [7]={ VDEL=true }},
    u = { copy="w", mark=4, [9]={ VDEL=true }},

    -- hose
    h = { copy="w", c_rel="floor_h", c_h=136,
          c_tex="hose_c", u_tex="hose_w", u_peg="bottom",
        },

    m = { copy="h", mark=1, [1]={ VDEL=true }},
    n = { copy="h", mark=2, [3]={ VDEL=true }},
    o = { copy="h", mark=3, [7]={ VDEL=true }},
    p = { copy="h", mark=4, [9]={ VDEL=true }},

    -- failing liquid
    a = { copy="h", mark=5,
          [2] = { rail="liquid_w", x_offset=84 },
          [4] = { rail="liquid_w", x_offset=72 },
          [1]={ dx=4,dy=4 },
        },
    b = { copy="h", mark=6,
          [2] = { rail="liquid_w", x_offset=0 },
          [6] = { rail="liquid_w", x_offset=12 },
          [3]={ dx=-4,dy=4 },
        },
    c = { copy="h", mark=7,
          [8] = { rail="liquid_w", x_offset=48 },
          [4] = { rail="liquid_w", x_offset=60 },
          [7]={ dx=4,dy=-4 },
        },
    d = { copy="h", mark=8,
          [8] = { rail="liquid_w", x_offset=36 },
          [6] = { rail="liquid_w", x_offset=24 },
          [9]={ dx=-4,dy=-4 },
        },
  },
},


------ Crates ------------------------------------

CRATE =
{
  scale=64,
  region="floor",

  structure =
  {
    "c"
  },

  elements =
  {
    c = { f_add="crate_h", f_h=0,
          f_tex="crate_f", l_tex="crate_w", l_peg="top" },
  },
},

CRATE_LONG =
{
  copy="CRATE",

  structure =
  {
    "cc",
  },
},

CRATE_BIG =
{
  copy="CRATE",

  structure =
  {
    "cc",
    "cc",
  },
},

CRATE_TWO_SIDED =
{
  copy="CRATE",

  elements =
  {
    c = { f_add="crate_h", f_h=0,
          f_tex="crate_f", l_tex="crate_w", l_peg="top",
          [4] = { l_tex="crate_w2", x_offset="x_offset" },
          [6] = { l_tex="crate_w2", x_offset="x_offset" },
        },
  },
},

CRATE_ROTATE_NARROW =
{
  structure =
  {
    "....",
    "....",
    ".c..",
    "....",
  },

  elements =
  {
    c = { f_add="crate_h", f_h=0,
          f_tex="crate_f", l_tex="crate_w", l_peg="top",

          [1] = { dx=-14, dy= 16 },
          [3] = { dx=  0, dy=-14 },
          [9] = { dx= 30, dy=  0 },
          [7] = { dx= 16, dy= 30 },

          [2] = { x_offset=10 }, [4] = { x_offset=10 },
          [6] = { x_offset=10 }, [8] = { x_offset=10 },
        },
  },
},

CRATE_ROTATE =
{
  structure =
  {
    "........",
    "........",
    "........",
    "........",
    "...c....",
    "........",
    "........",
    "........",
  },

  elements =
  {
    c = { f_add="crate_h", f_h=0,
          f_tex="crate_f", l_tex="crate_w", l_peg="top",

          [1] = { dx=-29, dy= 16 },
          [3] = { dx=  0, dy=-29 },
          [9] = { dx= 45, dy=  0 },
          [7] = { dx= 16, dy= 45 },
        },
  },
},

CRATE_ROTATE_22DEG =
{
  structure =
  {
    "........",
    "........",
    "........",
    "........",
    "...c....",
    "........",
    "........",
    "........",
  },

  elements =
  {
    c = { f_add="crate_h", f_h=0,
          f_tex="crate_f", l_tex="crate_w", l_peg="top",

          [1] = { dx=-24, dy=  0 },
          [3] = { dx= 19, dy=-24 },
          [9] = { dx= 43, dy= 19 },
          [7] = { dx=  0, dy= 43 },
        },
  },
},

CRATE_TRIPLE =
{
  structure =
  {
    "aaaacccc",
    "aaaacccc",
    "aaaacccc",
    "aaaaccdd",
    "bbbfee..",
    "bbbfee..",
    "bbbb....",
    "bbbb....",
  },

  elements =
  {
    a = { f_h=128, f_tex="crate_f1", l_tex="crate_w1", l_peg="top" },
    b = { f_h=64,  f_tex="crate_f2", l_tex="crate_w2", l_peg="top" },
    c = { f_h=64,  f_tex="crate_f3", l_tex="crate_w3", l_peg="top" },

    e = { f_h=32,  f_tex="small_f",  l_tex="small_w",  l_peg="top" },

    d = { copy="c", [2] = { x_offset=32 }},
    f = { copy="b", [6] = { x_offset=32 }},
  },
},

CRATE_JUMBLE =
{
  scale=64,

  structure =
  {
    ".Cd..",
    "BCTWX",
    "BTB.d",
    "eWe..",
    ".X...",
  },

  elements =
  {
    T = { f_h=192, f_tex="tall_f", l_tex="tall_w", l_peg="top" },
    W = { f_h=128, f_tex="wide_f", l_tex="wide_w", l_peg="top", [6] = { x_offset=64 } },
    X = { copy="W", [2] = { x_offset=64 }, [4] = { x_offset=64 }, [6] = {} },

    B = { f_h=128, f_tex="crate_f1", l_tex="crate_w1", l_peg="top" },
    C = { f_h=128, f_tex="crate_f2", l_tex="crate_w2", l_peg="top" },

    d = { f_h=64,  f_tex="crate_f1", l_tex="crate_w1", l_peg="top" },
    e = { f_h=64,  f_tex="crate_f2", l_tex="crate_w2", l_peg="top" },
  },
},


------ Cages ------------------------------------

CAGE_PILLAR =
{
  scale=64,

  structure = { "c" },

  elements =
  {
    c = { f_rel="cage_base_h", f_h=0, f_tex="cage_f", l_tex="cage_w",
          c_rel="cage_base_h", c_h=0, c_add="rail_h",
          c_tex="cage_c", u_tex="cage_w",
          u_peg="bottom", l_peg="bottom",

          [2] = { rail="rail_w", impassible=true },
          [4] = { rail="rail_w", impassible=true },
          [6] = { rail="rail_w", impassible=true },
          [8] = { rail="rail_w", impassible=true },
        },
  },

  things =
  {
    { kind="cage_spot", x=32, y=32 },
  },
},

CAGE_SMALL =
{
  scale=64,

  structure = { "c" },

  elements =
  {
    c = { f_rel="cage_base_h", f_h=0,
          f_tex="cage_f", l_tex="cage_w", l_peg="bottom",

          [2] = { rail="rail_w", impassible=true },
          [4] = { rail="rail_w", impassible=true },
          [6] = { rail="rail_w", impassible=true },
          [8] = { rail="rail_w", impassible=true },
        },
  },

  things =
  {
    { kind="cage_spot", x=32, y=32 },
  },
},

CAGE_MEDIUM =
{
  copy="CAGE_SMALL",

  structure =
  {
    "cc",
    "cc",
  },

  things =
  {
    { kind="cage_spot", x=32, y=32, double=true, },
  },
},

CAGE_LARGE =
{
  copy="CAGE_SMALL",

  structure =
  {
    "ccc",
    "ccc",
    "ccc",
  },

  things =
  {
    { kind="cage_spot", x=64, y=64, double=true },
  },
},

CAGE_OPEN_W_POSTS =
{
  region="floor",

  structure =
  {
    "OOccccccccPP",
    "OBddddddddBP",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "MBeeeeeeeeBN",
    "MMccccccccNN",
  },

  elements =
  {
    -- posts
    B = { f_add="rail_h", f_h=56,
          l_tex="beam_w", f_tex="beam_f",
        },

    M = { copy="B",
          [1] = { dx= 8, dy= 8 },
          [7] = { dx= 8, dy= 0 },
          [3] = { dx= 0, dy= 8 },
        },
    N = { copy="B",
          [3] = { dx=-8, dy= 8 },
          [9] = { dx=-8, dy= 0 },
          [1] = { dx= 0, dy= 8 },
        },
    O = { copy="B",
          [7] = { dx= 8, dy=-8 },
          [1] = { dx= 8, dy= 0 },
          [9] = { dx= 0, dy=-8 },
        },
    P = { copy="B",
          [9] = { dx=-8, dy=-8 },
          [3] = { dx=-8, dy= 0 },
          [7] = { dx= 0, dy=-8 },
        },

    -- cage area
    c = { f_h=48, l_tex="cage_w", f_tex="cage_f",
        },
    
    -- grating
    d = { copy="c", mark=1,
          [8] = { rail="rail_w", l_peg="bottom", impassible=true },
          [7] = { dx=0, dy=-4 }, [9] = { dx=0, dy=-4 },
        },
    e = { copy="c", mark=1,
          [2] = { rail="rail_w", l_peg="bottom", impassible=true },
          [1] = { dx=0, dy=4 }, [3] = { dx=0, dy=4 },
        },
    f = { copy="c", mark=1,
          [4] = { rail="rail_w", l_peg="bottom", impassible=true },
          [1] = { dx=4, dy=0 }, [7] = { dx=4, dy=0 },
        },
    g = { copy="c", mark=1,
          [6] = { rail="rail_w", l_peg="bottom", impassible=true },
          [3] = { dx=-4, dy=0 }, [9] = { dx=-4, dy=0 },
        },
  },

  things =
  {
    { kind="cage_spot", x=64, y=64, double=true },
  },
},

CAGE_LARGE_W_LIQUID =
{
  scale=64,

  structure =
  {
    "MNNNO",
    "PLaLQ",
    "PcedQ",
    "PLbLQ",
    "STTTU",
  },

  elements =
  {
    -- liquid
    L = { f_h=-56, f_tex="liquid_f" },

    N = { copy="L", [8] = { rail="rail_w", impassible=true } },
    P = { copy="L", [4] = { rail="rail_w", impassible=true } },
    Q = { copy="L", [6] = { rail="rail_w", impassible=true } },
    T = { copy="L", [2] = { rail="rail_w", impassible=true } },

    M = { [2] = { rail="rail_w", impassible=true },
          [6] = { rail="rail_w", impassible=true },
          [3] = { VDEL=true }
        },
    O = { [2] = { rail="rail_w", impassible=true },
          [4] = { rail="rail_w", impassible=true },
          [1] = { VDEL=true }
        },
    S = { [8] = { rail="rail_w", impassible=true },
          [6] = { rail="rail_w", impassible=true },
          [9] = { VDEL=true }
        },
    U = { [8] = { rail="rail_w", impassible=true },
          [4] = { rail="rail_w", impassible=true },
          [7] = { VDEL=true }
        },

    -- pillar
    e = { f_h=168, f_tex="cage_f", l_tex="cage_w", l_peg="top" },

    a = { copy="e", f_h=104, [8] = { l_tex="cage_sign_w" },
          [7] = { dx=0,dy=-32 }, [9] = { dx=0,dy=-32 } },

    b = { copy="e", f_h=104, [2] = { l_tex="cage_sign_w" },
          [1] = { dx=0,dy= 32 }, [3] = { dx=0,dy= 32 } },

    c = { copy="e", f_h=104, [4] = { l_tex="cage_sign_w" },
          [1] = { dx= 32,dy=0 }, [7] = { dx= 32,dy=0 } },

    d = { copy="e", f_h=104, [6] = { l_tex="cage_sign_w" },
          [3] = { dx=-32,dy=0 }, [9] = { dx=-32,dy=0 } },
  },

  things =
  {
    { kind="cage_spot", x=160, y=160 },
  },
},

CAGE_MEDIUM_W_LIQUID =
{
  scale=64,

  structure =
  {
    "MNNO",
    "PeeQ",
    "PeeQ",
    "STTU",
  },

  elements =
  {
    -- liquid
    L = { f_h=-32, f_tex="liquid_f" },

    N = { copy="L", [8] = { rail="rail_w", impassible=true } },
    P = { copy="L", [4] = { rail="rail_w", impassible=true } },
    Q = { copy="L", [6] = { rail="rail_w", impassible=true } },
    T = { copy="L", [2] = { rail="rail_w", impassible=true } },

    M = { copy="P", [8] = { rail="rail_w", impassible=true } },
    O = { copy="Q", [8] = { rail="rail_w", impassible=true } },
    S = { copy="P", [2] = { rail="rail_w", impassible=true } },
    U = { copy="Q", [2] = { rail="rail_w", impassible=true } },

    -- central pillar
    e = { f_h=96, f_tex="cage_f", l_tex="cage_w", l_peg="top" },
  },

  things =
  {
    { kind="cage_spot", x=96, y=96, double=true },
  },
},

CAGE_NICHE =
{
  structure =
  {
    "########",
    "#cccccc#",
    "#cccccc#",
    "#cccccc#",
    "#cccccc#",
    "#cccccc#",
    "#cccccc#",
    "#cccccc#",
  },

  elements =
  {
    c = { f_rel="low_h", f_h=0,
          c_rel="low_h", c_h=0, c_add="rail_h",
          l_peg="bottom", u_peg="bottom",

          [2] = { rail="rail_w", impassible=true },
        },
  },

  things =
  {
    { kind="cage_spot", x=64, y=64 },
  },
},


------ Corners ------------------------------------

CORNER_BEAM =
{
  add_mode="corner",

  structure =
  {
    "BB..",
    "BB..",
    "....",
    "....",
  },

  elements =
  {
    B = { solid="beam_w" }
  },
},

CORNER_LIGHT =
{
  add_mode="corner",
  environment="indoor",

  structure =
  {
    "BBB.",
    "BLs.",
    "Bss.",
    "....",
  },

  elements =
  {
    B = { solid="beam_w"  },
    L = { solid="lite_w" },

    s = { f_h=16, c_h=-16, l_tex="beam_w", u_tex="beam_w",
          f_tex="beam_f", c_tex="beam_f",
          light=192
        }
  },
},

CORNER_DIAGONAL =
{
  add_mode="corner",

  structure =
  {
    "AAA.",
    "AAA.",
    "AAA.",
    "....",
  },

  elements =
  {
--# A = { solid="wall", [3] = {VDEL=true}, [9] = {VDEL=true} },
    A = { solid="wall", [3] = {VDEL=true} },
  },
},

CORNER_DIAG_BIG =
{
  copy="CORNER_DIAGONAL",

  structure =
  {
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "........",
  },
},

CORNER_DIAG_30DEG =
{
  copy="CORNER_DIAGONAL",

  structure =
  {
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "........",
  },
},

CORNER_CONCAVE =
{
  add_mode="corner",

  structure =
  {
    "##B.",
    "##B.",
    "AA..",
    "....",
  },

  elements =
  {
    A = { solid="wall", [3]={ dx=-27, dy=16 }, [9]={ dx=-16, dy=16 },
          [2] = { x_offset=0 }, [6] = { x_offset=17 },
        },

    B = { solid="wall", [3] = { dx=-16, dy=27 },
          [2] = { x_offset=36 }, [6] = { x_offset=55 },
        },
  },
},

CORNER_CONCAVE_BIG =
{
  add_mode="corner",

  structure =
  {
    "####BB..",
    "####BB..",
    "####BB..",
    "####BB..",
    "AAAA....",
    "AAAA....",
    "........",
    "........",
  },

  elements =
  {
    A = { solid="wall", [3]={ dx=-54, dy=32 }, [9]={ dx=-32, dy=32 },
          [2] = { x_offset=0 }, [6] = { x_offset=34 },
        },

    B = { solid="wall", [3] = { dx=-32, dy=54 },
          [2] = { x_offset=72 }, [6] = { x_offset=110 },
        },
  },
},

CORNER_CONVEX =
{
  add_mode="corner",

  structure =
  {
    "##B.",
    "##B.",
    "AA..",
    "....",
  },

  elements =
  {
    A = { solid="wall", [3] = { dx=-16, dy=5 },
          [2] = { x_offset=0 }, [6] = { x_offset=17 },
        },

    B = { solid="wall", [3] = { dx=-5, dy=16 },
          [2] = { x_offset=36 }, [6] = { x_offset=55 },
        },
  },
},


------ Pillars ------------------------------------

PILLAR =
{
  scale=64,

  structure = { "P" },

  elements =
  {
    P = { solid="wall", l_peg="bottom" }
  },
},

PILLAR_WIDE =
{
  copy="PILLAR",

  structure =
  {
    "PP",
    "PP",
  },
},

PILLAR_LIGHT1 =
{
  structure =
  {
    "BsB.",
    "sLs.",
    "BsB.",
    "....",
  },

  elements =
  {
    B = { solid="beam_w"  },
    L = { solid="lite_w" },

    s = { f_h=16, c_h=-16, l_tex="beam_w", u_tex="beam_w",
          f_tex="beam_f", c_tex="beam_f",
          light=192
        }
  },
},

PILLAR_LIGHT2 =
{
  copy="PILLAR_LIGHT1",

  structure =
  {
    "BssB",
    "sLLs",
    "sLLs",
    "BssB",
  },
},

PILLAR_LIGHT3 =
{
  structure =
  {
    "pppp",
    "pLLp",
    "pLLp",
    "pppp",
  },

  elements =
  {
    L = { solid="lite_w" },

    p = { f_h=48, c_h=-48, light=192, }
  },
},

PILLAR_ROUND_SMALL =
{
  structure =
  {
    "....",
    ".ab.",
    ".cd.",
    "....",
  },

  elements =
  {
    a = { solid="wall", [7] = { dx=-6, dy= 6 }, [9] = { dx= 0, dy=14 },
          [8] = { x_offset= 96 }, [4] = { x_offset=120 },
        },
    b = { solid="wall", [9] = { dx= 6, dy= 6 }, [3] = { dx=14, dy= 0 },
          [6] = { x_offset= 48 }, [8] = { x_offset= 72 },
        },
    c = { solid="wall", [7] = { dx=-14,dy= 0 }, [1] = { dx=-6, dy=-6 },
          [4] = { x_offset=144 }, [2] = { x_offset=168 },
        },
    d = { solid="wall", [1] = { dx= 0, dy=-14}, [3] = { dx= 6, dy=-6 },
          [2] = { x_offset=  0 }, [6] = { x_offset= 24 },
        },
  },
},

PILLAR_ROUND_MEDIUM =
{
  structure =
  {
    "........",
    "........",
    "..jihg..",
    "..k##f..",
    "..m##e..",
    "..abcd..",
    "........",
    "........",
  },

  elements =
  {
    a = { solid="wall",
          [1] = { dx=-12, dy=-12 }, [7] = { dx=-24, dy=-8 },
          [2] = { x_offset=336 }, [4] = { x_offset=313 },
        },
    b = { solid="wall",
          [1] = { dx=-8, dy=-24 },
          [2] = { x_offset=359 },
        },
    c = { solid="wall",
          [1] = { dx=  0, dy=-29 },
          [2] = { x_offset=  0 },
        },

    d = { solid="wall",
          [3] = { dx=12, dy=-12 }, [1] = { dx=8, dy=-24 },
          [6] = { x_offset= 48 }, [2] = { x_offset= 25 },
        },
    e = { solid="wall",
          [3] = { dx=24, dy=-8 },
          [6] = { x_offset= 71 },
        },
    f = { solid="wall",
          [3] = { dx=29, dy= 0 },
          [6] = { x_offset= 96 },
        },

    g = { solid="wall",
          [9] = { dx=12, dy=12 }, [3] = { dx=24, dy=8 },
          [8] = { x_offset=144 }, [6] = { x_offset=121 },
        },
    h = { solid="wall",
          [9] = { dx=8, dy=24 },
          [8] = { x_offset=167 },
        },
    i = { solid="wall",
          [9] = { dx= 0, dy=29 },
          [8] = { x_offset=192 },
        },

    j = { solid="wall",
          [7] = { dx=-12, dy=12 }, [9] = { dx=-8, dy=24 },
          [4] = { x_offset=240 }, [8] = { x_offset=217 },
        },
    k = { solid="wall",
          [7] = { dx=-24, dy=8 },
          [4] = { x_offset=263 },
        },
    m = { solid="wall",
          [7] = { dx=-29, dy= 0 },
          [4] = { x_offset=288 },
        },
  },
},

PILLAR_ROUND_LARGE =
{
  structure =
  {
    "............",
    "............",
    "............",
    "............",
    "....jihg....",
    "....k##f....",
    "....m##e....",
    "....abcd....",
    "............",
    "............",
    "............",
    "............",
  },

  elements =
  {
    a = { solid="wall",
          [1] = { dx=-26, dy=-26 }, [7] = { dx=-42, dy=-16 },
          [2] = { x_offset=448 }, [4] = { x_offset=417 },
        },
    b = { solid="wall",
          [1] = { dx=-16, dy=-42 },
          [2] = { x_offset=479 },
        },
    c = { solid="wall",
          [1] = { dx=  0, dy=-49 },
          [2] = { x_offset=  0 },
        },

    d = { solid="wall",
          [3] = { dx=26, dy=-26 }, [1] = { dx=16, dy=-42 },
          [6] = { x_offset= 64 }, [2] = { x_offset= 33 },
        },
    e = { solid="wall",
          [3] = { dx=42, dy=-16 },
          [6] = { x_offset= 95 },
        },
    f = { solid="wall",
          [3] = { dx=49, dy= 0 },
          [6] = { x_offset=128 },
        },

    g = { solid="wall",
          [9] = { dx=26, dy=26 }, [3] = { dx=42, dy=16 },
          [8] = { x_offset=192 }, [6] = { x_offset=161 },
        },
    h = { solid="wall",
          [9] = { dx=16, dy=42 },
          [8] = { x_offset=223 },
        },
    i = { solid="wall",
          [9] = { dx= 0, dy=49 },
          [8] = { x_offset=256 },
        },

    j = { solid="wall",
          [7] = { dx=-26, dy=26 }, [9] = { dx=-16, dy=42 },
          [4] = { x_offset=320 }, [8] = { x_offset=289 },
        },
    k = { solid="wall",
          [7] = { dx=-42, dy=16 },
          [4] = { x_offset=351 },
        },
    m = { solid="wall",
          [7] = { dx=-49, dy= 0 },
          [4] = { x_offset=384 },
        },
  },
},

PILLAR_DOUBLE_TECH_LARGE =
{
  structure =
  {
    "........................",
    ".oaaaaaaaap..oaaaaaaaap.",
    ".aatbbbbuaa..aatbbbbuaa.",
    ".atbddddbuaaaatbddddbua.",
    ".abceffecbbbbbbceffecba.",
    ".abcfLLfcbbbbbbcfLLfcba.",
    ".abcfLLfcbbbbbbcfLLfcba.",
    ".abceffecbbbbbbceffecba.",
    ".arbddddbsaaaarbddddbsa.",
    ".aarbbbbsaa..aarbbbbsaa.",
    ".maaaaaaaan..maaaaaaaan.",
    "........................",
  },

  elements =
  {
    -- outer base
    a = { f_h= 8, f_tex="outer_f", l_tex="outer_w",
          c_h=-8, c_tex="outer_f", u_tex="outer_w",
          light="outer_lt",
        },

    m = { copy="a", mark=1, [1] = { VDEL=true }},
    n = { copy="a", mark=2, [3] = { VDEL=true }},
    o = { copy="a", mark=3, [7] = { VDEL=true }},
    p = { copy="a", mark=4, [9] = { VDEL=true }},

    -- inner base
    b = { f_h= 16, f_tex="inner_f", l_tex="inner_w",
          c_h=-16, c_tex="inner_f", u_tex="inner_w",
          light="inner_lt",
        },

    r = { copy="b", mark=1, [1] = { VDEL=true }},
    s = { copy="b", mark=2, [3] = { VDEL=true }},
    t = { copy="b", mark=3, [7] = { VDEL=true }},
    u = { copy="b", mark=4, [9] = { VDEL=true }},

    -- shiny decoration
    c = { f_h= 32, f_tex="shine_f", l_tex="shine_w", l_peg="top",
          c_h=-32, c_tex="shine_f", u_tex="shine_w", u_peg="top",
          light="shine_lt",
          [2] = { l_tex="shine_side", u_tex="shine_side" },
          [8] = { l_tex="shine_side", u_tex="shine_side" },
        },
    d = { f_h= 32, f_tex="shine_f", l_tex="shine_w", l_peg="top",
          c_h=-32, c_tex="shine_f", u_tex="shine_w", u_peg="top",
          light="shine_lt",
          [4] = { l_tex="shine_side", u_tex="shine_side" },
          [6] = { l_tex="shine_side", u_tex="shine_side" },
        },

    -- pillars
    e = { solid="pillar_w" },
    L = { solid="light_w"  },

    f = { f_h= 48, f_tex="pillar_f", l_tex="pillar_w", l_peg="bottom",
          c_h=-48, c_tex="pillar_f", u_tex="pillar_w", u_peg="top",
          light="pillar_lt", kind="kind",
        },
  },

  -- FIXME: spot for thing
},


------ Overhangs ------------------------------------

OVERHANG_1 =
{
  structure =
  {
    "PooooooooooP",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "PooooooooooP",
  },

  elements =
  {
    P = { solid="beam_w" }, 

    o = { c_h=-24, c_tex="hang_c", u_tex="hang_u",
          u_peg="top", light_add = -32,
        },
  },
},

OVERHANG_2 =
{
  copy="OVERHANG_1",

  structure =
  {
    "PPooooooooPP",
    "PPooooooooPP",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "PPooooooooPP",
    "PPooooooooPP",
  },
},

OVERHANG_3 =
{
  copy="OVERHANG_1",

  structure =
  {
    "oooooooooooo",
    "oPPooooooPPo",
    "oPPooooooPPo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oPPooooooPPo",
    "oPPooooooPPo",
    "oooooooooooo",
  },
},


------ Doom and Doom II -------------------------------

DOOM2_667_END_SWITCH =
{
  region="floor",

  structure =
  {
    "................",
    ".RRRRRRRRRRRRRR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnSSSSnnnnR.",
    ".RnnnnSSSSnnnnR.",
    ".RnnnnSSSSnnnnR.",
    ".RnnnnSSSSnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RRRRRRRRRRRRRR.",
    "................",
  },

  elements =
  {
    n = { f_h=32 },

    -- Raising part
    R = { f_h=-6, kind="kind", tag="tag" },

    -- Switch
    S = { f_h=96, f_tex="switch_f", l_tex="switch_w",
          l_peg="top", y_offset="y_offset",
        }
  },
},


------ Heretic and Hexen -------------------------------

HEXEN_V_TELEPORT =
{
  structure =
  {
    "............",
    "..WWWWZZZZ..",
    "..WWWWZZZZ..",
    "..WWWWZZZZ..",
    "..WWWWZZZZ..",
    "..WWxxxxZZ..",
    "..WWxxxxZZ..",
    "..WWttttZZ..",
    "..WWssssZZ..",
    "............",
    "............",
    "............",
  },

  elements =
  {
    s = { f_h=16, c_rel="floor_h", c_h=144, light=200,
          f_tex="frame_f", c_tex="frame_c",
          l_tex="frame_w", u_tex="frame_w",
          l_peg="bottom", u_peg="top",
        },

    t = { copy="s", mark=1,
          [7] = { dx=0, dy=-12 },
          [9] = { dx=0, dy=-12 },
          [2] = { rail="border_w", l_peg="bottom", },
          [8] = { rail="telep_w",  l_peg="bottom", },
        },

    x = { copy="s", light=0,
          [2] = { kind="kind", tag="tag" },
        },

    W = { solid="frame_w", [7] = { dx= 48, dy=0 }},
    Z = { solid="frame_w", [9] = { dx=-48, dy=0 }},
  },
},

HEXEN_TRIPLE_PED =
{
  scale=64,
  region="floor",

  structure =
  {
    "p.p",
    "...",
    ".p.",
  },

  elements =
  {
    p = { f_h=0, f_add="ped_h",
          f_tex="ped_f", l_tex="ped_w", l_peg="top",
        }
  },

  things =
  {
    { kind="item_F_t", x=96,  y=96  },
    { kind="item_C_t", x=32,  y=160 },
    { kind="item_M_t", x=160, y=160 },
  },
},


------ Wolfenstein ------------------------------------

WOLF_ELEVATOR =
{
  scale=64,

  structure =
  {
    "#####",
    "##E##",
    "#E.E#",
    "#FdF#",
  },

  elements =
  {
    E = { solid="elevator" },
    F = { solid="front"    },

    d = { kind="door_kind" },
  },
},

WOLF_PACMAN_BASE =
{
  scale=64,

  structure = { "#" }, -- dummy

  elements =
  {
    G = { solid="ghost_w" },

    B = { thing="blinky", angle=90  },
    C = { thing="clyde",  angle=90  },
    I = { thing="inky",   angle=270 },
    P = { thing="pinky",  angle=270 },

    d = { thing="dot_t" },
    t = { thing="treasure1" },
    u = { thing="treasure2" },
    m = { thing="first_aid" },
  },
},

WOLF_PACMAN_MID_1 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "##B.####.######.####C.##",
    "##d.####.######.####d.##",
    "##..##..d.d.d.d.d.##..##",
    "##d.##............##d.##",
    "##..##.dGGG..GGGd.##..##",
    "##d.##.dGGG..GGGd.##d.##",
    "#...##.dGG.tt.GGd.##...#",
    "d.G....dG.tttt.Gd....G.d",
    "..G.d..dGttttttGd..d.G..",
    "#...##.dGGttttGGd.##...#",
    "##d.##.dGGGuuGGGd.##d.##",
    "##..##.dGGGGGGGGd.##..##",
    "##d.##............##d.##",
    "##..##.d.d.d.d.d..##..##",
    "##d.####.######.####d.##",
    "##I.####.######.####P.##",
  },
},

WOLF_PACMAN_MID_2 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "##B.#######..#######.C##",
    "##d.#######.d#######.d##",
    "##d.###..........###.d##",
    "##d.##...d..d..d..##.d##",
    "##d.##d.GGGGGGGG.d##.d##",
    "###ddd..GGtt.GGG..ddd###",
    "######d.GGttt.GG.d######",
    "######..GGtutt....######",
    "######d.GGtutt...d######",
    "######..GGttt.GG..######",
    "###dddd.GGtt.GGG.dddd###",
    "##d.##..GGGGGGGG..##.d##",
    "##d.##.d..d..d..d.##.d##",
    "##d.###..........###.d##",
    "##d.#######d.#######.d##",
    "##I.#######..#######.P##",
  },
},

WOLF_PACMAN_MID_3 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "##B.####.######.####C.##",
    "##d.####d######.####d.##",
    "##..d.d.........d.d...##",
    "######..d.d.d.d...######",
    "dddddd..GGGGGGGGd.dddddd",
    "d#####.dGGtuutGG..#####d",
    "d#####..GttttttGd.#####d",
    "d#####.dG.tttt.G..#####d",
    "dddddd..GGGttGGGd.dddddd",
    "######.dGGGttGGG..######",
    "##...d..G......Gd.d.d.##",
    "##.d##.dG.GGGG.G..##..##",
    "##..##...d.d.d.d..##.d##",
    "##.d##............##..##",
    "##..#######d.#######.d##",
    "##Id#######..#######P.##",
  },
},

WOLF_PACMAN_CORN_1 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "#########...........",
    "#########d.d.d.d.d..",
    "#########.########.#",
    "####.d...d########d#",
    "####...d....##m.....",
    ".d.d.d####d.##..d.d.",
    ".........#..d.d.####",
    "d.#####..#####..d.d.",
    "..###..d..d.##......",
    "m.###d.###..###d####",
    ".......###..###.####",
    ".d.d.d.###d.d.d.d.d.",
  },
},

WOLF_PACMAN_CORN_2 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "##########..####....",
    "..d.d...d.d.####.d..",
    "..###.d#########..##",
    "d.###..#####.d.d.d##",
    "..###d.d.d.d..######",
    "m.######..#####md.d.",
    "..######..d.###d####",
    "d.#########.###.####",
    "..d.d.d.###d.d.d..##",
    "######..###.####..##",
    "######d.d.d.####.d..",
    "##########..####....",
  },
},

WOLF_PACMAN_CORN_3 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "##########..####.##.",
    "#####..d.d.d.d..d##d",
    "#####.........d#.##.",
    "#####.d######..#.d.d",
    "#d.##....d.m#.d#..##",
    "...d...####.#....d##",
    ".....d.####.#.d#####",
    "#d.##....d.m#...d.d.",
    "#####.d######.d####d",
    "#####............##.",
    "#####..d.d.d.d.d.##d",
    "##########..####....",
  },
},


} -- DOOM.FACTORY.PREFABS

ULTDOOM.FACTORY.D1_QUESTS =
{
  key =
  {
    k_blue=50, k_red=50, k_yellow=50
  },

  switch =
  {
    sw_blue=50, sw_hot=30,
    sw_vine=10, sw_skin=40,
    sw_metl=50, sw_gray=20,
  },

  weapon =
  {
    saw=10, launch=80, plasma=60, bfg=5
  },

  item =
  {
    blue_armor=40, invis=40, backpack=25,
    berserk=20, goggle=5, invul=2, map=3
  },
}

ULTDOOM.FACTORY.D1_COMBOS =
{
  ---- TECH ------------

  TECH_TRON =
  {
    theme_probs = { TECH=20 },
    mat_pri = 12,

    wall  = "COMPOHSO",
    floor = "CEIL3_2",
    ceil  = "CEIL5_2",

    lift = "PLAT1",
    step = "STEP1",
    step_floor = "STEP1",
  },

  ---- CAVE ---------------

  CAVE_ASH =
  {
    theme_probs = { CAVE=30 },
    mat_pri = 2,

    wall  = "ASHWALL",
    floor = "FLAT5_8", -- FLOOR6_2
    ceil  = "FLAT5_8",

    arch  = "arch_russian_WOOD",

    sc_fabs = { stalagmite_MED=40, other=10 },
  },

}

ULTDOOM.FACTORY.D1_EXITS =
{
}

ULTDOOM.FACTORY.D1_HALLWAYS =
{
}

ULTDOOM.FACTORY.D1_CRATES =
{
  COMPUTER =
  {
    wall = "COMPUTE1", h=128, floor = "FLAT23",
    side_x_offset=67
  },

  PLANET1 =
  {
    wall = "PLANET1", h=128, floor = "FLAT23",
    side_x_offset=64
  },
 
  PLANET2 =
  {
    wall = "PLANET1", h=64, floor = "FLAT23",
    x_offset=128, side_y_offset=64
  },
 
  SKIN =
  {
    wall = "SKINBORD", h=64, floor = "CEIL3_3", can_rotate=true
  },
}

ULTDOOM.FACTORY.D1_RAILS =
{
  r_1 = { wall="BRNSMALC", w=128, h=64  },
  r_2 = { wall="MIDGRATE", w=128, h=128 },
}

ULTDOOM.FACTORY.D1_WALL_PREFABS =
{
  wall_pic_COMP2 =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    theme_probs = { TECH=90, INDUSTRIAL=30 },
    skin = { pic_w="COMP2", lite_w="SUPPORT2", pic_h=128 },
  },

  wall_pic_TEKWALL2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 144,
    skin = { pic_w="TEKWALL2", lite_w="METAL", pic_h=128 },
    theme_probs = { TECH=10 },
  },

  wall_pic_TEKWALL3 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 144,
    skin = { pic_w="TEKWALL3", lite_w="METAL", pic_h=128 },
    theme_probs = { TECH=10 },
  },

  wall_pic_TEKWALL5 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 144,
    skin = { pic_w="TEKWALL5", lite_w="METAL", pic_h=128 },
    theme_probs = { TECH=10 },
  },

  lights_thin_LITERED =
  {
    prefab = "WALL_LIGHTS_THIN",
    min_height = 128,
    theme_probs = { TECH=90, HELL=2 },
    skin =
    {
      lite_w="LITERED", lite_side="LITERED",
      frame_f="FLOOR1_6",
      wall_lt=255, kind=8,
    },
  },

}

ULTDOOM.FACTORY.D1_ROOMS =
{
  PLANT =
  {
    wall_fabs =
    {
      wall_pic_COMP2 = 30, 
      other = 100
    },
  },

  COMPUTER =
  {
    wall_fabs =
    {
      wall_pic_COMP2 = 30, 
      other = 100
    },
  },

  TORTURE =
  {
    space_range = { 60, 90 },

    sc_count = { 6,16 },

    scenery =
    {
      impaled_human  = 40, impaled_twitch = 40,

      hang_arm_pair  = 40, hang_leg_pair  = 40,
      hang_leg_gone  = 40, hang_leg       = 40,
      hang_twitching = 40,

      other = 50
    },

    sc_fabs =
    {
      pillar_SPDUDE5=30, other=50
    },

    wall_fabs =
    {
      wall_pic_SPDUDE1 = 20, wall_pic_SPDUDE2 = 20,

      other = 50
    },
  },

  PRISON =
  {
  },
}

------------------------------------------------------------

ULTDOOM.FACTORY.D1_EPISODE_THEMES =
{
  { URBAN=5, INDUSTRIAL=5, TECH=9, CAVE=2, HELL=2 },
  { URBAN=9, INDUSTRIAL=5, TECH=4, CAVE=2, HELL=4 },
  { URBAN=1, INDUSTRIAL=1, TECH=1, CAVE=5, HELL=9 },
  { URBAN=4, INDUSTRIAL=2, TECH=2, CAVE=4, HELL=7 },

  -- this entry used for a single episode or level
  { URBAN=5, INDUSTRIAL=4, TECH=6, CAVE=4, HELL=6 },
}

ULTDOOM.FACTORY.D1_SECRET_EXITS =
{
  E1M3 = true,
  E2M5 = true,
  E3M6 = true,
  E4M2 = true,
}

ULTDOOM.FACTORY.D1_EPISODE_BOSSES =
{
  "baron", -- the Bruiser Brothers
  "cyber",
  "spider",
  "spider",
}

ULTDOOM.FACTORY.D1_SKY_INFO =
{
  { color="white",  light=192 },
  { color="red",    light=176 },
  { color="red",    light=192 },
  { color="orange", light=192 },
}

function ULTDOOM.get_factory_levels(episode)

  local level_list = {}

  local theme_probs = ULTDOOM.FACTORY.D1_EPISODE_THEMES[episode]
  if OB_CONFIG.length ~= "full" then
    theme_probs = ULTDOOM.FACTORY.D1_EPISODE_THEMES[5]
  end

  for map = 1,9 do
    local Level =
    {
      name = string.format("E%dM%d", episode, map),

      episode   = episode,
      ep_along  = map,
      ep_length = 9,

      theme_probs = theme_probs,
      sky_info = ULTDOOM.FACTORY.D1_SKY_INFO[episode],

      boss_kind   = (map == 8) and ULTDOOM.FACTORY.D1_EPISODE_BOSSES[episode],
      secret_kind = (map == 9) and "plain",

      toughness_factor = sel(map==9, 1.2, 1 + (map-1) / 5),
    }

    if ULTDOOM.FACTORY.D1_SECRET_EXITS[Level.name] then
      Level.secret_exit = true
    end

    std_decide_quests(Level, ULTDOOM.FACTORY.D1_QUESTS, DOOM.FACTORY.DM_QUEST_LEN_PROBS)

    table.insert(level_list, Level)
  end

  return level_list
end


function ULTDOOM.factory_setup()

  GAME.FACTORY = 
  {
    doom_format = true,

    plan_size = 10,
    cell_size = 9,
    cell_min_size = 6,

    caps = { heights=true, sky=true, 
             fragments=true, move_frag=true, rails=true,
             closets=true,   depots=true,
             switches=true,  liquids=true,
             teleporters=true,
           },

    SKY_TEX    = "F_SKY1",
    ERROR_TEX  = "FIREBLU1",
    ERROR_FLAT = "SFLR6_4",

    classes  = { "doomguy" },

    monsters = DOOM.FACTORY.DM_MONSTERS,
    bosses   = DOOM.FACTORY.DM_BOSSES,
    weapons  = DOOM.FACTORY.DM_WEAPONS,

    things = DOOM.FACTORY.DM_THINGS,

    mon_give       = DOOM.FACTORY.DM_MONSTER_GIVE,
    mon_weap_prefs = DOOM.FACTORY.DM_MONSTER_WEAPON_PREFS,
    initial_model  = DOOM.FACTORY.DM_INITIAL_MODEL,

    pickups = DOOM.FACTORY.DM_PICKUPS,
    pickup_stats = { "health", "bullet", "shell", "rocket", "cell" },
    niceness = DOOM.FACTORY.DM_NICENESS,

    dm = DOOM.FACTORY.DM_DEATHMATCH,
    dm_exits = DOOM.FACTORY.DM_DEATHMATCH_EXITS,

    combos    = DOOM.FACTORY.DM_COMBOS,
    exits     = DOOM.FACTORY.DM_EXITS,
    hallways  = DOOM.FACTORY.DM_HALLWAYS,

    hangs     = DOOM.FACTORY.DM_OVERHANGS,
    pedestals = DOOM.FACTORY.DM_PEDESTALS,
    mats      = DOOM.FACTORY.DM_MATS,
    crates    = DOOM.FACTORY.DM_CRATES,

    liquids   = DOOM.FACTORY.DM_LIQUIDS,
    switches  = DOOM.FACTORY.DM_SWITCHES,
    doors     = DOOM.FACTORY.DM_DOORS,
    key_doors = DOOM.FACTORY.DM_KEY_DOORS,
    lifts     = DOOM.FACTORY.DM_LIFTS,

    images    = DOOM.FACTORY.DM_IMAGES,
    lights    = DOOM.FACTORY.DM_LIGHTS,

    rooms     = DOOM.FACTORY.DM_ROOMS,
    themes    = DOOM.FACTORY.DM_THEMES,

    sc_fabs   = DOOM.FACTORY.DM_SCENERY_PREFABS,
    feat_fabs = DOOM.FACTORY.DM_FEATURE_PREFABS,
    wall_fabs = DOOM.FACTORY.DM_WALL_PREFABS,

    door_fabs = DOOM.FACTORY.DM_DOOR_PREFABS,
    arch_fabs = DOOM.FACTORY.DM_ARCH_PREFABS,
    win_fabs  = DOOM.FACTORY.DM_WINDOW_PREFABS,
    misc_fabs = DOOM.FACTORY.DM_MISC_PREFABS,

    toughness_factor = 1.00,
    
    depot_info = { teleport_kind=97 },

    room_heights = { [96]=5, [128]=25, [192]=70, [256]=70, [320]=12 },
    space_range  = { 20, 90 },

    diff_probs = { [0]=20, [16]=20, [32]=80, [64]=60, [96]=20 },
    bump_probs = { [0]=40, [16]=20, [32]=20, [64]=10 },

    door_probs   = { out_diff=75, combo_diff=50, normal=15 },
    window_probs = { out_diff=75, combo_diff=60, normal=35 },

    hallway_probs = { 20, 30, 41, 53, 66 },
    shack_prob    = 25,
  }

  GAME.FACTORY.episodes   = 4
  GAME.FACTORY.level_func = ULTDOOM.get_factory_levels

  GAME.FACTORY.quests   = ULTDOOM.FACTORY.D1_QUESTS

  GAME.FACTORY.rooms    = table.merge_w_copy(GAME.FACTORY.rooms,    ULTDOOM.FACTORY.D1_ROOMS)
  GAME.FACTORY.combos   = table.merge_w_copy(GAME.FACTORY.combos,   ULTDOOM.FACTORY.D1_COMBOS)
  GAME.FACTORY.exits    = table.merge_w_copy(GAME.FACTORY.exits,    ULTDOOM.FACTORY.D1_EXITS)
  GAME.FACTORY.hallways = table.merge_w_copy(GAME.FACTORY.hallways, ULTDOOM.FACTORY.D1_HALLWAYS)
  GAME.FACTORY.crates   = table.merge_w_copy(GAME.FACTORY.crates,   ULTDOOM.FACTORY.D1_CRATES)

  GAME.FACTORY.wall_fabs = table.merge_w_copy(GAME.FACTORY.wall_fabs, ULTDOOM.FACTORY.D1_WALL_PREFABS)

  GAME.FACTORY.rails = ULTDOOM.FACTORY.D1_RAILS

  -- remove DOOM2-only weapons and items --

  GAME.FACTORY.weapons["super"] = nil

  GAME.FACTORY.dm.weapons["super"] = nil

  local SUB_LISTS =
  {
    "things",
    "monsters", "bosses", "weapons", "pickups",
    "combos",   "exits",  "hallways",
    "hangs",    "crates", "doors",    "mats",
    "lights",   "pics",   "liquids",  "rails",
    "scenery",  "rooms",   "themes",
    "sc_fabs",  "misc_fabs", "feat_fabs",
  }

  for zzz,sub in ipairs(SUB_LISTS) do
    if GAME.FACTORY[sub] then
      table.name_up(GAME.FACTORY[sub])
    end
  end

  GAME.FACTORY.PREFABS = ULTDOOM.FACTORY.PREFABS

  table.name_up(GAME.FACTORY.PREFABS)

  table.expand_copies(GAME.FACTORY.PREFABS)

  for name,P in pairs(GAME.FACTORY.PREFABS) do
    table.expand_copies(P.elements)
  
    -- set size values
    local f_deep = #P.structure
    local f_long = #P.structure[1]

    if not P.scale then
      P.scale = 16
    end

    if P.scale == 64 then
      P.long, P.deep = f_long, f_deep

    elseif P.scale == 16 then
      if (f_long % 4) ~= 0 or (f_deep % 4) ~= 0 then
        error("Prefab not a multiple of four: " .. tostring(P.name))
      end

      P.long = math.floor(f_long / 4)
      P.deep = math.floor(f_deep / 4)
    else
      error("Unsupported scale " .. tostring(P.scale) .. " in prefab: " .. tostring(P.name))
    end
  end

  table.name_up(GAME.FACTORY.PREFABS)

  local function pow_factor(info)
    return 5 + 19 * info.hp ^ 0.5 * (info.dm / sel(info.melee,80,50)) ^ 1.2
  end

  for name,info in pairs(GAME.FACTORY.monsters) do
    info.pow = pow_factor(info)

    gui.debugf("Monster %s : power %f\n", name, info.pow)

    local def = GAME.FACTORY.things[name]
    if not def then
      error("Monster has no definition?? : " .. tostring(name))
    end

    info.r = non_nil(def.r)
    info.h = non_nil(def.h)
  end

  local episode_num

  if OB_CONFIG.length == "single" then
    episode_num = 1
  elseif OB_CONFIG.length == "episode" then
    episode_num = GAME.FACTORY.min_episodes or 1
  else
    episode_num = GAME.FACTORY.episodes
  end

  -- build episode/level lists...should I be using the top-level map_num stuff? - Dasho
  GAME.FACTORY.all_levels = {}

  for epi = 1,episode_num do
    local levels = GAME.FACTORY.level_func(epi)
    for zzz, L in ipairs(levels) do
      table.insert(GAME.FACTORY.all_levels, L)
    end
  end

end

function ULTDOOM.slump_setup()
  if ob_match_game({game = {doom1=1, ultdoom=1}}) then
    if OB_CONFIG.theme == "default" then
      PARAM.slump_config = ULTDOOM.THEMES.DEFAULTS.slump_config
    elseif OB_CONFIG.theme == "jumble" then
      local possible_configs = {}
      for _,tab in pairs(ULTDOOM.THEMES) do
        if tab.slump_config then
          table.insert(possible_configs, tab.slump_config)
        end
      end
      PARAM.slump_config = rand.pick(possible_configs)
    elseif ULTDOOM.THEMES[OB_CONFIG.theme].slump_config then
      PARAM.slump_config = ULTDOOM.THEMES[OB_CONFIG.theme].slump_config
    else
      PARAM.slump_config = ULTDOOM.THEMES.DEFAULTS.slump_config
    end
  end
end

--------------------------------------------------------------------

OB_GAMES["doom1"] =
{
  label = _("Doom 1"),

  priority = 98,  -- keep at second spot

  engine = "idtech_1",
  format = "doom",
  game_dir = "doom",
  iwad_name = "doom.wad",

  use_generics = true,

  tables =
  {
    DOOM, ULTDOOM
  },

  hooks =
  {
    get_levels = ULTDOOM.get_levels,
    slump_setup = ULTDOOM.slump_setup,
    factory_setup = ULTDOOM.factory_setup,
    end_level  = DOOM.end_level,
    all_done   = DOOM.all_done
  },
}


OB_GAMES["ultdoom"] =
{
  label = _("Ultimate Doom"),

  engine = "idtech_1",
  extends = "doom1",

  priority = 97  -- keep at third spot

  -- no additional tables

  -- no additional hooks
}


--------------------------------------------------------------------

OB_THEMES["deimos"] =
{
  label = _("Deimos"),
  game = "doom1",
  priority = 40,
  name_class = "TECH",
  mixed_prob = 30,
}


OB_THEMES["flesh"] =
{
  label = _("Thy Flesh"),
  game = "ultdoom",
  priority = 10,
  name_class = "GOTHIC",
  mixed_prob = 20,
}
