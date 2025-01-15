/*
 * Copyright 2000 David Chess; Copyright 2005-2007 Sam Trenholme; Copyright 2021-2025 The OBSIDIAN Team
 *
 * Slump is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2, or (at your option) any later
 * version.
 *
 * Slump is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Slump; see the file GPL.  If not, write to the Free
 * Software Foundation, 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 *
 * Additionally, while not required for redistribution of this program,
 * the following requests are made when making a derived version of
 * this program:
 *
 * - Slump's code is partly derived from the Doom map generator
 *   called SLIGE, by David Chess.  Please inform David Chess of
 *   any derived version that you make.  His email address is at
 *   the domain "theogeny.com" with the name "chess" placed before
 *   the at symbol.
 *
 * - Please do not call any derivative of this program SLIGE.*/

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include <string>

#include "slump.h"

namespace slump
{

// Global variables
int     current_level_number = 0;
int     global_verbosity     = 0;           /* Oooh, a global variable! */
boolean ok_to_roll           = SLUMP_FALSE; /* Stop breaking -seed...   */

/* Machoize: Make a given level harder
 * config c: The configuration for this setup
 * amount: how hard to make it (1: Same hardness; <1 harder; >1 easier) */
void machioize(config *c, float amount)
{
    genus *m;
    int    a;
    for (m = c->genus_anchor; m; m = m->next)
    {
        if (!(m->bits & SLUMP_MONSTER))
            continue;
        for (a = 0; a <= 2; a++)
        {
            m->ammo_to_kill[a] *= amount;
            m->damage[a] *= amount;
            m->altdamage[a] *= amount;
        }
    }
}

bool BuildLevels(const std::string &filename)
{

    /* A stubby but functional main() */

    level      ThisLevel;
    haa       *ThisHaa = NULL;
    config    *ThisConfig;
    int        i;
    dumphandle dh;
    float      macho_amount = 1;

    printf("SLUMP version %d.%03d.%02d -- by Sam Trenholme, http://www.samiam.org\n"
           "based on SLIGE by Dave Chess, dmchess@aol.com\n\n",
           SLUMP_SOURCE_VERSION, SLUMP_SOURCE_SERIAL, SLUMP_SOURCE_PATCHLEVEL);

    ThisConfig = get_config(filename);
    if (ThisConfig == NULL)
    {
        return false;
    }
    if (ThisConfig->cwadonly)
    {
        dh = OpenDump(ThisConfig);
        if (dh == NULL)
            return false;
        record_custom_textures(dh, ThisConfig);
        record_custom_flats(dh, ThisConfig, SLUMP_TRUE);   /* record all flats */
        record_custom_patches(dh, ThisConfig, SLUMP_TRUE); /* and patches */
        CloseDump(dh);
        printf("\nDone: wrote customization WAD %s.\n", ThisConfig->outfile);
        return true;
    }
    dh = OpenDump(ThisConfig);
    if (dh == NULL)
        return false;
    if (ThisConfig->do_slinfo)
        make_slinfo(dh, ThisConfig);
    if (ThisConfig->do_music)
        make_music(dh, ThisConfig);

    for (i = 0; i < ThisConfig->levelcount; i++)
    {
        if ((!ThisHaa) || (ThisConfig->mission == 1))
        {
            if (ThisHaa)
                free(ThisHaa);
            ThisHaa = starting_haa();
        }
        if ((i + 1) == (ThisConfig->levelcount))
            ThisConfig->last_mission = SLUMP_TRUE;
        /* Each level starts with a new ThisHaa */
        free(ThisHaa);
        ThisHaa = starting_haa();
        hardwired_nonswitch_nontheme_config(ThisConfig);
        macho_amount = 1 - ((float)(ThisConfig->map) * .008);
        macho_amount -= ((float)(ThisConfig->mission) * .025);
        NewLevel(&ThisLevel, ThisHaa, ThisConfig);
        DumpLevel(dh, ThisConfig, &ThisLevel, ThisConfig->episode, ThisConfig->mission, ThisConfig->map);
        if (need_secret_level(ThisConfig))
        {
            free(ThisHaa);
            ThisHaa      = starting_haa();
            macho_amount = 1 - ((float)(ThisConfig->map) * .008);
            macho_amount -= ((float)(ThisConfig->mission) * .025);
            hardwired_nonswitch_nontheme_config(ThisConfig);
            make_secret_level(dh, ThisHaa, ThisConfig);
        }
        if (ThisConfig->map)
            ThisConfig->map++;
        if (ThisConfig->mission)
            ThisConfig->mission++;
        if (ThisConfig->mission == 9)
        { /* Around the corner */
            ThisConfig->episode++;
            ThisConfig->mission = 1;
        }
        FreeLevel(&ThisLevel);
    }
    if (!(ThisConfig->gamemask & (SLUMP_DOOMI_BIT | SLUMP_HERETIC_BIT)))
    {
        record_custom_textures(dh, ThisConfig);
        record_custom_flats(dh, ThisConfig, SLUMP_FALSE);
        record_custom_patches(dh, ThisConfig, SLUMP_FALSE);
    }
    CloseDump(dh);
    printf("\nDone: wrote %s.\n", ThisConfig->outfile);
    return true;
}

} // namespace slump
