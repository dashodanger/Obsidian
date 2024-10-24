------------------------------------------------------------------------
--  LAYOUTING UTILS
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2006-2017 Andrew Apted
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


function Layout_compute_dists(R, SEEDS)
  --
  -- Compute various distances in a room:
  --
  -- (1) give each seed a 'sig_dist' value, which is roughly the #
  --     of seeds the player must walk to reach a significant thing
  --     in the room (including entry and exit points).
  --

  local function can_traverse(S, N)
    -- FIXME
    return true
  end


  local function mark_chunk(chunk)
    for sx = chunk.sx1, chunk.sx2 do
    for sy = chunk.sy1, chunk.sy2 do
      SEEDS[sx][sy].sig_dist = 0
    end
    end
  end


  local function init_sig_dists()
    for _,S in pairs(R.seeds) do
      S.sig_dist = nil

      for _,dir in pairs(geom.ALL_DIRS) do
        local E = S.edge[dir]

        if E and E.conn then
          S.sig_dist = 0.7
        end
      end
    end

    -- now check teleporters
    -- [ and exits, mainly to keep a teleporter entry far away ]

    for _,chunk in pairs(R.floor_chunks) do
      if chunk.content == "TELEPORTER" or chunk.is_bossy then
        mark_chunk(chunk)
      end
    end

    for _,chunk in pairs(R.closets) do
      if chunk.content == "TELEPORTER" then
        mark_chunk(chunk)
      end
    end

    -- finally handle goal spots
    for _,goal in pairs(R.goals) do
      if goal.chunk then
        mark_chunk(goal.chunk)
      end
    end
  end


  local function collect_fillable_seeds()
    local list = {}

    for _,S in pairs(R.seeds) do
      if S.sig_dist then goto continue end

      for _,dir in pairs(geom.ALL_DIRS) do
        local N = S:neighbor(dir, nil, SEEDS)

        if N and N.room == R and N.sig_dist and can_traverse(S, N) then
          table.insert(list, S)
          break;
        end
      end
      ::continue::
    end

    return list
  end


  local function spread_sig_dists()
    local list = collect_fillable_seeds()

    if table.empty(list) then
      return false
    end

    for _,S in pairs(list) do
      for _,dir in pairs(geom.ALL_DIRS) do
        local N = S:neighbor(dir, nil, SEEDS)

        if N and N.room == R and N.sig_dist and can_traverse(S, N) then
          S.sig_dist = math.min(N.sig_dist + 1, S.sig_dist or 999)
        end
      end

      assert(S.sig_dist)
    end

    return true
  end


  local function calc_chunk_sig_dist(chunk)
    -- compute average of all seeds in chunk
    local sum = 0
    local total = 0

    for sx = chunk.sx1, chunk.sx2 do
    for sy = chunk.sy1, chunk.sy2 do
      local dist = SEEDS[sx][sy].sig_dist

      if dist then
        sum = sum + dist
        total = total + 1
      end
    end
    end

--  stderrf("chunk %s in %s --> %1.1f / %d\n", chunk.kind or "??", R.name, sum, total)

    if total > 0 then
      chunk.sig_dist = sum / total
    end
  end


  local function visit_chunks(list)
    for _,chunk in pairs(list) do
      calc_chunk_sig_dist(chunk)
    end
  end


--[[
  local function init_wall_dists()
    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S.room ~= R then continue end

      for dir = 1,9 do if dir ~= 5 then
        local N = S:neighbor(dir)

        if not (N and N.room == R) then
          S.wall_dist = 0.5,
        end
      end end -- dir

    end -- sx, sy
    end
  end


  local function spread_wall_dists()
    local changed = false

    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S.room ~= R then continue end

      for dir = 2,8,2 do
        local N = S:neighbor(dir)
        if not (N and N.room == R) then continue end

        if S.wall_dist and S.wall_dist + 1 < (N.wall_dist or 999) then
          N.wall_dist = S.wall_dist + 1,
          changed  = true
        end
      end

    end  -- sx, sy
    end

    return changed
  end
--]]


  ---| Layout_compute_dists |---

  init_sig_dists()

  for loop = 1, 999 do
    if not spread_sig_dists() then break; end
  end

  visit_chunks(R.floor_chunks)
  visit_chunks(R.closets)
end



