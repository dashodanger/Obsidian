----------------------------------------------------------------
--  MODULE: id software mode
----------------------------------------------------------------
--  Copyright (C) 2022 Reisal
--  Copyright (C) 2022 dasho
--  Copyrighr (C) 2022 MsrSgtShooterPerson
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
----------------------------------------------------------------

-- This is to mimic general features seen in the Doom games. Only
-- Doom 2 has been fully analyzed (pending tweaks if needed) so
-- Doom 2 will be the one working right now.

-- Possible choices for configuration:
--
-- Size, monster quantity, lighting level, number of outdoors, secret quantity,
-- teleporters, traps, windows, steepness, street mode, procedural gotcha,
-- room height size, cages, sink type, liquids, barrels, keyed doors, normal doors,
-- nearby and distant/remote switches, fences, porches, big rooms/outdoors, ambushes,
-- scenics, symmetry, parks/park detail, caves, hallways, etc.

-- PARAMETERS FOUND THAT CAN BE USED --

-- LEVEL.size_multiplier
-- LEVEL.area_multiplier
-- LEVEL.size_consistency = "strict"/"normal"
-- LEVEL.sky_light = # here
-- LEVEL.has_streets = true/false
-- LEVEL.squareishness = 0 to 100
-- LEVEL.liquid_usage = # ? (0-100)
-- LEVEL.room_height_style
-- LEVEL.has_outdoors = "true/false?"
-- PARAM.room_heights = "normal/short-ish/short/tall/tall-ish" ???
-- or LEVEL.room_height_style ?
-- PARAM.wad_minimum_brightness /  PARAM.wad_maximum_brightness

-- END PARAMETERS --

IWAD_MODE = { }

-- Needs the following:
-- Min/Max light levels, sink style, switch goals/remote switch choices,
-- cliffs and more.

------------
-- Doom 2 --
------------

