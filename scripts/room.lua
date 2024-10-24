------------------------------------------------------------------------
--  ROOM MANAGEMENT
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2006-2017 Andrew Apted
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


--class ROOM
--[[
    is_hallway : bool  -- true for hallways
    is_outdoor : bool  -- true for outdoor rooms

    is_cave    : bool  -- true for caves (indoors)
    is_park    : bool  -- true for parks (outdoors)

    is_natural_park : bool  -- parks with natural walls

    areas = list(AREA)

    seeds = list(SEED)

    sx1, sy1, sx2, sy2  -- \ Seed range
    sw, sh, svolume     -- /

     size_limit   -- \  limits on ergonomic growth
    floor_limit   -- /


    conns : list(CONNS)   -- connections to other rooms

    quest : QUEST

    zone : ZONE

    peer : ROOM     -- links rooms created via symmetry


    goals    : list(GOAL)   -- what goals are here (e.g. keys)
    weapons  : list(NAME)   -- what weapons to place in this room
    items    : list(NAME)   -- what nice items to place
    closet_items : list     -- what items to use in secret closets


    floor_chunks : list(CHUNK)   -- chunks in a walkable area
     ceil_chunks : list(CHUNK)

    closets  : list(CHUNK)
    stairs   : list(CHUNK)
    joiners  : list(CHUNK)
    pieces   : list(CHUNK)  -- for hallways

    triggers : list(TRIGGER)  -- used for traps


    light_level : keyword    -- "bright", "normal", "dark" or "verydark",

    symmetry : SYMMETRY_INFO

    border : AREA

    gx1, gy1, gx2, gy2   -- seed range while growing

    floor_mats[z] : name
     ceil_mats[z] : name

    guard_chunk : CHUNK   -- what a bossy monster is guarding

    aversions : table[name] -> factor

    scenic_fences : table[name] -- specific fence material if this room looks at a vista
--]]


--class SPOT
--[[
    x1, y1, x2, y2, z1, z2   -- coordinate range

    mx, my, mz   -- middle point

    kind : keyword    -- "monster", "item", "big_item",
                      -- FIXME : what else?

    where : keyword   -- "floor", "closet",
                      -- "cage", "trap",

    closet : CLOSET_INFO    -- only present for closets
--]]


--class TRIGGER
--[[
    kind : keyword    -- "edge" or "spot",

    edge   : EDGE     -- place trigger near this edge (of a door/joiner/closet)
    spot   : CHUNK    -- place trigger around this floor chunk (of an item/switch)

    action : number   -- the "special" to use
    tag    : number   -- the tag for the trap-doors
--]]


------------------------------------------------------------------------


ROOM_CLASS = {}

function ROOM_CLASS.new(LEVEL)
  local id = alloc_id(LEVEL, "room")

  local R =
  {
    id = id,
    name = string.format("ROOM_%d", id),

    svolume = 0,
    total_inner_points = 0,
    num_windows = 0,
    need_teleports = 0,

    areas = {},
    seeds = {},
    conns = {},
    internal_conns = {},
    temp_areas = {},

    goals = {},
    teleporters = {},
    weapons = {},
    items = {},
    closet_items = {},

    mon_spots  = {},
    item_spots = {},
    big_spots  = {},
    entry_spots = {},
    important_spots = {},  -- from prefabs

    floor_chunks  = {},
     ceil_chunks  = {},
    liquid_chunks = {},

    closets = {},
    stairs  = {},
    joiners = {},
    pieces  = {},

    cages = {},
    traps = {},
    triggers = {},
    aversions = {},

    used_chunks = 0,  -- includes closets

    floor_mats = {},
     ceil_mats = {},

    floor_groups = {},
     ceil_groups = {},

    solid_ents = {},
    exclusions = {},
    avoid_mons = {},
    locked_fences = {},

    hazard_health = 0,

    scenic_fences = {},
  }

  table.set_class(R, ROOM_CLASS)
  table.insert(LEVEL.rooms, R)
  return R
end


function ROOM_CLASS.add_area(R, A)
  assert(not R.is_dead)

  A.room = R
  A.is_outdoor = R.is_outdoor

  table.insert(R.areas, A)

  R.svolume = R.svolume + A.svolume
  R.total_inner_points = R.total_inner_points + #A.inner_points
end


function ROOM_CLASS.get_env(R)
  if R.is_hallway then return "hallway" end

  if R.is_cave then return "cave" end
  if R.is_park then return "park" end

  if R.is_outdoor then return "outdoor" end

  return "building"
end


function ROOM_CLASS.rough_size(R)
  local count = 0

  for _,A in pairs(R.areas) do
    count = count + #A.seeds
  end

  return count
end


function ROOM_CLASS.num_floors(R)
  local count = 0

  for _,A in pairs(R.areas) do
    if A.mode == "floor" then
      count = count + 1
    end
  end

  return count
end


function ROOM_CLASS.kill_it(R, LEVEL, SEEDS)
  gui.debugf("Killing %s\n", R.name)
  assert(not R.is_dead)

  -- sanity check
  for _,C in pairs(LEVEL.conns) do
    if (C.R1 == R) or (C.R2 == R) then
      error("Killed a connected room!")
    end
  end

  table.kill_elem(LEVEL.rooms, R)

  -- remove from the trunk object
  table.kill_elem(R.trunk.rooms, R)

  for _,A in pairs(R.areas) do
    gui.debugf("   kill %s\n", A.name)
    A:kill_it(LEVEL, nil, SEEDS)
  end

  R.name = "DEAD_" .. R.name
  R.is_dead = true

  R.areas = nil
  R.trunk = nil

  R.sx1   = nil
  R.areas = nil
end


function ROOM_CLASS.try_collect_seed(R, S)
  if not S.area then return end
  if S.area.room ~= R then return end

  S.room = R

  table.insert(R.seeds, S)

  -- update ROOM's bounding box

  R.sx1 = math.min(R.sx1 or  999, S.sx)
  R.sy1 = math.min(R.sy1 or  999, S.sy)
  R.sx2 = math.max(R.sx2 or -999, S.sx)
  R.sy2 = math.max(R.sy2 or -999, S.sy)
end


function ROOM_CLASS.collect_seeds(R, SEEDS)
  for sx = 1, SEED_W do
  for sy = 1, SEED_H do
    local S  = SEEDS[sx][sy]
    local S2 = S.top

    R:try_collect_seed(S)

    if S2 then R:try_collect_seed(S2) end
  end
  end

  if not R.sx1 then
    error("Room with no seeds!")
  end

  R.sw = R.sx2 - R.sx1 + 1
  R.sh = R.sy2 - R.sy1 + 1
end


function ROOM_CLASS.contains_seed(R, x, y)
  if x < R.sx1 or x > R.sx2 then return false end
  if y < R.sy1 or y > R.sy2 then return false end
  return true
end


function ROOM_CLASS.get_bbox(R)
  local S1 = SEEDS[R.sx1][R.sy1]
  local S2 = SEEDS[R.sx2][R.sy2]

  return S1.x1, S1.y1, S2.x2, S2.y2
end


function ROOM_CLASS.has_sky_neighbor(R)
  for _,C in pairs(R.conns) do
    if C.A1.room == C.A2.room then goto continue end
    local N = C:other_room(A)
    if N.is_outdoor and N.mode ~= "void" then return true end
    ::continue::
  end

  return false
end


function ROOM_CLASS.has_vista_neighbor(R) --MSSP
  for _,A in pairs(R.areas) do
    for _,N in pairs(A.neighbors) do
      if N.mode == "scenic" then
        return true
      end
    end
  end

  return false
end


function ROOM_CLASS.has_teleporter(R)
  for _,C in pairs(R.conns) do
    if C.kind == "teleporter" then return true end
  end

  return false
end


function ROOM_CLASS.prelim_conn_num(R, LEVEL)
  local count = 0

  for _,PC in pairs(LEVEL.prelim_conns) do
    if PC.R1 == R or PC.R2 == R then
      count = count + 1
    end
  end

  return count
end


function ROOM_CLASS.calc_walk_vol(R)
  local vol = 0

  for _,A in pairs(R.areas) do
    if (A.mode == "floor" or A.mode == "nature") or
       (A.chunk and A.chunk.kind == "stair")
    then
      A:calc_volume()
      vol = vol + A.svolume
    end
  end

  -- this should not happen
  if vol < 1 then vol = 1 end

  return vol
end


function ROOM_CLASS.total_conns(R, ignore_secrets)
  local count = 0

  for _,C in pairs(R.conns) do
    if ignore_secrets and C.is_secret then
      goto continue
    end

    count = count + 1
    ::continue::
  end

  return count
end


function ROOM_CLASS.is_unused_leaf(R)
  if R.is_hallway then return false end
  if R.is_secret  then return false end
  if R.is_start   then return false end

  if R:total_conns("ignore_secrets") >= 2 then return false end

  if #R.goals   > 0 then return false end
  if #R.weapons > 0 then return false end

  return true
end


function ROOM_CLASS.hallway_other_conn(H, C1)
  -- if hallway only has one other connection, return it,
  -- otherwise return NIL.

  if #H.conns == 2 then
    if H.conns[1] == C1 then return H.conns[2] end
    if H.conns[2] == C1 then return H.conns[1] end
  end

  return nil
end


function ROOM_CLASS.secret_entry_conn(R, skip_room)
  -- find entry connection for a potential secret room.
  -- when skip_room is non-nil, ignore it.

  for _,C in pairs(R.conns) do
    local R2 = C:other_room(R)

    if R2 == skip_room then goto continue end

    if C then return C end
    ::continue::
  end

  error("Cannot find entry conn for secret room")
end


function ROOM_CLASS.add_entry_spot(R, spot)
  table.insert(R.entry_spots, spot)

  if not R.entry_coord then
    local mx = (spot.x1 + spot.x2) / 2
    local my = (spot.y1 + spot.y2) / 2

    R.entry_coord = { x=mx, y=my, z=spot.z1 + 40, angle=spot.angle }
  end
end


function ROOM_CLASS.furthest_dist_from_entry(R)
  if not R.entry_coord then
    -- rough guess
    local S1 = SEEDS[R.sx1][R.sy1]
    local S2 = SEEDS[R.sx2][R.sy2]

    local w = S2.x2 - S1.x1
    local h = S2.y2 - S1.y1

    return math.max(w, h)
  end

  local result = 512

  local ex = R.entry_coord.x
  local ey = R.entry_coord.y

  for sx = R.sx1, R.sx2 do
  for sy = R.sy1, R.sy2 do
    local S = SEEDS[sx][sy]

    if S.room ~= R then goto continue end

    local ox = sel(S.x1 < ex, S.x1, S.x2)
    local oy = sel(S.y1 < ey, S.y1, S.y2)

    local dist = geom.dist(ex, ey, ox, oy)

    result = math.max(result, dist)
    ::continue::
  end
  end

  return result
end


function ROOM_CLASS.usable_chunks(R)
  local num = #R.floor_chunks + #R.closets - R.used_chunks
  if num < 0 then num = 0 end
  return num
end


function ROOM_CLASS.add_solid_ent(R, id, x, y, z)
  -- the "id" can be a name or a number.
  -- for names, we can use the proper size and ignore passable ents.

  local info

  if type(id) ~= "number" then
    info = GAME.ENTITIES[id]
  end

  if not info then
    info = { r=32, h=96 }
  end

  if info.pass then return end

  local SOLID_ENT =
  {
    id = id,

    x = x,
    y = y,
    z = z,

    r = info.r,
    h = info.h
  }

  table.insert(R.solid_ents, SOLID_ENT)
end


function ROOM_CLASS.spots_do_decor(R, floor_h)
  local low_h  = PARAM.spot_low_h
  local high_h = PARAM.spot_high_h

  for _,ent in pairs(R.solid_ents) do
    local z1 = ent.z
    local z2 = ent.z + ent.h

    if z1 >= floor_h + high_h then goto continue end
    if z2 <= floor_h then goto continue end

    local content = SPOT_LEDGE
    if z1 >= floor_h + low_h then content = SPOT_LOW_CEIL end

    local x1, y1 = ent.x - ent.r, ent.y - ent.r
    local x2, y2 = ent.x + ent.r, ent.y + ent.r

    gui.spots_fill_box(x1, y1, x2, y2, content)
    ::continue::
  end
end


function ROOM_CLASS.add_exclusion(R, kind, x1, y1, r, x2, y2)
  -- x2 and y2 are optional
  if x2 == nil then x2 = x1 end
  if y2 == nil then y2 = y1 end

  local area =
  {
    kind = kind,

    x1 = x1 - r,
    y1 = y1 - r,
    x2 = x2 + r,
    y2 = y2 + r
  }

  table.insert(R.exclusions, area)
end


