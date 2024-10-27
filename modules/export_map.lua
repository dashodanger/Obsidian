----------------------------------------------------------------
--  MODULE: Export to .MAP format
----------------------------------------------------------------
--
--  Copyright (C) 2011 Andrew Apted
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

EXPORT_MAP = {}


function export_printf(fmt, ...)
  table.insert(EXPORT_MAP.ent_data, string.format(fmt, ...))
end


function EXPORT_MAP.add_brush(coords)
  local file = EXPORT_MAP.file

  if not file then return end

  -- brushes are written directly to the file
  fprintf(file, "{\n")

  local mode, def_tex
  local top, bottom
  local xy_coords = {}

  -- scan the coordinates and grab the bits we need
  for _,C in pairs(coords) do
    -- first coordinate might be just the mode / material
    if C.m then
      mode = C.m
    elseif C.t then
      top = C
    elseif C.b then
      bottom = C
    elseif C.x then
      table.insert(xy_coords, C)
    else
      error("Weird brush!")
    end

    if not def_tex and C.tex then
      def_tex = C.tex
    end
  end

  if not def_tex then def_tex = "_ERROR" end  -- FIXME

  if not top    then top    = { t= 4096, tex=def_tex } end
  if not bottom then bottom = { b=-4096, tex=def_tex } end

  -- Top
  fprintf(file, "( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) %s 0 0 0 1 1\n",
          0, 0, top.t,  0, 64, top.t,  64, 0, top.t, top.tex or def_tex)

  -- Bottom
  fprintf(file, "( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) %s 0 0 0 1 1\n",
          0, 0, bottom.b,  64, 0, bottom.b,  0, 64, bottom.b, bottom.tex or def_tex)

  -- Sides
  assert(#xy_coords >= 3)

  for i = 1,#xy_coords do
    local k = i + 1
    if k > #xy_coords then k = 1 end

    local C1 = xy_coords[i]
    local C2 = xy_coords[k]

    fprintf(file, "( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) %s 0 0 0 1.000 1.000\n",
            C1.x, C1.y, 0,  C1.x, C1.y, 64,  C2.x, C2.y, 0, C1.tex or def_tex)
  end

  fprintf(file, "}\n")
end


function EXPORT_MAP.add_entity(ent, model)
  local file = EXPORT_MAP.file

  if not file then return end

  -- ignore certain stuff
  if ent.id == "oblige_sun" then return end

  -- entity lines are not output directly, but stored instead
  export_printf("{\n")

  local classname
  local origin
  local light

  for key, value in pairs(ent) do

    -- special handling for the origin
    if key == "x" or key == "y" or key == "z" then
      if not origin then origin = {} end
      origin[key] = value
      goto continue
    end

    -- ignore any model reference
    if key == "model" then goto continue end

    -- grab the classname
    if key == "id" then
      classname = value
      goto continue
    end

    -- convert lights
    if key == "light" then
      light = (0 + value) * 2.2
      goto continue
    end

    export_printf("\"%s\" \"%s\"\n", tostring(key), tostring(value))
    ::continue::
  end


  if classname then
    export_printf("\"classname\" \"%s\"\n", classname)
  end

  if origin then
    export_printf("\"origin\" \"%d %d %d\"\n", math.floor(origin.x) or 0, math.floor(origin.y) or 0, math.floor(origin.z) or 0)
  end

  if light then
    export_printf("\"light\" \"%d\"\n", light)
  end


  if model then
    local def_tex = "_ERROR"

    export_printf("{\n")

    -- Top and Bottom
    export_printf("( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) %s 0 0 0 1 1\n",
                  0, 0, model.z2,  0, 64, model.z2,  64, 0, model.z2, model.z_face.tex or def_tex)

    export_printf("( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) %s 0 0 0 1 1\n",
                  0, 0, model.z1,  64, 0, model.z1,  0, 64, model.z1, model.z_face.tex or def_tex)

    -- Left and Right
    export_printf("( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) %s 0 0 0 1.000 1.000\n",
                  model.x1, model.y2, 0,  model.x1, model.y2, 64,  model.x1, model.y1, 64, model.x_face.tex or def_tex)

    export_printf("( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) %s 0 0 0 1.000 1.000\n",
                  model.x2, model.y1, 0,  model.x2, model.y1, 64,  model.x2, model.y2, 0, model.x_face.tex or def_tex)

    -- Back and Front
    export_printf("( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) %s 0 0 0 1.000 1.000\n",
                  model.x1, model.y1, 0,  model.x1, model.y1, 64,  model.x2, model.y1, 0, model.y_face.tex or def_tex)

    export_printf("( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) ( %1.0f %1.0f %1.0f ) %s 0 0 0 1.000 1.000\n",
                  model.x2, model.y2, 0,  model.x2, model.y2, 64,  model.x1, model.y2, 0, model.y_face.tex or def_tex)

    export_printf("}\n")
  end

  export_printf("}\n")
end


function EXPORT_MAP.add_model(model)
  local file = EXPORT_MAP.file

  if not file then return end

  assert(model.entity)

  EXPORT_MAP.add_entity(model.entity, model)
end


function EXPORT_MAP.setup()
  -- clean up any previous run which got cancelled or aborted
  if EXPORT_MAP.file then
    EXPORT_MAP.file:close()
    EXPORT_MAP.file = nil
    EXPORT_MAP.ent_data = nil
  end

  -- setup hooks
  GAME.add_brush_func  = EXPORT_MAP.add_brush
  GAME.add_entity_func = EXPORT_MAP.add_entity
  GAME.add_model_func  = EXPORT_MAP.add_model
end


function EXPORT_MAP.begin_level(self, LEVEL)
  -- pre-built levels cannot be exported
  if LEVEL.prebuilt then return end

  local filename = gui.get_save_path() .. "/" .. gui.get_filename_base() .. "-" .. LEVEL.name .. ".map"

  local file, error_msg = io.open(filename, "w")

  if not file then
    gui.printf("Failed to create file: %s\n", tostring(error_msg))
    return
  end

  gui.printf("Started .MAP export to file: %s\n", filename)

  EXPORT_MAP.file = file
  EXPORT_MAP.ent_data = {}

  fprintf(file, "// this MAP file was created by OBSIDIAN.\n")
  fprintf(file, "// it is only for the purpose of debugging.\n")

  -- write the worldspawn entity
  fprintf(file, "{\n")
  fprintf(file, "\"classname\" \"worldspawn\"\n")
  fprintf(file, "\"worldtype\" \"0\"\n")  -- FIXME
end


function EXPORT_MAP.end_level()
  local file = EXPORT_MAP.file

  if not file then return end

  -- close off the worldspawn entity
  fprintf(file, "}\n")

  -- write the entity data
  for _, str in pairs(EXPORT_MAP.ent_data) do
    fprintf(file, "%s", str)
  end

  fprintf(file, "// The End\n")

  EXPORT_MAP.file:close()
  EXPORT_MAP.file = nil
  EXPORT_MAP.ent_data = nil

  gui.printf("Finished .MAP export\n")
end


----------------------------------------------------------------


OB_MODULES["export_map"] =
{
  label = _("Export .MAP files"),

  where = "other",
  priority = -75,
  engine = "!idtech_0",
  port = "!limit_enforcing",

  tables =
  {
    EXPORT_MAP
  },

  hooks =
  {
    setup       = EXPORT_MAP.setup,
    begin_level = EXPORT_MAP.begin_level,
    end_level   = EXPORT_MAP.end_level
  }
}

