------------------------------------------------------------------------
--  GRAMMAR RULES
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2015-2017 Andrew Apted
--  Copyright (C) 2018-2022 MsrSgtShooterPerson
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

SHAPES.OBSIDIAN =
{

ROOT_1 =
{
  prob = 50,

  structure =
  {
    "!!!!!", ".....",
    "!!!!!", ".RRR.",
    "!!!!!", ".RRR.",
    "!!!!!", ".RRR.",
    "!!!!!", ".....",
  },

  new_room =
  {
    symmetry  = { kind="mirror", x=3, y=2, dir=8 },
    symmetry2 = { kind="rotate", x=2, y=2, x2=4, y2=4 },
  },

  auxiliary =
  {
    pass = "start_closet3"
  }
},


ROOT_3 =
{
  prob = 40,

  structure =
  {
    "!!!!!!", "......",
    "!!!!!!", ".RRRR.",
    "!!!!!!", ".RRRR.",
    "!!!!!!", ".RRRR.",
    "!!!!!!", ".RRRR.",
    "!!!!!!", "......",
  },

  new_room =
  {
    symmetry  = { kind="mirror", x=3, y=2, w=2, dir=8 },
    symmetry2 = { kind="rotate", x=2, y=2, x2=5, y2=5 }
  },

  auxiliary =
  {
    pass = "start_closet4"
  }
},


ROOT_4 =
{
  prob = 20,

  structure =
  {
    "!!!!!!", "......",
    "!!!!!!", "./RR%.",
    "!!!!!!", ".RRRR.",
    "!!!!!!", ".RRRR.",
    "!!!!!!", ".%RR/.",
    "!!!!!!", "......",
  },

  diagonals =
  {
    ".R", "R.",
    ".R", "R.",
  },

  new_room =
  {
    symmetry  = { kind="mirror", x=3, y=2, w=2, dir=8 },
    symmetry2 = { kind="rotate", x=2, y=2, x2=5, y2=5 },
  },

  auxiliary =
  {
    pass = "start_closet2"
  }
},


ROOT_L1 =
{
  prob = 1,

  structure =
  {
    "!!!!!", ".RR#.",
    "!!!!!", ".RR##",
    "!!!!!", "#RRRR",
    "!!!!!", "#RRRR",
    "!!!!!", "###..",
  }
},


ROOT_T2 =
{
  prob = 25, --5,

  structure =
  {
    "!!!!!!", "......",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "#%RR/#",
    "!!!!!!", "##RR##",
  },

  diagonals = { ".R", "R." },

  new_room =
  {
    symmetry = { kind="mirror", x=3, y=1, w=2, dir=8 }
  },

  auxiliary =
  {
    pass = "start_closet2"
  }
},


ROOT_LIQUID_1A =
{
  prob = 4, --7 --5,

  structure =
  {
    "!!!!!", "/RRR%",
    "!!!!!", "R/~%R",
    "!!!!!", "R~~~R",
    "!!!!!", "R%~/R",
    "!!!!!", "%RRR/",
  },

  diagonals =
  {
    ".R", "R.",
    "R~", "~R",
    "R~", "~R",
    ".R", "R.",
  },

  new_room =
  {
    symmetry  = { kind="mirror", x=3, y=1, dir=8 },
    symmetry2 = { kind="rotate", x=2, y=2, x2=4, y2=4 }
  },

  auxiliary =
  {
    pass = "start_closet3"
  }
},


ROOT_LIQUID_1B =
{
  template = "ROOT_LIQUID_1A",

  prob = 1,

  structure =
  {
    "!!!!!", "/RRR%",
    "!!!!!", "R/~%R",
    "!!!!!", "R~C~R",
    "!!!!!", "R%~/R",
    "!!!!!", "%RRR/",
  },

  cage_mode = "fancy"
},


START_CLOSET_2x2 =
{
  pass = "start_closet2",
  prob = 50,

  structure =
  {
    "..", "TT",
    "..", "TT",
    "11", "11",
  },

  closet = { from_dir=2, usage="start" }
},


START_CLOSET_3x2 =
{
  pass = "start_closet3",
  prob = 50,

  structure =
  {
    "...", "TTT",
    "...", "TTT",
    "111", "111",
  },

  closet = { from_dir=2, usage="start" }
},


START_CLOSET_4x2 =
{
  pass = "start_closet4",
  prob = 50,

  structure =
  {
    "....", "TTTT",
    "....", "TTTT",
    "1111", "1111",
  },

  closet = { from_dir=2, usage="start" }
},


------------------------------------------


-- MSSP: Commented out these rules - these seem to be
-- from an abandoned experiment by Andrew to grow maps
-- backwards (from an exit) to provide combat space for bosses

--[[EXIT_1 =
{
  prob = 75 --60,

  structure =
  {
    "!!!!!", ".....",
    "!!!!!", ".RRR.",
    "!!!!!", ".RRR.",
    "!!!!!", ".RRR.",
    "!!!!!", ".....",
  },

  new_room =
  {
    usage = "boss",
    symmetry = { x=3, y=2, dir=8 }
  },

  auxiliary =
  {
    pass = "exit1_closet"
  },

  auxiliary2 =
  {
    pass = "exit1_area"
  }
},


EXIT1_CLOSET =
{
  pass = "exit1_closet",
  prob = 66 --50,

  structure =
  {
    "...", "TTT",
    "...", "TTT",
    "111", "111",
  },

  closet = { from_dir=2, usage="exit" }
},


EXIT1_AREA_A =
{
  pass = "exit1_area",
  prob = 95 --50,

  structure =
  {
    ".111.", "#111#",
    ".111.", "#111#",
    ".111.", "#111#",
    "x...x", "xvvvx",
    "x...x", "xAAAx",
    "x...x", "xAAAx",
    "x...x", "xAAAx",
  }

},

EXIT1_AREA_B =
{
  pass = "exit1_area",
  prob = 80 --50,

  structure =
  {
    ".111.", "A111A",
    ".111.", "A111A",
    ".111.", "A111A",
    ".....", "AvvvA",
    ".....", "AAAAA",
  }

},


EXIT1_AREA_C =
{
  pass = "exit1_area",
  prob = 65 --50,

  structure =
  {
    "...111...", "AA<111>AA",
    "...111...", "AA<111>AA",
    "...111...", "AA<111>AA",
    "xxx...xxx", "xxx###xxx",
  },

},


EXIT_2 =
{
  prob = 30,

  structure =
  {
    "!!!!!", ".###.",
    "!!!!!", ".RRR.",
    "!!!!!", ".RRR.",
    "!!!!!", ".RRR.",
    "!!!!!", ".....",
  },

  new_room =
  {
    usage = "boss"
  },

  auxiliary =
  {
    pass = "exit2_closet"
  },

  auxiliary2 =
  {
    pass = "exit2_decor"
  }
},


EXIT2_CLOSET =
{
  pass = "exit2_closet",
  prob = 50,

  structure =
  {
    "1..", "1TT",
    "1..", "1TT",
    "1..", "1TT",
  },

  closet = { from_dir=4, usage="exit" }
},


EXIT2_DECOR =
{
  pass = "exit2_decor",
  prob = 70 --50,

  structure =
  {
    "..1", "TT1",
    "..1", "TT1",
    "..1", "TT1",
  },

  closet = { from_dir=6 }
},


EXIT_3 =
{
  env  = "building",
  prob = 30 --20,

  structure =
  {
    "!!!!!", ".....",
    "!!!!!", ".....",
    "!!!!!", ".....",
    "!!!!!", ".....",
    "!!!!!", ".....",
    "!!!!!", ".RRR.",
    "!!!!!", "#RRR#",
    "!!!!!", ".RRR.",
    "!!!!!", ".....",
  },

  new_room =
  {
    usage = "boss",
    symmetry = { x=3, y=2, dir=8 }
  },

  auxiliary =
  {
    pass = "exit3_area"
  }
},


EXIT3_AREA_A =
{
  pass = "exit3_area",
  prob = 50,

  structure =
  {
    ".......", "#AAAAA#",
    ".......", "#A...A#",
    "..111..", "#A111A#",
  },

  auxiliary =
  {
    pass = "exit3_closet"
  },

  auxiliary2 =
  {
    pass = "exit3_decor"
  }
},


EXIT3_AREA_B =
{
  pass = "exit3_area",
  prob = 70 --50,

  structure =
  {
    ".......", "#/AAA%#",
    ".......", "#A/#%A#",
    "..111..", "#A111A#",
  },

  diagonals =
  {
    "#A", "A#",
    "A#", "#A",
  },

  auxiliary =
  {
    pass = "exit1_closet"
  }
},


EXIT3_CLOSET =
{
  pass = "exit3_closet",
  prob = 70 --50,

  structure =
  {
    "11111", "11111",
    "1...1", "1TTT1",
  },

  closet = { from_dir=8, usage="exit" }
},


EXIT3_DECOR =
{
  pass = "exit3_decor",
  prob = 70 --50,

  structure =
  {
    ".....", "#TTT#",
    "11111", "11111",
  },

  closet = { from_dir=2 }
}]]


------------------------------------------
------------------
-- SPROUT RULES --
------------------

-- DIRECT_1


SPROUT_DIRECT_1 =
{
  prob = 3, --3,

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "x11x", "x11x",
  },

  new_room =
  {
    conn = { x=2, y=1, w=2, dir=8 },

    symmetry = { kind="mirror", x=2, y=3, w=2, dir=8 },
    symmetry2 = { kind="mirror", x=2, y=3, w=2, dir=8 },
    symmetry3 = { kind="rotate", x=2, y=2, x2=4, y2=4 }
  }
},


SPROUT_DIRECT_1_SYMM =
{
  prob = 3,

  styles = {"symmetry"},

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "....", ".RR.",
    "....", ".RR.",
    "x11x", "x11x",
  },

  new_room =
  {
    conn = { x=2, y=1, w=2, dir=8 },

    symmetry = { kind="mirror", x=2, y=4, dir=8 },
    symmetry2 = { kind="mirror", x=2, y=4, dir=8 },
    symmetry3 = { kind="rotate", x=2, y=2, x1=3, y2=5 }
  }
},


-- DIRECT_2


SPROUT_DIRECT_2 =
{
  prob = 100,

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "x11x", "x11x",
    "x11x", "x11x",
  },

  new_room =
  {
    conn = { x=2, y=2, w=2, dir=8 },

    symmetry = { kind="mirror", x=2, y=3, w=2, dir=8 },
    symmetry2 = { kind="mirror", x=2, y=3, w=2, dir=4 },
    symmetry3 = { kind="rotate", x=2, y=3, x2=3, y2=4 }
  }
},


SPROUT_DIRECT_2_SYMM =
{
  prob = 100,

  styles = {"symmetry"},

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "....", ".RR.",
    "....", ".RR.",
    "x11x", "x11x",
    "x11x", "x11x",
  },

  new_room =
  {
    conn = { x=2, y=2, w=2, dir=8 },

    symmetry = { kind="mirror", x=2, y=5, dir=8 },
    symmetry2 = { kind="mirror", x=2, y=5, dir=4 },
    symmetry3 = { kind="rotate", x=2, y=4, x2=3, y2=6 }
  }
},


SPROUT_DIRECT_2_EMERGENCY =
{
  emergency = true,

  -- high prob to force this rule to be tried fairly early
  prob = 500,

  structure =
  {
    "..", "RR",
    "..", "RR",
    "11", "11",
  },

  new_room =
  {
    conn = { x=1, y=1, w=2, dir=8 },

    symmetry = { kind="mirror", x=1, y=2, w=2, dir=8 },
    symmetry2 = { kind="mirror", x=1, y=2, w=2, dir=4 },
    symmetry3 = { kind="rotate", x=1, y=2, x2=2, y2=3 }
  }
},


--[[SPROUT_DIRECT_THIN_EMERGENCY =
{
  emergency = true

  prob = 250,

  aversion = 65,

  env = "!cave",

  structure =
  {
    "..","RR",
    "..","RR",
    "..","11",
    "x1","x1",
  },

  new_room =
  {
    conn = { x=1, y=2, w=2, dir=8 }
  }
}]]


SPROUT_DIRECT_THROUGH_2X_LIQUID =
{
  emergency = true,

  prob = 250,

  structure =
  {
    "..","RR",
    "..","RR",
    "~~","11",
    "~~","11",
    "11","11",
  },

  new_room =
  {
    conn = { x=1, y=3, w=2, dir=8 },

    symmetry = { kind="mirror", x=1, y=5, w=2, dir=8 },
    symmetry2 = { kind="mirror", x=1, y=5, dir=4 },
    symmetry3 = { kind="rotate", x=1, y=3, x2=2, y2=5 }
  }
},


SPROUT_DIRECT_THROUGH_1X_LIQUID =
{
  emergency = true,

  prob = 400,

  structure =
  {
    "..","RR",
    "..","RR",
    "~~","11",
    "11","11",
  },

  new_room =
  {
    conn = { x=1, y=2, w=2, dir=8 },

    symmetry = { kind="mirror", x=1, y=3, w=2, dir=8 },
    symmetry2 = { kind="mirror", x=1, y=3, dir=4 },
    symmetry3 = { kind ="rotate", x=1, y=2, x2=2, y2=4},
  }
},


SPROUT_DIRECT_FROM_DIAGONAL =
{
  emergency = true,

  prob = 250,

  structure =
  {
    "xx..","xxRR",
    "xx..","xxRR",
    "xx..","xx11",
    "x...","x/11",
    "1%.x","11/x",
    "11xx","11xx",
  },

  diagonals =
  {
    ".1","1.",
    "1.","1.",
  },

  new_room =
  {
    conn = { x=3, y=4, w=2, dir=8 },

    symmetry = { kind="mirror", x=3, y=5, dir=8 },
    symmetry2 = { kind="mirror", x=3, y=5, dir=4 },
    symmetry3 = { kind="rotate", x=3, y=5, x2=4, y2=6 }
  }
},


-- DIRECT_3


SPROUT_DIRECT_3 =
{
  prob = 400,

  structure =
  {
    ".....", ".RRR.",
    ".....", ".RRR.",
    "x111x", "x111x",
  },

  new_room =
  {
    conn = { x=2, y=1, w=3, dir=8 },

    symmetry = { kind="mirror", x=3, y=2, dir=8 },
    symmetry2 = { kind="mirror", x=3, y=2, dir=4 },
    symmetry3 = { kind="rotate", x=2, y=2, x2=3, y2=4 }
  }
},


SPROUT_DIRECT_3_SYMM =
{
  prob = 400,

  styles = {"symmetry"},

  structure =
  {
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    "x111x", "x111x",
  },

  new_room =
  {
    conn = { x=2, y=1, w=3, dir=8 },

    symmetry = { kind="mirror", x=3, y=6, dir=8 },
    symmetry2 = { kind="mirror", x=2, y=6, dir=4 },
    symmetry3 = { kind="rotate", x=2, y=4, x2=4, y2=7 }
  }
},


-- DIRECT_4


SPROUT_DIRECT_4 =
{
  prob = 4000,

  structure =
  {
    "....", "RRRR",
    "....", "RRRR",
    "1111", "1111",
  },

  new_room =
  {
    conn = { x=1, y=1, w=4, dir=8 },

    symmetry = { kind="mirror", x=2, y=2, w=2, dir=8 },
    --symmetry2 = { kind="mirror", x=2, y=2, w=4, dir=4 },
    symmetry3 = { kind="rotate", x=1, y=2, x2=4, y2=3 }
  }
},


SPROUT_DIRECT_4_SYMM =
{
  prob = 4000,

  styles = {"symmetry"},

  structure =
  {
    "....", "RRRR",
    "....", "RRRR",
    "....", "RRRR",
    "....", "RRRR",
    "....", "RRRR",
    "....", "RRRR",
    "1111", "1111",
  },

  new_room =
  {
    conn = { x=1, y=1, w=4, dir=8 },

    symmetry = { kind="mirror", x=2, y=5, dir=6 },
    symmetry2 = { kind="mirror", x=2, y=5, dir=4 },
    symmetry3 = { kind="rotate", x=1, y=4, x2=4, y2=7 }
  }
},



SPROUT_CASTLE_2 =
{
  theme = "!urban",
  env = "outdoor",
  prob = 350, --200,

  structure =
  {
    "xx!!!!xx", "xxRRRRxx",
    "xx!!!!xx", "xxRRRRxx",
    "xx!!!!xx", "xxRRRRxx",
    "xx!!!!xx", "xxRRRRxx",
    "!!!!!!!!", "11%RR/11",
    "!!!!!!!!", "11111111",
    "xxx11xxx", "xxx11xxx",
  },

  diagonals = { "1R", "R1" },

  new_room =
  {
    env = "building",

    conn = { x=4, y=2, w=2, dir=8 },

    symmetry = { kind="mirror", x=4, y=5, w=4, dir=4 },
    symmetry = { kind="mirror", x=4, y=5, w=4, dir=6 },
    symmetry = { kind="rotate", x=3, y=4, x2=6, y2=7 }
  }
},


--[[SPROUT_DOUBLE_TEST =
{
  prob = 0  -- not supported yet

  structure =
  {
    "....", "RR%.",
    "....", "RRR%",
    "11..", "11RR",
    "11..", "11RR",
  },

  diagonals =
  {
    "R.", "R.",
  },

  new_room =
  {
    conn  = { x=1, y=2, w=2, dir=8 },
    conn2 = { x=2, y=2, w=2, dir=6 },

    symmetry = { x=3, y=3, dir=9 }
  }
}]]


SPROUT_SYMMETRY_3 =
{
  prob = 30,

  structure =
  {
    ".....", ".RRR.",
    ".....", ".RRR.",
    "x111x", "x111x",
  },

  new_room =
  {
    conn = { x=2, y=1, w=3, dir=8 },

    symmetry = { kind="mirror", x=3, y=2, dir=8 },
    symmetry2 = { kind="mirror", x=3, y=2, dir=4 },
    symmetry3 = { kind="rotate", x=2, y=2, x2=4, y2=3 }
  }
},


-- JOINER_2x1


SPROUT_JOINER_2x1 =
{
  prob = 350, --360,

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "x..x", "xJJx",
    "x11x", "x11x",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=2, y=3, w=2, dir=8 },
    symmetry2 = { kind="mirror", x=2, y=3, w=2, dir=4 },
    symmetry3 = { kind="rotate", x=2, y=3, x2=3, y2=4 }
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_2x1_SYMM =
{
  prob = 350,

  styles = {"symmetry"},

  structure =
  {
    "....",".RR.",
    "....",".RR.",
    "....",".RR.",
    "....",".RR.",
    "x..x","xJJx",
    "x11x","x11x",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=2, y=5, dir=6},
    symmetry2 = { kind="mirror", x=2, y=5, dir=4},
    symmetry3 = { kind="rotate", x=2, y=5, x2=3, y2=6}
  },

  joiner =
  {
    from_dir = 2
  }
},


-- JOINER_3x1


SPROUT_JOINER_3x1 =
{
  prob = 1500,

  structure =
  {
    ".....", ".RRR.",
    ".....", ".RRR.",
    "x...x", "xJJJx",
    "x111x", "x111x",
  },

  new_room =
  {
    symmetry = { x=3, y=3, dir=8 }
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_3x1_SYMM =
{
  prob = 1500,

  styles = {"symmetry"},

  structure =
  {
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    "x...x", "xJJJx",
    "x111x", "x111x",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=3, y=7, dir=6},
    symmetry2 = { kind="mirror", x=3, y=7, dir=4},
    symmetry3 = { kind="rotate", x=2, y=5, x2=4, y2=8}
  },

  joiner =
  {
    from_dir = 2
  }
},


-- JOINER_4x1


SPROUT_JOINER_4x1 =
{
  prob = 3000,

  structure =
  {
    "....", "RRRR",
    "....", "RRRR",
    "....", "JJJJ",
    "1111", "1111",
  },

  new_room =
  {
    symmetry = { x=2, y=3, w=2, dir=8 }
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_4x1_SYMM =
{
  prob = 3000,

  styles = {"symmetry"},

  structure =
  {
    "....", "RRRR",
    "....", "RRRR",
    "....", "RRRR",
    "....", "RRRR",
    "....", "RRRR",
    "....", "RRRR",
    "....", "JJJJ",
    "1111", "1111",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=2, y=7, dir=6},
    symmetry2 = { kind="mirror", x=2, y=7, dir=4},
    symmetry3 = { kind="rotate", x=1, y=5, x2=4, y2=8}
  },

  joiner =
  {
    from_dir = 2
  }
},


-- JOINER_2x2


SPROUT_JOINER_2x2 =
{
  prob = 2000, --100,

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "x..x", "xJJx",
    "x..x", "xJJx",
    "x11x", "x11x",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=2, y=4, dir=8 },
    symmetry = { kind="mirror", x=2, y=4, dir=4 },
    symmetry = { kind="rotate", x=2, y=4, x2=3, y2=5 }
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_2x2_SYMM =
{
  prob = 2000,

  styles = {"symmetry"},

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "....", ".RR.",
    "....", ".RR.",
    "x..x", "xJJx",
    "x..x", "xJJx",
    "x11x", "x11x",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=2, y=6, dir=6},
    symmetry2 = { kind="mirror", x=2, y=6, dir=4},
    symmetry3 = { kind="rotate", x=2, y=5, x2=3, y2=7}
  },

  joiner =
  {
    from_dir = 2
  }
},


-- JOINER_3x2


SPROUT_JOINER_3x2 =
{
  prob = 3000,

  structure =
  {
    ".....", ".RRR.",
    ".....", ".RRR.",
    "x...x", "xJJJx",
    "x...x", "xJJJx",
    "x111x", "x111x",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=3, y=4, dir=8 },
    symmetry2 = { kind="mirror", x=3, y=4, dir=4 },
    symmetry3 = { kind="rotate", x=2, y=4, x2=4, y2=5 }
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_3x2_SYMM =
{
  prob = 3000,

  styles = {"symmetry"},

  structure =
  {
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    ".....", ".RRR.",
    "x...x", "xJJJx",
    "x...x", "xJJJx",
    "x111x", "x111x",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=3, y=8, dir=6},
    symmetry2 = { kind="mirror", x=2, y=8, dir=4},
    symmetry3 = { kind="rotate", x=2, y=6, x2=4, y2=9}
  },

  joiner =
  {
    from_dir = 2
  }
},


-- JOINER_4x2


SPROUT_JOINER_4x2 =
{
  prob = 2500,

  structure =
  {
    "......", ".RRRR.",
    "......", ".RRRR.",
    "x....x", "xJJJJx",
    "x....x", "xJJJJx",
    "x1111x", "x1111x",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=3, y=4, dir=8 },
    --symmetry2 = { kind="mirror", x=3, y=5, dir=4 },
    symmetry3 = { kind="rotate", x=2, y=3, x2=5, y2=5 },
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_4x2_SYMM =
{
  prob = 2500,

  styles = {"symmetry"},

  structure =
  {
    "......", ".RRRR.",
    "......", ".RRRR.",
    "......", ".RRRR.",
    "......", ".RRRR.",
    "......", ".RRRR.",
    "......", ".RRRR.",
    "x....x", "xJJJJx",
    "x....x", "xJJJJx",
    "x1111x", "x1111x",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=3, y=8, dir=6},
    symmetry2 = { kind="mirror", x=3, y=8, dir=4},
    symmetry3 = { kind="rotate", x=2, y=6, x2=5, y2=9}
  },

  joiner =
  {
    from_dir = 2
  }
},


-- JOINER_2x3


SPROUT_JOINER_2x3 =
{
  prob = 800,

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "x..x", "xJJx",
    "x..x", "xJJx",
    "x..x", "xJJx",
    "x11x", "x11x",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=2, y=5, dir=8 },
    symmetry2 = { kind="mirror", x=2, y=5, dir=4 },
    symmetry3 = { kind="rotate", x=2, y=5, x2=3, y2=6 }
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_2x3_SYMM =
{
  prob = 200,

  styles = {"symmetry"},

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "....", ".RR.",
    "....", ".RR.",
    "x..x", "xJJx",
    "x..x", "xJJx",
    "x..x", "xJJx",
    "x11x", "x11x",
  },

  new_room =
  {
    symmetry = { kind="mirror", x=2, y=6, dir=6},
    symmetry2 = { kind="mirror", x=2, y=6, dir=4},
    symmetry3 = { kind="rotate", x=2, y=5, x2=3, y2=8}
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_L =
{
  prob = 120, -- 60

  structure =
  {
    "....", "####",
    "....", "RRJJ",
    "....", "RRJJ",
    "xx11", "xx11",
  },

  new_room =
  {
  },

  joiner =
  {
    shape = "L",
    from_dir = 2,
    dest_dir = 4
  }
},


SPROUT_TELEPORTER_2x2 =
{
  prob = 700,

  structure =
  {
    "..", "TT",
    "..", "TT",
    "11", "11",
    "11", "11",
  },

  teleporter = true,

  closet =
  {
    from_dir = 2
  }
},


------------------------------------------


DECORATE_CAGE_1 =
{
  prob = 4,
  skip_prob = 75,
  env  = "!cave",

  structure =
  {
    "...", "...",
    "...", ".C.",
    "x1x", "x1x",
  },

  auxiliary =
  {
    pass = "cage_grow",

    count = { 1,4 }
  }
},


DECORATE_CAGE_2 =
{
  prob = 10,
  env  = "!cave",

  structure =
  {
    "....", "....",
    "....", ".CC.",
    "x11x", "x11x",
  },

  auxiliary =
  {
    pass = "cage_grow",

    count = { 1,4 }
  }
},


AUX_CAGE_GROW1 =
{
  pass = "cage_grow",

  prob = 50,

  structure =
  {
    "C.", "CC",
    "11", "11",
  }
},


AUX_CAGE_GROW2 =
{
  pass = "cage_grow",

  prob = 50,

  structure =
  {
    "C.", "CC",
    "1.", "1C",
  }
},


AUX_CAGE_GROW3 =
{
  pass = "cage_grow",

  prob = 50, --50,

  structure =
  {
    "..", "/C",
    "C.", "CC",
    "11", "11",
  },

  diagonals =
  {
    ".C",
  }
},


AUX_CAGE_GROW4 =
{
  pass = "cage_grow",

  prob = 35,

  structure =
  {
    "C.","CC",
    "C.","CC",
    "11","11",
  }
},


AUX_CAGE_GROW5 =
{
  pass = "cage_grow",

  prob = 35,

  structure =
  {
    "C.","C%",
    "C.","CC",
    "11","11",
  },

  diagonals =
  {
    "C."
  }
},

--------------------
-- DECORATE RULES --
--------------------

DECORATE_CLOSET_2x1 =
{
  prob = 60, --40,
  prob_skew = 2,

  structure =
  {
    "..", "TT",
    "11", "11",
  },

  closet = { from_dir=2 }
},


DECORATE_CLOSET_2x2 =
{
  prob = 120, --80,
  prob_skew = 2,

  structure =
  {
    "..", "TT",
    "..", "TT",
    "11", "11",
  },

  closet = { from_dir=2 }
},


DECORATE_CLOSET_3x1 =
{
  prob = 60,
  prob_skew = 2,

  structure =
  {
    "...", "TTT",
    "111", "111",
  },

  closet = { from_dir=2 }
},


DECORATE_CLOSET_3x2 =
{
  prob = 80, --60,
--prob_skew = 4,

  structure =
  {
    "...", "TTT",
    "...", "TTT",
    "111", "111",
  },

  closet = { from_dir=2 }
},


DECORATE_CLOSET_4x2 =
{
  prob = 60,

  structure =
  {
    "....", "TTTT",
    "....", "TTTT",
    "1111", "1111",
  },

  closet = { from_dir=2 }
},


------------------------------------------
--   Landscape stuff
------------------------------------------


PARK_ROOT_3x3 =
{
  prob = 90, --50,

  structure =
  {
    "!!!", "RRR",
    "!!!", "RRR",
    "!!!", "RRR",
  }
},


PARK_GROW_1 =
{
  prob = 200, --100,

  structure =
  {
    "....", ".11.",
    "....", ".11.",
    "....", ".11.",
    "x11x", "x11x",
  }
},

PARK_GROW_2 =
{
  prob = 80, --30,

  structure =
  {
    "....", ".11.",
    "....", ".11.",
    "x11x", "x11x",
  }
},


PARK_GROW_3 =
{
  prob = 600, --500,

  structure =
  {
    ".....", ".111.",
    ".....", ".111.",
    "x111x", "x111x",
  }
},


-- MSSP: added these in order to lessen the tendency for parks
-- to be long and stringy, which feels really weird for natural outdoors
PARK_GROW_4 =
{
  prob = 1000,

  structure =
  {
    "11xx","11xx",
    "....","1111",
    "....","1111",
    "....","1111",
    "....","1111"
  }
},


PARK_GROW_5 =
{
  prob = 700,

  structure =
  {
    "11xxx","11xxx",
    ".....","11111",
    ".....","11111",
    ".....","11111",
    ".....","11111",
    ".....","11111"
  }
},


PARK_GROW_6 =
{
  prob = 600,

  structure =
  {
    "11xxxx","11xxxx",
    "......","111111",
    "......","111111",
    "......","111111",
    "......","111111",
    "......","111111",
    "......","111111"
  }
},


FILLER_1 =
{
  pass = "filler",
  prob = 40, --30,

  structure =
  {
    "1..", "1..",
    "1..", "11.",
    "111", "111",
  }
},


FILLER_2 =
{
  pass = "filler",
  prob = 75, --60,

  structure =
  {
    "1.1", "111",
    "x1x", "x1x",
  }
},


FILLER_3 =
{
  pass = "filler",
  prob = 45, --30,

  structure =
  {
    "1..1", "1111",
    "1111", "1111",
  }
},


SMOOTHER_1 =
{
  pass = "smoother",
  prob = 75, --50,

  structure =
  {
    "x.", "x.",
    "1.", "1%",
    "11", "11",
  },

  diagonals = { "1." }
},


------------------------------------------
--   Cave stuff
------------------------------------------

CAVE_ROOT_5x5 =
{
  prob = 20, --10,

  structure =
  {
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
  }
},


CAVE_ROOT_6x6 =
{
  prob = 100,

  structure =
  {
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR",
  }
},


SPROUT_DIRECT_2_cave =
{
  prob = 100,
  env = "cave",

  structure =
  {
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    "xx11x", "xx11x",
  },

  new_room =
  {
    env = "cave",

    conn = { x=3, y=1, w=2, dir=8 }
  }
},


SPROUT_DIRECT_3_cave =
{
  prob = 300,
  env = "cave", --disable direct connections for caves

  structure =
  {
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    "x111x", "x111x",
  },

  new_room =
  {
    env = "cave",

    conn = { x=2, y=1, w=3, dir=8 }
  }
},


SPROUT_JOINER_2x1_cave =
{
  prob = 500,
  env = "cave", --disable direct connections for caves

  structure =
  {
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    "xx..x", "xxJJx",
    "xx11x", "xx11x",
  },

  new_room =
  {
    env = "cave"
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_3x1_cave =
{
  prob = 2000,

  structure =
  {
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    "x...x", "xJJJx",
    "x111x", "x111x",
  },

  new_room =
  {
    env = "cave"
  },

  joiner =
  {
    from_dir = 2
  }
},


--[[ disabled for now....

SPROUT_JOINER_3x2_cave =
{
  prob = 4000,

  structure =
  {
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    "x...x", "xJJJx",
    "x...x", "xJJJx",
    "x111x", "x111x",
  },

  new_room =
  {
    env = "cave",
  },

  joiner =
  {
    from_dir = 2,
  }
},
--]]


CAVE_GROW_3x1 =
{
  prob = 75, --50,

  structure =
  {
    "...", "111",
    "111", "111",
  }
},


CAVE_GROW_3x2 =
{
  prob = 80, --50,

  structure =
  {
    "...", "111",
    "...", "111",
    "111", "111",
  }
},


CAVE_GROW_4x1 =
{
  prob = 100,

  structure =
  {
    "....", "1111",
    "1111", "1111",
  }
},


CAVE_GROW_4x2 =
{
  prob = 100,

  structure =
  {
    "....", "1111",
    "....", "1111",
    "1111", "1111",
  }
},


CAVE_GROW_5x1 =
{
  prob = 150,

  structure =
  {
    ".....", "11111",
    "11111", "11111",
  }
},


CAVE_GROW_5x2 =
{
  prob = 200, --150,

  structure =
  {
    ".....", "11111",
    ".....", "11111",
    "11111", "11111",
  }
},


------------------------------------------
--   Hallway stuff
------------------------------------------

SPROUT_narrow_hallway =
{
  prob = 2500, -- 1100 --900,
  skip_prob = 10,

  structure =
  {
    "...", ".@.",
    "...", ".H.",
    "111", "111",
  },

  new_room =
  {
    env = "hallway",

    conn = { x=2, y=1, dir=8 },

    hall_type = "narrow",

    grow_pass = "hall_1"
  }
},


HALL_1_GROW_I1 =
{
  pass = "hall_1",
  prob = 90, --50,

  structure =
  {
    "!", "@",
    "@", "H",
    "1", "1",
  }
},


HALL_1_GROW_L1 =
{
  pass = "hall_1",
  prob = 60, --50,
  prob_skew = 2,

  structure =
  {
    ".#.", ".#.",
    "!@#", "@H#",
    ".1.", ".1.",
  },

  link1_2 = { dest_dir=4 }
},


HALL_1_GROW_T1 =
{
  pass = "hall_1",
  prob = 60, --50,
  prob_skew = 2,

  structure =
  {
    ".#.", ".#.",
    "!@!", "@H@",
    ".1.", ".1.",
  },

  hallway = { keep_shape_prob=90 },

  link1_2 = { dest_dir=4 },
  link3_2 = { dest_dir=6 }
},


HALL_1_GROW_P1 =
{
  pass = "hall_1",
  prob = 30, --5,
  prob_skew = 2,

  structure =
  {
    ".!.", ".@.",
    "!@!", "@H@",
    ".1.", ".1.",
  },

  hallway = { keep_shape_prob=50 },

  link1_2 = { dest_dir=4 },
  link3_2 = { dest_dir=6 },
  link2_3 = { dest_dir=8 }
},


HALL_1_SPROUT_A =
{
  pass = "hall_1_sprout",
  prob = 120, --100,

  structure =
  {
    "....", "RRRR",
    "....", "RRRR",
    "x@xx", "xHxx",
    "x1xx", "x1xx",
  },

  new_room =
  {
    conn = { x=2, y=2, dir=8 },

    symmetry = { kind="mirror", x=2, y=3, w=2, dir=8 }
  }
},


SPROUT_wide_hallway =
{
  prob = 3200, --1800 --1500,
  skip_prob = 20,

  structure =
  {
    "..", "..",
    "..", "@@",
    "..", "HH",
    "11", "11",
  },

  new_room =
  {
    env = "hallway",

    conn = { x=1, y=1, w=2, dir=8 },

    hall_type = "wide",

    grow_pass = "hall_2"
  }
},


HALL_2_GROW_I1 =
{
  pass = "hall_2",
  prob = 55, --40,

  structure =
  {
    "..", "..",
    "..", "@@",
    "..", "HH",
    "@@", "HH",
    "11", "11",
  }
},


HALL_2_GROW_L1 =
{
  pass = "hall_2",
  prob = 35, --50,
  prob_skew = 2,

  structure =
  {
    "....", ".@HH",
    "..@@", ".@HH",
    "xx11", "xx11",
  },

  link2_2 = { dest_dir=4 }
},


HALL_2_GROW_T1 =
{
  pass = "hall_2",
  prob = 30, --25,
  prob_skew = 2,

  structure =
  {
    "......", ".@HH@.",
    "..@@..", ".@HH@.",
    "xx11xx", "xx11xx",
  },

  hallway = { keep_shape_prob=50 },

  link2_2 = { dest_dir=4 },
  link5_2 = { dest_dir=6 }
},


HALL_2_GROW_P1 =
{
  pass = "hall_2",
  prob = 10, --5,
  prob_skew = 2,

  structure =
  {
    "xx..xx", "xx..xx",
    "xx..xx", "xx@@xx",
    "......", ".@HH@.",
    "..@@..", ".@HH@.",
    "xx11xx", "xx11xx",
  },

  link2_2 = { dest_dir=4 },
  link5_2 = { dest_dir=6 },
  link3_4 = { dest_dir=8 }
},


HALL_2_SPROUT_A =
{
  pass = "hall_2_sprout",
  prob = 100,

  structure =
  {
    "....", "RRRR",
    "....", "RRRR",
    "x@@x", "xHHx",
    "x11x", "x11x",
  },

  new_room =
  {
    conn = { x=2, y=2, w=2, dir=8 },

    symmetry = { kind="mirror", x=2, y=3, w=2, dir=8 }
  }
},


HALL_2_SPROUT_B =
{
  pass = "hall_2_sprout",
  prob = 15, --10,

  structure =
  {
    "....", "RRRR",
    "....", "RRRR",
    "@@xx", "HHxx",
    "11xx", "11xx",
  },

  new_room =
  {
    conn = { x=1, y=2, w=2, dir=8 },

    -- deliberately no symmetry info
  }
},

----------------
-- GROW RULES --
----------------

GROW_2 =
{
  prob = 100, --Non-MSSP default: 100, Obsidian default: 400
  prob_skew = 2,

  base_set = true,

  structure =
  {
    "....", ".11.",
    "x11x", "x11x",
  }
},


GROW_3 =
{
  prob = 50, --Non-MSSP default: 50, Obsidian default: 250
  prob_skew = 2,

  base_set = true,

  structure =
  {
    ".....", ".111.",
    "x111x", "x111x",
  }
},


GROW_4 =
{
  prob = 50, --Non-MSSP default: 50, Obsidian default: 250
  prob_skew = 2,
  skip_prob = 25, --50,

  base_set = true,

  structure =
  {
    "....", "1111",
    ".11.", "1111",
  }
},


GROW_BLOB_1 =
{
  prob = 25, --Non-MSSP default: 25, Obsidian default: 200

  base_set = true,

  structure =
  {
    "....", "1111",
    "....", "1111",
    "x11x", "x11x",
  }
},

--7.50 stuff

GROW_DIAG_BLOB1 =
{
  prob = 45,

  base_set = true,

  structure =
  {
    "...", "AA%",
    "%..", "%AA",
    "x%.", "x%A",
    "x1.", "x1.",
  },

  diagonals =
  {
          "A.",
    "1.", "1A",
    "1.", "1A",
  }
},


GROW_DIAG_BLOB2 =
{
  prob = 65, --45,

  base_set = true,

  structure =
  {
    "...", "AA%",
    "%..", "%AA",
    "x%.", "x%A",
    "x1x", "x1x",
    "x/.", "x/A",
    "/..", "/AA",
    "...", "AA/",
  },

  diagonals =
  {
          "A.",
    "1.", "1A",
    "1.", "1A",
    "1.", "1A",
    "1.", "1A",
          "A.",
  }
},

-- End 7.50 stuff

GROW_FUNNEL_2 =
{
  prob = 25, --5,
  skip_prob = 15, --50,

  base_set = true,

  structure =
  {
    "....", "#11#",
    "....", "/11%",
    "1111", "1111",
  },

  diagonals = { "#1", "1#" }
},


GROW_CURVE_1 =
{
  prob = 75, --50,
  prob_skew = 3,
  skip_prob = 5, --25,

  base_set = true,

  structure =
  {
    "1.", "1%",
    "1.", "11",
    "1.", "11",
    "1.", "1/",
  },

  diagonals = { "1.", "1." }
},


GROW_AREA_1 =
{
  prob = 200, --40,

  base_set = true,

  structure =
  {
    "....", ".AA.",
    "x11x", "x11x",
  }
},


GROW_AREA_2 =
{
  prob = 50, --6,
  skip_prob = 30, --50,

  base_set = true,

  structure =
  {
    "...", "AAA",
    "11.", "11A",
    "11.", "11A",
  }
},


GROW_DIAG_WING =
{
  prob = 70, --40,
  prob_skew = 2,
  skip_prob = 5, --35,

  base_set = true,

  structure =
  {
    "x...", "x#AA",
    "x...", "x/AA",
    "1%..", "1%/#",
    "11xx", "11xx",
  },

  diagonals =
  {
    "#A",
    "1.", "1A", "A#",
  }
},


GROW_BIG_CAGE =
{
  prob = 8,
  skip_prob = 30,
  aversion = 10,

  base_set = true,

  structure =
  {
    "....", "1111",
    "....", "1CC1",
    "....", "1CC1",
    "....", "1111",
    "x11x", "x11x",
  },

  cage_mode = "fancy"
},


GROW_CAGEPAIR_1 =
{
  prob = 8,
  skip_prob = 30,

  base_set = true,

  structure =
  {
    "....", "AAAA",
    "....", "CAAC",
    "....", "AAAA",
    "x11x", "x11x",
  },

  cage_mode = "fancy"
},


GROW_CAGEPAIR_2 =
{
  prob = 8,
  skip_prob = 75, --30,
  aversion = 5,

  base_set = true,

  structure =
  {
    "....", "AAAA",
    "....", "CAAC",
    "....", "AAAA",
    "....", "CAAC",
    "....", "AAAA",
    "x11x", "x11x",
  },

  cage_mode = "fancy"
},


GROW_LIQUID_CAGE3 =
{
  prob = 10,
  skip_prob = 20, --33,

  structure =
  {
    "....", "/C~1",
    "....", "C/~1",
    "....", "~~/1",
    "....", "1111",
    "1111", "1111",
  },

  diagonals =
  {
    ".C",
    "C~",
    "~1",
  },

  cage_mode = "fancy"
},


GROW_STAIR_2 =
{
  prob = 10, --12,
  prob_skew = 3,
  skip_prob = 45, --35,

  base_set = true,

  structure =
  {
    "..", "AA",
    "..", "^^",
    "11", "11",
  }
},


GROW_STAIR_3 =
{
  prob = 5, --5,
  prob_skew = 3,
  skip_prob = 45, --35,

  base_set = true,

  structure =
  {
    "...", "AAA",
    "...", "^^^",
    "111", "111",
  }
},


GROW_NARROWSTAIR_1 =
{
  prob = 25, --10,
  prob_skew = 3,
  skip_prob = 7, --25,

  base_set = true,

  structure =
  {
    "...", "AAA",
    "...", "1^1",
    "111", "111",
  }
},


GROW_NARROWSTAIR_2 =
{
  prob = 20, --10,
  prob_skew = 3,
  skip_prob = 15, --70,

  z_dir = "up",

  base_set = true,

  structure =
  {
    "...", "AAA",
    "...", "1^1",
    "...", "1^1",
    "111", "111",
  }
},


GROW_CAGESTAIR_1 =
{
  prob = 8,
  skip_prob = 50,
  aversion = 5,

  base_set = true,

  structure =
  {
    "...", "AAA",
    "...", "^C^",
    "111", "111",
  },

  cage_mode = "fancy"
},


GROW_CAGESTAIR_2 =
{
  prob = 8,
  skip_prob = 70,
  aversion = 5,

  base_set = true,

  structure =
  {
    "....", "AAAA",
    "....", "^CC^",
    "1111", "1111",
  },

  cage_mode = "fancy"
},


GROW_CAGESTAIR_3 =
{
  prob = 8,
  skip_prob = 70,
  aversion = 5,

  base_set = true,

  structure =
  {
    "....", "AAAA",
    "....", "^CC^",
    "....", "^CC^",
    "1111", "1111",
  },

  cage_mode = "fancy"
},


GROW_STAIRPAIR_4 =
{
  prob = 80, --200,
  skip_prob = 40, --60,
  aversion = 3,

  base_set = true,

  structure =
  {
    ".......", "AAAAAAA",
    ".......", "^^111^^",
    ".......", "^^111^^",
    "..111..", "1111111",
  }
},

GROW_STAIRPAIR_4B =
{
  prob = 85, --120,
  skip_prob = 40, --60,
  aversion = 3,

  base_set = true,

  structure =
  {
    ".......", "AAAAAAA",
    ".......", "^^111^^",
    ".......", "^^111^^",
    ".11111.", "1111111",
  }
},


GROW_STAIRPAIR_4C =
{
  prob = 40, --50,
  skip_prob = 40, --60,

  base_set = true,

  structure =
  {
    ".......", "AAAAAAA",
    ".......", "^^~~~^^",
    ".......", "^^~~~^^",
    ".11111.", "1111111",
  }
},


GROW_STAIRPAIR_5 =
{
  prob = 15, --20,
  skip_prob = 80, --50,
  aversion = 5,

  z_dir = "up",

  base_set = true,

  structure =
  {
    ".....", "AAAAA",
    ".....", "^111A",
    ".....", "^111A",
    "11...", "1111A",
    "11...", "11>>A",
  }
},


-- FIXME : rename, as these are really L-shape new-floor rules
GROW_STAIRPAIR_5E =
{
  prob = 60, --80,
  skip_prob = 33,
  aversion = 4,

  base_set = true,

  --z_dir = "up",

  structure =
  {
    "....", "AAAA",
    "....", "^11A",
    "....", "^11A",
    "11..", "111A",
    "11..", "111A",
  }
},


GROW_STAIRPAIR_5F =
{
  prob = 25, --30,
  skip_prob = 50,
  aversion = 4,

  base_set = true,

  --z_dir = "up",

  structure =
  {
    "....", "AAAA",
    "....", "11^A",
    "....", "11^A",
    "11..", "111A",
    "11..", "111A",
  }
},


GROW_STAIRPAIR_5G =
{
  prob = 10,
  skip_prob = 50,
  aversion = 4,

  base_set = true,

  --z_dir = "up",

  structure =
  {
    "....", "AAAA",
    "....", "11^A",
    "....", "11^A",
    "11..", "11^A",
    "11..", "111A",
  }
},


GROW_STAIRPAIR_5D =
{
  prob = 20,
  skip_prob = 50,
  aversion = 4,

  base_set = true,

  --z_dir = "down",

  structure =
  {
    "...xx", "AAAxx",
    "...xx", "^AAxx",
    ".....", "^AAAA",
    "11...", "11AAA",
    "11...", "11>>A",
  }
},


GROW_STAIR_POOL2 =
{
  -- this one is higher than STAIR_POOL1,

  prob = 5, --7,
  skip_prob = 85, --75,
  aversion = 15,

  base_set = true,

  structure =
  {
    "x....", "xAAA%",
    "1....", "1/~%A",
    "1....", "1~~~A",
    "1....", "1~~/A",
    "1....", "1>>A/",
  },

  diagonals =
  {
    "A.",
    "1~", "~A",
    "~A",
    "A.",
  }
},


GROW_STAIR_SIDE2 =
{
  prob = 80,
  prob_skew = 3,
  skip_prob = 30, --30,

  base_set = true,

  --z_dir = "up",

  structure =
  {
    "...","AAA",
    "...","AAA",
    ".1x","^1x",
    ".1x","^1x",
    ".1x","11x",
  }
},


GROW_STAIR_SIDE3 =
{
  prob = 50,
  prob_skew = 3,
  skip_prob = 70, --50,
  aversion  = 7,

  base_set = true,

  structure =
  {
    "..","AA",
    "..","AA",
    ".1","^1",
    ".1","^1",
    ".1","^1",
    ".1","11",
  }
},


GROW_STAIR_HUGE =
{
  prob = 8, --8,
  skip_prob = 65, --80,
  aversion  = 15, --20,

  base_set = true,

  structure =
  {
    "x....x", "xAAAAx",
    "x....x", "xAAAAx",
    "......", "/~^^~%",
    "......", "~~^^~~",
    "......", "%~^^~/",
    "x1111x", "x1111x",
  },

  diagonals =
  {
    ".~", "~.",
    ".~", "~.",
  }
},


--[[GROW_XXX_BRIDGE1 =
{
  prob = 0,

  structure =
  {
    "x..x", "x~~x",
    "x...", "x~~A",
    "1...", "1==A",
    "x...", "x~~A",
    "x..x", "x~~x",
  }
},


test crud......

GROW_LIQUID_1 =
{
  prob = 200,

  structure =
  {
    "....", ".11.",
    "....", ".~~.",
    "x11x", "x11x",
    "x11x", "x11x",
  },

  auxiliary =
  {
    pass = "liquid_grow",

    count = { 4,8 },
  },

  xx_auxiliary2 =
  {
    pass = "liquid_newarea",

    count = { 1,3 }
  }
},


AUX_LIQUID_1 =
{
  pass = "liquid_grow",
  prob = 30 --50,

  structure =
  {
    "1.", "11",
    "~.", "~~",
    "1.", "11",
  }
},


AUX_LIQUID_2 =
{
  pass = "liquid_grow",
  prob = 30 --50,

  structure =
  {
    "...", ".11",
    "1..", "1/~",
    "~..", "~/1",
    "1..", "11.",
  },

  diagonals =
  {
    "1~", "~1",
  }
},


AUX_LIQUID_3 =
{
  pass = "liquid_grow",
  prob = 0,

  structure =
  {
    "...", "...",
    "~.~", "~~~",
  },

  diagonals =
  {
    ".~", "~.",
  }
},
--]]

-------------------------
-- GROW RULES EXPANDED --
-------------------------
-- MsrSgtShooterPerson's kool x-perimental shapes of definite kool

GROW_STAIR_TRI =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    ".....","AAAAA",
    ".....","AAAAA",
    ".....","^A^A^",
    ".....","11111",
    "11xxx","11xxx",
  }
},

GROW_STAIR_5_MIRRORED_A =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "11...","11>AA",
    "11...","11>AA",
    ".....","vvAAA",
    ".....","AAA^^",
    ".....","AA<11",
    ".....","AA<11"
  }
},

GROW_STAIR_5_MIRRORED_B =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "11....","11>>AA",
    "11....","111AAA",
    "......","v1/AA^",
    "......","vAA/1^",
    "......","AAA111",
    "......","AA<<11"
  },

  diagonals =
  {
    "1A",
    "A1"
  }
},

GROW_STAIR_ASKEW =
{
  prob = 20,
  skip_prob = 50,

  structure =
  {
    "x...","xAAA",
    "x...","xAAA",
    "x...","x^^^",
    "1...","1111",
    "1...","1111"
  }
},

GROW_STAIR_ASKEW_LONG =
{
  prob = 12,
  skip_prob = 65,

  structure =
  {
    "x......","xAAAAAA",
    "x......","xAAAAAA",
    "x......","x^^^^^^",
    "1......","1111111",
    "1......","1111111"
  }
},

GROW_STAIR_ASKEW_LONG_DIVISIONS =
{
  prob = 12,
  skip_prob = 65,

  structure =
  {
    "x......","xAAAAAA",
    "x......","xAAAAAA",
    "x......","x^^1^^1",
    "1......","1111111",
    "1......","1111111"
  }
},

-- MSSP's Greek COLONNADE sort of things. [MSSPCOLONNADE]

GROW_COLONNADE_1 =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    ".....","#111#",
    ".....","11111",
    ".....","11111",
    ".....","1#1#1",
    ".....","11111",
    ".....","1#1#1",
    ".....","11111",
    ".....","11111",
    ".....","#111#",
    "x11xx","x11xx"
  }
},

GROW_COLONNADE_1_LONG =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    ".....","#111#",
    ".....","11111",
    ".....","11111",
    ".....","1#1#1",
    ".....","1#1#1",
    ".....","1#1#1",
    ".....","11111",
    ".....","11111",
    ".....","#111#",
    "x11xx","x11xx"
  }
},

GROW_COLONNADE_1_LONG_NEW_AREA =
{
  prob = 5,
  skip_prob = 85,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1A1A1",
    ".....","1#1#1",
    ".....","1#1#1",
    ".....","1#1#1",
    ".....","1A1A1",
    ".....","11111",
    "11xxx","11xxx"
  }
},

GROW_COLONNADE_1_LIQUID =
{
  prob = 7,
  skip_prob = 80,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1#~#1",
    ".....","1~1~1",
    ".....","1#~#1",
    ".....","11111",
    ".....","11111",
    "11xxx","11xxx"
  }
},

GROW_COLONNADE_2 =
{
  prob = 10,
  skip_prob = 60,

  structure =
  {
    "1......","1111111",
    "1......","11#11#1",
    "x......","x111111",
    "x......","x1#11#1",
    "x......","x111111",
    "x......","x1#11#1",
    "x......","x111111",
  }
},

GROW_COLONNADE_2_LONG =
{
  prob = 10,
  skip_prob = 60,

  structure =
  {
    "1......","1111111",
    "1......","11####1",
    "x......","x111111",
    "x......","x1####1",
    "x......","x111111",
    "x......","x1####1",
    "x......","x111111",
  }
},

GROW_COLONNADE_2_LONG_NEW_AREA =
{
  prob = 5,
  skip_prob = 85,

  structure =
  {
    "1........","111111111",
    "1........","11A####A1",
    "x........","x11111111",
    "x........","x1A####A1",
    "x........","x11111111",
    "x........","x1A####A1",
    "x........","x11111111",
  }
},

GROW_COLONNADE_TINY =
{
  prob = 10,
  skip_prob = 60,

  structure =
  {
    "...","111",
    "...","1#1",
    "...","111",
    "...","1.1",
    "...","111",
    "11x","11x"
  }
},

GROW_COLONNADE_PARTHENON =
{
  prob = 7,
  skip_prob = 80,

  structure =
  {
    "1....","11>AA",
    "1....","11#AA",
    "x....","x1>AA",
    "x....","x1>AA",
    "x....","x1#AA",
    "x....","x1>AA",
  }
},

GROW_COLONNADE_PARTHENON_3P =
{
  prob = 7,
  skip_prob = 75,

  structure =
  {
    "1....","11>AA",
    "1....","11.AA",
    "x....","x1>AA",
    "x....","x1.AA",
    "x....","x1>AA",
    "x....","x1.AA",
    "x....","x1>AA",
  }
},

GROW_COLONNADE_PARTHENON_LAKE =
{
  prob = 15,
  prob_skew = 3,
  skip_prob = 75,

  structure =
  {
    "1.......","1111>>AA",
    "1.......","1111>>AA",
    "x.......","x1/~#~%A",
    "x.......","x1~~~~~A",
    "xx.....x","xx%~~~/x",
  },

  diagonals =
  {
    "1~","~A",
    ".~","~.",
  }
},

GROW_COLONNADE_MOAT_1X =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "1......","111>>AA",
    "1......","111~~AA",
    "x......","x11~#AA",
    "x......","x11~~AA",
    "x......","x11>>AA",
  }
},

GROW_COLONNADE_MOAT_2X =
{
  prob = 25,
  skip_prob = 80,

  structure =
  {
    "1......","111>>AA",
    "1......","111~~AA",
    "x......","x11~#AA",
    "x......","x11~~AA",
    "x......","x11>>AA",
    "x......","x11~~AA",
    "x......","x11~#AA",
    "x......","x11~~AA",
    "x......","x11>>AA",
  }
},

GROW_COLONNADE_CORNER =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "11.....","111>>A%",
    "11.....","111>>AA",
    ".......","11111AA",
    ".......","vv111#A",
    ".......","vv11/AA",
    ".......","AAA#AAA",
    ".......","%AAAAAA",
  },

  diagonals =
  {
        "A.",
      "1A",
    ".A",
  }
},

GROW_COLONNADE_CORNER_LIQUID =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "11.....","111>>A%",
    "11.....","111>>AA",
    ".......","11/~~AA",
    ".......","vv~~~#A",
    ".......","vv~~/AA",
    ".......","AAA#AAA",
    ".......","%AAAAAA",
  },

  diagonals =
  {
      "A.",
    "1~",
      "~A",
    ".A",
  }
},

GROW_COLONNADE_CORNER_SOLID =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "11.....","111>>A%",
    "11.....","111>>AA",
    ".......","11/##AA",
    ".......","vv###AA",
    ".......","vv##/AA",
    ".......","AAAAAAA",
    ".......","%AAAAAA",
  },

  diagonals =
  {
    "A.",
    "1.",
    ".A",
    ".A",
  }
},

GROW_COLONNADE_510_STAIRS_STRAIGHT =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    ".........","AAAAAAAAA",
    ".........","AAAAAAAAA",
    ".........","AA#^^^#AA",
    ".........","AAA111AAA",
    ".........","AAA111AAA",
    "xxxx11xxx","xxxx11xxx",
  }
},

GROW_COLONNADE_510_STAIRS_STRAIGHT =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    ".........","AAAAAAAAA",
    ".........","AAAAAAAAA",
    ".........","AA#^^^#AA",
    ".........","AA~111~AA",
    ".........","AA~111~AA",
    ".........","AA~111~AA",
    ".........","AA~111~AA",
    "xxx111xxx","xxx111xxx",
  }
},

GROW_COLONNADE_510_STAIRS_TRI =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "..........","AAAAAAAAAA",
    "..........","AAAAAAAAAA",
    "..........","AA#^^^^#AA",
    "..........","AA<1111>AA",
    "..........","AA<1111>AA",
    "..........","AA<1111>AA",
    "..........","AA<1111>AA",
    "xxxxx11xxx","xxxxx11xxx",
  }
},

GROW_COLONNADE_510_FANCY_CEILING_QUAD =
{
  prob = 30,
  skip_prob = 80,

  structure =
  {
    "........","111AA111",
    "........","111AA111",
    "........","AAA~~AAA",
    "........","AAA~~AAA",
    "........","111~~111",
    "........","111~~111",
    "........","AAA~~AAA",
    "........","AAA~~AAA",
    "........","11111111",
    "xxxxxx11","xxxxxx11",
  }
},

GROW_COLONNADE_510_FANCY_CEILING_OCTO =
{
  prob = 30,
  skip_prob = 80,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","AAA~~AAA",
    "........","111~~111",
    "........","AAA~~AAA",
    "........","111~~111",
    "........","AAA~~AAA",
    "........","111~~111",
    "........","AAA~~AAA",
    "........","11111111",
    "xxxxxx11","xxxxxx11",
  }
},

GROW_COLONNADE_510_FANCY_CEILING_HORSESHOE =
{
  prob = 30,
  skip_prob = 80,

  structure =
  {
    "........","AAAAAAAA",
    "........","AAAAAAAA",
    "........","AA/11%AA",
    "........","AA1~~1AA",
    "........","AA1~~1AA",
    "........","AA1~~1AA",
    "........","AA1~~1AA",
    "........","A/1~~1%A",
    "........","/11~~11%",
    "........","11111111",
    "xxxxxx11","xxxxxx11",
  },

  diagonals =
  {
    "A1","1A",
    "A1","1A",
    "A1","1A",
  }
},

GROW_COLONNADE_510_FANCY_CEILING_HORSESHOE_STAIRS =
{
  prob = 45,
  skip_prob = 80,

  structure =
  {
    "xxx..xxx","xxx11xxx",
    "........","AAA11AAA",
    "........","AAA11AAA",
    "........","AA/11%AA",
    "........","AA1~~1AA",
    "........","AA1~~1AA",
    "........","AA1~~1AA",
    "........","^^1~~1^^",
    "........","^^1~~1^^",
    "........","11111111",
    "xxxxxx11","xxxxxx11",
  },

  diagonals =
  {
    "A1","1A",
  }
},

GROW_COLONNADE_VAULT =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "........","11111111",
    "........","11#11#11",
    "........","11111111",
    "........","11#11#11",
    "........","11111111",
    "........","11#11#11",
    "........","11111111",
    "........","11#11#11",
    "........","11111111",
    "xxxxxx11","xxxxxx11",
  }
},

GROW_COLONNADE_VAULT_NEW_AREA =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "........","AA1111AA",
    "........","AA#11#AA",
    "........","AA1111AA",
    "........","AA#11#AA",
    "........","AA1111AA",
    "........","AA#11#AA",
    "........","AA1111AA",
    "........","AA#11#AA",
    "........","AA1111AA",
    "xxx11xxx","xxx11xxx",
  }
},

GROW_COLONNADE_VAULT_NEW_AREA_CROSS =
{
  prob = 30,
  skip_prob = 80,

  structure =
  {
    "xxx......xxx","xxxA1111Axxx",
    "xxx......xxx","xxxA#11#Axxx",
    "............","AAAA1111AAAA",
    "............","AA#/1111%#AA",
    "............","AAA111111AAA",
    "............","AA#%1111/#AA",
    "............","AAAA1111AAAA",
    "xxx......xxx","xxxA#11#Axxx",
    "xxx......xxx","xxxA1111Axxx",
    "xxxxx11xxxxx","xxxxx11xxxxx",
  },

  diagonals =
  {
    "A1","1A",
    "A1","1A"
  }
},

GROW_COLONNADE_VAULT_THICK_PILLARS_NEW_AREA =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "..........","AAA1111AAA",
    "..........","AA##11##AA",
    "..........","AA##11##AA",
    "..........","AAA1111AAA",
    "..........","AAA1111AAA",
    "..........","AA##11##AA",
    "..........","AA##11##AA",
    "..........","AAA1111AAA",
    "xxxx11xxxx","xxxx11xxxx",
  },

  auxiliary =
  {
    pass = "GROW_COLONNADE_VAULT_THICK_PILLARS_NEW_AREA_aux"
  }
},

GROW_COLONNADE_VAULT_THICK_PILLARS_NEW_AREA_aux =
{
  prob = 25,
  skip_prob = 50,

  pass = "GROW_COLONNADE_VAULT_THICK_PILLARS_NEW_AREA_aux",

  structure =
  {
    "xx22xx","xx22xx",
    "xx11xx","xxAAxx",
    "211112","2A11A2",
    "211112","2A11A2",
    "xx11xx","xxAAxx",
    "xx22xx","xx22xx"
  }
},

GROW_COLONNADE_VAULT_ALTERNATING =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","AA#11#AA",
    "........","AA#11#AA",
    "........","11111111",
    "........","11111111",
    "........","AA#11#AA",
    "........","AA#11#AA",
    "........","11111111",
    "xxxxxx11","xxxxxx11",
  },

  auxiliary = 
  {
    pass = "GROW_COLONNADE_VAULT_ALTERNATING_aux"
  }
},

GROW_COLONNADE_VAULT_ALTERNATING_aux =
{
  prob = 50,
  skip_prob = 50,

  pass = "GROW_COLONNADE_VAULT_ALTERNATING_aux",

  structure =
  {
    "11111111","AAAAAAAA",
    "22x11x22","22xAAx22",
    "22x11x22","22xAAx22",
    "11111111","111AA111",
    "11111111","111AA111",
    "22x11x22","22xAAx22",
    "22x11x22","22xAAx22",
    "11111111","AAAAAAAA"
  }
},

GROW_COLONNADE_VAULT_ALTERNATING_THIN =
{
  prob = 35,
  skip_prob = 75,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","AAA11AAA",
    "........","11111111",
    "........","AAA11AAA",
    "........","11111111",
    "........","AAA11AAA",
    "........","11111111",
    "xxxxxx11","xxxxxx11",
  },

  auxiliary =
  {
    pass = "GROW_COLONNADE_VAULT_ALTERNATING_THIN_aux"
  }
},

GROW_COLONNADE_VAULT_ALTERNATING_THIN_aux =
{
  prob = 50,
  skip_prob = 50,

  pass = "GROW_COLONNADE_VAULT_ALTERNATING_THIN_aux",

  structure =
  {
    "11111111","11111111",
    "22211222","222AA222",
    "11111111","AAA11AAA",
    "22211222","222AA222",
    "11111111","AAA11AAA",
    "22211222","222AA222",
    "11111111","11111111"
  }
},

GROW_COLONNADE_COLUMNS_SMALL_4x =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x.......","x1111111",
    "x.......","x1111111",
    "x.......","xAAAAAAA",
    "x.......","xA#A#A#A",
    "x.......","xAAAAAAA",
    "1.......","11111111",
    "1.......","11111111"
  }
},

GROW_COLONNADE_COLUMNS_BIG_3x =
{
  prob = 35,
  skip_prob = 75,

  structure =
  {
    "x..........","x1111111111",
    "x..........","x1111111111",
    "x..........","xAAAAAAAAAA",
    "x..........","xA##A##A##A",
    "x..........","xA##A##A##A",
    "x..........","xAAAAAAAAAA",
    "1..........","11111111111",
    "1..........","11111111111"
  }
},

GROW_COLONNADE_STRAIGHT_HALF_VAULT_SHORT =
{
  prob = 25,
  skip_prob = 50,

  structure =
  {
    "1...","11AA",
    "1...","11AA",
    "x...","x1AA",
    "x...","x1AA",
    "x...","x1AA",
    "x...","x1AA",
  }
},

GROW_COLONNADE_STRAIGHT_HALF_VAULT_LONG =
{
  prob = 30,
  skip_prob = 60,

  structure =
  {
    "1...","11AA",
    "1...","11AA",
    "x...","x1AA",
    "x...","x1AA",
    "x...","x1AA",
    "x...","x1AA",
    "x...","x1AA",
    "x...","x1AA",
  }
},

GROW_COLONNADE_STRAIGHT_HALF_VAULT_CORNER =
{
  prob = 30,
  skip_prob = 60,

  structure =
  {
    "1.....","111111",
    "1.....","11AAAA",
    "x.....","x1AAAA",
    "x.....","x1AAAA",
    "x.....","x1AAAA",
    "x.....","x1AAAA",
  }
},

GROW_COLONNADE_STRAIGHT_HALF_VAULT_CORNER_CHAMFERED =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "x..xxxx","x11xxxx",
    "1......","1111111",
    "1......","11/AAAA",
    "x......","x1AAAAA",
    "x......","x1AAAAA",
    "x......","x1AAAAA",
    "x......","x1AAAAA",
  },

  diagonals =
  {
    "1A"
  }
},

GROW_COLONNADE_STRAIGHT_VAULT =
{
  prob = 30,
  skip_prob = 35,

  structure =
  {
    "....","A11A",
    "....","A11A",
    "....","A11A",
    "....","A11A",
    "....","A11A",
    "....","A11A",
    "x11x","x11x",
  }
},

GROW_COLONNADE_STRAIGHT_VAULT_FROM_SIDE =
{
  prob = 30,
  skip_prob = 35,

  structure =
  {
    "......","111111",
    "......","AAAAAA",
    "......","AAAAAA",
    "......","111111",
    "xxxx11","xxxx11",
  }
},

GROW_COLONNADE_STRAIGHT_VAULT_LARGE =
{
  prob = 40,
  skip_prob = 35,

  structure =
  {
    "........","AA1111AA",
    "........","AA1111AA",
    "........","AA1111AA",
    "........","AA1111AA",
    "........","AA1111AA",
    "........","AA1111AA",
    "xxxx11xx","xxxx11xx",
  }
},

GROW_COLONNADE_STRAIGHT_VAULT_LARGE_LIQUID =
{
  prob = 30,
  skip_prob = 35,

  structure =
  {
    "........","AA1111AA",
    "........","AA1~~1AA",
    "........","AA1~~1AA",
    "........","AA1~~1AA",
    "........","AA1~~1AA",
    "........","AA1111AA",
    "xxxx11xx","xxxx11xx",
  }
},

GROW_COLONNADE_STRAIGHT_VAULT_LARGE_FROM_SIDE =
{
  prob = 40,
  skip_prob = 35,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","AAAAAAAA",
    "........","AAAAAAAA",
    "........","11111111",
    "........","11111111",
    "xxxxxx11","xxxxxx11",
  }
},

GROW_COLONNADE_STRAIGHT_VAULT_LARGE_FROM_SIDE_LIQUID =
{
  prob = 40,
  skip_prob = 35,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","AAAAAAAA",
    "........","A~~~~~~A",
    "........","A~~~~~~A",
    "........","AAAAAAAA",
    "........","11111111",
    "........","11111111",
    "xxxxxx11","xxxxxx11",
  }
},

GROW_COLONNADE_STRAIGHT_VAULT_BELT =
{
  prob = 50,
  skip_prob = 75,

  structure =
  {
    "x........x","xAA1111AAx",
    "..........","/AA1111AA%",
    "..........","AA/%11/%AA",
    "..........","AA##AA##AA",
    "..........","AA%/11%/AA",
    "..........","%AA1111AA/",
    "x........x","xAA1111AAx",
    "xxx11xxxxx","xxx11xxxxx",
  },

  diagonals =
  {
         ".A","A.",
    "A.",".1","1.",".A",
    "A.",".1","1.",".A",
         ".A","A.",
  }
},

GROW_COLONNADE_CLOISTER =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxxxxxxx","11xxxxxxxxx",
    "...........","11111111111",
    "...........","11111111111",
    "...........","11#1#1#1#11",
    "...........","111AAAAA111",
    "...........","11#AAAAA#11",
    "...........","111AAAAA111",
    "...........","11#AAAAA#11",
    "...........","111AAAAA111",
    "...........","11#AAAAA#11",
    "...........","11111111111",
    "...........","11111111111",
  }
},

GROW_COLONNADE_CLOISTER_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxxxxxxx","11xxxxxxxxx",
    "...........","11111111111",
    "...........","11111111111",
    "...........","11#1#1#1#11",
    "...........","111AAAAA111",
    "...........","11#A~~~A#11",
    "...........","111A~~~A111",
    "...........","11#A~~~A#11",
    "...........","111A~~~A111",
    "...........","11#AAAAA#11",
    "...........","11111111111",
    "...........","11111111111",
  }
},

-- DOOM2 - shapes vaguely resembling certain map layout pieces from Doom 2

GROW_DOOM2_ENTRY =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x...x","xAAAx",
    "x...x","xAAAx",
    ".....","#AAA#",
    ".....","1^^^1",
    ".....","11111",
    ".....","11111",
    "11xxx","11xxx"
  }
},

GROW_DOOM2_ENTRY_CAGE =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    ".....","AAAAA",
    ".....","%AAA/",
    ".....","CAAAC",
    ".....","C^^^C",
    ".....","C111C",
    ".....","/111%",
    ".....","11111",
    "11xxx","11xxx"
  },

  diagonals =
  {
    "CA","AC",
    "C1","1C"
  }
},

GROW_DOOM2_ENTRY_CAGE_DOUBLE =
{
  prob = 7,
  skip_prob = 85,

  structure =
  {
    "........","AAAAAAAA",
    "........","%AA/%AA/",
    "........","CAACCAAC",
    "........","C^^CC^^C",
    "........","C11CC11C",
    "........","/11%/11%",
    "........","11111111",
    "11xxxxxx","11xxxxxx"
  },

  diagonals =
  {
    "CA","AC","CA","AC",
    "C1","1C","C1","1C"
  }
},

GROW_DOOM2_ENTRY_CAGE_ALT =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    "x...x","xAAAx",
    ".....","#AAA#",
    ".....","CAAAC",
    ".....","#^^^#",
    ".....","C111C",
    ".....","#111#",
    ".....","11111",
    "11xxx","11xxx"
  }
},

-- 3.57-style rules

GROW_357_OPEN_ROOF_LIQUID =
{
  prob = 45,
  skip_prob = 75,

  structure =
  {
    "............","111111111111",
    "............","1#11111111#1",
    "............","11AAAAAAAA11",
    "............","11AAAAAAAA11",
    "............","11AA~~~~AA11",
    "............","11AA~~~~AA11",
    "............","11AA~~~~AA11",
    "............","11AA~~~~AA11",
    "............","11AAAAAAAA11",
    "............","11AAAAAAAA11",
    "............","1#11111111#1",
    "............","111111111111",
    "xxxxxxxxxx11","xxxxxxxxxx11",
  }
},

GROW_357_OPEN_ROOF_NEW_AREA =
{
  prob = 45,
  skip_prob = 75,

  structure =
  {
    "............","111111111111",
    "............","1#11111111#1",
    "............","11AAAAAAAA11",
    "............","11AAAAAAAA11",
    "............","11AAAAAAAA11",
    "............","11AAAAAAAA11",
    "............","11AAAAAAAA11",
    "............","11AAAAAAAA11",
    "............","11AAAAAAAA11",
    "............","11AAAAAAAA11",
    "............","1#11111111#1",
    "............","111111111111",
    "xxxxxxxxxx11","xxxxxxxxxx11",
  }
},

GROW_357_ROUND_HOLLOW_1 =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "xx11xxxxxx","xx11xxxxxx",  
    "x........x","x/111111%x",
    "..........","/11111111%",
    "..........","11/#vv#%11",
    "..........","1//AAAA%%1",
    "..........","1#AAAAAA#1",
    "..........","1AAAAAAAA1",
    "..........","1AAAAAAAA1",
    "..........","1#AAAAAA#1",
    "..........","1%%AAAA//1",
    "..........","11%#^^#/11",
    "..........","%11111111/",
    "x........x","x%111111/x",
  },

  diagonals =
  {
         ".1","1.",
         ".1","1.",
         "1.",".1",
    ".1",".A","A.","1.",
    ".1",".A","A.","1.",
         "1.",".1",
         ".1","1.",
         ".1","1.",
  }
},

GROW_357_ROUND_HOLLOW_1_LIQUID =
{
  prob = 35,
  skip_prob = 75,

  structure =
  {
    "xx11xxxxxx","xx11xxxxxx",
    "x........x","x/111111%x",
    "..........","/11111111%",
    "..........","11/#vv#%11",
    "..........","1//AAAA%%1",
    "..........","1#A/~~%A#1",
    "..........","1AA~~~~AA1",
    "..........","1AA~~~~AA1",
    "..........","1#A%~~/A#1",
    "..........","1%%AAAA//1",
    "..........","11%#^^#/11",
    "..........","%11111111/",
    "x........x","x%111111/x",
  },

  diagonals =
  {
         ".1","1.",
         ".1","1.",
         "1.",".1",
    "1.",".A","A.",".1",
         "A~","~A",
         "A~","~A",
    "1.",".A","A.",".1",
         "1.",".1",
         ".1","1.",
         ".1","1.",
  }
},

GROW_357_ROUND_HOLLOW_2 =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "xx11xxxxxx","xx11xxxxxx",
    "x........x","x/111111%x",
    "..........","/11111111%",
    "..........","11/#AA#%11",
    "..........","1//1111%%1",
    "..........","1#111111#1",
    "..........","1A111111A1",
    "..........","1A111111A1",
    "..........","1#111111#1",
    "..........","1%%1111//1",
    "..........","11%#AA#/11",
    "..........","%11111111/",
    "x........x","x%111111/x",
  },

  diagonals =
  {
         ".1","1.",
         ".1","1.",
         "1.",".1",
    "1.",".1","1.",".1",
    "1.",".1","1.",".1",
         "1.",".1",
         ".1","1.",
         ".1","1.",
  }
},

GROW_357_ROUND_HOLLOW_HALF =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "..........","1AAAAAAAA1",
    "..........","1AAAAAAAA1",
    "..........","1#AAAAAA#1",
    "..........","1%%AAAA//1",
    "..........","11%#^^#/11",
    "..........","%11111111/",
    "x........x","x%111111/x",
    "xx11xxxxxx","xx11xxxxxx",
  },

  diagonals =
  {
    "1.",".A","A.",".1",
         "1.",".1",
         ".1","1.",
         ".1","1.",
  }
},

GROW_357_ROUND_HOLLOW_HALF_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "..........","1AA~~~~AA1",
    "..........","1AA%~~/AA1",
    "..........","1#AAAAAA#1",
    "..........","1%%AAAA//1",
    "..........","11%#^^#/11",
    "..........","%11111111/",
    "x........x","x%111111/x",
    "xx11xxxxxx","xx11xxxxxx",
  },

  diagonals =
  {
         "A~","~A",
    "1.",".A","A.",".1",
         "1.",".1",
         ".1","1.",
         ".1","1.",
  }
},

GROW_357_ROUND_ARCH =
{
  prob = 35,
  skip_prob = 75,

  structure =
  { 
    "11xxxxx","11xxxxx",
    ".......","1111111",
    ".......","1/AAA%1",
    ".......","1#AAA#1",
    ".......","1%AAA/1",
    ".......","1111111",
    ".......","1111111",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  }
},

GROW_357_ROUND_ARCH_STAIRS =
{
  prob = 35,
  skip_prob = 75,

  structure =
  { 
    "11xxxxx","11xxxxx",
    ".......","1111111",
    ".......","11vvv11",
    ".......","1/AAA%1",
    ".......","1#AAA#1",
    ".......","1%AAA/1",
    ".......","11^^^11",
    ".......","1111111",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  }
},

GROW_357_ROUND_ARCH_ALT =
{
  prob = 40,
  skip_prob = 80,

  structure =
  { 
    "11xxxxxxx","11xxxxxxx",
    ".........","111111111",
    ".........","1/AAAAA%1",
    ".........","AA#AAA#AA",
    ".........","1%AAAAA/1",
    ".........","111111111",
    ".........","111111111",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  }
},

GROW_357_ROUND_ARCH_DOUBLE =
{
  prob = 30,
  skip_prob = 80,

  structure =
  { 
    "11xxxxxxxx","11xxxxxxxx",
    "..........","1111111111",
    "..........","1/AAAAAA%1",
    "..........","AA##AA##AA",
    "..........","AA##AA##AA",
    "..........","1%AAAAAA/1",
    "..........","1111111111",
    "..........","1111111111",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  }
},

GROW_357_ROUND_ARCH_ALT_STAIRS =
{
  prob = 40,
  skip_prob = 80,

  structure =
  { 
    "11xxxxxxx","11xxxxxxx",
    ".........","111111111",
    ".........","v/AAAAA%v",
    ".........","AAA#A#AAA",
    ".........","^%AAAAA/^",
    ".........","111111111",
    ".........","111111111",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  }
},

GROW_357_ROUND_ARCH_DOUBLE_STAIRS =
{
  prob = 25,
  skip_prob = 80,

  structure =
  { 
    "11xxxxxxxxxx","11xxxxxxxxxx",
    "............","111111111111",
    "............","vv/AAAAAA%vv",
    "............","AAAA#AA#AAAA",
    "............","AAAA#AA#AAAA",
    "............","^^%AAAAAA/^^",
    "............","111111111111",
    "............","111111111111",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  }
},

GROW_357_ROUND_ARCH_ALT_2 =
{
  prob = 40,
  skip_prob = 80,

  structure =
  { 
    "xx111xx","xx111xx",
    ".......","11AAA11",
    ".......","11AAA11",
    ".......","1/A#A%1",
    ".......","1AAAAA1",
    ".......","1%A#A/1",
    ".......","11AAA11",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  }
},

-- MSSP's liquid tiles. [MSSPLIQUID]

GROW_LIQUID_GUTTER_SIDE =
{
  prob = 5,
  skip_prob = 40,

  structure =
  {
    "...","~11",
    "...","~11",
    "...","111",
    "11x","11x",
  },
},

GROW_LIQUID_GUTTER_CORNER =
{
  prob = 30,
  skip_prob = 40,

  structure =
  {
    "....","~~11",
    "....","~/11",
    "x11x","x11x",
  },

  diagonals =
  {
    "~1",
  },
},

GROW_LIQUID_POOL_1X1 =
{
  prob = 5,
  prob_skew = 2,
  skip_prob = 35,

  structure =
  {
    "...","111",
    "...","111",
    "...","1~1",
    "...","111",
    "11x","11x",
  },
},

GROW_LIQUID_POOL_1X1_2 =
{
  prob = 5,
  prob_skew = 2,
  skip_prob = 35,

  structure =
  {
    "x...x","x111x",
    ".....","11111",
    ".....","1~#~1",
    ".....","11111",
    "11x..","11x11",
  },
},


GROW_LIQUID_POOL_2X2 =
{
  prob = 15,
  prob_skew = 2,
  skip_prob = 35,

  structure =
  {
    "....","1111",
    "....","1111",
    "....","1~~1",
    "....","1~~1",
    "....","1111",
    "11xx","11xx",
  },
},

GROW_LIQUID_POOL_2X2_2 =
{
  prob = 15,
  prob_skew = 2,
  skip_prob = 35,

  structure =
  {
    "..xxxx..","11xxxx11",
    "........","11111111",
    "........","1~~11~~1",
    "........","1~~11~~1",
    "........","11111111",
    "11xxxx..","11xxxx11",
  },
},

GROW_LIQUID_POOL_2X2_NEW_AREA =
{
  prob = 10,
  skip_prob = 35,

  structure =
  {
    "x....x","x1111x",
    "x....x","x1111x",
    "......","AA~~AA",
    "......","AA~~AA",
    "x....x","x1111x",
    "xxx11x","xxx11x",
  },
},

GROW_LIQUID_POOL_2X2_NEW_AREA_2 =
{
  prob = 10,
  skip_prob = 35,

  structure =
  {
    "x..xxxx..x","x11xxxx11x",
    "x........x","x11111111x",
    "..........","AA~~AA~~AA",
    "..........","AA~~AA~~AA",
    "x........x","x11111111x",
    "x11xxxx..x","x11xxxx11x",
  },
},

GROW_LIQUID_POOL_2_2x2_STAIR =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "x....x","x1111x",
    "x....x","x1111x",
    "......","~~vv~~",
    "......","~~AA~~",
    "......","~~AA~~",
    "......","~~^^~~",
    "x....x","x1111x",
    "x....x","x1111x",
    "xxx11x","xxx11x",
  }
},

GROW_LIQUID_POOL_3X1 =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "...","111",
    "...","111",
    "...","1~1",
    "...","1~1",
    "...","1~1",
    "...","111",
    "x11","x11",
  },
},

GROW_LIQUID_POOL_3X1_NEW_AREA =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "x...x","x111x",
    "x...x","x111x",
    ".....","AA~AA",
    ".....","AA~AA",
    ".....","AA~AA",
    "x...x","x111x",
    "xx11x","xx11x",
  },
},

GROW_LIQUID_POOL_3X1_NEW_AREA_ALT =
{
  prob = 35,
  skip_prob = 75,

  structure =
  {
    "...","111",
    "...","111",
    "...","v1v",
    "...","A~A",
    "...","A~A",
    "...","A~A",
    "...","^1^",
    "...","111",
    "x11","x11",
  },
},

GROW_LIQUID_POOL_3X1_TRIPLE =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    ".......","1111111",
    ".......","1111111",
    ".......","1~1~1~1",
    ".......","1~1~1~1",
    ".......","1~1~1~1",
    ".......","1111111",
    "xxxxx11","xxxxx11",
  },
},

GROW_LIQUID_POOL_3X1_TRIPLE_NEW_AREA =
{
  prob = 30,
  skip_prob = 80,

  structure =
  {
    ".......","1111111",
    ".......","1111111",
    ".......","v1v1v1v",
    ".......","A~A~A~A",
    ".......","A~A~A~A",
    ".......","A~A~A~A",
    ".......","^1^1^1^",
    ".......","1111111",
    "xxxxx11","xxxxx11",
  }
},

GROW_LIQUID_POOL_H_TRIPLE_NEW_AREA =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1v1v1",
    ".....","~A~A~",
    ".....","~A~A~",
    ".....","~AAA~",
    ".....","~A~A~",
    ".....","~A~A~",
    ".....","1^1^1",
    ".....","11111",
    "xxx11","xxx11"
  }
},

GROW_LIQUID_POOL_H_TRIPLE_THICK_NEW_AREA =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","1vv11vv1",
    "........","~AA~~AA~",
    "........","~AA~~AA~",
    "........","~AAAAAA~",
    "........","~AAAAAA~",
    "........","~AA~~AA~",
    "........","~AA~~AA~",
    "........","1^^11^^1",
    "........","11111111",
    "xxxxxx11","xxxxxx11"
  }
},

GROW_LIQUID_POOL_Z_TRIPLE_NEW_AREA =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","111v1",
    ".....","~~~A~",
    ".....","~~~A~",
    ".....","~AAA~",
    ".....","~A~~~",
    ".....","~A~~~",
    ".....","1^111",
    ".....","11111",
    "xxx11","xxx11"
  }
},

GROW_LIQUID_POOL_Z_TRIPLE_NEW_THICK_AREA =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","111vv1",
    "......","~~~AA~",
    "......","~~~AA~",
    "......","~/AAA~",
    "......","~AAA/~",
    "......","~AA~~~",
    "......","~AA~~~",
    "......","1^^111",
    "......","111111",
    "xxxx11","xxxx11"
  },

  diagonals =
  {
    "~A","A~"
  }
},

GROW_LIQUID_POOL_WIDE_COLONNADED_DOUBLE =
{
  prob = 30,
  skip_prob = 80,

  structure =
  {
    "11xxxxxxx","11xxxxxxx",
    ".........","111111111",
    ".........","111111111",
    ".........","A%1~~~1/A",
    ".........","AA%~~~/AA",
    ".........","AA#~~~#AA",
    ".........","AA/~~~%AA",
    ".........","A/1~~~1%A",
    ".........","111111111",
    ".........","111111111"
  },

  diagonals =
  {
    "A1","1A",
    "A1","1A",
    "A1","1A",
    "A1","1A"
  }
},

GROW_LIQUID_POOL_WIDE_FLOWING_CEILING =
{
  prob = 30,
  skip_prob = 80,

  structure =
  {
    "11xxxxxxx","11xxxxxxx",
    ".........","111111111",
    ".........","111111111",
    ".........","A%1~~~1/A",
    ".........","AA%~~~/AA",
    ".........","AA#~~~#AA",
    ".........","AAA~~~AAA",
    ".........","AAA~~~AAA",
    ".........","AAAAAAAAA",
    ".........","AAAAAAAAA"
  },

  diagonals =
  {
    "A1","1A",
    "A1","1A",
  }
},

GROW_LIQUID_POOL_WIDE_COLONNADED_TRIPLE =
{
  prob = 35,
  skip_prob = 80,

  structure =
  {
    "11xxxxxxxxx","11xxxxxxxxx",
    "...........","11111111111",
    "...........","11111111111",
    "...........","11~~111~~11",
    "...........","11~~111~~11",
    "...........","A%~~/A%~~/A",
    "...........","A#~~#A#~~#A",
    "...........","A/~~%A/~~%A",
    "...........","11~~111~~11",
    "...........","11~~111~~11",
    "...........","11111111111",
    "...........","11111111111"
  },

  diagonals =
  {
    "A1","1A","A1","1A",
    "A1","1A","A1","1A"
  }
},

GROW_LIQUID_POOL_DEPRESSED =
{
  prob = 20,
  skip_prob = 60,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","vv~~~~vv",
    "........","AA~~~~AA",
    "........","AA~~~~AA",
    "........","^^~~~~^^",
    "........","11111111",
    "........","11111111",
    "xxxxxx11","xxxxxx11",
  }
},

GROW_LIQUID_POOL_DEPRESSED_DIAG =
{
  prob = 15,
  skip_prob = 65,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","vv~~~~vv",
    "........","AA~~~~AA",
    "........","A/~~~~%A",
    "........","A~~~~~~A",
    "........","A%~~~~/A",
    "........","AA~~~~AA",
    "........","^^~~~~^^",
    "........","11111111",
    "........","11111111",
    "11xxxxxx","11xxxxxx",
  },

  diagonals =
  {
    "A~","~A",
    "A~","~A",
  }
},

GROW_LIQUID_PILLAR_CENTER =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1/~%1",
    ".....","1~.~1",
    ".....","1%~/1",
    ".....","11111",
    "11xxx","11xxx",
  },

  diagonals =
  {
    "1~","~1",
    "1~","~1",
  },
},

GROW_LIQUID_PILLAR_CENTER_LONG =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1/~%1",
    ".....","1~.~1",
    ".....","1~.~1",
    ".....","1~.~1",
    ".....","1%~/1",
    ".....","11111",
    "11xxx","11xxx",
  },

  diagonals =
  {
    "1~","~1",
    "1~","~1",
  },
},

GROW_LIQUID_PILLAR_CENTER_CROSS =
{
  prob = 10,
  skip_prob = 50,

  structure =
  {
    ".......","1111111",
    ".......","1111111",
    ".......","11/~%11",
    ".......","1/~.~%1",
    ".......","1~...~1",
    ".......","1%~.~/1",
    ".......","11%~/11",
    ".......","1111111",
    "11xxxxx","11xxxxx",
  },

  diagonals =
  {
    "1~","~1",
    "1~","~1",
    "1~","~1",
    "1~","~1",
  },
},

GROW_LIQUID_SIDE_POOL_THICC =
{
  prob = 15,
  skip_prob = 65,

  structure =
  {
    "x....x","x/~~%x",
    "x....x","x%~~/x",
    "1.....","111111",
    "1.....","111111",
  },

  diagonals =
  {
    ".~","~.",
    "1~","~1",
  },
},

GROW_LIQUID_SIDE_POOL_THIN =
{
  prob = 15,
  skip_prob = 65,

  structure =
  {
    "x....x","x/~~%x",
    "1.....","111111",
    "1.....","111111",
  },

  diagonals =
  {
    ".~","~.",
  },
},

GROW_LIQUID_POOL_VENT_DOUBLE =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "x.............","x1111111111111",
    "x.............","x11/~~~1~~~%11",
    "1.............","111~~~~1~~~~11",
    "1.............","11111111111111",
  },

  diagonals =
  {
    "1~","~1",
  }
},

GROW_LIQUID_POOL_VENT_QUAD =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "1.............","11111111111111",
    "1.............","111/~~~1~~~%11",
    "x.............","x11~~~~1~~~~11",
    "x.............","x1111111111111",
    "x.............","x11~~~~1~~~~11",
    "x.............","x11%~~~1~~~/11",
    "x.............","x1111111111111",
  },

  diagonals =
  {
    "1~","~1",
    "1~","~1",
  }
},

GROW_LIQUID_POOL_VENT_QUAD_STAIRS =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "1.............","1111>>AAAAAAAA",
    "1.............","111/~~~1~~~%AA",
    "x.............","x11~~~~1~~~~AA",
    "x.............","x11111111111AA",
    "x.............","x11~~~~1~~~~AA",
    "x.............","x11%~~~1~~~/AA",
    "x.............","x111>>AAAAAAAA",
  },

  diagonals =
  {
    "1~","~A",
    "1~","~A",
  }
},

GROW_LIQUID_POOL_VENT_QUAD_STAIR =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "1.............","1111>AAAAA<111",
    "1.............","111/~~~A~~~%11",
    "x.............","x11~~~~A~~~~11",
    "x.............","x11>AAAAAAA<11",
    "x.............","x11~~~~A~~~~11",
    "x.............","x11%~~~A~~~/11",
    "x.............","x111>AAAAA<111",
  },

  diagonals =
  {
    "1~","~1",
    "1~","~1",
  }
},

GROW_LIQUID_POOL_VENT_QUAD_CENTER_BRIDGE =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "1.............","11111111111111",
    "1.............","111/~~~~~~~%11",
    "x.............","x11~~/111%~~11",
    "x.............","x1111111111111",
    "x.............","x11~~%111/~~11",
    "x.............","x11%~~~~~~~/11",
    "x.............","x1111111111111",
  },

  diagonals =
  {
    "1~","~1",
    "~1","1~",
    "~1","1~",
    "1~","~1",
  }
},

GROW_LIQUID_POOL_VENT_QUAD_CENTER_BRIDGE_STAIR =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "1.............","1111>AAAAAAAAA",
    "1.............","111/~~~~~~~%AA",
    "x.............","x11~~/AAA%~~AA",
    "x.............","x11>AAAAAAAAAA",
    "x.............","x11~~%AAA/~~AA",
    "x.............","x11%~~~~~~~/AA",
    "x.............","x111>AAAAAAAAA",
  },

  diagonals =
  {
    "1~","~A",
    "~A","A~",
    "~A","A~",
    "1~","~A",
  }
},

GROW_LIQUID_FIGURE_CORRIDOR =
{
  prob = 25,
  skip_prob = 80,

  structure =
  {
    "....","1111",
    "....","1111",
    "....","~11~",
    "....","1111",
    "....","~11~",
    "....","1111",
    "x11x","x11x",
  },
},

GROW_LIQUID_FIGURE_CORRIDOR_NEW_AREA =
{
  prob = 25,
  skip_prob = 80,

  structure =
  {
    "x....x","x1111x",
    "x....x","x1111x",
    "x....x","x~11~x",
    "......","AAAAAA",
    "......","AAAAAA",
    "x....x","x~11~x",
    "x....x","x1111x",
    "xx11xx","xx11xx",
  },
},

GROW_LIQUID_SQUEEZE_CORRIDOR =
{
  prob = 5,
  skip_prob = 65,

  structure =
  {
    "...","111",
    "...","111",
    "...","%1/",
    "...","~1~",
    "...","/1%",
    "x1x","x1x",
  },

  diagonals =
  {
    "~1","1~",
    "~1","1~",
  },
},

GROW_LIQUID_SQUEEZE_GAP_CROSSING =
{
  prob = 5,
  skip_prob = 65,

  structure =
  {
    "...","111",
    "...","111",
    "...","%1/",
    "...","~~~",
    "...","/1%",
    "...","111",
    "x1x","x1x",
  },

  diagonals =
  {
    "~1","1~",
    "~1","1~",
  },
},

GROW_LIQUID_SQUEEZE_GAP_CROSSING_STAIR =
{
  prob = 4,
  skip_prob = 75,

  structure =
  {
    "...","111",
    "...","111",
    "...","1v1",
    "...","%A/",
    "...","~A~",
    "...","/A%",
    "...","1^1",
    "...","111",
    "x1x","x1x",
  },

  diagonals =
  {
    "~1","1~",
    "~1","1~",
  },
},

GROW_LIQUID_PLATFORM_FUNNEL =
{
  prob = 20,
  skip_prob = 70,

  structure =
  {
    "......","/~11~%",
    "......","~/11%~",
    "xx11xx","xx11xx",
  },

  diagonals =
  {

    ".~","~.",
    "~1","1~",
  },
},

GROW_LIQUID_PLATFORM_DIAGONAL_DOUBLE_FUNNEL =
{
  prob = 18,
  skip_prob = 80,

  structure =
  {
    "111~~%","11....",
    "111~~~","11....",
    "111%~~","......",
    "~~%111","......",
    "~~~111","......",
    "%~~111","......"
  },

  diagonals =
  {
    "~.",
    "1~",
    "~1",
    ".~"
  }
},

GROW_LIQUID_PLATFORM_DIAGONAL_DOUBLE_FUNNEL_PILLAR =
{
  prob = 18,
  skip_prob = 80,

  structure =
  {
    "111~~%","11....",
    "1111#~","11..#.",
    "11111~","......",
    "~11111","......",
    "~#1111",".#....",
    "%~~111","......"
  },

  diagonals =
  {
    "~.",
    ".~"
  }
},

GROW_LIQUID_WATERFALL_SIDES =
{
  prob = 5,
  skip_prob = 50,

  structure =
  {
    "...","AAA",
    "...","AAA",
    "...","~^~",
    "x1x","x1x",
  },
},

GROW_LIQUID_LEAP_SINGLE =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "...","111",
    "...","111",
    "...","vvv",
    "...","AAA",
    "...","%A/",
    "...","~~~",
    "...","/A%",
    "...","AAA",
    "...","^^^",
    "111","111",
  },

  diagonals =
  {
    "~A","A~",
    "~A","A~",
  },
},

GROW_LIQUID_LEAP_SINGLE_CAGE =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "...","111",
    "...","111",
    "...","vvv",
    "...","AAA",
    "...","%A/",
    "...","C~C",
    "...","/A%",
    "...","AAA",
    "...","^^^",
    "111","111",
  },

  diagonals =
  {
    "CA","AC",
    "CA","AC",
  },
},

GROW_LIQUID_U =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    ".......","11~~~11",
    ".......","11~~~11",
    ".......","11~~~11",
    ".......","11%~/11",
    ".....11","1111111",
    ".....11","1111111",
  },

  diagonals =
  {
    "1~","~1",
  },
},

GROW_LIQUID_U_ALT =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "11.....","11~~~11",
    "11.....","11~~~11",
    ".......","11~~~11",
    ".......","11%~/11",
    ".......","1111111",
    ".......","1111111",
  },

  diagonals =
  {
    "1~","~1",
  },
},

GROW_LIQUID_U_ALT_CAGE =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "11.....","11C#C11",
    "11.....","11C#C11",
    ".......","11CCC11",
    ".......","11%C/11",
    ".......","1111111",
    ".......","1111111",
  },

  diagonals =
  {
    "1C","C1",
  },
},

GROW_LIQUID_U_ALT_NEW_AREA =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "1.......","11A~~~A1",
    "1.......","11A~~~A1",
    "x.......","x1A~~~A1",
    "x.......","x1A%~/A1",
    "x.......","x1%AAA/1",
    "x.......","x1111111",
  },

  diagonals =
  {
    "1~","~1",
    "1A","A1",
  },
},

GROW_LIQUID_INTERSECTION =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "xxx...xxx","xxx111xxx",
    "x.......x","x~%111/~x",
    "x........","x%~111~/.",
    ".........","111111111",
    ".........","111111111",
    ".........","111111111",
    "x.......x","x/~111~%x",
    "x.......x","x~/111%~x",
    "xxx111xxx","xxx111xxx",
  },

  diagonals =
  {
    "~1","1~",
    "1~","~1",
    "1~","~1",
    "~1","1~",
  },
},

GROW_LIQUID_OVAL_SPLIT =
{
  prob = 25,
  skip_prob = 80,

  structure =
  {
    "xxx11xxx","xxx11xxx",
    "........","~~~11~~~",
    "........","~~/11%~~",
    "........","~/1/%1%~",
    "........","~11~~11~",
    "........","~11~~11~",
    "........","~%1%/1/~",
    "........","~~%11/~~",
    "........","~~~11~~~",
    "xxx..xxx","xxx11xxx",
    "xxx..xxx","xxx11xxx",
  },

  diagonals =
  {
         "~1","1~",
    "~1","1~","~1","1~",
    "~1","1~","~1","1~",
         "~1","1~",
  },
},

GROW_LIQUID_OVAL_SPLIT_SOLID_PILLAR =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "xxx11xxx","xxx11xxx",
    "........","~~~11~~~",
    "........","~~/11%~~",
    "........","~/1/%1%~",
    "........","~11..11~",
    "........","~11..11~",
    "........","~%1%/1/~",
    "........","~~%11/~~",
    "........","~~~11~~~",
    "xxx..xxx","xxx11xxx",
    "xxx..xxx","xxx11xxx"
  },

  diagonals =
  {
         "~1","1~",
    "~1","1.",".1","1~",
    "~1","1.",".1","1~",
         "~1","1~"
  }
},

GROW_OVAL_SPLIT_NEW_AREA =
{
  prob = 20,
  skip_prob = 85,

  structure =
  {
    "xx11xx","xx11xx",
    "xx..xx","xx11xx",
    "x....x","x/1/%x",
    "......","/1/%A%",
    "......","11..AA",
    "......","11..AA",
    "......","%1%/A/",
    "x....x","x%1%/x",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx"
  },

  diagonals =
  {
      ".1","1A","A.",
    ".1","1.",".A","A.",
    ".1","1.",".A","A.",
      ".1","1A","A."
  }
},

GROW_OVAL_SPLIT_NEW_AREA_BIG =
{
  prob = 25,
  skip_prob = 80,

  structure =
  {
    "xxx11xxx","xxx11xxx",
    "xxx..xxx","xxx11xxx",
    "xx....xx","xx/1/%xx",
    "x......x","x/1/%A%x",
    "........","/11..AA%",
    "........","111..AAA",
    "........","111..AAA",
    "........","%11..AA/",
    "x......x","x%1%/A/x",
    "xx....xx","xx%1%/xx",
    "xxx..xxx","xxx11xxx",
    "xxx..xxx","xxx11xxx"
  },

  diagonals =
  {
      ".1","1A","A.",
    ".1","1.",".A","A.",
          "1.",".A",
          "1.",".A",
    ".1","1.",".A","A.",
      ".1","1A","A."
  }
},

-- MSSP's ramps and all sorts of stuff. [RAMPS]

GROW_RAMP_ROUND =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "xx11xx","xx11xx",
    "x....x","x/11%x",
    "......","/1vv1%",
    "......","AAAAAA",
    "......","AAAAAA",
    "......","%1^^1/",
    "x....x","x%11/x"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    ".1","1.",
    ".1","1.",
  }
},

GROW_RAMP_ROUND_ALT =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "xx....x","xx/AA%x",
    "x......","x/A^^A%",
    "1......","1111111",
    "1......","1111111",
    "x......","x%AvvA/",
    "xx....x","xx%AA/x"
  },

  diagonals =
  {
    ".A","A.",
    ".A","A.",
    ".A","A.",
    ".A","A.",
  }
},

GROW_RAMP_ROUND_LIQUID_SINK =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "..........","111>AA<111",
    "..........","111>AA<111",
    "..........","11/~~~~%11",
    "..........","vv~~~~~~vv",
    "..........","AA~~~~~~AA",
    "..........","AA~~~~~~AA",
    "..........","^^~~~~~~^^",
    "..........","11%~~~~/11",
    "..........","111>AA<111",
    "..........","111>AA<111",
    "11xxxxxxxx","11xxxxxxxx"
  },

  diagonals =
  {
    "1~","~1",
    "1~","~1"
  }
},

GROW_RAMP_ROUND_LIQUID_SINK_BRIDGED =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "..........","111>AA<111",
    "..........","111>AA<111",
    "..........","11/~~~~%11",
    "..........","vv~~~~~~vv",
    "..........","AAA<11>AAA",
    "..........","AAA<11>AAA",
    "..........","^^~~~~~~^^",
    "..........","11%~~~~/11",
    "..........","111>AA<111",
    "..........","111>AA<111",
    "11xxxxxxxx","11xxxxxxxx"
  },

  diagonals =
  {
    "1~","~1",
    "1~","~1"
  }
},

GROW_RAMP_ROUND_LIQUID_SINK_SMALL =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "........","11>AA<11",
    "........","1/~%/~%1",
    "........","v~~~~~~v",
    "........","A%~~~~/A",
    "........","A/~~~~%A",
    "........","^~~~~~~^",
    "........","1%~/%~/1",
    "........","11>AA<11",
    "11xxxxxx","11xxxxxx"
  },

  diagonals =
  {
    "1~","~A","A~","~1",
         "A~","~A",
         "A~","~A",
    "1~","~A","A~","~1",
  }
},

GROW_RAMP_ROUND_LIQUID_SINK_SMALL_BRIDGED =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "........","11>AA<11",
    "........","1/~%/~%1",
    "........","v~~~~~~v",
    "........","A%~~~~/A",
    "........","AA<11>AA",
    "........","A/~~~~%A",
    "........","^~~~~~~^",
    "........","1%~/%~/1",
    "........","11>AA<11",
    "11xxxxxx","11xxxxxx"
  },

  diagonals =
  {
    "1~","~A","A~","~1",
         "A~","~A",
         "A~","~A",
    "1~","~A","A~","~1"
  }
},

GROW_RAMP_ROUND_PACMAN_E =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "xxx11xxx","xxx11xxx",
    "x......x","x/1111%x",
    "........","/111111%",
    "........","111/AAAA",
    "........","11>AAAAA",
    "........","11>AAAAA",
    "........","11111111",
    "........","11111111",
    "........","11>AAAAA",
    "........","11>AAAAA",
    "........","111%AAAA",
    "........","%111111/",
    "x......x","x%1111/x"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
      "1A",
      "1A",
    ".1","1.",
    ".1","1."
  }
},

GROW_RAMP_ROUND_PACMAN_Z =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "xxx11xxx","xxx11xxx",
    "x......x","x/1111%x",
    "........","/111111%",
    "........","111/AAAA",
    "........","11>AAAAA",
    "........","11>AAAAA",
    "........","11111111",
    "........","11111111",
    "........","AAAAA%11",
    "........","AAAAA<11",
    "........","AAAAA<11",
    "........","%111111/",
    "x......x","x%1111/x"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
      "1A",
      "A1",
    ".1","1.",
    ".1","1."
  }
},

GROW_RAMP_THIN_SINK =
{
  prob = 20,
  aversion = 5,
  skip_prob = 75,

  structure =
  {
    ".....","AAAAA",
    ".....","AAAAA",
    ".....","1%A/1",
    ".....","11^11",
    "x...x","x1^1x",
    "x111x","x111x",
  },

  diagonals =
  {
    "1A","A1",
  },
},

GROW_RAMP_THIN_SINK_LIQUID =
{
  prob = 20,
  aversion = 5,
  skip_prob = 75,

  structure =
  {
    ".....","AAAAA",
    ".....","AAAAA",
    ".....","~%A/~",
    "x...x","x~^~x",
    "x...x","x~^~x",
    "x111x","x111x",
  },

  diagonals =
  {
    "~A","A~",
  },
},

GROW_RAMP_INTERSECTION =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xxx11xxx","xxx11xxx",
    "........","/AA11AA%",
    "........","AAA11AAA",
    "........","AA^11^AA",
    "........","11111111",
    "........","11111111",
    "........","AAv11vAA",
    "........","AAA11AAA",
    "........","%AA11AA/"
  },

  diagonals =
  {
    ".A","A.",
    ".A","A."
  }
},

GROW_RAMP_INTERSECTION_QUARTERS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xxx11xxx","xxx11xxx",
    "........","/AA1111%",
    "........","AAA11111",
    "........","AA^11111",
    "........","11111111",
    "........","11111111",
    "........","11111vAA",
    "........","11111AAA",
    "........","%1111AA/"
  },

  diagonals =
  {
    ".A","1.",
    ".1","A."
  }
},

GROW_RAMP_THIN_RISE =
{
  prob = 20,
  aversion = 5,
  skip_prob = 75,

  structure =
  {
    "x...x","xAAAx",
    "x...x","xAAAx",
    "x...x","xA^Ax",
    "x...x","xA^Ax",
    ".....","AA1AA",
    ".....","A/1%A",
    ".....","11111",
    "x111x","x111x",
  },

  diagonals =
  {
    "A1","1A",
  },
},

GROW_RAMP_THIN_RISE_LIQUID =
{
  prob = 20,
  aversion = 5,
  skip_prob = 75,

  structure =
  {
    "x...x","xAAAx",
    "x...x","xAAAx",
    "x...x","xA^Ax",
    "x...x","xA^Ax",
    ".....","AA1AA",
    ".....","A/1%A",
    ".....","~/1%~",
    "x111x","x111x",
  },

  diagonals =
  {
    "A~","~A",
    "~1","1~",
  },
},

GROW_RAMP_THIN_HALF_SINK =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "...","AAA",
    "...","AAA",
    "...","AA^",
    "...","AA^",
    "...","AA1",
    "...","AA1",
    "...","A/1",
    "x11","x11",
    "x11","x11",
  },

  diagonals =
  {
    "A1",
  },
},

GROW_RAMP_THIN_HALF_SINK_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "....","AAAA",
    "....","AAAA",
    "....","AA~^",
    "....","AA~^",
    "....","AA~1",
    "....","AA~1",
    "....","A/~1",
    "....","~~/1",
    "xx11","xx11",
    "xx11","xx11",
  },

  diagonals =
  {
    "A~",
    "~1",
  },
},

GROW_RAMP_THIN_HALF_RISE =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "...","AAA",
    "...","AAA",
    "...","1%A",
    "...","11^",
    "...","11^",
    "...","111",
    "...","111",
    "x11","x11",
    "x11","x11",
  },

  diagonals =
  {
    "1A",
  },
},

GROW_RAMP_THIN_HALF_RISE_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "...","AAA",
    "...","AAA",
    "...","~%A",
    "...","1~^",
    "...","1~^",
    "...","111",
    "...","111",
    "x11","x11",
    "x11","x11",
  },

  diagonals =
  {
    "~A",
  },
},

GROW_REVERSE_FUNNEL =
{
  prob = 20,
  aversion = 3,
  skip_prob = 60,

  structure =
  {
    "x.....","x11AAA",
    "1.....","111%AA",
    "1.....","1111AA",
    "x.....","x11>AA",
    "x.....","x111AA",
    "x.....","x11/AA",
    "x.....","x11AAA",
  },

  diagonals =
  {
    "1A",
    "1A",
  },
},

GROW_REVERSE_FUNNEL_LIQUID =
{
  prob = 20,
  aversion = 3,
  skip_prob = 60,

  structure =
  {
    "x......","x11~AAA",
    "1......","111%%AA",
    "1......","1111~AA",
    "x......","x111>AA",
    "x......","x111~AA",
    "x......","x11//AA",
    "x......","x11~AAA",
  },

  diagonals =
  {
    "1~","~A",
    "1~","~A",
  },
},

GROW_REVERSE_FUNNEL_LIQUID_COMPLEX =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "x.........","x11~AAA<11",
    "1.........","111%%AA<11",
    "1.........","1111~AA%11",
    "x.........","x111>AAAAA",
    "x.........","x111>AAAAA",
    "x.........","x111~AA/11",
    "x.........","x11//AA<11",
    "x.........","x11~AAA<11"
  },

  diagonals =
  {
    "1~","~A",
    "A1",
    "A1",
    "1~","~A"
  }
},

GROW_SIDE_ON_RAMP =
{
  prob = 25,
  skip_prob = 10,

  structure =
  {
    "x..","xAA",
    "x..","xAA",
    "x..","x^^",
    "1..","111",
    "1..","11/",
  },

  diagonals =
  {
    "1.",
  },
},

GROW_SIDE_ON_RAMP_TALL =
{
  prob = 25,
  skip_prob = 10,

  structure =
  {
    "x..","xAA",
    "x..","xAA",
    "x..","x^^",
    "x..","x^^",
    "1..","111",
    "1..","11/",
  },

  diagonals =
  {
    "1.",
  },
},

GROW_SIDE_ON_RAMP_TALL_TO_JUNCTION =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "....","A%/A",
    "....","AAAA",
    "x..x","xAAx",
    "x..x","xAAx",
    "x..x","x^^x",
    "x..x","x^^x",
    "1..x","111x",
    "1..x","11/x",
  },

  diagonals =
  {
    "A.",".A",
    "1.",
  },
},

GROW_SIDE_ON_RAMP_TALL_TO_JUNCTION_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "........","AA%/%/AA",
    "........","AAA~~AAA",
    "xx....xx","xx^~~^xx",
    "xx....xx","xx^~~^xx",
    "xx....xx","xx1%/1xx",
    "xx....xx","xx1111xx",
    "1.....xx","111111xx",
    "1.....xx","11111/xx",
  },

  diagonals =
  {
    "A.",".~","~.","A.",
    "1~","~1",
    "1."
  }
},

GROW_SIDE_ON_RAMP_TALL_LIQUID =
{
  prob = 25,
  skip_prob = 25,

  structure =
  {
    "x...","x~AA",
    "x...","x~AA",
    "x...","x~^^",
    "x...","x~^^",
    "1...","1111",
    "1...","111/",
  },

  diagonals =
  {
    "1.",
  },
},

GROW_SIDE_ON_RAMP_TALL_LIQUID_TO_JUNCTION =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "......","AAAAAA",
    "......","AAAAAA",
    "x....x","x~^^~x",
    "x....x","x~^^~x",
    "1....x","1111~x",
    "1....x","111/~x",
    "x....x","x~~~/x"
  },

  diagonals =
  {
    "1~",
    "~.",
  },
},

GROW_CAUSEWAY =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "xxxx..xxx","xxxxAAxxx",
    "1........","1111AA111",
    "1........","111>AA<11",
    "x........","x111AA111",
    "x........","x111AA111",
    "x........","x11>AA<11",
    "x........","x111AA111",
    "xxxx..xxx","xxxxAAxxx"
  }
},

GROW_CAUSEWAY_WATERLOCKED_PILLARED =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","~~#AA#~~",
    "........","~~~AA~~~",
    "........","~~~AA~~~",
    "........","~~~AA~~~",
    "........","~~~AA~~~",
    "........","~~#AA#~~",
    "........","11111111",
    "........","11111111",
    "11xxxxxx","11xxxxxx"
  }
},

GROW_CAUSEWAY_WATERLOCKED_PILLARED_BRIDGE =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","~~#vv#~~",
    "........","~~~AA~~~",
    "........","~~~AA~~~",
    "........","~~~AA~~~",
    "........","~~~AA~~~",
    "........","~~#^^#~~",
    "........","11111111",
    "........","11111111",
    "11xxxxxx","11xxxxxx"
  }
},

GROW_CAUSEWAY_WATERLOCKED_PILLARED_BRIDGE_CAGED =
{
  prob = 20,
  skip_prob = 85,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","~~#vv#~~",
    "........","~~CAAC~~",
    "........","~~CAAC~~",
    "........","~~CAAC~~",
    "........","~~CAAC~~",
    "........","~~#^^#~~",
    "........","11111111",
    "........","11111111",
    "11xxxxxx","11xxxxxx"
  }
},

GROW_CAUSEWAY_WATERLOCKED_PILLARED_BRIDGE_THIN =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    ".111.","11111",
    ".....","~~1~~",
    ".....","~#1#~",
    ".....","~~1~~",
    ".....","~~1~~",
    ".....","~#1#~",
    ".....","~~1~~",
    ".....","11111"
  }
},

GROW_CAUSEWAY_WATERLOCKED_PILLARED_BRIDGE_THIN_HORSESHOE =
{
  prob = 12,
  skip_prob = 85,

  structure =
  {
    ".111......","1111##1111",
    "..........","~~1~~~~1~~",
    "..........","~#1#~~#1#~",
    "..........","~~1~~~~1~~",
    "..........","~~111111~~",
    "..........","~###~~~#~~",
    "..........","~~~~~~~~~~"
  }
},

GROW_CAUSEWAY_WATERLOCKED =
{
  prob = 35,
  skip_prob = 80,

  structure =
  {
    "11x.....xxx","11xAA~AAxxx",
    "...........","111AA~AA111",
    "...........","11>AA~AA<11",
    "...........","111AA~AA111",
    "...........","111AA~AA111",
    "...........","11>AA~AA<11",
    "...........","111AA~AA111",
    "xxx.....xxx","xxxAA~AAxxx"
  }
},

GROW_CAUSEWAY_WATERLOCKED_CROSSED_OUT =
{
  prob = 35,
  skip_prob = 80,

  structure =
  {
    "xxxx.....xxx","xxxxAA~AAxxx",
    "1...........","1111AA~AA111",
    "1...........","111>AA~AA<11",
    "x...........","x111A/~%A111",
    "x...........","x11~~~~~~~11",
    "x...........","x111A%~/A111",
    "x...........","x11>AA~AA<11",
    "x...........","x111AA~AA111",
    "xxxx.....xxx","xxxxAA~AAxxx",
  },

  diagonals =
  {
    "A~","~A",
    "A~","~A",
  }
},

GROW_CAUSEWAY_WATERLOCKED_CENTER_PILLAR =
{
  prob = 45,
  skip_prob = 80,

  structure =
  {
    "xxxx.....xxx","xxxxAA~AAxxx",
    "1...........","1111AA~AA111",
    "1...........","111>AAAAA<11",
    "x...........","x111A/#%A111",
    "x...........","x~~~A###A~~~",
    "x...........","x111A%#/A111",
    "x...........","x11>AAAAA<11",
    "x...........","x111AA~AA111",
    "xxxx.....xxx","xxxxAA~AAxxx",
  },

  diagonals =
  {
    "A.",".A",
    "A.",".A",
  }
},

GROW_CAUSEWAY_WATERBOUND =
{
  prob = 30,
  skip_prob = 80,

  structure =
  {
    "x..........","x11~~AA~~11",
    "x..........","x11~~AA~~11",
    "x..........","x11>>AA<<11",
    "x..........","x11~~AA~~11",
    "x..........","x11~~AA~~11",
    "x..........","x11>>AA<<11",
    "1..........","111~~AA~~11",
    "1..........","111~~AA~~11",
  },
},

GROW_CAUSEWAY_WATERBOUND_PILLAR_INTERRUPT =
{
  prob = 40,
  skip_prob = 80,

  structure =
  {
    "x..........","x11~~AA~~11",
    "x..........","x11~~AA~~11",
    "x..........","x11>>AA<<11",
    "x....xx....","x11~/xx%~11",
    "x....xx....","x11~%xx/~11",
    "x..........","x11>>AA<<11",
    "1..........","111~~AA~~11",
    "1..........","111~~AA~~11",
  },

  diagonals =
  {
    "~.",".~",
    "~.",".~",
  }
},

GROW_CAUSEWAY_WATERBOUND_PILLAR_INNER_LOOP =
{
  prob = 25,
  skip_prob = 80,

  structure =
  {
    "x..........","x11~~AA~~11",
    "x..........","x11~~AA~~11",
    "x..........","x11~/AA%~11",
    "x..........","x11>A..A<11",
    "x..........","x11>A..A<11",
    "x..........","x11~%AA/~11",
    "1..........","111~~AA~~11",
    "1..........","111~~AA~~11",
  },

  diagonals =
  {
    "~A","A~",
    "~A","A~",
  }
},

GROW_CAUSEWAY_WATERBOUND_PILLAR_INNER_LOOP_TEE =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "x..........","xAAAAAAAAAA",
    "x..........","xAAAAAAAAAA",
    "x..........","x11~%AA/~11",
    "x..........","x11~~AA~~11",
    "x..........","x11~/AA%~11",
    "x..........","x11>AAAA<11",
    "x..........","x11>AAAA<11",
    "x..........","x11~%AA/~11",
    "1..........","111~~AA~~11",
    "1..........","111~~AA~~11",
  },

  diagonals =
  {
    "~A","A~",
    "~A","A~",
    "~A","A~",
  }
},

GROW_CAUSEWAY_SINGLE =
{
  prob = 10,
  skip_prob = 70,

  structure =
  {
    "1.....","1111AA",
    "1.....","111>AA",
    "x.....","x111AA",
    "x.....","x111AA",
    "x.....","x11>AA",
    "x.....","x111AA",
  },
},

GROW_CAUSEWAY_SINGLE_WATERBOUND =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11~~AA",
    "......","11>>AA",
    "......","11~~AA",
    "......","11~~AA",
    "......","11>>AA",
    "......","11~~AA",
  },
},

GROW_CAUSEWAY_SINGLE_CORNER_PILLAR =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "........1","%11111111",
    "........1","111111111",
    "........x","11/#v~~~x",
    "........x","11#/AAAAx",
    "........x","11>AAAAAx",
    "........x","11~AAAAAx",
    "........x","11~AAAAAx",
    "........x","11~AAAAAx"
  },

  diagonals =
  {
    "1.",
    "1.",
    ".A"
  }
},

GROW_CAUSEWAY_SINGLE_THICC_CORNER_PILLAR =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    ".........1","%111111111",
    ".........1","1111111111",
    ".........x","11/##v~~~x",
    ".........x","11###v~~~x",
    ".........x","11##/AAAAx",
    ".........x","11>>AAAAAx",
    ".........x","11~~AAAAAx",
    ".........x","11~~AAAAAx",
    ".........x","11~~AAAAAx"
  },

  diagonals =
  {
    "1.",
    "1.",
    ".A"
  }
},

GROW_CAUSEWAY_SINGLE_WATERBOUND_OFF_RAMP =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "11xxxxxxxx","11xxxxxxxx",
    "..........","11~~AA1111",
    "..........","11>>AA<<11",
    "..........","11~~AA1111",
    "..........","11~~AA1111",
    "..........","11>>AA<<11",
    "..........","11~~AA1111",
  },
},

GROW_CAUSEWAY_SINGLE_WATERBOUND_ON_RAMP =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "11xxxxxxxx","11xxxxxxxx",
    "..........","1111AA~~11",
    "..........","11>>AA<<11",
    "..........","1111AA~~11",
    "..........","1111AA~~11",
    "..........","11>>AA<<11",
    "..........","1111AA~~11",
  },
},

GROW_CAUSEWAY_SINGLE_WATERBOUND_BEND =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxxx","11xxxxx",
    "......x","11~~AAx",
    "......x","11>>AAx",
    ".......","11~~%A%",
    ".......","11~~~AA",
    ".......","11~~~AA",
    ".......","11~~/A/",
    "......x","11>>AAx",
    "......x","11~~AAx",
  },

  diagonals =
  {
    "~A","A.",
    "~A","A.",
  }
},

GROW_PILLAR_HALF_BIB =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "11xxxxx","11xxxxx",
    ".......","1111111",
    ".......","1111111",
    ".......","vv#AA11",
    ".......","AAAAA11",
    ".......","AAAAAAA",
  }
},

GROW_PILLAR_HALF_BIB_ALT_APPROACH =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    ".......x","1111111x",
    ".......x","1111111x",
    ".......1","vv#AA111",
    ".......1","AAAAA111",
    ".......x","AAAAAAAx",
  }
},

GROW_PILLAR_BIB_DIAG =
{
  prob = 18,
  skip_prob = 80,

  structure =
  {
    "11xxxx","11xxxx",
    "......","111111",
    "......","111111",
    "......","11/%11",
    "......","vv%/AA",
    "......","AAAAAA",
    "......","AAAAAA",
  },

  diagonals =
  {
    "1.",".1",
    "A.",".A"
  }
},

GROW_PILLAR_BIB_DIAG_DOUBLED =
{
  prob = 22,
  skip_prob = 82,

  structure =
  {
    "xxxx11xxxx","xxxx11xxxx",
    "..........","1111111111",
    "..........","1111111111",
    "..........","11/%11/%11",
    "..........","AA%/vv%/AA",
    "..........","AAAAAAAAAA",
    "..........","AAAAAAAAAA",
  },

  diagonals =
  {
    "1.",".1","1.",".1",
    "A.",".A","A.",".A"
  }
},

GROW_PILLAR_BIB_DIAG_TRIPLED =
{
  prob = 25,
  skip_prob = 82,

  structure =
  {
    "xxxxxx11xxxxxx","xxxxxx11xxxxxx",
    "..............","11111111111111",
    "..............","11111111111111",
    "..............","11/%11/%11/%11",
    "..............","AA%/vv%/vv%/AA",
    "..............","AAAAAAAAAAAAAA",
    "..............","AAAAAAAAAAAAAA",
  },

  diagonals =
  {
    "1.",".1","1.",".1","1.",".1",
    "A.",".A","A.",".A","A.",".A"
  }
},

GROW_CAUSEWAY_SINGLE_SOLID_PILLAR =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11##AA",
    "......","11>>AA",
    "......","11##AA",
    "......","11##AA",
    "......","11>>AA",
    "......","11##AA",
  },
},

GROW_CAUSEWAY_SINGLE_SOLID_PILLAR_OFF_RAMP =
{
  prob = 25,
  skip_prob = 80,

  structure =
  {
    "11xxxxxxxx","11xxxxxxxx",
    "..........","11##AA1111",
    "..........","11>>AA<<11",
    "..........","11##AA1111",
    "..........","11##AA1111",
    "..........","11>>AA<<11",
    "..........","11##AA1111",
  },
},

GROW_CAUSEWAY_SINGLE_SOLID_PILLAR_ON_RAMP =
{
  prob = 25,
  skip_prob = 80,

  structure =
  {
    "11xxxxxxxx","11xxxxxxxx",
    "..........","1111AA##11",
    "..........","11>>AA<<11",
    "..........","1111AA##11",
    "..........","1111AA##11",
    "..........","11>>AA<<11",
    "..........","1111AA##11",
  },
},

GROW_CAUSEWAY_CORNER =
{
  prob = 10,
  skip_prob = 70,

  structure =
  {
    "x........","x11111111",
    "x........","x11111v11",
    "x........","x11/AAAAA",
    "x........","x11AAAAAA",
    "x........","x11AA11^1",
    "x........","x1>AA1111",
    "1........","111AA<111",
    "1.......x","111AA111x",
  },

  diagonals =
  {
    "1A",
  },
},

GROW_CAUSEWAY_CORNER_LIQUID_OUTER =
{
  prob = 8,
  skip_prob = 70,

  structure =
  {
    "x........","x11111111",
    "x........","x11/~~v~~",
    "x........","x1//AAAAA",
    "x........","x1~AAAAAA",
    "x........","x1~AA~~^~",
    "x........","x1>AA~111",
    "1........","11~AA<111",
    "1.......x","11~AA~11x",
  },

  diagonals =
  {
         "1~",
    "1~","~A",
  },
},

GROW_CAUSEWAY_CORNER_LIQUID_INNER =
{
  prob = 7,
  skip_prob = 75,

  structure =
  {
    "x............","x111111111111",
    "x............","x111111111v11",
    "x............","x11/AAAAAAAAA",
    "x............","x11AAAAAAAAAA",
    "x............","x11AA/~~~~A~~",
    "x............","x11AA~~~~~A~~",
    "x............","x11AA~~/AAAAA",
    "x............","x11AA~~AAAAAA",
    "x............","x11AA~~AA11^1",
    "x............","x1>AAAAAA1111",
    "1............","111AA~~AA<111",
    "1...........x","111AA~~AA111x",
  },

  diagonals =
  {
    "1A",
    "A~",
    "~A"
  },
},

GROW_CAUSEWAY_CORNER_SINGLE =
{
  prob = 20,
  skip_prob = 60,

  structure =
  {
    "x.......","x1111111",
    "x.......","x1111v11",
    "x.......","x11/AAAA",
    "x.......","x11AAAAA",
    "x....xxx","x1>AAxxx",
    "1....xxx","111AAxxx",
    "1....xxx","111AAxxx",
  },

  diagonals =
  {
    "1A",
  },
},

GROW_CAUSEWAY_TIP =
{
  prob = 25,
  skip_prob = 70,

  structure =
  {
    "1........","111111111",
    "1........","111111111",
    "x........","x11AAAA11",
    "x........","x11AAAA11",
    "x........","x11>AA<11",
    "x........","x11>AA<11",
    "xxx....xx","xxxAAAAxx",
    "xxx....xx","xxxAAAAxx",
  },
},

GROW_CAUSEWAY_KNIFE =
{
  prob = 10,
  skip_prob = 75,

  structure = 
  {
    "..xx","/%xx",
    "...x","AA%x",
    "....","AA1%",
    "....","AA%1",
    "....","AA/1",
    "....","AA%1",
    "....","AA/1",
    "....","AA%1",
    "....","AA/1",
    "..xx","11xx",
    "..xx","11xx",
    "..xx","11xx",
    "..xx","11xx",
    "11xx","11xx"
  },

  diagonals =
  {
    ".A","A.",
    "1.",
    "1.",
    "A1",
    "A1",
    "A1",
    "A1",
    "A1",
    "A1"
  }
},

GROW_CAUSEWAY_KNIFE_SERRATED =
{
  prob = 10,
  skip_prob = 80,

  structure = 
  {
    "..xxx","/%xxx",
    "...xx","AA%xx",
    "....x","AA1%x",
    ".....","AA%1%",
    ".....","AA/1/",
    ".....","AA%1%",
    ".....","AA/1/",
    ".....","AA%1%",
    ".....","AA/1/",
    "..xxx","11xxx",
    "..xxx","11xxx",
    "..xxx","11xxx",
    "..xxx","11xxx",
    "11xxx","11xxx"
  },

  diagonals =
  {
    ".A","A.",
    "1.",
    "1.",
    "A1","1.",
    "A1","1.",
    "A1","1.",
    "A1","1.",
    "A1","1.",
    "A1","1."
  }
},

GROW_CAUSEWAY_KNIFE_SERRATED_LIQUID =
{
  prob = 7,
  skip_prob = 80,

  structure = 
  {
    "..xxxxx","/%xxxxx",
    "...xxxx","AA%xxxx",
    "....xxx","AA1%xxx",
    ".......","AA%1%~%",
    ".......","AA/1/~/",
    ".......","AA%1%~%",
    ".......","AA/1/~/",
    ".......","AA%1%~%",
    ".......","AA/1/~/",
    "..xxxxx","11xxxxx",
    "..xxxxx","11xxxxx",
    "..xxxxx","11xxxxx",
    "..xxxxx","11xxxxx",
    "11xxxxx","11xxxxx"
  },

  diagonals =
  {
    ".A","A.",
    "1.",
    "1.",
    "A1","1~","~.",
    "A1","1~","~.",
    "A1","1~","~.",
    "A1","1~","~.",
    "A1","1~","~.",
    "A1","1~","~."
  }
},

GROW_GATED_RAMP =
{
  prob = 20,
  skip_prob = 50,

  structure =
  {
    "......","AAAAAA",
    "......","AAAAAA",
    "......","A#^^#A",
    "xx11xx","xx11xx",
  },
},

GROW_GATED_SIDE_RAMP =
{
  prob = 20,
  skip_prob = 50,

  structure =
  {
    "........","AAAAAAAA",
    "........","AAAAAAAA",
    "........","^^#AA#^^",
    "........","11111111",
    "xxx11xxx","xxx11xxx",
  },
},

--MSSP's simple bends. [BEND]

GROW_BEND =
{
  prob = 20,

  structure =
  {
    "..","1%",
    "..","11",
    "11","11",
  },

  diagonals =
  {
    "1.",
  },
},

GROW_SQUIGGLE =
{
  prob = 15,
  skip_prob = 60,

  structure =
  {
    "..xx","11xx",
    "..xx","11xx",
    "...x","%1%x",
    "x...","x%1%",
    "xx11","xx11",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
  },
},

GROW_TINY_U =
{
  prob = 13,
  skip_prob = 60,

  structure =
  {
    "......","/1111%",
    "......","111111",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    ".1","1.",
  },
},

-- Thicker on-ramps [BIGRAMPS]

GROW_STAIRED_HORSESHOE =
{
  prob = 20,
  skip_prob = 80,

  aversion = 10,

  structure =
  {
    "..........","/AAAAAAAA%",
    "..........","AAAAAAAAAA",
    "..........","AA/1111%AA",
    "..........","AA111111AA",
    "....xx....","^^11xx11^^",
    "....xx....","1111xx1111",
    "....xx....","1111xx1111",
    "xxxxxxxx11","xxxxxxxx11",
  },

  diagonals =
  {
    ".A","A.",
    "A1","1A",
  },
},

GROW_STAIRED_HORSESHOE_TIGHTER =
{
  prob = 20,
  skip_prob = 80,

  aversion = 10,

  structure =
  {
    "..........","./AAAAAA%.",
    "..........","/AAAAAAAA%",
    "..........","AA/1^^1%AA",
    "..........","AA111111AA",
    "..........","AA111111AA",
    "xxxx11xxxx","xxxx11xxxx",
  },

  diagonals =
  {
    ".A","A.",
    ".A","A.",
    "A1","1A",
  },
},

GROW_STAIRED_T =
{
  prob = 25,
  skip_prob = 50,

  aversion = 10,

  structure =
  {
    "........","AAAAAAAA",
    "........","AAAAAAAA",
    "........","11%AA/11",
    "........","111AA111",
    "........","111^^111",
    "........","11111111",
    "xxxxxx11","xxxxxx11",
  },

  diagonals =
  {
    "1A","A1",
  },
},

GROW_STAIRED_L =
{
  prob = 40,
  skip_prob = 50,

  aversion = 5,

  structure =
  {
    ".....","AAAAA",
    ".....","AAAAA",
    ".....","11%AA",
    ".....","111AA",
    "x....","x11^^",
    "x....","x11^^",
    ".....","11111",
    ".....","11111",
    "11xxx","11xxx",
  },

  diagonals =
  {
    "1A",
  },
},

-- MSSP's squeezed corridors. [SQUEEZE]


GROW_SQUEEZE_STRAIGHT_NEW_AREA =
{
  prob = 15,
  skip_prob = 85,

  structure =
  {
    "...","AAA",
    "...","AAA",
    "x.x","x1x",
    "x.x","x1x",
    "x.x","x1x",
    "x1x","x1x",
  },
},

GROW_SQUEEZE_CURVE_NEW_AREA =
{
  prob = 10,
  skip_prob = 70,

  structure =
  {
    "xxx..","xxxAA",
    ".....","111AA",
    ".xx..","1xxAA",
    ".xxxx","1xxxx",
    "1xxxx","1xxxx",
  },
},

GROW_SQUEEZE_STAIRCASE =
{
  prob = 7,
  skip_prob = 70,

  structure =
  {
    "..","AA",
    "..","AA",
    "x.","x^",
    "x1","x1",
  },
},

GROW_SQUEEZE_EVEN_MORE_STAIRCASE =
{
  prob = 7,
  skip_prob = 76,

  structure =
  {
    "..","AA",
    "..","AA",
    "x.","x^",
    "x.","x^",
    "x.","x^",
    "x1","x1",
  },
},

GROW_SQUEEZE_LIQUID_ONE_SIDE =
{
  prob = 6,
  skip_prob = 70,

  structure =
  {
    "..x","AAx",
    "..x","AAx",
    "...","^~~",
    "...","^~~",
    "1xx","1xx",
  },
},

GROW_SQUEEZE_LIQUID_BOTH_SIDES =
{
  prob = 6,
  skip_prob = 65,

  structure =
  {
    "x...x","xAAAx",
    "x...x","xAAAx",
    ".....","~~^~~",
    ".....","~~^~~",
    "xx1xx","xx1xx",
  },
},

GROW_SQUEEZE_CURVE_LIQUID_SIDE =
{
  prob = 5,
  skip_prob = 60,

  structure =
  {
    "x...","x/AA",
    "....","/AAA",
    "....","A/~~",
    "....","^~~~",
    "1xxx","1xxx",
  },

  diagonals =
  {
    ".A",
    ".A",
    "A~",
  },
},

GROW_SQUEEZE_DRAIN =
{
  prob = 3,
  skip_prob = 75,

  structure =
  {
    "...","111",
    "...","111",
    "...","~1~",
    "...","~1~",
    "...","~1~",
    "x1x","x1x",
  },
},

GROW_SQUEEZE_DRAIN_CURVE =
{
  prob = 8,
  skip_prob = 60,

  structure =
  {
    ".......","/~~~~11",
    ".......","~/11111",
    ".......","~1/~~11",
    "....xxx","~1~/xxx",
    "...xxxx","~1~xxxx",
    "x1xxxxx","x1xxxxx",
  },

  diagonals =
  {
    ".~",
    "~1",
    "1~",
    "~.",
  },
},

GROW_SQUEEZE_DRAIN_RING =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    ".......","/~~~~11",
    ".......","~/11111",
    ".......","~1/~~1~",
    ".......","~1~~/1~",
    ".......","11111/~",
    "1......","11~~~~/",
  },

  diagonals =
  {
    ".~",
    "~1",
         "1~",
              "~1",
                   "1~",
                   "~.",
  },
},

GROW_SQUEEZE_DRAIN_RING_WHOLE =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "xxxx..xxxx","xxxx11xxxx",
    "..........","/~~~11~~~%",
    "..........","~/111111%~",
    "..........","~1/~~~~%1~",
    "..........","~1~~~~~~1~",
    "..........","~1%~~~~/1~",
    "..........","~%111111/~",
    "..........","%~~~11~~~/",
    "xxxx11xxxx","xxxx11xxxx"
  },

  diagonals =
  {
    ".~","~.",
    "~1","1~",
    "1~","~1",
    "1~","~1",
    "~1","1~",
    ".~","~."
  },
},

-- some more other cages

GROW_CAGE_BETWEEN_PILLAR =
{
  prob = 10,
  skip_prob = 70,

  aversion = 10,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1#C#1",
    ".....","11111",
    "x111x","x111x",
  },

  cage_mode = "fancy",
},

GROW_CAGE_AROUND_PILLAR =
{
  prob = 25,
  skip_prob = 65,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1CCC1",
    ".....","1C#C1",
    ".....","1CCC1",
    ".....","11111",
    "x111x","x111x",
  },

  cage_mode = "fancy",
},

GROW_CAGE_AROUND_PILLAR_ALTERNATING =
{
  prob = 25,
  skip_prob = 65,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","11C11",
    ".....","1C#C1",
    ".....","11C11",
    ".....","11111",
    "x111x","x111x",
  },

  cage_mode = "fancy",
},

GROW_CAGE_AROUND_PILLAR_DIAGONAL =
{
  prob = 25,
  skip_prob = 65,

  structure =
  {
    "x....","x/111",
    ".....","/1111",
    ".....","1/CC1",
    ".....","1C#C1",
    ".....","1CC/1",
    ".....","1111/",
    "111.x","111/x",
  },

  cage_mode = "fancy",

  diagonals =
  {
    ".1",
    ".1",
    "1C",
    "C1",
    "1.",
    "1."
  }
},

GROW_CAGE_Z =
{
  prob = 10,
  skip_prob = 70,

  aversion = 5,

  structure =
  {
    "....","1111",
    "....","1111",
    "....","11CC",
    "....","1111",
    "....","CC11",
    "....","1111",
    "x11x","x11x",
  },

  cage_mode = "fancy",
},

GROW_CAGE_SIMPLE_CORNER =
{
  prob = 10,
  skip_prob = 70,

  structure =
  {
    "....","/C11",
    "..11","C111",
  },

  diagonals =
  {
    ".C",
  },

  cage_mode = "fancy"
},

GROW_CAGE_SIMPLE_DOUBLE_CORNER =
{
  prob = 10,
  skip_prob = 70,

  structure =
  {
    "......","/C11C%",
    "......","C1111C",
    "......","111111",
    "......","111111",
    "xx11xx","xx11xx",
  },

  diagonals =
  {
    ".C","C.",
  },

  cage_mode = "fancy"
},

GROW_CAGE_SIMPLE_QUAD_CORNER =
{
  prob = 10,
  skip_prob = 70,

  structure =
  {
    "......","/C11C%",
    "......","C1111C",
    "......","111111",
    "......","111111",
    "......","C1111C",
    "......","%C11C/",
    "xx11xx","xx11xx",
  },

  diagonals =
  {
    ".C","C.",
    ".C","C.",
  },

  cage_mode = "fancy"
},

GROW_CAGE_DOOM_MAP01 =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","1C11C1",
    "......","111111",
    "......","111111",
    "......","1C11C1",
    "......","111111",
    "11xxxx","11xxxx",
  }
},

GROW_CAGE_DOOM_MAP01_LIQUID =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","1C~~C1",
    "......","1~~~~1",
    "......","1~~~~1",
    "......","1C~~C1",
    "......","111111",
    "11xxxx","11xxxx",
  }
},

GROW_CAGE_DOOM_MAP01_PILLARED =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","1C11C1",
    "......","1#11#1",
    "......","111111",
    "......","1#11#1",
    "......","1C11C1",
    "......","111111",
    "11xxxx","11xxxx",
  }
},

GROW_CAGE_DOOM_MAP01_PILLARED_LIQUID =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","1C~~C1",
    "......","1#~~#1",
    "......","1~~~~1",
    "......","1#~~#1",
    "......","1C~~C1",
    "......","111111",
    "11xxxx","11xxxx",
  }
},

GROW_CAGE_ON_LIQUID_CANAL_SIDE =
{
  prob = 10,

  structure =
  {
    "x....","x~CC~",
    "1....","11111",
    "1....","11111",
    "x....","x~CC~",
  },
},

GROW_CAGE_ROUND_ARENA =
{
  prob = 15,
  skip_prob = 80,

  aversion = 4,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1/C%1",
    ".....","1CCC1",
    ".....","1%C/1",
    ".....","11111",
    "11xxx","11xxx",
  },

  diagonals =
  {
    "1C","C1",
    "1C","C1",
  },
},

GROW_CAGE_SIDEWAYS =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "11xxxx","11xxxx",
    "......","111111",
    "......","111111",
    "......","CCC#11",
    "......","111111",
    "......","111111",
  },
},

GROW_CAGE_SIDEWAYS_STAIR =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "11xxxx","11xxxx",
    "......","111111",
    "......","111111",
    "......","CCC#vv",
    "......","AAAAAA",
    "......","AAAAAA",
  },
},

GROW_CAGE_SIDEWAYS_BOTH_SIDES =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    "11xxxxxx","11xxxxxx",
    "........","11111111",
    "........","11#11#11",
    "........","11C11C11",
    "........","11C11C11",
    "........","11C11C11",
  },
},

GROW_CAGE_SPIRAL =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    "x.....","xCCCC%",
    "1.....","1111%C",
    "1.....","11111C",
    "xx....","xx#vvC",
    "......","AAAAAC",
    "......","AAAA/C",
    "x.....","xCCCC/",
  },

  diagonals =
  {
        "C.",
    "1C",
    "AC",
        "C.",
  },
},

GROW_CAGE_ROUND_RAFTERS_ONE_SIDE =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "xx11","xx11",
    "....","/C11",
    "....","C/11",
    "....","1111",
    "....","1111",
  },

  diagonals =
  {
    ".C",
    "C1",
  },
},

GROW_CAGE_JAGGED =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    "11xx","11xx",
    "....","11/C",
    "....","11%C",
    "....","111C",
    "....","11/C",
    "....","11%C",
  },

  diagonals =
  {
    "1C",
    "1C",
    "1C",
    "1C"
  }
},

GROW_CAGE_JAGGED_DOUBLE =
{
  prob = 8,
  skip_prob = 85,

  structure =
  {
    "xx11xx","xx11xx",
    "......","C%11/C",
    "......","C/11%C",
    "......","C1111C",
    "......","C%11/C",
    "......","C/11%C"
  },

  diagonals =
  {
    "C1","1C",
    "C1","1C",
    "C1","1C",
    "C1","1C"
  }
},

GROW_CAGE_JAGGED_STAIRS =
{
  prob = 10,
  skip_prob = 85,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11>>AA",
    "......","11/C%A",
    "......","11%C/A",
    "......","111CAA",
    "......","11/C%A",
    "......","11%C/A",
    "......","11>>AA"
  },

  diagonals =
  {
    "1C","CA",
    "1C","CA",
    "1C","CA",
    "1C","CA"
  }
},

-- MSSP's elevated catwalks. [CATWALK]

GROW_CATWALK_BIFUNNEL_SINK =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "xx...xx","xx111xx",
    "xx...xx","xx111xx",
    ".......","AA%1/AA",
    ".......","AA<1>AA",
    ".......","AA/1%AA",
    "x.....x","x11111x",
    "xx111xx","xx111xx",
  },

  diagonals =
  {
    "A1","1A",
    "A1","1A",
  },
},

GROW_CATWALK_BIFUNNEL_RISE =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xx...xx","xx111xx",
    "xx...xx","xx111xx",
    ".......","AA%v/AA",
    ".......","AAAAAAA",
    ".......","AA/^%AA",
    "x.....x","x11111x",
    "xx111xx","xx111xx",
  },

  diagonals =
  {
    "A1","1A",
    "A1","1A",
  },
},

GROW_CATWALK_BIFUNNEL_SINK_TALL =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "xx...xx","xx111xx",
    "xx...xx","xx111xx",
    ".......","AA%1/AA",
    ".......","A<<1>>A",
    ".......","AA/1%AA",
    "xx...xx","xx111xx",
    "xx111xx","xx111xx",
  },

  diagonals =
  {
    "A1","1A",
    "A1","1A",
  },
},

GROW_CATWALK_BIFUNNEL_RISE_TALL =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "xx.....xx","xx11111xx",
    "xx.....xx","xx11v11xx",
    ".........","AA%1v1/AA",
    ".........","AAAAAAAAA",
    ".........","AA/1^1%AA",
    "xx.....xx","xx11^11xx",
    "xx.....xx","xx11111xx",
    "xxx111xxx","xxx111xxx",
  },

  diagonals =
  {
    "A1","1A",
    "A1","1A",
  },
},

GROW_CATWALK_SIDESTAIRS =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    "x.....xx","x11111xx",
    "x.....xx","x11111xx",
    "........","AA<<1/AA",
    "........","AAAAAAAA",
    "........","AA<<1%AA",
    "xxxx11xx","xxxx11xx",
  },

  diagonals =
  {
    "1A","1A",
  },
},

GROW_CATWALK_U =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "xx.....xx","xx/111%xx",
    "x.......x","x/11111%x",
    ".........","/11/A%11%",
    ".........","11/AAA%11",
    ".........","11AA#AA11",
    "xxxx.....","xxxx#^^11",
    "xxxx.....","xxxx#^^11",
    "xxxxx111x","xxxxx111x",
  },

  diagonals =
  {
         ".1","1.",
         ".1","1.",
    ".1","1A","A1","1.",
         "1A","A1",
  },
},

-- MSSP's wide diagonals. [DIAGONALS]

GROW_DIAGONAL_L =
{
  prob = 20,
  skip_prob = 50,

  structure =
  {
    "xx....","xx/111",
    "x.....","x/1111",
    "......","/11111",
    "....xx","111/xx",
    "...xxx","111xxx",
    "x11xxx","x11xxx",
  },

  diagonals =
  {
    ".1",
    ".1",
    ".1",
    "1.",
  },
},

GROW_DIAGONAL_L_CATWALK =
{
  prob = 20,
  skip_prob = 50,

  structure =
  {
    "xx.....","xx/A<11",
    "x......","x/AA<11",
    ".......","/AA/111",
    ".......","AA/1111",
    ".....xx","^^11/xx",
    "....xxx","1111xxx",
    "....xxx","1111xxx",
    "xx11xxx","xx11xxx",
  },

  diagonals =
  {
        ".A",
      ".A",
    ".A","A1",
       "A1",
    "1.",
  },
},

GROW_DIAGONAL_L_CATWALK_CONTINUE =
{
  prob = 20,
  skip_prob = 50,

  structure =
  {
    "xx.....","xx/AAAA",
    "x......","x/AAAAA",
    ".......","/AA/111",
    ".......","AA/1111",
    ".....xx","^^11/xx",
    "....xxx","1111xxx",
    "....xxx","1111xxx",
    "xx11xxx","xx11xxx",
  },

  diagonals =
  {
        ".A",
      ".A",
    ".A","A1",
      "A1",
    "1.",
  },
},

GROW_DIAGONAL_S =
{
  prob = 15,
  skip_prob = 65,

  structure =
  {
    "xxx...","xxx111",
    "xxx...","xxx111",
    "xx....","xx/111",
    "x.....","x/111/",
    ".....x","/111/x",
    "....xx","111/xx",
    "...xxx","111xxx",
    "...xxx","111xxx",
    "x11xxx","x11xxx",
  },

  diagonals =
  {
    ".1",
    ".1","1.",
    ".1","1.",
         "1.",
  },
},

GROW_DIAGONAL_SIDE_BLOB =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "....x","AAAAx",
    "....x","AAAAx",
    ".....","%AA/1",
    "x....","x%/11",
    "xx11x","xx11x",
  },

  diagonals =
  {
    ".A","A1",
    ".A","A1",
  },
},

GROW_DIAGONAL_SIDE_BLOB_ALT =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "x..xxx","xAAxxx",
    "x..xxx","xAAxxx",
    "x...xx","xAA%xx",
    "x....x","xAAA%x",
    "x.....","x%AA/1",
    "xx....","xx%/11",
    "xxx.11","xxx111",
  },

  diagonals =
  {
    "A.",
    "A.",
    ".A","A1",
    ".A","A1",
  },
},

GROW_DIAGONAL_SIDE_BLOB_ALT_2 =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "...xxx","111xxx",
    "....xx","11/%xx",
    "x....x","x/AA%x",
    "x.....","x%AA/1",
    "xx....","xx%/11",
    "xxx.11","xxx111",
  },

  diagonals =
  {
    "1A","A.",
    "1A","A.",
    ".A","A1",
    ".A","A1",
  },
},

GROW_DIAGONAL_SIDE_BLOB_ALT_L =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    ".....x","111/%x",
    "......","11/AA%",
    "xx....","xx%AA/",
    "xxx...","xxx%/1",
    "xxxx..","xxxx11",
    "xxxx11","xxxx11",
  },

  diagonals =
  {
    "1A","A.",
    "1A","A.",
    ".A","A1",
    ".A","A1",
  },
},

GROW_DIAGONAL_SIDE_BLOB_ALT_PILLARED =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "....xxxx","1111xxxx",
    "....xxxx","1111xxxx",
    ".....xxx","11#A%xxx",
    "......xx","11AAA%xx",
    "xx......","xx%AAA11",
    "xxx.....","xxx%A#11",
    "xxxx....","xxxx1111",
    "xxxx..11","xxxx1111",
  },

  diagonals =
  {
    "A.",
    "A.",
    ".A",
    ".A",
  },
},

-- MSSP's water canals. [CANALS]

GROW_LIQUID_CANAL_STRAIGHT =
{
  prob = 60,

  group = "canal",

  structure =
  {
    "~.","~~",
    "~.","~~",
    "1.","11",
    "1.","11",
    "~.","~~",
    "~.","~~",
  },
},

GROW_LIQUID_CANAL_CROSSING =
{
  prob = 40,

  group = "canal",

  engine = "zdoom",

  structure =
  {
    "~...","~~~~",
    "~...","~~~~",
    "1...","1A11",
    "1...","1A11",
    "~...","~~~~",
    "~...","~~~~",
  },
},


GROW_LIQUID_CANAL_STRAIGHT_AREA_TRANSITION =
{
  prob = 30,

  group = "canal",

  structure =
  {
    "~..","~~~",
    "~..","~~~",
    "1..","1AA",
    "1..","1AA",
    "~..","~~~",
    "~..","~~~",
  },
},

GROW_LIQUID_CANAL_STRAIGHT_STAIRCASE =
{
  prob = 40,

  group = "canal",

  structure =
  {
    "~...","~~~~",
    "~...","~~~~",
    "1...","1>AA",
    "1...","1>AA",
    "~...","~~~~",
    "~...","~~~~",
  },
},

GROW_LIQUID_CANAL_STRAIGHT_BULGE =
{
  prob = 40,

  group = "canal",

  structure =
  {
    "~.....","~~11~~",
    "~.....","~/11%~",
    "1.....","11111A",
    "1.....","11111A",
    "~.....","~%11/~",
    "~.....","~~11~~",
  },

  diagonals =
  {
    "~1","1~",
    "~1","1~",
  },
},

GROW_LIQUID_CANAL_CURVE =
{
  prob = 60,

  group = "canal",

  structure =
  {
    "~.....","~~~~~%",
    "~.....","~~~~~~",
    "1.....","111%~~",
    "1.....","1111~~",
    "~.....","~%11~~",
    "~.....","~~11~~",
  },

  diagonals =
  {
    "~.",
    "1~",
    "~1",
  },
},

GROW_LIQUID_CANAL_ENTRY_B =
{
  prob = 50,

  group = "canal",

  group_pos = "entry",

  structure =
  {
    "x..","x~~",
    "x..","x~~",
    "1..","111",
    "1..","111",
    "x..","x~~",
    "x..","x~~",
  },

  diagonals =
  {
    ".~",
    ".~",
  },
},

GROW_LIQUID_CANAL_OUT_ALT =
{
  prob = 10,

  structure =
  {
    "~..","~AA",
    "1..","1AA",
    "1..","1AA",
    "~..","~AA",
  },
},

-- [SINGLE_CANAL : SCANAL]

GROW_LIQUID_SCANAL_ENTRY =
{
  prob = 20,

  group = "single_canal",

  structure =
  {
    "1..","111",
    "1..","111",
    "x..","x~~",
    "x..","x~~",
  },
},

GROW_LIQUID_SCANAL_ENTRY_FORWARD =
{
  prob = 20,

  group = "single_canal",

  structure =
  {
    "1....","111~~",
    "1....","111~~",
  },
},

GROW_LIQUID_SCANAL_STRAIGHT =
{

  prob = 60,

  group = "single_canal",

  structure =
  {
    "1.","11",
    "1.","11",
    "~.","~~",
    "~.","~~",
  },
},

GROW_LIQUID_SCANAL_STRAIGHT_CROSSING =
{
  prob = 30,

  engine = "zdoom",

  group = "single_canal",

  structure =
  {
    "1.....","11~111",
    "1.....","1/~%11",
    "~.....","~~~~~~",
    "~.....","~~~~~~",
  },

  diagonals =
  {
    "1~","~1",
  },
},

GROW_LIQUID_SCANAL_STAIR =
{
  prob = 40,

  group = "single_canal",

  structure =
  {
    "1...","1>AA",
    "1...","1>AA",
    "~...","~~~~",
    "~...","~~~~",
  },
},

GROW_LIQUID_SCANAL_OUTER_BEND =
{
  prob = 30,

  group = "single_canal",

  structure =
  {
    "1...","111%",
    "1...","1111",
    "~...","~~11",
    "~...","~~11",
  },

  diagonals =
  {
    "1.",
  },

},

GROW_LIQUID_SCANAL_INNER_BEND =
{
  prob = 30,

  group = "single_canal",

  structure =
  {
    "1...","11~~",
    "1...","11~~",
    "~...","~~~~",
    "~...","~~~/",
  },

  diagonals =
  {
    "~.",
  },
},

GROW_LIQUID_SCANAL_T_JUNCTION =
{
  prob = 20,

  group = "single_canal",

  structure =
  {
    "1.....","111111",
    "1.....","111111",
    "~.....","~%11/~",
    "~.....","~~11~~",
  },

  diagonals =
  {
    "~1","1~",
  },
},

-- [UNGROUPED CANALS]

GROW_CANAL_DOUBLE_UNG =
{
  prob = 25,

  structure =
  {
    "11..","1111",
    "11..","1111",
    "..xx","~~xx",
    "..xx","~~xx",
  },
},

GROW_CANAL_DOUBLE_CORNER_UNG =
{
  prob = 15,

  structure =
  {
    "11....","1111~~",
    "11....","1111~~",
    "......","~~~~~~",
    "......","~~~~~/",
  },

  diagonals =
  {
    "~.",
  },
},

GROW_CANAL_SINGLE_UNG =
{
  prob = 25,

  structure =
  {
    "11..","1111",
    "11..","1111",
    "..xx","~~xx",
  }
},

GROW_CANAL_SINGLE_CORNER_UNG =
{
  prob = 25,

  structure =
  {
    "11..","1111",
    "11..","1111",
    "....","~~~~",
  }
},

GROW_CANAL_SINGLE_CORNER_UNG_PILLARED =
{
  prob = 25,

  structure =
  {
    "11......","11111111",
    "11......","11/..%11",
    "........","~~%../~~",
    "x......x","x%~~~~/x",
  },

  diagonals =
  {
    "1.",".1",
    "~.",".~",
    ".~","~.",
  }
},

-- [NARROW CANALS : NCANALS]

GROW_NARROW_CANAL_ENTRY =
{
  prob = 5,

  structure =
  {
    "1..","111",
    "1..","111",
    "x..","x~~",
  }
},

GROW_NARROW_CANAL_ENTRY_FROMSIDE =
{
  prob = 5,

  structure =
  {
    "1...","111~",
    "1...","111~",
  }
},

GROW_NARROW_CANAL_STRAIGHT =
{
  prob = 10,

  structure =
  {
    "1.","11",
    "1.","11",
    "~.","~~",
  },
},

GROW_NARROW_CANAL_STRAIGHT_CROSSING =
{
  prob = 5,

  structure =
  {
    "1......","111A111",
    "1......","11/~%11",
    ".......","~~~~~~~",
  },

  diagonals =
  {
    "1~","~1",
  },
},

GROW_NARROW_CANAL_STAIRS =
{
  prob = 10,

  structure =
  {
    "1...","1>AA",
    "1...","1>AA",
    "~...","~~~~",
  },
},

GROW_NARROW_CANAL_INNER_CURVE =
{
  prob = 5,

  structure =
  {
    "1...","111%",
    "1...","1111",
    "~...","~%11",
    "x...","x~11",
  },

  diagonals =
  {
    "1.",
    "~1",
  },
},

GROW_NARROW_CANAL_OUTER_CURVE =
{
  prob = 5,

  structure =
  {
    "1..","11~",
    "1..","1/~",
    "~..","~~/",
  },

  diagonals =
  {
    "1~",
    "~.",
  },
},

-- MSSP's maze parts. [MAZE]
GROW_MAZE_STRAIGHT =
{
  prob = 10,
  skip_prob = 85,

  structure =
  {
    "x..x","x11x",
    "x..x","x11x",
    "....","#1##",
    "....","#1##",
    "x11x","x11x",
  }
},

GROW_MAZE_ZIGZAG =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    "x..x","x11x",
    "x..x","x%1x",
    "x..x","x#1x",
    "....","#/1#",
    "....","#1/#",
    "x..x","x1#x",
    "x..x","x1%x",
    "x11x","x11x"
  },

  diagonals =
  {
    ".1",
    ".1",
    "1.",
    "1."
  }
},

GROW_MAZE_ZIGZAG_CAGE =
{
  prob = 5,
  skip_prob = 80,

  structure =
  {
    "x..x","x11x",
    "x..x","x%1x",
    "x..x","xC1x",
    "....","#/1#",
    "....","#1/#",
    "x..x","x1Cx",
    "x..x","x1%x",
    "x11x","x11x"
  },

  diagonals =
  {
    "C1",
    "C1",
    "1C",
    "1C"
  }
},

GROW_MAZE_ZIGZAG_DOUBLE =
{
  prob = 8,
  skip_prob = 80,

  structure =
  {
    "x..x","x11x",
    "x..x","x%1x",
    "x..x","x#1x",
    "...x","#/1x",
    "x...","x1/#",
    "x..x","x1#x",
    "x..x","x1#x",
    "x...","x1%#",
    "...x","#%1x",
    "x..x","x#1x",
    "x..x","x/1x",
    "x11x","x11x"
  },

  diagonals =
  {
    ".1",
    ".1",
    "1.",
    "1.",
    ".1",
    ".1"
  }
},

GROW_MAZE_ZIGZAG_DOUBLE_CAGE =
{
  prob = 5,
  skip_prob = 80,

  structure =
  {
    "x..x","x11x",
    "x..x","x%1x",
    "x..x","xC1x",
    "...x","#/1x",
    "x...","x1/#",
    "x..x","x1Cx",
    "x..x","x1Cx",
    "x...","x1%#",
    "...x","#%1x",
    "x..x","xC1x",
    "x..x","x/1x",
    "x11x","x11x"
  },

  diagonals =
  {
    "C1",
    "C1",
    "1C",
    "1C",
    "C1",
    "C1"
  }
},

GROW_MAZE_SIDE_BUMP =
{
  prob = 5,
  skip_prob = 80,

  structure =
  {
    "x..x","x11x",
    "xx.x","xx1x",
    "xx..","xx1%",
    "xx..","xx11",
    "xx..","xx11",
    "xx..","xx1/",
    "xx.x","xx1x",
    "x11x","x11x"
  },

  diagonals =
  {
    "1.",
    "1."
  }
},

GROW_MAZE_SIDE_BUMP_CAGE =
{
  prob = 5,
  skip_prob = 80,

  structure =
  {
    "x..x","x11x",
    "xx.x","xx1x",
    "xx..","xx1%",
    "xx..","xx11",
    "xx..","xx1C",
    "xx..","xx11",
    "xx..","xx1C",
    "xx..","xx11",
    "xx..","xx1/",
    "xx.x","xx1x",
    "x11x","x11x"
  },

  diagonals =
  {
    "1.",
    "1."
  }
},

GROW_MAZE_STRAIGHT_NEW_AREA =
{
  prob = 8,
  skip_prob = 75,

  structure =
  {
    "x..","xAA",
    "x..","xAA",
    "...","#1#",
    "x11","x11",
  }
},

GROW_MAZE_STRAIGHT_STAIRED =
{
  prob = 10,
  skip_prob = 35,

  structure =
  {
    "x..","xAA",
    "x..","xAA",
    "...","#^#",
    "...","#1#",
    "x11","x11",
  }
},

GROW_MAZE_STRAIGHT_LONG =
{
  prob = 8,
  skip_prob = 35,

  structure =
  {
    "x..","x11",
    "x..","x11",
    "...","#1#",
    "...","#1#",
    "...","#1#",
    "...","#1#",
    "x11","x11",
  }
},

GROW_MAZE_STRAIGHT_STAIRED_LONG =
{
  prob = 10,
  skip_prob = 35,

  structure =
  {
    "x..","xAA",
    "x..","xAA",
    "...","#^#",
    "...","#^#",
    "...","#^#",
    "x11","x11",
  }
},

GROW_MAZE_L =
{
  prob = 12,
  skip_prob = 35,

  structure =
  {
    "...x..","###x11",
    "......","#11111",
    "...xxx","#1#xxx",
    "...xxx","#1#xxx",
    "11xxxx","11xxxx",
  }
},

GROW_MAZE_L_DIAG =
{
  prob = 10,
  skip_prob = 35,

  structure =
  {
    "xx.x..","xx#x11",
    "x.....","x#/111",
    "....xx","#/1/xx",
    "....xx","#1/#xx",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
         ".1",
    ".1","1.",
    "1.",
  }
},

GROW_MAZE_T =
{
  prob = 8,
  skip_prob = 35,

  structure =
  {
    ".......","11###11",
    ".......","1111111",
    "xx...xx","xx#1#xx",
    "xx...xx","xx#1#xx",
    "xxx11xx","xxx11xx",
  }
},

GROW_MAZE_X =
{
  prob = 5,
  skip_prob = 50,

  structure =
  {
    "1...xxxx..","1111xxxx11",
    "1....xx...","1111%xx/11",
    "xxx......x","xxx%1%/1/x",
    "xxxx....xx","xxxx%11/xx",
    "xxxx....xx","xxxx/11%xx",
    "xxx......x","xxx/1/%1%x",
    "xx...xx...","xx11/xx%11",
    "xx..xxxx..","xx11xxxx11",
  },

  diagonals =
  {
         "1.",".1",
    ".1","1.",".1","1.",
         ".1","1.",
         ".1","1.",
    ".1","1.",".1","1.",
         "1.",".1",
  }
},

GROW_MAZE_T_DIAG =
{
  prob = 2,
  skip_prob = 65,

  structure =
  {
    "....x....","11##x##11",
    ".........","111%#/111",
    "xx.....xx","xx%111/xx",
    "xx.....xx","xx#%1/#xx",
    "xxxx.xxxx","xxxx1xxxx",
    "xxxx11xxx","xxxx11xxx",
  },

  diagonals =
  {
    "1.",".1",
    ".1","1.",
    ".1","1.",
  }
},

GROW_MAZE_CROSS =
{
  prob = 8,
  skip_prob = 45,

  structure =
  {
    "xxxx..xxx","xxxx11xxx",
    "xxxx..xxx","xxxx11xxx",
    "xxx...xxx","xxx#1#xxx",
    ".........","111111111",
    "..x...x..","11x#1#x11",
    "xxxx11xxx","xxxx11xxx",
  }
},

GROW_MAZE_U =
{
  prob = 8,
  skip_prob = 45,

  structure =
  {
    "x...x","x111x",
    "x.x.x","x1x1x",
    ".....","#1#1#",
    ".....","#1#1#",
    ".....","11#11",
    "11...","11#11",
  }
},

GROW_MAZE_ =
{
  prob = 8,
  skip_prob = 50,

  structure =
  {
    "xxxx..xxx","xxxx11xxx",
    "xxxx..xxx","xxxx11xxx",
    "xxxx.xxxx","xxxx1xxxx",
    "xxx...xxx","xxx/1%xxx",
    ".........","111111111",
    "..x...x..","11x%1/x11",
    "xxxx.xxxx","xxxx1xxxx",
    "xxxx11xxx","xxxx11xxx",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1."
  }
},

--[[GROW_MAZE_SQUARE =
{
  prob = 5,
  skip_prob = 50,
  
  structure =
  {
    "xx..xx","xx##xx",
    "x....x","x1111x",
    "......","#1..1#",
    "......","#1..1#",
    "x1...x","x1111x",
    "x1..xx","x1##xx",
  }
},]]

GROW_MAZE_STRAIGHT_CAGE =
{
  prob = 8,
  skip_prob = 35,

  structure =
  {
    "x..","x11",
    "x..","x11",
    "x.x","x1x",
    "...","#1C",
    "...","#1C",
    "x.x","x1x",
    "x11","x11",
  }
},

GROW_MAZE_STRAIGHT_CAGE_ALT =
{
  prob = 2,
  skip_prob = 35,

  structure =
  {
    "x..","x11",
    "x..","x11",
    "x.x","x1x",
    "...","#1C",
    "...","#1#",
    "...","#1C",
    "x.x","x1x",
    "x11","x11",
  }
},

-- [LARGE MAZE]

GROW_LARGE_MAZE_LONG =
{
  prob = 10,
  skip_prob = 50,

  structure =
  {
    "x..x","x11x",
    "x..x","x11x",
    "....","!11!",
    "....","!11!",
    "....","!11!",
    "....","!11!",
    "x11x","x11x",
    "x11x","x11x",
  }
},

GROW_LARGE_MAZE_LONGER =
{
  prob = 7,
  skip_prob = 65,

  structure =
  {
    "x..x","x11x",
    "x..x","x11x",
    "....","!11!",
    "....","!11!",
    "....","!11!",
    "....","!11!",
    "....","!11!",
    "....","!11!",
    "x11x","x11x",
    "x11x","x11x",
  }
},

GROW_LARGE_MAZE_LONG_BANDS =
{
  prob = 10,
  skip_prob = 50,

  structure =
  {
    "x..x","x11x",
    "x..x","x11x",
    "....","!AA!",
    "....","!11!",
    "....","!11!",
    "....","!AA!",
    "x11x","x11x",
    "x11x","x11x",
  }
},

GROW_LARGE_MAZE_CROSS =
{
  prob = 7,
  skip_prob = 65,

  structure =
  {
    "xxxx..xxxx","xxxx11xxxx",
    "xxxx..xxxx","xxxx11xxxx",
    "xxx....xxx","xxx!11!xxx",
    "xx......xx","xx!!11!!xx",
    "..........","1111111111",
    "..........","1111111111",
    "xx......xx","xx!!11!!xx",
    "xxx....xxx","xxx!11!xxx",
    "xxxx11xxxx","xxxx11xxxx",
    "xxxx11xxxx","xxxx11xxxx",
  }
},

GROW_LARGE_MAZE_CROSS_NEW_AREA =
{
  prob = 7,
  skip_prob = 65,

  structure =
  {
    "xxxx..xxxx","xxxx11xxxx",
    "xxxx..xxxx","xxxx11xxxx",
    "xxx....xxx","xxx!11!xxx",
    "xx......xx","xx!!AA!!xx",
    "..........","111A11A111",
    "..........","111A11A111",
    "xx......xx","xx!!AA!!xx",
    "xxx....xxx","xxx!11!xxx",
    "xxxx11xxxx","xxxx11xxxx",
    "xxxx11xxxx","xxxx11xxxx",
  }
},

-- [TWO-WAYS]

GROW_TWO_WAY_SMALL =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "....","1111",
    "....","11vv",
    "....","AAAA",
    "....","AAAA",
    "....","^^11",
    "....","1111",
    "11xx","11xx",
  }
},

GROW_THREE_WAY_SMALL =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "......","111111",
    "......","11vv11",
    "......","AAAAAA",
    "......","AAAAAA",
    "......","^^11^^",
    "......","111111",
    "11xxxx","11xxxx",
  }
},

GROW_RUNIC_S =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "xx....","xx11AA",
    "xx....","xx11AA",
    "xx....","xx11#A",
    "x.....","x/11AA",
    "......","/11/AA",
    "......","11/AA/",
    ".....x","11AA/x",
    "....xx","11#Axx",
    "....xx","11AAxx",
    "11..xx","11AAxx",
  },

  diagonals =
  {
    ".1",
    ".1","1A",
    "1A","A.",
         "A.",
  }
},

GROW_RUNIC_S_LIQUID =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "xx....","xx11~~",
    "xx....","xx11~~",
    "xx....","xx11#~",
    "x.....","x/11~~",
    "......","/11/~~",
    "......","11/~~/",
    ".....x","11~~/x",
    "....xx","11#~xx",
    "....xx","11~~xx",
    "11..xx","11~~xx",
  },

  diagonals =
  {
    ".1",
    ".1","1~",
    "1~","~.",
         "~.",
  }
},

GROW_RUNIC_S_STAIR =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "xx....","xx11AA",
    "xx....","xx1#AA",
    "xx....","xx1>AA",
    "xx....","xx1>AA",
    "x.....","x/11AA",
    "......","/11/AA",
    "......","11/AA/",
    ".....x","11AA/x",
    "....xx","11#Axx",
    "....xx","11AAxx",
    "11..xx","11AAxx",
  },

  diagonals =
  {
    ".1",
    ".1","1A",
    "1A","A.",
         "A.",
  }
},

-- MSSP's liquid slabs. [LIQUID_SLABS]

GROW_LIQUID_SLAB_ENTRY =
{
  prob = 20,
  skip_prob = 55,

  structure =
  {
    "....","1111",
    "....","1111",
    "....","~~~~",
    "....","1111",
    "11..","1111",
  },
},

GROW_LIQUID_SLAB_LONG =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","~~~~~~~~",
    "........","11111111",
    "11......","11111111",
  },
},

GROW_LIQUID_SLAB_BRIDGE =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    ".......","1111111",
    ".......","111v111",
    ".......","~~~A~~~",
    ".......","111^111",
    "11.....","1111111",
  },
},

GROW_LIQUID_SLAB_DIAGONAL =
{
  prob = 15,
  skip_prob = 65,

  structure =
  {
    "...x","11~x",
    "....","1//1",
    "..11","~/11",
    "xx11","xx11",
  },

  diagonals =
  {
    "1~","~1",
    "~1",
  },
},

GROW_LIQUID_SLAB_DIAGONAL_REVERSE =
{
  prob = 15,
  skip_prob = 65,

  structure =
  {
    "....x","1111x",
    ".....","111/~",
    ".....","11//1",
    "...11","1//11",
    "x..11","x~111",
  },

  diagonals =
  {
    "1~",
    "1~","~1",
    "1~","~1",
  },
},

-- Lake shapes - very large bodies of water. [LAKE]

GROW_LAKE_BIG_O_NEW_AREA =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "xxxxx11xxxxx","xxxxx11xxxxx",
    "............","/1111111111%",
    "............","111111111111",
    "............","111111111111",
    "............","111/~~~~%111",
    "............","111~~~~~~111",
    "............","111~~~~~~111",
    "............","111~~~~~~111",
    "............","vvv~~~~~~vvv",
    "............","vvv~~~~~~vvv",
    "............","AAA~~~~~~AAA",
    "............","AAA~~~~~~AAA",
    "............","AAA~~~~~~AAA",
    "............","AAA%~~~~/AAA",
    "............","AAAAAAAAAAAA",
    "............","AAAAAAAAAAAA",
    "............","%AAAAAAAAAA/",
  },

  diagonals =
  {
    ".1","1.",
    "1~","~1",
    "A~","~A",
    ".A","A.",
  },
},

GROW_LAKE_BIG_O_WIDE_NEW_AREA =
{
  prob = 40,
  skip_prob = 80,

  structure =
  {
    "xxxxxxx11xxxxxxx","xxxxxxx11xxxxxxx",
    "................","AAAAAA<11>AAAAAA",
    "................","AAAAAA<11>AAAAAA",
    "................","AAAAAA<11>AAAAAA",
    "................","AAA/~~~~~~~~%AAA",
    "................","AAA~~~~~~~~~~AAA",
    "................","AAA~~~~~~~~~~AAA",
    "................","AAA~~~~~~~~~~AAA",
    "................","AAA~~~~~~~~~~AAA",
    "................","AAA~~~~~~~~~~AAA",
    "................","AAA~~~~~~~~~~AAA",
    "................","AAA~~~~~~~~~~AAA",
    "................","AAA~~~~~~~~~~AAA",
    "................","AAA%~~~~~~~~/AAA",
    "................","AAAAAAAAAAAAAAAA",
    "................","AAAAAAAAAAAAAAAA",
    "................","AAAAAAAAAAAAAAAA",
  },

  diagonals =
  {
    "A~","~A",
    "A~","~A",
  },
},

GROW_LAKE_BIG_L_NEW_AREA =
{
  prob = 75,
  skip_prob = 65,

  structure =
  {
    "xxxxx11xxxxxxxxxxx","xxxxx11xxxxxxxxxxx",
    "............xxxxxx","/1111111111%xxxxxx",
    "............xxxxxx","111111111111xxxxxx",
    "............xxxxxx","111111111111xxxxxx",
    "............xxxxxx","111/~~~~%111xxxxxx",
    "............xxxxxx","vvv~~~~~~vvvxxxxxx",
    "............xxxxxx","AAA~~~~~~AAAxxxxxx",
    "..................","AAA~~~~~~AAAAAAAA%",
    "..................","AAA~~~~~~AAAAAAAAA",
    "..................","AAA~~~~~~%AAAAAAAA",
    "..................","AAA~~~~~~~~~~~%AAA",
    "..................","AAA~~~~~~~~~~~~AAA",
    "..................","AAA~~~~~~~~~~~~AAA",
    "..................","AAA%~~~~~~~~~~/AAA",
    "..................","AAAAAAAAAAAAAAAAAA",
    "..................","AAAAAAAAAAAAAAAAAA",
    "..................","%AAAAAAAAAAAAAAAA/",
  },

  diagonals =
  {
    ".1","1.",
    "1~","~1",
         "A.",
    "~A",
         "~A",
    "A~","~A",
    ".A","A.",
  },
},

GROW_LAKE_BIG_J_NEW_AREA =
{
  prob = 35,
  skip_prob = 75,

  structure =
  {
    "x11xxxxxxxxx","x11xxxxxxxxx",
    ".........xxx","111~~~~~~xxx",
    ".........xxx","111~~~~~~xxx",
    ".........xxx","111~~~~~~xxx",
    ".........xxx","111~~~~~~xxx",
    ".........xxx","111~~~~~~xxx",
    ".........xxx","111~~~~~~xxx",
    ".........xxx","111~~~~~~xxx",
    ".........xxx","vvv~~~~~~xxx",
    ".........xxx","vvv~~~~~~xxx",
    "............","AAA~~~~~~AAA",
    "............","AAA~~~~~~AAA",
    "............","AAA~~~~~~AAA",
    "............","AAA%~~~~/AAA",
    "............","AAAAAAAAAAAA",
    "............","AAAAAAAAAAAA",
    "............","%AAAAAAAAAA/",
  },

  diagonals =
  {
    "A~","~A",
    ".A","A.",
  },
},

GROW_LAKE_BIG_J_NEW_AREA_2 =
{
  prob = 50,
  skip_prob = 75,

  structure =
  {
    "x11xxxxxxxxx","x11xxxxxxxxx",
    "............","111~~~~~~111",
    "............","111~~~~~~111",
    "............","111~~~~~~111",
    "............","111~~~~~~111",
    "............","111~~~~~~111",
    "............","111~~~~~~111",
    "............","111~~~~~~111",
    "............","vvv~~~~~~vvv",
    "............","vvv~~~~~~vvv",
    "............","AAA~~~~~~AAA",
    "............","AAA~~~~~~AAA",
    "............","AAA~~~~~~AAA",
    "............","AAA%~~~~/AAA",
    "............","AAAAAAAAAAAA",
    "............","AAAAAAAAAAAA",
    "............","%AAAAAAAAAA/",
  },

  diagonals =
  {
    "A~","~A",
    ".A","A.",
  },
},

GROW_LAKE_CROSS_NEW_AREA =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "xxxxxxx11xxxxxxx","xxxxxxx11xxxxxxx",
    "x..............x","x/~~~~1111~~~~%x",
    "................","/~~~~~1111~~~~~%",
    "................","~~~~~~vvvv~~~~~~",
    "................","~~~~~~vvvv~~~~~~",
    "................","~~~~~~AAAA~~~~~~",
    "................","~~~~~/AAAA%~~~~~",
    "xxx..........xxx","xxxAAAAAAAAAAxxx",
    "xxx..........xxx","xxxAAAAAAAAAAxxx",
    "xxx..........xxx","xxxAAAAAAAAAAxxx",
    "xxx..........xxx","xxxAAAAAAAAAAxxx",
    "................","~~~~~%AAAA/~~~~~",
    "................","~~~~~~AAAA~~~~~~",
    "................","~~~~~~AAAA~~~~~~",
    "......xxxx......","~~~~~~xxxx~~~~~~",
    "......xxxx......","%~~~~~xxxx~~~~~/",
    "x.....xxxx.....x","x%~~~~xxxx~~~~/x",
  },

  diagonals =
  {
    ".~","~.",
    ".~","~.",
    "~A","A~",
    "~A","A~",
    ".~","~.",
    ".~","~.",
  },
},

GROW_LAKE_CROSS_NEW_AREA_STRAIGHT =
{
  prob = 35,
  skip_prob = 75,

  structure =
  {
    "xxxxxxx11xxxxxxx","xxxxxxx11xxxxxxx",
    "x..............x","x/~~~~1111~~~~%x",
    "................","/~~~~~1111~~~~~%",
    "................","~~~~~~vvvv~~~~~~",
    "................","~~~~~~vvvv~~~~~~",
    "................","~~~~~~AAAA~~~~~~",
    "................","~~~~~/AAAA%~~~~~",
    "................","~~~~/AAAAAA%~~~~",
    "................","~~~~AAAAAAAA~~~~",
    "................","~~~~AAAAAAAA~~~~",
    "................","~~~~%AAAAAA/~~~~",
    "................","~~~~~%AAAA/~~~~~",
    "................","~~~~~~AAAA~~~~~~",
    "................","~~~~~~^^^^~~~~~~",
    "................","~~~~~~^^^^~~~~~~",
    "................","%~~~~~1111~~~~~/",
    "x..............x","x%~~~~1111~~~~/x",
  },

  diagonals =
  {
    ".~","~.",
    ".~","~.",
    "~A","A~",
    "~A","A~",
    "~A","A~",
    "~A","A~",
    ".~","~.",
    ".~","~.",
  },
},

GROW_LAKE_BIG_X_NEW_AREA =
{
  prob = 45,
  skip_prob = 60,

  structure =
  {
    "xxxxx........xxxxx","xxxxx~~~~~~~~xxxxx",
    "11...............x","11111%~~~~~~/1111x",
    "11...............x","111111%~~~~/11111x",
    "x................x","x111111%~~/111111x",
    "..................","~%111111%/111111/~",
    "..................","~~%111111111111/~~",
    "..................","~~~%1111111111/~~~",
    "..................","~~~/1111111111%~~~",
    "..................","~~/111111111111%~~",
    "..................","~/111111/%111111%~",
    "x................x","x111111/~~%111111x",
    "x................x","x11111/~~~~%11111x",
    "x................x","x1111/~~~~~~%1111x",
    "xxxxx........xxxxx","xxxxx~~~~~~~~xxxxx",
  },

  diagonals =
  {
         "1~","~1",
         "1~","~1",
         "1~","~1",
    "~1","1~","~1","1~",
    "~1"     ,     "1~",
    "~1"     ,     "1~",
    "~1"     ,     "1~",
    "~1"     ,     "1~",
    "~1","1~","~1","1~",
         "1~","~1",
         "1~","~1",
         "1~","~1",
  },
},

GROW_BIG_REACTOR_ARENA =
{
  prob = 45,
  skip_prob = 75,

  structure =
  {
    "xxxxx1111xxxxx","xxxxx1111xxxxx",
    "x............x","x/1111111111%x",
    "..............","/111111111111%",
    "..............","11111111111111",
    "..............","111/%1111/%111",
    "..............","111%/AAAA%/111",
    "..............","1111AAAAAA1111",
    "..............","AAAAAAAAAAAAAA",
    "..............","AAAAAAAAAAAAAA",
    "..............","1111AAAAAA1111",
    "..............","111/%1111/%111",
    "..............","111%/AAAA%/111",
    "..............","111111AA111111",
    "..............","%11111AA11111/",
    "x............x","x%1111AA1111/x",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    "1#","#1","1#","#1",
    "1#","#1","1#","#1",
    "1#","#1","1#","#1",
    "1#","#1","1#","#1",
    ".1","1.",
    ".1","1.",
  },
},

-- MSSP's shape primitives [PRIMITIVES]

GROW_PRIMITIVE_CIRCLE_3X =
{
  prob = 45,
  skip_prob = 25,

  structure =
  {
    "xx.....xx","xx/111%xx",
    "x.......x","x/11111%x",
    ".........","111111111",
    ".........","111111111",
    ".........","111111111",
    "x.......x","x%11111/x",
    "xx.....xx","xx%111/xx",
    "xxx111xxx","xxx111xxx",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    ".1","1.",
    ".1","1.",
  },
},

GROW_PRIMITIVE_CIRCLE_2X =
{
  prob = 20,
  skip_prob = 25,

  structure =
  {
    "xx..xx","xx11xx",
    "x....x","x/11%x",
    "......","/1111%",
    "......","111111",
    "......","111111",
    "......","%1111/",
    "x....x","x%11/x",
    "xx11xx","xx11xx",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    ".1","1.",
    ".1","1.",
  },
},

-- MSSP's shape tamers. Tries to get rid of strange architectural decisions such as pointy walls. [TAMERS]

SERRATED_EDGE_SMOOTHER =
{
  pass = "smoother",
  prob = 35,

  structure =
  {
    "1","1",
    "/","1",
  },

  diagonals =
  {
    ".1",
  },
},

SERRATED_LIQUID_SMOOTHER3 =
{
  pass = "smoother",

  prob = 15,

  structure =
  {
    "~~1","~~1",
    "/~1","~~1",
  },

  diagonals =
  {
    ".~",
  },
},

--MSSP's square-out. Makes rooms less... wormy or spaghetti-ish.

SQUARE_OUT_FROM_CORNER_2X =
{
  pass = "square_out",

  prob = 100,

  structure =
  {
    "1..","111",
    "x11","x11",
  },
},

SQUARE_OUT_FROM_CORNER =
{
  pass = "square_out",

  prob = 50,

  structure =
  {
    "1.","11",
    "x1","x1",
  },
},

SQUARE_OUT_THICKEN_CLIFF_BOTH_SIDES =
{
  pass = "square_out",

  prob = 150,

  structure =
  {
    "..","11",
    "11","11",
    "22","22",
    "..","22",
  },
},

SQUARE_OUT_THICKEN_CLIFF_ONE_SIDE =
{
  pass = "square_out",

  prob = 125,

  structure =
  {
    "..","11",
    "11","11",
    "22","22",
  },
},

SQUARE_OUT_EXTEND_AREA_BORDER =
{
  pass = "square_out",

  prob = 80,

  structure =
  {
    "x1","x1",
    "2.","22",
  },
},

SQUARE_OUT_SMOOTH_EDGE =
{
  pass = "square_out",

  prob = 35,

  structure =
  {
    "x1","x1",
    "1.","1/",
  },

  diagonals =
  {
    "1.",
  },
},

SQUARE_OUT_SMOOTH_PLATFORM =
{
  pass = "square_out",

  prob = 50,

  structure =
  {
    "x1x","x1x",
    "122","1/2",
    "x2x","x2x",
  },

  diagonals =
  {
    "12",
  },
},

SQUARE_OUT_REMOVE_TRIANGLE =
{
  pass = "square_out",

  prob = 15,

  structure =
  {
    "1%","11",
    "x1","x1",
  },

  diagonals =
  {
    "1.",
  },
},

--MSSP's random negative features [FEATURES] - 'negative' because they attempt to modify an existing room if it has too much clean space.

GROW_FEATURES_CENTER =
{
  prob = 25,
  skip_prob = 30,

  structure =
  {
    "1......","1111111",
    "1......","11/A%11",
    "x......","x1AAA11",
    "x......","x1%A/11",
    "x......","x111111",
  },

  diagonals =
  {
    "1.",".1",
    "1.",".1",
  },
},

GROW_FEATURES_CENTER_RAISED =
{
  prob = 10,
  skip_prob = 50,

  structure =
  {
    "1......","1111111",
    "1......","11/v%11",
    "x......","x1>A<11",
    "x......","x1%^/11",
    "x......","x111111",
  },

  diagonals =
  {
    "1.",".1",
    "1.",".1",
  },
},

GROW_FEATURES_OCT_MOATED_PLATFORM =
{
  prob = 20,
  skip_prob = 50,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","~~~~~~",
    "......","~/AA%~",
    "......","~AAAA~",
    "......","~AAAA~",
    "......","~%AA/~",
    "......","~~~~~~",
    "....11","111111",
    "....11","111111",
  },

  diagonals =
  {
    "~.",".~",
    "~.",".~",
  },
},

GROW_FEATURES_OCT_MOATED_PLATFORM_STAIRS =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","~~vv~~",
    "......","~/AA%~",
    "......","~AAAA~",
    "......","~AAAA~",
    "......","~%AA/~",
    "......","~~^^~~",
    "....11","111111",
    "....11","111111",
  },

  diagonals =
  {
    "~.",".~",
    "~.",".~",
  },
},

GROW_FEATURES_RECT_MOATED_PLATFORM =
{
  prob = 20,
  skip_prob = 50,

  structure =
  {
    ".......","1111111",
    ".......","1111111",
    ".......","~~~~~~~",
    ".......","~#111#~",
    ".......","~~~~~~~",
    ".....11","1111111",
    ".....11","1111111",
  },
},

GROW_FEATURES_RECT_MOATED_PLATFORM_STAIRS =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    ".......","1111111",
    ".......","1111111",
    ".......","~~vvv~~",
    ".......","~#AAA#~",
    ".......","~~^^^~~",
    ".....11","1111111",
    ".....11","1111111",
  },
},

GROW_ELEVATED_PILLAR_ROUND =
{
  prob = 35,
  skip_prob = 40,

  structure =
  {
    ".........","111111111",
    ".........","11/AAA%11",
    ".........","11AAAAA11",
    ".........","11>A.AA11",
    ".........","11AAAAA11",
    "11.......","11%AAA/11",
    "11.......","111111111",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  },
},

GROW_ELEVATED_PILLAR_U =
{
  prob = 20,
  skip_prob = 70,

  structure =
  {
    "1....","1>AAA",
    "1....","1>AAA",
    "xx...","xx.AA",
    "xx...","xxAAA",
    "xx...","xxAAA",
  },
},

GROW_ELEVATED_PILLAR_U_FULL =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "1.....","1>>AAA",
    "1.....","1>>AAA",
    "x.....","xAA.AA",
    "x.....","xAAAAA",
    "x.....","xAAAAA",
  },
},

GROW_ELEVATED_PILLAR_U_FULL_LIQUID =
{
  prob = 20,
  skip_prob = 70,

  structure =
  {
    "1.....","1>>AAA",
    "1.....","1>>AAA",
    "x.....","x~~.AA",
    "x.....","xAAAAA",
    "x.....","xAAAAA",
  },
},

GROW_WIDE_SPACE_DEPRESSION =
{
  prob = 38,
  skip_prob = 70,

  aversion = 5,

  structure =
  {
    "...","111",
    "...","111",
    "...","vvv",
    "...","AAA",
    "...","AAA",
    "...","^^^",
    "...","111",
    "11x","11x",
  },
},

GROW_WIDE_SPACE_CATWALK_PLAIN =
{
  prob = 40,
  skip_prob = 35,

  structure =
  {
    "......","11AA11",
    "......","11AA11",
    "......","11^^11",
    "......","111111",
    "xx11xx","xx11xx",
  },
},

GROW_WIDE_SPACE_CATWALK_PLAIN_LIQUID =
{
  prob = 20,
  skip_prob = 35,

  structure =
  {
    "........","11~AA~11",
    "........","11~AA~11",
    "........","11~^^~11",
    "........","11111111",
    "xxx11xxx","xxx11xxx",
  },
},

GROW_WIDE_SPACE_CATWALK_TALL_PLAIN =
{
  prob = 35,
  skip_prob = 35,

  structure =
  {
    "......","11AA11",
    "......","11AA11",
    "......","11^^11",
    "......","11^^11",
    "......","111111",
    "xx11xx","xx11xx",
  },
},

GROW_WIDE_SPACE_CATWALK_TALL_PLAIN_LIQUID =
{
  prob = 25,
  skip_prob = 35,

  structure =
  {
    "........","11~AA~11",
    "........","11~AA~11",
    "........","11~^^~11",
    "........","11~^^~11",
    "........","11111111",
    "xxx11xxx","xxx11xxx",
  },
},

GROW_WIDE_SPACE_PLATFORM_TINY =
{
  prob = 30,
  skip_prob = 35,

  structure =
  {
    "......x","11AA11x",
    "......x","11AA11x",
    "......1","11>A111",
    "......1","1111111"
  }
},

GROW_WIDE_SPACE_PLATFORM_TINY_LIQUID =
{
  prob = 20,
  skip_prob = 35,

  structure =
  {
    ".......x","11AA~11x",
    ".......x","11AA~11x",
    ".......1","11>A~111",
    ".......1","11111111"
  }
},

GROW_WIDE_LOW_CEILING_SIDE =
{
  prob = 20,
  skip_prob = 60,

  structure =
  {
    "....","1111",
    "....","1111",
    "....","1#AA",
    "....","1AAA",
    "....","1AAA",
    "....","1#AA",
    "....","1111",
    "11xx","11xx",
  },
},

GROW_WIDE_LOW_CEILING_SIDE_LIQUID =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "....","1111",
    "....","1111",
    "....","1#AA",
    "....","1A~~",
    "....","1A~~",
    "....","1#AA",
    "....","1111",
    "11xx","11xx",
  },
},


GROW_WIDE_LOW_CEILING_CENTER =
{
  prob = 20,
  skip_prob = 60,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","1.AA.1",
    "......","1AAAA1",
    "......","1AAAA1",
    "......","1.AA.1",
    "......","111111",
    "11xxxx","11xxxx",
  },
},

GROW_WIDE_LOW_CEILING_CENTER_LIQUID =
{
  prob = 20,
  skip_prob = 65,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","1.~~.1",
    "......","1~~~~1",
    "......","1~~~~1",
    "......","1.~~.1",
    "......","111111",
    "11xxxx","11xxxx",
  },
},

GROW_WIDE_LOW_CEILING_CORNER =
{
  prob = 20,
  skip_prob = 65,

  structure =
  {
    ".....","AAAA1",
    ".....","AAA#1",
    ".....","AAA/1",
    "...11","A#/11",
    "...11","11111",
  },

  diagonals =
  {
    "A1",
    "A1",
  },
},

GROW_WIDE_LOW_CEILING_CORNER_STAIRS =
{
  prob = 5,
  skip_prob = 75,

  structure =
  {
    ".....","AAA<1",
    ".....","AAA#1",
    ".....","AAA/1",
    "...11","^#/11",
    "...11","11111",
  },

  diagonals =
  {
    "A1",
    "A1",
  },
},

GROW_COLONNADE_3_PILLARS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "1.........","1111111111",
    "1.........","1111111111",
    "x.........","x11#A#A#11",
    "x.........","x11AAAAA11",
    "x.........","x11AAAAA11",
  },
},

GROW_COLONNADE_3_STAIRS =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "........","AAAAAAAA",
    "........","AAAAAAAA",
    "........","^^A^^A^^",
    "........","^^A^^A^^",
    "........","^^#^^#^^",
    "........","11111111",
    "........","11111111",
    "11xxxxxx","11xxxxxx"
  }
},

GROW_COLONNADE_3_STAIRS_PILLARLESS =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "........","AAAAAAAA",
    "........","AAAAAAAA",
    "........","^^A^^A^^",
    "........","^^A^^A^^",
    "........","^^A^^A^^",
    "........","11111111",
    "........","11111111",
    "11xxxxxx","11xxxxxx"
  }
},

GROW_TRIANGULAR_LOW_CEILING =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xxx111xxx","xxx111xxx",
    ".........","111111111",
    ".........","111/.%111",
    ".........","11/AAA%11",
    ".........","1/AAAAA%1",
    "x!xxxxx!x","x!xxxxx!x",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
    "1A","A1",
  },
},

GROW_PILLAR_2X2 =
{
  prob = 10,

  structure =
  {
    "1.....","111111",
    "1.....","11..11",
    "x.....","x1..11",
    "x.....","x11111",
  },
},

GROW_PILLAR_2X2_STAIRS =
{
  prob = 3,

  structure =
  {
    "1....","11111",
    "1....","11..1",
    "x....","xv..v",
    "x....","xAAAA",
    "x....","xAAAA",
  },
},

GROW_PILLAR_3X3 =
{
  prob = 10,

  structure =
  {
    "1......","1111111",
    "1......","11/#%11",
    "x......","x1###11",
    "x......","x1%#/11",
    "x......","x111111",
  },

  diagonals =
  {
    "1.",".1",
    "1.",".1",
  },
},

GROW_PILLAR_3X3_STAIRS =
{
  prob = 3,

  structure =
  {
    "1.....","111111",
    "1.....","11/#%1",
    "x.....","xv###v",
    "x.....","xA%#/A",
    "x.....","xAAAAA",
    "x.....","xAAAAA",
  },

  diagonals =
  {
    "1.",".1",
    "A.",".A",
  },
},

GROW_PILLAR_3x3_TOP_SLOPE =
{
  prob = 5,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1/A%1",
    ".....","1A#A1",
    ".....","1%A/1",
    ".....","11111",
    "11xxx","11xxx",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  },
},

GROW_PILLAR_TORII =
{
  prob = 10,

  structure =
  {
    ".......","1111111",
    ".......","1111111",
    ".......","1#A1A#1",
    ".......","1111111",
    "xx111xx","xx111xx",
  },
},

GROW_PILLAR_BEAN =
{
  prob = 10,

  structure =
  {
    "....","1111",
    "....","1111",
    "....","1/#1",
    "....","1#/1",
    "....","1111",
    "x11x","x11x",
  },

  diagonals =
  {
    "1.",
    ".1",
  },
},

GROW_PILLAR_GATE =
{
  prob = 15,
  skip_prob = 35,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","1#AA#1",
    "......","111111",
    "11xxxx","11xxxx",
  },
},

GROW_PILLAR_GATE_LIQUID =
{
  prob = 15,
  skip_prob = 50,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","1#~~#1",
    "......","111111",
    "11xxxx","11xxxx",
  }
},

GROW_PILLAR_PLUS_SHAPED_CAGE =
{
  prob = 15,
  skip_prob = 85,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1#C#1",
    ".....","1CCC1",
    ".....","1#C#1",
    ".....","11111",
    "11xxx","11xxx"
  }
},

GROW_PILLAR_C_SHAPED_CAGE =
{
  prob = 15,
  skip_prob = 85,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1#C%1",
    ".....","11%C1",
    ".....","111#1",
    ".....","11111",
    "11xxx","11xxx"
  },

  diagonals =
  {
    "C1",
    "1C"
  }
},

GROW_PILLAR_STUPID_BRIDGE_CAGE =
{
  prob = 15,
  skip_prob = 85,

  structure =
  {
    ".....","11111",
    ".....","11111",
    ".....","1#v#1",
    ".....","1CAC1",
    ".....","1CAC1",
    ".....","1#^#1",
    ".....","11111",
    "11xxx","11xxx"
  }
},

GROW_WATER_STRIPES_SIDE =
{
  prob = 10,
  skip_prob = 85,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11~~~~",
    "......","111111",
    "......","11~~~~",
    "......","111111",
    "......","11~~~~",
    "......","111111",
    "......","11~~~~",
    "......","111111"
  }
},

GROW_WATER_STRIPES_SIDE_SLOPE =
{
  prob = 5,
  skip_prob = 85,

  structure =
  {
    "11xxxxxxxx","11xxxxxxxx",
    "..........","11~~~~~~AA",
    "..........","11111AAAAA",
    "..........","11~~~~~~AA",
    "..........","11111AAAAA",
    "..........","11~~~~~~AA",
    "..........","11111AAAAA",
    "..........","11~~~~~~AA",
    "..........","1111>>AAAA"
  }
},


GROW_WATER_STRIPES_SIDE_SLOPE_CAGED =
{
  prob = 5,
  skip_prob = 90,

  structure =
  {
    "11xxxxxxxx","11xxxxxxxx",
    "..........","11~~~~~CAA",
    "..........","11111AAAAA",
    "..........","11~~~~~CAA",
    "..........","11111AAAAA",
    "..........","11~~~~~CAA",
    "..........","11111AAAAA",
    "..........","11~~~~~CAA",
    "..........","1111>>AAAA"
  }
},

GROW_WATER_STRIPES_CURVE =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    "11......","11111111",
    "11......","11111111",
    "........","11~~~~~1",
    "........","11~11111",
    "........","11~11111",
    "........","11~11~~1",
    "........","11~11~11",
    "........","11111111"
  }
},

GROW_WATER_STRIPES_RETICULE =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    "11........","1111111111",
    "11........","111~11~111",
    "..........","111~11~111",
    "..........","1~~~11~~~1",
    "..........","1111111111",
    "..........","1111111111",
    "..........","1~~~11~~~1",
    "..........","111~11~111",
    "..........","111~11~111",
    "..........","1111111111"
  }
},

GROW_WATER_STRIPES_RETICULE_DIAGONAL =
{
  prob = 10,
  skip_prob = 85,

  structure =
  {
    "11........","1111111111",
    "11........","111~11~111",
    "..........","11/~11~%11",
    "..........","1~~/11%~~1",
    "..........","1111111111",
    "..........","1111111111",
    "..........","1~~%11/~~1",
    "..........","11%~11~/11",
    "..........","111~11~111",
    "..........","1111111111"
  },

  diagonals =
  {
    "1~","~1",
    "~1","1~",
    "~1","1~",
    "1~","~1"
  }
},

GROW_WATER_STRIPES_RETICULE_half =
{
  prob = 8,
  skip_prob = 85,

  structure =
  {
    "xxxx......","xxxx111111",
    "xxx.......","xxx~11~111",
    "xx........","xx/~11~%11",
    "x.........","x~~/11%~~1",
    "1.........","1111111111",
    "1.........","1111111111",
    "x.........","x~~%11/~~1",
    "xx........","xx%~11~/11",
    "xxx.......","xxx~11~111",
    "xxxx......","xxxx111111"
  },

  diagonals =
  {
    ".~","~1",
    "~1","1~",
    "~1","1~",
    ".~","~1"
  }
},

GROW_WATER_STRIPES_RETICULE_halfdiag =
{
  prob = 10,
  skip_prob = 90,

  structure =
  {
    "11....xxxx","111111xxxx",
    "11.....xxx","111~11~xxx",
    "........xx","11/~11~%xx",
    ".........x","1~~/11%~~x",
    "..........","1111111111",
    "..........","1111111111",
    "x.........","x~~%11/~~1",
    "xx........","xx%~11~/11",
    "xxx.......","xxx~11~111",
    "xxxx......","xxxx111111"
  },

  diagonals =
  {
    "1~","~.",
    "~1","1~",
    "~1","1~",
    ".~","~1"
  }
},

GROW_WATER_STRIPES_RETICULE_PILLARED =
{
  prob = 10,
  skip_prob = 90,

  structure =
  {
    "11........","1111111111",
    "11........","111~11~111",
    "..........","111~##~111",
    "..........","1~~~##~~~1",
    "..........","1111111111",
    "..........","1111111111",
    "..........","1~~~##~~~1",
    "..........","111~##~111",
    "..........","111~11~111",
    "..........","1111111111"
  }
},

GROW_WATER_STRIPES_RETICULE_DIAGONAL_PILLARED =
{
  prob = 10,
  skip_prob = 90,

  structure =
  {
    "11........","1111111111",
    "11........","111~##~111",
    "..........","11/~##~%11",
    "..........","1~~/11%~~1",
    "..........","1111111111",
    "..........","1111111111",
    "..........","1~~%11/~~1",
    "..........","11%~##~/11",
    "..........","111~##~111",
    "..........","1111111111"
  },

  diagonals =
  {
    "1~","~1",
    "~1","1~",
    "~1","1~",
    "1~","~1"
  }
},

--

GROW_CHAMFER_WIDE_ROOM_CORNER =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xxx...","xxx/11",
    "xx....","xx/111",
    "x.....","x/1111",
    "1.....","111111",
    "1.....","111111",
  },


  diagonals =
  {
    ".1",
    ".1",
    ".1",
  },
},

GROW_CHAMFER_WIDE_ROOM_CORNER_LIQUID =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "......","/~~/11",
    "......","~~/111",
    "......","~/1111",
    "1.....","111111",
    "1.....","111111",
  },


  diagonals =
  {
    ".~","~1",
      "~1",
    "~1",
  },
},

GROW_CHAMFER_WIDE_ROOM_CORNER_OUTLET =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "xxxx..","xxxx11",
    "xxxx..","xxxx11",
    "xxx...","xxx/11",
    "1.....","111111",
    "1.....","111111",
  },

  diagonals =
  {
    ".1",
  },
},

GROW_CHAMFER_WIDE_ROOM_CORNER_OUTLET_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xxxx..","xxxx11",
    "xx....","xx/~11",
    "xx....","xx~/11",
    "1.....","111111",
    "1.....","111111",
  },

  diagonals =
  {
    ".~",
    "~1",
  },
},

-- MSSP's 3.x/6.x-style rooms [6.x]
-- supposedly more or less trying to replicate the strange ceiling
-- layouts found in 3.x/6.x

GROW_36_DOUBLE_AREA =
{
  prob = 35,
  skip_prob = 80,

  structure =
  {
    "......","AAAA11",
    "......","AAAA11",
    "xx....","xx1111",
    "xx....","xx1111",
    "xx....","xx1111",
    "xx....","xx1111",
    "....11","AAAA11",
    "....11","AAAA11",
  },
},

GROW_36_DOUBLE_AREA_MIRRORED =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "..........","AAAA11AAAA",
    "..........","AAAA11AAAA",
    "xx......xx","xx111111xx",
    "xx......xx","xx111111xx",
    "xx......xx","xx111111xx",
    "xx......xx","xx111111xx",
    "..........","AAAA11AAAA",
    "....11....","AAAA11AAAA",
  },
},

GROW_36_SINGLE_AREA =
{
  prob = 30,
  skip_prob = 80,

  structure =
  {
    "x....","x1111",
    "x....","x1111",
    ".....","AAA11",
    ".....","AAA11",
    ".....","AAA11",
    ".....","AAA11",
    "x..11","x1111",
    "x..11","x1111",
  },
},

GROW_36_SINGLE_AREA_MIRRORED =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "x......x","x111111x",
    "x......x","x111111x",
    "........","AAA11AAA",
    "........","AAA11AAA",
    "........","AAA11AAA",
    "........","AAA11AAA",
    "x......x","x111111x",
    "x..11..x","x111111x",
  },
},

GROW_36_TRIPLE_AREA =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "....","AA11",
    "....","AA11",
    "x...","x111",
    "x...","x111",
    "....","AA11",
    "....","AA11",
    "x...","x111",
    "x...","x111",
    "..11","AA11",
    "..11","AA11",
  },
},

GROW_36_TRIPLE_AREA_MIRRORED =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    "......","AA11AA",
    "......","AA11AA",
    "x....x","x1111x",
    "x....x","x1111x",
    "......","AA11AA",
    "......","AA11AA",
    "x....x","x1111x",
    "x....x","x1111x",
    "......","AA11AA",
    "..11..","AA11AA",
  },
},

GROW_36_DOUBLE_FORWARD_AREA =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "..xxxx..","AAxxxxAA",
    "........","AA1111AA",
    "x......x","x111111x",
    "x......x","x111111x",
    "x......x","x111111x",
    "xxx11xxx","xxx11xxx",
  },
},

GROW_36_DOUBLE_FORWARD_AREA_STAIRS =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "..xxxx..","AAxxxxAA",
    "........","AA1111AA",
    "x......x","x^1111^x",
    "x......x","x^1111^x",
    "x......x","x111111x",
    "xxx11xxx","xxx11xxx",
  },
},

GROW_36_QUAD_FORWARD_AREA =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "..xxxx..","AAxxxxAA",
    "........","AA1111AA",
    "x......x","x111111x",
    "x......x","x111111x",
    "x......x","x111111x",
    "x......x","x111111x",
    "........","AA1111AA",
    "........","AA1111AA",
    "xxx11xxx","xxx11xxx",
  },
},

GROW_36_QUAD_FORWARD_AREA_STAIRS =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "..xxxx..","AAxxxxAA",
    "........","AA1111AA",
    "x......x","x^1111^x",
    "x......x","x111111x",
    "x......x","x111111x",
    "x......x","xv1111vx",
    "........","AA1111AA",
    "........","AA1111AA",
    "xxx11xxx","xxx11xxx",
  },
},

GROW_36_SINGLE_FORWARD_AREA =
{
  prob = 35,
  skip_prob = 75,

  structure =
  {
    "x....x","xAAAAx",
    "......","1AAAA1",
    "......","111111",
    "......","111111",
    "......","111111",
    "xx11xx","xx11xx",
  },
},

GROW_36_ROUND_NEW_AREA =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "xx....xx","xx1111xx",
    "x......x","x/1111%x",
    "........","11/AA%11",
    "........","11AAAA11",
    "........","11AAAA11",
    "........","11%AA/11",
    "x......x","x%1111/x",
    "xxx11xxx","xxx11xxx",
  },

  diagonals =
  {
    ".1","1.",
    "1A","A1",
    "1A","A1",
    ".1","1.",
  },
},

GROW_36_CROSS_NEW_AREA =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "xx....xx","xx1111xx",
    "xx....xx","xx1111xx",
    "........","11AAAA11",
    "........","11AAAA11",
    "........","11AAAA11",
    "........","11AAAA11",
    "xx....xx","xx1111xx",
    "xxx11xxx","xxx11xxx",
  },
},

GROW_SLIGE_BOXES =
{
  prob = 5,
  skip_prob = 80,

  structure =
  {
    "........","11111111",
    "........","1AAAAAA1",
    "........","1A1111A1",
    "........","1A1AA1A1",
    "........","1A1AA1A1",
    "........","1A1111A1",
    "........","1AAAAAA1",
    "........","11111111",
    "11xxxxxx","11xxxxxx"
  },
},

GROW_SLIGE_BANDS =
{
  prob = 5,
  skip_prob = 80,

  structure =
  {
    "......","111111",
    "......","AAAAAA",
    "......","111111",
    "......","AAAAAA",
    "......","111111",
    "......","AAAAAA",
    "......","111111",
    "......","AAAAAA",
    "11xxxx","11xxxx"
  },
},

GROW_36_CROSS_NEW_AREA_STAIRS =
{
  prob = 20,
  skip_prob = 70,

  structure =
  {
    "xx....xx","xx1111xx",
    "xx....xx","xxvvvvxx",
    "........","1>AAAA<1",
    "........","1>AAAA<1",
    "........","1>AAAA<1",
    "........","1>AAAA<1",
    "xx....xx","xx^^^^xx",
    "xx....xx","xx1111xx",
    "xxx11xxx","xxx11xxx",
  },
},

GROW_36_2SQUARE =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "11.........","11111111111",
    "11.........","11111111111",
    "...........","11AAA1AAA11",
    "...........","11AAA1AAA11",
    "...........","11AAA1AAA11",
    "...........","11111111111",
    "...........","11111111111",
  }
},

GROW_36_4SQUARE =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "11.........","11111111111",
    "11.........","11111111111",
    "...........","11AAA1AAA11",
    "...........","11AAA1AAA11",
    "...........","11AAA1AAA11",
    "...........","11111111111",
    "...........","11AAA1AAA11",
    "...........","11AAA1AAA11",
    "...........","11AAA1AAA11",
    "...........","11111111111",
    "...........","11111111111",
  }
},

GROW_36_6SQUARE =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11.........","11111111111",
    "11.........","11111111111",
    "...........","11AAA1AAA11",
    "...........","11AAA1AAA11",
    "...........","11111111111",
    "...........","11AAA1AAA11",
    "...........","11AAA1AAA11",
    "...........","11111111111",
    "...........","11AAA1AAA11",
    "...........","11AAA1AAA11",
    "...........","11111111111",
    "...........","11111111111",
  }
},

GROW_36_TEE_NEW_AREA =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "........","11AAAA11",
    "........","11AAAA11",
    "........","11AAAA11",
    "........","11AAAA11",
    "xx....xx","xx1111xx",
    "xxx11xxx","xxx11xxx",
  },
},

GROW_36_BISECT_SMALL =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "xx..xx","xx11xx",
    "x....x","x#11#x",
    "1.....","111111",
    "1.....","111111",
    "x....x","x#11#x",
    "xx..xx","xx11xx"
  },
},

GROW_36_BISECT_NEW_AREA_SMALL =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "xx..xx","xxAAxx",
    "x....x","x#AA#x",
    "1.....","11AA11",
    "1.....","11AA11",
    "x....x","x#AA#x",
    "xx..xx","xxAAxx"
  },
},

GROW_36_CROSS_NEW_AREA_SMALL =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "......","11AA11",
    "......","11AA11",
    "xx..xx","xx11xx",
    "xx11xx","xx11xx",
  },
},

GROW_36_TEE_NEW_AREA_SMALL =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "......","11AA11",
    "......","11AA11",
    "xx..xx","xx11xx",
    "xx11xx","xx11xx",
  },
},

GROW_36_ATARI_LOGO_NEW_AREA =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "......","AA11AA",
    "......","AA11AA",
    "......","AA11AA",
    "......","AA11AA",
    "......","A/11%A",
    "......","111111",
    "......","111111",
    "xx11xx","xx11xx",
  },

  diagonals =
  {
    "A1","1A",
  },
},

GROW_36_INVERSE_ATARI_LOGO_NEW_AREA =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "........","11AAAA11",
    "........","11AAAA11",
    "........","11AAAA11",
    "........","11AAAA11",
    "........","11%AA/11",
    "........","11111111",
    "........","11111111",
    "xxx11xxx","xxx11xxx",
  },

  diagonals =
  {
    "1A","A1",
  },
},

GROW_36_RIBBED_WALLS_NEW_AREA_DOUBLE =
{
  prob = 25,
  skip_prob = 70,

  structure =
  {
    "xx....","xxAAAA",
    "xx....","xxAAAA",
    "......","11AAAA",
    "......","11AAAA",
    "xx....","xxAAAA",
    "xx....","xxAAAA",
    "......","11AAAA",
    "......","11AAAA",
    "xx....","xxAAAA",
    "xx....","xxAAAA",
    "xxx11x","xxx11x",
  },
},

GROW_36_RIBBED_WALLS_NEW_AREA_SINGLE =
{
  prob = 20,
  skip_prob = 70,

  structure =
  {
    "x....","xAAAA",
    ".....","1AAAA",
    "x....","xAAAA",
    ".....","1AAAA",
    "x....","xAAAA",
    ".....","1AAAA",
    "x....","xAAAA",
    "xx11x","xx11x",
  },
},

GROW_36_PEANUT_NEW_AREA =
{
  prob = 30,
  skip_prob = 70,

  structure =
  {
    "xxx....xx","xxxAAAAxx",
    "x........","x11AAAA11",
    "x........","x11AAAA11",
    "x........","x11%AA/11",
    "1........","1111AA111",
    "1........","1111AA111",
    "x........","x11/AA%11",
    "x........","x11AAAA11",
    "x........","x11AAAA11",
    "xxx....xx","xxxAAAAxx",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  },
},

GROW_36_4PILLAR_ARCHS_NEW_AREA =
{
  prob = 30,
  skip_prob = 60,

  structure =
  {
    "x......x","x111111x",
    "x......x","x111111x",
    "........","AA#AA#AA",
    "........","AAAAAAAA",
    "........","AAAAAAAA",
    "........","AA#AA#AA",
    "x......x","x111111x",
    "x......x","x111111x",
    "xxx11xxx","xxx11xxx",
  },
},

GROW_36_4PILLAR_OPEN_ROOF_GAZEBO_NEW_AREA =
{
  prob = 25,
  skip_prob = 60,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","1#AA#1",
    "......","1A11A1",
    "......","1A11A1",
    "......","1#AA#1",
    "......","111111",
    "......","111111",
    "xx11xx","xx11xx",
  },
},

GROW_36_CANDY =
{
  prob = 35,
  skip_prob = 60,

  structure =
  {
    "........","11111111",
    "........","11111111",
    "........","11/AA%11",
    "........","AAAAAAAA",
    "........","AAA##AAA",
    "........","AAA##AAA",
    "........","AAAAAAAA",
    "........","11%AA/11",
    "........","11111111",
    "........","11111111",
    "xxx11xxx","xxx11xxx",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  },
},

GROW_36_CENTER_PILLAR_CROSSED =
{
  prob = 35,

  skip_prob = 70,

  structure =
  {
    "........","/11AA11%",
    "........","111AA111",
    "........","111AA111",
    "........","AAAAAAAA",
    "........","AAAAAAAA",
    "........","111AA111",
    "........","111AA111",
    "........","%11AA11/",
    "xxx11xxx","xxx11xxx",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
  },
},

GROW_36_TRIPLE_DIAMONDS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "...x","111x",
    "....","11/%",
    "....","11%/",
    "...x","111x",
    "....","11/%",
    "....","11%/",
    "...x","111x",
    "....","11/%",
    "....","11%/",
    ".11x","111x",
    ".11x","111x",
  },

  diagonals =
  {
    "1A","A.",
    "1A","A.",
    "1A","A.",
    "1A","A.",
    "1A","A.",
    "1A","A.",
  },
},

GROW_36_DOUBLE_LONG_DIAMONDS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "...x","111x",
    "....","11/%",
    "....","11AA",
    "....","11%/",
    "...x","111x",
    "....","11/%",
    "....","11AA",
    "....","11%/",
    ".11x","111x",
    ".11x","111x",
  },

  diagonals =
  {
    "1A","A.",
    "1A","A.",
    "1A","A.",
    "1A","A.",
  },
},

GROW_36_LONG_DIAMOND =
{
  prob = 25,
  skip_prob = 60,

  structure =
  {
    "xx....xx","xx/AA%xx",
    "........","11%AA/11",
    "........","11111111",
    "...11...","11111111",
    "xxx11xxx","xxx11xxx",
  },

  diagonals =
  {
    ".A","A.",
    "1A","A1",
  },
},

GROW_36_LONG_DIMAOND_STAIRS =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "xx......xx","xx/AAAA%xx",
    "..........","11%AAAA/11",
    "..........","1111^^1111",
    "....11....","1111111111",
    "xxxx11xxxx","xxxx11xxxx",
  },

  diagonals =
  {
    ".A","A.",
    "1A","A1",
  },
},

GROW_36_CORNER_DIAMOND =
{
  prob = 25,
  skip_prob = 70,

  structure =
  {
    "x..xx","x/Axx",
    ".....","/A/11",
    ".....","A/111",
    "x..11","x1111",
    "x..11","x1111",
  },

  diagonals =
  {
         ".A",
    ".A","A1",
    "A1",
  },
},

GROW_36_HEXAGON_INSET =
{
  prob = 20,
  skip_prob = 50,

  structure =
  {
    "x....x","x1111x",
    "x.....","x11/A%",
    "......","111AAA",
    "......","111AAA",
    "......","111AAA",
    "x.....","x11%A/",
    "x....x","x1111x",
  },

  diagonals =
  {
    "1A","A.",
    "1A","A.",
  },
},

GROW_36_HEXAGON_INSET =
{
  prob = 12,
  skip_prob = 50,

  structure =
  {
    "x....x","x1111x",
    "x.....","x11/A%",
    "x.....","x11#AA",
    "1.....","111AAA",
    "1.....","111AAA",
    "x.....","x11#AA",
    "x.....","x11%A/",
    "x....x","x1111x",
  },

  diagonals =
  {
    "1A","A.",
    "1A","A.",
  },
},

GROW_36_HEXAGON_INSET_MOAT =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x....x","x1/~~x",
    "x.....","x1~/A%",
    "x.....","x1~#AA",
    "1.....","11>AAA",
    "1.....","11>AAA",
    "x.....","x1~#AA",
    "x.....","x1~%A/",
    "x....x","x1%~~x",
  },

  diagonals =
  {
    "1~",
    "~A","A.",
    "~A","A.",
    "1~",
  },
},

--

GROW_BOWL =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x...........","x11/AAAA%111",
    "x...........","x11AAAAAA111",
    "1...........","11>AAAAAA<11",
    "1...........","11>AAAAAA<11",
    "x...........","x11AAAAAA111",
    "x...........","x11%AAAA/111",
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1",
  },
},

GROW_BOWL_LIQUID =
{
  prob = 35,
  skip_prob = 75,

  structure =
  {
    "x...........","x1/~~~~~~%11",
    "x...........","x1~/AAAA%~11",
    "x...........","x1~AAAAAA~11",
    "1...........","11>AAAAAA<11",
    "1...........","11>AAAAAA<11",
    "x...........","x1~AAAAAA~11",
    "x...........","x1~%AAAA/~11",
    "x...........","x1%~~~~~~/11",
  },

  diagonals =
  {
    "1~","~1",
    "~A","A~",
    "~A","A~",
    "1~","~1",
  },
},

-- [4x3_ALPHABET]

GROW_3x_A =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "xx11xx","xx11xx",
    "x....x","x/11%x",
    "......","/1111%",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "......","111111",
    "......","111111",
    "..xx..","11xx11",
    "..xx..","11xx11",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
  },
},

GROW_3x_A_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xx11xx","xx11xx",
    "x....x","x/11%x",
    "......","/1111%",
    "..xx..","11xx11",
    "..xx..","vvxxvv",
    "......","AAAAAA",
    "......","AAAAAA",
    "..xx..","AAxxAA",
    "..xx..","AAxxAA",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
  },
},

GROW_3x_A_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xx11xx","xx11xx",
    "x....x","x/11%x",
    "......","/1111%",
    "......","11~~11",
    "......","11~~11",
    "......","111111",
    "......","111111",
    "......","11~~11",
    "......","11~~11",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
  },
},

GROW_3x_B =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11111%",
    "..x...","11x111",
    "..x...","11x11/",
    ".....x","11111x",
    ".....x","11111x",
    "..x...","11x11%",
    "..x...","11x111",
    "......","11111/",
  },

  diagonals =
  {
    "1.",
    "1.",
    "1.",
    "1.",
  },
},

GROW_3x_B_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11>AA%",
    "..x...","11xAAA",
    "..x...","11xAA/",
    ".....x","11>AAx",
    ".....x","11>AAx",
    "..x...","11xAA%",
    "..x...","11xAAA",
    "......","11>AA/",
  },

  diagonals =
  {
    "A.",
    "A.",
    "A.",
    "A.",
  },
},

GROW_3x_B_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11111%",
    "......","11~111",
    "......","11~11/",
    "......","11111~",
    "......","11111~",
    "......","11~11%",
    "......","11~111",
    "......","11111/",
  },

  diagonals =
  {
    "1.",
    "1~",
    "1~",
    "1.",
  },
},

GROW_3x_C =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "xxx11x","xxx11x",
    "......","/1111%",
    "......","111111",
    "..xx..","11xx11",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xx..","11xx11",
    "......","111111",
    "......","%1111/",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
  },
},

GROW_3x_C_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xxx11x","xxx11x",
    "......","/A<11%",
    "......","AA<111",
    "..xx..","AAxx11",
    "..xxxx","AAxxxx",
    "..xxxx","AAxxxx",
    "..xx..","AAxx11",
    "......","AA<111",
    "......","%A<11/",
  },

  diagonals =
  {
    ".A","1.",
    ".A","1.",
  },
},

GROW_3x_C_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xxx11x","xxx11x",
    "......","/1111%",
    "......","111111",
    "......","11~~11",
    "......","11~~~~",
    "......","11~~~~",
    "......","11~~11",
    "......","111111",
    "......","%1111/",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
  },
},

GROW_3x_C_CENT =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "xxxx11xx","xxxx11xx",
    "x......x","x/1111%x",
    "x......x","x111111x",
    "x..xx..x","x11xx11x",
    "x..xxxxx","x11xxxxx",
    "........","AAAAAAAA",
    "x..xxxxx","x11xxxxx",
    "........","AAAAAAAA",
    "x..xxxxx","x11xxxxx",
    "x..xx..x","x11xx11x",
    "x......x","x111111x",
    "x......x","x%1111/x"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
  },
},

GROW_CBM =
{
  prob = 10,
  skip_prob = 88,

  structure =
  {
    "xxx....xx","xxx/%/%xx",
    "xx......x","xx/1111%x",
    "x........","x/111111%",
    "1........","111111111",
    "1........","111111111",
    "x........","x%111111/",
    "xx......x","xx%1111/x"
  },

  diagonals =
  {
    ".1","1.",".1","1.",
    ".1","1.",
    ".1","1.",

    ".1","1.",
    ".1","1."
  }
},

GROW_CBM_STEEPNESS =
{
  prob = 8,
  skip_prob = 92,

  structure =
  {
    "xxx....xx","xxx/%/%xx",
    "xx......x","xx/11%A%x",
    "x........","x/1111%A%",
    "1........","111111>AA",
    "1........","111111>AA",
    "x........","x%1111/A/",
    "xx......x","xx%11/A/x"
  },

  diagonals =
  {
    ".1","1.",".A","A.",
    ".1","1A","A.",
    ".1","1A","A.",

    ".1","1A","A.",
    ".1","1A","A."
  }
},

GROW_3x_D =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "x......","x11111%",
    "x......","x111111",
    "x..xx..","x11xx11",
    "x..xx..","x11xx11",
    "x..xx..","x11xx11",
    "x..xx..","x11xx11",
    "1......","1111111",
    "1......","111111/",
  },

  diagonals =
  {
    "1.",
    "1.",
  },
},

GROW_3x_D_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x......","xAAAAA%",
    "x......","xAAAAAA",
    "x..xx..","x11xxAA",
    "x..xx..","x11xxAA",
    "x..xx..","x11xx^^",
    "x..xx..","x11xx11",
    "1......","1111111",
    "1......","111111/",
  },

  diagonals =
  {
    "A.",
    "1.",
  },
},

GROW_3x_D_LIQUID_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x......","x11>AA%",
    "x......","x11>AAA",
    "x......","x11~~AA",
    "x......","x11~~AA",
    "x......","x11~~AA",
    "x......","x11~~AA",
    "1......","111>AAA",
    "1......","111>AA/",
  },

  diagonals =
  {
    "A.",
    "A.",
  },
},

GROW_3x_E =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "......1","1111111",
    "......1","1111111",
    "..xxxxx","11xxxxx",
    "....xxx","1111xxx",
    "....xxx","1111xxx",
    "..xxxxx","11xxxxx",
    "......x","111111x",
    "......x","111111x",
  },
},

GROW_3x_E_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "......1","1111111",
    "......1","1111111",
    "..xxxxx","vvxxxxx",
    "....xxx","AAAAxxx",
    "....xxx","AAAAxxx",
    "..xxxxx","^^xxxxx",
    "......x","111111x",
    "......x","111111x",
  },
},

GROW_3x_E_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "......1","1111111",
    "......1","1111111",
    "......x","11~~~~x",
    "......x","1111~~x",
    "......x","1111~~x",
    "......x","11~~~~x",
    "......x","111111x",
    "......x","111111x",
  },
},

GROW_3x_E_LIQUID_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "......1","AAA<111",
    "......1","AAA<111",
    "......x","AA~~~~x",
    "......x","AAAA~~x",
    "......x","AAAA~~x",
    "......x","AA~~~~x",
    "......x","AAA<11x",
    "......x","AAA<11x",
  },
},

GROW_3x_F =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "......","111111",
    "......","111111",
    "..xxxx","11xxxx",
    "....xx","1111xx",
    "....xx","1111xx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "11xxxx","11xxxx",
  },
},

GROW_3x_F_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "......","111111",
    "......","111111",
    "..xxxx","vvxxxx",
    "....xx","AAAAxx",
    "....xx","AAAAxx",
    "..xxxx","^^xxxx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "11xxxx","11xxxx",
  },
},

GROW_3x_F_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","11~~~~",
    "......","1111~~",
    "......","1111~~",
    "......","11~~~~",
    "....xx","11~~xx",
    "....xx","11~~xx",
    "11xxxx","11xxxx",
  },
},

GROW_3x_G =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "......1","/111111",
    "......1","1111111",
    "..xxxxx","11xxxxx",
    "..x...x","11x111x",
    "..x...x","11x111x",
    "..xx..x","11xx11x",
    "......x","111111x",
    "......x","%1111/x",
  },

  diagonals =
  {
    ".1",
    ".1","1.",
  },
},

GROW_3x_G_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "......1","/111111",
    "......1","1111111",
    "..xxxxx","vvxxxxx",
    "..x...x","AAxAAAx",
    "..x...x","AAxAAAx",
    "..xx..x","^^xx^^x",
    "......x","111111x",
    "......x","%1111/x",
  },

  diagonals =
  {
    ".1",
    ".1","1.",
  },
},

GROW_3x_G_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "......1","/111111",
    "......1","1111111",
    "......x","11~~~~x",
    "......x","11~111x",
    "......x","11~111x",
    "......x","11~~11x",
    "......x","111111x",
    "......x","%1111/x",
  },

  diagonals =
  {
    ".1",
    ".1","1.",
  },
},

GROW_3x_H =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "......","111111",
    "......","111111",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "..xx..","11xx11",
  },
},

GROW_3x_H_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "..xx..","11xxAA",
    "..xx..","11xxAA",
    "..xx..","vvxxAA",
    "......","AAAAAA",
    "......","AAAAAA",
    "..xx..","AAxx^^",
    "..xx..","AAxx11",
    "..xx..","AAxx11",
  },
},

GROW_3x_H_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11~~11",
    "......","11~~11",
    "......","11~~11",
    "......","111111",
    "......","111111",
    "......","11~~11",
    "......","11~~11",
    "......","11~~11",
  },
},

GROW_3x_H_LIQUID_NEW_AREA =
{
  prob = 12,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11~~11",
    "......","11~~11",
    "......","11~~11",
    "......","AAAAAA",
    "......","AAAAAA",
    "......","11~~11",
    "......","11~~11",
    "......","11~~11",
  },
},

GROW_3x_LIQUID_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11~~11",
    "......","11~~11",
    "......","vv~~vv",
    "......","AAAAAA",
    "......","AAAAAA",
    "......","^^~~^^",
    "......","11~~11",
    "......","11~~11",
  },
},

GROW_3x_I =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "x....x","x1111x",
    "x....x","x1111x",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "x....x","x1111x",
    "x....x","x1111x",
    "xx11xx","xx11xx",
  },
},

GROW_3x_I_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x....x","xAAAAx",
    "x....x","xAAAAx",
    "xx..xx","xxAAxx",
    "xx..xx","xx^^xx",
    "xx..xx","xx^^xx",
    "xx..xx","xx11xx",
    "x....x","x1111x",
    "x....x","x1111x",
    "xx11xx","xx11xx",
  },
},

GROW_3x_I_STAIRS_UP_DOWN =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x....x","x1111x",
    "x....x","x1111x",
    "xx..xx","xxvvxx",
    "xx..xx","xxAAxx",
    "xx..xx","xxAAxx",
    "xx..xx","xx^^xx",
    "x....x","x1111x",
    "x....x","x1111x",
    "xx11xx","xx11xx",
  },
},

GROW_3x_I_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x....x","x1111x",
    "x....x","x1111x",
    "......","~~11~~",
    "......","~~11~~",
    "......","~~11~~",
    "......","~~11~~",
    "x....x","x1111x",
    "x....x","x1111x",
    "xx11xx","xx11xx",
  },
},

GROW_3x_I_BULGE =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "x....x","x/11%x",
    "......","/A11A%",
    "......","AA11AA",
    "......","AA11AA",
    "......","%A11A/",
    "x....x","x%11/x",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx11xx","xx11xx"
  },

  diagonals =
  {
    ".A","A.",
    ".A","A.",
    ".A","A.",
    ".A","A.",
  }
},

GROW_3x_I_BULGE_LIQUID =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "x....x","x/11%x",
    "......","/1111%",
    "......","11~~11",
    "......","11~~11",
    "......","%1111/",
    "x....x","x%11/x",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx11xx","xx11xx"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    ".1","1.",
    ".1","1.",
  }
},

GROW_3x_I_BULGE_ALT =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "x....x","x/11%x",
    "......","/1111%",
    "......","AAAAAA",
    "......","AAAAAA",
    "......","%1111/",
    "x....x","x%11/x",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx11xx","xx11xx"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    ".1","1.",
    ".1","1.",
  }
},

GROW_3x_J =
{
  prob = 40,
  skip_prob = 80,

  structure =
  {
    "11xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "......","111111",
    "......","%1111/",
  },

  diagonals =
  {
    ".1","1.",
  },
},

GROW_3x_J_LIQUID =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "11xxxx","11xxxx",
    "....xx","11~~xx",
    "....xx","11~~xx",
    "......","11~~~~",
    "......","11~~~~",
    "......","11~~11",
    "......","11~~11",
    "......","111111",
    "......","%1111/",
  },

  diagonals =
  {
    ".1","1.",
  },
},

GROW_3x_K =
{
  prob = 15,
  skip_prob = 82,

  structure =
  {
    "..xx..","11xx11",
    "..x...","11x/11",
    "......","11/11/",
    ".....x","1111/x",
    ".....x","1111%x",
    "......","11%11%",
    "..x...","11x%11",
    "..xx..","11xx11",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    ".1",
    ".1","1.",
         "1.",
         "1.",
    ".1","1.",
    ".1",
  },
},

GROW_3x_K_STAIRS =
{
  prob = 10,
  skip_prob = 82,

  structure =
  {
    "..xx..","11xxAA",
    "..x...","11x/AA",
    "......","11/AA/",
    ".....x","11>A/x",
    ".....x","11>A%x",
    "......","11%AA%",
    "..x...","11x%AA",
    "..xx..","11xxAA",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    ".A",
    ".A","A.",
         "A.",
         "A.",
    ".A","A.",
    ".A",
  },
},

GROW_3x_K_LIQUID =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "......","11~~11",
    "......","11~/11",
    "......","11/11/",
    "......","1111/~",
    "......","1111%~",
    "......","11%11%",
    "......","11~%11",
    "......","11~~11",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    "~1",
    "~1","1~",
         "1~",
         "1~",
    "~1","1~",
    "~1",
  },
},

GROW_3x_L =
{
  prob = 45,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "......","111111",
    "......","111111",
  },
},

GROW_3x_L_alt =
{
  prob = 25,
  skip_prob = 80,

  structure =
  {
    "x..xxxx","x11xxxx",
    "x..xxxx","x11xxxx",
    "x..xxxx","x11xxxx",
    "x..xxxx","x11xxxx",
    "1......","1111111",
    "1......","1111111",
  },
},

GROW_3x_L_CAGE =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "x......","x11AAAA",
    "x......","x11>AAA",
    "x......","x11CCAA",
    "x......","x11CC^A",
    "1......","1111111",
    "1......","1111111",
  },
},

GROW_3x_L_CAGE_alt =
{
  prob = 10,
  skip_prob = 86,

  structure =
  {
    "x......","x11AACC",
    "x......","x11>ACC",
    "x......","x11AAAA",
    "x......","x11AA^A",
    "1......","1111111",
    "1......","1111111",
  },
},

GROW_3x_L_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "......","11~~~%",
    "......","11~~~~",
    "......","11~~~~",
    "......","11~~~~",
    "......","111111",
    "......","111111",
  },

  diagonals =
  {
    "~.",
  },
},

GROW_3x_L_LIQUID_alt =
{
  prob = 8,
  skip_prob = 82,

  structure =
  {
    "x......","x11~~~%",
    "x......","x11~~~~",
    "x......","x11~~~~",
    "x......","x11~~~~",
    "1......","1111111",
    "1......","1111111",
  },

  diagonals =
  {
    "~.",
  },
},

GROW_3x_L_UP_DOWN =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "..xxxx","11xxxx",
    "..xxxx","vvxxxx",
    "..xxxx","AAxxxx",
    "..xxxx","AAxxxx",
    "..xxxx","AAxxxx",
    "..xxxx","AAxxxx",
    "......","AAA<11",
    "......","AAA<11",
  }
},

GROW_3x_L_SHORTCUT =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "11...x","1111%x",
    ".....x","11111x",
    "..x..x","vvx11x",
    "..x..x","AAx11x",
    "..x...","AAx11%",
    "..x...","AAx%11",
    "..xx..","AAxx11",
    "......","AAA<11",
    "......","AAA<11",
  },

  diagonals =
  {
    "1.",
    "1.",
    ".1"
  }
},

GROW_3x_L_SHORTCUT_ALT =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "11...x","11>A%x",
    ".....x","11>AAx",
    "..x..x","11xAAx",
    "..x..x","11xAAx",
    "..x...","11xAA%",
    "..x...","11x%AA",
    "..xx..","11xx^^",
    "......","111111",
    "......","111111",
  },

  diagonals =
  {
    "A.",
    "A.",
    ".A"
  }
},

GROW_3x_L_SHORTCUT_LIQUID =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "11...x","1111%x",
    ".....x","11111x",
    ".....x","vv~11x",
    ".....x","AA~11x",
    "......","AA~11%",
    "......","AA~%11",
    "......","AA~~11",
    "......","AAA<11",
    "......","AAA<11",
  },

  diagonals =
  {
    "1.",
    "1.",
    "~1"
  }
},

GROW_3x_M =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "...xx...","11%xx/11",
    "........","111%/111",
    "........","11111111",
    "........","11%11/11",
    "..x..x..","11x11x11",
    "..x..x..","11x11x11",
    "..x..x..","11x11x11",
    "..x..x..","11x11x11",
    "xxx11xxx","xxx11xxx",
  },

  diagonals =
  {
    "1.",".1",
    "1.",".1",
    ".1","1.",
  },
},

GROW_3x_N =
{
  prob = 30,
  skip_prob = 75,

  structure =
  {
    "...x..","11%x11",
    "......","111%11",
    "......","111111",
    "......","111111",
    "......","11%111",
    "..x...","11x%11",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    "1.",
      "1.",
    ".1",
      ".1",
  },
},

GROW_3x_N_LIQUID =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "..~~..","11~~11",
    "...~..","11%~11",
    "......","111%11",
    "......","111111",
    "......","111111",
    "......","11%111",
    "..~...","11~%11",
    "..~~..","11~~11",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    "1~",
      "1~",
    "~1",
      "~1",
  },
},

GROW_3x_O =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "xx11xx","xx11xx",
    "......","/1111%",
    "......","111111",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "......","111111",
    "......","%1111/",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
  },
},

GROW_3x_O_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xx11xx","xx11xx",
    "......","/1111%",
    "......","111111",
    "......","11~~11",
    "......","11~~11",
    "......","11~~11",
    "......","11~~11",
    "......","111111",
    "......","%1111/",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
  },
},

GROW_3x_O_UP_DOWN =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xx11xx","xx11xx",
    "......","/1111%",
    "......","111111",
    "......","vv..vv",
    "......","AA..AA",
    "......","AA..AA",
    "......","^^..^^",
    "......","111111",
    "......","%1111/",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
  },
},

GROW_3x_O_LIQUID_PENINSULA =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xxx11xxx","xxx11xxx",
    "........","/111111%",
    "........","11111111",
    "........","11~~~~11",
    "........","11~AA~11",
    "........","vv~AA~vv",
    "........","vv~AA~vv",
    "........","AAAAAAAA",
    "........","%AAAAAA/",
  },

  diagonals =
  {
    ".1","1.",
    ".A","A.",
  },
},

GROW_3x_P =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "......","11111%",
    "......","111111",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "......","111111",
    "......","11111/",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    "1.",
    "1.",
  },
},

GROW_3x_P_STAIRS =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "......","11>>A%",
    "......","11>>AA",
    "..xx..","11xxAA",
    "..xx..","11xxAA",
    "......","11>>AA",
    "......","11>>A/",
    "..xxxx","11xxxx",
    "..xxxx","11xxxx",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    "A.",
    "A.",
  },
},

GROW_3x_P_LIQUID =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "......","11111%",
    "......","111111",
    "......","11~~11",
    "......","11~~11",
    "......","111111",
    "......","11111/",
    "....xx","11~~xx",
    "....xx","11~~xx",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    "1.",
    "1.",
  },
},

GROW_3x_P_LIQUID_STAIRS =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "......","11>>A%",
    "......","11>>AA",
    "......","11~~AA",
    "......","11~~AA",
    "......","11>>AA",
    "......","11>>A/",
    "....xx","11~~xx",
    "....xx","11~~xx",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    "A.",
    "A.",
  },
},

-- Q

GROW_3x_R =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "......","11111%",
    "......","111111",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "......","11111/",
    "......","11111%",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    "1.",
    "1.",
    "1.",
  },
},

GROW_3x_R_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "......","11111%",
    "......","111111",
    "......","11~~11",
    "......","11~~11",
    "......","11111/",
    "......","11111%",
    "......","11~~11",
    "......","11~~11",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    "1.",
    "1.",
    "1.",
  },
},

GROW_3x_S =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "x......","x/11111",
    "x......","x111111",
    "x..xxxx","x11xxxx",
    "x......","x11111%",
    "x......","x%11111",
    "xxxxx..","xxxxx11",
    "1......","1111111",
    "1......","111111/",
  },

  diagonals =
  {
    ".1",
    "1.",
    ".1",
    "1.",
  },
},

GROW_3x_S_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x......","x/11111",
    "x......","x111111",
    "x......","x11~~~~",
    "x......","x11111%",
    "x......","x%11111",
    "x......","x~~~~11",
    "1......","1111111",
    "1......","111111/",
  },

  diagonals =
  {
    ".1",
    "1.",
    ".1",
    "1.",
  },
},

GROW_3x_S_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x......","x/AAAAA",
    "x......","xAAAAAA",
    "x..xxxx","xAAxxxx",
    "x......","xAA<<1%",
    "x......","x%A<<11",
    "xxxxx..","xxxxx11",
    "1......","1111111",
    "1......","111111/",
  },

  diagonals =
  {
    ".A",
    "1.",
    ".A",
    "1.",
  },
},

GROW_3x_S_STAIRS_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x......","x/AAAAA",
    "x......","xAAAAAA",
    "x......","xAA~~~~",
    "x......","xAA<<1%",
    "x......","x%A<<11",
    "x......","x~~~~11",
    "1......","1111111",
    "1......","111111/",
  },

  diagonals =
  {
    ".A",
    "1.",
    ".A",
    "1.",
  },
},

GROW_3x_S_DOLLAR =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "xxxx.x.xxx","xxxxAxAxxx",
    "x.........","x/11A1A111",
    "x.........","x111A1A111",
    "x..x.x.xxx","x11xAxAxxx",
    "x.........","x111A1A11%",
    "x.........","x%11A1A111",
    "xxxx.x.x..","xxxxAxAx11",
    "1.........","1111A1A111",
    "1.........","1111A1A11/",
    "xxxx.x.xxx","xxxxAxAxxx"
  },

  diagonals =
  {
    ".1",
    "1.",
    ".1",
    "1.",
  },
},

GROW_3x_T =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "......","111111",
    "......","111111",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx11xx","xx11xx",
  }
},

GROW_3x_T_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "......","111111",
    "......","111111",
    "......","~~11~~",
    "......","~~11~~",
    "......","~~11~~",
    "......","~~11~~",
    "......","~~11~~",
    "......","~~11~~",
    "xx11xx","xx11xx",
  }
},

GROW_CROSS_PILLARS =
{
  prob = 8,
  skip_prob = 80,

  structure =
  {
    "xxxx11xxxx","xxxx11xxxx",
    "..........","1111111111",
    "..........","1111vv1111",
    "..........","1111AA1111",
    "..........","1111AA1111",
    "..........","11#AAAA#11",
    "..........","11#AAAA#11",
    "..........","1111AA1111",
    "..........","1111AA1111",
    "..........","1111AA1111",
    "..........","1111AA1111"
  }
},

GROW_CROSS_PILLARS_SIDE =
{
  prob = 8,
  skip_prob = 80,

  structure =
  {
    "xxxx11xxxxxx","xxxx11xxxxxx",
    "............","AAAA11AAAAAA",
    "............","AAAA11AAAAAA",
    "............","AA#111111>AA",
    "............","AA#111111>AA",
    "............","AAAAAAAAAAAA",
    "............","AAAAAAAAAAAA"
  }
},

GROW_3x_U =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "......","111111",
    "......","%1111/",
  },

  diagonals =
  {
    ".1","1.",
  },
},

GROW_3x_U_LIQUID =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11~~11",
    "......","11~~11",
    "......","11~~11",
    "......","11~~11",
    "......","11~~11",
    "......","11~~11",
    "......","111111",
    "......","%1111/",
  },

  diagonals =
  {
    ".1","1.",
  },
},

-- V (mostly the same as 'Y' or 'U'?)

-- W (just the upside-down of 'M')

GROW_3x_X =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "..xx..","11xx11",
    "..xx..","11xx11",
    "......","11%/11",
    "......","%1111/",
    "......","/1111%",
    "......","11/%11",
    "..xx..","11xx11",
    "..xx..","11xx11",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    "1.",".1",
    ".1","1.",
    ".1","1.",
    "1.",".1",
  },
},

GROW_3x_X_HALF =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "..xx..","11xx11",
    "..xx..","11xx11",
    "......","11%/11",
    "......","%1111/",
    "x11xxx","x11xxx",
  },

  diagonals =
  {
    "1.",".1",
    ".1","1.",
  },
},

GROW_3x_X_NEW_AREA =
{
  prob = 50,
  skip_prob = 80,

  structure =
  {
    "..xx..","11xxAA",
    "..xx..","11xxAA",
    "......","11%/AA",
    "......","%1/AA/",
    "......","/1%AA%",
    "......","11/%AA",
    "..xx..","11xxAA",
    "..xx..","11xxAA",
    "11xxxx","11xxxx"
  },

  diagonals =
  {
    "1.",".A",
    ".1","1A","A.",
    ".1","1A","A.",
    "1.",".A"
  }
},

GROW_3x_Y =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "..xx..","11xx11",
    "..xx..","11xx11",
    "......","11%/11",
    "......","%1111/",
    "x....x","x%11/x",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx11xx","xx11xx",
  },

  diagonals =
  {
    "1.",".1",
    ".1","1.",
    ".1","1.",
  },
},

GROW_3x_Y_STAIRS =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "..xx..","AAxxAA",
    "..xx..","AAxxAA",
    "..xx..","^^xx^^",
    "......","11%/11",
    "......","%1111/",
    "x....x","x%11/x",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx11xx","xx11xx",
  },

  diagonals =
  {
    "1.",".1",
    ".1","1.",
    ".1","1.",
  },
},

GROW_3x_Y_LIQUID =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "......","11~~11",
    "......","11~~11",
    "......","11%/11",
    "......","%1111/",
    "......","~%11/~",
    "......","~~11~~",
    "......","~~11~~",
    "......","~~11~~",
    "xx11xx","xx11xx",
  },

  diagonals =
  {
    "1~","~1",
    "~1","1~",
    "~1","1~",
  },
},

-- Z (skipped because it would be the same as 'N'?)

-- Numbers

GROW_ONE =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "x...xx","x/11xx",
    "....xx","/111xx",
    "....xx","1111xx",
    "....xx","1111xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "......","111111",
    "......","111111",
    "11xxxx","11xxxx"
  },

  diagonals =
  {
    ".1",
    ".1"
  }
},

GROW_ONE_STAIRS =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "x...xx","x/AAxx",
    "....xx","/AA^xx",
    "....xx","AA11xx",
    "....xx","A<11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "......","111111",
    "......","111111",
    "11xxxx","11xxxx"
  },

  diagonals =
  {
    ".A",
    ".A"
  }
},

GROW_FOUR =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "x..x..","x11x11",
    "...x..","/11x11",
    "...x..","11/x11",
    "..xx..","11xx11",
    "......","111111",
    "......","111111",
    "xxxx..","xxxx11",
    "xxxx..","xxxx11",
    "xxxx..","xxxx11",
    "xxxx..","xxxx11",
    "xxxx11","xxxx11"
  },

  diagonals =
  {
    ".1",
    "1."
  }
},

GROW_FOUR_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x..x..","xAAxAA",
    "...x..","/AAxAA",
    "...x..","AA/xAA",
    "..xx..","AAxx^^",
    "......","AAA<11",
    "......","AAA<11",
    "xxxx..","xxxx11",
    "xxxx..","xxxx11",
    "xxxx..","xxxx11",
    "xxxx..","xxxx11",
    "xxxx11","xxxx11"
  },

  diagonals =
  {
    ".A",
    "A."
  }
},

GROW_SEVEN =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "......","111111",
    "......","111111",
    "xxx...","xxx/11",
    "xx....","xx/111",
    "xx....","xx111/",
    "xx...x","xx11/x",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx11xx","xx11xx"
  },

  diagonals =
  {
    ".1",
    ".1",
    "1.",
    "1."
  }
},

GROW_SEVEN_STAIRS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "......","AAAAAA",
    "......","AAAAAA",
    "xxx...","xxx/A1",
    "xx....","xx/A/1",
    "xx....","xxA/1/",
    "xx...x","xx^1/x",
    "xx..xx","xx^1xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx..xx","xx11xx",
    "xx11xx","xx11xx"
  },

  diagonals =
  {
        ".A",
      ".A",
    "A1",
    "A1","1.",
      "1."
  }
},

GROW_EIGHT =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x....x","x/11%x",
    "......","/1111%",
    "......","11/%11",
    "......","11##11",
    "......","%1111/",
    "......","/1111%",
    "......","11##11",
    "......","11%/11",
    "......","%1111/",
    "x....x","x%11/x",
    "xx11xx","xx11xx"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    "1.",".1",
    ".1","1.",
    ".1","1.",
    "1.",".1",
    ".1","1.",
    ".1","1."
  }
},

GROW_HALF_EIGHT =
{
  prob = 15,
  skip_prob = 65,

  structure =
  {
    "x....x","x/11%x",
    "......","/1111%",
    "......","11/%11",
    "......","11##11",
    "......","%1111/",
    "xx11xx","xx11xx"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    "1.",".1",
    ".1","1.",
  }
},

GROW_HALF_EIGHT_LIQUID_POOL =
{
  prob = 15,
  skip_prob = 65,

  structure =
  {
    "x....x","x/11%x",
    "......","/1111%",
    "......","11/%11",
    "......","11%/11",
    "......","%1111/",
    "xx11xx","xx11xx"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    "1~","~1",
    "1~","~1",
    ".1","1.",
  }
},

GROW_HALF_EIGHT_LIQUID_POOL_LONG =
{
  prob = 12,
  skip_prob = 65,

  structure =
  {
    "x....x","x/11%x",
    "......","/1111%",
    "......","11/%11",
    "......","11~~11",
    "......","11~~11",
    "......","11%/11",
    "......","%1111/",
    "xx11xx","xx11xx"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    "1~","~1",
    "1~","~1",
    ".1","1.",
  }
},

GROW_EIGHT_STAIRS =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "x....x","x/AA%x",
    "......","/AAAA%",
    "......","AA/%AA",
    "......","AA##AA",
    "......","%^11^/",
    "......","/1111%",
    "......","11##11",
    "......","11%/11",
    "......","%1111/",
    "x....x","x%11/x",
    "xx11xx","xx11xx"
  },

  diagonals =
  {
    ".A","A.",
    ".A","A.",
    "A.",".A",
    ".A","A.",
    ".1","1.",
    "1.",".1",
    ".1","1.",
    ".1","1."
  }
},

GROW_DEUCE_DIAMONDS =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xx....xx","xx/11%xx",
    "x......x","x/1111%x",
    "........","/1/%111%",
    "........","11%/1111",
    "........","1111/%11",
    "........","%111%/1/",
    "x......x","x%1111/x",
    "xx....xx","xx%11/xx",
    "xxx11xxx","xxx11xxx"
  },

  diagonals =
  {
        ".1","1.",
        ".1","1.",
    ".1","1.",".1","1.",
        "1.",".1",
        "1.",".1",
    ".1","1.",".1","1.",
        ".1","1.",
        ".1","1."
  }
},

-- MSSP's rooms shaped like English alphabet letters. [LETTERS]

GROW_SKULL_P1_NEW_AREA =
{
  prob = 15,
  skip_prob = 85,

  structure =
  {
    "x.......x","x/AAAAA%x",
    ".........","/AAAAAAA%",
    ".........","AA/%A/%AA",
    ".........","AA%/A%/AA",
    ".........","AAAAAAAAA",
    ".........","%AAAAAAA/",
    "x.......x","x1A1A1A1x",
    "x.......x","x1A1A1A1x",
    "x.......x","x1A1A1A1x",
    "x.......x","x1A1A1A1x",
    "x.......x","x1111111x",
    "x.......x","x1111111x",
    "xxx111xxx","xxx111xxx"
  },

  diagonals =
  {
    ".A","A.",
    ".A","A.",
    "A~","~A","A~","~A",
    "A~","~A","A~","~A",
    ".A","A."
  }
},

GROW_SKULL_P1_STEEPNESS =
{
  prob = 10,
  skip_prob = 85,

  structure =
  {
    "x.......x","x/AAAAA%x",
    ".........","/AAAAAAA%",
    ".........","AA/%A/%AA",
    ".........","AA%/A%/AA",
    ".........","AAAAAAAAA",
    ".........","%AAAAAAA/",
    "x.......x","x1A1A1A1x",
    "x.......x","x1A1A1A1x",
    "x.......x","x1A1A1A1x",
    "x.......x","x1^1^1^1x",
    "x.......x","x1111111x",
    "x.......x","x1111111x",
    "xxx111xxx","xxx111xxx"
  },

  diagonals =
  {
    ".A","A.",
    ".A","A.",
    "A~","~A","A~","~A",
    "A~","~A","A~","~A",
    ".A","A."
  }
},

GROW_SKULL_P1_STEEPNESS_HALF =
{
  prob = 8,
  skip_prob = 85,

  structure =
  {
    "x....","x/AAA",
    ".....","/AAAA",
    ".....","AA/%A",
    ".....","AA%/A",
    ".....","AAAAA",
    ".....","%AAAA",
    "x....","x1A1A",
    "x....","x1A1A",
    "x....","x1A1A",
    "x....","x1^1^",
    "x....","x1111",
    "x....","x1111",
    "xxx11","xxx11"
  },

  diagonals =
  {
    ".A",
    ".A",
    "A~","~A",
    "A~","~A",
    ".A"
  }
},

-- other shapes

GROW_DIAGONAL_STALK =
{
  prob = 10,
  skip_prob = 80,

  structure =
  {
    "xxx.....","xxx11111",
    "xxx.....","xxx1111/",
    "xx.....x","xx/111/x",
    "x.....xx","x/111/xx",
    ".....xxx","/1111xxx",
    ".....xxx","11111xxx",
    "xxx11xxx","xxx11xxx"
  },

  diagonals =
  {
    "1.",
    ".1","1.",
    ".1","1.",
    ".1",
  },
},

GROW_DIAGONAL_STALK_LIQUID =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "xxx.....","xxx11111",
    "xx......","xx/1111/",
    "x.......","x//111//",
    ".......x","//111//x",
    "......xx","/1111/xx",
    ".....xxx","11111xxx",
    "xxx11xxx","xxx11xxx"
  },

  diagonals =
  {
         ".~","1~",
    ".~","~1","1~","~.",
    ".~","~1","1~","~.",
         "~1","~.",
  },
},

GROW_DIAGONAL_STALK_LIQUID_STAIRS =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "xxx.....","xxxAAAAA",
    "xx......","xx/AAAA/",
    "x.......","x/~AAA//",
    "x......x","x~~^^~~x",
    ".......x","//111~/x",
    "......xx","/1111/xx",
    ".....xxx","11111xxx",
    "xxx11xxx","xxx11xxx"
  },

  diagonals =
  {
         ".~","A~",
    ".~"     ,"A~","~.",
    ".~","~1",     "~.",
         "~1","~.",
  },
},

GROW_DIAGONAL_STALK_FUNNEL =
{
  prob = 10,
  skip_prob = 75,

  structure =
  {
    "........","11111111",
    "........","%111111/",
    "x......x","x%1111/x",
    "xx....xx","xx1111xx",
    "x......x","x/1111%x",
    "........","/111111%",
    "........","11111111",
    "11xxxxxx","11xxxxxx"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    ".1","1.",
    ".1","1."
  },
},

GROW_DIAGONAL_STALK_FUNNEL_NEW_AREA =
{
  prob = 9,
  skip_prob = 75,

  structure =
  {
    "........","AAAAAAAA",
    "........","%AAAAAA/",
    "x......x","x%AAAA/x",
    "xx....xx","xx1111xx",
    "x......x","x/1111%x",
    "........","/111111%",
    "........","11111111",
    "11xxxxxx","11xxxxxx"
  },

  diagonals =
  {
    ".A","A.",
    ".A","A.",
    ".1","1.",
    ".1","1."
  },
},

GROW_DIAGONAL_STALK_FUNNEL_STAIRS =
{
  prob = 9,
  skip_prob = 75,

  structure =
  {
    "........","AAAAAAAA",
    "........","%AAAAAA/",
    "x......x","x%AAAA/x",
    "xx....xx","xx^^^^xx",
    "x......x","x/1111%x",
    "........","/111111%",
    "........","11111111",
    "11xxxxxx","11xxxxxx"
  },

  diagonals =
  {
    ".A","A.",
    ".A","A.",
    ".1","1.",
    ".1","1."
  },
},

GROW_DIAGONAL_STALK_FUNNEL_STAIRS_LIQUID =
{
  prob = 9,
  skip_prob = 75,

  structure =
  {
    "........","AAAAAAAA",
    "........","%AAAAAA/",
    "........","~%AAAA/~",
    "........","~~^^^^~~",
    "........","~/1111%~",
    "........","/111111%",
    "........","11111111",
    "11xxxxxx","11xxxxxx"
  },

  diagonals =
  {
    "~A","A~",
    "~A","A~",
    "~1","1~",
    "~1","1~"
  },
},

GROW_O =
{
  prob = 40,
  skip_prob = 75,

  structure =
  {
    "x......x","x/1111%x",
    "........","/111111%",
    "........","11111111",
    "...xx...","111xx111",
    "...xx...","111xx111",
    "........","11111111",
    "........","%111111/",
    "x......x","x%1111/x",
    "xxx11xxx","xxx11xxx",
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    ".1","1.",
    ".1","1.",
  },
},

GROW_O_STAIR =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x......x","x/AAAA%x",
    "........","/AAAAAA%",
    "........","AAAAAAAA",
    "...xx...","AAAxxAAA",
    "...xx...","^^^xx^^^",
    "........","11111111",
    "........","%111111/",
    "x......x","x%1111/x",
    "xxx11xxx","xxx11xxx",
  },

  diagonals =
  {
    ".A","A.",
    ".A","A.",
    ".1","1.",
    ".1","1.",
  },
},

GROW_HALF_C =
{
  prob = 75,
  skip_prob = 25,

  structure =
  {
    "x.......x","x/111111x",
    "........1","/11111111",
    "........1","111111111",
    "........x","11111111x",
    ".....xxxx","1111/xxxx",
    "....xxxxx","1111xxxxx",
  },

  diagonals =
  {
    ".1",
    ".1",
    "1.",
  },
},

GROW_HALF_C_STAIR =
{
  prob = 50,
  skip_prob = 25,

  structure =
  {
    "x.......x","x/111111x",
    "........1","/11111111",
    "........1","111111111",
    "........x","11111111x",
    ".....xxxx","1111/xxxx",
    "....xxxxx","vvvvxxxxx",
    "....xxxxx","AAAAxxxxx",
    "....xxxxx","AAAAxxxxx",
  },

  diagonals =
  {
    ".1",
    ".1",
    "1.",
  },
},

GROW_L =
{
  prob = 75,
  skip_prob = 25,

  structure =
  {
    "x11xxxxx","x11xxxxx",
    "....xxxx","1111xxxx",
    "....xxxx","1111xxxx",
    "....xxxx","1111xxxx",
    "....xxxx","1111xxxx",
    "........","11111111",
    "........","11111111",
    "........","11111111",
    "........","11111111",
  },
},

GROW_L_STAIR =
{
  prob = 35,
  skip_prob = 50,

  structure =
  {
    "x11xxxxx","x11xxxxx",
    "....xxxx","1111xxxx",
    "....xxxx","1111xxxx",
    "....xxxx","1111xxxx",
    "....xxxx","1111xxxx",
    "........","1111>>AA",
    "........","1111>>AA",
    "........","1111>>AA",
    "........","1111>>AA",
  },
},

GROW_L_STAIR_ALT =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "x11xxxxx","x11xxxxx",
    "....xxxx","1111xxxx",
    "....xxxx","1111xxxx",
    "....xxxx","vvvvxxxx",
    "....xxxx","vvvvxxxx",
    "........","AAAA<<11",
    "........","AAAA<<11",
    "........","AAAA<<11",
    "........","AAAA<<11",
  },
},

GROW_T_STAIR =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xxxxx11xxxxx","xxxxx11xxxxx",
    "xxxx....xxxx","xxxx1111xxxx",
    "xxxx....xxxx","xxxx1111xxxx",
    "xxxx....xxxx","xxxxvvvvxxxx",
    "xxxx....xxxx","xxxxvvvvxxxx",
    "............","11>>AAAA<<11",
    "............","11>>AAAA<<11",
    "............","11>>AAAA<<11",
    "............","11>>AAAA<<11",
  },
},

GROW_T_STAIR_LIQUID =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "xxxxx11xxxxx","xxxxx11xxxxx",
    "xxxx....xxxx","xxxx1111xxxx",
    "xxxx....xxxx","xxxx1111xxxx",
    "xxxx....xxxx","xxxxvvvvxxxx",
    "xxxx....xxxx","xxxxvvvvxxxx",
    "............","11>>AAAA<<11",
    "............","11>>A~~A<<11",
    "............","11>>A~~A<<11",
    "............","11>>AAAA<<11",
  },
},

GROW_T_STAIR_ALT =
{
  prob = 12,
  skip_prob = 75,

  structure =
  {
    "xxxxx11xxxxx","xxxxx11xxxxx",
    "xxxx....xxxx","xxxx1111xxxx",
    "xxxx....xxxx","xxxx1111xxxx",
    "xxxx....xxxx","xxxxvAAvxxxx",
    "xxxx....xxxx","xxxxvAAvxxxx",
    "............","11>>AAAA<<11",
    "............","11AAAAAAAA11",
    "............","11AAAAAAAA11",
    "............","11>>AAAA<<11",
  },
},

-- Elevated letters.

GROW_ELEVATED_T_STALK_ENTRY =
{
  prob = 15,
  skip_prob = 20,

  aversion = 5,

  structure =
  {
    "1........","11111AAAA",
    "1........","11111AAAA",
    "x........","x11>AAAAA",
    "x........","x11>AAAAA",
    "x........","x11>AAAAA",
    "x........","x11>AAAAA",
    "x........","x1111AAAA",
    "x........","x1111AAAA",
  },
},

GROW_ELEVATED_O_QUARTER =
{
  prob = 15,
  skip_prob = 20,

  aversion = 5,

  structure =
  {
    "x11xx","x11xx",
    ".....","11111",
    ".....","11111",
    ".....","11/AA",
    ".....","11AAA",
    ".....","11AAA",
    ".....","11>AA",
    ".....","11>AA",
  },

  diagonals =
  {
    "1A",
  },
},

-- MSSP's keyboard symbols. I'm running out of ideas. [SYMBOLS]
GROW_SHARP =
{
  prob = 15,
  skip_prob = 75,

  structure =
  {
    "xx..xx..xx","xx11xx11xx",
    "xx..xx..xx","xx11xx11xx",
    "..........","1111111111",
    "..........","1111111111",
    "xx..xx..xx","xx11xx11xx",
    "xx..xx..xx","xx11xx11xx",
    "..........","1111111111",
    "..........","1111111111",
    "xx..xx..xx","xx11xx11xx",
    "xx..xx..xx","xx11xx11xx",
    "xx11xxxxxx","xx11xxxxxx"
  }
},

GROW_SHARP_NEW_AREA =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "xx..xx..xx","xx11xx11xx",
    "xx..xx..xx","xx11xx11xx",
    "..........","1111AA1111",
    "..........","111/AA%111",
    "xx..xx..xx","xxAAxxAAxx",
    "xx..xx..xx","xxAAxxAAxx",
    "..........","111%AA/111",
    "..........","1111AA1111",
    "xx..xx..xx","xx11xx11xx",
    "xx..xx..xx","xx11xx11xx",
    "xx11xxxxxx","xx11xxxxxx"
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1"
  }
},

GROW_SHARP_LIQUID =
{
  prob = 15,
  skip_prob = 80,

  structure =
  {
    "xx..xx..xx","xx11xx11xx",
    "xx..xx..xx","xx11xx11xx",
    "..........","1111AA1111",
    "..........","111/AA%111",
    "xx......xx","xxAA~~AAxx",
    "xx......xx","xxAA~~AAxx",
    "..........","111%AA/111",
    "..........","1111AA1111",
    "xx..xx..xx","xx11xx11xx",
    "xx..xx..xx","xx11xx11xx",
    "xx11xxxxxx","xx11xxxxxx"
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1"
  }
},

GROW_ARROW =
{
  prob = 15,
  prob = 75,

  structure =
  {
    "xx/%xx","xx..xx",
    "x/11%x","x....x",
    "/1111%","......",
    "xx11xx","xx..xx",
    "xx11xx","xx..xx",
    "xx11xx","xx..xx",
    "xx11xx","xx..xx",
    "xx11xx","xx11xx"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    ".1","1."
  }
},

GROW_ARROW_DOUBLE =
{
  prob = 20,
  prob = 80,

  structure =
  {
    "xx/%xx","xx..xx",
    "x/11%x","x....x",
    "/1111%","......",
    "xx11xx","xx..xx",
    "1111xx","1...xx",
    "1111xx","1...xx",
    "xx11xx","xx..xx",
    "%1111/","......",
    "x%11/x","x....x",
    "xx%/xx","xx..xx"
  },

  diagonals =
  {
    ".1","1.",
    ".1","1.",
    ".1","1.",
    ".1","1.",
    ".1","1.",
    ".1","1."
  }
},

-- MSSP's huge-arse rooms. [HUGE]

GROW_EXTRUSION_CORNER_4x4 =
{
  prob = 40,
  skip_prob = 10,

  structure =
  {
    "x....","x1111",
    "x....","x1111",
    "1....","11111",
    "1....","11111",
    "x11xx","x11xx",
  },
},

GROW_EXTRUSION_CORNER_4x4_NEW_AREA =
{
  prob = 40,
  skip_prob = 10,

  structure =
  {
    "x....","xAAAA",
    "x....","xAAAA",
    "1....","1AAAA",
    "1....","1AAAA",
    "x11xx","x11xx",
  },
},

GROW_EXTRUSION_4X6 =
{
  prob = 50,
  skip_prob = 25,

  structure =
  {
    "x11x","x11x",
    "....","1111",
    "....","1111",
    "....","1111",
    "....","1111",
    "....","1111",
    "....","1111",
  },
},

GROW_EXTRUSION_4X4 =
{
  prob = 65,
  skip_prob = 25,

  structure =
  {
    "x11x","x11x",
    "....","1111",
    "....","1111",
    "....","1111",
    "....","1111",
  },
},

GROW_EXTRUSION_NEW_AREA_4x2 =
{
  prob = 35,
  skip_prob = 25,

  structure =
  {
    "1111","1111",
    "....","AAAA",
    "....","AAAA",
  },
},

GROW_EXTRUSION_NEW_AREA_4x2_RETURN =
{
  prob = 45,
  skip_prob = 30,

  structure =
  {
    "1111","1111",
    "....","AAAA",
    "....","AAAA",
    "1111","1111",
    "1111","1111",
  },
},

GROW_EXTRUSION_STAIRCASE_4x2 =
{
  prob = 40,
  skip_prob = 30,

  structure =
  {
    "xx11","xx11",
    "....","AAvv",
    "....","AAvv",
    "....","AAAA",
    "....","AAAA",
  },
},

GROW_EXTRUSION_STAIRCASE_4x2_SIDEWAYS =
{
  prob = 40,
  skip_prob = 30,

  structure =
  {
    "xx11","xx11",
    "....","A<<1",
    "....","A<<1",
    "....","AAAA",
    "....","AAAA",
  },
},

GROW_EXTRUSION_STAIRCASE_4x2_SMALL =
{
  prob = 40,
  skip_prob = 30,

  structure =
  {
    "xx11","xx11",
    "....","AAAv",
    "....","AAAA",
    "....","AAAA",
    "....","AAAA",
  },
},

GROW_EXTRUSION_STAIRCASE_4x2_SMALL_SIDEWAYS =
{
  prob = 40,
  skip_prob = 30,

  structure =
  {
    "xx11","xx11",
    "....","AA<1",
    "....","AAAA",
    "....","AAAA",
    "....","AAAA",
  },
},

GROW_EXTRUSION_SINK =
{
  prob = 25,
  skip_prob = 25,

  aversion = 8,

  structure =
  {
    "11.xx","111xx",
    "11.xx","111xx",
    ".....","11vAA",
    ".....","11AAA",
    ".....","11^AA",
    "...xx","111xx",
    "...xx","111xx",
  },
},

DECORATE_CAGE_CANALS_STRAIGHT_3X =
{
  prob = 8,

  structure =
  {
    "...","CCC",
    "~~~","~~~",
    "111","111",
  },

  cage_mode = "fancy",
},

DECORATE_CAGE_CANALS_STRAIGHT_2X =
{
  prob = 8,

  structure =
  {
    "..","CC",
    "~~","~~",
    "11","11",
  },

  cage_mode = "fancy",
},

DECORATE_CAGE_CANALSWIDE_STRAIGHT_3X =
{
  prob = 10,

  structure =
  {
    "...","CCC",
    "~~~","~~~",
    "~~~","~~~",
    "111","111",
  },

  cage_mode = "fancy",
},

DECORATE_CAGE_CANALSWIDE_STRAIGHT_2X =
{
  prob = 5,

  structure =
  {
    "..","CC",
    "~~","~~",
    "~~","~~",
    "11","11",
  },
},

DECORATE_CAGE_CANALSWIDE_STRAIGHT_3X =
{
  prob = 7,

  structure =
  {
    "...","CCC",
    "~~~","~~~",
    "~~~","~~~",
    "111","111",
  },

  cage_mode = "fancy",
},

GROW_WIDE_SPACE_2X12 =
{
  prob = 2,
  prob_skew = 2,
  skip_prob = 40,

  structure =
  {
    "1............","1111111111111",
    "1............","1111111111111",
  },
},

GROW_WIDE_SPACE_2X12_SIDEWAYS =
{
  prob = 2,
  prob_skew = 2,
  skip_prob = 40,


  structure =
  {
    ".............","1111111111111",
    ".............","1111111111111",
    "11xxxxxxxxxxx","11xxxxxxxxxxx",
  },
},

GROW_WIDE_SPACE_2X8 =
{
  prob = 2,
  prob_skew = 2,
  skip_prob = 25,

  structure =
  {
    "1........","111111111",
    "1........","111111111",
  },
},

GROW_WIDE_SPACE_2X8_SIDEWAYS =
{
  prob = 2,
  prob_skew = 2,
  skip_prob = 25,

  structure =
  {
    ".........","111111111",
    ".........","111111111",
    "11xxxxxxx","11xxxxxxx",
  },
},

GROW_ROUNDED_CAP =
{
  prob = 20,
  prob_skew = 10,
  skip_prob = 15,

  structure =
  {
    "1...","111%",
    "1...","1111",
    "1...","1111",
    "1...","111/",
  },

  diagonals =
  {
    "1.",
    "1.",
  },
},

GROW_BLADED_CAP =
{
  prob = 20,
  prob_skew = 10,
  skip_prob = 25,

  structure =
  {
    "1..","111",
    "1..","111",
    "1..","11/",
    "1..","1/.",
  },

  diagonals =
  {
    "1.",
    "1.",
  },
},

--MSSP's cliff extensions [CLIFF] [LEDGES]

GROW_INTO_CLIFF =
{
  prob = 20,
  skip_prob = 25,

  structure =
  {
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11^^",
    "....","1111",
    "....","1111",
    "11xx","11xx",
  },
},

GROW_INTO_CLIFF_INVERSE =
{
  prob = 20,
  skip_prob = 25,

  structure =
  {
    "....","1111",
    "....","1111",
    "....","11vv",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "11xx","11xx",
  },
},

GROW_INTO_CLIFF_LONG =
{
  prob = 20,
  skip_prob = 25,

  structure =
  {
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11^^",
    "....","1111",
    "11xx","11xx",
  },
},

GROW_INTO_CLIFF_LONG_INVERSE =
{
  prob = 20,
  skip_prob = 25,

  structure =
  {
    "....","1111",
    "....","1111",
    "....","11vv",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "11xx","11xx",
  },
},

GROW_INTO_CLIFF_CURVE =
{
  prob = 35,
  skip_prob = 15,

  structure =
  {
    "......","/11111",
    "......","111111",
    "......","11/AAA",
    "......","11AAAA",
    "......","11AAxx",
    "......","11AAxx",
    "......","11^^xx",
    "......","1111xx",
    "11xxxx","11xxxx",
  },

  diagonals =
  {
    ".1","1A",
  },
},

GROW_INTO_CLIFF_CURVE =
{
  prob = 35,
  skip_prob = 15,

  structure =
  {
    "......","AAAAA%",
    "......","AAAAAA",
    "......","111%AA",
    "......","1111AA",
    "......","1111^^",
    "......","111111",
    "xxxx11","xxxx11",
  },

  diagonals =
  {
    "A.","1A",
  },
},

GROW_JAGGED_LIQUID =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "11xxx","11xxx",
    ".....","11~~~",
    ".....","11%~~",
    ".....","11/~~",
    ".....","11~~~",
    ".....","11%~~",
    ".....","11/~~",
    ".....","11~~~"
  },

  diagonals =
  {
    "1~",
    "1~",
    "1~",
    "1~"
  }
},

GROW_JAGGED_LIQUID_STEEPNESS =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "11xxx","11xxx",
    ".....","vv~~~",
    ".....","AA%~~",
    ".....","AA/~~",
    ".....","AA~~~",
    ".....","AA%~~",
    ".....","AA/~~",
    ".....","AA~~~"
  },

  diagonals =
  {
    "A~",
    "A~",
    "A~",
    "A~"
  }
},

GROW_JAGGED_LIQUID_EXTENDED =
{
  prob = 20,
  skip_prob = 80,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11~~~~",
    "......","111%~~",
    "......","111/~~",
    "......","11~~~~",
    "......","111%~~",
    "......","111/~~",
    "......","11~~~~"
  },

  diagonals =
  {
    "1~",
    "1~",
    "1~",
    "1~"
  }
},

GROW_JAGGED_LIQUID_3X =
{
  prob = 25,
  skip_prob = 80,

  structure =
  {
    "11xxx","11xxx",
    ".....","11~~~",
    ".....","11%~~",
    ".....","11/~~",
    ".....","11%~~",
    ".....","11/~~",
    ".....","11%~~",
    ".....","11/~~",
    ".....","11~~~"
  },

  diagonals =
  {
    "1~",
    "1~",
    "1~",
    "1~",
    "1~",
    "1~"
  }
},

GROW_JAGGED_LIQUID_3X_STEEPNESS =
{
  prob = 25,
  skip_prob = 80,

  structure =
  {
    "11xxx","11xxx",
    ".....","vv~~~",
    ".....","AA~~~",
    ".....","AA%~~",
    ".....","AA/~~",
    ".....","AA%~~",
    ".....","AA/~~",
    ".....","AA%~~",
    ".....","AA/~~",
    ".....","AA~~~"
  },

  diagonals =
  {
    "A~",
    "A~",
    "A~",
    "A~",
    "A~",
    "A~"
  }
},

-- x4,

GROW_CLIFF_ENTRY_X4 =
{
  prob = 50,
  skip_prob = 25,

  structure =
  {
    "........","1111AAAA",
    "........","1111AAAA",
    "........","11111^^1",
    "11......","11111111",
    "11......","11111111",
  },
},

GROW_CLIFF_STRAIGHT_X4 =
{
  prob = 50,
  skip_prob = 25,

  structure =
  {
    "....","AAAA",
    "....","AAAA",
    "....","^^^^",
    "1111","1111",
  },
},

GROW_CLIFF_DOUBLE_HOOK_X2_1 =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "....","AAAA",
    "....","AAAA",
    "....","^^AA",
    "....","^^AA",
    "....","11^^",
    "....","11^^",
    "....","1111",
    "....","1111",
    "xx11","xx11",
  }
},

GROW_CLIFF_DOUBLE_HOOK_X2_1_LIQUID =
{
  prob = 12,
  skip_prob = 75,

  structure =
  {
    ".....","AAAAA",
    ".....","AAAAA",
    ".....","^^~AA",
    ".....","^^~AA",
    ".....","11~^^",
    ".....","11~^^",
    ".....","11111",
    ".....","11111",
    "xxx11","xxx11",
  }
},

GROW_CLIFF_DOUBLE_TRIDENT =
{
  prob = 20,
  skip_prob = 50,

  structure =
  {
    "......","AAAAAA",
    "......","AAAAAA",
    "......","^^AA^^",
    "......","^^AA^^",
    "......","11^^11",
    "......","11^^11",
    "......","111111",
    "......","111111",
    "xx11xx","xx11xx",
  }
},

GROW_CLIFF_DOUBLE_HOOK_X2_2 =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    ".....","AAAAA",
    ".....","AAAAA",
    ".....","^^~AA",
    ".....","^^~AA",
    ".....","11#AA",
    ".....","11~AA",
    ".....","11~AA",
    ".....","11#AA",
    ".....","11~^^",
    ".....","11~^^",
    ".....","11111",
    ".....","11111",
    "xxx11","xxx11",
  }
},

GROW_CLIFF_DOUBLE_HOOK_X2_2_LIQUID =
{
  prob = 35,
  skip_prob = 75,

  structure =
  {
    "....","AAAA",
    "....","AAAA",
    "....","^^AA",
    "....","^^AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11AA",
    "....","11^^",
    "....","11^^",
    "....","1111",
    "....","1111",
    "xx11","xx11",
  }
},

GROW_CLIFF_DOUBLE_TRIDENT_X2 =
{
  prob = 35,
  skip_prob = 75,

  structure =
  {
    "......","AAAAAA",
    "......","AAAAAA",
    "......","^^AA^^",
    "......","^^AA^^",
    "......","11AA11",
    "......","11AA11",
    "......","11AA11",
    "......","11AA11",
    "......","11^^11",
    "......","11^^11",
    "......","111111",
    "......","111111",
    "xx11xx","xx11xx",
  }
},

GROW_CLIFF_DOUBLE_TRIDENT_X2_LIQUID =
{
  prob = 25,
  skip_prob = 75,

  structure =
  {
    "........","AAAAAAAA",
    "........","AAAAAAAA",
    "........","^^~AA~^^",
    "........","^^~AA~^^",
    "........","11~AA~11",
    "........","11~AA~11",
    "........","11~AA~11",
    "........","11~AA~11",
    "........","11~^^~11",
    "........","11~^^~11",
    "........","11111111",
    "........","11111111",
    "xxx11xxx","xxx11xxx",
  }
},

-- cliff-side/area-to-area cages

DECORATE_CLIFF_CAGE_2X_ROW =
{
  prob = 8,
  skip_prob = 80,

  structure =
  {
    "x11x","x11x",
    "1111","1111",
    "1111","1CC1",
    "2222","2222",
    "x22x","x22x",
  },

  cage_mode = "fancy",
},

DECORATE_CLIFF_CAGE_3X_ROW =
{
  prob = 8,
  skip_prob = 80,

  structure =
  {
    "x111x","x111x",
    "11111","11111",
    "11111","1CCC1",
    "22222","22222",
    "x222x","x222x"
  },

  cage_mode = "fancy",
},

DECORATE_CLIFF_CAGE_3X_STAGGERED =
{
  prob = 3,
  skip_prob = 80,

  structure =
  {
    "x11111x","x11111x",
    "1111111","1111111",
    "1111111","1C1C1C1",
    "2222222","2222222",
    "x22222x","x22222x"
  },

  cage_mode = "fancy",
},

-- MSSP's liquid placer [LIQUID-CLIFF]

GROW_LIQUID_POOL_PLACE_3x3 =
{
  prob = 15,
  skip_prob = 25,

  structure =
  {
    "x......","x111111",
    "1......","11/~%11",
    "1......","11~~~11",
    "x......","x1%~/11",
    "x......","x111111",
  },

  diagonals =
  {
    "1~","~1",
    "1~","~1",
  },
},

GROW_LIQUID_POOL_PLACE_3x3_NEW_AREA =
{
  prob = 15,
  skip_prob = 25,

  structure =
  {
    "x......","xAAAAAA",
    "x......","x111%AA",
    "x......","x111111",
    "1......","11/~%11",
    "1......","11~~~11",
    "x......","x1%~/11",
    "x......","x111111",
    "x......","x111/AA",
    "x......","xAAAAAA",
  },

  diagonals =
  {
      "1A",
    "1~","~1",
    "1~","~1",
      "1A",
  },
},

GROW_LIQUID_POOL_PLACE_3x3_STAIRS =
{
  prob = 5,
  skip_prob = 50,

  structure =
  {
    "x......","x11>AAA",
    "1......","11/~%AA",
    "1......","11~~~AA",
    "x......","x1%~/AA",
    "x......","x11>AAA",
  },

  diagonals =
  {
    "1~","~A",
    "1~","~A",
  },
},

GROW_LIQUID_POOL_PLACE_3x6 =
{
  prob = 15,
  skip_prob = 25,

  structure =
  {
    "x........","x11111111",
    "1........","11/~~~%11",
    "1........","11~~~~~11",
    "x........","x1%~~~/11",
    "x........","x11111111",
  },

  diagonals =
  {
    "1~","~1",
    "1~","~1",
  },
},

GROW_LIQUID_POOL_PLACE_3x6_NEW_AREA =
{
  prob = 15,
  skip_prob = 25,

  structure =
  {
    "x........","xAAAAAAAA",
    "x........","xAA/11%AA",
    "x........","x11111111",
    "1........","11/~~~%11",
    "1........","11~~~~~11",
    "x........","x1%~~~/11",
    "x........","x11111111",
    "x........","xAA%11/AA",
    "x........","xAAAAAAAA"
  },

  diagonals =
  {
    "A1","1A",
    "1~","~1",
    "1~","~1",
    "A1","1A"
  },
},

GROW_LIQUID_POOL_PLACE_3x6_STAIRS =
{
  prob = 15,
  skip_prob = 25,

  structure =
  {
    "x........","x11>>>AAA",
    "1........","11/~~~%AA",
    "1........","11~~~~~AA",
    "x........","x1%~~~/AA",
    "x........","x11>>>AAA",
  },

  diagonals =
  {
    "1~","~A",
    "1~","~A",
  },
},

GROW_LIQUID_POOL_PLACE_3x6_STAIRS_TRI =
{
  prob = 15,
  skip_prob = 25,

  structure =
  {
    "x........","x11>>>AAA",
    "1........","11/~~~%AA",
    "1........","11~~~~~AA",
    "x........","x111>>>AA",
    "x........","x1~~~~~AA",
    "x........","x1%~~~/AA",
    "x........","x11>>>AAA",
  },

  diagonals =
  {
    "1~","~A",
    "1~","~A",
  },
},

GROW_PILLAR_LEDGE_DOUBLE_OUTER =
{
  prob = 25,
  skip_prob = 50,

  structure =
  {
    ".....","AAAAA",
    ".....","AAAAA",
    ".....","^^AAA",
    ".....","11AAA",
    ".....","11#AA",
    ".....","11AAA",
    ".....","11#AA",
    ".....","11AAA",
    "11xxx","11xxx",
  },
},

GROW_PILLAR_LEDGE_DOUBLE_INNER =
{
  prob = 25,
  skip_prob = 50,

  structure =
  {
    ".....","AAAAA",
    ".....","AAAAA",
    ".....","^^AAA",
    ".....","11%AA",
    ".....","11#AA",
    ".....","111AA",
    ".....","11#AA",
    ".....","111AA",
    "11.xx","111xx",
  },

  diagonals =
  {
    "1A"
  }
},

GROW_LIQUID_PILLAR =
{
  prob = 25,
  skip_prob = 50,

  structure =
  {
    "....","11~~",
    "....","11~~",
    "....","11#~",
    "....","11~~",
    "11xx","11xx",
  },
},

GROW_LIQUID_PILLAR_INWARD =
{
  prob = 25,
  skip_prob = 50,

  structure =
  {
    "....","11~~",
    "....","11~~",
    "....","AA#~",
    "....","11~~",
    "11xx","11xx",
  },
},

GROW_LIQUID_PILLAR_INWARD =
{
  prob = 20,
  skip_prob = 50,

  structure =
  {
    "....","11~~",
    "....","11~~",
    "....","AA.~",
    "....","11~~",
    "....","AA.~",
    "....","11~~",
    "11xx","11xx",
  },
},

-- MSSP's single-seed trenches. [TRENCHES]

GROW_TRENCH_STRAIGHT =
{
  prob = 50,
  skip_prob = 40,

  structure =
  {
    "1......","11111AA",
    "1......","11>>AAA",
    "1......","11111AA",
  },
},

GROW_TRENCH_STRAIGHT_LONG =
{
  prob = 30,
  skip_prob = 40,

  structure =
  {
    "1.........","11111111AA",
    "1.........","11>>AAAAAA",
    "1.........","11111111AA",
  },
},

GROW_TRENCH_CURVE =
{
  prob = 15,
  skip_prob = 70,

  aversion = 10,

  structure =
  {
    "xxx...","xxxAAA",
    "xxx...","xxxAAA",
    "xx....","xx11A1",
    "1.....","111/A1",
    "1.....","1>AA/1",
    "1.....","111111",
  },

  diagonals =
  {
    "1A",
    "A1",
  },
},

GROW_TRENCH_CURVE_INNER_SOLID =
{
  prob = 15,
  skip_prob = 70,

  aversion = 6,

  structure =
  {
    "xxxx..","xxxxAA",
    "xxxx..","xxxxAA",
    "xxxx..","xxxxA1",
    "xxx...","xxx/A1",
    "1.....","1>AA/1",
    "1.....","111111",
  },

  diagonals =
  {
    ".A",
    "A1",
  },
},

GROW_TRENCH_CURVE_INNER_SOLID_RING =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xxxxx..","xxxxxAA",
    "xx.....","xx/AAAA",
    "xx.....","xxA/#A1",
    "xx.....","xxA#/A1",
    "1......","1>AAA/1",
    "1......","1111111",
  },

  diagonals =
  {
    ".A",
    "A.",
         ".A",
    "A1",
  },
},

GROW_TRENCH_CURVE_INNER_SOLID_RING_LIQUID =
{
  prob = 30,
  skip_prob = 80,

  structure =
  {
    "x.......","x~~~~~AA",
    "x.......","x~~/AAAA",
    "x.......","x~~A/#A~",
    "x.......","x~~A#/A~",
    "1.......","11>AAA/~",
    "1.......","11~~~~~~",
  },

  diagonals =
  {
    "~A",
    "A.",
         ".A",
    "A~",
  },
},

GROW_TRENCH_CURVE_OUTER_SOLID =
{
  prob = 15,
  skip_prob = 70,

  aversion = 6,

  structure =
  {
    "xxx...","xxx11A",
    "x.....","x/111A",
    "x.....","x1/#1A",
    "x.....","x1#/1A",
    "1.....","1111/A",
    "1.....","1>AAA/",
  },

  diagonals =
  {
    ".1",
    "1.",
         ".1",
    "1A",
    "A.",
  },
},

GROW_TRENCH_CURVE_OUTER_SOLID_LIQUID =
{
  prob = 25,
  skip_prob = 80,

  aversion = 6,

  structure =
  {
    "xxxx..","xxxxAA",
    "x.....","x/~~~A",
    "x.....","x~/#~A",
    "x.....","x~#/~A",
    "1.....","1~~~/A",
    "1.....","1>AAA/",
  },

  diagonals =
  {
    ".~",
    "~.",
         ".~",
    "~A",
    "A.",
  },
},

GROW_TRENCH_CURVE_OUTER_SOLID_RING =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "xxx..","xxxAA",
    "xxx..","xxxAA",
    "xx...","xx11A",
    "1....","111/A",
    "1....","1>AA/",
  },

  diagonals =
  {
    "1A",
    "A.",
  },
},

GROW_TRENCH_CURVE_OUTER_SOLID_RING_LIQUID =
{
  prob = 30,
  skip_prob = 80,

  structure =
  {
    "x....","x~~AA",
    "x....","x~~AA",
    "x....","x~/1A",
    "1....","111/A",
    "1....","1>AA/",
  },

  diagonals =
  {
    "~1",
    "1A",
    "A."
  },
},

-- MSSP's sewers [SEWER]

GROW_SEWER_ENTRY =
{
  prob = 25,
  skip_prob = 25,

  group = "sewer",

  structure =
  {
    "......","111111",
    "......","111111",
    "......","~~~~~1",
    "1.....","111111",
    "1.....","111111",
  },
},

GROW_SEWER_STAIRS =
{
  prob = 30,
  skip_prob = 25,

  group = "sewer",

  structure =
  {
    "......","111>AA",
    "......","111>AA",
    "......","~~~~~A",
    "1.....","111>AA",
    "1.....","111>AA",
  },
},

GROW_SEWER_SWERVE =
{
  prob = 35,
  skip_prob = 10,

  group = "sewer",

  structure =
  {
    "1....x","1111%x",
    "1.....","111111",
    "......","~~~%11",
    "......","11%~~1",
    "......","111111",
    "x.....","x%1111",
  },

  diagonals =
  {
    "1.",
    "~1",
    "1~",
    ".1",
  },
},

GROW_SEWER_CURVED =
{
  prob = 20,
  skip_prob = 10,

  group = "sewer",

  structure =
  {
    "1.....","11111%",
    "1.....","111111",
    "......","~~~%11",
    "......","11%~11",
    "......","111~11",
    "x.....","x11111",
  },

  diagonals =
  {
    "1.",
    "~1",
    "1~",
  },
},

-- crappy rule
--[[GROW_SEWER_CROSSING = 
{
  prob = 25,
  skip_prob = 75,

  group = "sewer",

  structure =
  {
    ".....","11~11",
    ".....","11~11",
    ".....","~~~~~",
    "1....","11~11",
    "1....","11~11",
  },
},]]

GROW_SEWER_CROSSING_CIRCLE_NEW_AREA =
{
  prob = 20,
  skip_prob = 75,

  structure =
  {
    "11xxx","11xxx",
    ".....","11~11",
    ".....","1/A%1",
    ".....","~AAA~",
    ".....","1%A/1",
    ".....","11~11"
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1"
  }
},

GROW_SEWER_CROSSING_CIRCLE_NEW_AREA_BIG =
{
  prob = 17,
  skip_prob = 80,

  structure =
  {
    "11xxxx","11xxxx",
    "......","11~~11",
    "......","1/AA%1",
    "......","~AAAA~",
    "......","~AAAA~",
    "......","1%AA/1",
    "......","11~~11"
  },

  diagonals =
  {
    "1A","A1",
    "1A","A1"
  }
},

GROW_SEWER_CROSSING_CIRCLE_NEW_AREA_BIG =
{
  prob = 17,
  skip_prob = 80,

  structure =
  {
    "11xxxxx","11xxxxx",
    ".......","11~~~11",
    ".......","1/A~A%1",
    ".......","~AA~AA~",
    ".......","~%AAA/~",
    ".......","~/AAA%~",
    ".......","~AA~AA~",
    ".......","1%A~A/1",
    ".......","11~~~11",
    ".......","11~~~11"
  },

  diagonals =
  {
    "1A","A1",
    "~A","A~",
    "~A","A~",
    "1A","A1"
  }
},

GROW_SEWER_STAIRS_SIDE_EXIT_NEW_AREA =
{
  prob = 35,
  skip_prob = 20,

  structure =
  {
    "xxxx..x","xxxxAAx",
    "1......","11>>AA1",
    "1......","11>>AA1",
    ".......","1~~~~~1",
    ".......","1111111",
    ".......","1111111",
  },
},

-- new stuff, organize later?

GROW_PLUS_SINGLE_STAIR =
{
  prob = 40,
  skip_prob = 80,

  structure =
  {
    "..........","AAAAAAAAAA",
    "..........","AAAAAAAAAA",
    "..........","AA/#11#%AA",
    "..........","AA##11##AA",
    "..........","AA<11111AA",
    "..........","AA<11111AA",
    "..........","AA##11##AA",
    "..........","AA##11##AA",
    "xxxx11xxxx","xxxx11xxxx"
  },

  diagonals =
  {
    "A.",".A"
  }
},

GROW_PLUS_SINGLE_STAIR_OPPOSITE =
{
  prob = 40,
  skip_prob = 80,

  structure =
  {
    "x..........","x1111111111",
    "x..........","x1111111111",
    "x..........","x11/#AA#%11",
    "x..........","x11##AA##11",
    "x..........","x11>AAAAA11",
    "x..........","x11>AAAAA11",
    "1..........","111##AA##11",
    "1..........","111##AA##11",
    "xxxxx..xxxx","xxxxxAAxxxx"
  },

  diagonals =
  {
    "1.",".1"
  }
},

GROW_PLUS_SINGLE_STAIR_OPPOSITE_DOUBLE =
{
  prob = 40,
  skip_prob = 80,

  structure =
  {
    "x..........","x1111AA1111",
    "x..........","x1111AA1111",
    "x..........","x11/#AA#%11",
    "x..........","x11##AA##11",
    "x..........","x11>AAAA<11",
    "x..........","x11>AAAA<11",
    "1..........","111##AA##11",
    "1..........","111##AA##11",
    "xxxxx..xxxx","xxxxxAAxxxx"
  },

  diagonals =
  {
    "1.",".1"
  }
},

GROW_FANBLADE =
{
  prob = 20,
  skip_prob = 85,

  structure =
  {
    "xxxx11xxx","xxxx11xxx",
    "xxxx...xx","xxxx111xx",
    "xxxx...xx","xxxx111xx",
    "...x...xx","11%x11/xx",
    ".........","111111111",
    ".........","111111111",
    "xxx..x...","xxx11x%11",
    "xx...xxxx","xx/11xxxx",
    "xx...xxxx","xx111xxxx",
    "xx...xxxx","xx111xxxx"
  },

  diagonals =
  {
    "1.","1.",
    ".1",".1"
  }
},

GROW_FANBLADE_NEWAREA =
{
  prob = 17,
  skip_prob = 85,

  structure =
  {
    "xxxx11xxx","xxxx11xxx",
    "xxxx...xx","xxxx111xx",
    "xxxx...xx","xxxx111xx",
    "...x...xx","AA%x11/xx",
    ".........","AAA111AAA",
    ".........","AAA111AAA",
    "xxx..x...","xxxAAx%AA",
    "xx...xxxx","xx/AAxxxx",
    "xx...xxxx","xxAAAxxxx",
    "xx...xxxx","xxAAAxxxx"
  },

  diagonals =
  {
    "A.","1.",
    ".A",".A"
  }
},

-- Compound grow rules with auxiliaries

GROW_SPIRAL_STAIR_SMALL =
{
  prob = 10,
  skip_prob = 50,

  structure =
  {
    "1......","111>>A%",
    "1......","11111%A",
    "x.....x","x11111x",
    "x.....x","x11111x"
  },

  diagonals =
  {
    "A.",
    "1A",
  },

  auxiliary =
  {
    pass = "grow_spiral_stair_small_step_2"
  }
},

GROW_SPIRAL_STAIR_SMALL_STEP_2 =
{
  prob = 10,

  pass = "grow_spiral_stair_small_step_2",
  
  structure =
  {
    "1x","1x",
    "x1","x1",
    "2.","2v",
    "2.","2v",
    "..","/A",
    "..","A/"
  },

  diagonals =
  {
    "2A",
    "A."
  },

  auxiliary =
  {
    pass = "grow_spiral_stair_small_step_3",
  }
},

GROW_SPIRAL_STAIR_SMALL_STEP_3 =
{
  prob = 10,

  pass = "grow_spiral_stair_small_step_3",

  structure =
  {
    "..22x1","A%22x1",
    "....1x","AA<<1x"
  },

  diagonals =
  {
    "A2",
  }
},

GROW_SPIRAL_STAIR =
{
  prob = 40,
  skip_prob = 50,

  structure =
  {
    "1.....","11>>A%",
    "1.....","11>>AA",
    "x...xx","x111xx",
    "x...xx","x111xx"
  },

  diagonals =
  {
    "A."
  },

  auxiliary =
  {
    pass = "grow_spiral_stair_2",
  }
},

GROW_SPIRAL_STAIR_DOUBLE =
{
  prob = 40,
  skip_prob = 50,

  structure =
  {
    "x...xx","x111xx",
    "x...xx","x111xx",
    "1.....","11>>AA",
    "1.....","11>>AA",
    "x...xx","x111xx",
    "x...xx","x111xx"
  },

  diagonals =
  {
    "A."
  },

  auxiliary =
  {
    pass = "grow_spiral_stair_2",

    count = {1,2}
  }
},

GROW_SPIRAL_STAIR_STEP_2 =
{
  prob = 40,

  pass = "grow_spiral_stair_2",

  structure =
  {
    "xx1x","xx1x",
    "xx11","xx11",
    "22..","22vv",
    "22..","22vv",
    "xx..","xxAA",
    "xx..","xxA/"
  },

  diagonals =
  {
    "A."
  },

  auxiliary =
  {
    pass = "grow_spiral_stair_3",
  }
},

GROW_SPIRAL_STAIR_STEP_3 =
{
  prob = 40,

  pass = "grow_spiral_stair_3",

  structure =
  {
    "xx22xx","xx22xx",
    "xx22xx","xx22xx",
    "....11","AA<<11",
    "....1x","AA<<1x"
  },
},

-- END OF GROW RULES

-- FORGET IT LMAO IT DOESN'T WORK
-- It works now. Cheer up, buddy. -- March, 2019,
-- MSSP's city streets. ExperiMENTAL. [STREETS]

STREETS_ENTRY_RSVOL_4 =
{
  prob = 5,

  pass = "streets_entry_4",

  structure =
  {
    "....","1111",
    "....","1111",
    "11..","1111",
    "11..","1111",
    "....","1111",
  },
},

STREETS_ENTRY_RSVOL_6 =
{
  prob = 5,

  pass = "streets_entry_6",

  structure =
  {
    "....","1111",
    "11..","1111",
    "11..","1111",
    "11..","1111",
    "....","1111",
  },
},

STREETS_ENTRY_RSVOL_8 =
{
  prob = 5,

  pass = "streets_entry_8",

  structure =
  {
    "....","1111",
    "11..","1111",
    "11..","1111",
    "11..","1111",
    "11..","1111",
    "....","1111",
  },
},

STREETS_STRAIGHT =
{
  prob = 100,

  pass = "streets",

  structure =
  {
    ".1111.",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
  },
},

STREETS_STRAIGHT_LONG =
{
  prob = 50,

  pass = "streets",

  structure =
  {
    ".1111.",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
  },

},

STREETS_BLOCK =
{
  prob = 25,

  pass = "streets",

  structure =
  {
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "1.........................","11111111111111111111111111",
    "1.........................","11111111111111111111111111",
    "1.........................","11111111111111111111111111",
    "1.........................","11111111111111111111111111",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................","11111111111111111111111111",
    "..........................","11111111111111111111111111",
    "..........................","11111111111111111111111111",
    "..........................","11111111111111111111111111",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
  },
},

STREETS_INTERSECTION =
{
  prob = 15,

  pass = "streets",

  structure =
  {
    "......",".1111.",
    "......",".1111.",
    "1.....","111111",
    "1.....","111111",
    "1.....","111111",
    "1.....","111111",
    "......",".1111.",
    "......",".1111.",
  },
},

STREETS_T_JUNCTION =
{
  prob = 25,

  pass = "streets",

  structure =
  {
    ".....",".1111",
    ".....",".1111",
    "1....","11111",
    "1....","11111",
    "1....","11111",
    "1....","11111",
    ".....",".1111",
    ".....",".1111",
  },
},

STREETS_CURVE =
{
  prob = 15,

  pass = "streets",

  structure =
  {
    ".1111....",".1111....",
    ".........",".1111%...",
    ".........",".11111111",
    ".........",".11111111",
    ".........",".11111111",
    ".........",".%1111111",
  },

  diagonals =
  {
    "1.",
    ".1",
  },
},

-- MSSP's sidewalks

SIDEWALK_STRAIGHT =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "....","AAAA",
    "....","AAAA",
    "1111","1111",
  },
},

SIDEWALK_STRAIGHT_INWARD =
{
  prob = 35,

  pass = "sidewalk",

  structure =
  {
    "1........","1AAAAAAAA",
    "1........","1AAAAAAAA",
  },
},

SIDEWALK_4X4 =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "11..","11AA",
    "11..","11AA",
    "....","AAAA",
    "....","AAAA",
  },
},

SIDEWALK_STRAIGHT_INWARD_ANGLED =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "1......","1AAAAAA",
    "1......","1AAAAAA",
    "1xxxx..","1xxxxAA",
    "1xxxx..","1xxxxAA",
    "1xxxx..","1xxxxAA",
    "1xxxx..","1xxxxAA",
  },
},

SIDEWALK_STRAIGHT_LARGE =
{
  prob = 50,

  pass = "sidewalk",

  structure =
  {
    "........","AAAAAAAA",
    "........","AAAAAAAA",
    "11111111","11111111",
  },
},

SIDEWALK_STRAIGHT_LARGE_CHAMFERED =
{
  prob = 15,

  pass = "sidewalk",

  structure =
  {
    "........","/AAAAAA%",
    "........","AAAAAAAA",
    "11111111","11111111",
  },

  diagonals =
  {
    ".A","A.",
  },
},

SIDEWALK_INTERSECTION_SIDE =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "1....","1AAA%",
    "1....","1AAAA",
    "1....","1AAAA",
    "1%...","1%AAA",
    "11111","11111",
  },

  diagonals =
  {
    "A.",
    "1.","1A",
  },
},

SIDEWALK_OUTER_CORNER =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "xx....","xxAAAA",
    "xx....","xxAAAA",
    "x11%..","x11%AA",
    "1111xx","1111xx",
    "111xxx","111xxx",
  },

  diagonals =
  {
    "1.","1A",
  },
},

SIDEWALK_EXTEND_SIDEWAYS =
{
  prob = 250,

  pass = "sidewalk",

  structure =
  {
    "2..","222",
    "2..","222",
    "111","111",
    "111","111",
  },
},

SIDEWALK_FILL_2X =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "2..2","2222",
    "2..2","2222",
    "x11x","x11x",
    "1111","1111",
  },
},

SIDEWALK_SLOPE_SIDE_SMOL =
{
  prob = 15,
  skip_prob = 40,

  pass = "sidewalk",

  structure =
  {
    "11..","11AA",
    "11..","11AA",
    "11..","11AA",
    "11..","11>A",
  },
},

SIDEWALK_SLOPE_SIDE_NEAR =
{
  prob = 15,
  skip_prob = 40,

  pass = "sidewalk",

  structure =
  {
    "11....","11AAAA",
    "11....","11>>AA",
    "11....","11>>AA",
    "11....","11AAAA",
  },
},

SIDEWALK_SLOPE_SIDE_FAR =
{
  prob = 10,
  skip_prob = 40,

  pass = "sidewalk",

  structure =
  {
    "11xx..","11xxAA",
    "11....","11>>AA",
    "11....","11>>AA",
    "11xx..","11xxAA",
  },
},

SIDEWALK_SLOPE_ON_RAMP =
{
  prob = 10,

  pass = "sidewalk",

  structure =
  {
    "11x..","11xAA",
    "11...","11>AA",
    "11...","11>AA",
    "11...","11>AA",
    "11...","11>AA",
    "11x..","11xAA",
  },
},

SIDEWALK_SLOPE_ON_RAMP_DOUBLE =
{
  prob = 10,

  pass = "sidewalk",

  structure =
  {
    "11x..","11xAA",
    "11...","11>AA",
    "11...","11>AA",
    "111..","111AA",
    "111..","111AA",
    "11...","11>AA",
    "11...","11>AA",
    "11x..","11xAA",
  },
},

SIDEWALK_PLAIN_STAIR =
{
  prob = 10,

  pass = "sidewalk",

  structure =
  {
    "..","AA",
    "..","AA",
    "..","^^",
    "11","11",
    "11","11",
  },
},

SIDEWALK_STAIR_Y_IN =
{
  prob = 10,

  pass = "sidewalk",

  structure =
  {
    ".....","..AAA",
    ".....","1>AAA",
    ".....","11%AA",
    "11...","111^.",
    "11...","1111.",
  },

  diagonals =
  {
    "1A",
  },
},

SIDEWALK_STAIR_Y_OUT =
{
  prob = 15,

  pass = "sidewalk",

  structure =
  {
    "......","AAAAAA",
    "......","AAAAAA",
    "......","11>>AA",
    "......","1111AA",
    "11....","1111AA",
    "11....","1111AA",
  },
},

SIDEWALK_BUILDING_4x4 =
{
  prob = 15,

  pass = "sidewalk",

  structure =
  {
    "11......","11AAAAAA",
    "11......","11AAAAAA",
    "........","AA....AA",
    "........","AA....AA",
    "........","AA....AA",
    "........","AA....AA",
    "........","AAAAAAAA",
    "........","AAAAAAAA",
  },
},

SIDEWALK_BUILDING_L =
{
  prob = 15,

  pass = "sidewalk",

  structure =
  {
    "11........","11AAAAAAAA",
    "11........","11AAAAAAAA",
    "..........","AAAA....AA",
    "..........","AAAA....AA",
    "..........","AA......AA",
    "..........","AA......AA",
    "..........","AA......AA",
    "..........","AA......AA",
    "..........","AAAAAAAAAA",
    "..........","AAAAAAAAAA",
  },
},

SIDEWALK_OVERHANG =
{
  prob = 20,

  pass = "sidewalk",

  structure =
  {
    "11....","11AAAA",
    "11....","11AAAA",
    "xx....","xx#AA#",
  },
},

SIDEWALK_OVERHANG_CORNER =
{
  prob = 20,

  pass = "sidewalk",

  structure =
  {
    "xx...","xxAAA",
    "11...","11AAA",
    "11...","11#AA",
  },
},

SIDEWALK_CURVE =
{
  prob = 20,

  pass = "sidewalk",

  structure =
  {
    "1...x","1AA%x",
    "1....","1AAA%",
    "xx...","xx%AA",
    "xxx..","xxxAA",
  },

  diagonals =
  {
    "A.",
      "A.",
    ".A",
  },
},

SIDEWALK_ZIGZAG =
{
  prob = 20,

  pass = "sidewalk",

  structure =
  {
    "1...xx","1AA%xx",
    "1....x","1AAA%x",
    "xx....","xx%AAA",
    "xxx...","xxx%AA",
  },

  diagonals =
  {
    "A.",
      "A.",
    ".A",
      ".A",
  },
},

SIDEWALK_LIQUID =
{
  prob = 50,

  pass = "sidewalk",

  structure =
  {
    "........","AA~~~~AA",
    "11111111","11111111",
  },
},

SIDEWALK_LIQUID_POOL_LONG =
{
  prob = 50,

  pass = "sidewalk",

  structure =
  {
    "......","AA~~~~",
    "......","AA~~~~",
    "11xxxx","11xxxx",
  },
},

SIDEWALK_LIQUID_POOL =
{
  prob = 50,

  pass = "sidewalk",

  structure =
  {
    "....","AA~~",
    "....","AA~~",
    "11xx","11xx",
  },
},

SIDEWALK_CAGE =
{
  prob = 50,

  pass = "sidewalk",

  structure =
  {
    "x..","xCC",
    "1..","1AA",
    "1..","1AA",
  },

  cage_mode = "fancy",
},

SIDEWALK_CAGE_4X =
{
  prob = 40,

  pass = "sidewalk",

  structure =
  {
    "x....","xCCCC",
    "1....","1AAAA",
    "1....","1AAAA",
  },

  cage_mode = "fancy",
},

SIDEWALK_CAGE_4X4 =
{
  prob = 35,

  pass = "sidewalk",

  structure =
  {
    "x..","xCC",
    "x..","xCC",
    "1..","1AA",
    "1..","1AA",
  },

  cage_mode = "fancy",
},

SIDEWALK_CLOSET_2X2 =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "1!!","1TT",
    "1!!","1TT",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_2X1 =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "1!","1T",
    "1!","1T",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_3X1 =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "1!","1T",
    "1!","1T",
    "1!","1T",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_3X2 =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "1!!","1TT",
    "1!!","1TT",
    "1!!","1TT",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_4X1 =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_6X1 =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_8X1 =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
  },

  closet = { from_dir=4 },
},
-- MSSP's street 'smoothers'

STREET_CORNER_FIXER =
{
  prob = 100,

  pass = "street_fixer",

  structure =
  {
    "x1111xx","x1111xx",
    "111111.","11111..",
    "111111.","11111..",
    "111111.","11111..",
    "111111.","1111/..",
    "x1111..","x......",
    "x......","x......",
  },

  diagonals =
  {
    "1.",
  },
},

STREET_T_JUNCTION_FIXER =
{
  prob = 100,

  pass = "street_fixer",

  structure =
  {
    "11111.","11111.",
    "11111!","1111/!",
    "!1111!","!....!",
    "!!!!!!","!!!!!!",
  },

  diagonals =
  {
    "1.",
  },
},

STREET_WEIRD_DEAD_BRANCH_FIXER =
{
  prob = 100,

  pass = "street_fixer",

  structure =
  {
    "111111","111111",
    ".1111.","......",
    "......","......",
  },
},

STREET_DEAD_END_FIXER =
{
  prob = 100,

  pass = "street_fixer",

  structure =
  {
    ".1111.",".1111.",
    "......",".%11/.",
  },

  diagonals =
  {
    ".1","1.",
  },
},

-- MSSP's building entrances... okay, just joiners and some such really

STREET_BUILDING_ENTRANCE =
{
  prob = 300,

  pass = "building_entrance",

  structure =
  {
    "..","RR",
    "..","RR",
    "11","11",
  },

  new_room =
  {
    env = "building",

    conn = { x=1, y=1, w=2, dir=8 },

    symmetry = { x=2, y=1, w=2, dir=8 },
  },
},

STREET_BUILDING_ENTRANCE_WITH_JOINER_2X1 =
{
  prob = 100,

  pass = "building_entrance",

  structure =
  {
    "....",".RR.",
    "....",".RR.",
    "x..x","xJJx",
    "x11x","x11x",
  },

  new_room =
  {
    symmetry = { x=3, y=2, w=2, dir=8 },
  },

  joiner =
  {
    from_dir = 2,
  },
},

STREET_BUILDING_ENTRANCE_WITH_JOINER_2X2 =
{
  prob = 100,

  pass = "building_entrance",

  structure =
  {
    "....",".RR.",
    "....",".RR.",
    "x..x","xJJx",
    "x..x","xJJx",
    "x11x","x11x",
  },

  new_room =
  {
    symmetry = { x=2, y=3, w=2, dir=8 },
  },

  joiner =
  {
    from_dir = 2,
  },
},

STREET_BUILDING_ENTRANCE_WITH_JOINER_3X2 =
{
  prob = 100,

  pass = "building_entrance",

  structure =
  {
    ".....",".RRR.",
    ".....",".RRR.",
    "x...x","xJJJx",
    "x...x","xJJJx",
    "x111x","x111x",
  },

  new_room =
  {
    symmetry = { x=3, y=3, w=2, dir=8 },
  },

  joiner =
  {
    from_dir = 2,
  },
}

}

SHAPES.BOXES_OF_DEATH =
{

ROOT_1 =
{
  prob = 10000,

  structure =
  {
    "!!!!!!!", ".......",
    "!!!!!!!", ".RRRRR.",
    "!!!!!!!", ".RRRRR.",
    "!!!!!!!", ".RRRRR.",
    "!!!!!!!", ".RRRRR.",
    "!!!!!!!", ".RRRRR.",
	  "!!!!!!!", ".......",
  },

},

-----------------------------------------

GROW_1 =
{
  prob = 20000, --Non-MSSP default: 100,

  base_set = true,

  structure =
  {
    ".", ".",
    "1", "1",
  },
},

------------------------------------------

SPROUT_DIRECT_1 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=3, y=1, w=3, dir=8 },
  },
  
},

SPROUT_DIRECT_2 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".#RRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=3, y=1, w=3, dir=8 },
  },
  
},

SPROUT_DIRECT_3 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RR#RR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=3, y=1, w=3, dir=8 },
  },
  
},

SPROUT_DIRECT_4 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RR#RR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RR#RR.",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=5, y=1, w=2, dir=8 },
  },
  
},

SPROUT_DIRECT_5 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".#1111.", ".#1111.",
  },
  
  new_room =
  {
    conn = { x=3, y=1, w=3, dir=8 },
  },
  
},

SPROUT_DIRECT_6 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".11#11.", ".11#11.",
  },
  
  new_room =
  {
    conn = { x=2, y=1, w=2, dir=8 },
  },
  
},

SPROUT_JOINER_1 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "..JJJ..",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=3, y=2, w=3, dir=8 },
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_2 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,
  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "...JJ..",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=4, y=2, w=2, dir=8 },
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_3 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "..JJ...",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=3, y=2, w=2, dir=8 },
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_4 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "..JJJ..",
    ".#1111.", ".#1111.",
  },
  
  new_room =
  {
    conn = { x=3, y=2, w=3, dir=8 },
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_5 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "...JJ..",
    ".#1111.", ".#1111.",
  },
  
  new_room =
  {
    conn = { x=4, y=2, w=2, dir=8 },
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_6 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "..JJ...",
    ".#1111.", ".#1111.",
  },
  
  new_room =
  {
    conn = { x=3, y=2, w=2, dir=8 },
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_7 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".JJ....",
    ".11#11.", ".11#11.",
  },
  
  new_room =
  {
    conn = { x=2, y=2, w=2, dir=8 },
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_TELEPORTER_2x2 =
{
  prob = 7000,

  structure =
  {
    "..", "TT",
    "..", "TT",
    "11", "11",
    "11", "11",
  },

  teleporter = true,

  closet =
  {
    from_dir = 2,
  },
},

SPROUT_TELEPORTER_2x2_EMERGENCY =
{
  prob = 7000,

  structure =
  {
    "..", "TT",
    "..", "TT",
    "11", "11",
    "11", "11",
  },

  emergency = true,

  teleporter = true,

  closet =
  {
    from_dir = 2,
  },
},

SPROUT_TELEPORTER_1x1 =
{
  prob = 7000,

  structure =
  {
    ".", "T",
    "1", "1",
  },

  teleporter = true,

  closet =
  {
    from_dir = 2,
  },
},

SPROUT_TELEPORTER_1x1_EMERGENCY =
{
  prob = 7000,

  structure =
  {
    ".", "T",
    "1", "1",
  },

  emergency = true,

  teleporter = true,

  closet =
  {
    from_dir = 2,
  },
},

SQUARE_OUT_1 =
{
  pass = "square_out",

  prob = 20000,

  structure =
  {
    ".",".",
    "1","1",
  },
},

SQUARE_OUT_3 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1111", "x1111",
    "11111", "11v11",
    "11111", "1>A<1",
    "11111", "11^11",
    "11111", "11111",
  },
},

SQUARE_OUT_4 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1x11", "x1x11",
    "11111", "11111",
    "11111", "1vvv1",
    "11111", "AAAAA",
    "11111", "AAAAA",
  },
},

SQUARE_OUT_5 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1x11", "x1x11",
    "11111", "11111",
    "11111", "11v11",
    "11111", "AAAAA",
    "11111", "AAAAA",
  },
},

SQUARE_OUT_6 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1x11", "x1x11",
    "11111", "11111",
    "11111", "1v1v1",
    "11111", "AAAAA",
    "11111", "AAAAA",
  },
},

SQUARE_OUT_7 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1x11", "x1x11",
    "11111", "11111",
    "11111", "1vAv1",
    "11111", "AvAvA",
    "11111", "AAAAA",
  },
},

SQUARE_OUT_8 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1x11", "x1x11",
    "11111", "1A1A1",
    "11111", "1AAA1",
    "11111", "1A1A1",
    "11x11", "11x11",
  },
},

SQUARE_OUT_9 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1x11", "x1x11",
    "11111", "11111",
    "11111", "~~~~~",
    "11111", "11111",
    "11x11", "11x11",
  },
},

SQUARE_OUT_10 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1x11", "x1x11",
    "11111", "11111",
    "11111", "11111",
    "11111", "AvvvA",
    "11111", "AAAAA",
  },
},

SQUARE_OUT_11 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1x11", "x1x11",
    "11111", "11111",
    "11111", "11111",
    "11111", "AAvAA",
    "11111", "AAAAA",
  },
},

SQUARE_OUT_12 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1111", "x1111",
    "11111", "1AAA1",
    "11111", "1AAA1",
    "11111", "1AAA1",
    "11111", "11111",
  },
},

SQUARE_OUT_13 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1111", "x1111",
    "11111", "1~~~1",
    "11111", "1~~~1",
    "11111", "1~~~1",
    "11111", "11111",
  },
},

SQUARE_OUT_14 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1111", "x1111",
    "11111", "1vvv1",
    "11111", "1AAA1",
    "11111", "1^^^1",
    "11111", "11111",
  },
},

SQUARE_OUT_15 =
{
  prob = 1000,
  pass = "square_out",

  structure =
  {
    "x1111", "x1111",
    "11111", "11111",
    "11111", "1AAA1",
    "11111", "11111",
    "11111", "11111",
  },
},

DECORATE_CLOSET_2x1 =
{
  prob = 6000, --40,
  prob_skew = 2,

  structure =
  {
    "..", "TT",
    "11", "11",
  },

  closet = { from_dir=2 },
},

FILLER_1 =
{
  pass = "filler",
  prob = 4000, --30,

  structure =
  {
    "1.", "1.",
    "1.", "11",
    "11", "11",
  },
},

SMOOTHER_1 =
{
  pass = "smoother",
  prob = 7500, --50,

  structure =
  {
    "x.", "x.",
    "1.", "1%",
    "11", "11",
  },

  diagonals = { "1." },
},

------------------------------------------
--   Landscape stuff
------------------------------------------


PARK_ROOT_5x5 =
{
  prob = 90, --50,

  structure =
  {
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
  }
},


PARK_GROW_1 =
{
  prob = 200, --100,

  structure =
  {
    ".", ".",
    "1", "1",
  }
},

------------------------------------------
--   Cave stuff
------------------------------------------

CAVE_ROOT_1 =
{
  prob = 10000,

  structure =
  {
    "!!!!!!!", ".......",
    "!!!!!!!", ".RRRRR.",
    "!!!!!!!", ".RRRRR.",
    "!!!!!!!", ".RRRRR.",
    "!!!!!!!", ".RRRRR.",
    "!!!!!!!", ".RRRRR.",
	  "!!!!!!!", ".......",
  },

},

SPROUT_DIRECT_1_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=3, y=1, w=3, dir=8 },

    env  = "cave",
  },
  
},

SPROUT_DIRECT_2_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".#RRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=3, y=1, w=3, dir=8 },

    env  = "cave",
  },
  
},

SPROUT_DIRECT_3_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RR#RR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=3, y=1, w=3, dir=8 },

    env  = "cave",
  },
  
},

SPROUT_DIRECT_4_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RR#RR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RR#RR.",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=2, y=1, w=2, dir=8 },

    env  = "cave",
  },
  
},

SPROUT_DIRECT_5_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".#1111.", ".#1111.",
  },
  
  new_room =
  {
    conn = { x=5, y=1, w=2, dir=8 },

    env  = "cave",
  },
  
},

SPROUT_DIRECT_6_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".11#11.", ".11#11.",
  },
  
  new_room =
  {
    conn = { x=2, y=1, w=2, dir=8 },

    env  = "cave",
  },
  
},

SPROUT_JOINER_1_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "..JJJ..",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=3, y=2, w=3, dir=8 },

    env  = "cave",
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_2_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "...JJ..",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=4, y=2, w=2, dir=8 },

    env  = "cave",
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_3_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "..JJ...",
    ".11111.", ".11111.",
  },
  
  new_room =
  {
    conn = { x=3, y=2, w=2, dir=8 },

    env  = "cave",
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_4_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "..JJJ..",
    ".#1111.", ".#1111.",
  },
  
  new_room =
  {
    conn = { x=3, y=2, w=3, dir=8 },

    env  = "cave",
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_5_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "...JJ..",
    ".#1111.", ".#1111.",
  },
  
  new_room =
  {
    conn = { x=4, y=2, w=2, dir=8 },

    env  = "cave",
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_6_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", "..JJ...",
    ".#1111.", ".#1111.",
  },
  
  new_room =
  {
    conn = { x=3, y=2, w=2, dir=8 },

    env  = "cave",
  },

  joiner =
  {
    from_dir = 2
  }
  
},

SPROUT_JOINER_7_cave =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".RRRRR.",
    ".......", ".JJ....",
    ".11#11.", ".11#11.",
  },
  
  new_room =
  {
    conn = { x=2, y=2, w=2, dir=8 },

    env  = "cave",
  },

  joiner =
  {
    from_dir = 2
  }
  
},

CAVE_GROW_1 =
{
  prob = 10000, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    ".", ".",
    "1", "1",
  },
},

-- V2 Hallway

SPROUT_wide_hallway =
{
  prob = 3200, --1800 --1500,
  skip_prob = 20,

  structure =
  {
    "..", "..",
    "..", "@@",
    "..", "HH",
    "11", "11",
  },

  new_room =
  {
    env = "hallway",

    conn = { x=1, y=1, w=2, dir=8 },

    hall_type = "wide",

    grow_pass = "hall_2"
  }
},


HALL_2_GROW_I1 =
{
  pass = "hall_2",
  prob = 55, --40,

  structure =
  {
    "..", "..",
    "..", "@@",
    "..", "HH",
    "@@", "HH",
    "11", "11",
  }
},


HALL_2_GROW_L1 =
{
  pass = "hall_2",
  prob = 35, --50,
  prob_skew = 2,

  structure =
  {
    "....", ".@HH",
    "..@@", ".@HH",
    "xx11", "xx11",
  },

  link2_2 = { dest_dir=4 }
},


HALL_2_GROW_T1 =
{
  pass = "hall_2",
  prob = 30, --25,
  prob_skew = 2,

  structure =
  {
    "......", ".@HH@.",
    "..@@..", ".@HH@.",
    "xx11xx", "xx11xx",
  },

  hallway = { keep_shape_prob=50 },

  link2_2 = { dest_dir=4 },
  link5_2 = { dest_dir=6 }
},


HALL_2_GROW_P1 =
{
  pass = "hall_2",
  prob = 10, --5,
  prob_skew = 2,

  structure =
  {
    "xx..xx", "xx..xx",
    "xx..xx", "xx@@xx",
    "......", ".@HH@.",
    "..@@..", ".@HH@.",
    "xx11xx", "xx11xx",
  },

  link2_2 = { dest_dir=4 },
  link5_2 = { dest_dir=6 },
  link3_4 = { dest_dir=8 }
},


HALL_2_SPROUT_A =
{
  pass = "hall_2_sprout",
  prob = 100,

  structure =
  {
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    "xx@@x", "xxHHx",
    "xx11x", "xx11x",
  },

  new_room =
  {
    conn = { x=3, y=2, w=2, dir=8 },
  }
},

HALL_2_SPROUT_B =
{
  pass = "hall_2_sprout",
  prob = 20,

  structure =
  {
    "....", "RRRR",
    "....", "RRRR",
    "....", "RRRR",
    "....", "RRRR",
    "x@@x", "xHHx",
    "x11x", "x11x",
  },

  new_room =
  {
    conn = { x=2, y=2, w=2, dir=8 },
  }
},

STREETS_ENTRY_RSVOL_4 =
{
  prob = 5,

  pass = "streets_entry_4",

  structure =
  {
    "....","1111",
    "....","1111",
    "11..","1111",
    "11..","1111",
    "....","1111",
  },
},

STREETS_ENTRY_RSVOL_6 =
{
  prob = 5,

  pass = "streets_entry_6",

  structure =
  {
    "....","1111",
    "11..","1111",
    "11..","1111",
    "11..","1111",
    "....","1111",
  },
},

STREETS_ENTRY_RSVOL_8 =
{
  prob = 5,

  pass = "streets_entry_8",

  structure =
  {
    "....","1111",
    "11..","1111",
    "11..","1111",
    "11..","1111",
    "11..","1111",
    "....","1111",
  },
},

STREETS_STRAIGHT =
{
  prob = 100,

  pass = "streets",

  structure =
  {
    ".1111.",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
  },
},

STREETS_STRAIGHT_LONG =
{
  prob = 50,

  pass = "streets",

  structure =
  {
    ".1111.",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
    "......",".1111.",
  },

},

STREETS_BLOCK =
{
  prob = 25,

  pass = "streets",

  structure =
  {
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "1.........................","11111111111111111111111111",
    "1.........................","11111111111111111111111111",
    "1.........................","11111111111111111111111111",
    "1.........................","11111111111111111111111111",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
    "..........................","11111111111111111111111111",
    "..........................","11111111111111111111111111",
    "..........................","11111111111111111111111111",
    "..........................","11111111111111111111111111",
    "..........................",".1111................1111.",
    "..........................",".1111................1111.",
  },
},

STREETS_INTERSECTION =
{
  prob = 15,

  pass = "streets",

  structure =
  {
    "......",".1111.",
    "......",".1111.",
    "1.....","111111",
    "1.....","111111",
    "1.....","111111",
    "1.....","111111",
    "......",".1111.",
    "......",".1111.",
  },
},

STREETS_T_JUNCTION =
{
  prob = 25,

  pass = "streets",

  structure =
  {
    ".....",".1111",
    ".....",".1111",
    "1....","11111",
    "1....","11111",
    "1....","11111",
    "1....","11111",
    ".....",".1111",
    ".....",".1111",
  },
},

STREETS_CURVE =
{
  prob = 15,

  pass = "streets",

  structure =
  {
    ".1111....",".1111....",
    ".........",".1111%...",
    ".........",".11111111",
    ".........",".11111111",
    ".........",".11111111",
    ".........",".%1111111",
  },

  diagonals =
  {
    "1.",
    ".1",
  },
},

-- MSSP's sidewalks

SIDEWALK_STRAIGHT =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "....","AAAA",
    "....","AAAA",
    "1111","1111",
  },
},

SIDEWALK_STRAIGHT_INWARD =
{
  prob = 35,

  pass = "sidewalk",

  structure =
  {
    "1........","1AAAAAAAA",
    "1........","1AAAAAAAA",
  },
},

SIDEWALK_4X4 =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "11..","11AA",
    "11..","11AA",
    "....","AAAA",
    "....","AAAA",
  },
},

SIDEWALK_STRAIGHT_INWARD_ANGLED =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "1......","1AAAAAA",
    "1......","1AAAAAA",
    "1xxxx..","1xxxxAA",
    "1xxxx..","1xxxxAA",
    "1xxxx..","1xxxxAA",
    "1xxxx..","1xxxxAA",
  },
},

SIDEWALK_STRAIGHT_LARGE =
{
  prob = 50,

  pass = "sidewalk",

  structure =
  {
    "........","AAAAAAAA",
    "........","AAAAAAAA",
    "11111111","11111111",
  },
},

SIDEWALK_STRAIGHT_LARGE_CHAMFERED =
{
  prob = 15,

  pass = "sidewalk",

  structure =
  {
    "........","/AAAAAA%",
    "........","AAAAAAAA",
    "11111111","11111111",
  },

  diagonals =
  {
    ".A","A.",
  },
},

SIDEWALK_INTERSECTION_SIDE =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "1....","1AAA%",
    "1....","1AAAA",
    "1....","1AAAA",
    "1%...","1%AAA",
    "11111","11111",
  },

  diagonals =
  {
    "A.",
    "1.","1A",
  },
},

SIDEWALK_OUTER_CORNER =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "xx....","xxAAAA",
    "xx....","xxAAAA",
    "x11%..","x11%AA",
    "1111xx","1111xx",
    "111xxx","111xxx",
  },

  diagonals =
  {
    "1.","1A",
  },
},

SIDEWALK_EXTEND_SIDEWAYS =
{
  prob = 250,

  pass = "sidewalk",

  structure =
  {
    "2..","222",
    "2..","222",
    "111","111",
    "111","111",
  },
},

SIDEWALK_FILL_2X =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "2..2","2222",
    "2..2","2222",
    "x11x","x11x",
    "1111","1111",
  },
},

SIDEWALK_SLOPE_SIDE_SMOL =
{
  prob = 15,
  skip_prob = 40,

  pass = "sidewalk",

  structure =
  {
    "11..","11AA",
    "11..","11AA",
    "11..","11AA",
    "11..","11>A",
  },
},

SIDEWALK_SLOPE_SIDE_NEAR =
{
  prob = 15,
  skip_prob = 40,

  pass = "sidewalk",

  structure =
  {
    "11....","11AAAA",
    "11....","11>>AA",
    "11....","11>>AA",
    "11....","11AAAA",
  },
},

SIDEWALK_SLOPE_SIDE_FAR =
{
  prob = 10,
  skip_prob = 40,

  pass = "sidewalk",

  structure =
  {
    "11xx..","11xxAA",
    "11....","11>>AA",
    "11....","11>>AA",
    "11xx..","11xxAA",
  },
},

SIDEWALK_SLOPE_ON_RAMP =
{
  prob = 10,

  pass = "sidewalk",

  structure =
  {
    "11x..","11xAA",
    "11...","11>AA",
    "11...","11>AA",
    "11...","11>AA",
    "11...","11>AA",
    "11x..","11xAA",
  },
},

SIDEWALK_SLOPE_ON_RAMP_DOUBLE =
{
  prob = 10,

  pass = "sidewalk",

  structure =
  {
    "11x..","11xAA",
    "11...","11>AA",
    "11...","11>AA",
    "111..","111AA",
    "111..","111AA",
    "11...","11>AA",
    "11...","11>AA",
    "11x..","11xAA",
  },
},

SIDEWALK_PLAIN_STAIR =
{
  prob = 10,

  pass = "sidewalk",

  structure =
  {
    "..","AA",
    "..","AA",
    "..","^^",
    "11","11",
    "11","11",
  },
},

SIDEWALK_STAIR_Y_IN =
{
  prob = 10,

  pass = "sidewalk",

  structure =
  {
    ".....","..AAA",
    ".....","1>AAA",
    ".....","11%AA",
    "11...","111^.",
    "11...","1111.",
  },

  diagonals =
  {
    "1A",
  },
},

SIDEWALK_STAIR_Y_OUT =
{
  prob = 15,

  pass = "sidewalk",

  structure =
  {
    "......","AAAAAA",
    "......","AAAAAA",
    "......","11>>AA",
    "......","1111AA",
    "11....","1111AA",
    "11....","1111AA",
  },
},

SIDEWALK_BUILDING_4x4 =
{
  prob = 15,

  pass = "sidewalk",

  structure =
  {
    "11......","11AAAAAA",
    "11......","11AAAAAA",
    "........","AA....AA",
    "........","AA....AA",
    "........","AA....AA",
    "........","AA....AA",
    "........","AAAAAAAA",
    "........","AAAAAAAA",
  },
},

SIDEWALK_BUILDING_L =
{
  prob = 15,

  pass = "sidewalk",

  structure =
  {
    "11........","11AAAAAAAA",
    "11........","11AAAAAAAA",
    "..........","AAAA....AA",
    "..........","AAAA....AA",
    "..........","AA......AA",
    "..........","AA......AA",
    "..........","AA......AA",
    "..........","AA......AA",
    "..........","AAAAAAAAAA",
    "..........","AAAAAAAAAA",
  },
},

SIDEWALK_OVERHANG =
{
  prob = 20,

  pass = "sidewalk",

  structure =
  {
    "11....","11AAAA",
    "11....","11AAAA",
    "xx....","xx#AA#",
  },
},

SIDEWALK_OVERHANG_CORNER =
{
  prob = 20,

  pass = "sidewalk",

  structure =
  {
    "xx...","xxAAA",
    "11...","11AAA",
    "11...","11#AA",
  },
},

SIDEWALK_CURVE =
{
  prob = 20,

  pass = "sidewalk",

  structure =
  {
    "1...x","1AA%x",
    "1....","1AAA%",
    "xx...","xx%AA",
    "xxx..","xxxAA",
  },

  diagonals =
  {
    "A.",
      "A.",
    ".A",
  },
},

SIDEWALK_ZIGZAG =
{
  prob = 20,

  pass = "sidewalk",

  structure =
  {
    "1...xx","1AA%xx",
    "1....x","1AAA%x",
    "xx....","xx%AAA",
    "xxx...","xxx%AA",
  },

  diagonals =
  {
    "A.",
      "A.",
    ".A",
      ".A",
  },
},

SIDEWALK_LIQUID =
{
  prob = 50,

  pass = "sidewalk",

  structure =
  {
    "........","AA~~~~AA",
    "11111111","11111111",
  },
},

SIDEWALK_LIQUID_POOL_LONG =
{
  prob = 50,

  pass = "sidewalk",

  structure =
  {
    "......","AA~~~~",
    "......","AA~~~~",
    "11xxxx","11xxxx",
  },
},

SIDEWALK_LIQUID_POOL =
{
  prob = 50,

  pass = "sidewalk",

  structure =
  {
    "....","AA~~",
    "....","AA~~",
    "11xx","11xx",
  },
},

SIDEWALK_CAGE =
{
  prob = 50,

  pass = "sidewalk",

  structure =
  {
    "x..","xCC",
    "1..","1AA",
    "1..","1AA",
  },

  cage_mode = "fancy",
},

SIDEWALK_CAGE_4X =
{
  prob = 40,

  pass = "sidewalk",

  structure =
  {
    "x....","xCCCC",
    "1....","1AAAA",
    "1....","1AAAA",
  },

  cage_mode = "fancy",
},

SIDEWALK_CAGE_4X4 =
{
  prob = 35,

  pass = "sidewalk",

  structure =
  {
    "x..","xCC",
    "x..","xCC",
    "1..","1AA",
    "1..","1AA",
  },

  cage_mode = "fancy",
},

SIDEWALK_CLOSET_2X2 =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "1!!","1TT",
    "1!!","1TT",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_2X1 =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "1!","1T",
    "1!","1T",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_3X1 =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "1!","1T",
    "1!","1T",
    "1!","1T",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_3X2 =
{
  prob = 100,

  pass = "sidewalk",

  structure =
  {
    "1!!","1TT",
    "1!!","1TT",
    "1!!","1TT",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_4X1 =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_6X1 =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
  },

  closet = { from_dir=4 },
},

SIDEWALK_CLOSET_8X1 =
{
  prob = 25,

  pass = "sidewalk",

  structure =
  {
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
    "1!","1T",
  },

  closet = { from_dir=4 },
},
-- MSSP's street 'smoothers'

STREET_CORNER_FIXER =
{
  prob = 100,

  pass = "street_fixer",

  structure =
  {
    "x1111xx","x1111xx",
    "111111.","11111..",
    "111111.","11111..",
    "111111.","11111..",
    "111111.","1111/..",
    "x1111..","x......",
    "x......","x......",
  },

  diagonals =
  {
    "1.",
  },
},

STREET_T_JUNCTION_FIXER =
{
  prob = 100,

  pass = "street_fixer",

  structure =
  {
    "11111.","11111.",
    "11111!","1111/!",
    "!1111!","!....!",
    "!!!!!!","!!!!!!",
  },

  diagonals =
  {
    "1.",
  },
},

STREET_WEIRD_DEAD_BRANCH_FIXER =
{
  prob = 100,

  pass = "street_fixer",

  structure =
  {
    "111111","111111",
    ".1111.","......",
    "......","......",
  },
},

STREET_DEAD_END_FIXER =
{
  prob = 100,

  pass = "street_fixer",

  structure =
  {
    ".1111.",".1111.",
    "......",".%11/.",
  },

  diagonals =
  {
    ".1","1.",
  },
},

-- MSSP's building entrances... okay, just joiners and some such really

STREET_BUILDING_ENTRANCE =
{
  prob = 300,

  pass = "building_entrance",

  structure =
  {
    "..","RR",
    "..","RR",
    "11","11",
  },

  new_room =
  {
    env = "building",

    conn = { x=1, y=1, w=2, dir=8 },

    symmetry = { x=2, y=1, w=2, dir=8 },
  },
},

STREET_BUILDING_ENTRANCE_WITH_JOINER_2X1 =
{
  prob = 100,

  pass = "building_entrance",

  structure =
  {
    "....",".RR.",
    "....",".RR.",
    "x..x","xJJx",
    "x11x","x11x",
  },

  new_room =
  {
    symmetry = { x=3, y=2, w=2, dir=8 },
  },

  joiner =
  {
    from_dir = 2,
  },
},

STREET_BUILDING_ENTRANCE_WITH_JOINER_2X2 =
{
  prob = 100,

  pass = "building_entrance",

  structure =
  {
    "....",".RR.",
    "....",".RR.",
    "x..x","xJJx",
    "x..x","xJJx",
    "x11x","x11x",
  },

  new_room =
  {
    symmetry = { x=2, y=3, w=2, dir=8 },
  },

  joiner =
  {
    from_dir = 2,
  },
},

STREET_BUILDING_ENTRANCE_WITH_JOINER_3X2 =
{
  prob = 100,

  pass = "building_entrance",

  structure =
  {
    ".....",".RRR.",
    ".....",".RRR.",
    "x...x","xJJJx",
    "x...x","xJJJx",
    "x111x","x111x",
  },

  new_room =
  {
    symmetry = { x=3, y=3, w=2, dir=8 },
  },

  joiner =
  {
    from_dir = 2,
  },
}

}


-- Earlier/simpler iteration of shape grammar, primarily for new game support
SHAPES.OBLIGE_745 =
{

ROOT_1 =
{
  prob = 100,

  structure =
  {
    "!!!!!", ".....",
    "!!!!!", ".RRR.",
    "!!!!!", ".RRR.",
    "!!!!!", ".RRR.",
    "!!!!!", ".....",
  }
},


ROOT_2 =
{
  prob = 60,

  structure =
  {
    "!!!!!", ".....",
    "!!!!!", "./R%.",
    "!!!!!", ".RRR.",
    "!!!!!", ".RRR.",
    "!!!!!", ".%R/.",
    "!!!!!", ".....",
  },

  diagonals =
  {
    ".R", "R.",
    ".R", "R.",
  }
},


ROOT_3 =
{
  prob = 20,

  structure =
  {
    "!!!!!!", "......",
    "!!!!!!", ".RRRR.",
    "!!!!!!", ".RRRR.",
    "!!!!!!", ".RRRR.",
    "!!!!!!", ".RRRR.",
    "!!!!!!", "......",
  }
},


ROOT_L1 =
{
  prob = 40,

  structure =
  {
    "!!!!!!", "......",
    "!!!!!!", ".RR##.",
    "!!!!!!", ".RR%#.",
    "!!!!!!", "#RRRR.",
    "!!!!!!", ".%RRR.",
    "!!!!!!", "..#...",
  },

  diagonals = { "R.", ".R" }
},


ROOT_T1 =
{
  prob = 40,

  structure =
  {
    "!!!!!!", "..##..",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "#%RR/#",
    "!!!!!!", "##RR##",
    "!!!!!!", "......",
  },

  diagonals = { ".R", "R." }
},


ROOT_CAGES4 =
{
  prob = 35,

  structure =
  {
    "!!!!!", ".#.#.",
    "!!!!!", "RCRCR",
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
    "!!!!!", "RCRCR",
    "!!!!!", ".#.#.",
  },

  new_room =
  {
    symmetry = { dir=4, x=2, y=3, w=2 }
  },

  cage_mode = "fancy"
},


ROOT_LIQUID_1A =
{
  prob = 25,

  structure =
  {
    "!!!!!", "/RRR%",
    "!!!!!", "R/~%R",
    "!!!!!", "R~#~R",
    "!!!!!", "R%~/R",
    "!!!!!", "%RRR/",
  },

  diagonals =
  {
    ".R", "R.",
    "R~", "~R",
    "R~", "~R",
    ".R", "R.",
  },

  new_room =
  {
    symmetry = { kind="rotate", x=2, y=2, x2=4, y2=4 }
  }
},


ROOT_LIQUID_1B =
{
  template = "ROOT_LIQUID_1A",

  prob = 30,

  structure =
  {
    "!!!!!", "/RRR%",
    "!!!!!", "R/~%R",
    "!!!!!", "R~C~R",
    "!!!!!", "R%~/R",
    "!!!!!", "%RRR/",
  },

  cage_mode = "fancy"
},


ROOT_LIQUID_CAGE2 =
{
  prob = 20,

  structure =
  {
    "!!!!!", "!RRR%",
    "!!!!!", "#~~%R",
    "!!!!!", "#C%~R",
    "!!!!!", "#C/~R",
    "!!!!!", "#~~/R",
    "!!!!!", "!RRR/",
  },

  diagonals =
  {
    "R.",
    "~R",
    "C~",
    "C~",
    "~R",
    "R.",
  },

  new_room =
  {
  },

  cage_mode = "fancy"
},


ROOT_LIQUID_CAGE3 =
{
  prob = 70,

  structure =
  {
    "!!!!!", "#####",
    "!!!!!", "#/C~R",
    "!!!!!", "#C/~R",
    "!!!!!", "#~~/R",
    "!!!!!", "!RRRR",
    "!!!!!", "!RRR/",
  },

  diagonals =
  {
    "#C",
    "C~",
    "~R",
    "R!",
  },

  cage_mode = "fancy"
},


------------------------------------------


GROW_2 =
{
  prob = 100,
  prob_skew = 2,

  structure =
  {
    "....", ".11.",
    "x11x", "x11x",
  }
},


GROW_3 =
{
  prob = 20,
  prob_skew = 2,

  structure =
  {
    ".....", ".111.",
    "x111x", "x111x"
  }
},


GROW_BLOB_1 =
{
  prob = 15,

  structure =
  {
    "....", "1111",
    "....", "1111",
    "x11x", "x11x"
  }
},


GROW_FUNNEL_1 =
{
  prob = 25,

  structure =
  {
    "....", "1111",
    "....", "%11/",
    ".11.", ".11."
  },

  diagonals = { ".1", "1." }
},


GROW_FUNNEL_2 =
{
  prob = 25,

  structure =
  {
    "....", "#11#",
    "....", "/11%",
    "1111", "1111"
  },

  diagonals = { "#1", "1#" }
},


GROW_CURVE_1 =
{
  prob = 80,

  structure =
  {
    "1.", "1%",
    "1.", "11",
    "1.", "1/"
  },

  diagonals = { "1.", "1." }
},


GROW_CURVE_2 =
{
  prob = 30,

  structure =
  {
    "..", "A%",
    "%.", "%A",
    "1.", "1A",
    "/.", "/A",
    "..", "A/"
  },

  diagonals =
  {
          "A.",
    "1.", "1A",
    "1.", "1A",
          "A."
  }
},


GROW_DIAG_BLOB1 =
{
  prob = 10,

  structure =
  {
    "...", "AA%",
    "%..", "%AA",
    "x%.", "x%A",
    "x1.", "x1.",
  },

  diagonals =
  {
          "A.",
    "1.", "1A",
    "1.", "1A"
  }
},


GROW_DIAG_BLOB2 =
{
  prob = 20,

  structure =
  {
    "...", "AA%",
    "%..", "%AA",
    "x%.", "x%A",
    "x1.", "x1.",
    "x/.", "x/A",
    "/..", "/AA",
    "...", "AA/"
  },

  diagonals =
  {
          "A.",
    "1.", "1A",
    "1.", "1A",
    "1.", "1A",
    "1.", "1A",
          "A."
  }
},


GROW_AREA_1 =
{
  prob = 40,

  structure =
  {
    "....", ".AA.",
    "x11x", "x11x"
  }
},


GROW_AREA_2 =
{
  prob = 3,

  structure =
  {
    "...", "AAA",
    "11.", "11A",
    "11.", "11A"
  }
},


GROW_STAIR_2 =
{
  prob = 12,
  prob_skew = 3,

  structure =
  {
    "....", ".AA.",
    "x..x", "x^^x",
    "x11x", "x11x"
  }
},


GROW_STAIR_3 =
{
  prob = 15,
  prob_skew = 3,

  structure =
  {
    "...", "AAA",
    "...", "^^^",
    "111", "111"
  }
},


GROW_STAIRPAIR_2 =
{
  prob = 10,
  prob_skew = 3,

  structure =
  {
    "...", "AAA",
    "...", "^C^",
    "111", "111"
  },

  cage_mode = "fancy"
},


GROW_STAIRPAIR_3 =
{
  prob = 2,

  structure =
  {
    "..x..", "AAxAA",
    ".....", "A^#^A",
    "x111x", "x111x"
  }
},


GROW_STAIR_CURVE =
{
  prob = 200,

  structure =
  {
    "x..x", "xA%x",
    "1%..", "1%A%",
    "11..", "11>A",
    "1/..", "1/A/",
    "x..x", "xA/x"
  },

  diagonals =
  {
          "A.",
    "1.", "1A", "A.",
    "1.", "1A", "A.",
          "A."
  }
},


GROW_DBLSTAIR_CURVE =
{
  prob = 200,

  structure =
  {
    "...", "SA%",
    "1%.", "1%A",
    "11.", "11A",
    "1/.", "1/A",
    "...", "SA/"
  },

  diagonals =
  {
          "A.",
    "1.", "1A",
    "1.", "1A",
          "A."
  },

  stair1_5 = { shape="L", from_dir=2, dest_dir=6 },
  stair1_1 = { shape="L", from_dir=8, dest_dir=6 }
},


GROW_STAIR_POOL1 =
{
  prob = 7,

  structure =
  {
    "x.....", "xAAA%.",
    "1.....", "1/~%A.",
    "1.....", "1~~~A.",
    "1.....", "1%~/A#",
    "1.....", "1>AA/.",
    "x....x", "x##..x",
  },

  diagonals =
  {
    "A.",
    "1~", "~A",
    "1~", "~A",
    "A."
  },
},


GROW_STAIR_POOL2 =
{
  -- this one is higher than STAIR_POOL1

  prob = 25,

  structure =
  {
    "x.....", "xAAA%.",
    "1.....", "1/~%A.",
    "1.....", "1~~~A.",
    "1.....", "1%~/A#",
    "1.....", "1>>A/.",
    "x....x", "x##..x"
  },

  diagonals =
  {
    "A.",
    "1~", "~A",
    "1~", "~A",
    "A."
  }
},


GROW_STAIR_SIDE2 =
{
  prob = 60,
  prob_skew = 3,

  structure =
  {
    "....", "#AAA",
    "..1x", "#^/x",
    "..1x", "#^1x",
    "..1x", "#11x",
  },

  diagonals = { "A1" }
},


GROW_STAIR_SIDE3 =
{
  prob = 60,
  prob_skew = 3,

  structure =
  {
    "...", "#AA",
    "...", "#AA",
    "..1", "#^/",
    "..1", "#^1",
    "..1", "#^1",
    "..1", "#11",
  },

  diagonals = { "A1" }
},


GROW_STAIR_HUGE =
{
  prob = 20,

  structure =
  {
    "x....x", "xAAAAx",
    "......", "~%^^/~",
    "......", "~~^^~~",
    "......", "~/^^%~",
    "x1111x", "x1111x",
  },

  diagonals =
  {
    "~A", "A~",
    "~1", "1~"
  }
},


GROW_LIQUID_BRIDGE1 =
{
  prob = 0,

  structure =
  {
    "x..x", "x~~x",
    "x...", "x~~A",
    "1...", "1==A",
    "x...", "x~~A",
    "x..x", "x~~x"
  }
},


------------------------------------------


SPROUT_DIRECT_1 =
{
  prob = 2,

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "x11x", "x11x"
  },

  new_room =
  {
    conn = { x=2, y=1, w=2, dir=8 },

    symmetry = { x=2, y=3, w=2, dir=8 }
  }
},


SPROUT_DIRECT_2 =
{
  prob = 100,

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "x11x", "x11x",
    "x11x", "x11x"
  },

  new_room =
  {
    conn = { x=2, y=2, w=2, dir=8 },

    symmetry = { x=2, y=3, w=2, dir=8 }
  }
},


SPROUT_DIRECT_3 =
{
  prob = 400,

  structure =
  {
    ".....", ".RRR.",
    ".....", ".RRR.",
    "x111x", "x111x"
  },

  new_room =
  {
    conn = { x=2, y=1, w=3, dir=8 },

    symmetry = { x=3, y=2, dir=8 }
  }
},


SPROUT_DIRECT_4 =
{
  prob = 4000,

  structure =
  {
    "....", "RRRR",
    "....", "RRRR",
    "1111", "1111"
  },

  new_room =
  {
    conn = { x=1, y=1, w=4, dir=8 },

    symmetry = { x=2, y=3, w=2, dir=8 }
  }
},


SPROUT_CASTLE_1 =
{
  env = "outdoor",
  prob = 1000,

  structure =
  {
    "!!xxxx!!", "11xxxx11",
    "!!!!!!!!", "11RRRR11",
    "!!!!!!!!", "11RRRR11",
    "!!!!!!!!", "11111111",
    "xxx11xxx", "xxx11xxx"
  },

  new_room =
  {
    env = "building",

    conn = { x=4, y=2, w=2, dir=8 }

--  symmetry = { x=4, y=3, w=2, dir=8 }
  }
},


SPROUT_CASTLE_2 =
{
  env = "outdoor",
  prob = 8000,

  structure =
  {
    "!!!!!!!!", "11RRRR11",
    "!!!!!!!!", "11RRRR11",
    "!!!!!!!!", "11%RR/11",
    "!!!!!!!!", "11111111",
    "xxx11xxx", "xxx11xxx"
  },

  diagonals = { ".R", "R." },

  new_room =
  {
    env = "building",

    conn = { x=4, y=2, w=2, dir=8 },

    symmetry = { x=4, y=3, w=2, dir=8 }
  }
},


SPROUT_DOUBLE_TEST =
{
  prob = 0,  -- not supported yet

  structure =
  {
    "....", "RR%.",
    "....", "RRR%",
    "11..", "11RR",
    "11..", "11RR"
  },

  diagonals =
  {
    "R.", "R."
  },

  new_room =
  {
    conn  = { x=1, y=2, w=2, dir=8 },
    conn2 = { x=2, y=2, w=2, dir=6 },

    symmetry = { x=3, y=3, dir=9 }
  }
},


SPROUT_SYMMETRY_3 =
{
  prob = 30,

  structure =
  {
    ".....", ".RRR.",
    ".....", ".RRR.",
    "x111x", "x111x"
  },

  new_room =
  {
    conn = { x=2, y=1, w=3, dir=8 },

    symmetry = { x=3, y=2, dir=8 }
  }
},

SPROUT_JOINER_2x1 =
{
  prob = 500,

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "x..x", "xJJx",
    "x11x", "x11x"
  },

  new_room =
  {
    symmetry = { x=2, y=3, w=2, dir=8 }
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_3x1 =
{
  prob = 2000,

  structure =
  {
    ".....", ".RRR.",
    ".....", ".RRR.",
    "x...x", "xJJJx",
    "x111x", "x111x"
  },

  new_room =
  {
    symmetry = { x=3, y=3, dir=8 }
  },

  joiner =
  {
    from_dir = 2
  },
},


SPROUT_JOINER_4x1 =
{
  prob = 4000,

  structure =
  {
    "....", "RRRR",
    "....", "RRRR",
    "....", "JJJJ",
    "1111", "1111"
  },

  new_room =
  {
    symmetry = { x=2, y=3, w=2, dir=8 }
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_2x2 =
{
  prob = 120,

  structure =
  {
    "....", ".RR.",
    "....", ".RR.",
    "x..x", "xJJx",
    "x..x", "xJJx",
    "x11x", "x11x"
  },

  new_room =
  {
    symmetry = { x=2, y=4, dir=8 }
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_3x2 =
{
  prob = 4000,

  structure =
  {
    ".....", ".RRR.",
    ".....", ".RRR.",
    "x...x", "xJJJx",
    "x...x", "xJJJx",
    "x111x", "x111x"
  },

  new_room =
  {
    symmetry = { x=3, y=4, dir=8 }
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_L =
{
  prob = 200,

  structure =
  {
    "....", "####",
    "....", "RRJJ",
    "....", "RRJJ",
    "xx11", "xx11"
  },

  new_room =
  {
  },

  joiner =
  {
    shape = "L",
    from_dir = 2,
    dest_dir = 4
  }
},


------------------------------------------


DECORATE_CAGE_1 =
{
  prob = 10,
  env  = "!cave",

  structure =
  {
    "...", "...",
    "...", ".C.",
    "x1x", "x1x"
  },

  auxiliary =
  {
    pass = "cage_grow",

    count = { 1,4 }
  }
},


AUX_CAGE_GROW1 =
{
  pass = "cage_grow",

  prob = 50,

  structure =
  {
    "C.", "CC",
    "11", "11"
  }
},


AUX_CAGE_GROW2 =
{
  pass = "cage_grow",

  prob = 50,

  structure =
  {
    "C.", "CC",
    "1.", "1C"
  }
},


AUX_CAGE_GROW3 =
{
  pass = "cage_grow",

  prob = 50,

  structure =
  {
    "...", "C%.",
    "C..", "CC.",
    "11x", "11x"
  },

  diagonals =
  {
    "C."
  }
},


DECORATE_CLOSET_2x1 =
{
  prob = 40,
  prob_skew = 2,

  structure =
  {
    "..", "TT",
    "11", "11"
  },

  closet = { from_dir=2 }
},


DECORATE_CLOSET_2x2 =
{
  prob = 60,
  prob_skew = 3,

  structure =
  {
    "..", "TT",
    "..", "TT",
    "11", "11"
  },

  closet = { from_dir=2 }
},


DECORATE_CLOSET_3x1 =
{
  prob = 60,
  prob_skew = 2,

  structure =
  {
    "...", "TTT",
    "111", "111"
  },

  closet = { from_dir=2 }
},


DECORATE_CLOSET_3x2 =
{
  prob = 60,
--prob_skew = 4

  structure =
  {
    "...", "TTT",
    "...", "TTT",
    "111", "111"
  },

  closet = { from_dir=2 }
},


------------------------------------------
--   Cave stuff
------------------------------------------

CAVE_ROOT_5x5 =
{
  prob = 10,

  structure =
  {
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR",
    "!!!!!", "RRRRR"
  }
},


CAVE_ROOT_6x6 =
{
  prob = 100,

  structure =
  {
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR",
    "!!!!!!", "RRRRRR"
  }
},


SPROUT_DIRECT_2_cave =
{
  prob = 100,

  structure =
  {
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    "xx11x", "xx11x"
  },

  new_room =
  {
    env = "cave",

    conn = { x=3, y=1, w=2, dir=8 }
  }
},


SPROUT_DIRECT_3_cave =
{
  prob = 300,

  structure =
  {
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    "x111x", "x111x"
  },

  new_room =
  {
    env = "cave",

    conn = { x=2, y=1, w=3, dir=8 }
  }
},


SPROUT_JOINER_2x1_cave =
{
  prob = 500,

  structure =
  {
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    "xx..x", "xxJJx",
    "xx11x", "xx11x"
  },

  new_room =
  {
    env = "cave"
  },

  joiner =
  {
    from_dir = 2
  }
},


SPROUT_JOINER_3x1_cave =
{
  prob = 2000,

  structure =
  {
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    ".....", "RRRRR",
    "x...x", "xJJJx",
    "x111x", "x111x"
  },

  new_room =
  {
    env = "cave"
  },

  joiner =
  {
    from_dir = 2
  }
},


--[[ disabled for now....

SPROUT_JOINER_3x2_cave =
{
  prob = 4000

  structure =
  {
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    "x...x", "xJJJx"
    "x...x", "xJJJx"
    "x111x", "x111x"
  }

  new_room =
  {
    env = "cave"
  }

  joiner =
  {
    from_dir = 2
  }
}
--]]


CAVE_GROW_3x1 =
{
  prob = 50,

  structure =
  {
    "...", "111",
    "111", "111"
  }
},


CAVE_GROW_3x2 =
{
  prob = 50,

  structure =
  {
    "...", "111",
    "...", "111",
    "111", "111"
  }
},


CAVE_GROW_4x1 =
{
  prob = 100,

  structure =
  {
    "....", "1111",
    "1111", "1111"
  }
},


CAVE_GROW_4x2 =
{
  prob = 100,

  structure =
  {
    "....", "1111",
    "....", "1111",
    "1111", "1111"
  }
},


CAVE_GROW_5x1 =
{
  prob = 150,

  structure =
  {
    ".....", "11111",
    "11111", "11111"
  }
},


CAVE_GROW_5x2 =
{
  prob = 150,

  structure =
  {
    ".....", "11111",
    ".....", "11111",
    "11111", "11111"
  }
},


CAVE_GROW_FILL_A =
{
  prob = 0,

  structure =
  {
    "1.", "11",
    "11", "11"
  }
},


CAVE_GROW_FILL_B =
{
  prob = 0,

  structure =
  {
    "1xx", "1xx",
    "1.x", "11x",
    "111", "111"
  }
},


------------------------------------------
--   Hallway stuff
------------------------------------------


SPROUT_1_hallway =
{
  prob = 0,

  structure =
  {
    "...", "...",
    "...", ".@.",
    "...", ".H.",
    "x1x", "x1x"
  },

  new_room =
  {
    env = "hallway",

    conn = { x=2, y=1, dir=8 }
  }
},


HALL_GROW_I1 =
{
  prob = 100/10,

  structure =
  {
    ".", "@",
    "@", "H",
    "1", "1"
  }
},


HALL_GROW_L1 =
{
  prob = 50/10,

  structure =
  {
    "...", "...",
    "..@", ".@H",
    "..1", "..1"
  }
},


HALL_GROW_T1 =
{
  prob = 50/10,

  structure =
  {
    ".....", ".....",
    "..@..", ".@H@.",
    "..1..", "..1.."
  }
},


HALL_SPROUT_1 =
{
  prob = 100,

  structure =
  {
    "...", "RRR",
    ".@.", "RRR",
    "x1x", "x1x"
  },

  new_room =
  {
    conn = { x=2, y=1, dir=8 }
  }
}


-- end of SHAPES.OBLIGE_745
}

SHAPES.BACKHALLS =
{

ignore_coverage = true,

ROOT_1 =
{
  prob = 50,

  structure =
  {
    "!!!", "...",
    "!!!", ".R.",
    "!!!", "...",
  },

},


-----------------------------------------

GROW_1 =
{
  prob = 400,
  prob_skew = 2,

  structure =
  {
    ".", "1",
    "1", "1",
  },
},


------------------------------------------

SPROUT_DIRECT_1 =
{
  prob = 400,
  prob_skew = 2,

  structure =
  {
    ".", "R",
    "1", "1",
  },

  new_room =
  {
    conn = { x=1, y=1, w=1, dir=8 },
  },

},

SPROUT_TELEPORTER_1x1 =
{
  prob = 700,

  structure =
  {
    ".", "T",
    "1", "1",
  },

  teleporter = true,

  closet =
  {
    from_dir = 2,
  },
},

SQUARE_OUT_FROM_CORNER_2X =
{
  pass = "square_out",

  prob = 100,

  structure =
  {
    ".",".",
    "1","1",
  },
},

DECORATE_CLOSET_2x1 =
{
  prob = 60, --40,
  prob_skew = 2,

  structure =
  {
    ".","T",
    "1","1",
  },

  closet = { from_dir=2 },
},

FILLER_1 =
{
  pass = "filler",
  prob = 40, --30,

  structure =
  {
    ".",".",
    "1","1",
  },
},

SMOOTHER_1 =
{
  pass = "smoother",
  prob = 75, --50,

  structure =
  {
    ".",".",
    "1","1",
  },
},

--------------------------------------

CAVE_ROOT_1 =
{
  prob = 50,

  structure =
  {
    "!!!", "...",
    "!!!", ".R.",
    "!!!", "...",
  },

},

-------------------------------------------

CAVE_GROW_1 =
{
  prob = 400,
  prob_skew = 2,

  structure =
  {
    ".", "1",
    "1", "1",
  },
},


------------------------------------------

SPROUT_DIRECT_1_cave =
{
  prob = 400,
  prob_skew = 2,

  structure =
  {
    ".", "R",
    "1", "1",
  },

  new_room =
  {
    env = "cave"
  },

  new_room =
  {
    conn = { x=1, y=1, w=1, dir=8 },
  },

},
-- end of SHAPES.BACKHALLS
}