function ROOM_CLASS.clip_spot_list(R, list, x1, y1, x2, y2, strict_mode)
  local new_list = {}

  for _,spot in pairs(list) do
    if (spot.x2 <= x1) or (spot.x1 >= x2) or
       (spot.y2 <= y1) or (spot.y1 >= y2)
    then
      -- unclipped

    elseif strict_mode then
      -- drop this spot
      goto continue

    else
      local w1 = x1 - spot.x1
      local w2 = spot.x2 - x2

      local h1 = y1 - spot.y1
      local h2 = spot.y2 - y2

      -- totally clipped?
      if math.max(w1, w2, h1, h2) < 8 then
        goto continue
      end

      -- shrink the existing box (keep side with most free space)

      if w1 >= math.max(w2, h1, h2) then
        spot.x2 = spot.x1 + w1
      elseif w2 >= math.max(w1, h1, h2) then
        spot.x1 = spot.x2 - w2
      elseif h1 >= math.max(w1, w2, h2) then
        spot.y2 = spot.y1 + h1
      else
        spot.y1 = spot.y2 - h2
      end

      assert(spot.x2 > spot.x1)
      assert(spot.y2 > spot.y1)
    end

    table.insert(new_list, spot)
    ::continue::
  end

  return new_list
end


function ROOM_CLASS.clip_spots(R, x1, y1, x2, y2)
  -- the given rectangle is where we _cannot_ have a spot

  assert(x1 < x2)
  assert(y1 < y2)

  -- enlarge the area a bit
  x1, y1 = x1 - 4, y1 - 4
  x2, y2 = x2 + 4, y2 + 4

  R.mon_spots  = R:clip_spot_list(R.mon_spots,  x1, y1, x2, y2)

---??  R.item_spots = R:clip_spot_list(R.item_spots, x1, y1, x2, y2)
---??  R.big_spots  = R:clip_spot_list(R.big_spots,  x1, y1, x2, y2, "strict")
end


function ROOM_CLASS.exclude_monsters(R)
  for _,box in pairs(R.exclusions) do
    if box.kind == "keep_empty" then
      R:clip_spots(box.x1, box.y1, box.x2, box.y2)
    end
  end
end


function ROOM_CLASS.usable_delta_h(R, from_h, h)
  if not rand.odds(R.delta_up_chance) then
    h = - h
  end

  if R.delta_limit_mode == "positive" then
    if from_h + h <= 0 then h = - h end
  else
    if from_h + h >= 0 then h = - h end
  end

  return from_h + h
end


function ROOM_CLASS.pick_direct_delta_h(R, from_h, A1, A2)
  if STYLE.steepness == "none" then
    return from_h
  end

  -- only change height if floor_groups are different
  if A1.floor_group and A1.floor_group == A2.floor_group then
    return from_h
  end

  local h = 8

  return R:usable_delta_h(from_h, h)
end


function ROOM_CLASS.pick_stair_delta_h(R, from_h, chunk)
  local h = chunk.prefab_def.delta_h
  assert(h)

  return R:usable_delta_h(from_h, h)
end


function ROOM_CLASS.get_highest_ceiling(R) --MSSP
  local h = -EXTREME_H
  for _,A in pairs(R.areas) do
    if A.ceil_h then
      if A.ceil_h > h then
        h = A.ceil_h
      end
    end
  end

  return h
end

------------------------------------------------------------------------


function Room_prepare_skies(LEVEL)
  --
  -- Each zone gets a rough sky height (dist from floors).
  -- The final sky height of each zone is determined later.
  --

  local function new_sky_add_h()
    if rand.odds(2)  then return 256 end
    if rand.odds(10) then return 192 end

    return 144
  end


  ---| Room_prepare_skies |---

  for _,Z in pairs(LEVEL.zones) do
    Z.sky_add_h = new_sky_add_h()
  end
end



function Room_reckon_door_tex(LEVEL)

  local function visit_conn(C, E1, E2)
    if E1 == nil then return end
    assert(E2)

    local A1 = assert(E1.area)
    local A2 = assert(E2.area)

    for pass = 1,2 do
      E1.wall_mat = Junction_calc_wall_tex(A1, A2)

      A1, A2 = A2, A1
      E1, E2 = E2, E1
    end
  end


  ---| Room_reckon_door_tex |---

  for _,C in pairs(LEVEL.conns) do
    if C.kind == "edge" then
      visit_conn(C, C.E1, C.E2)
      visit_conn(C, C.F1, C.F2)
    end
  end
end



function Room_pick_joiner_prefab(LEVEL, C, chunk)
  -- Note: this also used for hallway terminators

  assert(chunk)

  local reqs = chunk:base_reqs(chunk.from_dir)
  local none_ok = "not_ok"

  reqs.kind  = C.kind
  reqs.shape = assert(chunk.shape)

  if C.kind == "joiner" then
    local A1 = chunk.from_area
    local A2 = chunk.dest_area

    reqs.env      = A1.room:get_env()
    reqs.neighbor = A2.room:get_env()

    if A1.floor_group and A1.floor_group.wall_group then
      reqs.group = assert(A1.floor_group.wall_group)
    end
    -- group string from the destination area is prioritized
    if A2.floor_group and A2.floor_group.wall_group then
      reqs.group = assert(A2.floor_group.wall_group)
    end

  elseif C.kind == "terminator" then
    reqs.group = assert(chunk.area.room.hall_group)
  end

  C:get_lock_reqs(reqs)

  if C.kind == "terminator" then
    none_ok = nil

    -- if it ends up here, something's wrong with growth
    if reqs.shape == "N" then reqs.shape = "I" end
  end

  chunk.prefab_def = Fab_pick(LEVEL, reqs, none_ok)
  if not chunk.prefab_def then
    reqs.group = nil
    chunk.prefab_def = Fab_pick(LEVEL, reqs)
  end

  -- should we flip the joiner?
  -- [ hallway terminators are already ok, done in Connect_directly ]
  -- [[ only straight pieces can be flipped ]]

  if C.kind == "joiner" and chunk.shape == "I" then
    local flip_it

    -- we generally want the joiner to face the earlier room
    -- (i.e. travel direction is toward the later room).
    -- this is critical for some locked types of joiners.
    if C.R1.lev_along > C.R2.lev_along then
      flip_it = true
    end

    if chunk.prefab_def.can_flip and rand.odds(50) then
      flip_it = not flip_it
    end

    -- this is needed when the environment on each side is important,
    -- such as the joiner connecting a normal room to a cave.
    if chunk.prefab_def.force_flip ~= nil then
      flip_it = chunk.prefab_def.force_flip
    end

    if flip_it then
      -- this reverses from_dir and dest_dir, and adjusts the
      -- from_area and dest_area fields accordingly.
      chunk:flip()
    end
  end
end



function Room_pick_edge_prefab(LEVEL, C)

  local function make_fence(E)
    E.kind = "fence"
    E.fence_mat = assert(E.area.zone.fence_mat)

    -- fence_top_z computed later...
    table.insert(E.area.room.locked_fences, E)
  end


  -- hack for unfinished games
  if THEME.no_doors then return end


  local  indoor_prob = style_sel("doors", 0, 15, 35,  65)
  local outdoor_prob = style_sel("doors", 0, 70, 90, 100)

  local E = C.E1

  if E.kind ~= "doorway" then
    E = C.E2
  end

  assert(E.kind == "doorway")


  -- get orientation right, "front" of prefab faces earlier room

  local R1 = C.R1
  local R2 = C.R2

  if R1 ~= E.area.room then
    R1, R2 = R2, R1
  end

  if R1.lev_along > R2.lev_along then
    E.flip_it = true
  end


  -- requirements for the prefab

  local reqs =
  {
    kind = "arch",

    seed_w = assert(E.long)
  }

  local goal

  if geom.is_corner(E.dir) then
    reqs.where = "diagonal"
    reqs.seed_h = reqs.seed_w
  else
    reqs.where = "edge"
  end

  reqs.env      = R1:get_env()
  reqs.neighbor = R2:get_env()


  -- locked door?
  C:get_lock_reqs(reqs)

  if C.lock then
    reqs.kind = "door"

    goal = C.lock.goals[1]

    E.door_tag = goal.tag

    C.is_door = true
    C.fresh_floor = true

    -- use lowering bars between outdoor rooms (usually)
    if R1.is_outdoor and R2.is_outdoor and
       goal.kind == "LOCAL_SWITCH" and
       rand.odds(80+20)
    then
      reqs.kind = "fence"

      make_fence(E)
    end

  -- secret door ?
  elseif C.is_secret then
    reqs.kind = "door"

    C.is_door = true

    if R1.is_outdoor and R2.is_outdoor then
      reqs.kind = "fence"

      make_fence(E)
    end

  else
    -- make a normal door?
    local prob = indoor_prob

    if R1.is_outdoor or R2.is_outdoor then
      prob = outdoor_prob
    end

    if rand.odds(prob) then
      -- TODO : reqs.kind = "door",

      C.is_door = true
    end
  end


  -- Ok, select it --

  E.prefab_def = Fab_pick(LEVEL, reqs)

  if goal then
    goal.action = E.prefab_def.door_action
  end
end



function Room_reckon_doors(LEVEL)
  for _,C in pairs(LEVEL.conns) do
    if C.kind == "edge" then
      Room_pick_edge_prefab(LEVEL, C)

    elseif C.kind == "joiner" then
      Room_pick_joiner_prefab(LEVEL, C, C.joiner_chunk)
    end
  end
end



function Room_detect_porches(LEVEL, R)
  --
  -- A "porch" is typically an area of an outdoor room that neighbors a
  -- building and will be given a solid low ceiling and some pillars to
  -- hold it up, and a floor higher than any nearby areas of the room.
  --
  -- It can also be used indoors (what previous code called a "periph").
  --
  -- Another use case is an outdoor hallway which is mostly surrounded
  -- by outdoor areas, and is higher than those areas.
  --

  local best_A
  local best_score


  local function set_as_porch(A)
    A.is_porch = true

    if A.peer then -- apply porchness to symmetry too, of course
      A.peer.is_porch = true
    end

    -- Note : keeping 'is_outdoor' on the area

    -- MSSP: Overriden because junction code seems to
    -- skip out on room->scenics interactions...
    A.is_outdoor = false

    if not A.room.porch_fence_type then
      A.room.porch_fence_type = rand.key_by_probs(
        {
          fence = 5,
          railing = 3,
          wall = 5,
        }
      )
    end
  end


  local function detect_hallway_porch()
    -- keep it simple, ignore merged hallways
    if #R.areas > 1 then return false end

    local HA = R.areas[1]

    for _,edge in pairs(HA.edge_loops[1]) do
      local N = edge.S:neighbor(edge.dir, nil, SEEDS)

      if not (N and N.area) then return false end

      local A2 = N.area

      if A2.mode == "scenic" then
        -- ok
        goto continue
      end

      local R2 = A2.room
      assert(R2 ~= R)

      if not R2 then
        -- no void, thanks
        return false
      end

      -- same zone?
      if R2.zone ~= R.zone then
        -- ok
        goto continue
      end

      -- TODO : if hallway is large, allow a few edges
      if not R2.is_outdoor then
         return false
      end

      -- floor check
      if HA.floor_h + 64 < (A2.floor_h or 0) then
        return false
      end
      ::continue::
    end

    gui.debugf("Hallway %s is now a PORCH\n", R.name)

    set_as_porch(HA)

    return true
  end


  local function eval_porch(A, mode)
    -- mode is either "indoor" or "outdoor",

    if A.room.floor_areas <= 1 then return -1 end

    if A.mode ~= "floor" then return -1 end

    -- single outdoor room? weird for it to be a porch --MSSP
    if #A.room.areas < 2 then return -1 end

    -- size check : never too much of room
    if A.svolume > R.svolume / 2 then return -1 end

    -- shape check : we want high twistiness, low openness
    if A.openness > 0.4 then return -1 end

    -- should not be surrounded by another area
    -- if #A.neighbors < 2 then return -1 end
    -- but... GAZEBOS! -MSSP

    -- FIXME.....

    local score = 100 + A.svolume - A.openness * 100

    -- tie break
    return score + gui.random()
  end


  local function detect_normal_porch(mode)
    -- Andrew: only one per room, so pick best
    -- MSSP: new behavior. Multiple porches per room, limited
    -- by the amount of areas within the room. (no more than half
    -- the room should be porched at least)
    local porchables = {}

    R.floor_areas = 0
    for _,A in pairs(R.areas) do

      if A.mode == "floor" then
        R.floor_areas = R.floor_areas + 1
      end

      A.porch_score = eval_porch(A, "indoor")
      if A.porch_score > 0 then
        table.insert(porchables, A)
      end
    end

    table.sort(porchables,
    function(A, B) return A.porch_score > B.porch_score end)

    R.porch_count = 0
    for _,A in pairs(porchables) do

      if R.porch_count > math.floor(R.floor_areas/3) then return end

      local porch_prob = style_sel("porches", 0, 25, 50, 75)
      porch_prob = porch_prob / (LEVEL.autodetail_group_walls_factor / 2)

      if A.porch_score > 0 and rand.odds(porch_prob) then
        set_as_porch(A)

        gui.debugf("Made %s into a PORCH\n", A.name)
        R.porch_count = R.porch_count + 1
      end

    end
  end


  ---| Room_detect_porches |---

  if R.is_hallway then
    detect_hallway_porch()

  elseif R.is_outdoor then
    detect_normal_porch("outdoor")

  else
    detect_normal_porch("indoor")
  end
