------------------------------------------------------------------------
--  SEED MANAGEMENT / GROWING
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2008-2017 Andrew Apted
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
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


--class SEED
--[[
    --
    -- A "seed" is a square or triangle-shaped half-square on the map,
    -- used for many space allocation tasks.  The corners exist on a
    -- regular grid (currently spaced at 128 units on each axis).
    --

    sx, sy  -- location in seed map

    x1, y1, x2, y2  -- 2D map coordinates

    diagonal : DIR  -- if non-nil, then seed is split into two halves.
                    -- DIR is the corner associated with the triangle
                    -- (and the direction *away* from the diagonal line)

                       +---+   +---+
                       |\ 9|   |7 /|
                       | \ |   | / |
                       |1 \|   |/ 3|
                       +---+   +---+

    top : SEED   -- if seed is split by a diagonal, then this refers to the
                 -- information for the TOP half (i.e. the half occupying the
                 -- top edge), and the main seed contains the BOTTOM half.

    bottom : SEED   -- used in 'top' seed to refer to the other half.


    ////////////////////////

    area : AREA

    room : ROOM

    edge[DIR] : EDGE  -- set when an EDGE object exists at this seed
                      -- Note: it may be several seeds wide

    chunk : CHUNK   -- only set when seed is part of a chunk

    mid_x, mid_y  -- mid point coordinate

    floor_h, ceil_h -- floor and ceiling heights
    f_tex,   c_tex  -- floor and ceiling textures
--]]


--class EDGE
--[[
    --
    -- An "edge" is the side of a seed (or a row of seeds).
    --
    -- Primary use is for connections between a room and another room or
    -- hallway.  Also used for windows and wide walls / pictures.
    --
    -- Edges are one-sided.  For connections there will be two edges
    -- back-to-back which refer to each other via the 'peer' field.
    -- For windows and fences, one edge straddles the border and
    -- the other one is set to "nothing".
    --
    -- Closets and joiners are considered self-contained and hence
    -- do not use/require edges in their inside region.
    --
    -- For long edges, the seed in 'S' here is the left-most one
    -- (relative to the 'dir' value).  So when dir == 8 then 'S' has
    -- the lowest sx coord, and when dir == 4 it has lowest sy coord.
    --

    kind : keyword  -- "nothing" (keep it empty)
                    -- "ignore" (use the junction instead)
                    -- "wall", "doorway",
                    -- "window", "fence", "railing",
                    -- "sky_edge",
                    -- [ "steps" ]
                    -- "beams" -- ObAddon-only feature -MSSP

    S : SEED        -- first seed (the "left-most" one when facing the edge)

    dir : DIR       -- which side of the seed(s)

    long : number   -- width of edge (in seeds)

    deep : number   -- if this edge is rendered, this is the wall's depth -MSSP

    area : AREA

    conn : CONN

    peer : EDGE  -- for connections and windows, the edge on other side

    other_area : AREA   -- used for closets and joiners


    floor_h  -- floor height (set during room layouting)
--]]


--class CHUNK
--[[
    -- a rectangle of seeds within an area of a room

    kind : keyword  -- "floor" (part of a walkable area)
                    -- "ceil"  (part of a ceiling)
                    -- "liquid",
                    -- "stair",
                    -- "closet" ('T' elements in rules)
                    -- "joiner" ('J' elements in rules)
                    -- "hallway" piece
                    -- "link",

    area : AREA

    sx1, sy1, sx2, sy2   -- seed range
    cx1, cy1, cx2, cy2   -- cell range (for CAVES only)

    sw, sh  -- seed size

    x1, y1, x2, y2   -- map coordinates

    mx, my           -- coordinate of middle point

    occupy : keyword  -- "floor" (needs a ceiling + walls)
                      -- "ceil"  (needs a floor + walls)
                      -- "whole" (completely self-contained)
                      -- is NIL for content-only stuff (e.g. pillars)

    shape : keyword  -- "U" or "I" or "L" or "T" or "P",
                     -- used for stairs, closets, joiners, hallway pieces

    content : keyword  -- is NIL when unused / free
                       -- "START", "EXIT", "SECRET_EXIT",
                       -- "TELEPORTER", "SWITCH",
                       -- "KEY", "WEAPON", "ITEM",
                       -- "CAGE", "TRAP", "DECORATION",

    is_secret      -- boolean
    is_bossy       -- boolean  (keep it clear for a boss monster)
    is_terminator  -- boolean  (for hallway pieces)

    lock : LOCK    -- present when "ITEM" (etc) needs a switch
                   -- (such as a lowering pedestal)

    goal : GOAL    -- for "SWITCH" contents, this is the goal which the
                   -- switch is for.  [ used to get the action and tag ]

    h_join[DIR] : CHUNK   -- for hallway pieces: nearby chunks

    peer : CHUNK   -- in symmetrical rooms, this is mirrored chunk

    floor_h        -- if present, overrides the area info  [ for nature areas ]
    floor_mat      -- if present, overrides the area info  [ for nature areas ]

    from_dir  : DIR
    from_area : AREA

    dest_dir  : DIR
    dest_area : AREA

     ceil_above : CHUNK  -- for "floor" kind, this is ceiling (NIL in outdoor rooms)
    floor_below : CHUNK  -- for "ceil" kind, this is floor chunk

    encroach[SIDE]   -- how much distance is used on each side, often zero
                     -- [ used by walls, archways, etc... ]

    open_to_sky   -- true if all sides face an outdoor area
    open_to_room  -- true if all sides face an open area of the room
--]]


