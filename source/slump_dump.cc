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
 * - Please do not call any derivative of this program SLIGE.
 */

#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include "lib_util.h"
#include "slump.h"

namespace slump
{

/* Global variables */

extern int     current_level_number;
extern int     global_verbosity; /* Oooh, a global variable! */
extern boolean ok_to_roll;       /* Stop breaking -seed...   */

#ifdef SLUMP_ENDIAN_BIG
unsigned int swap_32(unsigned int in)
{
    return ((in >> 24) & 0xff) |  /* hi byte (byte 1) becomes low uint8_t */
           ((in >> 8) & 0xff00) | /* byte 2 becomes byte 3 */
           ((in & 0xff00) << 8) | /* byte 3 becomes byte 2 */
           ((in & 0xff) << 24);   /* low byte becomes hi uint8_t */
}
int swap_32s(int in)
{
    return ((in >> 24) & 0xff) |  /* hi byte (byte 1) becomes low uint8_t */
           ((in >> 8) & 0xff00) | /* byte 2 becomes byte 3 */
           ((in & 0xff00) << 8) | /* byte 3 becomes byte 2 */
           ((in & 0xff) << 24);   /* low byte becomes hi uint8_t */
}
short swap_16(short in)
{
    return ((in >> 8) & 0xff) | ((in & 0xff) << 8);
}
#endif /* SLUMP_ENDIAN_BIG */

/* Open a file ready to dump multiple levels into */
dumphandle OpenDump(config *c)
{
    dumphandle answer;
    struct
    {
        char         tag[4];
        unsigned int lmpcount;
        unsigned int inxoffset;
    } headerstuff;

    answer    = (dumphandle)malloc(sizeof(*answer));
    answer->f = FileOpen(c->outfile, "wb");
    if (answer->f == NULL)
    {
        fprintf(stderr, "Error opening <%s>.\n", c->outfile);
        perror("Maybe");
        return NULL;
    }
    memcpy(headerstuff.tag, "PWAD", 4);
    /* No endian issues since these values are zero */
    headerstuff.lmpcount  = 0;                        /* To be filled in later */
    headerstuff.inxoffset = 0;
    fwrite(&headerstuff, sizeof(headerstuff), 1, answer->f);
    answer->offset_to_index    = sizeof(headerstuff); /* Length of the header */
    answer->index_entry_anchor = 0;
    answer->lmpcount           = 0;
    return answer;
}

/* Write out the directory, patch up the header, and close the file */
void CloseDump(dumphandle dh)
{
    struct
    {
        unsigned int offset;
        unsigned int length;
        char         lumpname[8];
    } directory_entry;

    index_entry *ie;

    /* Write the index entries */
    for (ie = dh->index_entry_anchor; ie; ie = ie->next)
    {
        directory_entry.offset = ie->offset;
        directory_entry.length = ie->length;
#ifdef SLUMP_ENDIAN_BIG
        directory_entry.offset = swap_32(directory_entry.offset);
        directory_entry.length = swap_32(directory_entry.length);
#endif /* SLUMP_ENDIAN_BIG */
        memset(directory_entry.lumpname, 0, 8);
        memcpy(directory_entry.lumpname, ie->name, strlen(ie->name));
        fwrite(&directory_entry, sizeof(directory_entry), 1, dh->f);
    }

    /* Go back and patch up the header */
    fseek(dh->f, 4, SEEK_SET);
#ifdef SLUMP_ENDIAN_BIG
    dh->lmpcount        = swap_32(dh->lmpcount);
    dh->offset_to_index = swap_32(dh->offset_to_index);
#endif /* SLUMP_ENDIAN_BIG */
    fwrite(&(dh->lmpcount), sizeof(unsigned int), 1, dh->f);
    fwrite(&(dh->offset_to_index), sizeof(unsigned int), 1, dh->f);
#ifdef SLUMP_ENDIAN_BIG
    /* Swap back in case we use the numbers later */
    dh->lmpcount        = swap_32(dh->lmpcount);
    dh->offset_to_index = swap_32(dh->offset_to_index);
#endif /* SLUMP_ENDIAN_BIG */

    /* and that's all! */
    fclose(dh->f);
}

/* Record the information about a new lmp of the given size */
void RegisterLmp(dumphandle dh, const char *s, unsigned int size)
{
    index_entry *ie, *ie2;

    ie       = (index_entry *)malloc(sizeof(*ie));
    ie->next = NULL;
    /* This list really has to be in frontwards order! */
    if (dh->index_entry_anchor == NULL)
    {
        dh->index_entry_anchor = ie;
    }
    else
    {
        for (ie2 = dh->index_entry_anchor; ie2->next; ie2 = ie2->next)
            ;
        ie2->next = ie;
    }
    strcpy(ie->name, s);
    ie->offset = dh->offset_to_index;
    ie->length = size;
    dh->offset_to_index += size;
    dh->lmpcount++;
}

/* Given a dumphandle, a music header, a music buffer, a lump name, */
/* and for some reason a config, do what's necessary to record it   */
/* in the file and index and stuff. */
void record_music(dumphandle dh, musheader *mh, uint8_t *buf, const char *s, config *c)
{
    unsigned int lsize;

    lsize = mh->headerlength + mh->muslength;
    RegisterLmp(dh, s, lsize);
    /* It'll be a royal pain to endian swap the header, so we just don't
     * have custom music on big-endian machines */
#ifndef SLUMP_ENDIAN_BIG
    // Need to try to get this working - Dasho
    fwrite(mh, sizeof(musheader), 1, dh->f); // Write fixed header
    fwrite(buf, mh->patches * sizeof(short) + mh->muslength, 1, dh->f);
#endif
}

/* Make the special SLINFO lmp, containing whatever we like */
void make_slinfo(dumphandle dh, config *c)
{
    static byte slinfo[100];

    sprintf((char *)slinfo, "SLUMP (%d.%03d.%02d)", SLUMP_SOURCE_VERSION, SLUMP_SOURCE_SERIAL, SLUMP_SOURCE_PATCHLEVEL);
    RegisterLmp(dh, "SLINFO", strlen((char *)slinfo) + 1);
    fwrite(slinfo, strlen((char *)slinfo) + 1, 1, dh->f);

} /* end make_slinfo() */

/* Make sure all teleports are OK; any teleport that is invalid (in other
 * words, doesn't have a destination) will be made in to an exit */
void validate_teleports(linedef *pLinedef, sector *pSector)
{
    int tags[1024];
    int a = 0;
    for (a = 0; a < 1024; a++)
    {
        tags[a] = 0;
    }
    for (; pSector != NULL; pSector = pSector->next)
    {
        if (pSector->tag > 0 && pSector->tag < 1024)
        {
            tags[pSector->tag] = 1;
        }
    }
    for (; pLinedef != NULL; pLinedef = pLinedef->next)
    {
        if (pLinedef->type == SLUMP_LINEDEF_TELEPORT && pLinedef->tag > 0 && pLinedef->tag < 1024 &&
            tags[pLinedef->tag] == 0)
        {
            printf("Warning: teleport with invalid tag; "
                   "making end of level!\n");
            pLinedef->type = SLUMP_LINEDEF_W1_END_LEVEL;
        }
    }
}

/* Write out a PWAD containing just the THINGS, LINEDEFS, SIDEDEFS, */
/* VERTEXES, and SECTORS for the given episode/mission.  The user   */
/* will have to run a nodebuilder and reject mapper hisself.        */
void DumpLevel(dumphandle dh, config *c, level *l, int episode, int mission, int map)
{
    unsigned int i;
    sector      *pSector;
    thing       *pThing;
    vertex      *pVertex;
    linedef     *pLinedef;
    sidedef     *pSidedef;

    struct
    {
        short x;
        short y;
        short angle;
        short type;
        short options;
    } rawthing;

    struct
    {
        short floor_height;
        short ceiling_height;
        char  floor_flat[8];
        char  ceiling_flat[8];
        short light_level;
        short special;
        short tag;
    } rawsector;

    struct
    {
        short x;
        short y;
    } rawvertex;

    struct
    {
        short x_offset;
        short y_offset;
        char  upper_texture[8];
        char  lower_texture[8];
        char  middle_texture[8];
        short sector;
    } rawsidedef;

    struct
    {
        short from;
        short to;
        short flags;
        short type;
        short tag;
        short right;
        short left;
    } rawlinedef;

    char sb[9];

    /* Register the zero-length marker entry */

    if (map == 0)
    {
        sprintf(sb, "E%dM%d", episode, mission);
    }
    else
    {
        sprintf(sb, "MAP%02d", map);
    }
    RegisterLmp(dh, sb, 0);

    /* Number all items, register in the directory */

    /* Number and count the things, register */
    for (i = 0, pThing = l->thing_anchor; pThing != NULL; i++)
    {
        pThing->number = i;
        pThing         = pThing->next;
    }
    RegisterLmp(dh, "THINGS", i * 10);

    /* Count the number of linedefs, register */
    for (i = 0, pLinedef = l->linedef_anchor; pLinedef != NULL; i++)
    {
        pLinedef->number = i;
        pLinedef         = pLinedef->next;
    }
    RegisterLmp(dh, "LINEDEFS", i * 14);

    /* Count the number of sidedefs, register */
    for (i = 0, pSidedef = l->sidedef_anchor; pSidedef != NULL; i++)
    {
        pSidedef->number = i;
        pSidedef         = pSidedef->next;
    }
    RegisterLmp(dh, "SIDEDEFS", i * 30);

    /* Count the number of vertexes, register */
    for (i = 0, pVertex = l->vertex_anchor; pVertex != NULL; i++)
    {
        pVertex->number = i;
        pVertex         = pVertex->next;
    }
    RegisterLmp(dh, "VERTEXES", i * 4);

    if (c->produce_null_lmps)
    {
        RegisterLmp(dh, "SEGS", 0);
        RegisterLmp(dh, "SSECTORS", 0);
        RegisterLmp(dh, "NODES", 0);
    }

    /* Count the number of sectors, register */
    for (i = 0, pSector = l->sector_anchor; pSector != NULL; i++)
    {
        pSector->number = i;
        pSector         = pSector->next;
    }
    RegisterLmp(dh, "SECTORS", i * 26);

    if (c->produce_null_lmps)
    {
        RegisterLmp(dh, "REJECT", 0);
        RegisterLmp(dh, "BLOCKMAP", 0);
    }

    /* Now actually write all those lmps */
    for (pThing = l->thing_anchor; pThing != NULL; pThing = pThing->next)
    {
        rawthing.x       = pThing->x;
        rawthing.y       = pThing->y;
        rawthing.angle   = pThing->angle;
        rawthing.type    = pThing->pgenus->thingid;
        rawthing.options = pThing->options;
#ifdef SLUMP_ENDIAN_BIG
        rawthing.x       = swap_16(rawthing.x);
        rawthing.y       = swap_16(rawthing.y);
        rawthing.angle   = swap_16(rawthing.angle);
        rawthing.type    = swap_16(rawthing.type);
        rawthing.options = swap_16(rawthing.options);
#endif
        fwrite(&rawthing, sizeof(rawthing), 1, dh->f);
    }

    /* validate teleports: a teleport without a corresponding
     * destination is made an exit (fixes slige.c bug) */
    validate_teleports(l->linedef_anchor, l->sector_anchor);

    /* and all the linedefs */
    for (pLinedef = l->linedef_anchor; pLinedef != NULL; pLinedef = pLinedef->next)
    {
        rawlinedef.from  = (pLinedef->from)->number;
        rawlinedef.to    = (pLinedef->to)->number;
        rawlinedef.flags = pLinedef->flags;
        rawlinedef.type  = pLinedef->type;
        rawlinedef.tag   = pLinedef->tag;
        if (pLinedef->right == NULL)
        {
            rawlinedef.right = (short)0xFFFF; /* actually an error, eh? */
        }
        else
        {
            rawlinedef.right = (pLinedef->right)->number;
        }
        if (pLinedef->left == NULL)
        {
            rawlinedef.left = (short)0xFFFF;
        }
        else
        {
            rawlinedef.left = (pLinedef->left)->number;
        }
#ifdef SLUMP_ENDIAN_BIG
        rawlinedef.from  = swap_16(rawlinedef.from);
        rawlinedef.to    = swap_16(rawlinedef.to);
        rawlinedef.flags = swap_16(rawlinedef.flags);
        rawlinedef.type  = swap_16(rawlinedef.type);
        rawlinedef.tag   = swap_16(rawlinedef.tag);
        rawlinedef.left  = swap_16(rawlinedef.left);
        rawlinedef.right = swap_16(rawlinedef.right);
#endif
        fwrite(&rawlinedef, sizeof(rawlinedef), 1, dh->f);
    }

    /* and all the sidedefs */
    for (pSidedef = l->sidedef_anchor; pSidedef != NULL; pSidedef = pSidedef->next)
    {
        rawsidedef.x_offset = pSidedef->x_offset;
        rawsidedef.y_offset = pSidedef->y_offset;
        memset(rawsidedef.upper_texture, 0, 8);
        memcpy(rawsidedef.upper_texture, pSidedef->upper_texture->realname, strlen(pSidedef->upper_texture->realname));
        pSidedef->upper_texture->used = SLUMP_TRUE;
        memset(rawsidedef.lower_texture, 0, 8);
        memcpy(rawsidedef.lower_texture, pSidedef->lower_texture->realname, strlen(pSidedef->lower_texture->realname));
        pSidedef->lower_texture->used = SLUMP_TRUE;
        memset(rawsidedef.middle_texture, 0, 8);
        memcpy(rawsidedef.middle_texture, pSidedef->middle_texture->realname,
               strlen(pSidedef->middle_texture->realname));
        pSidedef->middle_texture->used = SLUMP_TRUE;
        rawsidedef.sector              = (pSidedef->psector)->number;
#ifdef SLUMP_ENDIAN_BIG
        rawsidedef.x_offset = swap_16(rawsidedef.x_offset);
        rawsidedef.y_offset = swap_16(rawsidedef.y_offset);
        rawsidedef.sector   = swap_16(rawsidedef.sector);
#endif
        fwrite(&rawsidedef, sizeof(rawsidedef), 1, dh->f);
    }

    /* and all the vertexes */
    for (pVertex = l->vertex_anchor; pVertex != NULL; pVertex = pVertex->next)
    {
        rawvertex.x = pVertex->x;
        rawvertex.y = pVertex->y;
#ifdef SLUMP_ENDIAN_BIG
        rawvertex.x = swap_16(rawvertex.x);
        rawvertex.y = swap_16(rawvertex.y);
#endif
        fwrite(&rawvertex, sizeof(rawvertex), 1, dh->f);
    }

    /* and finally all the sectors */
    for (pSector = l->sector_anchor; pSector != NULL; pSector = pSector->next)
    {

        rawsector.floor_height   = pSector->floor_height;
        rawsector.ceiling_height = pSector->ceiling_height;
        memset(rawsector.floor_flat, 0, 8);
        memcpy(rawsector.floor_flat, pSector->floor_flat->name, strlen(pSector->floor_flat->name));
        pSector->floor_flat->used = SLUMP_TRUE;
        memset(rawsector.ceiling_flat, 0, 8);
        memcpy(rawsector.ceiling_flat, pSector->ceiling_flat->name, strlen(pSector->ceiling_flat->name));
        pSector->ceiling_flat->used = SLUMP_TRUE;
        if (pSector->light_level < SLUMP_ABSOLUTE_MINLIGHT)
        { /* Rooms can be too dark */
            pSector->light_level = SLUMP_ABSOLUTE_MINLIGHT;
        }
        rawsector.light_level = pSector->light_level;
        rawsector.special     = pSector->special;
        rawsector.tag         = pSector->tag;
#ifdef SLUMP_ENDIAN_BIG
        rawsector.floor_height   = swap_16(rawsector.floor_height);
        rawsector.ceiling_height = swap_16(rawsector.ceiling_height);
        rawsector.light_level    = swap_16(rawsector.light_level);
        rawsector.special        = swap_16(rawsector.special);
        rawsector.tag            = swap_16(rawsector.tag);
#endif

        fwrite(&rawsector, sizeof(rawsector), 1, dh->f);
    }

} /* end DumpLevel */

/* Dump the given texture lmp to the given dump-handle */
void dump_texture_lmp(dumphandle dh, texture_lmp *tl)
{
    int             texturecount = 0;
    int             patchcount;
    int             lmpsize, isize, i;
    custom_texture *ct;
    patch          *p;
    uint8_t        *buf, *tbuf;

    /* First figure entire lmp size.  Four bytes of tcount... */
    lmpsize = 4;

    /* Plus four-plus-22 bytes per texture, plus 10 per patch */
    for (ct = tl->custom_texture_anchor; ct; ct = ct->next)
    {
        texturecount++;
        lmpsize += 4 + 22; /* Four bytes index, 22 bytes structure */
        for (p = ct->patch_anchor; p; p = p->next)
            lmpsize += 10;
    }

    /* Get storage for the lmp itself */
    buf  = (uint8_t *)malloc(lmpsize);
    tbuf = buf;

    /* Write in the count */
#ifndef SLUMP_ENDIAN_BIG
    *(int *)tbuf = texturecount;
    tbuf += sizeof(int);
#else
    *(int *)tbuf = swap_32s(texturecount);
    tbuf += sizeof(int);
#endif

    /* Now traverse the textures again, and make the index */
    isize = 4 + 4 * texturecount;
    for (ct = tl->custom_texture_anchor; ct; ct = ct->next)
    {
#ifndef SLUMP_ENDIAN_BIG
        *(int *)tbuf = isize;
        tbuf += sizeof(int);
#else
        *(int *)tbuf = swap_32s(isize);
        tbuf += sizeof(int);
#endif
        isize += 22; /* Four bytes index, 22 bytes structure */
        for (p = ct->patch_anchor; p; p = p->next)
            isize += 10;
    }

    /* Now one last time, writing the data itself */
    for (ct = tl->custom_texture_anchor; ct; ct = ct->next)
    {
        for (i = 0; i < (int)strlen(ct->name); i++)
        {
            *(tbuf++) = (byte)((ct->name)[i]);
        }
        for (i = strlen(ct->name); i < 8; i++)
        {
            *(tbuf++) = (byte)0;
        }
        *(short *)tbuf = 0;
        tbuf += sizeof(short);
        *(short *)tbuf = 0;
        tbuf += sizeof(short);
#ifndef SLUMP_ENDIAN_BIG
        *(short *)tbuf = ct->xsize;
        tbuf += sizeof(short);
        *(short *)tbuf = ct->ysize;
        tbuf += sizeof(short);
#else
        *(short *)tbuf = swap_16(ct->xsize);
        tbuf += sizeof(short);
        *(short *)tbuf = swap_16(ct->ysize);
        tbuf += sizeof(short);
#endif
        *(short *)tbuf = 0;
        tbuf += sizeof(short);
        *(short *)tbuf = 0;
        tbuf += sizeof(short);
        for (patchcount = 0, p = ct->patch_anchor; p; p = p->next)
            patchcount++;
#ifndef SLUMP_ENDIAN_BIG
        *(short *)tbuf = patchcount;
        tbuf += sizeof(short);
#else
        *(short *)tbuf = swap_16(patchcount);
        tbuf += sizeof(short);
#endif
        for (p = ct->patch_anchor; p; p = p->next)
        {
#ifndef SLUMP_ENDIAN_BIG
            *(short *)tbuf = p->x;
            tbuf += sizeof(short);
            *(short *)tbuf = p->y;
            tbuf += sizeof(short);
            *(short *)tbuf = p->number;
            tbuf += sizeof(short);
            *(short *)tbuf = 1;
            tbuf += sizeof(short);
#else
            *(short *)tbuf = swap_16(p->x);
            tbuf += sizeof(short);
            *(short *)tbuf = swap_16(p->y);
            tbuf += sizeof(short);
            *(short *)tbuf = swap_16(p->number);
            tbuf += sizeof(short);
            *(short *)tbuf = swap_16(1);
            tbuf += sizeof(short);
#endif
            *(short *)tbuf = 0;
            tbuf += sizeof(short);
        }
    }

    RegisterLmp(dh, tl->name, lmpsize);
    fwrite(buf, lmpsize, 1, dh->f);
}

/* Allocate, initialize, register with the texture (but don't */
/* bother returning) a new patch for this texture */
void add_patch(custom_texture *ct, short patchid, short x, short y)
{
    patch *answer = (patch *)malloc(sizeof(*answer));
    patch *p;

    answer->number = patchid;
    answer->x      = x;
    answer->y      = y;
    answer->next   = NULL;
    /* Simplest if these are in frontward order */
    if (ct->patch_anchor == NULL)
    {
        ct->patch_anchor = answer;
    }
    else
    {
        for (p = ct->patch_anchor; p->next; p = p->next)
        {
        }; /* find last */
        p->next = answer;
    }
}

/* Record any custom textures, made from existing patches, that */
/* we might want to show off by using.  Only works in DOOM2, sadly. */
/* In DOOM I, we'd have to recreate the entire TEXTURE2 (or 1) lump, */
/* and then add our stuff to it. */
void record_custom_textures(dumphandle dh, config *c)
{
    texture_lmp    *tl;
    custom_texture *ct;

    /* Return if TEXTURE2 not available */
    if (c->gamemask & (SLUMP_DOOM0_BIT | SLUMP_DOOM1_BIT | SLUMP_DOOMI_BIT | SLUMP_HERETIC_BIT))
        return;

    tl = new_texture_lmp("TEXTURE2");

    ct = new_custom_texture(tl, "GRAYALT", 0x80, 0x80);
    add_patch(ct, 0x87, 0, 0);
    add_patch(ct, 0x8a, 0, 0x40);
    add_patch(ct, 0x8a, 0x40, 0);
    add_patch(ct, 0x87, 0x40, 0x40);
    ct = new_custom_texture(tl, "TEKVINE", 0x100, 0x80);
    add_patch(ct, 0x19b, 0, 0);
    add_patch(ct, 0x183, 0x40, 0);
    add_patch(ct, 0x19b, 0x80, 0);
    add_patch(ct, 0x183, 0xc0, 0);
    add_patch(ct, 0x35, 0, 0);     /* Vines! */
    ct = new_custom_texture(tl, "WOODVINE", 0x100, 0x80);
    add_patch(ct, 0x1b1, 0, 0);    /* WOOD9 */
    add_patch(ct, 0x1b1, 0x40, 0); /* WOOD9 */
    add_patch(ct, 0x1b1, 0x80, 0); /* WOOD9 */
    add_patch(ct, 0x1b1, 0xc0, 0); /* WOOD9 */
    add_patch(ct, 0x35, 0, 0);     /* Vines! */
    ct = new_custom_texture(tl, "WOODLITE", 0x100, 0x80);
    add_patch(ct, 0x1ac, -4, 0);   /* Copied from WOOD5 */
    add_patch(ct, 0x1ad, 124, 0);  /* Copied from WOOD5 */
    add_patch(ct, 0x1ac, 252, 0);  /* Copied from WOOD5 */
    add_patch(ct, 0x78, 32, 20);   /* The light overlay */
    ct = new_custom_texture(tl, "DOORSKUL", 0x40, 0x48);
    add_patch(ct, 0x6b, 0, 0);     /* The door */
    add_patch(ct, 0x1ab, 21, 11);  /* The liddle skull */
    ct = new_custom_texture(tl, "EXITSWIT", 0x40, 0x80);
    add_patch(ct, 0x87, 0, 0);
    add_patch(ct, 0x87, 0, 64);
    add_patch(ct, 0x177, 16, 70);
    add_patch(ct, 0x79, 16, 104);
    ct = new_custom_texture(tl, "EXITSWIW", 0x40, 0x80);
    add_patch(ct, 0xdd, 0, 0);
    add_patch(ct, 0x173, 0x0e, 0x40);
    add_patch(ct, 0x79, 16, 104);
    ct = new_custom_texture(tl, "EXITSWIR", 0x40, 0x80);
    add_patch(ct, 0x12d, 0, 0);
    add_patch(ct, 0x173, 0x0f, 0x42);
    add_patch(ct, 0x79, 16, 104);
    ct = new_custom_texture(tl, "MARBGARG", 0x40, 0x80);
    add_patch(ct, 0x0BD, 0, 0);  /* MWALL3_1 */
    add_patch(ct, 0x1B2, 6, 31); /* SW2_4 */

    dump_texture_lmp(dh, tl);
    free_texture_lmp(tl);
} /* end record_custom_textures */

byte fbuf[64 * 64 + 4];                /* For use in making custom flats and patches; 64x64 */
byte pbuf[SLUMP_TLMPSIZE(0x80, 0x40)]; /* Also */

/* Record any custom flats that we might want to show off by using. */
/* This is *much* simpler than textures! */
void record_custom_flats(dumphandle dh, config *c, boolean even_unused)
{
    short   i, j, x, x2, y, dx, dy;
    boolean started = SLUMP_FALSE;

    if (even_unused || find_flat(c, "SLGRASS1")->used)
    {

        if (!started)
            RegisterLmp(dh, "FF_START", 0);
        started = SLUMP_TRUE;
        announce(SLUMP_VERBOSE, "SLGRASS1");

        basic_background2(fbuf, 0x7c, 4);
        x = roll(64);
        y = roll(64);
        for (;;)
        {
            dx = 1 - roll(3);
            dy = 1 - roll(3);
            if (dx && dy)
                break;
        }
        for (i = 512; i; i--)
        {
            x += dx;
            y += dy;
            if (x < 0)
                x += 64;
            if (x > 63)
                x -= 64;
            if (y < 0)
                y += 64;
            if (y > 63)
                y -= 64;
            fbuf[64 * x + y]  = 0xbc + roll(4);
            x2                = (x == 0) ? 63 : x - 1;
            fbuf[64 * x2 + y] = 0xbc;
            x2                = (x == 63) ? 0 : x + 1;
            fbuf[64 * x2 + y] = 0xbf;
            if (roll(8) == 0)
                dx = 1 - roll(3);
            if (roll(8) == 0)
                dy = 1 - roll(3);
            for (; !(dx || dy);)
            {
                dx = 1 - roll(3);
                dy = 1 - roll(3);
            }
        }

        RegisterLmp(dh, "SLGRASS1", 4096);
        fwrite(fbuf, 4096, 1, dh->f);
    }

    if (even_unused || find_flat(c, "SLSPARKS")->used)
    {

        if (!started)
            RegisterLmp(dh, "FF_START", 0);
        started = SLUMP_TRUE;
        announce(SLUMP_VERBOSE, "SLSPARKS");
        memset(fbuf, 0, 4096);
        for (i = 512; i; i--)
            fbuf[roll(64) + 64 * roll(64)] = 0xb0 + roll(16);
        RegisterLmp(dh, "SLSPARKS", 4096);
        fwrite(fbuf, 4096, 1, dh->f);
    }

    if (even_unused || find_flat(c, "SLGATE1")->used)
    {

        if (!started)
            RegisterLmp(dh, "FF_START", 0);
        started = SLUMP_TRUE;
        announce(SLUMP_VERBOSE, "SLGATE1");

        basic_background2(fbuf, 0x9c, 4);

        for (i = 4; i < 60; i++)
        {
            for (j = 4; j < 60; j++)
            {
                dx = abs((i << 1) - 63) >> 2;
                dy = abs((j << 1) - 63) >> 2;
                x  = 0xcf - (dx + dy) / 2;
                x += roll(2);
                x -= roll(2);
                if (x > 0xcf)
                    x = 0xcf;
                if (x < 0xc0)
                    x = 0xc0;
                fbuf[64 * i + j] = (byte)x;
            }
        }

        RegisterLmp(dh, "SLGATE1", 4096);
        fwrite(fbuf, 4096, 1, dh->f);
    }

    if (even_unused || find_flat(c, "SLLITE1")->used)
    {

        if (!started)
            RegisterLmp(dh, "FF_START", 0);
        started = SLUMP_TRUE;
        announce(SLUMP_VERBOSE, "SLLITE1");

        basic_background2(fbuf, 0x94, 4);

        for (i = 0; i < 4; i++)
        {
            for (j = 0; j < 4; j++)
            {
                for (x = 3; x < 13; x++)
                {
                    for (y = 3; y < 13; y++)
                    {
                        if ((x == 3 || x == 12) && (y == 3 || y == 12))
                            continue;
                        dx = abs((x << 1) - 15) >> 2;
                        dy = abs((y << 1) - 15) >> 2;
                        if (dy > dx)
                            dx = dy;
                        x2 = 0xa1 + 2 * dx;
                        x2 += roll(2) - roll(2);
                        if (x2 > 0xa7)
                            x2 = 0xa7;
                        if (x2 < 0xa0)
                            x2 = 0xa0;
                        fbuf[64 * (16 * i + x) + 16 * j + y] = (byte)x2;
                    }
                }
            }
        }

        RegisterLmp(dh, "SLLITE1", 4096);
        fwrite(fbuf, 4096, 1, dh->f);
    }

    if (even_unused || find_flat(c, "SLFLAT01")->used)
    {

        if (!started)
            RegisterLmp(dh, "FF_START", 0);
        started = SLUMP_TRUE;
        announce(SLUMP_VERBOSE, "SLFLAT01");

        basic_background2(fbuf, 0x6b, 5);
        for (i = 0; i < 4096; i++)
            if (fbuf[i] > 0x6d)
                fbuf[i] = 0x0;
        for (i = 0; i < 64; i++)
        {
            fbuf[i]           = 0x6b;
            fbuf[64 * i]      = 0x6b;
            fbuf[63 * 64 + i] = 0x6f;
            fbuf[64 * i + 63] = 0x6f;
        }

        RegisterLmp(dh, "SLFLAT01", 4096);
        fwrite(fbuf, 4096, 1, dh->f);
    }

    if (started)
    {
        RegisterLmp(dh, "FF_END", 0);
        RegisterLmp(dh, "F_END", 0); /* Just in case */
    }
}

/* Record any custom/replacement patches that we might want to show off */
/* by using. */
void record_custom_patches(dumphandle dh, config *c, boolean even_unused)
{
    int      rows, columns, i, j, lsize;
    uint8_t *p, thispel;
    boolean  started = SLUMP_FALSE;

    if (even_unused || SLUMP_FALSE)
    {

        if (!started)
        {
            RegisterLmp(dh, "P_START", 0); /* Which?  Both? */
            RegisterLmp(dh, "PP_START", 0);
        }
        started = SLUMP_TRUE;

        rows    = 0x80;
        columns = 0x40;
        lsize   = SLUMP_TLMPSIZE(rows, columns);
        if (lsize > sizeof(pbuf))
            announce(SLUMP_ERROR, "Buffer overflow in r_c_t()");
        p = pbuf;
        /* The picture header */
#ifndef SLUMP_ENDIAN_BIG
        *(short *)p = columns;
        p += sizeof(short); /* Width */
        *(short *)p = rows;
        p += sizeof(short); /* Height */
        *(short *)p = (columns >> 1) - 1;
        p += sizeof(short); /* Width offset */
        *(short *)p = rows - 5;
        p += sizeof(short); /* Magic */
#else
        *(short *)p = swap_16(columns);
        p += sizeof(short); /* Width */
        *(short *)p = swap_16(rows);
        p += sizeof(short); /* Height */
        *(short *)p = swap_16((columns >> 1) - 1);
        p += sizeof(short); /* Width offset */
        *(short *)p = swap_16(rows - 5);
        p += sizeof(short); /* Magic */
#endif
        /* The pointers to the columns */
        for (i = 0; i < columns; i++)
        {
            int z;
            z = 8 + 4 * (columns) + i * (rows + 5);
#ifndef SLUMP_ENDIAN_BIG
            *(int *)p = z;
            p += sizeof(int);
#else
            *(int *)p = swap_32s(z);
            p += sizeof(int);
#endif
        }
        /* The columns themselves */
        for (i = 0; i < columns; i++)
        {
            /* The column header */
            *p = 0;
            p++;
            *p = (byte)rows;
            p++;
            /* The column itself, including silly bytes */
            for (j = -1; j < rows + 1; j++)
            {
                if (rollpercent(10))
                    thispel = 0xc0 + roll(16);
                else
                    thispel = 0;
                *p = thispel;
                p++;
            }
            /* And finally */
            *p = 0xff;
            p++;
        }
        /* Whew! */

        RegisterLmp(dh, "WALL51_1", lsize); /* DOOM I only */
        fwrite(pbuf, lsize, 1, dh->f);
    }

    if (even_unused || SLUMP_FALSE)
    {

        if (!started)
        {
            RegisterLmp(dh, "P_START", 0); /* Which?  Both? */
            RegisterLmp(dh, "PP_START", 0);
        }
        started = SLUMP_TRUE;

        rows    = 0x80;
        columns = 0x40;
        lsize   = SLUMP_TLMPSIZE(rows, columns);
        if (lsize > sizeof(pbuf))
            announce(SLUMP_ERROR, "Buffer overflow in r_c_t()");
        p = pbuf;
        /* The picture header */
#ifndef SLUMP_ENDIAN_BIG
        *(short *)p = columns;
        p += sizeof(short); /* Width */
        *(short *)p = rows;
        p += sizeof(short); /* Height */
        *(short *)p = (columns >> 1) - 1;
        p += sizeof(short); /* Width offset */
        *(short *)p = rows - 5;
        p += sizeof(short); /* Magic */
#else
        *(short *)p = swap_16(columns);
        p += sizeof(short); /* Width */
        *(short *)p = swap_16(rows);
        p += sizeof(short); /* Height */
        *(short *)p = swap_16((columns >> 1) - 1);
        p += sizeof(short); /* Width offset */
        *(short *)p = swap_16(rows - 5);
        p += sizeof(short); /* Magic */
#endif
        /* The pointers to the columns */
        for (i = 0; i < columns; i++)
        {
            int z;
            z = 8 + 4 * (columns) + i * (rows + 5);
#ifndef SLUMP_ENDIAN_BIG
            *(int *)p = z;
            p += sizeof(int);
#else
            *(int *)p = swap_32s(z);
            p += sizeof(int);
#endif
        }
        /* The columns themselves */
        for (i = 0; i < columns; i++)
        {
            /* The column header */
            *p = 0;
            p++;
            *p = (byte)rows;
            p++;
            /* The column itself, including silly bytes */
            for (j = -1; j < rows + 1; j++)
            {
                if (rollpercent(20))
                    thispel = 0xd0 + roll(16);
                else
                    thispel = 0;
                *p = thispel;
                p++;
            }
            /* And finally */
            *p = 0xff;
            p++;
        }
        /* Whew! */

        RegisterLmp(dh, "WALL51_2", lsize);
        fwrite(pbuf, lsize, 1, dh->f);
    }

    /* Next is the steel-rollup-door patch.  It's currently put into */
    /* the WALL51_3 slot, which means it appears in texture SP_DUDE5 */
    /* (instead of the yucchy dead guy hanging on the wall.)  The    */
    /* internal name for the texture is SLDOOR1.                     */

    if (even_unused || find_texture(c, "SLDOOR1")->used)
    {

        if (!started)
        {
            RegisterLmp(dh, "P_START", 0); /* Which?  Both? */
            RegisterLmp(dh, "PP_START", 0);
        }
        started = SLUMP_TRUE;

        /* First a little correlated noise for "dirtying" */
        basic_background2(fbuf, 0, 5);

        /* Then the actual patch */
        rows    = 0x80;
        columns = 0x40;
        lsize   = SLUMP_TLMPSIZE(rows, columns);
        if (lsize > sizeof(pbuf))
            announce(SLUMP_ERROR, "Buffer overflow in r_c_t()");
        p = pbuf;
        /* The picture header */
#ifndef SLUMP_ENDIAN_BIG
        *(short *)p = columns;
        p += sizeof(short); /* Width */
        *(short *)p = rows;
        p += sizeof(short); /* Height */
        *(short *)p = (columns >> 1) - 1;
        p += sizeof(short); /* Width offset */
        *(short *)p = rows - 5;
        p += sizeof(short); /* Magic */
#else
        *(short *)p = swap_16(columns);
        p += sizeof(short); /* Width */
        *(short *)p = swap_16(rows);
        p += sizeof(short); /* Height */
        *(short *)p = swap_16((columns >> 1) - 1);
        p += sizeof(short); /* Width offset */
        *(short *)p = swap_16(rows - 5);
        p += sizeof(short); /* Magic */
#endif
        /* The pointers to the columns */
        for (i = 0; i < columns; i++)
        {
            int z;
            z = 8 + 4 * (columns) + i * (rows + 5);
#ifndef SLUMP_ENDIAN_BIG
            *(int *)p = z;
            p += sizeof(int);
#else
            *(int *)p = swap_32s(z);
            p += sizeof(int);
#endif
        }
        /* The columns themselves */
        for (i = 0; i < columns; i++)
        {
            /* The column header */
            *p = 0;
            p++;
            *p = (byte)rows;
            p++;
            /* The column itself, including silly bytes */
            for (j = -1; j < rows + 1; j++)
            {
                thispel = 0x60 + (j + 1) % 8;
                if ((j >= 0) && (j < rows))
                    thispel += 2 - fbuf[64 * (i) + (j & 63)];
                *p = thispel;
                p++;
            }
            /* And finally */
            *p = 0xff;
            p++;
        }
        /* Whew! */

        RegisterLmp(dh, "WALL51_3", lsize);
        fwrite(pbuf, lsize, 1, dh->f);
    }

    if (started)
    {
        RegisterLmp(dh, "PP_END", 0);
        RegisterLmp(dh, "P_END", 0);
    }
}

/* Compose replacements for the music sections used by the */
/* given config, and send them out the dumphandle. */
void make_music(dumphandle dh, config *c)
{
    musheader mh;
    uint8_t  *musbuf;

    /* Definitely a stub! */
    if (c->gamemask & SLUMP_DOOM1_BIT)
    {
        musbuf = one_piece(&mh);
        record_music(dh, &mh, musbuf, "D_INTROA", c);
        free(musbuf);
    }
    if (c->gamemask & SLUMP_DOOM2_BIT)
    {
        musbuf = one_piece(&mh);
        record_music(dh, &mh, musbuf, "D_DM2TTL", c);
        free(musbuf);
    }

} /* end stubby make_music() */

/* Make a secret level following the current level.  With luck, */
/* the current level has an exit to it! */
void make_secret_level(dumphandle dh, haa *oldhaa, config *c)
{
    config *SecConfig;
    level   SecLevel;
    haa    *SecHaa;

    SecConfig = (config *)malloc(sizeof(*SecConfig));
    memcpy(SecConfig, c, sizeof(*c));
    SecHaa = (haa *)malloc(sizeof(*SecHaa));
    memcpy(SecHaa, oldhaa, sizeof(*oldhaa));
    secretize_config(SecConfig);
    if (SecConfig->map == 31)
        SecConfig->map++;
    if (SecConfig->map == 15)
        SecConfig->map = 31;
    if (SecConfig->episode != 0)
        SecConfig->mission = 9;
    NewLevel(&SecLevel, SecHaa, SecConfig);
    DumpLevel(dh, SecConfig, &SecLevel, SecConfig->episode, SecConfig->mission, SecConfig->map);
    if (SecConfig->map == 31)
    {
        SecConfig->map           = 32;
        SecConfig->secret_themes = SLUMP_TRUE;
        NewLevel(&SecLevel, SecHaa, SecConfig);
        DumpLevel(dh, SecConfig, &SecLevel, SecConfig->episode, SecConfig->mission, SecConfig->map);
    }
}

} // namespace slump