end



function Room_make_windows(LEVEL, A1, A2, SEEDS)

  local edge_list = {}
  local total_len = 0

  local WINDOW_PATTERNS =
  {
    "1", "2", "3", "22", "2-2", "33", "3-3",
  }

  if rand.odds(50) then
    WINDOW_PATTERNS[6] = "222"
  end


  local function area_can_window(A)
    if not A.room then return false end
    if not A.floor_h then return false end

    -- disable windows into caves [ for now... ]
    if A.room and A.room.is_cave then return false end

    if A.mode == "void" then return false end

    if A.mode == "scenic" then return false end

    if A.chunk and (A.chunk.kind ~= "floor" 
    or A.chunk.kind ~= "stair") then return false end

    if A.room.is_hallway then return false end

    return true
  end


  local function decide_window_group()
    local R1 = A1.room
    local R2 = A2.room

    local group1 = A1.zone.window_group
    local group2 = A2.zone.window_group

    if R1.is_exit and LEVEL.exit_windows then
      group1 = LEVEL.exit_windows
      group2 = LEVEL.exit_windows
    end

    if group1 == nil then return group2 end
    if group2 == nil then return group1 end

    if not R2 then
      return group1
    end

    if R1.zone.along <= R2.zone.along then
      return group1
    else
      return group2
    end
  end


  local function calc_vertical_space(A1, A2)
    local c1 = A1.ceil_h
    local c2 = A2.ceil_h

    if not c1 or not c2 then return -77,-99 end

    -- TODO : handle "nature" areas better (checks cells along the junction)
    local f1 = A1.max_floor_h or A1.floor_h
    local f2 = A2.max_floor_h or A2.floor_h

    if A1.room and A1.room.is_park then
      f1 = A1.room.max_floor_h
    end
    if A2.room and A2.room.is_park then
      f2 = A2.room.max_floor_h
    end

    local max_f = math.max(f1, f2)
    local min_c = math.min(c1, c2)

    if A1.chunk and A1.chunk.kind == "stair" then
      max_f = math.max(A1.from_area.floor_h, A1.dest_area.floor_h, max_f)
    end
    if A2.chunk and A2.chunk.kind == "stair" then
      max_f = math.max(A2.from_area.floor_h, A2.dest_area.floor_h, max_f)
    end

    return max_f, (min_c - max_f)
  end


  local function is_possible_at_seed(S, dir)
    if not S then return false end

    if S.area ~= A1 then return false end

    local N = S:neighbor(dir, nil, SEEDS)

    if not N then return false end

    if N.area ~= A2 then return false end

    -- already have edges here?
    if S.edge[dir]    then return false end
    if N.edge[10-dir] then return false end

    return true
  end


  local function kill_seed(S, seed_list)
    for k = 1, #seed_list do
      if seed_list[k] == S then
         seed_list[k] = "DEAD"
      end
    end
  end


  local function add_piece(S, dir, long)
    local E = { S=S, dir=dir, long=long }

--stderrf("  %s dir:%d long:%d\n", E.S.name, dir, long)

    table.insert(edge_list, E)

    total_len = total_len + long
  end


  local function check_for_edge(S, dir, seed_list)
    if not is_possible_at_seed(S, dir) then return end

    -- determine maximum length of window, and update 'S' to be
    -- the left-most seed of that run.

    local L_dir = geom.LEFT [dir]
    local R_dir = geom.RIGHT[dir]

    local LS = S
    local RS = S

    local long = 1

    for pass = 1, 9 do
      RS = RS:neighbor(R_dir, nil, SEEDS)

      if not is_possible_at_seed(RS, dir) then
        break;
      end

      long = long + 1

      kill_seed(RS, seed_list)
    end

    for pass = 1, 9 do
      LS = LS:neighbor(L_dir, nil, SEEDS)

      if not is_possible_at_seed(LS, dir) then
        break;
      end

      S = LS
      long = long + 1

      kill_seed(LS, seed_list)
    end

    -- limit width of window
    -- [ currently windows this wide *never* occur ]
    while long >= 9 do
      S = S:neighbor(R_dir, nil, SEEDS)
      long = long - 2
    end

    if long >= 8 then
      long = 7
    end

    -- divide really wide windows into smaller ones

    local pattern = assert(WINDOW_PATTERNS[long])

    for i = 1, #pattern do
      local ch = string.sub(pattern, i, i)

      if ch == '-' then
        S = S:neighbor(R_dir, nil, SEEDS)
        goto continue
      end

      local want_len = 0 + ch
      assert(want_len > 0)

      add_piece(S, dir, want_len)

      for i = 1, want_len do
        S = S:neighbor(R_dir, nil, SEEDS)
      end
      ::continue::
    end
  end


  local function find_window_edges()
-- stderrf("Window edges %s --> %s\n", A1.name, A2.name)

    for dir = 2,8,2 do
      local seed_list = table.copy(A1.seeds)

      for i = 1, #seed_list do
        local S = seed_list[i]

        if S ~= "DEAD" then
          check_for_edge(S, dir, seed_list)
        end
      end
    end

    return edge_list, total_len
  end


  local function install_windows(group, z, height, base_prob)
    for _,E in pairs(edge_list) do
      -- wide windows occur quite rarely, so bump up their chance
      local prob = base_prob
      if E.long >= 2 then
        prob = math.min((prob + 100) / 2, prob * 2.5)
      end

      if (A1.room and A1.room.force_windows) or
         (A2.room and A2.room.force_windows) or
         rand.odds(prob)
      then
        local E1, E2 = Edge_new_pair("window", "nothing", E.S, E.dir, E.long, LEVEL, SEEDS)

        E1.window_z = z
        E1.window_group  = group
        E1.window_height = height

        E1.wall_mat = Junction_calc_wall_tex(A1, A2)
        E2.wall_mat = Junction_calc_wall_tex(A2, A1)
      end
    end
  end


  ---| Room_make_windows |---

  if not area_can_window(A1) then return end

  if A2.mode ~= "scenic" then
    if not area_can_window(A2) then return end
  end

  -- dummy height for scenic areas are set here so z_fit windows
  --[[ can actually go from floor to ceiling among these junctions
  if A2.mode == "scenic" then
    if not A2.floor_h then
      A2.floor_h = A2:lowest_neighbor().floor_h
    end
  end]]

  -- remove windows into quiet start rooms... but not on procedural gotchas
  if PARAM.bool_quiet_start == 1 and not LEVEL.is_procedural_gotcha then
    if A1.room and A1.room.is_start then
      if A2.room then return end
    end

    if A2.room and A2.room.is_start then
      if A1.room then return end
    end
  end

  if A1.border_type == "simple_fence" or A2.border_type == "simple_fence" then return end
  if A1.border_type == "no_vista" or A2.border_type == "no_vista" then return end

  local z, height = calc_vertical_space(A1, A2)

  if height < 128 then return end

  -- if theme has no window groups, we cannot make any windows
  local group = decide_window_group()
  if not group then return end

  find_window_edges()

  -- check style
  local prob = style_sel("windows", 0, 35, 70, 140)

  -- less chance between indoor rooms
  if (not A1.is_outdoor and not A2.is_outdoor) then
    prob = prob * 0.7
  end

  -- much less chance between zones
  if A1.zone ~= A2.zone then
    prob = prob * 0.3
  end

  -- what the heck is a porch that doesn't
  -- have windows? -MSSP
  if A1.is_porch or A2.is_porch then
    prob = 140
  end

  install_windows(group, z, height, prob)
end



