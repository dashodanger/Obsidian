------------------------------------------------------------------------
--  WAD PREFAB SYSTEM
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2013-2017 Andrew Apted
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

WADFAB_ENTITIES =
{
  -- monster spots

  [8102] = { kind="monster", r= 20 },
  [8103] = { kind="monster", r= 32 },
  [8104] = { kind="monster", r= 48 },
  [8106] = { kind="monster", r= 64 },
  [8108] = { kind="monster", r=128 },

  [8112] = { kind="flyer", r= 20 },
  [8113] = { kind="flyer", r= 32 },
  [8114] = { kind="flyer", r= 48 },
  [8116] = { kind="flyer", r= 64 },
  [8118] = { kind="flyer", r=128 },

  [8122] = { kind="cage", r= 20 },
  [8123] = { kind="cage", r= 32 },
  [8124] = { kind="cage", r= 48 },
  [8126] = { kind="cage", r= 64 },
  [8128] = { kind="cage", r=128 },

  [8132] = { kind="trap", r= 20 },
  [8133] = { kind="trap", r= 32 },
  [8134] = { kind="trap", r= 48 },
  [8136] = { kind="trap", r= 64 },
  [8138] = { kind="trap", r=128 },

  -- special spots

  [8151] = { kind="pickup",    r=16 },
  [8152] = { kind="big_item",  r=16 },
  [8160] = { kind="important", r=64 },

  -- lighting

  [8181] = { kind="light" },

  -- souuuuund

  [8185] = { kind="sound" },

  -- miscellaneous

  [8199] = { kind="secret" }
}

WADFAB_ENTITIES_HEXEN =
{
  -- monster spots

  [8105] = { kind="monster", r= 20 },
  [8106] = { kind="monster", r= 32 },
  [8107] = { kind="monster", r= 48 },
  [8108] = { kind="monster", r= 64 },
  [8109] = { kind="monster", r=128 },

  [8112] = { kind="flyer", r= 20 },
  [8113] = { kind="flyer", r= 32 },
  [8114] = { kind="flyer", r= 48 },
  [8116] = { kind="flyer", r= 64 },
  [8118] = { kind="flyer", r=128 },

  [8122] = { kind="cage", r= 20 },
  [8123] = { kind="cage", r= 32 },
  [8124] = { kind="cage", r= 48 },
  [8126] = { kind="cage", r= 64 },
  [8128] = { kind="cage", r=128 },

  [8132] = { kind="trap", r= 20 },
  [8133] = { kind="trap", r= 32 },
  [8134] = { kind="trap", r= 48 },
  [8136] = { kind="trap", r= 64 },
  [8138] = { kind="trap", r=128 },

  -- special spots

  [8151] = { kind="pickup",    r=16 },
  [8152] = { kind="big_item",  r=16 },
  [8160] = { kind="important", r=64 },

  -- lighting

  [8181] = { kind="light" },

  -- souuuuund

  [8185] = { kind="sound" },

  -- miscellaneous

  [8199] = { kind="secret" }
}

WADFAB_FX_DELTAS =
{
  [1]  =  48,  -- random off
  [2]  =  48,  -- blink fast
  [12] =  48,  -- blink fast, sync
  [3]  =  48,  -- blink slow
  [13] =  48,  -- blink slow, sync
  [17] =  48,  -- flickers
  [8]  = 128  -- oscillates
}


WADFAB_REACHABLE   = 992
WADFAB_MOVER       = 995
WADFAB_DOOR        = 996
WADFAB_DELTA_12    = 997
WADFAB_LIGHT_BRUSH = 987


function load_from_subdir(top_level, sub, extension)
  -- ignore the attic (it contains a lot of broken stuff)
  if sub == "_attic" then return end

  local dir = top_level .. "/" .. sub

  local list, err = gui.scan_directory(dir, extension)

  if list == nil then
    gui.printf("Failed to scan prefab directory '%s'\n", sub)
    return
  end

  gui.set_import_dir(dir)

  for _,filename in pairs(list) do
    gui.debugf("Loading %s/%s\n", sub, filename)

    gui.import(filename)
  end

  gui.set_import_dir("")
end


function visit_dir(top_level, extension)
  gui.printf("Loading prefabs from: '%s'\n", top_level)
  local subdirs, err = gui.scan_directory(top_level, "DIRS")

  if not subdirs then
    gui.printf("Failed to scan folder: %s\n", tostring(err))
    return
  end

  for _,sub in pairs(subdirs) do
    load_from_subdir(top_level, sub, extension)
  end

  -- give each loaded definition a 'dir_name' field.
  -- [ we assume previous defs also got it, hence this will only set
  --   the dir_name in the definitions just loaded ]

  for name,def in pairs(PREFABS) do
    if not def.dir_name then
      def.dir_name = top_level
    end
  end

  gui.printf("OK\n")
end


function Fab_load_all_definitions()

  local function kind_from_filename(filename)
    assert(filename)

    local kind = string.match(filename, "([%w_]+)/")

    if not kind then
      error("weird prefab filename: " .. tostring(filename))
    end

    return kind
  end


  local function random_factor(def)
    if not def.prob_skew then return 1 end

    local prob_skew = def.prob_skew
    local half_skew = (1.0 + prob_skew) / 2.0

    return rand.pick({ 1 / prob_skew, 1 / half_skew, 1.0, half_skew, prob_skew })
  end


  local function calc_prob(def)
    if def.skip_prob then
      if rand.odds(def.skip_prob) then return 0 end
    end

    -- check against current game, engine, theme (etc...)
    if not ob_match_game(def)     then return 0 end
    if not ob_match_port(def)   then return 0 end

    -- normal logic --

    local prob = def.prob or 0

    prob = prob * random_factor(def)

    return prob
  end


  local function process_resource_pack_fabs()
    if PARAM.obsidian_resource_pack_active then
      for _,def in pairs(PREFABS) do
        if def.replaces then
          PREFABS[def.replaces].delete = true
        end
      end

      for _,def in pairs(PREFABS) do
        if def.template and PREFABS[def.template].delete then
          def.delete = true
        end
      end
    else
      for _,def in pairs(PREFABS) do
        if def.texture_pack == "armaetus" then
          def.delete = true
        end
      end
    end

    for _,def in pairs(PREFABS) do
      if def.delete then PREFABS[def.name] = nil end
    end
  end


  local function preprocess_all()
    table.name_up(PREFABS)
    table.expand_templates(PREFABS)

    local count = 0

    process_resource_pack_fabs()

    for _,def in pairs(PREFABS) do
      if def.delete then error(table.tostr(def)) end

      if not def.kind then
        def.kind = kind_from_filename(def.file)
      end
    
      def.use_prob = calc_prob(def)

      if def.use_prob > 0 then
        count = count + 1
      end
    end

    gui.printf(count .. " prefabs loaded and usable!\n\n")
  end


  ---| Fab_load_all_definitions |---

  PREFABS = {}

  assert(GAME.game_dir)

  visit_dir("games/" .. GAME.game_dir .. "/fabs", "*.lua")
  ob_invoke_hook("addon_fabs")
  preprocess_all()
end



function Fab_update_skip_prob()
  for name,def in pairs(PREFABS) do
    if def.skip_prob then
      if rand.odds(def.skip_prob) then
        def.use_prob = 0
      else
        def.use_prob = def.prob
      end
    end

    if def.prob_skew and def.use_prob ~= 0 then

      local prob_skew = def.prob_skew
      local half_skew = (1.0 + prob_skew) / 2.0

      local final_skew = rand.pick({ 1 / prob_skew, 1 / half_skew, 1.0, half_skew, prob_skew })

      def.use_prob = def.prob * final_skew
    end
  end
end



function Fab_expansion_groups(list, axis_name, fit_size, pf_size, fabinfo)
  local extra = fit_size - pf_size

  -- nothing needed if the size is the same
  if math.abs(extra) < 1 then return nil end


  if extra < 0 then
    -- TO-DO: Fix issue with beam fit
    if fabinfo.kind == "beam" then goto continue end
    local problem_string = "\n\nPREFAB DOES NOT FIT!!!\n"
    problem_string = problem_string .. "(on " .. axis_name .. " axis)\n"
    problem_string = problem_string .. "Fab info:\n"
    problem_string = problem_string .. table.tostr(fabinfo) .. "\n"
    problem_string = problem_string .. "Required: " .. fit_size .. " Prefab has: " .. pf_size .. "\n\n"
    gui.printf(problem_string)
    ::continue::
  end

  --assert(extra > 0)

  -- check some special keywords.
  -- missing 'x_fit' field (etc) defaults to "stretch",

  if not list or list == "stretch" then
    local G =
    {
      low   = 0,
      high  = pf_size,
      low2  = 0,
      high2 = fit_size
    }

    G.size  = G.high  - G.low
    G.size2 = G.high2 - G.low2

    return { G }

  elseif list == "left" or list == "bottom" then
    list = { 0, 1 }

  elseif list == "right" or list == "top" then
    list = { pf_size - 1, pf_size }

  elseif list == "frame" then
    list = { 0, 1, pf_size - 1, pf_size }
  end


  if type(list) ~= "table" then
    error("Bad " .. axis_name .. "_fit field in prefab: " .. tostring(list))
  end


  -- validate list
  for i = 1, #list-1 do
    local A = list[i]
    local B = list[i + 1]

    if A >= B then
      error("Bad ordering in " .. axis_name .. "_fit field in prefab")
    end
  end


  -- compute total weight of expanding sections
  local total_weight = 0

  for i = 1, #list-1, 2 do
    local weight = list[i+1] - list[i]
    total_weight = total_weight + weight
  end

  assert(total_weight > 0)


  -- construct the mapping groups
  local groups = { }
  local pos = list[1]

  for i = 1,#list-1 do
    local G =
    {
      low  = list[i],
      high = list[i+1]
    }

    G.size = G.high - G.low

    G.size2 = G.size

    if (i % 2) == 1 then
      local weight = list[i+1] - list[i]
      G.size2 = G.size2 + extra * weight / total_weight
    end

    G.low2  = pos
    G.high2 = pos + G.size2

    pos = pos + G.size2,

    table.insert(groups, G)
  end

  return groups
