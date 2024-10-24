------------------------------------------------------------------------
--  QUEST ASSIGNMENT
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

--|
--| See doc/Quests.txt for an overview of the quest system
--|

--class QUEST
--[[
    id, name   -- debugging aids

    rooms[id] : ROOM

    svolume   : total svolume of all rooms

    entry : ROOM

    goals : list(GOAL)

    parent_node : QUEST_NODE

--]]


--class QUEST_NODE
--[[
    --
    -- The quests are placed in a binary tree.  The QUEST objects are the
    -- leaves, and this structure represents the nodes.
    --

    node_id : number   (distinguishes nodes from quests)

    before  : NODE or QUEST
    after   : NODE or QUEST

    conn : CONN  -- where the division occurred
--]]


--class ZONE
--[[
    --
    -- A zone is a group of rooms and areas which form a distinct
    -- section of the map.  Zones are always separated by walls,
    -- except at room connections which cross a zone barrier.
    --

    id, name  -- debugging aids

    rooms : list(ROOM)
    areas : list(AREA)

    sky_h : number   -- height of sky for this zone

    along : number   -- lower values are entered earlier


    === Theme stuff ===

    cave_theme     : ROOM_THEME
    outdoor_theme  : ROOM_THEME

    facade_mat      -- material for outer walls of buildings
    other_facade    -- another one

    nature_facade       -- natural facade for fully natural parks
    other_nature_facade

    fence_mat       -- material for fences


    === Monster stuff ===

    mon_palette     -- palette of monsters for this zone
                    -- [ a table of mon=prob pairs ]

    weap_palette    -- weapon usage palette
--]]


--class GOAL
--[[
    --
    -- A goal is something which the player is required to find.
    -- For example, a key that is needed to open a door, or the
    -- exit from the level.  Also used for level starting spots.
    --

    id, name  -- debugging aids

    kind : keyword  --  "KEY", "SWITCH",
                    --  "START", "EXIT" or "SECRET_EXIT",

    item : keyword  -- name of key or switch

    room  : ROOM    -- where the goal is
    chunk : CHUNK   -- place in room where the goal is

    backtrack : list(ROOMS)  -- rooms player MUST back-track through
                             -- (includes room with the locked conn,
                             --  but excludes room with the goal).

    action : name    -- name of action special for switches
    tag    : number  -- tag number to use for a switched door

--]]


--------------------------------------------------------------]]


function Quest_new(LEVEL)
  local id = 1 + #LEVEL.quests

  local QUEST =
  {
    id = id,
    name  = "QUEST_" .. id,
    rooms = {},
    goals = {},
    svolume = 0,
  }

  table.insert(LEVEL.quests, QUEST)

  return QUEST
end


function QuestNode_new(LEVEL)
  local NODE =
  {
    node_id = alloc_id(LEVEL, "quest_node")
  }

  return NODE
end


function Zone_new(LEVEL)
  local id = 1 + #LEVEL.zones

  local ZONE =
  {
    id = id,
    name = "ZONE_" .. id,
    rooms = {},
    areas = {},
  }

  table.insert(LEVEL.zones, ZONE)

  return ZONE
end


function Goal_new(LEVEL, kind)
  local id = alloc_id(LEVEL, "goal")

  local GOAL =
  {
    id = id,
    name = "GOAL_" .. (kind or "XX") .. "_" .. id,
    kind = kind
  }

  return GOAL
end



function Quest_size_of_room_set(rooms)
  local total = 0

  for id, R in pairs(rooms) do
    total = total + R.svolume
  end

  return total
end



function Quest_create_initial_quest(LEVEL)
  --
  -- Turns the whole map into a single QUEST object, and the exit
  -- room is the goal of the quest.
  --
  -- This quest can be divided later on into major and minor quests.
  --

  local function eval_exit_room(R, secret_mode)
    local function recurse_to_start(R, mult)
      mult = mult * math.clamp(1, R.svolume / 128, 9001) 
      if R.grow_parent then
        recurse_to_start(R.grow_parent, mult)
      end
      return mult
    end

    if R.is_exit    then return -1 end
    if R.is_hallway then return -1 end
    if R.is_start and #LEVEL.rooms > 1 then return -1 end
    if R.is_exit then return -1 end

    -- must be a leaf room, but only if secret
    if R:total_conns() > 1 and secret_mode then 
      return -1 
    end

    local conn = R.conns[1]

    if secret_mode then
      if R.is_start then return -1 end

      -- cannot teleport into a secret exit
      if conn.kind == "teleporter" then return -1 end

      if conn.kind == "joiner" then
        -- no L-shape joiners!
        if conn.joiner_chunk.shape ~= "I" then return -1 end
      end

      -- don't waste big rooms on a secret exit
      local score = 200 - math.min(R.svolume, 190)

      return score + gui.random()
    end

    -- occasionally the grower will only produce a single room,
    -- hence we cannot reject a starting room completely
    if R.is_start then
      return gui.random() / 100
    end

    -- prefer a non-teleporter entrance (so we can lock it)
    if conn.kind == "teleporter" then
      local score = sel(R.is_cave, 1, 2)

      return score + gui.random()
    end

    local score = R.svolume

    -- give a bigger score to rooms further into the map
    local score_mult
    if R.grow_parent then
      local init_mult = 1
      score_mult = recurse_to_start(R.grow_parent, init_mult)
    end
    score = score * (score_mult or 1)

    -- caves are not ideal
    if R.is_cave then score = score / 4 end
    -- sub rooms that are too small
    if R.is_sub_room and R.svolume < 16 and not secret_mode then 
      score = score / 48
    end

    --[[if not R.is_sub_room then
      score = score + gui.random() * 10
    end]]

    if R:total_conns() > 1 then
      score = score / 10
    end

    R.exit_score = score

    return score 
  end


  local function pick_exit_room(secret_mode)
    --
    -- We want a large room for the exit, so can have a big battle with
    -- one or more boss-like monsters.
    --
    local best
    local best_score = 0

    if #LEVEL.rooms == 1 then return LEVEL.rooms[1] end

    for _,R in pairs(LEVEL.rooms) do
      local score = eval_exit_room(R, secret_mode)

      if score > best_score then
        best = R
        best_score = score
      end
    end

    return best
  end


  local function mark_exit_connection(R)
    local C = R.conns[1]

    if C then
      local H = C:other_room(R)
      if H.is_hallway and H:total_conns() == 2 then
        C = H:hallway_other_conn(C)
      end
    end

    if C then
      C.leads_to_exit = true

      -- generally try to lock the exit room
      if rand.odds(90) then
        C.prefer_locked = true
      end
    end
  end


  local function add_normal_exit(quest)
    local R = LEVEL.exit_room

    if not R then
      R = pick_exit_room()
    end

    if not R then
      error("Unable to pick exit room!")
    end

    if R:total_conns() > 1 then
      warning("Exit room has multiple conns!\n")
    end

    gui.printf("Exit room: %s\n", R.name)

    R.is_exit = true

    if not LEVEL.exit_room then
      LEVEL.exit_room = R
    end

    -- create the goal for the entire map
    local GOAL = Goal_new(LEVEL, "EXIT")

    GOAL.room = R

    table.insert(R.goals, GOAL)
    table.insert(quest.goals, GOAL)

    R.used_chunks = R.used_chunks + 1

    mark_exit_connection(R)
  end


  local function add_secret_exit()

    if LEVEL.is_procedural_gotcha and PARAM.bool_boss_gen and PARAM.bool_boss_gen == 1 then
      LEVEL.need_secret_exit = true
      return
    end

    local R = pick_exit_room("secret_mode")

    if not R then
      -- invoke plan B : use a secret closet somewhere
      LEVEL.need_secret_exit = true
      return
    end

    -- OK --

    gui.printf("Secret Exit: %s\n", R.name)

    R.is_exit = true
    R.is_secret_exit = true

    Quest_make_room_secret(R)

    local GOAL = Goal_new(LEVEL, "SECRET_EXIT")

    table.insert(R.goals, GOAL)
    R.used_chunks = R.used_chunks + 1
  end


  ---| Quest_create_initial_quest |---

  local Q = Quest_new(LEVEL)

  -- this quest becomes head of the quest tree
  LEVEL.quest_root = Q

  for _,R in pairs(LEVEL.rooms) do
    R.quest = Q

    Q.rooms[R.id] = R
    Q.svolume = Q.svolume + R.svolume
  end

  -- the start room may not be chosen yet (so NIL is ok)
  Q.entry = LEVEL.start_room

  add_normal_exit(Q)

  if LEVEL.secret_exit then
    add_secret_exit()
  end
end



