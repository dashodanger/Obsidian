HACX.ENTITIES =
{

  --- entities for generic prefabs, the rid field stands for "Real ID" --
  generic_barrel = { id=7000, rid=2035, r=15, h=60 },
  generic_ceiling_light = { id=7001, rid=28, r=31, h=60, light=255, pass=true, ceil=true, add_mode="island" },
  generic_standalone_light = { id=7002, rid=27, r=12, h=54, light=255 }, -- "torches" and such, freestanding on a floor
  generic_wall_light    = { id=7003, rid=50, r=10, h=64, light=255, pass=true, add_mode="extend" }, -- "torches" and such, attached to a wall
  generic_wide_light    = { id=7004, rid=76, r=16, h=44, light=255 }, -- wide standalone light, braziers, etc
  generic_small_pillar  = { id=7005, rid=29, r=16, h=36 },
  k_one = { id=7006, rid=80 },
  k_two = { id=7007, rid=73 },
  k_three = { id=7008, rid=79 },
  generic_p1_start = { id=7009, rid=1, r=16, h=56 },
  generic_p2_start = { id=7010, rid=2, r=16, h=56 },
  generic_p3_start = { id=7011, rid=3, r=16, h=56 },
  generic_p4_start = { id=7012, rid=4, r=16, h=56 },
  generic_teleport_spot = { id=7013, rid=14},

 --- special stuff ---
  player1 = { id=1, r=16, h=56 },
  player2 = { id=2, r=16, h=56 },
  player3 = { id=3, r=16, h=56 },
  player4 = { id=4, r=16, h=56 },

  dm_player     = { id=11, r=16, h=56 },
  teleport_spot = { id=14, r=16, h=56 },

  --- keys ---
  k_password = { id=5 },
  k_ckey     = { id=6 },
  k_keycard  = { id=13 },

  kz_red     = { id=38 },
  kz_yellow  = { id=39 },
  kz_blue    = { id=40 },

  -- TODO: POWERUPS

  --- scenery ---
  chair      = { id=35, r=24, h=40 }

  -- TODO: all other scenery!!
}

HACX.GENERIC_REQS =
{
  -- These are used for fulfilling fab pick requirements in prefab.lua
  Generic_Key_One = { kind = "k_one", rkind = "k_yellow" },
  Generic_Key_Two = { kind = "k_two", rkind = "k_green" },
  Generic_Key_Three = { kind = "k_three", rkind = "k_blue" }
}

HACX.PLAYER_MODEL =
{
  danny =
  {
    stats   = { health=0 },
    weapons = { pistol=1, boot=1 }
  }
}
