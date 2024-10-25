----------------------------------------------------------------
-- LEVEL WRITER (Doom, Heretic and Hexen)
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


--[[

private class Vertex
  x, y
  dx, dy
  lines : array
  index : number in WAD (starts at 0)
end

private class Sector
  f_h, c_h      : floor/ceil heights
  f_tex, c_tex  : floor/ceil textures

  light : 0 to 255
  tag   : tag number -- optional

  index : number -- only set when writing
end

private class Sidedef
  upper, mid, lower : textures  -- optional
  x_offset, y_offset
  sector : Sector
end

private class Linedef
  v1, v2 : start/end Vertex refs
  front, back : Sidedefs
  flags : number
end

--]]


-- thing flags
MTF_EASY    = 1
MTF_MEDIUM  = 2
MTF_HARD    = 4
MTF_AMBUSH  = 8

-- hexen thing flags
XTF_FIGHTER = 32
XTF_CLERIC  = 64
XTF_MAGE    = 128
XTF_SP      = 256
XTF_COOP    = 512
XTF_DM      = 1024

-- linedef flags
ML_IMPASSABLE  = 1
ML_NO_MONSTER  = 2
ML_TWO_SIDED   = 4
ML_UPPER_UNPEG = 8
ML_LOWER_UNPEG = 16
ML_SECRET      = 32
ML_BLOCK_SOUND = 64
ML_MAPPED      = 128

-- hexen linedef flags
XL_REPEATABLE  = 512
XL_ACT_WALK    = (0 * 1024)
XL_ACT_USE     = (1 * 1024)
XL_ACT_MONSTER = (2 * 1024)
XL_ACT_SHOOT   = (3 * 1024)
XL_ACT_BUMP    = (4 * 1024)

HEXEN_ACTION_LOOKUP =
{
  W1 = 0x0000, WR = 0x0200,
  S1 = 0x0400, SR = 0x0600,
  M1 = 0x0800, MR = 0x0a00,
  G1 = 0x0c00, GR = 0x0e00,
  B1 = 0x1000, BR = 0x1200,
}


