//------------------------------------------------------------------------
//  2.5D CSG : LOCAL DEFS
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#pragma once

#include <vector>

#include "csg_main.h"

constexpr double SNAG_EPSILON = 0.001;

/***** CLASSES ****************/

class partition_c;
class region_c;
class gap_c;

class snag_c
{
  public:
    double x1, y1;
    double x2, y2;

    bool mini;

    partition_c *on_node;

    region_c *region; // only valid AFTER MergeRegions()

    snag_c *partner;  // only valid AFTER HandleOverlaps()

    std::vector<brush_vert_c *> sides;

    // quantized along values, used for overlap detection
    int q_along1;
    int q_along2;

    // used by CSG DOOM code
    bool seen;

  private:
    snag_c(const snag_c &other);

  public:
    snag_c(brush_vert_c *side, double _x1, double _y1, double _x2, double _y2);

    snag_c(double _x1, double _y1, double _x2, double _y2, partition_c *part);

    ~snag_c();

    double Length() const;

    snag_c *Cut(double ix, double iy);

    void CalcAlongs();

    // this is for the MiniMap code, returns true if brushes are the same
    // on both sides.  CSG_SortBrushes() must have been called already.
    bool SameSides() const;

    // also for minimap
    bool IsTwoSided() const;

    void TransferSides(snag_c *other);

    void RemoveSide(int index);
    void RemoveSidesForBrush(const csg_brush_c *B);

    // brush side finding functions, return NULL if not found
    brush_vert_c *FindOneSidedVert(double z);
    brush_vert_c *FindBrushVert(const csg_brush_c *B);
};

class region_c
{
  public:
    std::vector<snag_c *> snags;

    std::vector<csg_brush_c *> brushes;

    std::vector<csg_entity_c *> entities;

    std::vector<gap_c *> gaps;

    double mid_x, mid_y;

    // this forms a bounding box (dist from the mid point)
    float rw, rh;

    bool degenerate;

    // used by DOOM and QUAKE Clipping (etc)
    int index;

    // used by DOOM shading code
    int shade;

  public:
    region_c();

    region_c(const region_c &other);

    ~region_c();

    void AddSnag(snag_c *S);
    bool HasSnag(snag_c *S) const;
    bool RemoveSnag(snag_c *S);

    void AddBrush(csg_brush_c *P);
    void RemoveBrush(int index);

    void AddGap(gap_c *G);
    void RemoveGap(int index);

    int TestSide(partition_c *P);

    void MergeOther(region_c *other);

    bool isClosed() const;

    // these use mid-point of region to compute Z for a brush top/bottom
    double TopZ(csg_brush_c *B) const;
    double BottomZ(csg_brush_c *B) const;

    void GetBounds(double *x1, double *y1, double *x2, double *y2) const;

    bool   ContainsPoint(double x, double y) const;
    double DistanceToPoint(float x, float y) const;
    double SquareDistance(float x, float y) const;

    void SortBrushes();

    void RemoveSidesForBrush(const csg_brush_c *B);

    // this requires CSG_SortBrushes() to have been called earlier
    bool HasSameBrushes(const region_c *other) const;

    bool HasFlattened() const;

    void ComputeMidPoint();
    void ComputeBounds();
    void ClockwiseSnags(); // requires CalcMidPoint()
};

class gap_c
{
  public:
    csg_brush_c *bottom;
    csg_brush_c *top;

    bool reachable;

    std::vector<gap_c *> neighbors;

    // liquid brush whose surface is in this gap (or clipped above it)
    csg_brush_c *liquid;

  public:
    gap_c(csg_brush_c *B, csg_brush_c *T);

    ~gap_c();

    void AddNeighbor(gap_c *N);
    bool HasNeighbor(gap_c *N) const;
};

class bsp_node_c
{
  public:
    // partition
    double x1, y1, x2, y2;

    // front : one of these should be non-NULL
    bsp_node_c *front_node;
    region_c   *front_leaf;

    // back : one of these should be non-NULL
    bsp_node_c *back_node;
    region_c   *back_leaf;

    // bounding box of this node
    float bb_x1, bb_y1;
    float bb_x2, bb_y2;

  public:
    bsp_node_c(double px1, double py1, double px2, double py2);

    // destructor deletes child nodes (but not leafs)
    ~bsp_node_c();

    void ComputeBBox();

  private:
    void AddBBox(bsp_node_c *node);
    void AddBBox(region_c *leaf);
};

/***** VARIABLES ****************/

extern std::vector<region_c *> all_regions;

extern bsp_node_c *bsp_root;

/***** FUNCTIONS ****************/

void CSG_BSP(double grid, bool is_clip_hull = false);
void CSG_BSP_Free();

region_c *CSG_PointInRegion(double x, double y);

void CSG_Shade();

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
