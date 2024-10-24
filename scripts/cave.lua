------------------------------------------------------------------------
--  CAVES and MAZES
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2009-2017 Andrew Apted
--  Copyright (C) 2020-2022 MsrSgtShooterPerson
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


--class BLOB
--[[
    --
    -- This describes a group of contiguous cells.
    --

    area : AREA   -- parent area

    cx1, cy1, cx2, cy2   -- cell bounding box

    floor_h    -- floor height
    floor_mat  -- floor material

    ceil_h     -- ceiling height    [ NIL for none, i.e. external_sky area ]
    ceil_mat   -- ceiling material

    is_wall   : boolean  -- true for solid walls
    is_fence  : boolean  -- true for a lake fence
    is_liquid : boolean  -- true for a liquid floor
    is_sky    : boolean  -- true for a sky ceiling

    is_waterfall : boolean

    goal_type : keyword     -- set if blob contains a goal

    neighbors : list(BLOB)  -- only used for visitable floors

    -- stuff for walkways only  [ FIXME ]
    children : list(BLOB)
--]]


CELL_CORNERS = { 1,3,9,7 }


function Cave_brush(area, x, y)
  local bx = area.base_x + (x - 1) * 64
  local by = area.base_y + (y - 1) * 64

  local coords = {}

  local diag_map = area.diagonals

  for _,side in pairs(CELL_CORNERS) do
    -- create a triangle when cell straddles a diagonal seed
    if diag_map[x][y] == 10 - side then goto continue end

    local dx, dy = geom.delta(side)

    local fx = bx + sel(dx < 0, 0, 64)
    local fy = by + sel(dy < 0, 0, 64)

    local cx =  x + sel(dx < 0, 0, 1)
    local cy =  y + sel(dy < 0, 0, 1)

    fx = fx + (area.delta_x_map[cx][cy] or 0)
    fy = fy + (area.delta_y_map[cx][cy] or 0)

    table.insert(coords, { x=fx, y=fy })
    ::continue::
  end

  return coords
end



function Cave_is_edge(S, dir, SEEDS)
  local N = S:raw_neighbor(dir, nil, SEEDS)

  if not N then return true end

  if N.room ~= S.room then return true end

  -- check for dead closets
  if N.area and N.area.mode == "void" then return true end

  -- edge of a closet?
  if N.chunk and N.chunk.kind == "closet" then
    return dir ~= (10 - N.chunk.from_dir)
  end

  -- edge of a joiner?
  if N.chunk and N.chunk == "joiner" then
    if dir == (10 - N.chunk.from_dir) then return false end
    if dir == (10 - N.chunk.dest_dir) then return false end
    return true
  end

  return false
end



function Cave_find_area_for_room(R)
  for _,A in pairs(R.areas) do
    if A.mode == "nature" then
      return A
    end
  end

  error("Cave/park room has no nature area")
end



function Cave_setup_stuff(area, SEEDS)
  assert(area)

  -- determine extent of cells
  local sx1,sy1, sx2,sy2 = area:calc_seed_bbox()

  area.cw = 2 * (sx2 - sx1 + 1)
  area.ch = 2 * (sy2 - sy1 + 1)

  area.base_sx = sx1
  area.base_sy = sy1

  area.bound_sx = sx2
  area.bound_sy = sy2

  area.base_x = SEEDS[sx1][sy1].x1
  area.base_y = SEEDS[sx1][sy1].y1

--stderrf("setup_stuff %d x %d : %s\n", area.cw, area.ch, area.name)

  area.walk_map = GRID_CLASS.new(area.cw, area.ch)

  area.diagonals = area.walk_map:blank_copy()
  area.blobs     = area.walk_map:blank_copy()

  area.walk_floors = {}

  area.cave_lights = {}
end



function Cave_collect_walk_rects(R, area)

  local function rect_for_seeds(kind, sx1,sy1, sx2,sy2)
    local rect =
    {
      kind = kind,

      cx1 = (sx1 - area.base_sx) * 2 + 1,
      cy1 = (sy1 - area.base_sy) * 2 + 1,
    }

    rect.cx2 = rect.cx1 + (sx2 - sx1 + 1) * 2 - 1
    rect.cy2 = rect.cy1 + (sy2 - sy1 + 1) * 2 - 1

    table.insert(area.walk_rects, rect)

    return rect
  end


  local function rect_for_edge(E, kind)
    local sx1 = E.S.sx
    local sy1 = E.S.sy

    local sx2 = sx1
    local sy2 = sy1

    if E.long > 1 then
      local along_dir = geom.RIGHT[E.dir]
      sx2, sy2 = geom.nudge(sx1, sy1, along_dir, E.long - 1)
    end

    if sx2 < sx1 then sx1, sx2 = sx2, sx1 end
    if sy2 < sy1 then sy1, sy2 = sy2, sy1 end

    local WC = rect_for_seeds(kind, sx1,sy1, sx2,sy2)

    return WC
  end


  local function rect_for_connection(C)
    -- teleporters will be handled elsewhere (e.g. as a floor_chunk)
    if C.kind == "teleporter" then return end

    local E = C:edge_for_room(R)
    assert(E)

    local WC = rect_for_edge(E, "conn")

    WC.conn = C

    if R.entry_conn and R.entry_conn == C then
      area.entry_walk = WC
    end
  end


  local function check_entry_chunk(WC, chunk)
    if R.is_start and not R.entry_conn and chunk.content == "START" then
      area.entry_walk = WC
    end

    if R.entry_conn and R.entry_conn.kind == "teleporter" then
      local R2 = R.entry_conn:other_room(R)

      if R2.lev_along < R.lev_along then
        area.entry_walk = WC
      end
    end
  end


  local function rect_for_floor_chunk(chunk)
    -- ignore unused floor chunks
    if not chunk.content then return end

    local kind = "floor"
    if chunk.content == "DECORATION" or
       chunk.content == "CAGE"
    then
      kind = "decor"
    end

    local WC = rect_for_seeds(kind, chunk.sx1, chunk.sy1, chunk.sx2, chunk.sy2)

    if chunk.sw >= 2 and chunk.sh >= 2 then
      WC.walk_shrinkage = 2
    end

    WC.chunk = chunk

    check_entry_chunk(WC, chunk)
  end


  local function rect_for_closet(chunk)
    -- ignore unused closets
    if not chunk.content then return end
    if chunk.content == "void" then return end

    local E = assert(chunk.edges[1])

    local WC = rect_for_edge(E, "closet")

    WC.chunk = chunk

    check_entry_chunk(WC, chunk)
  end


  ---| Cave_collect_walk_rects |---

  area.walk_rects = {}

  for _,C in pairs(R.conns) do
    rect_for_connection(C)
  end

  for _,chunk in pairs(R.floor_chunks) do
    rect_for_floor_chunk(chunk)
  end

  for _,chunk in pairs(R.closets) do
    rect_for_closet(chunk)
  end
end



function Cave_map_usable_area(area)

  local bbox = {}


  local function cell_within_triangle(diag_mode, dx, dy)
    if diag_mode == 1 then return not (dx == 1 and dy == 1) end
    if diag_mode == 3 then return not (dx == 0 and dy == 1) end
    if diag_mode == 7 then return not (dx == 1 and dy == 0) end
    if diag_mode == 9 then return not (dx == 0 and dy == 0) end

    error("bad diag_mode")
  end


  local function cell_touches_diagonal(diag_mode, dx, dy)
    local val = dx * 10 + dy

    if diag_mode == 1 or diag_mode == 9 then
      return (val == 1) or (val == 10)
    else
      return (val == 0) or (val == 11)
    end
  end


  local function visit_seed(S)
    local cx1 = (S.sx - area.base_sx) * 2 + 1
    local cy1 = (S.sy - area.base_sy) * 2 + 1
    local cx2 = cx1 + 1
    local cy2 = cy1 + 1

    bbox.cx1 = math.min(bbox.cx1 or  9999, cx1)
    bbox.cy1 = math.min(bbox.cy1 or  9999, cy1)
    bbox.cx2 = math.max(bbox.cx2 or -9999, cx2)
    bbox.cy2 = math.max(bbox.cy2 or -9999, cy2)

    -- update diagonal grid for cave
    local diag_mode

    if S.diagonal then
      diag_mode = S.diagonal

      if S.area ~= area then
        diag_mode = 10 - diag_mode
      end
    end

    for dx = 0, 1 do
    for dy = 0, 1 do
      local cx = cx1 + dx
      local cy = cy1 + dy

      if (diag_mode == nil) or cell_within_triangle(diag_mode, dx, dy) then
        area.walk_map[cx][cy] = 0
      end

      if diag_mode and cell_touches_diagonal(diag_mode, dx, dy) then
        area.diagonals[cx][cy] = diag_mode
      end
    end -- cx, cy
    end
  end


  ---| Cave_map_usable_area |---

  for _,S in pairs(area.seeds) do
    visit_seed(S)
  end
end



function Cave_clear_walk_rects(area)
  for _,rect in pairs(area.walk_rects) do
    area.walk_map:fill(rect.cx1, rect.cy1, rect.cx2, rect.cy2, -1)
  end
end



function Cave_cell_touches_map_edge(LEVEL, area, cx, cy)
  local sx = area.base_sx + math.round((cx - 1) / 2)
  local sy = area.base_sy + math.round((cy - 1) / 2)

  if (cx % 2) == 0 then
    if sx >= LEVEL.absolute_x2 then return true end
  else
    if sx <= LEVEL.absolute_x1 then return true end
  end

  if (cy % 2) == 0 then
    if sy >= LEVEL.absolute_y2 then return true end
  else
    if sy <= LEVEL.absolute_y1 then return true end
  end

  return false
end



function Cave_cell_touches_room(area, cx, cy, R, SEEDS)
  -- checks diagonal directions too (i.e. corner touches)

  for _,dir in pairs(geom.ALL_DIRS) do
    local nx, ny = geom.nudge(cx, cy, dir)

    -- get seed coordinate of neighbor cell
    local sx = area.base_sx + math.round((nx - 1) / 2)
    local sy = area.base_sy + math.round((ny - 1) / 2)

    if not Seed_valid(sx, sy) then goto continue end

    local S1 = SEEDS[sx][sy]
    local S2 = S1.top

    nx = 1 - (nx % 2)  -- 0 for left side,   1 for right side
    ny = 1 - (ny % 2)  -- 0 for bottom side, 1 for top side

    if S1.diagonal == 1 then

      if (nx == 0 and ny == 0) or dir == 9 then
        S2 = nil
      elseif (nx == 1 and ny == 1) or dir == 1 then
        S1 = nil
      end

    elseif S1.diagonal == 3 then

      if (nx == 1 and ny == 0) or dir == 7 then
        S2 = nil
      elseif (nx == 0 and ny == 1) or dir == 3 then
        S1 = nil
      end

    end

    if S1 and S1.area and S1.area.room == R then return true end
    if S2 and S2.area and S2.area.room == R then return true end
    ::continue::
  end

  return false
end



function Cave_generate_cave(R, area, SEEDS)

  local is_lake = (area.liquid_mode == "lake")

  -- this contains where walls and must-be-clear spots are
  local map = area.walk_map

  -- this is the generated 2d cave
  local cave


  local function set_whole(S, value)
    local cx = (S.sx - area.base_sx) * 2 + 1
    local cy = (S.sy - area.base_sy) * 2 + 1

    map:fill(cx, cy, cx+1, cy+1, value)
  end


  local function set_side(S, side, value)
    local cx = (S.sx - area.base_sx) * 2 + 1
    local cy = (S.sy - area.base_sy) * 2 + 1

    local x1,y1, x2,y2 = geom.side_coords(side, cx,cy, cx+1,cy+1)

    map:fill(x1, y1, x2, y2, value)
  end


  local function set_corner(S, side, value)
    local cx = (S.sx - area.base_sx) * 2 + 1
    local cy = (S.sy - area.base_sy) * 2 + 1

    local nx, ny = geom.pick_corner(side, cx, cy, cx+1, cy+1)

    map:set(nx, ny, value)
  end


  local function mark_boundaries()
    -- this also sets most parts of the cave to zero
    -- [ zero means "can make cave here" ]

    for _,S in pairs(area.seeds) do
      for dir = 2,8,2 do
        if Cave_is_edge(S, dir, SEEDS) then
          set_side(S, dir, sel(is_lake, -1, 1))
        end

        -- in lake mode, clear whole seeds that touch edge of map
        -- (i.e. which will have a sky border next to them)
        if is_lake and S:need_lake_fence(dir) then
          set_whole(S, -1)
        end
      end

      for _,dir in pairs(geom.CORNERS) do
        if Cave_is_edge(S, dir, SEEDS) then
          -- lakes require whole seed to be cleared (esp. at "innie corners")
          if is_lake then
            set_whole(S, -1)
          else
            set_corner(S, dir, 1)
          end
        end
      end
    end
  end


  local function check_need_wall(S, dir)
    -- don't clobber connections

    local N = S:neighbor(dir)

    if not (N and N.room) then return true end

    if N.room == R then return false end

    return true
  end


  local function add_needed_cave_walls(S)
    -- a seed has been cleared, but it may need a wall or fence on
    -- one of the sides...

    for dir = 2,8,2 do
      if check_need_wall(S, dir) then
        -- merely mark it here, handled by border_up()
--FIXME        S.border[dir].cave_gap = true
      end
    end
  end


  local function is_fully_interior(S)
    for _,dir in pairs(geom.ALL_DIRS) do
      if Cave_is_edge(S, dir, SEEDS) then return false end
    end

    return true
  end


  local function clear_some_seeds()
    for _,S in pairs(area.seeds) do
      if rand.odds(10) and is_fully_interior(S) then
        set_whole(S, -1)
      end
    end
  end


  local function check_walks_reachable()
    --
    -- checks that all walking points can reach each other.
    --

    assert(cave.flood)

    local walk_id = nil

    for _,P in pairs(area.walk_rects) do
      if (cave.flood[P.cx1][P.cy1] or 0) >= 0 then
        -- not valid : the cell is solid or absent
        return false
      end

      local reg = cave.flood[P.cx1][P.cy1]

      if not walk_id then
        walk_id = reg
        goto continue
      end

      if walk_id ~= reg then
        -- not valid : the empty areas are disjoint
        return false
      end
      ::continue::
    end

    cave.walk_id = walk_id

    return true
  end


  local function is_cave_good(cave)
    -- check that all important parts are connected

    if not check_walks_reachable(area.walk_rects) then
      -- gui.debugf("cave failed connection check\n")
      return false
    end

    assert(cave.walk_id)
    assert(cave.walk_id < 0)

    -- now check that the size is adequate

    local empty_reg = cave.regions[cave.walk_id]
    assert(empty_reg)

    local W = cave.w
    local H = cave.h

    local cw = empty_reg.cx2 - empty_reg.cx1 + 1
    local ch = empty_reg.cy2 - empty_reg.cy1 + 1

    if (cw < W / 2) or
       (ch < H / 2) or
       (cw * ch < W * H / 2.5)
    then
      gui.debugf("cave failed size check\n")
      return false
    end

    return true
  end


  local function generate_cave()
    map:dump(R.name .. " Empty Cave:")

    local solid_prob = 38

    if is_lake then
      solid_prob = 58
    end

    local MAX_LOOP = 20

    for loop = 1,MAX_LOOP do
      gui.debugf("Trying to make a cave: loop %d\n", loop)

      if loop >= MAX_LOOP then
        gui.printf("Failed to generate a usable cave! (%s)\n", R.name)

        -- emergency fallback
        cave = map:gen_empty_cave()

        cave:flood_fill()

        is_cave_good(cave)
        break
      end

      cave = map:generate_cave(solid_prob)

      cave:dump("Generated Cave:")

      cave:remove_dots()
      cave:flood_fill()

      if is_cave_good(cave) then
        break
      end

      -- randomly clear some seeds in the room.
      -- After each iteration the number of cleared cells will keep
      -- increasing, making it more likely to generate a valid cave.
      clear_some_seeds()
    end

    if not is_lake then
      cave:solidify_pockets(cave.walk_id)
    end

    cave:dump("Filled Cave:")

---??  local islands = cave:find_islands()

    return cave
  end


  ---| Cave_generate_cave |---

  mark_boundaries()

  Cave_clear_walk_rects(area)

  area.cave_map = generate_cave()
