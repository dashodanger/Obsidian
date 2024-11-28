PREFABS.Stairs_glow_1x =
{
  file   = "stairs/gtd_stairs_glow_64.wad",
  map    = "MAP01",

  theme = "!tech",

  prob   = 25,
  prob_skew = 3,

  style  = "liquids",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,

  bound_z1 = 0,

  delta_h = 64,

  x_fit = { 56,72 }
}

PREFABS.Stairs_glow_2x =
{
  template = "Stairs_glow_1x",
  map    = "MAP02",

  prob   = 35,

  seed_h = 2,

  delta_h = 96,
}

PREFABS.Stairs_glow_3x =
{
  template = "Stairs_glow_1x",
  map    = "MAP03",

  prob   = 45,
  seed_h = 3,

  delta_h = 128,

  x_fit = "bottom"
}

-- alt textures

PREFABS.Stairs_glow_1x_tech =
{
  template = "Stairs_glow_1x",

  theme = "tech",

  flat_CEIL5_2 = "FLAT19",
  tex_BROWN144 = "SHAWN2"
}

PREFABS.Stairs_glow_2x_tech =
{
  template = "Stairs_glow_1x",
  map    = "MAP02",

  theme = "tech",
  prob   = 35,

  seed_h = 2,

  delta_h = 96,

  flat_CEIL5_2 = "FLAT19",
  tex_BROWN144 = "SHAWN2"
}

PREFABS.Stairs_glow_3x_tech =
{
  template = "Stairs_glow_1x",
  map    = "MAP03",

  theme = "tech",
  prob   = 45,

  seed_h = 3,

  delta_h = 128,

  x_fit = "bottom",

  flat_CEIL5_2 = "FLAT19",
  tex_BROWN144 = "SHAWN2"
}