--------------------------------------------------------------]]


BASE_X = 0
BASE_Y = 0


SEED_CLASS = {}

--
-- convert a square seed to a pair of diagonal seeds.
-- the 'S' parameter becomes the bottom half.
--
-- NOTE: should only be done on unused seeds.
--
function SEED_CLASS.split(S, diagonal)
  assert(diagonal == 1 or diagonal == 3)
  assert(not S.diagonal)

  S.diagonal = diagonal

  local S2 = Seed_create(S.sx, S.sy, S.x1, S.y1)

  S2.diagonal = 10 - diagonal

  S2.x1 = S.x1 ; S2.y1 = S.y1
  S2.x2 = S.x2 ; S2.y2 = S.y2

  S2.edge_of_map = S.edge_of_map

  S .name = string.format("SEED [%d,%d,B]", S.sx, S.sy)
  S2.name = string.format("SEED [%d,%d,T]", S.sx, S.sy)

  -- link fake seed with real one
  S.top = S2 ; S2.bottom = S

  -- update mid-points
  S :calc_mid_point()
  S2:calc_mid_point()
end


function SEED_CLASS.join_halves(S)
  assert(S.diagonal)
  assert(S.top and not S.bottom)

  local S2 = S.top

  S.diagonal = nil
  S.top = nil

  S.name = string.format("SEED [%d,%d]", S.sx, S.sy)

  S:calc_mid_point()

  -- kill the other half

  S2.name = "DEAD_" .. S2.name
  S2.is_dead = true
  S2.diagonal = "dead"

  S2.area = nil
  S2.room = nil
  S2.edge = nil
end


-- NOTE: this is "raw" and does not handle diagonal seeds
function SEED_CLASS.raw_neighbor(S, dir, dist, SEEDS)
  local nx, ny = geom.nudge(S.sx, S.sy, dir, dist)

  if nx < 1 or nx > SEED_W or ny < 1 or ny > SEED_H then
    return nil
  end

  return SEEDS[nx][ny]
end


--
-- This method handles diagonal seeds.  'S' should be one particular half
-- ('top' or 'bottom'), and the result 'N' will also be a certain half.
--
-- Returns 'nodir' parameter when 'dir' makes no sense
-- (i.e. for square seed, only 2/4/6/8, and for a diagonal, only 3 dirs).
--
-- Returns NIL for edge of map (like the raw_neighbor method).
--
function SEED_CLASS.neighbor(S, dir, nodir, SEEDS)
  local N

  -- handle square seeds

  if not S.diagonal then
    if not (dir == 2 or dir == 4 or dir == 6 or dir == 8) then
      return nodir
    end

    N = S:raw_neighbor(dir, nil, SEEDS)

    if N then
      if dir == 2 and N.diagonal then return N.top end

      if dir == 4 and N.diagonal == 1 then return N.top end
      if dir == 6 and N.diagonal == 3 then return N.top end
    end

    return N
  end

  -- handle diagonal seeds

  if (S.diagonal == 7 or S.diagonal == 9) and dir == 8 then
    return S:raw_neighbor(dir, nil, SEEDS)
  end

  if (S.diagonal == 1 or S.diagonal == 3) and dir == 2 then
    N = S:raw_neighbor(dir, nil, SEEDS)
    if N and N.diagonal then return N.top end
    return N
  end

  if (S.diagonal == 1 or S.diagonal == 7) and dir == 4 then
    N = S:raw_neighbor(dir, nil, SEEDS)
    if N and N.diagonal == 1 then return N.top end
    return N
  end

  if (S.diagonal == 3 or S.diagonal == 9) and dir == 6 then
    N = S:raw_neighbor(dir, nil, SEEDS)
    if N and N.diagonal == 3 then return N.top end
    return N
  end

  -- diagonal directions in directions seeds

  if S.diagonal == 1 and dir == 9 then return S.top end
  if S.diagonal == 3 and dir == 7 then return S.top end

  if S.diagonal == 7 and dir == 3 then return S.bottom end
  if S.diagonal == 9 and dir == 1 then return S.bottom end

  return nodir
end


function SEED_CLASS.same_room(S, dir)
  local N = S:neighbor(dir)

  return N and (N.room == S.room)
end


function SEED_CLASS.calc_mid_point(S)
  -- 'S' can be a half-seed too
  local mx = (S.x1 + S.x2) / 2
  local my = (S.y1 + S.y2) / 2

  if S.diagonal == 1 then
    mx = (S.x1 + mx) / 2
    my = (S.y1 + my) / 2

  elseif S.diagonal == 3 then
    mx = (S.x2 + mx) / 2
    my = (S.y1 + my) / 2

  elseif S.diagonal == 7 then
    mx = (S.x1 + mx) / 2
    my = (S.y2 + my) / 2

  elseif S.diagonal == 9 then
    mx = (S.x2 + mx) / 2
    my = (S.y2 + my) / 2
  end

  S.mid_x = math.round(mx)
  S.mid_y = math.round(my)