function Room_border_up(LEVEL, SEEDS)
  --
  -- Decide the default bordering between any two adjacent areas.
  -- This default can be overridden by EDGE objects, e.g. for doors.
  -- Also some code has already set up the junctions [ TODO : list them ].
  --

  local omit_fence_prob = rand.pick({ 10,50,90 })


  local function can_omit_fence(A1, A2)
    -- TODO : support mode == "nature",
    if not (A1.mode == "floor" and A1.room) then return false end
    if not (A2.mode == "floor" and A2.room) then return false end

    -- start rooms need protection from monsters in neighbor rooms
    if (A1.room and A1.room.is_start) or (A2.room and A2.room.is_start) then
      if rand.odds(80) then return false end
    end

    -- never fall down into a secret
    if A1.room.is_secret or A2.room.is_secret then
      return false
    end

    if A1.room.lev_along > A2.room.lev_along then
      return A1.floor_h > A2.floor_h + 78
    else
      return A2.floor_h > A1.floor_h + 78
    end
  end


  local function can_beam(A1, A2, junction)
    if not A1.room or not A2.room then
      return false
    end

    -- stop beams from going up in an area the same sky sinks because it looks silly
    if A1.ceil_group and A2.ceil_group then
      if A1.ceil_group == A2.ceil_group then
        if A1.ceil_group.sink and A1.ceil_group.sink.mat == "_SKY" then
          return false
        end
      end
    end

    -- no beams on an edge length of only 1
    if junction.perimeter == 1 then
      return false
    end

    if A1.dead_end and A2.dead_end then return false end

    -- beams can be between floors and liquids
    if (A1.mode == "floor" or A1.mode == "liquid") and
        (A2.mode == "floor" or A2.mode == "liquid") then
      return true
    end

    return false
  end


  local function can_fence(A1, A2)
    if A1.chunk and A1.chunk.kind == "stair"
    and (A1.chunk.dest_area == A2 or A1.chunk.from_area == A2) then
      return false
    end

    if A2.chunk and A2.chunk.kind == "stair"
    and (A2.chunk.dest_area == A1 or A2.chunk.from_area == A1) then
      return false
    end

    if A1.mode == "liquid" or A2.mode == "liquid"
    or A1.mode == "cage" or A2.mode == "cage" then
      return false
    end

    return true
  end


  local function rail_or_fence(A1, A2)
    if A1.fence_up_type
    and A2.fence_up_type then

      if A1.fence_up_type == A2.fence_up_type then
        return A1.fence_up_type
      end

      if A1.fence_up_type ~= A2.fence_up_type then
        if A1.floor_h > A2.floor_h then
          return A1.fence_up_type
        else
          return A2.fence_up_type
        end
      end
    end

    if A1.fence_up_type and not A2.fence_up_type then
      return A1.fence_up_type
    else
      return A2.fence_up_type
    end

    return nil
  end


  local function can_porch_wall(A1, A2)
    if (A1.mode == "floor" and A2.mode ~= "floor")
    or (A1.mode ~= "floor" and A2.mode == "floor") then
      return false
    end

    return true
  end


  local function can_indoor_fence(A1, A2)
    if not A1.room or not A2.room then
      return false
    end

    if A1.floor_h == A2.floor_h then
      return false
    end

    if A1.room and A2.room then
      if A1.mode == "floor" and A2.mode == "floor" then
        return true
      end
    end

    return false
  end


  local function visit_junction(junc)
    local A1 = junc.A1
    local A2 = junc.A2

    assert(A1 ~= A2)


    -- already decided?
    if junc.E1 then return end


    -- handle edge of map
    -- [ normal rooms should not touch the edge ]

    if A2 == "map_edge" then
      if A1.map_edge_type == "edge" then
        Junction_make_map_edge(junc)
      elseif A1.map_edge_type == "wall" then
        Junction_make_wall(junc)
      end
      return
    end


    -- zones : gotta keep 'em separated

    if A1.zone ~= A2.zone then
      Room_make_windows(LEVEL, A1, A2, SEEDS)
      Junction_make_wall(junc)
      return
    end


    -- void --

    if A1.mode == "void" and A2.mode == "void" then
      Junction_make_empty(junc)
      return
    end


    -- room to void / vice versa --

    if A1.mode ~= "void" and A2.mode == "void" then
      Junction_make_wall(junc)
      return
    elseif A2.mode ~= "void" and A1.mode == "void" then
      Junction_make_wall(junc)
      return
    end


    -- void to scenic / vice versa --

    if A1.mode == "void" and A2.mode == "scenic" then
      Junction_make_wall(junc)
      return
    elseif A2.mode == "void" and A1.mode == "scenic" then
      Junction_make_wall(junc)
      return
    end


    -- closets --

    if (A1.mode == "chunk" and A1.chunk.occupy == "whole") or
       (A2.mode == "chunk" and A2.chunk.occupy == "whole")
    then
      Junction_make_wall(junc)
      return
    end


    -- scenic to scenic --

    if A2.room and not A1.room then
      A1, A2 = A2, A1
    end

    if not A1.room then
      -- nothing needed when both are building/cave
      if A1.is_outdoor or A2.is_outdoor then
        Cave_join_scenic_borders(junc)
      end

      return
    end


    -- scenic to room --

    if not A1.room and A2.room then
      if A1.border_type == "simple_fence" or A1.border_type == "no_vista"
      or A1.border_type == nil then
        Junction_make_wall(junc)
      end
    end


    -- room to scenic --

    if not A2.room then
      if A1.room.border ~= A2 or A2.border_type == "no_vista" then
        Junction_make_wall(junc)

      elseif not A1.is_outdoor and not A1.is_cave then
        if A2.border_type ~= "simple_fence"
        or A1.border_type ~= "no_vista"
        or A2.border_type == nil then
          Room_make_windows(LEVEL, A1, A2, SEEDS)
        end
        Junction_make_wall(junc)

      elseif A1.is_outdoor then
        if A2.border_type ~= "no_vista" then
          if A2.fence_type == "fence" then
            Junction_make_fence(junc)
          elseif A2.fence_type == "railing" then
            Junction_make_railing(LEVEL, junc, "FENCE_MAT_FROM_THEME", "block")
          elseif A2.fence_type == "wall" then
            Room_make_windows(LEVEL, A1, A2, SEEDS)
            Junction_make_wall(junc)
          end
        end

      else
        Junction_make_empty(junc)

      end

      return
    end


    -- the same room / room to room --

    if A1.room == A2.room then

      -- cages --
      -- just minor fixes

      if A1.mode == "cage" and A2.mode == "cage"
      and ((not A1.cage_mode and A2.cage_mode)
      or (A1.cage_mode and not A2.cage_mode)) then
        Junction_make_railing(LEVEL, junc, "FENCE_MAT_FROM_THEME", "block")
      end

      -- walls on areas where ceilings and floors meet --

      if not (A1.is_outdoor and A2.is_outdoor) then
        if (A1.floor_h > A2.ceil_h)
        or (A2.floor_h > A1.ceil_h) then
          Junction_make_wall(junc)
        end
      end

      -- beams --

      if not A1.is_outdoor and not A2.is_outdoor then
        local beam_prob = style_sel("beams",0,10,20,30)
          / (LEVEL.autodetail_group_walls_factor/3)
        if can_beam(A1, A2, junc) and rand.odds(beam_prob) then
          Junction_make_beams(junc)
        end
      end

      -- fences --

      if A1.is_outdoor and A2.is_outdoor then
        if (A1.floor_h ~= A2.floor_h)
        and (A1.fence_up or A2.fence_up) then
          if can_fence(A1, A2) then
            local fence_up_type = rail_or_fence(A1, A2)
            if fence_up_type == "fence" then
              Junction_make_fence(junc)
            elseif fence_up_type == "rail" then
              Junction_make_railing(LEVEL, junc, "FENCE_MAT_FROM_THEME", "block")
            end
          end
        end
      end

      -- porch neighbors --

      if A1.is_porch_neighbor or A2.is_porch_neighbor then
        if (A1.mode == "floor" and A2.mode == "liquid")
        or (A1.mode == "liquid" and A2.mode == "floor")
        and A1.room.is_outdoor then
          if A1.is_porch or A2.is_porch then
            Junction_make_empty(junc)
            return
          elseif not A1.is_porch or not A2.is_porch then
            Junction_make_beams(junc)
            return
          end
        end
      end

      -- porches --

      if (A1.is_porch and not A2.is_porch)
      or (not A1.is_porch and A2.is_porch) then

        if (A1.dead_end or A2.dead_end) then
          if A1.room and A1.room:get_env() == "building"
          or A2.room and A2.room:get_env() == "building" then
            Junction_make_empty(junc)
            return
          end
        end

        if A1.mode == "cage" or A2.mode == "cage" then
          if A1.cage_mode == "fancy" or A2.cage_mode == "fancy" then
            Junction_make_railing(LEVEL, junc, "FENCE_MAT_FROM_THEME", "block")
          else
            Junction_make_empty(junc)
          end
          return
        end

        if (A1.floor_h == A2.floor_h)
        or A1.mode == "liquid" or A2.mode == "liquid" then
          if can_beam(A1, A2, junc) then
            if A1.room.is_outdoor and rand.odds(style_sel("beams",0,25,50,75)) then
              Junction_make_beams(junc)
            end
          end
          return
        else
          if A1.is_outdoor then
            Room_make_windows(LEVEL, A1, A2, SEEDS)
            if can_porch_wall(A1, A2) then
              Junction_make_wall(junc)
            end
          elseif not A1.is_outdoor then
            if can_porch_wall(A1, A2) then
              if A1.room.porch_fence_type == "fence" then
                Junction_make_fence(junc)
              elseif A1.room.porch_fence_type == "railing" then
                Junction_make_railing(LEVEL, junc, "FENCE_MAT_FROM_THEME", "block")
              elseif A1.room.porch_fence_type == "wall" then
                Room_make_windows(LEVEL, A1, A2, SEEDS)
                Junction_make_wall(junc)
              end
            end
          end
        end
      end

      return
    end

    -- porch neighbors --

    if A1.is_porch_neighbor or A2.is_porch_neighbor then
      if ((A1.mode == "liquid" and A2.mode == "floor")
      or (A1.mode == "floor" and A2.mode == "liquid"))
      and A1.room == A2.room 
      and rand.odds(style_sel("beams",0,25,50,75)) then
        Junction_make_beams(junc)
      end

      if A1.mode == "cage" or A2.mode == "cage"
      and A1.room == A2.room then
        Junction_make_railing(LEVEL, junc, "FENCE_MAT_FROM_THEME", "block")
      end

      if A1.room ~= A2.room then
        Room_make_windows(LEVEL, A1, A2, SEEDS)
        Junction_make_wall(junc)
      end
      return
    end

    -- fences --

    if A1.is_outdoor and A2.is_outdoor then
      -- occasionally omit it when big height difference
      -- MSSP: New behavior, make a railing instead
      if can_omit_fence(A1, A2) and rand.odds(omit_fence_prob) then
        Junction_make_railing(LEVEL, junc, "FENCE_MAT_FROM_THEME", "block")
      else
        Junction_make_fence(junc)
      end

      return
    end


    -- windows --

    Room_make_windows(LEVEL, A1, A2, SEEDS)


    -- when in doubt, block it out!

    Junction_make_wall(junc)
  end


  local function assign_window_groups()
    if not THEME.window_groups then return end

    local tab = table.copy(THEME.window_groups)

    for _,Z in pairs(LEVEL.zones) do
      Z.window_group = rand.key_by_probs(tab)

      tab[Z.window_group] = tab[Z.window_group] / 2
    end
  end


  local function decide_window_boosts()
    for _,R in pairs(LEVEL.rooms) do
      if R.is_outdoor then goto continue end
      if R.is_cave    then goto continue end

      local prob = style_sel("windows", 0, 2, 5, 8)
      if R.is_secret then prob = prob * 2 end
      if R.symmetry  then prob = prob * 2 end

      if rand.odds(prob) then
        R.force_windows = true
      end
      ::continue::
    end
  end

  local function assign_beam_density()
    for _,R in pairs(LEVEL.rooms) do
      if rand.odds(75) then
        if rand.odds(50) then
          R.beam_density = "sparse-even"
        else
          R.beam_density = "sparse-odd"
        end
      else
        R.beam_density = "dense"
      end
    end
  end

  local function decide_fenced_rooms()

    local function can_have_fences(A)
      if not A.room then return false end

      if not A.room.is_outdoor then return false end

      if A.is_porch then return false end

      if A.mode == "floor" then
        local fence_prob = style_sel("fences",0,30,60,90) / (LEVEL.autodetail_group_walls_factor / 2)
        if rand.odds(fence_prob) then
          return true
        end
      end

      return false
    end



    for _,A in pairs(LEVEL.areas) do
      if can_have_fences(A) then
        A.fence_up = true

        if rand.odds(50) then
          A.fence_up_type = "fence"
        else
          A.fence_up_type = "rail"
        end
      end
    end

    -- second pass, adopt some empty neighbors of the same height
    -- and give them the the same fency type too
    for _,A in pairs(LEVEL.areas) do
      if A.fence_up then
        for _,N in pairs(LEVEL.areas) do
          if N.room then
            if A.floor_h == N.floor_h
            and A.room == N.room
            and N.mode == "floor"
            and not N.fence_up then
              N.fence_up = true
              N.fence_up_type = A.fence_up_type
            end
          end
        end
      end
    end

  end


  local function check_sky_closets()
    for _,A in pairs(LEVEL.areas) do
      if A.mode ~= "chunk" then goto continue end

      if not A.room then goto continue end
      if not A.room.is_outdoor then goto continue end
      if A.room.border_type == "no_vista" then goto continue end

      local T = A.chunk
      if T.kind ~= "closet" then goto continue end

      if T:is_open_to_sky(A.room, SEEDS) then
        T.open_to_sky = true
      end
      ::continue::
    end
  end


  ---| Room_border_up |---

  assign_window_groups()
  decide_window_boosts()

  decide_fenced_rooms()

  assign_beam_density()

  check_sky_closets()

  for _,junc in pairs(LEVEL.junctions) do
    if junc.E1 == nil then
      visit_junction(junc)
    end
  end
end


------------------------------------------------------------------------


function Room_set_kind(R, is_hallway, is_outdoor, is_cave, LEVEL)
  R.is_hallway = is_hallway
  R.is_outdoor = is_outdoor
  R.is_cave    = is_cave

  if is_hallway then
    R.name = string.format("HALLWAY_%d", R.id)
  end

  -- determine if outdoor room should be a park
  -- TODO : exit room cannot be a park, remove that restriction
  if is_outdoor and not (is_hallway or is_cave or R.is_street) and
     R.id ~= 1
  then
    local park_prob = style_sel("parks", 0, 22, 45, 90)
    if LEVEL.is_nature then park_prob = 100 end

    if rand.odds(park_prob) then
      R.is_park = true
    end
  end

  if R.is_park then
    local nature_park_prob = style_sel("natural_parks", 0, 33, 66, 90)
    if LEVEL.is_nature then
      nature_park_prob = math.clamp(50, nature_park_prob * 2, 100)
    end

    if rand.odds(nature_park_prob) then
      R.is_natural_park = true
      for _,A in pairs(R.areas) do
        A.is_natural_park = true
      end
    end
  end

  if LEVEL.is_nature and not R.is_outdoor and not is_hallway then
    R.is_cave = true
  end

  for _,A in pairs(R.areas) do
    A.is_outdoor = R.is_outdoor
  end
end



function Room_choose_kind(R, last_R, LEVEL)
  -- these outdoor probs carefully chosen so that:
  --    few   is about 15%
  --    some  is about 35%
  --    heaps is about 75%
  -- MSSP: attempting new numbers
  local out_prob

  if not last_R then -- chances for first room or trunk(?)
    out_prob = style_sel("outdoors", 0, 30, 60, 100)
  elseif last_R.is_outdoor then -- chance if previous room was outdoor
    out_prob = style_sel("outdoors", 0, 15, 35, 80)
  else -- chance if previous room was anything else
    out_prob = style_sel("outdoors", 0, 30, 60, 100)
  end

  -- alternating outdoors: 
  if LEVEL.alternating_outdoors then
    if last_R then
      if last_R.is_outdoor then
        out_prob = 0
      else
        out_prob = 100
      end
    end
  end

  if not LEVEL.has_outdoors then
    out_prob = 0
  end

  if last_R and last_R.is_street then
    out_prob = out_prob * 0.25
  end

  local is_outdoor = rand.odds(out_prob)

  if LEVEL.is_nature then
    if is_outdoor then R.is_park = true end
  end

  return is_outdoor, false  -- is_cave
end

-- Room size testing
-- Edit by Reisal

function Room_choose_size(LEVEL, R, not_big)
  -- decides whether room will be "big" or not.
  -- room kind (building, cave, etc) should have been set already.

  local prob

  if not_big then
    prob = 0
  elseif R.is_cave then
    prob = 100
  elseif R.is_start or R.is_exit then
    prob = 0
  elseif R.is_outdoor then
    prob = style_sel("big_outdoor_rooms", 0, 50, 75, 90)
  else
