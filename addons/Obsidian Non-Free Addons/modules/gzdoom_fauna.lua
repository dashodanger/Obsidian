------------------------------------------------------------------------
--  MODULE: Fauna Module
------------------------------------------------------------------------
--
--  Copyright (C) 2020-2022 Frozsoul (based off MsrSgtShooterPerson's Jokewad Module)
--  Copyright (C) 2020-2022 josh771  (ZScript code for SpringyFly)
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

FAUNA_MODULE = {}

FAUNA_MODULE.DEC =
[[
ACTOR Fauna
{
  +CANNOTPUSH
  -CANPUSHWALLS
  -CANUSEWALLS
  -ACTIVATEMCROSS
  -COUNTKILL
  +NOTELESTOMP
  +NEVERRESPAWN
}

ACTOR Insect: Fauna
{
  +NEVERTARGET
}

ACTOR FlyingInsect: Insect
{
  +BOUNCEONWALLS
  +FLOAT
  +NOGRAVITY
}

ACTOR Rodent: Fauna
{
  damagefactor "Trample", 0
  damagefactor "Stomp", 0
}

// Credits:
// Decorate: Captain Toenail    (with modifications by Frozsoul)
// Sprites: Operation Bodycount
// Sounds: FindSounds.com
actor ScurryRat: Rodent 30100
{
  radius 8
  height 8
  mass 50
  speed 15
  scale 0.25
  health 1
  seesound    "rat/active"
  activesound "rat/active"
  deathsound  "rat/death"
  +FLOORCLIP
  +FRIGHTENED
  +LOOKALLAROUND
  +STANDSTILL
  +AMBUSH
  +SHOOTABLE
  states
  {
  LookAround:
    TNT1 A 0 A_StopSound(4)
    RATS A 1 A_Jump(256,"LookAround1","LookAround2")
    stop

  LookAround1:
    RATS A 40 A_Look
    RATS B 50 A_Look
    TNT1 A 0 A_Jump(30,"LookAround2")
    TNT1 A 0 A_Jump(5,"See")
    loop

  LookAround2:
    RATS B 50 A_Look
    RATS A 70 A_Look
    TNT1 A 0 A_Jump(30,"LookAround1")
    TNT1 A 0 A_Jump(5,"See")
    loop

  Spawn:
  See:
    RATS A 2 A_Chase
    TNT1 A 0 A_SetSpeed(15)
    TNT1 A 0 A_PlaySound("rat/scurry", 4, 0.8, 1, 3)
    RATS A 2 A_Chase
    RATS B 2 A_Chase
    RATS B 2 A_Chase
    RATS C 2 A_Chase
    RATS C 2 A_Chase
    RATS D 2 A_Chase
    RATS D 2 A_Chase
    TNT1 A 0 A_Jumpifcloser(20,"Bolt")
    TNT1 A 0 A_Jump(128,"LookAround")
    loop
  Bolt:
    RATS C 2 ThrustThing(angle * 256 / 360 + 128,40,1,0)
    RATS C 2 ThrustThingZ(0,15,0,1)
    TNT1 A 0 A_PlaySound("rat/scurry", 4, 0.8, 1, 3)
    TNT1 A 0
    {
        if (Random(0, 255) < 50)
        {
            A_SetSpeed(RandomPick(18, 20, 22));
        }
    }
    Goto See
  Death:
    TNT1 A 0 A_StopSound(4)
    RATS I 3 A_ScreamAndUnblock
    RATS JKL 3
    RATS L -1
    stop
  }
}
]]

-- ZScript code: josh771,
-- Sounds: FreeSounds
-- Sprites: Blood
-- Sprite Edit: Doomedarchviledemon
-- Idea Base: Population animal
FAUNA_MODULE.ZSC =
[[
class SpringyFly : Actor
{
    transient FLineTraceData fltData;
    Vector3 dest;
    double chase;
    double ignore;
    int pause;

    Vector3 spring(Vector3 p, Vector3 r, Vector3 v, double k, double d)
    {
        //p == current position
        //r == rest position
        //v == current velocity
        //k == spring coefficient
        //d == damping coefficient
        //simple damped spring formula
        return -(d * v) - (k * (p - r));
    }

    void getNewDest()
    {
        LineTrace(
            frandom(0,360),
            frandompick(8,16,32,64,128,256,512,1024),
            frandom(-90,90),
            TRF_THRUACTORS | TRF_ABSPOSITION,
            dest.z,
            dest.x,
            dest.y,
            fltData);
        dest = (dest + fltData.HitLocation) * 0.5;
    }

    override void PostBeginPlay()
    {
        SetOrigin((pos.xy, frandom(floorz + 8, ceilingz - 8)), false);
        dest = pos;
        getNewDest();
        chase = 0;
        ignore = 35;
        pause = 0;
        scale *= frandom(0.1,0.2);
        A_StartSound("fly/buzz", CHAN_BODY, CHANF_LOOP);
    }

    override void Tick()
    {

        if (isFrozen())
            return;

        UpdateWaterLevel();

        //This block manually advances states. Ripped straight from FastProjectile class:
        if (tics != -1)
        {
            if (tics > 0)
                tics--;
            while (!tics)
            {
                if (!SetState (CurState.NextState)) // mobj was removed
                    return;
            }
        }

        if (pause)
        {
            vel *= 0.8;
            pause--;
        }
        else
        {
            vel += spring(pos, dest, vel, 0.01, 0.01);
        }

        A_FaceMovementDirection();

        if (!ignore)
        {
            LineTrace(angle, vel.length() * 4, pitch, TRF_ALLACTORS, 4, 4, data:fltData);

            if (fltData.TRACE_HitActor && !target)
            {
                target = fltData.HitActor;
                chase = random(18, 525);
            }
        }
        else
            ignore--;

        LineTrace(angle, vel.length() * 4, pitch, TRF_THRUACTORS, 4, 4, data:fltData);

        if (fltData.HitType != TRACE_HitNone)
        {
            vel *= 0.8;
        }

        else
        {
            if (!target && !random(0,34))
            {
                getNewDest();
            }
        }

        SetOrigin(pos + vel, true);

        if (target)
        {
            dest = (target.x + frandom(-target.radius , target.radius),
                    target.y + frandom(-target.radius , target.radius),
                    target.z + target.height);
            if (!chase)
            {
                A_ClearTarget();
                ignore = random(18, 105);
            }
            else
                chase--;
        }

        if (!pause && !random(0,104))
            pause = random(1,35);
    }

    Default
    {
        ActiveSound "Fly/Buzz";
        Height 8;
        Radius 4;
        +FORCEXYBILLBOARD;
        +NOGRAVITY;
    }

    States
    {
    Spawn:
        FLYA AB 1;
        Loop;
    }
}
]]


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SNDINFO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

FAUNA_MODULE.SNDINFO =
[[
Fly/Buzz FLYBUZZ
$attenuation Fly/Buzz 3

// Scurry rat active (squeaking) sounds
// Includes NULLs to reduce frequency of squeaking noise
DSRATIDL DSRATIDL
DSRAT DSRAT
$attenuation DSRATIDL 3
$attenuation DSRAT 3
$random rat/active { DSRATIDL DSRAT DSRAT DSRAT DSRAT NULL NULL NULL NULL NULL NULL NULL NULL NULL NULL NULL NULL }

// Scurry rat death sounds
DSRATDI1    DSRATDI1
DSRATDI2    DSRATDI2
$attenuation DSRATDI1 3
$attenuation DSRATDI2 3
$random rat/death    { DSRATDI1 DSRATDI2 }

// Sound modified from https://freesound.org/people/krnash/sounds/389794/
rat/scurry    RATCRAWL
]]

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DEFINITIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

FAUNA_MODULE.ACTORS =
{
  SpringyFly =
  {
    id = 30000,
    cluster = 2,
  },

  rat =
  {
    id = 30100,
    cluster = 1,
  },
}

FAUNA_MODULE.DOOMEDNUMS =
[[
  30000 = SpringyFly
]]

function FAUNA_MODULE.get_levels(self)

  module_param_up(self)

end

function FAUNA_MODULE.end_level(self, LEVEL)

  if LEVEL.prebuilt then return end

  if PARAM.bool_flies == 1 then
    FAUNA_MODULE.add_flies(LEVEL)
  end

  if PARAM.bool_rats == 1 then
    FAUNA_MODULE.add_rats(LEVEL)
  end

end

function FAUNA_MODULE.add_flies(LEVEL)

  for _,A in pairs(LEVEL.areas) do

    if (A.mode and A.mode == "floor") then
      for _,S in pairs(A.seeds) do

        -- No spawning in outdoor snow areas
        if (A.is_outdoor and LEVEL.outdoor_theme == "snow") then end

        -- Default spawning odds
        local spawn_odds = 10

        -- Lower spawning probability if indoors
        if (A.is_indoor) then
          spawn_odds = 5
        end

        -- Greater spawning probability if outdoors and temperate
        if (A.is_outdoor and LEVEL.outdoor_theme == "temperate") then
          spawn_odds = 15
        end

        if rand.odds(spawn_odds) then

          local item_tab = {
            SpringyFly = 5,
          }

          local choice = rand.key_by_probs(item_tab)
          local item = FAUNA_MODULE.ACTORS[choice]
          local cluster
          local count = 1

          if item.cluster then
            count = rand.irange(1, item.cluster)
          end

          for i = 1, count do
            local event_thing = {}

            local final_z = A.ceil_h

            if A.room and not A.room.is_park then
              final_z = A.floor_h + 2
            end

            event_thing.id = FAUNA_MODULE.ACTORS[choice].id
            event_thing.z = final_z
            event_thing.x = rand.irange(S.mid_x + 48, S.mid_x - 48)
            event_thing.y = rand.irange(S.mid_y + 48, S.mid_y - 48)

            raw_add_entity(event_thing)
          end
        end
      end
    end
  end
end

function FAUNA_MODULE.add_rats(LEVEL)

  for _,A in pairs(LEVEL.areas) do
    if (A.mode and A.mode == "floor") then
      for _,S in pairs(A.seeds) do

        -- No spawning in outdoor snow areas
        if (A.is_outdoor and LEVEL.outdoor_theme == "snow") then end

        -- Default spawning odds
        local spawn_odds = 1

        -- Greater spawning probability if indoors
        if (A.is_indoor) then
          spawn_odds = 3
        end

        if rand.odds(spawn_odds) then

          local item_tab = {
            rat = 5,
          }

          local choice = rand.key_by_probs(item_tab)
          local item = FAUNA_MODULE.ACTORS[choice]
          local cluster
          local count = 1

          if item.cluster then
            count = rand.irange(1, item.cluster)
          end

          for i = 1, count do
            local event_thing = {}

            local final_z = A.ceil_h

            if A.room and not A.room.is_park then
              final_z = A.floor_h + 2
            end

            event_thing.id = FAUNA_MODULE.ACTORS[choice].id
            event_thing.z = final_z
            event_thing.x = rand.irange(S.mid_x + 48, S.mid_x - 48)
            event_thing.y = rand.irange(S.mid_y + 48, S.mid_y - 48)

            raw_add_entity(event_thing)
          end
        end
      end
    end
  end
end



function FAUNA_MODULE.all_done()
  if PARAM.bool_flies == 1 or PARAM.bool_rats == 1 then
    SCRIPTS.fauna_SNDINFO = FAUNA_MODULE.SNDINFO
  end

  if PARAM.bool_flies == 1 then
    SCRIPTS.zscript = ScriptMan_combine_script(SCRIPTS.zscript, FAUNA_MODULE.ZSC)
    SCRIPTS.doomednums = ScriptMan_combine_script(SCRIPTS.doomednums, FAUNA_MODULE.DOOMEDNUMS)

    local dir = "games/doom/data/"
    gui.wad_merge_sections(dir .. "Fly.wad")
    gui.wad_insert_file(dir .. "sounds/FLYBUZZ.ogg", "FLYBUZZ")
  end

  if PARAM.bool_rats == 1 then
    SCRIPTS.decorate = ScriptMan_combine_script(SCRIPTS.decorate, FAUNA_MODULE.DEC)

    local dir = "games/doom/data/"
    gui.wad_merge_sections(dir .. "Rats.wad")
    gui.wad_insert_file(dir .. "sounds/DSRAT.ogg", "DSRAT")
    gui.wad_insert_file(dir .. "sounds/DSRATIDL.ogg", "DSRATIDL")
    gui.wad_insert_file(dir .. "sounds/DSRATDI1.ogg", "DSRATDI1")
    gui.wad_insert_file(dir .. "sounds/DSRATDI2.ogg", "DSRATDI2")
    gui.wad_insert_file(dir .. "sounds/RATCRAWL.ogg", "RATCRAWL")
  end
end

OB_MODULES["fauna_module"] =
{

  name = "fauna_module",

  label = _("GZDoom: Fauna"),

  where = "other",
  priority = 68,

  port = "zdoom",

  hooks =
  {
    get_levels = FAUNA_MODULE.get_levels,
    end_level = FAUNA_MODULE.end_level,
    all_done = FAUNA_MODULE.all_done
  },

  options =
  {

    {
      name = "bool_flies",
      label=_("Flies"),
      valuator = "button",
      default = 0,
      tooltip = _("Adds flies to maps. \n"),
    },

    {
      name = "bool_rats",
      label=_("Rats"),
      valuator = "button",
      default = 0,
      tooltip = _("Adds scurrying rats to maps. \n"),
    },
  },
}
