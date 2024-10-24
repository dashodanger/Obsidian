----------------------------------------------------------------
-- GAME DEF : Operation Body Count
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

OBC.FACTORY = { }

-- constants
OBC.FACTORY.NO_TILE = 7
OBC.FACTORY.NO_OBJ  = 0

OBC.FACTORY.PREFABS =
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

DOOR_OBCY =
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

OBC_ELEVATOR =
{
  scale=64,

  structure =
  {
    "#####",
    "##E##",
    "##.##",
    "#FdF#",
  },

  elements =
  {
    E = { solid="elevator" },
    F = { solid="front"    },

    d = { kind="door_kind" },
  },

  things =
  {
    { kind="exit", x=160,  y=128 },
  },
},

} -- OBC.FACTORY.PREFABS

OBC.FACTORY.THINGS =
{
  -- players
  player1 = { kind="other", r=30, h=60,
              id={ easy=19, medium=19, hard=19, dirs="player" },
            },

  -- enemies
  rat_1     = { kind="monster", r=30, h=60,
              id={ easy=108, medium=144, hard=180, dirs=true },
            },
  rat_2   = { kind="monster", r=30, h=60,
              id={ easy=216, medium=234, hard=252, dirs=true, patrol=4 },
            },
  electro_bot = { kind="monster", r=30, h=60,
              id={ easy=270, medium=288, hard=306, dirs=true, patrol=4 },
            },
  mercenary = { kind="monster", r=30, h=60,
              id={ easy=196, medium=196, hard=196, dirs=false },
            },
  sewer_terrorist  = { kind="monster", r=30, h=60,
              id={ easy=179, medium=179, hard=179, dirs=false },
            },
  weak_terrorist  = { kind="monster", r=30, h=60,
              id={ easy=116, medium=152, hard=188, dirs=true, patrol=4 },
            },
  terrorist  = { kind="monster", r=30, h=60,
              id={ easy=278, medium=296, hard=314, dirs=true },
            },

  -- bosses
  swamp_monster = { kind="monster", id=215, r=30, h=60 },
  cell_boss     = { kind="monster", id=142, r=30, h=60 },
  terror_boss   = { kind="monster", id=232, r=30, h=60 },
  victor        = { kind="monster", id=214, r=30, h=60 },

  -- pickups
  health_packet = { kind="pickup", id=60, r=30, h=60, pass=true },
  flak_jacket = { kind="pickup", id=59, r=30, h=60, pass=true },
  ammo_box  = { kind="pickup", id=56, r=30, h=60, pass=true },
  fuel_tank     = { kind="pickup", id=58, r=30, h=60, pass=true },
  rocket_grenade = { kind="pickup", id=57, r=30, h=60, pass=true },
  uzi = { kind="pickup", id=52, r=30, h=60, pass=true },
  galil = { kind="pickup", id=53, r=30, h=60, pass=true },
  flame_thrower = { kind="pickup", id=54, r=30, h=60, pass=true },
  grenade_launcher = { kind="pickup", id=55, r=30, h=60, pass=true },

  -- scenery
  nothing     = { kind="scenery", id=18, r=30, h=60, pass=true },

  -- special
  secret  = { kind="other", id=98, r=30,h=60, pass=true },

  turn_E  = { kind="other", id=90, r=30,h=60, pass=true },
  turn_NE = { kind="other", id=91, r=30,h=60, pass=true },
  turn_N  = { kind="other", id=92, r=30,h=60, pass=true },
  turn_NW = { kind="other", id=93, r=30,h=60, pass=true },
  turn_W  = { kind="other", id=94, r=30,h=60, pass=true },
  turn_SW = { kind="other", id=95, r=30,h=60, pass=true },
  turn_S  = { kind="other", id=96, r=30,h=60, pass=true },
  turn_SE = { kind="other", id=97, r=30,h=60, pass=true },

  sewer_exit  = { kind="other", id=103, r=30,h=60, pass=true },
}

OBC.FACTORY.TILE_NUMS =
{
  area_min = 139,
  area_max = 161,

  deaf_guard = 138,

  door = { 130, 131 },  -- E/W then N/S

  door_elevator = { 134, 135 },
}

----------------------------------------------------------------

OBC.FACTORY.COMBOS =
{
  SEWER_ROOM =
  {
    mat_pri = 5,
    wall = 5, void = 16, floor=0, ceil=0,
    decorate = 2, door_side = 5,

    theme_probs = { SEWER=50 },
  },

  SKYSCRAPER_ROOM =
  {
    mat_pri = 53,
    wall = 53, void = 61, floor=0, ceil=0,
    decorate = 54, door_side = 53,

    theme_probs = { SKYSCRAPER=50 },
  },
}

