----------------------------------------------------------------
--  Room Layouting
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

--[[ *** CLASS INFORMATION ***

class ROOM
{
  kind : keyword  -- Indoor values: "room", "hallway", "stairwell"
                  -- Outdoor values: "ground", "hill", "valley"

  outdoor : bool  -- true for outdoor rooms

  conns : array(CONN)  -- connections with neighbor rooms

  branch_kind : keyword

  symmetry : keyword   -- symmetry of connections, or NIL
                       -- keywords are "x", "y", "xy", "r", "t"

  sx1, sy1, sx2, sy2  -- \ Seed range
  sw, sh, svolume     -- /

  floor_h, ceil_h : number

  purpose : keyword   -- usually NIL, can be "EXIT" etc... (FIXME)

  arena : ARENA


  --- plan_sp code only:

  lx1, ly1, lx2, ly2  -- coverage on the Land Map

  group_id : number  -- traversibility group

  --- layout code only:

  tx1, ty1, tx2, ty2, tw, th  -- Seed range for layouting

  layout_symmetry : keyword  -- can be "none", "x", "y", "xy"
}


----------------------------------------------------------------


Room Layouting Notes
====================

IDEAS:

- height diffs:
  - basic (if all else fails) algorithm:
    flood fill heights from conn seeds to remaining seeds
    [BUT: floor_h of room]
    add a stair seed at some meeting spots

    if height diff is huge, deserves more seeds

  - patterns:
    (a) L shape is nice
    (b) U shape is possible
    (c) plain side fill (two deep if room is big)

--------------------------------------------------------------]]


require 'defs'
require 'util'


function Room_SetupTheme(R)
 
  --!!! TEMP CRUD to decide Outdoorsiness
  if R.outdoor == nil then
    if R.parent then
      if R.parent.outdoor == nil then Room_SetupTheme(R.parent) end
      R.outdoor = sel(R.parent.outdoor, false, rand_odds(25))

    else
      local outdoor_chance = 10

      if R.sx1 <= 2 or R.sx2 >= SEED_W-1 then outdoor_chance = outdoor_chance + 25 end
      if R.sy1 <= 2 or R.sy2 >= SEED_H-1 then outdoor_chance = outdoor_chance + 25 end
      if R.children then outdoor_chance = 80 end

      R.outdoor = rand_odds(outdoor_chance)
    end
  end

  if not PLAN.outdoor_combos then
    PLAN.outdoor_combos = {}

    for num = 1,2 do
      local name = rand_key_by_probs(PLAN.theme.ground)
      PLAN.outdoor_combos[num] = assert(GAME.combos[name]) 
    end
  end

  if not PLAN.indoor_combos then
    PLAN.indoor_combos = {}

    for num = 1,3 do
      local name = rand_key_by_probs(PLAN.theme.building)
      PLAN.indoor_combos[num] = assert(GAME.combos[name]) 
    end
  end


  if R.outdoor then
    R.combo = rand_element(PLAN.outdoor_combos)
  else
    R.combo = rand_element(PLAN.indoor_combos)
  end
end

function Room_SetupTheme_Scenic(R)
  -- find closest non-scenic room
  local mx = int((R.sx1 + R.sx2) / 2)
  local my = int((R.sy1 + R.sy2) / 2)

  for dist = -SEED_W,SEED_W do
    if Seed_valid(mx + dist, my, 1) then
      local S = SEEDS[mx + dist][my][1]
      if S.room and S.room.kind ~= "scenic" and
         S.room.combo
---      and (not S.room.outdoor) == (not R.outdoor)
      then
        R.combo = S.room.combo
        R.outdoor = S.room.outdoor
        return
      end
    end

    if Seed_valid(mx, my + dist, 1) then
      local S = SEEDS[mx][my + dist][1]
      if S.room and S.room.kind ~= "scenic" and
         S.room.combo
---      and (not S.room.outdoor) == (not R.outdoor)
      then
        R.combo = S.room.combo
        R.outdoor = S.room.outdoor
        return
      end
    end
  end

  -- fallback
  local name

  if R.outdoor then
    name = rand_key_by_probs(PLAN.theme.ground)
    R.combo = assert(GAME.combos[name])
  else
    R.combo = PLAN.indoor_combos[rand_irange(1,4)]
  end
end


function calc_conn_area(R)
  local lx, ly = 999,999
  local hx, hy = 0,0

  for _,C in ipairs(R.conns) do
    local S = C:seed(R)
    lx = math.min(lx, S.sx)
    ly = math.min(ly, S.sy)
    hx = math.max(hx, S.sx)
    hy = math.max(hy, S.sy)
  end

  assert(lx <= hx and ly <= hy)

  return lx,ly, hx,hy
end