end


function SEED_CLASS.mid_point(S)
  assert(S.mid_x)

  return S.mid_x, S.mid_y
end


function SEED_CLASS.midstr(S)
  return string.format("SEED(%+5d %+5d)", S.mid_x, S.mid_y)
end


function SEED_CLASS.left_corner_coord(S, dir)
  -- assumes 'dir' is a valid direction for this seed (or half-seed)

  if geom.is_corner(dir) then
    dir = geom.LEFT_45[dir]
  end

  if dir == 8 then return S.x1, S.y2 end
  if dir == 2 then return S.x2, S.y1 end

  if dir == 4 then return S.x1, S.y1 end
  if dir == 6 then return S.x2, S.y2 end

  error("bad dir to SEED:left_corner_coord")
end


function SEED_CLASS.right_corner_coord(S, dir)
  -- assumes 'dir' is a valid direction for this seed (or half-seed)

  if geom.is_corner(dir) then
    dir = geom.RIGHT_45[dir]
  end

  if dir == 8 then return S.x2, S.y2 end
  if dir == 2 then return S.x1, S.y1 end

  if dir == 4 then return S.x1, S.y2 end
  if dir == 6 then return S.x2, S.y1 end

  error("bad dir to SEED:left_corner_coord")
end


function SEED_CLASS.edge_mid_coord(S, dir)
  -- assumes 'dir' is a valid direction for this seed (or half-seed)

  local mx, my = S:mid_point()

  if dir == 2 then return mx, S.y1 end
  if dir == 8 then return mx, S.y2 end

  if dir == 4 then return S.x1, my end
  if dir == 6 then return S.x2, my end

  -- diagonal edge
  return mx, my
end


function SEED_CLASS.raw_corner(S, LEVEL, dir)
  -- this method is RAW: it does not care about diagonals

  local cx = S.sx
  local cy = S.sy

  if dir == 3 or dir == 9 then cx = cx + 1 end
  if dir == 7 or dir == 9 then cy = cy + 1 end

  return Corner_lookup(LEVEL, cx, cy)
end


function SEED_CLASS.get_corner(S, LEVEL, dir)
  -- check for invalid dir (e.g. when looping over all corners)
  if S.diagonal == (10 - dir) then
    return nil
  end

  return S:raw_corner(LEVEL, dir)
end


function SEED_CLASS.line_coords(S, dir)
  local x1, y1 = S.x1, S.y1
  local x2, y2 = S.x2, S.y2

  if dir == 8 then y1 = y2 end
  if dir == 2 then y2 = y1 end
  if dir == 4 then x2 = x1 end
  if dir == 6 then x1 = x2 end

  if dir == 2 then
    x1, x2 = x2, x1
  end

  if dir == 6 or dir == 1 or dir == 9 then
    y1, y2 = y2, y1
  end

  return x1,y1, x2,y2
end


function SEED_CLASS.has_inner_point(S, dir)
  local corner = S:get_corner(dir)

  return corner and corner.inner_point
end


function SEED_CLASS.has_connection(S)
  for _,dir in pairs(geom.ALL_DIRS) do
    local E = S.edge[dir]
    if E and E.conn then return true end
  end

  return false
end


function SEED_CLASS.make_brush(S)
  local brush =
  {
    { x=S.x1, y=S.y1, __dir=2 },
    { x=S.x2, y=S.y1, __dir=6 },
    { x=S.x2, y=S.y2, __dir=8 },
    { x=S.x1, y=S.y2, __dir=4 },
  }

  if S.diagonal == 3 then
    brush[3].__dir = 7
    table.remove(brush, 4)

  elseif S.diagonal == 7 then
    brush[1].__dir = 3
    table.remove(brush, 2)

  elseif S.diagonal == 1 then
    brush[2].__dir = 9
    table.remove(brush, 3)

  elseif S.diagonal == 9 then
    brush[4].__dir = 1
    table.remove(brush, 1)

  elseif S.diagonal then
    error("Invalid diagonal seed!")
  end

  return brush
end


----------------------------------------------------------------------


function Seed_create(sx, sy, x1, y1)
  local S =
  {
    sx = sx,
    sy = sy,

    x1 = x1,
    y1 = y1,

    name = string.format("SEED [%d,%d]", sx, sy),

    edge   = {},
    m_cell = {},
  }

  S.x2 = S.x1 + SEED_SIZE
  S.y2 = S.y1 + SEED_SIZE

  table.set_class(S, SEED_CLASS)

  S:calc_mid_point()

  return S
end