function Layout_spot_for_wotsit(LEVEL, R, kind, required, SEEDS)
  --
  -- Find a free chunk in the room for a certain thing
  -- (like a key, switch, weapon, starting spot, etc....).
  --
  -- If 'required' is true, produces an error when nothing
  -- can be found, otherwise NIL is returned when none left.
  --
  -- The returned chunk is either a floor chunk or a closet.
  --

  local function eval_spot(chunk)
    -- already used?
    if chunk.content then return -1 end

    if LEVEL.is_procedural_gotcha == true and PARAM.bool_boss_gen == 1 then
      if chunk.kind == "closet" then return -1 end
      if kind == "WEAPON" and PARAM.boss_gen_weap == "close" then
        for _,goal in pairs(R.goals) do
          if goal.chunk and goal.kind == "START" and
            geom.dist(chunk.mx,chunk.my,goal.chunk.mx,goal.chunk.my) > 726 then
            return -1
          end
        end
      end
    end

    -- don't place important things right over the road
    if chunk.area and chunk.area.is_road then return -1 end

    if kind == "LOCAL_SWITCH" then
      if chunk.kind ~= "closet" then return -1 end
    end

    -- when we have alternate start rooms, cannot use closets
    if kind == "START" and R.player_set then
      if chunk.kind == "closet" then return -1 end
    end

    -- handle symmetrical room
    if chunk.peer and chunk.peer.content == kind then
      return 700 + gui.random()
    end

    -- avoid using chunks right next to a connection or closet entrance
    if chunk.kind == "floor" and chunk:is_must_walk(SEEDS) then
      return 1.0 + gui.random()
    end

    -- avoid using chunks set aside for boss monsters
    if chunk.is_bossy then
      return 2.0 + gui.random()
    end

    local score = (chunk.sig_dist or 0) * 10 + 10

    -- tie breaker
    score = score + gui.random() ^ 2

    -- the exit room generally has a closet pre-booked
    if kind == "EXIT" and chunk.prefer_usage == "exit" then
      score = score + 200
    end

    -- start rooms and teleporter roots too
    if (kind == "START" or kind == "TELEPORTER") and chunk.prefer_usage == "start" then
      score = score + 200
    end

    -- really really want a secret exit in a closet
    if kind == "SECRET_EXIT" and chunk.kind == "closet" then
      score = score + 600
    end

    -- due to unusual bugs with steppy caves, 
    -- important closets are now allowed as normal in caves. -MSSP

    -- in caves, prefer spots which do not touch the room edge,
    -- and prefer not to use closets (which don't look good).
    --[[if R.is_cave then
      if chunk.kind == "closet" then
        score = score / 3
      elseif not chunk.touches_wall then
        score = score * 3
      end

      return score
    end]]

    -- in general, prefer closets over free-standing spots
    if chunk.kind == "closet" then
      score = score + 22
    end

    if chunk.sw >= 2 or chunk.sh >= 2 then
      score = score + 9
    end

    if chunk.is_straddler then
      if kind == "EXIT"  or kind == "START" or
         kind == "KEY" or kind == "SWITCH"
      then
        score = score + 41
      end
    end

    if chunk.prefer_usage and chunk.prefer_usage == kind then
      score = score * 2
    end

    return score
  end


  ---| Layout_spot_for_wotsit |---

  Layout_compute_dists(R, SEEDS)

  local best
  local best_score = 0

  -- first, try floor chunks
  for _,chunk in pairs(R.floor_chunks) do
    local score = eval_spot(chunk)

    if score > best_score then
      best = chunk
      best_score = score
    end
  end

  -- now try closets
  for _,chunk in pairs(R.closets) do
    local score = eval_spot(chunk)

    if score > best_score then
      best = chunk
      best_score = score
    end
  end


  if best then
    assert(best)

    -- never use it again
    best.content = kind

    -- ensure we cannot climb over a nearby fence
    if best.kind == "floor" then
      best.area.podium_h = 24
    end

    -- leave room for player to enter a closet
    if best.kind == "closet" then
      for _,E in pairs(best.edges) do
        Edge_mark_walk(E, SEEDS)
      end
    end

    return best
  end


  -- nothing available!

  return nil
end



function Layout_place_importants(LEVEL, R, imp_pass, SEEDS)
  --
  -- imp_pass is '1' for vital stuff (goals and teleporters)
  -- imp_pass is '2' for less vital stuff (weapons and items)
  --

  local function point_in_front_of_closet(chunk, r)
    local mx, my = chunk.mx, chunk.my

    if chunk.from_dir == 2 then return mx, chunk.y1 - r end
    if chunk.from_dir == 8 then return mx, chunk.y2 + r end

    if chunk.from_dir == 4 then return chunk.x1 - r, my end
    if chunk.from_dir == 6 then return chunk.x2 + r, my end

    error("point_in_front_of_closet : unknown dir")
  end


  local function add_goal(goal)
    local chunk = Layout_spot_for_wotsit(LEVEL, R, goal.kind, "required", SEEDS)

    if not chunk then
      gui.printf(R.id .. ": " ..
      table.tostr(R) .. "\n")
      error("No spot in room for " .. goal.kind .. " in "
      .. "ROOM_" .. R.id)
    end

-- stderrf("Layout_place_importants: goal '%s' @ %s\n", goal.kind, R.name)

    chunk.content_item = goal.item
    chunk.goal = goal

    goal.chunk = chunk

    if goal.kind ~= "START" then
      R.guard_chunk = chunk
    end

    if goal.kind == "START" then
      if not chunk.closet then
-- FIXME broken since our "spot" does not have x1/y1/x2/y2,
--        R:add_entry_spot(spot)
      end

      -- exclude monsters
      local mx, my = chunk.mx, chunk.my

      if chunk.kind == "closet" then
        mx, my = point_in_front_of_closet(chunk, 96)
      end

      if LEVEL.is_procedural_gotcha and PARAM.bool_boss_gen == 1 then
        R:add_exclusion("keep_empty", mx, my,  100)
      else
        R:add_exclusion("keep_empty", mx, my,  640)
      end
      R:add_exclusion("non_facing", mx, my, 1280)
    end
  end


  local function add_teleporter(conn)
    local chunk = Layout_spot_for_wotsit(LEVEL, R, "TELEPORTER", "required", SEEDS)

    if not chunk then
      gui.printf("Ouch oof owiee b0rkity b0rk:\n")
      gui.printf(R.id .. ": " ..
      table.tostr(R) .. "\n")
      error("No spot in room for teleporter!")
    end

    chunk.conn = conn

    -- exclude monsters from being nearby

    local mx, my = chunk.mx, chunk.my

    if chunk.kind == "closet" then
      mx, my = point_in_front_of_closet(chunk, 96)
    end

    R:add_exclusion("keep_empty", mx, my, 192)
    R:add_exclusion("non_facing", mx, my, 384)
  end


  local function add_weapon(weapon)
    local chunk = Layout_spot_for_wotsit(LEVEL, R, "WEAPON", nil, SEEDS)

    if not chunk then
      -- try to place it in a future room
      table.insert(LEVEL.unplaced_weapons, weapon)
      return
    end

    chunk.content_item = weapon

    if not R.guard_chunk then
      R.guard_chunk = spot
    end
  end


  local function add_item(item)
    local chunk = Layout_spot_for_wotsit(LEVEL, R, "ITEM", nil, SEEDS)

    if not chunk then
      warning("unable to place nice item: %s\n", item)
      return
    end

    chunk.content_item = item

    if not R.guard_chunk then
      R.guard_chunk = spot
    end
  end


  local function rank_for_weapon(name)
    local info = GAME.WEAPONS[name]
    assert(info)

    return info.level * 1000 + info.damage * info.rate + info.pref / 100
  end


  local function sort_weapons()
    -- point of this is to assign the best spots to the biggest weaps

    table.sort(R.weapons,
        function(A, B)
          return rank_for_weapon(A) > rank_for_weapon(B)
        end)
  end


  ---| Layout_place_importants |---

  if imp_pass == 1 then
    for _,tel in pairs(R.teleporters) do
      add_teleporter(tel)
    end

    for _,goal in pairs(R.goals) do
      add_goal(goal)
    end

  elseif imp_pass == 2 then
    -- try weapons which failed to be placed in the previous room
    if not table.empty(LEVEL.unplaced_weapons) then
      table.append(R.weapons, LEVEL.unplaced_weapons)
      LEVEL.unplaced_weapons = {}
    end

    sort_weapons()

    for _,name in pairs(R.weapons) do
      add_weapon(name)
    end

    for _,name in pairs(R.items) do
      add_item(name)
    end

  else
    error("bad imp_pass")
  end
end



function Layout_place_hub_gates(LEVEL, SEEDS)
  -- this also does secret exit closets

  local function num_free_chunks(list)
    local count = 0

    for _,chunk in pairs(list) do
      if chunk.content == nil
      or chunk.content == "DECORATION" then
        count = count + 1
      end
    end

    return count
  end


  local function eval_closet_room(R)
    local free_spots = num_free_chunks(R.closets)

    if free_spots == 0 then return -1 end

    local score = 0

    if R.is_secret then
      score = 300
    elseif not (R.is_start or R.is_exit) then
      score = 200
    end

    -- prefer it near the end of the map
    if R.lev_along > 0.7 then
      score = score + 50
    elseif R.lev_along > 0.4 then
      score = score + 20
    end

    -- prefer leaving some closets for other things
    score = score + math.clamp(1, free_spots, 7)

    -- tie breaker
    return score + gui.random() * 0.5
  end


  local function eval_free_standing_room(R)
    local free_spots = num_free_chunks(R.floor_chunks)

    if free_spots == 0 then return -1 end

    local score = 0

    if R.is_secret then
      score = 300
    elseif not (R.is_start or R.is_exit) then
      score = 200
    elseif #R.goals == 0 then
      score = 100
    end

    -- check number of spots against what will be needed
    -- [ we reach this function due to a dearth of closets.... ]
    local need_spots = #R.goals + #R.teleporters

    if R.is_start then need_spots = need_spots + 1 end

    if free_spots > need_spots then
      score = score + 50
    end

    -- prefer it near the end of the map
    if R.lev_along > 0.7 then
      score = score + 20
    elseif R.lev_along > 0.4 then
      score = score + 10
    end

    -- prefer leaving some closets for other things
    score = score + math.clamp(1, free_spots, 7)

    -- tie breaker
    return score + gui.random() * 0.5
  end


  local function make_secret_exit(R)
    gui.printf("Secret Exit: %s (in a closet)\n", R.name)

    -- should not fail, as our eval function detects free spots
    local chunk = Layout_spot_for_wotsit(LEVEL, R, "SECRET_EXIT", "required", SEEDS)

    chunk.content = "SECRET_EXIT"

    -- mark the closet as hidden in the room
    chunk.is_secret = true
  end


  local function add_secret_closet()
    local best_R
    local best_score = 0

    for _,R in pairs(LEVEL.rooms) do
      local score = eval_closet_room(R)

      if score > best_score then
        best_R = R
        best_score = score
      end
    end

    if not best_R then
      return false
    end

    make_secret_exit(best_R)
    return true
  end


  local function add_secret_switch()
    local best_R
    local best_score = 0

    for _,R in pairs(LEVEL.rooms) do
      local score = eval_free_standing_room(R)

      if score > best_score then
        best_R = R
        best_score = score
      end
    end

    if not best_R then
      warning("could not add a secret exit to the map!\n")
      return
    end

    make_secret_exit(best_R)
  end


  ---| Layout_place_hub_gates |---

  if LEVEL.need_secret_exit then
    if not add_secret_closet() then
      -- invoke plan C : make a secret switch somewhere
      add_secret_switch()
    end
  end
end



function Layout_place_all_importants(LEVEL, SEEDS)
  -- do hub gates and secret exit closets
  -- [ do this first, since these require closets, whereas normal
  --   starts and exits and goals can be placed without closets ]
  Layout_place_hub_gates(LEVEL, SEEDS)

  for _,R in pairs(LEVEL.rooms) do
    if R.is_hallway then goto continue end
    Layout_place_importants(LEVEL, R, 1, SEEDS)
    ::continue::
  end

  for _,R in pairs(LEVEL.rooms) do
    if R.is_hallway then goto continue end
    Layout_place_importants(LEVEL, R, 2, SEEDS)
    ::continue::
  end

  -- warn about weapons that could not be placed anywhere
  for _,weapon in pairs(LEVEL.unplaced_weapons) do
    warning("unable to place weapon: %s!\n", weapon)
  end
end



function Layout_choose_face_area(A)
  -- used for scenic liquid pools

  local best
  local best_score = -1

  for _,N in pairs(A.neighbors) do
    if not N.room then goto continue end
    if not N.is_outdoor then goto continue end

    if N.mode ~= "floor" then goto continue end
    if not N.floor_h then goto continue end

    if N.zone ~= A.zone then goto continue end

    if N.room.is_hallway then goto continue end

    -- ok --

    local junc = Junction_lookup(LEVEL, A, N)

    local score = junc.perimeter + 2.2 * gui.random() ^ 3

    if score > best_score then
      best = N
      best_score = score
    end
    ::continue::
  end

  return best
end



function Layout_add_traps(LEVEL)
  --
  -- Add traps to rooms, especially monster closets.
  --

  local function eval_trap_distance(R, chunk)
    -- compute a distance to the room's goal
    local dist = 0

    if R.guard_chunk then
      local dx = math.abs(R.guard_chunk.mx - chunk.mx)
      local dy = math.abs(R.guard_chunk.my - chunk.my)

      dist = (dx + dy) / SEED_SIZE
    end

    -- tie breaker
    chunk.trap_dist = dist + (gui.random() ^ 2) * 16
  end


  local function locs_for_room(R, kind)
    -- kind is either "closet" or "teleport".
    -- returns a list of all possible monster closets / teleport spots.
    -- [ in symmetrical rooms, peered closets only return a single one ]

    if R.is_secret then return nil end

    local locs = {}

    if kind == "closet" then
      for _,chunk in pairs(R.closets) do
        if not chunk.content and not chunk:is_slave() then
          eval_trap_distance(R, chunk)
          table.insert(locs, chunk)
        end
      end

      table.sort(locs,
          function(A, B) return A.trap_dist < B.trap_dist end)

    elseif kind == "teleport" then

      -- large chunks are better, so place them first in the list
      local locs2 = {}

      for _,chunk in pairs(R.floor_chunks) do
        -- MSSP-FIXME: instead of not placing teleporter traps on road areas,
        -- find a way to keep the sink rendered
        if not chunk.content and not chunk.area.is_road then
          if chunk.sw >= 2 and chunk.sh >= 2 then
            eval_trap_distance(R, chunk)
            table.insert(locs, chunk)
          else
            eval_trap_distance(R, chunk)
            table.insert(locs2, chunk)
          end
        end
      end

      table.sort(locs,
        function(A, B) return A.trap_dist > B.trap_dist end)
      table.sort(locs2,
        function(A, B) return A.trap_dist > B.trap_dist end)

      table.append(locs, locs2)

    else
      error("locs_for_room: unknown kind")
    end

    if table.empty(locs) then return nil end

    if kind == "teleport" and #locs < 3 then return nil end

    return locs
  end


  local function fake_backtrack(R)
    -- this is used for trapped items
    -- [ goals have "real" backtracking info ]

    local result = {}

    if #R.conns == 1 then
      local C = R.conns[1]
      R = C:other_room(R)
      table.insert(result, R)
    end

    return result
  end

 -- Closet and teleporter traps

  local function closet_dice(R, is_same)
    -- chance of using a monster closet to release monsters
    local prob

    if R.is_cave then
      prob = style_sel("traps", 0,  2,  5, 15)
      --prob = style_sel("traps", 0,  0,  5, 15)
    elseif is_same then
      prob = style_sel("traps", 0, 20, 40, 70)
      --prob = style_sel("traps", 0, 25, 50, 85)
    else
      prob = style_sel("traps", 0, 10, 25, 55)
      --prob = style_sel("traps", 0, 15, 30, 70)
    end

    return rand.odds(prob)
  end


  local function teleport_dice(R, is_same)
    -- chance of using teleporting-in monsters
    local prob

    if is_same and not R.is_cave then
      prob = style_sel("traps", 0,  3, 12, 25)
      --prob = style_sel("traps", 0,  2, 10, 20)
    else
      prob = style_sel("traps", 0,  10, 33, 66)
      --prob = style_sel("traps", 0,  8, 25, 50)
    end

    return rand.odds(prob)
  end


  local function places_for_backtracking(R, backtrack, p_kind)
    --
    -- The main thing this does is pick which rooms to trap up and
    -- which ones to skip.  This is where the style is applied.
    --
    -- p_kind is either "goal", "item" or "weapon".
    --

--[[  REVIEW this....
    if p_kind == "weapon" then
      same_prob = same_prob * 1.5,
    end
--]]

    -- create list of potential rooms for da monsters
    local places = {}

    if not R.is_start then
      table.insert(places, { room=R })
    end

    for _,N in pairs(backtrack) do
      table.insert(places, { room=N })
    end

    -- visit each place, decide what method to use (or to skip it)
    local result = {}

    for _,info in pairs(places) do
      local closet_locs
      local  telep_locs

      local is_same = (info.room == R)

      --default Oblige actions when Trap Styles isn't used.

      if OB_CONFIG.trap_style == "default" or OB_CONFIG.trap_style == nil then

        if closet_dice(info.room, is_same) then
          closet_locs = locs_for_room(info.room, "closet")
        end

        if teleport_dice(info.room, is_same) then
          telep_locs = locs_for_room(info.room, "teleport")
        end
      end


      --selecting based on ratio

      local prob_tab =
      {
        closets = 0,
        ["80"] = 20,
        ["60"] = 40,
        ["40"] = 60,
        ["20"] = 80,
        teleports = 100
      }

      if OB_CONFIG.trap_style ~= nil and OB_CONFIG.trap_style ~= "default" then
        if rand.odds(prob_tab[OB_CONFIG.trap_style]) then
          if teleport_dice(info.room, is_same) then
            telep_locs = locs_for_room(info.room, "teleport")
          end
        else
          if closet_dice(info.room, is_same) then
            closet_locs = locs_for_room(info.room, "closet")
          end
        end
      end


      -- break ties
      -- [ but in caves, prefer teleporting in ]
      if closet_locs and telep_locs then
        if info.room.is_cave or rand.odds(40) then
          closet_locs = nil
        else
          telep_locs = nil
        end
      end

      if closet_locs then
        info.kind = "closet"
        info.locs = closet_locs

      elseif telep_locs then
        info.kind = "teleport"
        info.locs = telep_locs
      end

--[[ QUANTITY DEBUG
gui.debugf("MonRelease in %s : kind --> %s\n",
           sel(info.room == R, "SAME", "EARLIER"),
           info.kind or "NOTHING")
--]]

      if info.locs then
        table.insert(result, info)
      end
    end

    return result
  end


  local function make_closet_trap(closet, trig)
    closet.content = "TRAP"
    closet.trigger = trig

    if closet.peer and not closet.peer.content then
      closet = closet.peer

      closet.content = "TRAP"
      closet.trigger = trig
    end
  end


  local function make_teleport_trap(chunk, trig)
    chunk.content = "MON_TELEPORT"
    chunk.trigger = trig
    chunk.out_tag = alloc_id(LEVEL, "tag")
  end


  local function fix_mirrored_trap(chunk, trig)
    if chunk.peer and not chunk.peer.content then
      chunk = chunk.peer

      -- using "NOTHING" is not enough (sinks would still be made)
      chunk.content = "MON_TELEPORT"
      chunk.trigger = trig
      chunk.out_tag = 9999  -- a dummy tag (never referenced)
    end
  end


  local function install_a_closet_trap(info, trig)
    local R    = info.room
    local locs = info.locs

    rand.shuffle(locs)

    local qty = rand.index_by_probs({ 40,40,20,5 })

    if STYLE.traps == "few"   then math.round((qty + 1) / 2) end
    if STYLE.traps == "more"  then qty = qty + 1 end
    if STYLE.traps == "heaps" then qty = qty + 2 end

    for i = 1, qty do
      if locs[i] then
        make_closet_trap(locs[i], trig)
      end
    end
  end


  -- MSSP: distance function just to be used for the teleporter
  -- trap stuff below.
  local function get_chunk_distance(chunk1, chunk2)
    local dist

    dist = geom.dist(chunk1.mx, chunk1.my, chunk2.mx, chunk2.my)

    return dist
  end


  local function install_a_teleport_trap(info, trig)
    local R    = info.room
    local locs = info.locs
    local total_exits = rand.pick({2,3,4})

    local DEPOT = Seed_alloc_depot(LEVEL, R)

    if not DEPOT then
      gui.debugf("Cannot make teleportation trap: out of depots\n")
      return
    end

    DEPOT.skin.trap_tag = trig.tag

    -- MSSP: Stop using chunks right in front of the player for telepoter spots
    -- MSSP-TODO: Revise the code to sort spots by their distance.
    if #R.triggers > 0 then

      for n = 1, #R.triggers do
        if R.triggers[n] then
          local o = 1
          while locs[o] do

            if #locs < total_exits then break end

            local spot_dist = get_chunk_distance(R.triggers[n].spot, locs[o])

            if spot_dist <= 1024 then
              table.remove(locs, o)
            else
              o = o + 1
            end

          end
        end
      end
    end


    -- re-use some chunks if there are less than three
    if #locs < 2 then table.insert(locs, locs[1]) end
    if #locs < 3 then table.insert(locs, locs[2]) end

    for n = 1, 3 do
      if locs[n].sw < 2 or locs[n].sh < 2 then
        DEPOT.max_spot_size = 64
      end
    end

    local chunk1 = table.remove(locs, 1)
    local chunk2 = table.remove(locs, 1)
    local chunk3 = table.remove(locs, 1)    
    local chunk4 = table.remove(locs, 1)

    -- in a symmetrical room, try to use a peered chunk
    if chunk1.peer and not chunk1.peer.content then
      chunk3 = chunk1.peer
    elseif chunk2.peer and not chunk2.peer.content then
      chunk3 = chunk2.peer
    elseif chunk3.peer and not chunk3.peer.content then
      chunk2 = chunk3.peer
    elseif chunk4 and chunk4.peer and not chunk4.peer.content then
      chunk3 = chunk4.peer
    end

    make_teleport_trap(chunk1, trig)
    make_teleport_trap(chunk2, trig)
    make_teleport_trap(chunk3, trig)
    if chunk4 then make_teleport_trap(chunk4, trig) end

    DEPOT.skin.out_tag1 = chunk1.out_tag
    DEPOT.skin.out_tag2 = chunk2.out_tag
    DEPOT.skin.out_tag3 = chunk3.out_tag
    if chunk4 then DEPOT.skin.out_tag4 = chunk4.out_tag end

    -- this is to prevent non-symmetrical sinks or decor prefabs
    fix_mirrored_trap(chunk1, trig)
    fix_mirrored_trap(chunk2, trig)
    fix_mirrored_trap(chunk3, trig)
    if chunk4 then fix_mirrored_trap(chunk4, trig) end
  end


  local function install_a_trap(places, trig)
    trig.action = "W1_OpenDoorFast"
    trig.tag = alloc_id(LEVEL, "tag")

    for _,info in pairs(places) do
      if info.kind == "teleport" then
        install_a_teleport_trap(info, trig)
      else
        install_a_closet_trap(info, trig)
      end
    end
  end


  local function trigger_for_entry(R)
    local C = R.entry_conn

    if not C then return nil end

    if C.kind == "teleporter" then
      -- TODO : find teleporter chunk
      return nil
    end

    -- split conn?  [ TODO : return a list of TRIGs ]
    if C.F1 then return nil end

    local E = C.E1
    if C.R2 == R then E = C.E2 end

    if not E then return nil end

    local TRIG =
    {
      kind = "edge",
      edge = E
    }

    table.insert(R.triggers, TRIG)

    return TRIG
  end


  -- TODO : trigger_for_exit(R)


  local function trigger_for_chunk(R, chunk)
    local TRIG

    if chunk.kind == "closet" then
      if not chunk.edges then return nil end

      TRIG =
      {
        kind = "edge",
        edges = chunk.edges,
        spot = chunk
      }
    else
      TRIG =
      {
        kind = "spot",
        spot = chunk
      }
    end

    table.insert(R.triggers, TRIG)

    return TRIG
  end


  local function trap_up_goal(R)
    if table.empty(R.goals) then return end

    local goal = rand.pick(R.goals)

    -- do not trap the exit switch, as player may exit too soon and
    -- not notice the released monsters
    if goal.kind == "START" or
       goal.kind == "EXIT" or
       goal.kind == "SECRET_EXIT"
    then
      return
    end

    local places = places_for_backtracking(R, goal.backtrack, "goal")
    if table.empty(places) then return end

    local trig = trigger_for_chunk(R, assert(goal.chunk))
    if not trig then return end

    install_a_trap(places, trig)
  end


  local function eval_item_for_trap(chunk)
    -- returns a probability

    if chunk.content == "WEAPON" or
       chunk.content == "ITEM"
    then
      -- ok
    else
      return -1
    end

    local prob
    local item = assert(chunk.content_item)

    if table.has_elem(LEVEL.new_weapons, item) then
      prob = 99
    -- very rarely trap weapons you already have
    elseif chunk.content == "WEAPON" then
      prob = 1
    else
      prob = 60
    end

    if not rand.odds(prob) then return -2 end

    -- tie breaker
    return 1 + gui.random()
  end


  local function trap_up_item(R)
    if R.is_start  then return end
    if R.is_secret then return end

    -- pick an item to target

    local ch_list = table.copy(R.floor_chunks)
    table.append(ch_list, R.closets)

    local best
    local best_score = -1

    for _,chunk in pairs(ch_list) do
      local score = eval_item_for_trap(chunk)
      if score > best_score then
        best = chunk
        best_score = score
      end
    end

    if not best then return end

    -- determine places and trigger, and install trap
    local p_kind = "item"

    if best.content == "WEAPON" then
      p_kind = "weapon"
    end

    local places = places_for_backtracking(R, fake_backtrack(R), p_kind)
    if table.empty(places) then return end

    local trig = trigger_for_chunk(R, best)
    if not trig then return end

    install_a_trap(places, trig)
  end


  ---| Layout_add_traps |---

  if STYLE.traps == "none" then return end

  for _,R in pairs(LEVEL.rooms) do
    if not R.is_sub_room then
      trap_up_goal(R)
    end
  end

  for _,R in pairs(LEVEL.rooms) do
    if not R.is_sub_room then
      trap_up_item(R)
    end
  end
end



function Layout_decorate_rooms(LEVEL, pass, SEEDS)
  --
  -- Decorate the rooms with crates, pillars, etc....
  --
  -- The 'pass' parameter is 1 for early pass, 2 for later pass.
  --
  -- Also handles all the unused closets in a room, turning them
  -- into cages, secret items (etc).
  --

  local function make_cage(chunk)
    -- select cage prefab
    local A = chunk.area
    local reqs

    if chunk.kind == "closet" then
      reqs = chunk:base_reqs(chunk.from_dir)

      reqs.kind  = "cage"
      reqs.shape = "U"   -- TODO: chunk.shape

      chunk.prefab_dir = chunk.from_dir

    else  -- free standing
      reqs =
      {
        kind  = "cage",
        where = "point",

        size  = assert(chunk.space)
      }

      -- FIXME : hack for caves
      if A.room.is_cave then
        reqs.height = A.room.walkway_height
      elseif A.room.is_park then
        reqs.height = A.zone.sky_h
      else
        reqs.height = A.ceil_h - A.floor_h
      end
    end

    if chunk.ceil_above then reqs.filled_ceiling = true end

    if A.room then
      reqs.env = A.room:get_env()

      if A.room.theme.theme_override then
        reqs.theme_override = A.room.theme.theme_override
      end
    end

    local prefab_def = Fab_pick(LEVEL, reqs, "allow_none")

    -- nothing matched?
    if not prefab_def then return end

    chunk.content    = "CAGE"
    chunk.prefab_def = prefab_def

    if prefab_def.plain_ceiling then
      chunk.floor_below = true
    end

    -- in symmetrical rooms, handle the peer too
    if chunk.peer and not chunk.peer.content then
      local peer = chunk.peer

      peer.content    = chunk.content
      peer.prefab_def = chunk.prefab_def

      if prefab_def.plain_ceiling then
        peer.floor_below = true
      end

      if chunk.kind ~= "closet" and chunk.prefab_dir then
        local A = chunk.area
        assert(A.room.symmetry)
        peer.prefab_dir = A.room.symmetry:conv_dir(chunk.prefab_dir)
      end
    end
  end


  local function make_secret_closet(chunk, item)
    chunk.content = "ITEM"
    chunk.content_item = item

    chunk.is_secret = true

    -- code in render.lua selects the actual prefab
  end


  local function kill_closet(chunk)
    chunk.area.mode = "void"
    chunk.content = "void"

    -- TODO : sometimes make a picture

    for _,E in pairs(chunk.edges) do
      E.kind = "ignore"
    end
  end


  local function joiner_not_large(C)
    if not C.joiner_chunk then return true end

    local vol = C.joiner_chunk.sw * C.joiner_chunk.sh

    return vol < 4
  end


  local function try_intraroom_lock(R)
    -- try to lock an unlocked exit and place switch for it

    if R.is_start then return end
    if R.is_exit  then return end

   -- Andrew's commit f9a3082ea000, October 20th

    -- when there is an alternate start room, ensure we don't block the
    -- path of a single player (who may begin on the wrong side).
    if LEVEL.alt_start and
       (R.zone == LEVEL.start_room.zone or
        R.zone == LEVEL.alt_start.zone)
    then
      return
    end

  -- End commit

    local conn_list = {}

    for _,C in pairs(R.conns) do
      local N = C:other_room(R)

      if (C.kind == "edge" or C.kind == "joiner" or C.kind == "terminator") and
         not C.lock and
         not (N.is_secret or R.is_secret) and
         not N.is_start and
         N.lev_along > R.lev_along and
         joiner_not_large(C)
      then
        table.insert(conn_list, C)
      end
    end

    if table.empty(conn_list) then return end

    local chunk = Layout_spot_for_wotsit(LEVEL, R, "LOCAL_SWITCH", nil, SEEDS)

    if not chunk then return end

    -- Ok, can make it

    local C = rand.pick(conn_list)

    local goal = Goal_new(LEVEL, "LOCAL_SWITCH")

    goal.item = "sw_metal"
    goal.room = R
    goal.tag  = alloc_id(LEVEL, "tag")

    chunk.goal = goal

    local lock = Lock_new(LEVEL, "intraroom", C)

    lock.conn  = C
    lock.goals = { goal }
  end


  local function try_lock_item(R)
    -- convert a key (etc) goal into a lowering pedestal with a
    -- switch to find.

    local item

    for _,chunk in pairs(R.floor_chunks) do
      if chunk.kind == "floor" and chunk.content == "KEY" and not chunk.lock then
        item = chunk
        break;
      end
    end

    if not item then return end

    -- see if we can place a switch
    local chunk = Layout_spot_for_wotsit(LEVEL, R, "LOCAL_SWITCH", nil, SEEDS)

    if not chunk then return end

    -- OK --

    local goal = Goal_new(LEVEL, "LOCAL_SWITCH")

    goal.item = "sw_metal"
    goal.room = R

    goal.tag = alloc_id(LEVEL, "tag")

    chunk.goal = goal

    local lock = Lock_new(LEVEL, "itemlock")

    lock.goals = { goal }
    lock.item  = item

    item.lock = lock
  end


  local function analyse_chunk_sinkage(chunk, where)
    --
    -- returns a three digit string, each digit represents a particular
    -- part of the chunk (middle, sides, corners).
    --
    -- each digit is 0 if not part of the sink (at all), 1 if partially
    -- part of a sink, and 2 if completely part of the sink.
    --
    -- e.g. "000" --> not touching the sink at all
    --      "222" --> the whole chunk is in the sink
    --      "200" --> only middle part is in the sink
    --      "022" --> only outer parts are in the sink (an island)
    --

    local   area_field = where .. "_group"
    local corner_field = where .. "_inner"

    if not chunk.area[area_field]      then return "000" end
    if not chunk.area[area_field].sink then return "000" end

    local  mid_count,  mid_total = 0, 0
    local side_count, side_total = 0, 0
    local corn_count, corn_total = 0, 0

    local cx1 = chunk.sx1
    local cy1 = chunk.sy1
    local cx2 = chunk.sx2 + 1
    local cy2 = chunk.sy2 + 1

    for cx = cx1, cx2 do
    for cy = cy1, cy2 do
      local corner = Corner_lookup(LEVEL, cx, cy)
      assert(corner)

      local A = corner[corner_field]

      local ox = (cx == cx1 or cx == cx2)
      local oy = (cy == cy1 or cy == cy2)

      if ox and oy then
        corn_count = corn_count + sel(A, 1, 0)
        corn_total = corn_total + 1

      elseif ox or oy then
        side_count = side_count + sel(A, 1, 0)
        side_total = side_total + 1

      else
        mid_count = mid_count + sel(A, 1, 0)
        mid_total = mid_total + 1
      end
    end
    end

    local function part_to_str(count, total)
      if count == 0 then return "0" end
      if count == total then return "2" end
      return "1"
    end

    return part_to_str( mid_count,  mid_total) ..
           part_to_str(side_count, side_total) ..
           part_to_str(corn_count, corn_total)
  end


  local function try_decoration_in_chunk(chunk, is_cave)

    if chunk.sw < 2 then return end
    if chunk.sh < 2 then return end

    -- only try mirrored chunks *once*
    if chunk:is_slave() then return end

    -- don't put bloody shit in the player's way
    if chunk:is_must_walk(SEEDS) then return end
    if chunk.peer and chunk.peer:is_must_walk(SEEDS) then return end

    local A = chunk.area

    local reqs =
    {
      kind  = "decor",
      where = "point",

      size   = assert(chunk.space)
    }

    -- control check for Epic Textures module environment theme,
    -- if available -MSSP
    if PARAM.environment_themes then
      if A.is_outdoor then
        reqs.outdoor_theme = LEVEL.outdoor_theme
      end
    end

    if is_cave then
      reqs.height = A.room.walkway_height
    else
      reqs.height = A.ceil_h - A.floor_h

      if A.ceil_group and A.ceil_group.sink then
        local sink = A.ceil_group.sink
        local diff = math.min(sink.dz or 0, sink.trim_dz or 0)

        if diff > 0 then diff = 1 end

        reqs.height = reqs.height - math.abs(diff) - 1
      end
    end

    if A.room then
      reqs.env = A.room:get_env()

      if A.room.theme.theme_override then
        reqs.theme_override = A.room.theme.theme_override
      end

    end

    -- hack for porches, because it's weird to see tree planters
    -- under them -MSSP
    if A.is_porch then
      reqs.env = "building"
    end

    if A.is_road then return end

    local sinkstat = analyse_chunk_sinkage(chunk, "floor")

    if sinkstat ~= "000" then
      -- require middle of chunk to be in the sink
      if string.sub(sinkstat, 1, 1) ~= "2" then return end

      -- ignore very small sinks (limited to just this chunk)
      if string.sub(sinkstat, 1, 1) == "0" then return end

      reqs.is_sink = "plain"

      -- check if the sink is a liquid material
      if A.floor_group and A.floor_group.sink then
        if A.floor_group.sink.mat == "_LIQUID" then
          reqs.is_sink = "liquid"
        end

        if A.floor_group.sink.mat == "_SKY" then
          reqs.is_sink = "sky"
        end

        -- check for when sinks have predefined liquids
        local liq_mat = A.floor_group.sink.mat
        if GAME.LIQUIDS[liq_mat] then
          reqs.is_sink = "liquid"
        end
      end

      -- reduce maximum size unless *whole* chunk is in the sink
      if sinkstat ~= "222" then
        reqs.size = 64
      end
    end

    -- check for wall group to decor assocation
    if A.floor_group and A.floor_group.wall_group then
      reqs.group = A.floor_group.wall_group
    end

    local def = Fab_pick(LEVEL, reqs, "none_ok")

    -- remove group requirement if no fab was found and try again
    if not def then
      reqs.group = nil
      def = Fab_pick(LEVEL, reqs, "none_ok")
    end

    -- GIVE IT UP, MAN, JUST GIVE THE F UP!
    if not def then return end

    -- don't create pillars under ceiling sinks
    -- TODO : allow it in certain circumstances
    -- FIXME: use 'reqs' to prevent picking them at all
    if def.z_fit and chunk.ceil_above and chunk.ceil_above.content then
      return
    end

    -- for stuff in a sink, ensure it is built at correct Z height
    if reqs.is_sink and chunk.area.floor_group.sink then
      chunk.floor_dz = chunk.area.floor_group.sink.dz
    end

    chunk.content = "DECORATION"
    chunk.prefab_def = def
    chunk.prefab_dir = rand.dir()

    -- prevent pillars clobbering ceiling lights
    if def.z_fit and chunk.ceil_above then
      chunk.ceil_above.content = "NOTHING"
    end

    if chunk.peer and not chunk.peer.content then
      assert(A.room.symmetry)
      local peer = chunk.peer

      peer.content = chunk.content
      peer.prefab_def   = chunk.prefab_def
      peer.prefab_dir   = A.room.symmetry:conv_dir(chunk.prefab_dir)

      if def.z_fit and peer.ceil_above then
        peer.ceil_above.content = "NOTHING"
      end
    end
  end


  local function switch_up_room(R)
    -- locking exits and items

    if THEME.no_switches then return end
    local switch_prob = style_sel("local_switches", 0, 20, 40, 80)

    for loop = 1, 2 do
      if rand.odds(switch_prob) then
        try_lock_item(R)
        try_intraroom_lock(R)
      end
    end
  end


  local function pick_cage_spot(locs)
    local best
    local best_score = -1

    for _,chunk in pairs(locs) do
      local score = gui.random()

      if chunk.kind == "closet" then score = score * 3 end

      if score > best_score then
        best = chunk
        best_score = score
      end
    end

    return assert(best)
  end


  local function extra_cage_prob(R, locs)
    --
    -- Factors determining the probability:
    --   (a) the "cages" style
    --   (b) number of existing cages (ones grown from rules)
    --   (c) the "pressure" value of the room
    --   (d) a dose of randomness
    --

    if #locs == 0 then return 0 end

    -- determine current quantity of free-range cages
    local cage_vol = 0

    for _,A in pairs(R.areas) do
      if A.mode == "cage" then
        cage_vol = cage_vol + A.svolume
      end
    end

    cage_vol = cage_vol / R:calc_walk_vol()

--- stderrf("Cage vol = %1.2f  in %s\n", cage_vol, R.name)


    local any_prob = style_sel("cages", 0, 40, 70, 90)

    if R.pressure == "high" or rand.odds(20) then any_prob = any_prob * 1.5 end
    if R.pressure == "low"  or rand.odds(10) then any_prob = any_prob / 2.5 end

    if not rand.odds(any_prob) then return 0 end


    -- fairly rare in caves
    if R.is_cave then return 10 end


    local per_prob = style_sel("cages", 0, 15, 30, 60)

    per_prob = per_prob * (1 - cage_vol * 4)
    per_prob = per_prob * rand.pick({ 0.7, 0.9, 1.1, 1.4 })

    per_prob = math.clamp(1, per_prob, 99)

--[[ DEBUG
stderrf("Cages in %s [%s pressure] --> any_prob=%d  per_prob=%d\n",
        R.name, R.pressure, any_prob, per_prob)
--]]

    return per_prob
  end


  local function try_extra_cages(R)
    -- never have cages in a start room, or secrets
    if R.is_start  then return end
    if R.is_secret then return end

    -- collect usable chunks
    local locs = {}

    for _,chunk in pairs(R.floor_chunks) do
      local A = chunk.area

      if not chunk.content and not chunk.is_bossy and
         not chunk:is_slave() and
         not chunk:is_must_walk(SEEDS) and
         (not chunk.peer or not chunk.peer:is_must_walk(SEEDS)) and
         chunk.sw >= 2 and chunk.sh >= 2 and
         not chunk.content and
         not (A.floor_group and A.floor_group.sink) and
         rand.odds(35)
      then
        table.insert(locs, chunk)
      end
    end

    for _,chunk in pairs(R.closets) do
      if not chunk.content and not chunk:is_slave() then
        table.insert(locs, chunk)
      end
    end

    -- decide probability (for use in each spot)
    -- [ not using a quota here -- tried it and it was too non-random ]
    local prob = extra_cage_prob(R, locs)

    -- make the cages
    for _,chunk in pairs(locs) do
      if rand.odds(prob) then
        make_cage(chunk)
      end
    end
  end


  local function try_secret_closets(R)
    if table.empty(R.closet_items) then return end

    local locs = {}

    for _,chunk in pairs(R.closets) do
      if not chunk.content then
        table.insert(locs, chunk)
      end
    end

    -- WISH : prefer chunks which are not near each other
    --        [ or: larger chunks ]
    rand.shuffle(locs)

    for _,item in pairs(R.closet_items) do
      if table.empty(locs) then break; end

      local chunk = table.remove(locs, 1)

      make_secret_closet(chunk, item)
    end
  end


  local function try_make_decor_closet(R, chunk)
    local reqs = chunk:base_reqs(chunk.from_dir)

    -- TODO : REVIEW THIS
    --        [ probably should be "decor" once have a proper picture system ]
    reqs.kind  = "picture"
    reqs.env = R:get_env()

    if R.theme.theme_override then
      reqs.theme_override = R.theme.theme_override
    end

    -- wall group association assocation
    if chunk.from_area.floor_group and chunk.from_area.floor_group.wall_group then
      reqs.group = chunk.from_area.floor_group.wall_group
    end

    if chunk.from_area.is_porch or chunk.from_area.is_porch_neighbor then
      reqs.porch = true
      reqs.height = chunk.from_area.ceil_h - chunk.from_area.floor_h
    end

    if R.is_cave then
      reqs.height = R.walkway_height
    end

    if R.is_park then
      -- no actual height information at this stage apparently
      -- re-decided in render_chunk instead if required
      reqs.height = EXTREME_H

      if R.is_natural_park then
        reqs.group = "natural_walls"
      end
    end

    chunk.prefab_def = Fab_pick(LEVEL, reqs, "none_ok")

    if not chunk.prefab_def then
      reqs.group = nil
      chunk.prefab_def = Fab_pick(LEVEL, reqs, "none_ok")
    end

    if not chunk.prefab_def then
      return
    end

--stderrf("decor closet : %s\n", chunk.prefab_def.name)

    chunk.content = "DECORATION"

--????  chunk.prefab_dir = chunk.from_dir

    -- in symmetrical rooms, handle the peer too
    if chunk.peer and not chunk.peer.content then
      local peer = chunk.peer

      peer.content = chunk.content
      peer.prefab_def   = chunk.prefab_def
    end
  end


  local function try_decor_closets(R)
    local locs = {}

    if not R.closet_mode then
      if not rand.odds(style_sel("pictures", 0, 45, 75,100)) 
      and not R.no_decor_closets then
        R.closet_mode = "no_closets"
      else
        R.closet_mode = "has_closets"
      end
    end

    if R.closet_mode and R.closet_mode == "no_closets" then
      return
    end

    for _,chunk in pairs(R.closets) do
      if not chunk.content then
        table.insert(locs, chunk)
      end
    end

    rand.shuffle(locs)

    local use_prob = 100

    for _,chunk in pairs(locs) do
      if rand.odds(use_prob) then
        try_make_decor_closet(R, chunk)
      end
    end
  end


  local function try_secondary_importants(R)
    if not R.secondary_important then return end

    gui.printf(R.secondary_important.kind .. " placed in ROOM_" .. R.id .. "\n")
    
    local usable_chunks = {}
    local preferred_chunk
    local def

    for _,chunk in pairs(R.closets) do
      if (not chunk.content or chunk.content == "DECORATION")
      and not chunk:is_slave() then
        table.insert(usable_chunks, chunk)
      end
    end

    -- no chunks to place important in for some reason...
    if table.empty(usable_chunks) then return end

    preferred_chunk = rand.pick(usable_chunks)
    -- gui.printf(table.tostr(usable_chunks,2))

    reqs = preferred_chunk:base_reqs(preferred_chunk.from_dir)

    reqs.kind = "sec_quest"
    reqs.group = R.secondary_important.kind
    reqs.shape = "U"

    def = Fab_pick(LEVEL, reqs)

    if def then preferred_chunk.prefab_def = def end
  end


  local function pick_wall_detail(R)
    if R.is_cave    then return end
    if R.is_outdoor then return end

    local tab = R.theme.wall_groups or THEME.wall_groups

    if not R.theme.wall_groups and R.theme.theme_override then
      tab = GAME.THEMES[ob_resolve_theme_keyword(R.theme.theme_override)].wall_groups
    end

    if R.forced_wall_groups then
      tab = R.forced_wall_groups
    end

    if not tab then return end

    local prob = THEME.wall_group_prob or 35
    if LEVEL.autodetail_group_walls_factor then
      prob = prob - math.clamp(0, LEVEL.autodetail_group_walls_factor, 35)
    end

    if PARAM.group_wall_prob and PARAM.group_wall_prob ~= "fab_default" then
      local mult = 1
      if THEME.plain_wall_multiplier then
        mult = THEME.plain_wall_multiplier
      end
      prob = prob * (PREFAB_CONTROL.WALL_GROUP_ODDS[PARAM.group_wall_prob] 
      or 1) * mult
    end

    prob = math.clamp(0, prob, 100)

    for _,fg in pairs(R.floor_groups) do
      if rand.odds(prob) then
        fg.wall_group = rand.key_by_probs(tab)
        if not PARAM.bool_avoid_wall_group_reuse
        or (PARAM.bool_avoid_wall_group_reuse
        and PARAM.bool_avoid_wall_group_reuse == 1) then
          table.add_unique(SEEN_WALL_GROUPS, fg.wall_group.name)
        end
      end
    end

  end


  local function grab_usable_sinks(R, group, where)

    local function filter_ceiling_sinks(sink_name, tab, LEVEL)
      if sink_name == "PLAIN" then return end

      local sink = GAME.SINKS[sink_name]

      if not sink then
        error("Unknown sink: " .. sink_name)
      end

      if sink.mat == "_LIQUID" or sink.trim_mat == "_LIQUID" then
        if not LEVEL.liquid then
          tab[sink_name] = 0
        end
        if PARAM.liquid_sinks then
          if PARAM.liquid_sinks == "no" then
            tab[sink_name] = 0
          end
          if LEVEL.liquid then
            if LEVEL.liquid.damage
            and PARAM.liquid_sinks == "not_damaging" then
              tab[sink_name] = 0
            end
            if LEVEL.liquid.damage and LEVEL.is_procedural_gotcha then
              tab[sink_name] = 0
            end
          end
        end
      end

      if (sink.trim_mat and sink.trim_mat == R.main_tex)
      then
        tab[sink_name] = nil
      end
    end
    -- skip sinks whose texture(s) clash with the room or area

    local tab
    local theme = LEVEL.theme_name
    assert(theme)

    if R.theme.theme_override then
      theme = ob_resolve_theme_keyword(R.theme.theme_override)
    end

    if where == "floor" then
      tab = R.theme.floor_sinks or GAME.THEMES[theme].floor_sinks
    else
      tab = R.theme.ceiling_sinks or GAME.THEMES[theme].ceiling_sinks
    end

    -- PLAIN setting is now ignored for a universal prob, see individual code below
    -- assert(tab["PLAIN"])

    tab = table.copy(tab)

    if not tab then
      gui.printf("WARNING!! " .. LEVEL.theme_name .. " has no usable sinks!")
      return
    end

    for _,name in pairs(table.keys(tab)) do
      filter_ceiling_sinks(name, tab, LEVEL)
    end

    return tab
  end


  local function pick_floor_sinks(R, LEVEL)

    local function pick_sink(floor_group, room, LEVEL)
      if floor_group.openness < 0.4 then return end

      local tab = grab_usable_sinks(room, floor_group, "floor")
      if tab == nil then return end
      if table.empty(tab) then return end

      local name = rand.key_by_probs(tab)

      -- PLAIN keyword for sinks should now be ignored in
      -- favor of this direct prob
      if rand.odds(75) then name = "PLAIN" end

      if name ~= "PLAIN" then
        floor_group.sink = GAME.SINKS[name]
        assert(floor_group.sink)
      end
    end

    local function pick_street_sink(floor_group, LEVEL)
      if floor_group.is_road then
        if not GAME.THEMES[LEVEL.theme_name].street_sinks then
          gui.printf("WARNING! No street sinks for theme " .. LEVEL.theme_name .. ".\n")
          return
        end
        floor_group.sink = GAME.SINKS[rand.key_by_probs(GAME.THEMES[LEVEL.theme_name].street_sinks)]
      end
    end

    if R.is_cave or
    (R.is_outdoor and not R.is_street) then
      return
    end

    for _,fg in pairs(R.floor_groups) do
      pick_sink(fg, R, LEVEL)
    end

    -- street sink code
    if R.is_street then
      for _,fg in pairs(R.floor_groups) do
        pick_street_sink(fg, LEVEL)
      end
    end
  end


  local function pick_ceiling_sinks(R, LEVEL)
    if R.is_cave or R.is_outdoor then return end

    for _,cg in pairs(R.ceil_groups) do
      if cg.openness < 0.4 then goto continue end

      local height = cg.h - cg.max_floor_h
      if height < 128 then goto continue end

      local tab = grab_usable_sinks(R, cg, "ceiling")
      if tab == nil then return end
      if table.empty(tab) then return end

      local name = rand.key_by_probs(tab)

      -- PLAIN keyword for sinks should now be ignored in
      -- favor of this direct prob
      if rand.odds(75) then name = "PLAIN" end

      if name ~= "PLAIN" then
        cg.sink = GAME.SINKS[name]
        assert(cg.sink)

        -- inhibit ceiling lights and pillars
        for _,chunk in pairs(R.ceil_chunks) do
          if chunk.area.ceil_group == cg and not chunk.content then
            chunk.content = "NOTHING"
          end
        end
      end
      ::continue::
    end
  end


  local function select_lamp_for_group(R, cg)
    local reqs =
    {
      kind  = "light",
      where = "point",

      size  = 80,
      height = cg.h - cg.max_floor_h,

      env = R:get_env()
    }

    if LEVEL.light_group and not table.empty(LEVEL.light_group) then
      reqs.light_color = rand.key_by_probs(LEVEL.light_group)
    end

    if R.theme.theme_override then
      reqs.theme_override = R.theme.theme_override
    end

    local def = Fab_pick(LEVEL, reqs, "none_ok")

    if not def then
      reqs.light_color = nil
      def = Fab_pick(LEVEL, reqs, "none_ok")
    end

    return def
  end


  local function select_lamp_for_porch(A)
    local reqs =
    {
      kind = "light",
      where = "point",

      size = 80,
      height = A.ceil_h - A.floor_h,

      env = "building",
    }

    if LEVEL.light_group and not table.empty(LEVEL.light_group) then
      reqs.light_color = rand.key_by_probs(LEVEL.light_group)
    end
  
    if A.room.theme.theme_override then
      reqs.theme_override = A.room.theme.theme_override
    end

    local def = Fab_pick(LEVEL, reqs, "none_ok")

    if not def then
      reqs.light_color = nil
      def = Fab_pick(LEVEL, reqs, "none_ok")
    end

    return Fab_pick(LEVEL, reqs, "none_ok")
  end


  local function pick_decorative_bling(R, LEVEL)
    local decor_prob = rand.pick({ 20, 55, 90 })

    local decor_prob_tab =
    {
      fab_heaps = 90,
      fab_more = 75,
      fab_few = 35,
      fab_rare = 15,
      fab_none = 0,
    }

    if PARAM.point_prob and PARAM.point_prob ~= "fab_default" then
      decor_prob = decor_prob_tab[PARAM.point_prob]
    end

    decor_prob = math.clamp(0, decor_prob / (LEVEL.autodetail_group_walls_factor / 2), 100)

    for _,chunk in pairs(R.floor_chunks) do
      if chunk.content == nil and not chunk.is_bossy and rand.odds(decor_prob) then
        try_decoration_in_chunk(chunk, nil, LEVEL)
      end
    end
  end


  local function pick_cavey_bling(R)
    local decor_prob = rand.pick({ 2, 6, 12, 24 })

    for _,chunk in pairs(R.floor_chunks) do
      if chunk.content == nil and not chunk.is_bossy and rand.odds(decor_prob) then
        try_decoration_in_chunk(chunk, "is_cave", LEVEL)
      end
    end
  end


  local function pick_ceiling_lights(R)
    if R.is_cave or R.is_park then return end

    local groups = {}

    local prob = R.theme.ceil_light_prob or THEME.ceil_light_prob or 50

    for _,cg in pairs(R.ceil_groups) do
      if not rand.odds(prob) then goto continue end

      local def = select_lamp_for_group(R, cg)
      if not def then goto continue end

      for _,chunk in pairs(R.ceil_chunks) do
        if chunk.area.ceil_group ~= cg then goto continue end
        if chunk.content then goto continue end
        if chunk.floor_below and chunk.floor_below.content then goto continue end
        if def.height > (chunk.area.ceil_h - chunk.area.floor_h) then
          goto continue end

        if true then
          chunk.content = "DECORATION"
          chunk.prefab_def = def
          chunk.prefab_dir = 2

          chunk.area.bump_light = 16

          chunk.ceil_above = true
        end
        ::continue::
      end
      ::continue::
    end

    -- allow fabrication of ceiling lights in outdoor porches
    if R.is_outdoor then
      for _,A in pairs(R.areas) do
        if A.is_porch then
          if not rand.odds(prob) then goto continue end

          A.lamp_def = select_lamp_for_porch(A)
          if not A.lamp_def then goto continue end
        end
        ::continue::
      end

      for _,chunk in pairs(R.floor_chunks) do
        if chunk.area.lamp_def then
          if chunk.content then goto continue end
          if chunk.floor_below and chunk.floor_below.content then goto continue end

          if chunk.area.lamp_def.height > (chunk.area.ceil_h - chunk.area.floor_h) then
            goto continue end

          chunk.content = "DECORATION"
          chunk.kind = "ceil"
          chunk.prefab_def = chunk.area.lamp_def
          chunk.prefab_dir = 2

          chunk.area.bump_light = 16

          chunk.ceil_above = true
          ::continue::
        end
      end
    end

  end


  local function unsink_chunk(chunk, where)
    local corner_field = where .. "_inner"

    local cx1 = chunk.sx1
    local cx2 = chunk.sx2 + 1

    local cy1 = chunk.sy1
    local cy2 = chunk.sy2 + 1

    for cx = cx1, cx2 do
    for cy = cy1, cy2 do
      local corner = Corner_lookup(LEVEL, cx, cy)
      assert(corner)

      corner[corner_field] = nil
    end
    end
  end


  local function unsink_importants(R)
    -- ensure importants do not sit on a floor sink
    -- TODO : review this, e.g. key pedestal can be OK (but need right floor_z)

    for _,chunk in pairs(R.floor_chunks) do
      if (chunk.content and chunk.content ~= "NOTHING") or chunk.is_bossy then
        unsink_chunk(chunk, "floor")

        if chunk.peer then
          unsink_chunk(chunk.peer, "floor")
        end
      end
    end
  end


  local function fix_stair_lighting(R)
    for _,chunk in pairs(R.stairs) do
      local N1 = chunk.from_area
      local N2 = chunk.dest_area

      if N1.bump_light and N2.bump_light then
        chunk.area.bump_light = N1.bump_light
      end
    end
  end


  local function pick_posts(R)
    if not R.is_outdoor then return end
    if R.is_cave then return end

    if not THEME.fence_posts then
      gui.printf("WARNING!!! No fence_posts table for theme: " .. LEVEL.theme_name .. "\n")
      return
    end
  end


  local function tizzy_up_normal_room(R, LEVEL)
    pick_posts(R)
    pick_wall_detail(R)

    pick_floor_sinks(R, LEVEL)
    pick_ceiling_sinks(R, LEVEL)

    unsink_importants(R)

    pick_decorative_bling(R, LEVEL)
    pick_ceiling_lights(R)

    fix_stair_lighting(R)
  end


  local function tizzy_all_closets(R)
    try_secret_closets(R)

    -- more cages, oh yes!
    try_extra_cages(R)

    try_decor_closets(R)

    try_secondary_importants(R)

    -- kill any unused closets
    for _,CL in pairs(R.closets) do
      if not CL.content then
        kill_closet(CL)
      end
    end
  end


  local function decor_early_pass(R, LEVEL)
    switch_up_room(R)

    -- closets must be decided early for caves
    if R.is_cave or R.is_park then
      pick_cavey_bling(R)

      tizzy_all_closets(R)
    end
  end


  local function decor_later_pass(R, LEVEL)
    if not (R.is_cave or R.is_park) then
      tizzy_up_normal_room(R, LEVEL)
      tizzy_all_closets(R)
    end
  end


  ---| Layout_decorate_rooms |---

  for _,R in pairs(LEVEL.rooms) do
    if pass == 1 then
      decor_early_pass(R, LEVEL)
    else
      decor_later_pass(R, LEVEL)
    end
  end
end


------------------------------------------------------------------------


function Layout_scenic_vistas(LEVEL, SEEDS)
  Area_pick_facing_rooms(LEVEL, SEEDS)

  LEVEL.scenic_fabs = {}

  for _,A in pairs(LEVEL.areas) do
    if A.mode == "scenic" then
      Cave_prepare_scenic_vista(LEVEL, A)
    end
  end

  for _,A in pairs(LEVEL.areas) do
    if A.mode == "scenic" then
      Cave_build_a_scenic_vista(LEVEL, A, SEEDS)
    end
  end
end



function Layout_handle_corners(LEVEL)


  local function fencepost_base_z(corner)
    local z

    for _,A in pairs(corner.areas) do
      z = math.N_max(A.floor_h, z)
    end

    return z
  end


  local function near_porch(corner)
    local diff = corner.areas[1].ceil_h
    local near_porch = false

    for _,A in pairs(corner.areas) do
      if A.is_porch or A.is_porch_neighbor then
        near_porch = true
      end

      if near_porch and A.ceil_h ~= diff then 
        return true
      end
    end

    return false
  end

  
  local function near_indoor_fence(junc)

    if junc.A1.room and junc.A1.room:get_env() == "building" or
    junc.A2.room and junc.A2.room:get_env() == "building" then
      if junc.E1 and junc.E1.kind == "fence" then return true end
      if junc.E2 and junc.E2.kind == "fence" then return true end
    end

    return false
  end


  local function fetch_good_pillar_material(corner)

    local mostly_env = Corner_get_env(corner)

    if mostly_env == "outdoor" then
      for _,A in pairs(corner.areas) do
        if A.room then return A.room.zone.facade_mat end
      end
    elseif mostly_env == "building" then
      for _,A in pairs(corner.areas) do
        if A.room then return A.room.main_tex end
      end
    end

    return "_DEFAULT"
  end


  local function check_need_fencepost(corner)
    -- already used?
    if corner.kind then return end

    local post_top_z

    corner.post_top_h = -EXTREME_H

    for _,junc in pairs(corner.junctions) do
      if junc.A2 == "map_edge" then return end
      if not junc.E1 then goto continue end

      -- code for fancy fenceposts
      if (junc.E1.kind == "fence" and junc.E1.area.is_outdoor) then
        if Corner_touches_wall(corner) then return end

        if corner.posted then return end

        local tallest_h = -EXTREME_H
        for _,xjunc in pairs(corner.junctions) do
          if xjunc.E1 and xjunc.E1.fence_top_z then
            tallest_h = math.max(tallest_h, xjunc.E1.fence_top_z)
          end
        end

        if Corner_is_at_area_corner(corner) then
          corner.post_mat = corner.areas[1].zone.fence_mat
          corner.kind = "post"
          corner.post_type = assert(corner.areas[1].zone.post_type)

          if corner.post_top_h < tallest_h then
            corner.post_top_h = tallest_h + 32
          end
        end

        -- original fenceposts on railings code
        -- (slightly cleaned up by MSSP) from Andrew
      elseif junc.E1.kind == "railing" then

        -- cannot place posts next to a wall
        if Corner_touches_wall(corner) then return end

        if not Corner_is_at_area_corner(corner) then return end

        local mostly_env = Corner_get_env(corner)

        -- indoor posts should meet the ceiling
        local tallest_h = -EXTREME_H

        if mostly_env == "building" then
          post_top_z = EXTREME_H

        else

          -- outdoor posts should meet up to the rail height
          for _,A in pairs(corner.areas) do

            if A.is_porch or A.is_porch_neighbor then
              tallest_h = EXTREME_H
              goto continue
            end

            tallest_h = math.max(tallest_h, A.floor_h + assert(junc.E1.rail_offset))

            if A.floor_h then
              tallest_h = math.max(tallest_h, A.floor_h)
            end
            ::continue::
          end

          post_top_z = tallest_h
        end

        corner.kind = "post"
        if corner.post_top_h < post_top_z then
          corner.post_top_h = post_top_z
        end
      end
      ::continue::
    end
  end


  local function add_pillar(corner)
    corner.kind = "pillar"
    corner.mat = fetch_good_pillar_material(corner)
  end


  local function check_need_pillar(corner)
    if corner.kind then return end

    local pillar_it = false
    for _,junc in pairs(corner.junctions) do
      if junc.A2 == "map_edge" then return end

      if not Corner_is_at_area_corner(corner) then return end

      -- don't put pillars adjacent to joiners and closets
      for _,S in pairs(corner.seeds) do
        if S.chunk then
          if S.chunk.kind == "joiner"
          or S.chunk.kind == "closet" then
            return
          end
        end
      end

      -- create support pillars on the corners
      -- where sky and ceilings of any other texture meet 
      if near_porch(corner) 
      or near_indoor_fence(junc) then
        pillar_it = true
      end
    end

    if pillar_it then
      add_pillar(corner)
    end

  end


  local function check_corner(cx, cy)
    local corner = Corner_lookup(LEVEL, cx, cy)

    check_need_fencepost(corner)
    check_need_pillar(corner)
  end


  ---| Layout_handle_corners |---

  for cx = 1, SEED_W + 1 do
  for cy = 1, SEED_H + 1 do
    check_corner(cx, cy)
  end
  end

end



function Layout_indoor_lighting(LEVEL)
  --
  -- Give each indoor/cave room a lighting keyword:
  --    "bright"   (160 units)
  --    "normal"   (144 units)
  --    "dark"     (128 units)
  --    "verydark" ( 96 units)
  --
  -- (Note: light levels are lower in caves)
  --
  -- Outdoor rooms are not affected here, but get a keyword which
  -- depends on the global "sky_light" value.
  --
  -- Individual areas can be increased by +16 or +32 based on what
  -- light sources are in that area (including windows).
  --

  local LIGHT_LEVELS =
  {
    bright   = math.round(224 * PARAM.float_overall_lighting_mult),
    normal   = math.round(192 * PARAM.float_overall_lighting_mult),
    dark     = math.round(160 * PARAM.float_overall_lighting_mult),
    verydark = math.round(128 * PARAM.float_overall_lighting_mult),
  }

  local CAVE_LEVELS =
  {
    bright   = math.round(192 * PARAM.float_overall_lighting_mult),
    normal   = math.round(160 * PARAM.float_overall_lighting_mult),
    dark     = math.round(128 * PARAM.float_overall_lighting_mult),
    verydark = math.round(96 * PARAM.float_overall_lighting_mult),
  }

  local function sky_light_to_keyword()
    if LEVEL.sky_light >= 168 then return "bright" end
    if LEVEL.sky_light >= 136 then return "normal" end
    if LEVEL.sky_light >= 120 then return "dark" end
    return "verydark"
  end

  local function set_room(R, what)
    R.light_level = what

    local base_light

    if R.is_cave then
      base_light = CAVE_LEVELS[what]
    else
      base_light = LIGHT_LEVELS[what]
    end

    assert(base_light)

    if OB_CONFIG.port ~= "zdoom" and OB_CONFIG.port ~= "edge" then
      local rounder = base_light % 16
      if rounder ~= 0 then
        if rounder > 8 then
          base_light = base_light + (16 - rounder)
        else
          base_light = base_light - rounder
        end
      end
      local JITTER = {0, 0, 0, -16, 16}
      base_light = base_light + rand.pick(JITTER)
    else
      local JITTER = {0, 0, 0, -math.round(base_light * 0.1), math.round(base_light * 0.1)}
      base_light = base_light + rand.pick(JITTER)
    end

    if R.theme.light_adjusts then
      base_light = base_light + rand.pick(R.theme.light_adjusts)
    end

    for _,A in pairs(R.areas) do
      -- brightness clamp
      A.base_light = math.clamp(PARAM.wad_minimum_brightness or 0, 
        base_light, PARAM.wad_maximum_brightness or 255)
    end

  end

 -- Very dark here! --Reisal

  local function visit_room(R, prev_room)
    local tab = { bright=25, normal=50, dark=50, verydark=25 }

    if R.is_start then
      tab["verydark"] = nil
    end

    if prev_room then
      assert(prev_room.light_level)

      if prev_room.light_level == "bright" then
        tab["dark"] = nil
        tab["verydark"] = nil
      elseif prev_room.light_level == "normal" then
        tab["verydark"] = nil
        tab["dark"] = 25
      elseif prev_room.light_level == "dark" then
        tab["bright"] = nil
        tab["normal"] = 25
      else
        tab["bright"] = nil
        tab["normal"] = nil
      end
    end

    if not R.light_level then
      set_room(R, rand.key_by_probs(tab))
    end

    -- recurse to neighbors
    for _,C in pairs(R.conns) do
      if C.is_cycle then goto continue end

      local R2 = C:other_room(R)

      if R2.lev_along > R.lev_along then
        visit_room(R2, R)
      end
      ::continue::
    end
  end


  ---| Layout_indoor_lighting |---

  -- setup outdoor rooms first
  for _,R in pairs(LEVEL.rooms) do
    if R.is_outdoor then
      -- cannot use set_room() here
      R.light_level = sky_light_to_keyword()
    end
  end

  visit_room(LEVEL.start_room)
end