end



function is_subst(value)
  return type(value) == "string" and string.match(value, "^[!?]")
end


function Fab_apply_substitute(value, SKIN)
  assert(is_subst(value))

  -- a simple substitution is just: "?varname",
  -- a more complex one has an operator: "?varname+3",  "?foo==1",

  local neg, var_name, op, number = string.match(value, "(.)([%w_]*)(%p*)(%-?[%d.]*)");

  if var_name == "" then var_name = nil end
  if op       == "" then op       = nil end
  if number   == "" then number   = nil end

  if not var_name or (op and not number) or (op and neg == '!') then
    error("bad substitution: " .. tostring(value));
  end

  -- first lookup variable name, abort if not present
  value = SKIN[var_name]

  if value == nil then
    return nil
  end

  -- recursive substitution is handled by caller
  if is_subst(value) then
    if op then
      error("subst op failed on recursive var: " .. var_name)
    end

    return value
  end

  -- apply the boolean negation
  if neg == '!' then
    return 1 - convert_bool(value)

  -- apply the operator
  elseif op then
    value  = 0 + value
    number = 0 + number

    if op == "+" then return value + number end
    if op == "-" then return value - number end

    if op == "==" then return sel(value == number, 1, 0) end
    if op == "!=" then return sel(value ~= number, 1, 0) end

    error("bad subst operator: " .. tostring(op))
  end

  return value
end



function Fab_determine_bbox(fab)
  local x1, y1, z1
  local x2, y2, z2

  -- Note: no need to handle slopes, they are defined to be "shrinky",
  --       (i.e. never higher that t, never lower than b).

  for _,B in pairs(fab.brushes) do
    if B[1].outlier then goto continue end
    if B[1].m == "light" then goto continue end
    if B[1].m == "rail"  then goto continue end
    if B[1].m == "spot"  then goto continue end

    for _,C in pairs(B) do

      if C.x then
        if not x1 then
          x1, y1 = C.x, C.y
          x2, y2 = C.x, C.y
        else
          x1 = math.min(x1, C.x)
          y1 = math.min(y1, C.y)
          x2 = math.max(x2, C.x)
          y2 = math.max(y2, C.y)
        end

      elseif C.b or C.t then
        local z = C.b or C.t
        if not z1 then
          z1, z2 = z, z
        else
          z1 = math.min(z1, z)
          z2 = math.max(z2, z)
        end
      end

    end -- C
    ::continue::
  end -- B

  assert(x1 and y1 and x2 and y2)

  -- Note: it is OK when z1 and z2 are not set (this happens with
  --       prefabs consisting entirely of infinitely tall solids).

  -- Note: It is possible to get dz == 0,

  local dz
  if z1 then dz = z2 - z1 end

  fab.bbox = { x1=x1, x2=x2, dx=(x2 - x1),
               y1=y1, y2=y2, dy=(y2 - y1),
               z1=z1, z2=z2, dz=dz,
             }

  gui.debugf("bbox =\n%s\n", table.tostr(fab.bbox))
end



function Fab_transform_XY(fab, T)

  local function brush_xy(brush)
    for _,C in pairs(brush) do
      if C.x then C.x, C.y = Trans.apply_xy(C.x, C.y) end

      if C.slope then C.slope = Trans.apply_slope(C.slope) end
      if C.angle then C.angle = Trans.apply_angle(C.angle) end
    end

    if sel(T.mirror_x, 1, 0) ~= sel(T.mirror_y, 1, 0) then
      brushlib.reverse(brush)
    end
  end


  local function entity_xy(E)
    if E.x then
      E.x, E.y = Trans.apply_xy(E.x, E.y)
    end

    if E.angle then
      E.angle = Trans.apply_angle(E.angle)
    end

    if E.angles then
      E.angles = Trans.apply_angles_xy(E.angles)
    end
  end


  local function model_xy(M)
    M.x1, M.y1 = Trans.apply_xy(M.x1, M.y1)
    M.x2, M.y2 = Trans.apply_xy(M.x2, M.y2)

    -- handle rotation / mirroring
    -- NOTE: we only support 0/90/180/270 rotations

    if M.x1 > M.x2 then M.x1, M.x2 = M.x2, M.x1 ; M.y_face.u1, M.y_face.u2 = M.y_face.u2, M.y_face.u1 end
    if M.y1 > M.y2 then M.y1, M.y2 = M.y2, M.y1 ; M.x_face.u1, M.x_face.u2 = M.x_face.u2, M.x_face.u1 end

    -- handle 90 and 270 degree rotations : swap X and Y faces
    local rotate = T.rotate or 0

    if math.abs(T.rotate - 90) < 15 or math.abs(T.rotate - 270) < 15 then
      M.x_face, M.y_face = M.y_face, M.x_face
    end
  end


  ---| Fab_transform_XY |---

  assert(fab.state == "skinned")

  fab.state = "transform_xy"

  Trans.set(T)

  local bbox = fab.bbox

  --- X ---

  if fab.x_fit or T.fitted_x then
    if not T.fitted_x then
      error("Fitted prefab used without fitted X transform Culprit: " .. fab.map .. " from " .. fab.name)

    elseif T.scale_x then
      error("Fitted transform used with scale_x Culprit: " .. fab.map .. " from " .. fab.name)

    elseif math.abs(bbox.x1) > 0.1 then
      error("Fitted prefab must have lowest X coord at 0. Culprit: " .. fab.map .. " from " .. fab.name)
    end

    Trans.TRANSFORM.groups_x = Fab_expansion_groups(fab.x_fit, "x", T.fitted_x, bbox.x2, fab)


  else
    -- "loose" placement
  end


  --- Y ---

  if fab.y_fit or T.fitted_y then
    if not T.fitted_y then
      error("Fitted prefab used without fitted Y transform. Culprit: " .. fab.map .. " from " .. fab.name)

    elseif T.scale_y then
      error("Fitted transform used with scale_y. Culprit: " .. fab.map .. " from " .. fab.name)

    elseif math.abs(bbox.y1) > 0.1 then
      error("Fitted prefab must have lowest Y coord at 0. Culprit: " .. fab.map .. " from " .. fab.name)
    end

    Trans.TRANSFORM.groups_y = Fab_expansion_groups(fab.y_fit, "y", T.fitted_y, bbox.y2, fab)

  else
    -- "loose" placement
  end

  -- apply the coordinate transform to all parts of the prefab

  for _,B in pairs(fab.brushes) do
    brush_xy(B)
  end

  for _,E in pairs(fab.entities) do
    entity_xy(E)
  end

  for _,M in pairs(fab.models) do
    model_xy(M)
    entity_xy(M.entity)
  end

  Trans.clear()
end



function Fab_transform_Z(fab, T)

  local function brush_z(brush)
    local b, t

    for _,C in pairs(brush) do
      if C.b then C.b = Trans.apply_z(C.b) ; b = C.b end
      if C.t then C.t = Trans.apply_z(C.t) ; t = C.t end
    end

    -- apply capping
    if Trans.z1_cap and not b and (not t or t.t > Trans.z1_cap) then
      table.insert(brush, { b = Trans.z1_cap })
    end

    if Trans.z2_cap and not t and (not b or b.b < Trans.z2_cap) then
      table.insert(brush, { t = Trans.z2_cap })
    end
  end


  local function entity_z(E)
    if E.z then
      E.z = Trans.apply_z(E.z)

      if E.delta_z then
        E.z = E.z + E.delta_z
        E.delta_z = nil
      end

      if PARAM.entity_delta_z then
        E.z = E.z + PARAM.entity_delta_z
      end

      if E.angles then
        E.angles = Trans.apply_angles_z(E.angles)
      end
    end
  end


  local function model_z(M)
    M.z1 = Trans.apply_z(M.z1)
    M.z2 = Trans.apply_z(M.z2)

    if M.delta_z then
      M.z1 = M.z1 + M.delta_z
      M.z2 = M.z2 + M.delta_z
    end

    if Trans.mirror_z then
      M.z1, M.z2 = M.z2, M.z1
    end
  end


  ---| Fab_transform_Z |---

  assert(fab.state == "transform_xy")

  fab.state = "transform_z"

  Trans.set(T)

  local bbox = fab.bbox

  --- Z ---

  if fab.z_fit or T.fitted_z then
    if not T.fitted_z then
      error("Fitted prefab used without fitted Z transform. Culprit: " .. fab.map .. " from " .. fab.name)

    elseif T.scale_z then
      error("Fitted transform used with scale_z. Culprit: " .. fab.map .. " from " .. fab.name)

    elseif not (bbox.dz and bbox.dz >= 1) then
      error("Fitted prefab has no vertical range! Culprit: " .. fab.map .. " from " .. fab.name)

    elseif math.abs(bbox.z1) > 0.1 then
      error("Fitted prefab must have lowest Z coord at 0. Culprit: " .. fab.map .. " from " .. fab.name ..
    " Bounding box z1: " .. bbox.z1)
    end

    Trans.TRANSFORM.groups_z = Fab_expansion_groups(fab.z_fit, "z", T.fitted_z, bbox.z2, fab)

  else
    -- "loose" mode
  end

  -- apply the coordinate transform to all parts of the prefab

  for _,B in pairs(fab.brushes) do
    brush_z(B)
  end

  for _,E in pairs(fab.entities) do
    entity_z(E)
  end

  for _,M in pairs(fab.models) do
    model_z(M)
  end

  Trans.clear()