IWAD_MODE.styles = {
  -- Approximate map dimensions: 3,500 x 3,600 map units
  MAP01 = {
    outdoors = "few", -- just outdoor secret and overlook
    caves = "none",
    parks = "none",
    liquids = "few", -- outdoor secret
    hallways = "few",
    big_rooms = "none",
    big_outdoor_rooms = "none",
    teleporters = "none",
    steepness = "few",
    traps = "none",
    cages = "few",
    ambushes = "few",
    doors = "few", -- side room and exit doors
    windows = "few", -- one window
    switches = "few", -- secret switch doesn't count
    keys = "none",
    trikeys= "none",
    scenics = "few",
    secrets = "few", -- shotgun secret
    parks = "none", -- nope!
    park_detail = "none",
    symmetry = "none",
    pictures = "some",
    barrels = "none",
    beams = "few",
    porches = "some",
    fences = "none"
  },

  MAP02 =
  {
    liquids = "heaps", -- everywhere!
    outdoors = "none", -- indoor map
    parks = "none",
    park_detail = "none",
    hallways = "few",
    big_rooms = "none",
    big_outdoor_rooms = "none",
    steepness = "few",
    traps = "some",
    windows = "few", -- map is indoors
    teleporters = "few", -- just that one by red key..
    keys = "few", -- single red door
    trikeys = "none",
    switches = "few",
    barrels = "some", -- lower rooms have them
    porches = "none",
    cages = "none",
    fences = "none",
    scenics = "none",
    pictures = "some",
    symmetry = "none",
    beams = "none",
    caves = "none"
  },

  -- MAP03 Approximate map dimensions: 3,000 x 2,000 map units
  MAP03 =
  {
    outdoors = "some",
    liquids = "some", -- pools around main room outside
    parks = "none",
    park_detail = "none",
    big_rooms = "some",
    big_outdoor_rooms = "few",
    traps = "few",
    keys = "few",
    trikeys = "none",
    cages = "few",
    barrels = "none",
    switches = "few",
    scenics = "few",
    windows = "some",
    fences = "none",
    symmetry = "none",
    porches = "few",
    teleporters = "few",
    steepness = "some",
    doors = "few",
    caves = "none",
    pictures = "few"
  },

  -- MAP04 Approximate map dimensions: 2,000 x 1,650 map units
  MAP04 =
  {
    outdoors ="none", -- totally indoors!
    big_outdoor_rooms = "none", -- again, inside
    big_rooms = "none", -- small, cramped rooms
    barrels = "some",
    keys = "heaps", -- three keys in map
    trikeys = "none",
    cages = "none",
    teleporters = "few",
    switches = "few",
    windows = "few",
    parks = "none",
    park_detail = "none",
    liquids = "few", -- just that slime pool leading to SSG secret
    traps = "some",
    symmetry = "none",
    steepness = "few",
    secrets = "few",
    porches = "none",
    caves = "none",
    pictures = "heaps"
  },

  -- MAP05 Approximate map dimensions: 3,150 x 2,150 map units
  MAP05 =
  {
    outdoors = "some", -- courtyard
    big_outdoor_areas = "few",
    parks = "few",
    steepness = "heaps",
    doors = "some",
    keys = "some",
    trikeys = "none",
    teleporters = "few",
    ambushes = "heaps", -- lots of them near start
    traps = "some",
    liquids = "some",
    barrels = "none",
    secrets = "few",
    hallways = "some",
    porches = "heaps",
    switches = "few",
    caves = "few",
    pictures = "few"
  },

  -- MAP06 Approximate map dimensions: 4,000 x 2,500 map units
  MAP06 =
  {
    outdoors = "few", -- outdoor lava courtyard
    liquids = "some",
    big_rooms = "some", -- Mastermind crusher room
    big_outdoor_rooms = "none",
    barrels = "few", -- megasphere room only
    keys = "some",
    trikeys ="few", -- sure, why not?
    ambushes = "some",
    traps = "heaps",
    steepness = "heaps",
    windows = "none",
    hallways = "few",
    symmetry = "none",
    teleporters = "few",
    cages = "some",
    porches = "few",
    switches = "some",
    caves = "none",
    pictures = "some"
  },

  -- MAP07 Approximate map dimensions: 2,300 x 2,000 map units
  MAP07 =
  {
    symmetry = "heaps", -- map is completely symmetrical
    outdoors = "heaps", -- lots of outdoors
    big_outdoor_rooms = "some",
    parks = "none",
    park_detail = "none",
    ambushes = "some",
    beams = "heaps",
    traps = "heaps",
    teleporters ="none",
    porches = "few",
    liquids = "none",
    cages = "none",
    steepness = "few", -- one of the few Doom 2 maps with very little height variation
    hallways = "none",
    barrels = "none",
    windows = "few",
    doors = "few",
    keys = "few",
    trikeys = "none",
    switches = "some",
    caves = "none",
    pictures = "few"
  },

  -- MAP08 Approximate map dimensions: 4,000 x 4,000 map units
  MAP08 =
  {
    outdoors = "none", -- another totally indoor map..
    windows = "none",
    big_outdoor_rooms = "none",
    traps = "heaps", -- not called "Tricks and Traps" for nothing!
    ambushes = "heaps",
    steepness = "some",
    barrels = "none",
    hallways = "some",
    keys = "some",
    trikeys = "few",
    switches = "some",
    teleporters = "some",
    symmetry = "none",
    doors = "some",
    porches = "none",
    beams = "some",
    caves = "none",
    pictures = "heaps",
    caves = "none"
  },

  -- MAP09 Approximate map dimensions: 4,200 x 4,000 map units
  MAP09 =
  {
    steepness = "heaps",
    outdoors = "few",
    big_outdoor_rooms = "some",
    symmetry = "none",
    doors = "some",
    keys ="heaps",
    trikeys = "some",
    porches = "few",
    teleporters ="few",
    traps = "some",
    switches = "some",
    beams = "few",
    ambushes = "heaps",
    traps = "few",
    pictures = "some",
    barrels = "none",
    liquids = "few",
    parks = "none",
    cages = "heaps",
    secrets = "few",
    hallways = "some",
    windows = "few",
    scenics = "none",
    caves = "none"
  },

  -- MAP10 Approximate map dimensions: 4,200 x 4,200 map units
  MAP10 =
  {
    big_rooms = "heaps",
    big_outdoor_rooms = "few",
    caves = "few",
    doors = "some",
    keys = "heaps",
    trikeys = "few",
    switches = "few",
    barrels = "some",
    outdoors = "none",
    steepness = "few",
    fences = "none",
    liquids = "none",
    ambushes = "some",
    traps = "some",
    hallways = "few",
    windows = "few",
    beams = "some",
    scenics = "few"
  },

  -- MAP11 Approximate map dimensions: 3,600 x 2,900 map units
  MAP11 =
  {
    outdoors = "heaps", -- It *is* outside mostly..
    big_outdoor_rooms = "heaps",
    big_rooms = "some",
    steepness = "heaps",
    windows = "some",
    doors = "few",
    keys = "some",
    trikeys = "few",
    caves = "some",
    ambushes = "some",
    traps = "some",
    beams = "heaps",
    switches = "few",
    teleporters = "some",
    secrets = "some",
    liquids = "heaps",
    cages = "some",
    scenics = "some",
    parks = "few",
    symmetry = "none"
  },

  -- MAP12 Approximate map dimensions: 4,000 x 4,400 map units
  MAP12 =
  {
    outdoors = "heaps",
    big_outdoor_rooms = "heaps",
    big_rooms = "few",
    windows = "few",
    scenics = "heaps",
    steepness = "some",
    parks = "few",
    park_detail = "few",
    ambushes = "few",
    traps = "some",
    keys = "some",
    trikeys = "few",
    switches = "some",
    liquids = "none",
    teleporters = "few",
    secrets = "few",
    doors = "some",
    beams = "none",
    symmetry = "some",
    cages = "few",
    pictures = "some",
    barrels = "none",
    caves = "none"
  },

  -- MAP13 Approximate map dimensions: 3,200 x 4,100 map units
  MAP13 =
  {
    outdoors = "heaps",
    big_outdoor_rooms = "few",
    doors = "heaps",
    big_rooms = "some",
    windows = "heaps",
    ambushes = "some",
    traps = "some",
    keys = "heaps",
    trikeys = "some",
    switches = "some",
    steepness = "heaps",
    barrels = "few",
    teleporters = "some",
    secrets = "some",
    symmetry = "heaps",
    cages = "heaps",
    pictures = "some",
    liquids = "none",
    caves = "none",
    scenics = "some",
    fences = "few",
    porches = "some",
    hallways = "few"
  },

  -- MAP14 Approximate map dimensions: 3,900 x 3,600 map units
  MAP14 =
  {
    outdoors = "some",
    big_outdoor_rooms = "few",
    big_rooms = "some",
    steepness = "some",
    windows = "heaps",
    ambushes = "some",
    traps = "some",
    barrels = "none",
    teleporters = "few",
    scenics = "some",
    fences = "heaps",
    porches = "heaps",
    liquids = "some",
    keys = "heaps",
    trikeys = "none",
    symmetry = "heaps",
    secrets = "few",
    hallways = "none",
    parks = "few",
    park_detail = "some",
    caves = "none"
  },

  -- MAP15 Approximate map dimensions: 4,300 x 7,200 map units
  MAP15 =
  {
    outdoors = "heaps",
    big_outdoor_rooms = "heaps",
    windows = "some",
    steepness = "heaps",
    barrels = "some",
    ambushes = "some",
    traps = "few",
    secrets = "heaps",
    porches = "heaps",
    teleporters = "some",
    liquids = "some",
    keys = "some",
    trikeys = "none",
    hallways = "none",
    scenics = "some",
    symmetry = "heaps",
    fences = "heaps",
    parks = "none",
    hallways = "few",
    switches = "some",
    pictures = "heaps",
    cages = "some",
    caves = "few"
  },

  -- MAP16 Approximate map dimensions: 4,900 x 4,800 map units
  MAP16 =
  {
    outdoors = "heaps",
    big_outdoor_rooms = "few",
    windows = "heaps",
    big_rooms = "none",
    steepness = "some",
    switches = "few",
    keys = "some",
    trikeys = "some",
    liquids = "few",
    pictures = "heaps",
    hallways = "few",
    fences = "some",
    scenics = "heaps",
    symmetry = "some",
    ambushes = "some",
    traps = "heaps",
    secrets = "few",
    barrels = "none",
    beams = "some",
    cages = "few",
    caves = "none"
  },

-- MAP17 Approximate map dimensions: 3,300 x 3,300 map units
MAP17 =
{
  outdoors ="few",
  big_rooms = "none",
  big_outdoor_rooms = "none",
  barrels = "few",
  cages = "some",
  doors = "some",
  hallways = "few",
  liquids = "few",
  steepness = "heaps",
  symmetry = "none",
  traps = "heaps",
  beams = "few",
  secrets = "few",
  fences = "none",
  scenics = "none",
  switches = "some",
  keys = "some",
  trikeys = "few",
  parks = "none",
  porches = "some",
  caves = "none"
},

-- MAP18 Approximate map dimensions: 4,900 x 4,500 map units
MAP18 =
{
  big_rooms = "none",
  big_outdoor_rooms = "some",
  parks = "heaps",
  doors = "few",
  steepness = "few",
  switches = "some",
  keys = "some",
  trikeys = "some",
  hallways = "none",
  beams = "some",
  symmetry = "none",
  scenics = "some",
  barrels = "few",
  windows = "few",
  cages = "none",
  traps = "some",
  liquids = "few",
  porches = "few",
  secrets = "few",
  caves = "none"
},

-- MAP19 Approximate map dimensions: 5,550 x 6,000 map units
MAP19 =
{
  outdoors = "heaps",
  big_outdoor_rooms = "heaps",
  doors = "heaps",
  keys = "heaps",
  trikeys = "some",
  windows = "heaps",
  steepness = "some",
  switches = "some",
  traps = "few",
  secrets = "some",
  porches = "few",
  cages = "heaps",
  scenics = "heaps",
  liquids = "few",
  beams = "few",
  symmetry = "some",
  hallways = "few",
  teleporters = "some",
  caves = "none"
},

-- MAP20 Approximate map dimensions: 5,200 x 6,300 map units
MAP20 =
{
  steepness = "heaps",
  outdoors = "some",
  big_outdoor_rooms = "heaps",
  big_rooms = "some",
  hallways = "none",
  secrets = "some",
  scenics = "heaps",
  beams = "none",
  liquids = "heaps",
  porches = "some",
  fences = "none",
  windows = "Few",
  switches = "few",
  doors = "few",
  traps = "some",
  symmetry = "none",
  keys = "few",
  trikeys = "none",
  teleporters = "few",
  parks = "none",
  caves = "few"
},

-- MAP21 Approximate map dimensions: 3,500 x 3,000 map units
MAP21 =
{
  outdoors = "few",
  parks = "none",
  big_outdoor_rooms = "none",
  barrels = "none",
  steepness = "few",
  keys = "few",
  trikeys = "some",
  traps = "some",
  doors = "few",
  teleporters = "some",
  beams = "none",
  scenics = "none",
  liquids = "few",
  porches = "few",
  fences = "none",
  switches = "few",
  cages = "none",
  windows = "none",
  secrets = "Few",
  hallways = "none",
  caves = "none"
},

-- MAP22 Approximate map dimensions: 2,300 x 1,850 map units
MAP22 =
{
  outdoors ="few",
  big_outdoor_rooms = "none",
  big_rooms ="none",
  doors = "few",
  steepness = "heaps",
  teleporters = "few",
  secrets = "few",
  traps = "some",
  scenics = "none",
  liquids = "few",
  beams = "few",
  porches = "few",
  fences = "none",
  windows = "some",
  cages = "few",
  keys = "few",
  trikeys = "none",
  parks = "none",
  hallways = "none",
  caves = "none",
  barrels = "few",
  switches = "few",
  pictures = "some"
},

-- MAP23 Approximate map dimensions: 4,300 x 5,050 map units
MAP23 =
{
  barrels = "heaps", -- Any way to have more than this?
  big_rooms = "heaps",
  big_outdoor_rooms = "none",
  doors = "few",
  traps = "some",
  windows = "few",
  liquids = "few",
  cages = "some",
  steepness = "heaps",
  beams = "none",
  keys = "few",
  trikeys = "none",
  switches = "few",
  teleporters = "few",
  caves = "few",
  parks = "none",
  scenics = "few",
  fences = "few",
  secrets = "some",
  symmetry = "none",
  hallways = "few",
  pictures = "few"
},

-- MAP24 Approximate map dimensions: 6,000 x 5,300 map units
MAP24 =
{
  steepness = "heaps",
  liquids = "heaps",
  cages = "some",
  doors = "some",
  keys = "heaps",
  trikeys = "some",
  teleporters = "some",
  outdoors = "none",
  big_outdoor_rooms = "none",
  big_rooms = "heaps",
  parks = "none",
  traps = "some",
  switches = "some",
  scenics = "none",
  fences = "few",
  beams = "few",
  caves = "none",
  windows = "few",
  symmetry = "none",
  pictures = "few"
},

-- MAP25 Approximate map dimensions: 3,600 x 7,200 map units
MAP25 =
{
  outdoors = "few",
  big_outdoor_rooms = "none",
  steepness = "heaps",
  switches = "some",
  keys = "few",
  trikeys = "few",
  windows = "none",
  cages = "some",
  caves = "some",
  hallways = "few",
  doors = "some",
  teleporters = "few",
  traps = "some",
  switches = "few",
  barrels = "few",
  porches = "some",
  fences = "some",
  scenics = "few",
  parks = "few",
  symmmetry = "none",
  pictures = "some"
},

-- MAP26 Approximate map dimensions: 4,600 x 3,200 map units
MAP26 =
{
  outdoors = "few",
  big_outdoor_rooms = "none",
  barrels = "some",
  cages = "heaps",
  hallways = "some",
  caves = "some",
  liquids = "heaps",
  steepness = "heaps",
  traps = "heaps",
  switches = "some",
  keys = "heaps",
  trikeys = "some",
  windows = "some",
  parks = "none",
  scenics = "some",
  porches = "some",
  teleporters = "some",
  secrets = "few",
  doors = "few",
  pictures = "some"
},

-- MAP27 Approximate map dimensions: 3,900 x 4,500 map units
MAP27 =
{
  outdoors = "few",
  big_outdoor_rooms = "few",
  big_rooms = "heaps",
  traps = "some",
  windows = "none",
  steepness = "some",
  doors = "few",
  keys = "some",
  trikeys = "few",
  secrets = "heaps",
  porches = "some",
  beams = "some",
  barrels = "none",
  parks = "none",
  symmetry = "heaps",
  liquids = "few",
  caves = "none",
  switches = "few",
  teleporters = "few",
  scenics = "none",
  pictures = "few",
  fences = "none"
},

-- MAP28 Approximate map dimensions: 4,400 x 5,000 map units
MAP28 =
{
  outdoors = "none",
  big_rooms = "heaps",
  big_outdoor_rooms = "none",
  symmetry = "none",
  caves = "some",
  cages = "some",
  traps = "some",
  doors = "few",
  keys = "heaps",
  trikeys = "heaps",
  secrets = "some",
  switches = "few",
  liquids = "few",
  pictures = "few",
  hallways = "few",
  parks = "few",
  park_detail = "heaps",
  teleporters = "some",
  fences = "few",
  porches = "few",
  windows = "none"
},

-- MAP29 Approximate map dimensions: 4,800 x 4,600 map units
MAP29 =
{
  outdoors = "none",
  big_rooms = "some",
  big_outdoor_rooms = "none",
  traps = "some",
  steepness = "heaps",
  symmetry = "none",
  teleporters = "some",
  windows = "few",
  switches = "heaps",
  scenics = "some",
  porches = "few",
  cages = "heaps",
  caves = "some",
  pictures = "some",
  doors = "few",
  keys = "few",
  trikeys = "none",
  barrels = "none",
  liquids = "heaps"
},

-- MAP30 Approximate map dimensions: 2,750 x 2,800 map units
MAP30 =
{
  outdoors = "none",
  windows = "none",
  steepness = "heaps",
  liquids = "some",
  barrels = "none",
  fences = "some",
  scenics = "heaps",
  keys = "none",
  trikeys = "none",
  switches = "few",
  porches = "some",
  secrets = "few",
  cages = "some",
  hallways = "none",
  caves = "none",
  traps = "some"
},

-- MAP31 Approximate map dimensions: 8,750 x 7,200 map units
MAP31 =
{
  outdoors = "none",
  big_outdoor_rooms = "none",
  windows = "none",
  big_rooms = "heaps",
  steepness = "few",
  barrels = "few",
  switches = "none",
  scenics = "none",
  keys = "none",
  trikeys = "none",
  teleporters = "none",
  liquids = "none",
  traps = "some",
  doors = "heaps",
  pictures = "some",
  caves = "none",
  cages = "some",
  fences = "few",
  symmetry = "heaps"
},

-- MAP32 Approximate map dimensions: 4,000 x 7,200 map units
MAP32 =
{
  outdoors = "few",
  big_outdoor_rooms = "none",
  windows = "none",
  big_rooms = "heaps",
  steepness = "few",
  barrels = "none",
  switches = "none",
  scenics = "none",
  keys = "none",
  trikeys = "none",
  teleporters = "none",
  liquids = "none",
  traps = "heaps",
  doors = "few",
  pictures = "some",
  caves = "none",
  cages = "some",
  fences = "few",
  symmetry = "heaps"
}
}

