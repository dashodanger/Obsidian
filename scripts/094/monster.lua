----------------------------------------------------------------
-- MONSTERS/HEALTH/AMMO
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

TOUGH_FACTOR = { easy=0.75, medium=1.00, hard=1.33 }
ACCURACIES   = { easy=0.55, medium=0.66, hard=0.77 }

HITSCAN_RATIOS = { 1.0, 0.8, 0.6, 0.4, 0.2, 0.1 }
MISSILE_RATIOS = { 1.0, 0.4, 0.1, 0.03 }
MELEE_RATIOS   = { 1.0 }

HITSCAN_DODGES = { easy=0.11, medium=0.22, hard=0.33 }
MISSILE_DODGES = { easy=0.71, medium=0.81, hard=0.91 }
MELEE_DODGES   = { easy=0.85, medium=0.95, hard=0.98 }

HEALTH_DISTRIB = { 24, 50, 90, 40, 5 }
AMMO_DISTRIB   = { 50, 80, 50, 10, 2 }


------------------------------------------------------------


zprint = do_nothing
zdump_table = do_nothing


function add_thing(c, bx,by, name, blocking, angle, options, classes)

  local kind = GAME.FACTORY.things[name]
  if not kind then
    error("Unknown thing kind: " .. name)
    return
  end

  local B = PLAN.blocks[bx][by]
  
  if not B then
    error("Thing placed in the void: " .. name)
  end

  if not B.things then B.things = {} end

  local THING =
  {
    name = name,
    kind = kind,
    angle = angle,
    options = options,
    classes = classes
  }

  -- gui.debugf("INSERTING %s INTO BLOCK (%d,%d)\n", kind, c.bx1-1+bx, c.by1-1+by)

  table.insert(B.things, THING)
  table.insert(PLAN.all_things, THING)

  if blocking then
--- DOESNT TAKE SKILLS INTO ACCOUNT: assert(not B.has_blocker)
    B.has_blocker = true
  end

  return THING
end

function add_monster_to_spot(spot, dx,dy, name,info, angle,options)

  local th = add_thing(spot.c, spot.x, spot.y, name, true, angle, options)

  if info.r >= 32 then
    -- Note: cannot handle monsters with radius >= 64 
    dx, dy = dx+32, dy+32
  end

  if spot.dx then dx = dx + spot.dx end
  if spot.dy then dy = dy + spot.dy end

  th.dx = dx
  th.dy = dy

  return th
end


function add_cage_spot(c, spot)

  if not c.cage_spots then
    c.cage_spots = {}
  end

  table.insert(c.cage_spots, spot)
end
  
function rectangle_to_spots(c, x,y, x2,y2)

  local w = x2-x+1
  local h = y2-y+1

  local spots = {}

  local function carve_it_up(x,y, w,h)
    local w2, h2 = math.floor(w/2), math.floor(h/2)
    
    if h > 2 then
      carve_it_up(x, y, w, h2)
      carve_it_up(x, y+h2, w, h-h2)
    elseif w > 2 then
      carve_it_up(x, y, w2, h)
      carve_it_up(x+w2, y, w-w2, h)
    else
      assert(w > 0 and h > 0)

      if (w==2) and (h==2) then
        table.insert(spots, {c=c, x=x, y=y, double=true })
      else
        for dx = 0,w-1 do for dy = 0,h-1 do
          table.insert(spots, {c=c, x=x+dx, y=y+dy})
        end end
      end
    end
  end

  carve_it_up(x,y, w,h)
  
  return spots
end


function find_free_spots(c)

  local function free_spot(bx, by)
--  if not valid_block(bx, by) then return false end

    local B = PLAN.blocks[bx][by]

    return (B and not B.solid and B.f_h and
            (not B.fragments or B.can_thing) and
            not B.has_blocker and not B.is_cage and not B.near_player)
  end

  local function free_double_spot(bx, by)
    local f_min =  99999
    local f_max = -99999

    for dx = 0,1 do for dy = 0,1 do
      if not free_spot(bx+dx, by+dy) then return false end

      local B = PLAN.blocks[bx+dx][by+dy]
      if B.fragments then
        B = B.fragments[1][1]
        assert(B)
      end

      f_min = math.min(f_min, B.f_h)
      f_max = math.max(f_max, B.f_h)
    end end

    return f_max <= (f_min + 10)
  end

  local list = {}
  local total = 0
  for bx = c.bx1,c.bx2,2 do for by = c.by1,c.by2,2 do
    if bx < c.bx2 and by < c.by2 and free_double_spot(bx, by) then
      table.insert(list, { c=c, x=bx, y=by, double=true})
      total = total + 4
    else
      for dx = 0,1 do for dy = 0,1 do
        if bx+dx <= c.bx2 and by+dy <= c.by2 and free_spot(bx+dx, by+dy) then
          table.insert(list, { c=c, x=bx+dx, y=by+dy })
          total = total + 1
        end
      end end
    end
  end end

  return list, total
end


function hm_give_health(HM, value, limit)
  if HM.health < limit then
    HM.health = math.min(HM.health + value, limit)
  end
end


function hm_give_armor(HM, value, limit)
  if HM.armor < limit then
    HM.armor = math.min(HM.armor + value, limit)
  end
end

function hm_give_weapon(HM, weapon, ammo_mul)

  if GAME.FACTORY.hexen_format then

    -- weapon not for our class?
    if string.sub(HM.class, 1,1) ~= string.sub(weapon,1,1) then
      return
    end

    -- already have it?
    if HM[weapon] then return end

    HM[weapon] = true

    -- handle getting all pieces of the mega weapon.
    -- Note: it's OK to check all classes at once here.

    if string.match(weapon, "%a%d_.*") then
      if (HM["f1_hilt"]  and  HM["f2_cross"] and  HM["f3_blade"]) or
         (HM["c1_shaft"] and  HM["c2_cross"] and  HM["c3_arc"])   or
         (HM["m1_stick"] and  HM["m2_stub"]  and  HM["m3_skull"])
      then
        local name = HEXEN.FACTORY.XN_WEAPON_NAMES[HM.class][4]
        assert(name)

        return hm_give_weapon(HM, name)
      end

      -- the pieces are not in the GAME.FACTORY.weapons table, so return now
      return
    end

    -- fall through
  end

  HM[weapon] = true

  local info = GAME.FACTORY.weapons[weapon]
  if not info then
    error("No such weapon: " .. tostring(weapon))
  end

  if info.ammo and info.give then
    if info.ammo == "dual_mana" then
      HM.blue_mana  = HM.blue_mana  + info.give * (ammo_mul or 1)
      HM.green_mana = HM.green_mana + info.give * (ammo_mul or 1)
      return
    end

    HM[info.ammo] = HM[info.ammo] + info.give * (ammo_mul or 1)
  end