function Seed_init(LEVEL)
  local SEEDS = table.array_2D(SEED_W, SEED_H)

  -- offset the map in DOOM for flat alignment
  BASE_X = 32
  BASE_Y = 32

  BASE_X = 32 - math.round(SEED_W / 2) * SEED_SIZE
  BASE_Y = 32 - math.round(SEED_H / 2) * SEED_SIZE

  for sx = 1, SEED_W do
  for sy = 1, SEED_H do
    local x1 = BASE_X + (sx-1) * SEED_SIZE
    local y1 = BASE_Y + (sy-1) * SEED_SIZE

    SEEDS[sx][sy] = Seed_create(sx, sy, x1, y1)
  end -- x,y
  end

  -- init depot locations [ for teleport-in monsters ]

  LEVEL.depot_locs = {}

  local depot_x = BASE_X
  local depot_y = BASE_Y + SEED_H * SEED_SIZE

  for row = 0, 2 do
  for col = 0, math.round(SEED_W / 3) - 1 do
    local x = depot_x + col * 3 * SEED_SIZE
    local y = depot_y + row * 6 * SEED_SIZE + 64

    table.insert(LEVEL.depot_locs, { x=x, y=y })
  end
  end
  return SEEDS
end


function Seed_valid(x, y)
  return (x >= 1 and x <= SEED_W) and
         (y >= 1 and y <= SEED_H)
end


function Seed_get_safe(x, y)
  return Seed_valid(x, y) and SEEDS[x][y]
end


function Seed_is_free(x, y)
  assert(Seed_valid(x, y))

  return not SEEDS[x][y].room
end


function Seed_valid_and_free(x, y)
  if not Seed_valid(x, y) then
    return false
  end

  return Seed_is_free(x, y)
end


function Seed_block_valid_and_free(x1,y1, x2,y2)

  assert(x1 <= x2 and y1 <= y2)

  if not Seed_valid(x1, y1) then return false end
  if not Seed_valid(x2, y2) then return false end

  for x = x1,x2 do
  for y = y1,y2 do
    local S = SEEDS[x][y][z]
    if S.room then
      return false
    end
  end -- x, y
  end

  return true
end


function Seed_squarify(LEVEL, SEEDS)
  -- detects when a diagonal seed has same area on each half, and
  -- merges the two halves into a full seed

  for sx = 1, SEED_W do
  for sy = 1, SEED_H do
    local S = SEEDS[sx][sy]

    if S.diagonal and S.top.area == S.area then
      S:join_halves()
    end
  end -- sx, sy
  end

  for _,A in pairs(LEVEL.areas) do
    A:remove_dead_seeds()
  end
end


function Seed_coord_range(sx1, sy1, sx2, sy2)
  assert(Seed_valid(sx1, sy1))
  assert(Seed_valid(sx2, sy2))

  local S1 = SEEDS[sx1][sy1]
  local S2 = SEEDS[sx2][sy2]

  return S1.x1, S1.y1, S2.x2, S2.y2
end


function Seed_from_coord(x, y, SEEDS)
  local sx = 1 + math.floor((x - BASE_X) / SEED_SIZE)
  local sy = 1 + math.floor((y - BASE_Y) / SEED_SIZE)

  -- clamp to usable range, mainly to handle edge cases
  sx = math.clamp(1, sx, SEED_W)
  sy = math.clamp(1, sy, SEED_H)

  return SEEDS[sx][sy]
end


function Seed_from_loc(loc)
  -- loc is 1 .. 9 (like number on the numeric keypad)

  local dx, dy = geom.delta(loc)

  dx = 0.5 + dx * 0.3 + rand.irange(-2, 2) / 20
  dy = 0.5 + dy * 0.3 + rand.irange(-2, 2) / 20

  local sx = rand.int(SEED_W * dx - 1.5)
  local sy = rand.int(SEED_H * dy - 1.5)

  sx = math.clamp(1, sx, SEED_W)
  sy = math.clamp(1, sy, SEED_H)

  return sx, sy
end


function Seed_inside_sprout_box(LEVEL, sx, sy)
  if sx < LEVEL.sprout_x1 or sx > LEVEL.sprout_x2 then return false end
  if sy < LEVEL.sprout_y1 or sy > LEVEL.sprout_y2 then return false end

  return true
end


function Seed_inside_boundary(LEVEL, sx, sy)
  if sx < LEVEL.walkable_x1 or sx > LEVEL.walkable_x2 then return false end
  if sy < LEVEL.walkable_y1 or sy > LEVEL.walkable_y2 then return false end

  return true
end


function Seed_inside_abs_limit(sx, sy)
  if sx < LEVEL.absolute_x1 or sx > LEVEL.absolute_x2 then return false end
  if sy < LEVEL.absolute_y1 or sy > LEVEL.absolute_y2 then return false end

  return true
end


function Seed_alloc_depot(LEVEL, room)
  -- returns NIL if no more are possible

  if table.empty(LEVEL.depot_locs) then
    return nil
  end

  local loc = table.remove(LEVEL.depot_locs, 1)

  local DEPOT =
  {
    room = room,
    x1 = loc.x,
    y1 = loc.y,
    skin = {},
  }

  DEPOT.skin.wall = "_ERROR"

  table.insert(LEVEL.depots, DEPOT)

  return DEPOT
end



