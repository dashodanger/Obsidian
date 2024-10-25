----------------------------------------------------------------
--  MODULE: Obsidian Resource Pack Materials
----------------------------------------------------------------
--
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
--  Copyright (C) 2015-2022 Reisal
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

-- Reminder: Please keep texture material additions alphabetized
-- and in categories for a more manageable setup when the file is
-- modified, thanks!

OBS_RESOURCE_PACK_LIQUID_DEFS =
{
  hotlava  = { mat="XLAV1", special=5, light_add=56, damage=10 },
  magma  = { mat="MAGMA1",  special=5, light_add=56, damage=10 },
  qlava  = { mat="QLAVA1", special=5, light_add=56, damage=10 },
  bsludge = { mat="OSLIME01", special=0 },
  gwater   = { mat="SLUDGE01", special=0 },
  ice   = { mat="SNOW9", special=0 }, --Looks best when outdoor environment is snow only
  ice2   = { mat="SNOW2", special=0 }, --Looks best when outdoor environment is snow only
  purwater   = { mat="PURW1", special=0 },
}

OBS_RESOURCE_PACK_MATERIALS = {

  -- Organic / Semi-organic
  ALTASH = { t="ALTASH", f="RROCK03" }, --ASPHALT from Evilution
  ASH01  = { t="ASH01",  f="FLOOR6_2" }, --ASHWALL2
  ASH02  = { t="ASH02",  f="RROCK03" }, --ASHWALL3
  ASH03  = { t="ASH03",  f="FLAT10" }, --ASHWALL4
  ASH04 = { t="ASH04", f="RROCK18" }, --ASHWALL7 variant
  ASH05  = { t="ASH05",  f="FLOOR6_2" }, --ASHWALL
  ASHWALL1  = { t="ASHWALL1", f="RROCK03" }, --ASHWALL2 & ASHWALL3 combo
  GREEN01 = { t="GREEN01", f="RROCK20" }, --Plutonia 2
  GREEN02 = { t="GREEN02", f="RROCK20" }, --Plutonia 2
  GREEN03 = { t="GREEN03", f="RROCK20" }, --Plutonia 2
  VINES1 = { t="VINES1", f="RROCK16" },
  VINES2 = { t="VINES2", f="RROCK16" },
  VINES3 = { t="VINES3", f="RROCK16" },
  VINES4 = { t="VINES4", f="RROCK16" },
  ZIM1 = { t="ZIM1", f="RROCK20" }, --ZIMMER1
  ZIM2 = { t="ZIM2", f="RROCK20" }, --ZIMMER2
  ZIM3 = { t="ZIM3", f="RROCK18" }, --ZIMMER3
  ZIM4 = { t="ZIM4", f="RROCK18" }, --ZIMMER4

  GRNSTONE = { t="GRNSTONE", f="GRNRKF"}, --originally green recolor of ROCKRED
  GRNRKF = { t="GRNSTONE", f="GRNRKF"},   --now reapproiated as a green glowy crystal

  -- Doors
  BIGDOOR8  = { t="BIGDOOR8",  f="CEIL5_2" }, --Similar to BIGDOOR7
  BIGDOOR9  = { t="BIGDOOR9",  f="CEIL5_2" }, --Similar to BIGDOOR7
  BIGDOOR0  = { t="BIGDOOR0",  f="CEIL5_2" }, --Similar to BIGDOOR7
  BIGDOORA  = { t="BIGDOORA",  f="FLOOR7_1" }, --Similar to BIGDOOR4
  BIGDOORB  = { t="BIGDOORB",  f="CEIL5_2" }, --Similar to BIGDOOR7, 64x128
  BIGDOORC  = { t="BIGDOORC",  f="CEIL5_1" },
  BIGDOORD  = { t="BIGDOORD",  f="CEIL5_1" },
  BIGDOORE  = { t="BIGDOORE",  f="FLOOR7_1" },
  BIGDOORF  = { t="BIGDOORF",  f="CEIL5_1" },
  BIGDOORG  = { t="BIGDOORG",  f="FLAT20" },
  BIGDOORH  = { t="BIGDOORH",  f="CEIL5_1" },
  BIGDOORI  = { t="BIGDOORI",  f="CEIL5_2" },
  BIGDOORJ  = { t="BIGDOORJ",  f="CEIL5_2" },
  BIGDOORK  = { t="BIGDOORK",  f="CEIL5_2" },
  BIGDOORL  = { t="BIGDOORL",  f="G08" },
  BIGDOORM  = { t="BIGDOORM",  f="WARN1" },
  BIGDOORN  = { t="BIGDOORN",  f="FLAT5_4" },
  DOORHI  = { t="DOORHI",  f="FLAT19" }, -- Tall 64x128 door. From Doom1,
  ICKDOOR1  = { t="ICKDOOR1",  f="FLAT19" }, -- ICKWALL style door. From Doom1,

  -- Bricks / Concrete
  BIGSTONE = { t="BIGSTONE", f="FLAT5_4" },
  BIGSTON2 = { t="BIGSTON2", f="FLAT5_4" },
  BIGSTON3 = { t="BIGSTON3", f="FLAT1" },
  BIGSTON4 = { t="BIGSTON4", f="FLOOR7_1" },
  BLIT01 = { t="BLIT01", f="RROCK10" }, --BRICKLIT
  BRIKS01 = { t="BRIKS01", f="FLAT5_4" }, --White bricks, 128x128,
  BRIKS02 = { t="BRIKS02", f="FLOOR7_1" }, --Brown bricks, 128x128,
  BRIKS03 = { t="BRIKS03", f="RROCK09" }, --Tan bricks, 128x128,
  BRIKS04 = { t="BRIKS04", f="FLAT19" }, --Cream bricks, 64x128,
  BRIKS05 = { t="BRIKS05", f="FLOOR0_1" }, --Tan bricks, 64x128,
  BRIKS06 = { t="BRIKS06", f="FLAT5_5" }, --Tan bricks, 128x128,
  BRIKS07 = { t="BRIKS07", f="FLOOR7_1" }, --Brown bricks, 128x128,
  BRIKS08 = { t="BRIKS08", f="RROCK14" }, --BIGBRIK1,
  BRIKS09 = { t="BRIKS09", f="FLAT5_4" }, --BIGBRIK2,
  BRIKS10 = { t="BRIKS10", f="FLAT5_4" },
  BRIKS11 = { t="BRIKS11", f="BLACK0" },
  BRIKS12 = { t="BRIKS12", f="RROCK09" },
  BRIKS13 = { t="BRIKS13", f="FLAT1" },
  BRIKS14 = { t="BRIKS14", f="RROCK09" },
  BRIKS15 = { t="BRIKS15", f="FLOOR7_1" }, --Brown
  BRIKS16 = { t="BRIKS16", f="FLOOR7_1" }, --Brown
  BRIKS17 = { t="BRIKS17", f="FLOOR7_1" }, --Brown
  BRIKS18 = { t="BRIKS18", f="FLAT5_4" }, --Gray
  BRIKS19 = { t="BRIKS19", f="FLAT5_5" }, --Tan
  BRIKS20 = { t="BRIKS20", f="FLAT5_5" }, --Tan
  BRIKS21 = { t="BRIKS21", f="FLAT5_4" }, --Gray
  BRIKS22 = { t="BRIKS22", f="FLAT5_5" }, --Tannish
  BRIKS23 = { t="BRIKS23", f="FLAT5_4" }, --Gray
  BRIKS24 = { t="BRIKS24", f="FLAT5_5" }, --Tannish
  BRIKS25 = { t="BRIKS25", f="RROCK20" }, --Green
  BRIKS26 = { t="BRIKS26", f="FLAT5_4" }, --Gray
  BRIKS27 = { t="BRIKS27", f="FLAT5_4" }, --Gray
  BRIKS28 = { t="BRIKS28", f="RROCK16" }, --Brown w/ vines
  BRIKS29 = { t="BRIKS29", f="FLAT1" },
  BRIKS30 = { t="BRIKS30", f="GSTN01" },
  BRIKS31 = { t="BRIKS31", f="FLOOR7_1" },
  BRIKS32 = { t="BRIKS32", f="FLAT5_4" },
  BRIKS33 = { t="BRIKS33", f="FLOOR7_1" },
  BRIKS34 = { t="BRIKS34", f="FLAT5_4" },
  BRIKS35 = { t="BRIKS35", f="BLACK0" },
  BRIKS36 = { t="BRIKS36", f="BLACK0" },
  BRIKS37 = { t="BRIKS37", f="FLAT5_4" }, -- Blue
  BRIKS38 = { t="BRIKS38", f="FLAT5_4" }, -- Blue
  BRIKS39 = { t="BRIKS39", f="GSTN02" },
  BRIKS40 = { t="BRIKS40", f="RROCK09" },
  BRIKS41 = { t="BRIKS41", f="RROCK09" },
  BRIKS42 = { t="BRIKS42", f="FLOOR7_1" },
  BRIKS43 = { t="BRIKS43", f="FLAT1" },

  BST01  = { t="BST01",  f="RROCK11" }, --BSTONE1,
  BST02  = { t="BST02",  f="RROCK12" }, --BSTONE2,
  BST03  = { t="BST03",  f="RROCK12" }, --BSTONE3,

  BRVINE  = { t="BRVINE",  f="FLOOR0_1" }, --BROVINE

  GRAY6 = { t="GRAY6", f="FLAT18" },
  GRAY8 = { t="GRAY8", f="FLAT18" },
  GRAY9 = { t="GRAY9", f="FLAT5_4" },
  GRAYDANG = { t="GRAYDANG", f="FLAT18" }, -- GRAY1 w/ no entry sign. From Doom1,

  STON4 = { t="STON4", f="FLAT5_4" }, --STONE4,
  STON6 = { t="STON6", f="RROCK09" }, --STONE6,
  STON7 = { t="STON7", f="FLAT5_4" },
  STONE8 = { t="STONE8", f="FLAT1" },
  STONE9 = { t="STONE9", f="FLAT1" },
  STONE10 = { t="STONE10", f="FLAT5_4" },
  STONGARG = { t="STONGARG", f="FLAT1" }, -- STONE3 with gargoyle faces. From Doom1,

  -- Urban specific
  CITY01 = { t="CITY01", f="RROCK10" }, -- BRICK1 style
  CITY02 = { t="CITY02", f="FLOOR0_1" }, -- Tannish marble w/ window
  CITY03 = { t="CITY03", f="FLOOR7_1" }, -- Darker tan bricks w/ window
  CITY04 = { t="CITY04", f="FLOOR7_1" }, -- Same as CITY03 but different window
  CITY05 = { t="CITY05", f="FLAT1" }, -- Gray bricks and black windows
  CITY06 = { t="CITY06", f="FLOOR0_1" }, -- BROWN1 style and black windows
  CITY07 = { t="CITY07", f="FLAT1" }, -- Industrial looking
  CITY08 = { t="CITY08", f="FLAT1" }, -- Gray bricks with stone arch window
  CITY09 = { t="CITY09", f="FLAT1" }, -- Small gray bricks with stone arch window
  CITY10 = { t="CITY10", f="FLOOR7_1" }, -- Small brown bricks with stone arch window
  CITY11 = { t="CITY11", f="FLOOR7_1" },
  CITY12 = { t="CITY12", f="FLAT5_5" },
  CITY13 = { t="CITY13", f="FLOOR7_1" },
  CITY14 = { t="CITY14", f="CEIL5_2"},

  -- night versions
  CITY04N = { t="CITY04N", f="FLOOR7_1"},
  CITY05N = { t="CITY05N", f="FLAT1"},
  CITY06N = { t="CITY06N", f="FLOOR0_1"},
  CITY07N = { t="CITY07N", f="FLAT1"},
  CITY11N = { t="CITY11N", f="FLOOR7_1"},
  CITY12N = { t="CITY12N", f="FLAT5_5"},
  CITY13N = { t="CITY13N", f="FLOOR7_1"},
  CITY14N = { t="CITY14N", f="CEIL5_2"},

  URBAN1 = { t="URBAN1", f="RROCK10" },
  URBAN2 = { t="URBAN2", f="FLAT1" },
  URBAN3 = { t="URBAN3", f="FLAT5_4" },
  URBAN4 = { t="URBAN4", f="FLOOR0_1" },

  -- These 4 can be useful for the urban shutters instead of the STEP# textures
  URBAN5 = { t="URBAN5", f="FLOOR7_1" }, -- Brown
  URBAN6 = { t="URBAN6", f="FLOOR7_1" }, -- Brown, warning lines
  URBAN7 = { t="URBAN7", f="FLAT1" }, -- Gray
  URBAN8 = { t="URBAN8", f="FLAT1" }, -- Gray, warning lines

 -- Cement
 -- Copies of the CEMENT# textures so they can be used normally.
  CEM01  = { t="CEM01",  f="FLAT19" }, --CEMENT7,
  CEM02  = { t="CEM02",  f="FLAT19" }, --CEMENT9,
  CEM03  = { t="CEM03",  f="FLAT19" }, --CEMENT1,
  CEM04  = { t="CEM04",  f="FLAT19" }, --CEMENT5,
  CEM05  = { t="CEM05",  f="FLAT19" }, --CEMENT2,
  CEM06  = { t="CEM06",  f="FLAT19" }, --CEMENT3,
  CEM07  = { t="CEM07",  f="FLAT19" }, --CEMENT6,
  CEM08  = { t="CEM08",  f="FLAT19" }, --CEMENT4,
  CEM09  = { t="CEM09",  f="FLAT19" },

   -- Not CEMENT type, just concrete type
  CEM10  = { t="CEM10",  f="FLAT19" },
  CEM11  = { t="CEM11",  f="FLOOR0_1" }, --Tan

  DRKCMT01  = { t="DRKCMT01",  f="RROCK03" }, --Dark version of CEMENT1,
  DRKCMT02  = { t="DRKCMT02",  f="RROCK03" }, --Dark version of CEMENT5,
  DRKCMT03  = { t="DRKCMT03",  f="RROCK03" }, --Dark version of CEMENT3,
  DRKCMT04  = { t="DRKCMT04",  f="RROCK03" }, --Dark version of CEMENT6,
  DRKCMT05  = { t="DRKCMT05",  f="RROCK03" }, --Dark version of CEMENT7,
  DRKCMT06  = { t="DRKCMT06",  f="RROCK03" }, --Dark version of CEMENT9,

  HELLCMT1  = { t="HELLCMT1",  f="RMARB3" }, --Red and white
  HELLCMT2  = { t="HELLCMT2",  f="RMARB3" }, --Red and white
  HELLCMT3  = { t="HELLCMT3",  f="RMARB3" }, --Red and white
  HELLCMT4  = { t="HELLCMT4",  f="RMARB3" }, --Red and white
  HELLCMT5  = { t="HELLCMT5",  f="RMARB3" }, --Red and white
  HELLCMT6  = { t="HELLCMT6",  f="RMARB3" }, --Red and white
  HELLCMT7  = { t="HELLCMT7",  f="FLOOR4_7" }, --Black and white
  HELLCMT8  = { t="HELLCMT8",  f="FLOOR4_7" }, --Black and white

  -- Bronze & Brown
  BRONZE5 =  { t="BRONZE5", f="MFLR8_2" },
  BRONZE6 =  { t="BRONZE6", f="MFLR8_2" },
  BRONZEG1 = { t="BRONZEG1", f="GMET07" },
  BRONZEG2 = { t="BRONZEG2", f="GMET07" },
  BRONZEG3 = { t="BRONZEG3", f="GMET07" },
  BROWN2   = { t="BROWN2",  f="FLAT5_4" },
  BROWN3   = { t="BROWN3",  f="FLAT5_4" },
  BROWNGR2 = { t="BROWNGR2", f="FLOOR7_1" },
  BROWNGR3 = { t="BROWNGR3", f="FLOOR7_1" },
  BROWNGR4 = { t="BROWNGR4", f="FLOOR7_1" },
  NUKESLAD = { t="NUKESLAD", f="FLOOR7_1" }, -- Hey, from Doom1!

  -- Computers / Tech
  CGCANI00 = { t="CGCANI00", f="CEIL5_1" }, --Animated
  CMPOHSO = { t="CMPOHSO", f="FLOOR7_1" }, --COMPOHSO
  CMPTILE = { t="CMPTILE", f="CEIL5_1" }, --COMPTILE
  COMPBLAK = { t="COMPBLAK", f="FLOOR1_6" }, --Black COMPBLUE
  COMPFUZ1 = { t="COMPFUZ1", f="CEIL5_1" }, --Animated
  COMPGREN = { t="COMPGREN", f="GRENFLOR" }, --Green COMPBLUE
  COMPRED = { t="COMPRED", f="FLOOR1_6" }, --Red COMPBLUE
  COMPSTA3 = { t="COMPSTA3", f="FLAT23" },
  COMPSTA4 = { t="COMPSTA4", f="FLAT23" },
  COMPSTA5 = { t="COMPSTA5", f="FLAT23" },
  COMPSTA6 = { t="COMPSTA6", f="FLAT23" },
  COMPSTA7 = { t="COMPSTA7", f="FLAT23" },
  COMPSTA8 = { t="COMPSTA8", f="FLAT23" },
  COMPSTA9 = { t="COMPSTA9", f="FLAT23" },
  COMPSTAA = { t="COMPSTAA", f="FLAT23" },
  COMPSTAB = { t="COMPSTAB", f="FLAT23" },
  COMPTIL2 = { t="COMPTIL2", f="FLOOR1_6" }, --Red COMPTILE
  COMPTIL3 = { t="COMPTIL3", f="CEIL5_1" }, --Black COMPTILE
  COMPTIL4 = { t="COMPTIL4", f="CEIL5_1" }, --Green COMPTILE
  COMPTIL5 = { t="COMPTIL5", f="CEIL5_1" }, --Yellow COMPTILE
  COMPTIL6 = { t="COMPTIL6", f="CEIL5_1" }, --Purple COMPTILE
  COMPSA1 = { t="COMPSA1", f="CEIL5_1" }, -- Animated broken screen
  COMPSC1 = { t="COMPSC1", f="CEIL5_1" }, -- Animated UAC screen
  COMPSD1 = { t="COMPSD1", f="CEIL5_1" }, -- Animated 4 green screens
  COMPU1 = { t="COMPU1", f="CEIL5_1" },
  COMPU2 = { t="COMPU2", f="CEIL5_1" },
  COMPU3 = { t="COMPU3", f="CEIL5_1" },
  COMPVENT = { t="COMPVENT", f="CEIL5_1" },
  COMPVEN2 = { t="COMPVEN2", f="CEIL5_1" },
  COMPY1 = { t="COMPY1", f="CEIL5_1" }, --Animated
  COMPCT01 = { t="COMPCT01", f="CEIL5_1" },
  COMPCT02 = { t="COMPCT02", f="CEIL5_1" },
  COMPCT03 = { t="COMPCT03", f="CEIL5_1" },
  COMPCT04 = { t="COMPCT04", f="CEIL5_1" },
  COMPCT05 = { t="COMPCT05", f="CEIL5_1" },
  COMPCT06 = { t="COMPCT06", f="CEIL5_1" },
  COMPCT07 = { t="COMPCT07", f="CEIL5_1" }, --256x128,
  CONSOLE1 = { t="CONSOLE1", f="CEIL5_1" }, --SPACEW3,
  CONSOLE2 = { t="CONSOLE2", f="FLAT23" }, --PLANET1,
  CONSOLE3 = { t="CONSOLE3", f="CEIL5_1" }, --COMP2,
  CONSOLE4 = { t="CONSOLE4", f="FLAT19" }, --COMPUTE1,
  CONSOLE5 = { t="CONSOLE5", f="CEIL5_1" }, --COMPUTE2,
  CONSOLE6 = { t="CONSOLE6", f="CEIL5_1" },
  CONSOLE7 = { t="CONSOLE7", f="CEIL5_1" },
  CONSOLE8 = { t="CONSOLE8", f="CEIL5_1" },
  CONSOLE9 = { t="CONSOLE9", f="CEIL5_1" },
  CONSOLEA = { t="CONSOLEA", f="FLAT23" },
  CONSOLEB = { t="CONSOLEB", f="FLAT23" },
  CONSOLEC = { t="CONSOLEC", f="FLAT23" },
  CONSOLED = { t="CONSOLED", f="FLAT23" },
  CONSOLEE = { t="CONSOLEE", f="FLAT23" },
  CONSOLEF = { t="CONSOLEF", f="FLAT23" },
  CONSOLEG = { t="CONSOLEG", f="FLAT23" },
  DECMP04A = { t="DECMP04A", f="CEIL5_1" }, --Animated
  GRAYBLU1 = { t="GRAYBLU1", f="FLAT14" },
  NMONIA1 = { t="NMONIA1", f="FLAT1" }, --Animated
  NOISE1 = { t="NOISE1", f="CEIL5_1" }, --Animated
  NOISE2A = { t="NOISE2A", f="CEIL5_1" }, --Animated
  NOISE3A = { t="NOISE3A", f="CEIL5_1" }, --Animated
  PLAN1 = { t="PLAN1", f="FLAT23" },
  PLAN2 = { t="PLAN2", f="FLAT23" },
  SPACEW5  = { t="SPACEW5",  f="SLIME14" },
  SPACEW6  = { t="SPACEW6",  f="SLIME15" },
  STARTAN1  = { t="STARTAN1",  f="FLOOR0_1" }, -- Plain STARTAN2. From Doom1,

  -- Glass
  GLASS1 = { t="GLASS1", f="CEIL5_1" }, --Red
  GLASS2 = { t="GLASS2", f="CEIL5_1" }, --Blue
  GLASS3 = { t="GLASS3", f="CEIL5_1" }, --Green
  GLASS4 = { t="GLASS4", f="CEIL5_1" }, --White
  GLASS5 = { t="GLASS5", f="CEIL5_1" }, --Black
  GLASS6 = { t="GLASS6", f="CEIL5_1" }, --Orange
  GLASS7 = { t="GLASS7", f="CEIL5_1" },
  GLASS8 = { t="GLASS8", f="CEIL5_1" }, --Multicolored

  -- These are 32x128 but tile to fit on pictures
  GLASS9 = { t="GLASS9", f="CEIL5_1" }, --Multicolored
  GLASS10 = { t="GLASS10", f="CEIL5_1" }, --Hexen
  GLASS11 = { t="GLASS11", f="CEIL5_1" }, --Yellow
  GLASS12 = { t="GLASS12", f="CEIL5_1" }, --Orange
  GLASS13 = { t="GLASS13", f="CEIL5_1" }, --Red
  GLASS14 = { t="GLASS14", f="CEIL5_1" }, --Blue
  WINGLAS1 = { t="WINGLAS1", f="CEIL5_1" }, -- Yellow dragon, 192px tall
  WINGLAS2 = { t="WINGLAS2", f="CEIL5_1" }, -- Red dragon in flame, 192px tall
  WINGLAS3 = { t="WINGLAS3", f="CEIL5_1" }, -- Red Dragon, 192px tall
  WINGLAS4 = { t="WINGLAS4", f="CEIL5_1" }, -- Blue Dragon, 192px tall

  -- Gothic
  BISHOP  = { t="BISHOP",  f="CEIL5_1" },
  GOTH01 = { t="GOTH01", f="FLOOR7_1" }, --Multicolor brown bricks
  GOTH02 = { t="GOTH02", f="GSTN03" }, --Brown metallic bricks
  GOTH03 = { t="GOTH03", f="GSTN05" }, --Brown metallic multicolored bricks
  GOTH04 = { t="GOTH04", f="GSTN05" }, --Same as GOTH03 but with red inverted cross design
  GOTH05 = { t="GOTH05", f="MFLR8_2" }, --Like GOTH02 but white cross design on it
  GOTH06 = { t="GOTH06", f="GSTN02" }, --Dark gray bricks
  GOTH07 = { t="GOTH07", f="GSTN01" }, --Gray bricks
  GOTH08 = { t="GOTH08", f="G13" }, --Bloody red bricks
  GOTH09 = { t="GOTH09", f="G11" }, --Dark gray stone
  GOTH10 = { t="GOTH10", f="G20" }, --Like GOTH09 but a green tinge
  GOTH11 = { t="GOTH11", f="FLOOR7_3" }, --Gray marble
  GOTH12 = { t="GOTH12", f="RROCK22" }, --Grayscale ZIMMER texture
  GOTH13 = { t="GOTH13", f="FLAT5_4" }, --Grayscale BRICK3,
  GOTH14 = { t="GOTH14", f="GWOD01" }, --Vertical wood
  GOTH15 = { t="GOTH15", f="GMET05" }, --Dark metallic wall
  GOTH16 = { t="GOTH16", f="G15" }, --Riveted metal wall
  GOTH17 = { t="GOTH17", f="G15" }, --Horizontal metal wall
  GOTH18 = { t="GOTH18", f="G15" }, --Block design version of GOTH16,
  GOTH19 = { t="GOTH19", f="G18" }, --Inverted cross version of GOTH18,
  GOTH20 = { t="GOTH20", f="G18" }, --Smaller cross version of GOTH19,
  GOTH21 = { t="GOTH21", f="G18" }, --Red line version of GOTH17,
  GOTH22 = { t="GOTH22", f="GMET05" }, --Horizontal dark metallic wall with rivets
  GOTH23 = { t="GOTH23", f="G06" }, --Black metallic wall
  GOTH24 = { t="GOTH24", f="G15" }, --Slightly different version of GOTH23,
  GOTH25 = { t="GOTH25", f="G07" }, --Very similar to GOTH22,
  GOTH26 = { t="GOTH26", f="G05" }, --Black wall
  GOTH27 = { t="GOTH27", f="G08" }, --Black wall with rivets
  GOTH28 = { t="GOTH28", f="G19" }, --Black wall with faces
  GOTH29 = { t="GOTH29", f="QFLAT02" }, --Quake style wall
  GOTH30 = { t="GOTH30", f="QFLAT03" }, --Quake style wall, cracked
  GOTH31 = { t="GOTH31", f="G06" }, --Black marble
  GOTH32 = { t="GOTH32", f="GMET04" }, --Rusty riveted metal support
  GOTH33 = { t="GOTH33", f="CEIL5_1" }, --Black wall with inverted red crosses
  GOTH34 = { t="GOTH34", f="G01" }, --Dark brown bricks
  GOTH35 = { t="GOTH35", f="FLOOR7_1" }, --Brown designed wall
  GOTH36 = { t="GOTH36", f="G09" }, --Darker version of GOTH18,
  GOTH37 = { t="GOTH37", f="G09" }, --Darker version of GOTH17,
  GOTH38 = { t="GOTH38", f="G09" }, --Lighter version of GOTH17,
  GOTH39 = { t="GOTH39", f="G09" }, --Like GOTH38, but more lines horizontally
  GOTH40 = { t="GOTH40", f="G09" }, --Vertical black metal supports
  GOTH41 = { t="GOTH41", f="G09" }, --Like GOTH40, but more rivets
  GOTH42 = { t="GOTH42", f="GSTN03" }, --BRONZE type wall
  GOTH43 = { t="GOTH43", f="SLIME15" }, --Wall version of SLIME15 flat
  GOTH44 = { t="GOTH44", f="G21" }, --Olive color marble tiles
  GOTH45 = { t="GOTH45", f="G21" }, --Olive colored bricks
  GOTH46 = { t="GOTH46", f="QFLAT05" },
  GOTH47 = { t="GOTH47", f="QFLAT06" },
  GOTH48 = { t="GOTH48", f="QFLAT06" },
  GOTH49 = { t="GOTH49", f="QFLAT05" },
  GOTH50 = { t="GOTH50", f="BLACK0" },
  GOTH51 = { t="GOTH51", f="BLACK0" },
  GUY1 = { t="GUY1", f="FLAT1" },

  -- Marble
  BLAKFACE = { t="BLAKFACE", f="BMARB3" }, -- Black MARBFACE
  BLAKFAC2 = { t="BLAKFAC2", f="BMARB3" }, -- Black MARBFAC2,
  BLAKFAC3 = { t="BLAKFAC3", f="BMARB3" }, -- Black MARBFAC3,
  BLAKMBGY = { t="BLAKMBGY", f="BMARB1" }, -- Black MARBGRAY
  BLAKMBG2 = { t="BLAKMBG2", f="BMARB1" }, -- Black MARBFAC4,
  GOATMARB = { t="GOATMARB", f="FLAT1" }, -- Goat/Baphomet relief thing
  GSTONE3 = { t="GSTONE3", f="FLOOR7_2" },
  ICONMRB1 = { t="ICONMRB1", f="FLOOR7_2" },
  KMARBLE1 = { t="KMARBLE1", f="BMARB2" }, -- Black MARBLE1,
  KMARBLE2 = { t="KMARBLE2", f="BMARB2" }, -- Black MARBLE2,
  KMARBLE3 = { t="KMARBLE3", f="BMARB2" }, -- Black MARBLE3,
  KSTONE1 = { t="KSTONE1", f="BMARB1" }, -- Black GSTONE
  KSTONE2 = { t="KSTONE2", f="BMARB3" }, -- Black GSTONE, red edging
  KSTONE3 = { t="KSTONE3", f="BMARB3" }, -- Black GSTONE, green edging
  KSTFONT1 = { t="KSTFONT1", f="BMARB3" }, -- Black GSTONE, red fountain
  KSTFNTG1 = { t="KSTFNTG1", f="BMARB3" }, -- Black GSTONE, green fountain
  KSTGARG = { t="KSTGARG", f="BMARB3" },
  KSTLION = { t="KSTLION", f="BMARB3" },
  KSTSATYR = { t="KSTSATYR", f="BMARB3" },
  LIONMRB1 = { t="LIONMRB1", f="TILES4" }, -- White marble lion
  LIONMRB2 = { t="LIONMRB2", f="FLAT1" }, -- White marble lion (grayer)
  LIONMRB3 = { t="LIONMRB3", f="TILES4" }, -- White marble lion
  MARB5BL = { t="MARB5BL", f="RMARB2" }, -- red-banded black marble
  -- green marble, thin tall
  MARBF01 = { t="MARBF01", f="FLOOR7_2" },
  MARBF02 = { t="MARBF02", f="FLOOR7_2" },
  MARBF03 = { t="MARBF03", f="FLOOR7_2" },
  -- dark, thin tall
  MARBFB1 = { t="MARBFB1", f="G11" },
  MARBFB2 = { t="MARBFB2", f="G11" },
  MARBFB3 = { t="MARBFB3", f="G11" },
  -- dark
  MARBFAB1 = { t="MARBFAB1", f="G11" },
  MARBFAB2 = { t="MARBFAB2", f="G11" },
  MARBFAB3 = { t="MARBFAB3", f="G11" },
  MARBFAB5 = { t="MARBFAB5", f="G11" },
  MARBFAB6 = { t="MARBFAB6", f="G11" },
  MARBFAB7 = { t="MARBFAB7", f="G11" },
  MARBFAB8 = { t="MARBFAB8", f="G11" },
  MARBFAB9 = { t="MARBFAB9", f="G11" },
  MARBFABA = { t="MARBFABA", f="G11" },
  MARBFABB = { t="MARBFABB", f="G11" },
  MARBFABC = { t="MARBFABC", f="G11" },
  MARBFABD = { t="MARBFABD", f="G11" },
  MARBFABF = { t="MARBFABF", f="G11" },
  MARBFABG = { t="MARBFABG", f="G11" },
  MARBFABH = { t="MARBFABH", f="G11" },
  MARBFABI = { t="MARBFABI", f="G11" },
  MARBFABJ = { t="MARBFABJ", f="G11" },

  -- green marble
  MARBFAC5 = { t="MARBFAC5", f="FLOOR7_2" }, --Plutonia 2,
  MARBFAC6 = { t="MARBFAC6", f="FLOOR7_2" },
  MARBFAC7 = { t="MARBFAC7", f="FLOOR7_2" },
  MARBFAC8 = { t="MARBFAC8", f="FLOOR7_2" }, -- Craneo's doing
  MARBFAC9 = { t="MARBFAC9", f="FLOOR7_2" }, -- Craneo's doing
  MARBFACA = { t="MARBFACA", f="FLOOR7_2" }, -- Craneo's doing
  MARBFACB = { t="MARBFACB", f="FLOOR7_2" }, -- Craneo's doing
  MARBFACC = { t="MARBFACC", f="FLOOR7_2" },
  MARBFACD = { t="MARBFACD", f="FLOOR7_2" },
  MARBFACF = { t="MARBFACF", f="FLOOR7_2" },
  MARBFACG = { t="MARBFACG", f="FLOOR7_2" },
  MARBFACH = { t="MARBFACH", f="FLOOR7_2" },
  MARBFACI = { t="MARBFACI", f="FLOOR7_2" },
  MARBFACJ = { t="MARBFACJ", f="FLOOR7_2" },

  MARBLE = { t="MARBLE", f="FLOOR7_2" },
  MARBLE4 = { t="MARBLE4", f="FLOOR7_2" },
  MARBLE5 = { t="MARBLE5", f="FLOOR7_2" },
  MARBLE6 = { t="MARBLE6", f="FLOOR7_2" },
  MARBLE7 = { t="MARBLE7", f="FLOOR7_2" },
  MARBLE8 = { t="MARBLE8", f="FLOOR7_2" },
  MARBLFAC = { t="MARBLFAC", f="TILES4" }, -- Greek inspired wall
  MBGRY = { t="MBGRY", f="FLOOR7_2" }, --MARBGRAY
  MBGRY2 = { t="MBGRY2", f="FLOOR7_2" }, --MARBFAC4,

  REDMARB1 = { t="REDMARB1", f="BMARB3" },
  REDMARB2 = { t="REDMARB2", f="RMARB1" },
  REDMARB3 = { t="REDMARB3", f="RMARB2" },

  -- Metal / Rust
  DARKMET1 = { t="DARKMET1", f="DARKM01" },
  EVILFACE = { t="EVILFACE", f="CEIL5_2" }, --From Plutonia 2,
  EVILFAC2 = { t="EVILFAC2", f="FLAT5_4" },
  EVILFAC3 = { t="EVILFAC3", f="FLAT5" },
  EVILFAC4 = { t="EVILFAC4", f="BLACK0" },
  EVILFAC5 = { t="EVILFAC5", f="BLACK0" },
  EVILFAC6 = { t="EVILFAC6", f="GRATE4" },
  EVILFAC7 = { t="EVILFAC7", f="GRATE4" },
  EVILFAC8 = { t="EVILFAC8", f="GRATE4" },
  EVILFAC9 = { t="EVILFAC9", f="GRATE4" },
  EVILFACA = { t="EVILFACA", f="GRATE4" },
  GRAYMET1 = { t="GRAYMET1", f="FLAT23" },
  GRAYMET2 = { t="GRAYMET2", f="SHINY04" },
  GRAYMET3 = { t="GRAYMET3", f="SHINY04" },
  GRAYMET4 = { t="GRAYMET4", f="SHINY04" },
  GRAYMET5 = { t="GRAYMET5", f="SHINY04" },
  GRAYMET6 = { t="GRAYMET6", f="SHINY04" }, -- Blue plating inside
  GRAYMET7 = { t="GRAYMET7", f="SHINY04" }, -- Purple
  GRAYMET8 = { t="GRAYMET8", f="SHINY04" }, -- Green
  GRAYMET9 = { t="GRAYMET9", f="SHINY04" }, -- Red
  GRAYMETA = { t="GRAYMETA", f="SHINY04" }, -- Cyan
  GRAYMETB = { t="GRAYMETB", f="SHINY04" }, -- Purple-ish
  GRAYMETC = { t="GRAYMETC", f="SHINY04" }, -- Orange
  MET2  = { t="MET2", f="CEIL5_2" }, -- METAL2,
  MET3  = { t="MET3", f="CEIL5_2" }, -- METAL3,
  MET4  = { t="MET4", f="CEIL5_2" }, -- METAL4,
  MET5  = { t="MET5", f="CEIL5_2" }, -- METAL5,
  MET6  = { t="MET6", f="CEIL5_2" }, -- METAL6,
  MET7  = { t="MET7", f="CEIL5_2" }, -- METAL7,
  METACOMP  = { t="METACOMP", f="CEIL5_2" },
  METAL8  = { t="METAL8", f="CEIL5_2" },
  METAL9  = { t="METAL9", f="CEIL5_2" },
  METAL10  = { t="METAL10", f="CEIL5_2" },
  METAL11  = { t="METAL11", f="FLOOR4_8" },

  METL01 = { t="METL01", f="CEIL5_2" }, --METAL2,
  METL02 = { t="METL02", f="GMET01" },
  METL03 = { t="METL03", f="GMET01" },
  METL04 = { t="METL04", f="SLIME16" }, --SPACEW4,

  RUSTWALL  = { t="RUSTWALL", f="GRATE8" },
  RUSTWAL2  = { t="RUSTWAL2", f="G08" },
  RUSTWAL3  = { t="RUSTWAL3", f="G08" },
  RUSTWAL4  = { t="RUSTWAL4", f="G08" },

  --Memento Mori 2 textures
  HELMET2 = { t="HELMET2", f="CEIL5_2" },
  MM205 = { t="MM205", f="MFLR8_4" }, --Rock with metal patterns
  MM206 = { t="MM206", f="G20" }, --Green rock
  MM207 = { t="MM207", f="G20" }, --Green brick

  -- the following textures are original composites and don't actually have anything to do with
  -- MM2 anymore
  MMT208 = { t="MMT208", f="QFLAT02" }, --Brown and black stripe wall
  MMT209 = { t="MMT209", f="QFLAT03" },
  MMT210 = { t="MMT210", f="QFLAT09" },

  -- Egypt
  EGYPT01   = { t="EGYPT01",   f="FLAT1_1" }, --64x64,
  EGYPT02   = { t="EGYPT02",   f="FLOOR7_1" }, --128x128,
  EGYPT03   = { t="EGYPT03",   f="FLOOR7_1" }, --64x128, doesn't tile horizontally that well
  EGYPT04   = { t="EGYPT04",   f="SAND2" }, --128x128,
  EGYPT05   = { t="EGYPT05",   f="RROCK09" }, --128x128,
  EGYPT06   = { t="EGYPT06",   f="RROCK09" }, --128x128,

  ESAND1   = { t="ESAND1",   f="SAND1" }, -- Sand dune texture
  ESAND2   = { t="ESAND2",   f="SAND2" }, -- Sand dune texture

  EGDOOR1  = { t="EGDOOR1",  f="FLOOR7_1" }, -- Door

  -- Egypt wall murals
  MURAL3   = { t="MURAL3",   f="FLAT1_1" }, --96x128,
  MURAL4   = { t="MURAL4",   f="FLAT1_1" }, --96x128,
  MURAL5   = { t="MURAL5",   f="FLAT1_1" },
  MURAL6   = { t="MURAL6",   f="FLAT1_1" },
  MURAL7   = { t="MURAL7",   f="RROCK09" }, --256x128,
  MURAL8   = { t="MURAL8",   f="RROCK03" }, --256x128,
  MURAL9   = { t="MURAL9",   f="RROCK09" },
  MURAL10  = { t="MURAL10",  f="RROCK09" },
  MURAL11  = { t="MURAL11",  f="RROCK09" },
  MURAL12  = { t="MURAL12",  f="RROCK09" },
  MURAL13  = { t="MURAL13",  f="RROCK09" },
  MURAL14  = { t="MURAL14",  f="RROCK09" },
  MURAL15  = { t="MURAL15",  f="RROCK09" },
  MURAL16  = { t="MURAL16",  f="RROCK09" },
  MURAL17  = { t="MURAL17",  f="RROCK09" },

  -- Rocks / Natural
  CATACMB1 = { t="CATACMB1", f="RROCK03" }, -- Dark gray rock, bones
  CATACMB2 = { t="CATACMB2", f="RROCK03" }, -- Dark gray rock, empty
  CATACMB3 = { t="CATACMB3", f="RROCK03" }, -- Dark gray rock
  CATACMB4 = { t="CATACMB4", f="FLOOR7_1" }, -- Dark brown rock, bones
  CATACMB5 = { t="CATACMB5", f="FLOOR7_1" }, -- Dark brown rock, empty
  CATACMB6 = { t="CATACMB6", f="FLOOR7_1" }, -- Dark brown rock
  RDROK1 = { t="RDROK1", f="RROCK01" },
  RDROK2 = { t="RDROK2", f="FLOOR6_1" },
  ROK01 = { t="ROK01", f="RROCK16" }, --ROCK4,
  ROK02 = { t="ROK02", f="RROCK09" }, --ROCK5,
  ROK03 = { t="ROK03", f="RROCK03" },
  ROK04 = { t="ROK04", f="RROCK03" },
  ROK05 = { t="ROK05", f="RROCK03" },
  ROK06 = { t="ROK06", f="RROCK18" },
  ROK07 = { t="ROK07", f="RROCK17" },
  ROK08 = { t="ROK08", f="GRNROCK" },
  ROK09 = { t="ROK09", f="GRNROCK" },
  ROK10 = { t="ROK10", f="RROCK13" },
  ROK11 = { t="ROK11", f="SLIME13" }, --BRICK10,
  ROK12 = { t="ROK12", f="FLAT10" },
  ROK13 = { t="ROK13", f="QFLAT07" },
  ROK14 = { t="ROK14", f="RROCK03" },
  ROK15 = { t="ROK15", f="RROCK03" },
  ROK16 = { t="ROK16", f="FLOOR7_1" }, --Brownish version of ROCK3,
  ROK17 = { t="ROK17", f="FLAT5_4" }, --Light gray bricks
  ROK18 = { t="ROK18", f="FLAT5_4" }, --Dark gray bricks (Flat needed)
  ROK19 = { t="ROK19", f="FLOOR7_1" }, --Brown/tan bricks (Flat needed)
  ROK20 = { t="ROK20", f="RROCK03" },
  ROK21 = { t="ROK21", f="FLAT10" },
  ROK22 = { t="ROK22", f="RROCK18" },
  ROK23 = { t="ROK23", f="RROCK03" },
  ROK24 = { t="ROK24", f="RROCK03" },
  ROK25 = { t="ROK25", f="RROCK17" },
  ROK26 = { t="ROK26", f="RROCK16" },
  ROKGRN = { t="ROKGRN", f="GRENFLOR" }, -- composite of various green cliff textures
  TNROK1 = { t="TNROK1", f="RROCK09" }, --TANROCK4,
  TNROK2 = { t="TNROK2", f="RROCK03" }, --TANROCK5,

  -- Pipes
  PIPESV1 = { t="PIPESV1", f="FLAT1" },
  PIPESV2 = { t="PIPESV2", f="FLAT5_5" },
  PIPESV3 = { t="PIPESV3", f="RROCK20" },
  PIPEDRK1 = { t="PIPEDRK1", f="RROCK03" },
  PIPEWAL5 = { t="PIPEWAL5", f="RROCK03" },

  -- Silver / Shiny
  HEX01 = { t="HEX01", f="SHINY03" },
  SHAWN4 = { t="SHAWN4", f="FLAT23" },
  SHAWN5 = { t="SHAWN5", f="FLAT23" },
  SHAWN01C = { t="SHAWN01C", f="FLAT23" },
  SHAWN01D = { t="SHAWN01D", f="FLAT23" },
  SHAWN01E = { t="SHAWN01E", f="FLAT23" },
  SHAWN01F = { t="SHAWN01F", f="FLAT23" },
  SHAWN01G = { t="SHAWN01G", f="FLAT23" },
  SHAWN01H = { t="SHAWN01H", f="FLAT23" },
  SHAWCOMP = { t="SHAWCOMP", f="FLAT23" },
  SHAWGRY4 = { t="SHAWGRY4", f="FLAT23" },
  SHAWHOSO = { t="SHAWHOSO", f="FLAT23" },
  SHAWNDR = { t="SHAWNDR", f="FLAT20" },
  SHAWVENT = { t="SHAWVENT", f="FLAT23" },
  SHAWVEN2 = { t="SHAWVEN2", f="FLAT23" },
  SILVBLU1 = { t="SILVBLU1", f="FLAT23" },
  SILVCOMP = { t="SILVCOMP", f="FLAT23" },
  SHAWSH04 = { t="SHAWSH04", f="SHINY04"},

  SILVER2G = { t="SILVER2G", f="FLAT23" },
  SILVER2R = { t="SILVER2R", f="FLAT23" },
  SILVER2O = { t="SILVER2O", f="FLAT23" },
  SILVER2Y = { t="SILVER2Y", f="FLAT23" },
  SILVER2W = { t="SILVER2W", f="FLAT23" },

  UACCRT1 = { t="UACCRT1", f="FLAT23" },

  -- Skin and Hell
  BODIES1 = { t="BODIES1", f="BODIESFL" }, -- Copy of AASHITTY
  BODIESB = { t="BODIESB", f="BODIESFL" }, --Dark red AASHITTY/SP_FACE2,
  BODIESC = { t="BODIESC", f="BODIESF2" }, --Dark brown AASHITTY/SP_FACE2,
  BONES1 = { t="BONES1", f="FLAT5_6" }, -- Brown bones
  BONES2 = { t="BONES2", f="FLAT5_6" }, -- Gray bones
  BONES3 = { t="BONES3", f="FLAT5_6" }, -- Bloody bones
  CORPSES = { t="CORPSES", f="FLAT5_6" }, --SLOPPY1,
  CRACKRED = { t="CRACKRED", f="RROCK01" },
  CRACKRD2 = { t="CRACKRD2", f="RROCK01" },
  CRAK01 = { t="CRAK01", f="RROCK01" }, --CRACKLE2,
  CRAK02 = { t="CRAK02", f="RROCK02" }, --CRACKLE4,
  DEATH1 = { t="DEATH1", f="FLAT5_4" },
  DEATH2 = { t="DEATH2", f="FLAT5_4" },
  DEATH3 = { t="DEATH3", f="FLAT5_4" },
  DEMSTAT = { t="DEMSTAT", f="GMET07" }, -- Demon statue, Craneo's stuff
  HELMET1 = { t="HELMET1", f="CEIL5_1" },
  HELWAL1 = { t="HELWAL1", f="RROCK03" }, --Memento Mori 2,
  HELLROK1 = { t="HELLROK1", f="FLOOR6_1" },
  HELWAL2 = { t="HELWAL2", f="FLOOR6_1" }, --Plutonia 2,
  PENTA1 = { t="PENTA1", f="RROCK03" },
  SKIN3 = { t="SKIN3", f="SFLR6_4" },
  SKIN4 = { t="SKIN4", f="SKINFLT1" },
  SKINHEAD = { t="SKINHEAD", f="SFLR6_4" },
  SKINLOW1  = { t="SKINLOW1",  f="FLAT5_2" }, --128x128 version of SKINLOW
  SKINMET3 = { t="SKINMET3", f="CEIL5_2" },
  SKINMET4 = { t="SKINMET4", f="CEIL5_2" },
  SKINMET5 = { t="SKINMET5", f="CEIL5_2" },
  SKINMET6 = { t="SKINMET6", f="CEIL5_2" },
  SKINMET7 = { t="SKINMET7", f="CEIL5_2" },
  SKTEK01 = { t="SKTEK01", f="FLAT5_5" }, --SKINTEK1,
  SKTEK02 = { t="SKTEK02", f="FLAT5_5" }, --SKINTEK2,
  SKULLS = { t="SKULLS", f="FLOOR6_1" }, --SP_FACE2,
  SKULLS2 = { t="SKULLS2", f="FLAT5_6" },
  SKULLS3 = { t="SKULLS3", f="FLAT5_6" }, --SKULWAL3,
  SKULLS4 = { t="SKULLS4", f="FLAT5_6" }, --SKULWALL
  SPDUDE3 = { t="SPDUDE3", f="FLOOR7_2" }, --SP_DUDE3,
  SPDUDE6 = { t="SPDUDE6", f="FLOOR7_2" }, --SP_DUDE6,
  SPDUDE7 = { t="SPDUDE7", f="FLOOR5_4" }, --SP_DUDE7,
  SPDUDE8 = { t="SPDUDE8", f="FLOOR5_4" }, --SP_DUDE8,
  SP_HOT2 = { t="SP_HOT2", f="RMARB3" },
  SP_HOT3 = { t="SP_HOT3", f="RMARB3" },
  SPINE01 = { t="SPINE01", f="SFLR6_4" },

  --Snow and Ice
  SNOW01 = { t="SNOW01", f="SNOW1" },
  SNOW02 = { t="SNOW02", f="SNOW1" },
  SNOW03 = { t="SNOW03", f="SNOW5" },
  SNOW04 = { t="SNOW04", f="SNOW8" },
  SNOW05 = { t="SNOW05", f="SNOW6" },
  SNOW06 = { t="SNOW06", f="SNOW8" },
  SNOW07 = { t="SNOW07", f="SNOW6" },
  SNOW08 = { t="SNOW08", f="SNOW1" },
  SNOW09 = { t="SNOW09", f="SNOW5" },
  SNOW10 = { t="SNOW10", f="SNOW1" },
  SNOW11 = { t="SNOW11", f="SNOW6" },
  SNOW12 = { t="SNOW12", f="SNOW6" },
  SNOW13 = { t="SNOW13", f="SNOW13F" }, -- 256x256, beautiful ice
  SNOW14 = { t="SNOW14", f="SNOW6" }, -- 256x256,
  SNOW15 = { t="SNOW15", f="SNOW1" },

  SNOWBOX1 = { t="SNOWBOX1", f="SNOW6" },
  SNOWBOX2 = { t="SNOWBOX2", f="SNOW1" },

  SNOWWAL1 = { t="SNOWWAL1", f="SHINY01" },
  SNOWWAL2 = { t="SNOWWAL2", f="SHINY02" },
  SNOWWAL3 = { t="SNOWWAL3", f="SHINY02" },
  SNOWWAL4 = { t="SNOWWAL4", f="SHINY01" },

  -- Snow + Tech
  SNWTF1 =  { t="SNOWWAL4", f="SNWTF1" },
  SNWTF2 =  { t="STONE10", f="SNWTF2" },
  SNWTF3 =  { t="STARGRY1", f="SNWTF3" },
  SNWTF4 =  { t="SNOWWAL2", f="SNWTF4" },
  SNWTF5 =  { t="SNOWWAL3", f="SNWTF5" },
  SNWTF6 =  { t="SNOWWAL2", f="SNWTF6" },
  SNWTF7 =  { t="SNOWWAL1", f="SNWTF7" },
  SNWTF8 =  { t="TEKSHAW", f="SNWTF8" },

  -- Desert textures
  DESBRIK1 = { t="DESBRIK1", f="RROCK09" }, -- Tan brick facade
  DESBRIK2 = { t="DESBRIK2", f="RROCK09" }, -- Tan brick facade
  DESBRIK3 = { t="DESBRIK3", f="FLOOR7_1" }, -- Brown brick facade w/ trim
  DESBRIK4 = { t="DESBRIK4", f="RROCK09" }, -- Tan brick facade
  DESBRIK5 = { t="DESBRIK5", f="RROCK09" }, -- Tan brick facade
  DESBRIK6 = { t="DESBRIK6", f="RROCK09" }, -- Tan brick facade w/ trim
  DESBRIK7 = { t="DESBRIK7", f="FLOOR7_1" }, -- Tan brick facade
  DESMARB1 = { t="DESMARB1", f="RROCK09" }, -- Elegant tan marble
  DESMARB2 = { t="DESMARB2", f="RROCK09" }, -- Elegant tan marble
  DESROCK1 = { t="DESROCK1", f="RROCK03" }, -- Brown rock
  DESROCK2 = { t="DESROCK2", f="QFLAT07" }, -- Brown rock
  DESROCK3 = { t="DESROCK3", f="FLOOR7_1" }, -- Brown rock
  DESROCK4 = { t="DESROCK4", f="RROCK09" }, -- Tan rock
  DESROCK5 = { t="DESROCK5", f="RROCK17" }, -- Brown rock

  -- Tekwall / Startan-types
  STARBR1 = { t="STARBR1", f="FLOOR0_2" },
  STARGRY1 = { t="STARGRY1", f="SHINY01" },
  TEKGRBLU = { t="TEKGRBLU", f="RROCK20" },
  TEKGRDR = { t="TEKGRDR", f="CEIL5_2" }, -- Usable as a door
  TEKGRN01 = { t="TEKGRN01", f="RROCK20" }, --RROCK20,
  TEKGRY01 = { t="TEKGRY01", f="RROCK21" },
  TEKGRY02 = { t="TEKGRY02", f="RROCK21" },
  TEKSHAW = { t="TEKSHAW", f="SHINY02" },
  TEKWALL2 = { t="TEKWALL2", f="CEIL5_1" },
  TEKWALL2 = { t="TEKWALL2", f="CEIL5_1" },
  TEKWALL7 = { t="TEKWALL7", f="FLOOR7_1" },
  TEKWALL8 = { t="TEKWALL8", f="TEK1" }, -- Red
  TEKWALL9 = { t="TEKWALL9", f="TEK2" }, -- Green
  TEKWALLA = { t="TEKWALLA", f="TEK3" }, -- Purple
  TEKWALLB = { t="TEKWALLB", f="TEK4" }, -- Blue
  TEKWALLC = { t="TEKWALLC", f="TEK5" }, -- Magenta
  TEKWALLD = { t="TEKWALLD", f="TEK6" }, -- Cyan/Aqua
  TEKWALLE = { t="TEKWALLE", f="TEK7" }, -- Orange
  TVSNOW01 = { t="TVSNOW01", f="CEIL5_1" }, --Animated

  -- Auxiliary
  COLLITE1 = { t="COLLITE1", f="RROCK20" }, --Green version of REDWALL1,
  COLLITE2 = { t="COLLITE2", f="ORANFLOR" }, --Orange version of REDWALL1,
  COLLITE3 = { t="COLLITE3", f="CEIL4_2" }, --Blue version of REDWALL1,
  DFAN1 = { t="DFAN1", f="METAL" }, -- Essentially a wall version of FAN1,
  LITE2 = { t="LITE2", f="FLOOR0_1" }, -- BROWN1 variant w/ lights. From Doom1,
  LITE4 = { t="LITE4", f="FLAT19" }, -- LITE5 and bigger light on bottom. From Doom1,
  LITE96 = { t="LITE96", f="FLOOR7_1" }, -- BROWN96 variant w/ lights. From Doom1,
  LITEBLU3 = { t="LITEBLU3", f="CEIL5_1" }, -- Large blue lights. From Doom1,
  LITESTON = { t="LITESTON", f="MFLR8_1" }, -- STONE2 variant w/ lights. From Doom1,
  RDLITE01 = { t="RDLITE01", f="FLOOR1_6" }, --REDLITE
  RDWAL01 = { t="RDWAL01", f="FLOOR1_6" }, --REDWALL1,
  SANDBAGS = { t="SANDBAGS", f="RROCK09" },
  SUPPORT4 = { t="SUPPORT4", f="FLAT23" },
  WHEEL1 = { t="WHEEL1", f="CEIL5_1" }, -- Truck wheel
  WHEEL2 = { t="WHEEL2", f="CEIL5_1" }, -- Car wheel
  WHEEL3 = { t="WHEEL3", f="CEIL5_1" }, -- Compact car wheel

  -- Steps
  WARNSTEP = { t="WARNSTEP", f="WARN1", sane=1 },

  -- Wood / Panel / Urban
  GUNRACK = { t="GUNRACK", f="RROCK09" }, -- Weapons rack by OSJ Clatchford, ZDoom custom texture thread, page 80,
  PANBOOK2 = { t="PANBOOK2", f="RROCK09" }, -- 128x128,
  PANBOOK3 = { t="PANBOOK3", f="RROCK09" }, -- 128x128,
  PANBOOK4 = { t="PANBOOK4", f="RROCK09" }, -- 64x128,
  PANBOOK5 = { t="PANBOOK5", f="RROCK09" }, -- 64x96,
  STUC01 = { t="STUC01", f="RROCK09" }, --STUCCO
  THATCH1 = { t="THATCH1", f="G03" },
  THATCH2 = { t="THATCH2", f="G02" },
  WD01 = { t="WD01", f="FLAT5_2" }, --WOOD8,
  WD02 = { t="WD02", f="FLAT5_2" }, --WOOD9,
  WD03 = { t="WD03", f="FLAT5_2" },
  WD04 = { t="WD04", f="FLAT5_1" },
  WODCRAT1 = { t="WODCRAT1", f="FLAT5_2" }, -- Wooden TNT UAC crate, 64x128,
  WODCRAT2 = { t="WODCRAT2", f="FLAT5_2" }, -- Wooden TNT UAC crate, 64x64,
  WODCRAT3 = { t="WODCRAT3", f="FLAT5_2" }, -- Wooden TNT UAC crate, 128x64,
  WODCRAT4 = { t="WODCRAT4", f="FLAT5_2" }, -- Wooden UAC crate, 64x64,
  WODCRAT5 = { t="WODCRAT5", f="FLAT5_2" }, -- Wooden UAC crate, 64x128,
  WOODDEM1 = { t="WOODDEM1", f="FLAT5_1" }, -- Ugly wooden demon relief
  WOODFACE = { t="WOODFACE", f="FLAT5_2" },
  WOODSKUL = { t="WOODSKUL", f="FLAT5_2" }, -- Wood with skull on it. From Doom1,
  WOOD13 = { t="WOOD13", f="FLAT5_2" },
  WOOD14 = { t="WOOD14", f="FLAT5_2" },
  WOOD15 = { t="WOOD15", f="FLAT5_2" },
  WOOD16 = { t="WOOD16", f="FLAT5_2" },
  WOOD17 = { t="WOOD17", f="FLAT5_2" },
  WOOD18 = { t="WOOD18", f="FLAT5_2" },
  WDMET01 = { t="WDMET01", f="CEIL5_2" }, --WOODMET1,
  WDMET02 = { t="WDMET02", f="CEIL5_2" }, --WOODMET2,
  WDMET03 = { t="WDMET03", f="CEIL5_2" },

  -- Jimmy's custom textures from Jimmytex
  MOSROK3   = { t="MOSROK3", f="RROCK09" }, -- Plutonia MOSROK, but brown

  -- Doom 2 Panels
  PANNY01   = { t="PANNY01", f="RROCK09" }, --PANEL1,
  PANNY02   = { t="PANNY02",   f="RROCK09" }, --PANEL2,
  PANNY03   = { t="PANNY03",   f="RROCK09" }, --PANEL3,
  PANNY04   = { t="PANNY04",   f="RROCK09" }, --PANEL4,
  PANNY05   = { t="PANNY05",   f="RROCK09" }, --PANEL6,
  PANNY06   = { t="PANNY06",   f="RROCK09" }, --PANEL7,
  PANNY07   = { t="PANNY07",   f="RROCK09" }, --PANEL8,
  PANNY08   = { t="PANNY08",   f="RROCK09" }, --PANEL9,
  PANNY09 = { t="PANNY09", f="RROCK09" }, --PANCASE2,
  PANNYA = { t="PANNYA", f="RROCK09" }, --TANROCK3,

  -- Animated liquid walls
  GRYFALL1   = { t="GRYFALL1", f="SLUDGE01", sane=1 },
  MFALL1     = { t="MFALL1", f="MAGMA1", sane=1 },
  PURFAL1     = { t="PURFAL1", f="PURW1", sane=1 },
  SLMFALL1   = { t="SLMFALL1", f="SLIME01", sane=1 },
  OFALL1     = { t="OFALL1", f="OSLIME01", sane=1 },
  LFAL21     = { t="LFAL21", f="QLAVA1", sane=1 },
  LFALL1     = { t="LFALL1", f="XLAV1", sane=1 },
  ICEFALL    = { t="ICEFALL", f="SNOW9", sane=1 }, --Not animated

  -- Animated but not fully liquid walls
   SLADRIP1 = { t="SLADRIP1", f="FLOOR7_1" },

  -- Candles / Misc Animated
  CANDLE1  = { t="CANDLE1", f="MAGMA1", sane=1 }, -- Burning candles, for decor, not walls
  FIREBLK1 = { t="FIREBLK1", f="FLOOR6_2", sane=1 }, -- Black FIREBLU1,
  LAVBLAK1 = { t="LAVBLAK1", f="RROCK03", sane=1 }, -- Black FIRELAVA
  LAVBLUE1 = { t="LAVBLUE1", f="FASHBLU", sane=1 }, -- Blue FIRELAVA
  LAVGREN1 = { t="LAVGREN1", f="FASHGREN", sane=1 }, -- Green FIRELAVA
  LAVWHIT1 = { t="LAVWHIT1", f="FASHWITE", sane=1 }, -- White FIRELAVA

  -- Switches
  SW1CHN = { t="SW1CHN", f="FLAT5_2" },
  SW2CHN = { t="SW2CHN", f="FLAT5_2" },
  SW1GOTH = { t="SW1GOTH", f="CEIL5_2" },
  SW2GOTH = { t="SW2GOTH", f="CEIL5_2" },
  SW1PENT = { t="SW1PENT", f="CEIL5_2" },
  SW2PENT = { t="SW2PENT", f="CEIL5_2" },
  SW1QUAK = { t="SW1QUAK", f="CEIL5_2" },
  SW2QUAK = { t="SW2QUAK", f="CEIL5_2" },
  SW1SKUL1 = { t="SW1SKUL1", f="CEIL5_2" },
  SW2SKUL1 = { t="SW2SKUL1", f="CEIL5_2" },

  -- Fencing & spacings
  BARBWIRE = { t="BARBWIRE", rail_h=32 }, -- Razor barbwire
  FENCE1 = { t="FENCE1", rail_h=128 },
  FENCE2 = { t="FENCE2", rail_h=128 },
  FENCE3 = { t="FENCE3", rail_h=64 },
  FENCE4 = { t="FENCE4", rail_h=128 },
  FENCE5 = { t="FENCE5", rail_h=72 },
  FENCE6 = { t="FENCE6", rail_h=72 },
  FENCE7 = { t="FENCE7", rail_h=128 },
  FENCE8 = { t="FENCE8", rail_h=96 }, -- Shiny
  FENCE9 = { t="FENCE9", rail_h=96 }, -- Rusty
  FENCEA = { t="FENCEA", rail_h=128 }, -- Shiny
  FENCEB = { t="FENCEB", rail_h=128 }, -- Rusty
  FENCEC = { t="FENCEC", rail_h=128 }, -- Fencing with vegetation(?) on it, from Evilution
  MIDSPAC2 = { t="MIDSPAC2", f="CEIL5_1", rail_h = 128 }, -- Darker
  MIDSPAC3 = { t="MIDSPAC3", f="CEIL5_1", rail_h = 128 }, -- A thicker, metallic look
  MIDSPAC4 = { t="MIDSPAC4", f="WARN1", rail_h = 128 }, -- Warning stripes
  MIDSPAC5 = { t="MIDSPAC5", f="WARN1", rail_h = 128 }, -- Warning stripes
  MIDSPAC6 = { t="MIDSPAC6", f="CEIL5_2", rail_h = 128 }, -- Diamond holes
  MIDSPAC7 = { t="MIDSPAC7", f="CEIL5_2", rail_h = 128 }, -- Rectangular holes
  MIDSPAC8 = { t="MIDSPAC8", f="CEIL5_2", rail_h = 128 }, --  Diagonal holes
  MIDVINE1 = { t="MIDVINE1", f="CEIL5_1", rail_h = 128 }, -- 256x128, brown vines
  MIDVINE2 = { t="MIDVINE2", f="CEIL5_1", rail_h = 128 }, -- 256x128, brown & green vines
  RAIL1 = { t="RAIL1", rail_h=32 },

  -- Transparent windows
  MIDWIND1 = { t="MIDWIND1", f="CEIL5_1", rail_h = 128 }, -- 32x128,
  MIDWIND2 = { t="MIDWIND2", f="CEIL5_1", rail_h = 128 }, -- 32x128,
  MIDWIND3 = { t="MIDWIND3", f="CEIL5_1", rail_h = 128 }, -- 64x128,
  MIDWIND4 = { t="MIDWIND4", f="CEIL5_1", rail_h = 96 }, -- 32x96,
  MIDWIND5 = { t="MIDWIND5", f="CEIL5_1", rail_h = 128 }, -- 64x128,
  MIDWIND6 = { t="MIDWIND6", f="CEIL5_1", rail_h = 96}, -- 32x96,
  MIDWIND7 = { t="MIDWIND7", f="CEIL5_1", rail_h = 128 }, -- 32x128,
  MIDWIND8 = { t="MIDWIND8", f="CEIL5_1", rail_h = 128 }, -- 128x128,

  -- Obsidian flags
  -- Note: Due to being over 128 height, we may need to use HI_START/HI_END lumps if
  -- we have problems with the textures being cut off in-game.
  OBDNBNR1 = { t="OBDNBNR1", f="CRATOP2" }, -- Obsidian flag, yellow
  OBDNBNR2 = { t="OBDNBNR2", f="SFLR6_4" }, -- Obsidian flag, hellish

  -- Vending machine textures (from vending_machine_textures.wad) --
  OBVNMCH1 = { t="OBVNMCH1", f="CEIL5_1" },
  OBVNMCH2 = { t="OBVNMCH2", f="CEIL5_1" },
  OBVNMCH3 = { t="OBVNMCH3", f="CEIL5_1" },
  OBVNMCH4 = { t="OBVNMCH4", f="CEIL5_1" },
  OBVNMCH5 = { t="OBVNMCH5", f="CEIL5_1" },

  CRATJOKE = { t="CRATJOKE", f="CRATOP2"},

 -- Exiting textures with new definitions
  FIREBLU1 = { t="FIREBLU1", f="FIRELAF1" },
  FIREBLU2 = { t="FIREBLU2", f="FIRELAF2" },
  FIREWALA = { t="FIREWALA", f="FLOOR6_1" },
  FIRELAV2 = { t="FIRELAV2", f="FLOOR6_1" },
  TEKWALL4 = { t="TEKWALL4", f="TEKFLR4" },

  ---------------------------
  -- StalungCraft textures --
  ---------------------------

  -- TODO: Use better flats used here if possible!

  -- Wood & bookcases
  BKCASE1A = { t="BKCASE1A", f="RROCK20" }, -- Tan bookshelf, filled with books, 64x128
  BKCASE2A = { t="BKCASE2A", f="RROCK20" }, -- Tam bookshelf, filled with books, 96x128
  BKCASE3A = { t="BKCASE3A", f="RROCK20" }, -- Tan bookshelf, filled with books, 128x128
  BKSIDE1A = { t="BKSIDE1A", f="RROCK20" }, -- Bookshelf side texture, 64x128

  -- Brick walls
  BRIC9GRN = { t="BRIC9GRN", f="FLOOR7_2" }, -- Light green bricks with ledge, 128x128
  BRIC9GRY = { t="BRIC9GRY", f="FLAT5_4" }, -- Gray bricks with ledge, 128x128
  BRIC9TAN = { t="BRIC9TAN", f="FLOOR7_1" }, -- Tan bricks with ledge, 128x128
  BRICEGRN = { t="BRICEGRN", f="FLOOR7_2" }, -- Big green bricks, 128x128
  BRICEGRY = { t="BRICEGRY", f="FLOOR7_1" }, -- Big gray bricks, 128x128
  BRICETAN = { t="BRICETAN", f="RROCK20" }, -- Big tan bricks, 128x128

  DECO1BLK = { t="DECO1BLK", f="BLACK0" }, -- Decorative black wall bits, 64x128
  DECO1BRN = { t="DECO1BRN", f="FLOOR7_1" }, -- Decorative brown wall bits, 64x128
  DECO1GRN = { t="DECO1GRN", f="FLOOR7_2" }, -- Decorative green wall bits, 64x128
  DECO1GRY = { t="DECO1GRY", f="FLAT1" }, -- Decorative gray wall bits, 64x128
  DECO1RED = { t="DECO1RED", f="FLOOR1_6" }, -- Decorative red wall bits, 64x128
  DECO1TAN = { t="DECO1TAN", f="RROCK20" }, -- Decorative tan wall bits, 64x128

  -- Decorative brick
  ENGRAV1 = { t="ENGRAV1", f="FLAT5_4" }, -- Medieval style brick/stone decor, 64x128 (Knight)
  ENGRAV2 = { t="ENGRAV2", f="FLAT5_4" }, -- Medieval style brick/stone decor, 64x128 (Cross?)
  ENGRAV3 = { t="ENGRAV3", f="FLAT5_4" }, -- Medieval style brick/stone decor, 64x128 (Cross!)
  ENGRAV4 = { t="ENGRAV4", f="FLAT5_4" }, -- Medieval style brick/stone decor, 64x128 (Skull)
  ENGRAV5 = { t="ENGRAV5", f="FLAT5_4" }, -- Medieval style brick/stone decor, 256x128 (Battle)
  ENGRAV6 = { t="ENGRAV6", f="FLAT5_4" }, -- Medieval style brick/stone decor, 256x96 (Gathering?)
  ENGRAV7 = { t="ENGRAV7", f="FLAT5_4" }, -- Medieval style brick/stone decor, 256x96 (Figures)
  ENGRAV8 = { t="ENGRAV8", f="FLAT5_4" }, -- Medieval style brick/stone decor, 256x96 (Figures)

  -- NOTE: FLATS USED IN DOOM 64 TEXTURES AT THE MOMENT ARE PLACEHOLDERS!! -A, Nov 12th, 2021
  -------------
  -- DOOM 64 --
  -------------

  -- Gore, anything bloody
  D64BOD01 = { t="D64BOD01", f="CEIL5_1" }, -- Body packed into wall, skeletonized, 32x128

  -- Reliefs, misc. details
  D64REL01 = { t="D64REL01", f="CEIL5_1" }, -- Lioney relief, 64x64
  D64REL02 = { t="D64REL02", f="CEIL5_1" }, -- Evil looking face, 64x64
  D64REL03 = { t="D64REL03", f="CEIL5_1" },
  D64REL04 = { t="D64REL04", f="CEIL5_1" }, -- Evil looking face, 64x64
  D64REL05 = { t="D64REL05", f="CEIL5_1" }, -- Evil looking face, 64x64 (similar to 04)
  D64REL06 = { t="D64REL06", f="CEIL5_1" }, -- Evil looking face, 64x64
  D64REL07 = { t="D64REL07", f="CEIL5_1" }, -- Evil looking face, 64x64
  D64REL08 = { t="D64REL08", f="CEIL5_1" }, -- Pentagram on dark stone, 64x64
  D64REL09 = { t="D64REL09", f="FLAT5_5" }, -- "Arrow" fleshy thing pointing right, 128x32 (for scrollers)
  D64REL10 = { t="D64REL10", f="FLAT5_5" }, -- "Arrow" fleshy thing pointing left, 128x32 (for scrollers)

  -- Support beams and such
  D64SUP01 = { t="D64SUP01", f="CEIL5_1" }, -- Evil looking support beam, similar look to D64REL02, 32x128
  D64SUP02 = { t="D64SUP02", f="CEIL5_1" }, -- Stone support with curvy relief, 32x128
  D64SUP03 = { t="D64SUP03", f="CEIL5_1" }, -- Skeletony face-like support beam, 32x128
  D64SUP04 = { t="D64SUP04", f="CEIL5_2" }, -- Riveted metal support beam, 16x128
  D64SUP05 = { t="D64SUP05", f="CEIL5_2" }, -- Riveted metal support beam with relief indentations, 16x128
  D64SUP06 = { t="D64SUP06", f="CEIL5_2" }, -- Dark riveted metal support beam, 16x128
  D64SUP07 = { t="D64SUP07", f="CEIL5_1" }, -- Stone engraved pillar, 32x128
  D64SUP08 = { t="D64SUP08", f="CEIL5_1" }, -- Draconic looking pillar, 32x128

  -- Animated walls
  D64ANM1A = { t="D64ANM1A", f="FLOOR7_2" }, -- Evil face anim 1 of 3, 64x64. This one needs similar timing like in Doom 64!
  D64ANM1B = { t="D64ANM1B", f="FLOOR7_2" }, -- Evil face anim 2 of 3, 64x64
  D64ANM1C = { t="D64ANM1C", f="FLOOR7_2" }, -- Evil face anim 3 of 3, 64x64

  -- Animated floors
  D64TEL01 = { t="BROWNHUG",  f="D64TEL01" }, -- Hellish teleporter
  D64TEL02 = { t="BROWNHUG",  f="D64TEL02" }, -- Hellish teleporter
  D64TEL03 = { t="BROWNHUG",  f="D64TEL03" }, -- Hellish teleporter
  D64TEL04 = { t="BROWNHUG",  f="D64TEL04" }, -- Hellish teleporter


  
 -- ------------------ --
 --  END DOOM 64 STUFF --
 -- ------------------ --

  --------------------
  --------------------
  --- Extra floors ---
  --------------------
  --------------------

  -- Organic
  BODIESFL = { f="BODIESFL", t="BODIESB" },
  BODIESF2 = { f="BODIESF2", t="BODIESC" },
  FASHBLU = { f="FASHBLU", t="LAVBLUE1" }, -- These four are to accompany the colored FIRELAVAs..
  FASHGREN = { f="FASHGREN", t="LAVGREN1" },
  FASHWITE = { f="FASHWITE", t="LAVWHIT1" },
  FASHBLAK = { f="FASHBLAK", t="LAVBLAK1" },

  -- Carpet
  CARPET1 = { t="PANNYA",  f="CARPET1" },
  CARPET2 = { t="WOOD1",  f="CARPET2" },
  CARPET3 = { t="PANNYA",  f="CARPET3" },
  CARPET4 = { t="WOOD3",  f="CARPET4" },
  CARPET5 = { t="WOOD1",  f="CARPET5" },
  CARPET6 = { t="WOOD1",  f="CARPET6" },
  CARPET7 = { t="WOODVERT",  f="CARPET7" },
  CARPET8 = { t="WOODVERT",  f="CARPET8" },

  -- Various Decayed Tech Flooring / etc
  DARKF01 = { t="BROWNGRN",  f="DARKF01" },
  DARKF02 = { t="BROWNGRN",  f="DARKF02" },
  DARKF03 = { t="METL01",  f="DARKF03" },
  FLOOR46D = { t="PIPEDRK1",  f="FLOOR46D" },
  FLOOR46E = { t="PIPEDRK1",  f="FLOOR46E" },
  FLAT15 = { t="COMPRED",  f="FLAT15" },
  FLOOR1_2 = { f="FLOOR1_2",  t="COMPRED" },
  FLOOR4_7 = { f="FLOOR4_7", t="STARGR1" },
  FLOOR51C = { f="FLOOR51C", t="METAL1" },
  FLOOR7_3 = { f="FLOOR7_3", t="GOTH11" },

  -- Egypt
  EG01  = { t="EGYPT03",  f="EG01" },
  EG02  = { t="STONE6",  f="EG02" },
  EG03  = { t="EGYPT03",  f="EG03" },
  EG04  = { t="STONE6",  f="EG04" },
  EG05  = { t="EGYPT04",  f="EG05" },
  EG06  = { t="BRIKS06",  f="EG06" },
  SAND1  = { t="ESAND1",  f="SAND1" },
  SAND2  = { t="ESAND2",  f="SAND2" },
  SAND3  = { t="DESROCK2",  f="SAND3" },
  SAND4  = { t="DESROCK3",  f="SAND4" },
  SAND5  = { t="DESROCK4",  f="SAND5" },
  SAND6  = { t="DESROCK2",  f="SAND6" },
  SAND7  = { t="DESROCK5",  f="SAND7" },

  -- Gothic
  G01 = { t="GOTH34",  f="G01" }, --Dark brown BRICK8-9 bricks
  G02 = { t="THATCH2",  f="G02" }, --Dark brown thatch pattern
  G03 = { t="THATCH1",  f="G03" }, --Brown thatch pattern
  G04 = { t="GOTH16",  f="G04" }, --Dark metal with 4 rivets
  G05 = { t="GOTH26",  f="G05" }, --Black carpety tiled floor
  G06 = { t="GOTH23",  f="G06" }, --Black tiles
  G07 = { t="GOTH25",  f="G07" }, --Black riveted floor
  G08 = { t="GOTH27",  f="G08" }, --Black riveted floor with darker rivets
  G09 = { t="GOTH36",  f="G09" }, --Dark brown 4 square metal/bricks
  G10 = { t="GOTH25",  f="G10" }, --Same as G09 but with rivets
  G11 = { t="GOTH09",  f="G11" }, --Black rocks
  G12 = { t="GOTH25",  f="G12" }, --Gray bricks
  G13 = { t="GOTH08",  f="G13" }, --Bloody red bricks
  G14 = { t="GOTH25",  f="G14" }, --Lighter version of G09,
  G15 = { t="GOTH23",  f="G15" }, --Darker black tiles
  G16 = { t="GOTH17",  f="G16" }, --Horizontal metal
  G17 = { t="GOTH18",  f="G17" }, --Vertical metal
  G18 = { t="GOTH15",  f="G18" }, --Metal squares
  G19 = { t="GOTH26",  f="G19" }, --Black wavey floor
  G20 = { t="GOTH10",  f="G20" }, --Green bricks
  G21 = { t="GOTH44",  f="G21" }, --Olive tiles

  -- Glass
  GGLAS01 = { t="GLASS9",  f="GGLAS01" },
  GGLAS02 = { t="GLASS9",  f="GGLAS02" },

  --Most of Gothic lights are red
  GLITE01 = { t="METL01",  f="GLITE01" },
  GLITE02 = { t="METAL",  f="GLITE02" },
  GLITE03 = { t="METL01",  f="GLITE03" },
  GLITE04 = { t="METL01",  f="GLITE04" },
  GLITE05 = { t="METL01",  f="GLITE05" }, --Orange
  GLITE06 = { t="METL01",  f="GLITE06" },
  GLITE07 = { t="METL01",  f="GLITE07" }, --Green
  GLITE08 = { t="METL01",  f="GLITE08" }, --White
  GLITE09 = { t="METL01",  f="GLITE09" }, --Blue
  ---- recolored vresions of GLITE05
  T_GLT5BL = { t="METL01",  f="T_GLT5BL" }, --Blue
  T_GLT5RD = { t="METL01",  f="T_GLT5RD" }, --Red
  T_GLT5WT = { t="METL01",  f="T_GLT5WT" }, --White
  T_GLT5YL = { t="METL01",  f="T_GLT5YL" }, --Yellow
  T_GLT5GN = { t="METL01",  f="T_GLT5GN" }, --Green

  -- Metal / Rust
  DARKM01 = { t="DARKMET1",  f="DARKM01" },
  GMET01 = { t="METL02",  f="GMET01" },
  GMET02 = { t="METL02",  f="GMET02" }, --Rivets
  GMET03 = { t="METL02",  f="GMET03" }, --Less rivets
  GMET04 = { t="GOTH32",  f="GMET04" },
  GMET05 = { t="GOTH15",  f="GMET05" },
  GMET06 = { t="GOTH15",  f="GMET06" },
  GMET07 = { t="METL01",  f="GMET07" },
  MEM01 = { t="HELMET2",  f="MEM01" },

  -- Bricks
  BLACK0 = { t="ALTASH",  f="BLACK0" },
  BRIK01 = { t="BRIKS06",  f="BRIK01" },
  GSTN01 = { t="GOTH07",  f="GSTN01" }, --Gray
  GSTN02 = { t="GOTH07",  f="GSTN02" }, --Dark gray
  GSTN03 = { t="GOTH02",  f="GSTN03" }, --Dark brown bricks/bronze plates
  GSTN04 = { t="GOTH07",  f="GSTN04" }, --Light brown
  GSTN05 = { t="GOTH07",  f="GSTN05" }, --Multicolored brown
  URB1 = { f="URB1", t="URBAN1" },
  URB2 = { f="URB2", t="URBAN2" },

  -- Rock
  RROCK14Z  = { f="RROCK14Z", t="BRIKS09" }, --Gray version
  RROCK21  = { f="RROCK21", t="TEKGRY01" }, --Grayscale version of RROCK20,

  -- Wood flooring
  GWOD01 = { t="WOOD1",  f="GWOD01" }, -- Tiles poorly
  GWOD02 = { t="WOOD1",  f="GWOD02" }, -- Tiles poorly
  GWOD03 = { t="WD01",  f="GWOD03" },
  GWOD04 = { t="WD02",  f="GWOD04" },
  WOODTIL = { t="WD03",  f="WOODTIL" },
  WOODTI2 = { t="WD04",  f="WOODTI2" },

  -- Marble
  BMARB1 = { t="KMARBLE1",  f="BMARB1" },
  BMARB2 = { t="KMARBLE2",  f="BMARB2" },
  BMARB3 = { t="KMARBLE1",  f="BMARB3" },
  RMARB1 = { t="REDMARB1",  f="RMARB1" },
  RMARB2 = { t="REDMARB3",  f="RMARB2" },
  RMARB3 = { t="REDMARB2",  f="RMARB3" },

  -- Grating
  GRATE1 = { t="METL01",  f="GRATE1" },
  GRATE2 = { t="METL01",  f="GRATE2" },
  GRATE3 = { t="METL01",  f="GRATE3" },
  GRATE4 = { t="METL01",  f="GRATE4" },
  GRATE5 = { t="METL01",  f="GRATE5" },
  GRATE6 = { t="METL01",  f="GRATE6" },
  GRATE7 = { t="METL01",  f="GRATE7" },
  GRATE8 = { t="METL01",  f="GRATE8" },

  -- Overhead Lights
  LITBL3F1 = { t="COMPSPAN", f="LITBL3F1" },
  LITBL3F2 = { t="COMPSPAN", f="LITBL3F2" },
  LITE4F1 = { t="SHAWN2", f="LITE4F1" },
  LITE4F2 = { t="SHAWN2", f="LITE4F2" },
  LITES01 = { t="METL01",  f="LITES01" },
  LITES02 = { t="METL01",  f="LITES02" },
  LITES03 = { t="METL01",  f="LITES03" },
  LITES04 = { t="METL01",  f="LITES04" },
  LIGHTS1 = { t="METL01",  f="LIGHTS1" },
  LIGHTS2 = { t="METL01",  f="LIGHTS2" },
  LIGHTS3 = { t="METL01",  f="LIGHTS3" },
  LIGHTS4 = { t="METL01",  f="LIGHTS4" },
  PLITE1 = { f="PLITE1", t="COMPSPAN" },
  TLITE5_1 = { f="TLITE5_1", t="COMPSPAN" },
  TLITE5_2 = { f="TLITE5_2", t="COMPSPAN" },
  TLITE5_3 = { f="TLITE5_3", t="COMPSPAN" },
  TLITE65B = { f="TLITE65B", t="COMPSPAN" },
  TLITE65G = { f="TLITE65G", t="COMPSPAN" },
  TLITE65O = { f="TLITE65O", t="COMPSPAN" },
  TLITE65P = { f="TLITE65P", t="COMPSPAN" },
  TLITE65W = { f="TLITE65W", t="COMPSPAN" },
  TLITE65Y = { f="TLITE65Y", t="COMPSPAN" },

  -- Quake
  QFLAT01 = { t="BRIKS07",  f="QFLAT01" },
  QFLAT02 = { t="BRIKS07",  f="QFLAT02" },
  QFLAT03 = { t="BRIKS07",  f="QFLAT03" },
  QFLAT04 = { t="BRIKS07",  f="QFLAT04" },
  QFLAT05 = { t="BRIKS03",  f="QFLAT05" },
  QFLAT06 = { t="BRIKS03",  f="QFLAT06" },
  QFLAT07 = { t="BRIKS07",  f="QFLAT07" },
  QFLAT09 = { t="METL01",  f="QFLAT09" },
  QFLAT10 = { t="METAL1",  f="QFLAT10" },

  -- Various shiny floors
  SHINY01 = { t="SHAWN2",  f="SHINY01" },
  SHINY02 = { t="SHAWN2",  f="SHINY02" },
  SHINY03 = { t="HEX01",  f="SHINY02" },
  SHINY04 = { t="SHAWN2",  f="SHINY04" },

  -- Snow and Ice
  SNOW1 = { t="SNOW10",  f="SNOW1" }, --Snow
  SNOW2 = { t="ICEFALL",  f="SNOW2" }, --Ice
  SNOW3 = { t="SNOW05",  f="SNOW3" }, --Snowy stone
  SNOW4 = { t="SNOW01",  f="SNOW4" }, --Snowy stone
  SNOW5 = { t="SNOW03",  f="SNOW5" }, --Snowy wall
  SNOW6 = { t="SNOW10",  f="SNOW6" }, --Snow
  SNOW7 = { t="SNOW10",  f="SNOW7" }, --Snow
  SNOW8 = { t="SNOW10",  f="SNOW8" }, --Snow
  SNOW9 = { t="ICEFALL",  f="SNOW9" }, --Ice
  SNOW10F = { t="SNOW10",  f="SNOW10F" }, -- Named like this to avoid texture conflict of the same name
  SNOW11F = { t="SNOW12",  f="SNOW11F" },
  SNOW12F = { t="SNOW15",  f="SNOW12F" },
  SNOW13F = { t="SNOW13",  f="SNOW13F" },
  SNOW14F = { t="SNOW10",  f="SNOW14F" },
  SNOWBRIK = { t="SNOW01",  f="SNOWBRIK" },
  SNOWROCK = { t="SNOW12",  f="SNOWROCK" },
  SNOWSTON = { t="SNOW14",  f="SNOWSTON" },

  -- Dirt/Ground/Grass
  GROUND01 = { t="DESROCK2",  f="GROUND01" }, -- Deadish looking grass
  GROUND02 = { t="DESROCK2",  f="GROUND02" }, -- Same as GROUND01, but less tile friendly
  GROUND03 = { t="DESROCK3",  f="GROUND03" }, -- Grass
  GROUND04 = { t="DESROCK5",  f="GROUND04" }, -- Less saturated grass

  -- Tech flats
  CEIL4_4 = { f="CEIL4_4", t="COMPBLUE" },
  GRENFLOR = { f="GRENFLOR",  t="COMPGREN" },
  GRNLITE2 = { f="GRNLITE2", t="TEKGRN01" },
  ORANFLOR = { f="ORANFLOR", t="COLLITE2" },
  STARBR2F = { t="STARBR2", f="STARBR2F" }, -- Unused
  STARG1F = { t="STARG1", f="STARG1F" }, -- Unused
  STARGRF = { t="STARG1", f="STARGRF" }, -- Unused
  STARTANF = { t="STARTAN2", f="STARTANF" }, -- Currently unused
  TEK1 = { t="TEKWALL8",  f="TEK1" },
  TEK2 = { t="TEKWALL9",  f="TEK2" },
  TEK3 = { t="TEKWALLA",  f="TEK3" },
  TEK4 = { t="TEKWALLB",  f="TEK4" },
  TEK5 = { t="TEKWALLC",  f="TEK5" },
  TEK6 = { t="TEKWALLD",  f="TEK6" },
  TEK7 = { t="TEKWALLE",  f="TEK7" },
  TEKFLR4 = { t="TEKWALL4",  f="TEKFLR4" },

  -- Tiles
  FFLAT01 = { t="GRAY8",  f="FFLAT01" },
  TILES1 = { t="STARGRY1",  f="TILES1" },
  TILES2 = { t="BROWN1",  f="TILES2" },
  TILES3 = { t="STUC01",  f="TILES3" },
  TILES4 = { t="GRAY1",  f="TILES4" },
  TILES5 = { t="STARGRY1",  f="TILES5" },
  TILES6 = { t="GRAY5",  f="TILES6" },

  -- Teleporter pads

  GATE4BL    = { f="GATE4BL", t="METAL" }, -- Blue
  GATE4MG    = { f="GATE4MG", t="METAL" }, -- Magenta
  GATE4OR    = { f="GATE4OR", t="METAL" }, -- Orange
  GATE4PU    = { f="GATE4PU", t="METAL" }, -- Purple
  GATE4RD    = { f="GATE4RD", t="METAL" }, -- Red, just brighter
  GATE4TN    = { f="GATE4TN", t="METAL" }, -- Skin-like

  -- Asphalt
  ROAD1 = { f="ROAD1", t="STONE2" }, -- Consult New_Road.wad for its use!
  ROAD2 = { f="ROAD2", t="BRIKS04" },
  ROAD3 = { f="ROAD3", t="BIGSTONE" },
  ROAD4 = { f="ROAD4", t="BRIKS05" },

  -- Miscellaneous
  REVAPPEA = { t="REVAPPEA", f="CEIL5_1" }, -- Spooky! Meant for walls and such

---------------------------------------------------------------
-- Overwriting existing flats to use new patches for textures
---------------------------------------------------------------

  WFALL1   = { t="WFALL1", f="FWATER1", sane=1 },
  FWATER1  = { t="WFALL1", f="FWATER1", sane=1 },

  LFALL1   = { t="LFALL1", f="LAVA1", sane=1 }, --FIREMAG1,

  BFALL1   = { t="BFAL1",  f="BLOOD1", sane=1 },
  BLOOD1   = { t="BFAL1",  f="BLOOD1", sane=1 },

  SFALL1   = { t="NFALL1",  f="NUKAGE1", sane=1 },
  NUKAGE1  = { t="NFALL1",  f="NUKAGE1", sane=1 },

  KFALL1   = { t="SLMFALL1", f="SLIME01", sane=1 }, -- new patches
  KFALL5   = { t="SLMFALL1", f="SLIME05", sane=1 },
  SLIME01  = { t="SLMFALL1", f="SLIME01", sane=1 },
  SLIME05  = { t="SLMFALL1", f="SLIME05", sane=1 },

  FLOOR6_2 = { f="FLOOR6_2", t="ASH05" },

  -------------------------
  -- New animated floors --
  -------------------------

  FAN1     = { f="FAN1",   t="METAL"    }, -- Ceiling fan

  FIRELAF1 = { t="FIREBLU1",  f="FIRELAF1" },
  FIRELAF2 = { t="FIREBLU2",  f="FIRELAF2" },

  ----------------------------------------
  -- End new animated non-liquid floors --
  ----------------------------------------

  -- New liquids --

  SLUDGE01  = { t="GRYFALL1", f="SLUDGE01", sane=1 },
  MAGMA1   = { t="MFALL1", f="MAGMA1", sane=1 },
  SNOW9 = { t="ICEFALL",  f="SNOW9", sane=1 }, --Ice
  OSLIME01  = { t="OFALL1", f="OSLIME01", sane=1 },
  XLAV1   = { t="LFALL1", f="XLAV1", sane=1 },
  QLAVA1   = { t="LFAL21", f="QLAVA1", sane=1 },
  PURW1   = { t="PURFAL1", f="PURW1", sane=1 },

  -- Warning Strip --
  WARN1 = { t="WARN1", f="WARN2" },
  WARN2 = { t="WARN2", f="WARN1" },

  -----------------------------------
  -- Walls as flats and vice versa --
  -----------------------------------

  XDARKMET = { t="DARKMET1", f="DARKMET1" },
  XGRATE7 = { t="GRATE7", f="GRATE7" },
  XGREEN01 = { t="GREEN01", f="GREEN01" },

  XSKIN3 = { t="SKIN3", f="SKIN3" },
  XSKIN4 = { t="SKIN4", f="SKIN4" },
  XHELLCMT  = { t="HELLCMT7", f="HELLCMT7" },
  XQFLAT07 = { t="QFLAT07", f="QFLAT07" },

  -- liquids

  XMFALL1 = { t="MFALL1", f="MFALL1" },

  ------------------
  -- Craneo Stuff --
  ------------------

  BANKDOOR = { t="BANKDOOR", f="FLAT23"},
  MONYFRON = { t="MONYFRON", f="MONYFLAT"},
  MONYSIDE = { t="MONYSIDE", f="MONYFLAT"},
  MONYFLAT = { t="MONYFRON", f="MONYFLAT"},

  CREYEWLL = { t="CREYEWLL", f="FLAT15"}, -- red skin wall with eyes
  CRFSHWLL = { t="CRFSHWLL", f="FLAT15"}, -- red flesh wall
  CRGRSWLL = { t="CRGRSWLL", f="FLAT5_5"}, -- brown flesh wall with lacerations
  CRHRTWLL = { t="CRHRTWLL", f="FLAT15"}, -- red flesh wall with lacerations

  -- Craneo's arcade machine screens
  ARCD2 = { t="ARCD2", f="CEIL4_3"},
  ARCD3 = { t="ARCD3", f="CEIL4_3"},
  ARCD4 = { t="ARCD4", f="CEIL4_3"},
  ARCD5 = { t="ARCD5", f="CEIL4_3"},
  ARCD6 = { t="ARCD6", f="CEIL4_3"},
  ARCD7 = { t="ARCD7", f="CEIL4_3"},
  ARCD8 = { t="ARCD8", f="CEIL4_3"},
  ARCD9 = { t="ARCD9", f="CEIL4_3"},
  ARCD10 = { t="ARCD10", f="CEIL4_3"},
  ARCD11 = { t="ARCD11", f="CEIL4_3"},

  -- Craneo's classical painting textures
  CPAQLRRE = { t="CPAQLRRE", f="CEIL4_3"},
  CPFLAYIN = { t="CPFLAYIN", f="CEIL4_3"},
  CPGARDEN = { t="CPGARDEN", f="CEIL4_3"},
  CPGARDN2 = { t="CPGARDN2", f="CEIL4_3"},
  CPMEDUS = { t="CPMEDUS", f="CEIL4_3"},
  CPHEGOAT = { t="CPHEGOAT", f="CEIL4_3"},
  CPHLLDEM = { t="CPHLLDEM", f="CEIL4_3"},
  CPHRSEMN = { t="CPHRSEMN", f="CEIL4_3"},
  CPHRSMN2 = { t="CPHRSMN2", f="CEIL4_3"},
  CPSATRN = { t="CPSATRN", f="CEIL4_3"},
  CPVLAD = { t="CPVLAD", f="CEIL4_3"},
  CPPAINT1 = { t="CPPAINT1", f="CEIL4_3"},
  CPPAINT2 = { t="CPPAINT2", f="CEIL4_3"},
  CPPAINT3 = { t="CPPAINT3", f="CEIL4_3"},
  CPPAINT4 = { t="CPPAINT4", f="CEIL4_3"},
  CPPAINT5 = { t="CPPAINT5", f="CEIL4_3"},
  CPPAINT6 = { t="CPPAINT6", f="CEIL4_3"},

  -- Craneo's wall of guns
  CRGNRCK1 = { t="CRGNRCK1", f="FLAT19"}, -- wall of vanilla weapons
  CRGNRCK2 = { t="CRGNRCK2", f="FLAT19"}, -- wall of non-canonical weapons
  CRGNRCK3 = { t="CRGNRCK3", f="FLAT19"}, -- empty wall

  -----------------------------------
  -- Demiosis and Craneo's adverts --
  -----------------------------------

  ADVCR1 = { t="ADVCR1", f="CEIL4_3"},
  ADVCR2 = { t="ADVCR2", f="CEIL4_3"},
  ADVCR3 = { t="ADVCR3", f="CEIL4_3"},
  ADVCR4 = { t="ADVCR4", f="CEIL4_3"},
  ADVCR5 = { t="ADVCR5", f="CEIL4_3"},
  ADVDE1 = { t="ADVDE1", f="CEIL4_3"},
  ADVDE2 = { t="ADVDE2", f="CEIL4_3"},
  ADVDE3 = { t="ADVDE3", f="CEIL4_3"},
  ADVDE4 = { t="ADVDE4", f="CEIL4_3"},
  ADVDE5 = { t="ADVDE5", f="CEIL4_3"},
  ADVDE6 = { t="ADVDE6", f="CEIL4_3"},
  ADVDE7 = { t="ADVDE7", f="CEIL4_3"},


  ----------------------------------------------
  -- Demiosis decorative tags/bloody writings --
  ----------------------------------------------

  TAG1 = { t="TAG1", f="CEIL4_3"},
  TAG2 = { t="TAG2", f="CEIL4_3"},
  TAG3 = { t="TAG3", f="CEIL4_3"},
  TAG4 = { t="TAG4", f="CEIL4_3"},
  TAG5 = { t="TAG5", f="CEIL4_3"},
  TAG6 = { t="TAG6", f="CEIL4_3"},
  TAG7 = { t="TAG7", f="CEIL4_3"},
  TAG8 = { t="TAG8", f="CEIL4_3"},
  TAG9 = { t="TAG9", f="CEIL4_3"},
  TAG10 = { t="TAG10", f="CEIL4_3"},
  TAG11 = { t="TAG11", f="CEIL4_3"},
  TAGS1 = { t="TAGS1", f="CEIL4_3"},
  TAGS2 = { t="TAGS2", f="CEIL4_3"},
  TAGS3 = { t="TAGS3", f="CEIL4_3"},
  TAGS4 = { t="TAGS4", f="CEIL4_3"},

  ----------------------------------------------
  -- Craneo decorative tags/bloody writings --
  ----------------------------------------------

  TAGCR1 = { t="TAGCR1", f="CEIL4_3"},
  TAGCR2 = { t="TAGCR2", f="CEIL4_3"},
  TAGCR3 = { t="TAGCR3", f="CEIL4_3"},
  TAGCR4 = { t="TAGCR4", f="CEIL4_3"},
  TAGCR5 = { t="TAGCR5", f="CEIL4_3"},
  TAGCR6 = { t="TAGCR6", f="CEIL4_3"},
  TAGCR7 = { t="TAGCR7", f="CEIL4_3"},
  TAGCR8 = { t="TAGCR8", f="CEIL4_3"},
  TAGCR9 = { t="TAGCR9", f="CEIL4_3"},
  TAGCR10 = { t="TAGCR10", f="CEIL4_3"},
  TAGCR11 = { t="TAGCR11", f="CEIL4_3"},
  TAGCR12 = { t="TAGCR12", f="CEIL4_3"},
  TAGCR13 = { t="TAGCR13", f="CEIL4_3"},
  TAGCR14 = { t="TAGCR14", f="CEIL4_3"},
  TAGCR15 = { t="TAGCR15", f="CEIL4_3"},
  TAGCR16 = { t="TAGCR16", f="CEIL4_3"},


  ------------------------
  -- Composite textures --
  ------------------------

  -- Tech --

  -- special rails
  GDRAIL1 = { t="GDRAIL1", f="CEIL5_1", rail_h=32}, -- is intended for fabs only

  -- Horizontal lights, based on the light bar found in
  -- the Doom2 exit door texture
  T_HLITE1 = { t="T_HLITE1", f="FLAT23" },
  T_HLITEY = { t="T_HLITEY", f="FLAT23" },
  T_HLITEG = { t="T_HLITEG", f="FLAT23" },
  T_HLITEB = { t="T_HLITEB", f="FLAT23" },

  -- Recolored CEIL4_3 flats
  T_CL43R = { t="COMPRED" , f="T_CL43R" },
  T_CL43Y = { t="SHAWN2" , f="T_CL43Y" }, -- needs yellow variant of COMPBLUE
  T_CL43G = { t="COMPGREN" , f="T_CL43G" },
  T_CL43P = { t="SHAWN2" , f="T_CL43P" }, -- needs purple variant of COMPBLUE

  -- Recolored LITE5 + Exit door light
  T_VLITER = { t="T_VLITER", f="FLAT23"},
  T_VLITEO = { t="T_VLITEO", f="FLAT23"},
  T_VLITEY = { t="T_VLITEY", f="FLAT23"},
  T_VLITEG = { t="T_VLITEG", f="FLAT23"},
  T_VLITEP = { t="T_VLITEP", f="FLAT23"},

  -- Recolored LITE5's
  T_VSLTER = { t="T_VSLTER", f="FLAT23"},
  T_VSLTEO = { t="T_VSLTEO", f="FLAT23"},
  T_VSLTEY = { t="T_VSLTEY", f="FLAT23"},
  T_VSLTEG = { t="T_VSLTEG", f="FLAT23"},
  T_VSLTEP = { t="T_VSLTEP", f="FLAT23"},

  -- Sandy Tech floors
  T_SDTCH1 = { t="STARTAN1", f = "T_SDTCH1"},
  T_SDTCH2 = { t="METL04", f = "T_SDTCH2"},
  T_SDTCH3 = { t="BRONZE5", f = "T_SDTCH3"},
  T_SDTCH4 = { t="CEM11", f = "T_SDTCH4"},
  T_SDTCH5 = { t="BROWN1", f = "T_SDTCH5"},

  -- COMPBLUE recolors
  COMPYELL = { t="COMPYELL", f = "ORANFLOR"}, -- comp yellow, why more would you wallow!?

  -- Gothic --

  -- Light trims
  T_GTHLY = { t="T_GTHLY", f="G04" },
  T_GTHLG = { t="T_GTHLG", f="G04" },
  T_GTHLB = { t="T_GTHLB", f="G04" },
  T_GTHLP = { t="T_GTHLP", f="G04" },

  -- Quad lights
  T_GHFLY = { t="G16", f="T_GHFLY" },
  T_GHFLB = { t="G16", f="T_GHFLB" },
  T_GHFLG = { t="G16", f="T_GHFLG" },
  T_GHFLP = { t="G16", f="T_GHFLP" },

  -------------
  -- DUKETEX --
  -------------

  -- store shelves
  DNSTOR01 = { t="DNSTOR01", f="CEIL5_2"},
  DNSTOR02 = { t="DNSTOR02", f="CEIL5_2"},
  DNSTOR03 = { t="DNSTOR03", f="CEIL5_2"},
  DNSTOR04 = { t="DNSTOR04", f="CEIL5_2"},
  DNSTOR05 = { t="DNSTOR05", f="CEIL5_2"},
  DNSTOR06 = { t="DNSTOR06", f="CEIL5_2"},
  DNSTOR07 = { t="DNSTOR07", f="CEIL5_2"},
  DNSTOR08 = { t="DNSTOR08", f="CEIL5_2"},
  DNSTOR09 = { t="DNSTOR09", f="CEIL5_2"},
  DNSTOR10 = { t="DNSTOR10", f="CEIL5_2"},
  DNSTOR11 = { t="DNSTOR11", f="CEIL5_2"},
  DNSTOR12 = { t="DNSTOR12", f="CEIL5_2"},
  DNSTOR13 = { t="DNSTOR13", f="CEIL5_2"},
  DNSTOR20 = { t="DNSTOR20", f="CEIL5_2"},
  DNSTOR21 = { t="DNSTOR21", f="CEIL5_2"},

  -- 8px step
  DNSTEP01 = { t="DNSTEP01", f="FLAT5_4"},

  ------------------
  -- MSSP Stuff --
  ------------------

  -- MSSP-TECH --
  -- silver walls (256px)
  OBTBSLV1 = { t="OBTBSLV1", f="GRATE1"},
  OBTBSLV2 = { t="OBTBSLV2", f="SHINY02"},
  OBTBSLV3 = { t="OBTBSLV3", f="SHINY04"},
  OBTBSLV4 = { t="OBTBSLV4", f="SHINY03"},
  OBTBSLV5 = { t="OBTBSLV5", f="FLAT3"},

  -- silver wall, bronze-framed (256px)
  OBTSVBZ1 = { t="OBTSVBZ1", f="G8_BRNF1"},
  OBTSVBZ2 = { t="OBTSVBZ2", f="G8_BRNF2"},
  OBTSVBZ3 = { t="OBTSVBZ3", f="G8_BRNF3"},

  -- silver walls (128px)
  OBTBSTX1 = { t="OBTBSTX1", f="SHINY03"},
  OBTBSTX2 = { t="OBTBSTX2", f="GRATE1"},
  OBTBSTX3 = { t="OBTBSTX3", f="GRATE6"},

  OBTSTX1B = { t="OBTSTX1B", f="STARTANF"}, -- brown recolor composite
  OBTSTX1G = { t="OBTSTX1G", f="STARG1F"}, -- green recolor composite

  -- techy brown walls (128px)
  G8_BRNW1 = { t="G8_BRNW1", f="SLIME16"},
  G8_BRNW2 = { t="G8_BRNW2", f="FLOOR4_1"},
  G8_BRNW3 = { t="G8_BRNW3", f="FLOOR4_5"},

  G8_BR1GY = { t="G8_BRNW1", f="GRATE2"}, -- grey recolor composite
  G8_BR2GY = { t="G8_BRNW2", f="FLOOR4_8"},
  G8_BR3GY = { t="G8_BRNW3", f="G15"},

  -- techy brick walls (256px)
  OBTBSLB1 = { t="OBTBSLB1", f="SHINY03"},
  OBTBSLB2 = { t="OBTBSLB2", f="FLOOR4_8"},
  OBTBSLB3 = { t="OBTBSLB3", f="SLIME14"},
  OBTBSLB4 = { t="OBTBSLB4", f="SLIME15"},
  OBTBSLB5 = { t="OBTBSLB5", f="MFLR8_1"},

  OBTBSB2B = { t="OBTBSB2B", f="FLOOR5_3"}, -- brown color composite
  OBTBSB3B = { t="OBTBSB3B", f="SLIME16"},
  OBTBSB4B = { t="OBTBSB4B", f="FLOOR4_1"},
  OBTBSB5B = { t="OBTBSB5B", f="FLAT5"},

  OBTSBGRE = { t="OBTSBGRE", f="DARKF02"}, -- bloodied version of the hex bricks

  -- custom cement walls (128px)
  OBTBCEM1 = { t="OBTBCEM1", f="FLOOR3_3"},
  OBTBCEM2 = { t="OBTBCEM2", f="SLIME16"},
  OBTBCEM3 = { t="OBTBCEM3", f="DEM1_6"},

  OBTBCMR1 = { t="OBTBCMR1", f="RMARB2"},
  OBTBCMR2 = { t="OBTBCMR2", f="FLAT15"},
  OBTBCMR3 = { t="OBTBCMR3", f="GMET02"},

  -- silver flats (128px)
  OBTBSFL1 = { t="OBTBSLV1", f="OBTBSFL1"}, --< metal grates
  OBTBSFL2 = { t="OBTBSLV2", f="OBTBSFL2"},
  OBTBSFL3 = { t="OBTBSTX1", f="OBTBSFL3"},

  OBTSVBF1 = { t="OBTBSLB2", f="OBTSVBF1"}, --< brick
  OBTSVBF2 = { t="OBTBSLB3", f="OBTSVBF2"},
  OBTSVBF3 = { t="OBTBSLB4", f="OBTSVBF3"},

  G8_BRNF1 = { t="G8_BRNW1", f="G8_BRNF1"}, --< brown floors/ceils
  G8_BRNF2 = { t="G8_BRNW3", f="G8_BRNF2"},
  G8_BRNF3 = { t="G8_BRNW2", f="G8_BRNF3"},

  OBTSBF1B = { t="OBTBSB3B", f="OBTSBF1B"}, -- brown color composite
  OBTSBF2B = { t="OBTBSB4B", f="OBTSBF2B"},
  OBTSBF3B = { t="OBTBSB5B", f="OBTSBF3B"},

  OBTSBF1R = { t="HELLCMT1", f="OBTSBF1R"}, -- red
  OBTSBF2R = { t="HELLCMT2", f="OBTSBF2R"},
  OBTSBF3R = { t="REDMARB1", f="OBTSBF3R"},

  -- 256-wide doors
  G8_SVDR3 = { t="G8_SVDR3", f="FLAT23"},

  -- it unfortunately needs to be said.
  G7DODSLS = { t="G7DODSLS", f="FLAT23"},

  NAHIDA = { t="NAHIDA", f="FLAT23"},
  BATHWTR1 = { t="BATHWTR1", f="FLAT23"},
  BATHWTR2 = { t="BATHWTR2", f="FLAT23"},

  ----------------------
  -- Special Textures --
  ----------------------
  FINVSBLE = { t="FINVSBLE", f="FINVSBLE"},

  -- Flats as walls and vice versa, resource pack edition
  XG19  = { t="G19", f="G19" },
  X_COMPBL  = { t="COMPBLUE", f="COMPBLUE" },
  X_ORANFL  = { t="ORANFLOR", f="ORANFLOR" },
  X_BRICK4  = { t="BRICK4", f="BRICK4" },
  X_FLOOR7  = { t="FLOOR7_3", f="FLOOR7_3" },
  XCARPET5  = { t="CARPET5", f="CARPET5" }
}

