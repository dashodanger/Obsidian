----------------------------------------------------------------
--  MODULE: Compress output to PK3
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

OB_MODULES["compress_output"] =
{
  label = _("PK3/ZIP Output"),

  where = "other",
  priority = 100,

  engine = "idtech_1",

  port = "advanced",
  tooltip= _("Automatically compress output to PK3 to save space."),
}