function Seed_dump_rooms(SEEDS)
  local function seed_to_char(S)
    if not S then return "!" end
    if S.custom then return S.custom end
    if S.free then return "!" end
    if S.error then return "?" end

    local R = S.room or (S.top and S.top.room)

    if not R then return " " end

    if S.diagonal == 1 then return "\\" end
    if S.diagonal == 3 then return "/" end

    if S.area then
      if S.area.chunk then
        if S.area.chunk.kind == "closet" then return "#" end
        if S.area.chunk.kind == "joiner" then 
          if S.area.chunk.from_dir == 2 then return "▲" end
          if S.area.chunk.from_dir == 4 then return "►" end
          if S.area.chunk.from_dir == 6 then return "◄" end
          if S.area.chunk.from_dir == 8 then return "▼" end
        end
        if S.area.chunk.kind == "stair" then
          if S.area.chunk.from_dir == 2 then return "↑" end
          if S.area.chunk.from_dir == 4 then return "→" end
          if S.area.chunk.from_dir == 6 then return "←" end
          if S.area.chunk.from_dir == 8 then return "↓" end
        end
      end
    end

    if R.is_outdoor then
      local n = 1 + ((R.id - 1) % 26)
      return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
    end

    local n = 1 + ((R.id - 1) % 26)
    return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
  end

  for y = SEED_H,1,-1 do
    local line = "  "
    for x = 1,SEED_W do
      line = line .. seed_to_char(SEEDS[x][y])
    end
    line = string.gsub(line, "  *$", "")
    gui.printf("%s\n", line)
  end

  gui.printf("\n")
end



function Seed_save_svg_image(filename, SEEDS)

  -- grid size
  local SIZE = 10

  local TOP  = (SEED_H + 1) * SIZE

  local fp


  local function wr_line(fp, x1, y1, x2, y2, color, width)
    fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
             10 + x1, TOP - y1, 10 + x2, TOP - y2, color, width or 1))
  end


  local function wr_seed_box(fp, x1, y1, x2, y2, color, width)
    x1 = x1 * SIZE
    y1 = y1 * SIZE

    x2 = (x2 + 1) * SIZE
    y2 = (y2 + 1) * SIZE

    wr_line(fp, x1,y1, x1,y2, color, width)
    wr_line(fp, x1,y1, x2,y1, color, width)
    wr_line(fp, x2,y1, x2,y2, color, width)
    wr_line(fp, x1,y2, x2,y2, color, width)
  end


  local function visit_seed(S1, dir)
    local S2 = S1:neighbor(dir, "NODIR", SEEDS)

    if S2 == "NODIR" then return end

    local A1 = S1.area
    local A2 = S2 and S2.area

    local color = "#777"
    local lin_w = 2

    if S1.kind == "dead" or (S2 and S2.kind == "dead") then
      color = "#f00"
      lin_w = 3

    elseif (S1.h_link or (S2 and S2.h_link)) and S1.h_link ~= (S2 and S2.h_link) then
      color = "#f00"

    elseif not A1 then
      return

    elseif not A2 then
      -- no change

    elseif A1 == A2 then
      color = "#ccf"
      lin_w = 1
      return

    elseif not A1.room and not A2.room then
      -- no change

    elseif (A1.chunk and A1.chunk.kind == "joiner") or (A2.chunk and A2.chunk.kind == "joiner") then
      color = "#f0f"
    elseif A1.room and (A1.room == A2.room) then
      color = "#0f0"
    elseif (A1.room and A1.room.is_hallway) or (A2.room and A2.room.is_hallway) then
      color = "#fb0"
    else
      color = "#00f"
      lin_w = 3
    end

    local sx1, sy1 = S1.sx, S1.sy
    local sx2, sy2 = sx1 + 1, sy1 + 1

    if dir == 3 or dir == 7 then
      -- no change

    elseif dir == 1 or dir == 9 then
      sy1, sy2 = sy2, sy1

    elseif dir == 2 then sy2 = sy1
    elseif dir == 8 then sy1 = sy2
    elseif dir == 4 then sx2 = sx1
    elseif dir == 6 then sx1 = sx2
    else
      error("uhhh what")
    end

    wr_line(fp, (sx1 - 1) * SIZE, (sy1 - 1) * SIZE,
                (sx2 - 1) * SIZE, (sy2 - 1) * SIZE, color, lin_w)
  end


  ---| Seed_save_svg_image |---

  fp = io.open(gui.get_save_path() .. "/" .. filename, "w")

  if not fp then error("Cannot create file") end

  -- header
  fp:write('<?xml version="1.0" encoding="UTF-8" standalone="no"?>')
  fp:write('<svg xmlns="http://www.w3.org/2000/svg" version="1.1">\n')

  -- grid
  local min_x = 0
  local min_y = 0

  local max_x = SEED_W * SIZE
  local max_y = SEED_H * SIZE

  fp:write(string.format("<rect width=\"%d\" height=\"%d\" fill=\"#fff\"/>",
           max_x + SIZE, max_y + SIZE))

  for x = 0, SEED_W do
    wr_line(fp, x * SIZE, min_y, x * SIZE, max_y, "#bbb")
  end

  for y = 0, SEED_H do
    wr_line(fp, min_x, y * SIZE, max_x, y * SIZE, "#bbb")
  end

  -- special bboxes
  if false then
    wr_seed_box(fp, LEVEL.sprout_x1, LEVEL.sprout_y1, LEVEL.sprout_x2, LEVEL.sprout_y2, "#cc0", 3)
    wr_seed_box(fp, LEVEL.walkable_x1, LEVEL.walkable_y1, LEVEL.walkable_x2, LEVEL.walkable_y2, "#f00", 3)
  end

  -- edges
  for x = 1, SEED_W do
  for y = 1, SEED_H do
    local S = SEEDS[x][y]

    for _,dir in pairs(geom.ALL_DIRS) do
      visit_seed(S, dir)
      if S.top then visit_seed(S.top, dir) end
    end
  end
  end

  -- end
  fp:write('</svg>\n')

  fp:close()