-- prob = style_sel("big_rooms", 0, 20, 40, 80) --Original
    prob = style_sel("big_rooms", 0, 15, 35, 75)
  end

  if rand.odds(prob) then
    R.is_big = true
  end

  local sum = LEVEL.map_W * 2/3 + rand.range( 10,50 )


  -- some extra size experiments - should be revised for
  -- more direct control. In fact, maybe this whole size
  -- decision code could use a clean-up
  if not R.is_start
  or not R.is_secret then
    if LEVEL.size_multiplier then
      sum = sum * LEVEL.size_multiplier
    end

    if LEVEL.size_consistency == "strict" then
      if not LEVEL.strict_size then
        LEVEL.strict_size = sum
      end
      sum = LEVEL.strict_size
    end

    if LEVEL.size_consistency == "bounded" then
      if not R.grow_parent 
      or (R.grow_parent and R.grow_parent.is_start) then
        R.size_bounded_sum = sum
      else
        R.size_bounded_sum = sum * rand.range(0.75, 1.5)
      end
      sum = R.size_bounded_sum
    end
  end

  R.floor_limit = rand.key_by_probs(
    {
      [1]=3,
      [2]=4,
      [3]=5,
      [4]=2,
      [5]=1,
    }
  )
  R.size_limit = sum * rand.range( 0.75,1.5 )
  assert(R.floor_limit)

  if R.is_cave then
    R.size_limit  = sum * rand.range( 1.7,3 )
    R.floor_limit = rand.key_by_probs(
      {
        [6]=3,
        [7]=2,
        [8]=2,
        [9]=1,
        [10]=1,
      }
    )

  --Make secret rooms smaller
  elseif R.is_secret then
    R. size_limit = sum * rand.range( 0.6,1.25 )
    R.floor_limit = rand.key_by_probs(
      {
        [1]=3,
        [2]=2,
        [3]=1,
      }
    )

  elseif R.is_big then
    R. size_limit = sum * rand.range( 2,2.7 )
    R.floor_limit = math.round(R.floor_limit * rand.key_by_probs(
        {
          [1]=1,
          [1.5]=2,
          [2]=3,
          [2.5]=4,
          [3]=2,
          [4]=2,
          [5]=1,
          [6]=1,
          [8]=1,
          [10]=1,
          [14]=1,
          [18]=1,
        }
      )
    )

    --Trying a different formula for is_big rooms
                    --[[rand.key_by_probs(
      {
        [6]=2,
        [7]=3,
        [8]=3,
        [9]=5,
        [10]=3,
        [11]=2,
        [12]=2,
        [13]=1,
        [14]=1,
        [15]=1,
      },
    )]]

  --Make parks bigger
  elseif R.is_park then
    R. size_limit = sum * rand.key_by_probs(
      {
        [2]=2,
        [3]=2,
        [4]=1.5,
        [6]=1,
        [8]=1,
      }
    )

  end

  if not R.is_start
  or not R.is_secret then
    if LEVEL.area_multiplier then
      R.floor_limit = math.round(R.floor_limit * LEVEL.area_multiplier)
    end
    if LEVEL.has_absurd_new_area_rules then
      R.floor_limit = R.floor_limit * 4
    end
  end

  -- Special instructions for procedural gotcha rooms
  if LEVEL.is_procedural_gotcha then

    if not R.is_start then -- main arena size

      R.size_limit = LEVEL.map_W*20
      R.floor_limit = rand.irange(20,80)
      R.is_big = true

    elseif R.is_start then -- start room size

      R.size_limit = LEVEL.map_W * 5
      R.floor_limit = R.floor_limit * 2
      R.is_big = true

      -- extra code for single-room gotchas
      if PARAM.bool_boss_gen == 1 then
        R.size_limit = LEVEL.map_W * 20
      end
    end

  elseif not LEVEL.is_procedural_gotcha then

    if R.is_start then
      R.size_limit = math.round(R.size_limit / 2)
      R.floor_limit = math.round(R.floor_limit / 2)
      R.size_limit = math.clamp(rand.pick({4,8,12,16}),R.size_limit,EXTREME_H)
    end

  end

  if R.is_street then
    R.size_limit = (LEVEL.map_W*LEVEL.map_H) * 1.3
    R.floor_limit = tonumber((LEVEL.map_W*LEVEL.map_H) * 0.3) -- number to be recalculated
    R.is_big = true
    R.is_outdoor = true
  end

  -- tame teleporter trunks and hallway exits
  if (not R.grow_parent and not R.is_start)
  or (R.grow_parent and R.grow_parent.is_hallway) then
    R.size_limit = math.round(R.size_limit / 5)
    R.floor_limit = math.round(R.floor_limit / 2)
    R.is_big = false
  end
end


------------------------------------------------------------------------


function Room_prepare_hallways(LEVEL)
  --
  -- Collects all the pieces of each hallway, and determines the
  -- shape and orientation of each piece.
  --

  local function pick_hallway_fab(R, chunk)
    -- Note: does not handle terminator pieces (they are done like joiners)

    assert(chunk.from_dir)
    assert(chunk.shape)

    local reqs = chunk:base_reqs(chunk.from_dir)

    reqs.kind  = "hall"
    reqs.shape = chunk.shape
    reqs.group = assert(chunk.area.room.hall_group)

    local def = Fab_pick(LEVEL, reqs)

    chunk.prefab_def = def
  end


  local function flow(R, piece, h, seen)
    seen[piece.id] = 1

    table.insert(R.pieces, piece)

    local A = piece.area

    -- MSSP-TODO: Figure out how to resolve this thing about Oblige
    -- chopping off hallways between rooms that are already initially connected.
    -- theory: might possibly be caused by some shape rules overriding the hall
    -- shape?
    if not (A and A.room == R) then
      error("CONGRATULATIONS! You have encountered a very rare error " ..
      "that is caused by the shape grammars! Sorry! This is error " ..
      "is still being looked into!")
    end

    A.prelim_h = h

    -- determine shape and orientation
    local cat_dir

    piece.shape, cat_dir = geom.categorize_shape(
        piece.h_join[2], piece.h_join[4], piece.h_join[6], piece.h_join[8])

    -- terminators get mis-categorized as dead-ends...
    if piece.is_terminator and piece.shape == "U" then
      piece.shape = "I"
    end

    -- an L shape needs a dest_dir, so piece can be mirrored when needed
    if piece.shape == "L" then
      for dir = 2,8,2 do
        if piece.h_join[dir] and piece.from_dir ~= dir then
          piece.dest_dir = dir
        end
      end
    end

    -- a T shape needs a specific from_dir
    local old_dir = piece.from_dir

    if piece.shape == "T" then
      piece.from_dir = cat_dir
    end

    if piece.is_terminator then
      Room_pick_joiner_prefab(LEVEL, assert(piece.conn), piece)
    else
      pick_hallway_fab(R, piece)

      -- allow occasional flippage of I pieces
      if piece.prefab_def.can_flip and piece.shape == "I" then
        if rand.odds(50) then
          piece.hallway_mirror = true
        end
      end

    end

    local delta_h = piece.prefab_def.delta_h or 0

    -- recurse to other pieces

    for dir, P in pairs(piece.h_join) do
      if not seen[P.id] then
        local new_h = h

        -- most prefabs are orientated along the flow, so only need to
        -- adjust  delta_h for certain "T" pieces (and maybe terminators...)
        if piece.shape == "T" and piece.from_dir ~= old_dir then
          if dir == piece.from_dir then
            if delta_h ~= 0 then
              A.prelim_h = A.prelim_h - delta_h
            end
            new_h = new_h - delta_h
          end
        else
          if piece.prefab_def.can_flip and R.stair_z_dir == -1 then
            new_h = new_h - delta_h
            A.prelim_h = A.prelim_h - delta_h
            piece.hallway_flip = true
          else
            new_h = new_h + delta_h
          end
        end

        flow(R, P, new_h, seen)
      end
    end
  end


  local function visit_hallway(R)
    R.stair_z_dir = rand.pick({-1,1})
    flow(R, R.first_piece, 0, {})
  end


  ---| Room_prepare_hallways |---

  for _,R in pairs(LEVEL.rooms) do
    if R.is_hallway then
      visit_hallway(R)
    end
  end
end



function Room_floor_ceil_heights(LEVEL, SEEDS)
  --
  -- Computes the floor and ceiling heights of all the areas of
  -- each room, including liquids and closets.
  --
  -- Also constructs CAVES and PARK rooms.
  --

  -- Note: the 'entry_h' field also serves as a "visited already" flag

  local TRAVERSE_H = 80


  local function set_floor(A, h)
    A.floor_h = h
  end


  local function set_ceil(A, h)
    A.ceil_h = h
  end


  local function areaconn_other(IC, A)
    if IC.A1 == A then return IC.A2 end
    if IC.A2 == A then return IC.A1 end

    return nil
  end


  local function prob_for_new_floor_group(A1, A2)
    local vol_1 = A1.svolume / sel(A1.room.symmetry, 2, 1)
    local vol_2 = A2.svolume / sel(A2.room.symmetry, 2, 1)

    -- TODO

    return 0
  end


  local function visit_floor_area(R, A, grp)
    if grp == "new" then
      grp = { id=alloc_id(LEVEL, "floor_group") }
    end

    A.floor_group = grp

    for _,IC in pairs(R.internal_conns) do
      local A2 = areaconn_other(IC, A)

      if not A2 then goto continue end
      if A2.floor_group then goto continue end

      -- Street Mode:
      -- keep the road area from the sidewalks
      if R.is_street then
        if A.is_road and not A2.is_road then goto continue end
      end

      -- stair connections *must* use another group.
      -- direct connections generally use the same group.
      if IC.kind ~= "direct" or rand.odds(prob_for_new_floor_group(A, A2)) then
        visit_floor_area(R, A2, "new")
      else
        visit_floor_area(R, A2, A.floor_group)
      end
      ::continue::
    end
  end


  local function group_floors(R)
    if R.is_park then return end
    if R.is_cave then return end
    if R.is_hallway then return end

    local start_area

    repeat
      start_area = rand.pick(R.areas)
    until start_area.mode == "floor"

    visit_floor_area(R, start_area, "new")
  end


  local function merge_floor_groups(R, group1, group2)
    if group1.id > group2.id then
      group1, group2 = group2, group1
    end

    for _,A in pairs(R.areas) do
      if A.floor_group == group2 then
        A.floor_group =  group1
      end
    end

    group2.id = "DEAD"
  end


  local function do_floor_groups_touch(R, group1, group2)
    for _,A3 in pairs(R.areas) do
      for _,A4 in pairs(R.areas) do
        if A3.floor_group == group1 and
           A4.floor_group == group2 and
           A3:touches(A4)
        then
          return true
        end
      end
    end

    return false
  end


  local function try_regroup_floors(R, A1, A2)
    local group1 = A1.floor_group
    local group2 = A2.floor_group

    if R.is_street then return end

    if not (group1 and group2) then return end

    if group1 == group2 then return end

    if group1.h ~= group2.h then return end

    if do_floor_groups_touch(R, group1, group2) then
      merge_floor_groups(R, group1, group2)
    end
  end


  local function regroup_floors(R)
    -- after setting floor heights in the room, this checks if two
    -- groups which touch each other have the same height

    for pass = 1, 3 do
      for _,A1 in pairs(R.areas) do
      for _,A2 in pairs(R.areas) do
        try_regroup_floors(R, A1, A2)
      end
      end
    end

    for _,A in pairs(R.areas) do
      if A.floor_group then
        if A.is_road then
          A.floor_group.is_road = true
        end
        table.add_unique(R.floor_groups, A.floor_group)
      end
    end

    for _,group in pairs(R.floor_groups) do
      Area_inner_points_for_group(LEVEL, R, group, "floor", SEEDS)
    end
  end


  local function ceilings_must_stay_separated(R, A1, A2)
    assert(A1 ~= A2)

    for _,IC in pairs(R.internal_conns) do
      if (IC.A1 == A1 and IC.A2 == A2) or
         (IC.A1 == A2 and IC.A2 == A1)
      then
        if IC.foobie_bletch then return false end

        return (IC.kind == "direct")
      end
    end

--[[
    if not A1:touches(A2) then return false end

    return (A1.floor_group == A2.floor_group)
--]]
    return false
  end


  local function merge_ceil_groups(R, group1, group2)
    if group1.id > group2.id then
      group1, group2 = group2, group1
    end

-- stderrf("%s : merging ceil %d --> %d\n", R.name, group2.id, group1.id)

    for _,A in pairs(R.areas) do
      if A.ceil_group == group2 then
         A.ceil_group =  group1
      end
    end

    group2.id = "DEAD"
  end


  local function try_merge_ceil_groups(R, group1, group2)
    assert(group1 ~= group2)

    local do_touch = false

    for _,A1 in pairs(R.areas) do
    for _,A2 in pairs(R.areas) do
      if A1.ceil_group ~= group1 then goto continue end
      if A2.ceil_group ~= group2 then goto continue end

      if ceilings_must_stay_separated(R, A1, A2) then return false end

      -- do not merge ciel groups seperated by porch areas
      if A1.is_porch or A2.is_porch then return false end

      if A1:touches(A2) then do_touch = true end

      for _,IC in pairs(R.internal_conns) do
        if (IC.A1 == A1 and IC.A2 == A2) or
           (IC.A1 == A2 and IC.A2 == A1)
        then
          do_touch = true
        end
      end
      ::continue::
    end  -- A1, A2,
    end

    if not do_touch then return false end

    merge_ceil_groups(R, group1, group2)
    return true
  end


  local function group_ceiling_pass(R)
    local groups = {}

    for _,A in pairs(R.areas) do
      if A.ceil_group then
        table.add_unique(groups, A.ceil_group)
      end
    end

    if #groups < 2 then return false end

    rand.shuffle(groups)

    for i = 2, #groups do
    for k = 1, i - 1 do
      if try_merge_ceil_groups(R, groups[i], groups[k]) then
        return true
      end
    end
    end

    return false
  end


  local function group_ceilings(R)
    if R.is_outdoor then return end

    for _,A in pairs(R.areas) do
      if A.mode == "floor" then
        A.ceil_group = { id=alloc_id(LEVEL, "ceil_group") }
      end
    end

