------------------------------------------------------------------------
--  SHAPE GROWING SYSTEM
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2015-2017 Andrew Apted
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

GROWER_DEBUG_INFO = {} -- MSSP: table for containing details about growth statistics

function Grower_preprocess_grammar(test_grammar)

  local def
  local diag_list


  local function name_to_pass(name)
    if string.match(name, "ROOT_")      then return "root" end
    if string.match(name, "EXIT_")      then return "exit" end
    if string.match(name, "GROW_")      then return "grow" end
    if string.match(name, "SPROUT_")    then return "sprout" end
    if string.match(name, "DECORATE_")  then return "decorate" end

    error("Unknown pass for grammar " .. tostring(name))
  end


  local function parse_element(ch, what)
    if ch == '.' then return { kind="free" } end
    if ch == '!' then return { kind="free", utterly=1 } end

    if ch == '~' then return { kind="liquid" } end
    if ch == '#' then return { kind="disable" } end
    if ch == '=' then return { kind="bridge", dir=6 } end

    if ch == '1' then return { kind="area", area=1 } end
    if ch == '2' then return { kind="area", area=2 } end
    if ch == '3' then return { kind="area", area=3 } end

    -- straight stairs
    if ch == '<' then return { kind="stair", dir=4 } end
    if ch == '>' then return { kind="stair", dir=6 } end
    if ch == '^' then return { kind="stair", dir=8 } end
    if ch == 'v' then return { kind="stair", dir=2 } end

    -- generic stairs (need an info table to set shape, dirs)
    if ch == 'S' then return { kind="stair"  } end

    -- match-only elements
    if ch == 'x' then return { kind="magic", what="all"  } end
    if ch == 'r' then return { kind="magic", what="room" } end
    if ch == 'f' then return { kind="magic", what="floor" } end
    if ch == 'o' then return { kind="magic", what="open" } end
    if ch == 'c' then return { kind="magic", what="closed" } end

    -- other stuff
    if ch == 'A' then return { kind="new_area" } end
    if ch == 'R' then return { kind="new_room" } end

    if ch == 'C' then return { kind="cage"   } end
    if ch == 'J' then return { kind="joiner" } end
    if ch == 'T' then return { kind="closet" } end

    -- hallway stuff
    if ch == '@' then return { kind="link"  } end
    if ch == 'a' then return { kind="link2" } end
    if ch == 'H' then return { kind="hallway" } end
    if ch == 'I' then return { kind="hall2"   } end
    if ch == 'K' then return { kind="hall3"   } end

    error("Grower_parse_char: unknown symbol: " .. tostring(ch))
  end


  local function parse_char(ch, what)
    -- handle diagonal seeds
    if ch == '/' or ch == '%' then
      if not diag_list then
        error("Grower_parse_char: missing diagonals in: " .. def.name)
      end

      local D = table.remove(diag_list, 1)
      if not D then
        error("Grower_parse_char: not enough diagonals in: " .. def.name)
      end

      local L = parse_element(string.sub(D, 1, 1), what)
      local R = parse_element(string.sub(D, 2, 2), what)

      local diagonal = sel(ch == '/', 3, 1)

      if ch == '%' then
        L, R = R, L
      end

      return { kind="diagonal", diagonal=diagonal, bottom=R, top=L }
    end

    return parse_element(ch, what)
  end


  local function convert_element(what, grid, x, y)
    local line

    if what == "input" then
      line = def.structure[y*2 - 1]
    else
      line = def.structure[y*2]
    end

    if #line ~= grid.w then
      error("Malformed structure in grammar: " .. def.name)
    end

    local ch = string.sub(line, x, x)

    local elem = parse_char(ch, diag_list, def)

    -- textural representation must be inverted
    local gy = grid.h + 1 - y

    grid[x][gy] = elem
  end


  local function split_element(E, new_diagonal)
    assert(not E.diagonal)

    local top = table.copy(E)

    return { kind="diagonal", diagonal=new_diagonal, bottom=E, top=top }
  end


  local function check_compatible_elements(E1, E2)
    if E1.kind == "new_area" or E1.kind == "new_room" or E1.kind == "hallway" then
      error("bad element in " .. def.name .. ": cannot use A/R/H' in match")
    end

    -- changing an area is OK
    if E1.kind == "area" and E2.kind == "area" then
      if E1.area ~= E2.area then
        E2.assignment = true

        def.area_growths[E2.area] = (def.area_growths[E2.area] or 0) + 1
        return
      end
    end

    -- FIXME : check for links ('@')

    -- same kind of thing is always acceptable
    if E1.kind == E2.kind then
      return
    end

    if E2.kind == "disable" then
      if E1.kind ~= "free" then
        error("bad element in " .. def.name .. ": '#' element cannot remove stuff")
      end
    end

    -- from here on, output element is an ASSIGNMENT
    -- i.e. setting something new or different into the seed(s)

    E2.assignment = true

    -- compute the growth of areas (how many seeds they add)
    if E2.kind == "area" then
      def.area_growths[E2.area] = (def.area_growths[E2.area] or 0) + 1
    end

    if E1.kind == "stair" or E1.kind == "joiner" or E1.kind == "closet" or
       E1.kind == "disable" or E1.kind == "magic"
    then
      error("bad element in " .. def.name .. ": cannot overwrite a " .. E1.kind)
    end

    if E2.kind == "magic" then
      error("bad element in " .. def.name .. ": cannot assign to a " .. E2.kind)
    end

    -- we cannot assign into a '.' (which means "not part of current room")
    if E1.kind == "free" and E2.kind ~= "disable" then
      E1.utterly = 1
    end
  end


  local function add_style(name)
    table.add_unique(def.styles, name)
  end


  local function check_added_stuff(E)
    if E.kind == "new_room" and not def.new_room then
      def.new_room = {}
    end

    if (E.kind == "new_area" or E.kind == "XXX_room") and not def.new_area then
      def.new_area = {}
    end

    if E.kind == "stair" then
      def.has_stair = true
    end

    if E.kind == "cage"    then add_style("cages")    end
    if E.kind == "liquid"  then add_style("liquids")  end
    if E.kind == "hallway" then add_style("hallways") end
    if E.kind == "stair"   then add_style("steepness") end
  end


  local function finalize_element(x, y)
    local E1 = def.input [x][y]
    local E2 = def.output[x][y]

    if E1.diagonal and E2.diagonal and E1.diagonal ~= E2.diagonal then
      error("mismatched diagonals in " .. def.name)
    end

    -- if only one side is diagonal, split the other side
    if not E1.diagonal and E2.diagonal then
      def.input [x][y] = split_element(E1, E2.diagonal)
    elseif not E2.diagonal and E1.diagonal then
      def.output[x][y] = split_element(E2, E1.diagonal)
    end

    E1 = def.input [x][y]
    E2 = def.output[x][y]

    -- check assignment
    if E1.diagonal then
      check_compatible_elements(E1.top,    E2.top)
      check_compatible_elements(E1.bottom, E2.bottom)
    else
      check_compatible_elements(E1, E2)
    end

    -- check added stuff
    if E2.diagonal then
      check_added_stuff(E2.top)
      check_added_stuff(E2.bottom)
    else
      check_added_stuff(E2)
    end
  end


  local function convert_structure()
    local W = #def.structure[1]
    local H = #def.structure

    if (H % 2) ~= 0 then
      error("Malformed structure in grammar: " .. def.name)
    end

    H = H / 2

    diag_list = nil

    if def.diagonals then
      diag_list = table.copy(def.diagonals)
    end

    def.input  = table.array_2D(W, H)
    def.output = table.array_2D(W, H)

    -- must iterate line by line, then across each line
    for y = 1, H do
    for x = 1, W do
      convert_element("input",  def.input,  x, y)
      convert_element("output", def.output, x, y)
    end
    end
  end


  local function finalize_structure()
    def.area_growths = {}

    for x = 1, def.input.w do
    for y = 1, def.input.h do
      finalize_element(x, y)
    end
    end
  end


  local function test_mirror_elem(E1, E2, dir_map)
    -- check stair directions
    if dir_map and E1.dir and E2.dir then
      if E1.dir ~= dir_map[E2.dir] then return false end
    end

    return E1.kind == E2.kind and E1.area == E2.area
  end


  local function test_horiz_symmetry(grid, x, y)
    local x2 = grid.w - x + 1

    local E = grid[x ][y]
    local N = grid[x2][y]

    -- special check for seeds sitting on the axis
    if x == x2 then
      if E.kind == "stair" then return E.dir and geom.is_vert(E.dir) end

      if E.kind == "diagonal" then return false end

      return true
    end

    -- if one seed is a diagonal, the other must be too
    if not (E.diagonal and N.diagonal) then
      return test_mirror_elem(E, N, geom.MIRROR_X)
    end

    if N.diagonal == E.diagonal then
      return false
    end

    -- the nice thing about X mirroring of diagonals is that the
    -- bottom and top do not change places.

    return test_mirror_elem(E.bottom, N.bottom) and
           test_mirror_elem(E.top,    N.top)
  end


  local function is_horiz_symmetrical(grid)
    for x = 1, grid.w do
    for y = 1, grid.h do
      if not test_horiz_symmetry(grid, x, y) then
        return false
      end
    end
    end

    return true
  end


  local function test_vert_symmetry(grid, x, y)
    local y2 = grid.h - y + 1

    local E = grid[x][y]
    local N = grid[x][y2]

    -- special check for seeds sitting on the axis
    if y == y2 then
      if E.kind == "stair" then return E.dir and geom.is_horiz(E.dir) end

      if E.kind == "diagonal" then return false end

      return true
    end

    -- if one seed is a diagonal, the other must be too
    if not (E.diagonal and N.diagonal) then
      return test_mirror_elem(E, N, geom.MIRROR_Y)
    end

    if N.diagonal == E.diagonal then
      return false
    end

    -- Y mirroring will swap the bottom and top

    return test_mirror_elem(E.bottom, N.top) and
           test_mirror_elem(E.top,    N.bottom)
  end


  local function is_vert_symmetrical(grid)
    for x = 1, grid.w do
    for y = 1, grid.h do
      if not test_vert_symmetry(grid, x, y) then
        return false
      end
    end
    end

    return true
  end


  local function test_transpose_symmetry(grid, x, y)
    local E = grid[x][y]
    local N = grid[y][x]

    -- special check for seeds sitting on the axis
    if x == y then
      if E.kind == "stair" then return false end

      if E.kind ~= "diagonal" then return true end

      if E.diagonal == 1 then return true end

      return test_mirror_elem(E.bottom, E.top)
    end

    -- if one seed is a diagonal, the other must be too
    if not (E.diagonal and N.diagonal) then
      return test_mirror_elem(E, N, geom.TRANSPOSE)
    end

    if N.diagonal ~= E.diagonal then
      return false
    end

    -- a diagonal at right angles to the axis of mirroring?
    if E.diagonal == 1 then
      return test_mirror_elem(E.bottom, N.bottom) and
             test_mirror_elem(E.top,    N.top)
    end

    -- a diagonal in same direction as axis of mirroring: the sides
    -- will be swapped when mirrored.

    return test_mirror_elem(E.bottom, N.top) and
           test_mirror_elem(E.top,    N.bottom)
  end


  local function is_transpose_symmetrical(grid)
    if grid.w ~= grid.h then
      return false
    end

    for x = 1, grid.w do
    for y = 1, grid.h do
      if not test_transpose_symmetry(grid, x, y) then
        return false
      end
    end
    end

    return true
  end


  local function check_symmetries()
    if is_horiz_symmetrical(def.input) and
       is_horiz_symmetrical(def.output)
    then
      def.x_symmetry = true
    end

    if is_vert_symmetrical(def.input) and
       is_vert_symmetrical(def.output)
    then
      def.y_symmetry = true
    end

    if is_transpose_symmetrical(def.input) and
       is_transpose_symmetrical(def.output)
    then
      def.t_symmetry = true
    end
  end


  local function find_focal_points()
    def.focal_points = {}

    if def.pass == "root" or def.pass == "exit" then
      return
    end

    for x = 1, def.input.w do
    for y = 1, def.input.h do
      local E1 = def.input[x][y]

      local f_name

      if E1.kind == "area" then
        f_name = E1.area
      elseif E1.kind == "link" then
        f_name = "link"
      end

      if not f_name then goto continue end

      -- already have one?
      if def.focal_points[f_name] then goto continue end

      -- add it
      def.focal_points[f_name] =
      {
        gx = x,
        gy = y
      }
      ::continue::
    end -- x, y
    end

    if table.empty(def.focal_points) then
      error("No focal points in rule: " .. def.name)
    end
  end


  local function find_connections()
    -- TODO
  end


  -- NOTE: this code not used at the moment
  local function visit_contiguous_elem(x, y, kind, locs, seen)
    table.insert(locs, { x=x, y=y })

    seen[def.input[x][y]] = true

    for dir = 2,8,2 do
      local nx, ny = geom.nudge(x, y, dir)

      if nx < 1 or nx > def.input.w then goto continue end
      if ny < 1 or ny > def.input.h then goto continue end

      local E = def.output[nx][ny]

      if seen[E] then goto continue end

      -- TODO support diagonals here
      if E.kind == "diagonal" then
        if E.top.kind == kind or E.bottom.kind == kind then
          error("diagonal not supported for element: " .. tostring(kind))
        end
      end

      if E.kind == kind then
        visit_contiguous_elem(nx, ny, kind, locs, seen)
      end
      ::continue::
    end
  end


  local function is_contig_part(kind, x, y, seen)
    local E2 = def.output[x][y]

    if E2.kind ~= kind then return false end

    if not E2.assignment then return false end

    return not seen[E2]
  end


  local function is_valid(x, y)
    if x < 1 or x > def.input.w then return false end
    if y < 1 or y > def.input.h then return false end

    return true
  end


  local function try_neighbor_part(kind, x, y, seen)
    if not is_valid(x, y) then return false end

    return is_contig_part(kind, x, y, seen)
  end


  local function mark_part_as_seen(kind, x, y, w, h, seen)
    for ex = x, x+w-1 do
    for ey = y, y+h-1 do
      if not is_contig_part(kind, ex, ey, seen) then
        error("bad structure: " .. kind .. " is not a pure rectangle")
      end

      local E2 = def.output[ex][ey]
      seen[E2] = true
    end
    end
  end


  local function determine_from_area(kind, x, y, dir)
    local E

    repeat
      x, y = geom.nudge(x, y, dir)
      if not is_valid(x, y) then return nil end

      E = def.output[x][y]
    until E.kind ~= kind

    -- FIXME : handle "diagonal",

    if E.kind ~= "area" then return nil end

    return E.area
  end


  local function find_info_for_part(kind, lx, ly)
    -- lx, ly is the lowest left corner of the part
    -- look for coordinate specific entry, e.g. "stair3_2",
    -- if that fails, look for generic entry e.g. "stair",

    local full_name = kind .. lx .. "_" .. ly

    return def[full_name] or def[kind]
  end


  local function get_contiguous_part(kind, x, y, seen)
    local w = 1
    local h = 1

    while try_neighbor_part(kind, x+w, y, seen) do w = w + 1 end
    while try_neighbor_part(kind, x, y+h, seen) do h = h + 1 end

    -- this also verifies the rectangle is all the same
    mark_part_as_seen(kind, x, y, w, h, seen)

    local r = { kind=kind, x1=x, y1=y, x2=x+w-1, y2=y+h-1 }

    if kind == "hall2" or kind == "hall3" then
      r.kind = "hallway"
    elseif kind == "link2" then
      r.kind = "link"
    end

    local E = def.output[x][y]

    -- grab "dir" from corresponding table, if present
    local info = find_info_for_part(r.kind, x, y)
    if info then
      table.merge_missing(r, info)
    end

    if E.dir then
      -- directional stair
      r.from_dir = 10 - E.dir

    elseif kind == "link" then
      r.dest_dir = r.dest_dir or 8

    elseif r.kind == "hallway" then
      r.from_dir = r.from_dir or 2

    else
      if not info then
        error("Missing " .. kind .. " info in grammar rule: " .. tostring(def.name))
      end

      assert(r.from_dir)
    end

    if r.kind == "hallway" or kind == "link" then
      -- nothing needed ??

    else
      r.from_area = determine_from_area(kind, x, y, r.from_dir)

      if not r.shape then
        if kind == "closet" then
          r.shape = "U"
        else
          r.shape = "I"
        end
      end
    end

    if kind == "joiner" then
      if not r.dest_dir then
        r.dest_dir = 10 - r.from_dir
      end
    end

    if r.kind == "stair" then
      r.occupy = "floor"
    else
      r.occupy = "whole"
    end

    if not def.rects then def.rects = {} end

    table.insert(def.rects, r)
  end


  local function locate_all_contiguous_parts(kind)
    local seen = {}

    for x = 1, def.output.w do
    for y = 1, def.output.h do
      if is_contig_part(kind, x, y, seen) then
        get_contiguous_part(kind, x, y, seen)
      end
    end
    end
  end


  ---| Grower_preprocess_grammar |---

  local gramgram = test_grammar

  local function process_some_cool_grammars(grammar)

      gui.printf("Preprocess shape grammars...\n")

      PARAM.shape_rule_count = 0

      table.name_up(grammar)

      table.expand_templates(grammar)

      for name,cur_def in pairs(grammar) do

        if type(cur_def) ~= "table" then goto continue end

        if cur_def.is_processed then goto continue end
        cur_def.is_processed = true

        PARAM.shape_rule_count = PARAM.shape_rule_count + 1 -- debug counter for amount of shape rules read

        -- instantiate debug stats for growth
        GROWER_DEBUG_INFO[cur_def.name] =
        {
          name = cur_def.name,
          applied = 0,
          trials = 0,
        }

        gui.debugf("processing: %s\n", name)

        def = cur_def

        if cur_def.pass == nil then
           cur_def.pass = name_to_pass(name)
        end

        if not def.styles then def.styles = {} end

        convert_structure()
        finalize_structure()
        check_symmetries()

        find_focal_points()
        find_connections()

        locate_all_contiguous_parts("stair")
        locate_all_contiguous_parts("joiner")
        locate_all_contiguous_parts("closet")

        locate_all_contiguous_parts("hallway")
        locate_all_contiguous_parts("hall2")
        locate_all_contiguous_parts("hall3")

        locate_all_contiguous_parts("link")
        locate_all_contiguous_parts("link2")

        if cur_def.teleporter then add_style("teleporters") end

        if string.match(name, "^HALL_") then cur_def.env = "hallway" end
        if string.match(name, "^CAVE_") then cur_def.env = "cave" end
        if string.match(name, "^PARK_") then cur_def.env = "park" end
        ::continue::
      end

      gui.printf(PARAM.shape_rule_count .. " rules loaded!\n")

  end

  process_some_cool_grammars(gramgram)