end



function Seed_draw_minimap(SEEDS, LEVEL)
  local map_W  -- size in the GUI
  local map_H  --

  local S1 = SEEDS[LEVEL.walkable_x1][LEVEL.walkable_y1]
  local S2 = SEEDS[LEVEL.walkable_x2][LEVEL.walkable_y2]

  local min_x = S1.x1 - 64
  local min_y = S1.y1 - 64

  local max_x = S2.x2 + 64
  local max_y = S2.y2 + 64

  local  width = max_x - min_x
  local height = max_y - min_y

  local size = math.max(width, height)

  local ofs_x = (size -  width) / 2
  local ofs_y = (size - height) / 2


  local function draw_edge(S, dir, color)
    local x1,y1, x2,y2 = S:line_coords(dir)

    x1 = (x1 - min_x + ofs_x) * map_W / size
    x2 = (x2 - min_x + ofs_x) * map_W / size

    y1 = (y1 - min_y + ofs_y) * map_H / size
    y2 = (y2 - min_y + ofs_y) * map_H / size

    gui.minimap_draw_line(math.round(x1),math.round(y1), math.round(x2),math.round(y2), color)
  end


  local function visit_seed(S1, dir)
    local S2 = S1:neighbor(dir, "NODIR", SEEDS)

    if S2 == "NODIR" then return end

    local A1 = S1.area
    local A2 = S2 and S2.area

    local R1 = A1 and A1.room
    local R2 = A2 and A2.room

    -- treat closets as not part of the room
    if R1 and A1.chunk and A1.chunk.kind == "closet" then R1 = nil end
    if R2 and A2.chunk and A2.chunk.kind == "closet" then R2 = nil end

    if not (R1 or R2) then return end

    if R1 == R2 then
      -- in same room, draw area boundaries in a not-too-bright color
      if A1.name < A2.name then
        draw_edge(S1, dir, "#aaaaaa")
      end

      return
    end

    -- ensure we only draw edges between two rooms once
    if R1 and R2 then
      if R1.name > R2.name then return end
    end

    local color = "#ffffff"

    if (R1 and R1.is_cave) or (R2 and R2.is_cave) then
      color = "#ff9933"
    elseif (R1 and R1.is_outdoor) or (R2 and R2.is_outdoor) then
      color = "#11aaff"
    end

    if (R1 and R1.is_park) or (R2 and R2.is_park) then
      color = "#70d872"
    end

    draw_edge(S1, dir, color)
  end


  ---| Seed_draw_minimap |---

  map_W, map_H = gui.minimap_begin()

  for x = 1, SEED_W do
  for y = 1, SEED_H do
    local S = SEEDS[x][y]

    for _,dir in pairs(geom.ALL_DIRS) do
      visit_seed(S, dir)
      if S.top then visit_seed(S.top, dir) end
    end
  end
  end
  if PARAM["bool_save_gif"] == 1 then
    gui.minimap_gif_frame()
  end
  gui.minimap_finish()
  gui.ticker()
end


------------------------------------------------------------------------


function Edge_new(kind, S, dir, long, LEVEL, SEEDS)
  -- Note: 'S' must be the left-most seed of a long edge

  local EDGE =
  {
    S = S,
    dir = dir,
    long = long,
    kind = kind,
    area = S.area
  }

  -- add it into each seed
  for i = 1, long do
    if not S then
      gui.printf(table.tostr(EDGE) .. "\n")
      gui.printf(table.tostr(EDGE.area) .. "\n")
      gui.printf(table.tostr(EDGE.area.room) .. "\n")
      -- note: this mostly only happens when a
      -- room-to-room connection (direct or via joiner)
      -- does not perfectly meet
      -- each other on the edge
      -- check shape rules for misbehaved shapes
      EDGE.S.error = true
      Seed_dump_rooms()
      error("Room connection check failed. \n\n" ..
          "Junction edge run has encountered to a missing seed. \n\n" ..
          "This is not a fun error message. Fun is not allowed. \n\n" ..
          "But you know what's less fun? If you report this message but " ..
          "don't provide your LOG info to describe its circumstances, which " ..
          "is more frustrating. \n\n" ..
          "ALSO OH GOD I CANT INTO COMPUTER PLS HELP")
    end

    assert(S)

    if S.edge[dir] then
      print("Seed already has an EDGE @ " .. S.mid_x .. ", ".. S.mid_y)
    end

    S.edge[dir] = EDGE

    S = S:neighbor(geom.RIGHT[dir], nil, SEEDS)
  end

  -- add it to area list
  if true then
    local A = assert(EDGE.area)
    table.insert(A.edges, EDGE)
  end

  -- add it to corners
  Corner_add_edge(EDGE, LEVEL)

  return EDGE
