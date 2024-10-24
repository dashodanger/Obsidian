------------------------------------------------------------------------
--  PANEL: Pickups
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
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

UI_PICKUPS = { }

UI_PICKUPS.HEALTH_CHOICES =
{
  "none",     _("NONE"),
  "scarce",   _("Scarce"),
  "less",     _("Less"),
  "bit_less", _("Bit Less"),
  "normal",   _("Normal"),
  "bit_more", _("Bit More"),
  "more",     _("More"),
  "heaps",    _("Heaps"),
}

UI_PICKUPS.WEAPON_CHOICES =
{
  "none",      _("NONE"),
  "very_soon", _("Very Soon"),
  "sooner",    _("Sooner"),
  "normal",    _("Normal"),
  "later",     _("Later"),
  "very_late", _("Very Late"),
}

UI_PICKUPS.ITEM_CHOICES =
{
  "none",   _("NONE"),
  "rare",   _("Rare"),
  "less",   _("Less"),
  "normal", _("Normal"),
  "more",   _("More"),
  "heaps",  _("Heaps"),
}

UI_PICKUPS.SECRET_ROOM_BONUS =
{
  "none", _("NONE"),
  "more", _("More"),
  "heaps", _("Heaps"),
  "heapser", _("Rich"),
  "heapsest", _("Resplendent")
}

function UI_PICKUPS.setup(self)
  
  module_param_up(self)

end


OB_MODULES["ui_pickups"] =
{
  label = _("Pickups"),

  where = "pickup",
  priority = 102,
  engine = "!idtech_0",
  port = "!limit_enforcing",

  hooks =
  {
    setup = UI_PICKUPS.setup,
  },

  options =
  {
    { name="health",     
    label=_("Health"),    
    choices=UI_PICKUPS.HEALTH_CHOICES, randomize_group="pickups", 
    tooltip = _("Control the number of health items.") 
    },

    { name="ammo",       
      label=_("Ammo"),      
      choices=UI_PICKUPS.HEALTH_CHOICES,  gap=1, randomize_group="pickups", 
      tooltip = _("Control the amount of ammunition.") 
    },

    { name="weapons",    
      label=_("Weapons"),   
      choices=UI_PICKUPS.WEAPON_CHOICES, randomize_group="pickups", 
      tooltip = _("Control the number of weapons.") 
    },

    { name="items",      
      label=_("Items"),     
      choices=UI_PICKUPS.ITEM_CHOICES, randomize_group="pickups", 
      tooltip = _("Control the number of armor and miscellaneous items.")
    },

    { name="secrets",    
      label=_("Secrets"),   
      choices=STYLE_CHOICES, randomize_group="pickups", 
      tooltip = _("Control the number of secrets.")
    },

    { name="secrets_bonus",
      label=_("Secrets Bonus"),
      choices=UI_PICKUPS.SECRET_ROOM_BONUS,
      tooltip=_("Adds extra content to secret rooms. Larger rooms offer more content. Default is NONE."),
      default="none",
      randomize_group="pickups",
      
    },
  },
}