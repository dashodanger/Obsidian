------------------------------------------------------------------------
--  MODULE: Procedural Gotcha Fine Tune
------------------------------------------------------------------------
--
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
--  Copyright (C) 2021-2022 Reisal
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

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM = {}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_DROPS = 
{
  doomish = 
  [[class BossExiter : CustomInventory
  {
      Default
      {
      Translation "168:191=250:254", "32:48=250:254", "192:207=32:47", "240:247=47:47";
      Scale 2;
      }
      States
      {
      Spawn:
          PINS ABCD 4 BRIGHT A_SpawnItemEx("BossExiterGlow");
          Loop;
      Pickup:
          TNT1 A 1 Exit_Normal(0);
          Stop;
      }
  }
  class BossExiterGlow : Actor
  {
      Default
      {
      Translation "168:191=250:254", "32:48=250:254", "192:207=32:47", "240:247=47:47";
      Scale 2;
      +NOGRAVITY;
      +NOINTERACTION;
      }
      States
      {
      Spawn:
          PINS ABCD 4 BRIGHT;
          Loop;
      }
      override void Tick()
      {
          super.Tick();
          A_Fadeout(0.02);
          scale *= 0.99;
          SetZ(pos.z+2);
      }
  }]],
  heretic =
  [[class BossExiter : CustomInventory
  {
      Default
      {
      Translation "225:234=145:157", "235:240=247:242", "44:44=144:144";
      }
      States
      {
      Spawn:
          INVS A 4 BRIGHT A_SpawnItemEx("BossExiterGlow");
          Loop;
      Pickup:
          TNT1 A 1 Exit_Normal(0);
          Stop;
      }
  }
  class BossExiterGlow : Actor
  {
      Default
      {
      Translation "225:234=145:157", "235:240=247:242", "44:44=144:144";
      +NOGRAVITY;
      +NOINTERACTION;
      }
      States
      {
      Spawn:
          INVS A 4 BRIGHT;
          Loop;
      }
      override void Tick()
      {
          super.Tick();
          A_Fadeout(0.02);
          scale *= 0.99;
          SetZ(pos.z+2);
      }
  }]],
  hacx =
  [[class BossExiter : CustomInventory
  {
      Default
      {
      Scale 2;
      }
      States
      {
      Spawn:
          PINS A 4 BRIGHT A_SpawnItemEx("BossExiterGlow");
          Loop;
      Pickup:
          TNT1 A 1 Exit_Normal(0);
          Stop;
      }
  }
  class BossExiterGlow : Actor
  {
      Default
      {
      Scale 2;
      +NOGRAVITY;
      +NOINTERACTION;
      }
      States
      {
      Spawn:
          PINS A 4 BRIGHT;
          Loop;
      }
      override void Tick()
      {
          super.Tick();
          A_Fadeout(0.02);
          scale *= 0.99;
          SetZ(pos.z+2);
      }
  }]]
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_DIFF_CHOICES =
{
  "easier", _("Easier"),
  "default", _("Moderate"),
  "harder", _("Harder"),
  "nightmare", _("Nightmare"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_LESS_HITSCAN =
{
  "default", _("Default"),
  "less", _("50% less"),
  "muchless", _("80% less"),
  "none", _("100% less"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.ARENA_STEEPNESS =
{
  "none",  _("NONE"),
  "rare",  _("Rare"),
  "few",   _("Few"),
  "less",  _("Less"),
  "some",  _("Some"),
  "mixed", _("Mix It Up"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.REINFORCE =
{
  "none",  _("NONE"),
  "weaker",  _("Weaker"),
  "default",   _("Default"),
  "harder",  _("Harder"),
  "tougher",  _("Much Harder"),
  "nightmare", _("Nightmare"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.REINFORCER =
{
  "weakester",  _("Extremely slow"),
  "weakest",  _("Very slow"),
  "weaker",  _("Slow"),
  "default",   _("Default"),
  "harder",  _("Fast"),
  "tougher",  _("Faster"),
  "serious", _("Nightmare"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_WEAP =
{
  "scatter", _("Scatter around arena"),
  "close",  _("Close to player start"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_EXIT =
{
  "default", _("Exit after 10 seconds"),
  "item",  _("Spawn pickup that exits the level"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_LIMITS =
{
  "hardlimit",  _("Hard Limit"),
  "softlimit",     _("Soft Limit"),
  "nolimit", _("No Limit"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TEMPLATES =
{
  ZSC =
[[
class BossGenerator_Handler : EventHandler
{
    bool bossEnabled;
    bool bossFound;
    int currentboss;
    bool IsBoss(actor a)
    {
        int ln = level.LevelNum;
        if(a.angle==ln || a.angle==45+ln || a.angle==90+ln || a.angle==135+ln || a.angle==180+ln || a.angle==225+ln || a.angle==270+ln || a.angle==315+ln)
        { return true;}
        else
        { return false;}
    }
    void SpreadMissile(actor Misl, float ang)
    {
        let proj = Misl.SpawnMissileAngleZSpeed(Misl.Pos.z, Misl.GetClassName(), Misl.Angle+ang, Misl.vel.z, Misl.Speed, Misl.Target,0);
        if(proj)
        {
            proj.A_GiveInventory("bossabilitygiver_spread");
            proj.target = Misl.Target;
            proj.tracer = Misl.Tracer;
        }
    }
    override void WorldLoaded(WorldEvent e)
    {
        LEVELCODE
    }
    Override void WorldThingSpawned(WorldEvent e)
    {
        if(!bossEnabled) return;
        if( e.Thing && e.Thing.bMISSILE && e.Thing.Health && e.Thing.Target && e.Thing.Target.CountInv("bossabilitygiver_boss") )
        {
            e.Thing.bTHRUSPECIES = true;
            e.Thing.bNORADIUSDMG = true;
        }
        if( e.Thing && e.Thing.bMISSILE && e.Thing.GetMissileDamage(7,1)>0 && e.Thing.Target && e.Thing.Target.CountInv("bossabilitygiver_boss") && e.Thing.GetClassname() != "BossSpook" )
        {
            ThinkerIterator BossFinder = ThinkerIterator.Create("bossController");
            bossController mo;
            while (mo = bossController(BossFinder.Next()))
            {
                mo.LProj=e.Thing.GetClassname();
                if(mo.FProj==""){ mo.FProj=e.Thing.GetClassname(); }
            }
        }
        if( e.Thing && e.Thing.bMISSILE && !e.Thing.CountInv("bossabilitygiver_spread") && !e.Thing.CountInv("bossabilitygiver_boss") && e.Thing.Target && e.Thing.Target.CountInv("bossabilitygiver_spread") )
        {
            SpreadMissile(e.Thing, 25.0);
            SpreadMissile(e.Thing, -25.0);
            if( e.Thing.Target.CountInv("bossabilitygiver_spread")>1)
            {
                SpreadMissile(e.Thing, 12.5);
                SpreadMissile(e.Thing, -12.5);
                if( e.Thing.Target.CountInv("bossabilitygiver_spread")>2)
                {
                    SpreadMissile(e.Thing, 37.5);
                    SpreadMissile(e.Thing, -37.5);
                }
            }
        }
        if( e.Thing && e.Thing.bMISSILE && e.Thing.Target && e.Thing.Target.CountInv("bossabilitygiver_bounce") )
        {
            e.Thing.bBOUNCEONWALLS = true;
            e.Thing.bBOUNCEONFLOORS = true;
            e.Thing.bouncefactor = 0.99;
            e.Thing.WallBounceFactor = 0.99;
            e.Thing.bouncecount = 3;
            if( e.Thing.CheckClass("FastProjectile",match_superclass:true))
            {
                let misl0 = BossRicochetThinker(new("BossRicochetThinker"));
                if(misl0)
                {
                    misl0.missile = e.Thing;
                    misl0.power = e.Thing.Target.CountInv("bossabilitygiver_bounce");
                }
            }
            if( e.Thing.Target.CountInv("bossabilitygiver_bounce")>1 )
            {
                e.Thing.WallBounceFactor = 1.1;
                e.Thing.bouncecount = 9;
            }
            else if( e.Thing.Target.CountInv("bossabilitygiver_bounce")>2 )
            {
                e.Thing.WallBounceFactor = 1.2;
                e.Thing.bouncecount = 20;
            }
        }
        if( e.Thing && e.Thing.bMISSILE && e.Thing.Target && e.Thing.Target.CountInv("bossabilitygiver_pyro") )
        {
            e.Thing.Target.bNORADIUSDMG = true;
            let misl = BossPyroThinker(new("BossPyroThinker"));
            if(misl)
            {
                misl.missile = e.Thing;
                misl.power = e.Thing.Target.CountInv("bossabilitygiver_pyro");
            }
        }
        if( e.Thing && e.Thing.bMISSILE && e.Thing.Target && e.Thing.Target.Target && e.Thing.Target.CountInv("bossabilitygiver_homing") )
        {
            e.Thing.bSEEKERMISSILE = true;
            let misl2 = BossHomingThinker(new("BossHomingThinker"));
            if(misl2)
            {
                misl2.missile = e.Thing;
                e.Thing.tracer = e.Thing.Target.Target;
                misl2.power = e.Thing.Target.CountInv("bossabilitygiver_homing");
            }
        }
        if(level.time > 1) return;
        if( e.Thing && e.Thing.bISMONSTER && IsBoss(e.Thing) && e.Thing.Health > 0 && e.Thing.Radius > 0 )
        {
            if( e.Thing.speed == 0 && e.Thing.health == 1000 && e.Thing.height == 16 && e.Thing.radius == 20) {}
            else
            {
                if(!bossFound)
                {
                    bossFound = true;
                    let bossy = bossController(new("bossController"));
                    if(bossy)
                    {
                        bossy.boss = e.Thing;
                        bossy.level = currentboss;
                    }
                }
                else
                {
                    e.Thing.ClearCounters();
                    e.Thing.Destroy();
                }
            }
        }
        else if( e.Thing && e.Thing.bISMONSTER && e.Thing.Radius > 0 && !e.Thing.bFRIENDLY)
        {
            if(e.Thing.Health < SMAXHEALTH)
            {
            BossSummonSpot mpos = BossSummonSpot(Actor.Spawn('BossSummonSpot', e.Thing.pos));
            mpos.MonsterClass = e.Thing.getClassName();
            }
            e.Thing.ClearCounters();
            e.Thing.Destroy();
        }
    }
    Override void WorldThingDamaged(WorldEvent e)
    {
        if(!bossEnabled) return;
        if(e.thing && e.thing.bISMONSTER && e.thing.bSKULLFLY && e.thing.CountInv("bossabilitygiver_boss"))
        {
            if(random(0,5) == 0)
            {
                e.thing.A_SkullAttack();
            }
            else
            {
                e.thing.VelFromAngle(20);
            }
        }
        if(e.thing && e.thing.bISMONSTER && e.thing.CountInv("bossabilitygiver_deflection") && e.DamageSource && e.Inflictor && !e.Inflictor.bMISSILE)
        {
            ThinkerIterator BossFinder = ThinkerIterator.Create("bossController");
            bossController mo;
            int ang;
            while(mo = bossController(BossFinder.Next()))
            {
                ang=mo.boss.AngleTo(e.DamageSource);
                if(e.thing.CountInv("bossabilitygiver_deflection")==3)
                {
                    ang=ang+random(-10,10);
                }
                else if(e.thing.CountInv("bossabilitygiver_deflection")==2)
                {
                    ang=ang+random(-45,45);
                }
                else if(e.thing.CountInv("bossabilitygiver_deflection")==1)
                {
                    ang=ang+random(-60,60);
                    if(ang > -5 && ang < 0) {ang=-5;}
                    if(ang < 5 && ang > 0) {ang=5;}
                }
                mo.SpawnMarkedProjectile("BossBDeflect",ang);
            }
        }
    }
    override void WorldTick()
    {
        if(!bossEnabled) return;
        if(!bossfound && level.time > 1 && level.time < 10)
        {
            console.PrintF("Trying fallback method to detect boss thing");
            ThinkerIterator Fallback = ThinkerIterator.Create("Actor");
            Actor findme;
            while (findme = Actor(Fallback.Next()))
            {
                if( findme && findme.bISMONSTER && IsBoss(findme) )
                {
                    bossFound = true;
                    let bossy = bossController(new("bossController"));
                    if(bossy)
                    {
                        bossy.boss = findme;
                        bossy.level = currentboss;
                    }
                    console.PrintF("Fallback detection successful");
                    Break;
                }
            }
            if(!bossfound) { console.PrintF("Fallback detection failed..."); }
        }
    }
    override void RenderOverlay(RenderEvent event)
    {
        if(!bossEnabled) return;
        if (level.time == 10 && !bossfound)
        {
            console.PrintF("There has been a problem spawning a boss!");
        }
        BOSSHPBAR
    }
}

class bossController : thinker
{
    actor boss;
    bool bossactive;
    bool bossdead;
    int ending;
    int summoncd;
    int phase;
    int teleportcd;
    int pcirclecd;
    state prevState;
    int level;
    int bossdelay;
    string FProj;
    string LProj;
    int prevhealth;
    int reflect;
    bool spooky;
    static const class<inventory> abil[] =
    {
        TRAITS
    };
    static const class<inventory> abilstart[] =
    {
        TRAITX
    };
    static const class<inventory> abilstart2[] =
    {
        TRAITZ
    };
    static const int bosshealth[] =
    {
        BHEALTH
    };
    static const int bosssummon[] =
    {
        BSUMMON
    };
    static const string type[] =
    {
        BTYPE
    };
    int ActivateSpawners(int count, int radius)
    {
        ThinkerIterator SpotFinder = ThinkerIterator.Create("BossSummonSpot");
        BossSummonSpot mo;
        while (mo = BossSummonSpot(SpotFinder.Next()))
        {
            if(mo && boss.Distance2D(mo) < radius)
            {
                if(count>0)
                {
                    count--;
                    mo.Activated=true;
                }
            }
        }
        return count;
    }
    void SpawnMarkedProjectile(string pclass, float angle)
    {
        let proj = boss.SpawnMissileAngle(pclass, angle, 0);
        if(proj) { proj.A_GiveInventory("bossabilitygiver_boss"); proj.tracer = boss.target; }
    }
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        if(boss)
        {
            if(boss.health < 300)
            {
                boss.PainChance*=0.5;
                boss.mass *= 2;
                boss.A_GiveInventory(abilstart2[level-1]);
                boss.DamageMultiply *= 2;
            }
            if(boss.health < 1000)
            {
                boss.PainChance*=0.5;
                boss.mass *= 2;
            }
            if(boss.Health < 2000)
            {
                if(boss.Radius<48)
                {
                    boss.scale *= 2;
                    boss.A_SetSize(boss.Radius*2, boss.Height*2, false);
                }
                else
                {
                    boss.scale *= 1.5;
                    boss.A_SetSize(boss.Radius*1.5, boss.Height*1.5, false);
                }
                if(type[level-1]=="melee")
                {
                    boss.meleerange*=2;
                }
                boss.bALWAYSFAST = true;
                boss.A_GiveInventory(abilstart[level-1]);
                boss.mass *= 1.5;
            }
            boss.Health = bosshealth[level-1];
            boss.starthealth = boss.health / G_SkillPropertyFloat(SKILLP_MonsterHealth);
            boss.bBOSS = true;
            boss.bNOTARGET = true;
            boss.bNOINFIGHTING = true;
            boss.bLOOKALLAROUND = true;
            boss.bTHRUSPECIES = true;
            boss.bQUICKTORETALIATE = true;
            boss.bAMBUSH = true;
            boss.Species = "IAmTheBoss";
            boss.SetTag(Stringtable.Localize(string.format("%s%i","$BOSS_NAME",level)));
            boss.PainChance*=0.5;
            boss.A_GiveInventory("bossabilitygiver_boss");
            pcirclecd = 400;
            teleportcd = 400;
        }
    }
    override void Tick()
    {
        super.Tick();
        if(bossactive && !bossdead && !boss)
        {
            bossdead = true;
            ThinkerIterator Fixer = ThinkerIterator.Create("Actor");
            Actor fixthefix;
            while (fixthefix = Actor(Fixer.Next()))
            {
                fixthefix.A_PrintBold(Stringtable.Localize(string.format("%s%i","$BOSS_DEATH",level)));
                fixthefix.A_Quake(6,150,0,2048);
                break;
            }
        }
        if(bossdead)
        {
            ending++;
        }
        if(ending==50||ending==85)
        {
            ThinkerIterator MobFinder = ThinkerIterator.Create("Actor");
            Actor mo;
            while (mo = Actor(MobFinder.Next()))
            {
                if(mo.bISMONSTER && !mo.bFRIENDLY)
                {
                    mo.A_Die();
                }
            }
        }
        BEXIT
        if(boss)
        {
            if(boss.starthealth < boss.health)
            {
                boss.starthealth = boss.health;
            }
            if(boss.CountInv("bossabilitygiver_spook") && !spooky && bossactive)
            {
                spooky = true;
                SpawnMarkedProjectile("BossSpook",0);
            }
            if(boss.CountInv("bossabilitygiver_deflection"))
            {
                if(boss.CountInv("bossabilitygiver_deflection") == 1 && reflect < 1)
                {
                    boss.bREFLECTIVE = true;
                    reflect++;
                }
                if(boss.CountInv("bossabilitygiver_deflection") == 2 && reflect < 2)
                {
                    boss.bMIRRORREFLECT = true;
                    reflect++;
                }
                if(boss.CountInv("bossabilitygiver_deflection") == 3 && reflect < 3)
                {
                    boss.bMIRRORREFLECT = false;
                    boss.bAIMREFLECT = true;
                    reflect++;
                }
            }
            if(boss.target && !bossactive)
            {
                if(!boss.CheckIfSeen() || boss.health < boss.starthealth)
                {
                    boss.bAMBUSH = false;
                    bossactive = true;
                    boss.A_PrintBold(Stringtable.Localize(string.format("%s%i","$BOSS_TAUNT",level)));
                    boss.A_Quake(6,60,0,2048);
                    MUSIC
                }
            }
            SUMCODE
            if(boss.health > 0 && boss.health < boss.starthealth*(0.3*(3-phase)))
            {
                boss.A_PlaySound(boss.SeeSound,CHAN_AUTO,1.0,false,ATTN_NONE);
                boss.A_GiveInventory(abil[((level-1)*3)+phase]);
                boss.A_Quake(6,60,0,2048);
                phase++;
            }
            if(boss.health < 1 && !bossdead)
            {
                boss.A_PrintBold(Stringtable.Localize(string.format("%s%i","$BOSS_DEATH",level)));
                boss.A_Quake(6,150,0,2048);
                bossdead = true;
            }
            if(boss.health > prevhealth)
            {
                prevhealth = boss.health;
            }
            if(boss.health < prevhealth && boss.health > 0)
            {
                prevhealth = boss.health;
                if(boss.CountInv("bossabilitygiver_dmgshot"))
                {
                    for(int i = 0; i < boss.CountInv("bossabilitygiver_dmgshot")*2; i++ )
                    {
                        if(FProj=="") { FProj = "CacodemonBall";}
                        SpawnMarkedProjectile(FProj,random(0,359));
                    }
                }
            }
            if(summoncd > 0)
            {
                summoncd--;
            }
            if(teleportcd > 0)
            {
                teleportcd--;
            }
            if(pcirclecd > 0)
            {
                pcirclecd--;
            }
            if(boss.health > 0 && boss.target && teleportcd == 0 && boss.CountInv("bossabilitygiver_teleport"))
            {
            if(boss.CountInv("bossabilitygiver_teleport")>1)
            {
            teleportcd = 200;
            }
            else if (boss.CountInv("bossabilitygiver_teleport")>2)
            {
            teleportcd = 60;
            }
            else
            {
            teleportcd = 800;
            }
            bossdelay=35;
            int maxstep = random(50,50*2);
            boss.A_SpawnItemEx("TeleportFog");
            boss.bJUMPDOWN = true;
            boss.bTHRUACTORS = true;
            boss.MaxDropOffHeight = 512;
            boss.MaxStepHeight = 512;
            boss.A_SetAngle(boss.angle+randompick(-90,-45,0,+45,+90));
            for(int i = 0; i < maxstep; i++)
                {
                boss.A_Chase(null, null,CHF_NORANDOMTURN);
                boss.A_SpawnItemEx("TeleportFog",random(-32,32),random(-32,32),random(0,64));
                }
            boss.bJUMPDOWN = boss.default.bJUMPDOWN;
            boss.bTHRUACTORS = boss.default.bTHRUACTORS;
            boss.MaxDropOffHeight = boss.default.MaxDropOffHeight;
            boss.MaxStepHeight = boss.Default.MaxStepHeight;
            boss.A_SpawnItemEx("TeleportFog");
            }
            if(boss.health > 0 && boss.target && pcirclecd == 0 && boss.CountInv("bossabilitygiver_pcircle"))
            {
            if(boss.CountInv("bossabilitygiver_pcircle")>1)
            {
            pcirclecd = 250;
            }
            else if (boss.CountInv("bossabilitygiver_pcircle")>2)
            {
            pcirclecd = 50;
            }
            else
            {
            pcirclecd = 500;
            }
            if(FProj=="") { FProj = "CacodemonBall";}
            for(int i = 0; i < 18; i++)
            {
                SpawnMarkedProjectile(FProj,i*20);
            }
            }
            if(bossdelay > 0)
            {
                boss.bJUSTATTACKED = true;
                bossdelay--;
            }
            if(boss.health > 0 && boss.CountInv("bossabilitygiver_speed"))
            {
            double multi;
            if(boss.CountInv("bossabilitygiver_speed")>1)
            {
            multi=2.0;
            }
            else if (boss.CountInv("bossabilitygiver_speed")>2)
            {
            multi=3.0;
            }
            else
            {
            multi=1.5;
            }
            if (prevState != boss.curState)
            { boss.A_SetTics (boss.tics / multi); }
            prevState = boss.curState;
            }
        }
    }
}

class BossPyroThinker : Thinker
{
    actor missile;
    int power;
    int fx;
    override void Tick()
    {
        super.Tick();
        if(fx>0)
        {
            fx--;
        }
        if(missile && fx==0)
        {
            missile.A_SpawnItemEx("BossPyroFire", flags:SXF_NOCHECKPOSITION);
            fx=5;
        }
        if(missile && missile.InStateSequence(missile.CurState, missile.ResolveState("Death")))
        {
            actor fire;
            BossPyroSpreadFire truefire;
            bool fireb;
            [fireb, fire] = missile.A_SpawnItemEx("BossPyroSpreadFire", xofs:-24, flags:SXF_NOCHECKPOSITION);
            If(fire)
            {
                truefire = BossPyroSpreadFire(fire);
                truefire.power = power;
                truefire.scale *= power;
            }
            missile.A_Explode(missile.GetMissileDamage(7,1)/2,128);
            missile.A_PlaySound("weapons/rocklx");
            self.Destroy();
        }
        if(!missile)
        {
            self.Destroy();
        }
    }
}

class BossHomingThinker : Thinker
{
    actor missile;
    int power;
    int fx;
    override void Tick()
    {
        super.Tick();
        if(fx>0)
        {
            fx--;
        }
        if(missile && fx==0)
        {
            missile.A_SpawnItemEx("RevenantTracerSmoke", zvel:1, flags:SXF_NOCHECKPOSITION);
            fx=2;
            if(missile && !missile.InStateSequence(missile.CurState, missile.ResolveState("Death")))
            {
                missile.A_SeekerMissile(1,3*power);
            }
        }
        if(!missile)
        {
            self.Destroy();
        }
    }
}

class BossRicochetThinker : Thinker
{
    actor missile;
    int power;
    override void Tick()
    {
        super.Tick();
        if(missile && missile.target && missile.InStateSequence(missile.CurState, missile.ResolveState("Death")))
        {
            let proj = missile.SpawnMissileAngleZ(missile.pos.z, "BossBDeflect", -missile.angle+random(-45,45), 0);
            if(proj)
            {
                proj.A_GiveInventory("bossabilitygiver_boss");
                proj.target = missile.target;
                proj.bBOUNCEONWALLS = true;
                proj.bBOUNCEONFLOORS = true;
                proj.bouncefactor = 0.99;
                proj.WallBounceFactor = 0.99;
                proj.bouncecount = 2;
                if( power == 2 )
                {
                    proj.WallBounceFactor = 1.1;
                    proj.bouncecount = 8;
                }
                else if( power == 3 )
                {
                    proj.WallBounceFactor = 1.2;
                    proj.bouncecount = 19;
                }
            }
            self.Destroy();
        }
        if(!missile)
        {
            self.Destroy();
        }
    }
}

class BossPyroFire : Actor
{
    Default
    {
        +NOBLOCKMAP +NOGRAVITY +ZDOOMTRANS
        RenderStyle "Add";
        Alpha 0.5;
        Scale 0.5;
    }
    States
    {
    Spawn:
        FIRE ABABCBCBCDCDCDEDEDEFEFEFGHGHGH 1 BRIGHT;
        Stop;
    }
}
class BossPyroSpreadFire : BossPyroFire
{
    int dmgcd;
    int power;
    Default
    {
        Scale 2.0;
    }
    States
    {
    Spawn:
        FIRE ABABCBCBCDCDCDEDEDEFEFEFGHGHGH 2 BRIGHT A_SetTics(1+2*power);
        Stop;
    }
    override void Tick()
    {
        super.Tick();
        if(dmgcd==0)
        {
            dmgcd=10;
            A_Explode(1+2*power,96+(32*power));
        }
        else
        {
            dmgcd--;
        }
    }
}

class BossBDeflect : Actor
{
    Default
    {
        Radius 6;
        Height 8;
        Speed 20;
        Damage 3;
        Projectile;
        RenderStyle "Add";
        Alpha 1;
    }
    States
    {
    Spawn:
        PUFF A 4 BRIGHT;
        Loop;
    Death:
        PUFF BCDE 6 BRIGHT;
        Stop;
    }
}

class BossSpook : Actor
{
    int power;
    Default
    {
        +NOBLOCKMAP +NOGRAVITY +DROPOFF +NOCLIP +SEEKERMISSILE
        Radius 6;
        Height 8;
        Speed 5;
        Damage 3;
        Projectile;
        RenderStyle "Add";
        Alpha 0.5;
        Scale 1.5;
    }
    States
    {
    Spawn:
        SKUL CD 4 BRIGHT;
        Loop;
    Death:
        SKUL FGHIJK 6 BRIGHT;
        Stop;
    }
    override void Tick()
    {
        super.Tick();
        if(target && target.health > 0)
        {
            power = target.CountInv("bossabilitygiver_spook");
            tracer = target.target;
            A_Explode(1,32,0,0,32);
            A_SeekerMissile(1,3*power);
            Speed=8+(3*(power-1));
        }
        else
        {
            if(power < 4)
            {
                SetState(FindState("Death",true));
                power = 4;
            }
        }
    }
}

class bossabilitygiver : Inventory
{
    default
    {
    +INVENTORY.UNDROPPABLE;
    +INVENTORY.UNTOSSABLE;
    Inventory.maxAmount 3;
    }
}

class BossSummonSpot : Actor
{
    string MonsterClass;
    bool Activated;
    Default { +NOINTERACTION }
    override void Tick()
    {
        super.Tick();
        if(Activated)
        {
            actor mon;
            bool done;
            [done, mon] = self.A_SpawnItemEx(MonsterClass);
            if(mon)
            {
                mon.bNOTARGET = 1;
                mon.bLOOKALLAROUND = 1;
            }
            SpawnTeleportFog(self.pos,0,0);
            Activated = false;
        }
    }
}

BOSSDROP

//special
class bossabilitygiver_nothing : bossabilitygiver { }
class bossabilitygiver_boss : bossabilitygiver { }
//passive
class bossabilitygiver_speed : bossabilitygiver { }
class bossabilitygiver_dmgshot : bossabilitygiver { }
class bossabilitygiver_deflection : bossabilitygiver { }
class bossabilitygiver_spook : bossabilitygiver { }
//major cooldown
class bossabilitygiver_teleport : bossabilitygiver { }
class bossabilitygiver_pcircle : bossabilitygiver { }
//projectile only
class bossabilitygiver_spread : bossabilitygiver { }
class bossabilitygiver_pyro : bossabilitygiver { }
class bossabilitygiver_bounce : bossabilitygiver { }
class bossabilitygiver_homing : bossabilitygiver { }
]],
  LVL = [[if(level.LevelNum == NUM)
        {
            bossEnabled = true;
            currentboss = CNT;
        }
]],
  MUS = [[S_ChangeMusic(string.format("%%s%%i","d_boss",level), 0, true, false);]],
  SUM = [[if(boss.health > 0 && boss.health < boss.starthealth*0.75 && summoncd == 0)
            {
                summoncd = self.bosssummon[level-1];
                int count = 5;
                int leftover = ActivateSpawners(count,512);
                if(leftover>0)
                {
                    ActivateSpawners(leftover,1024);
                }
            }
]],
  EXNORMAL = [[if(ending>350)
        {
            Exit_Normal(0);
        }
]],
  EXITEM = [[if(ending==100)
            {
                if(boss)
                {
                    boss.A_SpawnItemEx("TeleportFog", flags:SXF_NOCHECKPOSITION);
                    boss.A_SpawnItemEx("BossExiter", flags:SXF_NOCHECKPOSITION);
                }
                else
                {
                    ThinkerIterator Exiter = ThinkerIterator.Create("BossSummonSpot");
                    BossSummonSpot fixexit;
                    while (fixexit = BossSummonSpot(Exiter.Next()))
                    {
                        fixexit.A_SpawnItemEx("TeleportFog", flags:SXF_NOCHECKPOSITION);
                        fixexit.A_SpawnItemEx("BossExiter", flags:SXF_NOCHECKPOSITION);
                        break;
                    }
                }
            }
]]
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TAUNTS =
{
  -- Scionox
  ["YOU CANNOT HANDLE THE POWER OF THE INFINITE HELL"] = 50,
  ["YOU ARE DOOMED!"] = 50,

  -- MSSP
  ["YOUR SOUL WILL BE MINE"] = 50,
  ["AH. FRESH MEAT"] = 50,
  ["HELL IS INFINITE"] = 50,
  ["WE ARE LEGION"] = 50,

  ["SHED THE BLOOD OF THE INNOCENTS"] = 50,
  ["DARKNESS REIGNS"] = 50,
  ["YOUR HEAD MAKES A FINE TROPHY"] = 50,
  ["I WILL FEAST ON YOUR SOUL"] = 50,
  ["I WILL PLAY HOPSCOTCH ON YOUR CHEST CAVITY"] = 50,

  ["I SACRIFICE THEE TO THE BURNING VOID"] = 50,
  ["THY FLESH CONSUMED. THY SOUL DEVOURED."] = 50,
  ["GAZE UPON THE ABYSS, MORTAL"] = 50,
  ["I AM THE END OF ALL THINGS"] = 50,
  ["I WILL DRAG YOUR ENTRAILS INTO THE DARK AETHER"] = 50,

  ["ALL DEMONS SERVE. ALL MEN DIE."] = 50,
  ["I HAVE COME FOR HELL'S BOUNTY UPON YOU"] = 50,
  ["BEG FOR YOUR LIFE, MORTAL"] = 50,
  ["ANGELS FEAR WHERE I TREAD AND SO WILL YOU"] = 50,
  ["YOU WILL FIND ONLY DEATH HERE, MORTAL"] = 50,

  ["DOOMSLAYER! HELL REVEALS ITSELF TO YOU!"] = 50,
  ["WHO DARES ENTER MY REALM?"] = 50,
  ["YOU ARE NO HERO, MORTAL. HELL IS INFINITE"] = 50,
  ["I WILL DESTROY EVERYTHING YOU HAVE EVER LOVED"] = 50,
  ["WE FINALLY MEET, DOOMSLAYER"] = 50,

  ["STEP INTO THE FOLD. I WILL UNMAKE YOU"] = 50,
  ["THE END OF YOU IS REVEALED"] = 50,
  ["TO BEAT THE GAME, YOU MUST BEAT ALL OF HELL, DOOMSLAYER"] = 50,
  ["SUFFER ME NOW"] = 50,
  ["YOU CREATED ME, MORTAL. YOU TRULY HAVE"] = 50,

  ["I WILL BREAK YOU LIKE A WISHBONE"] = 50,
  ["I CANNOT WAIT TO WEAR YOU FLESH, DOOMSLAYER!"] = 50,
  ["I HUNGER."] = 50,
  ["I THIRST FOR MORTAL FLESH AND BLOOD"] = 50,
  ["THE DEATH OF ALL THINGS IS NIGH"] = 50,

  ["YOU ARE BUT A MORTAL IN THE WRONG PLACE. I WILL SHOW YOU WHY."] = 50,
  ["THIS IS NO PLACE FOR A HERO"] = 50,
  ["NO GODS OR KINGS. ONLY HELL AND BEYOND."] = 50,
  ["THE WORLD FEARS ITS INEVITABLE DEMISE. AND ME."] = 50,
  ["THERE IS NO SALVATION FOR THE WICKED. YOU AND ME."] = 50,

  ["LONG WILL BE YOUR SUFFERING. JOYOUS WILL BE YOUR PAIN."] = 50,
  ["I AM THE DESTROYER OF WORLDS."] = 50,
  ["I WILL ANOINT MY BLADES WITH YOUR BLOOD"] = 50,
  ["A LITTLE FLEA. I AM INCLINED TO SCRATCH."] = 50,
  ["FOOLISH CUR. THE DARKNESS SURROUNDS YOU."] = 50,

  ["THE WORLD BURNS AND YOU WILL BE AMONG THE ASHES"] = 50,

  ["I wasn't supposed to be here today"] = 10, -- rare
  ["You wanna go, bro? You wanna go?"] = 10, -- rare
  ["Never gonna give you up, never gonna let you down"] = 10, --rare

  -- Beed28,
  ["A MAN LIKE YOU IS NOTHING BUT A MISERABLE PILE OF SECRETS"] = 50,
  ["WELCOME... TO DIE!"] = 50,

  -- Craneo
  ["GREETINGS, MORTAL. ARE YOU READY TO DIE?"] = 50,
  ["WE HAVE SUCH SIGHTS TO SHOW YOU"] = 50,
  ["WE WILL TEAR YOUR SOUL APART"] = 50,
  ["YOUR SUFFERING WILL BE LEGENDARY, EVEN IN HELL!"] = 50,

  ["PAIN HAS A FACE. I WILL SHOW IT TO YOU."] = 50,
  ["WELCOME TO YOUR DEATH, MORTAL!"] = 50,
  ["DID YOU HOPE TO ACCOMPLISH ANYTHING BY COMING HERE?"] = 50,
  ["ONLY SUFFERING AND PAIN AWAITS YOU FURTHER ON"] = 50,
  ["YOUR JOURNEY IS FUTILE. YOU WILL DIE AND YOU SOUL WILL BE MINE."] = 50,

  ["THERE IS NO ESCAPE"] = 50,
  ["DEATH IS NOT YOUR END. YOUR SOUL WILL BURN IN HELL FOREVER."] = 50,
  ["EVERY STEP TAKEN BRINGS YOUR SOUL CLOSER TO ME"] = 50,

  ["IT WAS ME WHO RUINED THE TOILETS!!!"] = 10, -- rare
  ["Giggity"] = 10, -- rare

  -- Tapwave
  ["YOU WILL NEVER FIND WHAT YOU SEEK. IT IS TRAPPED IN HELL FOREVER."] = 50,

  -- Demios
  ["YOU? HERE?! ARGH! INCOMPETENTS ALL OF THEM!"] = 50,
  ["WHEN I'M DONE WITH YOU, I WILL SEE TO YOUR ETERNAL SUFFERING"] = 50,
  ["YOU DARE INTERFERE, MORTAL?"] = 50,
  ["YOU WILL RELIVE THIS NIGHTMARE FOREVER"] = 50,

  -- EpicTyph
  ["SMASH. TIME TO SMASH!"] = 50,
  ["YOUR KIND ARE OVER"] = 50,

  -- Mogwaltz
  ["HOW MANY OF YOUR MISBEGOTTEN KIND I MUST SQUASH?"] = 50,

  -- Frozsoul
  ["ALL YOUR BASE ARE BELONG TO US"] = 10, -- rare

  -- retxirT
  ["WHY MUST I DO EVERYTHING MYSELF?"] = 50,
  ["YOUR STAY OF EXECUTION IS OVER. I HAVE COME TO DELIVER."] = 50,
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.DEATHS =
{
  -- Scionox
  ["NOOOO, I SHALL RETURN!!!"] = 50,
  ["NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!"] = 50,

  -- MSSP
  ["GRAAAAAHHH!!"] = 50,
  ["GRRRRHHHHH!"] = 50,
  ["THIS IS NOT THE END, MORTAL"] = 50,
  ["THIS IS NOT OVER, MORTAL"] = 50,
  ["HELL WILL NOT FORGIVE"] = 50,

  ["HELL'S CHAMPIONS SHALL RISE WHERE I FALL"] = 50,
  ["DESTROYING ME DOES NOT DESTROY HELL"] = 50,
  ["HELL STILL REIGNS ETERNAL"] = 50,
  ["THERE WILL BE MORE COMING YOUR WAY, MORTAL"] = 50,

  ["And I thought I was retiring tomorrow"] = 5,
  ["MY LUNCH!"] = 5,

  -- Craneo
  ["CURSE YOU AND YOUR DESCENDANTS!"] = 50,
  ["NOT EVEN THE PITS OF HELL WILL CONTAIN MY REVENGE"] = 50,
  ["YOU ARE NOW WORTHY OF FIGHTING MY MASTER"] = 50,
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TRAITS =
{
  SPEED =
  {
    name = '"bossabilitygiver_speed"',
    probmisl = 60,
    probscan = 0,
    probmele = 90,
    difffact = 1.1,
    mislfact = 1.1,
    mindiff = -1,
  },

  DMGSHOT =
  {
    name = '"bossabilitygiver_dmgshot"',
    probmisl = 50,
    probscan = 40,
    probmele = 50,
    difffact = 1.2,
    mislfact = 1.3,
    mindiff = 1,
  },

  TELEPORT =
  {
    name = '"bossabilitygiver_teleport"',
    probmisl = 50,
    probscan = 50,
    probmele = 80,
    difffact = 1.1,
    mislfact = 1.1,
    mindiff = -1,
  },

  PCIRCLE =
  {
    name = '"bossabilitygiver_pcircle"',
    probmisl = 50,
    probscan = 40,
    probmele = 60,
    difffact = 1.1,
    mislfact = 1.3,
    mindiff = -1,
  },

  SPREAD =
  {
    name = '"bossabilitygiver_spread"',
    probmisl = 30,
    probscan = 0,
    probmele = 0,
    difffact = 1.0,
    mislfact = 1.6,
    mindiff = -1,
  },

  PYRO =
  {
    name = '"bossabilitygiver_pyro"',
    probmisl = 50,
    probscan = 0,
    probmele = 0,
    difffact = 1.0,
    mislfact = 1.3,
    mindiff = -1,
  },

  BOUNCE =
  {
    name = '"bossabilitygiver_bounce"',
    probmisl = 40,
    probscan = 0,
    probmele = 0,
    difffact = 1.0,
    mislfact = 1.4,
    mindiff = 1,
  },

  HOMING =
  {
    name = '"bossabilitygiver_homing"',
    probmisl = 50,
    probscan = 0,
    probmele = 0,
    difffact = 1.0,
    mislfact = 1.4,
    mindiff = -1,
  },

  DEFLECTION =
  {
    name = '"bossabilitygiver_deflection"',
    probmisl = 20,
    probscan = 30,
    probmele = 40,
    difffact = 1.3,
    mislfact = 1.1,
    mindiff = 1,
  },

    SPOOK =
  {
    name = '"bossabilitygiver_spook"',
    probmisl = 40,
    probscan = 40,
    probmele = 30,
    difffact = 1.2,
    mislfact = 1.2,
    mindiff = 2,
  },
}

function PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.game_specific_hpbar()
    if OB_CONFIG.game == "heretic" then
     PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TEMPLATES.BAR = [[if(bossFound)
        {
        ThinkerIterator BossFinder = ThinkerIterator.Create("bossController");
        bossController mo;
        while (mo = bossController(BossFinder.Next()))
        {
            if(mo.boss && mo.bossactive && !mo.bossdead)
            {
            int bars = (mo.boss.health * 20) / mo.boss.starthealth;
            string barsx;
            for(int i = 0; i<bars; i++)
            {
                barsx.AppendFormat("1");
            }
            string name = Stringtable.Localize(string.format("%%s%%i","$BOSS_NAME",currentboss));
            string bosshp = string.format("%%s %%s %%s", name, "\n", barsx);
            if(name.length()>32)
            {
                if(name.length()>41)
                {
                    screen.DrawText(SmallFont, Font.CR_RED, -92, -32, bosshp, DTA_Clean, true);
                }
                else
                {
                    screen.DrawText(BigFont, Font.CR_RED, -92, -32, bosshp, DTA_Clean, true);
                }
            }
            else
            {
                screen.DrawText(BigFont, Font.CR_RED, 32, -32, bosshp, DTA_Clean, true);
            }
            }
        }
        }
]]
    else
     PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TEMPLATES.BAR = [[if(bossFound)
        {
        ThinkerIterator BossFinder = ThinkerIterator.Create("bossController");
        bossController mo;
        while (mo = bossController(BossFinder.Next()))
        {
            if(mo.boss && mo.bossactive && !mo.bossdead)
            {
            int bars = (mo.boss.health * 20) / mo.boss.starthealth;
            string barsx;
            for(int i = 0; i<bars; i++)
            {
                barsx.AppendFormat("I");
            }
            string name = Stringtable.Localize(string.format("%%s%%i","$BOSS_NAME",currentboss));
            string bosshp = string.format("%%s %%s %%s", name, "\n", barsx);
            if(name.length()>32)
            {
                if(name.length()>41)
                {
                    screen.DrawText(SmallFont, Font.CR_RED, -92, -32, bosshp, DTA_Clean, true);
                }
                else
                {
                    screen.DrawText(BigFont, Font.CR_RED, -92, -32, bosshp, DTA_Clean, true);
                }
            }
            else
            {
                screen.DrawText(BigFont, Font.CR_RED, 32, -32, bosshp, DTA_Clean, true);
            }
            }
        }
        }
]]
    end
end

function PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.grab_random_taunt()
  return rand.key_by_probs(PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TAUNTS)
end

function PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.grab_random_death()
  return rand.key_by_probs(PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.DEATHS)
end

function PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.grab_random_trait(btype, etraits)
  local traits = {}

  for name,info in pairs(PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TRAITS) do

  local tprob
    local stack = 0

  if btype == "melee" and info.probmele > 0 then
    tprob = info.probmele
    tprob = tprob * (((info.difffact-1.0) * PARAM.boss_gen_tmult)+1)
  elseif btype == "hitscan" and info.probscan > 0 then
    tprob = info.probscan
    tprob = tprob * (((info.difffact-1.0) * PARAM.boss_gen_tmult)+1)
  elseif btype == "missile" and info.probmisl > 0 then
    tprob = info.probmisl
    tprob = tprob * (((info.mislfact-1.0) * PARAM.boss_gen_tmult)+1)
  end

  if(info.mindiff>PARAM.boss_gen_tmult) then
      tprob = 0
  end

  if etraits ~= nil then
    for etrait,einfo in pairs(etraits) do
        if einfo == info.name then
          stack = stack + 1
        if PARAM.boss_gen_tmult < 0 then
          tprob = math.floor(tprob * 0.25)
        elseif PARAM.boss_gen_tmult > 1 then
          tprob = tprob * 2
        end
        end
    end

      if stack == 3 then
        tprob = 0
      end
    end

  if tprob == nil then tprob = 0 end
    traits[info.name] = tprob
  end

  local trait = rand.key_by_probs(traits)

  return trait
end

function PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.syntaxize(str, str2)
  local final
  if str == "" then
    final = str .. str2
  else
    final = str .. ",\n" .. str2
  end
  return final
end

function PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.check_monsters_enabled()
  if PARAM.float_mons == 0 and PARAM.bool_boss_gen == 1 then
    error("Monsters must be enabled for boss generator!")
  end
end

function PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.end_lvl(self, LEVEL)

  if PARAM.bool_boss_gen == 1 then

  if LEVEL.is_procedural_gotcha then
    local scripty = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TEMPLATES.LVL

    local id

    if ob_match_game({game = {doom2=1, hacx=1}}) then
        id = LEVEL.id
    else
      if OB_CONFIG.length == "single" or OB_CONFIG.length == "few" then
        id = LEVEL.id
      else
        id = 10 * (LEVEL.episode.ep_index - 1) + math.round(PARAM.episode_length * LEVEL.ep_along)
      end
    end

    scripty = string.gsub(scripty, "NUM", id)
    scripty = string.gsub(scripty, "CNT", PARAM.boss_count)

    PARAM.lvlstr = PARAM.lvlstr .. scripty .. "\n"

    if PARAM.story_generator == "proc" then
      if OB_CONFIG.length == "single" then
        if LEVEL.id == 1 then table.insert(PARAM.epi_bosses,PARAM.boss_count) end
      elseif OB_CONFIG.length == "few" then
        if LEVEL.id == 4 then table.insert(PARAM.epi_bosses,PARAM.boss_count) end
      elseif OB_CONFIG.length == "episode" then
        if LEVEL.id == 11 then table.insert(PARAM.epi_bosses,PARAM.boss_count) end
      elseif OB_CONFIG.length == "game" then
        if LEVEL.id == 11 or LEVEL.id == 20 or LEVEL.id == 30 then
        table.insert(PARAM.epi_bosses,PARAM.boss_count) end
      end
    end

    PARAM.boss_count = PARAM.boss_count + 1
  end

  end

end

function PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.boss_info(self, info)
  local btype = {}

  btype.attack = info.attack
  btype.health = info.health

  table.insert(PARAM.boss_types, btype)
end

function PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.all_done()

  if PARAM.bool_boss_gen == 1 then

  local scripty = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TEMPLATES.ZSC
  local btrait = ""
  local btrait2 = ""
  local btrait3 = ""
  local bhealth = ""
  local bsummon = ""
  local btype = ""

  if PARAM.boss_count <= 1 then
    -- nothing happens and everyone is just sad
    warning("No procedural gotchas found by boss generator")
    PARAM.boss_count = -1
    return
  end

  if PARAM.float_mons == 0 then
    -- no monsters, no boss, duh
    warning("No monsters found by boss generator")
    PARAM.boss_count = -1
    return
  end

  scripty = string.gsub(scripty, "LEVELCODE", PARAM.lvlstr)

  if ob_match_game({game = "doomish"}) then
    scripty = string.gsub(scripty, "BOSSDROP", PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_DROPS.doomish)
  elseif OB_CONFIG.game == "heretic" then
    scripty = string.gsub(scripty, "BOSSDROP", PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_DROPS.heretic)
  elseif OB_CONFIG.game == "hacx" then
    scripty = string.gsub(scripty, "BOSSDROP", PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_DROPS.hacx)
  else
    scripty = string.gsub(scripty, "BOSSDROP", PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_DROPS.doomish)
  end

  if PARAM.bool_boss_gen_hpbar == 1 then
    PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.game_specific_hpbar()
    scripty = string.gsub(scripty, "BOSSHPBAR", PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TEMPLATES.BAR)
  else
    scripty = string.gsub(scripty, "BOSSHPBAR", "")
  end

  if PARAM.bool_boss_gen_music == 1 then
    scripty = string.gsub(scripty, "MUSIC", PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TEMPLATES.MUS)
  else
    scripty = string.gsub(scripty, "MUSIC", "")
  end

  if PARAM.boss_gen_reinforce ~= "none" then
    scripty = string.gsub(scripty, "SUMCODE", PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TEMPLATES.SUM)
  else
    scripty = string.gsub(scripty, "SUMCODE", "")
  end

  if PARAM.boss_gen_reinforce == "nightmare" then
    scripty = string.gsub(scripty, "SMAXHEALTH", "10000")
  else
    scripty = string.gsub(scripty, "SMAXHEALTH", "1000")
  end

  if PARAM.boss_gen_exit == "item" then
    scripty = string.gsub(scripty, "BEXIT", PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TEMPLATES.EXITEM)
  else
    scripty = string.gsub(scripty, "BEXIT", PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.TEMPLATES.EXNORMAL)
  end

  for name,info in pairs(PARAM.boss_types) do
    local bhp = info.health
    local batk = info.attack
    local traitstack = {}
    local ttrait

    if(boss_trait_diff == "harder" or (boss_trait_diff == "default" and rand.odds(50))) then
      ttrait = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.grab_random_trait(batk,traitstack)
      table.insert(traitstack, ttrait)
      btrait2 = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.syntaxize(btrait2,ttrait)
    else
      btrait2 = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.syntaxize(btrait2,'"bossabilitygiver_nothing"')
    end

    if(boss_trait_diff == "nightmare") then
      ttrait = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.grab_random_trait(batk,traitstack)
      table.insert(traitstack, ttrait)
      btrait3 = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.syntaxize(btrait3,ttrait)
    else
      btrait3 = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.syntaxize(btrait3,'"bossabilitygiver_nothing"')
    end

    for i = 0,2,1 do
      ttrait = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.grab_random_trait(batk,traitstack)
      table.insert(traitstack, ttrait)
      btrait = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.syntaxize(btrait,ttrait)
    end

    local batkx = "\"" .. batk .. "\""

    btype = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.syntaxize(btype,batkx)

    local mult
    local hpcalc

    if PARAM.boss_gen_diff == "nightmare" then
      mult=1.5
    else
      if bhp<300 then mult=1.5
      elseif bhp<1000 then mult=1.3
      elseif bhp<2000 then mult=1.1
      else mult=1.0 end
    end

    hpcalc = math.floor(rand.pick({5000,5200,5400,5600,5800,6000})*mult*PARAM.float_boss_gen_mult)

    if batk == "hitscan" and PARAM.boss_gen_dmult<3.0 then hpcalc = hpcalc*0.75 end

    bhealth = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.syntaxize(bhealth,hpcalc)

    local sumcalc

    sumcalc = math.floor(rand.pick({400,450,500,550,600})*PARAM.boss_gen_rmult)
    bsummon = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.syntaxize(bsummon,sumcalc)

  end

  scripty = string.gsub(scripty, "TRAITS", btrait)
  scripty = string.gsub(scripty, "TRAITX", btrait2)
  scripty = string.gsub(scripty, "TRAITZ", btrait3)
  scripty = string.gsub(scripty, "BHEALTH", bhealth)
  scripty = string.gsub(scripty, "BSUMMON", bsummon)
  scripty = string.gsub(scripty, "BTYPE", btype)

  PARAM.BOSSSCRIPT = PARAM.BOSSSCRIPT .. scripty
  PARAM.BOSSLANG = {}
  PARAM.boss_count = PARAM.boss_count - 1

  local cnt = 1

  for i = 1,PARAM.boss_count,1 do

    local demon_name
    if PARAM.story_generator == "proc" then
      for _,epiboss in pairs(PARAM.epi_bosses) do
        if i == epiboss then
          demon_name = PARAM.epi_names[cnt]
        cnt = cnt + 1
        end
      end
    end

    if demon_name == nil then
      demon_name = rand.key_by_probs(namelib.NAMES.GOTHIC.lexicon.e)
      demon_name = string.gsub(demon_name, "NOUNGENEXOTIC", namelib.generate_unique_noun("exotic"))

      -- sometimes add an honorific to add to the boss's evilness
      if rand.odds(50) then -- title
        demon_name = demon_name .. " the " .. rand.key_by_probs(GAME.STORIES.EVIL_TITLES)
      elseif rand.odds(25) then -- places
        demon_name = demon_name .. " of " .. Naming_grab_one("GOTHIC")
      end
    end

    local line = "BOSS_NAME" .. i .. ' = "' .. demon_name .. '";\n'
    table.insert(PARAM.BOSSLANG, line)

    local taunt = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.grab_random_taunt()
    line = "BOSS_TAUNT" .. i .. ' = "' .. demon_name .. ": " .. taunt .. '";\n'
    table.insert(PARAM.BOSSLANG, line)

    local dead = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.grab_random_death()
    line = "BOSS_DEATH" .. i .. ' = "' .. demon_name .. ": " .. dead .. '";\n'
    table.insert(PARAM.BOSSLANG, line)

  end

  end

end

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.GOTCHA_MAP_SIZES =
{
  "large", _("Large"),
  "regular", _("Regular"),
  "small", _("Small"),
  "tiny", _("Tiny")
}

PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.PROC_GOTCHA_CHOICES =
{
  "final", _("Final Map Only"),
  "epi",   _("Last Level of Episode"),
  "2epi",   _("Two per Episode"),
  "3epi",   _("Three per Episode"),
  "4epi",   _("Four per Episode"),
  "_",     _("_"),
  "5p",    _("5% Chance, Any Map After Map 4"),
  "10p",   _("10% Chance, Any Map After Map 4"),
  "all",   _("Everything")
}

function PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.setup(self)

  module_param_up(self)

  if PARAM.bool_boss_gen == 1 then

    PARAM.boss_types = {}
    PARAM.lvlstr = ""
    PARAM.BOSSSCRIPT = ""
    PARAM.boss_count = 1
    PARAM.epi_bosses = {}
    PARAM.epi_names = {}

    if PARAM.boss_gen_diff == "easier" then
      PARAM.boss_gen_dmult = -1.0
    elseif PARAM.boss_gen_diff == "default" then
      PARAM.boss_gen_dmult = 1.0
    elseif PARAM.boss_gen_diff == "harder" then
      PARAM.boss_gen_dmult = 2.0
    elseif PARAM.boss_gen_diff == "nightmare" then
      PARAM.boss_gen_dmult = 3.0
    end

    if PARAM.boss_trait_diff == "easier" then
      PARAM.boss_gen_tmult = -1.0
    elseif PARAM.boss_trait_diff == "default" then
      PARAM.boss_gen_tmult = 1.0
    elseif PARAM.boss_trait_diff == "harder" then
      PARAM.boss_gen_tmult = 2.0
    elseif PARAM.boss_trait_diff == "nightmare" then
      PARAM.boss_gen_tmult = 3.0
    end

    if PARAM.boss_gen_reinforcerate == "weakester" then
      PARAM.boss_gen_rmult = 4.0
    elseif PARAM.boss_gen_reinforcerate == "weakest" then
      PARAM.boss_gen_rmult = 2.0
    elseif PARAM.boss_gen_reinforcerate == "weaker" then
      PARAM.boss_gen_rmult = 1.5
    elseif PARAM.boss_gen_reinforcerate == "default" then
      PARAM.boss_gen_rmult = 1.0
    elseif PARAM.boss_gen_reinforcerate == "harder" then
      PARAM.boss_gen_rmult = 0.75
    elseif PARAM.boss_gen_reinforcerate == "tougher" then
      PARAM.boss_gen_rmult = 0.5
    elseif PARAM.boss_gen_reinforcerate == "serious" then
      PARAM.boss_gen_rmult = 0.25
    end

  end

end

OB_MODULES["procedural_gotcha_zdoom"] =
{

  name = "procedural_gotcha_zdoom",

  label = _("Procedural Gotchas"),

  port = "zdoom",
  where = "combat",
  priority = 92,

  hooks =
  {
    setup = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.setup,
    begin_level = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.check_monsters_enabled,
    end_level = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.end_lvl,
    all_done = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.all_done,
    boss_info = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.boss_info
  },

  tooltip=_("This module allows you to fine tune the Procedural Gotcha experience if you have Procedural Gotchas enabled. Does not affect prebuilts. It is recommended to pick higher scales on one of the two options, but not both at once for a balanced challenge."),

  options =
  {

    {
      name = "header_gotchaoptions",
      label = _("Regular Gotcha Options"),
    },

     {
      name="gotcha_frequency",
      label=_("Gotcha Frequency"),
      choices=PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.PROC_GOTCHA_CHOICES,
      default="final",
      tooltip = _("Procedural Gotchas are two room maps, where the second is an immediate but immensely-sized exit room with gratitiously intensified monster strength. Essentially an arena - prepare for a tough, tough fight!\n\nNotes:\n\n5% of levels may create at least 1 or 2 gotcha maps in a standard full game."),
      priority = 106,
      randomize_group="monsters",
      gap = 1
    },

    {
      name = "bool_gotcha_boss_fight",
      label=_("Force Big-Boss Fight"),
      valuator = "button",
      default = 1,
      tooltip = _("Attempts to guarantee a fight against a boss-type (nasty tier) monster in the procedural gotcha."),
      priority = 105,
      randomize_group="monsters",
      gap = 1
    },

    {
      name="float_gotcha_qty",
      label=_("Extra Quantity"),
      valuator = "slider",
      units = _("x Monsters"),
      min = 0.2,
      max = 10,
      increment = 0.1,
      default = 1.2,
      tooltip = _("Offset monster strength from your default quantity of choice plus the increasing level ramp. If your quantity choice is to reduce the monsters, the monster quantity will cap at a minimum of 0.1 (Scarce quantity setting)."),
      priority = 104,
      randomize_group="monsters",
    },

    {
      name="float_gotcha_strength",
      label=_("Extra Strength"),
      valuator = "slider",
      min = 0,
      max = 16,
      increment = 1,
      default = 4,
      presets = _("0:NONE,2:2 (Stronger),4:4 (Harder),6:6 (Tougher),8:8 (CRAZIER),16:16 (NIGHTMARISH)"),
      tooltip = _("Offset monster quantity from your default strength of choice plus the increasing level ramp."),
      priority = 103,
      randomize_group="monsters",
    },


    {
      name="gotcha_map_size",
      label=_("Map Size"),
      choices=PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.GOTCHA_MAP_SIZES,
      default = "small",
      tooltip = _("Size of the procedural gotcha. Start and arena room sizes are relative to map size as well."),
      priority = 102,
      randomize_group="monsters",
      gap = 1
    },

    {
      name = "header_bossoptions",
      label = _("ZScript Generated Boss Options"),
    },

    {
      name = "bool_boss_gen",
      label=_("Enable Procedural Bosses"),
      valuator = "button",
      default = 1,
      tooltip = _("Toggles Boss Monster generation with special traits for Gotchas."),
      priority = 101,
    },

    {
      name = "boss_gen_steepness",
      label = _("Arena Steepness"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.ARENA_STEEPNESS,
      default = "none",
      tooltip = _("Influences steepness settings for boss arenas. Boss arena steepness is capped to be less intrusive to boss movement."),
      priority = 99,
      gap = 1,
      randomize_group="monsters",
    },

    {
      name = "boss_gen_diff",
      label = _("Boss Tier"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_DIFF_CHOICES,
      default = "default",
      tooltip = _("Increases or reduces chances of boss being based off of a more powerful monster."),
      priority = 98,
      randomize_group="monsters",
    },

    {
      name = "boss_trait_diff",
      label = _("Boss Trait Strength"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_DIFF_CHOICES,
      default = "default",
      tooltip = _("Increases or reduces chances of boss getting more powerful traits."),
      priority = 98,
      randomize_group="monsters",
    },

    {
      name = "float_boss_gen_mult",
      label = _("Boss Health Multiplier"),
      tooltip = _("Makes boss health higher or lower than default, useful when playing with mods that have different average power level of weapons."),
      valuator = "slider",
      units = _("x"),
      min = 0.25,
      max = 5,
      increment = 0.25,
      default = 1,
      priority = 97,
      randomize_group="monsters",
    },


    {
      name = "boss_gen_hitscan",
      label = _("Hitscan Bosses"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_LESS_HITSCAN,
      default = "default",
      tooltip = _("Reduces chance of hitscan bosses spawning."),
      priority = 96,
      randomize_group="monsters",
    },


    {
      name = "bool_boss_gen_hpbar",
      label = _("Visible Health Bar"),
      valuator = "button",
      default = 1,
      tooltip = _("If enabled, an hp bar will appear on UI while boss is active."),
      priority = 95,
    },


    {
      name = "bool_boss_gen_music",
      label=_("Enable Boss Music"),
      valuator = "button",
      default = 0,
      tooltip = _("If enabled, encountering a boss will start boss theme music. (For now you have to have your own music files with lumps named D_BOSSx where x is boss number)"),
      priority = 94
    },


    {
      name = "boss_gen_reinforce",
      label = _("Reinforcement Strength"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.REINFORCE,
      default = "default",
      tooltip = _("Influences the strength of reinforcements summoned by bosses"),
      priority = 93,
      randomize_group="monsters",
    },


    {
      name = "boss_gen_reinforcerate",
      label = _("Reinforcement Rate"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.REINFORCER,
      default = "default",
      tooltip = _("Influences the spawn rate of reinforcements summoned by bosses"),
      priorty = 92,
      randomize_group="monsters",
    },


    {
      name = "bool_boss_gen_types",
      label = _("Respect zero prob"),
      priority = 96,
      valuator = "button",
      default = 0,
      tooltip = _("If enabled, monsters disabled in monster control module cant be chosen as a boss."),
      priorty = 91,
      gap = 1,
      randomize_group="monsters",
    },


    {
      name = "boss_gen_typelimit",
      label = _("Monster limit type"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_LIMITS,
      default = "softlimit",
      tooltip = _("Influences how boss difficulty and megawad progression affects the monster type of boss.\n\nHard Limit: Doesn't allow monster types outside of range to ever spawn.\n\nSoft Limit: Reduces the probability of spawning of monster types outside of range.\n\nNo Limit: Difficulty doesn't have effect on monster type selection."),
      priority = 90,
      randomize_group="monsters",
    },


    {
      name = "boss_gen_weap",
      label = _("Weapon placement"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_WEAP,
      default = "scatter",
      tooltip = _("Influences weapon placement in boss arena."),
      priority = 89,
      gap = 1,
      randomize_group="monsters",
    },


    {
      name = "boss_gen_exit",
      label = _("Exit type"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_ZDOOM.BOSS_EXIT,
      default = "default",
      tooltip = _("Changes exit type after boss has been destroyed."),
      priority = 88,
    },


    {
      name = "float_boss_gen_ammo",
      label = _("Ammo supplies mult"),
      valuator = "slider",
      units = _("x"),
      min = 1,
      max = 5,
      increment = 1,
      default = 3,
      tooltip = _("Changes multiplier of ammunition items on the boss arena(This is also affected by boss health multiplier)."),
      priority = 87,
      randomize_group="monsters",
    },


    {
      name = "float_boss_gen_heal",
      label = _("Healing supplies mult"),
      valuator = "slider",
      units = _("x"),
      min = 1,
      max = 5,
      increment = 1,
      default = 3,
      tooltip = _("Changes multiplier of healing items on the boss arena."),
      priority = 86,
      randomize_group="monsters",
    },
  },
}