end


function Edge_new_opposite(kind, S, dir, long, LEVEL, SEEDS)
  local N = S:neighbor(dir, nil, SEEDS)
  assert(N)

  for k = 1, long-1 do
    N = N:neighbor(geom.RIGHT[dir], nil, SEEDS)
    if not N then
      S.error = true
      gui.printf(table.tostr(S) .. "\n")
      gui.printf(table.tostr(S.area) .. "\n")
    end
    assert(N)
  end

  return Edge_new(kind, N, 10-dir, long, LEVEL, SEEDS)
end


function Edge_new_pair(kind1, kind2, S, dir, long, LEVEL, SEEDS)
  local E1 = Edge_new         (kind1, S, dir, long, LEVEL, SEEDS)
  local E2 = Edge_new_opposite(kind2, S, dir, long, LEVEL, SEEDS)

  E1.peer = E2
  E2.peer = E1

  return E1, E2
end


function Edge_mark_walk(E, SEEDS)
  local S = E.S

  for i = 1, E.long do
    assert(S)

    S.must_walk = true

    S = S:neighbor(geom.RIGHT[E.dir], nil, SEEDS)
  end
end


function Edge_line_coords(E, SEEDS)
  local x1, y1 = E.S:left_corner_coord(E.dir)

  -- determine seed at other end of edge
  local N = E.S

  if E.long >= 2 then
    if N.bottom then N = N.bottom end
    N = N:raw_neighbor(geom.RIGHT[E.dir], E.long - 1, SEEDS)
    assert(N)
  end

  local x2, y2 = N:right_corner_coord(E.dir)

  return x1,y1, x2,y2
end


function Edge_mid_point(E, SEEDS)
  local x1,y1, x2,y2 = Edge_line_coords(E, SEEDS)

  x1 = (x1 + x2) / 2
  y1 = (y1 + y2) / 2

  return x1, y1
end


function Edge_is_wallish(E)
  if E.is_wallish then return true end

  if E.kind == "wall" or
     E.kind == "window" or
     E.kind == "doorway"
  then
    return true
  end

  -- handle straddling stuff
  if E.peer and E.kind == "nothing" then
    local kind2 = E.peer.kind

    if kind2 == "window" or
       kind2 == "doorway"
    then
      return true
    end
  end

  return false
end


function Edge_wallish_tex(E)
  -- this handles most cases
  if E.wall_mat then
    return E.wall_mat
  end

  -- closets and joiners
  if E.other_area then
    return Junction_calc_wall_tex(E.area, E.other_area)
  end

  -- fallback
  return "_ERROR"
end


function Edge_is_fencish(E)
  if E.kind == "fence" then return true end

  if E.peer and E.kind == "nothing" then
    if E.peer.kind == "fence" then return true end
  end

  return false
end


------------------------------------------------------------------------


CHUNK_CLASS = {}


function CHUNK_CLASS.new(SEEDS, LEVEL, kind, sx1,sy1, sx2,sy2)
  local CK =
  {
    id = alloc_id(LEVEL, "chunk"),

    kind = kind,

    sx1 = sx1, sy1 = sy1,
    sx2 = sx2, sy2 = sy2,

    sw = (sx2 - sx1 + 1),
    sh = (sy2 - sy1 + 1),

    encroach = {},
  }

  CK.name = string.format("CHUNK_%d", CK.id)

  table.set_class(CK, CHUNK_CLASS)

  local S1 = SEEDS[sx1][sy1]
  local S2 = SEEDS[sx2][sy2]

  CK.x1, CK.y1 = S1.x1, S1.y1
  CK.x2, CK.y2 = S2.x2, S2.y2

  CK.mx = math.mid(S1.x1, S2.x2)
  CK.my = math.mid(S1.y1, S2.y2)

  return CK
end


function CHUNK_CLASS.kill_it(CK, SEEDS)
  assert(not CK.is_dead)

  for sx = CK.sx1, CK.sx2 do
  for sy = CK.sy1, CK.sy2 do
    local S = SEEDS[sx][sy]

    -- FIXME : this is WRONG WRONG WRONG
    if S.chunk == CK then S.chunk = nil end
  end
  end

  CK.kind = "DEAD_" .. CK.kind
  CK.is_dead = true

  CK.area   = nil
  CK.occupy = nil
  CK.shape  = nil

  CK.sx1  = nil ; CK.sx2  = nil
  CK.sy1  = nil ; CK.sy2  = nil

  if CK.peer then
     CK.peer.peer = nil
     CK.peer = nil
  end
end