end

function hm_give_item(HM, item)

  if item == "backpack" then
    HM.backpack = true
    HM.bullet = HM.bullet + 10
    HM.shell  = HM.shell  + 4 
    HM.rocket = HM.rocket + 1 
    HM.cell   = HM.cell   + 20

  elseif item == "armor" then
    hm_give_armor(HM, 200, 200)

  elseif item == "mega" then
    hm_give_armor (HM, 200, 200)
    hm_give_health(HM, 200, 200)

  elseif item == "berserk" then
    HM.berserk = true
    hm_give_health(HM, 100, 100)

  elseif item == "invis" or item == "invul" then

    HM[item] = (HM[item] or 0) + 6
  end
end

function give_assumed_stuff(list)
  if not list then return end

  for zzz,def in ipairs(list) do
gui.printf("&&&&& give_assumed_stuff: weap=%s &&&&&\n", def.weapon or "-")
    for xxx,CL in ipairs(GAME.FACTORY.classes) do
      for yyy,SK in ipairs(SKILLS) do
        local HM = PLAN.hmodels[CL][SK]
    
        if def.weapon then
          hm_give_weapon(HM, def.weapon)
        else
          -- ????
        end
      end
    end
  end
end


function initial_hmodels()
  local MODELS = {}

  for xxx,CL in ipairs(GAME.FACTORY.classes) do
    MODELS[CL] = { }

    for zzz,SK in ipairs(SKILLS) do
      MODELS[CL][SK] = table.copy(non_nil(GAME.FACTORY.initial_model[CL]))

      MODELS[CL][SK].class = CL
      MODELS[CL][SK].skill = SK
    end
  end

  return MODELS
end


function determine_face_dir(c, x, y, last_dir)

---#  -- randomly rotate last direction
---#  local r = gui.random() * 100
---#
---#      if r <  5 then last_dir = rotate_cw90 (last_dir)
---#  elseif r < 10 then last_dir = rotate_ccw90(last_dir)
---#  elseif r < 40 then last_dir = rotate_cw45 (last_dir)
---#  elseif r < 70 then last_dir = rotate_ccw45(last_dir)
---#  end

  -- find what angles we can face
  local probs = {}

  for dir = 1,9 do
    if dir == 5 then
      probs[dir] = 0
    else
      local dx,dy = dir_to_delta(dir)
      local nx,ny = x+dx, y+dy

      if not valid_block(nx,ny) then
        probs[dir] = 0
      elseif GAME.FACTORY.caps.four_dirs and ((dir%2) == 1) then
        probs[dir] = 0
      else
        local B = PLAN.blocks[nx][ny]
        if not B or B.solid or B.door_kind then
          probs[dir] = 0
        elseif B.fragments then
          probs[dir] = 1
        elseif B.has_blocker then
          probs[dir] = 2
        else
          probs[dir] = 3
        end
      end
    end
  end

  -- check that at least one direction is possible
  local max_prob = 0
  for dir = 1,9 do
    max_prob = math.max(max_prob, probs[dir])
  end

  if max_prob == 0 then
    gui.printf("WARNING: no valid face_dir for monster @ (%d,%d)\n", c.x, c.y)
    return last_dir
  end

  -- convert list into probability table, clearing out the worse
  -- directions and aiming towards the last_dir.

  local function p_dist(d1, d2)
    assert(1 <= d1 and d1 <= 9 and d1 ~= 5)
    assert(1 <= d2 and d2 <= 9 and d2 ~= 5)

    if d1 == d2 then return 60 end

    if d1 == rotate_ccw45(d2) then return 90 end 
    if d1 == rotate_cw45 (d2) then return 90 end 

    if d1 == rotate_ccw90(d2) then return 20 end 
    if d1 == rotate_cw90 (d2) then return 20 end 

    return sel(d1 == 10-d2, 0.1, 1)
  end

  for dir = 1,9 do
    if probs[dir] < max_prob then
      probs[dir] = 0
    else
      probs[dir] = p_dist(dir, last_dir)
    end
  end

  return rand.index_by_probs(probs)
end


----------------------------------------------------------------

