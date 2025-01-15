//------------------------------------------------------------------------
//
//  AJ-Polygonator
//  (C) 2021-2025 The OBSIDIAN Team
//  (C) 2000-2013 Andrew Apted
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#pragma once

#include "poly.h"

namespace ajpoly
{

/* ----- OBJECTS --------------------------------- */

// a wall_tip is where a wall meets a vertex

class wall_tip_c
{
  public:
    // link in list.  List is kept in ANTI-clockwise order.
    wall_tip_c *next;
    wall_tip_c *prev;

    // angle that line makes at vertex (degrees).
    double angle;

    // sectors on each side of wall.  Left is the side of increasing
    // angles, right is the side of decreasing angles.  Either can be
    // NULL for one sided walls.
    sector_c *left;
    sector_c *right;
};

/* ----- VARIABLES --------------------------------- */

// map limits
extern int limit_x1, limit_y1;
extern int limit_x2, limit_y2;

// a special sector used to represent the void (empty space)
extern sector_c *void_sector;

/* ----- FUNCTIONS --------------------------------- */

vertex_c  *NewVertex();
linedef_c *NewLinedef();
sidedef_c *NewSidedef();
sector_c  *NewSector();
thing_c   *NewThing();

vertex_c  *NewSplit();
edge_c    *NewEdge();
polygon_c *NewPolygon();
wall_tip_c        *NewWallTip();

// return a new vertex (with correct wall_tip info) for the split that
// happens along the given edge at the given location.
vertex_c *NewVertexFromSplit(edge_c *E, double x, double y);

bool VerifyOuterLines();

} // namespace ajpoly

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
