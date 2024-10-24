------------------------------------------------------------------------
--  BASE FILE for DOOM, DOOM II (etc)
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2011,2014, 2022 Reisal
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

DOOM = { }


gui.import("params")

gui.import("entities")
gui.import("factory") -- For earlier Oblige versions
gui.import("monsters")
gui.import("pickups")
gui.import("weapons")

gui.import("materials")
gui.import("themes")
gui.import("levels")
gui.import("resources")
gui.import("vanilla_mats")
gui.import("names")
gui.import("stories")

-- pull in the other Doom games...

gui.import("x_doom1")
gui.import("x_tnt")
gui.import("x_plutonia")

------------------------------------------------------------------------

OB_GAMES["doom2"] =
{
  label = _("Doom 2"),

  priority = 99,  -- keep at top

  engine = "idtech_1",
  format = "doom",
  game_dir = "doom",
  iwad_name = "doom2.wad",

  tables =
  {
    DOOM
  },

  hooks =
  {
    setup = DOOM.setup,
    factory_setup = DOOM.factory_setup,
    slump_setup = DOOM.slump_setup,
    get_levels = DOOM.get_levels,
    end_level  = DOOM.end_level,
    all_done   = DOOM.all_done
  },
}