end



function Fab_bound_brushes_Z(fab, z1, z2)
  if not (z1 or z2) then return end

  for _,B in pairs(fab.brushes) do
    local b = Brush_get_b(B)
    local t = Brush_get_t(B)

    if z1 and not b then table.insert(B, { b = z1 }) end
    if z2 and not t then table.insert(B, { t = z2 }) end
  end
end



function Fab_render(fab)

  assert(fab.state == "transform_z")

  fab.state = "rendered"
  local fab_map

  if fab.map then
    fab_map = fab.map
  else
    fab_map = "object"
  end

  for _,B in pairs(fab.brushes) do
    if B[1].m ~= "spot" then
      raw_add_brush(B)
    end
  end

  for _,M in pairs(fab.models) do
    raw_add_model(M)
  end

  for _,E in pairs(fab.entities) do
    if E.id then
      raw_add_entity(E)
    end
  end
end



function Fab_solid_entities(fab, room)
  -- prefab must be rendered (or ready to render)

  -- TODO : for doors and joiners, store ent in BOTH rooms

  if not room then return end

  if fab.solid_ents ~= true then return end

  for _,E in pairs(fab.entities) do
    if E.id then
      room:add_solid_ent(E.id, E.x, E.y, E.z)
    end
  end
end



function Fab_process_spots(fab, room)
  -- prefab must be rendered (or ready to render)

  local cur_cage
  local cur_trap


  local function spot_from_brush(B)
    local x1,y1, x2,y2
    local z1,z2

    if brushlib.is_quad(B) then
      x1,y1, x2,y2 = brushlib.bbox(B)

      for _,C in pairs(B) do
        if C.b then z1 = C.b end
        if C.t then z2 = C.t end
      end
    else
      -- TODO : calc middle point and largest square
      error("Unimplemented: cage spots on rotated prefabs")
    end

    if not z1 or not z2 then
      error("monster spot brush is missing t/b coord")
    end

    local SPOT =
    {
      kind  = B[1].spot_kind,
      angle = B[1].angle,
      rank  = B[1].rank,

      x1 = x1, y1 = y1, z1 = z1,
      x2 = x2, y2 = y2, z2 = z2,
    }

    return SPOT
  end


  local function OLD__distribute_spots(R, list)
    local seen = {}

    for _,spot in pairs(list) do
      seen[spot.kind] = 1
    end

    for _,spot in pairs(list) do
      if not seen["big_item"] and spot.kind == "important" then
        local new_spot = table.copy(spot)
        new_spot.kind = "big_item"
        table.insert(R.item_spots, new_spot)
      end

      if not seen["pickup"] and spot.kind == "monster" then
        local new_spot = table.copy(spot)
        new_spot.kind = "pickup"
        table.insert(R.item_spots, new_spot)
      end
    end
  end


  local function process_spot(B)
    local spot = spot_from_brush(B)

gui.debugf("  got spot kind '%s'\n", spot.kind)

    local R = assert(room)

    if spot.kind == "cage" then
      if not cur_cage then
        cur_cage = { mon_spots={} }
      end

      table.insert(cur_cage.mon_spots, spot)
      return
    end

    if spot.kind == "trap" then
      if not cur_trap then
        cur_trap = { mon_spots={} }
      end

      table.insert(cur_trap.mon_spots, spot)
      return
    end

    if spot.kind == "pickup" or spot.kind == "big_item" then
      table.insert(R.item_spots, spot)
    elseif spot.kind == "important" then
      table.insert(R.important_spots, spot)
    else
      table.insert(R.mon_spots, spot)
    end
  end


  ---| Fab_process_spots |---

gui.debugf("Fab_process_spots @ %s\n", room and room.name or "???")

  --TODO : review this
  if not room then return end

  for _,B in pairs(fab.brushes) do
    if B[1].m == "spot" then
      process_spot(B)
    end
  end

  if cur_cage then table.insert(room.cages, cur_cage) end
  if cur_trap then table.insert(room.traps, cur_trap) end
end



function Fab_size_check__OLD(skin, long, deep)
  -- the 'long' and 'deep' parameters can be nil : means anything is OK

  if long and skin.long then
    if type(skin.long) == "number" then
      if long < skin.long then return false end
    else
      if long < skin.long[1] then return false end
      if long > skin.long[2] then return false end
    end
  end

  if deep and skin.deep then
    if type(skin.deep) == "number" then
      if deep < skin.deep then return false end
    else
      if deep < skin.deep[1] then return false end
      if deep > skin.deep[2] then return false end
    end
  end

  if skin._aspect then
    -- we don't know the target size, so cannot guarantee any aspect ratio
    if not (long and deep) then return false end

    local aspect = long / deep

    if type(skin._aspect) == "number" then
      aspect = aspect / skin._aspect
      -- fair bit of lee-way here
      if aspect < 0.9 or aspect > 1.1 then return false end
    else
      if aspect < skin._aspect[1] * 0.95 then return false end
      if aspect > skin._aspect[2] * 1.05 then return false end
    end
  end

  return true  -- OK --
end


function Fab_parse_edges__OLD(skin)
  --| convert the 'north', 'east' (etc) fields of a skin into
  --| a list of portals in a 2D array.

  if skin._seed_map then return end

  -- create the seed map
  if not skin.seed_w then skin.seed_w = 1 end
  if not skin.seed_h then skin.seed_h = 1 end

  local W = skin.seed_w
  local H = skin.seed_h

  local map = table.array_2D(W, H)

  skin._seed_map = map


  -- initialize it
  for x = 1, W do
  for y = 1, H do
    map[x][y] = { edges={} }
  end
  end


  -- also determine the maximum floor_h (if absent from skin)
  local max_floor_h = 0


  local function lookup_edge(char)
    if char == '#' then return nil end

    if char == '.' then return { f_h=0 } end

    if not string.match(char, "[a-z]") then
      error("Illegal char in prefab edge string: " .. char)
    end

    local edge = skin.edges and skin.edges[char]

    if not edge then
      error("Unknown edge in prefab edge string: " .. char)
    end

    return edge
  end


  local function parse_edge(dir, str)
    -- check stuff
    if type(str) ~= "string" then
      error("bad edge string in prefab skin")
    elseif #str ~= geom.vert_sel(dir, W, H) then
      error("edge string does not match prefab size")
    end

    -- process each element of the edge string
    for n = 1, #str do
      local x, y

      if dir == 2 then x = n ; y = 1 end
      if dir == 8 then x = n ; y = H end
      if dir == 4 then x = 1 ; y = n end
      if dir == 6 then x = W ; y = n end

      local edge = lookup_edge(string.sub(str, n, n))

      map[x][y].edges[dir] = edge

      if type(edge) == "table" and edge.f_h then
        max_floor_h = math.max(max_floor_h, edge.f_h)
      end
    end
  end


  for k, edge in pairs(skin) do
    if k == "north" then parse_edge(8, edge) end
    if k == "south" then parse_edge(2, edge) end
    if k == "east"  then parse_edge(6, edge) end
    if k == "west"  then parse_edge(4, edge) end
  end

  if not skin.max_floor_h then
    skin.max_floor_h = max_floor_h
  end
end


------------------------------------------------------------------------


DOOM_TWO_SIDED_FLAG = 0x04


