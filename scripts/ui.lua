------------------------------------------------------------------------
--  OBSIDIAN  :  NUKLEAR UI INTERFACE
------------------------------------------------------------------------
--
--
--  Copyright (C) 2024 The OBSIDIAN Team
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

-- CAVEMAN SHIT BELOW THIS LINE --

local normal_font
local bold_font

function ob_gui_init_fonts(font_scale)
  if OB_NK_CTX == nil then return "bork" end
  if OB_NK_ATLAS == nil then return "bork" end
  normal_font = OB_NK_ATLAS:add(24 * font_scale, "data/fonts/SourceSansPro/SourceSansPro-Regular.ttf")
  normal_font:set_height(24)
  bold_font = OB_NK_ATLAS:add(28 * font_scale, "data/fonts/SourceSansPro/SourceSansPro-Bold.ttf")
  bold_font:set_height(28)
  nk.style_set_font(OB_NK_CTX, normal_font)
  return "groovy"
end

local op = 'Doom'
local value = 0.6

function ob_gui_frame(width, height)
  if OB_NK_CTX == nil then return "quit" end

  if nk.window_begin(OB_NK_CTX, "Build", {0, 0, width, height}, 0) then

    -- fixed widget pixel width
    nk.layout_row_static(OB_NK_CTX, 30, 150, 1)

    if nk.button(OB_NK_CTX, nil, "File Picker Test") then
        OB_NK_PICKED_FILE = nil
        gui.spawn_file_picker()
    end

    -- fixed widget window ratio width
    nk.layout_row_dynamic(OB_NK_CTX, 30, 2)
    if nk.option(OB_NK_CTX, 'Doom', op == 'Doom') then op = 'Doom' end
    if nk.option(OB_NK_CTX, 'Heretic', op == 'Heretic') then op = 'Heretic' end

    -- custom widget pixel width
    nk.layout_row_begin(OB_NK_CTX, 'static', 30, 2)
    nk.layout_row_push(OB_NK_CTX, 50)
    nk.label(OB_NK_CTX, "Size:", nk.TEXT_LEFT)
    nk.layout_row_push(OB_NK_CTX, 110)
    value = nk.slider(OB_NK_CTX, 0, value, 1.0, 0.1)
    nk.layout_row_end(OB_NK_CTX)
    if OB_NK_PICKED_FILE ~= nil then
      nk.layout_row_push(OB_NK_CTX, 512)
      nk.label(OB_NK_CTX, OB_NK_PICKED_FILE, nk.TEXT_LEFT)
      nk.layout_row_end(OB_NK_CTX)
    end
  end
  nk.window_end(OB_NK_CTX)
  return "ok"
end