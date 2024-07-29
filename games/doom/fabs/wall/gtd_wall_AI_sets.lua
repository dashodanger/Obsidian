PREFABS.Wall_AI_goth_comp_yellow_stained_glass_1 =
{
  file   = "wall/gtd_wall_AI_sets.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "gtd_AI_goth_comp_yellow_stained_glass",

  where  = "edge",
  deep   = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit  = {8,9}
}

PREFABS.Wall_AI_goth_comp_yellow_stained_glass_1_stretchable =
{
  template = "Wall_AI_goth_comp_yellow_stained_glass_1",
  map = "MAP02",

  rank = 2,

  height = 148,

  bound_z2 = 148,

  z_fit  = {139,140}
}

PREFABS.Wall_AI_goth_comp_yellow_stained_glass_1_lite_pillar =
{
  template = "Wall_AI_goth_comp_yellow_stained_glass_1",
  map = "MAP03",

  prob = 5,

  z_fit = {86,87}
}

PREFABS.Wall_AI_goth_comp_yellow_stained_glass_1_lite_pillar_stretchable =
{
  template = "Wall_AI_goth_comp_yellow_stained_glass_1",
  map = "MAP03",

  height = 128,

  prob = 5,
  rank = 2,

  z_fit = {86,87}
}

--
-- boiler room
--

PREFABS.Wall_AI_boiler_room_pipes =
{
  file   = "wall/gtd_wall_AI_sets.wad",
  map    = "MAP10",

  prob   = 50,
  group  = "gtd_AI_boiler_room",

  where  = "edge",
  deep   = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_AI_boiler_room_dashboards =
{
  template = "Wall_AI_boiler_room_pipes",
  map = "MAP11",

  prob = 8
}