function Fab_load_wad(def)
  local fab


  local function convert_offset(raw_val)
    if raw_val == nil then return nil end

    assert(type(raw_val) == "number")

    if raw_val == 0 then return nil end
    if raw_val == 1 then return 0 end

    return raw_val
  end


  local function heights_are_same(sec, other_sec, pass)
    if not sec then return false end
    if not other_sec then return false end

    if pass == 1 then
      return sec.floor_h == other_sec.floor_h
    else
      return sec.ceil_h  == other_sec.ceil_h
    end
  end


  local function decode_polygon_side(sec, C, pass)
    -- pass is 1 for floor, 2 for ceiling
    -- sec will be NIL for a polygon in void space

    local C2 = { x=C.x, y=C.y }

    C2.u1_along = C.along

    local side
    local line

    if C.side then side = gui.wadfab_get_side(C.side) end
    if C.line then line = gui.wadfab_get_line(C.line) end

    -- get other sector (which the polygon side faces)
    local other_sec

    if line and side and side.sector then
      other_sec = gui.wadfab_get_sector(side.sector)
    end

    local flags = (line and line.flags) or 0

    local two_sided = (line and line.left and line.right)


    --- determine texture to use ---

    local upper_tex
    local lower_tex
    local   mid_tex

    upper_tex = side and side.upper_tex
    if upper_tex == "-" then upper_tex = nil end

    lower_tex = side and side.lower_tex
    if lower_tex == "-" then lower_tex = nil end

    mid_tex = side and side.mid_tex
    if mid_tex == "-" then mid_tex = nil end


    local tex

    -- if line is one-sided, use the middle texture
    if line and not two_sided then
      tex = mid_tex

    elseif pass == 1 then
      tex = lower_tex or upper_tex

    else
      tex = upper_tex or lower_tex
    end

    if tex then
      C2.tex = tex
    end


    -- line type --

    if line and line.special and line.special > 0 then
      C2.special = line.special
    end

    if line and line.tag and line.tag > 0 then
      C2.tag = line.tag
    end

    -- line flags --

    local MLF_UpperUnpegged = 0x0008
    local MLF_LowerUnpegged = 0x0010

    local upper_unpeg
    local lower_unpeg

    if not line then
      -- nothing

    else
      -- keep these flags: block-all, block-mon, secret, no-draw,
      --                   always-draw, block-sound, pass-thru
      flags = bit.band(flags, 0x2E3)

      if flags ~= 0 then
        C2.flags = flags

        -- this makes sure the flags get applied
        if not C2.special then C2.special = 0 end
      end

      upper_unpeg = (bit.band(flags, MLF_UpperUnpegged) ~= 0)
      lower_unpeg = (bit.band(flags, MLF_LowerUnpegged) ~= 0)
    end

    -- offsets --

    if heights_are_same(sec, other_sec, pass) then
      -- do not copy the offsets to the brush

    elseif side and line then
      C2.u1 = convert_offset(side.x_offset)
      C2.v1 = convert_offset(side.y_offset)
    end

    if not C2.u1 then
      C2.align = "world"
    else
      C2.align = "prealigned"
    end

    if side and side.sidedef_index then
      C2.sidedef_index = side.sidedef_index
    end
  
    --[[if side then
      table.alt_print_table(side)
      gui.printf("--\n")
    end
    table.alt_print_table(C2)
    gui.printf("\n")]]

    return C2
  end
  
 local function decode_polygon_side_hexen(sec, C, pass)
    -- pass is 1 for floor, 2 for ceiling
    -- sec will be NIL for a polygon in void space

    local C2 = { x=C.x, y=C.y }

    C2.u1_along = C.along

    local side
    local line

    if C.side then side = gui.wadfab_get_side(C.side) end
    if C.line then line = gui.wadfab_get_line_hexen(C.line) end

    -- get other sector (which the polygon side faces)
    local other_sec

    if line and side and side.sector then
      other_sec = gui.wadfab_get_sector(side.sector)
    end

    local flags = (line and line.flags) or 0

    local two_sided = (line and line.left and line.right)


    --- determine texture to use ---

    local upper_tex
    local lower_tex
    local   mid_tex

    upper_tex = side and side.upper_tex
    if upper_tex == "-" then upper_tex = nil end

    lower_tex = side and side.lower_tex
    if lower_tex == "-" then lower_tex = nil end

    mid_tex = side and side.mid_tex
    if mid_tex == "-" then mid_tex = nil end


    local tex

    -- if line is one-sided, use the middle texture
    if line and not two_sided then
      tex = mid_tex

    elseif pass == 1 then
      tex = lower_tex or upper_tex

    else
      tex = upper_tex or lower_tex
    end

    if tex then
      C2.tex = tex
    end


    -- line type --

    if line and line.special and line.special > 0 then
      C2.special = line.special
    end

    if line and line.arg1 and line.arg1 >= 0 then
      C2.arg1 = line.arg1
    end

    if line and line.arg2 and line.arg2 >= 0 then
      C2.arg2 = line.arg2
    end

    if line and line.arg3 and line.arg3 >= 0 then
      C2.arg3 = line.arg3
    end

    if line and line.arg4 and line.arg4 >= 0 then
      C2.arg4 = line.arg4
    end

    if line and line.arg5 and line.arg5 >= 0 then
      C2.arg5 = line.arg5
    end

    -- line flags --

    local MLF_UpperUnpegged = 0x0008
    local MLF_LowerUnpegged = 0x0010

    local upper_unpeg
    local lower_unpeg

    if not line then
      -- nothing

    else
      -- keep these flags: block-all, block-mon, secret, no-draw,
      --                   always-draw, block-sound, pass-thru
      if flags ~= 0 then
        C2.flags = flags

        -- this makes sure the flags get applied
        if not C2.special then C2.special = 0 end
      end
      
      C.act = bit.rshift(bit.band(flags, 0x1C00), 10)

      upper_unpeg = (bit.band(flags, MLF_UpperUnpegged) ~= 0)
      lower_unpeg = (bit.band(flags, MLF_LowerUnpegged) ~= 0)
    end

    -- offsets --

    if heights_are_same(sec, other_sec, pass) then
      -- do not copy the offsets to the brush

    elseif side and line then
      C2.u1 = convert_offset(side.x_offset)
      C2.v1 = convert_offset(side.y_offset)
    end

    if not C2.u1 then
      C2.align = "world"
    else
      C2.align = "prealigned"
    end

    if side and side.sidedef_index then
      C2.sidedef_index = side.sidedef_index
    end

    return C2
  end

  local function decode_3d_floor_side(exfl, C)
    local C2 = { x=C.x, y=C.y }

    C2.tex = exfl.side_tex

