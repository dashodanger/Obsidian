PREFABS.Wall_hell_engraving_plain_1 =
{
  file = "wall/gtd_wall_hell_engraving_set.wad",
  map = "MAP01",

  prob = 50,
  theme = "hell",

  group = "gtd_wall_hell_engraving_1",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top",
}

PREFABS.Wall_hell_engraving_arched_1 =
{
  template = "Wall_hell_engraving_plain_1",
  map = "MAP02",

  prob = 15,

  height = 128,

  tex_ENGRAV1 = 
  {
    DECO1GRY = 1,
    ENGRAV1 = 1,
    ENGRAV2 = 1,
    ENGRAV3 = 1,
    ENGRAV4 = 1,
  },

  bound_z2 = 128
}

--

PREFABS.Wall_hell_engraving_plain_2 =
{
  template = "Wall_hell_engraving_plain_1",

  group = "gtd_wall_hell_engraving_2",

  tex_ENGRAV6 = "ENGRAV7"
}

PREFABS.Wall_hell_engraving_arched_2 =
{
  template = "Wall_hell_engraving_plain_1",
  map = "MAP02",

  prob = 15,

  group = "gtd_wall_hell_engraving_2",

  height = 128,

  tex_ENGRAV6 = "ENGRAV7",
  tex_ENGRAV1 = 
  {
    DECO1GRY = 1,
    ENGRAV1 = 1,
    ENGRAV2 = 1,
    ENGRAV3 = 1,
    ENGRAV4 = 1
  },

  bound_z2 = 128
}

--

PREFABS.Wall_hell_engraving_plain_3 =
{
  template = "Wall_hell_engraving_plain_1",

  group = "gtd_wall_hell_engraving_3",

  tex_ENGRAV6 = "ENGRAV8"
}

PREFABS.Wall_hell_engraving_arched_3 =
{
  template = "Wall_hell_engraving_plain_1",
  map = "MAP02",

  prob = 15,

  group = "gtd_wall_hell_engraving_3",

  height = 128,

  tex_ENGRAV6 = "ENGRAV8",
  tex_ENGRAV1 = 
  {
    DECO1GRY = 1,
    ENGRAV1 = 1,
    ENGRAV2 = 1,
    ENGRAV3 = 1,
    ENGRAV4 = 1
  },

  bound_z2 = 128
}

--

PREFABS.Wall_hell_engraving_dark =
{
  template = "Wall_hell_engraving_plain_1",
  map = "MAP03",

  height = 128,

  bound_z2 = 128,

  group = "gtd_wall_hell_engraving_dark"
}

PREFABS.Wall_hell_engraving_dark_diag =
{
  template = "Wall_hell_engraving_plain_1",
  map = "MAP04",

  height = 128,
  where = "diagonal",

  bound_z2 = 128,

  group = "gtd_wall_hell_engraving_dark"
}

--

PREFABS.Wall_hell_engraving_arch =
{
  template = "Wall_hell_engraving_plain_1",
  map = "MAP05",

  height = 128,

  bound_z2 = 128,

  group = "gtd_wall_hell_engraving_arch"
}

PREFABS.Wall_hell_engraving_arch_triple =
{
  template = "Wall_hell_engraving_plain_1",
  map = "MAP06",

  prob = 25,

  height = 128,

  bound_z2 = 128,

  group = "gtd_wall_hell_engraving_arch"
}

PREFABS.Wall_hell_engraving_arch_diag =
{
  template = "Wall_hell_engraving_plain_1",
  map = "MAP07",

  height = 128,
  where = "diagonal",

  bound_z2 = 128,

  group = "gtd_wall_hell_engraving_arch"
}

--

PREFABS.Wall_hell_engraving_top_band =
{
  template = "Wall_hell_engraving_plain_1",
  map = "MAP10",

  height = 96,

  bound_z2 = {22,24 , 88,89},

  group = "gtd_wall_hell_engraving_top_band"
}