OBC.FACTORY.EXITS =
{
  ELEVATOR =  -- FIXME: not needed, remove
  {
    mat_pri = 53,
    wall = 53, void = 53, floor=0, ceil=0,
  },
}


OBC.FACTORY.KEY_DOORS =
{

}

OBC.FACTORY.MISC_PREFABS =
{
  elevator =
  {
    prefab = "OBC_ELEVATOR",
    add_mode = "extend",

    skin = { elevator=113, front=53, exit="sewer_exit"}
  },
}



---- QUEST STUFF ----------------

OBC.FACTORY.QUESTS =
{
  key = {  },

  switch = { },

  weapon = { uzi=50, galil=20, flame_thrower=10, grenade_launcher=5},

  item =
  {
    health_packet = 50, flak_jacket = 50, ammo_box = 50, fuel_tank = 20, rocket_grenade = 10,
  },

  exit =
  {
    elevator=50
  }
}


OBC.FACTORY.ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    scenery = { nothing=90 },

    space_range = { 10, 50 },
  },

  STORAGE =
  {
    scenery = { nothing=90 },
  },

  SUPPLIES =
  {
    scenery = { nothing=90 },

    pickups = { health_packet=50, flak_jacket=15, ammo_box=25 },
    pickup_rate = 66,
  },

  QUARTERS =
  {
    scenery = { nothing=90 },
  },

  BATHROOM =
  {
    scenery = { nothing=90 },
  },
}

OBC.FACTORY.THEMES =
{
  SEWER =
  {
    room_probs =
    {
      STORAGE = 50,
      SUPPLIES = 15,
      QUARTERS = 50, BATHROOM = 15,
    },

    scenery =
    {
      nothing=50
    },
  },

  SKYSCRAPER =
  {
    room_probs =
    {
      STORAGE = 40,
      SUPPLIES = 10,
      QUARTERS = 20, BATHROOM = 10,
    },

    scenery =
    {
      nothing=50
    },
  },
}


----------------------------------------------------------------

OBC.FACTORY.MONSTERS =
{
  rat_1 = { prob=25, hp=1,   dm=5,  fp=1.0, melee=true, },
  rat_2 = { prob=20, hp=10,   dm=15,  fp=1.0, melee=true, },
  electro_bot = { prob=15, hp=10,   dm=15,  fp=1.0, melee=true, },
  mercenary = { prob=10, hp=40,   dm=20,  fp=1.0, hitscan=true },
  sewer_terrorist = { prob=20, hp=10,   dm=5,  fp=1.0, hitscan=true },
  weak_terrorist  = { prob=60, hp=25,  dm=10, fp=1.0, hitscan=true },
  terrorist = { prob=30, hp=50,  dm=25, fp=1.7, hitscan=true, },
}

OBC.FACTORY.BOSSES =
{
  swamp_monster   = { hp=1000, dm=30 },
  cell_boss = { hp=1000, dm=50, hitscan=true },
  terror_boss      = { hp=1000, dm=50, hitscan=true },
  victor    = { hp=1000, dm=50, hitscan=true },
}

OBC.FACTORY.MONSTER_GIVE =
{
  sewer_terrorist = { { weapon="uzi"} },
  weak_terrorist  = { { weapon="uzi"} },
  terrorist       = { { weapon="galil"} },
  cell_boss       = { { weapon="uzi"} },
}

OBC.FACTORY.WEAPONS =
{
  shotgun = { fp=0, melee=true,           rate=3.0, dm= 7, freq= 2, held=true },
  uzi     = { fp=1, ammo="bullet", per=1, rate=3.0, dm=17, freq=10, held=true },
  galil   = { fp=2, ammo="bullet", give=4, per=1, rate=8.0,  dm=17, freq=30, },
  flame_thrower = { fp=3, ammo="fuel", give=6, per=1, rate=16.0, dm=17, freq=90, },
  grenade_launcher = { fp=4, ammo="grenade", give=6, per=1, rate=16.0, dm=17, freq=90, },
}

OBC.FACTORY.PICKUPS =
{
  health_packet = { stat="health", give=25 },
  flak_jacket = { stat="armor", give=10 },
  ammo_box  = { stat="bullet", give=4  },
  fuel_tank  = { stat="fuel", give=4  },
  rocket_grenade  = { stat="grenade", give=1  },
}

OBC.FACTORY.INITIAL_MODEL =
{
  assault =
  {
    health=100, armor=0, bullet=8,
    shotgun=true, uzi=true
  }
}


------------------------------------------------------------

OBC.FACTORY.EPISODE_THEMES =
{
  { SEWER=5 },
  { SEWER=5 },
  { SEWER=5 },
  { SEWER=5 },
  --{ SKYSCRAPER=5 },
  --{ SKYSCRAPER=5 },
  --{ SKYSCRAPER=5 },
}