--??  C2.u1  = exfl.x_offset
--??  C2.v1  = exfl.y_offset

    return C2
  end


  local function create_void_brush(coords)
    local B =
    {
      { m="solid" }
    }


    for _,C in pairs(coords) do
      if GAME.sub_format == "hexen" then
        table.insert(B, decode_polygon_side_hexen(nil, C, 1))
      else
        table.insert(B, decode_polygon_side(nil, C, 1))
      end
    end

    -- add this new brush to the prefab
    table.insert(fab.brushes, B)
  end


  local function decode_lighting(S, C)

    if S.light == 0 then 
      C.shadow = 10000
    elseif S.light < 80 then
      C.shadow = 64
    elseif S.light < 144 then
      C.shadow = 144 - S.light
    elseif S.light > 240 then
      C.light_add = 96
    elseif S.light > 144 then
      C.light_add = S.light - 144
    end

    -- lighting specials need a 'fx_delta' field (for best results)
    local delta = WADFAB_FX_DELTAS[S.special or 0]

    if delta then
      C.fx_delta = delta
    end

  end

  local function create_light_brush(S, coords)
    -- clear the special (but allow light effects)
    S.special = S.tag
    S.tag = 0

    local B =
    {
      { m="light" }
    }

    decode_lighting(S, B[1])

    for _,C in pairs(coords) do
      if GAME.sub_format == "hexen" then
        table.insert(B, decode_polygon_side_hexen(S, C, 1))
      else
        table.insert(B, decode_polygon_side(S, C, 1))  
      end  
    end

    table.insert(fab.brushes, B)
  end


  local function create_brush(S, coords, pass)

    -- pass: 1 = create a floor brush (or solid wall)
    --       2 = create a ceiling brush

    if pass == 1 and S.special == WADFAB_LIGHT_BRUSH then
      create_light_brush(S, coords)
    end

    -- skip making a brush when the flat is '_NOTHING'
    if pass == 1 and S.floor_tex == "_NOTHING" then return end
    if pass == 2 and S.ceil_tex  == "_NOTHING" then return end

    local B =
    {
      { m="solid" }
    }

    local is_door = (S.floor_h >= S.ceil_h)

    if pass == 1 then
      local C = { t=S.floor_h, tex=S.floor_tex }

      --if (def.delta) then print("DELTA: " .. def.delta) end  // "Debugging"

      if S.special == WADFAB_REACHABLE then
        C.reachable = true
      elseif S.special == WADFAB_MOVER then
        B[1].mover = 1
      elseif S.special == WADFAB_DOOR then
        -- not used on the floor
      elseif S.special == WADFAB_DELTA_12 then
        if (def.delta) then
          C.delta_z = -(def.delta)
        else
          C.delta_z = -12
        end
      elseif S.special and S.special > 0 then
        C.special = S.special
      end

      if S.tag and S.tag > 0 then
        C.tag = S.tag
      end

      -- give floor brush lighting ONLY when ceiling brush is absent
      if S.ceil_tex == "_NOTHING" and S.floor_h < S.ceil_h then
        decode_lighting(S, C)
      end

      table.insert(B, C)

    else
      local C = { b=S.ceil_h, tex=S.ceil_tex }

      -- to make closed doors we need to force a gap, otherwise the CSG
      -- code will create void space.
      if is_door then
        C.b = S.floor_h + 1
        C.delta_z = -1
      end

      if S.special == WADFAB_DOOR then
        B[1].mover = 1
      end

      -- closed sectors never specify a light
      if S.floor_h < S.ceil_h then
        decode_lighting(S, C)
      end

      -- give ceiling brush the tag ONLY when floor brush is absent
      if S.floor_tex == "_NOTHING" then
        if S.tag and S.tag > 0 then
          C.tag = S.tag
        end

        if S.special > 0 and S.special < 800 then
          C.special = S.special
        end
      end

      -- automatically convert to a sky brush
      if C.tex == "_SKY" then
        B[1].m = "sky"
      end

      table.insert(B, C)
    end

    for _,C in pairs(coords) do
      if GAME.sub_format == "hexen" then
        table.insert(B, decode_polygon_side_hexen(S, C, pass))
      else
        table.insert(B, decode_polygon_side(S, C, pass))
      end  
    end

    -- add this new brush to the prefab
    table.insert(fab.brushes, B)
  end


  local function create_3d_floor(exfl, coords)
    -- TODO : support liquids

    local B =
    {
      { m="solid" }
    }

    -- top of brush
    local BOT = { b=exfl.bottom_h, tex=exfl.bottom_tex }

    table.insert(B, BOT)

    -- bottom of brush
    local TOP = { t=exfl.top_h, tex=exfl.top_tex }

    table.insert(B, TOP)

    -- sides
    for _,C in pairs(coords) do
      table.insert(B, decode_3d_floor_side(exfl, C))
    end

    table.insert(fab.brushes, B)
  end


  local function skill_to_rank(flags)
    if not flags then return 2 end

    if bit.band(flags, 2) ~= 0 then return 2 end
    if bit.band(flags, 4) ~= 0 then return 3 end

    return 1
  end


  local function angle_to_light(angle)
    if not angle then return 160 end

    if angle < 0 then angle = angle + 360 end

    angle = math.clamp(0, angle, 300)

    return 112 + math.round(angle * 16 / 45)
  end


  local function handle_entity(fab, E)
  
    local spot_info

    if GAME.sub_format == "hexen" then
      spot_info = WADFAB_ENTITIES_HEXEN[E.id]
    else
      spot_info = WADFAB_ENTITIES[E.id]
    end
    
    if not spot_info then
      table.insert(fab.entities, E)
      return
    end

    -- logic to add light entities:
    --   - angle controls level (0 = 112, 45 = 128, ..., 315 = 224)
    if spot_info.kind == "light" then
      E.id = "light"

      E.light = angle_to_light(E.angle)
      E.angle = nil

      E.factor = 1.0
      E.flags  = nil

      table.insert(fab.entities, E)
      return
    end

    -- sound control logic
    if spot_info.kind == "sound" then
      if PARAM.ambient_sounds then
        if not fab.sound then
          error(fab.name .. " has a sound thing without a sound def.\n" ..
          "Y U DO THIS?!?!?! Y HUH Y???!?!")
        end

        local picked_sound = 0

        if type(fab.sound) == "table" then
          picked_sound = rand.key_by_probs(fab.sound)
        elseif type(fab.sound) == "string" then
          picked_sound = fab.sound
        end

        E.id = AMBIENT_SOUND_DEFS[picked_sound].id

        E.flags = nil
        table.insert(fab.entities, E)
      end
      return
    end

    if spot_info.kind == "secret" then
      E.id = "oblige_secret"
      E.flags = nil

      table.insert(fab.entities, E)
      return
    end

    -- create a fake brush for the spot
    -- (this brush is never sent to the CSG code -- it is simply a
    --  handy way to get the spot translated and rotated)

    local B =
    {
      { m = "spot" }
    }

    B[1].spot_kind = spot_info.kind
    B[1].angle = E.angle
    B[1].rank  = skill_to_rank(E.flags)

    local r = spot_info.r

    local mon_height = def.mon_height or 128,

    table.insert(B, { x = E.x - r, y = E.y - r })
    table.insert(B, { x = E.x + r, y = E.y - r })
    table.insert(B, { x = E.x + r, y = E.y + r })
    table.insert(B, { x = E.x - r, y = E.y + r })

    table.insert(B, { b = E.z })
    table.insert(B, { t = E.z + mon_height })

    table.insert(fab.brushes, B)
  end


  local function handle_railing(fab, L)
    -- must be two sided
    if not (L.left and L.right) then return end

    -- calculate base Z
    local z

    do
      local side1 = gui.wadfab_get_side(L.left)
      local side2 = gui.wadfab_get_side(L.right)
      assert(side1 and side2)

      local S1 = gui.wadfab_get_sector(side1.sector)
      local S2 = gui.wadfab_get_sector(side2.sector)
      assert(S1 and S2)

      local z1 = S1.floor_h
      local z2 = S2.floor_h

      if S1.special == WADFAB_DELTA_12 then 
        z1 = z1 - (def.delta or 12)
      end
      
      if S2.special == WADFAB_DELTA_12 then 
        z2 = z2 - (def.delta or 12)
      end

      z = math.max(z1, z2)
    end

    for pass = 1, 2 do
      local side = gui.wadfab_get_side(sel(pass == 1, L.right, L.left))
      assert(side)

      -- check for a railing texture on this side
      local tex = side.mid_tex
      if tex == nil or tex == "" or tex == "-" then goto continue end

      local S = gui.wadfab_get_sector(side.sector)
      assert(S)

      local x1, y1 = L.x1, L.y1
      local x2, y2 = L.x2, L.y2
      assert(x1 and y2)

      -- swap coords for back side
      if pass == 2 then
        x1, x2 = x2, x1
        y1, y2 = y2, y1
      end

      -- create the brush

      local props = { tex = tex }

      -- add forced offsets as per def declarations
      local offsets = def.forced_offsets and def.forced_offsets[side.sidedef_index] or {}
      props.u1 = offsets.x or convert_offset(side.x_offset)
      props.v1 = offsets.y or convert_offset(side.y_offset)

      local B = brushlib.rail_brush(x1,y1, x2,y2, z, props)

      table.insert(fab.brushes, B)
      ::continue::
    end
  end


  local function create_it()
    fab = table.copy(def)

    fab.state = "raw"

    fab.brushes  = {}
    fab.models   = {}
    fab.entities = {}
  end


  local function load_it()
    create_it()

    gui.debugf("Processing " .. table.tostr(def) .. "\n")

    local filename = assert(def.dir_name) .. "/" .. def.file

    gui.debugf("Loading wad-fab %s / %s\n", def.file, def.map or "*")

    -- load the map structures into memory
    -- [ if map is not specified, use "*" to load the first one ]
    gui.wadfab_load(filename, def.map or "*")

    local E

    for thing_idx = 0,9999 do
      if GAME.sub_format == "hexen" then
        E = gui.wadfab_get_thing_hexen(thing_idx)
      else
        E = gui.wadfab_get_thing(thing_idx)
      end

      -- nil result marks the end
      if not E then break; end

      handle_entity(fab, E)
    end

    for poly_idx = 0,9999 do
      local sec_idx, coords = gui.wadfab_get_polygon(poly_idx)

      -- nil result marks the end
      if not sec_idx then break; end

      -- negative value means "void" space
      if sec_idx < 0 then
        create_void_brush(coords)
        goto continue
      end

      local S = gui.wadfab_get_sector(sec_idx)
      assert(S)

      create_brush(S, coords, 1)  -- floor
      create_brush(S, coords, 2)  -- ceil

      -- check for 3D floors
      for fl_idx = 0,9 do
        local exfl = gui.wadfab_get_3d_floor(poly_idx, fl_idx)
        if not exfl then break; end

        create_3d_floor(exfl, coords)
      end
      ::continue::
    end
    
    local L

    for line_idx = 0,9999 do
      if GAME.sub_format == "hexen" then
        L = gui.wadfab_get_line_hexen(line_idx)
      else
        L = gui.wadfab_get_line(line_idx)
      end

      -- nil result marks the end
      if not L then break; end

      handle_railing(fab, L)
    end

    gui.wadfab_free()

    Fab_determine_bbox(fab)

    return fab
  end


  ---| Fab_load_wad |---

  if not GAME.cached_wads then
    GAME.cached_wads = {}
  end

  if not GAME.cached_wads[def] then
    GAME.cached_wads[def] = load_it()
  end

  local orig = GAME.cached_wads[def]
  assert(orig)

  return table.deep_copy(orig)
end



function Fab_bound_it(fab)
  -- the definition can directly override the prefab bounding box.
  -- this can be used to supply brushes outside of the normally
  -- occupied space.

  if fab.bound_x1 then fab.bbox.x1 = fab.bound_x1 end
  if fab.bound_x2 then fab.bbox.x2 = fab.bound_x2 end

  if fab.bound_y1 then fab.bbox.y1 = fab.bound_y1 end
  if fab.bound_y2 then fab.bbox.y2 = fab.bound_y2 end

  if fab.bound_z1 then fab.bbox.z1 = fab.bound_z1 end
  if fab.bound_z2 then fab.bbox.z2 = fab.bound_z2 end


  if fab.bbox.x1 and fab.bbox.x2 then
    fab.bbox.dx = fab.bbox.x2 - fab.bbox.x1
  end

  if fab.bbox.y1 and fab.bbox.y2 then
    fab.bbox.dy = fab.bbox.y2 - fab.bbox.y1
  end

  if fab.bbox.z1 and fab.bbox.z2 then
    fab.bbox.dz = fab.bbox.z2 - fab.bbox.z1
  end
end



function Fab_merge_skins(fab, room, list)
  --
  -- merges the skin list into the global / game / theme skins,
  -- and also includes various default values.
  --

  local result = table.copy(GLOBAL_SKIN_DEFAULTS)

  if GAME.SKIN_DEFAULTS then
    table.merge(result, GAME.SKIN_DEFAULTS)
  end

  if THEME.skin_defaults then
    table.merge(result, THEME.skin_defaults)
  end

  if room and room.skin then
    table.merge(result, room.skin)
  end

  for _,skin in pairs(list) do 
    table.merge(result, skin)
    if GAME.sub_format == "hexen" then
      table.merge_missing(result, skin)
    end
  end

  return result
end



function Fab_collect_fields(fab)
  --
  -- Find all the prefab fields with special prefixes (like tex_)
  -- used for replacing textures (etc) in a prefab, and collect
  -- them into a table.
  --
  -- Also merges fields from global and game/theme specific tables.
  --

  local function match_prefix(name)
    if string.match(name, "^tex_")    then return true end
    if string.match(name, "^flat_")   then return true end
    if string.match(name, "^thing_")  then return true end

    if string.match(name, "^line_")   then return true end
    if string.match(name, "^sector_") then return true end
    if string.match(name, "^tag_")    then return true end

    if string.match(name, "^offset_") then return true end
    if string.match(name, "^delta") then return true end
    if string.match(name, "^forced_offsets") then return true end

    return false
  end


  local function matching_fields()
    local list = { }

    for k,v in pairs(fab) do
      if match_prefix(k) then
        table.insert(list, k)
      end
    end

    return list
  end


  ---| Fab_collect_fields |---

  fab.fields = {}

  for _,k in pairs(matching_fields()) do
    fab.fields[k] = fab[k] ; fab[k] = nil
  end

  if THEME.prefab_fields then
    table.merge_missing(fab.fields, THEME.prefab_fields)
  end

  if GAME.PREFAB_FIELDS then
    table.merge_missing(fab.fields, GAME.PREFAB_FIELDS)
  end

  table.merge_missing(fab.fields, GLOBAL_PREFAB_FIELDS)