end



function Grower_calc_rule_probs(LEVEL)
  --
  -- Modify the probability of all rules, based on current game and
  -- theme, the chosen styles for the level, and a random factor.
  -- This gives each level a distinctive feel.
  --

  local function style_factor(rule)
    if not rule.styles then return 1 end

    local factor = 1.0

    for _,name in pairs(rule.styles) do
      if STYLE[name] == nil then
        error("Unknown style in grammar rule: " .. tostring(name))
      end

      factor = factor * style_sel(name, 0, 0.28, 1.0, 3.5)
    end

    return factor
  end


  local function random_factor(rule)
    if not rule.prob_skew then return 1 end

    local prob_skew = rule.prob_skew
    local half_skew = (1.0 + prob_skew) / 2.0

    return rand.pick({ 1 / prob_skew, 1 / half_skew, 1.0, half_skew, prob_skew })
  end


  local function calc_prob(rule, LEVEL)
    if rule.skip_prob then
      if rand.odds(rule.skip_prob) then return 0 end
    end

    -- check against current game, engine, theme (etc).
    -- [ I doubt these are useful, but do it for completeness ]
    if not ob_match_game(rule)     then return 0 end
    if not ob_match_port(rule)   then return 0 end

    -- liquid check
    if not LEVEL.liquid and rule.styles and
      table.has_elem(rule.styles, "liquids")
    then
      return 0
    end

    -- check hallway types
    if rule.new_room and rule.new_room.hall_type == "narrow" and
      table.empty(THEME.narrow_halls or {})
    then
      return 0
    end

    if rule.new_room and rule.new_room.hall_type == "wide" and
      table.empty(THEME.wide_halls or {})
    then
      return 0
    end

    -- normal logic --

    local prob = rule.prob or 0

    prob = prob *  style_factor(rule)
    prob = prob * random_factor(rule)

    return prob
  end


  ---| Grower_calc_rule_probs |---

  PARAM.skipped_rules = 0

  for _,rule in pairs(SHAPE_GRAMMAR) do
    if type(rule) == "table" then
      local new_prob = calc_prob(rule, LEVEL)
      rule.use_prob = new_prob
      if new_prob == 0 then
        PARAM.skipped_rules = PARAM.skipped_rules + 1
      end

      -- attempt to ignore hallway sprouts
      if LEVEL.is_nature then
        if rule.new_room 
        and rule.new_room.env
        and rule.new_room.env == "hallway" then
          rule.use_prob = 0
          PARAM.skipped_rules = PARAM.skipped_rules + 1
        end
      end
    end
  end

  -- outdoor openness pass
  if LEVEL.outdoor_openness then
    for _,rule in pairs(SHAPE_GRAMMAR) do
      if type(rule) == "table" then
        if string.match(rule.name, "COLONNADE") or
        string.match(rule.name, "PILLAR") then
          rule.env = "building"
          rule.outdoor_openness = "low"
        end
      end
    end
  end

  gui.printf("Shape rules skipped for this level: " .. PARAM.skipped_rules ..
  " / " .. PARAM.shape_rule_count .. "\n")
  gui.printf("Rules can be disabled via skip probability or level styles.\n")

  -- Shape grouping system
  PARAM.cur_shape_group = ""
  PARAM.cur_shape_group_apply_count = 0

  -- Layout Absurdifier (AKA Layout Consistency)

  if OB_CONFIG.float_layout_absurdity then
    gui.printf("\n--== Layout Consistency Module ==--\n\n")
  end

  if not LEVEL.is_procedural_gotcha and not LEVEL.is_nature and not LEVEL.has_streets then
    if PARAM.float_layout_absurdity then
      if rand.odds(PARAM.float_layout_absurdity) then
        LEVEL.is_absurd = true
      end
    end
  end

  if LEVEL.is_absurd then
    gui.printf("This level is absurd!\n\n")
  end

  LEVEL.absurd_grammar_rules = {}
  LEVEL.base_set_rules = {}
  local shape_order = {}

  local function Grower_absurdify()
    
    local function Grower_reset_absurdities()
      for _,rule in pairs(SHAPE_GRAMMAR) do

        rule.is_absurd = nil

        --[[if rule.prob then
          rule.use_prob = rule.prob
        end]]

        if not rule.initial_env then goto continue end

        if rule.initial_env == "none" then rule.env = nil
        else rule.env = rule.initial_env end

        ::continue::
      end
    end

    local function Grower_absurdify_rule(rule, qty)

      local new_factor
  
      if string.match(rule.name,"ROOT") then return end
      if string.match(rule.name,"CAVE") then return end
      if rule.pass and rule.pass ~= "grow" then return end
      if table.has_elem(rule.styles, "liquids") 
        and not LEVEL.liquid then return end
      if table.has_elem(rule.styles, "cages") 
        and not rand.odds(style_sel("cages", 0, 40, 70, 90)) then return end

      --if rand.odds(75) then
      new_factor = rand.range( 100,1000000 ) * rand.range( 0.75,1.25 )
      rule.use_prob = math.round(rule.prob * new_factor)
      if rule.new_area then
        LEVEL.has_absurd_new_area_rules = true
      end
      --[[else
        new_factor = low_ab_factor * rand.range( 0.75,1.25 )
        rule.use_prob = rule.prob * new_factor
        rule.negative_absurdity = true
      end]]

      -- diversify environments
      local new_env
      if rand.odds(50) and qty > 1 and not rule.outdoor_openness == "low" then
        if rand.odds(style_sel("outdoors", 0, 30, 60, 100)) then
          new_env = "outdoor"
        else
          new_env = "building"
        end
      end

      rule.initial_env = rule.env or "none"
      rule.env = new_env
      rule.is_absurd = true

      gui.printf(rule.name .. ": " .. rule.prob 
        .. "->" .. math.round(rule.use_prob) .. " \n")
      gui.debugf("Factor: x" .. math.round(new_factor) .. "\n")

      local info =
      {
        name = rule.name,
        prob = rule.use_prob,
        env = rule.env,
        order = (#LEVEL.absurd_grammar_rules or 0) + 1
      }
      table.insert(LEVEL.absurd_grammar_rules, info)

      if new_env then gui.debugf("New env: " .. new_env .. "\n") end
    end

    Grower_reset_absurdities()

    local rules_to_absurdify = rand.pick({1,1,2,2,2,3,3,4})

    -- double the amount of absurd rules if it's closer to a balance of
    -- outdoor/interior environments based on level style
    if rand.odds(style_sel("outdoors", 0, 30, 45, 0)) then
      rules_to_absurdify = rules_to_absurdify * 2
    end

    local count = rules_to_absurdify
    gui.printf(rules_to_absurdify .. " rules will be absurd!\n\n")

    local grammarset = {}
    for _,rule in pairs(SHAPE_GRAMMAR) do
      table.insert(grammarset, rule.name)
    end

    -- pick rules to make absurd
    while #LEVEL.absurd_grammar_rules < rules_to_absurdify do
      local absurded_rule = rand.pick(grammarset)

      Grower_absurdify_rule(SHAPE_GRAMMAR[absurded_rule], rules_to_absurdify)
    end

    for _,rule in pairs(LEVEL.absurd_grammar_rules) do
      shape_order[rule.order] = rule.name
    end

    -- collect base set rules and preserve them
    for _,rule in pairs(SHAPE_GRAMMAR) do
      if rule.base_set and not rule.is_absurd then
        local info =
        {
          name = rule.name,
          prob = rule.use_prob
        }
        table.insert(LEVEL.base_set_rules, info)
      end
    end

    -- extra absurdity logic
    if #LEVEL.absurd_grammar_rules > 1 then
      if rand.odds(75) then
        LEVEL.absurdity_round_robin = true

        local stack_start = shape_order[1]
        for i = 1, #LEVEL.absurd_grammar_rules - 1 do
          LEVEL.absurd_grammar_rules[i].next = shape_order[i+1]
        end
        LEVEL.absurd_grammar_rules[#LEVEL.absurd_grammar_rules].next = stack_start
      end
    end

  end

  if LEVEL.is_absurd then
    Grower_absurdify()
    gui.printf("\n\n")
  end
end



function Grower_decide_extents(LEVEL)
  --
  -- decides how much of the map we can use for growing rooms.
  --


  if LEVEL.has_streets then
    if PARAM.bool_appropriate_street_themes 
    and PARAM.bool_appropriate_street_themes == 1 
    and not LEVEL.theme.streets_friendly then
      LEVEL.has_streets = nil
    end
  end

  assert(math.floor(LEVEL.map_W) < SEED_W)
  assert(math.floor(LEVEL.map_H) < SEED_H)

  local map_x1 = 1 + math.floor((SEED_W - LEVEL.map_W) / 2)
  local map_y1 = 1 + math.floor((SEED_H - LEVEL.map_H) / 2)

  local map_x2 = map_x1 + LEVEL.map_W - 1
  local map_y2 = map_y1 + LEVEL.map_H - 1


  -- we prevent creation of new rooms unless the initial part
  -- lies inside this sprout bbox...
  -- [ however we grow this when trying to fulfil the coverage ]
  local dist = 2

  LEVEL.sprout_x1 = map_x1 + dist
  LEVEL.sprout_y1 = map_y1 + dist
  LEVEL.sprout_x2 = map_x2 - dist
  LEVEL.sprout_y2 = map_y2 - dist

  gui.debugf("Sprout bbox : (%d %d) .. (%d %d)\n",
        LEVEL.sprout_x1, LEVEL.sprout_y1,
        LEVEL.sprout_x2, LEVEL.sprout_y2)


  -- this bbox is the limit where any walkable/visitable parts
  -- of a room may be placed...
  dist = 8

  local EDGE = 4

  LEVEL.walkable_x1 = math.max(map_x1 - dist, 1 + EDGE)
  LEVEL.walkable_y1 = math.max(map_y1 - dist, 1 + EDGE)

  LEVEL.walkable_x2 = math.min(map_x2 + dist, SEED_W - EDGE)
  LEVEL.walkable_y2 = math.min(map_y2 + dist, SEED_H - EDGE)

  gui.debugf("Walkable bbox : (%d %d) .. (%d %d)\n",
        LEVEL.walkable_x1, LEVEL.walkable_y1,
        LEVEL.walkable_x2, LEVEL.walkable_y2)


  -- this bbox is the absolute limit where anything can be placed
  -- (especially scenic areas which border the normal rooms).
  -- in other words, seeds outside this range will never be used.
  LEVEL.absolute_x1 = math.max(LEVEL.walkable_x1 - EDGE, 1)
  LEVEL.absolute_y1 = math.max(LEVEL.walkable_y1 - EDGE, 1)
  LEVEL.absolute_x2 = math.min(LEVEL.walkable_x2 + EDGE, SEED_W)
  LEVEL.absolute_y2 = math.min(LEVEL.walkable_y2 + EDGE, SEED_H)

  gui.debugf("Absolute bbox : (%d %d) .. (%d %d)\n",
        LEVEL.absolute_x1, LEVEL.absolute_y1,
        LEVEL.absolute_x2, LEVEL.absolute_y2)


  -- calculate a minimum and maximum # of rooms

  local base = (LEVEL.map_W - 12) * 0.72

  LEVEL.min_rooms = math.max(3, math.floor(base / 3))
  LEVEL.max_rooms = math.max(6, math.floor(base))

  -- add extra rooms based on extra size and area multiplier

  if LEVEL.size_multiplier then
    if LEVEL.size_multiplier < 1 then
      LEVEL.max_rooms = math.floor(LEVEL.max_rooms * ((1 - LEVEL.size_multiplier)+1) * 2/3)
    end
    if LEVEL.area_multiplier < 1 then
      LEVEL.max_rooms = math.floor(LEVEL.max_rooms * ((1 - LEVEL.area_multiplier)+1) * 2/3)
    end
  end

  -- specific instructions for procedural gotcha

  if LEVEL.is_procedural_gotcha == true then
    if PARAM.bool_boss_gen == 1 then
      LEVEL.min_rooms = 1
      LEVEL.max_rooms = 1
    else
      LEVEL.min_rooms = 2
      LEVEL.max_rooms = 2
    end
  end

  gui.printf("Target # of rooms : %d .. %d\n\n", LEVEL.min_rooms, LEVEL.max_rooms)


  -- calculate the coverage target

  LEVEL.min_coverage = math.floor(LEVEL.map_W * LEVEL.map_H * 0.65)

  if LEVEL.has_streets then
    gui.printf("--==| Streets Mode activated! |==--\n\n")
  end

  if LEVEL.is_nature then
    gui.printf("--==| Nature mode activated! Take a walk! |==--\n\n")
  end

  -- linear start code
  if PARAM.linear_start 
  and PARAM.linear_start ~= "default"
  and PARAM.linear_start == "all" then
    LEVEL.has_linear_start = true
  end

  if LEVEL.has_linear_start then
    gui.printf("--==| Linear Start activated! |==--\n\n")
  end
end



function Grower_determine_coverage(SEEDS, LEVEL)
  local seed_count = 0
  local room_count = 0

  for sx = 1, SEED_W do
  for sy = 1, SEED_H do
    local S = SEEDS[sx][sy]

    if S.area or (S.top and S.top.area) then
      seed_count = seed_count + 1
    end
  end
  end

  -- ignore hallways when counting rooms
  for _,R in pairs(LEVEL.rooms) do
    if R.is_grown and not R.is_hallway then
      room_count = room_count + 1
    end
  end

  return seed_count, room_count
end



function Grower_split_liquids(SEEDS, LEVEL)
  --
  -- Checks the liquid areas in a room are contiguous.
  -- When the area has separate pieces, make new areas for them.
  --
  -- Handles large cages too.
  --

  local good_areas = {}


  local function grow_contiguous_area(S, list)
    S.mark_contiguous = true

    table.insert(list, S)

    for _,dir in pairs(geom.ALL_DIRS) do
      local N = S:neighbor(dir, nil, SEEDS)

      if N and N.area == S.area and not N.mark_contiguous then
        grow_contiguous_area(N, list)
      end
    end
  end


  local function split_area(A, mode, seed_list)
    local A2 = AREA_CLASS.new(LEVEL, mode)

    A2.room = A.room
    A2.room:add_area(A2)

    A2.cage_mode = A.cage_mode

    A2.seeds = seed_list

    for _,S in pairs(seed_list) do
      S.area = A2

      table.kill_elem(A.seeds, S)
    end

    return A2
  end


  local function check_at_seed(S, mode)
    local A = S.area

    if not A then return end
    if not A.room then return end

    if A.mode ~= mode then return end

    -- already known to be contiguous?
    if good_areas[A] then return end

    local list = {}

    grow_contiguous_area(S, list)

    -- clear the marking flag
    for _,S in pairs(list) do
      S.mark_contiguous = false
    end

    -- all seeds in the area are contiguous?
    if #list >= #A.seeds then
      good_areas[A] = true
      return
    end

    -- current area is not contiguous, need to split it

    local A2 = split_area(A, mode, list)

    good_areas[A2] = true
  end


  local function check_all_seeds(mode)
    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S = SEEDS[sx][sy]

      check_at_seed(S, mode)

      if S.top then
        check_at_seed(S.top, mode)
      end
    end  -- sx, sy
    end
  end


  local function handle_symmetry(R)
    for _,A in pairs(R.areas) do
      if A.peer then goto continue end

      if A.mode == "liquid" or A.mode == "cage" then
        local S = A.seeds[1]

        if not S then
          A.mode = "void"
          return
        end

        assert(S)
        assert(S.area == A)

        local T = R.symmetry:transform(S, SEEDS)

        if T and T.area and T.area.room == R and T.area.mode == A.mode then
          A.peer = T.area
          T.area.peer = A
        end
      end
      ::continue::
    end
  end


  ---| Grower_split_liquids |---

  check_all_seeds("liquid")
  check_all_seeds("cage")

  -- in symmetrical rooms, peer up the mirrored parts
  for _,R in pairs(LEVEL.rooms) do
    if R.symmetry then
      handle_symmetry(R)
    end
  end
end



function Grower_new_prelim_conn(LEVEL, R1, R2, kind)
  local PC =
  {
    R1 = R1,
    R2 = R2,
    kind = kind
  }

  table.insert(LEVEL.prelim_conns, PC)

  return PC
end


function Grower_kill_prelim_conn(LEVEL, PC)
  PC.kind  = "DEAD"
  PC.is_dead = true

  PC.R1    = nil
  PC.R2    = nil
  PC.chunk = nil

  table.kill_elem(LEVEL.prelim_conns, PC)
end



function Grower_add_room(LEVEL, parent_R, info, trunk, rule)

  local R = ROOM_CLASS.new(LEVEL)

  if rule then
    R.sprout_rule = rule.name
  end

gui.debugf("new room %s : env = %s : parent = %s\n", R.name, tostring(info.env), tostring(parent_R and parent_R.name))

  if info.force_start then
    R.is_start = true
    LEVEL.start_room = R
  end

  if info.force_exit then
    R.is_exit = true
    LEVEL.exit_room = R
  end

  -- streets you gotta have
  if LEVEL.has_streets then
    if info.env ~= "hallway"
    and info.env ~= "cave"
    and not R.is_park then
      if R.id%2 == 0
      and rand.odds(66) then
        R.is_street = true
        R.is_outdoor = true
      end
    end
  end

  if info.force_no_street then
    R.is_street = false
  end

  if trunk == nil then
    assert(parent_R)
    trunk = assert(parent_R.trunk)
  end

  R.trunk = trunk
  table.insert(trunk.rooms, R)

  R.grow_parent = parent_R


  -- pick room environment (outdoor / cave)
  local is_hallway = false
  local is_outdoor = false
  local is_cave = false

  if info.env == "hallway" then
    is_hallway = true
  elseif info.env == "outdoor" then
    is_outdoor = true
  elseif info.env == "building" then
    is_outdoor = false
  elseif info.env == "cave" then
    is_cave = true
  else
    is_outdoor = Room_choose_kind(R, parent_R, LEVEL)
  end

  Room_set_kind(R, is_hallway, is_outdoor, is_cave, LEVEL)

  if info.force_no_hallway then
    R.is_hallway = false
  end

  if R.is_street then
    is_outdoor = true
    is_hallway = false
    is_cave = false
  end

  Room_choose_size(LEVEL, R)

  -- always need at least one floor area
  -- [ except for hallways, every piece is an area ]

  if is_hallway then
    R.all_links = {}

    -- choose what kind of hallway to make
    local kind_tab
    if info.hall_type == "narrow" then kind_tab = THEME.narrow_halls end
    if info.hall_type == "wide"   then kind_tab = THEME.  wide_halls end

    -- unusable hallway types are inhibited in prob_for_rule()
    assert(kind_tab and not table.empty(kind_tab))

    R.hall_type  = info.hall_type

    R.hall_group = rand.key_by_probs(kind_tab)

  else
    local A = AREA_CLASS.new(LEVEL, "floor")
    R:add_area(A)

    A.prelim_h = 0

    -- max size of new area  [ for caves it is whole room ]
    if R.is_cave or R.is_park then
      A.max_size = R.size_limit
    elseif R.is_big then
      A.max_size = R.size_limit
    else
      A.max_size = rand.pick({ 16, 24, 32 })
    end

  end


  R.delta_limit_mode = rand.sel(50, "positive", "negative")
  R.delta_up_chance  = 50

  if rand.odds(70) then
    if R.delta_limit_mode == "positive" then
      R.delta_up_chance = 90
    else
      R.delta_up_chance = 10
    end
  end

  return R
end



function Grower_kill_room(SEEDS, LEVEL, R)
  gui.debugf("Killing " .. R.id .. "\n")

  local function turn_joiner_into_closet(R2, chunk)
    chunk.kind = "closet"

    chunk.area.mode = "void"    -- ugh, what?
    chunk.content = "void"

    chunk.dest_dir  = nil
    chunk.dest_area = nil
    chunk.shape = "U"

    table.insert(R2.closets, chunk)
  end


  local function kill_joiner(chunk)
    local A2 = chunk.area
    local R2 = A2.room
    assert(R2)

    gui.debugf("  killing joiner in %s\n", R2.name)

    table.kill_elem(R2.joiners, chunk)

    if chunk.peer then
      chunk.peer.peer = nil
      chunk.peer = nil
    end

    if false then
      turn_joiner_into_closet(R2, chunk)
      return
    end

    A2:kill_it(LEVEL, "remove_from_room", SEEDS)
  end


  local function handle_conn()
    -- there should be a single prelim-conn : find and kill it

    for _,PC in pairs(LEVEL.prelim_conns) do
      if PC.R1 == R or PC.R2 == R then
        gui.debugf("  killing prelim conn %s -> %s\n", PC.R1.name, PC.R2.name)

        local other = sel(PC.R1 == R, PC.R2, PC.R1)

        if other.is_hallway then
          hallway_neighbor = other

          assert(PC.chunk)
          assert(PC.chunk.is_terminator)

          PC.chunk.cut_off = true
        end

        if PC.kind == "joiner" and PC.chunk.area.room ~= R then
          kill_joiner(PC.chunk)
        end

        Grower_kill_prelim_conn(LEVEL, PC)
        break;
      end
    end

    -- sanity check
    for _,PC in pairs(LEVEL.prelim_conns) do
      assert(not (PC.R1 == R or PC.R2 == R))
    end
  end


  ---| Grower_kill_room |---

  gui.debugf("Killing small/ungrown room %s\n", R.name)

  assert(R ~= LEVEL.start_room)
  assert(R ~= LEVEL.exit_room)

  handle_conn()

  R:kill_it(LEVEL, SEEDS)

  -- if this room was connected to a hallway, we should prune it too
  -- (which may end up recursing into this function)
  if hallway_neighbor then
    Grower_prune_hallway(SEEDS, LEVEL, hallway_neighbor)
  end

  -- sanity check
  if table.empty(LEVEL.rooms) then
    error("All rooms were pruned!")
  end

  -- make any split diagonals seeds whole again
  Seed_squarify(LEVEL, SEEDS)
end

function Grower_grammatical_pass(SEEDS, LEVEL, R, pass, apply_num, stop_prob,
                                 parent_rule, is_create, is_emergency)
  --
  -- Creates rooms using Shape Grammars.
  --

  local grammar = SHAPE_GRAMMAR

  -- reset absurdified rules
  for _,R in pairs(LEVEL.absurd_grammar_rules) do
    grammar[R.name].use_prob = R.prob
  end
  for _,rule in pairs(LEVEL.base_set_rules) do
    grammar[rule.name].use_prob = rule.prob
  end

  --

  local cur_rule
  local cur_symmetry

  -- this maps area numbers (1/2/3) in the current rule to areas of
  -- the current room
  local area_map = {}

  -- if rule matches a link ('@'), this is the link chunk
  local link_chunk

  -- this table contains the current best match.
  -- fields include:
  --     score   : number (higher is better), < 0 if no match yet
  --     T       : the transform of the best match
  --     areas[] : copy of the area_map[] table
  local best = {}

  local new_room
  local new_conn
  local new_area
  local new_intconn

  -- this is used to mark seeds for one side of a mirrored rule
  -- (in symmetrical rooms).
  local sym_token

  -- list of transformed rectangles (copied from cur_rule.rects)
  local new_chunks
  local old_chunks

  -- true when room has reached the limit on floor areas
  local hit_floor_limit


  local function what_in_there(S)
    local A = S.area
    if not A then return "-" end
    if not A.room then return "?" end
    return A.name
  end


  local function unset_seed(S)
    local A = assert(S.area)
    assert(A.room)

    S.area = nil

    table.kill_elem(A.seeds, S)
  end


  local function set_seed(S, A)
    assert(A.room)

    if S.area == A then return end

    if S.area then
      assert(S.area.room == R)
      unset_seed(S)
    end

    S.area = A

    table.insert(A.seeds, S)

    -- update the room's growth bbox
    if A.room then
      local AR = A.room

      if not AR.gx1 or S.sx < AR.gx1 then AR.gx1 = S.sx end
      if not AR.gy1 or S.sy < AR.gy1 then AR.gy1 = S.sy end

      if not AR.gx2 or S.sx > AR.gx2 then AR.gx2 = S.sx end
      if not AR.gy2 or S.sy > AR.gy2 then AR.gy2 = S.sy end
    end
  end


  local function set_liquid(S)
    if not R.dummy_liquid then
       R.dummy_liquid = AREA_CLASS.new(LEVEL, "liquid")
       R:add_area(R.dummy_liquid)
    end

    set_seed(S, R.dummy_liquid)
  end


  local function set_cage(S)
    if not R.dummy_cage then
       R.dummy_cage = AREA_CLASS.new(LEVEL, "cage")
       R:add_area(R.dummy_cage)
    end

    set_seed(S, R.dummy_cage)
  end


  local function set_cage_fancy(S)
    if not R.fancy_cage then
       R.fancy_cage = AREA_CLASS.new(LEVEL, "cage")
       R.fancy_cage.cage_mode = "fancy",

       R:add_area(R.fancy_cage)
    end

    set_seed(S, R.fancy_cage)
  end


  local function prob_for_rule(rule)
    -- the 'use_prob' field is computed earler, and already takes styles
    -- into account.

    local prob = rule.use_prob or 0

    if prob <= 0 then return 0 end

    if rule.emergency then
      if not is_emergency then return 0 end
    end

    if not ob_match_level_theme(LEVEL, rule) then return 0 end
    if not ob_match_feature(rule)     then return 0 end

    -- aversion check (less chance if used before)
    if R.aversions[rule.name] then
      prob = prob * R.aversions[rule.name]
    end

    -- don't exceed trunk quota
    if not is_emergency and rule.teleporter and #LEVEL.trunks >= LEVEL.max_trunks then
      return 0
    end

    if rule.teleporter and R.is_exit then
      prob = prob / 4
    end

    -- stair direction check
    if rule.z_dir == "up"   and R.trunk.stair_z_dir < 0 then return 0 end
    if rule.z_dir == "down" and R.trunk.stair_z_dir > 0 then return 0 end

    -- no cages in start rooms
    if R.is_start and table.has_elem(rule.styles, "cages") then return 0 end

    -- environment checks...
    if (rule.env or "any") ~= "any" then
      -- FIXME: support "!xxx" properly [ see prefab code ]
      if rule.env == "!cave" then
        if R:get_env() == "cave" then return 0 end
      else
        if rule.env ~= R:get_env() then return 0 end
      end
    end

    -- hallways and caves are more restrictive than normal
    if R.is_hallway and rule.env ~= "hallway" then
      return 0
    end

    if pass == "root" or pass == "grow" then
      if R.is_cave and rule.env ~= "cave" then return 0 end
      if R.is_park and rule.env ~= "park" then return 0 end
    end


    --MSSP attachment: never use liquids nor steepness in caves and stuff ever - very evil stuff ya know
    if pass == "sprout" or pass == "decorate" then
      if R.is_park and table.has_elem(rule.styles, "steepness") then return 0 end
      if R.is_park and table.has_elem(rule.styles, "liquids") then return 0 end
      if R.is_cave and table.has_elem(rule.styles, "steepness") then return 0 end
      if R.is_cave and table.has_elem(rule.styles, "liquids") then return 0 end
      if R.is_cave and table.has_elem(rule.styles, "cages") then return 0 end
    end

    if rule.new_room and rule.new_room.env == "cave" then
      if R.is_cave then
        prob = prob * LEVEL.cave_extend_factor
      else
        prob = prob * LEVEL.cave_new_factor
      end
    end

    return prob
  end


  local function prob_for_symmetry(R)
    if R.is_hallway then return 0 end

    if R.is_cave then return 0 end

    if R.is_street then return 0 end

    if LEVEL.has_linear_start then
      if R.is_start then return 0 end 
      if not R.grow_parent and not R.is_start then
        return 0 
      end
    end

 
    if R.is_outdoor then
      return style_sel("symmetry", 0,  5, 15, 50)
    else
      return style_sel("symmetry", 0, 20, 50, 90)
    end
  end


  local function collect_matching_rules(want_pass, stop_prob, no_new_areas)
    local tab = {}

    for name,rule in pairs(grammar) do
      if type(rule) ~= "table" then goto continue end

      if rule.pass ~= want_pass then goto continue end

      if no_new_areas and rule.new_area then goto continue end

      local prob = prob_for_rule(rule)

      if prob > 0 then
        tab[name] = prob
      end
      ::continue::
    end

    --if SHAPE_GRAMMAR == SHAPES.OBSIDIAN then
      --if table.empty(tab) then
        --error("No rules found for " .. tostring(want_pass) .. " pass")
      --end
    --end

    if stop_prob > 0 then
      tab["STOP"] = stop_prob
    end

    return tab
  end


  local function calc_transform(transpose, flip_x, flip_y)
    local T =
    {
      flip_x = (flip_x > 0),
      flip_y = (flip_y > 0),

      transpose = (transpose > 0)
    }

    return T
  end


  local function transform_coord(T, px, py)
    px = px - 1
    py = py - 1

    if T.flip_x then px = -px end
    if T.flip_y then py = -py end

    if T.transpose then px, py = py, px end

    return T.x + px, T.y + py
  end


  local function transform_dir(T, dir)
    if T.flip_x then dir = geom.MIRROR_X[dir] end
    if T.flip_y then dir = geom.MIRROR_Y[dir] end

    if T.transpose then dir = geom.TRANSPOSE[dir] end

    return dir
  end


  local function transform_is_flippy(T)
    local res = false

    if T.flip_x then res = not res end
    if T.flip_y then res = not res end

    if T.transpose then res = not res end

    return res
  end


  local function transform_diagonal(T, dir, bottom, top)
    if T.flip_x then
      dir = geom.MIRROR_X[dir]
    end

    if T.flip_y then
      dir = geom.MIRROR_Y[dir]
      top, bottom = bottom, top
    end

    if T.transpose then
      if dir == 3 or dir == 7 then
        dir = 10 - dir
        top, bottom = bottom, top
      end
    end

    return dir, bottom, top
  end


  local function transform_rect(T, rect)
    local x1, y1 = transform_coord(T, rect.x1, rect.y1)
    local x2, y2 = transform_coord(T, rect.x2, rect.y2)

    if x1 > x2 then x1,x2 = x2,x1 end
    if y1 > y2 then y1,y2 = y2,y1 end

    return x1,y1, x2,y2
  end


  local function transform_symmetry(T)
    if not cur_rule.new_room then return nil end

    local symmetry_choices = {}

    for key,SYM in pairs(cur_rule.new_room) do
      if string.gmatch(key, "symmetry") then
        if SYM.kind and (SYM.kind ~= "rotate" or rand.odds(20)) then
          table.insert(symmetry_choices, key)
        end
      end
    end

    --[[for i = 1,9 do
      local name = "symmetry"
      if i > 1 then name = name .. i end

      local info = cur_rule.new_room[name]

      if info and (info.kind ~= "rotate" or rand.odds(20)) then
        table.insert(all_symmetries, cur_rule.new_room[name])
      end
    end]]

    if table.empty(symmetry_choices) then return end

    local info = cur_rule.new_room[rand.pick(symmetry_choices)]

    local sym = Symmetry_new(info.kind or "mirror")

    sym.x, sym.y = transform_coord(T, info.x, info.y)

    if info.x2 then
      sym.x2, sym.y2 = transform_coord(T, info.x2, info.y2)

      if sym.x > sym.x2 then sym.x, sym.x2 = sym.x2, sym.x end
      if sym.y > sym.y2 then sym.y, sym.y2 = sym.y2, sym.y end
    end

    if info.dir then
      sym.dir = transform_dir(T, info.dir)
    end

    sym.wide = (info.w == 2)

    -- wide mode requires X and Y coord to be the lowest of the pair
    if sym.wide then
      local x2, y2 = geom.nudge(info.x, info.y, geom.RIGHT[info.dir])

      x2, y2 = transform_coord(T, x2, y2)

      sym.x = math.min(sym.x, x2)
      sym.y = math.min(sym.y, y2)
    end

    return sym
  end


  local function transform_connection(T, info, c_out)
    local sx, sy = transform_coord(T, info.x, info.y)
    assert(Seed_valid(sx, sy))

    local S = SEEDS[sx][sy]

    local dir2 = transform_dir(T, info.dir)

    if dir2 == 1 or dir2 == 3 then
      S = assert(S.top)
    end

    local long = info.w or 1

    if long > 1 and geom.is_straight(info.dir) and transform_is_flippy(T) then
      local across_dir = transform_dir(T, geom.RIGHT[info.dir])
      S = S:raw_neighbor(across_dir, long - 1, SEEDS)
    end

    c_out.S = S
    c_out.dir = dir2
    c_out.long = long
--[[
stderrf("transform_connection: (%d %d) dir %d --> (%d %d) S=%s A=%s dir=%d\n",
info.x, info.y, info.dir, sx, sy, S.name, S.area.name, dir2)
stderrf("prelim_conn %s --> %s : S=%s dir=%d\n", c_out.R1.name, c_out.R2.name, S.name, c_out.dir)
--]]
  end


  local function mark_connection_used(conn)
    local S = conn.S

    -- FIXME : handle joiners
    if not S then return end

    for i = 1, conn.long do
      local N = S:neighbor(conn.dir, nil, SEEDS)
      assert(N)

      S.no_assignment = true
      N.no_assignment = true

      if geom.is_straight(conn.dir) then
        S = S:raw_neighbor(geom.RIGHT[conn.dir], nil, SEEDS)
        assert(S)
      end
    end
  end


  local function get_iteration_range(T)
    if is_create then
      local dx = math.min(10, math.floor(SEED_W / 4))
      local dy = math.min(10, math.floor(SEED_H / 4))

      local mx = math.floor(SEED_W / 2)
      local my = math.floor(SEED_H / 2)

      -- the exit room is alway placed near top of map
      if cur_rule.absolute_pos == "top" or cur_rule.absolute_pos == "corner" then
        my = LEVEL.sprout_y2 + 2
        dy = 8
      end

      if cur_rule.absolute_pos == "right" or cur_rule.absolute_pos == "corner" then
        mx = LEVEL.sprout_x2 + 2
        dx = 8
      end

--[[      if cur_rule.absolute_pos == "bottom" then
        mx = LEVEL.sprout_x2 - 2,
        dx = 8,
      end]]

      return mx-dx, my-dy, mx+dx, my+dy
    end


    -- firstly compute the bounding box that a pattern will occupy
    -- [ relative to any T.x, T.y coordinate being tried ]

    T.x = 0
    T.y = 0

    local W = cur_rule.input.w
    local H = cur_rule.input.h

    local dx1, dy1 = transform_coord(T, 1, 1)
    local dx2, dy2 = transform_coord(T, W, H)

    if dx1 > dx2 then dx1, dx2 = dx2, dx1 end
    if dy1 > dy2 then dy1, dy2 = dy2, dy1 end

--stderrf("\n\n Rule %s : %dx%d\n", cur_rule.name, W, H)
--stderrf("delta size: (%d %d) .. (%d %d)\n", dx1, dy1, dx2, dy2)

    -- secondly, compute the bounding box we *want* to cover
    -- [ namely the current room size expanded by size of pattern,
    --   then limited to the map itself ]

    if T.transpose then W, H = H, W end

    local x1 = R.gx1 - W
    local y1 = R.gy1 - H

    local x2 = R.gx2 + W
    local y2 = R.gy2 + H

--stderrf("raw want area : (%d %d) .. (%d %d)\n", x1,y1, x2,y2)

    x1 = math.max(x1, 1)
    y1 = math.max(y1, 1)

    x2 = math.min(x2, SEED_W)
    y2 = math.min(y2, SEED_H)

--stderrf("clipped want area : (%d %d) .. (%d %d)\n", x1,y1, x2,y2)

    -- finally, combine them

    x1 = x1 - dx1 ; y1 = y1 - dy1
    x2 = x2 - dx2 ; y2 = y2 - dy2

--stderrf("RESULT : (%d %d) .. (%d %d)\n\n", x1,y1, x2,y2)

    assert(x2 >= x1)
    assert(y2 >= y1)

    return x1, y1, x2, y2
  end


  local function convert_symmetrical_transform(sym, T)
    local T2 = table.copy(T)

    if sym.kind == "rotate" then
      T2.x = sym.x * 2 + (sym.x2 - sym.x) - T.x
      T2.y = sym.y * 2 + (sym.y2 - sym.y) - T.y

      T2.flip_x = not T2.flip_x
      T2.flip_y = not T2.flip_y

      return T2
    end

    if sym.dir == 2 or sym.dir == 8 then
      T2.x = sym.x * 2 + sel(sym.wide, 1, 0) - T.x

      if T.transpose then
        T2.flip_y = not T.flip_y
      else
        T2.flip_x = not T.flip_x
      end

      return T2
    end

    if sym.dir == 4 or sym.dir == 6 then
      T2.y = sym.y * 2 + sel(sym.wide, 1, 0) - T.y

      if T.transpose then
        T2.flip_x = not T.flip_x
      else
        T2.flip_y = not T.flip_y
      end

      return T2
    end

    if sym.dir == 1 or sym.dir == 9 then
      T2.x = sym.x + (T.y - sym.y)
      T2.y = sym.y + (T.x - sym.x)

      T2.transpose = not T.transpose

      return T2
    end

    if sym.dir == 3 or sym.dir == 7 then
      T2.x = sym.x - (T.y - sym.y)
      T2.y = sym.y - (T.x - sym.x)

      T2.transpose = not T.transpose
      T2.flip_x    = not T.flip_x
      T2.flip_y    = not T.flip_y

      return T2
    end

    error("convert_mirrored_transform: weird sym.dir")
  end


  local function is_element_a_chunk(E)
    return E.kind == "closet" or E.kind == "joiner" or
           E.kind == "stair"  or E.kind == "hallway" or
           E.kind == "link"
  end


  local function find_chunk(sx, sy)
    if new_chunks then
      for _,K in pairs(new_chunks) do
        if K.sx1 <= sx and sx <= K.sx2 and
           K.sy1 <= sy and sy <= K.sy2
        then
          return K
        end
      end
    end

    return nil
  end


  local function match_floor(E1, A)
    return area_map[E1.area] == A
  end


  local function match_link(E1, A)
    if A.mode ~= "chunk" then return false end

    return link_chunk == A.chunk
  end


  local function match_a_magic_element(S, E1)
    local A = S.area

    if E1.what == "all" then return true end

    -- this one allows other rooms, and the '#' disable element
    -- FIXME : "closed" elements may not be useful, review this
    if E1.what == "closed" then
      if not A then return true end
      if A.room ~= R then return true end
      if S.disabled_R == R then return true end

      if A.chunk and A.chunk.kind == "closet" then return true end
      if A.chunk and A.chunk.kind == "joiner" then return true end

      return false
    end

    -- all other magic elements require an area and same room
    if not A then return false end
    if A.room ~= R then return false end
    if S.disabled_R == R then return false end

    if E1.what == "room" then
      return A and A.room == R
    end

    if E1.what == "floor" then
      return A.mode == "floor"
    end

    -- FIXME : this "open" element may not be useful, review this
    if E1.what == "open" then
      if A.chunk and A.chunk.kind == "closet" then return false end
      if A.chunk and A.chunk.kind == "joiner" then return false end

      return true
    end

    error("Unknown element kind: magic/" .. tostring(E1.what))
  end


  local function match_an_element(S, E1, E2, T)

    if E1.kind == "magic" then
      assert(not E2.assignment)
      return match_a_magic_element(S, E1)
    end

    -- new rooms must not be placed in boundary spaces
    if (E2.kind == "new_room" or E2.kind == "hallway") and
       not Seed_inside_sprout_box(LEVEL, S.sx, S.sy)
    then
      return false
    end


    -- symmetry handling
    -- [ we prevent a pattern from overlapping its mirror ]
    -- [[ but we allow setting whole seeds *on* the axis of symmetry ]]
    -- [[[ except for new rooms and chunks, as they must remain distinct ]]]
    if T.is_first and E2.assignment then
      if E2.kind == "new_room" or
         E2.kind == "hallway" or
         is_element_a_chunk(E2) or
         not R.symmetry:on_axis(S.sx, S.sy)
      then
        S.sym_token = assert(sym_token)
      end
    end

    if T.is_second and E2.assignment then
      if S.sym_token == assert(sym_token) then
        return false
      end
    end

    -- don't allow staircase to touch
    if E2.kind == "stair" and E2.assignment then
      if S.no_stair_R == R then return false end
    end

    -- for "!", require nothing there at all
    if E1.kind == "free" and E1.utterly then
      if S.area then return false end
      if S.disabled_R == R then return false end

      if not Seed_inside_boundary(LEVEL, S.sx, S.sy) then
        return false
      end

      return true
    end


    if E1.kind == "disable" then
      return (S.disabled_R == R)
    end

    -- seed is locked out of further changes?
    if E2.assignment and (S.no_assignment or S.disabled_R == R) then
      return false
    end


    -- do we have an area in current room?
    local A = S.area
    if A and A.room ~= R then A = nil end

    if E1.kind == "free" then
      return not A
    end

    -- everything else requires an area of the current room
    if not A then return false end

    if E1.kind == "area" then
      return match_floor(E1, A)

    elseif E1.kind == "link" then
      return match_link(E1, A)

    elseif E1.kind == "liquid" or
           E1.kind == "cage"
    then
      return (A.mode == E1.kind)
    end

    local chunk = S.chunk

    if E1.kind == "stair" then
      -- note: we do not check direction of stair
      return chunk and chunk.kind == "stair"
    end

    if E1.kind == "closet" then
      return chunk and chunk.kind == "closet"
    end

    error("Element kind not testable: " .. tostring(E1.kind))
  end


  local function match_a_focal_point(area_num, T, px, py)
    local sx, sy = transform_coord(T, px, py)

    if sx <= 1 or sx >= SEED_W or
       sy <= 1 or sy >= SEED_H
    then
      return false
    end

    local S = SEEDS[sx][sy]
    local A = S.area

    if not A then return false end
    if S.diagonal and S.top.area ~= A then return false end

    if A.room ~= R then return false end

    -- logic for hallway links --

    if area_num == "link" then
      if A.mode ~= "chunk" then return false end
      if A.chunk.kind ~= "link" then return false end

      if link_chunk and link_chunk ~= A.chunk then return false end

      link_chunk = A.chunk
      return true
    end

    -- normal logic --

    if R.is_hallway then
      if A.mode ~= "chunk" then return false end
      if A.chunk.kind ~= "hallway" then return false end
    else
      if A.mode ~= "floor" then return false end
    end

    -- FIXME : hallways may need special treatment (see code above)

    -- check the area is NOT assigned to a different area_num
    if area_map[1] == A then return (area_num == 1) end
    if area_map[2] == A then return (area_num == 2) end
    if area_map[3] == A then return (area_num == 3) end

    if area_map[area_num] ~= nil then return false end

    -- check if area is inhibiting further growth or sprouts
    if pass == "grow"   and A.no_grow    then return false end
    if pass == "sprout" and A.no_sprout  then return false end

    -- check if the area would grow too big
    local growth = cur_rule.area_growths[area_num] or 0
    if growth > 0 and #A.seeds + growth > A.max_size and not is_emergency then
      return false
    end

    -- don't create a brand new area when existing area is tiny
    if not R.is_hallway and cur_rule.new_area and pass ~= "sprout" then
      A:calc_volume()
      local area_min_size = sel(R.symmetry, 8, 4)
      if A.svolume < area_min_size then return false end
    end

    -- OK --
    area_map[area_num] = A

    return true
  end


  local function install_an_element(S, E1, E2, T)
    assert(E2.assignment)

    if E2.kind == "disable" then
      -- prevent the seed being used by THIS room ever again
      -- [ however, OTHER rooms are allowed to use it, and actually
      --   may already be using it! ]
      S.disabled_R = R
      return
    end

    if E2.kind == "free" then
      if S.area then
        unset_seed(S)
      end

      return
    end

    -- handle special rectangles (stairs, cages, traps)
    local chunk = find_chunk(S.sx, S.sy)

    if chunk then
      assert(chunk.area)
      set_seed(S, chunk.area)
      S.chunk = chunk
      return
    end

    if E2.kind == "area" then
      -- an assertion here usually means the grammar rule uses e.g. '2'
      -- in the output side but not in the input side.
      local A = assert(area_map[E2.area])
      set_seed(S, A)
      return
    end

    if E2.kind == "new_area" then
      assert(new_area)

      set_seed(S, new_area)
      return
    end

    if E2.kind == "new_room" then
      assert(new_room)
      set_seed(S, new_room.areas[1])
      return
    end

    if E2.kind == "liquid" then
      set_liquid(S)
      return
    end

    -- this is for LARGE (free-range) cages
    -- [ prefab cages are done via "closet" elements ]
    if E2.kind == "cage" then
      if cur_rule.cage_mode then
        set_cage_fancy(S)
      else
        set_cage(S)
      end

      return
    end

    error("INSTALL : unsupported kind: " .. E2.kind)
  end


  local function match_or_install_B(what, S, E1, E2, T)
    if what == "TEST" then
      return match_an_element(S, E1, E2, T)
    end

    if E2.assignment then
      return install_an_element(S, E1, E2, T)
    end

    return true
  end


  local function match_or_install_element(what, E1, E2, T, px, py)
    local sx, sy = transform_coord(T, px, py)

    -- never allow patterns to touch edge of map
    if sx <= 1 or sx >= SEED_W or
       sy <= 1 or sy >= SEED_H
    then
      return false
    end

    local S = SEEDS[sx][sy]

    local S2 = S.top or S


    -- simplest case : square on square

    if not E1.diagonal and not S.diagonal then
      return match_or_install_B(what, S, E1, E2, T)
    end


    -- fairly simple : square on diagonal

    if not E1.diagonal then
      assert(S.diagonal)

      if what == "TEST" then
        return match_an_element(S,  E1, E2, T) and
               match_an_element(S2, E1, E2, T)
      end

      if E2.assignment then
        if S .area then unset_seed(S)  end
        if S2.area then unset_seed(S2) end

        S:join_halves()

        install_an_element(S, E1, E2, T)
      end

      return true
    end


    assert(E1.diagonal)
    assert(E2.diagonal)


    -- in symmetrical rooms, forbid diagonals on axis of symmetry
    if (T.is_first or T.is_second) and R.symmetry:on_axis(sx, sy) then
      return false
    end


    local  dir, E1B, E1T = transform_diagonal(T, E1.diagonal, E1.bottom, E1.top)
    local zdir, E2B, E2T = transform_diagonal(T, E2.diagonal, E2.bottom, E2.top)


    -- diagonal on square

    if not S.diagonal then
      -- for the test, no need to remap anything
      if what == "TEST" then
        return match_an_element(S, E1B, E2B, T) and
               match_an_element(S, E1T, E2T, T)
      end

      if E2B.assignment or E2T.assignment then

        -- split the seed
        local A = S.area
        if A then unset_seed(S) end

        S:split(math.min(dir, 10 - dir))
        S2 = S.top

        if A then
          set_seed(S,  A)
          set_seed(S2, A)
        end

        if E2B.assignment then install_an_element(S,  E1B, E2B, T) end
        if E2T.assignment then install_an_element(S2, E1T, E2T, T) end
      end

      return true
    end


    -- final case : diagonal on diagonal

    assert( S.diagonal)

    if not geom.is_parallel(S.diagonal, dir) then
          -- incompatible diagonals
      return false
    end

    local res1 = match_or_install_B(what, S , E1B, E2B, T)
    local res2 = match_or_install_B(what, S2, E1T, E2T, T)

    return res1 and res2
  end


  local function add_internal_conn(A1, A2, kind)
    local C =
    {
      kind = kind or "direct",

      A1 = A1,
      A2 = A2,
    }

    if cur_rule.has_stair then
      assert(not cur_rule.joiner)
      C.kind = "stair"
    end

    table.insert(R.internal_conns, C)

    return C
  end


  local function mark_chunk_nb_side(r, dir)
    assert(geom.is_straight(dir))

    local x1, y1 = r.sx1, r.sy1
    local x2, y2 = r.sx2, r.sy2

    if dir == 2 then y2 = y1 end
    if dir == 8 then y1 = y2 end
    if dir == 4 then x2 = x1 end
    if dir == 6 then x1 = x2 end

    for sx = x1, x2 do
    for sy = y1, y2 do
      local S = SEEDS[sx][sy]

      local N = S:neighbor(dir)
      assert(N)

      N.no_assignment = true
    end
    end
  end


  local function mark_chunk_neighbors(r)  -- UNUSED ????
    local shape = assert(r.shape)

    -- the "dir" generally faces its source
    -- [ but it won't matter when shape is "I" or "P" ]
    assert(r.dir)

    mark_chunk_nb_side(r, r.dir)

    -- this handles "L" shape
    if r.dir2 then
      mark_chunk_nb_side(r, r.dir2)
    end

    if shape == "I" or shape == "P" then
      mark_chunk_nb_side(r, 10 - r.dir)
    end

    if shape == "T" or shape == "P" then
      mark_chunk_nb_side(r, geom.LEFT [r.dir])
      mark_chunk_nb_side(r, geom.RIGHT[r.dir])
    end
  end


  local function pick_stair_prefab(chunk)
    local A = chunk.area
    local R = A.room

    if not R.has_consistent_stairs_rolled then
      -- should probably put this in a function for cleanliness
      for _,P in pairs(PREFABS) do
        if P.kind == "stairs" then
          if P.original_rank and P.original_rank ~= 0 then
            P.rank = P.original_rank
            P.original_rank = nil
          else
            P.rank = nil
          end
        end
      end
    end

    if rand.odds(R.trunk.consistent_stairs) 
    and not R.has_consistent_stairs_rolled then
      R.has_consistent_stairs = true
    end

    R.has_consistent_stairs_rolled = true

    local reqs = chunk:base_reqs(chunk.from_dir)

    reqs.kind  = "stairs"
    reqs.shape = assert(chunk.shape)

    if A.room then
      reqs.env = A.room:get_env()
    end

    -- prevent small areas connected with a lift
    -- [ FIXME : this is broken due to deep staircases ]
    if false then
      local vol_1 = chunk.from_area.svolume / sel(R.symmetry, 2, 1)
      local vol_2 = chunk.dest_area.svolume / sel(R.symmetry, 2, 1)

      if vol_1 < 7 or vol_2 < 7 then
        reqs.max_delta_h = 32
      end
    end

    local def = Fab_pick(LEVEL, reqs)
    
    if R.has_consistent_stairs then
      if def then
        if def.rank then
          PREFABS[def.name].original_rank = def.rank
        else
          PREFABS[def.name].original_rank = 0
        end
      end
      PREFABS[def.name].rank = 1
    end

    return def
  end


  local function mark_stair_seeds(chunk)
    -- used to prevent staircases in a room touching

    local sx1 = math.clamp(1, chunk.sx1 - 2, SEED_W)
    local sy1 = math.clamp(1, chunk.sy1 - 2, SEED_H)
    local sx2 = math.clamp(1, chunk.sx2 + 2, SEED_W)
    local sy2 = math.clamp(1, chunk.sy2 + 2, SEED_H)

    for sx = sx1, sx2 do
    for sy = sy1, sy2 do
      SEEDS[sx][sy].no_stair_R = R
    end
    end
  end


  local function install_create_chunks(T)
    new_chunks = {}

    local stair_prefab

    local link_info

    -- need to remove the existing link chunk
    if link_chunk then
      link_info =
      {
        dest_dir = assert(link_chunk.dest_dir)
      }

      table.kill_elem(R.all_links, link_chunk)

      -- this kills the chunk too
      link_chunk.area:kill_it(LEVEL, "remove_from_room", SEEDS)
      link_chunk = nil
    end

    for _,r in pairs(cur_rule.rects) do
      local x1,y1, x2,y2 = transform_rect(T, r)

      assert(r.kind)
      local chunk = CHUNK_CLASS.new(SEEDS, LEVEL, r.kind, x1,y1, x2,y2)

      if r.from_dir then chunk.from_dir = transform_dir(T, r.from_dir) end
      if r.dest_dir then chunk.dest_dir = transform_dir(T, r.dest_dir) end

      chunk.shape  = r.shape
      chunk.occupy = r.occupy
      chunk.prefer_usage = r.usage

      if T.is_straddling then
        chunk.is_straddler = true
      end

      if rand.odds(r.keep_shape_prob or 0) then
        chunk.keep_shape = true
      end

      if r.from_area then
        chunk.from_area = assert(area_map[r.from_area])
      end

      table.insert(new_chunks, chunk)


      local A
      local R2 = R

      if new_room and new_room.is_hallway then
        R2 = new_room
      end

      do
        A = AREA_CLASS.new(LEVEL, "chunk")
        R2:add_area(A)

        chunk.area = A
        A.chunk = chunk
      end


      -- symmetry handling : peer up mirrored chunks and their areas
      if T.is_second and old_chunks then
        assert(old_chunks)

        local old_chunk = old_chunks[#new_chunks]
        assert(old_chunk)
        assert(old_chunk.kind == chunk.kind)

        chunk.peer = old_chunk
        old_chunk.peer = chunk

        if A then
          A.peer = old_chunk.area
          old_chunk.area.peer = A
        end
      end


      if r.kind == "stair" then
        chunk.dest_area = assert(new_area)
        assert(new_intconn)
        new_intconn.stair_chunk = chunk

        local from_area = chunk.from_area --assert(chunk.from_area)
        if not from_area then
          error("Missing staircase area source.\n" ..
          "Problem shape rule: " .. cur_rule.name)
        end
        chunk.area.prelim_h = assert(from_area.prelim_h)

        -- choose the stair prefab now
        if not stair_prefab then
          if chunk.peer and chunk.peer.prefab_def then
            stair_prefab = chunk.peer.prefab_def
          end
        end

        if not stair_prefab then
          stair_prefab = pick_stair_prefab(chunk)

          local h = assert(stair_prefab.delta_h)

          if R.trunk.stair_z_dir < 0 then
            h = h * -1
          end

          if rand.odds(R.trunk.stair_z_dir_fudge_prob) then
            h = h * -1
          end

          new_area.prelim_h = from_area.prelim_h + h
        end

        if new_area.prelim_h < from_area.prelim_h then
          chunk.area.prelim_h = chunk.area.prelim_h - stair_prefab.delta_h
          chunk:flip()
        end

        chunk.prefab_def = stair_prefab

        mark_stair_seeds(chunk)

      elseif r.dest_area then
        chunk.dest_area = assert(area_map[r.dest_area])
      end

      if r.kind == "joiner" then
        assert(new_room)
        chunk.dest_area = new_room.areas[1]

        new_conn.kind = "joiner"
        new_conn.chunk = chunk

        -- connection goes from CURRENT ROOM --> NEW ROOM
        new_conn.A1  = assert(chunk.from_area)
        new_conn.A2  = assert(new_room.areas[1])
---stderrf("JOINER : %s / %s (%s) --> %s / %s (%s)\n",
---  R.name, new_conn.TA1.name, new_conn.TA1.room.name,
---  new_room.name, new_conn.TA2.name, new_conn.TA2.room.name)

--???        assert(chunk.dir)
--???        chunk.dir = transform_dir(T, chunk.dir)
      end

      if r.kind == "hallway" then
        chunk.h_join = {}

        if new_conn then
          new_conn.kind  = "terminator"
          new_conn.chunk = chunk
        end

        if new_room then
          chunk.is_terminator = true

          if new_room.is_hallway then
            new_room.first_piece = chunk
          end
        end

        local prev_chunk = area_map[1].chunk

        if prev_chunk then
          local dir1 = link_info.dest_dir
          local dir2 = 10 - dir1
--[[
stderrf("Link pieces: %s dir:%d <--> %s dir:%d\n",
         prev_chunk.area.name, dir1,
              chunk.area.name, dir2)
--]]
          --assert(prev_chunk.h_join[dir1] == nil)
          --assert(     chunk.h_join[dir2] == nil)

          prev_chunk.h_join[dir1] = chunk
               chunk.h_join[dir2] = prev_chunk
        end
      end

      if r.kind == "link" then
        table.insert(R2.all_links, chunk)
      end

      if r.kind == "closet" then table.insert(R.closets, chunk) end
      if r.kind == "stair"  then table.insert(R.stairs,  chunk) end
      if r.kind == "joiner" then table.insert(R.joiners, chunk) end
    end
  end


  local function pre_install(T)
    new_room = nil
    new_conn = nil

    old_chunks = new_chunks
    new_chunks = nil

    if is_create then
      new_room = R

    elseif cur_rule.new_room then
      local info = cur_rule.new_room

      new_room = Grower_add_room(LEVEL, R, info, nil, cur_rule)

      -- create a preliminary connection (last room to this one).
      -- the seed and direction are determined later.
      new_conn = Grower_new_prelim_conn(LEVEL, R, new_room, "edge")
--stderrf("prelim_conn %s --> %s\n", new_conn.R1.name, new_conn.R2.name)

      if not new_room.is_hallway then
        local A = new_room.areas[1]

        A.no_grow   = info.no_grow
        A.no_sprout = info.no_sprout
      end

      -- this only for hallways (ATM)
      new_room.grow_pass = info.grow_pass
    end

    if cur_rule.new_area and not new_area then
      local info = cur_rule.new_area

      new_area = AREA_CLASS.new(LEVEL, "floor")

      -- max size of new area
      --new_area.max_size = rand.pick({ 16, 24, 32, 128, 256, 512 })
      if R.svolume then
        new_area.max_size = (R.size_limit - R.svolume) * 1.25
      end

      new_area.no_grow   = info.no_grow
      new_area.no_sprout = info.no_sprout

      R:add_area(new_area)

      local from_area_idx = info.from_area or 1
      local from_area = assert(area_map[from_area_idx])

      new_area.prelim_h = assert(from_area.prelim_h)

      new_intconn = add_internal_conn(from_area, new_area)
    end

    if cur_rule.rects then
      install_create_chunks(T)
    end
  end


  local function post_install(T)
    Seed_squarify(LEVEL, SEEDS)

    if cur_rule.teleporter then
      R.need_teleports = R.need_teleports + 1
    end

    if new_room then
      assert(new_room.gx1)

      local sym_prob = prob_for_symmetry(new_room)

      if rand.odds(sym_prob) then
        new_room.symmetry = transform_symmetry(T)

----    stderrf("new_room.symmetry :\n%s\n", table.tostr(new_room.symmetry))
      end

      if not is_create then
        -- joiners connections are handled later
        if cur_rule.new_room.conn then
          transform_connection(T, cur_rule.new_room.conn, new_conn)
        end
        mark_connection_used(new_conn)
      end
    end
  end


  local function match_or_install_pat_raw(what, T)
    if what == "INSTALL" then pre_install(T) end

    for px = 1, cur_rule.input.w do
    for py = 1, cur_rule.input.h do
      local E1 = cur_rule.input [px][py]
      local E2 = cur_rule.output[px][py]

      local res = match_or_install_element(what, E1, E2, T, px, py)

      if what == "TEST" and not res then
        -- cannot place this shape here (something in the way)

--[[ DEBUG
if pass == "grow" then
gui.debugf("  failed at (%d %d) : %s -> %s\n", px, py, E1.kind, E2.kind)
end
--]]
        return false
      end
    end -- px, py
    end

--[[ DEBUG
if what == "INSTALL" then
stderrf("=== install_pattern %s @ (%d %d) ===\n", cur_rule.name, T.x, T.y)
stderrf("T =\n%s\n", table.tostr(T))
end
--]]

    if what == "INSTALL" then post_install(T) end

    return true
  end


  local function try_straddling_pattern(what, T)
    -- this handles a pattern which is symmetrical and which is sitting
    -- exactly at the right spot to be usable ONCE in a symmetrical room
    -- (i.e. perfectly straddling the axis of symmetry).

    if is_create then return false end

    if R.symmetry.kind ~= "mirror" then return false end

    if geom.is_vert(R.symmetry.dir) then
      if T.transpose then return false end
    elseif geom.is_horiz(R.symmetry.dir) then
      if not T.transpose then return false end
    else
      -- never for diagonal axis of symmetry
      return false
    end

    if not cur_rule.x_symmetry then return false end

    local W = cur_rule.input.w
    local H = cur_rule.input.h

    -- width must be odd/even to match R.symmetry mode
    if (W % 2) ~= sel(R.symmetry.wide, 0, 1) then return false end

    -- get transformed bbox of pattern
    local bx1, by1 = transform_coord(T, 1, 1)
    local bx2, by2 = transform_coord(T, W, H)

    if bx1 > bx2 then bx1, bx2 = bx2, bx1 end
    if by1 > by2 then by1, by2 = by2, by1 end

    -- check that it straddles at right spot
    if T.transpose then
      if by1 ~= R.symmetry.y - math.floor((W-1) / 2) then return false end
    else
      if bx1 ~= R.symmetry.x - math.floor((W-1) / 2) then return false end
    end

    if match_or_install_pat_raw(what, T) then
      return true
    end

    return false
  end


  local function match_or_install_pattern(what, T)
    if what == "TEST" then
    else
      new_area = nil
      new_intconn = nil
    end

--stderrf("=== match_or_install_pattern %s @ (%d %d) ===\n", cur_rule.name, T.x, T.y)
    T.is_first  = nil
    T.is_second = nil
    T.is_straddling = nil

    if R.symmetry then
      T.is_straddling = true

      if try_straddling_pattern(what, T) then

--[[ DEBUG
if what == "INSTALL" then
stderrf("[ straddler ]\n")
stderrf("T =\n%s\n", table.tostr(T))
end
--]]
        return true
      end

      T.is_straddling = nil
    end

    if R.symmetry then
      local T2 = convert_symmetrical_transform(R.symmetry, T)

      T2.is_first  = true
      T .is_second = true

--stderrf("SYMMETRICAL ROOM : match_or_install_pattern\n")
--stderrf("T = \n%s\n", table.tostr(T))
--stderrf("T2 = \n%s\n", table.tostr(T2))

      if what == "TEST" then
        sym_token = alloc_id(LEVEL, "sym_token")
      end

      -- an exit room should only have a single connection, so
      -- inhibit a mirrored sprout.
      if what == "INSTALL" and pass == "sprout" and R.is_exit and not LEVEL.is_procedural_gotcha then
        -- la la la
      elseif not match_or_install_pat_raw(what, T2) then
        return false
      end
    end

    return match_or_install_pat_raw(what, T)
  end


  local function match_all_focal_points(T)
    area_map[1] = nil
    area_map[2] = nil
    area_map[3] = nil
    link_chunk  = nil

    for area_num, loc in pairs(cur_rule.focal_points) do
      if not match_a_focal_point(area_num, T, loc.gx, loc.gy) then
        return false
      end
    end

    return true
  end


  local function try_apply_a_rule(LEVEL)
    --
    -- Test all eight possible transforms (four rotations + mirroring)
    -- in all possible locations in the room.  If at least one is
    -- successful, pick it and apply the substitution.
    --

    gui.debugf("  Trying rule '" .. cur_rule.name .. "' in ROOM_" .. R.id .. "\n")

    if R.shapes_tried then
      R.shapes_tried = R.shapes_tried + 1
    else
      R.shapes_tried = 1
    end
  
    GROWER_DEBUG_INFO[cur_rule.name].trials = GROWER_DEBUG_INFO[cur_rule.name].trials + 1

    best = { score=-1, areas={} }

    local T
    local x1, y1, x2, y2

    -- exit rooms (and auxiliary pieces) do not rotate or mirror
    if cur_rule.no_rotate then
      T = calc_transform(0, 0, 0)
      x1,y1, x2,y2 = get_iteration_range(T)
  
      for x = x1, x2 do
        for y = y1, y2 do
  
          T.x = x
          T.y = y
  
          if not match_all_focal_points(T) then goto continue end
  
          if match_or_install_pattern("TEST", T) then
            best.T = table.copy(T)
            best.score = 1
  
            -- this is less memory hungry than copying the whole table
            best.areas[1] = area_map[1]
            best.areas[2] = area_map[2]
            best.areas[3] = area_map[3]
  
              best.link_chunk = link_chunk
            goto justpickone
          end
          ::continue::
        end -- x, y
      end
    else
      if LEVEL.shape_transform_mode == "random" then
        LEVEL.shape_transform_possibilities = rand.shuffle(LEVEL.shape_transform_possiblities)
      end
      for _,transform in pairs(LEVEL.shape_transform_possiblities) do
        T = calc_transform(transform[1], transform[2], transform[3])
        x1,y1, x2,y2 = get_iteration_range(T)
  
        for x = x1, x2 do
          for y = y1, y2 do
    
            T.x = x
            T.y = y
    
            if not match_all_focal_points(T) then goto continue end
    
            if match_or_install_pattern("TEST", T) then
              best.T = table.copy(T)
              best.score = 1
    
              -- this is less memory hungry than copying the whole table
              best.areas[1] = area_map[1]
              best.areas[2] = area_map[2]
              best.areas[3] = area_map[3]
    
                best.link_chunk = link_chunk
              goto justpickone
            end
            ::continue::
          end -- x, y
        end
      end
    end

    ::justpickone::

    if best.score < 0 then
      --gui.printf(" NOPE!\n")
      return false
    end

    -- ok --

    area_map[1] = best.areas[1]
    area_map[2] = best.areas[2]
    area_map[3] = best.areas[3]

    link_chunk = best.link_chunk

    match_or_install_pattern("INSTALL", best.T)

    return true
  end


  local function update_aversions(rule)
    if not rule.aversion then
      return
    end

    if R.aversions[rule.name] == 0 then
      return
    end

    if R.aversions[rule.name] == nil then
       R.aversions[rule.name] = 1
    end

    if R.aversions[rule.name] < 0.002 then
       R.aversions[rule.name] = 0
      return
    end

    R.aversions[rule.name] = R.aversions[rule.name] / rule.aversion
  end


  -- MSSP: update smart groupings
  local function update_shape_groupings(rule, LEVEL)


    local function style_factor(rule)
      if not rule.styles then return 1 end

      local factor = 1.0

      for _,name in pairs(rule.styles) do
        if STYLE[name] == nil then
          error("Unknown style in grammar rule: " .. tostring(name))
        end

        factor = factor * style_sel(name, 0, 0.28, 1.0, 3.5)
      end

      return factor
    end


    local function random_factor(rule)
      if not rule.prob_skew then return 1 end

      local prob_skew = rule.prob_skew
      local half_skew = (1.0 + prob_skew) / 2.0

      return rand.pick({ 1 / prob_skew, 1 / half_skew, 1.0, half_skew, prob_skew })
    end


    local function calc_prob_absurdity(rule, x_prob, mode, LEVEL)
      -- MSSP: this is a modification of calc_prob function.
      -- x_prob is used for absurdity and shape groupings,
      -- such that absurdification still runs through all
      -- game filters and styles

      if rule.skip_prob then
        if rand.odds(rule.skip_prob) then return 0 end
      end

      if not ob_match_game(rule)     then return 0 end
      if not ob_match_port(rule)   then return 0 end

      if not LEVEL.liquid and rule.styles and
         table.has_elem(rule.styles, "liquids")
      then
        return 0
      end

      if rule.new_room and rule.new_room.hall_type == "narrow" and
         table.empty(THEME.narrow_halls or {})
      then return 0 end

      if rule.new_room and rule.new_room.hall_type == "wide" and
         table.empty(THEME.wide_halls or {})
      then return 0 end

      local prob = rule.prob or 0

      prob = prob *  style_factor(rule)
      prob = prob * random_factor(rule)

      if mode ~= "reset" then
        if x_prob then
          if mode == "multiply" or not mode then
            prob = prob * x_prob
          elseif mode == "divide" then
            prob = prob / x_prob
          end
        end
      end

      return prob
    end


    local function change_group_probs(mode, LEVEL)
      for name,cur_def in pairs(grammar) do
        if rule.group == cur_def.group
        and rule.group_pos ~= "entry" then
          if mode == "highlight" then
            calc_prob_absurdity(cur_def, 1000000, "multiply", LEVEL)
          elseif mode == "reduce" then
            calc_prob_absurdity(cur_def, 1.2, "divide", LEVEL)
          elseif mode == "reset" then
            calc_prob_absurdity(cur_def, 0, "reset", LEVEL)
          end
        end
      end
    end

    if not rule.group then return end

    if LEVEL.is_procedural_gotcha then return end

    if LEVEL.is_absurd then return end

    -- reset when rooms have changed
    if PARAM.operated_room ~= R.id and PARAM.cur_shape_group then
      PARAM.operated_room = R.id
      change_group_probs("reset", LEVEL)
      PARAM.cur_shape_groop = ""
      PARAM.cur_shape_group_apply_count = 0
    end

    PARAM.operated_room = R.id

    --[[if PARAM.cur_shape_group ~= ""
    and PARAM.print_shape_steps
    and PARAM.print_shape_steps ~= "no" then
      gui.printf("Shape group: " .. PARAM.cur_shape_group .. "\n")
      gui.printf("Shape count: " .. PARAM.cur_shape_group_apply_count .. "\n")
    end]]

    -- start it up
    if (rule.group and PARAM.cur_shape_group == "")
    and PARAM.cur_shape_group_apply_count == 0
    and rand.odds(50) then
      PARAM.cur_shape_group = rule.group

      change_group_probs("highlight", LEVEL)

      PARAM.cur_shape_group_apply_count = rand.irange(6,15)
    end

    -- behavior for subsequent use of the same rules
    if (rule.group == PARAM.cur_shape_group) then
      PARAM.cur_shape_group_apply_count = PARAM.cur_shape_group_apply_count - 1

      -- decrease probability for rules as each rule in the same
      -- 'smart group' is applied
      if PARAM.cur_shape_group_apply_count > 0 then
        change_group_probs("reduce", LEVEL)

      -- reset the probabilities of all rules in the smart group
      -- once the apply count has reached count
      elseif PARAM.cur_shape_group_apply_count <= 0 then
        change_group_probs("reset", LEVEL)

        PARAM.cur_shape_group = ""
      end

    end

    -- end of the rine - sometimes the shape group doesn't manifest
    if PARAM.cur_shape_group_apply_count == 0 then
      PARAM.cur_shape_group = ""
    end

  end


  local function auxiliary_name(index)
    local name = "auxiliary"

    if index >= 2 then
      name = name .. index
    end

    return name
  end


  local function apply_auxiliary_rules()
    for idx = 1,9 do
      local aux_name = auxiliary_name(idx)

      local aux = cur_rule[aux_name]
      cur_rule.is_auxiliary = true
      if aux == nil then goto continue end

      assert(aux.pass)

      -- 'count' can be a number or a range of values: { low,high }
      local num = aux.count or 1

      if type(num) == "table" then
        num = rand.irange(num[1], num[2])
      end

      Grower_grammatical_pass(SEEDS, LEVEL, R, aux.pass, num, aux.stop_prob or 0, cur_rule, false, is_emergency)
      ::continue::
    end
  end


  local function apply_a_rule(LEVEL)
    local rule_tab = collect_matching_rules(pass, stop_prob, hit_floor_limit)

    --if SHAPE_GRAMMAR ~= SHAPES.OBSIDIAN then
      if table.empty(rule_tab) then return end
    --end

    local rules = table.copy(rule_tab)

    -- original qty is around 20, Obsidian base is 5
    local tries = 20 -- Maybe tune this parameter to test build speed? - Dasho

    if tries > #rules then tries = #rules end

    for x = tries,0,-1 do
      if table.empty(rules) then return end

      local name = rand.key_by_probs(rules)

      if name == "STOP" then return end

      cur_rule = assert(grammar[name])

      -- don't try this rule again
      rules[name] = nil

      if try_apply_a_rule(LEVEL) then goto success end

      -- normalize absurd rule probability for each unsuccesful attempt
      if grammar[name].is_absurd then
        grammar[name].use_prob = grammar[name].use_prob / 5

        -- if normalized absurd rules still don't work...
        if tries%2 == 0 then
          if rand.odds(50) then
  
            -- 50% chance of shuffling transform matrix
            LEVEL.shape_transform_possibilities = rand.shuffle(LEVEL.shape_transform_possiblities)

            if R.transform_changes then
              R.transform_changes = R.transform_changes + 1
            else
              R.transform_changes = 1
            end
          else

            -- 50% chance of boosting probs for base set by a whole lot
            if R.base_set_increase then
              R.base_set_increase = R.base_set_increase + 1
            else
              R.base_set_increase = 1
            end
            for _,rule in pairs(LEVEL.base_set_rules) do
              grammar[rule.name].use_prob = grammar[rule.name].use_prob * 30
            end
          end
        end
      end

      if x == 0 then return end
    end

    ::success::

    -- SUCCESS --

    gui.debugf("ROOM_" .. R.id .. " APPLIED rule: " .. cur_rule.name .. "\n")

    if pass == "grow" then
      if R.shapes_applied then
        R.shapes_applied = R.shapes_applied + 1
      else
        R.shapes_applied = 1
      end

      if not R.shapes or table.empty(R.shapes) then
        R.shapes = {}
      else
        R.shapes[cur_rule.name] = R.shapes[cur_rule.name] + 1
      end

      if cur_rule.is_absurd then
        if R.absurd_shapes then
          table.add_unique(R.absurd_shapes, cur_rule.name)
        else
          R.absurd_shapes = {}
        end
      end
    end

    if pass == "sprout" then
      R.sprout_succesful = true
    end

    if cur_rule.is_auxiliary then
      R.has_auxiliary = true
    end

    -- round robin absurdity settings
    if LEVEL.absurdity_round_robin then
      local tab = {}
      for _,rule in pairs(LEVEL.absurd_grammar_rules) do
        tab[rule.name] = rule.prob
      end

      for _,rule in pairs(LEVEL.absurd_grammar_rules) do
        rule.prob = tab[rule.next]
      end
    end
    
    -- debug statistics
    GROWER_DEBUG_INFO[cur_rule.name].applied = GROWER_DEBUG_INFO[cur_rule.name].applied + 1

    if PARAM["live_minimap"] == "step" then
      Seed_draw_minimap(SEEDS, LEVEL)
    end

    update_aversions(cur_rule)

    update_shape_groupings(cur_rule, LEVEL)

    -- apply any auxiliary rules
    if cur_rule.auxiliary then
      apply_auxiliary_rules()
    end

    if is_emergency then
      gui.debugf("Emergency in ROOM_" .. R.id .. " is resolved OMG AMAZING!!!!\n")
      if not R.emergency_sprout_attempts then
        R.emergency_sprout_attempts = 1
      else
        R.emergency_sprout_attempts = R.emergency_sprout_attempts + 1
      end
    end

    if R.emergency_sprout_attempts then
      gui.debugf(R.id .. " Emergency Sprout attempts: " .. R.emergency_sprout_attempts .. "\n")
    end
  end


  ---| Grower_grammatical_pass |---

  gui.debugf("Growing %s with [%s x %d].....\n", R.name, pass, apply_num)

  -- we should have a known bbox (unless creating a room)
  if not is_create then
    assert(R.gx1)
  end

  for loop = 1, apply_num do
    -- hit the size limit?
    if pass == "grow" and R:rough_size() >= R.size_limit then
      break;
    end

    -- hit the room limit?
    if pass == "sprout" and #LEVEL.rooms >= LEVEL.max_rooms then
      break;
    end

    -- exit rooms must have only a single entrance
    if pass == "sprout" and R.is_exit and R:prelim_conn_num(LEVEL) >= 1 then
      break;
    end

    if LEVEL.has_linear_start then
      if pass == "sprout" then
        if not R.is_street and R:prelim_conn_num(LEVEL) >= 1 and R.is_start then
          break;
        end
      end
    end

    -- stderrf("LOOP %d\n", loop)
    apply_a_rule(LEVEL)

    -- if we surpass the floor limit, remove rules which add new areas
    if pass == "grow" and not hit_floor_limit and R:num_floors() >= R.floor_limit then
      hit_floor_limit = true
    end
  end
end



function Grower_grammatical_room(SEEDS, LEVEL, R, pass, is_emergency)
  local apply_num

  if pass == "grow" then
    apply_num = rand.pick( {10,20,30} )

    if R.is_hallway then
      pass = assert(R.grow_pass)
      if R.hall_type == "narrow" then
        apply_num = rand.irange(5, 15)
      else
        apply_num = rand.irange(3, 8)
      end
    end

  elseif pass == "sprout" then
    if R.is_exit then
      apply_num = 1
    else
      apply_num = rand.pick({ 1,2,2,3 })
    end

    if R.is_hallway then
      pass = R.grow_pass .. "_sprout"
    end

    if R.is_street then
      apply_num = rand.irange(6,20)
    end

  elseif pass == "decorate" then
    -- TODO: review this (and stop_prob), see what works best
    local tmp_num = sel(R.is_big, 10, 6)
    if R.is_outdoor or R.is_cave then apply_num = tmp_num / 2 end
    if R.is_natural_park then apply_num = tmp_num * 2 end

    apply_num = tmp_num

  elseif pass == "filler" then
    apply_num = 30

  elseif pass == "smoother" then
    apply_num = 15

  elseif pass == "streets" then
    apply_num = rand.irange(5,10)

  elseif pass == "streets_entry_4"
  or pass == "streets_entry_6"
  or pass == "streets_entry_8" then
    apply_num = 1

  elseif pass == "sidewalk" then
    R.areas[1]:calc_volume()
    local sidewalk_apply_num = math.ceil(R.areas[1].svolume/4.5)
    gui.printf("Road volume: " .. R.areas[1].svolume .. "\n")
    apply_num = sidewalk_apply_num

  elseif pass == "street_fixer" then
    apply_num = 15

  elseif pass == "building_entrance" then
    apply_num = rand.irange(5,10)

  elseif pass == "square_out" then

    for _,A in pairs(R.areas) do
      A:calc_volume()
      R.svolume = R.svolume + A.svolume
    end

    apply_num = math.floor(R.svolume/rand.irange(4,8))

    if LEVEL.is_procedural_gotcha then
      apply_num = math.ceil(apply_num * 0.25)
    end

  else
    error("unknown grammar pass: " .. tostring(pass))
  end


  local stop_prob = 0

  if pass == "grow"     then stop_prob =  5 end
  if pass == "decorate" then stop_prob = 10 end

  --
  if LEVEL.is_procedural_gotcha then
    if pass == "grow" or pass == "sprout" then
      apply_num = 50
    elseif pass == "decorate" then
      apply_num = 15
    end
  end

  Grower_grammatical_pass(SEEDS, LEVEL, R, pass, apply_num, stop_prob, nil, nil, is_emergency)

end



function Grower_clean_up_links(SEEDS, LEVEL, R, do_all)
  if not do_all then
    rand.shuffle(R.all_links)
  end

  for i = #R.all_links, 1, sel(do_all, -1, -2) do
    local chunk = table.remove(R.all_links, i)

    if not chunk.is_dead then
      chunk.area:kill_it(LEVEL, "remove_from_room", SEEDS)
    end
  end

--[[ VALIDATION CRUD
  if do_all then
    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local K = SEEDS[sx][sy].chunk
      if K and K.area.room == R then
        assert(K.kind ~= "link")
      end
    end
    end
  end
--]]
end



function Grower_prune_hallway(SEEDS, LEVEL, R)
  --
  -- Prune the dead ends of the grown hallway.
  -- The whole room is killed when there is nowhere left to go.
  --

  local function kill_a_piece(piece)
    assert(not piece.is_dead)

    for dir, P2 in pairs(piece.h_join) do
      if not P2.is_dead then
        assert(P2.h_join[10 - dir] == piece)
               P2.h_join[10 - dir] = nil
      end
    end

    piece.area:kill_it(LEVEL, "remove_from_room", SEEDS)
  end


  local function dead_end_flow(piece, seen, last_piece)
    seen[piece.id] = 1

    -- recurse to neighbors FIRST, which means we can prune this
    -- piece if ones further along were pruned

    local neighbors = table.copy(piece.h_join)

    for dir,P in pairs(neighbors) do
      if not seen[P.id] then
        dead_end_flow(P, seen, piece)
      end
    end

    -- terminating pieces are OK, unless attached room was killed
    if piece.is_terminator then
      if not piece.cut_off then return end
    end

    -- count number of REAL destinations
    local count = 0

    for dir, P2 in pairs(piece.h_join) do
      if not P2.delay_pruned then
        count = count + 1
      end
    end

    if count >= 2 then
      return -- OK
    end

    -- kill any neighbors that delayed being pruned
    -- (since the current piece will be removed or become a dead-end)
    neighbors = table.copy(piece.h_join)

    for dir, P2 in pairs(neighbors) do
      if P2.delay_pruned then
        kill_a_piece(P2)
      end
    end

    -- does last piece wants to keep its original shape?
    if last_piece and last_piece.keep_shape and not piece.is_terminator then
      piece.delay_pruned = true
      return
    end

    -- kill the piece
    kill_a_piece(piece)
  end


  ---| Grower_prune_hallway |---

  Grower_clean_up_links(SEEDS, LEVEL, R, "do_all")

  if R:prelim_conn_num(LEVEL) < 2 then
    Grower_kill_room(SEEDS, LEVEL, R)
    return
  end

  dead_end_flow(R.first_piece, {}, nil)
end



function Grower_grow_room(SEEDS, LEVEL, R)
  gui.ticker()

  if R.is_street then
    R.is_grown = true
    return
  end

  local function is_too_small(R)
    -- never prune a root room (including the exit)

    if R.is_root then return false end

    if LEVEL.is_procedural_gotcha then
      return R:calc_walk_vol() < 128
    end

    return R:calc_walk_vol() < 8
  end

  ---| Grower_grow_room |---


  Grower_grammatical_room(SEEDS, LEVEL, R, "grow")

  -- if room too small, try another grow pass, then kill it

  if not R.is_hallway and is_too_small(R) then
    Grower_grammatical_room(SEEDS, LEVEL, R, "grow")

    if is_too_small(R) then

      if R.grow_parent and R.grow_parent.is_start 
      and R.small_room then
        return 
      end

      if R.prelim_conn_num == 1 then
        Grower_kill_room(SEEDS, LEVEL, R)
        return
      end

    end
  end

  if LEVEL.is_procedural_gotcha then
    if R.grow_parent and R.grow_parent.is_start then
      if R.grow_parent:prelim_conn_num(LEVEL) > 1 then
        if R.prelim_conn_num == 1 then
          gui.debugf("Procedural Gotcha: ROOM " .. R.id .. " culled.\n")
          Grower_kill_room(SEEDS, LEVEL, R)
        end
      end
    end
  end

  if (LEVEL.has_linear_start and #LEVEL.rooms == 4) or
  (LEVEL.is_procedural_gotcha and #LEVEL.rooms > 2) then
    for _,R2 in pairs(LEVEL.rooms) do
      if #R2.conns == 1 and R2.grow_parent.is_start then
        if R.prelim_conn_num == 1 then
          Grower_kill_room(SEEDS, LEVEL, R2)
        end
      end
    end
  end

  if PARAM["live_minimap"] == "room" then
    Seed_draw_minimap(SEEDS, LEVEL)
  end

  R.is_grown = true
end



function Grower_sprout_room(SEEDS, LEVEL, R)
  if R.is_dead then return end

  if rand.odds(LEVEL.squareishness) and not R.is_cave and not R.is_park
  and not R.is_hallway and not R.is_street then

    -- square_out pass - makes rooms a bit more buff and square
    -- to distort the layout a bit more
    Grower_grammatical_room(SEEDS, LEVEL, R, "square_out")
    R.is_squarified = true
  end

  Grower_grammatical_room(SEEDS, LEVEL, R, "sprout")

  -- if hallway did not sprout, try again
  if R.is_hallway and R:prelim_conn_num(LEVEL) < 2 then
    Grower_clean_up_links(SEEDS, LEVEL, R)
    Grower_grammatical_room(SEEDS, LEVEL, R, "sprout")
  end

  if R.is_street and R:prelim_conn_num(LEVEL) < math.clamp(1, math.floor(R.svolume/64), 10) then
    Grower_grammatical_room(SEEDS, LEVEL, R, "sprout")
  end

  R.is_sprouted = true

  if R.is_hallway then
    Grower_prune_hallway(SEEDS, LEVEL, R)
  end
end



function Grower_make_street(R, SEEDS, LEVEL)
  if R.is_streeted then return end

  R.areas[1]:calc_volume()
  R.svolume = R.areas[1].svolume
  if R.svolume == 4 then
    Grower_grammatical_room(SEEDS, LEVEL, R, "streets_entry_4")
  elseif R.svolume == 6 then
    Grower_grammatical_room(SEEDS, LEVEL, R, "streets_entry_6")
  elseif R.svolume == 8 then
    Grower_grammatical_room(SEEDS, LEVEL, R, "streets_entry_8")
  end

  Grower_grammatical_room(SEEDS, LEVEL, R, "streets")

  -- sanity check: failed street rooms shall now become just
  -- regular rooms
  R.areas[1]:calc_volume()
  if R.areas[1].svolume < 96 then
    R.is_street = false
    return
  end

  Grower_grammatical_room(SEEDS, LEVEL, R, "street_fixer")

  for _,A in pairs(R.areas) do
    if not A.is_sidewalk then
      A.is_road = true
    end
  end

  R.floor_limit = math.clamp(5,R.areas[1].svolume/16,100)

  Grower_grammatical_room(SEEDS, LEVEL, R, "sidewalk")

  --[[if not R.is_start then
    Grower_grammatical_room(R, "building_entrance")
  end]]

  for _,A in pairs(R.areas) do
    if not A.is_road then
      A.is_sidewalk = true
    end
  end

  R.is_streeted = true
end



function Grower_create_and_grow_room(SEEDS, LEVEL, trunk, mode, info)
  -- create the ROOM object
  local R = Grower_add_room(LEVEL, nil, info, trunk)
  assert(R)

  R.is_root = true

  -- apply a root rule for it
  local pass = "root"

  if mode == "exit" then
    pass = "exit"
  end

  Grower_grammatical_pass(SEEDS, LEVEL, R, pass, 1, 0, nil, "is_create", nil)


  -- if a root failed to establish itself, kill the room
  if R.gx1 == nil then
    if mode == "exit" then
      error("Exit room could not be placed!")
    end

    gui.debugf("%s could not establish a root, killing it\n", R.name)

    R:kill_it(LEVEL)

    Grower_kill_a_trunk(LEVEL, trunk)

    return R
  end

  -- if it's a street, street it
  if R.is_street then
    Grower_make_street(R, SEEDS, LEVEL)
  end

  -- grow it now
  Grower_grow_room(SEEDS, LEVEL, R)
  Grower_sprout_room(SEEDS, LEVEL, R)

  return R
end



function Grower_add_a_trunk(LEVEL)
  local trunk =
  {
    id = alloc_id(LEVEL, "trunk"),
    rooms = {},
  }

  trunk.name = string.format("TRUNK_%d", trunk.id)

  trunk.stair_z_dir = rand.sel(50, 1, -1)
  trunk.stair_z_dir_fudge_prob = rand.pick({0,13,25,33,50})
  trunk.consistent_stairs = 100 - trunk.stair_z_dir_fudge_prob

  table.insert(LEVEL.trunks, trunk)

  gui.debugf("Added trunk: %s\n", trunk.name)

  return trunk
end


function Grower_kill_a_trunk(LEVEL, TR)
  TR.name = "DEAD_" .. TR.name
  TR.is_dead = true

  table.kill_elem(LEVEL.trunks, TR)

  -- sanity check
  for _,R in pairs(LEVEL.rooms) do
    assert(R.trunk ~= TR)
  end
end



function Grower_begin_trunks(LEVEL, SEEDS)
  --
  -- Trunks are parts of the map grown separately, and will be
  -- connected via teleporters (only).
  --
  -- Here we decide how many to make, create each one and its
  -- first room [ which is grown later ].
  --
  -- The very first room of the first trunk will be the EXIT room
  -- for the map, and it is grown immediately (ensuring the next
  -- room to grow is the one sprouted off it).
  --

  local max_trunks = 1

  local  some_prob = style_sel("teleporters", 0, 20, 50, 100)
  local extra_prob = style_sel("teleporters", 0, 10, 35, 70)
  local  many_prob = style_sel("teleporters", 0,  0,  5, 50)

  if PARAM.teleporters and rand.odds(some_prob) then
    max_trunks = 2

    if rand.odds(extra_prob) then max_trunks = max_trunks + 1 end
    if rand.odds(extra_prob) then max_trunks = max_trunks + 1 end

    if rand.odds(many_prob) then
      max_trunks = 9
    end
  end

  LEVEL.trunks = {}

  LEVEL.max_trunks = max_trunks


  -- create first trunk and the exit room

  local trunk = Grower_add_a_trunk(LEVEL)
  local info  = {}

  -- TODO : if we have big boss (esp. Mastermind) then
  --        grow the map backwards (do "exit" pass now)

  info.force_start = true
  info.force_exit  = false

  local R = Grower_create_and_grow_room(SEEDS, LEVEL, trunk, nil, info)

  -- Last ditch to save the level
  if R.is_dead then
    LEVEL.max_trunks = 9
    Grower_kill_a_trunk(LEVEL, trunk)
    local new_trunk = Grower_add_a_trunk(LEVEL)
    R = Grower_create_and_grow_room(SEEDS, LEVEL, new_trunk, nil, info)
  end

  assert(not R.is_dead)  

  -- ensure the first floor of an exit room is kept usable for bosses
  if R.is_exit then
    for _,A in pairs(R.areas) do
      if A.mode == "floor" then
        A.is_bossy = true
        break;
      end
    end
  end
end



function Grower_add_teleporter_trunk(SEEDS, LEVEL, parent_R, is_emergency)

  local trunk = Grower_add_a_trunk(LEVEL)
  local info  = {}

--[[ FIXME
  if rand.odds(LEVEL.cave_trunk_prob) then
    info.env = "cave",
  end
--]]
  if is_emergency then
    info.force_no_street = true
  end

  local R = Grower_create_and_grow_room(SEEDS, LEVEL, trunk, "normal", info)

  if R.is_dead then
    -- trunk should be dead too
    return
  end

  Grower_new_prelim_conn(LEVEL, parent_R, R, "teleporter")
end



function Grower_grow_all_rooms(SEEDS, LEVEL)

  local coverage
  local cov_rooms


  local function reached_coverage()
gui.debugf("=== Coverage seeds: %d/%d  rooms: %d/%d\n",
        coverage,  LEVEL.min_coverage,
        cov_rooms, LEVEL.min_rooms)

    return (coverage  >= LEVEL.min_coverage) and
           (cov_rooms >= LEVEL.min_rooms)
  end


  local function grow_teleport_trunk()
    for _,R in pairs(LEVEL.rooms) do
      if R.need_teleports > 0 then
        R.need_teleports = R.need_teleports - 1
        Grower_add_teleporter_trunk(SEEDS, LEVEL, R)
        return true
      end
    end

    return false
  end


  local function emergency_sprouts()
    local room_list = table.copy(LEVEL.rooms)

    rand.shuffle(room_list)

    for _,R in pairs(room_list) do
      -- hallways cannot be regrown or resprouted
      if R.is_hallway then goto continue end

      R.emergency_sprouted = true
      Grower_grammatical_room(SEEDS, LEVEL, R, "sprout", "is_emergency")
      ::continue::
    end
  end


  local function check_initial_room()
    local R = LEVEL.start_room or LEVEL.exit_room

    if not R then return true end

    if R:prelim_conn_num(LEVEL) == 0 then
      Grower_sprout_room(SEEDS, LEVEL, R)

      for _,PC in pairs(LEVEL.prelim_conns) do
        if PC.R1 == R or PC.R2 == R then
          local other = sel(PC.R1 == R, PC.R2, PC.R1)

          if other.is_street then
            Grower_make_street(R, SEEDS, LEVEL)
          end

          Grower_grow_room(SEEDS, LEVEL, other)
          Grower_sprout_room(SEEDS, LEVEL, other)
          break;
        end
      end

      return false
    end

    return true
  end


  local function handle_next_room()
    coverage, cov_rooms = Grower_determine_coverage(SEEDS, LEVEL)
    LEVEL.cur_coverage = coverage

    if reached_coverage() then return "reached" end

    if grow_teleport_trunk() then
      return "ok"
    end

    for _,R in pairs(LEVEL.rooms) do

      -- if it's a street, street it
      if R.is_street then
        Grower_make_street(R, SEEDS, LEVEL)
      end

      if not R.is_grown then
        Grower_grow_room(SEEDS, LEVEL, R)
        Grower_sprout_room(SEEDS, LEVEL, R)
        return "ok"
      end

      if not R.shapes_applied or 
      (R.shapes_applied and R.shapes_applied == 0) and not R.is_start
      and R.shapes_tried <= 500 then
        Grower_grow_room(SEEDS, LEVEL, R)
        Grower_sprout_room(SEEDS, LEVEL, R)
      end
    end

    return "none"
  end


  local function kill_surplus_rooms()
    -- remove any sprouted rooms which did not grow

    local list = table.copy(LEVEL.rooms)

    for _,R in pairs(list) do
      if not R.is_grown and not R.is_start then
        if R.is_hallway then
          Grower_kill_room(SEEDS, LEVEL, R)
        elseif R.prelim_conn_num == 1
        and rand.odds(style_sel("sub_rooms", 100, 66, 33, 0)) then
          Grower_kill_room(SEEDS, LEVEL, R)
        else
          R.is_sub_room = true
        end
      end

      --[[if R.prelim_conn_num(R, LEVEL) == 1 and R.areas[1].svolume <= 8
      and #R.areas == 1 and not R.is_start then
        gui.printf("Prelim conn num: " .. R.prelim_conn_num(R, LEVEL) .. "\n")
        gui.printf(table.tostr(R, 2))
        local hallway_parent
        if R.parent_R and R.parent_R.is_hallway then
          hallway_parent = R.parent_R
        end
        Grower_kill_room(SEEDS, LEVEL, R)
        if hallway_parent then Grower_kill_room(SEEDS, LEVEL, hallway_parent) end
      end]]

    end
  end


  local function expand_limits()
    LEVEL.sprout_x1 = math.max(LEVEL.sprout_x1 - 2, LEVEL.walkable_x1)
    LEVEL.sprout_y1 = math.max(LEVEL.sprout_y1 - 2, LEVEL.walkable_y1)
    LEVEL.sprout_x2 = math.min(LEVEL.sprout_x2 + 2, LEVEL.walkable_x2)
    LEVEL.sprout_y2 = math.min(LEVEL.sprout_y2 + 2, LEVEL.walkable_y2)

    if cov_rooms >= LEVEL.max_rooms and not LEVEL.is_procedural_gotcha then
      LEVEL.max_rooms = cov_rooms + 1
    end

  end


  local function emergency_teleport_break(LEVEL, R)
    local final_R = LEVEL.rooms[#LEVEL.rooms]

    if R then final_R = R end
  
    Seed_draw_minimap(SEEDS, LEVEL)

    if final_R.is_hallway or final_R.is_grown then
      local found_room
      local cur_id = #LEVEL.rooms

      while(cur_id >= 1 and not found_room) do
        if LEVEL.rooms[id] then
          local cur_R = LEVEL.rooms[id]

          if not cur_R.is_hallway or not cur_R.is_grown then
            final_r = cur_R
            found_room = true
          end
        end

        cur_id = cur_id - 1
      end
    end

    if final_R.is_hallway or final_R.is_grown then return end

    if PARAM.bool_allow_teleporter_emergency_breaks == 1 then
      final_R.has_teleporter_break = true
      print(final_R.name .. " in critical condition! " ..
      "GET THE TELEPORNEPHERINE!\n")
      Grower_add_teleporter_trunk(SEEDS, LEVEL, final_R, true)
    else
      print(final_R.name .. " needs Telepornepherine, but " ..
      "teleporter emergency breaks are disabled!\n")
    end
  end


  -- a version of emergency_sprouts() except for the last
  -- room in the stack only of a linear level only
  local function emergency_linear_sprouts()
    local R = LEVEL.rooms[#LEVEL.rooms]
    if not reached_coverage() then

      if R.is_hallway then return end

      gui.printf("Oh noes! Attempting emergency sprout in ROOM_" .. R.id .. "!!!\n")
      Grower_grammatical_room(SEEDS, LEVEL, R, "sprout", "is_emergency")
      Grower_grow_room(SEEDS, LEVEL, R)
    end

    if not R.emergency_sprout_attempts 
    or (R.emergency_sprout_attempts and R.emergency_sprout_attempts > 1) then
      return "oof"
    end
    return "yas queen"
  end


  ---| Grower_grow_all_rooms |---

  -- if map is too small, try to sprout some more rooms
  local MAX_LOOP = 10
  local MAX_RETRIES = 5

  check_initial_room()

  for loop = 1, MAX_LOOP do

    local kw

    if loop == 9 then
      loop = 1
      MAX_RETRIES = MAX_RETRIES - 1
      rand.shuffle(LEVEL.shape_transform_possiblities)
      if MAX_RETRIES == 0 then
        Seed_draw_minimap(SEEDS, LEVEL)
        error("Unable to sprout more rooms.")
      end
    end

    gui.debugf("shape transform matrix: \n" .. 
      table.tostr(LEVEL.shape_transform_possiblities, 2))

    repeat
      kw = handle_next_room()
    until kw ~= "ok"

    if kw == "reached" then
      kill_surplus_rooms()

      -- go around again if the initial room resprouted
      if check_initial_room() ~= "resprout" then
        break;
      end
    end

    if loop == MAX_LOOP then
      break;
    end

    expand_limits()
    emergency_sprouts()

    if not LEVEL.is_procedural_gotcha then

      -- levels that don't reach at least 
      -- half the amount of expected maximum rooms
      if (#LEVEL.rooms < ((LEVEL.min_rooms + LEVEL.max_rooms) / 2)) then
        if emergency_linear_sprouts() == "oof" then
          emergency_teleport_break(LEVEL)
        end
      end

      -- levels that don't reach the prefered coverage
      if (LEVEL.cur_coverage <= LEVEL.min_coverage ) then
        if emergency_linear_sprouts() == "oof" then
          emergency_teleport_break(LEVEL)
        end
      end

    end

    --[[if LEVEL.cur_coverage <= LEVEL.min_coverage / 4
    and PARAM.bool_allow_teleporter_emergency_breaks == 1 then
      for _,R in pairs(LEVEL.rooms) do
        if not R.shapes_applied or 
        (R.shaped_applied and R.shapes_applied == 0) then
          Grower_add_teleporter_trunk(SEEDS, LEVEL, R, true)
        end
      end
    end]]
  end

  -- force grow child rooms from start rooms
  if #LEVEL.rooms == 2 then
    gui.printf("BALLS! " .. MAX_LOOP .. "\n")
    for _,R in pairs(LEVEL.rooms) do
      if R.grow_parent and R.grow_parent.is_start then
        gui.printf("SHIT HAPPENED! " .. LEVEL.name .. "\n")
        Grower_kill_room(SEEDS, LEVEL, R)
        Grower_sprout_room(SEEDS, LEVEL, R.grow_parent)
      end
    end

    for _,R in pairs(LEVEL.rooms) do
      if R.grow_parent and R.grow_parent.is_start then
        Grower_grow_room(SEEDS, LEVEL, R)
        Grower_sprout_room(SEEDS, LEVEL, R)
        MAX_LOOP = 10
        MAX_RETRIES = 5
      end
    end
  end

  if LEVEL.rooms == 1 then
    for _,R in pairs(LEVEL.rooms) do
      if R.is_start then
        Grower_sprout_room(SEEDS, LEVEL, R)
        Grower_grow_room(SEEDS, LEVEL, R)
        Grower_sprout_room(SEEDS, LEVEL, R)
        Grower_sprout_room(SEEDS, LEVEL, R)
        Grower_sprout_room(SEEDS, LEVEL, R)
      end
    end
  end

  -- remove ungrown teleporter trunks
  for _,R in pairs(LEVEL.rooms) do
    if R.is_root and R.is_grown and #R.trunk.rooms == 1 
    and R:calc_walk_vol() <= 24 and not R.is_start and not R.emergency_sprouted then
      gui.printf("Killed teleporter ROOM_" .. R.id .. "\n")
      gui.printf(table.tostr(R.trunk.rooms,1) .. "\n")
      gui.printf(table.tostr(R,2) .. "\n")
      Grower_kill_room(SEEDS, LEVEL, R)
      --Grower_kill_a_trunk(LEVEL, R.trunk)
    end
  end

end



function Grower_decorate_rooms(SEEDS, LEVEL)
  local room_list = table.copy(LEVEL.rooms)

  -- TODO : do buildings before outdoor/cave
  --        __OR__  do certain "phases" in different orders
  --                e.g. adding cages/traps BEFORE expanding outdoors/caves

  rand.shuffle(room_list)

  for _,R in pairs(room_list) do
    if not R.is_hallway and not R.is_street then
      Grower_grammatical_room(SEEDS, LEVEL, R, "decorate")
      if PARAM["live_minimap"] == "room" then
        Seed_draw_minimap(SEEDS, LEVEL)
      end
    end
  end
end



function Grower_expand_parks(SEEDS, LEVEL)
  local room_list = table.copy(LEVEL.rooms)

  rand.shuffle(room_list)

  for _,R in pairs(room_list) do
    if R.is_outdoor and not R.is_street then
      -- disable the seed limit
      for _,A in pairs(R.areas) do
        if A.max_size then A.max_size = 999 end
      end

      Grower_grammatical_room(SEEDS, LEVEL, R, "filler")
    end
  end

  for _,R in pairs(room_list) do
    if R.is_outdoor and not R.is_street then
      Grower_grammatical_room(SEEDS, LEVEL, R, "smoother")
    end
    if PARAM["live_minimap"] == "room" then
    Seed_draw_minimap(SEEDS, LEVEL)
    end
  end

  -- fix area modes
  for _,R in pairs(room_list) do
    if R.is_park or R.is_cave then
      for _,A in pairs(R.areas) do
        if A.mode == "floor" then
          A.mode = "nature"
        end
      end -- A
    end
  end -- R
end



function Grower_flatten_outdoor_fences()

  local sx1, sy1
  local sx2, sy2

  local function get_bounds(R)
    sx1, sy1 =  9e9,  9e9
    sx2, sy2 = -9e9, -9e9

    for _,A in pairs(R.areas) do
      for _,S in pairs(A.seeds) do
        sx1 = math.min(sx1, S.sx)
        sy1 = math.min(sy1, S.sy)
        sx2 = math.max(sx2, S.sx)
        sy2 = math.max(sy2, S.sy)
      end
    end
  end


  local function set_liquid(R, S)
    if not R.dummy_liquid then
       R.dummy_liquid = AREA_CLASS.new(LEVEL, "liquid")
       R:add_area(R.dummy_liquid)
    end

    S.area = R.dummy_liquid

    table.insert(S.area.seeds, S)
  end


  local function scan_direction(R, x, y, dir)
    -- check we can see the edge of the map
    local x2, y2 = x, y

    while true do
      x2, y2 = geom.nudge(x2, y2, dir)

      if not Seed_valid(x2, y2) then break; end

      local S = SEEDS[x2][y2]

      if S.area then return end
      if S.top and S.top.area then return end
    end


    -- mark the seed just over the border
    x2, y2 = geom.nudge(x, y, dir)

    if Seed_valid(x2, y2) then
      local S = SEEDS[x2][y2]
      assert(not S.area)

      S.park_border = true
    end


    dir = 10 - dir

    local change_list = {}

    while x >= sx1 and x <= sx2 and y >= sy1 and y <= sy2 do
      local S1 = SEEDS[x][y]
      local S2 = S1.top

      if S2 then
        -- swap S1 and S2 so that S1 is "earlier" (closer to edge of room)
        assert(S1.diagonal <= 3)

        if (dir == 2) or
           (dir == 4 and S1.diagonal == 1) or
           (dir == 6 and S1.diagonal == 3)
        then
          S1, S2 = S2, S1
        end
      end

      for pass = 1, 2 do
        local S = sel(pass == 1, S1, S2)
        if not S then goto continue end

        if not S.area then
          table.insert(change_list, S)
          goto continue
        end

        if S.area.mode == "liquid" then
          goto continue
        end

        -- once we hit a non-liquid area, stop

        if S.area.room == R then
          for _,N in pairs(change_list) do
            set_liquid(R, N)
          end
        end
        
        if S then
          return
        end
        ::continue::
      end

      x, y = geom.nudge(x, y, dir)
    end
  end


  local function fixup_diagonal(R, S)
    if not S then return end
    if not S.diagonal then return end

    if S.area then return end

    -- require at least two liquid neighbors in same room
    local nb_count = 0
    local nb_area

    for _,dir in pairs(geom.ALL_DIRS) do
      local N = S:neighbor(dir)

      if N and N.area and
         N.area.room == R and
         N.area.mode == "liquid"
      then
        nb_count = nb_count + 1

        if not nb_area then nb_area = N.area end
      end
    end

    if nb_count >= 2 then
      set_liquid(R, S)
    end
  end


  local function visit_park(R)
    get_bounds(R)

    for x = sx1, sx2 do
      scan_direction(R, x, sy1, 2)
      scan_direction(R, x, sy2, 8)
    end

    for y = sy1, sy2 do
      scan_direction(R, sx1, y, 4)
      scan_direction(R, sx2, y, 6)
    end

    -- handle awkward diagonals
    for pass = 1, 2 do
      for x = sx1, sx2 do
      for y = sy1, sy2 do
        local S = SEEDS[x][y]

        fixup_diagonal(R, S)
        fixup_diagonal(R, S.top)
      end
      end
    end
  end


  ---| Grower_flatten_outdoor_fences |---

  for _,R in pairs(LEVEL.rooms) do
    if R.is_outdoor and not R.is_cave then
      visit_park(R)
    end
  end
end



function Grower_hallway_kinds__UNUSED()
  --
  -- Determines kind (building, outdoor, etc) of hallways.
  -- Actually called by quest code after room visit order has been
  -- established.
  --
  -- Result is based on two connecting rooms.  For example:
  --    cave + cave --> cave (usually)
  --    building + building -> building
  --

  local function get_room_pair(H)
    local R1, R2

    -- always use room at the entrance
    assert(H.entry_conn)
    R1 = H.entry_conn:other_room(H)

    -- if more than one exit, randomly pick it
    local conns2 = table.copy(H.conns)
    rand.shuffle(conns2)

    if conns2[1] == H.entry_conn then
      table.remove(conns2, 1)
    end

    assert(conns2[1])

    R2 = conns2[1]:other_room(H)

    return R1, R2
  end


  local function visit_hall(H)
    local R1, R2 = get_room_pair(H)

    local is_outdoor = false
    local is_cave    = false

    if (R1.is_cave and R2.is_cave  and rand.odds(90)) or
       ((R1.is_cave or R2.is_cave) and rand.odds(60))
    then
      is_cave = true
    end

    if (R1.is_outdoor and R2.is_outdoor and rand.odds(50)) or
       ((R1.is_outdoor or R2.is_outdoor) and rand.odds(25)) or
       ((H.svolume or 0) >= 3 and rand.odds(5))
    then
      is_outdoor = true
    end

-- stderrf("Hallway kind @ %s --> %s %s\n", H.name, sel(is_outdoor, "OUT", "-"), sel(is_cave, "CAVE", "-"))

    Room_set_kind(H, true, is_outdoor, is_cave)
  end


  ---| Grower_hallway_kinds |---

--???  TODO : review this, see if needed
do return end

  for _,H in pairs(LEVEL.rooms) do
    if H.is_hallway then
      visit_hall(H)
    end
  end
end



function Grower_setup_caves(LEVEL)
  -- the chance that any ROOT pattern will be a cave
  LEVEL.cave_trunk_prob = style_sel("caves", 0, 10, 35, 90)

  -- the factors to apply to rules which SPROUT a cave room:
  --    "new_factor" is used when source room is not a cave, and
  --    "extend_factor" is used when it is a cave.

  LEVEL.cave_new_factor    = style_sel("caves", 0, 0.1, 1.0, 9.0)
  LEVEL.cave_extend_factor = style_sel("caves", 0, 0.0, 0.1, 1.0)
end



function Grower_cave_stats(LEVEL)
  local rooms = 0

  -- seed counts
  local cave  = 0
  local total = 0

  for _,R in pairs(LEVEL.rooms) do
    local size = R:rough_size()

    if R.is_cave then
      rooms = rooms + 1
      cave  = cave  + size
    end

---- DEBUG FOR SIZES ----
-- stderrf("  %s : %d rough seeds (limit %d), %d floors\n", R.name, size, R.size_limit, R:num_floors())

    total = total + size
  end

  if total < 1 then total = 1 end

--[[
  stderrf("Cave stats : %d/%d rooms : %d/%d seeds (%d%%)\n",
          rooms, #LEVEL.rooms, cave, total, math.floor(cave*100/total))
--]]
end



function Grower_create_rooms(LEVEL, SEEDS)
  -- we don't make real connections until later (Connect_stuff)
  LEVEL.prelim_conns = {}

  Grower_setup_caves(LEVEL)
  Grower_calc_rule_probs(LEVEL)

  Grower_decide_extents(LEVEL)

  Grower_begin_trunks(LEVEL, SEEDS)
  Grower_grow_all_rooms(SEEDS, LEVEL)
  Grower_cave_stats(LEVEL)

  Grower_decorate_rooms(SEEDS, LEVEL)
  Grower_expand_parks(SEEDS, LEVEL)

  Grower_split_liquids(SEEDS, LEVEL)

  Seed_squarify(LEVEL, SEEDS)

  -- debugging aid
  if OB_CONFIG.svg or (PARAM.bool_save_svg and PARAM.bool_save_svg == 1) then
    Seed_save_svg_image(OB_CONFIG.title .. "_" .. LEVEL.name .. ".svg", SEEDS)
  end

  if PARAM.bool_shape_rule_stats == 1 then
    table.sort(GROWER_DEBUG_INFO, function(A,B)
    return (A.trials > B.trials) end)

    gui.printf("\n--==| Shape Rule Statistics |==--\n" ..
    "NAME: APPLY COUNT / TRIAL COUNT : USE PROBABILITY\n")
    for _,rule in pairs(GROWER_DEBUG_INFO) do

      local cur_prob = 0
      if SHAPE_GRAMMAR[rule.name] then 
        cur_prob = SHAPE_GRAMMAR[rule.name].use_prob

        gui.printf(rule.name .. ": ")
        if rule.trials > 0 then
          gui.printf(rule.applied .. " / " .. rule.trials)
          gui.printf(" : " .. cur_prob)
        elseif rule.trials == 0 then
          gui.printf(cur_prob .. " ***UNUSED***")
        end

        if SHAPE_GRAMMAR[rule.name].is_absurd then
          gui.printf(" (ABSURD)")
        end

        if rule.trials > 0 then
          local perc = math.floor((rule.applied / rule.trials) * 10000) / 100
          gui.printf(" (" .. perc .. "%% success)")
        end     
      end


      gui.printf("\n")
    end
  end

  Seed_draw_minimap(SEEDS, LEVEL)

-- FIXME : VALIDATION CRUD
    --for sx = 1, SEED_W do
    --for sy = 1, SEED_H do
      --local K = SEEDS[sx][sy].chunk
      --if K then assert(K.kind ~= "link") end
    --end
    --end
end