function dump_layout(R)

  local function outside_seed(x, y)
    for dir = 2,8,2 do
      local sx, sy = nudge_coord(x, y, dir)
      if R:valid_T(sx, sy) then
        local T = SEEDS[sx][sy][1]
        if T.conn_dirs and T.conn_dirs[10-dir] then
          return '*'
        end
      end
    end
      
    for _,C in ipairs(R.conns) do
      local S = C:seed(R)
      local ox, oy = nudge_coord(S.sx, S.sy, S.conn_dir)
      if ox == x and oy == y then
        return '+'
      end
    end

    return ' '
  end

  local function inside_seed(x, y)
    local S = SEEDS[x][y][1]
    assert(S and S.room == R)

    if S.layout then
      return S.layout.char
    end

    return '.'
  end


  --| dump_layout |--

  gui.debugf("Room %s @ (%d,%d) Layout:\n", R.kind, R.sx1, R.sy1)

  for y = R.ty2+1, R.ty1-1, -1 do
    line = ""
    for x = R.tx1-1, R.tx2+1 do
      if x < R.tx1 or x > R.tx2 or y < R.ty1 or y > R.ty2 then
        line = line .. outside_seed(x, y)
      else
        line = line .. inside_seed(x, y)
      end
    end
    gui.debugf(" %s\n", line)
  end

  gui.debugf("\n");
end


function Rooms_decide_hallways_II()
  -- Marks certain rooms to be hallways, using the following criteria:
  --   - indoor non-leaf room
  --   - prefer small rooms
  --   - prefer all neighbors are indoor
  --   - no purpose (not a start room, exit room, key room)
  --   - no teleporters
  --   - not the destination of a locked door (anti-climactic)

  local HALL_SIZE_PROBS = { 98, 84, 60, 40, 20, 10 }
  local REVERT_PROBS    = {  0,  0, 25, 75, 90, 98 }

  local function eval_hallway(R)
    -- Wolf3D: the outdoor areas become hallways
    if CAPS.no_sky then
      return (R.outdoor and R.num_branch >= 2)
    end

    if R.outdoor or R.kind == "scenic" then
      return false
    end

    if R.purpose then return false end

    if #R.teleports > 0 then return false end
    if R.num_branch < 2 then return false end
    if R.num_branch > 5 then return false end

    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.outdoor and rand_odds(95) then
        return false
      end

      if C.dest == R and C.lock and rand_odds(50) then
        return false
      end
    end

    local min_d = math.min(R.sw, R.sh)

    if min_d > 6 then return false end

    return rand_odds(HALL_SIZE_PROBS[min_d])
  end

  local function hallway_neighbors(R)
    local hall_nb = 0
    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.kind == "hallway" then hall_nb = hall_nb + 1 end
    end

    return hall_nb
  end

  local function surrounded_by_halls(R)
    local hall_nb = hallway_neighbors(R)
    return (hall_nb == #R.conns) or (hall_nb >= 3)
  end

  local function stairwell_neighbors(R)
    local swell_nb = 0
    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.kind == "stairwell" then swell_nb = swell_nb + 1 end
    end

    return swell_nb
  end

  local function locked_neighbors(R)
    local count = 0
    for _,C in ipairs(R.conns) do
      if C.lock then count = count + 1 end
    end

    return count
  end


  ---| Room_decide_hallways |---
  
  for _,R in ipairs(PLAN.all_rooms) do
    if eval_hallway(R) then
gui.debugf("  Made Hallway @ %s\n", R:tostr())
      R.kind = "hallway"
      R.outdoor = nil
    end
  end

  -- large rooms which are surrounded by hallways are wasted,
  -- hence look for them and revert them back to normal.
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "hallway" and surrounded_by_halls(R) then
      local min_d = math.min(R.sw, R.sh)

      assert(min_d <= 6)

      if rand_odds(REVERT_PROBS[min_d]) then
        R.kind = "indoor"
gui.debugf("Reverted HALLWAY @ %s\n", R:tostr())
      end
    end
  end

  -- decide stairwells
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "hallway" and R.num_branch == 2 and
       stairwell_neighbors(R) == 0 and
       locked_neighbors(R) == 0
    then
      local hall_nb = hallway_neighbors(R) 

      local prob = 70
      if hall_nb >= 2 then prob = 2  end
      if hall_nb == 1 then prob = 30 end

      if rand_odds(prob) then
        R.kind = "stairwell"
      end
    end
  end -- for R

  -- we don't need archways where two hallways connect
  for _,C in ipairs(PLAN.all_conns) do
    if C.src.kind == "hallway" and C.dest.kind == "hallway" then
      local S = C.src_S
      local T = C.dest_S
      local dir = S.conn_dir

      if S.border[S.conn_dir].kind == "arch" or
         T.border[T.conn_dir].kind == "arch"
      then
        S.border[S.conn_dir].kind = nil
        T.border[T.conn_dir].kind = nil
      end
    end
  end -- for C
end


function Room_spot_for_wotsit(R, kind)
  -- FIXME !!!! CRUD
  local sx, sy, S

  repeat
    sx = rand_irange(R.sx1, R.sx2)
    sy = rand_irange(R.sy1, R.sy2)

    S = SEEDS[sx][sy][1]
  until S.room == R and not S.has_wotsit

  S.has_wotsit = true

  return sx, sy, S
end


function Rooms_lay_out_II()

  gui.printf("\n--==| Rooms_lay_out II |==--\n\n")

  PLAN.theme = GAME.themes["TECH"] -- FIXME

  for _,R in ipairs(PLAN.all_rooms) do
    Room_SetupTheme(R)
  end
  for _,R in ipairs(PLAN.scenic_rooms) do
    Room_SetupTheme_Scenic(R)
  end

  Rooms_decide_hallways_II()

  for _,R in ipairs(PLAN.all_rooms) do
--!!!!    Room_LayItOut(R)
  end

end