end



function Fab_substitutions(fab, SKIN)
  --
  -- Handle all subs (the "?xxx" syntax) and random tables.
  --
  -- This only affects the replacement fields (tex_FOO etc).
  --

  local function random_pass(keys)
    -- most fields with a table value are considered to be random
    -- replacement, e.g. tex_FOO = { COMPSTA1=50, COMPSTA2=50 }.

    for _,name in pairs(keys) do
      local value = fab.fields[name]

      if type(value) ~= "table" or string.match(name, "^forced_offsets") then goto continue end

      if table.size(value) == 0 then
        error("Fab_substitutions: random table is empty: " .. tostring(name))
      end

      fab.fields[name] = rand.key_by_probs(value)
      ::continue::
    end
  end


  local function do_substitution(value)
    local seen = {}

    while is_subst(value) do

      -- found a cyclic reference?
      if seen[value] then
        error("cyclic substitution ref: " .. tostring(value))
      end

      seen[value] = 1

      local new_val = Fab_apply_substitute(value, SKIN)

      if new_val == nil then
        if type(value) == "string" and string.match(value, "out_tag") then
          new_value = nil
        else
          error("unknown substitution ref: " .. tostring(value))
        end
      end

      value = new_val
    end

    return value
  end


  local function subst_pass(keys)
    for _,name in pairs(keys) do
      local value = fab.fields[name]

      if is_subst(value) then
        fab.fields[name] = do_substitution(value)
      end
    end
  end


  ---| Fab_substitutions |---

  -- Note: iterate over a copy of the key names, since we cannot
  --       safely modify a table while iterating through it.
  --
  local keys = table.keys(fab.fields)

  -- this order is important : random tables must be handled after
  -- keyword substitutions.

  subst_pass(keys)

  random_pass(keys)
  
end



function Fab_replacements(LEVEL, fab)
  --
  -- Replaces textures (etc) in the brushes of the prefab with
  -- stuff from the skin.
  --
  -- This happens _after_ the substitutions.
  --

  local function sanitize_char(ch)
    if ch == " " or ch == "-" or ch == "_" then return "_" end

    if string.match(ch, "%w") then return ch end

    -- convert a weird character to a lowercase letter
    local num = string.byte(ch)
    if (num < 0) then num = -num end
    num = (num % 26) + 1

    return string.sub("abcdefghijklmnopqrstuvwxyz", num, num)
  end


  local function sanitize(name)
    name = string.upper(name)

    local s = ""

    for i = 1,#name do
      s = s .. sanitize_char(string.sub(name, i, i))
    end

    if s == "" then return "XXX" end

    return s
  end


  local function check(prefix, val)
    local k = prefix .. "_" .. val

    if fab.fields[k] then return fab.fields[k] end

    return val
  end

  local function check_tex(val, missing_mats)
    local k = "tex_" .. val

    if fab.fields[k] then
      val = fab.fields[k]
    end

    if val == "_NOTHING" then
      val = "_DEFAULT"
    end

    if THEME.prefab_remap then
      val = THEME.prefab_remap[val] or val
    end

    local mat = Mat_lookup_tex(LEVEL, val, missing_mats)

    return assert(mat.t)
  end


  local function check_flat(val, C, missing_mats)
    local k = "flat_" .. val

    if fab.fields[k] then
      val = fab.fields[k]
    end


    -- give liquid brushes lighting and/or special type
    if val == "_LIQUID" and LEVEL.liquid then
      C.special   = C.special or LEVEL.liquid.special
      C.light_add = LEVEL.liquid.light_add
    end

    if THEME.prefab_remap then
      val = THEME.prefab_remap[val] or val
    end

    local mat = Mat_lookup_flat(LEVEL, val, missing_mats)

    return assert(mat.f or mat.t)
  end


  local function check_tag(val)
    local k = "tag_" .. val

    -- if it is not already specified, allocate a new tag

    if not fab.fields[k] then
      fab.fields[k] = alloc_id(LEVEL, "tag")
    end

    return fab.fields[k]
  end
  

  local function get_entity_id(name)
    -- allow specifying a raw ID number
    if type(name) == "number" then return name end

    local info = GAME.ENTITIES[name] or
                 GAME.MONSTERS[name] or
                 GAME.WEAPONS[name]  or
                 GAME.PICKUPS[name] or
                 GAME.NICE_ITEMS[name]

    if info then
      return assert(info.id)
    end

    return nil  -- not found
  end


  local function check_thing(val)
    local k = "thing_" .. val

    if fab.fields[k] then
      local name = fab.fields[k]

      if name == "nothing" then return nil end

      val = get_entity_id(name)

      if val == nil then
        -- show a warning (but silently ignore non-standard players)
        if not string.match(name, "^player") then
          gui.printf("\nLACKING ENTITY : %s\n\n", name)
        end
      end
    end

    return THEME.entity_remap_by_id[val] or val
  end


  local function check_props(E)
    -- DISABLED : MAYBE REMOVE THIS