--[[
    -- pick some internal connections that should BLAH BLAH
    for _,IC in pairs(R.internal_conns) do
      if IC.kind == "stair" or rand.odds(30) then
        IC.same_ceiling = true
      end
    end
--]]

    for loop = 1, 1 do
      group_ceiling_pass(R)
    end

    -- handle stairs
    for _,A in pairs(R.areas) do
      if A.chunk and A.chunk.kind == "stair" and not A.chunk.prefab_def.plain_ceiling then
        local N1 = A.chunk.from_area
        local N2 = A.chunk.dest_area

        if N1.floor_h < N2.floor_h then
          A.ceil_group = N1.ceil_group
        else
          A.ceil_group = N2.ceil_group
        end

      end
    end


    for _,A in pairs(R.areas) do
      if A.ceil_group then
        table.add_unique(R.ceil_groups, A.ceil_group)
      end
    end

    for _,group in pairs(R.ceil_groups) do
      Area_inner_points_for_group(LEVEL, R, group, "ceil", SEEDS)
    end
  end


  --[[local function room_add_steps(R)
    -- NOT USED ATM [ should be done while flowing through room ]

    for _,C in pairs(R.internal_conns) do
      local A1 = C.A1
      local A2 = C.A2

      if C.kind == "stair" then goto continue end

      local diff = math.abs(A1.floor_h - A2.floor_h)
      if diff <= PARAM.jump_height then goto continue end

      -- FIXME : generally build single staircases (a la V6 and earlier)

      local junc = Junction_lookup(A1, A2)

      Junction_make_steps(junc)
      ::continue::
    end
  end]]


  local function process_room(R, entry_area)
    gui.debugf("ASSIGN FLOORS IN %s\n", R.name)

    local base_h = 0

    if entry_area then
      base_h = R.entry_h - assert(entry_area.prelim_h)
    end

    -- compute the actual floor heights, ensuring entry_area becomes 'entry_h'
    for _,A in pairs(R.areas) do
      if A.prelim_h then
        set_floor(A, base_h + A.prelim_h)
      end

--    stderrf("%s %s = %s : floor_h = %s\n", R.name, A.name, tostring(A.mode), tostring(A.floor_h))
    end
  end


  local function process_cave(R)
    Cave_build_a_cave(R, R.entry_h, SEEDS, LEVEL)
  end


  local function process_park(R)
    R.walkway_height = 256
    R.areas[1].base_light = 144

    Cave_build_a_park(LEVEL, R, R.entry_h, SEEDS)
  end


  local function maintain_material_across_conn(C)
    if C.kind ~= "edge" then return false end

    if C.R1.is_cave or C.R2.is_cave then return false end
    if C.R1.is_hallway or C.R2.is_hallway then return false end

    if C.A1.floor_h    ~= C.A2.floor_h then return false end
    if C.R1.is_outdoor ~= C.R2.is_outdoor then return false end

    if not (C.E1.kind == "nothing" or C.E1.kind == "doorway") then return false end
    if not (C.E2.kind == "nothing" or C.E2.kind == "doorway") then return false end

    return true
  end


  local function select_floor_mats(R, entry_conn)
    if not R.theme.floors then return end

    -- maintain floor material if same height and no door
    if entry_conn and maintain_material_across_conn(entry_conn) then
      local A1 = entry_conn.A1
      local A2 = entry_conn.A2

      if not A1.floor_mat then
        A1, A2 = A2, A1
      end

      if A1.floor_mat then
        assert(A1.floor_h)

        R.floor_mats[A1.floor_h] = A1.floor_mat
      end
    end

    for _,A in pairs(R.areas) do
      if A.mode ~= "floor" then goto continue end

      assert(A.floor_h)

      if A.peer and A.peer.floor_mat then
        A.floor_mat = A.peer.floor_mat
        goto continue
      end

      if not R.floor_mats[A.floor_h] then
        if R.is_outdoor then
          local tex
          if rand.odds(50) then
            tex = rand.key_by_probs(R.floor_mat_list)
            R.floor_mat_list[tex] = R.floor_mat_list[tex] / 4
            R.floor_mats[A.floor_h] = tex
          else
            tex = rand.key_by_probs(R.floor_mat_list_natural)
            R.floor_mat_list_natural[tex] = R.floor_mat_list_natural[tex] / 4
            R.floor_mats[A.floor_h] = tex
          end
        else
          R.floor_mats[A.floor_h] = rand.key_by_probs(R.theme.floors)
        end
      end

      if R.is_outdoor then
        if R.theme.porch_floors then
          A.porch_floor_mat = rand.key_by_probs(R.theme.porch_floors)
        else
          gui.printf(LEVEL.theme_name .. " NEEDS A PORCH_FLOORS table BADLY!!!111\n")
        end
      end

      A.floor_mat = assert(R.floor_mats[A.floor_h])
      ::continue::
    end
  end


  local function select_ceiling_mats(R)
    -- outdoor rooms do not require ceiling materials
    if R.is_outdoor then return end

    local tab = R.theme.ceilings or R.theme.floors
    assert(tab)

    for _,A in pairs(R.areas) do
      if A.is_outdoor then goto continue end
      --if A.is_porch   then goto continue end

      if A.mode ~= "floor" then goto continue end

      assert(A.ceil_h)

      if A.peer and A.peer.ceil_mat then
        A.ceil_mat = A.peer.ceil_mat
        goto continue
      end

      if not R.ceil_mats[A.ceil_h] then
        R.ceil_mats[A.ceil_h] = rand.key_by_probs(tab)
      end

      A.ceil_mat = assert(R.ceil_mats[A.ceil_h])
      ::continue::
    end
  end


  local function visit_joiner(entry_h, prev_room, conn)
    local chunk = assert(conn.joiner_chunk)
    assert(chunk.prefab_def)

    -- FIXME: this smells like a hack
    if chunk.occupy == "whole" then
      chunk.area.is_outdoor = nil
    end

    local delta_h = chunk.prefab_def.delta_h or 0

    -- are we entering the joiner from the opposite side?
    if chunk.from_area.room ~= prev_room then
      delta_h = 0 - delta_h
    end

    local joiner_h = math.min(entry_h, entry_h + delta_h)

    set_floor(chunk.area, joiner_h)

-- stderrf("  setting joiner in %s to %d\n", C.joiner_chunk.area.name, C.joiner_chunk.area.floor_h)
-- stderrf("  loc: (%d %d)\n", C.joiner_chunk.sx1, C.joiner_chunk.sy1)

    return entry_h + delta_h
  end


  local function visit_room(R, entry_h, entry_area, prev_room, via_conn)
    group_floors(R)

    if entry_area then
      assert(entry_area.room == R)
      assert(entry_area.mode ~= "joiner")
    end

    -- handle start rooms and teleported-into rooms
    if not entry_h then
      entry_h = rand.irange(0, 4) * 64
    end

    R.entry_h = entry_h

    if via_conn then
      via_conn.door_h = entry_h
    end

    if R.is_hallway then
      process_room(R, entry_area)

    elseif R.is_cave then
      process_cave(R)

    elseif R.is_park then
      process_park(R)

    else
      process_room(R, entry_area)

      select_floor_mats(R, via_conn)

      Room_detect_porches(LEVEL, R)
    end

    -- recurse to neighbors
    for _,C in pairs(R.conns) do
      if C.is_cycle then goto continue end

      local R2 = C:other_room(R)

      local A1, A2
      if C.R1 == R then A1 = C.A1 else A1 = C.A2 end
      if C.R1 == R then A2 = C.A2 else A2 = C.A1 end

      -- already visited it?
      if R2.entry_h then goto continue end

      gui.debugf("Recursing through %s (%s)\n", C.name, C.kind)
-- if C.kind ~= "teleporter"then
-- stderrf("  %s / %s ---> %s / %s\n", A1.name, A1.mode, A2.name, A2.mode)
-- end

      if C.kind == "teleporter" then
        visit_room(R2, nil, nil, R, C)
        goto continue
      end

      assert(A1.mode ~= "joiner")
      assert(A2.mode ~= "joiner")

      assert(A1.floor_h)

      local next_h = C.conn_h or A1.floor_h

      if C.kind == "joiner" then  --FIXME???  or C.kind == "terminator" then
        next_h = visit_joiner(next_h, R, C)
      end

      visit_room(R2, next_h, A2, R, C)
      ::continue::
    end
  end


  local function do_liquid_areas(R)
    for _,A in pairs(R.areas) do
      if A.mode == "liquid" then
        local N = A:lowest_neighbor()
        local N2 = A:highest_neighbor()

        if not N then
