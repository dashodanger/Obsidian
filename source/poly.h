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

// functions provided by the application

#include <stdint.h>
#include <string.h>

#include <string>
#include <unordered_map>

namespace ajpoly
{

/* -------- OBJECTS ------------------------ */

class wall_tip_c;
class sector_c;
class linedef_c;
class edge_c;

class vertex_c
{
  public:
    int index;

    // coordinates
    double x, y;

    // reference count (use to detect duplicate vertices)
    int ref_count;

    // set of wall_tips
    wall_tip_c *tip_set;

  public:
    vertex_c() : index(-1), x(), y(), ref_count(), tip_set()
    {
    }

    sector_c *CheckOpen(double dx, double dy) const;

    void AddTip(double dx, double dy, sector_c *left, sector_c *right);
};

// this bit in the index value differentiates normal vertices from split ones
constexpr int SPLIT_VERTEX = (1 << 24);

class sector_c
{
  public:
    int index;

    // heights
    int floor_h, ceil_h;

    // textures
    char floor_tex[10];
    char ceil_tex[10];

    // attributes
    int light;
    int special;
    int tag;

    edge_c *edge_list;

    // this keeps track of 3D floors in this sector
    // (floor_start is really private)
    int num_floors;
    int floor_start;

    char is_dummy; // private

    // UDMF support
    std::unordered_map<std::string, std::string> misc_vals;

  public:
    sector_c()
        : index(-1), floor_h(), ceil_h(), floor_tex(), ceil_tex(), light(), special(), tag(), edge_list(), num_floors(),
          floor_start(), is_dummy()
    {
    }

    linedef_c *getExtraFloor(int index);
};

constexpr uint16_t VOID_SECTOR_IDX = 0xFFFF;

class sidedef_c
{
  public:
    int index;

    // adjacent sector.  Can be NULL (invalid sidedef)
    sector_c *sector;

    // offset values
    int x_offset, y_offset;

    // texture names
    char upper_tex[10];
    char lower_tex[10];
    char mid_tex[10];

    // UDMF support
    std::unordered_map<std::string, std::string> misc_vals;

  public:
    sidedef_c() : index(-1), sector(), x_offset(), y_offset(), upper_tex(), lower_tex(), mid_tex()
    {
    }
};

class linedef_c
{
  public:
    int index;

    vertex_c *start;
    vertex_c *end;

    sidedef_c *right; // right side
    sidedef_c *left;  // left side, or NULL if none

    char is_border;

    int flags;
    int special;
    int tag;

    // Hexen support
    uint8_t args[5];

    // UDMF support
    std::unordered_map<std::string, std::string> misc_vals;

  public:
    linedef_c() : index(-1), start(), end(), right(), left(), is_border(), flags(), special(), tag(), args()
    {
    }
};

class thing_c
{
  public:
    int index;

    int x, y;
    int type;
    int options;
    int angle;

    // Hexen support
    int     tid;
    int     height;
    int     special;
    uint8_t args[5];

    // UDMF support
    std::unordered_map<std::string, std::string> misc_vals;

  public:
    thing_c() : index(-1), x(), y(), type(), options(), angle(), tid(), height(), special(), args()
    {
    }
};

class edge_c
{
  public:
    int index;

    // link for list
    edge_c *next;

    vertex_c *start;
    vertex_c *end;

    // linedef that this edge goes along, or NULL if none
    linedef_c *linedef;

    // adjacent sector, or NULL if none (for outside of map)
    sector_c *sector;

    // side of linedef this edge is on: 0 for right, 1 for left
    // (not valid when 'linedef' field is NULL)
    int side;

    // edge on other side, or NULL if one-sided.
    // this relationship is always one-to-one : if one of the edges
    // gets split, the partner must also be split.
    edge_c *partner;

  public: // really private
    // precomputed data for faster calculations
    double psx, psy;
    double pex, pey;
    double pdx, pdy;

    double p_length;
    double p_angle;
    double p_para;
    double p_perp;

    // linedef that this edge initially came from.
    // For "real" edges, this is the same as the 'linedef' field.
    // For "mini" edges, this is the linedef of the partition.
    // can be NULL (e.g. for edges added around the map)
    linedef_c *source_line;

  public:
    edge_c() : next(), start(), end(), linedef(), sector(), side(), partner(), source_line()
    {
    }

    void Recompute();

    double AlongDist(double x, double y) const;
    double PerpDist(double x, double y) const;

    void CopyInfo(const edge_c *other);
};

class polygon_c
{
  public:
    int index;

    // sector this belongs to (possibly 'void_sector')
    sector_c *sector;

    edge_c *edge_list;

    // approximate middle point
    double mid_x;
    double mid_y;

  public:
    polygon_c() : sector(), edge_list(), mid_x(), mid_y()
    {
    }

    bool ContainsPoint(double x, double y) const;

    int CountEdges() const;

    void CalcMiddle();
    void ClockwiseOrder();
};

/* -------- VARIABLES ------------------------ */

extern int num_vertices;
extern int num_linedefs;
extern int num_sidedefs;
extern int num_sectors;
extern int num_things;

extern int num_splits;
extern int num_edges;
extern int num_polygons;

/* -------- FUNCTIONS ------------------------ */

// return error message when something fails.
// (this will be a static buffer, so is not guaranteed to remain valid
//  after any other API call)
const char *GetError();

// try to load a wad file.
// returns true on success, false on error
bool LoadWAD(const char *wad_filename);

// free all data associated with the wad file.
// can be safely called without any loaded wad file
void FreeWAD();

// try to open a map from the current wad file.
// returns true on success, false on error
bool OpenMap(const char *map_name);

// free all data associated with a map.
// can be safely called without any opened map
void CloseMap();

// attempt to polygonize each sector in the map.
// when 'require_border' is true, map must be bounded by a linedef
// on all four sides (north, south, east and west).
// returns true on success, false on error
bool Polygonate(bool require_border);

// level access functions
// the first group can be called after OpenMap().
// the Polygon() function can only be called after Polygonate().

vertex_c  *Vertex(int index);
linedef_c *Linedef(int index);
sidedef_c *Sidedef(int index);
sector_c  *Sector(int index);
thing_c   *Thing(int index);

polygon_c *Polygon(int index);

} // namespace ajpoly

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