function CHUNK_CLASS.base_reqs(chunk, dir)
  local reqs =
  {
    where  = "seeds",

    seed_w = chunk.sw,
    seed_h = chunk.sh
  }

  if geom.is_horiz(dir) then
    reqs.seed_w = chunk.sh
    reqs.seed_h = chunk.sw
  end

  local h1, h2

  if chunk.from_area then h1 = chunk.from_area:get_height() end
  if chunk.dest_area then h2 = chunk.dest_area:get_height() end

  if h1 and h2 then
    reqs.height = math.min(h1, h2)
  else
    reqs.height = h1 or h2
  end

  return reqs
end


function CHUNK_CLASS.is_slave(chunk)
  -- the "slave" chunk is a peered chunk with a higher ID number

  if not chunk.peer then return false end

  return chunk.id > chunk.peer.id
end


function CHUNK_CLASS.is_must_walk(chunk, SEEDS)
  for sx = chunk.sx1, chunk.sx2 do
  for sy = chunk.sy1, chunk.sy2 do
    local S = SEEDS[sx][sy]

    if S.must_walk then return true end
  end
  end

  return false
end


function CHUNK_CLASS.is_open_to_sky(chunk, R, SEEDS)
  -- are all neighbors of the chunk going to be a sky ceiling?

  if not R.is_outdoor then return false end

  local function area_open_to_sky(A)
    if not A.is_outdoor then return false end
    if A.mode == "void" then return false end
    if A.room and A.room ~= R then return false end
    if A.mode == "scenic" and A.face_room ~= R then return false end
    if A.border_type == "no_vista" then return false end

    return true
  end

  for sx = chunk.sx1-1, chunk.sx2+1 do
  for sy = chunk.sy1-1, chunk.sy2+1 do
    -- only check seeds around the chunk
    if (sx >= chunk.sx1 and sx <= chunk.sx2) and
       (sy >= chunk.sy1 and sy <= chunk.sy2)
    then goto continue end

    if not Seed_valid(sx, sy) then return false end

    local S = SEEDS[sx][sy]

    local A = S.area
    if not (A and area_open_to_sky(A)) then return false end

    if S.diagonal then
      A = S.top.area
      if not (A and area_open_to_sky(A)) then return false end
    end
    ::continue::
  end
  end

  return true
end


function CHUNK_CLASS.is_open_to_room(chunk, R)
  -- chunk faces a normal (open) area of the room on ALL sides?
  -- TODO : determine max_floor and min_ceil of neighbors
  --        [ fail when height < N, e.g. 128 ]

  if R.is_outdoor then return false end

  local function area_open_to_room(A)
    if A.room ~= R then return false end

    -- TODO : check for stairs

    if not (A.mode == "floor" or A.mode == "nature" or
            A.mode == "liquid")
    then return false end

    return true
  end

  for sx = chunk.sx1-1, chunk.sx2+1 do
  for sy = chunk.sy1-1, chunk.sy2+1 do
    -- only check seeds around the chunk
    if (sx >= chunk.sx1 and sx <= chunk.sx2) and
       (sy >= chunk.sy1 and sy <= chunk.sy2)
    then goto continue end

    if not Seed_valid(sx, sy) then return false end

    local S = SEEDS[sx][sy]

    local A = S.area
    if not (A and area_open_to_room(A)) then return false end

    if S.diagonal then
      A = S.top.area
      if not (A and area_open_to_room(A)) then return false end
    end
    ::continue::
  end
  end

  return true
end


function CHUNK_CLASS.create_edge(chunk, LEVEL, kind, side, SEEDS)
  -- the edge faces *into* the chunk (on the given side)

  local sx, sy

  if side == 2 then sx = chunk.sx1 ; sy = chunk.sy1 - 1 end
  if side == 8 then sx = chunk.sx2 ; sy = chunk.sy2 + 1 end

  if side == 4 then sx = chunk.sx1 - 1 ; sy = chunk.sy2 end
  if side == 6 then sx = chunk.sx2 + 1 ; sy = chunk.sy1 end

  assert(Seed_valid(sx, sy))

  local long = geom.vert_sel(side, chunk.sw, chunk.sh)

  local S = SEEDS[sx][sy]

  local E

  if S then
    E = Edge_new(kind, S, 10-side, long, LEVEL, SEEDS)
  else
    return nil
  end

  E.other_area = chunk.area

  return E
end


function CHUNK_CLASS.create_edge_pair(chunk, LEVEL, kind1, side, SEEDS)
  local E1 = chunk:create_edge(LEVEL, kind1, side, SEEDS)

  local E2 = Edge_new_opposite("nothing", E1.S, E1.dir, E1.long, LEVEL, SEEDS)

  return E1, E2
end


function CHUNK_CLASS.flip(chunk)
  local A1 = chunk.from_area
  local A2 = chunk.dest_area

  chunk.from_area = A2
  chunk.dest_area = A1

  if chunk.shape == "L" then
    chunk.from_dir, chunk.dest_dir = chunk.dest_dir, chunk.from_dir
  else
    chunk.from_dir = 10 - chunk.from_dir

    if chunk.dest_dir then
      chunk.dest_dir = 10 - chunk.dest_dir
    end
  end

  chunk.is_flipped = not chunk.is_flipped
end