--!!!! FIXME : temp stuff for park-border experiment....
--!!!!    error("failed to find liquid neighbor")
          A.floor_h = 977
          A.ceil_h  = 999
          goto continue
        end

        A.floor_h  = N.floor_h - (THEME.pool_depth or 16)
        A.ceil_h   = N2.ceil_h
        A.ceil_mat = N2.ceil_mat
        ::continue::
      end
    end
  end


  local function get_cage_neighbor(A)
    local N = A:highest_neighbor()

    if N then return N end

    for _,N2 in pairs(A.neighbors) do
      if N2.room == A.room and N2.mode == "liquid" then return N2 end
    end

    for _,N3 in pairs(A.neighbors) do
      if N3.room == A.room and N3.mode == "nature" then return N3 end
    end

    -- error("failed to find cage neighbor")
  end


  --local function kill_start_cages(R)
    local function kill_cages(R, want_void)
    -- turn cages in start rooms into a plain floor

    for _,A in pairs(R.areas) do
      if A.mode ~= "cage" then goto continue end

      --if R.is_park or R.is_cave then
        if R.is_park or R.is_cave or want_void then
        A.mode = "void"
        goto continue
      end

      local N

      if A.peer and A.peer.floor_h then
        N = A.peer
      else
        N = get_cage_neighbor(A)
      end

      A.mode = N.mode

      A.floor_h   = N.floor_h
      A.floor_mat = N.floor_mat

      A.ceil_h    = N.ceil_h
      A.ceil_mat  = N.ceil_mat
      ::continue::
    end
  end


  local function add_cage_lighting(R, A)
    if not R.cage_light_fx then
      --  8 = oscillates
      -- 17 = flickering
      -- 12 = flashes @ 1 hz
      -- 13 = flashes @ 2 hz
      R.cage_light_fx = rand.pick({ 0,8,12,13,17 })
    end

    if R.cage_light_fx == 0 then
      -- no effect
      A.bump_light = 32
      return
    end

    A.bump_light = 48
    A.sector_fx  = R.cage_light_fx
  end


  local function do_a_cage(R, A)
    -- for symmetry, ensure second cage is same as first
    if A.peer and A.peer.floor_h then
      local P = A.peer

      A.floor_h   = P.floor_h
      A.floor_mat = P.floor_mat

      A.ceil_h    = P.ceil_h
      A.ceil_mat  = P.ceil_mat

      A.bump_light = P.bump_light
      A.sector_fx  = P.sector_fx

      if table.has_elem(R.cage_rail_areas, P) then
        table.insert(R.cage_rail_areas, A)
      end

      return
    end

    local N = get_cage_neighbor(A)

    if not N then
      A.mode = "void"
      return
    end

    -- set a base height for the cage neighbor so cages
    -- along this area look consistent
    if not N.cage_floor_h then
      local offset = rand.pick({32,48})

      N.cage_floor_h = (N.floor_h or N.max_floor_h) + offset
      if N.mode == "nature" then N.cage_floor_h = N.max_floor_h + offset end
    end
    A.floor_h = N.cage_floor_h

    A.cage_neighbor = N

    -- set ceiling for cage (basically if indoors)
    if N.ceil_h then
      A.ceil_h = math.max(A.floor_h + A.room.scenic_fences.rail_h, A.floor_h + 96, N.ceil_h)
    end

    A.floor_mat = assert(R.cage_mat or A.zone.cage_mat)
    A.ceil_mat = assert(R.cage_mat or A.zone.cage_mat)

    -- fancy cages
    if A.cage_mode or (#A.seeds >= 4 and rand.odds(50)) then

      table.insert(R.cage_rail_areas, A)

      if not R.is_outdoor then

        if N.ceil_h and N.ceil_h > A.ceil_h + 96 then
          A.ceil_h = N.ceil_h
        else
          A.ceil_mat = A.floor_mat
        end

        add_cage_lighting(R, A)
      end

      -- occasionally make floor level cages
      if R.cage_floor_level and N.mode == "floor" then
        local diff = N.floor_h - A.floor_h
        A.floor_h = N.floor_h

        if not R.is_outdoor then
          A.ceil_h = math.max(A.floor_h + A.room.scenic_fences.rail_h, A.floor_h + 96)
        end
      end
    end

    -- adopt room textures on cases where flats have same
    -- heights to the neighbor
    if A.ceil_h == N.ceil_h then
      A.ceil_mat = N.ceil_mat
    end
    if A.floor_h == N.floor_h then
      A.floor_mat = N.floor_mat
    end
  end


  local function do_sink_mats(R)
    local picked_ceil_mat
    local picked_floor_mat

    -- MSSP-TODO: pick the material from the largest area in the room instead (via svolume)
    while not picked_floor_mat do
      for _,A in pairs(R.areas) do
        if A.floor_mat then
          picked_floor_mat = A.floor_mat
        end
      end
      if not picked_floor_mat then picked_floor_mat = R.main_tex end
    end

    R.floor_sink_mat = picked_floor_mat

    if R.is_outdoor then return end

    while not picked_ceil_mat do
      for _,A in pairs(R.areas) do
        if A.ceil_mat then
          picked_ceil_mat = A.ceil_mat
        end
      end
      if not picked_ceil_mat then picked_ceil_mat = R.main_tex end
    end
    R.ceil_sink_mat = picked_ceil_mat

  end


  local function do_cage_areas(R)
    if R.is_start then
      --kill_start_cages(R)
      kill_cages(R)
      return
    end

    if R.is_secret and rand.odds(90) then
      kill_cages(R, "want_void")
      return
    end

    R.cage_rail_areas = {}

    if rand.odds(50) and not R.is_park then
      R.cage_floor_level = true
    end

    for _,A in pairs(R.areas) do
      if A.mode == "cage" then
        do_a_cage(R, A)
      end
    end
  end


  local function do_stairs(R)
    for _,chunk in pairs(R.stairs) do
      local A = chunk.area

      -- outdoor heights are done later, get a dummy now
      if A.is_outdoor then
        A.ceil_h = A.floor_h + R.zone.sky_add_h - 8
        goto continue
      end

      local N1 = chunk.from_area
      local N2 = chunk.dest_area
      assert(N1.ceil_h)
      assert(N2.ceil_h)

      if N1.ceil_h < (N2.floor_h + 96) then
        N1.ceil_h = N2.ceil_h
        N1 = N2
      end

      A.ceil_h   = N1.ceil_h
      A.ceil_mat = N1.ceil_mat
      ::continue::
    end

    -- MSSP: second pass
    for _,chunk in pairs(R.stairs) do
      local A = chunk.area
      local N = chunk.from_area

      A.ceil_h = N.ceil_h
    end
  end


  local function do_closets(R)
    for _,chunk in pairs(R.closets) do
      local A = chunk.area

      assert(chunk.from_area)
      A.floor_h = assert(chunk.from_area.floor_h)

      -- FIXME: this smells like a hack
      if chunk.occupy == "whole" then
        A.is_outdoor = nil
      end
    end
  end


  local function calc_min_max_h(R, with_ceil)
    R.max_floor_h = -EXTREME_H
    R.min_floor_h =  EXTREME_H
    R.max_ceil_h  = -EXTREME_H
    R.min_ceil_h  =  EXTREME_H

    for _,A in pairs(R.areas) do
      if A.floor_h then
        R.max_floor_h = math.max(R.max_floor_h, A.max_floor_h or A.floor_h)
        R.min_floor_h = math.min(R.min_floor_h, A.min_floor_h or A.floor_h)

        if A.floor_group then A.floor_group.h = A.floor_h end
      end

      if with_ceil and A.ceil_h and not R.is_hallway then
        R.max_ceil_h = math.max(R.max_ceil_h, A.max_ceil_h or A.ceil_h)
        R.min_ceil_h = math.min(R.min_ceil_h, A.min_ceil_h or A.ceil_h)
      end

    end

    assert(R.max_floor_h >= R.min_floor_h)
    if with_ceil and not R.is_hallway then
      assert( R.max_ceil_h >= R.min_ceil_h )
    end

    -- hack
    if R.is_park and R.park_type == "plains" then
      R.max_floor_h = R.entry_h
    end
  end


  local function check_joiner_nearby_h(A)
    -- FIXME for terminators
    for _,C in pairs(LEVEL.conns) do
      if (C.kind == "joiner" or C.kind == "XXX_terminator") and
         (C.A1 == A or C.A2 == A)
      then
        return C.joiner_chunk.prefab_def.nearby_h
      end
    end

    return nil
  end


  local function calc_ceil_stuff(R, group)
    group.vol = 0

    for _,A in pairs(R.areas) do
      if A.ceil_group == group then
        group.vol = group.vol + A.svolume

        group.min_floor_h = math.N_min(A.floor_h, group.min_floor_h)
        group.max_floor_h = math.N_max(A.floor_h, group.max_floor_h)
      end
    end

    if R.symmetry then group.vol = group.vol / 2 end

    assert(group.max_floor_h)

    group.min_h = 96

    for _,A in pairs(R.areas) do
      if A.ceil_group == group and A:has_conn(LEVEL) then
        -- TODO : get nearby_h from arch/door prefab  [ but it aint picked yet... ]
        local min_h = A.floor_h + 128 - group.max_floor_h
        group.min_h = math.max(group.min_h, min_h)

        min_h = check_joiner_nearby_h(A)
        if min_h then
          min_h = A.floor_h + min_h - group.max_floor_h
          group.min_h = math.max(group.min_h, min_h)
        end
      end
    end

--[[
    stderrf("%s : ceil group %d : vol=%d  min=%d  max=%d\n", R.name, group.id,
        group.vol, group.min_floor_h, group.max_floor_h)
--]]
  end


  local function calc_a_ceiling_height(R, group)
    local add_h

    if not R.height_profile then
      R.height_profile = rand.pick({"normal","inverse","random"})
    end

    if R.height_profile == "normal" then
          if group.vol <  8 then add_h = 96
      elseif group.vol < 16 then add_h = 128
      elseif group.vol < 32 then add_h = 160
      elseif group.vol < 48 then add_h = 192
      else                       add_h = 256
      end
    elseif R.height_profile == "inverse" then
      if group.vol     < 16 then add_h = 256
      elseif group.vol < 32 then add_h = 192
      elseif group.vol < 48 then add_h = 160
      else                       add_h = 128
      end
    else
      add_h = rand.pick({128, 160, 192, 224, 256})
    end

    -- MSSP: code for the height style control
    if not R.height_style then
      R.height_style = rand.key_by_probs(LEVEL.room_height_style_tab)
    end

    -- nothing actually happens if the height_style is "normal",
    -- whereas normal is Oblige's default behavior

    if R.height_style == "short" then
      if add_h > 144 then add_h = 144 end
    elseif R.height_style == "tall" then

      local tall_offsets =
      {
        [1.5] = 3,
        [2] = 9,
        [3] = 1,
      }

      if group.vol > 96 then
        tall_offsets[3] = 3
      elseif group.vol > 64 then
        tall_offsets[3] = 2
      end

      add_h = tonumber(add_h * rand.key_by_probs(tall_offsets))
    end

    if add_h > 128 and group.max_floor_h >= group.min_floor_h + 64 then
      add_h = add_h - 32
    end

    add_h = math.max(group.min_h, add_h)

    group.h = group.max_floor_h + add_h
  end


  local function ceil_ensure_traversibility(R)
    -- ensure enough vertical room for player to travel between two
    -- internally connected areas

    for _,IC in pairs(R.internal_conns) do
      local A1 = IC.A1
      local A2 = IC.A2

      local top_z = math.max(A1.floor_h, A2.floor_h)

      if A1.stair_top_h then top_z = math.max(top_z, A1.stair_top_h) end
      if A2.stair_top_h then top_z = math.max(top_z, A2.stair_top_h) end

      top_z = top_z + TRAVERSE_H

      if A1.ceil_group then
        while A1.ceil_group.h < top_z do A1.ceil_group.h = A1.ceil_group.h + 32 end
      else
        A1.traverse_ceil_h = top_z
      end

      if A2.ceil_group then
        while A2.ceil_group.h < top_z do A2.ceil_group.h = A2.ceil_group.h + 32 end
      else
        A2.traverse_ceil_h = top_z
      end
    end
  end


  local function ceiling_group_heights(R)
    --
    -- Notes:
    --   a major requirement is the ceiling groups which neighbor
    --   each other (incl. via a stair) get a unique ceil_h.
    --
    --   a lesser goal is that larger ceiling groups get a higher
    --   ceiling than smaller ones.
    --

    local groups = {}

    for _,A in pairs(R.areas) do
      if A.ceil_group then
        table.add_unique(groups, A.ceil_group)
      end
    end

    for _,group in pairs(groups) do
      calc_ceil_stuff(R, group)
    end

    rand.shuffle(groups)

    for _,group in pairs(groups) do
      calc_a_ceiling_height(R, group)
    end

    ceil_ensure_traversibility(R)

    -- TODO if largest ceil-group is same as a neighbor, raise by 32 until different
  end


  local function porch_fixup_neighbors(R)

    local function infect_area(A, N)
      if not N.floor_h or not N.ceil_h then return end

      A.is_outdoor = false
      A.ceil_mat = N.ceil_mat
      A.is_porch_neighbor = true

      if A.mode == "cage" then
        A.ceil_h = N.ceil_h
        A.floor_h = (N.floor_h or N.chunk.floor_h) + 24

        local h_diff
        h_diff = A.ceil_h - A.floor_h
        if h_diff < 96 then
          A.floor_h = A.ceil_h - 96
        end
        A.cage_mode = "fancy"
      end

      if A.peer then
        A.peer.is_outdoor = false
        A.peer.is_porch_neighbor = true
        A.peer.ceil_mat = A.ceil_mat
        A.peer.ceil_h = A.ceil_h
      end

    end

    local function check_neighboring_porches(A)
      local porch_count = 0
      for _,N in pairs(A.neighbors) do

        if N.is_porch then
          porch_count = porch_count + 1
        end

        -- a staircase between two porches... porch it all the time
        if A.chunk and A.chunk.kind == "stair" then
          if A.chunk.from_area.is_porch and
          A.chunk.dest_area.is_porch then
            return A, N
          end
        end

        -- areas to be infected by porches should all be in the same room
        if A.room == N.room then
          if porch_count == #A.neighbors then
            return A, N
          elseif porch_count > 0
          and porch_count < #A.neighbors
          and rand.odds(50) then
            return A, N
          end
        end
      end

    end

    if R.is_outdoor then
      for _,A in pairs(R.areas) do

        local A1
        local A2

        if A.chunk then
          if A.chunk.kind == "stair" then
            if A.chunk.from_area.is_porch
            or A.chunk.dest_area.is_porch then
              A1, A2 = check_neighboring_porches(A)
            end
          end
        end

        if A.mode == "liquid" or A.mode == "cage" then
          A1, A2 = check_neighboring_porches(A)
        end

        if A1 and A2 then
          infect_area(A1, A2)
        end

      end
    end

  end


  local function do_ceilings(R)
    group_ceilings(R)

    if not R.is_outdoor then
      ceiling_group_heights(R)
    end

    for _,A in pairs(R.areas) do
      if A.mode ~= "floor" then goto continue end

      -- outdoor heights are done later, get a dummy now
      if A.is_outdoor then
        A.ceil_h = A.floor_h + R.zone.sky_add_h - 8
        goto continue
      end

      if A.peer and A.peer.ceil_h then
        A.ceil_h = A.peer.ceil_h
        goto continue
      end

      if A.ceil_group then
        set_ceil(A, assert(A.ceil_group.h))
        goto continue
      end

      local height = rand.pick({ 128, 192,192,192, 256,320 })

      if A.is_porch then
        height = 144
      end

---## if not A.floor_h then
---## gui.debugf("do_ceilings : no floor_h in %s %s in %s\n", A.name, A.mode, A.room.name)
---## end
      assert(A.floor_h)

      local new_h = R.max_floor_h + 128

      if A.traverse_ceil_h then new_h = math.max(new_h, A.traverse_ceil_h) end

      set_ceil(A, new_h)
      ::continue::
    end

    -- MSSP: get certain areas neighboring porches to also adopt
    -- the porch's ceiling heights and materials
    porch_fixup_neighbors(R)

    -- now pick textures
    select_ceiling_mats(R)
  end


  local function sanity_check()
    for _,R in pairs(LEVEL.rooms) do
      if not R.entry_h then
--[[ "fubar" debug stuff
R.entry_h = -77,
for _,A in pairs(R.areas) do A.floor_h = R.entry_h end
end
--]]
        error("Room did not get an entry_h")
      end
    end
  end


  ---| Room_floor_ceil_heights |---

  local first = LEVEL.start_room or LEVEL.blue_base or LEVEL.rooms[1]

  -- recursively visit all rooms
  visit_room(first)

  -- sanity check : all rooms were visited
  sanity_check()

  for _,R in pairs(LEVEL.rooms) do
    calc_min_max_h(R)

    -- corner style decision -MSSP
    if THEME.sink_style and #THEME.sink_style > 0 then
      R.corner_style = rand.key_by_probs(THEME.sink_style)
    elseif R.is_outdoor then
      R.corner_style = "curved"
    else
      R.corner_style = "sharp"
    end

    if not (R.is_cave or R.is_park) then
      regroup_floors(R)

      do_ceilings(R)
      do_liquid_areas(R)

      do_sink_mats(R)
    end

    do_cage_areas(R)
    do_stairs(R)

    do_closets(R)

    Room_cleanup_stairs_to_nowhere(R)
    calc_min_max_h(R, "ceilz_with_feelz")
  end
end



function Room_add_cage_rails(LEVEL)
  -- this must be called AFTER scenic borders are finished, since
  -- otherwise we won't know the floor_h of border areas.

  local function rails_in_cage(A, R)
    for _,N in pairs(A.neighbors) do
      if N.zone ~= A.zone then goto continue end

      local junc = Junction_lookup(LEVEL, A, N)

      if junc.E1 and junc.E1.kind ~= "nothing" then goto continue end
      if junc.E2 and junc.E2.kind ~= "nothing" then goto continue end

      -- don't place railings on higher floors (it looks silly)
      if N.floor_h and N.floor_h > A.floor_h then goto continue end

      Junction_make_railing(LEVEL, junc, "FENCE_MAT_FROM_THEME", "block")
      ::continue::
    end
  end


  ---| Room_add_cage_rails |---

  for _,R in pairs(LEVEL.rooms) do
    if R.cage_rail_areas then
      for _,A in pairs(R.cage_rail_areas) do
        rails_in_cage(A, R)
      end
    end
  end
end



function Room_set_sky_heights(LEVEL)

  local function do_area(A)
    local sky_h = (A.max_floor_h or A.floor_h) + A.zone.sky_add_h

    A.zone.sky_h = math.N_max(A.zone.sky_h, sky_h)
  end


  local function do_fence(E)
    assert(E.peer)

    local A1 = E.area
    local A2 = E.peer.area

    E.fence_top_z = Junction_calc_fence_z(A1, A2)
  end


  ---| Room_set_sky_heights |---

  -- MSSP: trying to get outdoor rooms to not
  -- be taller than any indoor room in the same
  -- zone
  for _,Z in pairs(LEVEL.zones) do
    Z.sky_h = -EXTREME_H
    for _,R in pairs(Z.rooms) do
      if R.max_ceil_h then
        Z.sky_h = math.max(Z.sky_h, R.max_ceil_h)
      end
    end
  end

  -- link also for instances where both rooms
  -- in a zone-to-new-zone connection have
  -- proper outdoor heights
  for _,C in pairs(LEVEL.conns) do
    if C.R1.zone ~= C.R2.zone then

      if C.R1.is_outdoor and C.R2.is_outdoor then
        C.R1.zone.sky_h = math.max(C.R1.zone.sky_h, C.R2.zone.sky_h)
        C.R2.zone.sky_h = math.max(C.R1.zone.sky_h, C.R2.zone.sky_h)
      end

      if not C.R1.is_outdoor and C.R2.is_outdoor then
        local from_room_max_height = C.R1:get_highest_ceiling()
        if from_room_max_height > C.R2.zone.sky_h then
          C.R2.zone.sky_h = from_room_max_height
        end
      end

      if C.R1.is_outdoor and not C.R2.is_outdoor then
        local dest_room_max_height = C.R2:get_highest_ceiling()
        if dest_room_max_height > C.R1.zone.sky_h then
          C.R1.zone.sky_h = dest_room_max_height
        end
      end

    end
  end

  for _,A in pairs(LEVEL.areas) do
    -- visit all normal, outdoor areas
    if A.floor_h and A.is_outdoor and not A.mode ~= "scenic" then
      do_area(A)

      -- include nearby buildings in same zone
      -- [ TODO : perhaps limit to where areas share a window or doorway ]
--???      for _,N in pairs(A.neighbors) do
--???        if N.zone == A.zone and N.floor_h and not N.is_outdoor and not N.is_boundary then
--???          do_area(N)
--???        end
--???      end
    end
  end

  -- ensure every zone gets a sky_h
  for _,Z in pairs(LEVEL.zones) do
    if not Z.sky_h then
      Z.sky_h = 0
      Z.no_outdoors = true
    end
  end

  -- transfer final results into areas
  -- [ SCENIC areas are done later.... ]

  for _,A in pairs(LEVEL.areas) do
    if A.floor_h and A.zone and A.is_outdoor and not A.is_porch then
      A.ceil_h = A.zone.sky_h + 16
    end
  end

  -- handle locked and secret fences
  for _,R in pairs(LEVEL.rooms) do
    for _,E in pairs(R.locked_fences) do
      do_fence(E)
    end
  end
end



function Room_cleanup_stairs_to_nowhere(R)

  local function area_leads_to_nowhere(A)

    -- style control
    if rand.odds(style_sel("dead_ends", 0, 33, 66, 100)) then
      return false
    end

    -- gotta be a floor obviously
    if A.mode ~= "floor"
    or not A.room
    or not A.floor_h then return false end

    -- must have an area lesser than 6 seeds
    if A.svolume > 8 then return false end

    local same_room_neighbors = 0
    local stair_neighbors = 0
    local from_area
    for _,N in pairs(A.neighbors) do

      if N.room == A.room then

        if N.mode == "floor" then

          same_room_neighbors = same_room_neighbors + 1

          -- must not be connected to other areas with the same floor height
          if A.floor_h == N.floor_h then
            return false
          end

        end

        if N.mode == "cage" then
          if A == N.cage_neighbor then
            return false
          end
        end

        if N.chunk then

          if N.chunk.kind == "stair" then
            -- if this area has stairs that go elsewhere, exclude
            stair_neighbors = stair_neighbors + 1
          end

          -- must not have a closet or joiner neighbor (because this means
          -- this room can have something important)
          if N.chunk.kind == "joiner" then
            if N.chunk.from_area == A then
              return false
            end
            if N.chunk.dest_area == A then
              return false
            end
          end
        end

      end

      -- must have at least a solid wall
      if same_room_neighbors == #A.neighbors then return false end

      -- must not have multiple stair connections
      if stair_neighbors > 1 then return false end
    end

    -- direct connections check
    for _,C in pairs(R.conns) do
      if C.A1 == A or
      C.A2 == A then
        return false
      end
    end

    return true
  end


  local function get_area_entry_stair(A)
    local source_stair
    local stair_source

    for _,N in pairs(A.neighbors) do
      if N.chunk then

        if N.chunk.kind == "stair" then
          if A == N.chunk.dest_area then
            source_stair = N
            stair_source = N.chunk.from_area
          elseif A == N.chunk.from_area then
            source_stair = N
            stair_source = N.chunk.dest_area
          end
          return source_stair, stair_source
        end
      end
    end
  end


  local function fixup_neighbors(A)
    for _,N in pairs(A.neighbors) do
      if N.chunk then
        if N.chunk.kind == "closet" then
          if A == N.chunk.from_area then
            N.floor_h = N.chunk.from_area.floor_h
          end
        end
      end

      if N.mode == "liquid" then
        local initial_height = EXTREME_H
        local best_LN
        for _,LN in pairs(N.neighbors) do
          if LN.room == N.room then
            if LN.mode == "floor" and LN.floor_h < initial_height then
              initial_height = LN.floor_h
              best_LN = LN
            end
          end
        end

        N.floor_h = best_LN.floor_h - 16
        N.ceil_h = best_LN.ceil_h

      end
    end
  end


  local function fixup_cages()
    for _,A in pairs(LEVEL.areas) do
      if A.mode == "cage" and A.floor_h then
        local tallest_ceiling = -EXTREME_H
        local lowest_floor = EXTREME_H

        for _,N in pairs(A.neighbors) do
          if A.room == N.room and (N.mode == "floor" or N.mode == "liquid") then
            if N.ceil_h > tallest_ceiling then
              tallest_ceiling = N.ceil_h
            end
            if N.floor_h < lowest_floor then
              lowest_floor = N.floor_h
            end
          end
        end

        if A.floor_h < lowest_floor and lowest_floor < EXTREME_H then
          local diff = lowest_floor - A.floor_h
          A.floor_h = lowest_floor + 32
          A.ceil_h = A.ceil_h + diff
        end
        if A.ceil_h > tallest_ceiling and tallest_ceiling > -EXTREME_H then
          local diff = lowest_floor + A.ceil_h
          A.ceil_h = tallest_ceiling
          if diff < 96 then
            A.ceil_h = lowest_floor + 96
          end
        end

      end
    end
  end


  local function select_porch_floor_mats(R)

    local function same_level_to_outdoor_area(A)

      for _,N in pairs(A.neighbors) do
        if N.room then
          if A.room == N.room
          and N.mode == "floor"
          and A.floor_h == N.floor_h then
            return true
          end
        end
      end

      return false
    end

    if R:get_env() ~= "outdoor" then return end

    for _,A in pairs(R.areas) do
      if A.is_porch then
        if not same_level_to_outdoor_area(A) then
          A.uses_porch_floor = true
          if not A.dead_end then
            A.floor_mat = A.porch_floor_mat
          end
        end
      end
    end

    -- second pass
    for _,A1 in pairs(R.areas) do
      if A1.uses_porch_floor and not A1.porch_floor_infected then
        for _,A2 in pairs(R.areas) do
          if A1.floor_h == A2.floor_h
          and A2.is_porch then
            A1.porch_floor_infected = true
            A2.floor_mat = A1.floor_mat
          end
        end
      end
    end
  end


  local SA -- source stair area
  local SAS -- source stair area's source area. Yes, that's not intuitive
            -- to think about, is it?

  for _,A in pairs(R.areas) do
    if area_leads_to_nowhere(A, R) then
      SA, SAS = get_area_entry_stair(A)

      gui.printf("AREA_"..A.id.." leads to nowhere. "..
      A:get_fseed_coord() .."\n")

      if SAS then
        -- convert nowhere areas to just normal areas (borrow info from main area)
        A.floor_h = SAS.floor_h
        A.ceil_h = SAS.ceil_h

        A.floor_mat = R.floor_mats[SAS.floor_h] --or SAS.floor_mat

        if A.room:get_env() == "building" then
          A.is_porch = nil
        end

        SA.mode = "floor"

        -- MSSP-FIXME: Find a better way - remove the chunk
        -- instead of giving it a stand-in prefab.
        SA.chunk.prefab_def = PREFABS["Completely_nothing"]
        SA.chunk.mode = "floor"
        SA.chunk.occupy = nil
        SA.chunk.ignore_stairs = true

        if SA.room:get_env() == "outdoor" then
          if SA.is_porch_neighbor then
            SA.is_porch = true
            SA.is_porch_neighbor = nil
          end
        elseif SA.room:get_env() == "building" then
          SA.is_porch_neighbor = nil
        end

        SA.floor_h = SAS.floor_h
        SA.ceil_h = SAS.ceil_h

        SA.floor_mat = SAS.floor_mat

        SA.floor_group = SAS.floor_group
        SA.ceil_group = SAS.ceil_group

        A.dead_end = true
        SA.dead_end = true

        -- unify heights
        if A.ceil_h - A.floor_h < 96
        or SA.ceil_h - SA.floor_h < 96 then
          A.ceil_h = A.floor_h + 96
          SA.ceil_h = A.ceil_h
        end

        -- affix textures
        if A.room:get_env() == "outdoor" then
          A.source_mat = R.floor_mats[A.floor_h] --or SAS.floor_mat 
          SA.source_mat = R.floor_mats[SA.floor_h] --or SAS.floor_mat
        end

        if A.room:get_env() == "building" then
          A.ceil_mat = R.ceil_mats[A.floor_h] --or SAS.ceil_mat
          SA.ceil_mat = R.ceil_mats[SA.ceil_h] --or SAS.ceil_mat
        end

        fixup_neighbors(A)
      end
    end
  end

  select_porch_floor_mats(R)

  --[[if not R.is_park then
    fixup_cages()
  end]]

end

------------------------------------------------------------------------

function Room_build_all(LEVEL, SEEDS)

  gui.printf("\n--==|  Build Rooms |==--\n\n")

  Area_building_facades(LEVEL)

  -- place importants early as traps need to know where they are.
  Layout_place_all_importants(LEVEL, SEEDS)

  Layout_indoor_lighting(LEVEL)

  Autodetail_get_level_svolume(LEVEL)

  -- this does traps, and may add switches which lock a door / joiner
  Layout_add_traps(LEVEL)
  Layout_decorate_rooms(LEVEL, 1, SEEDS)

  -- do doors before floor heights, they may have a delta_h (esp. joiners)
  Room_reckon_door_tex(LEVEL)
  Room_prepare_skies(LEVEL)

  Room_reckon_doors(LEVEL)
  Room_prepare_hallways(LEVEL)

  Room_floor_ceil_heights(LEVEL, SEEDS)
  Room_set_sky_heights(LEVEL)


  -- this does other stuff (crates, free-standing cages, etc..)
  Layout_decorate_rooms(LEVEL, 2, SEEDS)
  Layout_scenic_vistas(LEVEL, SEEDS)

  Room_border_up(LEVEL, SEEDS)

  Autodetail_plain_walls(LEVEL)
  Autodetail_report(LEVEL)

  Room_add_cage_rails(LEVEL)

  Layout_handle_corners(LEVEL)

  ob_invoke_hook_with_table("level_layout_finished", LEVEL) --MSSP

  gui.at_level(LEVEL.name .. " (Fabs)", LEVEL.id, #GAME.levels)
  Render_set_all_properties(LEVEL)

  Render_all_chunks(LEVEL, SEEDS)
  Render_all_areas(LEVEL, SEEDS)

  Render_triggers(LEVEL)
  Render_determine_spots(LEVEL, SEEDS)
end