--[[
    local k = "props_" .. E.id

    if fab.fields[k] then
      table.merge(E, fab.fields[k])
    end
--]]
  end


  local function fixup_x_offsets(C)
    -- adjust X offset for split edges

    if C.u1 and C.u1 ~= "" and C.u1_along then
      C.u1 = C.u1 + math.round(C.u1_along)
      C.u1_along = nil
    end
  end


  local function build_entity_remap_table()
    if THEME.entity_remap_by_id then return end

    THEME.entity_remap_by_id = {}

    if not THEME.entity_remap then return end

    for name1,name2 in pairs(THEME.entity_remap) do
      local id1 = get_entity_id(name1)
      local id2 = get_entity_id(name2)

      if id1 and id2 and id1 ~= id2 then
        THEME.entity_remap_by_id[id1] = id2
      end
    end
  end

  local function forced_offset_check(C)
    if C.sidedef_index and fab.fields["forced_offsets"] then
      local offset = fab.fields["forced_offsets"][C.sidedef_index]
      if offset then
        if offset.x then C.u1 = offset.x end
        if offset.y then C.v1 = offset.y end
      end
    end
  end

  ---| Fab_replacements |---

  build_entity_remap_table()

  current_tag = 0 -- Used to help Hexen arg1 match with appropriate sector tag when needed

  local materials_table = {}

  local missing_mats = {}

  local used_texes = {}

  local used_flats = {}

  for _,B in pairs(fab.brushes) do
    for _,C in pairs(B) do
      if C.special and C.x then
        C.special = check("line", C.special)
      end
      if C.special and not C.x then C.special = check("sector", C.special) end

      -- Convulted solution for Hexen-format remote/local switch rendering - Dasho
      if GAME.sub_format == "hexen" then
        if fab.switch_action and C.special and C.special ~= 0 then
          if C.special == fab.switch_action then
            if fab.switch_arg1 then
              C.arg1 = fab.switch_arg1
            end
            if fab.switch_arg2 then
              C.arg2 = fab.switch_arg2
            end
            if fab.switch_arg3 then
              C.arg3 = fab.switch_arg3
            end
            if fab.switch_arg4 then
              C.arg4 = fab.switch_arg4
            end
            if fab.switch_arg5 then
              C.arg5 = fab.switch_arg5
            end
            if fab.switch_flags then
              C.flags = fab.switch_flags
            end
          end
          -- Switch goal tags are already properly allocated/reserved - Dasho
          goto skiptagcheck
        end
      end

      if C.tag then
        C.tag = check_tag(C.tag) 
        current_tag = C.tag
      end

      -- This should provide enough compatibility to work with the generic prefab set - Dasho
      if GAME.sub_format == "hexen" then
        if C.x and C.special then 
          if (C.special >= 10 and C.special <= 12) then 
            C.arg1 = current_tag 
          elseif C.special == 13 then
            C.arg5 = current_tag
          elseif C.special == 22 then
            C.arg1 = current_tag
          elseif C.special == 70 then
            if fab.out_tag1 then -- Handle monster depots
              local tag_table = {}
              table.insert(tag_table, fab.out_tag1)
              if fab.out_tag2 then table.insert(tag_table, fab.out_tag2) end
              if fab.out_tag3 then table.insert(tag_table, fab.out_tag3) end
              if fab.out_tag4 then table.insert(tag_table, fab.out_tag4) end
              rand_tag = rand.pick(tag_table)
              C.arg1 = rand_tag
              C.arg2 = rand_tag
            else
              C.arg1 = fab.out_tag
              C.arg2 = fab.out_tag
            end
          end
        end
      end

      ::skiptagcheck::

      if C.u1  then C.u1  = check("offset", C.u1) end
      if C.v1  then C.v1  = check("offset", C.v1) end

      -- do textures last (may add e.g. special for liquids)
      -- probably add material checking here? - Dasho
      if C.tex and C.x     then
        if PARAM.bool_print_fab_materials and PARAM.bool_print_fab_materials == 1 then
          table.add_unique(materials_table, C.tex)
        end
        C.tex  = check_tex (sanitize(C.tex), missing_mats)
        if PARAM.missing_material_behavior and PARAM.missing_material_behavior ~= "ignore" then
          if PARAM.bool_non_vanilla_as_missing and PARAM.bool_non_vanilla_as_missing == 1 then
            table.add_unique(used_texes, C.tex)
          end
        end
      end
      if C.tex and not C.x then
        if PARAM.bool_print_fab_materials and PARAM.bool_print_fab_materials == 1 then
          table.add_unique(materials_table, C.tex)
        end
        C.tex  = check_flat(sanitize(C.tex), C, missing_mats)
        if PARAM.missing_material_behavior and PARAM.missing_material_behavior ~= "ignore" then
          if PARAM.bool_non_vanilla_as_missing and PARAM.bool_non_vanilla_as_missing == 1 then
            table.add_unique(used_flats, C.tex)
          end
        end
      end

      fixup_x_offsets(C)
      forced_offset_check(C)
    end
  end

  if not table.empty(materials_table) then
    print("Materials for fab " .. fab.name .. "\nIn file " .. fab.file .. ":" .. table.tostr(materials_table) .. "\n")
  end

  if PARAM.missing_material_behavior and PARAM.missing_material_behavior ~= "ignore" then
    local error_out = false
    local bad_flats = {}
    local bad_texes = {}
    if not table.empty(missing_mats) then
      print("FAB: " .. fab.name .. "\nIN FILE: " .. fab.file .. "\nHAS THE FOLLOWING UNDEFINED MATERIALS: \n")
      for _,v in pairs(missing_mats) do
        print(v .. "\n")
      end
      error_out = true
    end
    if not table.empty(used_flats) then
      for _,v in pairs(used_flats) do
        if not table.has_elem(GAME.VANILLA_MATS, v) then
          table.add_unique(bad_flats, v)
        end
      end
      if not table.empty(bad_flats) then
        print("FAB: " .. fab.name .. "\nIN FILE: " .. fab.file .. "\nHAS THE FOLLOWING NON-VANILLA FLATS: \n")
        for _,v in pairs(bad_flats) do
          print(v .. "\n")
        end
        error_out = true
      end
    end
    if not table.empty(used_texes) then
      for _,v in pairs(used_texes) do
        if not table.has_elem(GAME.VANILLA_MATS, v) then
          table.add_unique(bad_texes, v)
        end
      end
      if not table.empty(bad_texes) then
        print("FAB: " .. fab.name .. "\nIN FILE: " .. fab.file .. "\nHAS THE FOLLOWING NON-VANILLA TEXTURES: \n")
        for _,v in pairs(bad_texes) do
          print(v .. "\n")
        end
        error_out = true
      end
    end
    if PARAM.missing_material_behavior == "abort" and error_out == true then
      error("\nFAB: " .. fab.name .. "\nIN FILE: " .. fab.file .. "\nHAS MATERIAL ERRORS! CHECK THE LOG FOR DETAILS!")
    end
  end

  for idx,E in pairs(fab.entities) do
    check_props(E)
    -- unknown entities set the 'id' to NIL
    -- (which prevents sending it to the CSG)
    E.id = check_thing(E.id)
    if GAME.sub_format == "hexen" then
      if E.tid ~= 0 then
        E.tid = check_tag(E.tid)
      end
      if E.id == 14 then -- Teleporter destination fix
        E.tid = fab.in_tag
      end
      if E.id == 7000 or E.id == 7001 then -- Place all weapon variants with appropriate per-class flags
        local wep
        for _,v in pairs(GAME.WEAPONS) do
          if E.id == v.id then
            wep = v
          end
        end
        for _,v in pairs(wep.class_weapon_ids) do
          local wep_ent = table.copy(E)
          wep_ent.id = v.id
          wep_ent.flags = bit.bor(E.flags, v.flags)
          table.add_unique(fab.entities, wep_ent)
        end
        table.remove(fab.entities, idx)
        goto entdone
      end
      if E.id == 7002 or E.id == 7003 or E.id == 7004 then -- Place all ultimate weapon pieces with appropriate per-class flags
        local piece
        for _,v in pairs(GAME.NICE_ITEMS) do
          if E.id == v.id then
            piece = v
          end
        end
        for _,v in pairs(piece.weapon_piece_ids) do
          local piece_ent = table.copy(E)
          piece_ent.id = v.id
          piece_ent.flags = bit.bor(E.flags, v.flags)
          table.add_unique(fab.entities, piece_ent)
        end
        table.remove(fab.entities, idx)
        goto entdone
      end
      ::entdone::
    end
  end
end



function Fab_render_sky(fab, room, T)
  if fab.add_sky then
    if not room then
      error("Prefab with add_sky used without any room")
    end

    if not T.bbox then
      error("Prefab with add_sky used in loose transform")
    end

    local brush = brushlib.quad(T.bbox.x1, T.bbox.y1, T.bbox.x2, T.bbox.y2, room.zone.sky_h)
    brushlib.set_mat(brush, "_SKY", "_SKY")
    Trans.brush(brush)
  end
end



function Fabricate(LEVEL, room, def, T, skins)
  -- room can be NIL

  if not def.file then
    error("Expecting prefab def table, not string!:\n"
    .. def)
  end

  gui.debugf("=========  FABRICATE %s\n", def.name)
  gui.debugf(table.tostr(T).."\n")

  local fab = Fab_load_wad(def)

  Fab_bound_it(fab)

  local SKIN = Fab_merge_skins(fab, room, skins)

  Fab_collect_fields(fab)

  Fab_substitutions(fab, SKIN)

  if GAME.sub_format == "hexen" then
    if SKIN.switch_action and type(SKIN.switch_action) == "number" then
      fab.switch_action = SKIN.switch_action
      if SKIN.switch_arg1 and type(SKIN.switch_arg1) == "number" then
        fab.switch_arg1 = SKIN.switch_arg1
      end
      if SKIN.switch_arg2 and type(SKIN.switch_arg2) == "number" then
        fab.switch_arg2 = SKIN.switch_arg2
      end
      if SKIN.switch_arg3 and type(SKIN.switch_arg3) == "number" then
        fab.switch_arg3 = SKIN.switch_arg3
      end
      if SKIN.switch_arg4 and type(SKIN.switch_arg4) == "number" then
        fab.switch_arg4 = SKIN.switch_arg4
      end
      if SKIN.switch_arg5 and type(SKIN.switch_arg5) == "number" then
        fab.switch_arg5 = SKIN.switch_arg5
      end
      if SKIN.switch_flags and type(SKIN.switch_flags) == "number" then
        fab.switch_flags = SKIN.switch_flags
      end
      if SKIN.switch_tag and type(SKIN.switch_tag) == "number" then
        fab.switch_tag = SKIN.switch_tag
      end
    end
    if SKIN.in_tag then fab.in_tag = SKIN.in_tag end
    if SKIN.out_tag then fab.out_tag = SKIN.out_tag end
    if SKIN.out_tag1 then fab.out_tag1 = SKIN.out_tag1 end
    if SKIN.out_tag2 then fab.out_tag2 = SKIN.out_tag2 end
    if SKIN.out_tag3 then fab.out_tag3 = SKIN.out_tag3 end
    if SKIN.out_tag4 then fab.out_tag4 = SKIN.out_tag4 end
  end

  Fab_replacements (LEVEL, fab)

  if PARAM.marine_gen and PARAM.level_has_marine_closets and fab.group == "marine_closet" then
    MARINE_CLOSET_TUNE.randomize_count()
    local marines = PARAM.marine_marines
    for _,E in pairs(fab.entities) do
      if E.id and E.id == 8001 then
        if marines > 0 then
          E.id = MARINE_CLOSET_TUNE.grab_type()
          marines = marines - 1
        else
          E.id = 0
       end
      end
    end
    if marines > 0 then warning("Failed to spawn marine") end
  end

  fab.state = "skinned"

  Fab_transform_XY(fab, T)
  Fab_transform_Z (fab, T)

  Fab_render(fab)
  Fab_render_sky(fab, room, T)

  Fab_solid_entities(fab, room)
  Fab_process_spots(fab, room)

end


------------------------------------------------------------------------

--[[

PREFAB SIZE MATCHING
--------------------

1. for "point" prefabs: have a "size" field for the square bbox

   and require def.size <= reqs.size

2. for "seeds" prefabs:

   (a) prefab have "seed_w" and "seed_h" fields, default to 1 if not present

   (b) prefabs can only occupy a larger space when "x_fit" / "y_fit",
       is present in the definition

3. for "edge" prefabs, only have "seed_w", and require "x_fit" to expand

4. for "diagonal" prefabs, both seed_w and seed_h must be the same
   and we NEVER expand them

--]]