function Quest_eval_divide_at_conn(C, goal, info)
  --
  -- Evaluate whether we can divide a quest at the given connection,
  -- locking up the given goal (which already exists in the quest).
  --
  -- The 'info' table contains the current best division (if any),
  -- and contains the following input fields:
  --
  --    lock_kind : the lock to place on the connection
  --    new_goals : goals used to solve the lock (usually 1)
  --
  -- and the following output fields:
  --
  --    score   :  best current score  (must be initialised to zero)
  --    conn    :  the best connection  [ NIL if none yet ]
  --    goal    :  the goal to lock up
  --    quest   :  the quest to divide
  --
  --    before  :  room set of first half
  --    after   :  room set of second half
  --    leafs   :  list of rooms place goals (#leafs >= #new_goals)
  --

  local quest  -- current quest


  local function same_quest(C2)
    return C2.R1.quest == C2.R2.quest
  end


  local function collect_rooms(R, list)
    list[R.id] = R

    for _,C2 in pairs(R.conns) do
      -- never pass through connection we are examining
      if C2 == C then goto continue end

      if not same_quest(C2) then goto continue end

      local R2
      if C2.R1 == R then
        R2 = C2.R2
      else
        R2 = C2.R1
      end

      -- already seen?
      if list[R2.id] then goto continue end

      collect_rooms(R2, list)
      ::continue::
    end

    return list
  end


  local function room_exits_in_set(R, rooms)
    local count = 0

    for _,C in pairs(R.conns) do
      local R2 = C:other_room(R)

      if rooms[R2.id] then count = count + 1 end
    end

    assert(count > 0)

    return count
  end


  local function unused_rooms_in_set(rooms)
    local leafs = {}

    for id, R in pairs(rooms) do
      if R.is_secret then goto continue end

      if R.is_hallway then goto continue end

      -- some goals already?
      if #R.goals > 0 then goto continue end

      if quest.entry and quest.entry == R then goto continue end

      -- skip the room immediately next to the proposed connection
      if C.R1 == R or C.R2 == R then goto continue end

      if room_exits_in_set(R, rooms) == 1 then
        table.add_unique(leafs, R)
      end
      ::continue::
    end

    return leafs
  end


  local function check_has_goal(rooms)
    if goal.room and rooms[goal.room.id] then
      return true
    end

    return false
  end


  local function eval_split_possibility(C, before, after, before_R, after_R)
    local before_size = Quest_size_of_room_set(before)
    local  after_size = Quest_size_of_room_set(after)

    local score = 200

    if C.prefer_locked then
      score = 400
    end

    -- prefer not to enter a hallway from a locked door
    if after_R.is_hallway then
      score = score - 100
    end

    -- try to avoid very unbalanced splits

    local   min_size = math.min(before_size, after_size)
    local total_size = before_size + after_size

    local frac = min_size / total_size

    if frac < 0.166 then
      score = score - 20
    elseif frac < 0.333 then
      score = score - 10
    end

    -- tie breaker
    return score + gui.random()
  end


  ---| Quest_eval_divide_at_conn |---

gui.debugf("  goal: %s/%s @ %s / %s\n", goal.kind or "???", goal.item or "???",
goal.room.name, goal.room.quest.name)

  -- must be same quest (caller guarantees this)
  assert(C.R1.quest == C.R2.quest)

  -- cannot lock teleporter connections
  if C.kind == "teleporter" then return end

  quest = C.R1.quest

gui.debugf("  quest : %s\n", quest.name)

  -- must not divide a room in half
  if C.R1 == C.R2 then
    return
  end

  -- collect rooms on each side of the connection
  local before = collect_rooms(C.R1, {})
  local  after = collect_rooms(C.R2, {})

--[[
stderrf("BEFORE =\n  ")
for id,_ in pairs(before) do stderrf("%d ", id) end stderrf("\n\n")
stderrf("AFTER =\n  ")
for id,_ in pairs(after) do stderrf("%d ", id) end stderrf("\n\n")
--]]

  local before_R = C.R1
  local  after_R = C.R2

  if check_has_goal(after) then
    -- OK
  elseif check_has_goal(before) then
    before, after = after, before
    before_R, after_R = after_R, before_R
  else
    error("Cannot find goal inside quest")
  end

  -- entry of quest MUST be in first half
  if quest.entry then
    if not before[quest.entry.id] then
      assert(after[quest.entry.id])
      return
    end
  end

  -- no locking end of hallways
  -- [ except for branchy hallways where one room is the exit ]
  if before_R.is_hallway then
    if #before_R.conns < 3 then return end
    if not after_R.is_exit then return end
    if after_R.is_secret   then return end
  end

  local leafs = unused_rooms_in_set(before)

  if #leafs < #info.new_goals then return end

  local score = eval_split_possibility(C, before, after, before_R, after_R)

gui.debugf("--> possible @ %s : score %1.1f\n", C.name, score)

  if score > info.score then
    info.score  = score

    info.conn   = C
    info.goal   = goal
    info.quest  = quest
    info.leafs  = leafs

    info.before   = before
    info.before_R = before_R
    info.after    = after
    info.after_R  = after_R
  end
end


function Quest_perform_division(LEVEL, info)
  --
  -- Splits the current quest into two, adding the new quest into the
  -- binary tree.  Also marks the connection as locked.
  --

  local function replace_with_node(Q, new_node)
    if not Q.parent_node then
      assert(LEVEL.quest_root == Q)
      LEVEL.quest_root = new_node
      return
    end

    if Q.parent_node.before == Q then
       Q.parent_node.before = new_node
      return
    end

    if Q.parent_node.after == Q then
       Q.parent_node.after = new_node
      return
    end

    error("Bad parent_node in quest")
  end


  local function assign_quest(Q)
    for id, R in pairs(Q.rooms) do
      R.quest = Q
    end
  end


  local function transfer_existing_goals(Q1, Q2)
gui.debugf("transfer_existing_goals:\n")
    for i = #Q2.goals, 1, -1 do
      local targ = Q2.goals[i]

      if targ.room and targ.room.quest == Q1 then
gui.debugf("   %s\n", targ.name)
        table.insert(Q1.goals, table.remove(Q2.goals, i))
      end
    end
  end


  local function eval_goal_room(Q1, R)
    local score = 100

    -- TODO : compute travel distance from R to where goal is used

    score = score + R:usable_chunks() * 10

    -- tie breaker
    return score + gui.random()
  end


  local function pick_room_for_goal(Q1)
    local best
    local best_score = 0

    for _,R in pairs(info.leafs) do
      local score = eval_goal_room(Q1, R)

      if score > best_score then
        best = R
        best_score = score
      end
    end

    assert(best)

    table.kill_elem(info.leafs, best)

    return best
  end


  local function place_goal_in_room(Q1, R, goal)
    goal.room = R

    table.insert( R.goals, goal)
    table.insert(Q1.goals, goal)

    R.used_chunks = R.used_chunks + 1

    -- for switched doors we need a tag value
    if goal.same_tag then
      goal.tag = assert(info.new_goals[1].tag)

    elseif goal.kind == "SWITCH" then
      goal.tag = alloc_id(LEVEL, "tag")
    end
  end


  local function place_new_goals(Q1)
    assert(#info.leafs >= #info.new_goals)

    rand.shuffle(info.leafs)

gui.debugf("PLACING NEW GOALS:\n")

    for _,goal in pairs(info.new_goals) do
      local R = pick_room_for_goal(Q1)

gui.debugf("  %s @ %s in %s\n", goal.name, R.name, Q1.name)

      place_goal_in_room(Q1, R, goal)
    end
  end


  ---| Quest_perform_division |---

  -- create the node
  local node = QuestNode_new(LEVEL)

  local Q2 = assert(info.quest)

  -- create the new quest
  -- (for the first half, existing quest becomes second half)

  local Q1 = Quest_new(LEVEL)

gui.debugf("Dividing %s,  first half is %s\n", Q2.name, Q1.name)


  -- link quests into node heirarchy

  node.before = Q1
  node.after  = Q2
  node.conn   = info.conn

  replace_with_node(Q2, node)

  Q1.parent_node = node
  Q2.parent_node = node


  -- setup quests, transfer stuff

  Q1.entry = Q2.entry
  Q2.entry = info.after_R

  Q1.rooms = info.before
  Q2.rooms = info.after

  Q1.svolume = Quest_size_of_room_set(Q1.rooms)
  Q2.svolume = Quest_size_of_room_set(Q2.rooms)

  assign_quest(Q1)
  assign_quest(Q2)

  -- do this AFTER assigning new 'quest' fields
  transfer_existing_goals(Q1, Q2)


  -- add the new goals to the first quest
  place_new_goals(Q1)

  assert(not table.empty(Q1.goals))
  assert(not table.empty(Q2.goals))


  -- lock the connection
  local lock = Lock_new(LEVEL, "quest", info.conn)

  lock.goals = info.new_goals
end



function Quest_scan_all_conns(LEVEL, new_goals, do_quest)
  -- do_quest can be NIL, or a particular quest to try dividing

  gui.debugf("Quest_scan_all_conns.....\n")
  gui.ticker()

  local info =
  {
    new_goals = new_goals,
    score = 0,
  }

  local need_joiner = (#new_goals >= 2 or new_goals[1].kind == "SWITCH")


  for _,C in pairs(LEVEL.conns) do
    local quest = C.R1.quest
    assert(quest)

    if do_quest and quest ~= do_quest then goto continue end

    if need_joiner and
       not (C.kind == "joiner" and
            C.joiner_chunk.shape == "I" and
            (C.joiner_chunk.sw >= 2 or C.joiner_chunk.sh >= 2))
    then
      goto continue
    end

    -- must be same quest on each side
    if C.R2.quest ~= quest then goto continue end

    for _,goal in pairs(quest.goals) do
      Quest_eval_divide_at_conn(C, goal, info)
    end
    ::continue::
  end


  -- nothing possible?
  if not info.conn then

gui.debugf("---> NOTHING POSSIBLE\n")
    return false
  end


  gui.printf("Dividing %s @ %s (%s -- %s)\n", info.quest.name,
             info.conn.name, info.conn.R1.name, info.conn.R2.name)

gui.debugf("   VIA: %s (x%d)\n", info.new_goals[1].item or "???", #info.new_goals)
gui.debugf("   Entry: %s\n", (info.quest.entry and info.quest.entry.name) or "--")

  Quest_perform_division(LEVEL, info)
  return true
end



function Quest_add_major_quests(LEVEL)
  --
  -- Divides the map into major quests, typically requiring a key to
  -- progress between the quests.
  --

  local function count_unused_leafs(quest)
    local unused = 0

    for id, R in pairs(quest.rooms) do
      if R:is_unused_leaf() 
      and not R.is_sub_room then -- don't count sub_rooms for the division of quests
        unused = unused + 1
      end
    end

    return unused
  end


  local function collect_key_goals(list)
    local key_tab = LEVEL.usable_keys or THEME.keys or {}

    local each_prob = style_sel("keys", 0, 40, 80, 100)

    -- decide maximum number
    local max_num = 1 + math.round(#LEVEL.rooms / 5)

    for name,_ in pairs(key_tab) do
      if rand.odds(each_prob) then
        local GOAL = Goal_new(LEVEL, "KEY")

        GOAL.item = name
        GOAL.prob = 50

        table.insert(list, GOAL)
      end
    end

    gui.printf("Maximum of %d key goals.\n", #list)
  end


  local function collect_switch_goals(list)
    if THEME.no_switches then return end

    local  any_prob = style_sel("switches", 0, 50, 75, 100)
    local each_prob = style_sel("switches", 0, 35, 65, 95)

    if not rand.odds(any_prob) then return {} end

    -- decide maximum number
    local max_num = 1 + math.round(#LEVEL.rooms / 5)

    for i = 1, max_num do
      if rand.odds(each_prob) then
        local GOAL = Goal_new(LEVEL, "SWITCH")

        GOAL.item = "sw_metal"
        GOAL.prob = 50

        table.insert(list, GOAL)
      end
    end

    gui.printf("Maximum of %d switch goals.\n", #list)
  end


  local function pick_goal(list)
    if table.empty(list) then
      return nil
    end

    local prob_tab = {}

    for index,goal in pairs(list) do
      prob_tab[index] = assert(goal.prob)
    end

    local idx = rand.index_by_probs(prob_tab)

    return table.remove(list, idx)
  end


  local function add_triple_key_door(key_list)
    if #key_list < 3 then return false end

    -- TODO: check that a usable prefab exists
    if not THEME.has_triple_key_door then return false end

    local prob = style_sel("trikeys", 0, 35, 70, 100)

    if not rand.odds(prob) then return false end

    rand.shuffle(key_list)

    local K1 = key_list[1]
    local K2 = key_list[2]
    local K3 = key_list[3]

    assert(K1 and K2 and K3)
    assert(K1.kind == "KEY")

    if not Quest_scan_all_conns(LEVEL, { K1, K2, K3 }) then
      return false
    end

    table.remove(key_list, 3)
    table.remove(key_list, 2)
    table.remove(key_list, 1)

    gui.printf("Added triple-key quest.\n")

    return true
  end


  local function add_double_switch_door(quest)
--FIXME
do return false end

    -- TODO: check that a usable prefab exists
    if not THEME.has_double_switch_door then return false end

    local prob = 35

    if LEVEL.has_double_switch_door then
      prob = prob / 2
    end

    if not rand.odds(prob) then return false end

    -- this is VERY dependent on the sw_pair.wad prefab
    local fab_def = PREFABS["Locked_double"]
    assert(fab_def)

    local GOAL1 = Goal_new(LEVEL, "SWITCH")
    local GOAL2 = Goal_new(LEVEL, "SWITCH")

    GOAL1.item = "sw_metal"
    GOAL2.item = "sw_metal"
    GOAL2.same_tag = true

--FIXME    GOAL1.action = fab_def.action1,
--FIXME    GOAL2.action = fab_def.action2,

    if not Quest_scan_all_conns(LEVEL, { GOAL1, GOAL2 }, quest) then
      return false
    end

    gui.printf("Added double-switch quest.\n")

    return true
  end


  local function lock_up_double_doors()
    for loop = 1, 2 do
      --TODO:
      -- local Q = find_exit_quest()
      -- if Q and count_unused_leafs(Q) >= 3 then
      --   if add_double_switch_door(Q) then
      --     LEVEL.has_double_switch_door = true
      --   end
      -- end
    end
  end


  -- index by unused :  1   2   3    4,
  local LOCK_PROBS = { 10, 60, 90, 100 }


  local function lock_up_a_quest(quest, goal_list)
    -- the goal is removed from goal_list

    local unused = count_unused_leafs(quest)

    if quest.no_more_locks then return end

    if unused < 1 then return end
    if unused > 4 then unused = 4 end

--[[ TODO : REVIEW (I think it makes more sense when we have remote-switch quests)
    if not rand.odds(LOCK_PROBS[unused]) then
      quest.no_more_locks = true
      return
    end
--]]

    local goal = pick_goal(goal_list)

    if goal then
      Quest_scan_all_conns(LEVEL, { goal }, quest)
    end
  end


  local function lock_up_quests(goal_list)
    local list = table.copy(LEVEL.quests)
    rand.shuffle(list)

    for _,Q in pairs(list) do
      lock_up_a_quest(Q, goal_list)
    end
  end


  ---| Quest_add_major_quests |---

  -- use keys to lock zone connections

  local goal_list = {}

  collect_key_goals(goal_list)

  -- triple key door?

  if add_triple_key_door(goal_list) then
    LEVEL.has_triple_key = true
    goal_list = { }
  end

  -- normal keyed doors...

  for pass = 1, 4 do
    lock_up_quests(goal_list)
  end


  -- use remotely switched doors only within a zone

  goal_list = {}

  collect_switch_goals(goal_list)


  -- double switched door?
  -- [ never make them if disabled by "switches" style ]

  if not table.empty(goal_list) then
    lock_up_double_doors(goal_list)
  end


  -- lastly, normal switched doors

  for pass = 1, 4 do
    lock_up_quests(goal_list)
  end


  -- fixup quest sizes
  for _,Q in pairs(LEVEL.quests) do
    Q.svolume = Quest_size_of_room_set(Q.rooms)
  end
end



function Quest_create_zones(LEVEL)
  --
  -- Divides the map into a few distinct sections.
  --
  -- Generally the start room and exit room are in distinct zones.
  -- Rooms in a quest usually belong to the same room, but this is
  -- not absolutely required (especially for teleporters).
  --

  local function calc_quota()
    --
    -- determine # of zones based on total used seeds
    --
    local total_svol = 0

    for _,A in pairs(LEVEL.areas) do
      if A.room then
        total_svol = total_svol + A.svolume
      end
    end

    local num = rand.int(total_svol / 240)

---##  stderrf("Map size : %d seeds --> %1.2f ZONES\n", total_svol, num)

    num = math.clamp(1, num, 5)

    gui.printf("Zone quota: %d\n", num)

    return num
  end


  local function assign_area(A, zone)
    if A.zone then return end

    A.zone = zone

    table.insert(zone.areas, A)
  end


  local function assign_room(R, zone)
    -- already has a zone?
    if R.zone then return end

    R.zone = zone

    table.insert(zone.rooms, R)

    for _,A in pairs(R.areas) do
      assign_area(A, zone)
    end
  end


  local function other_zone(unwanted_zone)
    local list = {}

    for _,Z in pairs(LEVEL.zones) do
      if Z ~= unwanted_zone then
        table.insert(list, Z)
      end
    end

    if table.empty(list) then
      return unwanted_zone
    end

    return rand.pick(list)
  end


  local function check_if_finished()
    for _,R in pairs(LEVEL.rooms) do
      if not R.zone then return false end
    end

    return true
  end


  local function spread_zones_via_conns(do_locks)
    local conn_list = table.copy(LEVEL.conns)
    rand.shuffle(conn_list)

    for _,C in pairs(conn_list) do
      local R = C.R1
      local N = C.R2

      if R.zone and N.zone then goto continue end

      if not R.zone then R, N = N, R end
      if not R.zone then goto continue end

      -- prefer not to cross quest boundaries
      --if C.lock and not do_locks then goto continue end

      if C.is_secret or C.kind == "teleporter" or C.lock then
        assign_room(N, other_zone(R.zone))

        -- only do one locked connection per group
        if C.lock then return end

        goto continue
      end

      if rand.odds(50) then
        assign_room(N, R.zone)
      end
      ::continue::
    end

-- stderrf("spread_zones_via_conns: done = %s\n", string.bool(is_done))

    return is_done
  end


  local function sort_zones()
    for _,Z in pairs(LEVEL.zones) do
      Z.along = 99

      for _,R in pairs(Z.rooms) do
        Z.along = math.min(Z.along, R.lev_along)
      end
    end

    table.sort(LEVEL.zones, function(A, B)
        return A.along < B.along end)
  end


  local function dump_zones()
    gui.printf("Zone list:\n")

    for _,Z in pairs(LEVEL.zones) do
      gui.printf("  %s : rooms:%d areas:%d\n", Z.name, #Z.rooms, #Z.areas)
    end
  end


  ---| Quest_create_zones |---

  local quota = calc_quota()

  if quota > #LEVEL.quests then
     quota = #LEVEL.quests
  end


  -- handle exit room first
  local exit_zone = Zone_new(LEVEL)

  assign_room(LEVEL.exit_room, exit_zone)


  -- start room(s) are usually the 2nd zone
  local start_zone = exit_zone

  if quota >= 2 then
    start_zone = Zone_new(LEVEL)
  end

  for _,R in pairs(LEVEL.rooms) do
    if R.is_start then
      assign_room(R, start_zone)
    end
  end


  -- handle quest entry rooms
  local quest_list = table.copy(LEVEL.quests)
  rand.shuffle(quest_list)

  for _,Q in pairs(quest_list) do
    -- hit the quota limit?
    if #LEVEL.zones >= quota then break; end

    local R = Q.entry

    if not R or R.zone then goto continue end

    if table.has_elem(Q.rooms, LEVEL.exit_room) then
      --???  assign_room(R, exit_zone)
      goto continue
    end

    assign_room(R, Zone_new(LEVEL))
    ::continue::
  end


  -- flow zones between room connections
  while not check_if_finished() do
    for loop = 1, 50 do
      spread_zones_via_conns(loop == 50)
    end
  end

  -- sanity check
  for _,R in pairs(LEVEL.rooms) do
    assert(R.zone)
  end


  sort_zones()

  Area_spread_zones(LEVEL)

  dump_zones()
end


------------------------------------------------------------------------


function Quest_calc_exit_dists(LEVEL)
  --
  -- For each room, determine a distance metric for the room to the
  -- nearest exit of the quest, which may be the level's exit room.
  -- If a quest does not have any exits, rooms will lack a dist.
  --


  local function mark_exit_to_quest(Q)
    -- find the room which exits into the given quest
    local exit_R

    for _,C in pairs(LEVEL.conns) do
      if C.R1 == Q.entry and C.R2.quest ~= Q then
        exit_R = C.R2
        break;
      end

      if C.R2 == Q.entry and C.R1.quest ~= Q then
        exit_R = C.R1
        break;
      end
    end

    if exit_R then
      assert(exit_R.quest ~= Q)
      exit_R.dist_to_exit = 0
    end
  end


  local function spread_through_conn(C)
    local R1 = C.R1
    local R2 = C.R2

    -- NEVER cross quest boundaries
    --if R1.quest ~= R2.quest then return false end

    if not R1.dist_to_exit then
      R1, R2 = R2, R1
    end

    if not R1.dist_to_exit then
      return false
    end

    local step = 1.0

    if R1.is_hallway or R2.is_hallway then
      step = 0.3
    end

    local new_dist = R1.dist_to_exit + step

    if not R2.dist_to_exit or (R2.dist_to_exit > new_dist) then
      R2.dist_to_exit = new_dist
      return true
    end

    return false
  end


  local function spread_dists()
    local did_spread = false

    for _,C in pairs(LEVEL.conns) do
      if spread_through_conn(C) then
        did_spread = true
      end
    end

    return did_spread
  end


  ---| Quest_calc_exit_dists |---

  LEVEL.exit_room.dist_to_exit = 0

  for _,Q in pairs(LEVEL.quests) do
    mark_exit_to_quest(Q)
  end

  for loop = 1,99 do
    if not spread_dists() then break; end
  end
end



function Quest_start_room(LEVEL)

  local start_quest


  local function find_start_quest()
    -- will be the quest without a current 'entry' area
    for _,Q in pairs(LEVEL.quests) do
      if not Q.entry then
        start_quest = Q
        return
      end
    end

    error("Failed to find starting quest")
  end


  local function eval_start_room(R, alt_mode)
    local score = 1

    -- never in a hallway
    -- TODO : occasionally allow it -- but require a closety void area nearby
    --        which we can use for a start closet
    if R.is_hallway then
      return -1
    end

    -- never in a secret exit room
    -- [ this is a fix for some two-room levels ]
    if R.is_secret_exit then return -1 end

    -- really really don't want to see a goal (like a key)
    if #R.goals > 0 then
      if alt_mode then return -1 end
    else
      score = score + 1000
    end

    -- need somewhere for starting pad, weapon and nice item
    local space = math.min(3, R:usable_chunks())
    score = score + space * 20

    -- far away from first locked door (or exit room)
    score = score + (R.dist_to_exit or 0) * 25

    -- prefer indoors
    if not R.is_outdoor then score = score + 7 end

    -- prefer no teleporter
    if not R:has_teleporter() then score = score + 1 end

    gui.debugf("eval_start_room in %s --> space:%d dist:%d %1.2f\n", R.name, space, math.round(R.dist_to_exit or -1), score)

    -- tie breaker
    return score + gui.random() * 2
  end


  local function pick_best_start(alt_mode)
    local best_R
    local best_score = 0

    for _,R in pairs(LEVEL.rooms) do
      if R.quest ~= start_quest then goto continue end

      local score = eval_start_room(R, alt_mode)

      if score > best_score then
        best_R = R
        best_score = score
      end
      ::continue::
    end

    return best_R
  end


  local function add_normal_start()
    local R = LEVEL.start_room

    if not R then
      R = pick_best_start()
    end

    if not R then
      error("Could not find a usable start room")
    end

    gui.printf("Start room: %s\n", R.name)

    R.is_start = true

    if not LEVEL.start_room then
      LEVEL.start_room  = R
    end

    if not start_quest then
      start_quest = assert(R.quest)
      assert(start_quest.entry == R)
    end

    start_quest.entry = R

    local GOAL = Goal_new(LEVEL, "START")

    table.insert(R.goals, GOAL)
    R.used_chunks = R.used_chunks + 1
  end


  local function partition_coop_players()
    --
    -- Partition players between the two rooms.  Since Co-op is often
    -- played by two people, have a large tendency to place player #1,
    -- and player #2 in different rooms.
    --
    -- Also never place both player #1 and player #2 in the alternate
    -- start room -- as it is possible for the path from an alt start
    -- room to be blocked off be an intraroom lock.
    --

    local set1, set2,

    set1 = { "player1", "player3" }
    set2 = { "player2", "player4" }

    LEVEL.start_room.player_set = set1
    LEVEL.alt_start.player_set = set2
  end


  local function find_alternate_start()
    local R = pick_best_start("alt_mode")

    if not R then return end

    -- OK --

    gui.printf("Alternate Start room: %s\n", R.name)

    R.is_start = true

    LEVEL.alt_start = R

    local GOAL = Goal_new(LEVEL, "START")

    GOAL.alt_start = true

    table.insert(R.goals, GOAL)
    R.used_chunks = R.used_chunks + 1,

    partition_coop_players()
  end


  ---| Quest_start_room |---

  Quest_calc_exit_dists(LEVEL)

  if not LEVEL.start_room then
    find_start_quest()
  end

  add_normal_start()

  if PARAM.bool_alt_starts == 1 then
    find_alternate_start()
  end
end



function Quest_order_by_visit(LEVEL)
  --
  -- Put all rooms in the level into the order the player will most
  -- likely visit them.  When there are choices or secrets, then the
  -- order chosen here will be quite arbitrary.
  --

  local room_along  = 1
  local quest_along = 1

  local next_locs = {}


  local function visit_quest_node(Q)
    if Q.node_id then
      visit_quest_node(Q.before)
      visit_quest_node(Q.after)
      return
    end

    Q.lev_along = quest_along / #LEVEL.quests

    quest_along = quest_along + 1
  end


  local function visit_next_room()
    table.sort(next_locs, function(A, B)
        return A.cost < B.cost end)

    local loc = assert(table.remove(next_locs, 1))

    local R = loc.R

--- stderrf("visit_next_room %s (quest %s along:%1.3f)\n", R.name, R.quest.name, R.quest.lev_along)

    R.lev_along = room_along / #LEVEL.rooms

    room_along = room_along + 1

    -- collect which rooms to visit next
    for _,C in pairs(R.conns) do
      local R2 = C:other_room(R)

      -- done the other room?
      if R2.lev_along then goto continue end

      local loc = { R=R2 }

      -- we MUST honor the quest ordering
      if R2.quest ~= R.quest then
        loc.cost = 100 + 100 * math.max(R2.quest.lev_along, R.quest.lev_along)

      elseif R2.rough_exit_dist then
        loc.cost = 80 - R2.rough_exit_dist

      else
        loc.cost = 0
      end

      -- tie breaker
      loc.cost = loc.cost + gui.random() * 0.1

      table.insert(next_locs, loc)
      ::continue::
    end
  end


  local function dump_quests()
    gui.printf("Quest list:\n")

    for _,Q in pairs(LEVEL.quests) do
      gui.printf("  %s : svolume:%d\n", Q.name, math.round(Q.svolume))
    end
  end


  local function dump_room_order()
    gui.debugf("Room Visit Order:\n")

    for _,R in pairs(LEVEL.rooms) do
      gui.debugf("  %1.3f : %s  %s\n",
                 R.lev_along, R.name, R.quest.name)
    end
  end


  local function do_entry_conns(R, entry_conn, seen)
    R.entry_conn = entry_conn

    seen[R] = 1

    for _,C in pairs(R.conns) do
      local R2 = C:other_room(R)

      if not seen[R2] then
        do_entry_conns(R2, C, seen)
      end
    end
  end


  local function mark_rough_path_to_exit()
    local R = LEVEL.exit_room
    local dist = 0

    while true do
      R.rough_exit_dist = dist

      if not R.entry_conn then
        break;
      end

      R = R.entry_conn:other_room(R)

      dist = dist + 1
    end
  end


  ---| Quest_order_by_visit |---

  do_entry_conns(LEVEL.start_room, nil, {})

  mark_rough_path_to_exit()


  -- sort the quests into a visit order --

  visit_quest_node(LEVEL.quest_root)

  -- sanity check
  for _,Q in pairs(LEVEL.quests) do
    assert(Q.lev_along)
  end

  table.sort(LEVEL.quests, function(A, B)
      return A.lev_along < B.lev_along end)

  dump_quests()


  -- sort the rooms into a visit order --

  table.insert(next_locs, { R=LEVEL.start_room, cost=0 })

  while next_locs[1] do
    visit_next_room()
  end

  -- sanity check
  for _,R in pairs(LEVEL.rooms) do
    if not R.lev_along then
      error("Room not visited: " .. R.name)
    end
  end

  table.sort(LEVEL.rooms, function(A,B)
      return A.lev_along < B.lev_along end)

  dump_room_order()
end



function Quest_find_backtracks(LEVEL)

  local function get_locked_conn(goal)
    for _,C in pairs(LEVEL.conns) do
      if C.lock then
        if table.has_elem(C.lock.goals, goal) then
          return C
        end
      end
    end

    error("cannot find locked connection for a goal")
  end


  local function find_path_between_rooms(R1, R2, seen)
    assert(R1 ~= R2)

    for _,C in pairs(R1.conns) do
      local N = C:other_room(R1)

      if N == R2 then return { C } end

      if seen[N] then goto continue end

      local seen2 = table.copy(seen)
      seen2[R1] = true

      local list = find_path_between_rooms(N, R2, seen2)

      if list then
        table.insert(list, 1, C)
        return list
      end
      ::continue::
    end

    return nil  -- no path
  end


  local function look_for_path(R, goal)
    local C = get_locked_conn(goal)

    local R2 = C.R1
    if C.R2.lev_along < C.R1.lev_along then
      R2 = C.R2
    end

    if R == R2 then return end

    local path = find_path_between_rooms(R, R2, {})

    gui.debugf("look_for_path : %s --> %s  goal %s/%s\n", R.name, R2.name,
               goal.kind, goal.item or "---")

    if not path then
      gui.debugf("   NO PATH\n")
      return
    end

    for _,C2 in pairs(path) do
      gui.debugf("   %s  :  %s <--> %s\n", C2.name, C2.R1.name, C2.R2.name)
    end

    -- convert to room a list
    -- we exclude the goal room, but include the lock-door room

    goal.backtrack = {}

    local cur_room = R

    for _,C2 in pairs(path) do
      assert(cur_room == C2.R1 or cur_room == C2.R2)

      cur_room = C2:other_room(cur_room)

      table.insert(goal.backtrack, cur_room)
    end
  end


  ---| Quest_find_backtracks |---

  for _,R in pairs(LEVEL.rooms) do
    for _,goal in pairs(R.goals) do
      if goal.kind == "KEY" or goal.kind == "SWITCH" then
        look_for_path(R, goal)
      end
    end
  end
end


------------------------------------------------------------------------


function Quest_add_weapons(LEVEL)
  --
  -- The weapons to use on the level are already decided, this function
  -- just decides in which rooms to place them.
  --

  local function should_swap(R1, R2, name1, name2)
    if R1 == R2 then return false end

    if R1.lev_along > R2.lev_along then
      R1, R2 = R2, R1
      name1, name2 = name2, name1
    end

    local info1 = assert(GAME.WEAPONS[name1])
    local info2 = assert(GAME.WEAPONS[name2])

    -- only swap when the ammo is the same
    if info1.ammo ~= info2.ammo then
      return false
    end

    local lev1 = info1.level or 1
    local lev2 = info2.level or 1

    if lev1 ~= lev2 then
      return lev1 > lev2
    end

    -- same level, so test the firepower
    local fp1 = info1.rate * info1.damage
    local fp2 = info2.rate * info2.damage

    return (fp1 > fp2)
  end


  local function reorder_weapons(room_list)
    for idx1 = 1, #room_list do
    for idx2 = idx1 + 1, #room_list do
      local R1 = room_list[idx1]
      local R2 = room_list[idx2]

      for w1 = 1, #R1.weapons do
      for w2 = 1, #R2.weapons do
        local name1 = R1.weapons[w1]
        local name2 = R2.weapons[w2]

        if should_swap(R1, R2, name1, name2) then
          R1.weapons[w1] = name2
          R2.weapons[w2] = name1
        end
      end -- w1, w2,
      end
    end -- idx1, idx2,
    end
  end


  local function do_start_weapons(R)
    if not R then return end

    R.weapons = table.copy(LEVEL.start_weapons)

    R.used_chunks = R.used_chunks + #R.weapons
  end


  local function eval_weapon_room(R)
    -- never in hallways!
    if R.is_hallway then return -200 end

    -- never in secrets!
    if R.is_secret then return -150 end

    -- starting rooms are done separately
    if R.is_start then return -100 end

    -- putting weapons in the exit room is a tad silly
    if R.is_exit then return -50 end

    -- really don't want more than one per room
    if #R.weapons > 0 then return -20 end

    -- basic fitness of the room is # of free chunks
    local score = R:usable_chunks() * 10 + 1

    -- big bonus for leaf rooms
    if R:total_conns("ignore_secrets") < 2 then
      score = score + 45
    end

    -- try to avoid rooms with a goal
    if #R.goals == 0 then
      score = score + 17
    end

    -- Note: tie breaker is added by caller

    return score
  end


  local function usable_rooms_in_zone(Z)
    local count = 0

    for _,R in pairs(Z.rooms) do
      if eval_weapon_room(R) > 0 then
        count = count + 1
      end
    end

    return count
  end


  local function pick_room(Z)
    -- the zone 'Z' can be NIL, meaning try ALL rooms.
    -- also, when a zone is given we skip any "unusable" rooms.

    local list = LEVEL.rooms

    if Z then list = Z.rooms end

    -- evaluate each room and pick the best
    local best_R
    local best_score

    for _,R in pairs(list) do
      local score = eval_weapon_room(R)

      -- unusable room?
      if Z and score < 0 then goto continue end

      -- tie breaker
      score = score + gui.random() * 4

      if not best_R or score > best_score then
        best_R = R
        best_score = score
      end
      ::continue::
    end

--  gui.debugf("|--> %s\n", best_R.name)

    return best_R
  end


  local function do_other_weapons()
    -- copy the weapon list, so we can modify it
    local list = table.copy(LEVEL.other_weapons)

    if table.empty(list) then return end

    local rooms = {}

    -- firstly, assign a weapon to every zone except the first

    for idx = 2, #LEVEL.zones do
      local Z = LEVEL.zones[idx]

      local R = pick_room(Z)

      if R then
        table.insert(R.weapons, table.remove(list, 1))
        table.insert(rooms, R)
      end

      if table.empty(list) then break; end
    end

    -- secondly, if we have any left over then assign to best scoring rooms

    while not table.empty(list) do
      local weapon = table.remove(list, 1)

      local R = pick_room(nil)
      assert(R)

      table.insert(R.weapons, weapon)
      table.insert(rooms, R)
    end

    -- finally, swap weapons if the order seems strange

    if not LEVEL.alt_start then
      table.insert(rooms, 1, LEVEL.start_room)
    end

    reorder_weapons(rooms)
  end


  local function do_the_secret_weapon()
    local best_R
    local best_score = -1

    for _,R in pairs(LEVEL.rooms) do
      if R.is_secret and not R.is_exit and not R.is_hallway then
        local score = R:usable_chunks() * 10
        score = score + gui.random()

        if score > best_score then
          best_R = R
          best_score = score
        end
      end
    end

    if best_R then
      table.insert(best_R.weapons, LEVEL.secret_weapon)
    end
  end


  local function dump_weapons()
    gui.debugf("Weapon assignment:\n")

    for _,R in pairs(LEVEL.rooms) do
      gui.debugf("  %s %s weapons = %s\n", R.zone.name, R.name,
                 table.list_str(R.weapons))
    end
  end


  ---| Quest_add_weapons |---

  if OB_CONFIG.weapons == "none" then
    return
  end

  -- the Co-op alternate start room gets the same weapons
  do_start_weapons(LEVEL.start_room)
  do_start_weapons(LEVEL.alt_start)

  do_other_weapons()

  if LEVEL.secret_weapon then
    do_the_secret_weapon()
  end

  dump_weapons()
end

function Quest_nice_items(LEVEL)
  --
  -- Decides which nice items, including powerups, to use on this level,
  -- especially for secrets but also the start room, unused leaf rooms,
  -- and (rarely) in normal rooms.
  --

  local max_level

  local   start_items
  local  normal_items
  local  closet_items
  local  secret_items
  local storage_items

  local ALL_ITEMS = table.merge(table.copy(GAME.NICE_ITEMS), GAME.PICKUPS)


  local function pick_item(pal)
    if table.empty(pal) then return nil end

    local name = rand.key_by_probs(pal)

    local info = ALL_ITEMS[name]
    assert(info)

    if info.once_only then
       start_items[name] = nil
      normal_items[name] = nil
      closet_items[name] = nil
      secret_items[name] = nil
    end

    --[[ TODO : REVIEW THIS
    if info.kind == "powerup" or info.kind == "weapon" then
      local old_prob = secret_items[name]
      secret_items[name] = old_prob / 8,
    end
    --]]

    return name
  end


  local function pick_different_item(pal, avoid_items)
    -- prevent giving a similar item in a secret closet to an item
    -- explicitly given to the player in a room.

    pal = table.copy(pal)

    for  _,name1 in pairs(avoid_items) do
      local info1 = assert(ALL_ITEMS[name1])

      for name2,val in pairs(pal) do
        local info2 = assert(ALL_ITEMS[name2])

        if info1.kind == info2.kind then
          pal[name2] = val / 100
        end
      end

      -- remove the actual item completely
      pal[name1] = nil
    end

    return pick_item(pal)
  end


  local function secret_palette(do_closet)
    local pal = {}

    for name,info in pairs(ALL_ITEMS) do
      if (info.level or 1) > max_level then
        goto continue
      end

      local prob

      if do_closet then
        prob = info.closet_prob
      else
        prob = info.secret_prob
      end

      if prob and prob > 0 then
        pal[name] = prob
      end
      ::continue::
    end

    return pal
  end


  local function normal_palette()
    local pal = {}

    for name,info in pairs(GAME.NICE_ITEMS) do
      if (info.level or 1) > max_level then
        goto continue
      end

      local prob = info.add_prob

      if prob and prob > 0 then
        pal[name] = info.add_prob
      end
      ::continue::
    end

    return pal
  end


  local function start_palette()
    local pal = {}

    -- Note: no powerups in start room

    for name,info in pairs(GAME.NICE_ITEMS) do
      if (info.level or 1) > max_level then
        goto continue
      end

      if info.kind == "powerup" then
        goto continue
      end

      local prob = info.start_prob or info.add_prob

      if prob and prob > 0 then
        pal[name] = prob
      end
      ::continue::
    end

    return pal
  end


  local function crazy_palette()
    local pal = {}

    for name,info in pairs(GAME.NICE_ITEMS) do
      -- ignore secret-only items
      if not info.add_prob then goto continue end

      pal[name] = info.crazy_prob or 50
      ::continue::
    end

    return pal
  end


  local function have_weapon_for_ammo(ammo)
    for name,info in pairs(GAME.WEAPONS) do
      if info.ammo ~= ammo then goto continue end

      -- the player always has this weapon?
      local classname, hmodel = next(GAME.PLAYER_MODEL)
      assert(hmodel)

      if hmodel.weapons[name] then return true end

      -- the weapon will be placed on this map?
      if table.has_elem(LEVEL.new_weapons, name) then return true end

      -- the weapon is given in a secret on this map?
      if LEVEL.secret_weapon == name then return true end

      -- the weapon was given in an earlier map?
      if PARAM.bool_pistol_starts == 0 and EPISODE.seen_weapons[name] then return true end
      ::continue::
    end

    return false
  end


  local function storage_palette()
    local pal = {}

    for name,info in pairs(ALL_ITEMS) do
      if not info.storage_prob then goto continue end

      -- check if we have a weapon which uses this ammo
      if info.kind == "ammo" and not have_weapon_for_ammo(info.give[1].ammo) then
        goto continue
      end

      if info.storage_prob > 0 then
        pal[name] = info.storage_prob
      end
      ::continue::
    end

    return pal
  end


  local function visit_secret_rooms()
    -- collect all secret leafs
    local rooms = {}

    for _,R in pairs(LEVEL.rooms) do
      if R.is_secret and not R.is_exit and not R.is_hallway and
        table.empty(R.weapons)
      then
        table.insert(rooms, R)
      end
    end

    rand.shuffle(rooms)

    for _,R in pairs(rooms) do
      local item = pick_item(secret_items)

      if item == nil then break; end

      table.insert(R.items, item)

      gui.debugf("Secret Item '%s' --> %s\n", item, R.name)
    end
  end


  local function secret_closets_in_room(R)
    if R.is_secret then return end

    -- chance of using *any* closets in this room
    local any_prob = style_sel("secrets", 0, 30, 60, 90)
    if not rand.odds(any_prob) then
      return
    end

    -- estimate number of usable closets
    local usable = (#R.closets - #R.items - #R.goals)
    if usable < 0 then usable = 0 end
    if usable > 5 then usable = 5 end

    -- rare in start rooms
    if R.is_start then usable = usable * 0.3 end

    -- choose how many to use
    usable = usable * style_sel("secrets", 0, 0.2, 0.3, 0.4)
    usable = rand.int(usable)

    -- pick the items
    for loop = 1, usable do
      local item = pick_different_item(closet_items, R.items)

      if item == nil then break; end

      table.insert(R.closet_items, item)

      gui.debugf("Closet Item '%s' --> %s\n", item, R.name)
    end
  end


  local function handle_secret_closets()
    local rooms = table.copy(LEVEL.rooms)
    rand.shuffle(rooms)

    for _,R in pairs(rooms) do
      secret_closets_in_room(R)
    end
  end


  local function visit_start_rooms()
    -- collect start rooms
    local rooms = {}

    table.insert(rooms, 1, LEVEL.start_room)

    if LEVEL.alt_start then
      table.insert(rooms, 1, LEVEL.alt_start)
    end

    -- apply Items setting
    local quota = 1

    if OB_CONFIG.items == "rare"  and rand.odds(80) then return end
    if OB_CONFIG.items == "less"  and rand.odds(50) then return end

    if OB_CONFIG.items == "more"  and rand.odds(50) then quota = 2 end
    if OB_CONFIG.items == "heaps" and rand.odds(80) then quota = 2 end

    if PARAM.bool_scale_items_with_map_size and PARAM.bool_scale_items_with_map_size == 1 then
      quota = math.round(quota * (1 + (LEVEL.map_W / 75)))
    end

    if quota >= 1 then
      for loop = 1, quota do
        -- add the same item into each start room
        local item = pick_item(start_items)

        if item == nil then break; end

        for _,R in pairs(rooms) do
          table.insert(R.items, item)

          gui.debugf("Start Item '%s' --> %s\n", item, R.name)
        end
      end
    end
  end


  local function eval_other_room(R)
    if R.is_secret  then return -1 end
    if R.is_start   then return -1 end
    if R.is_exit    then return -1 end
    if R.is_hallway then return -1 end

    if R:usable_chunks() < 2 then return -1 end

    -- unused leaf rooms take priority
    if R:is_unused_leaf() then
      return 100 + gui.random()
    end

    local score = 10

    -- TODO : allow a weapon or goal BUT only if room is really large

    if #R.weapons > 0 then return -1 end
    if #R.items   > 0 then return -1 end

    if #R.goals == 0 then score = score + 50 end

    if R:total_conns("ignore_secrets") < 2 then
      score = score + 20
    end

    -- tie breaker
    return score + gui.random()
  end


  local function collect_other_rooms()
    local list = {}

    for _,R in pairs(LEVEL.rooms) do
      local score = eval_other_room(R)

      if score > 0 then
        R.nice_item_score = score

        table.insert(list, R)
      end
    end

    -- sort them (best first)
    table.sort(list, function(A, B)
        return A.nice_item_score > B.nice_item_score end)

    return list
  end


  local function visit_other_rooms()
    local quota = (LEVEL.map_W + LEVEL.map_H + 45) / rand.pick({ 50, 70, 90 })

    if OB_CONFIG.items == "rare"  then quota = quota / 4.0 end
    if OB_CONFIG.items == "less"  then quota = quota / 2.0 end
    if OB_CONFIG.items == "more"  then quota = quota * 2.0 end
    if OB_CONFIG.items == "heaps" then quota = quota * 4.0 end

    if OB_CONFIG.items == "mixed" then quota = quota * rand.pick({ 0.5, 1.0, 2.0 }) end

    quota = rand.int(quota)

    if PARAM.bool_scale_items_with_map_size and PARAM.bool_scale_items_with_map_size == 1 then
      quota = math.round(quota * (1 + (LEVEL.map_W / 75)))
    end

    gui.printf("Other Item quota : %1.2f\n", quota)

    local locs = collect_other_rooms()

    if quota >= 1 then
      for i = 1, quota do
        if table.empty(locs) then break; end

        local R = table.remove(locs, 1)

        local item = pick_item(normal_items)
        if item == nil then break; end

        table.insert(R.items, item)

        gui.debugf("Other Item '%s' --> %s\n", item, R.name)
      end
    end
  end


  local function pick_storage_item(R)
    if table.empty(storage_items) then return end

    local name = rand.key_by_probs(storage_items)
    local info = assert(ALL_ITEMS[name])

    R.storage_items = {}

    for i = 1, info.storage_qty or 1 do
      local pair =
      {
        item  = info,
        count = 1,
        is_storage = true,
        random = gui.random()
      }

      table.insert(R.storage_items, pair)
    end

    gui.debugf("Storage Item '%s' --> %s\n", name, R.name)
  end


  local function find_storage_rooms()
    for _,R in pairs(LEVEL.rooms) do
      -- this test automatically excludes hallways and secrets
      if R:is_unused_leaf() and
         #R.items == 0 and
         not R.rough_exit_dist
      then

        -- store a "minor" item here, e.g. 50 units of health
        pick_storage_item(R)
      end
    end
  end


  local function assign_secondary_importants()
    if not LEVEL.secondary_importants 
    or table.empty(LEVEL.secondary_importants) then return end

    local simp_tab = LEVEL.secondary_importants
    rand.shuffle(simp_tab)

    local room_tab = {}
    local chosen_room

    -- secondary importants table attributes:

    -- level_prob: probability for this SI to appear in map
    -- min_count: minimum number the SI fab should appear in map
    -- max_count: maximum number
    -- not_start: if true, start rooms are excluded from room pick
    -- not_exit: if true, exit rooms are excluded
    -- min_prog: 0-1 value; how far along in the level should
    --   SI fab start spawning
    -- max_prog: 0-1 value; how far along in the level should
    --   SI fab stop spawning

    local function pick_room_for_si(info)
      -- check min and max along rooms in the level
      local max_along_room = 0
      local min_along_room = 1

      local final_min_prog = info.min_prog
      local final_max_prog = info.max_prog
      local avg_prog = (info.min_prog + info.max_prog) / 2

      -- sanity check for when rooms fall out of the along range
      for _,R in pairs(LEVEL.rooms) do
        max_along_room = math.max(max_along_room, R.lev_along)
        min_along_room = math.min(min_along_room, R.lev_along)

        if min_along_room > info.min_prog then
          min_along_room = 0
        end

        if max_along_room < info.max_prog then
          max_along_room = 1
        end
      end

      final_min_prog = math.clamp(min_along_room, final_min_prog, max_along_room)
      final_max_prog = math.clamp(min_along_room, final_max_prog, max_along_room)
      final_distance = math.abs(final_max_prog - final_min_prog)

      for _,R in pairs(LEVEL.rooms) do
        if R.closets
        and not R.secondary_important
        and not R.is_hallway then
          local do_it = true

          if R.lev_along < final_min_prog then
            do_it = false
          end

          if R.lev_along > final_max_prog then
            do_it = false
          end            

          if (info.not_start and R.is_start) or
          (info.not_exit and R.is_exit) or
          (info.not_secret and R.is_secret) then
            do_it = false
          end

          if do_it then
            R.SI_score = math.abs(R.lev_along - avg_prog)
            table.insert(room_tab, R)
          end
        end
      end

      for count = info.min_count or 1, info.max_count do
        if table.empty(room_tab) then goto continue end

        local best_room
        local best_score = 10

        -- pick the room that is closest to the average
        -- of the room progress position choice
        for _,R in pairs(room_tab) do
          if R.SI_score <= best_score then
            best_room = R
            best_score = R.SI_score + rand.range(0, final_distance)
          end
        end

        best_room.secondary_important =
        {
          kind = info.kind
        }

        -- prevent picking the same room if there are
        -- still other rooms available
        if #room_tab > 2 then
          table.kill_elem(room_tab, best_room)
        end

        ::continue::
      end
    end

    for _,SI in pairs(simp_tab) do
      pick_room_for_si(SI)
    end
  end


  ---| Quest_nice_items |---

  max_level = 1 + LEVEL.ep_along * 9

  -- collect all the items we might use
  start_items = start_palette()

  if PARAM.float_strength == 12 then
    normal_items = crazy_palette()
  else
    normal_items = normal_palette()
  end

  closet_items = secret_palette("do_closet")
  secret_items = secret_palette()

  storage_items = storage_palette()

  -- handle the secret sauces first
  visit_secret_rooms()

  if OB_CONFIG.items == "none" then
    gui.printf("Nice Items : disabled (user setting).\n")
  else
    -- start rooms usually get one (occasionally two)
    visit_start_rooms()

    -- TODO help for fighting big bosses
    -- visit_boss_rooms()

    visit_other_rooms()
  end

  handle_secret_closets()

  -- mark all remaining unused leafs as STORAGE rooms
  find_storage_rooms()

  assign_secondary_importants()
end



function Quest_make_room_secret(R)
  R.is_secret = true

  -- hack-fix to prevent small outdoor secret rooms
  -- being porched, and the ceiling line division
  -- causing the fence gate to be b0rked -MSSP
  for _,A in pairs(R.areas) do
    A.is_porch = false
    if R.is_outdoor then
      A.is_outdoor = true
    end
  end

  local C = R:secret_entry_conn()
  assert(C)

  -- when connected to a hallway, make the hallway secret too
  -- (unless hallway connects three or more rooms...)

  local H = C:other_room(R)

  if H.is_hallway and H:total_conns() == 2 then
    H.is_secret = true

    C = H:hallway_other_conn(C)
    assert(C)
  end

  -- mark connection to get a secret door
  C.is_secret = true
end



function Quest_big_secrets(LEVEL)
  --
  -- Finds unused leaf rooms and turns some of them into secrets.
  -- These are "big" secrets, but we also create small ("closet")
  -- secrets elsewhere.
  --

  local max_size = 64 -- 199


  local function eval_secret_room(R)
    if R.is_start   then return -1 end
    if R.is_exit    then return -1 end
    if R.is_hallway then return -1 end

    if #R.goals > 0 then return -1 end

    -- must be a leaf room
    if #R.conns > 1 then return -1 end

    -- cannot teleport into a secret room
    -- [ WISH : support this, a secret teleporter closet somewhere ]
    local conn = R.conns[1]

    if conn.kind == "teleporter" then return -1 end

    if conn.kind == "joiner" then
      -- no L-shape joiners!
      if conn.joiner_chunk.shape ~= "I" then return -1 end
    end

    -- split connections are no good because they create TWO sectors with
    -- the secret special (type #9).
    if conn.F1 then return -1 end

    -- smaller is better (don't waste large rooms)
    if R.svolume > max_size then return -1 end

    local score = max_size - R.svolume + 1

    if conn.kind == "edge" then score = score + 10 end
  
    if R.is_sub_room then score = score * 1.25 end

    -- tie breaker
    return score + gui.random() * 6
  end


  local function collect_possible_secrets()
    local list = {}

    for _,R in pairs(LEVEL.rooms) do
      local score = eval_secret_room(R)

      if score > 0 then
        list[R.id] = score
      end
    end

    return list
  end


  local function pick_room(list)
    assert(not table.empty(list))

    local id = rand.key_by_probs(list)
    list[id] = nil

    for _,R in pairs(LEVEL.rooms) do
      if R.id == id then
        return R
      end
    end

    error("pick secret room failed.")
  end


  ---| Quest_big_secrets |---

  if STYLE.secrets == "none" then
    gui.printf("Secrets: NONE (by style)\n")
    return
  end

  local poss_list  = collect_possible_secrets()
  local poss_count = table.size(poss_list)

  -- quantities : use first possible secret / using the rest
  local first = style_sel("secrets", 0, 0.40, 0.70, 0.90)
  local  rest = style_sel("secrets", 0, 0.25, 0.50, 0.75)

  local quota = 0

  if poss_count >= 1 then
    quota = rand.int(first + rest * (poss_count - 1))
  end

  quota = math.clamp(0, quota, poss_count)

  gui.debugf("Secrets: %d (from %d possible)\n", quota, poss_count)

  -- create them now

  for i = 1, quota do
    local R = pick_room(poss_list)

    Quest_make_room_secret(R)

    gui.debugf("Secret room in %s\n", R.name)
  end
end



function Quest_room_themes(LEVEL)
  --
  -- This decides the room themes to use in each room, and also
  -- various textures (e.g. the fence material for each zone).
  --

  local function match_level_theme(name, override)
    local keyword
    if not override then
      keyword = LEVEL.theme_name
    else
      keyword = override
    end

    if string.match(name, "^any_") or
       string.match(name, "^" .. keyword .. "_")
    then
      return true
    end

    return false
  end


  local function total_volume_of_room_kind(kind)
    -- FIXME : BORKEN !!  (R.kind is not used anymore)

    local vol = 0

    for _,R in pairs(LEVEL.rooms) do
      if R.kind == kind then
        vol = vol + R.svolume
      end
    end

    return vol
  end


  local function collect_usable_themes(env, group, override)
    local tab = {}

    for name,info in pairs(GAME.ROOM_THEMES) do
      if info.kind then
        error("Room theme uses old 'kind' keyword: " .. name)
      end

      if info.prob and
         info.env == env and
         info.group == group and
         match_level_theme(name, override)
      then
        tab[name] = info.prob
      end
    end

    if table.empty(tab) then
      error("No rooms themes found for...\n" ..
      "env: " .. env .. "\n" ..
      "group: " .. group)
    end

    return tab
  end


  local function pick_zone_theme(theme_tab, previous)
    assert(theme_tab)

    local tab = table.copy(theme_tab)

    -- prefer not to use same theme as the last one
    for n = 1,2 do
      local prev = previous and previous[n]

      if prev and tab[prev] then
        tab[prev] = tab[prev] / 4
      end
    end

    local name = rand.key_by_probs(tab)

    return assert(GAME.ROOM_THEMES[name])
  end


  local function pick_building_theme(R, last_R, conn, tab)
    local last_theme

    if last_R and last_R:get_env() == "building" then
      last_theme = last_R and last_R.theme
    end

    if last_theme and table.size(tab) >= 2 then
      assert(conn)

      -- IDEA : make this depend on combined size of both rooms
      local keep_prob = 100
      if last_theme.keep_prob then keep_prob = last_theme.keep_prob end

      -- force theme change over zone boundaries or teleporters
      if R.zone ~= last_R.zone or conn.keyword == "teleporter" then
        keep_prob = 0
      end

      if rand.odds(keep_prob) then
        R.theme = last_theme
        return
      end

      tab = table.copy(tab)
      tab[last_theme.name] = nil
    end

    local name = rand.key_by_probs(tab)

    R.theme = GAME.ROOM_THEMES[name]
    assert(R.theme)
    if not PARAM.bool_avoid_room_theme_reuse or (PARAM.bool_avoid_room_theme_reuse and PARAM.bool_avoid_room_theme_reuse == 1) then
      table.add_unique(SEEN_ROOM_THEMES, R.theme.name)
    end
  end


  local function visit_room(R, last_R, via_conn, theme_tab)
    if R:get_env() == "building" and not R.theme then
      pick_building_theme(R, last_R, via_conn, theme_tab)
    end

    for _,C in pairs(R.conns) do
      local R2 = C:other_room(R)

      if R2.lev_along > R.lev_along then
        visit_room(R2, R, C, theme_tab)
      end
    end
  end


  local function choose_building_themes()
    
    local building_tab = collect_usable_themes("building")

    local max_room_theme = math.round(PARAM.float_max_room_themes or 1)

    if not PARAM.bool_avoid_room_theme_reuse or (PARAM.bool_avoid_room_theme_reuse and PARAM.bool_avoid_room_theme_reuse == 1) then
      for theme,odds in pairs(building_tab) do
        if table.has_elem(SEEN_ROOM_THEMES, theme) then
          building_tab[theme] = nil
        end
      end

      -- Empty seen room themes if all options exhausted
      if table.empty(building_tab) then
        SEEN_ROOM_THEMES = nil
        SEEN_ROOM_THEMES = {}
        building_tab = collect_usable_themes("building")
      end
    end

    while table.size(building_tab) > max_room_theme do
      local theme, odds = rand.table_pair(building_tab)
      if rand.odds(math.max(5, 100 - odds)) then -- Always give at least some chance to prevent infinite loop in case odds are all 100+
        building_tab[theme] = nil
      end
    end

    visit_room(LEVEL.start_room, nil, nil, building_tab)

    local max_wall_groups = math.round(PARAM.float_max_indoor_wall_groups or 2)

    local the_wall_group_tab = table.copy(LEVEL.theme.wall_groups)

    if not PARAM.bool_avoid_wall_group_reuse or (PARAM.bool_avoid_wall_group_reuse and PARAM.bool_avoid_wall_group_reuse == 1) then
      for group,odds in pairs(the_wall_group_tab) do
        if table.has_elem(SEEN_WALL_GROUPS, group) then
          the_wall_group_tab[group] = nil
        end
      end

      -- Empty seen wall groups if all options exhausted
      if table.empty(building_tab) then
        SEEN_WALL_GROUPS = nil
        SEEN_WALL_GROUPS = {}
        the_wall_group_tab = table.copy(LEVEL.theme.wall_groups)
      end
    end

    while table.size(the_wall_group_tab) > max_wall_groups do
      local group, odds = rand.table_pair(the_wall_group_tab)
      if rand.odds(math.max(5, 100 - odds)) then -- Always give at least some chance to prevent infinite loop in case odds are all 100+
        the_wall_group_tab[group] = nil
      end
    end

    -- add prob bias for picked wall groups
    local prob_modifier = 2
    for set,prob in pairs(the_wall_group_tab) do
      prob_modifier = prob_modifier / 2
      the_wall_group_tab[set] = prob_modifier
    end

    for _,R in pairs(LEVEL.rooms) do
      if R:get_env() == "building" then
        if not R.is_exit then
          R.forced_wall_groups = the_wall_group_tab
        end
      end
    end

  end


  local function choose_hallway_themes()
    for _,R in pairs(LEVEL.rooms) do
      if R.is_hallway then
        local tab = collect_usable_themes("hallway", R.hall_group)

        local name = rand.key_by_probs(tab, {})

        R.theme = GAME.ROOM_THEMES[name]
        assert(R.theme)
      end
    end
  end


  local function choose_other_themes()
    local outdoor_tab = collect_usable_themes("outdoor")
    local    cave_tab = collect_usable_themes("cave")

    for _,Z in pairs(LEVEL.zones) do
      Z.outdoor_theme = pick_zone_theme(outdoor_tab)
      Z.   cave_theme = pick_zone_theme(cave_tab)

      -- apply it to all rooms in this zone
      for _,R in pairs(Z.rooms) do
        if R.is_cave then
          R.theme = Z.cave_theme
        elseif R.is_outdoor then
          R.theme = Z.outdoor_theme
        end
      end
    end

    if THEME.outdoor_wall_groups then -- MSSP-TODO: No need for this check
                                      -- once all themes have outdoor_wall_groups?
      LEVEL.outdoor_wall_group = rand.key_by_probs(THEME.outdoor_wall_groups)
      gui.debugf("outdoor_wall_group : " .. LEVEL.outdoor_wall_group .. "\n")
    end

  end


  local function misc_fabs()
    local theme

    for _,R in pairs(LEVEL.rooms) do
      theme = LEVEL.theme_name

      if R.theme.theme_override then
        theme = ob_resolve_theme_keyword(R.theme.theme_override)
      end

      R.fence_group = rand.key_by_probs(THEME.fence_groups)
      R.beam_group = rand.key_by_probs(THEME.beam_groups)
    end

    if PARAM.bool_dynamic_lights == 1 then
      LEVEL.light_group = {}

      local tab = {}
      table.name_up(LIGHT_GROUPS)
      for _,LG in pairs(LIGHT_GROUPS) do
        tab[LG.name] = LG.prob
      end

      local pick = rand.key_by_probs(tab)
      gui.printf("\nLevel light group: " .. pick .. "\n")
      if pick == "all" then goto continue end
      local color_group = LIGHT_GROUPS[pick].shades

      local c_tab = LIGHT_COLORS
      if (OB_CONFIG.game == "doom2"
      or OB_CONFIG.game == "doom1"
      or OB_CONFIG.game == "ultdoom")
      and not PARAM.obsidian_resource_pack_active then
        c_tab = LIGHT_COLORS_COMPAT
      end

      for _,color_set in pairs(color_group) do
        local c_pick = rand.key_by_probs(c_tab[color_set])
        gui.printf("+ light_color: " .. c_pick .."\n")
        LEVEL.light_group[c_pick] = 1
      end

      ::continue::
    end
  end


  local function misc_textures()
--[[  UNUSED ATM
    local outdoor_volume = total_volume_of_room_kind("outdoor")
    local cave_volume    = total_volume_of_room_kind("cave")

    gui.debugf("outdoor_volume : %d\n", outdoor_volume)
    gui.debugf("cave_volume : %d\n", cave_volume)
--]]

    for _,Z in pairs(LEVEL.zones) do
      assert(THEME.fences)

      Z.fence_mat = rand.key_by_probs(THEME.fences)
      Z.cage_mat  = rand.key_by_probs(THEME.cage_mats)
      Z.steps_mat = THEME.steps_mat

      Z.post_type = rand.key_by_probs(THEME.fence_posts)

      Z.scenic_fences = GAME.MATERIALS[rand.key_by_probs(THEME.scenic_fences)]
    end

    for _,R in pairs(LEVEL.rooms) do
      R.scenic_fences = R.zone.scenic_fences

      if R:get_env() == "building" then
        R.cage_mat = rand.key_by_probs(R.theme.floors)
      end
    end
  end


  local function facade_textures()
    if not THEME.facades then
      error("Theme is missing facades table")
    end

    local tab = table.copy(THEME.facades)
    local nature_tab = collect_usable_themes("outdoor")
    local nature_theme = pick_zone_theme(nature_tab)

    for pass = 1,2 do
    for _,Z in pairs(LEVEL.zones) do
      local mat = rand.key_by_probs(tab)
      local nature_mat = rand.key_by_probs(nature_theme.naturals)

      -- less likely to use it again
      tab[mat] = tab[mat] / 20
      nature_theme.naturals[nature_mat] = nature_theme.naturals[nature_mat] / 20

      if pass == 1 then
        Z.facade_mat = mat
        Z.nature_facade = nature_mat
      else
        Z.other_facade = mat
        Z.other_nature_facade = nature_mat
      end
    end -- pass, Z
    end
  end


  local function pick_alternate_tex(tab, prev, num_try)
    for loop = 1, num_try do
      local tex = rand.key_by_probs(tab)

      if tex ~= prev then
        return tex
      end
    end

    return prev
  end


  local function setup_cave_theme(R)
    R.main_tex = rand.key_by_probs(R.zone.cave_theme.walls)

    R.walkway_height = rand.pick { 160, 176, 192, 224 }

    -- floor and ceiling materials --

    local floor_tab = R.zone.cave_theme.floors
    local  ceil_tab = R.zone.cave_theme.ceilings

    if not ceil_tab then ceil_tab = floor_tab end

    R.floor_mat = pick_alternate_tex(floor_tab, R.main_tex, 2)

    if rand.odds(20) then
      R.ceil_mat = R.floor_mat
    elseif rand.odds(60) then
      R.ceil_mat = R.main_tex
    else
      R.ceil_mat = rand.key_by_probs(ceil_tab)
    end

    -- alternate floor and ceiling materials --

    R.alt_floor_mat = pick_alternate_tex(floor_tab, R.floor_mat, 9)

    if R.floor_mat ~= R.ceil_mat and rand.odds(50) then
      R.alt_ceil_mat = R.floor_mat
    elseif R.alt_floor_mat ~= R.ceil_mat and rand.odds(50) then
      R.alt_ceil_mat = R.alt_floor_mat
    else
      R.alt_ceil_mat = pick_alternate_tex(ceil_tab, R.ceil_mat, 9)
    end
  end


  local function setup_room_theme(R)

    local function resolve_room_theme(keyword)
      -- hacky: don't interpret room keywords for Doom 1
      if OB_CONFIG.game == "ultdoom" or OB_CONFIG.game == "doom1" then
        return keyword
      end

      if keyword then
        return ob_resolve_theme_keyword(R.theme.theme_override)
      end

      return keyword
    end

    assert(R.theme)
    local theme = LEVEL.theme_name

    if R.theme.theme_override then
      theme = ob_resolve_theme_keyword(R.theme.theme_override)
    end

    if R.is_cave then
      setup_cave_theme(R)

    elseif R.is_park then
      R.main_tex = R.zone.fence_mat

      R.floor_mat     = rand.key_by_probs(assert(R.theme.naturals))
      R.alt_floor_mat = pick_alternate_tex(R.theme.naturals, R.floor_mat, 3)

    elseif R.is_outdoor then
      if rand.odds(50) then
        R.main_tex = R.zone.facade_mat
      else
        R.main_tex = R.zone.other_facade
      end

      if R.exit_facade then
        R.main_tex = R.exit_facade
      end

      R.floor_mat_list = {}
      R.floor_mat_list_natural = {}

      R.floor_mat_list[rand.key_by_probs(R.theme.floors)] = 100
      R.floor_mat_list[rand.key_by_probs(R.theme.floors)] = 100
      R.floor_mat_list[rand.key_by_probs(R.theme.floors)] = 100
      R.floor_mat_list_natural[rand.key_by_probs(R.theme.naturals)] = 100
      R.floor_mat_list_natural[rand.key_by_probs(R.theme.naturals)] = 100

    else
      R.main_tex = rand.key_by_probs(R.theme.walls)
    end

    if R.is_hallway then
      R.floor_mat = rand.key_by_probs(R.theme.floors)
      R. ceil_mat = rand.key_by_probs(R.theme.ceilings)
    end

    if R.is_natural_park then
      R.main_tex = R.zone.nature_facade
    end

    -- create a skin (for prefabs)
    R.skin =
    {
      wall  = R.main_tex,
      floor = R.floor_mat,  -- can be NIL
      ceil  = R.ceil_mat,   -- ditto
    }

    -- pillarz
    if not R.is_cave or not R.is_park then
      local reqs =
      {
        kind = "pillar",
        where = "point",

        height = EXTREME_H,
        size = 128,
      }

      local def = Fab_pick(LEVEL, reqs)

      R.pillar_def = def
    end
  end


  local function choose_exit_theme()
    local exit_room = LEVEL.exit_room
    local env = exit_room:get_env()
    local next_theme
    local tab = {}

    if exit_room.is_street then return end
    if LEVEL.is_procedural_gotcha then return end

    if GAME.levels[LEVEL.id + 1] then
      next_theme = GAME.levels[LEVEL.id + 1].theme_name
    end

    if next_theme == LEVEL.theme_name then return end
    if not next_theme then return end

    LEVEL.next_theme = next_theme

    if env == "park" then env = "outdoor" end

    tab = collect_usable_themes(env, nil, next_theme)

    exit_room.theme = GAME.ROOM_THEMES[rand.key_by_probs(tab)]

    if not exit_room.theme.theme_override then
      exit_room.theme.theme_override = next_theme
    end

    local f_tab = GAME.THEMES[next_theme].facades
    local wg_tab = GAME.THEMES[next_theme].outdoor_wall_groups

    if wg_tab then
      LEVEL.alt_outdoor_wall_group = rand.key_by_probs(wg_tab)
    else
      LEVEL.alt_outdoor_wall_group = "none"
    end

    LEVEL.exit_windows = rand.key_by_probs(GAME.THEMES[next_theme].window_groups)
    LEVEL.exit_scenic_fence_mat = GAME.MATERIALS[
      rand.key_by_probs(GAME.THEMES[next_theme].scenic_fences)
      ]
    LEVEL.exit_fence = rand.key_by_probs(GAME.THEMES[next_theme].fence_groups)

    if exit_room.is_outdoor and not exit_room.is_park then
      exit_room.exit_facade = rand.key_by_probs(f_tab)
      f_tab[exit_room.exit_facade] = f_tab[exit_room.exit_facade] / 10
      exit_room.alt_exit_facade = rand.key_by_probs(f_tab)
      f_tab[exit_room.exit_facade] = f_tab[exit_room.exit_facade] / 10
    end
  end


  local function room_textures()
    for _,R in pairs(LEVEL.rooms) do
      setup_room_theme(R)
    end
  end


  local function dump_themes()
    gui.debugf("\nRoom themes:\n")

    for _,Z in pairs(LEVEL.zones) do
      gui.debugf("%s:\n", Z.name)
      gui.debugf("   facades   : %s / %s\n", Z.facade_mat, Z.other_facade)
      gui.debugf("   fence     : %s\n", Z.fence_mat)

      for _,R in pairs(Z.rooms) do
        gui.debugf("   %s = %s  (main_tex: %s)\n", R.name, R.theme.name, R.main_tex)
      end
    end
  end


  ---| Quest_room_themes |---

  choose_building_themes()
  choose_hallway_themes()
  choose_other_themes()

  misc_fabs()
  
  if PARAM.bool_foreshadowing_exit and PARAM.bool_foreshadowing_exit == 1 then
    choose_exit_theme()
  end

    misc_textures()
  facade_textures()
    room_textures()

  dump_themes()
end



function Quest_make_quests(LEVEL)

  gui.printf("\n--==| Make Quests |==--\n\n")

  gui.at_level(LEVEL.name .. " (Quests)", LEVEL.id, #GAME.levels)

  Monster_prepare(LEVEL)

  LEVEL.quests = {}
  LEVEL.zones  = {}

  Quest_create_initial_quest(LEVEL)

  Quest_add_major_quests(LEVEL)

  Quest_start_room(LEVEL)
  Quest_order_by_visit(LEVEL)
  Quest_find_backtracks(LEVEL)

  -- this must be after quests have been ordered
  Quest_create_zones(LEVEL)

  Quest_big_secrets(LEVEL)

  Quest_room_themes(LEVEL)

  Quest_add_weapons(LEVEL)

  Quest_nice_items(LEVEL)

  Monster_pacing(LEVEL)
  Monster_assign_bosses(LEVEL)
end