OBC.FACTORY.SECRET_EXITS =
{

}

OBC.FACTORY.EPISODE_BOSSES =
{
  "swamp_monster",
  "cell_boss",
  "terror_boss",
  "victor",
}

OBC.FACTORY.KEY_NUM_PROBS =
{
  small   = { 90, 50, 20 },
  regular = { 40, 90, 40 },
  large   = { 20, 50, 90 },
}

OBC.FACTORY.QUEST_LEN_PROBS =
{
  ----------  2   3   4   5   6   7   8   9  10  11  12  -------

  key    = {  0,  0,  2, 10, 20, 50, 75, 40, 20, 10, 5, 1 },
  exit   = {  0,  0,  2, 10, 20, 50, 75, 40, 20, 10, 5, 1 },

  boss   = {  0,  0,  2, 10, 30, 50, 30, 10, 2 },

  weapon = {  0, 90, 50, 12, 4, 2 },
  item   = { 30, 70, 70, 10 },  -- treasure
}

function OBC.decide_quests(level_list, is_spear)

  local function add_quest(L, kind, item, secret_prob, ob_size)
    secret_prob = 0 --FIXME !!!!

    local len_probs = non_nil(OBC.FACTORY.QUEST_LEN_PROBS[kind])
    local Quest =
    {
      kind = kind,
      item = item,
      want_len = 1 + rand.index_by_probs(len_probs),
      ob_size = ob_size
    }
    if item == "secret" or (secret_prob and rand.odds(secret_prob)) then
      Quest.is_secret = true
      -- need at least one room in-between (for push-wall)
      if Quest.want_len < 3 then Quest.want_len = 3 end
    end
    table.insert(L.quests, Quest)
    return Quest
  end

  local gatling_maps =
  {
    [rand.irange(2,3)] = true,
    [rand.irange(4,6)] = true,
    [rand.irange(7,9)] = true,
  }

  for zzz,Level in ipairs(level_list) do

    -- weapons and keys
    
    local ob_size = Level.ob_size

    if rand.odds(90 - 40 * ((Level.ep_along-1) % 3)) then
      add_quest(Level, "weapon", "uzi", 35, ob_size)
    end

    if gatling_maps[Level.ep_along] then
      add_quest(Level, "weapon", "galil", 50, ob_size)
    end

    -- treasure

    if rand.odds(60) then
      add_quest(Level, "item", "ammo_box", 50, ob_size)
    end

    -- bosses and exits

    if Level.boss_kind then
      local Q = add_quest(Level, "boss", Level.boss_kind, 0, ob_size)
    end

    if Level.secret_exit then
--FIXME  add_quest(Level, "exit", "secret")
    end

    add_quest(Level, "exit", "normal", 0, ob_size)
  end
end