function write_level(lev_name)
 
  local sec_list   = {}
  local vert_list  = {}
  local line_list  = {}
  local thing_list = {}

  local total_sec   = 0
  local total_vert  = 0
  local total_side  = 0

  local vert_map = {}  -- acting as a set.  key is string "%d:%d" | value is index
  local vert_num = 0

  local sec_map = {}
  local total_group = 0

  local tx_file  -- text mode output

  local DUMMY_BLOCK = { solid=GAME.FACTORY.ERROR_TEX }


  local function FRAGMENT_X(x) return (x-1-BORDER_BLK*FW)*16 end
  local function FRAGMENT_Y(y) return (y-1-BORDER_BLK*FH)*16 end

  local function BLOCK_X(x) return FRAGMENT_X((x-1)*FW + 1) end
  local function BLOCK_Y(y) return FRAGMENT_Y((y-1)*FH + 1) end

  local function NORMALIZE(n) return math.floor(n * 1.0) end


  local function construct_things()

    local function do_thing(bx, by, th)
      th.x = BLOCK_X(bx + 0.5) + (th.dx or 0)
      th.y = BLOCK_Y(by + 0.5) + (th.dy or 0)

      th.flags = 0

      if th.options then
        if th.options.easy   then th.flags = th.flags + MTF_EASY   end
        if th.options.medium then th.flags = th.flags + MTF_MEDIUM end
        if th.options.hard   then th.flags = th.flags + MTF_HARD   end
        if th.options.ambush then th.flags = th.flags + MTF_AMBUSH end
      else
        -- default options
        th.flags = th.flags + MTF_EASY + MTF_MEDIUM + MTF_HARD
      end

      if GAME.FACTORY.hexen_format then
        if th.classes then
          if th.classes.fighter then th.flags = th.flags + XTF_FIGHTER end
          if th.classes.cleric  then th.flags = th.flags + XTF_CLERIC  end
          if th.classes.mage    then th.flags = th.flags + XTF_MAGE    end
        else
          -- default classes
          th.flags = th.flags + XTF_FIGHTER + XTF_CLERIC + XTF_MAGE
        end

        if th.modes then
          if th.modes.sp   then th.flags = th.flags + XTF_SP   end
          if th.modes.coop then th.flags = th.flags + XTF_COOP end
          if th.modes.dm   then th.flags = th.flags + XTF_DM   end
        else
          -- default game modes
          th.flags = th.flags + XTF_SP + XTF_COOP + XTF_DM
        end
      end

      table.insert(thing_list, th)
    end

    --- construct_things ---

    for bx = 1,PLAN.blk_w do
      for by = 1,PLAN.blk_h do
        local B = PLAN.blocks[bx][by]
        if B and B.things then
          for zzz,th in ipairs(B.things) do
            do_thing(bx, by, th)
          end
        end
      end
    end
  end

  local function construct_linedefs()

    local cur_line = nil

    local function create_vertex(L, x, y)
      local str = string.format("%d:%d", x, y)
      local index

      if vert_map[str] then
        index = vert_map[str]
        local V = vert_list[index]
        table.insert(V.lines, L)
        return V
      end

      index = vert_num
      vert_num = vert_num + 1

      local V = { x=x, y=y, lines={ L } }
      vert_list[index] = V
      vert_map[str] = index
      return V
    end

    local function push_line()
      if not cur_line then return end

      assert(cur_line.front)

      -- swap vertices for backward lines
      if cur_line.norm == 4 or cur_line.norm == 8 then
        cur_line.sx, cur_line.ex = cur_line.ex, cur_line.sx
        cur_line.sy, cur_line.ey = cur_line.ey, cur_line.sy
      end

      cur_line.v1 = create_vertex(cur_line, cur_line.sx, cur_line.sy)
      cur_line.v2 = create_vertex(cur_line, cur_line.ex, cur_line.ey)

      table.insert(line_list, cur_line)

      cur_line = nil
    end

    local function create_sidedef(f,b, f_over,b_over, sx, sy) 
      if f.solid then return nil end

      local SIDE = { block=f }

      SIDE.x_offset = b_over.x_offset or b.x_offset
      SIDE.y_offset = b_over.y_offset or b.y_offset

      if not SIDE.x_offset and f_over.x_offset then
        SIDE.x_offset = -f_over.x_offset
      end

      -- set textures
      if b.solid then
        SIDE.mid = b_over.l_tex or b.solid
      else
        SIDE.upper = b_over.u_tex or b.u_tex or GAME.FACTORY.ERROR_TEX
        SIDE.lower = b_over.l_tex or b.l_tex or GAME.FACTORY.ERROR_TEX

        if f_over.rail and not b_over.rail then
          SIDE.mid = f_over.rail
          if f_over.y_offset then SIDE.y_offset = f_over.y_offset end
          -- x_offset already handled above
        else
          SIDE.mid = b_over.rail or b.rail or f.rail
        end
      end

      -- FIXME: temp hack for Doom1 liquid sides
      if OB_CONFIG.game == "doom1" or OB_CONFIG.game == "ultdoom" then
        if SIDE.mid   == "BFALL1" then SIDE.mid   = "BLODRIP1" end
        if SIDE.upper == "BFALL1" then SIDE.upper = "BLODRIP1" end
        if SIDE.lower == "BFALL1" then SIDE.lower = "BLODRIP1" end

        if SIDE.mid   == "SFALL1" then SIDE.mid   = "BLODGR1" end
        if SIDE.upper == "SFALL1" then SIDE.upper = "BLODGR1" end
        if SIDE.lower == "SFALL1" then SIDE.lower = "BLODGR1" end
      end

      return SIDE
    end

    local function compute_line_flags(f,b, f_over,b_over, f_side,b_side, norm)
      local flags = 0

      local impassible = f.impassible or f_over.impassible or
                         b.impassible or b_over.impassible

      local l_peg = b_over.l_peg or f_over.l_peg or b.l_peg or f.l_peg
      local u_peg = b_over.u_peg or f_over.u_peg or b.u_peg or f.u_peg

      if not b.solid then

        flags = flags + ML_TWO_SIDED

        u_peg = u_peg or "top"
        l_peg = l_peg or "bottom"

      else  -- one sided --

        impassible = true

        l_peg = l_peg or "top"
      end

      if impassible then flags = flags + ML_IMPASSABLE end

      if l_peg == "bottom" then flags = flags + ML_LOWER_UNPEG end
      if u_peg == "top"    then flags = flags + ML_UPPER_UNPEG end

      -- sound blocking.  Note some subtlety here, when (count == 1)
      -- we only want a single edge to block, for (count == 2) we
      -- allow all edges to block sound.
      local w = sel(norm < 5, f, b)
      if (w.block_sound == 1) or
         (f.block_sound == 2) or
         (b.block_sound == 2)
      then
        flags = flags + ML_BLOCK_SOUND
      end

      if b_over.block_mon or f_over.block_mon then
        flags = flags + ML_NO_MONSTER
      end

      return flags
    end

    
    local function new_group()
      total_group = total_group + 1
      return { id=total_group }
    end

    local function merge_groups(g, h)
      
      if g == h then return end

      -- simplify pointer chains
      while g.ptr and g.ptr.ptr do g.ptr = g.ptr.ptr end
      while h.ptr and h.ptr.ptr do h.ptr = h.ptr.ptr end

      if g.ptr then assert(g.id >= g.ptr.id); g.id = g.ptr.id end
      if h.ptr then assert(h.id >= h.ptr.id); h.id = h.ptr.id end

      if g.id > h.id then
        if g.ptr then g.ptr.ptr = h end
        g.ptr = h

      elseif g.id < h.id then
        if h.ptr then h.ptr.ptr = g end
        h.ptr = g

      else
        -- already the same!
      end
    end

    local function same_sector(b1, b2)

      return (not b1.solid == not b2.solid) and
             (b1.f_h   == b2.f_h) and
             (b1.c_h   == b2.c_h) and
             (b1.f_tex == b2.f_tex) and
             (b1.c_tex == b2.c_tex) and
             (b1.light == b2.light) and
             (b1.tag   == b2.tag) and
             (b1.kind  == b2.kind) and
             (b1.mark  == b2.mark) and
             (b1.same_sec == b2.same_sec)
    end

    local function same_sector_w_merge(b1, b2)

      if b1 == b2 then return true end

      if b1.group and b2.group and (b1.group.id == b2.group.id) then
        return true
      end

      if b1.same_sec and (b1.same_sec == b2.same_sec) then
        return true
      end

      if same_sector(b1, b2) then
        if b1.group and b2.group then
          merge_groups(b1.group, b2.group)
        elseif b2.group and not b1.group then
          b1.group = b2.group
        elseif b1.group and not b2.group then
          b2.group = b1.group
        else  -- neither has a group yet
          b1.group = new_group()
          b2.group = b1.group
        end

        return true

      else  -- not same sector

        -- we DONT create new groups here, since there is a very
        -- good chance that the block will share a group later.
        --
        -- THIS MEANS: singleton blocks (no matching neighbour)
        -- will never get a 'group' field.
 
        return false
      end
    end

    local function match_sidedefs(s1, s2)
      if not s1 or not s2 then return s1 == s2 end

      -- Note: no need to check sector/block reference

      return
         (s1.lower == s2.lower) and
         (s1.upper == s2.upper) and
         (s1.mid   == s2.mid) and
         (s1.x_offset == s2.x_offset) and
         (s1.y_offset == s2.y_offset)
    end

    local function line_length(L)
      local dx = L.ex - L.sx
      local dy = L.ey - L.sy
      return math.floor(math.sqrt(dx*dx + dy*dy) + 0.5)
    end

    local function frag_pair(f,b,norm, x,y,dx,dy)

      if f == b then
        return push_line()
      end

      if not f or not (f.solid or f.f_tex) then f = DUMMY_BLOCK end
      if not b or not (b.solid or b.f_tex) then b = DUMMY_BLOCK end

      if f.solid and b.solid then
        return push_line()
      end

      -- don't create lines when sector is same on both sides
      if same_sector_w_merge(f, b) then
        return push_line()
      end

      local f_over = f[10-norm] or DUMMY_BLOCK
      local b_over = b[norm]    or DUMMY_BLOCK

      -- linedefs must have a front, flip if needed.
      -- Also some lines need to face out (doors)
      if f.solid or
        (not b.solid and (f.door_kind or f.lift_kind or f_over.kind))
      then
        norm = 10 - norm
        f, b = b, f
        f_over, b_over = b_over, f_over
      end

      assert(not f.solid)

      local f_side = create_sidedef(f,b, f_over,b_over)
      local b_side = create_sidedef(b,f, b_over,f_over)

      local flags = compute_line_flags(f,b, f_over,b_over, f_side,b_side, norm)

      local sx = FRAGMENT_X(x)
      local sy = FRAGMENT_Y(y)
      local ex = FRAGMENT_X(x + dx)
      local ey = FRAGMENT_Y(y + dy)

      if cur_line then
        local f_same = same_sector_w_merge(cur_line.f_block, f)
        local b_same = same_sector_w_merge(cur_line.b_block, b)
      
        if f_same and b_same and
            cur_line.norm  == norm and
            cur_line.flags == flags and
            match_sidedefs(cur_line.front, f_side) and
            match_sidedefs(cur_line.back,  b_side) and
            -- make sure line #0 is short (try to avoid intercept
            -- overflow in older DOOM engines)
            #line_list > 0
        then
          -- simply extend current line
          cur_line.ex, cur_line.ey = ex, ey
          return
        end
      end

      push_line()

      cur_line =
      {
        norm  = norm,
        flags = flags,

        f_block = f,
        b_block = b,

        front = f_side,
        back  = b_side,

        sx = sx, sy = sy,
        ex = ex, ey = ey,

        kind = not b.solid and (b.door_kind or b.lift_kind)
      }

      -- FIXME remove this door_kind/lift_kind/walk_kind shit

      if not b.solid and b.lift_kind then
        cur_line.tag = b.tag

        if b.lift_walk and (b.f_h == f.f_h) then
          cur_line.kind = b.lift_walk
        end
      end

      if b_over.kind then
        cur_line.kind = b_over.kind
        cur_line.tag  = b_over.tag

      elseif ((f.walk_kind ~= b.walk_kind) or (f.walk_tag ~= b.walk_tag))
             and not b.solid and not cur_line.kind
             and not (b.near_switch or f.near_switch)
      then
        if f.walk_kind then
          cur_line.kind = f.walk_kind
          cur_line.tag  = f.walk_tag
        else
          cur_line.kind = b.walk_kind
          cur_line.tag  = b.walk_tag
        end
      end
    end

    --==-- construct_linedefs --==--

    local frag_w = PLAN.blk_w * FW
    local frag_h = PLAN.blk_h * FH

    -- first do all horizontal lines...
    -- Note: we go ONE PAST the right/top edges.
    local x, y

    for y = 1,frag_h+1 do
      x = 1; while x <= frag_w do

        local bx,  fx  = div_mod(x, FW)
        local by0, fy0 = div_mod(y-1, FH)
        local by1, fy1 = div_mod(y, FH)

        local b0 = PLAN.blocks[bx] and PLAN.blocks[bx][by0]
        local b1 = PLAN.blocks[bx] and PLAN.blocks[bx][by1]

        local f0 = b0 and b0.fragments and b0.fragments[fx][fy0]
        local f1 = b1 and b1.fragments and b1.fragments[fx][fy1]

        if b0 and not b0.fragments then f0 = b0 end
        if b1 and not b1.fragments then f1 = b1 end

        local count = 1
        if f0 == b0 and f1 == b1 then count = 4 end

        frag_pair(f0,f1,2, x,y,count,0)

        x = x + count
      end

      push_line()

      gui.ticker()
    end

    gui.printf("TOTAL_GROUPS X = %d\n", total_group)

    if gui.abort() then return end

    -- now do all vertical lines...

    for x = 1,frag_w+1 do
      y = 1; while y <= frag_h do

        local by,  fy  = div_mod(y, FH)
        local bx0, fx0 = div_mod(x-1, FW)
        local bx1, fx1 = div_mod(x, FW)

        local b0 = PLAN.blocks[bx0] and PLAN.blocks[bx0][by]
        local b1 = PLAN.blocks[bx1] and PLAN.blocks[bx1][by]

        local f0 = b0 and b0.fragments and b0.fragments[fx0][fy]
        local f1 = b1 and b1.fragments and b1.fragments[fx1][fy]

        if b0 and not b0.fragments then f0 = b0 end
        if b1 and not b1.fragments then f1 = b1 end

        local count = 1
        if f0 == b0 and f1 == b1 then count = 4 end

        frag_pair(f1,f0,6, x,y,0,count)

        y = y + count
      end

      push_line()

      gui.ticker()
    end

    gui.printf("TOTAL_GROUPS Y = %d\n", total_group)
  end

  local function adjust_vertices()

    local function v_adjust(x, y, adj)
      local str = string.format("%d:%d", x, y)
      local V = vert_map[str]
      if V then
        V = vert_list[V]
        V.dx = (V.dx or 0) + (adj.dx or 0)
        V.dy = (V.dy or 0) + (adj.dy or 0)
        V.VDEL = adj.VDEL
      end
    end

    local function do_block(B, fx, fy, d)

      local x = FRAGMENT_X(fx)
      local y = FRAGMENT_Y(fy)

      if B[1] then v_adjust(x,   y,   B[1]) end
      if B[3] then v_adjust(x+d, y,   B[3]) end
      if B[7] then v_adjust(x,   y+d, B[7]) end
      if B[9] then v_adjust(x+d, y+d, B[9]) end
    end

    -- adjust_vertices --

    for bx = 1,PLAN.blk_w do
      for by = 1,PLAN.blk_h do
        local B = PLAN.blocks[bx][by]
        if B and B.fragments then
          for fx=1,4 do for fy=1,4 do
            local F = B.fragments[fx][fy]
            if F then
              do_block(F, (bx-1)*4+fx, (by-1)*4+fy, 16)
            end
          end end
        elseif B then
          do_block(B, bx*4-3, by*4-3, 64)
        end
      end
    end
  end

  local function delete_vertex(L, V, V_good)
    L.deleted = true

    -- find other line
    local M = V.lines[1]
    if M == L then
      M = V.lines[2]
    else
      assert(V.lines[2] == L)
    end

    -- fix the other line
    if M.v1 == V then
      M.v1 = V_good
    else
      assert(M.v2 == V)
      M.v2 = V_good
    end

    -- fix the good vertex
    if V_good.lines[1] == L then
      V_good.lines[1] = M
    else
      assert(V_good.lines[2] == L)
      V_good.lines[2] = M
    end

    -- catch attempt to re-use old vertex/linedef
    V.lines = nil
    L.v1, L.v2 = nil
  end

  local function delete_linedefs()
    
    -- Deleting one linedef can mean another (earlier) linedef
    -- should also be deleted (due to re-assigning vertices).
    -- Hence we must repeat this loop until all are done.
    repeat
      local changes = false

      gui.debugf("Deleting linedefs\n")

      for zzz,L in ipairs(line_list) do
        if not L.deleted then
          if L.v1.VDEL and #L.v1.lines == 2 then
            delete_vertex(L, L.v1, L.v2)
            changes = true

          -- Note: else here (because if v1 is deleted, v2 no longer
          --       belongs to the current line)
          elseif L.v2.VDEL and #L.v2.lines == 2 then
            delete_vertex(L, L.v2, L.v1)
            changes = true
          end
        end
      end
    until not changes
  end

  local function create_sector(B)
    if B.solid then return nil end

    if B.new_sec then return B.new_sec end

    if B.same_sec then return create_sector(B.same_sec) end

    local singleton = not B.group

    if B.group then
      while B.group.ptr do B.group = B.group.ptr end

      if sec_map[B.group.id] then return sec_map[B.group.id] end
    end

    SECT =
    {
      f_h = B.f_h,
      c_h = B.c_h,
      f_tex = B.f_tex,
      c_tex = B.c_tex,
      tag = B.tag,
      light = B.light,
      kind = B.kind,

      T_index = #sec_list
    }

    B.new_sec = SECT

    if B.group then sec_map[B.group.id] = SECT end

    table.insert(sec_list, SECT)

    return SECT
  end

  local function construct_sectors()

    for zzz,L in ipairs(line_list) do
      if L.front and L.front.block then
        L.front.sector = create_sector(L.front.block)
      end
      if L.back and L.back.block then
        L.back.sector = create_sector(L.back.block)
      end
    end
  end
 
  local function write_vertex(vert)

    vert.index = total_vert
    total_vert = total_vert + 1

    if vert.dx then vert.x = vert.x + vert.dx end
    if vert.dy then vert.y = vert.y + vert.dy end

    gui.v094_add_vertex(NORMALIZE(vert.x), NORMALIZE(vert.y))
  end

  local function write_sector(sec)

    sec.index = total_sec
    total_sec = total_sec + 1

    gui.v094_add_sector(NORMALIZE(sec.f_h), NORMALIZE(sec.c_h),
      sec.f_tex or GAME.FACTORY.ERROR_FLAT,
      sec.c_tex or GAME.FACTORY.ERROR_FLAT,
      sec.light or 0, sec.kind or 0, sec.tag or 0)
  end
  
  local function write_sidedef(sd)

    sd.index = total_side
    total_side = total_side + 1

    if not sd.sector.index then
      write_sector(sd.sector)
    end

    gui.v094_add_sidedef(sd.sector.index,
      sd.lower or "-", sd.mid   or "-", sd.upper or "-",
      sd.x_offset or 0, sd.y_offset or 0)
  end

  local function write_linedefs()

    for zzz,L in ipairs(line_list) do
      gui.ticker()

      if not L.deleted then
        if not L.v1.index then write_vertex(L.v1) end
        if not L.v2.index then write_vertex(L.v2) end
        
        if L.front and not L.front.index then
          write_sidedef(L.front)
        end
        if L.back  and not L.back.index  then
          write_sidedef(L.back)
        end

        -- Hexen linetypes
        if type(L.kind) == "table" then
          local flags = non_nil(L.flags)

          local args = table.copy(L.kind.args)

          if args[1] == "tag" then args[1] = L.tag or 0 end
          if args[2] == "tag" then args[2] = L.tag or 0 end

          flags = flags + HEXEN_ACTION_LOOKUP[L.kind.act]

          gui.v094_add_linedef(L.v1.index, L.v2.index,
                L.front and L.front.index or -1,
                L.back  and L.back.index  or -1,
                L.kind.id, flags, 0, args or {0,0,0,0,0});
        else
          gui.v094_add_linedef(L.v1.index, L.v2.index,
                L.front and L.front.index or -1,
                L.back  and L.back.index  or -1,
                L.kind or 0, non_nil(L.flags), L.tag or 0, L.args or {0,0,0,0,0});
        end
      end
    end
  end

  local function write_things()
    
    for zzz,th in pairs(thing_list) do

      gui.v094_add_thing(
          NORMALIZE(th.x), NORMALIZE(th.y), NORMALIZE(th.z or 0),
          th.kind.id, th.angle or 0, non_nil(th.flags),
          th.tid or 0, th.special or 0, th.args or {0,0,0,0,0})
    end
  end

  ---- BEGIN write_level ----

  construct_things()
  
  if gui.abort() then return end
 
  construct_linedefs()
  construct_sectors()

  adjust_vertices()
  delete_linedefs()

  if gui.abort() then return end

  gui.v094_begin_level()

  write_things()
  write_linedefs()  -- does vert/side/secs along the way

  gui.v094_end_level(lev_name)