OBS_RESOURCE_PACK_ANIMDEFS =
[[
// Animations for Obsidian Resource Pack:

	texture CGCANI00
  allowdecals
  pic CGCANI00 tics 1.5
  pic CGCANI01 tics 1.5
  pic CGCANI02 tics 1.5
  pic CGCANI03 tics 1.5
  pic CGCANI04 tics 1.5
  pic CGCANI05 tics 1.5
  pic CGCANI06 tics 1.5
  pic CGCANI07 tics 1.5
	
	texture DECMP04A
  allowdecals
  pic DECMP04A tics 2
  pic DECMP04B tics 2
  pic DECMP04C tics 2
  pic DECMP04D tics 2
  pic DECMP04E tics 2
  pic DECMP04F tics 2
  pic DECMP04G tics 2
  pic DECMP04H tics 2
	pic DECMP04B tics 2
	
	texture TVSNOW01
  allowdecals
  pic TVSNOW01 tics 2
  pic TVSNOW02 tics 2
  pic TVSNOW03 tics 2

	texture COMPFUZ1
  allowdecals
  pic COMPFUZ1 tics 2
  pic COMPFUZ2 tics 2
  pic COMPFUZ3 tics 2
	pic COMPFUZ4 tics 2
	
	texture COMPY1
  allowdecals
  pic COMPY1 tics 4
  pic COMPY2 tics 4
  pic COMPY3 tics 4
  pic COMPY2 tics 4
	
	texture CANDLE1
  pic CANDLE1 tics 4
  pic CANDLE2 tics 4
  pic CANDLE3 tics 4
	
	// Black FIRELAVA
	Texture LAVBLAK1
	allowdecals
	pic LAVBLAK1 tics 8
	pic LAVBLAK2 tics 8
	
	// Blue FIRELAVA
	Texture LAVBLUE1
	allowdecals
	pic LAVBLUE1 tics 8
	pic LAVBLUE2 tics 8
	
	// Green FIRELAVA
	Texture LAVGREN1
	allowdecals
	pic LAVGREN1 tics 8
	pic LAVGREN2 tics 8
	
	// White FIRELAVA
	Texture LAVWHIT1
	allowdecals
	pic LAVWHIT1 tics 8
	pic LAVWHIT2 tics 8
	
	// Black FIREBLU1
	Texture FIREBLK1
	allowdecals
	pic FIREBLK1 tics 8
	pic FIREBLK2 tics 8
	
	// Doom1 SLADWALL slime fall
	texture SLADRIP1
	allowdecals
  pic SLADRIP1 tics 6
  pic SLADRIP2 tics 6
  pic SLADRIP3 tics 6
	
	//Red version of black GST fontfall
	texture KSTFONT1
  allowdecals
  pic KSTFONT1 tics 6
  pic KSTFONT2 tics 6
  pic KSTFONT3 tics 6
	
	//Green version
	texture KSTFNTG1
  allowdecals
  pic KSTFNTG1 tics 6
  pic KSTFNTG2 tics 6
  pic KSTFNTG3 tics 6
	
	// Broken animated screen
	Texture COMPSA1
	allowdecals
	range COMPSA30 tics 2
	
	// UAC logo screen
	Texture COMPSC1
	allowdecals
	range COMPSC12 tics 1.5
	
	// Multiple broken animated screens
	Texture COMPSD1
	allowdecals
	range COMPSD8 tics 2
	
	Texture NMONIA1
	allowdecals
	pic NMONIA1 tics 3
	pic NMONIA2 tics 3
	pic NMONIA3 tics 3
	pic NMONIA4 tics 3
	pic NMONIA5 tics 3
	pic NMONIA6 tics 3
	pic NMONIA7 tics 3
	pic NMONIA8 tics 3
	
	// Static screen
	Texture NOISE1
	allowdecals
	pic NOISE1 tics 1.5
	pic NOISE2 tics 1.5
	pic NOISE3 tics 1.5
	pic NOISE4 tics 1.5
	
	// Smaller static screen
	Texture NOISE2A
	allowdecals
	pic NOISE2A tics 1.5
	pic NOISE2B tics 1.5
	pic NOISE2C tics 1.5
	pic NOISE2D tics 1.5
	
	// Smaller static screen 2
	Texture NOISE3A
	allowdecals
	pic NOISE3A tics 1.5
	pic NOISE3B tics 1.5
	pic NOISE3C tics 1.5
	pic NOISE3D tics 1.5
	
	//Gray liquid fall
	texture GRYFALL1
  pic GRYFALL1 tics 8
  pic GRYFALL2 tics 8
  pic GRYFALL3 tics 8
	pic GRYFALL4 tics 8
	
	//Dark gray slime fall
	texture OFALL1
  pic OFALL1 tics 8
  pic OFALL2 tics 8
  pic OFALL3 tics 8
	pic OFALL4 tics 8
	
	//Brown liquid fall
	texture SLMFALL1
  pic SLMFALL1 tics 8
  pic SLMFALL2 tics 8
  pic SLMFALL3 tics 8
	pic SLMFALL4 tics 8
	
	//Blood liquid fall
	texture BFAL1
  pic BFAL1 tics 8
  pic BFAL2 tics 8
  pic BFAL3 tics 8
	pic BFAL4 tics 8
	
	//Green liquid fall
	texture NFALL1
  pic NFALL1 tics 8
  pic NFALL2 tics 8
  pic NFALL3 tics 8
	pic NFALL4 tics 8
	
	//Lava liquid fall
	texture LFALL1
  pic LFALL1 tics 8
  pic LFALL2 tics 8
  pic LFALL3 tics 8
	pic LFALL4 tics 8
	
	//Lava liquid fall 2
	texture LFAL21
  pic LFAL21 tics 8
  pic LFAL22 tics 8
  pic LFAL23 tics 8
	pic LFAL24 tics 8
	
	//Water liquid fall
	texture WFALL1
  pic WFALL1 tics 8
  pic WFALL2 tics 8
  pic WFALL3 tics 8
	pic WFALL4 tics 8
	
	//Cooler purple liquid fall
	texture PURFAL1
  pic PURFAL1 tics 8
  pic PURFAL2 tics 8
  pic PURFAL3 tics 8
	pic PURFAL4 tics 8

	//Magma
	texture MFALL1
  pic MFALL1 tics 8
  pic MFALL2 tics 8
  pic MFALL3 tics 8
	pic MFALL4 tics 8
	
	//Wall copy of FAN1 flat, meant as ventilation
	texture DFAN1
  pic DFAN1 tics 1
  pic DFAN2 tics 1
  pic DFAN3 tics 1
  pic DFAN4 tics 1

	//Broken grocery fridge from Duke Nukem
	texture DNSTOR09
	pic DNSTOR09 tics 8
	pic DNSTOR10 tics 8
	pic DNSTOR11 tics 8

	//These two need definitions because they're solid like normal
	//walls, not liquid so decals can be applied to them.
	
	//Frozen waterfall type 1
	texture ICEFALL
	allowdecals
	pic ICEFALL tics 8
	pic ICEFALL tics 8

  //Green crystal
  texture GRNSTONE
  allowdecals
  pic GRNSTONE tics 17
  pic GRNSTON1 tics 2
  pic GRNSTON2 tics 2
  pic GRNSTON3 tics 2
	
// Switches //

  switch doom 3 SW1CHN on pic SW2CHN tics 0
  switch doom 3 SW1GOTH on pic SW2GOTH tics 0
  switch doom 3 SW1QUAK on pic SW2QUAK tics 0
  switch doom 3 SW1SKUL1 on pic SW2SKUL1 tics 0
  switch doom 3 SW1PENT on pic SW2PENT tics 0
  
  switch doom 3 SDGTHSW1 on pic SDGTHSW2 tics 0
	
//Crap for flats here
	
  warp flat LAVA1
  warp flat LAVA2
  warp flat LAVA3
  warp flat LAVA4
  warp2 flat FWATER1
  warp2 flat FWATER2
  warp2 flat FWATER3
  warp2 flat FWATER4
  warp2 flat BLOOD1
  warp2 flat BLOOD2
  warp2 flat BLOOD3
  warp flat NUKAGE1
  warp flat NUKAGE2
  warp flat NUKAGE3
  warp2 flat SLIME01
  warp2 flat SLIME02
  warp2 flat SLIME03
  warp2 flat SLIME04
  warp flat SLIME05
  warp flat SLIME06
  warp flat SLIME07
  warp flat SLIME08
  warp flat SLUDGE01
  warp flat SLUDGE02
  warp flat SLUDGE03
  warp flat SLUDGE04
  warp flat XWATER1
  warp flat XWATER2
  warp flat XWATER3
  warp flat XWATER4
  warp flat QLAVA1
  warp flat QLAVA2
  warp flat QLAVA3
  warp flat QLAVA4
  warp flat MAGMA1
  warp flat MAGMA2
  warp flat MAGMA3
  warp flat MAGMA4
  warp2 flat OSLIME01
  warp2 flat OSLIME02
  warp flat XLAV1
  warp flat XLAV2
  warp flat PURW1
  warp flat PURW2

  TEXTURE FWATER1
  PIC  1	 TICS  1
  PIC  1	 TICS  1

  TEXTURE NUKAGE1
  PIC  1	 TICS  1
  PIC  1	 TICS  1

  TEXTURE LAVA1
  PIC  1	 TICS  1
  PIC  1	 TICS  1

  TEXTURE BLOOD1
  PIC  1	 TICS  1
  PIC  1	 TICS  1

  TEXTURE SLIME01
  PIC  1	 TICS  1
  PIC  1	 TICS  1

  TEXTURE SLIME05
  PIC  1	 TICS  1
  PIC  1	 TICS  1

  //New
  TEXTURE SLUDGE01
  PIC  1	 TICS  1
  PIC  1	 TICS  1

  TEXTURE OSLIME01
  PIC  1	 TICS  5
  PIC  2	 TICS  5

  TEXTURE QLAVA1
  PIC  1	 TICS  8
  PIC  2	 TICS  8
  PIC  3	 TICS  8
  PIC  4	 TICS  8

  TEXTURE MAGMA1
  PIC  1	 TICS  8
  PIC  2	 TICS  8
  PIC  3	 TICS  8
  PIC  4	 TICS  8

  TEXTURE FIRELAF1
  allowdecals
  PIC  1	 TICS  8
  PIC  2	 TICS  8

  TEXTURE XLAV1
  PIC  1	 TICS  8
  PIC  2	 TICS  8

  TEXTURE PURW1
  PIC  1	 TICS  8
  PIC  2	 TICS  8

  TEXTURE FAN1
  PIC  1	 TICS  1
  PIC  2	 TICS  1
  PIC  3   TICS  1
  PIC  4   TICS  1
]]

