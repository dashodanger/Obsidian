----------------------------------------------------------------
--  MODULE: Optional Nodebuilding
----------------------------------------------------------------
--
--  Copyright (C) 2023-2025 The OBSIDIAN Team
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

OB_MODULES["build_nodes"] =
{
  label = _("Build Nodes"),

  where = "other",
  priority = 100,

  engine = "idtech_1",

  port = "zdoom",
  tooltip= _("Use Obsidian's internal nodebuilder to add GL Nodes to the generated mapset."),
}