end



function Cave_liquid_pools__OLD()

--[[ OLD STUFF.... TODO: REVIEW IF USEFUL

  local function heights_near_island(island)
    local min_floor =  9e9,
    local max_ceil  = -9e9,

    for x = 1, area.cw do
    for y = 1, area.ch do
      if ((island:get(x, y) or 0) > 0) then
        for dir = 2,8,2 do
          local nx, ny = geom.nudge(x, y, dir)

          if not island:valid(nx, ny) then continue end

          local B = R.area_map:get(nx, ny)
          if not B then continue end

          min_floor = math.min(min_floor, B.floor_h)
          max_ceil  = math.max(max_ceil , B.ceil_h)
        end
      end
    end  -- x, y
    end

--FIXME  assert(min_floor < max_ceil)

    return min_floor, max_ceil
  end


  local function turn_area_into_liquid(island)
    -- create a lava/nukage pit

    local f_mat = R.floor_mat or cave_tex
    local c_mat = R.ceil_mat  or cave_tex
    local l_mat = LEVEL.liquid.mat

    local f_h, c_h = heights_near_island(island)

    -- FIXME! should not happen
    if f_h >= c_h then return end

    f_h = f_h - 24,
    c_h = c_h + 64,

    for x = 1, cave.w do
    for y = 1, cave.h do

      if ((island:get(x, y) or 0) > 0) then

        -- do not render a wall here
        cave:set(x, y, 0)

        local f_brush = Cave_brush(area, x, y)
        local c_brush = Cave_brush(area, x, y)

        if PARAM.deep_liquids then
          brushlib.add_top(f_brush, f_h-128)
          brushlib.set_mat(f_brush, f_mat, f_mat)

          Trans.brush(f_brush)

          local l_brush = Cave_brush(area, x, y)

          table.insert(l_brush, 1, { m="liquid", medium=LEVEL.liquid.medium })

          brushlib.add_top(l_brush, f_h)
          brushlib.set_mat(l_brush, "_LIQUID", "_LIQUID")

          Trans.brush(l_brush)

          -- TODO: lighting

        else
          brushlib.add_top(f_brush, f_h)

          -- damaging
          f_brush[#f_brush].special = LEVEL.liquid.special

          -- lighting
          if LEVEL.liquid.light then
            f_brush[#f_brush].light = LEVEL.liquid.light
          end

          brushlib.set_mat(f_brush, l_mat, l_mat)

          Trans.brush(f_brush)
        end

        -- common ceiling code

        brushlib.add_bottom(c_brush, c_h)
        brushlib.set_mat(c_brush, c_mat, c_mat)

        if c_mat == "_SKY" then
          table.insert(c_brush, 1, { m="sky" })
        end

        Trans.brush(c_brush)
      end

    end end -- x, y
  end
--]]


  ---| Cave_liquid_pools |---

  if not LEVEL.liquid then return end

  local prob = 70  -- FIXME

  for _,island in pairs(cave.islands) do
    if rand.odds(prob) then
      turn_area_into_liquid(island)
    end
  end
end



function Cave_create_areas(R, area, LEVEL)
  --
  -- Sub-divide the floor of the cave into areas of differing heights.
  --

  local cave = area.cave_map

  local is_lake = (area.liquid_mode == "lake")

  -- groups are areas (rectangles) belonging to portals or importants
  -- and must be kept distinct (at the same height).
  local group_list
  local group_map


  local function install_blob(B, template, mul, empty_ok)
    for cx = 1, area.cw do
    for cy = 1, area.ch do
      if ((template:get(cx, cy) or 0) * mul) > 0 then
        area.blobs[cx][cy] = B

        B.cx1 = math.min(B.cx1 or  9999, cx)
        B.cy1 = math.min(B.cy1 or  9999, cy)

        B.cx2 = math.max(B.cx2 or -9999, cx)
        B.cy2 = math.max(B.cy2 or -9999, cy)
      end
    end
    end

    if not B.cx1 and not empty_ok then
      error("Cave install_blob: no cells!")
    end
  end


  local function copy_cave_without_fences()
    local new_cave = area.cave_map:copy()

    if area.fence_blob then
      for cx = 1, area.cw do
      for cy = 1, area.ch do
        local B = area.blobs[cx][cy]

        if B and B.is_fence then
          new_cave:set(cx, cy, nil)
        end
      end
      end
    end

    return new_cave
  end


  local function apply_walk_chunks(map)
    for _,rect in pairs(area.walk_rects) do
      local cx1, cy1 = rect.cx1, rect.cy1
      local cx2, cy2 = rect.cx2, rect.cy2

      if rect.walk_shrinkage == 2 then
        map:fill(cx1 + 1, cy1 + 1, cx2 - 1, cy2 - 1, 1)
      else
        map:fill(cx1, cy1, cx2, cy2, 1)
      end
    end
  end


  local function compute_floor_sinks(SINK1, SINK2, R, AREA)
    -- sometimes make sink1 be liquid but sink2 be solid
    if area.liquid_mode == "some" and rand.odds(15) then
      SINK1.floor_dz  = -12
      SINK1.is_liquid = true

      SINK2.floor_dz  = -4
      SINK2.floor_mat = AREA.floor_mat
      return
    end

    -- sometimes make a completely liquid floor [ if non-damaging ]
    if area.liquid_mode == "heaps" and not LEVEL.liquid.damage and rand.odds(25) then
       AREA.is_liquid = true
      SINK1.is_liquid = true
      SINK2.is_liquid = true

      SINK1.floor_dz = 0
      SINK2.floor_dz = 0

      -- occasionally some islands
      if rand.odds(30) then
        SINK2.is_liquid = nil
        SINK2.floor_mat = assert(R.floor_mat)
        SINK2.floor_dz  = 8
      end

      return
    end


    SINK1.floor_dz  = -8
    SINK1.floor_mat = assert(R.alt_floor_mat)

    if area.liquid_mode == "heaps" then
      SINK1.is_liquid = true
    end

    -- when no liquid, often make a larger area of the alternate floor
    if area.liquid_mode == "none" and rand.odds(50) then
      SINK2.floor_dz  = SINK1.floor_dz
      SINK2.floor_mat = SINK1.floor_mat
      return
    end


    SINK2.floor_dz  = -16
    SINK2.floor_mat = AREA.floor_mat

    if area.liquid_mode ~= "none" then
      SINK2.is_liquid = true
    end

    -- when both sinks are liquid, synchronise floor heights
    if SINK1.is_liquid and SINK2.is_liquid then
      SINK1.floor_dz = -12
      SINK2.floor_dz = SINK1.floor_dz
    end
  end


  local function compute_ceiling_sinks(SINK1, SINK2, R, AREA)
    local bump1 = rand.pick({ 48,64,80,96 })
    local bump2 = rand.pick({ 48,64,80,96 })

    SINK1.ceil_dz  = bump1
    SINK2.ceil_dz  = bump1 + bump2

    SINK1.ceil_mat = assert(R.alt_ceil_mat)
    SINK2.ceil_mat = assert(R.ceil_mat)

    if rand.odds(10) then
      SINK1.ceil_mat, SINK2.ceil_mat = SINK2.ceil_mat, SINK1.ceil_mat
    end

    if area.sky_mode == "heaps" then
      SINK1.is_sky = true
    end

    if area.sky_mode ~= "none" then
      SINK2.is_sky = true

      -- no big need to synchronise skies (as per liquids)
    end
  end


  local function make_walkway()
    --
    -- We have one main area, always walkable.
    -- The indentation / liquid / sky bits are considered to be
    -- modifications of the main area.
    --

    assert(area.liquid_mode ~= "lake")

    local AREA =
    {
      neighbors = {},
      children  = {},

      floor_mat = R.floor_mat,
       ceil_mat = R.ceil_mat
    }

    assert(AREA.floor_mat)
    assert(AREA.ceil_mat)

    table.insert(area.walk_floors, AREA)

---??  for _,WC in pairs(area.walk_rects) do
---??    WC.cave_area = AREA
---??  end

    install_blob(AREA, cave, -1)

    -- compute properties of each sink
    local SINK1 = { parent=AREA }
    local SINK2 = { parent=AREA }

    compute_floor_sinks  (SINK1, SINK2, R, AREA)
    compute_ceiling_sinks(SINK1, SINK2, R, AREA)


    -- this fixes MON_TELEPORT spots [ so they blend in ]
    R.mon_tele_floor = AREA.floor_mat

    area.floor_mat = AREA.floor_mat
    area.ceil_mat  = AREA.ceil_mat


    -- actually install the sinks...
    local walk_way = copy_cave_without_fences()

    apply_walk_chunks(walk_way)

    walk_way:negate()
    walk_way:shrink8(true)
    walk_way:remove_dots()

    install_blob(SINK1, walk_way, 1, "empty_ok")

    table.insert(AREA.children, SINK1)

    -- shrink the walkway further
    walk_way:shrink8(true)
    walk_way:remove_dots()

    install_blob(SINK2, walk_way, 1, "empty_ok")

    table.insert(AREA.children, SINK2)
  end


  local function add_group_to_map(G)
    table.insert(group_list, G)

    for x = G.cx1, G.cx2 do
    for y = G.cy1, G.cy2 do
      group_map[x][y] = G
    end
    end
  end


  local function remove_group_from_map(G)
    table.kill_elem(group_list, G)

    for x = G.cx1, G.cx2 do
    for y = G.cy1, G.cy2 do
      group_map[x][y] = nil
    end
    end
  end


  local function create_group_map()
    group_list = {}

    group_map = GRID_CLASS.blank_copy(area.cave_map)

    for _,WC in pairs(area.walk_rects) do
      add_group_to_map(WC)
    end
  end


  local function grow_step_areas()

    local pos_list = { }

    pos_list[1] =
    {
      x = area.walk_rects[1].cx1,
      y = area.walk_rects[1].cy1,
    }


    local free  = copy_cave_without_fences()

    local step
    local size

    local cw = free.w
    local ch = free.h

    -- current bbox : big speed up by limiting the scan area
    local cx1, cy1
    local cx2, cy2

    local touched_groups

    area.floor_mat = area.room.floor_mat
    area.ceil_mat = area.room.ceil_mat

    -- mark free areas with zero instead of negative
    for fx = 1, cw do
    for fy = 1, ch do
      if (free[fx][fy] or 0) < 0 then
        free[fx][fy] = 0
      end
    end
    end


    local function touch_a_group(G)
      remove_group_from_map(G)

      table.insert(touched_groups, G)

      -- add the whole group to the current step
      for x = G.cx1, G.cx2 do
      for y = G.cy1, G.cy2 do
        step[x][y] = 1
        free[x][y] = 1

        size = size + 1
      end
      end

      -- update bbox
      cx1 = math.min(cx1, G.cx1)
      cy1 = math.min(cy1, G.cy1)

      cx2 = math.max(cx2, G.cx2)
      cy2 = math.max(cy2, G.cy2)
    end


    local function grow_add(x, y)
      step[x][y] = 1
      free[x][y] = 1

      size = size + 1

      -- update bbox
      if x < cx1 then cx1 = x end
      if x > cx2 then cx2 = x end

      if y < cy1 then cy1 = y end
      if y > cy2 then cy2 = y end

      if group_map[x][y] then
        touch_a_group(group_map[x][y])
      end
    end


    local function grow_horiz(y, prob)
      for x = cx1, cx2 do
        if x > 1 and step[x][y] == 1 and step[x-1][y] == 0 and free[x-1][y] == 0 and rand.odds(prob) then
          grow_add(x-1, y)
        end
      end

      for x = cx2, cx1, -1 do
        if x < cw and step[x][y] == 1 and step[x+1][y] == 0 and free[x+1][y] == 0 and rand.odds(prob) then
          grow_add(x+1, y)
        end
      end
    end


    local function grow_vert(x, prob)
      for y = cy1, cy2 do
        if y > 1 and step[x][y] == 1 and step[x][y-1] == 0 and free[x][y-1] == 0 and rand.odds(prob) then
          grow_add(x, y-1)
        end
      end

      for y = cy2, cy1, -1 do
        if y < ch and step[x][y] == 1 and step[x][y+1] == 0 and free[x][y+1] == 0 and rand.odds(prob) then
          grow_add(x, y+1)
        end
      end
    end


    local function grow_it(prob)
      for y = cy1, cy2 do
        grow_horiz(y, prob)
      end

      for x = cx1, cx2 do
        grow_vert(x, prob)
      end
    end


    local function grow_an_area(cx, cy, prev_B)

-- free:dump("Free:")

      step  = GRID_CLASS.blank_copy(free)

      step:set_all(0)

      size = 0

      touched_groups = {}

      cx1 = cx ; cx2 = cx
      cy1 = cy ; cy2 = cy

      -- set initial point
      grow_add(cx, cy)

      local count = rand.pick { 1, 2, 3 },

      grow_it(100)

      for loop = 1, count do
        grow_it(50)
      end

      if size < 4 or #touched_groups > 0 then
        grow_it(100)
        grow_it(40)
      end

step:dump("Step:")

      -- when the step is too small, merge it into previous area
      --if size < 4 and prev_B then

        --install_blob(prev_B, step, 1)

      --else
        local AREA =
        {
          neighbors = {},
        }

        AREA.floor_mat = area.room.floor_mat
        AREA.ceil_mat = area.room.ceil_mat

        table.insert(area.walk_floors, AREA)

        install_blob(AREA, step, 1)

        prev_B = AREA
      --end


      -- remember area of covered groups (e.g. for outgoing heights)
      for _,G in pairs(touched_groups) do
        G.area = prev_B

        if G.portal then
          prev_B.goal_type = "portal"
        else
          prev_B.goal_type = "important"
        end
      end


      -- find new positions for growth

      for x = cx1, cx2 do
      for y = cy1, cy2 do
        if step[x][y] ~= 1 then goto continue end

        for dir = 2,8,2 do
          local nx, ny = geom.nudge(x, y, dir)
          if free:valid(nx, ny) and free[nx][ny] == 0 then
            table.insert(pos_list, { x=nx, y=ny, prev=prev_B })
          end
        end
        ::continue::
      end -- x, y
      end
    end


    --| grow_step_areas |--

    while #pos_list > 0 do
      local pos = table.remove(pos_list, rand.irange(1, #pos_list))

      -- ignore out-of-date positions
      if free[pos.x][pos.y] ~= 0 then goto continue end

      grow_an_area(pos.x, pos.y, pos.prev)
      ::continue::
    end
  end


  local function determine_touching_areas()
    local W = area.cw
    local H = area.ch

    for x = 1, W do
    for y = 1, H do
      local B1 = area.blobs[x][y]

      if not (B1 and B1.neighbors) then goto continue end

      for dir = 2,4,2 do
        local nx, ny = geom.nudge(x, y, dir)

        if not cave:valid(nx, ny) then goto continue end

        local B2 = area.blobs[nx][ny]

        if not (B2 and B2.neighbors) then goto continue end

        if B2 ~= B1 then
          table.add_unique(B1.neighbors, B2)
          table.add_unique(B2.neighbors, B1)
        end
        ::continue::
      end
      ::continue::
    end  -- x, y
    end

    -- verify all areas touch at least one other
    if #area.walk_floors > 1 then
      for _,B in pairs(area.walk_floors) do
        assert(not table.empty(B.neighbors))
      end
    end
  end


  local function set_walls()
    area.wall_blob =
    {
      is_wall = true,
      wall_mat = assert(area.room.main_tex)
    }

    for x = 1, area.cw do
    for y = 1, area.ch do
      local val = cave:get(x, y)

      if (val or 0) > 0 then
        area.blobs[x][y] = area.wall_blob
      end
    end
    end
  end


  ---| Cave_create_areas |---

  if area.step_mode == "walkway" then
    make_walkway()
  else
    create_group_map()

    grow_step_areas()

    --[[if #group_list > 0 then
      gui.printf("WARNING:\nCave steps failed to cover all important chunks " ..
      "in ROOM" .. area.room.id .. "\n")
      gui.printf(table.tostr(group_list,2) .. "\n")
      for _,G in pairs(group_list) do
        if G.kind and G.kind == "conn" then
          gui.printf(table.tostr(G.conn),2)
          gui.printf(table.tostr(G.conn.joiner_chunk),2)
        end
      end
    end]]
  end

  determine_touching_areas()

  if not is_lake then
    set_walls()
  end
end



function Cave_bunch_areas(R, mode, LEVEL)
  --
  -- This picks a bunch of step areas which will become either liquid
  -- or sky (depending on 'mode' parameter).
  --

  local area = R.cave_area


  local function setup()
    for _,B in pairs(area.walk_floors) do
      if B.goal_type then B.near_bunch = 0 end
    end
  end


  local function pick_start_area()
    local poss = {}

    for _,B in pairs(area.walk_floors) do
      if not B.near_bunch then
        table.insert(poss, B)
      end
    end

    if table.empty(poss) then return nil end

    return rand.pick(poss)
  end


  local function touches_the_list(N, list, except)
    for _,N2 in pairs(N.neighbors) do
      if list[N2] and N2 ~= except then
        return true
      end
    end

    return false
  end


  local function grow_bunch(list)
    local poss = {}

    for B,_ in pairs(list) do
      for _,N in pairs(B.neighbors) do
        if list[N] then goto continue end
        if N.near_bunch then goto continue end

        if touches_the_list(N, list, B) then goto continue end

        table.insert(poss, N)
        ::continue::
      end
    end

    if table.empty(poss) then return false end

    local B2 = rand.pick(poss)

    list[B2] = 1

    return true
  end


  local function install_bunch(list)
    local head_B

    for B,_ in pairs(list) do
      if not head_B then head_B = B end

      if mode == "sky"    then B.sky_bunch    = head_B ; B.is_sky    = true end
      if mode == "liquid" then B.liquid_bunch = head_B ; B.is_liquid = true end

      B.near_bunch = 0

      for _,N in pairs(B.neighbors) do
        if not N.near_bunch or N.near_bunch > 1 then
          N.near_bunch = 1
        end
      end
    end

    -- extra health to compensate player for crossing the river
    if mode == "liquid" and LEVEL.liquid.damage then
      R.hazard_health = R.hazard_health + 20
    end
  end


  local function clear()
    for _,B in pairs(area.walk_floors) do
      B.near_bunch = nil
    end
  end


  ---| Cave_bunch_areas |---

  if area.step_mode == "walkway" then return end
  if area.liquid_mode == "lake"  then return end

  if mode == "sky"    and area.sky_mode    ~= "some" then return end
  if mode == "liquid" and area.liquid_mode ~= "some" then return end

  setup()

  local try_count = math.round(#area.walk_floors / rand.sel(50, 8, 14))

  for i = 1, try_count do
    local B1 = pick_start_area()

    if not B1 then break; end  -- nothing is possible

    local list = { [B1] = 1 }

    while grow_bunch(list) and rand.odds(64) do
      -- keep growing...
    end

    if table.size(list) >= 2 then
      install_bunch(list)
    end
  end

  clear()
end



function Cave_heights_near_area(R, B)
  local area = R.cave_area

  local cave = area.cave_map

  local min_floor_h =  9e9
  local max_floor_h = -9e9

  local min_ceil_h =  9e9
  local max_ceil_h = -9e9

  for x = 1, area.cw do
  for y = 1, area.ch do
    for dir = 2,4 do
      local nx, ny = geom.nudge(x, y, dir)

      if not cave:valid(nx, ny) then goto continue end

      local B1 = area.blobs[x][y]
      local B2 = area.blobs[nx][ny]

      if (B2 == B) then
        B1, B2 = B2, B1
      end

      if not B2 or (B1 ~= B) or (B2 == B) then goto continue end

      if B2.floor_h then
        min_floor_h = math.min(min_floor_h, B2.floor_h)
        max_floor_h = math.max(max_floor_h, B2.floor_h)
      end

      if B2.ceil_h then
        min_ceil_h = math.min(min_ceil_h, B2.ceil_h)
        max_ceil_h = math.max(max_ceil_h, B2.ceil_h)
      end
      ::continue::
    end
  end -- x, y
  end

  if min_floor_h > max_floor_h then
    min_floor_h = nil
    max_floor_h = nil
  end

  if min_ceil_h > max_ceil_h then
    min_ceil_h = nil
    max_ceil_h = nil
  end

  return min_floor_h, max_floor_h,
         min_ceil_h,  max_ceil_h
end



function Cave_floor_heights(R, entry_h)
  assert(entry_h)

  local area = R.cave_area


  local z_change_prob = rand.sel(15, 40, 10)

  if area.step_mode == "up" or area.step_mode == "down" then
    z_change_prob = 0
  end


  local function blobify()
    local src = area.walk_map:copy()

    for x = 1, area.cw do
    for y = 1, area.ch do
      if src[x][y] then src[x][y] = 1 end
    end
    end

    blob_map = src:create_blobs(4, 3)

    -- ensure walk-rects are fully contained in a single blob
    blob_map:walkify_blobs(area.walk_rects)

    -- ensure half-cells are merged with the blob touching the
    -- corner away from the diagonal, otherwise the gap which
    -- could exist there may be too narrow for players to pass
    --blob_map:merge_diagonal_blobs(area.diagonals)

    --blob_map:merge_small_blobs(4)

    blob_map:extent_of_blobs()
    blob_map:neighbors_of_blobs()

    blob_map:dump_blobs()
  end


  local function floor_for_river(bunch_B, h)
    assert(not bunch_B.floor_h)

    local diff_h = 16

    -- determine minimum of all areas touching the river
    for _,B in pairs(area.walk_floors) do
      if B.liquid_bunch ~= bunch_B then goto continue end

      for _,N in pairs(B.neighbors) do
        if N.liquid_bunch then goto continue end

        if N.floor_h then
          h = math.min(h, N.floor_h - diff_h)
        end
        ::continue::
      end
      ::continue::
    end

    for _,B in pairs(area.walk_floors) do
      if B.liquid_bunch == bunch_B then
        B.floor_h = h
      end
    end

    return h
  end


  local function spread_river_banks(bunch_B, h)
    --| ensure all areas touching the river get a floor height now
    --| (to prevent those areas becoming lower than the river).

    for _,B in pairs(area.walk_floors) do
      if B.liquid_bunch ~= bunch_B then goto continue end

      for _,N in pairs(B.neighbors) do
        if N.liquid_bunch then goto continue end

        if not N.floor_h then
          N.floor_h = h + rand.pick({8, 16, 24})
        end
        ::continue::
      end
      ::continue::
    end
  end


  local function visit_area(B, z_dir, h)
    --|
    --| recursively spread floors heights into each area
    --|

    assert(not B.visited)
    B.visited = true

    if rand.odds(z_change_prob) then
      z_dir = - z_dir
    end


    -- floor --

    if B.floor_h then
      h = B.floor_h
    elseif B.liquid_bunch then
      h = floor_for_river(B.liquid_bunch, h)
    else
      B.floor_h = h
    end


    if B.liquid_bunch then
      spread_river_banks(B.liquid_bunch, h)
    end


    -- ceiling --

    if R.is_outdoor and false then  --!!!???
      -- no ceil_h (done later as the base area ceiling)
    elseif B.goal_type then
      B.ceil_h = h + 192
    else
      B.ceil_h = h + R.walkway_height
    end


    rand.shuffle(B.neighbors)

    for _,N in pairs(B.neighbors) do
      if not N.visited then
        local new_h = h + z_dir * rand.sel(35, 8, 16)
        visit_area(N, z_dir, new_h)
      end
    end
  end


  local function find_entry_area()

    local e_blob = area.entry_walk

    local cx = (e_blob.cx1 + e_blob.cx2) / 2
    local cy = (e_blob.cy1 + e_blob.cy2) / 2
    local nearest_dist = EXTREME_H

    for _,WF in pairs(area.walk_floors) do
      --[[local cx_c = (WF.cx1 + WF.cx2) / 2,
      local cy_c = (WF.cy1 + WF.cy2) / 2,

      -- distance check
      WF.dist_to_entry = geom.dist(cx,cy,cx_c,cy_c)
      nearest_dist = math.min(nearest_dist, WF.dist_to_entry)]]

      -- touching check
      WF.dist_to_entry = geom.box_dist(
        e_blob.cx1, e_blob.cy1, e_blob.cx2, e_blob.cy2,
        WF.cx1, WF.cy1, WF.cx2, WF.cy2
      )
    end

    for _,WF in pairs(area.walk_floors) do
      if WF.dist_to_entry == 0 then
        return WF
      end
    end

    error("No entry walk floor found!!! Life is meaningless meow\n" ..
    "Everything is terrible and food doesn't taste the same " ..
    "and the bottle is running low on pills")
  end


  local function transfer_heights()
    -- transfer heights to importants and portals
    -- FIXME
    for _,imp in pairs(R.cave_imps) do
      assert(imp.area)
      assert(imp.area.floor_h)

      local G = imp.goal
      local C = imp.conn

      if G then
        G.z1 = imp.area.floor_h
        G.z2 = G.z1 + 160

        G.S.floor_h = G.z1
      end

      if C then
        local S = C:get_seed(R)
        S.floor_h = imp.area.floor_h

        if not C.conn_h then
          C.conn_h  = imp.area.floor_h
        end
      end
    end
  end


  local function update_min_max_floor(step)
    R.floor_min_h = entry_h
    R.floor_max_h = entry_h

    for _,B in pairs(area.walk_floors) do
      R.floor_min_h = math.min(R.floor_min_h, B.floor_h)
      R.floor_max_h = math.max(R.floor_max_h, B.floor_h)
    end
  end


  local function update_walk_ways()
    for _,B in pairs(area.walk_floors) do
      if not B.children then goto continue end

      for _,SINK in pairs(B.children) do
        SINK.floor_h = B.floor_h + SINK.floor_dz

        if B.ceil_h then
          SINK.ceil_h = B.ceil_h + SINK.ceil_dz
        end
      end
      ::continue::
    end
  end


  local function update_fences()
    if area.liquid_mode == "lake" then
      area.fence_blob.floor_h = R.floor_max_h + 96
      area. wall_blob.floor_h = area.fence_blob.floor_h

      R.cave_fence_z = area.fence_blob.floor_h

    elseif area.sky_mode == "low_wall" then
      area.wall_blob.floor_h = R.floor_max_h + 80

      R.cave_fence_z = area.wall_blob.floor_h

    else
      -- do not need a cave_fence_z
    end
  end


  local function update_lakes()
    if not area.lakes then return end

    for pass = 1,4 do
      for _,B in pairs(area.lakes) do
        if not B.floor_h then

          local f_h = Cave_heights_near_area(R, A)

          if f_h then
            B.floor_h = f_h - rand.pick({ 8, 16, 24 })
          elseif pass == 4 then
            error("Lake failed to get a height")
          end

        end
      end
    end
  end


  local function ceiling_for_sky_bunch(bunch_B)
    local h = bunch_B.ceil_h or 0

    for _,B in pairs(area.walk_floors) do
      if B.sky_bunch ~= bunch_B then goto continue end

      for _,N in pairs(B.neighbors) do
        if N.sky_bunch then goto continue end

        if N.ceil_h then
          h = math.max(h, N.ceil_h)
        end
        ::continue::
      end
      ::continue::
    end

    h = h + rand.pick({ 32,48,64,96 })

    for _,B in pairs(area.walk_floors) do
      if B.sky_bunch == bunch_B then
        B.ceil_h = h
      end
    end
  end


  local function update_sky_bunches()
    for _,B in pairs(area.walk_floors) do
      if B.sky_bunch == B then
        ceiling_for_sky_bunch(B)
      end
    end
  end


  local function temp_chunk_crud()
    for _,chunk in pairs(R.floor_chunks) do
      if chunk.content == "MON_TELEPORT" then
        chunk.floor_h   = entry_h
        chunk.floor_mat = R.mon_tele_floor
      end
    end
  end


  ---| Cave_floor_heights |---

  local z_dir

  if area.step_mode == "up" then
    z_dir = 1
  elseif area.step_mode == "down" then
    z_dir = -1
  else
    z_dir = rand.sel(37, 1, -1)
  end

  -- TEMP RUBBISH
  area.floor_h = entry_h
  area.ceil_h  = entry_h + R.walkway_height

  local entry_area = find_entry_area()
  assert(entry_area)

  blobify()

  visit_area(entry_area, z_dir, entry_h)

  -- transfer_heights()
-- Heights already transfered after all cave operations.

  update_min_max_floor()
  update_walk_ways()
  update_fences()
  update_lakes()
  update_sky_bunches()

  temp_chunk_crud()
end



function Cave_fill_lakes(R)
  local area = R.cave_area

  local cave = area.cave_map


  local function add_lake(id, reg)

    -- FIXME: if reg.size < 16 then emptify_region()

    local LAKE =
    {
      is_liquid = true,

      region = reg,

      cx1 = reg.cx1,
      cy1 = reg.cy1,
      cx2 = reg.cx2,
      cy2 = reg.cy2,
    }

    table.insert(area.lakes, LAKE)

    for x = LAKE.cx1, LAKE.cx2 do
    for y = LAKE.cy1, LAKE.cy2 do
      if cave.flood[x][y] == id then
        area.blobs[x][y] = LAKE
      end
    end
    end
  end


  local function handle_island(id, reg)

    -- TODO: if large, keep as island and add bridge to nearby ground

    add_lake(id, reg)
  end


  ---| Cave_fill_lakes |---

  if area.liquid_mode ~= "lake" then return end

  -- determine region id for the main walkway
  local p1 = area.walk_rects[1]

  local path_id = cave.flood[p1.cx1][p1.cy1]

  for id,reg in pairs(cave.regions) do
    if (id > 0) then
      add_lake(id, reg)
    end

    if (id < 0) and (id ~= path_id) then
      handle_island(id, reg)
    end
  end
end



function Cave_lake_fences(R)
  local area = R.cave_area

  local function install_fence_post(cx1, cy1, cx2, cy2, dir, along_dir, i, deep)
    if along_dir == 6 then
      cx1 = cx1 + (i - 1)
      cx2 = cx1
    else
      cy1 = cy1 + (i - 1)
      cy2 = cy1
    end

        if dir == 2 then cy2 = cy1 + (deep - 1)
    elseif dir == 8 then cy1 = cy2 - (deep - 1)
    elseif dir == 4 then cx2 = cx1 + (deep - 1)
    elseif dir == 6 then cx1 = cx2 - (deep - 1)
    end

    for x = cx1, cx2 do
    for y = cy1, cy2 do
      area.blobs[x][y] = area.fence_blob
    end
    end
  end


  local function try_fence_run(S, dir)
    if not S.lake_fences then S.lake_fences = {} end

    -- already done?
    if S.lake_fences[dir] then return end

    local along_dir = geom.vert_sel(dir, 6, 8)

    local count = 1

    local S1 = S
    local S2 = S:neighbor(along_dir)

    while S2 do
      if S2.room ~= R then break; end

      assert(not (S2.lake_fences and S2.lake_fences[dir]))

      if not S2:need_lake_fence(dir) then break; end

      if not S2.lake_fences then S2.lake_fences = {} end

      count = count + 1

      S2 = S2:neighbor(along_dir)
    end

    --- OK, install it ---

    for i = 1, count do
      local N = S:neighbor(along_dir, i - 1)

      N.lake_fences[dir] = true  -- prevent visiting again
    end

    local S2 = S:neighbor(along_dir, count - 1)

    local cx1 = 1 + (S.sx - area.base_sx) * 2
    local cy1 = 1 + (S.sy - area.base_sy) * 2

    local cx2 = 1 + (S2.sx - area.base_sx) * 2 + 1
    local cy2 = 1 + (S2.sy - area.base_sy) * 2 + 1

    assert(cx2 > cx1 and cy2 > cy1)

    -- starting depth
    local deep = rand.sel(50, 1, 2)

    for i = 1, count * 3 do
      install_fence_post(cx1, cy1, cx2, cy2, dir, along_dir, i, deep)

      -- pick next depth
      deep = rand.sel(50, 1, 2)
    end
  end


  local function do_innie_corners()
    -- the mark boundaries logic assures that the whole seed at an
    -- "innie corner" is cleared (and walkable).  Here we ensure there
    -- is a single fence block touching that corner, to make the lake
    -- fence flow nicely around the innie corner.

    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S.room ~= R then goto continue end

      cx1 = (x - area.base_sx) * 2 + 1
      cy1 = (y - area.base_sy) * 2 + 1

      for _,dir in pairs(geom.CORNERS) do
        if not Cave_is_edge(S, dir, SEEDS) then goto continue end

        local A_dir = geom. LEFT_45[dir]
        local B_dir = geom.RIGHT_45[dir]

        local A = S:neighbor(A_dir)
        local B = S:neighbor(B_dir)

        if not A or (A.room ~= S.room) then goto continue end
        if not B or (B.room ~= S.room) then goto continue end

        if A:need_lake_fence(B_dir) or
           B:need_lake_fence(A_dir)
        then
          local cx, cy = geom.pick_corner(dir, cx1, cy1, cx1+1, cy1+1)
          area.blobs[cx][cy] = area.fence_blob
        end
        ::continue::
      end
      ::continue::
    end -- x, y
    end
  end


  --| Cave_lake_fences |--

  if area.liquid_mode ~= "lake" then
    return
  end

  local FENCE =
  {
    is_fence = true

    -- floor_h
  }

  area.fence_blob = FENCE

  for x = R.sx1, R.sx2 do
  for y = R.sy1, R.sy2 do
    local S = SEEDS[x][y]

    if S.room ~= R then goto continue end

    for dir = 2,8,2 do
      if S:need_lake_fence(dir) then
        try_fence_run(S, dir)
      end
    end
    ::continue::
  end -- sx, sy
  end

  do_innie_corners()
end



function Cave_make_waterfalls(R)
  -- this checks if two lakes can be connected by a short run of
  -- intermediate cells.

  local area = R.cave_area

  local cave = area.cave_map


  local function can_still_traverse(cx, cy, dir)
    -- see if cells on each side has same floor

    local A_dir = geom.LEFT [dir]
    local B_dir = geom.RIGHT[dir]

    local ax, ay = geom.nudge(cx, cy, A_dir)
    local bx, by = geom.nudge(cx, cy, B_dir)

    if not cave:valid(ax, ay) then return false end
    if not cave:valid(bx, by) then return false end

    local A = area.blobs[ax][ay]
    local B = area.blobs[bx][by]

    if not A or not B then return false end

    if A.is_wall or not A.floor_h then return false end
    if B.is_wall or not B.floor_h then return false end

    return math.abs(A.floor_h - B.floor_h) < 4
  end


  local function try_from_loc(lake, x, y, dir)
    if area.blobs[x][y] ~= lake then
      return false
    end

    local nx, ny = geom.nudge(x, y, dir)

    if not cave:valid(nx, ny) then return false end

    local B = area.blobs[nx][ny]

    if not B or B == lake then return false end

    if B.is_liquid or B.is_fence or B.is_wall then return false end

    local length = 1
    local max_length = 4

    for dist = 2, 9 do
      if length > max_length then return false end

      local ox, oy = geom.nudge(x, y, dir, dist)

      if not cave:valid(ox, oy) then return false end

      local B2 = area.blobs[ox][oy]

      if not B2 or B2 == lake then return false end

      -- found another lake?
      if B2.liquid then
        if lake.floor_h - B2.floor_h < 50 then return false end
        break;
      end

      if B.is_fence or B.is_wall then return false end

      length = length + 1
    end

    -- check player can traverse (somewhere along the new channel)

    local trav_count = 0

    for dist = 1, length do
      local ox, oy = geom.nudge(x, y, dir, dist)

      if can_still_traverse(ox, oy, dir) then
        trav_count = trav_count + 1
      end
    end

    if trav_count == 0 then return false end

    -- OK --

    for dist = 1, length do
      local ox, oy = geom.nudge(x, y, dir, dist)

      area.blobs[ox][oy] = lake
    end

    return true
  end


  local function try_waterfall(lake, dir)
    local cx1, cy1 = lake.cx1, lake.cy1
    local cx2, cy2 = lake.cx2, lake.cy2

    if dir == 2 then cy2 = math.min(lake.cy2, cy1 + 2) end
    if dir == 8 then cy1 = math.max(lake.cy1, cy2 - 2) end
    if dir == 4 then cx2 = math.min(lake.cx2, cx1 + 2) end
    if dir == 6 then cx1 = math.max(lake.cx1, cx2 - 2) end

    for x = cx1, cx2 do
    for y = cy1, cy2 do
      if try_from_loc(lake, x, y, dir, dist) then
        return true
      end
    end -- x, y
    end

    return false
  end


  local function connect_pools()
    for _,lake in pairs(area.lakes) do
      local w, h = geom.group_size(lake.cx1, lake.cy1, lake.cx2, lake.cy2)

      -- too large?
      -- we skip the main lake (only test cases beginning at a pool)
      if w > 15 or h > 15 then goto continue end

      local DIRS = { 2,4,6,8 }
      rand.shuffle(DIRS)

      for _,dir in pairs(DIRS) do
        if try_waterfall(lake, dir) then
          break;
        end
      end
      ::continue::
    end
  end


  local function cells_are_fences(cx1, cy1, cx2, cy2)
    for x = cx1, cx2 do
    for y = cy1, cy2 do
      assert(cave:valid(x, y))
      local B = area.blobs[x][y]
      if not (B and B.is_fence) then return false end
    end
    end

    return true
  end


  local function check_side_floors(cx, cy, dir, walk_B)
    dir = geom.RIGHT[dir]

    for pass = 1, 2 do
      local nx, ny = geom.nudge(cx, cy, dir)

      if not cave:valid(nx, ny) then return false end

      local N = area.blobs[nx][ny]
      if not N then return false end

      -- allow fences
      if N.is_fence then goto continue end

      -- this check prevents odd-looking falls (want only a single side of
      -- the LOW_POOL to be visible)
      if N.is_liquid then return false end

      if N.is_wall or not N.floor_h then return false end

      if N ~= walk_B then return false end

      dir = 10 - dir
      ::continue::
    end

    return true
  end


  local function attempt_a_fence_fall(cx, cy, dir)
    -- create a string describing what we can see
    local str = ""

    local low_floor
    local liq_area

    for i = 0, 7 do
      local nx, ny = geom.nudge(cx, cy, dir, i)
      if not cave:valid(nx, ny) then return false end

      local BL = area.blobs[nx][ny]
      if not BL or BL.is_wall or BL.goal_type then return false end

      -- do not join onto a previously built waterfall
      if BL.is_waterfall then return false end

      if BL.is_fence then
        str = str .. "F"
      elseif BL.is_liquid then
        str = str .. "L"
        liq_area = BL
      elseif BL.floor_h then
        str = str .. "W"

        if not low_floor then
          low_floor = BL
        else
          if BL ~= low_floor then return end
        end

        if not check_side_floors(nx, ny, dir, BL) then
          return false
        end

      else
        return false
      end
    end


    -- check if possible
    if not string.match(str, "F+W+L") then
      return false
    end

    assert(low_floor)
    assert(liq_area)

    if low_floor.floor_h - liq_area.floor_h < 50 then
      return false  -- the "falls" would be too low
    end

    -- random chance of not making it
    if rand.odds(50) then
      return false
    end


    -- OK, do it --

    local F1 = area.blobs[cx][cy]
    assert(F1.floor_h)

    local HIGH_POOL =
    {
      is_liquid  = true,
      is_waterfall = true,
      floor_h = F1.floor_h - 24,
    }

    local LOW_POOL =
    {
      is_liquid  = true,
      is_waterfall = true,
      floor_h = low_floor.floor_h - 12,
    }

    area.blobs[cx][cy] = HIGH_POOL

    for i = 1, 7 do
      local ch = string.sub(str, i+1, i+1)
      local nx, ny = geom.nudge(cx, cy, dir, i)

      if ch == 'L' then break; end

      if ch == 'F' and i == 1 and string.sub(str, 3, 3) == 'F' then
        area.blobs[nx][ny] = HIGH_POOL
        goto continue
      end

      area.blobs[nx][ny] = LOW_POOL
      ::continue::
    end

    return true
  end


  local function try_fence_fall(S, dir)
    -- Note: 'dir' faces inwards (away from fence)

    local along_dir = geom.vert_sel(dir, 6, 8)

    -- must be at edge of room
    local N = S:neighbor(10 - dir)
    if N and N.room == R then return end

    -- we only try pairs of seeds along the edge
    if geom.is_vert(dir) then
      if (S.sx % 2) == 0 then return end
    else
      if (S.sy % 2) == 0 then return end
    end

    -- check second seed in pair
    local S2 = S:neighbor(along_dir)
    if not (S2 and S2.room == R) then return end

    local N2 = S2:neighbor(10 - dir)
    if N2 and N2.room == R then return end


    local cx1 = 1 + (S.sx - area.base_sx) * 2
    local cy1 = 1 + (S.sy - area.base_sy) * 2

    if dir == 4 then cx1 = cx1 + 1 end
    if dir == 2 then cy1 = cy1 + 1 end

    local cx2, cy2 = cx1, cy1

    -- we test middle four cells in the seed pair
    if geom.is_vert(dir) then
      cx1 = cx1 + 1
      cx2 = cx1 + 3
    else
      cy1 = cy1 + 1
      cy2 = cy1 + 3
    end

    -- all these cells should be fences : verify
    if not cells_are_fences(cx1, cy1, cx2, cy2) then
      return
    end

    local deltas = { 0,1,2,3 }
    rand.shuffle(deltas)

    for i = 1, 4 do
      local cx, cy = geom.nudge(cx1, cy1, along_dir, i - 1)

      if attempt_a_fence_fall(cx, cy, dir) then
        -- yay!
        return
      end
    end
  end


  local function fence_falls()
    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]

      if S.room ~= R then goto continue end

      for dir = 2,8,2 do
        try_fence_fall(S, dir)
      end
      ::continue::
    end -- sx, sy
    end
  end


  ---| Cave_make_waterfalls |---

  if area.liquid_mode ~= "lake" then return end

  connect_pools()

  fence_falls()
end



function Cave_decorations(R)
  --
  -- add torches (etc)
  --

  local area = R.cave_area

  local cave = area.cave_map


  local function block_is_bounded(x, y, B, dir)
    local nx, ny = geom.nudge(x, y, dir)

    if not cave:valid(nx, ny) then return true end

    local N = area.blobs[nx][ny]

    if not (N and N.floor_h) then return true end
    if N.is_wall or N.is_fence or N.is_liquid then return true end

    if math.abs(N.floor_h - B.floor_h) > 16 then return true end

    return false
  end


  local function usable_corner(x, y)
    local B = area.blobs[x][y]

    if not (B and B.floor_h) then return false end

    -- analyse neighborhood of cell
    local nb_str = ""

    for dir = 1,9 do
      if block_is_bounded(x, y, B, dir) then
        nb_str = nb_str .. "1"
      else
        nb_str = nb_str .. "0"
      end
    end

    -- match neighborhood string
    -- Note: each '.' in the pattern means "Dont Care",

    return string.match(nb_str, "^11.100.00$") or
           string.match(nb_str, "^.1100100.$") or
           string.match(nb_str, "^.0010011.$") or
           string.match(nb_str, "^00.001.11$")
  end


  local function find_corner_locs()
    local locs = {}

    for x = 2, area.cw - 1 do
    for y = 2, area.ch - 1 do
      if usable_corner(x, y) then
        table.insert(locs, { cx=x, cy=y })
      end
    end
    end

    return locs
  end


  local function select_torch()
    local tab = R.theme.torches or THEME.cave_torches

    if not tab then return end

    return rand.key_by_probs(tab)
  end


  local function kill_nearby_locs(list, x, y)
    for _,loc in pairs(list) do
      if math.abs(loc.cx - x) <= 2 and
         math.abs(loc.cy - y) <= 2
      then
        loc.dead = true
      end
    end
  end


  local function add_torch(x, y, torch_ent)
    local B = area.blobs[x][y]
    assert(B and B.floor_h)

    local mx = area.base_x + (x-1) * 64 + 32
    local my = area.base_y + (y-1) * 64 + 32

    Trans.entity(torch_ent, mx, my, B.floor_h) ---??  { cave_light=48 })

    R:add_solid_ent(torch_ent, mx, my, B.floor_h)

    table.insert(area.cave_lights, { x=mx, y=my, z=B.floor_h + 64 })
  end


  local function place_torches_in_corners(prob)
    local torch_ent = select_torch()

    if not torch_ent then return end

    local locs = find_corner_locs()

    rand.shuffle(locs)

    local perc  = sel(area.torch_mode == "few", 5, 12)
    local quota = #locs * perc / 100

    quota = quota * rand.range(0.8, 1.2)
    quota = math.round(quota + gui.random())

    -- very rarely add lots of torches
    if area.torch_mode ~= "few" and rand.odds(1) then
      quota = #locs / 2
    end

    while quota > 0 do
      if table.empty(locs) then break; end

      local loc = table.remove(locs, 1)
      if loc.dead then goto continue end

      add_torch(loc.cx, loc.cy, torch_ent)

      -- prevent adding a torch in a neighbor cell, since that can
      -- block the player's path.
      kill_nearby_locs(locs, loc.cx, loc.cy)

      quota = quota - 1
      ::continue::
    end
  end


  ---| Cave_decorations |---

  if area.torch_mode ~= "none" then
    place_torches_in_corners()
  end
end



function Cave_decide_properties(R, area, LEVEL)
  --
  --  V7 NOTES
  -- ==========
  --
  -- (1) Outdoor caves are disabled, including the "lake" mode.
  --
  --     This is partly because I think a better system for outdoor
  --     rooms is necessary, which uses this cave system, but plans
  --     areas in a more deliberate way -- e.g. placing a river, or
  --     having porches in front of entrances to buildings.
  --
  --     This new "landscape" system would probably be used for the
  --     border areas of the map too.  Investigation into this idea
  --     is planned for a later time.
  --
  -- (2) Only flat caves are currently generated.
  --
  --     Getting the other STEP_MODES working again is non-trivial.
  --     But I also think that the steppy caves are too random, and
  --     an approach of making a small number of distinct areas which
  --     border each other (and connect via cavey stairs or a lift
  --     prefab) is going to better results.
  --

  -- Attempting to restore steppy caves... -MSSP, February 6, 2020,

  -- step mode --

  area.step_mode = "walkway"

  -- MSSP: Steppy caves are back, baby!
  if rand.odds(style_sel("steepness", 0, 25, 50, 75)) or (PARAM.steppy_caves and PARAM.steppy_caves == "always") then
    if rand.odds(50) then
      area.step_mode = "up"
    else
      area.step_mode = "down"
    end
  end

  if PARAM.steppy_caves and PARAM.steppy_caves == "no" then
    area.step_mode = "walkway"
  end

  -- liquid mode --

  local LIQUID_MODES = { none=60, some=30, heaps=10 }

  if not LEVEL.liquid then
    area.liquid_mode = "none"
  else
    local factor = style_sel("liquids", 33, 3, 1, 0.3)

    LIQUID_MODES.none = LIQUID_MODES.none * factor

    area.liquid_mode = rand.key_by_probs(LIQUID_MODES)
  end

  -- sky mode --

  local SKY_MODES = { none=60, some=40, heaps=40 }

  if R.light_level == "verydark" then SKY_MODES.none = 300 end
  if R.light_level == "bright"   then SKY_MODES.none = 10 end

  area.sky_mode = rand.key_by_probs(SKY_MODES)

  -- torch mode --

  local TORCH_MODES = { none=60, few=40, some=20 }

  if R.light_level == "bright" or
     (area.sky_mode ~= "none" and not LEVEL.is_dark) or
     area.liquid_mode ~= "none"
  then
    -- we have another source of light (sky or liquid)
    area.torch_mode = "none"

  else
    if R.light_level == "verydark" then TORCH_MODES.none = 10 end
    if R.light_level == "dark"     then TORCH_MODES.none = 20 end

    area.torch_mode = rand.key_by_probs(TORCH_MODES)
  end

  if area.torch_mode ~= "none" then
    area.cave_lighting = 1
  end

  -- extra health for damaging liquid
  if area.liquid_mode ~= "none" and LEVEL.liquid.damage then
    R.hazard_health = R.hazard_health + R.svolume * 0.7
  end

  gui.debugf("Cave properties in %s\n", R.name)
  gui.debugf("    step_mode : %s\n", area.step_mode)
  gui.debugf("  liquid_mode : %s\n", area.liquid_mode)
  gui.debugf("     sky_mode : %s\n", area.sky_mode)
  gui.debugf("   torch_mode : %s\n", area.torch_mode)
end



function Cave_build_a_cave(R, entry_h, SEEDS, LEVEL)

  local area = Cave_find_area_for_room(R)

  R.cave_area = area

  Cave_setup_stuff(area, SEEDS)

  Cave_collect_walk_rects(R, area)

  Cave_decide_properties(R, area, LEVEL)

  Cave_map_usable_area(area)

  Cave_generate_cave(R, area, SEEDS)

  Cave_lake_fences(R)
  Cave_fill_lakes(R)

  Cave_create_areas(R, area, LEVEL)

  Cave_bunch_areas(R, "liquid", LEVEL)
  Cave_bunch_areas(R, "sky", LEVEL)

  Cave_floor_heights(R, entry_h)

  Cave_make_waterfalls(R)

  Cave_decorations(R)

  -- distribute info for importants
  for _,WC in pairs(area.walk_rects) do
    local blob = area.blobs[WC.cx1][WC.cy1]
    assert(blob)


    if WC.kind == "conn" and WC.conn.kind ~= "teleporter" then
      WC.conn.conn_h = assert(blob.floor_h)
    end

    if WC.chunk then
      WC.chunk.floor_h   = assert(blob.floor_h)
      WC.chunk.ceil_h    = assert(blob.ceil_h)
      WC.chunk.floor_mat = assert(blob.floor_mat or area.room.floor_mat)

      -- distribute cell floor height info to seeds
      local x = WC.chunk.sx1
      local y

      while x <= WC.chunk.sx2 do

        y = WC.chunk.sy1
        while y <= WC.chunk.sy2 do

          SEEDS[x][y].floor_h = WC.chunk.floor_h
          SEEDS[x][y].ceil_h = WC.chunk.ceil_h
          SEEDS[x][y].floor_mat = WC.chunk.floor_mat

          y = y + 1
        end
        x = x + 1
      end
    end
  end

  --[[ sync heights of blobs near to walk rects
  for _,WC in pairs(area.walk_rects) do
    for _,BOT in pairs(area.blobs) do
      for _,B in pairs(BOT) do
        if B.is_wall then continue end

        local dist
        local dist_to_check = 1,

        local points =
        {
          [1] = {x=WC.cx1, y=WC.cy1},
          [2] = {x=WC.cx1, y=WC.cy2},
          [3] = {x=WC.cx2, y=WC.cy1},
          [4] = {x=WC.cx2, y=WC.cy2}
        }

        local points_to_compare =
        {
          [1] = {x=B.cx1, y=B.cy1},
          [2] = {x=B.cx1, y=B.cy2},
          [3] = {x=B.cx2, y=B.cy2},
          [4] = {x=B.cx2, y=B.cy1}
        }

        local yas_queen = false

        for _,P in pairs(points) do
          for _,CP in pairs(points_to_compare) do
            dist = geom.dist(P.x, P.y, CP.x, CP.y)
            if dist <= dist_to_check then
              yas_queen = true
              continue
            end
          end
        end

        if yas_queen then
          if WC.chunk then
            B.floor_h = WC.chunk.floor_h
            B.ceil_h = WC.chunk.ceil_h
          elseif WC.conn then
            local diff = math.abs(B.floor_h - WC.conn.conn_h)
            if diff < 24 then
              B.floor_h = WC.conn.conn_h
            end
          end
        end

      end
    end
  end]]
  --

end



function Cave_build_a_park(LEVEL, R, entry_h, SEEDS)

  local area = Cave_find_area_for_room(R)

  local blob_map

  local floor_num

  local tree_locs


  local RAISE_HEIGHTS =
  {
    [16] = 40, [32] = 60, [48] = 40, [64] = 20,
  }


  local function blobify()
    local src = area.walk_map:copy()

    for x = 1, area.cw do
    for y = 1, area.ch do
      if src[x][y] then src[x][y] = 1 end
    end
    end

    blob_map = src:create_blobs(3, 2)

    -- ensure walk-rects are fully contained in a single blob
    blob_map:walkify_blobs(area.walk_rects)

    -- ensure half-cells are merged with the blob touching the
    -- corner away from the diagonal, otherwise the gap which
    -- could exist there may be too narrow for players to pass
    blob_map:merge_diagonal_blobs(area.diagonals)

    blob_map:merge_small_blobs(4)

    blob_map:extent_of_blobs()
    blob_map:neighbors_of_blobs()

    blob_map:dump_blobs()
  end


  local function temp_install_floor(FL)
    for cx = 1, area.cw do
    for cy = 1, area.ch do
      local val = area.walk_map[cx][cy]

      if val == nil then goto continue end

      area.blobs[cx][cy] = FL

      FL.cx1 = math.min(FL.cx1 or  9999, cx)
      FL.cy1 = math.min(FL.cy1 or  9999, cy)
      FL.cx2 = math.max(FL.cx2 or -9999, cx)
      FL.cy2 = math.max(FL.cy2 or -9999, cy)
      ::continue::
    end -- cx, cy
    end
  end


  local function temp_install_blob(B, reg)
    B.cx1, B.cy1 = reg.cx1, reg.cy1
    B.cx2, B.cy2 = reg.cx2, reg.cy2

    for cx = B.cx1, B.cx2 do
    for cy = B.cy1, B.cy2 do
      if blob_map[cx][cy] == reg.id then
        area.blobs[cx][cy] = B
      end
    end -- cx, cy
    end
  end


  local function do_parky_stuff()
    local FLOOR =
    {
      neighbors = {},
      children  = {},

      floor_mat = assert(R.floor_mat),

      -- TEMP RUBBISH
      floor_h = entry_h
    }

    area.floor_blob = FLOOR

    table.insert(area.walk_floors, FLOOR)

    area.external_sky = true

    temp_install_floor(area.floor_blob)
  end


  local function do_install_floor_blob(B, base_h)
    local BLOB =
    {
      floor_h   = B.prelim_h + base_h,
      floor_mat = B.floor_mat
    }

    assert(BLOB.floor_h)
    assert(BLOB.floor_mat)

    if area.room then
      area.room.floor_mats[BLOB.floor_h] = BLOB.floor_mat
    end

    temp_install_blob(BLOB, B)

    table.insert(area.walk_floors, BLOB)

    area.min_floor_h = math.min(area.min_floor_h, BLOB.floor_h)
    area.max_floor_h = math.max(area.max_floor_h, BLOB.floor_h)

    if B.decor then
      local mx = area.base_x + (B.decor.cx - 1) * 64 + 32
      local my = area.base_y + (B.decor.cy - 1) * 64 + 32

      Trans.entity(B.decor.ent, mx, my, BLOB.floor_h, B.decor.props)

      R:add_solid_ent(B.decor.ent, mx, my, BLOB.floor_h)
    end

    -- inhibit pickup items in damaging liquid
    if BLOB.floor_mat == "_LIQUID" and LEVEL.liquid.damage then
      BLOB.no_items = true
    end
  end


  ----===========  RIVER STUFF  ===========----


  local function check_river_point(cx, cy)
    -- returns -1 if hit/touching a walk chunk
    -- returns  0 if hit another room
    -- returns +1 if spot is fine

    if cx < 1 or cx > area.cw then return 0 end
    if cy < 1 or cy > area.ch then return 0 end

    for nx = cx-1, cx+1 do
    for ny = cy-1, cy+1 do
      if nx < 1 or nx > area.cw then goto continue end
      if ny < 1 or ny > area.ch then goto continue end

      local v2 = area.walk_map[nx][ny]

      -- touches a walk chunk?
      if v2 and v2 < 0 then return -1 end
      ::continue::
    end
    end

    local v = area.walk_map[cx][cy]

    if v == nil then return 0 end

    return 1
  end


  local function check_river_start_point(cx, cy)
    -- the start point is also where the bridge will go,
    -- so make sure there is enough room for a bridge.

    for dx =  0, 1 do
    for dy = -3, 3 do
      if check_river_point(cx+dx, cy+dy) < 1 then
        return false
      end
    end
    end

    for dx = -4, 4 do
      if check_river_point(cx+dx, cy) < 1 then
        return false
      end
    end

    return true
  end


  local function meander(points, x, y, dx)
    x = x + dx

    local v0 = check_river_point(x, y)

    if v0 < 1 then return false end

    local decide_prob = rand.sel(50, 25, 75)

    local max_loop = 1

    while 1 do
      table.insert(points, { x=x, y=y })

      -- see where we can go to from here
      local dy = 0

      for loop = 1, rand.irange(1,max_loop) do

        local v1 = check_river_point(x + dx, y)
        local v2 = check_river_point(x, y - 1)
        local v3 = check_river_point(x, y + 1)

        -- finish successfully when hit edge of room
        if v1 == 0 then return true end

        -- fail if we have nowhere else to go
        v1 = (v1 > 0)
        v2 = (v2 > 0)
        v3 = (v3 > 0)

        if dy ~= 0 then
          if dy < 0 then v3 = false else v2 = false end
        end

        if not (v1 or v2 or v3) then return false end

        if v2 then v2 = check_river_point(x + dx, y - 1) > 0 end
        if v3 then v3 = check_river_point(x + dx, y + 1) > 0 end

        if (v2 or v3) and (not v1 or rand.odds(70)) then
          if dy ~= 0 then
            -- ok
          else
            if v2 and v3 then
              if rand.odds(decide_prob) then v2 = false else v3 = false end
            end

            if v2 then dy = -1 else dy = 1 end
          end

          y = y + dy

          table.insert(points, { x=x, y=y })
        else
          break;
        end

      end -- loop

      x = x + dx

      if max_loop < 4 then
        max_loop = max_loop + 1
      end
    end
  end


  local function get_river_ranges(points)
    local y_ranges = {}

    for _,P in pairs(points) do
      local r = y_ranges[P.x]

      if not y_ranges[P.x] then
        r = { y1=P.y, y2=P.y }
        y_ranges[P.x] = r
      else
        r.y1 = math.min(r.y1, P.y)
        r.y2 = math.max(r.y2, P.y)
      end
    end

    return y_ranges
  end


  local function score_river(points)
    -- computes a measure of how well the river divides the
    -- floor space into two halves.

    -- first, determine Y range for each x coordinate
    local y_ranges = get_river_ranges(points)

    -- second, see how much space is above and below each column
    local sum   = 0
    local count = 0

    for x,r in pairs(y_ranges) do
      local top = 0
      local bottom = 0

      for y = r.y2 + 1, area.ch do
        if area.walk_map[x][y] ~= nil then
          top = top + 1
        end
      end

      for y = 1, r.y1 - 1 do
        if area.walk_map[x][y] ~= nil then
          bottom = bottom + 1
        end
      end

      -- this will range from 0.0 (good) to 1.0 (bad)
      local val = math.abs(top - bottom) / area.ch

      sum   = sum + val
      count = count + 1
    end

    -- not wide enough?
    if count < 15 then return -1 end

    sum = sum / count

    -- not enough space on each side?
    if sum > 0.31 then return -1 end

    local score = (1.0 - sum) * 30 + count

    -- tie breaker
    return score + gui.random() * 0.1
  end


  local function try_a_river()
    local points = {}

    -- pick starting point
    local x, y

    for loop = 1,50 do
      x = rand.irange(1, area.cw)
      y = rand.irange(1, area.ch)

      if check_river_start_point(x, y) then
        break;
      end

      x = nil
      y = nil
    end

    if not x then return nil end

    table.insert(points, { x=x,   y=y })
    table.insert(points, { x=x+1, y=y })

    -- meander eastward

    if not meander(points, x+1, y, 1) then return nil end

    -- meander westward

    if not meander(points, x, y, -1) then return nil end

    -- too short?
    if #points < 10 then return nil end

    -- OK --

    return points, score_river(points)
  end


  local function find_river_banks(RIVER)
    -- finds all contiguous regions

    local map2 = area.walk_map:copy()

    for x = 1, area.cw do
    for y = 1, area.ch do
      if map2:get(x, y) == 0 then
        map2:set(x, y, -1)
      end

      if area.blobs[x][y] == RIVER then
        map2:set(x, y, nil)
      end
    end
    end

    map2:flood_fill()

    return map2
  end


  local function merge_a_runt(map2, reg, RIVER)
    for rx = reg.cx1, reg.cx2 do
    for ry = reg.cy1, reg.cy2 do
      if map2.flood[rx][ry] == reg.id then
        area.blobs[rx][ry] = RIVER
      end
    end
    end
  end


  local function check_walkables(RIVER, bx, by)
    local map2 = find_river_banks(RIVER)

    local B1 = map2.flood[bx][by - 2]
    local B2 = map2.flood[bx][by + 2]

    assert(B1 and B1 < 0)
    assert(B2 and B2 < 0)

    local result = true

    for _,P in pairs(area.walk_rects) do
      local B = map2.flood[P.cx1][P.cy1]

      if not (B == B1 or B == B2) then
        result = false
        break;
      end
    end

    -- handle little cut-off pieces

    for _,reg in pairs(map2.regions) do
      if reg.size < 6 and reg.id ~= B1 and reg.id ~= B2 then
        merge_a_runt(map2, reg, RIVER)
      end
    end

    return result
  end


  local function add_the_bridge(RIVER, bx, by, LEVEL)
    -- this tells the Render_cell() code to not move cell corners,
    -- so the floor adjoining the bridge will be aligned properly.
    local BRIDGE = table.copy(RIVER)
    BRIDGE.is_river  = nil
    BRIDGE.is_bridge = true

    for dx =  0, 1 do
    for dy = -1, 1 do
      area.blobs[bx+dx][by+dy] = BRIDGE
    end
    end

    local reqs =
    {
      kind  = "bridge",
      where = "point",
    }

    local def = Fab_pick(LEVEL, reqs)

    local mx = area.base_x + (bx - 1) * 64 + 64
    local my = area.base_y + (by - 1) * 64 + 32

    local T = Trans.spot_transform(mx, my, entry_h, 2)

    Fabricate(LEVEL, R, def, T, {})
  end


  local function install_river(points, RIVER, LEVEL)
    R.has_river = true

    -- bridge cell coords
    local bx = points[1].x
    local by = points[1].y

    for _,P in pairs(points) do
      area.blobs[P.x][P.y] = RIVER

      if check_river_point(P.x, P.y-1) > 0 then area.blobs[P.x][P.y-1] = RIVER end
      if check_river_point(P.x, P.y+1) > 0 then area.blobs[P.x][P.y+1] = RIVER end

      if math.abs(P.x - points[1].x) < 2 then goto continue end

      if check_river_point(P.x, P.y-2) > 0 then area.blobs[P.x][P.y-2] = RIVER end
      if check_river_point(P.x, P.y+2) > 0 then area.blobs[P.x][P.y+2] = RIVER end
      ::continue::
    end


    -- check if all walk-points can be reached

    if not check_walkables(RIVER, bx, by) then
      -- make it very shallow, disable the bridge
      RIVER.floor_h = entry_h - 24
    else
      add_the_bridge(RIVER, bx, by, LEVEL)
    end
  end


  local function can_make_river_tower(B)
    if B.is_walk then return end

    -- check whether the blob is completely surrounded by
    -- cells at the same height.

    for cx = B.cx1, B.cx2 do
    for cy = B.cy1, B.cy2 do
      if blob_map[cx][cy] ~= B.id then goto continue end

      for _,dir in pairs(geom.ALL_DIRS) do
        local nx, ny = geom.nudge(cx, cy, dir)
        if not blob_map:valid(nx, ny) then return false end

        local n_id = blob_map[nx][ny]
        if not n_id then return false end
        if n_id == B.id then goto continue end

        local N = blob_map.regions[n_id]
        assert(N)

        if N.floor_id ~= B.floor_id then return false end

        if N.is_tower then return false end
        ::continue::
      end
      ::continue::
    end
    end

    return true
  end


  local function river_add_towers()
    local prob = rand.pick({ 10, 30, 90 })

    for _,B in pairs(blob_map.regions) do
      if rand.odds(prob) and can_make_river_tower(B) then
        B.is_tower = true
        B.prelim_h = B.prelim_h + 64
      end
    end
  end


  local function make_a_river(LEVEL)
    local RIVER =
    {
      neighbors = {},
      children  = {},

      is_liquid = true,
      is_river  = true,

      floor_h   = entry_h - rand.pick({48, 64, 80, 96, 128})
    }

    local best
    local best_score = 0

    for loop = 1,30 do
      local points, score = try_a_river()

      if points and score > best_score then
        best = points
        best_score = score
      end
    end

    if best then
      install_river(best, RIVER, LEVEL)
    end

    --[[for _,B in pairs(RIVER) do
      B.prelim_h = entry_h
      B.floor_mat = area.room.floor_mat
    end

    river_add_towers(blob_map)

    -- render em
    for _,reg in pairs(RIVER) do
      if reg.is_tower then
        do_install_floor_blob(reg, 0)
      end
    end]]
  end


  ----===========  HILLSIDE STUFF  ===========----


  local function hill_clear()
    for _,B in pairs(blob_map.regions) do
      B.floor_id = nil
      B.stair    = nil
    end
  end


  local function hill_save(HILL)
    HILL.blob_floors = {}

    for _,B in pairs(blob_map.regions) do
      HILL.blob_floors[B.id] = B.floor_id
    end
  end


  local function hill_restore(HILL)
    for _,B in pairs(blob_map.regions) do
      B.floor_id = HILL.blob_floors[B.id]
    end
  end


  local function hill_best_stair_neighbor(B, dir)
    local cx1, cy1 = B.cx1, B.cy1
    local cx2, cy2 = B.cx2, B.cy2

    if dir == 2 then cy2 = cy1 end
    if dir == 8 then cy1 = cy2 end
    if dir == 4 then cx2 = cx1 end
    if dir == 6 then cx1 = cx2 end

    local counts = {}

    for x = cx1, cx2 do
    for y = cy1, cy2 do
      if blob_map[x][y] ~= B.id then goto continue end

      local nx, ny = geom.nudge(x, y, dir)

      if not blob_map:valid(nx, ny) then goto continue end

      local id = blob_map[nx][ny]
      if id == nil then goto continue end
      if id == B.id then goto continue end

      if not counts[id] then
        counts[id] = 1 + gui.random() / 10  -- tie breaker
      else
        counts[id] = counts[id] + 1
      end
      ::continue::
    end
    end

    -- pick the one with highest count
    local best

    for id,count in pairs(counts) do
      if not best or count > counts[best] then
        best = id
      end
    end

    -- require at least 2 cells
    if best and counts[best] < 2 then
      best = nil
    end

    return blob_map.regions[best]
  end


  local function hill_blob_is_good_stair(B, is_vert)
    if B.is_walk then return false end  -- must not be a walk rect

    -- check large enough, or too large
    local cw = B.cx2 - B.cx1 + 1
    local ch = B.cy2 - B.cy1 + 1

    if B.size <  6  then return false end
    if B.size >= 20 then return false end

    if is_vert then
      if ch < 3 or ch > 6 then return false end
      if cw < 2 or cw > 9 then return false end
    else
      if cw < 3 or cw > 6 then return false end
      if ch < 2 or ch > 9 then return false end
    end

    -- find best connecting blobs
    local src  = hill_best_stair_neighbor(B, sel(is_vert, 2, 4))
    local dest = hill_best_stair_neighbor(B, sel(is_vert, 8, 6))

    if not src  then return false end
    if not dest then return false end

    if src == dest then return false end

    -- Ok!
    return true, src, dest
  end


  local function hill_can_use_stair(st, others)
    for _,st2 in pairs(others) do
      -- blob is already in the list?
      if st2.B == st.B then return false end

      -- blob has a neighbor already in the list?
      -- [ main thing here is to avoid src/dest of another stair ]
      if table.has_elem(st.B.neighbors, st2.B) then return false end
    end

    return true
  end


  local function hill_select_stairs(all_stairs, want_num)
    local list = table.copy(all_stairs)

    rand.shuffle(list)

    local result = {}

    while #result < want_num do
      -- not enough stairs?
      if table.empty(list) then return nil end

      local st = table.remove(list, 1)

      if hill_can_use_stair(st, result) then
        table.insert(result, st)
      end
    end

    return result
  end


  local function hill_new_floor()
    floor_num = floor_num + 1

    return floor_num
  end


  local function hill_set_floor(B, f_id)
    B.floor_id = f_id
  end


  -- this one handles stairs (recursively, as they may form chains)
  local function hill_change_floor(B, f_id, old, stairs)
    if B.floor_id == f_id then return true end

    if B.floor_id ~= old  then return false end

    B.floor_id = f_id

    for _,st in pairs(stairs) do
      if not st.is_contained then goto continue end

      if st.src == B then
        if not hill_change_floor(st.dest, f_id,  old, stairs) then
          return false
        end
      end

      if st.dest == B then
        if not hill_change_floor(st.src,  f_id,  old, stairs) then
          return false
        end
      end
      ::continue::
    end

    return true
  end


  local function hill_divide_floor(st, stairs)
    local old = st.src.floor_id
    assert(old)

    assert(st.dest.floor_id == old)

    -- mark stairs that are wholly contained in this floor
    -- [ EXCEPT the stair we are dividing! ]
    for _,st2 in pairs(stairs) do
      st2.is_contained = false

      if st2 ~= st and st2.src.floor_id == old and st2.dest.floor_id == old then
        st2.is_contained = true
      end
    end


    local new1 = hill_new_floor()
    local new2 = hill_new_floor()

    if not hill_change_floor(st.src, new1,  old, stairs) then
      return false
    end

    if not hill_change_floor(st.dest, new2,  old, stairs) then
      return false
    end

    -- grow the new floors

    local unfilled = {}

    for _,B in pairs(blob_map.regions) do
      if B.floor_id == old then
        table.insert(unfilled, B)
      end
    end

    rand.shuffle(unfilled)

    for _,B in pairs(blob_map.regions) do
      rand.shuffle(B.neighbors)
    end

    local function get_a_neighbor(B)
      for _,N in pairs(B.neighbors) do
        if N.floor_id == new1 then return new1 end
        if N.floor_id == new2 then return new2 end
      end

      return nil
    end

    -- spread new floors into blobs containing the old floor

    repeat
      local changes = false

      for i = #unfilled, 1, -1 do
        local B = unfilled[i]

        if B.floor_id ~= old then
          table.remove(unfilled, i)
          goto continue
        end

        local use_id = get_a_neighbor(B)
        if not use_id then goto continue end

        if not hill_change_floor(B, use_id,  old, stairs) then
          return false
        end

        changes = true
        ::continue::
      end

    until not changes

    -- check whether all blobs with old floor were replaced

    for _,B in pairs(blob_map.regions) do
      if B.floor_id == old then
        return false
      end
    end

    return true  -- OK
  end


  local function hill_create_a_division(all_stairs, want_stairs, info)
    --
    -- Create a division of the room with the wanted number of stairs.
    -- If successful and score is better, updates the 'info' table.
    --
    -- HILL =
    -- {
    --   stairs : list(STAIR_INFO)
    --
    --   blob_floors[blob_id] -> integer / "stair",
    -- }
    --

    hill_clear()

    floor_num = 0

    -- not possible unless we have enough stairs
    if want_stairs > #all_stairs then return end

    -- pick a random set of stairs (which do not touch)
    local stairs = hill_select_stairs(all_stairs, want_stairs)

    if not stairs then return end


    -- initial setup : place all blobs on a single floor, but
    -- the stair blobs are marked as "stair",

    local F1 = hill_new_floor()

    for _,B in pairs(blob_map.regions) do
      hill_set_floor(B, F1)
    end

    for _,st in pairs(stairs) do
      hill_set_floor(st.B, "stair")
    end


    -- then for each stair we divide its floor into two new floors.
    -- if this fails, then we abort the attempt.

    for _,st in pairs(stairs) do
      if not hill_divide_floor(st, stairs) then
        return
      end
    end


    -- evaluate the result --

    local floor_sizes = {}

    for _,B in pairs(blob_map.regions) do
      local f_id = B.floor_id

      if f_id ~= "stair" then
        floor_sizes[f_id] = (floor_sizes[f_id] or 0) + B.size
      end
    end

    local total_size = 0
    local min_size   = 9e9

    for _,size in pairs(floor_sizes) do
      total_size = total_size + size
      min_size   = math.min(min_size, size)
    end

    assert(total_size > 0)

    local score = 20 * min_size / total_size + gui.random()

    if score > info.score then
      local HILL =
      {
        stairs = stairs
      }

      hill_save(HILL)

      info.best  = HILL
      info.score = score
    end
  end


  local function mark_features_of_floors(HILL)
    -- count how many stairs connect to each floor.

    local floors = HILL.floors

    for _,st in pairs(HILL.stairs) do
      local src  = assert(st.src .floor_id)
      local dest = assert(st.dest.floor_id)

      floors[src ].stair_num = floors[src ].stair_num + 1
      floors[dest].stair_num = floors[dest].stair_num + 1
    end

    -- see what walk_rects are used on each floor
    for _,WC in pairs(area.walk_rects) do
      local id = blob_map[WC.cx1][WC.cy1]
      assert(id)

      local B = blob_map.regions[id]
      assert(B)

      floors[B.floor_id].is_walk = true

      if WC.kind == "conn" or WC.kind == "closet" then
        B.has_conn = true
        floors[B.floor_id].has_conn = true
      end
    end
  end


  local function create_a_height_profile(HILL)
    -- a height profile is a blank copy of HILL.floors with 'prelim_h'
    -- (and possibly liquid info) set.
    --
    -- this function updates HILL.profile if the score is better.

    local profile = {}

    for id,_ in pairs(HILL.floors) do
      profile[id] = {}
    end

    -- pick starting floor, mark it as the lowest

    local start_f

    for id, F in pairs(HILL.floors) do
      assert(F.stair_num >= 1)

      if F.stair_num == 1 and (not start_f or rand.odds(50)) then
        start_f = id
      end
    end

    profile[start_f].prelim_h = 0


    -- flow through stairs to unvisited floors

    repeat
      local changes = false

      rand.shuffle(HILL.stairs)

      for _,st in pairs(HILL.stairs) do
        local P1 = profile[st.src .floor_id]
        local P2 = profile[st.dest.floor_id]

        assert(P1 and P2)

        if not P1.prelim_h then
          P1, P2 = P2, P1
        end

        local raise_h = rand.key_by_probs(RAISE_HEIGHTS)

        if P1.prelim_h and not P2.prelim_h then
          P2.prelim_h = P1.prelim_h + raise_h
          changes = true
        end
      end

    until not changes


    -- sanity check
    for id, P in pairs(profile) do
      assert(P.prelim_h)
    end


    -- TODO : score it properly!
    local score = 1 + gui.random()

    if score > (HILL.score or 0) then
      HILL.score = score
      HILL.profile = profile
    end
  end


  local function can_make_tower(B)
    if B.floor_id == "stair" then return false end
    if B.is_walk then return false end

    -- check whether the blob is completely surrounded by
    -- cells at the same height.

    for cx = B.cx1, B.cx2 do
    for cy = B.cy1, B.cy2 do
      if blob_map[cx][cy] ~= B.id then goto continue end

      for _,dir in pairs(geom.ALL_DIRS) do
        local nx, ny = geom.nudge(cx, cy, dir)
        if not blob_map:valid(nx, ny) then return false end

        local n_id = blob_map[nx][ny]
        if not n_id then return false end
        if n_id == B.id then goto continue end

        local N = blob_map.regions[n_id]
        assert(N)

        if N.floor_id ~= B.floor_id then return false end

        if N.is_tower then return false end
        ::continue::
      end
      ::continue::
    end
    end

    return true
  end


  local function hill_add_towers(HILL)
    local prob = rand.pick({ 10, 30, 90 })

    for _,B in pairs(blob_map.regions) do
      if rand.odds(prob) and can_make_tower(B) then
        B.is_tower = true
        B.prelim_h = B.prelim_h + 64

        if B.floor_mat == "_LIQUID" then
          B.floor_mat = R.alt_floor_mat
        end
      end
    end
  end


  local function hill_make_a_pool(B)
    B.prelim_h = B.prelim_h - 12
    B.floor_mat = "_LIQUID"

    -- extra health for damaging liquid
    if LEVEL.liquid.damage then
      R.hazard_health = R.hazard_health + math.round(B.size / 4)
    end
  end


  local function can_make_pool(B)
    if B.floor_id == "stair" then return false end
    if B.is_tower then return false end

    for _,N in pairs(B.neighbors) do
      if N.floor_id == "stair" then return false end
      if N.prelim_h < B.prelim_h then return false end
    end

    if B.has_conn then return false end

    -- rarely put goals in a damaging liquid
    if B.is_walk and LEVEL.liquid.damage and rand.odds(85) then
      return false
    end

    return true
  end


  local function hill_add_pools(HILL)
    -- decide how many to use
    local prob = rand.sel(30, 30, 10)

    local room_prob = style_sel("liquids", 0, 30, 60, 90)
    local  all_prob = style_sel("liquids", 0, 10, 35, 70)

    if HILL.has_liquid then
      room_prob = room_prob / 2
       all_prob =  all_prob / 4
    end

    if not LEVEL.liquid then return end
    if not rand.odds(room_prob) then return end

    if rand.odds(all_prob) then
      prob = 95
      if R.is_plain then prob = 45 end
    end

    -- visit each blob and see if we can make a pool
    -- [ update prelim_h in a second pass, to two or more neighboring
    --   blobs to become liquid ]
    for _,B in pairs(blob_map.regions) do
      if rand.odds(prob) and can_make_pool(B) then
        B.is_pool = true
      end
    end

    for _,B in pairs(blob_map.regions) do
      if B.is_pool then
        hill_make_a_pool(B)
      end
    end
  end


  local function pick_spot_for_tree(B)
    local cx, cy = blob_map:random_blob_cell(B.id)
    if not cx then return nil end

    -- never on a diagonal cell
    if area.diagonals[cx][cy] then return nil end

    for _,dir in pairs(geom.ALL_DIRS) do
      local nx, ny = geom.nudge(cx, cy, dir)
      if not blob_map:valid(nx, ny) then return nil end

      if area.diagonals[nx][ny] then return nil end

      local n_id = blob_map[nx][ny]
      if not n_id then return nil end

      local N = blob_map.regions[n_id]
      assert(N)

      if N.floor_id ~= B.floor_id then return nil end
    end

    -- ensure tree is not adjacent to another one
    for _,loc in pairs(tree_locs) do
      if math.abs(cx - loc.cx) <= 1 and
         math.abs(cy - loc.cy) <= 1
      then
        return nil
      end
    end

    return cx, cy  -- OK
  end


  local function try_add_decor_item(B)
    if B.floor_id == "stair" then return false end
    if B.is_walk  then return false end

    -- less chance in pools (never in damaging liquids)
    if B.is_pool then
      if LEVEL.liquid.damage then return false end
      if rand.odds(50) then return false end
    end

    -- pick a spot, check if it is usable
    local cx, cy

    for loop = 1, 5 do
      cx, cy = pick_spot_for_tree(B)
      if cx then break; end
    end

    if not cx then return false end

    -- Ok --

    B.decor =
    {
      ent = rand.key_by_probs(THEME.park_decor),
      cx  = cx,
      cy  = cy
    }

    table.insert(tree_locs, B.decor)

    return true
  end


  local function hill_add_decor(HILL)
    if not THEME.park_decor then return end

    tree_locs = {}

    local prob = style_sel("park_detail", 0, 30, 60, 90)

    for _,B in pairs(blob_map.regions) do
      if rand.odds(prob) then
        try_add_decor_item(B)
      end
    end
  end


  local function install_hillside(HILL)
    R.has_hills = true

    hill_clear()
    hill_restore(HILL)

    -- create an info table for each floor

    local floors = {}  --  [floor_id] -> { prelim_h=xxx }

    for _,f_id in pairs(HILL.blob_floors) do
      if f_id ~= "stair" and not floors[f_id] then
        floors[f_id] = { id=f_id, stair_num=0 }
      end
    end

    HILL.floors = floors

    -- analyse floor usage
    mark_features_of_floors(HILL)


    -- create a height profile
    -- [ we pick the "best" out of several profiles ]

    for loop = 1, 5 do
      create_a_height_profile(HILL)
    end


    -- determine materials
    local h_list = {}
    local h_mats = {}

    for _,P in pairs(HILL.profile) do
      table.add_unique(h_list, P.prelim_h)
    end

    table.sort(h_list)

    local mat1 = R.floor_mat
    local mat2 = R.alt_floor_mat

    if rand.odds(50) then mat1, mat2 = mat2, mat1 end

    for _,h in pairs(h_list) do
      h_mats[h] = mat1
      mat1, mat2 = mat2, mat1
    end


    -- install the height profile
    -- [ stairs are processed later.... ]

    for _,B in pairs(blob_map.regions) do
      if B.floor_id ~= "stair" then
        local P1 = HILL.profile[B.floor_id]
        assert(P1)

        B.prelim_h = assert(P1.prelim_h)

        if P1.is_liquid then
          B.floor_mat = "_LIQUID"
          HILL.has_liquid = true
        else
          B.floor_mat = assert(h_mats[B.prelim_h])
        end
      end
    end

    for _,st in pairs(HILL.stairs) do
      st.B.stair_info = st
    end


    -- decorate time!

    hill_add_towers(HILL)
    hill_add_pools(HILL)
    hill_add_decor(HILL)
  end


  local function hill_grow_with_stairs()
    -- collect the blobs which would make good stairs

    local all_stairs = {}

    for _,B in pairs(blob_map.regions) do
      for pass = 1, 2 do
        local is_vert = (pass == 2)
        local ok,src,dest = hill_blob_is_good_stair(B, is_vert)

        if ok then
          table.insert(all_stairs, { B=B, is_vert=is_vert, src=src, dest=dest })
        end
      end
    end

    -- try many combinations of dividing up the room based
    -- on using some of those stairs, and choose the highest
    -- scoring one.

    -- FIXME : make this depend on size of room  [ and some randomness ]
    local max_stairs = 4

    local info = { score=-1 }

    for want_stairs = max_stairs, 1, -1 do
      for loop = 1, 50 do
        hill_create_a_division(all_stairs, want_stairs, info)
--stderrf("loop:%d want:%d --> score:%1.3f\n", loop, want_stairs, info.score)
      end

      -- if we managed something, then install it
      if info.best then
        install_hillside(info.best)
        return true
      end

      -- try again with fewer wanted stairs
    end

    -- nothing worked :(
    return false
  end


  local function division_for_stair(width, num_div)
    -- the stair blob is 'width' cells wide (in the travel direction).
    --
    -- returns a table of length 'num_div' with how many cells to use
    -- for each step of the stair.

    assert(num_div <= width)

    if num_div == 1 then
      return { width }
    end

    local total  = 0
    local result = {}

    for i = 1, num_div do
      table.insert(result, 1)
    end

    for k = 1, width - num_div do
      local m = table.remove(result, #result)
      table.insert(result, 1, m + 1)
    end

    return result
  end


  local function do_make_stair_step(B, st_dir, along, w, z, mat)
    local STEP =
    {
      floor_h   = z,
      floor_mat = mat
    }

    local cx1, cy1 = B.cx1, B.cy1
    local cx2, cy2 = B.cx2, B.cy2

    if st_dir == 8 then cy1 = cy1 + along ; cy2 = cy1 + (w-1) end
    if st_dir == 2 then cy2 = cy2 - along ; cy1 = cy2 - (w-1) end

    if st_dir == 6 then cx1 = cx1 + along ; cx2 = cx1 + (w-1) end
    if st_dir == 4 then cx2 = cx2 - along ; cx1 = cx2 - (w-1) end

    for cx = cx1, cx2 do
    for cy = cy1, cy2 do
      if blob_map[cx][cy] == B.id then
        area.blobs[cx][cy] = STEP
      end
    end
    end
  end


  local function do_install_stair_blob(B, base_h)
    local st = assert(B.stair_info)

    local z1 = st.src .prelim_h + base_h
    local z2 = st.dest.prelim_h + base_h

    local z_diff = math.abs(z1 - z2)

    -- nothing is needed for a small height difference
    if z_diff <= 16 then
      local N = rand.sel(50, st.src, st.dest)

      B.prelim_h  = N.prelim_h
      B.floor_mat = N.floor_mat

      do_install_floor_blob(B, base_h)
      return
    end

    -- use floor material of highest sfloor
    local floor_mat = sel(z1 > z2, st.src.floor_mat, st.dest.floor_mat)
    assert(floor_mat)

    -- determine how many steps, and width of each step
    local width
    local num_div

    if st.is_vert then
      width = B.cy2 - B.cy1 + 1
    else
      width = B.cx2 - B.cx1 + 1
    end

    if z_diff >= 64 then
      num_div = math.min(width, 6)
    else
      num_div = math.min(width, 3)
    end

    local div = division_for_stair(width, num_div)

    -- get direction
    local st_dir = sel(st.is_vert, 8, 6)

    if z1 > z2 then
      table.reverse(div)
    end

    -- build the steps
    local along = 0

    for index,w in pairs(div) do
      local z = z1 + (z2 - z1) * index / (#div + 1)

      do_make_stair_step(B, st_dir, along, w, z, floor_mat)

      along = along + w
    end
  end


  --___________>>>>>>>>>>>>>>>>>>


  local function hill_can_use_step(B, chain, is_last)
    if B.prelim_h then return false end  -- in use already

    if not is_last then
      if B.is_walk then return false end  -- must not be a walk rect

      if B.size >= 12 then return false end  -- too big
    end

    if table.has_elem(chain, B) then return false end  -- already a step

    return true
  end


  local function hill_try_pick_chain(B, length)
    local chain = {}

    for i = 1, length do
      local nb
      local nb_score = -1

      for _,N in pairs(B.neighbors) do
        if hill_can_use_step(N, chain, i == length) then
          local score = gui.random()

          if score > nb_score then
            nb = N
            nb_score = score
          end
        end
      end

      -- nothing possible?
      if not nb then return nil end

      table.insert(chain, nb)

      B = nb
    end

    return chain
  end


  local function hill_pick_a_chain(B)
    for loop = 1, 30 do
      local chain = hill_try_pick_chain(B, 4)

      if chain then return chain end
    end

    return nil
  end


  local function hill_set_neighbors(B, ref)
    for _,N in pairs(B.neighbors) do
      if not N.floor_id then
        N.floor_id = ref.floor_id
        N.prelim_h = ref.prelim_h
      end
    end
  end


  local function hill_fill_gaps()
    local changes = false

    for _,B in pairs(blob_map.regions) do
      local nb

      if not B.prelim_h then
        for _,N in pairs(B.neighbors) do
          if N.prelim_h and N.floor_id ~= "step" then
            if not nb or rand.odds(50) then nb = N end
          end
        end
      end

      if nb then
        B.prelim_h = nb.prelim_h
        B.floor_id = nb.floor_id

        changes = true
      end
    end

    return changes
  end


  local function hill_grow_with_steps_OLD(entry_reg)
    --
    -- 1. start with a blob 'B', make it FLOOR #0,
    --
    -- 2. pick a chain of neighbors from B
    --    (B -> X -> Y -> Z -> C)
    --    where none of X/Y/Z are walk chunks
    --    and none of X/Y/Z are HUGE chunks
    --
    -- 3. mark blob 'C' as FLOOR #1, X/Y/Z marked as "step",
    --
    -- 4. neighbors of X/Y/Z are marked as FLOOR #0  [ REVIEW THIS! ]
    --
    -- 5. continue this process (B := C ; goto 1.)
    --
    -- 6. fill unused blobs with a nearby FLOOR (#0 .. #N)
    --

    local B = entry_reg  -- TODO : pick blob at random

    B.floor_id = 0
    B.prelim_h = 0

stderrf("hill_grow_with_steps...\n")
    while 1 do
      local chain = hill_pick_a_chain(B)

      if not chain then
        break;
--[[
        B = hill_pick_neighbor()

        if not B then break; end

        continue  ]]
      end

      local C = table.remove(chain, #chain)

stderrf("  picked chain from blob %d --> %d\n", B.id, C.id)

      C.floor_id = B.floor_id + 1
      C.prelim_h = B.prelim_h + 8

      for _,step in pairs(chain) do
        step.floor_id = "step"
        step.prelim_h = C.prelim_h

        C.prelim_h = C.prelim_h + 8
      end

      for _,step in pairs(chain) do
        hill_set_neighbors(step, C)
      end

      B = C
    end

    -- fill any gaps
    while hill_fill_gaps() do end
  end


  local function make_a_hillside()
    -- we need to know where the entrance is
    if not area.entry_walk then return end

    local ecx = area.entry_walk.cx1
    local ecy = area.entry_walk.cy1

    if not hill_grow_with_stairs() then
      area.room.cannot_into_hills = true
      return
    end

    local entry_id = blob_map[ecx][ecy]
    assert(entry_id)

    local entry_reg = blob_map.regions[entry_id]

    -- this ensure the entry floor (blob) becomes 'entry_h'
    local base_h = entry_h - assert(entry_reg.prelim_h)

    -- install all the blobs
    area.walk_floors = {}

    -- TODO : merge neighboring blobs with same h/mat  [ must handle "decor" too!! ]

    for _,reg in pairs(blob_map.regions) do
      if reg.floor_id == "stair" then
        do_install_stair_blob(reg, base_h)

      elseif reg.prelim_h then
        do_install_floor_blob(reg, base_h)
      end
    end
  end


  local function update_chunk_textures()
    -- ensure out-going connections get the correct floor_h,
    -- closets too
    -- [ FIXME : use this logic for normal CAVES too ]

    -- MSSP-TODO
    --print_area(area)
    --[[for _,B in pairs(area.blobs) do
      for _,cell in pairs(B) do
        local bx = area.base_sx
        local by = area.base_sy

        if cell.cx1 then
          local x = math.round(cell.cx1 / 2)
          local y = math.round(cell.cy1 / 2)

          while x <= cell.cx2 do
            y = math.round(cell.cy1 / 2)
            while y <= cell.cy2 do
              local nx = bx + math.round(x / 2) - 1,
              local ny = by + math.round(y / 2) - 1,

              if not SEEDS[nx][ny].floor_h then
                SEEDS[nx][ny].floor_h = cell.floor_h

              elseif SEEDS[nx][ny].floor_h then

                local h = SEEDS[nx][ny].floor_h
                local nh = cell.floor_h

                SEEDS[nx][ny].floor_h = math.max(h,nh)
              end

              SEEDS[nx][ny].floor_mat = cell.floor_mat

              y = y + 1,
            end

            x = x + 1,
          end
        end

      end
    end]]

    for _,WC in pairs(area.walk_rects) do
      local blob = area.blobs[WC.cx1][WC.cy1]
      assert(blob)


      if WC.kind == "conn" and WC.conn.kind ~= "teleporter" then
        WC.conn.conn_h = assert(blob.floor_h)
      end

      if WC.chunk then
        WC.chunk.floor_h   = assert(blob.floor_h)
        WC.chunk.floor_mat = assert(blob.floor_mat)

        -- distribute cell floor height info to seeds
        local x = WC.chunk.sx1
        local y

        while x <= WC.chunk.sx2 do

          y = WC.chunk.sy1
          while y <= WC.chunk.sy2 do

            SEEDS[x][y].floor_h = WC.chunk.floor_h
            SEEDS[x][y].floor_mat = WC.chunk.floor_mat
            --SEEDS[x][y].free = true

            y = y + 1
          end
          x = x + 1
        end
      end
    end

    -- distribute proper materials to closets
    for _,CL in pairs(area.room.closets) do
      CL.floor_mat = area.room.floor_mats[CL.floor_h]
    end
  end


  -- MSSP-TODO: My weird solution to the bland, empty parks. Once I figure it out that is.
  local function make_some_plains()
    if not area.entry_walk then return end

    local ecx = area.entry_walk.cx1
    local ecy = area.entry_walk.cy1

    R.has_hills = true
    R.is_plain = true

    for cx = 1, area.cw do
      for cy = 1, area.ch do
        local id = blob_map[cx][cy]
        if not id then goto continue end

        local reg = blob_map.regions[id]

        local info = {}
        info.floor_h = entry_h
        info.floor_mat = R.floor_mat

        area.blobs[cx][cy] = info
        ::continue::
      end
    end

    --
    for _,B in pairs(blob_map.regions) do
      B.prelim_h = entry_h
      B.floor_mat = R.floor_mat
    end

    hill_add_towers(blob_map)
    hill_add_pools(blob_map)
    hill_add_decor(blob_map)

    -- render em
    for _,reg in pairs(blob_map.regions) do
      if reg.prelim_h then
        do_install_floor_blob(reg, 0)
      end
    end

  end


  ---| Cave_build_a_park |---

gui.debugf("BUILD PARK IN %s\n", R.name)

  R.cave_area = area

  Cave_setup_stuff(area, SEEDS)

  Cave_collect_walk_rects(R, area)

  Cave_map_usable_area(area)

  Cave_clear_walk_rects(area)

  area.min_floor_h = entry_h
  area.max_floor_h = entry_h

  -- TEMP RUBBISH
  area.floor_h = entry_h
  area.ceil_h  = entry_h + 256
  area.ceil_mat = "_SKY"

  blobify()

  do_parky_stuff()

  if LEVEL.liquid and rand.odds(style_sel("liquids", 0, 16.67, 33.33, 50)) then
    R.park_type = "river"
  end

  if rand.odds(style_sel("steepness", 0, 33, 66,100)) then
    R.park_type = "hills"
  end

  if R.park_type == "hills" then
    make_a_hillside()
  elseif R.park_type == "river" then
    make_a_river(LEVEL)
  end

  -- fallback if in case hillside function
  -- doesn't fetch valid profiles
  if R.cannot_into_hills or not R.park_type then
    R.park_type = "plains"

    make_some_plains()
  end

  update_chunk_textures()

  --[[update room maximum and minimum heights
  R.max_floor_h = area.max_floor_h
  R.min_floor_h = area.floor_h

  for _,closet in pairs(R.closets) do
    R.max_floor_h = math.max(R.max_floor_h, closet.floor_h)
    R.min_floor_h = math.min(R.min_floor_h, closet.floor_h)
  end

  gui.printf("ROOM_" .. R.id .. ": " ..
  R.max_floor_h .. ", " .. R.min_floor_h .. "\n")]]
end



function Cave_prepare_scenic_vista(LEVEL, area)

  local room = assert(area.face_room)

  -- decide what kind of vista to make

  local vista_type
  local vista_list = {}

  if OB_CONFIG.zdoom_vista == "enable" then
    vista_list =
    {
      bottomless_drop = 3,
      cliff_gradient = 7,
    }
  end

  if (OB_CONFIG.zdoom_vista == "sky_gen_smart" and not EPISODE.has_mountains) then
    vista_list =
    {
      bottomless_drop = 2,
      cliff_gradient = 8,
    }
  end

  vista_list.simple_fence = 3
  vista_list.watery_drop = 3

  if LEVEL.liquid then
    vista_list.ocean = 4
  end

  if not room.is_exit then
    vista_list.fake_room = 4
  end

  vista_type = rand.key_by_probs(vista_list)

  local nice_view_prob = style_sel("scenics", 0, 16, 33, 50)
  if room.is_outdoor then nice_view_prob = style_sel("scenics", 5, 50, 75, 100) end

  nice_view_prob = math.clamp(0, nice_view_prob - (LEVEL.autodetail_group_walls_factor * 4) + 1, 100)

  if not rand.odds(nice_view_prob) then
    vista_type = "no_vista"
  end

  if room.is_natural_park then
    area.is_natural_park = true
  end

  if vista_type == "watery_drop" then
    area.border_type = "watery_drop"
  elseif vista_type == "cliff_gradient" then
    area.border_type = "cliff_gradient"
  elseif vista_type == "bottomless_drop" then
    area.border_type = "bottomless_drop"
  -- MSSP-TODO: find a better way to mix it up with interior facing rooms
  elseif vista_type == "fake_room"
  and not room.is_park and room.is_outdoor then
    area.border_type = "fake_room"
  elseif vista_type == "ocean" and LEVEL.liquid then
    area.border_type = "ocean"
  elseif vista_type == "no_vista" then
    area.border_type = "no_vista"
  elseif room.has_hills or vista_type == "simple_fence" then
    area.border_type = "simple_fence"
  end

  if not area.border_type or room.is_cave then
    area.border_type = "no_vista"
  end

  local fence_tab =
  {
    fence = 3,
    railing = 5.5,
    wall = 1.5,
  }

  local edge_tab =
  {
    wall = 1,
    edge = 9,
  }

  if room.is_park then fence_tab.railing = 0 end

  if area.border_type == "bottomless_drop"
  or area.border_type == "cliff_gradient" then
    edge_tab.wall = 0
  end

  -- decide border junction
  area.fence_type = rand.key_by_probs(fence_tab)

  -- decide map edge junction type
  area.map_edge_type = rand.key_by_probs(edge_tab)
end



function Cave_build_a_scenic_vista(LEVEL, area, SEEDS)

  local room = assert(area.face_room)

  local blob_map


  local function new_blob()
    local FL =
    {
      neighbors = {},
      children  = {}
    }

    return FL
  end


  local function blobify()
    local src = area.walk_map:copy()

    for x = 1, area.cw do
    for y = 1, area.ch do
      if src[x][y] then src[x][y] = 1 end
    end
    end

    blob_map = src:create_blobs(3, 2)

    -- no walk_rects to worry about

    blob_map:merge_small_blobs(4)

    blob_map:extent_of_blobs()
    blob_map:neighbors_of_blobs()

--  blob_map:dump_blobs()
  end


  local function mark_must_walk_blobs()
    -- TODO : use A* pathing to mark all blobs on a PATH
    --
    -- [ blobs not on the path can potentially become blocking,
    --   however we must ensure the player cannot become trapped
    --   if they fall from a higher floor ]
  end


  local function calc_room_dists()
    for cx = 1, area.cw do
    for cy = 1, area.ch do
      local id = blob_map[cx][cy]
      if not id then goto continue end

      local reg = blob_map.regions[id]
      if reg.room_dist then goto continue end

      if Cave_cell_touches_room(area, cx, cy, room, SEEDS) then
        reg.room_dist = 0
      end
      ::continue::
    end
    end

    blob_map:spread_blob_dists("room_dist")
  end


  local function calc_mapedge_dists()
    for cx = 1, area.cw do
    for cy = 1, area.ch do
      local id = blob_map[cx][cy]
      if not id then goto continue end

      local reg = blob_map.regions[id]
      if reg.mapedge_dist then goto continue end

      if Cave_cell_touches_map_edge(LEVEL, area, cx, cy) then
        reg.mapedge_dist = 0
      end
      ::continue::
    end
    end

    blob_map:spread_blob_dists("mapedge_dist")
  end


  local function temp_install_floor(FL)
    for cx = 1, area.cw do
    for cy = 1, area.ch do
      local val = area.walk_map[cx][cy]

      if val == nil then goto continue end

      area.blobs[cx][cy] = FL

      FL.cx1 = math.min(FL.cx1 or  9999, cx)
      FL.cy1 = math.min(FL.cy1 or  9999, cy)
      FL.cx2 = math.max(FL.cx2 or -9999, cx)
      FL.cy2 = math.max(FL.cy2 or -9999, cy)
      ::continue::
    end -- sx, sy
    end
  end


  local function get_most_extreme_neighbor_floor(A, mode)

    if mode == "highest" then

      local tallest_h = -EXTREME_H

      for _,N in pairs(A.neighbors) do
        if N.floor_h and N.room then
          tallest_h = math.max(tallest_h, N.floor_h)
        end
      end

      return tallest_h

    elseif mode == "lowest" then

      local lowest_h = EXTREME_H

      for _,N in pairs(A.neighbors) do
        if N.floor_h and N.room then
          lowest_h = math.min(lowest_h, N.floor_h)
        end
      end

      return lowest_h
    end
  end


  local function get_random_area(room)
    local tab = {}

    for _,A in pairs(room.areas) do
      if A.mode == "floor" and A.floor_h then
        table.insert(tab, A)
      end
    end

    return rand.pick(tab)
  end


  local function make_simple_fence()
    --
    -- WHAT: a basic fence, like in E1M1 or MAP01 of standard DOOM
    --

    local function can_rail()
      local rail_top = area.floor_h + room.scenic_fences.rail_h
      if rail_top <= area.zone.sky_h then return true end

      return false
    end

    local FL = new_blob()

    FL.floor_h = (room.max_floor_h or room.entry_h) + 72

    FL.floor_mat = assert(area.zone.fence_mat)

    FL.floor_y_offset = 0

    temp_install_floor(FL)

    area.fence_FLOOR = FL

    area.floor_h = FL.floor_h

    if rand.odds(75) and can_rail() then
      area.fence_type = "railing"
    else
      area.fence_type = false
    end
  end


  local function make_bottomless_drop()

    local FL = new_blob()

    FL.floor_h = get_most_extreme_neighbor_floor(area, "lowest") - 8192

    FL.floor_mat = assert("_SKY" --[[area.zone.fence_mat]])

    FL.floor_y_offset = 0

    temp_install_floor(FL)

    area.fence_FLOOR = FL


    -- TEMP RUBBISH
    area.floor_h = FL.floor_h
  end


  local function make_ocean()

    -- lots of water - lots and lots and lots of water

    blobify()

    calc_room_dists()
    calc_mapedge_dists()

    local FL = new_blob()

    FL.floor_h = get_most_extreme_neighbor_floor(area, "lowest") - 16

    FL.floor_mat = assert(LEVEL.liquid.mat)

    FL.floor_y_offset = 0

    temp_install_floor(FL)

    area.fence_FLOOR = FL

    -- make some cliffs

    local CLIFF = new_blob()
    local WATERFALLS = new_blob()

    CLIFF.floor_h = get_most_extreme_neighbor_floor(area, "highest") + rand.pick({56,64,72,96})
    CLIFF.floor_mat = assert(room.zone.nature_facade)

    WATERFALLS.floor_h = rand.irange(FL.floor_h + 16, CLIFF.floor_h - 16)
    WATERFALLS.floor_mat = LEVEL.liquid.mat

    for cx = 1, area.cw do
    for cy = 1, area.ch do
      local id = blob_map[cx][cy]
      if not id then goto continue end

      local reg = blob_map.regions[id]

      if not (reg.room_dist and reg.mapedge_dist) then goto continue end

      if reg.mapedge_dist * 2.4 <= reg.room_dist  then
        area.blobs[cx][cy] = CLIFF
      elseif reg.mapedge_dist * 2.2 <= reg.room_dist  then
        area.blobs[cx][cy] = WATERFALLS
      end
      ::continue::
    end
    end

    if THEME.cliff_trees then
      for id, reg in pairs(blob_map.regions) do
        local cx, cy = blob_map:random_blob_cell(id)
        if not cx then goto continue end

        local B = area.blobs[cx][cy]
        assert(B)

        if not B.floor_h then goto continue end
        if B.floor_h < CLIFF.floor_h then goto continue end

        -- don't place trees too close to the rooms... -MSSP
        if reg.room_dist < 1 then goto continue end

        local mx = area.base_x + (cx-1) * 64 + 32
        local my = area.base_y + (cy-1) * 64 + 32

        local tree = rand.key_by_probs(THEME.cliff_trees)

        Trans.entity(tree, mx, my, B.floor_h)
        ::continue::
      end
    end

    -- TEMP RUBBISH
    area.floor_h = FL.floor_h
  end


  local function make_cliff_gradient()

    -- cliffs slowly receding into the distance

    blobify()

    calc_room_dists()
    calc_mapedge_dists()

    -- initial base room is just a sky, just like bottomless drop
    local FL = new_blob()

    local main_h = get_most_extreme_neighbor_floor(area, "lowest")
    FL.floor_h = main_h - 8192
    FL.floor_mat = "_SKY"

    temp_install_floor(FL)

    -- make some purteh wurteh cluffs

    local CLIFF = new_blob()
    local CLIFF2 = new_blob()

    CLIFF.floor_h = main_h - 16
    CLIFF.floor_mat = assert(room.zone.nature_facade)

    CLIFF2.floor_h = CLIFF.floor_h - 64
    CLIFF2.floor_mat = assert(room.zone.other_nature_facade)

    for cx = 1, area.cw do
    for cy = 1, area.ch do
      local id = blob_map[cx][cy]
      if not id then goto continue end

      local reg = blob_map.regions[id]

      if not (reg.room_dist and reg.mapedge_dist) then goto continue end

      if reg.mapedge_dist * 0.4 >= reg.room_dist  then
        area.blobs[cx][cy] = CLIFF
      elseif reg.mapedge_dist * 1.0 >= reg.room_dist  then
        area.blobs[cx][cy] = CLIFF2
      end
      ::continue::
    end
    end

    if THEME.cliff_trees then
      for id, reg in pairs(blob_map.regions) do
        local cx, cy = blob_map:random_blob_cell(id)
        if not cx then goto continue end

        local B = area.blobs[cx][cy]
        assert(B)

        if not B.floor_h then goto continue end
        if B.floor_h < CLIFF2.floor_h then goto continue end

        -- don't place trees too close to the rooms... -MSSP
        if reg.room_dist < 1 then goto continue end

        local mx = area.base_x + (cx-1) * 64 + 32
        local my = area.base_y + (cy-1) * 64 + 32

        local tree = rand.key_by_probs(THEME.cliff_trees)

        Trans.entity(tree, mx, my, B.floor_h)
        ::continue::
      end
    end

    area.cliff_FLOOR = CLIFF
    area.floor_h = CLIFF.floor_h

  end


  local function make_watery_drop()
    --
    -- WHAT: large body of liquid with an impassible railing
    --

    blobify()

    calc_room_dists()
    calc_mapedge_dists()

    -- create the liquid area --

    local drop_h = rand.key_by_probs({
      [16]=4,
      [64]=1,
      [96]=1,
      [128]=1,
      [192]=1,
    })

    if room.has_hills then drop_h = drop_h / 2 end

    local FL = new_blob()

    local initial_h = get_most_extreme_neighbor_floor(area, "lowest")
    FL.floor_h   = initial_h - drop_h
    if LEVEL.liquid then
      FL.is_liquid = true
    else
      FL.floor_mat = assert(room.zone.other_nature_facade)
    end

    temp_install_floor(FL)

    area.liquid_FLOOR = FL


    -- create cliffs in the distance --

    local CLIFF  = new_blob()
    local CLIFF2 = new_blob()
    local CLIFF3 = new_blob()

    CLIFF.floor_h   = get_most_extreme_neighbor_floor(area, "highest") + 96
    CLIFF.floor_mat = assert(room.zone.nature_facade)

    local drop_diff = CLIFF.floor_h - FL.floor_h

    CLIFF3.floor_h   = FL.floor_h + math.ceil(drop_diff * 0.33)
    CLIFF3.floor_mat = assert(room.zone.other_nature_facade)

    CLIFF2.floor_h   = FL.floor_h + math.ceil(drop_diff * 0.66)
    CLIFF2.floor_mat = assert(room.zone.nature_facade)

    for cx = 1, area.cw do
    for cy = 1, area.ch do
      local id = blob_map[cx][cy]
      if not id then goto continue end

      local reg = blob_map.regions[id]

      if not (reg.room_dist and reg.mapedge_dist) then goto continue end

      if reg.mapedge_dist * 1.8 <= reg.room_dist  then
        area.blobs[cx][cy] = CLIFF
      elseif reg.mapedge_dist * 1.0 <= reg.room_dist  then
        area.blobs[cx][cy] = CLIFF2
      elseif reg.mapedge_dist * 0.4 <= reg.room_dist  then
        area.blobs[cx][cy] = CLIFF3
      end
      ::continue::
    end
    end

    area.cliff_FLOOR = CLIFF

    --add some scenery objects

    if THEME.cliff_trees then
      for id, reg in pairs(blob_map.regions) do
        local cx, cy = blob_map:random_blob_cell(id)
        if not cx then goto continue end

        local B = area.blobs[cx][cy]
        assert(B)

        if not B.floor_h then goto continue end
        if B.floor_h < CLIFF3.floor_h then
          if FL.is_liquid then
            goto continue
          end
        end

        -- less chance of using a tree on highest cliff
        if rand.odds(30) then goto continue end
        if B.floor_h > CLIFF2.floor_h and rand.odds(70) then goto continue end

        -- don't place trees too close to the rooms... -MSSP
        if reg.room_dist and reg.room_dist < 1 then goto continue end

        -- OK --
        local mx = area.base_x + (cx-1) * 64 + 32
        local my = area.base_y + (cy-1) * 64 + 32

        local tree = rand.key_by_probs(THEME.cliff_trees)

        Trans.entity(tree, mx, my, B.floor_h)
        ::continue::
      end
    end

    -- TEMP RUBBISH
    area.floor_h = initial_h



    -- NOTE: the railing is setup in Room_border_up()
  end


  local function make_fake_room()

    local FL = new_blob()

    local src_area = get_random_area(room)

    area.map_edge_type = "wall"

    FL.floor_h = src_area.floor_h
    FL.floor_mat = src_area.floor_mat
    FL.floor_y_offset = 0

    temp_install_floor(FL)

    area.floor_h = FL.floor_h

    area.fence_FLOOR = src_area.fence_mat
    area.floor_mat = FL.floor_mat
    area.main_tex = room.main_tex

  end


  local function make_no_vista()
    -- for people who don't like nice views
    area.mode = "void"
  end


  ---| Cave_build_a_scenic_vista |---

  assert(area.mode == "scenic")

  Cave_setup_stuff(area, SEEDS)

  area.external_sky = true

  Cave_map_usable_area(area)

  if area.border_type == "simple_fence" then
    make_simple_fence()

  elseif area.border_type == "watery_drop" then
    make_watery_drop()

  elseif area.border_type == "cliff_gradient" then
    make_cliff_gradient()

  elseif area.border_type == "bottomless_drop" then
    make_bottomless_drop()

  elseif area.border_type == "ocean" then
    make_ocean()

  elseif area.border_type == "fake_room" then
    make_fake_room()

  elseif area.border_type == "no_vista" then
    make_no_vista()

  else
    error("Unknown border_type: " .. tostring(area.border_type))
  end
end



function Cave_join_scenic_borders(junc)
  --
  -- See if we can join two scenic borders.
  --
  -- Note: the zones will always be the same here.
  --

  local function lower_floors(A, B)
    A.floor_h = math.min(A.floor_h, B.floor_h)
    B.floor_h = A.floor_h
  end


  local function raise_floors(A, B)
    A.floor_h = math.max(A.floor_h, B.floor_h)
    B.floor_h = A.floor_h
  end


  ---| Cave_join_scenic_borders |---

  local A = junc.A1
  local B = junc.A2

  if A.border_type == "simple_fence" and B.border_type == "simple_fence" then
    local diff_h = B.fence_FLOOR.floor_h - A.fence_FLOOR.floor_h

    -- if heights are close, increase lower one to match the other
    if math.abs(diff_h) <= 32 and rand.odds(65) then
      raise_floors(A.fence_FLOOR, B.fence_FLOOR)
    end

    return
  end

  if A.border_type == "ocean" and B.border_type == "ocean" then
      lower_floors(A.fence_FLOOR, B.fence_FLOOR)
    return
  end

  if A.border_type == "bottomless_drop" and B.border_type == "bottomless_drop" then
    return
  end

  --[[DISABLED FOR NOW...

  if A.border_type == "watery_drop" and B.border_type == "watery_drop" then
    lower_floors(A.liquid_FLOOR, B.liquid_FLOOR)
    raise_floors(A. cliff_FLOOR, B. cliff_FLOOR)
    return
  end

  if (A.border_type == "watery_drop" and B.border_type == "simple_fence") or
     (B.border_type == "watery_drop" and A.border_type == "simple_fence")
  then
    if A.border_type == "watery_drop" then A, B = B, A end

    -- tend to make nothing, but ensure the fence is not below the liquid
    if A.fence_FLOOR.floor_h >= B.liquid_FLOOR.floor_h + 32 then
       A.fence_FLOOR.floor_mat = B.cliff_FLOOR.floor_mat
       return
    end
  end]]

  -- in all other cases, make a wall
  Junction_make_wall(junc)
end