EPIC_BRIGHTMAPS =
[[brightmap texture COMPSTA3
{
  map OBRCPST1
}
brightmap texture COMPSTA4
{
  map OBRCPST1
}
brightmap texture COMPSTA5
{
  map OBRCPST2
}
brightmap texture COMPSTA6
{
  map OBRCPST2
}
brightmap texture COMPSTA7
{
  map OBRCPST1
}
brightmap texture COMPSTA8
{
  map OBRCPST1
}
brightmap texture COMPSTA9
{
  map OBRCPST1
}
brightmap texture COMPSTAA
{
  map OBRCPST1
}
brightmap texture COMPSTAB
{
  map OBRCPST3
}

// shawcomp set

brightmap texture SHAWCOMP
{
  map OBRSHCP1
}
brightmap texture CONSOLE3
{
  map OBRSHCP1
}
brightmap texture CONSOLE4
{
  map OBRCNSL4
}
brightmap texture CONSOLEF
{
  map OBRCNSLF
}
brightmap texture CONSOLEG
{
  map OBRCNSLG
}

// large single monitors

brightmap texture COMPCT01
{
  map OBRCPCT1
}
brightmap texture COMPCT02
{
  map OBRCPCT1
}
brightmap texture COMPCT03
{
  map OBRCPCT1
}
brightmap texture COMPCT04
{
  map OBRCPCT1
}
brightmap texture COMPCT05
{
  map OBRCPCT1
}
brightmap texture COMPCT06
{
  map OBRCPCT1
}
brightmap texture COMPCT07
{
  map OBRCPCT2
}

brightmap texture COMPFUZ1
{
  map CMPFUZBR
}
brightmap texture COMPFUZ2
{
  map CMPFUZBR
}
brightmap texture COMPFUZ3
{
  map CMPFUZBR
}
brightmap texture COMPFUZ4
{
  map CMPFUZBR
}

brightmap texture CGCANI00
{
  map CGANIBR
}
brightmap texture CGCANI01
{
  map CGANIBR
}
brightmap texture CGCANI02
{
  map CGANIBR
}
brightmap texture CGCANI03
{
  map CGANIBR
}
brightmap texture CGCANI04
{
  map CGANIBR
}
brightmap texture CGCANI05
{
  map CGANIBR
}
brightmap texture CGCANI06
{
  map CGANIBR
}
brightmap texture CGCANI07
{
  map CGANIBR
}


// silver light variations
brightmap texture SILVER2R
{
  map OBRSLVL
}
brightmap texture SILVER2O
{
  map OBRSLVL
}
brightmap texture SILVER2Y
{
  map OBRSLVL
}
brightmap texture SILVER2W
{
  map OBRSLVL
}
brightmap texture SILVER2G
{
  map OBRSLVL
}

// vent (the only one that needs a brightmap TBH
brightmap texture COMPVEN2
{
  map OBRCPVN2
}

// vertical lights
brightmap texture LITE2
{
  map OBRLITE2
}
brightmap texture LITE96
{
  map OBRLIT96
}
brightmap texture LITESTON
{
  map OBRLITSN
}

// comptiles
brightmap texture COMPTIL2
{
  map OBRCPTIL
}
brightmap texture COMPTIL3
{
  map OBRCPTIL
}
brightmap texture COMPTIL4
{
  map OBRCPTIL
}
brightmap texture COMPTIL5
{
  map OBRCPTIL
}
brightmap texture COMPTIL6
{
  map OBRCPTIL
}
brightmap texture GRAYBLU1
{
  map OBRCPTIL
}
brightmap texture SILVBLU1
{
  map OBRCPTIL
}
brightmap texture TEKGRBLU
{
  map OBRCPTIL
}

// monitors with static/noise
brightmap texture NOISE1
{
  map OBRNOIS1
}
brightmap texture NOISE2
{
  map OBRNOIS1
}
brightmap texture NOISE3
{
  map OBRNOIS1
}
brightmap texture NOISE4
{
  map OBRNOIS1
}

// quad monitors
brightmap texture COMPSD1
{
  map OBRCPSD1
}
brightmap texture COMPSD2
{
  map OBRCPSD1
}
brightmap texture COMPSD3
{
  map OBRCPSD1
}
brightmap texture COMPSD4
{
  map OBRCPSD1
}
brightmap texture COMPSD5
{
  map OBRCPSD1
}
brightmap texture COMPSD6
{
  map OBRCPSD1
}
brightmap texture COMPSD7
{
  map OBRCPSD1
}
brightmap texture COMPSD8
{
  map OBRCPSD1
}

brightmap texture CONSOLEA
{
  map CONSOLBR
}
brightmap texture CONSOLEB
{
  map CONSOLBR
}
brightmap texture CONSOLEC
{
  map CONSOLBR
}
brightmap texture CONSOLED
{
  map CONSOLBR
}
brightmap texture CONSOLEE
{
  map CONSOLBR
}

//
brightmap texture NOISE2A
{
  map OBRNOIS2
}
brightmap texture NOISE2B
{
  map OBRNOIS2
}
brightmap texture NOISE2C
{
  map OBRNOIS2
}
brightmap texture NOISE2D
{
  map OBRNOIS2
}
//
brightmap texture NOISE3A
{
  map OBRNOIS3
}
brightmap texture NOISE3B
{
  map OBRNOIS3
}
brightmap texture NOISE3C
{
  map OBRNOIS3
}
brightmap texture NOISE3D
{
  map OBRNOIS3
}

// lite5 recolors - excluding the original lite5
brightmap texture T_VSLTEG
{
  map OBRLITE5
}
brightmap texture T_VSLTEO
{
  map OBRLITE5
}
brightmap texture T_VSLTEP
{
  map OBRLITE5
}
brightmap texture T_VSLTER
{
  map OBRLITE5
}
brightmap texture T_VSLTEY
{
  map OBRLITE5
}

// gothic stuf
brightmap texture GLASS1
{
  map OBRGLSBG
}
brightmap texture GLASS2
{
  map OBRGLSBG
}
brightmap texture GLASS3
{
  map OBRGLSBG
}
brightmap texture GLASS4
{
  map OBRGLSBG
}
brightmap texture GLASS6
{
  map OBRGLSBG
}
brightmap texture GLASS11
{
  map OBRGLSTL
}
brightmap texture GLASS12
{
  map OBRGLSTL
}
brightmap texture GLASS13
{
  map OBRGLSTL
}
brightmap texture GLASS14
{
  map OBRGLSTL
}
brightmap texture GOTH21
{
  map OBRGT21
}
brightmap texture GOTH04
{
  map GOTH04BR
}
brightmap texture GOTH19
{
  map GOTH19BR
}
brightmap texture GOTH20
{
  map GOTH20BR
}
brightmap texture GOTH33
{
  map GOTH33BR
}

// gothic lavafalls
brightmap texture MFALL1
{
  map MFALLBR
}
brightmap texture MFALL2
{
  map MFALLBR
}
brightmap texture MFALL3
{
  map MFALLBR
}
brightmap texture MFALL4
{
  map MFALLBR
}

// gothic switches
brightmap texture SW2SKUL1
{
  map OBRS2SK
}
brightmap texture SW2PENT
{
  map OBRS2PT
}

brightmap texture SW2QUAK
{
  map OBRS2QK
}
brightmap texture SW2GOTH
{
  map OBRS2GH
}
brightmap texture SW2CHN
{
  map OBRS2CN
}

// colorful churchy glass
brightmap texture GLASS7
{
  map OBRGLAS7
}

brightmap texture GLASS8
{
  map OBRGLAS8
}

brightmap texture GLASS9
{
  map OBRGLAS9
}

// bookshelves

brightmap texture PANBOOK2
{
  map OBRPNBK2
}

brightmap texture PANBOOK3
{
  map OBRPNBK3
}

// liquids

// Oblige lava patch
brightmap texture FIREMAG1
{
  map OBRLFAL1
}

brightmap texture FIREMAG2
{
  map OBRLFAL2
}

brightmap texture FIREMAG3
{
  map OBRLFAL3
}

//urban
brightmap texture CITY01
{
  map OBRCITY1
}

brightmap texture CITY02
{
  map OBRCITY1
}

brightmap texture CITY03
{
  map OBRCITY1
}

brightmap texture CITY04
{
  map OBRCITY4
}

brightmap texture CITY05
{
  map OBRCITY5
}

brightmap texture CITY06
{
  map OBRCITY4
}

brightmap texture CITY07
{
  map OBRCITY7
}

brightmap texture CITY12
{
  map OBRCTY12
}

brightmap texture CITY14
{
  map OBRCTY14
}

brightmap texture CITY04N
{
  map CTY04NBR
}

brightmap texture CITY05N
{
  map CTY05NBR
}

brightmap texture CITY06N
{
  map CTY04NBR
}

brightmap texture CITY07N
{
  map CTY07NBR
}

brightmap texture CITY11N
{
  map CTY11NBR
}

brightmap texture CITY12N
{
  map CTY12NBR
}

brightmap texture CITY13N
{
  map CTY13NBR
}

brightmap texture CITY14N
{
  map CTY14NBR
}

brightmap texture GRAYMET6
{
  map OBRGRYMT
}

brightmap texture GRAYMET7
{
  map OBRGRYMT
}

brightmap texture GRAYMET8
{
  map OBRGRYMT
}

brightmap texture GRAYMET9
{
  map OBRGRYMT
}

brightmap texture GRAYMETA
{
  map OBRGRYMT
}

brightmap texture GRAYMETB
{
  map OBRGRYMT
}

brightmap texture GRAYMETC
{
  map OBRGRYMT
}

brightmap texture RDLITE01
{
  map OBRRDLT1
}

brightmap texture LITEBLU3
{
  map OBRLTBL3
}

//nature
brightmap texture GRNRKF
{
  map OBRGRNRK
}

brightmap texture GRNSTONE
{
  map OBRGRNST
}

// SD stuff
brightmap texture SDOM_WL2
{
  map SDMWL2BR
}

brightmap texture SDOM_WL5
{
  map SDMWL5BR
}

brightmap texture SD_GTHW1
{
  map SDGHW1BR
}

brightmap texture SD_GTLW1
{ 
  map SDGTL1BR
}

brightmap texture SD_GTLW2
{ 
  map SDGTL2BR
}

brightmap texture SD_GTLW3
{ 
  map SDGTL3BR
}

brightmap texture SD_GTLW4
{ 
  map SDGTL4BR
}

brightmap texture SD_TWDL1
{
  map SDTDL1BR
}

brightmap texture SD_TWDL2
{
  map SDTDL2BR
}

brightmap texture SD_TWDL3
{
  map SDTDL3BR
}

brightmap texture SD_TWLW1
{
  map STWLW1BR
}

brightmap texture SD_TWLW2
{
  map STWLW2BR
}

brightmap texture SD_TWLW5
{
  map STWLW5BR
}

brightmap texture SD_TWLW6
{
  map STWLW6BR
}

brightmap texture SD_TWLW8
{
  map STWLW8BR
}

brightmap texture SD_TWLWA
{
  map STWLWABR
}

brightmap texture SD_TSGW4
{
  map STGSW4BR
}

brightmap texture SD_TSGW7
{
  map STGSW7BR
}

brightmap texture SD_TSGW9
{
  map STGSW9BR
}

brightmap texture SD_TSGWA
{
  map STGSWABR
}

brightmap texture SD_TSGWB
{
  map STGSWBBR
}

brightmap texture SD_TSGWC
{
  map STGSWCBR
}

brightmap texture S_W2WAL4
{
  map SW2WBR4
}

brightmap texture SD_HCCW1
{
  map SDBRHCW1
}

brightmap texture SD_HCCW2
{
  map SDBRHCW2
}
  
brightmap texture SD_HCCW3
{
  map SDBRHCW3
}

brightmap texture SD_HCCW4
{
  map SDBRHCW4
}

brightmap texture SD_HCCW6
{
  map SDBRHCW6
}

brightmap texture SD_HCCW7
{
  map SDBRHCW7
}
  
brightmap texture SD_HCCW8
{
  map SDBRHCW8
}

brightmap texture SD_HCCW9
{
  map SDBRHCW9
}

brightmap texture SD_HCCWC
{
  map SDBRHCWC
}

brightmap texture SD_TWDW3
{
  map OBRTWTW3
}

brightmap texture SD_TWDW8
{
  map OBRTWTW8
}

brightmap texture SD_TWDW9
{
  map OBRTWTW9
}

brightmap texture SDMSRCP1
{
  map OBRMRCP1
}

brightmap texture SDMSRCP2
{
  map OBRMRCP2
}

brightmap texture SDMSRCP3
{
  map OBRMRCP3
}

brightmap texture SDTBNKW7
{
  map SDTBKBR7
}

brightmap texture SDTBNKWA
{
  map SDTBKBRA
}

brightmap texture SDTBNKWB
{
  map SDTBKBRB
}

brightmap texture SDTBNKWC
{
  map SDTBKBRC
}

brightmap texture SDTBNKWE
{
  map SDTBKBRE
}

brightmap texture SD_TSGF3
{
  map SDTSFBR3
}

brightmap texture SD_TSGF7
{
  map SDTSFBR7
}

brightmap texture SD_TSGF9
{
  map SDTSFBR9
}

brightmap texture SD_TSGFA
{
  map SDTSFBRA
}

brightmap texture SDHCCBW1
{
  map SDHCCBR1
}

brightmap texture SDHCCBW2
{
  map SDHCCBR2
}

brightmap texture SDHCCBW3
{
  map SDHCCBR3
}

brightmap texture SDHCCBW4
{
  map SDHCCBR4
}

brightmap texture SDHCCBW5
{
  map SDHCCBR5
}

brightmap texture SDHCCBW8
{
  map SDHCCBR8
}

brightmap texture SDHCCBW9
{
  map SDHCCBR9
}

brightmap texture SDHCCBWA
{
  map SDHCCBRA
}

brightmap texture SDHCCBWB
{
  map SDHCCBRB
}

brightmap texture SDHCCBWC
{
  map SDHCCBRC
}

// iStuff wall brightmaps
brightmap texture SDIPHWL2
{
  map SDIPHBR2
}

brightmap texture SDIPHWL5
{
  map SDIPHBR5
}

brightmap texture SDIPHWL7
{
  map SDIPHBR7
}

brightmap texture SDIPHWL8
{
  map SDIPHBR8
}

brightmap texture SDIPHWL9
{
  map SDIPHBR9
}

brightmap texture SDIPHWLA
{
  map SDIPHBRA
}
]]

-- aliases - when you're too lazy to write down wall and flat names in every
-- room theme

OBS_RESOURCE_PACK_TEXTURE_SET_ALIASES =
{
  __SD_GRAY_TECH_WALLS =
  {
    materials =
    {
      "SDOM_WL1", "SDOM_WL2", "SDOM_WL3", 
      "SDOM_WL4", "SDOM_WL5", "SDOM_WL6"
    }
  },

  __SD_GRAY_TECH =
  {
    materials =
    {
      "SDOM_FT1", "SDOM_FT2", "SDOM_FT3", "SDOM_FT4"
    }
  }
}