function Fab_find_matches(LEVEL, reqs, match_state)

  local function match_size(def)
    -- "point" prefabs match the real size (a square)
    -- [ if size is missing, we assume it fits anywhere ]
    if def.where == "point" then
      return (def.size or 0) <= (reqs.size or 0)
    end

    -- prefab definition defaults to 1
    local sw = math.round(def.seed_w or 1)
    local sh = math.round(def.seed_h or 1)

    local req_w = math.round(reqs.seed_w or 1)
    local req_h = math.round(reqs.seed_h or 1)

    -- "diagonal" prefabs need an exact same square
    if def.where == "diagonal" then
      return sw == sh and sw == req_w and sh == req_h
    end

    -- we only allow expanding a prefab if "x_fit"/"y_fit" is specified

    if not (sw == req_w or (def.x_fit and sw < req_w)) then
      return false
    end

    -- "edge" prefabs only check width (seed_h is meaningless)
    if def.where == "edge" then return true end

    if not (sh == req_h or (def.y_fit and sh < req_h)) then
      return false
    end

    return true
  end


  local function match_height(def)
    if def.delta_h and reqs.max_delta_h and math.abs(def.delta_h) > reqs.max_delta_h then
      return false
    end

    if type(def.height) == "table" then
      local req_h = reqs.height

      if req_h == nil then return false end

      return (def.height[1] <= req_h and req_h <= def.height[2])
    end

    -- [ if height is missing, we assume it fits anywhere ]
    return (def.height or 0) <= (reqs.height or 0)
  end


  local function match_environment(req_k, def_k)
    -- for this, the prefab definition says the *required* thing
    if def_k == nil or def_k == "any" then return true end

    if req_k == nil then return false end

    if def_k == "nature" then
      if match_environment(req_k, "park") then return true end
      if match_environment(req_k, "cave") then return true end
    end

    if def_k == "outdoor" then
      if match_environment(req_k, "park")      then return true end
      if match_environment(req_k, "courtyard") then return true end
    end

    if def_k == "artificial_outdoors" then
      if match_environment(req_k, "park") then return false end
      if match_environment(req_k, "outdoor") then return true end
    end

    -- negated check?
    if string.sub(def_k, 1, 1) == '!' then
      def_k = string.sub(def_k, 2)

      return not match_environment(def_k, req_k)
    end

    return def_k == req_k
  end


  local function match_word_or_table(req_k, def_k)
    if type(req_k) == "table" and def_k then
      -- recursively check each keyword to allow table<-->table matches
      for r2,_ in pairs(req_k) do
        if match_word_or_table(r2, def_k) then return true end
      end

      return false
    end

    if type(def_k) == "table" and ref_k then
      return (def_k[req_k] or 0) > 0
    end

    return def_k == req_k
  end


  local function match_requirements(def)
    -- type check
    local kind = assert(def.kind)

    if def.jump_crouch and def.jump_crouch == true then
      if not PARAM.bool_jump_crouch then
        def.use_prob = 0 
        return 0 
      end
      if PARAM.bool_jump_crouch == 0 then
        def.use_prob = 0
        return 0
      end
    end

    if reqs.kind ~= kind then return 0 end

    -- placement check
    if not def.where then return 0 end
    if not match_word_or_table(reqs.where, def.where) then return 0 end

    -- size check
    if not match_size(def)   then return 0 end
    if not match_height(def) then return 0 end

    -- group check
    if not match_word_or_table(reqs.group, def.group) then return 0 end

    -- flavor check   MSSP: not actually used?!
    -- if not match_word_or_table(reqs.flavor, def.flavor) then return 0 end

    -- shape check
    if not match_word_or_table(reqs.shape, def.shape) then return 0 end

    -- key check
    if not match_word_or_table(reqs.key, def.key) then return 0 end

    -- check on item type
    if def.item_kind and reqs.item_kind ~= def.item_kind then return 0 end

    -- check on room type (building / outdoor / cave)
    if not match_environment(reqs.env,      def.env)      then return 0 end
    if not match_environment(reqs.neighbor, def.neighbor) then return 0 end

    if def.open_to_sky and not reqs.open_to_sky then return 0 end

    -- hallway stuff
    if reqs.door   ~= def.door   then return 0 end
    if reqs.secret ~= def.secret then return 0 end

    -- door check [WTF?]
    if def.no_door and reqs.has_door then return 0 end

    -- liquid check
    if def.liquid then
      if not LEVEL.liquid then
        def.use_prob = 0 
        return 0 
      end
      if def.liquid == "harmless" and     LEVEL.liquid.damage then return 0 end
      if def.liquid == "harmful"  and not LEVEL.liquid.damage then return 0 end
    end

    -- on liquids check
    if def.on_liquids == "never" and reqs.on_liquids == "liquid" then return 0 end
    if def.on_liquids == "only" and reqs.on_liquids ~= "liquid" then return 0 end

    -- sink check
    if reqs.is_sink and def.sink_mode == "never" then return 0 end
    if reqs.is_sink == "liquid" and def.sink_mode == "never_liquids" then return 0 end
    if reqs.is_sink == "sky" and def.sink_mode == "never_sky" then return 0 end

    -- darkness check
    if def.dark_map and not LEVEL.is_dark then
      def.use_prob = 0 
      return 0 
    end

    -- for fabs to spawn on roads (and not sidewalks)
    if reqs.is_road and not def.can_be_on_roads then return 0 end

    -- disable outdoor wall fab from appearing in scenic rooms
    if reqs.scenic and def.scenic_mode == "never" then return 0 end
    if not reqs.scenic and def.scenic_mode == "only" then return 0 end

    -- stair check
    if reqs.on_stairs and def.on_stairs == "never" then return 0 end

    if def.has_teleporter and PARAM.teleporters == "none" then return 0 end

    -- park mode check
    if reqs.group and reqs.group == "natural_park" and def.park_mode == "no_nature" then return 0 end

    -- wall fabs that need to be flat, to prevent high-depth walls from intersecting
    if reqs.deep and def.deep then
      if def.deep > reqs.deep then return 0 end
    end

    -- for fabs that need the illusion of depth
    if def.need_solid_depth and not reqs.solid_depth then return 0 end
    if reqs.solid_depth and def.need_solid_depth then
      if def.need_solid_depth > reqs.solid_depth then return 0 end 
    end

    -- REMOVE-ME - temporary fix for the issue of non-natural walls looking
    -- when placed in parks
    if reqs.no_top_fit and def.z_fit == "top" then return 0 end

    -- fabs that require a plain ceiling are disqualified if
    -- the ceiling has already content in it
    if reqs.filled_ceiling and def.plain_ceiling then return 0 end

    if reqs.porch and def.in_porches == "never" then return 0 end

    -- light color check
    if reqs.light_color and def.light_color ~= reqs.light_color then return 0 end

    -- special code for checking on climate-theme fabs based on the Epic
    -- Textures module Environment Themes -MSSP
    if not reqs.outdoor_theme then
      if def.outdoor_theme then
        if def.outdoor_theme ~= "temperate" then
          return 0
        end
      end
    elseif reqs.outdoor_theme then
      if reqs.outdoor_theme == "temperate" then
        if def.outdoor_theme then
          if def.outdoor_theme ~= "temperate" then
            return 0
          end
        end
      elseif reqs.outdoor_theme == "snow" then
        if def.outdoor_theme then
          if def.outdoor_theme ~= "snow" then
            return 0
          end
        end
      elseif reqs.outdoor_theme == "desert" then
        if def.outdoor_theme then
          if def.outdoor_theme ~= "desert" then
            return 0
          end
        end
      end
  end

    return 1
  end


  local function style_factor(def)
    if not def.style then return 1 end

    local style_tab = def.style

    if type(style_tab) ~= "table" then
      style_tab = { def.style }
      def.style = style_tab
    end

    local factor = 1.0

    for _,name in pairs(style_tab) do
      if STYLE[name] == nil then
        error("Unknown style name in prefab def: " .. tostring(name))
      end

      factor = factor * style_sel(name, 0, 0.28, 1.0, 3.5)
    end

    return factor
  end


  local function prob_for_match(def, match_state, theme_override)
    local prob = assert(def.use_prob)

    if prob <= 0 then return 0 end

    local factor = style_factor(def)

    if not ob_match_level_theme(LEVEL, def, theme_override) then return 0 end
    if not ob_match_feature(def) then return 0 end
    if factor <= 0 then
      def.use_prob = 0
      return 0
    end

    if (def.rank or 0) < match_state.rank then return 0 end

    prob = prob * match_requirements(def)
    prob = prob * factor

    return prob
  end


  ---| Fab_find_matches |---

  assert(reqs.kind)

  local tab = {}

  for name,def in pairs(LEVEL.PREFABS) do
    local prob = prob_for_match(def, match_state, reqs.theme_override)

    if prob > 0 then
      -- Ok, add it
      -- a higher rank overrides anything lower

      if (def.rank or 0) > match_state.rank then
        match_state.rank = def.rank
        tab = {}
      end

      tab[name] = prob
    end
  end

  return tab
end



function Fab_pick(LEVEL, reqs, allow_none)
  local tab = {}

  local match_state = { rank=0 }

  local cur_req = reqs

  cur_req.game = OB_CONFIG.game

  while cur_req do
      -- keep the earliest matches (they override later matches)
    table.merge_missing(tab, Fab_find_matches(LEVEL, cur_req, match_state))
   
    cur_req = cur_req.alt_req
  end

  if DEBUG_FAB_PICK then
     gui.printf("\n\nFAB_PICK = \n%s\n\n", table.tostr(tab))
  end

  if table.empty(tab) then
    if allow_none then return nil end

    gui.printf("Fab_pick:\n")
    gui.printf("reqs  = \n%s\n", table.tostr(reqs))

    error("No matching prefabs for: " .. reqs.kind)
  end

  if reqs.NONE_prob then
    tab["NONE"] = reqs.NONE_prob
  end

  local name

  -- see if a desired prefab *can* be used -- if so, use it
  if reqs.want_fab and (tab[reqs.want_fab] or 0) > 0 then
    name = reqs.want_fab
  else
    name = rand.key_by_probs(tab)
  end

  if DEBUG_FAB_PICK then
    gui.debugf("Fab_pick : chose %s\n", tostring(name))
  end

  if name == "NONE" then return nil end

  return assert(PREFABS[name])
end