-- Simulate the battle for skill SK (2|3|4).
-- Updates the given player HModel.
--
function simulate_battle(HM, mon_set, quest)
 
  local shoot_accuracy = ACCURACIES[HM.skill]

  local active_mon = {}

  local cur_weap = "pistol"
  local remain_shots = 0


  local function dump_active_mon()
    zprint("  Monsters {")
    for zzz,AC in ipairs(active_mon) do
      zprint("    ", AC.name, AC.health)
    end
    zprint("  }")
  end

  local function give_monster_stuff(AC)
    if not GAME.FACTORY.mon_give then return end
    if AC.caged then return end

    local stuff = GAME.FACTORY.mon_give[AC.name]
    if not stuff then return end

    for zzz,item in ipairs(stuff) do
      if item.weapon then
        hm_give_weapon(HM, item.weapon, 0.5) -- dropped
      elseif item.ammo then
        assert(item.ammo ~= "dual_mana")
        HM[item.ammo] = HM[item.ammo] + item.give * 0.5
      else
        error("UKNOWN ITEM GIVEN BY " .. AC.name)
      end
    end
  end

  local function remove_dead_mon()
    for i = #active_mon,1,-1 do
      if active_mon[i].health <= 0 then
        give_monster_stuff(active_mon[i])
        table.remove(active_mon, i)
      end
    end
  end

  local function active_toughness()
    local T = 0
    for zzz,AC in ipairs(active_mon) do
      T = T + AC.health
    end
    return T
  end

  local function hurt_mon(idx, damage)
    local AC = active_mon[idx]
    if AC and AC.health > 0 then
      AC.health = AC.health - damage
    end
  end

  local function hurt_player(damage)
    -- ignore damage when Invulerable
    if HM.invul then return end

    if HM.armor > 0 then
      local saved = damage * 0.4  -- approximation
      if saved < HM.armor then
        HM.armor = HM.armor - saved
      else
        saved = HM.armor
        HM.armor = 0
      end
      damage = damage - saved
    end
    HM.health = HM.health - damage
  end


  local function player_shoot()

    local function select_weapon()

      -- virtual reality mode 
      -- use current weapon for a small time, then switch

      if remain_shots > 0 then return cur_weap end

      local first_mon = active_mon[1].name
      assert(first_mon)

      -- preferred weapon based on monster
      local MW_prefs
      if GAME.FACTORY.mon_weap_prefs then MW_prefs = GAME.FACTORY.mon_weap_prefs[first_mon] end

      local names = {}
      local probs = {}
      
      for name,info in pairs(GAME.FACTORY.weapons) do
        if HM[name] then
          local freq = info.freq
          freq = freq * (MW_prefs and MW_prefs[name] or 1.0)

          table.insert(names, name)
          table.insert(probs, freq)
        end
      end

      assert(#names >= 1)
      assert(#names == #probs)

      local idx = rand.index_by_probs(probs)

      local wp = names[idx]
      local info = GAME.FACTORY.weapons[wp]
      assert(info)

      remain_shots = 1 + gui.random() + gui.random()
      remain_shots = math.floor(remain_shots * info.rate)

      if remain_shots < 1 then remain_shots = 1 end

      return wp
    end

    local function blast_monsters(num, damage)
      for i = 1,num do
        hurt_mon(i, damage * (num - i + 1) / num)
      end
    end

    local function shoot_weapon(name, info)

zprint("PLAYER SHOOT: ", name, remain_shots, "ammo",
info.ammo and HM[info.ammo] or "-")

      hurt_mon(1, info.dm * shoot_accuracy)

zprint(active_mon, #active_mon, active_mon[1])
      -- shotguns can kill multiple monsters
      if (name == "shotty" or name == "super") and
          active_mon[1].health <= 0 and active_mon[2] then
        hurt_mon(2, info.dm * shoot_accuracy / 2.0)
      end

      if name == "bfg"    then blast_monsters(9, 50) end
      if name == "launch" then blast_monsters(3, 64) end

      if info.ammo then
        if info.ammo == "dual_mana" then

          HM["blue_mana"]  = HM["blue_mana"]  - info.per
          HM["green_mana"] = HM["green_mana"] - info.per
        else
          HM[info.ammo] = HM[info.ammo] - info.per
        end
      end

      remain_shots = remain_shots - 1
    end

    ------ player_shoot ------
    --
    -- 1. select weapon
    -- 2. apply damage to monster #1
    -- 2a. if shotgun killed #1, hit monster #2
    -- 2b. for BFG, spray monsters #1..#9
    -- 2c. rocket damage: partial for #1..#3
    -- 3. update ammo
    -- 4. return time taken

    cur_weap = select_weapon()

    local info = GAME.FACTORY.weapons[cur_weap]
    assert(info)

    shoot_weapon(cur_weap, info)

    return 1 / info.rate
  end


  local function monster_shoot(time)

    local function mon_hurts_mon(m1, m2)
      if m1 == m2 then
        return GAME.FACTORY.monsters[m1].hitscan and (m1 ~= "vile")
      end

      if (m1 == "knight" and m2 == "baron") or
         (m1 == "baron"  and m2 == "knight") then
        return false
      end

      return true
    end

    local function distance_ratio(idx, AC)
      -- vile fire is not blocked
      if AC.name == "vile" then return 1 end

      if AC.info.hitscan then return HITSCAN_RATIOS[idx] or 0 end
      if AC.info.melee   then return MELEE_RATIOS[idx] or 0 end
      return MISSILE_RATIOS[idx] or 0
    end

    local function dodge_ratio(AC)
      if AC.info.hitscan then return HITSCAN_DODGES[HM.skill] end
      if AC.info.melee   then return MELEE_DODGES[HM.skill] end
      return MISSILE_DODGES[HM.skill]
    end

    -------- monster_shoot ---------
    -- 
    -- 1. monster #1 does full damage to player
    -- 1a.  (all other melee monsters do ZERO dm)
    -- 2. monster #2..#N does partial damage:
    -- 2a. assuming other monsters get in way
    -- 2b. 2 -> 1/2, 3->1/3, 4->1/5, 5->1/8  factorial
    -- 2c. in-fighting (damage previous mon)
    -- 3. player dodging:
    -- 3a. hitscan: dodged 20%
    -- 3b. missile: dodged 50%
    -- 3c. melee: dodged 80%

    local mon_fight = 0.4

    for idx,AC in ipairs(active_mon) do
      if AC.health > 0 then
        local accuracy = distance_ratio(idx, AC)
        local dodge    = 1.0 - dodge_ratio(AC)

        if HM.invis then dodge = dodge / 1.5 end

        hurt_player(AC.info.dm * (time * mon_fight) * accuracy * dodge)

        -- simulate infighting
        local infight_prob = 0.75
        if idx >= 2 and mon_hurts_mon(AC.name, active_mon[idx-1].name) then
          hurt_mon(idx-1, AC.info.dm * (time * mon_fight) * infight_prob)
        end
      end 
    end
  end

  local function update_powerups(HM)

    if HM.invis then
      HM.invis = HM.invis - 1
      if HM.invis <= 0 then
        HM.invis = nil
        zprint("LOST POWERUP:", "invis")
      end
    end

    if HM.invul then
      HM.invul = HM.invul - 1
      if HM.invul <= 0 then
        HM.invul = nil
        zprint("LOST POWERUP:", "invul")
      end
    end
  end

  local function handle_quest()
    if quest then
      if quest.kind == "weapon" then
        hm_give_weapon(HM, quest.item)
        zprint("PICKED UP QUEST WEAPON", quest.item)
      
      elseif quest.kind == "item" then
        hm_give_item(HM, quest.item)
        zprint("PICKED UP QUEST ITEM", quest.item)
      end
    end
  end

  ---=== simulate_battle ===---

  update_powerups(HM)  -- tick 1 of 2

  -- create list of monsters
  assert(mon_set)

  for zzz,th in ipairs(mon_set) do
    for num = 1,th.horde do
      table.insert(active_mon,
        { name=th.name, info=th.info, health=th.info.hp, caged=th.caged })
    end
  end

  if #active_mon == 0 then
    update_powerups(HM)  -- tick 2 of 2
    handle_quest(do_quest)

    return
  end

  -- put toughest monster first, weakest last.
  table.sort(active_mon, function(A,B) return A.health > B.health end)

  local do_quest = true

  local total_time = 0
  local round_time

  local total_tough = active_toughness()

  repeat

zprint("\n  ----------------------\n")
zprint("  Time ", total_time)
dump_active_mon(active_mon)
zdump_table(HM, "HModel")

    round_time = player_shoot()

    monster_shoot(round_time)

    remove_dead_mon()

    -- get quest item at the half-way point
    if do_quest and active_toughness() < total_tough/2 then
      update_powerups(HM) -- tick 2 of 2
      handle_quest()

      do_quest = nil
    end

    total_time = total_time + round_time

  until #active_mon == 0

  assert(not do_quest)

zprint("BATTLE OVER.")
zdump_table(HM, "HModel")
zprint("\n\n\n")
end


----------------------------------------------------------------

PICKUP_PATTERNS =
{
  { 0,0 },

  { -0.5,0,  0.5,0 },

  { -0.7,-0.7, 0.7,0.7 },

  { -1,-1, 0,0, 1,1 },
  { -1,0,  0,0, 1,0 },

  { -1,-1, 0,1, 1,-1 },

  { -1,-1, 1,-1,      -1,1, 1,1 },
  { -1,-1, 1,-1, 0,0, -1,1, 1,1 },

  { -1,0, 0,-1,      1,0, 0,1 },
  { -1,0, 0,-1, 0,0, 1,0, 0,1 },

  { -1,-1, -0.3,-0.3, 0.3,0.3, 1,1 },

  { -1,-1, 0,-1, 1,-1,  -1,0,      1,0,  -1,1, 0,1, 1,1 },
  { -1,-1, 0,-1, 1,-1,  -1,0, 0,0, 1,0,  -1,1, 0,1, 1,1 },

  { -1,-1, -0.3,-1, 0.3,-1, 1,-1,  -1,1, -0.3,1, 0.3,1, 1,1 },

  { -1,0, 0,-1, 1,0, 0,1,  -0.7,-0.7, 0.7,-0.7, -0.7,0.7, 0.7,0.7 },

  { -1,0, -0.5,0, 1,0, 0.5,0,  0,-1, 0,-0.5, 0,1, 0,0.5 },
}

function select_cluster_pattern(count, maximum)

  if count <= 1 then return PICKUP_PATTERNS[1] end

  -- first try for an exact match
  local probs = {}
  local got_exact = false

  for i,pat in ipairs(PICKUP_PATTERNS) do
    probs[i] = 0
    if (#pat/2) == count then probs[i] = 90; got_exact = true end
  end

  -- if that fails, look for the closest match
  if not got_exact then
    for i,pat in ipairs(PICKUP_PATTERNS) do
      probs[i] = 0
      if (#pat/2) <= maximum then
        probs[i] = 90 / (1 + math.abs(#pat/2 - count)) ^ 2
      end
    end
  end

  return PICKUP_PATTERNS[rand.index_by_probs(probs)]
end


function distribute_pickups(c, HM, backtrack)

  local R -- table[SKILL] -> required num


  local function add_pickup(c, name, info, cluster)

    if not cluster then
      cluster = select_cluster_pattern(1)
    end

    if not c.pickup_set then
      c.pickup_set = { }
      for xxx,CL in ipairs(GAME.FACTORY.classes) do
        c.pickup_set[CL] = { easy={}, medium={}, hard={} }
      end
    end

    table.insert(c.pickup_set[HM.class][HM.skill], { name=name, info=info, cluster=cluster })
  end


  local function be_nice_to_player()

    if not GAME.FACTORY.niceness then return end

    for zzz,ndef in pairs(GAME.FACTORY.niceness) do
      local prob = ndef.prob

      if ndef.always and c == c.quest.path[#c.quest.path - 1] then prob=99 end
      if ndef.weapon and HM[ndef.weapon] then prob=1 end
      if ndef.quest  and c.quest.level < ndef.quest then prob = 0 end

      if rand.odds(prob) then
        if ndef.weapon then
          local info = GAME.FACTORY.weapons[ndef.weapon]
          assert(info)

          add_pickup(c, ndef.weapon, info)
          hm_give_weapon(HM, ndef.weapon)
          return;

        elseif ndef.pickup then
          local info = GAME.FACTORY.pickups[ndef.pickup]  -- may be nil

          add_pickup(c, ndef.pickup, info)

          if info and (info.stat == "armor") then
            hm_give_armor(HM, info.give, info.limit or info.give)
          else
            -- ????
          end

          return;
        else
          error("Bad NICENESS table!")
        end
      end
    end
  end

  local function adjust_hmodel(HM)

    -- apply the user's health/ammo adjustments here

    local HEALTH_ADJUSTS = 
    { 
      none=0,
      scarce=0.35,
      less=0.7,
      bit_less=0.85, 
      normal=1.0,
      bit_more=1.2, 
      more=1.4,
      heaps=1.6
    }
    local   AMMO_ADJUSTS = 
    { 
      none=0,
      scarce=0.4,
      less=0.8,
      bit_less=1.0, 
      normal=1.2,
      bit_more=1.4, 
      more=1.6,
      heaps=1.8 
    }

    local health_mul = HEALTH_ADJUSTS[OB_CONFIG.health]
    local   ammo_mul =   AMMO_ADJUSTS[OB_CONFIG.ammo]

    for zzz,stat in ipairs(GAME.FACTORY.pickup_stats) do
      if stat == "health" then
        if HM.health < 70 then
          HM.health = (HM.health-70) * health_mul + 70
        end
      else
        if HM[stat] < 0 then HM[stat] = HM[stat] * ammo_mul end
      end
    end
  end

  local function compute_want(stat)
    return sel(stat == "health", 70, 0)
  end

  local function decide_pickup(stat, R)

    local infos = {}
    local probs = {}
    local names = {}

    for name,info in pairs(GAME.FACTORY.pickups) do
      if info.stat == stat then
        if info.give <= R * 2 then
          local prob = info.prob or 50
          if info.give > R then
            prob = prob / 3
          end
          table.insert(names, name)
          table.insert(infos, info)
          table.insert(probs, prob)
        end
      end
    end

    if #infos == 0 then return nil, nil end  -- SHIT!

    local idx = rand.index_by_probs(probs)
    local th_info = infos[idx]

    local count = 1 + math.floor(R / th_info.give)
    if GAME.FACTORY.caps.blocky_items then count = 1 end

    if th_info.clu_max then count = math.min(count, th_info.clu_max) end

    local cluster = select_cluster_pattern(count, count)
    assert(#cluster/2 <= count)

    return names[idx], th_info, cluster
  end

  local function get_distrib_targets(c)
    local distrib = table.copy(AMMO_DISTRIB)
    local targets = {}

    for n = 1,5 do
      local idx = c.along + n - 3
      if (1 <= idx) and (idx <= #c.quest.path) then
        targets[n] = c.quest.path[idx]
      else
        distrib[n] = 0
      end
    end

    return distrib, targets
  end

  local function add_coop_pickup(targets, ...)
    add_pickup(targets[3], ...)

    local L = targets[2] or targets[1] or targets[4]
    local H = targets[4] or targets[5] or targets[2]

    if L and rand.odds(70) then
      add_pickup(L, ...)
    end

    if H and rand.odds(70) then
      add_pickup(H, ...)
    end

    if not L and not H then
      add_pickup(targets[3], ...)
    end
  end


  ---=== distribute_pickups ===---

  local distrib, targets = get_distrib_targets(c)

  if not backtrack then
    be_nice_to_player()
  end

  adjust_hmodel(HM)

  for zzz,stat in ipairs(GAME.FACTORY.pickup_stats) do

    local want = compute_want(stat, HM)

    -- create pickups until target reached
    while HM[stat] < want do

      local r_max = want - HM[stat]

      local name, info, cluster = decide_pickup(stat, r_max)

      if not info then break end

      if PLAN.coop and stat ~= "health" then
        add_coop_pickup(targets, name, info, cluster)
      else
        local tc = targets[rand.index_by_probs(distrib)]
        add_pickup(tc, name, info, cluster)
      end

      HM[stat] = HM[stat] + #cluster/2 * info.give
    end
  end
end


function place_battle_stuff(c, stats)

  local CL, SK

  local function copy_shuffle_spots(list)
    local copies = {}
    for zzz, spot in ipairs(list) do
      table.insert(copies, table.copy(spot))
    end
    rand.shuffle(copies)
    return copies
  end

  local function dump_spots(list)
    gui.debugf("{\n")
    for zzz, sp in ipairs(list) do
      gui.debugf("  (%d,%d) %s", sp.x, sp.y, sel(sp.double, "DOUBLE", "-"))
    end
    gui.debugf("}\n")
  end

  local function split_big_spots(list)

    -- iterate using integer indices, hence we can add new spots
    -- to the end of the list without affecting the traversal.

    for idx = 1,#list do
      local spot = list[idx]

      if spot.double then
        table.insert(list, { c=spot.c, x=spot.x+1, y=spot.y+0 })
        table.insert(list, { c=spot.c, x=spot.x+0, y=spot.y+1 })
        table.insert(list, { c=spot.c, x=spot.x+1, y=spot.y+1 })

        spot.double = nil
      end
    end

    -- intermingle the new singles
    rand.shuffle(list)
  end
  
  local function spot_dist(s1, s2)
    local dx = math.abs(s1.x - s2.x)
    local dy = math.abs(s1.y - s2.y)
    return math.max(dx, dy)
  end
  
  local function alloc_spot(spots, want_big, near_to)

    if #spots == 0 then return nil, nil end

    if want_big then
      for i = 1,#spots do
        if spots[i].double then
          return table.remove(spots, i)
        end
      end

      return nil, nil
    end

    if near_to then
      local best = 0
      local best_d = 999

      -- our search is not exhaustive (too expensive!)
      for i = 1,math.min(#spots,10) do
        local d = spot_dist(spots[i], near_to)
        if d < best_d then best, best_d = i, d end
      end

      if best > 0 then
        return table.remove(spots, best)
      end
    end

    -- assume that once 'want_big' is false, all the doubles have
    -- been split up.
    assert(not spots[1].double)

    return table.remove(spots, 1)
  end

  local function place_pickup(spots, dat)

    local spot = alloc_spot(spots, dat.cluster.is_big)

    if not spot then
      spot = alloc_spot(spots, false)
    end

    if not spot then
      gui.printf("UNABLE TO PLACE PICKUP: %s x%d\n", dat.name, #dat.cluster/2)
      -- FIXME: put in next cell
      return
    end

    local options = { [SK]=true }
    local classes = { [CL]=true }

    local mirror = rand.odds(50)
    local rotate = rand.odds(50)

    local d_mul = sel(dat.cluster.is_big, 40, 20)

    for i = 1,#dat.cluster,2 do

      local dx = dat.cluster[i]   * d_mul
      local dy = dat.cluster[i+1] * d_mul

      if mirror then dx = -dx end
      if rotate then dx,dy = dy,dx end

      if spot.double then dx,dy = dx+32,dy+32 end

      local th = add_thing(c, spot.x, spot.y, dat.name, false, 0, options, classes)

      th.dx = dx + (spot.dx or 0)
      th.dy = dy + (spot.dy or 0)

      -- statistics....
      if dat.info then
        if dat.info.stat == "health" then
          stats[SK].health = stats[SK].health + dat.info.give
        elseif dat.info.stat ~= "armor" then
          -- not quite right, but close enough...
          stats[SK].ammo = stats[SK].ammo + (dat.info.give or 1)
        end
      end
    end
  end

  local function place_pickup_list(pickups)

    local spots = copy_shuffle_spots(c.free_spots)

    -- perform two passes, place big clusters first
    for pass = 1,2 do
      for zzz,dat in ipairs(pickups) do
        if (pass~=1) == (not dat.cluster.is_big) then
          place_pickup(spots, dat)

          -- re-use spots if we run out
          if #spots == 0 then 
            spots = copy_shuffle_spots(c.free_spots)
            if pass == 2 then split_big_spots(spots) end
          end
        end
      end

      split_big_spots(spots)
    end
  end

  local function place_monster(spots, dat)
    assert(dat.info)

    if dat.caged then return end

    local face_dir
    repeat face_dir = rand.irange(1,9) until face_dir ~= 5

    local is_big = (dat.info.r >= 32)
    local spot = alloc_spot(spots, is_big)

    for i = 1,dat.horde do

      if not spot then
        gui.printf("UNABLE TO PLACE MONSTER: %s x%d\n", dat.name, dat.horde)
        -- FIXME: put in next cell
        return
      end

      local options = { [SK]=true }

      if rand.dual_odds(c == c.quest.last, 88, 44) then
        options.ambush = true
      end

      face_dir = determine_face_dir(spot.c, spot.x, spot.y, face_dir)

      add_monster_to_spot(spot, 0,0, dat.name, dat.info,
                          dir_to_angle(face_dir), options)

      stats[SK].monsters = stats[SK].monsters + 1
      stats[SK].power = stats[SK].power + dat.info.pow

      spot = alloc_spot(spots, is_big, spot)
    end
  end

  local function place_monster_list(mons)

    local spots = copy_shuffle_spots(c.free_spots)

    -- perform two passes, place big monsters first
    for pass = 1,2 do
      for zzz, dat in ipairs(mons) do
        local info = GAME.FACTORY.monsters[dat.name]
        if (pass==1) == (info.r >= 32) then
          place_monster(spots, dat)
        end
      end

      split_big_spots(spots)
    end

  end

  --- place_battle_stuff ---

  if GAME.FACTORY.caps.elevator_exits and c.is_exit then return end

  for zzz,skill in ipairs(SKILLS) do
    SK = skill

    for xxx,clazz in ipairs(GAME.FACTORY.classes) do
      CL = clazz
      if c.pickup_set then
        place_pickup_list(c.pickup_set[CL][SK])
      end
    end

    if c.mon_set then
      place_monster_list(c.mon_set[SK] )
    end
  end
end

function place_quest_stuff(Q, stats)
  assert(stats)

  for zzz,c in ipairs(Q.path) do
    if c.mon_set or c.pickup_set then
      place_battle_stuff(c, stats)
      c.mon_set = nil
      c.pickup_set = nil
    end
  end
end


----------------------------------------------------------------


function battle_in_cell(c)

  local T, U, SK

  local function T_average()
    return (T.easy + T.medium + T.hard) / 3.0
  end

  local function T_max()
    return math.max(T.easy, T.medium, T.hard)
  end

  local function best_weapon_fp(skill)

    local fp = 0

    -- note: for Hexen we check _all_ classes, which is OK
    -- because the quest structure means every class gets
    -- weapon #2 (for example) at the same time.

    for name,info in pairs(GAME.FACTORY.weapons) do
      for xxx,CL in ipairs(GAME.FACTORY.classes) do
        local HM = PLAN.hmodels[CL][skill]
        if HM[name] and info.fp > fp then
          fp = info.fp
        end
      end
    end

    return fp
  end

  local function decide_monster(fp)

    local names = { "none" }
    local probs = { 30     }

    for name,info in pairs(GAME.FACTORY.monsters) do
      if (info.pow < T*2) and (fp >= math.floor(info.fp)) then

        local prob = info.prob * (c.mon_prefs[name] or 1)

        if info.pow > T then
          prob = prob * (2 - info.pow / T) ^ 1.7
        end
        if (fp < info.fp) then
          prob = prob * (1 - (info.fp - fp))
        end

        table.insert(names, name)
        table.insert(probs, prob)
      end
    end

    if #probs == 1 then return nil, nil end

    local idx = rand.index_by_probs(probs)
    local name = names[idx]

    if name == "none" then return name, 0 end

    local info = GAME.FACTORY.monsters[name]
    assert(info)

    return name, info
  end

  local function decide_monster_horde(info)
    local horde = 1
    local max_horde = 1 + math.floor(T / info.pow)

    if info.hp <= 500 and rand.odds(30) then horde = horde + 1 end
    if info.hp <= 100 then horde = horde + rand.index_by_probs { 90, 40, 10, 3, 0.5 } end

    return math.min(horde, max_horde)
  end

  local function determine_mon_prefs(c)
    if c.mon_prefs then return end

    c.mon_prefs = table.copy(GAME.FACTORY.monster_prefs or {})

    local function merge_prefs(tab)
      if tab then
        for name,mul in pairs(tab) do
          c.mon_prefs[name] = (c.mon_prefs[name] or 1) * mul
        end
      end
    end

    merge_prefs(c.quest.theme.monster_prefs)
    merge_prefs(c.room_type.monster_prefs)
    merge_prefs(c.combo.monster_prefs)

  end

  local function create_monsters()

    local fp = best_weapon_fp(SK)

    -- create monsters until T is exhausted
    for loop = 1,99 do
      local name, info = decide_monster(fp)

      if not name then break end

      if name == "none" then
        T = T-20; U = U+20
      else
        horde = decide_monster_horde(info)
        table.insert(c.mon_set[SK], { name=name, horde=horde, info=info })
        T = T - horde * info.pow
      end
    end
  end

  local function decide_cage_monster(T, fp, x_horde, allow_big, allow_horde, is_surprise)

    local names = {}
    local probs = {}

    for name,info in pairs(GAME.FACTORY.monsters) do
      if (info.cage_fallback) or 
         ((info.pow < T*2/x_horde) and (fp >= math.floor(info.fp)))
      then
        local prob = info.cage_prob or info.cage_fallback or 0

        if is_surprise and (fp < info.fp) then
          prob = prob * (1 - (info.fp - fp))
        end

        if info.melee and not is_surprise then prob = 0 end
        if info.r >= 31 and not allow_big then prob = 0 end

        if prob > 0 then
          table.insert(names, name)
          table.insert(probs, prob)
        end
      end
    end

    assert(#probs > 0)

    local idx = rand.index_by_probs(probs)
    local info = GAME.FACTORY.monsters[names[idx]]
    assert(info)

    return names[idx], info
  end

  local function decide_cage_horde(spot, info)
    if not spot.double then return 1 end

    if info.r >= 31 then return 1 end  ---### >= 25

    if info.hp <= 100 then return rand.index_by_probs { 10, 30, 50, 70 } end
    if info.hp <= 450 then return rand.index_by_probs { 10, 30, 50 } end

    return rand.index_by_probs { 10, 30 }
  end

  local function fill_cages()

    if not c.cage_spots then return end

    local orig_T = T

    local fp = best_weapon_fp(SK)
 
    local small = decide_cage_monster(T, fp, #c.cage_spots)
    local big   = decide_cage_monster(T, fp, #c.cage_spots, true, true)

    for zzz,spot in ipairs(c.cage_spots) do

      local name
      if true then -- spot.different then
        name = decide_cage_monster(T, fp, sel(spot.double,2,1), spot.double, spot.double)
      else
        name = sel(spot.double, big, small)
      end

      local info = GAME.FACTORY.monsters[name]
      assert(info)

      local horde = decide_cage_horde(spot, info)

      for i = 1,horde do
        local dx = math.floor((i-1)%2) * 64
        local dy = math.floor((i-1)/2) * 64

        local angle = rand.irange(0,7) * 45
        local options = { [SK]=true }

        add_monster_to_spot(spot, dx,dy, name,info, angle,options)

        -- allow monster to take part in battle simulation
        table.insert(c.mon_set[SK], { name=name, horde=1, info=info, caged=true })

        -- caged monsters affect the total toughness
        T = T - info.pow
      end
    end

    -- don't use up all the toughness, allow non-caged monsters
    T = math.max(T, orig_T / 3)
  end

  local function try_fill_closet(surprise)
    if not surprise or surprise.trigger_cell ~= c then return end

    local fp = best_weapon_fp(SK)

    local CT = surprise.toughness * TOUGH_FACTOR[SK]

    for zzz,place in ipairs(surprise.places) do
      for yyy,spot in ipairs(place.spots) do

        local allow_big = not surprise.depot_cell and spot.double
        local name, info = decide_cage_monster(CT, fp, #place.spots, allow_big, spot.double, true)
        assert(name)

        local horde = decide_cage_horde(spot, info)

        for i = 1,horde do
          local dx = math.floor((i-1)%2) * 64
          local dy = math.floor((i-1)/2) * 64

          local angle = delta_to_angle(5-(spot.x+dx/64), 5-(spot.y+dy/64))
          local options = { [SK]=true }

          add_monster_to_spot(spot, dx,dy, name,info, angle,options)

          table.insert(place.mon_set[SK], { name=name, horde=1, info=info, caged=true })
        end
      end  -- spots
    end  -- places

    -- health/ammo are added later (in backtrack_to_cell)
  end

  local function fill_closets()
    try_fill_closet(c.quest.closet)
    try_fill_closet(c.quest.depot)
  end

  local function add_teleports_for_depot(spots)
    local prev
    
    for zzz,place in ipairs(c.quest.depot.places) do
      if place.c == c then

        if not prev or #spots >= 3 then
          prev = table.remove(spots)
        end

        if not prev then
          gui.printf("WARNING: No room for TELEPORTER @ (%d,%d)\n", c.x, c.y)
          return
        end

        gui.debugf("ADD_TELEPORTER @ (%d,%d) tag: %d\n", c.x, c.y, place.tag)

        local x,y = prev.x, prev.y
        add_thing(c, x, y, "teleport_spot", true)
        PLAN.blocks[x][y].tag = place.tag
      end
    end
  end

  ---=== battle_in_cell ===---

  if GAME.FACTORY.caps.elevator_exits and c.is_exit then return end

zprint("BATTLE IN", c.x, c.y)

  local spots, free_space = find_free_spots(c) --FIXME: move out of here
  rand.shuffle(spots)
  c.free_spots = spots

  if c.quest.depot then
    add_teleports_for_depot(c.free_spots)
  end

  if free_space < 2 then return end
  free_space = free_space * 1.5 / (BW * BH)  -- FIXME: remove BW

  c.mon_set = { easy={}, medium={}, hard={} }

  determine_mon_prefs(c)

  local last_T = 0

  if not PLAN.left_overs then
    PLAN.left_overs = { easy=0, medium=0, hard=0 }
  end

  if c.no_monsters then return end

  for zzz,skill in ipairs(SKILLS) do
  
    SK = skill

    T = c.toughness * (free_space ^ 0.7) * TOUGH_FACTOR[SK]
    T = T + PLAN.left_overs[SK]
    U = 0

    if GAME.FACTORY.caps.tiered_skills then
      T, last_T = T - last_T, T
    end

    fill_closets()
    fill_cages()

    create_monsters(space)

    -- left over toughness gets compounded (but never decreased)
    PLAN.left_overs[SK] = math.max(0, T + U)

    local quest = sel(c == c.quest.last, c.quest, nil)

zprint("SIMULATE in CELL", c.x, c.y, SK)

    for xxx,CL in ipairs(GAME.FACTORY.classes) do

      simulate_battle(PLAN.hmodels[CL][SK], c.mon_set[SK], quest)

      distribute_pickups(c, PLAN.hmodels[CL][SK])
    end
  end
end


function backtrack_to_cell(c)

  local function surprise_me(surprise)
    for zzz,place in ipairs(surprise.places) do
      if c == place.c then
        for xxx,CL in ipairs(GAME.FACTORY.classes) do
          for zzz,SK in ipairs(SKILLS) do
            simulate_battle(PLAN.hmodels[CL][SK], place.mon_set[SK]) 
            distribute_pickups(c, PLAN.hmodels[CL][SK], "backtrack")
          end
        end
      end
    end
  end

  if GAME.FACTORY.caps.elevator_exits and c.is_exit then return end

  if c.quest.closet then
    surprise_me(c.quest.closet)
  end

  if c.quest.depot then
    surprise_me(c.quest.depot)
  end
end


function battle_in_quest(Q)

  give_assumed_stuff(Q.assumed_stuff)

  for zzz,c in ipairs(Q.path) do
    if c.toughness then
      battle_in_cell(c)
    end
  end

  for idx = #Q.path,1,-1 do
    local c = Q.path[idx]
    if c.toughness then
      backtrack_to_cell(Q.path[idx])
      c.toughness = nil
    end
  end
end

function dump_battle_stats(stats)
  gui.printf("\n")
  gui.printf("BATTLE STATS\n")

  for zzz,SK in ipairs(SKILLS) do
    gui.printf("%7s | h:%4d  ammo:%4d  mon:%4d  pow:%5f\n", SK,
      stats[SK].health, stats[SK].ammo,
      stats[SK].monsters, stats[SK].power)
  end

  gui.printf("\n")
end

function battle_through_level()

  -- step 1: decide monsters, simulate battles, decide health/ammo

  for zzz,Q in ipairs(PLAN.quests) do
    battle_in_quest(Q)
  end

  -- step 2: place monsters and health/ammo into level

  local stats =
  {
    easy   = { health = 0, ammo = 0, monsters = 0, power = 0 },
    medium = { health = 0, ammo = 0, monsters = 0, power = 0 },
    hard   = { health = 0, ammo = 0, monsters = 0, power = 0 },
  }

  for zzz,Q in ipairs(PLAN.quests) do
    place_quest_stuff(Q, stats)
  end

  dump_battle_stats(stats)
end

----------------------------------------------------------------

function deathmatch_in_cell(c)

  local SK

  local HEALTH_PROBS_1 = 
  { 
    none=0, 
    scarce=20, 
    less=33, 
    bit_less=40,
    normal=50,
    bit_more=60, 
    more=75,
    heaps=85 
  }
  local HEALTH_PROBS_2 = 
  { 
    none=0,
    scarce=7,
    less=15,
    bit_less=18, 
    normal=20,
    bit_more=30, 
    more=40,
    heaps=50
  }

  local AMMO_PROBS_1 = 
  { 
    none=0,
    scarce=20,
    less=40,
    bit_less=55,
    normal=70,
    bit_more=80,
    more=90,
    heaps=95
  }
  local AMMO_PROBS_2 = 
  { 
    none=0,
    scarce=7,
    less=15,
    bit_less=22,
    normal=30,
    bit_more=40,
    more=50,
    heaps=70 
  }

  local ITEM_PROB = 10

  local function add_dm_pickup(name)
    local min_cluster = 1
    local max_cluster = 1

    if GAME.FACTORY.dm.min_clu then min_cluster = GAME.FACTORY.dm.min_clu[name] or 1 end
    if GAME.FACTORY.dm.max_clu then max_cluster = GAME.FACTORY.dm.max_clu[name] or 1 end

    local count = rand.irange(min_cluster, max_cluster)
    local cluster = select_cluster_pattern(count, max_cluster)

--gui.printf("DM PICKUP '%s' @ (%d,%d) skill:%s\n", name, c.x, c.y, SK)

    local info = GAME.FACTORY.pickups[name] -- may be nil

    -- FIXME: this stinks
    for xxx,CL in ipairs(GAME.FACTORY.classes) do
      table.insert(c.pickup_set[CL][SK], { name=name, info=info, cluster=cluster })
    end
  end

  --== deathmatch_in_cell ==--

  c.pickup_set = {}
  for xxx,CL in ipairs(GAME.FACTORY.classes) do
    c.pickup_set[CL] = { easy={}, medium={}, hard={} }
  end

  c.mon_set = { easy={}, medium={}, hard={} }

  c.free_spots = find_free_spots(c)
  rand.shuffle(c.free_spots)

  if #c.free_spots == 0 then return end

  for zzz,skill in ipairs(SKILLS) do

    SK = skill

    -- health, ammo and items
    if rand.odds(HEALTH_PROBS_1[OB_CONFIG.health]) then
      local what = choose_dm_thing(GAME.FACTORY.dm.health, false)
      add_dm_pickup( what )
    end

    if rand.odds(AMMO_PROBS_1[OB_CONFIG.ammo]) then
      local what = choose_dm_thing(GAME.FACTORY.dm.ammo, false)
      add_dm_pickup( what )
    end

    if rand.odds(ITEM_PROB) then
      local what = choose_dm_thing(GAME.FACTORY.dm.items, true)
      add_dm_pickup( what )
    end

    -- secondary health and ammo
    if rand.odds(HEALTH_PROBS_2[OB_CONFIG.health]) then
      local what = choose_dm_thing(GAME.FACTORY.dm.health, false)
      add_dm_pickup( what )
    end
    if rand.odds(AMMO_PROBS_2[OB_CONFIG.ammo]) then
      local what = choose_dm_thing(GAME.FACTORY.dm.ammo, false)
      add_dm_pickup( what )
    end

    -- tertiary ammo
    if rand.odds(AMMO_PROBS_2[OB_CONFIG.ammo]) then
      local what = choose_dm_thing(GAME.FACTORY.dm.ammo, true)
      add_dm_pickup( what )
    end
  end
end


function deathmatch_through_level()

  local stats =
  {
    easy   = { health = 0, ammo = 0, monsters = 0, power = 0 },
    medium = { health = 0, ammo = 0, monsters = 0, power = 0 },
    hard   = { health = 0, ammo = 0, monsters = 0, power = 0 },
  }

  for x = 1,PLAN.w do for y = 1,PLAN.h do
    local c = PLAN.cells[x][y]
    if c then
      deathmatch_in_cell(c)
      place_battle_stuff(c, stats)
    end
  end end

  dump_battle_stats(stats)
end

