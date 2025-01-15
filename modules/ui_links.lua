----------------------------------------------------------------
--  MODULE: Useful Links
----------------------------------------------------------------
--
--  Copyright (C) 2023-2025 The OBSIDIAN Team
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

OB_MODULES["ui_useful_links"] =
{
  label = _("Useful Links"),

  where = "links",
  priority = 101,

  options =
  {
    {
      name = "header_free_content",
      label = _("Game WADs (Libre/Freeware)"),
      gap = 1
    },
    { 
      name="url_freedoom",     
      label=_("Freedoom (Doom 1/2 Replacement)"),
      url="https://freedoom.github.io/download.html",
    },
    { 
      name="url_blasphemer",     
      label=_("Blasphemer (Heretic Replacement)"),
      url="https://github.com/Catoptromancy/blasphemer",    
    },
    { 
      name="url_cq3_vanilla",     
      label=_("Chex Quest 3: Vanilla Edition"),
      url="https://melodic-spaceship.neocities.org/chex3v",    
    },
    { 
      name="url_hacx",     
      label=_("HacX 1.2"),
      url="https://www.doomworld.com/idgames/themes/hacx/hacx12",    
    },
    { 
      name="url_harmony",     
      label=_("Harmony Compatible"),
      url="https://www.doomworld.com/idgames/levels/doom2/Ports/g-i/harmonyc",    
    },
    { 
      name="url_rekkr",     
      label=_("REKKR"),
      url="https://www.doomworld.com/idgames/levels/doom/megawads/rekkr",
      gap=4    
    },

    {
      name = "header_addons",
      label = _("Obsidian Addons"),
      gap = 1
    },   
    { 
      name="url_edge_classic_pack",     
      label=_("Lobo's EDGE-Classic Enhancements"),
      url="https://obsidian-level-maker.github.io/addons.html",
    },
    { 
      name="url_mobreck_mbf21",     
      label=_("Mobreck's MBF21 Expanded DOOM Beastiary"),
      url="https://www.moddb.com/mods/the-mbf21-expanded-doom-bestiary-project/downloads/medb-addon-for-obsidian",    
    },
    { 
      name="url_doomrla_pickups",     
      label=_("xBEEKAYRANDEEx's DoomRLA Pickups"),
      url="https://obsidian-level-maker.github.io/addons.html",    
    },
    { 
      name="url_heathens_maze",     
      label=_("Heathen's Maze For Heretic - Craneo"),
      url="https://obsidian-level-maker.github.io/addons.html",    
    },
    { 
      name="url_obsidian_jukebox",     
      label=_("Simon-v's Jukebox"),
      url="https://obsidian-level-maker.github.io/addons.html",    
    },
    { 
      name="url_silentzorah_jukebox",     
      label=_("SilentZorah's Jukebox - Craneo"),
      url="https://obsidian-level-maker.github.io/addons.html",    
    },
    { 
      name="url_delta_resource_pack",     
      label=_("MsrSgtShooterPerson's Delta Resource Pack"),
      url="https://obsidian-level-maker.github.io/addons.html",
      gap=4
    },

    {
      name = "header_source_ports",
      label = _("Source Ports"),
      gap = 1
    },  
    { 
      name="url_marshmallow",     
      label=_("Marshmallow Doom"),
      url="http://marshmallowdoom.com/marshmallow-wp",
    },
    { 
      name="url_k8vaoom",     
      label=_("k8vavoom"),
      url="https://doomer.boards.net/thread/2260/k8vavoom",    
    },
    { 
      name="url_edge_classic",     
      label=_("EDGE-Classic"),
      url="https://edge-classic.github.io/",    
    },
    { 
      name="url_prboomx",     
      label=_("PrBoomX"),
      url="https://github.com/JadingTsunami/prboomX",    
    },
    { 
      name="url_doom_retro",     
      label=_("Doom Retro"),
      url="https://www.doomretro.com/",    
    },
    { 
      name="url_helion",     
      label=_("Helion"),
      url="https://github.com/Helion-Engine/Helion",    
    },
    { 
      name="url_gzdoom",     
      label=_("ZDoom Family (GZDoom, LZDoom, ZDoom)"),
      url="https://www.zdoom.org/index",    
    },
    { 
      name="url_dsda_doom",     
      label=_("DSDA-Doom"),
      url="https://github.com/kraflab/dsda-doom",    
    },
    { 
      name="url_eternity",     
      label=_("Eternity Engine"),
      url="https://github.com/team-eternity/eternity",    
    },
    { 
      name="url_woof",     
      label=_("Woof"),
      url="https://github.com/fabiangreffrath/woof"
    }
  }
}