-- translate changes to here instead
function IWAD_MODE.begin_level(self, LEVEL)

  local nt = assert(namelib.NAMES)

  if LEVEL.name == "MAP01" then
    LEVEL.map_W = 22
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.e)
    LEVEL.size_multiplier = 0.6
    LEVEL.size_consistency = "strict"
    LEVEL.sky_light = 192
    LEVEL.room_height_style = "short-ish"
  elseif LEVEL.name == "MAP02" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.6
    LEVEL.area_multiplier = 0.5
    LEVEL.size_consistency = "strict"
    LEVEL.sky_light = 192
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.e)
    LEVEL.room_height_style = "short"
  elseif LEVEL.name == "MAP03" then
    LEVEL.map_W = 25
    LEVEL.size_multiplier = 0.75
    LEVEL.sky_light = 144
    LEVEL.size_consistency = "normal"
    LEVEL.description = "The " .. rand.key_by_probs(nt.TECH.lexicon.n)
    LEVEL.room_height_style = "normal"
  elseif LEVEL.name == "MAP04" then
    LEVEL.map_W = 20
    LEVEL.size_multiplier = 0.6
    LEVEL.size_consistency = "strict"
    LEVEL.sky_light = 160
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.e)
    LEVEL.room_height_style = "short"
  elseif LEVEL.name == "MAP05" then
    LEVEL.map_W = 28
    LEVEL.size_multiplier = 0.7
    LEVEL.sky_light = 144
    LEVEL.size_consistency = "normal"
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.e)
    LEVEL.squareishness = 35
    LEVEL.room_height_style = "tall-ish"
  elseif LEVEL.name == "MAP06" then
    LEVEL.map_W = 30
    LEVEL.size_multiplier = 0.7
    LEVEL.size_consistency = "normal"
    LEVEL.sky_light = 192
    LEVEL.description = "The " .. rand.key_by_probs(nt.TECH.lexicon.n)
    LEVEL.room_height_style = "tall-ish"
  elseif LEVEL.name == "MAP07" then
    LEVEL.map_W = 26
    LEVEL.size_consistency = "strict"
    LEVEL.is_procedural_gotcha = true
    LEVEL.sky_light = 192
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.c) .. " Simple"
    LEVEL.size_multiplier = 1.2
    LEVEL.area_multiplier = 0.75
    LEVEL.room_height_style = "short-ish"
  elseif LEVEL.name == "MAP08" then
    LEVEL.map_W = 28
    LEVEL.size_multiplier = 0.8
    LEVEL.size_consistency = "strict"
    LEVEL.sky_light = 192
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.d) .. " and Traps"
    LEVEL.room_height_style = "tall-ish"
  elseif LEVEL.name == "MAP09" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.7
    LEVEL.size_consistency = "normal"
    LEVEL.sky_light = 144
    LEVEL.description = "The " .. rand.key_by_probs(nt.URBAN.lexicon.o)
    LEVEL.room_height_style = "tall"
  elseif LEVEL.name == "MAP10" then
    LEVEL.map_W = 32
    LEVEL.size_multiplier = 1.2
    LEVEL.area_multiplier = 0.7
    LEVEL.size_consistency = "normal"
    LEVEL.sky_light = 144
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.e)
    LEVEL.squareishness = 30
    LEVEL.room_height_style = "tall-ish"
  elseif LEVEL.name == "MAP11" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.8
    LEVEL.size_consistency = "normal"
    LEVEL.sky_light = 160
    LEVEL.description = rand.key_by_probs(nt.TECH.lexicon.n) .. " of Destruction"
    LEVEL.room_height_style = "tall"
  elseif LEVEL.name == "MAP12" then
    LEVEL.map_W = 36
    LEVEL.size_consistency = "strict"
    LEVEL.size_multiplier = 0.75
    LEVEL.has_streets = true -- Its shape implies this
    LEVEL.is_nature = false
    LEVEL.sky_light = 144
    LEVEL.squareishness = 55
    LEVEL.description = "The " .. rand.key_by_probs(nt.URBAN.lexicon.n)
    LEVEL.room_height_style = "tall-ish"
  elseif LEVEL.name == "MAP13" then
    LEVEL.map_W = 40
    LEVEL.size_multiplier = 0.7
    LEVEL.size_consistency = "normal"
    LEVEL.sky_light = 128
    LEVEL.has_streets = true
    LEVEL.is_nature = false
    LEVEL.description = rand.key_by_probs(nt.URBAN.lexicon.a) .. " Downtown"
    LEVEL.squareishness = 60
    LEVEL.room_height_style = "tall"
  elseif LEVEL.name == "MAP14" then
    LEVEL.map_W = 30
    LEVEL.size_multiplier = 0.5
    LEVEL.size_consistency = "strict"
    LEVEL.area_multiplier = 0.8
    LEVEL.sky_light = 144
    LEVEL.squareishness = 25
    LEVEL.description = rand.key_by_probs(nt.URBAN.lexicon.a) .. " Dens"
    LEVEL.room_height_style = "normal"
  elseif LEVEL.name == "MAP15" then
    LEVEL.map_W = 44
    LEVEL.size_multiplier = 0.8
    LEVEL.area_multiplier = 1.1
    LEVEL.size_consistency = "normal"
    LEVEL.sky_light = 160
    LEVEL.has_streets = true -- Shaped enough for this
    LEVEL.is_nature = false
    LEVEL.description = rand.key_by_probs(nt.URBAN.lexicon.a) .. " Industrial Zone"
    LEVEL.squareishness = 55
    LEVEL.room_height_style = "tall"
  elseif LEVEL.name == "MAP16" then -- Streets mode
    LEVEL.map_W = 38
    LEVEL.size_multiplier = 1.2
    LEVEL.area_multiplier = 0.8
    LEVEL.size_consistency = "normal"
    LEVEL.has_streets = true
    LEVEL.is_nature = false
    LEVEL.sky_light = 144
    LEVEL.squareishness = 30
    LEVEL.room_height_style = "normal"
  elseif LEVEL.name == "MAP17" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.65
    LEVEL.area_multiplier = 1.2
    LEVEL.size_consistency = "strict"
    LEVEL.sky_light = 192
    LEVEL.room_height_style = "tall"
  elseif LEVEL.name == "MAP18" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.7
    LEVEL.size_consistency = "strict"
    LEVEL.area_multiplier = 0.75
    LEVEL.sky_light = 160
    LEVEL.description = "The " .. rand.key_by_probs(nt.GOTHIC.lexicon.n)
    LEVEL.squareishness = 60
    LEVEL.room_height_style = "tall-ish"
  elseif LEVEL.name == "MAP19" then
    LEVEL.map_W = 34
    LEVEL.size_multiplier = 0.7
    LEVEL.area_multiplier = 1.2
    LEVEL.size_consistency = "normal"
    LEVEL.sky_light = 176
    LEVEL.description = rand.key_by_probs(nt.URBAN.lexicon.a) .. " Citadel"
    LEVEL.squareishness = 40
    LEVEL.room_height_style = "normal"
  elseif LEVEL.name == "MAP20" then
    LEVEL.map_W = 40
    LEVEL.size_multiplier = 0.9
    LEVEL.area_multiplier = 2.0
    LEVEL.size_consistency = "normal"
    LEVEL.sky_light = 255 -- dunno why id put 255
    LEVEL.room_height_style = "tall"
  elseif LEVEL.name == "MAP21" then
    LEVEL.map_W = 22
    LEVEL.size_multiplier = 0.5
    LEVEL.area_multiplier = 1.2
    LEVEL.sky_light = 160
    LEVEL.size_consistency = "strict"
    LEVEL.room_height_style = "short-ish"
  elseif LEVEL.name == "MAP22" then
    LEVEL.map_W = 24
    LEVEL.size_multiplier = 0.5
    LEVEL.area_multiplier = 1.2
    LEVEL.sky_light = 192
    LEVEL.size_consistency = "strict"
    LEVEL.description =  "The " .. rand.key_by_probs(nt.GOTHIC.lexicon.n)
    LEVEL.squareishness = 30
    LEVEL.room_height_style = "normal"
  elseif LEVEL.name == "MAP23" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.7
    LEVEL.area_multiplier = 1.3
    LEVEL.sky_light = 160
    LEVEL.size_consistency = "normal"
    LEVEL.description = "Barrels o' " .. rand.key_by_probs(nt.URBAN.lexicon.h)
    LEVEL.room_height_style = "tall-ish"
  elseif LEVEL.name == "MAP24" then
    LEVEL.map_W = 30
    LEVEL.size_multiplier = 0.8
    LEVEL.area_multiplier = 1.5
    LEVEL.size_consistency = "normal"
    LEVEL.sky_light = 144 -- guess, can't find indoors
    LEVEL.description =  "The " .. rand.key_by_probs(nt.GOTHIC.lexicon.n)
    LEVEL.room_height_style = "tall"
  elseif LEVEL.name == "MAP25" then
    LEVEL.map_W = 26
    LEVEL.size_multiplier = 0.6
    LEVEL.area_multiplier = 1.3
    LEVEL.sky_light = 128
    LEVEL.size_consistency = "strict"
    LEVEL.description = rand.key_by_probs(nt.GOTHIC.lexicon.a) .. " Bloodfalls"
    LEVEL.room_height_style = "normal"
  elseif LEVEL.name == "MAP26" then
    LEVEL.map_W = 30
    LEVEL.size_multiplier = 0.8
    LEVEL.area_multiplier = 1.5
    LEVEL.size_consistency = "normal"
    LEVEL.sky_light = 144
    LEVEL.description = rand.key_by_probs(nt.GOTHIC.lexicon.a) .. " Mines"
    LEVEL.room_height_style = "tall-ish"
  elseif LEVEL.name == "MAP27" then
    LEVEL.map_W = 24
    LEVEL.size_multiplier = 0.6
    LEVEL.area_multiplier = 1.25
    LEVEL.size_consistency = "strict"
    LEVEL.sky_light = 144
    LEVEL.description =  "Monster " .. rand.key_by_probs(nt.GOTHIC.lexicon.n)
    LEVEL.squareishness = 45
    LEVEL.room_height_style = "short-ish"
  elseif LEVEL.name == "MAP28" then
    LEVEL.map_W = 28
    LEVEL.size_multiplier = 0.8
    LEVEL.area_multiplier = 1.5
    LEVEL.size_consistency = "strict"
    LEVEL.sky_light = 144
    LEVEL.room_height_style = "tall"
  elseif LEVEL.name == "MAP29" then
    LEVEL.map_W = 32
    LEVEL.size_multiplier = 0.8
    LEVEL.area_multiplier = 1.4
    LEVEL.size_consistency = "strict"
    LEVEL.sky_light = 144
    LEVEL.description =  "The Living " .. rand.key_by_probs(nt.GOTHIC.lexicon.h)
    LEVEL.room_height_style = "tall"
  elseif LEVEL.name == "MAP30" then
    LEVEL.map_W = 36
    LEVEL.size_multiplier = 1.5
    LEVEL.area_multiplier = 1.5
    LEVEL.size_consistency = "strict"
    LEVEL.is_procedural_gotcha = true
    LEVEL.sky_light = 144
    LEVEL.description = "Icon of " .. rand.key_by_probs(nt.GOTHIC.lexicon.h)
    LEVEL.room_height_style = "tall-ish"
  elseif LEVEL.name == "MAP31" then
    LEVEL.map_W = 28
    LEVEL.size_multiplier = 0.5
    LEVEL.area_multiplier = 0.75
    LEVEL.size_consistency = "normal"
    LEVEL.sky_light = 192
    LEVEL.squareishness = 90
    LEVEL.room_height_style = "short"
  elseif LEVEL.name == "MAP32" then
    LEVEL.map_W = 24
    LEVEL.size_multiplier = 0.6
    LEVEL.area_multiplier = 0.5
    LEVEL.size_consistency = "strict"
    LEVEL.sky_light = 192
    LEVEL.squareishness = 80
    LEVEL.room_height_style = "short"
    end

  
  -- LEVEL.description = "Icon of " .. rand.key_by_probs(nt.GOTHIC.lexicon.h) - For reference
  -- LEVEL.description = rand.key_by_probs(nt.URBAN.lexicon.a) .. " Citadel" - For reference

  -- combine explicit tables from above
  if IWAD_MODE.styles[LEVEL.name] then
    table.merge(STYLE, IWAD_MODE.styles[LEVEL.name])
  end

 -- sanity check and fixing for level names
  LEVEL.description = namelib.fix_up(LEVEL.description)
  LEVEL.map_H = LEVEL.map_W

  -- reporting changes
  gui.printf(table.tostr(LEVEL,2))
end

OB_MODULES["iwad_mode"] =
{
  label = _("IWAD Style Mode"),
  port = "!limit_enforcing",
  game = "doom2", -- Only one supported for now
  where = "arch",
  priority = 60,
  tooltip =_("Attempts to mimic various architectural features seen in the Doom 2 IWAD maps.\nNOTE: This will override settings in other parts of the program such as Level Size, Room Size, etc!"),

  hooks =
  {
    begin_level = IWAD_MODE.begin_level
  }
}