end


----------------------------------------------------------------

function make_mini_map()

  if not gui.map_begin then return end

  gui.map_begin(PLAN.blk_w, PLAN.blk_h)

  for by = 1,PLAN.blk_h do
    for bx = 1,PLAN.blk_w do
      local B = PLAN.blocks[bx][by]
      if not B then gui.map_pixel(0)
      elseif B.solid then gui.map_pixel(1)
--    elseif B.kind or B.fragments then gui.map_pixel(4)
      elseif B.c_tex == GAME.FACTORY.SKY_TEX then gui.map_pixel(3)
      else gui.map_pixel(2)
      end
    end
  end

  gui.map_end()
end


----------------------------------------------------------------
--  CUSTOM WRITER for WOLF MAPS
----------------------------------------------------------------

function write_wolf_level()

  local function handle_block(x, y)
    if not valid_block(x, y) then return end
    local B = PLAN.blocks[x][y]
    if not B then return end

    local tile = GAME.FACTORY.NO_TILE
    local obj  = GAME.FACTORY.NO_OBJ

    if B.solid then
      assert(type(B.solid) == "number")
      tile = B.solid
    elseif B.door_kind then
      tile = GAME.FACTORY.TILE_NUMS[B.door_kind]
      if not tile then
        error("Unknown door_kind: " .. tostring(B.door_kind))
      end
      if type(tile) == "table" then
        tile = tile[sel(B.door_dir==4 or B.door_dir==6, 1, 2)]
        assert(tile)
      end
    else
      -- when we run out of floor codes (unlikely!) then reuse them
      local avail = GAME.FACTORY.TILE_NUMS.area_max - GAME.FACTORY.TILE_NUMS.area_min + 1
      local floor = B.floor_code or 0

      tile = GAME.FACTORY.TILE_NUMS.area_min + (floor % avail)
    end

    if B.things and B.things[1] then
      local th   = B.things[1]
      local kind = th.kind.id

      if type(kind) == "table" then

        -- convert skill settings
        if not th.options or th.options.easy then
          obj = kind.easy
        elseif th.options.medium then
          obj = kind.medium
        else
          obj = kind.hard
        end
        assert(obj)

        -- convert angle
        --
        -- Note that the player is different from the enemies:
        --   PLAYER : 19=N, 20=E, 21=S, 22=W
        --   ENEMY  : +0=E, +1=N, +2=W, +3=S

        if kind.dirs and th.angle then
          if kind.dirs == "player" then
            local offset = math.floor((360 - th.angle + 135) / 90) % 4
            assert(0 <= offset and offset <= 3)
            obj = obj + offset
          else
            local offset = math.floor((th.angle + 45) / 90) % 4
            assert(0 <= offset and offset <= 3)
            obj = obj + offset
          end
        end

        -- FIXME sometimes patrol (put choice in monster.lua)
        -- Disabled due to problems (T_Path error)

--      if kind.patrol and rand_odds(10) then
--        obj = obj + kind.patrol
--      end
      else
        obj = kind
      end
    end

    if (tile <= 63) and (obj > 0) then
      gui.printf("HOLO BLOCK @ (%d,%d) -- tile:%d obj:%d\n", x, y, tile,obj)
    end

    gui.wolf_block(x, y, tile, obj)
  end

  if gui.abort() then return end

  gui.v094_begin_wolf_level(lev_name);

  for y = 1,64 do for x = 1,64 do
    handle_block(x, y)
  end end

  gui.v094_end_wolf_level()
end
