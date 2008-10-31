----------------------------------------------------------------
--  SEED MANAGEMENT / GROWING
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

class SEED
{
  sx, sy, sz : location in seed map

  room : ROOM

  borders : table(DIR -> BORDER)  -- DIR can be (2 4 6 8)

  x1, y1, z1, x2, y2, z2 : map coordinates for 3D bbox 
}


class BORDER
{
  kind  : "solid" | "view" | "walk"

  other : SEED  -- seed we are connected to, or nil 

  rlink : RLINK
}

--------------------------------------------------------------]]

require 'defs'
require 'util'


function Seed_init(W, H, D)

  -- setup globals 
  SEED_W = W
  SEED_H = H
  SEED_D = D

  SEEDS = array_2D(W, H)

  for x = 1,W do for y = 1,H do
    SEEDS[x][y] = {}

    for z = 1,D do
      SEEDS[x][y][z] = { sx=x, sy=y, sz=z }
    end
  end end -- x,y
end


function Seed_close()
  SEEDS = nil

  SEED_W = nil
  SEED_H = nil
  SEED_D = nil
end


function Seed_valid(x, y, z)
  return (x >= 1 and x <= SEED_W) and
         (y >= 1 and y <= SEED_H) and
         (z >= 1 and z <= SEED_D)
end


function Seed_get_safe(x, y, z)
  return Seed_valid(x, y, z) and SEEDS[x][y][z]
end


function Seed_is_free(x, y, z)
  assert(Seed_valid(x, y, z))

  return not SEEDS[x][y][z].room
end


function Seed_valid_and_free(x, y, z)
  if not Seed_valid(x, y, z) then
    return false
  end

  if SEEDS[x][y][z].room then
    return false
  end

  return true
end


function Seed_block_valid_and_free(x1,y1,z1, x2,y2,z2)

  assert(x1 <= x2 and y1 <= y2 and z1 <= z2)

  if not Seed_valid(x1, y1, z1) then return false end
  if not Seed_valid(x2, y2, z2) then return false end

  for x = x1,x2 do for y = y1,y2 do for z = z1,z2 do
    local S = SEEDS[x][y][z]
    if S.room then
      return false
    end
  end end end -- x, y, z

  return true
end


function Seed_dump_rooms()
  gui.printf("Seed room map:\n")

  local ROOM_IDX = 0
  local HALL_IDX = 0

  local ROOMS = "BFGHIDKLPTQJY"
  local HALLS = "acmunorvsewxz"

  local function seed_to_char(S)
    if not S then return "!" end

    if not S.room then
      return "."
    end

    if not S.room.dump_char then
      if S.room.kind == "hall" then
        S.room.dump_char = string.sub(HALLS, 1+HALL_IDX, 1+HALL_IDX)
        HALL_IDX = (HALL_IDX + 1) % string.len(HALLS)
      else
        S.room.dump_char = string.sub(ROOMS, 1+ROOM_IDX, 1+ROOM_IDX)
        ROOM_IDX = (ROOM_IDX + 1) % string.len(ROOMS)
      end
    end

    return S.room.dump_char
  end

  for y = SEED_H,1,-1 do
    for x = 1,SEED_W do
      gui.printf("%s", seed_to_char(SEEDS[x][y][1]))
    end
    gui.printf("\n")
  end

  gui.printf("\n")
end


function Seed_dump_fabs()
  local function char_for_seed(S)

    if not S or not S.kind then return "." end

    if S.kind == "ground" then return "2" end
    if S.kind == "valley" then return "1" end
    if S.kind == "hill"   then return "3" end

    if S.kind == "indoor" then return "#" end
    if S.kind == "hall"   then return "+" end
    if S.kind == "liquid" then return "~" end

    return "?"
  end

  gui.printf("Room Fabs:\n")

  for y = SEED_H,1,-1 do
    
    for x = 1,SEED_W do
      gui.printf("%s", char_for_seed(SEEDS[x][y][1].room))
    end

    gui.printf("\n")
  end

  gui.printf("\n")
end


function Seed_grow()

  assert(PARAMS.seed_size)

  for x = 1,SEED_W do for y = 1,SEED_H do for z = 1,SEED_D do

    local S = SEEDS[x][y][z]

    S.x1 = x * PARAMS.seed_size
    S.y1 = y * PARAMS.seed_size

    S.x2 = (x+1) * PARAMS.seed_size
    S.y2 = (y+1) * PARAMS.seed_size

  end end end --- x, y, z

  return
end