function OBC.get_factory_levels(episode)

  local level_list = {}

  local theme_probs = OBC.FACTORY.EPISODE_THEMES[episode]

  local boss_kind = OBC.FACTORY.EPISODE_BOSSES[episode]
  if OB_CONFIG.length ~= "full" then
    boss_kind = OBC.FACTORY.EPISODE_BOSSES[rand.irange(1,4)]
  end

  for map = 1,10 do

    local Level =
    {
      name = string.format("E%dL%d", episode, map),

      episode   = episode,
      ep_along  = map,
      ep_length = 10,

      theme_probs = theme_probs,
      sky_info = { color="blue", light=192 }, -- dummy

      boss_kind   = (map == 10)  and boss_kind,

      quests = {},

      toughness_factor = sel(map==10, 1.1, 1 + (map-1) / 5),
    }

    local ob_size = PARAM.float_size_wolf_3d

    if OB_CONFIG.length == "single" then
      if ob_size == gui.gettext("Episodic") or 
      ob_size == gui.gettext("Progressive") then
        ob_size = 36
        goto foundsize
      end
    end
  
    if ob_size == gui.gettext("Mix It Up") then
  
      local result_skew = 1.0
      local low = PARAM.float_level_lower_bound_wolf_3d or 10
      local high = PARAM.float_level_upper_bound_wolf_3d or 75
  
      if OB_CONFIG.level_size_bias_wolf_3d then
        if OB_CONFIG.level_size_bias_wolf_3d == "small" then
          result_skew = .80
        elseif OB_CONFIG.level_size_bias_wolf_3d == "large" then
          result_skew = 1.20
        end
      end
  
      ob_size = math.clamp(low, math.round(rand.irange(low, high) * result_skew), high)
      goto foundsize
    end
  
    if ob_size == gui.gettext("Episodic") or 
    ob_size == gui.gettext("Progressive") then
  
      -- Progressive --
  
      local ramp_factor = 0.66
  
      if OB_CONFIG.level_size_ramp_factor_wolf_3d then
        ramp_factor = tonumber(OB_CONFIG.level_size_ramp_factor_wolf_3d)
      end
  
      local along
  
      if OB_CONFIG.length == "few" then
        along = Level.ep_along / 4
      elseif OB_CONFIG.length == "episode" then
        along = Level.ep_along / Level.ep_length
      else
        along = ((Level.ep_length * (GAME.FACTORY.episodes - 1)) + Level.ep_along) / (Level.ep_length * GAME.FACTORY.episodes)
      end
  
      along = along ^ ramp_factor
  
      if ob_size == gui.gettext("Episodic") then along = Level.ep_along / Level.ep_length end
  
      along = math.clamp(0, along, 1)
  
      -- Level Control fine tune for Prog/Epi
  
      -- default when Level Control is off: ramp from "small" --> "large",
      local def_small = PARAM.float_level_lower_bound_wolf_3d or 30
      local def_large = PARAM.float_level_upper_bound_wolf_3d - def_small or 42
  
      -- this basically ramps up
      ob_size = math.round(def_small + along * def_large)
    end

    ::foundsize::

    if ob_size <= 22 then
      Level.plan_size = 4
    elseif ob_size <= 48 then
      Level.plan_size = 5
    elseif ob_size <= 58 then
      Level.plan_size = 6
    else
      Level.plan_size = 7
    end

    Level.ob_size = ob_size

    if not PARAM.room_size_multiplier_wolf_3d then
      Level.cell_size = 12
    else
      if PARAM.room_size_multiplier_wolf_3d == "mixed" then
        Level.cell_size = 7 + math.round(3 * rand.pick({0.33,0.66,1,1.33,1.66}))
      else
        Level.cell_size = 7 + math.round(3 * tonumber(PARAM.room_size_multiplier_wolf_3d))
      end
    end

    if OBC.FACTORY.SECRET_EXITS[Level.name] then
      Level.secret_exit = true
    end

    table.insert(level_list, Level)
  end


  local function dump_levels()
    for idx,L in ipairs(level_list) do
      gui.printf("Wolf3d episode [%d] map [%d] : %s\n", episode, idx, L.name)
      show_quests(L.quests)
    end
  end

  OBC.decide_quests(level_list)

--  dump_levels()

  return level_list
end


----------------------------------------------------------------

function OBC.factory_setup()

  GAME.FACTORY = 
  {
    wolf_format = true,

    cell_min_size = 7,

    caps = { blocky_items=true, blocky_doors=true,
             tiered_skills=true, elevator_exits=true,
             four_dirs=true, sealed_start=true,
           },

    TILE_NUMS = OBC.FACTORY.TILE_NUMS,
    NO_TILE = OBC.FACTORY.NO_TILE,
    NO_OBJ = OBC.FACTORY.NO_OBJ,

    ERROR_TEX  = OBC.FACTORY.NO_TILE,
    ERROR_FLAT = 99, -- dummy
    SKY_TEX    = 77, -- dummy

    episodes = 4,
    level_func = OBC.get_factory_levels,

    classes  = { "assault" },

    things     = OBC.FACTORY.THINGS,
    monsters   = OBC.FACTORY.MONSTERS,
    bosses     = OBC.FACTORY.BOSSES,
    mon_give   = OBC.FACTORY.MONSTER_GIVE,
    weapons    = OBC.FACTORY.WEAPONS,

    pickups = OBC.FACTORY.PICKUPS,
    pickup_stats = { "health", "bullet" },

    initial_model = OBC.FACTORY.INITIAL_MODEL,

    quests  = OBC.FACTORY.QUESTS,

    dm = {},

    combos    = OBC.FACTORY.COMBOS,
    exits     = OBC.FACTORY.EXITS,
    hallways  = nil,

    doors     = OBC.FACTORY.DOORS,
    key_doors = OBC.FACTORY.KEY_DOORS,

    rooms     = OBC.FACTORY.ROOMS,
    themes    = OBC.FACTORY.THEMES,

    misc_fabs = OBC.FACTORY.MISC_PREFABS,

    toughness_factor = 0.40,

    room_heights = { [128]=50 },
    space_range  = { 50, 90 },
    door_probs = { combo_diff=90, normal=20, out_diff=1 },
    window_probs = { out_diff=0, combo_diff=0, normal=0 },
  }

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

  GAME.FACTORY.PREFABS = OBC.FACTORY.PREFABS

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

      P.long = math.round(f_long / 4)
      P.deep = math.round(f_deep / 4)
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

end

