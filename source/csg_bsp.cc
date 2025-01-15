//------------------------------------------------------------------------
//  2.5D Constructive Solid Geometry
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

#include <algorithm>

#include "csg_local.h"
#include "csg_main.h"
#include "g_doom.h" // for MLF_DontDraw
#include "lib_util.h"
#include "main.h"
#include "sys_assert.h"
#include "sys_macro.h"

double QUANTIZE_GRID;

static bool csg_is_clip_hull;

static std::vector<region_c *> dead_regions;

class partition_c
{
  public:
    double x1, y1;
    double x2, y2;

  public:
    partition_c(double _x1, double _y1, double _x2, double _y2) : x1(_x1), y1(_y1), x2(_x2), y2(_y2)
    {
    }

    partition_c(const snag_c *S) : x1(S->x1), y1(S->y1), x2(S->x2), y2(S->y2)
    {
    }

    ~partition_c()
    {
    }
};

class group_c
{
  public:
    std::vector<region_c *> regs;

    std::vector<csg_entity_c *> ents;

  public:
    group_c() : regs(), ents()
    {
    }

    ~group_c()
    {
    }

    void AddRegion(region_c *R)
    {
        regs.push_back(R);
    }

    void AddEntity(csg_entity_c *E)
    {
        ents.push_back(E);
    }

    void GetGroupBounds(double *min_x, double *min_y, double *max_x, double *max_y)
    {
        *min_x = *min_y = +9e9;
        *max_x = *max_y = -9e9;

        for (unsigned int k = 0; k < regs.size(); k++)
        {
            double x1, y1, x2, y2;

            regs[k]->GetBounds(&x1, &y1, &x2, &y2);

            *min_x = OBSIDIAN_MIN(*min_x, x1);
            *min_y = OBSIDIAN_MIN(*min_y, y1);

            *max_x = OBSIDIAN_MAX(*max_x, x1);
            *max_y = OBSIDIAN_MAX(*max_y, y1);
        }
    }
};

//------------------------------------------------------------------------

snag_c::snag_c(brush_vert_c *side, double _x1, double _y1, double _x2, double _y2)
    : x1(_x1), y1(_y1), x2(_x2), y2(_y2), mini(false), on_node(NULL), region(NULL), partner(NULL), seen(false)
{
    if (Length() < SNAG_EPSILON)
    {
        FatalError("Line loop contains zero-length line! (%1.2f %1.2f)\n", x1, y1);
    }

    sides.push_back(side);
}

snag_c::snag_c(double _x1, double _y1, double _x2, double _y2, partition_c *part)
    : x1(_x1), y1(_y1), x2(_x2), y2(_y2), mini(true), on_node(part), region(NULL), partner(NULL), seen(false)
{
}

snag_c::snag_c(const snag_c &other)
    : x1(other.x1), y1(other.y1), x2(other.x2), y2(other.y2), mini(other.mini), on_node(other.on_node),
      region(other.region), partner(NULL), seen(false)
{
    // copy sides
    for (auto *side : other.sides)
    {
        sides.push_back(side);
    }
}

snag_c::~snag_c()
{
}

double snag_c::Length() const
{
    return ComputeDist(x1, y1, x2, y2);
}

snag_c *snag_c::Cut(double ix, double iy)
{
    snag_c *T = new snag_c(*this);

    x2    = ix;
    T->x1 = ix;
    y2    = iy;
    T->y1 = iy;

    return T;
}

void snag_c::CalcAlongs()
{
    SYS_ASSERT(on_node);

    double a1 = AlongDist(x1, y1, on_node->x1, on_node->y1, on_node->x2, on_node->y2);
    double a2 = AlongDist(x2, y2, on_node->x1, on_node->y1, on_node->x2, on_node->y2);

    a1 /= SNAG_EPSILON;
    a2 /= SNAG_EPSILON;

    q_along1 = OBSIDIAN_I_ROUND(a1);
    q_along2 = OBSIDIAN_I_ROUND(a2);
}

bool snag_c::SameSides() const
{
    if (!partner || !partner->region)
    {
        return false;
    }

    return region->HasSameBrushes(partner->region);
}

void snag_c::TransferSides(snag_c *other)
{
    for (unsigned int i = 0; i < other->sides.size(); i++)
    {
        sides.push_back(other->sides[i]);
    }

    other->sides.clear();
}

void snag_c::RemoveSide(int index)
{
    SYS_ASSERT(index < (int)sides.size());

    sides[index] = sides.back();

    sides.pop_back();
}

void snag_c::RemoveSidesForBrush(const csg_brush_c *B)
{
    for (int k = (int)sides.size() - 1; k >= 0; k--)
    {
        brush_vert_c *V = sides[k];

        if (V->parent == B)
        {
            RemoveSide(k);
        }
    }
}

brush_vert_c *snag_c::FindOneSidedVert(double z)
{
    for (unsigned int i = 0; i < sides.size(); i++)
    {
        brush_vert_c *V = sides[i];

        if (!(V->parent->bkind == BKIND_Solid))
        {
            continue;
        }

        if (z > V->parent->b.z - Z_EPSILON && z < V->parent->t.z + Z_EPSILON)
        {
            return V;
        }
    }

    return NULL;
}

brush_vert_c *snag_c::FindBrushVert(const csg_brush_c *B)
{
    for (unsigned int i = 0; i < sides.size(); i++)
    {
        brush_vert_c *V = sides[i];

        if (V->parent == B)
        {
            return V;
        }
    }

    return NULL;
}

bool snag_c::IsTwoSided() const
{
    region_c *N = partner ? partner->region : NULL;

    return (N && N->gaps.size() > 0);
}

//------------------------------------------------------------------------

region_c::region_c() : snags(), brushes(), entities(), gaps(), degenerate(false), index(-1), shade(0)
{
}

region_c::region_c(const region_c &other)
    : snags(), brushes(), entities(), gaps(), degenerate(false), index(-1), shade(0)
{
    for (unsigned int i = 0; i < other.brushes.size(); i++)
    {
        brushes.push_back(other.brushes[i]);
    }
}

region_c::~region_c()
{
    unsigned int i;

    for (i = 0; i < snags.size(); i++)
    {
        delete snags[i];
    }

    for (i = 0; i < gaps.size(); i++)
    {
        delete gaps[i];
    }
}

void region_c::AddSnag(snag_c *S)
{
    snags.push_back(S);
}

bool region_c::HasSnag(snag_c *S) const
{
    for (unsigned int i = 0; i < snags.size(); i++)
    {
        if (snags[i] == S)
        {
            return true;
        }
    }

    return false;
}

bool region_c::RemoveSnag(snag_c *S)
{
    for (unsigned int i = 0; i < snags.size(); i++)
    {
        if (snags[i] == S)
        {
            snags[i] = snags.back();
            snags.pop_back();
            return true;
        }
    }

    return false;
}

void region_c::AddBrush(csg_brush_c *P)
{
    brushes.push_back(P);
}

void region_c::RemoveBrush(int index)
{
    SYS_ASSERT(index < (int)brushes.size());

    RemoveSidesForBrush(brushes[index]);

    brushes[index] = brushes.back();

    brushes.pop_back();
}

void region_c::AddGap(gap_c *G)
{
    gaps.push_back(G);
}

void region_c::RemoveGap(int index)
{
    int total = (int)gaps.size();

    SYS_ASSERT(index < total);

    for (; index + 1 < total; index++)
    {
        gaps[index] = gaps[index + 1];
    }

    gaps.pop_back();
}

void region_c::MergeOther(region_c *other)
{
    unsigned int i;

    // TODO: snags and brushes should never be duplicated by a merge,
    //       however for robustness we should check and skip them.

    for (i = 0; i < other->snags.size(); i++)
    {
        AddSnag(other->snags[i]);
    }

    for (i = 0; i < other->brushes.size(); i++)
    {
        AddBrush(other->brushes[i]);
    }

    other->snags.clear();
    other->brushes.clear();
}

bool region_c::isClosed() const
{
    if (gaps.size() == 0)
    {
        return true;
    }

    csg_brush_c *B = gaps.front()->bottom;
    csg_brush_c *T = gaps.back()->top;

    return (T->b.z - B->t.z < 9.5);
}

void region_c::GetBounds(double *x1, double *y1, double *x2, double *y2) const
{
    if (snags.empty())
    {
        *x1 = *x2 = *y1 = *y2 = 0;
        return;
    }

    *x1 = *y1 = +9e9;
    *x2 = *y2 = -9e9;

    for (unsigned int i = 0; i < snags.size(); i++)
    {
        const snag_c *S = snags[i];

        *x1 = OBSIDIAN_MIN(*x1, OBSIDIAN_MIN(S->x1, S->x2));
        *y1 = OBSIDIAN_MIN(*y1, OBSIDIAN_MIN(S->y1, S->y2));

        *x2 = OBSIDIAN_MAX(*x1, OBSIDIAN_MAX(S->x1, S->x2));
        *y2 = OBSIDIAN_MAX(*y1, OBSIDIAN_MAX(S->y1, S->y2));
    }
}

void region_c::ComputeMidPoint()
{
    mid_x = mid_y = 0;

    if (snags.empty())
    {
        return;
    }

    for (unsigned int i = 0; i < snags.size(); i++)
    {
        const snag_c *S = snags[i];

        mid_x += S->x1 + S->x2;
        mid_y += S->y1 + S->y2;
    }

    double total = 2 * snags.size();

    mid_x /= total;
    mid_y /= total;
}

void region_c::ComputeBounds()
{
    rw = rh = 0;

    for (unsigned int i = 0; i < snags.size(); i++)
    {
        const snag_c *S = snags[i];

        rw = OBSIDIAN_MAX(rw, fabs(S->x1 - mid_x));
        rh = OBSIDIAN_MAX(rh, fabs(S->y1 - mid_y));
    }
}

bool region_c::ContainsPoint(double x, double y) const
{
    for (unsigned int i = 0; i < snags.size(); i++)
    {
        const snag_c *S = snags[i];

        double d = PerpDist(x, y, S->x1, S->y1, S->x2, S->y2);

        if (d < -SNAG_EPSILON)
        {
            return false;
        }
    }

    return true;
}

double region_c::DistanceToPoint(float x, float y) const
{
    if (ContainsPoint(x, y))
    {
        return 0;
    }

    double best = 9e9;

    for (unsigned int i = 0; i < snags.size(); i++)
    {
        const snag_c *S = snags[i];

        double dist = PointLineDist(x, y, S->x1, S->y1, S->x2, S->y2);

        best = OBSIDIAN_MIN(best, dist);
    }

    return best;
}

double region_c::SquareDistance(float x, float y) const
{
    double bx1, by1, bx2, by2;

    GetBounds(&bx1, &by1, &bx2, &by2);

    double x_dist = (x < bx1) ? (bx1 - x) : (x > bx2) ? (x - bx2) : 0;
    double y_dist = (y < by1) ? (by1 - y) : (y > by2) ? (y - by2) : 0;

    return OBSIDIAN_MAX(x_dist, y_dist);
}

bool region_c::HasSameBrushes(const region_c *other) const
{
    // NOTE WELL: assumes brushes have been sorted

    if (brushes.size() != other->brushes.size())
    {
        return false;
    }

    for (unsigned int i = 0; i < brushes.size(); i++)
    {
        if (brushes[i] != other->brushes[i])
        {
            return false;
        }
    }

    return true;
}

double region_c::TopZ(csg_brush_c *B) const
{
    return B->t.CalcZ(mid_x, mid_y);
}

double region_c::BottomZ(csg_brush_c *B) const
{
    return B->b.CalcZ(mid_x, mid_y);
}

void region_c::ClockwiseSnags()
{
    if (snags.size() < 2)
    {
        return;
    }

    int i;
    int total = (int)snags.size();

    // determine angle of each snag's starting vertex
    double *angles = new double[total];

    for (i = 0; i < total; i++)
    {
        snag_c *S = snags[i];

        angles[i] = CalcAngle(mid_x, mid_y, S->x1, S->y1);
    }

    i = 0;

    while (i + 1 < total)
    {
        snag_c *A = snags[i];
        snag_c *B = snags[i + 1];

        if (angles[i] < angles[i + 1] - OBSIDIAN_ANG_EPSILON)
        {
            // swap 'em
            snags[i]     = B;
            snags[i + 1] = A;

            std::swap(angles[i], angles[i + 1]);

            // bubble down
            if (i > 0)
            {
                i--;
            }
        }
        else
        {
            // bubble up
            i++;
        }
    }

    if (angles)
    {
        delete[] angles;
    }
}

struct csg_brush_ptr_Compare
{
    inline bool operator()(const csg_brush_c *A, const csg_brush_c *B) const
    {
        // want lowest bottom to be first
        if (fabs(A->b.z - B->b.z) >= Z_EPSILON)
        {
            return A->b.z < B->b.z;
        }

        // if bottom is the same, want highest top to be first
        if (fabs(A->t.z - B->t.z) >= Z_EPSILON)
        {
            return A->t.z > B->t.z;
        }

        // tie breaker
        return A < B;
    }
};

void region_c::SortBrushes()
{
    std::sort(brushes.begin(), brushes.end(), csg_brush_ptr_Compare());
}

void region_c::RemoveSidesForBrush(const csg_brush_c *B)
{
    for (unsigned int i = 0; i < snags.size(); i++)
    {
        snags[i]->RemoveSidesForBrush(B);
    }
}

//------------------------------------------------------------------------

gap_c::gap_c(csg_brush_c *B, csg_brush_c *T) : bottom(B), top(T), reachable(false), liquid(NULL)
{
}

gap_c::~gap_c()
{
}

void gap_c::AddNeighbor(gap_c *N)
{
    if (!HasNeighbor(N))
    {
        neighbors.push_back(N);
    }
}

bool gap_c::HasNeighbor(gap_c *N) const
{
    for (unsigned int i = 0; i < neighbors.size(); i++)
    {
        if (neighbors[i] == N)
        {
            return true;
        }
    }

    return false;
}

bsp_node_c::bsp_node_c(double px1, double py1, double px2, double py2)
    : x1(px1), y1(py1), x2(px2), y2(py2), front_node(NULL), front_leaf(NULL), back_node(NULL), back_leaf(NULL),
      bb_x1(0), bb_y1(0), bb_x2(0), bb_y2(0)
{
}

bsp_node_c::~bsp_node_c()
{
    delete front_node;
    delete back_node;
}

void bsp_node_c::ComputeBBox()
{
    bb_x1 = bb_y1 = +9e9;
    bb_x2 = bb_y2 = -9e9;

    if (front_node)
    {
        AddBBox(front_node);
    }
    if (front_leaf)
    {
        AddBBox(front_leaf);
    }

    if (back_node)
    {
        AddBBox(back_node);
    }
    if (back_leaf)
    {
        AddBBox(back_leaf);
    }

    if (bb_x1 > bb_x2)
    {
        bb_x1 = bb_x2 = 0;
    }
    if (bb_y1 > bb_y2)
    {
        bb_y1 = bb_y2 = 0;
    }
}

void bsp_node_c::AddBBox(bsp_node_c *node)
{
    node->ComputeBBox();

    if (node->bb_x2 > node->bb_x1)
    {
        bb_x1 = OBSIDIAN_MIN(bb_x1, node->bb_x1);
        bb_x2 = OBSIDIAN_MAX(bb_x2, node->bb_x2);

        bb_y1 = OBSIDIAN_MIN(bb_y1, node->bb_y1);
        bb_y2 = OBSIDIAN_MAX(bb_y2, node->bb_y2);
    }
}

void bsp_node_c::AddBBox(region_c *leaf)
{
    double x1, y1, x2, y2;

    leaf->GetBounds(&x1, &y1, &x2, &y2);

    bb_x1 = OBSIDIAN_MIN(bb_x1, x1);
    bb_x2 = OBSIDIAN_MAX(bb_x2, x2);

    bb_y1 = OBSIDIAN_MIN(bb_y1, y1);
    bb_y2 = OBSIDIAN_MAX(bb_y2, y2);
}

/***** VARIABLES ******************/

static std::vector<partition_c *> all_partitions;

std::vector<region_c *> all_regions;

bsp_node_c *bsp_root;

//------------------------------------------------------------------------

static void QuantizeVert(const brush_vert_c *V, int *qx, int *qy)
{
    *qx = OBSIDIAN_I_ROUND(V->x / QUANTIZE_GRID);
    *qy = OBSIDIAN_I_ROUND(V->y / QUANTIZE_GRID);
}

static bool OnSameLine(double x1, double y1, double x2, double y2, const snag_c *S, double DIST)
{
    double d1 = PerpDist(S->x1, S->y1, x1, y1, x2, y2);

    if (fabs(d1) > DIST)
    {
        return false;
    }

    double d2 = PerpDist(S->x2, S->y2, x1, y1, x2, y2);

    if (fabs(d2) > DIST)
    {
        return false;
    }

    return true;
}

bool region_c::HasFlattened() const
{
    SYS_ASSERT(!snags.empty());

    unsigned int k;

    double left_x = 9e9, left_y = 9e9;
    double right_x = -9e9, right_y = -9e9;

    // step 1: find a left-most and right-most coordinate

    for (k = 0; k < snags.size(); k++)
    {
        snag_c *S = snags[k];

        if (S->x1 < left_x)
        {
            left_x = S->x1;
            left_y = S->y1;
        }
        if (S->x2 < left_x)
        {
            left_x = S->x2;
            left_y = S->y2;
        }

        if (S->x1 > right_x)
        {
            right_x = S->x1;
            right_y = S->y1;
        }
        if (S->x2 > right_x)
        {
            right_x = S->x2;
            right_y = S->y2;
        }
    }

    // step 2: check if ALL snags are lying on that line

    double DIST = QUANTIZE_GRID / 1.98;

    if (fabs(right_x - left_x) < DIST)
    {
        return true;
    }

    for (k = 0; k < snags.size(); k++)
    {
        snag_c *S = snags[k];

        if (!OnSameLine(left_x, left_y, right_x, right_y, S, DIST))
        {
            return false;
        }
    }

    return true;
}

static void CreateRegion(group_c &root, csg_brush_c *P)
{
    SYS_ASSERT(P);

    // handle map-models
    std::string link_key = P->props.getStr("link_entity");
    if (!link_key.empty())
    {
        CSG_LinkBrushToEntity(P, link_key);
        return;
    }

    if (P->bflags & (BFLAG_Detail | BFLAG_NoClip | BFLAG_NoDraw))
    {
        return;
    }

    region_c *R = new region_c;

    R->AddBrush(P);

    int min_qx = (1 << 30);
    int min_qy = (1 << 30);
    int max_qx = -(1 << 30);
    int max_qy = -(1 << 30);

    // NOTE: brush sides go ANTI-clockwise, region snags go CLOCKWISE,
    //       hence we need to flip them here.

    int total = (int)P->verts.size();

    for (int k = total - 1; k >= 0; k--)
    {
        int k2 = (k + total - 1) % total;

        brush_vert_c *v1 = P->verts[k];
        brush_vert_c *v2 = P->verts[k2];

        int qx1, qy1;
        int qx2, qy2;

        QuantizeVert(v1, &qx1, &qy1);
        QuantizeVert(v2, &qx2, &qy2);

        if (qx1 == qx2 && qy1 == qy2)
        { // degenerate ?
            continue;
        }

#if 0 // vertex quantization is disabled -- probably a bad idea
        snag_c *S = new snag_c(v2, v1->x, qx1 * QUANTIZE_GRID, qy1 * QUANTIZE_GRID,
                qx2 * QUANTIZE_GRID, qy2 * QUANTIZE_GRID); */
#else
        snag_c *S = new snag_c(v2, v1->x, v1->y, v2->x, v2->y);
#endif

        R->AddSnag(S);

        min_qx = OBSIDIAN_MIN(min_qx, OBSIDIAN_MIN(qx1, qx2));
        min_qy = OBSIDIAN_MIN(min_qy, OBSIDIAN_MIN(qy1, qy2));

        max_qx = OBSIDIAN_MAX(max_qx, OBSIDIAN_MAX(qx1, qx2));
        max_qy = OBSIDIAN_MAX(max_qy, OBSIDIAN_MAX(qy1, qy2));
    }

    if (R->snags.size() < 3 || max_qx <= min_qx || max_qy <= min_qy || R->HasFlattened())
    {
        // degenerate region : skip it
        delete R;
    }
    else
    {
        root.AddRegion(R);

        all_regions.push_back(R);
    }
}

#if 0
static void MoveOntoLine(partition_c *part, double *x, double *y)
{
    double along = AlongDist(*x, *y, part->x1,part->y1, part->x2,part->y2);

    AlongCoord(along, part->x1,part->y1, part->x2,part->y2, x, y);
}
#endif

//------------------------------------------------------------------------

int region_c::TestSide(partition_c *part)
{
    bool has_front = false;
    bool has_back  = false;

    for (unsigned int i = 0; i < snags.size(); i++)
    {
        snag_c *S = snags[i];

        double a = PerpDist(S->x1, S->y1, part->x1, part->y1, part->x2, part->y2);
        double b = PerpDist(S->x2, S->y2, part->x1, part->y1, part->x2, part->y2);

        int a_side = (a < -SNAG_EPSILON) ? -1 : (a > SNAG_EPSILON) ? +1 : 0;
        int b_side = (b < -SNAG_EPSILON) ? -1 : (b > SNAG_EPSILON) ? +1 : 0;

        if (a_side == 0 && b_side == 0)
        {
            S->on_node = part;
        }

        if (a_side > 0 || b_side > 0)
        {
            has_front = true;
        }
        if (a_side < 0 || b_side < 0)
        {
            has_back = true;
        }

#if 0 // NOTE: this probably wasn't a good idea after all
      // adjust vertices which sit "nearly" on the line
        if (a_side == 0) MoveOntoLine(part, &S->x1, &S->y1);
        if (b_side == 0) MoveOntoLine(part, &S->x2, &S->y2);
#endif
    }

    if (has_back && has_front)
    {
        return 0;
    }

    return has_back ? -1 : +1;
}

static void DivideOneSnag(snag_c *S, partition_c *part, region_c *front, region_c *back, double *along_min,
                          double *along_max)
{
    // get relationship of lines to each other
    double a = PerpDist(S->x1, S->y1, part->x1, part->y1, part->x2, part->y2);
    double b = PerpDist(S->x2, S->y2, part->x1, part->y1, part->x2, part->y2);

    int a_side = (a < -SNAG_EPSILON) ? -1 : (a > SNAG_EPSILON) ? +1 : 0;
    int b_side = (b < -SNAG_EPSILON) ? -1 : (b > SNAG_EPSILON) ? +1 : 0;

    // THIS SHOULD NOT HAPPEN
    // [regions are convex, therefore a side sitting on the partition means
    //  the whole region lies completely on one side of the partition, and
    //  TestSide() should have detected that]
    // HOWEVER: sometimes regions are a tiny bit broken
    if (a_side == 0 && b_side == 0)
    {
        // this snag runs along the same line as the partition.
        // check whether it goes in the same direction or the opposite.
        if (VectorSameDir(part->x2 - part->x1, part->y2 - part->y1, S->x2 - S->x1, S->y2 - S->y1))
        {
            front->AddSnag(S);
        }
        else
        {
            back->AddSnag(S);
        }

        return;
    }

    // intersection stuff  -- FIXME: duplicated code
    if (a_side != b_side)
    {
        double ix, iy;

        CalcIntersection(S->x1, S->y1, S->x2, S->y2, part->x1, part->y1, part->x2, part->y2, &ix, &iy);

        double along = AlongDist(ix, iy, part->x1, part->y1, part->x2, part->y2);

        *along_min = OBSIDIAN_MIN(*along_min, along);
        *along_max = OBSIDIAN_MAX(*along_max, along);
    }

    // completely on front side?
    if (a_side >= 0 && b_side >= 0)
    {
        front->AddSnag(S);
        return;
    }

    // completely on back side?
    if (a_side <= 0 && b_side <= 0)
    {
        back->AddSnag(S);
        return;
    }

    // when we reach here, we have a and b non-zero and opposite sign,
    // hence this snag will be cut by the partition line.

    SYS_ASSERT(a_side == -b_side);

    double ix, iy;

    CalcIntersection(S->x1, S->y1, S->x2, S->y2, part->x1, part->y1, part->x2, part->y2, &ix, &iy);

    snag_c *T = S->Cut(ix, iy);

    if (a_side < 0)
    {
        back->AddSnag(S);
        front->AddSnag(T);
    }
    else
    {
        front->AddSnag(S);
        back->AddSnag(T);
    }
}

static void DivideOneRegion(region_c *R, partition_c *part, group_c &front, group_c &back)
{
    SYS_ASSERT(!R->snags.empty());

    int side = R->TestSide(part);

    if (side > 0)
    {
        front.AddRegion(R);
        return;
    }
    else if (side < 0)
    {
        back.AddRegion(R);
        return;
    }

    // --- region needs to be split ---

    region_c *N = new region_c(*R);

    all_regions.push_back(N);

    // iterate over a swapped-out version of the region's snags
    // (so we can safely add certain ones back into R->snags)
    std::vector<snag_c *> local_snags;

    std::swap(R->snags, local_snags);

    // compute intersection points
    double along_min = 9e9;
    double along_max = -9e9;

    for (unsigned int i = 0; i < local_snags.size(); i++)
    {
        snag_c *S = local_snags[i];

        DivideOneSnag(S, part, R, N, &along_min, &along_max);
    }

    SYS_ASSERT(!R->snags.empty());
    SYS_ASSERT(!N->snags.empty());

    // --- add the mini snags ---

    // FIXME: SYS_ASSERT(along_max > along_min + SNAG_EPSILON);

    if (along_max > along_min + SNAG_EPSILON)
    {
        const auto [x1, y1] = AlongCoord(along_min, part->x1, part->y1, part->x2, part->y2);
        const auto [x2, y2] = AlongCoord(along_max, part->x1, part->y1, part->x2, part->y2);

        R->AddSnag(new snag_c(x1, y1, x2, y2, part));
        N->AddSnag(new snag_c(x2, y2, x1, y1, part));
    }

    // check if new regions are degenerate, don't keep them

    if (R->snags.size() < 3)
    {
        R->degenerate = true;
        LogPrint("WARNING: region degenerated (%zu snags)\n", R->snags.size());
    }
    else
    {
        front.AddRegion(R);
    }

    if (N->snags.size() < 3)
    {
        N->degenerate = true;
        LogPrint("WARNING: region degenerated (%zu snags)\n", N->snags.size());
    }
    else
    {
        back.AddRegion(N);
    }
}

static region_c *MergeGroup(group_c &group)
{
    region_c *R = group.regs[0];

    for (unsigned int i = 1; i < group.regs.size(); i++)
    {
        R->MergeOther(group.regs[i]);
    }

    // grab the entities
    std::swap(R->entities, group.ents);

    // can now set the 'region' field of snags

    for (unsigned int k = 0; k < R->snags.size(); k++)
    {
        R->snags[k]->region = R;
    }

    // snags themselves get merged/etc in HandleOverlaps()

    return R;
}

static partition_c *AddPartition(const snag_c *S)
{
    all_partitions.push_back(new partition_c(S));

    return all_partitions.back();
}

static partition_c *AddPartition(double x1, double y1, double x2, double y2)
{
    all_partitions.push_back(new partition_c(x1, y1, x2, y2));

    return all_partitions.back();
}

static partition_c *ChoosePartition(group_c &group, bool *reached_chunk)
{
    if (!*reached_chunk)
    {
        // seed-wise binary subdivision thang
        //
        // Instead of finding a side to use as the partition line (which is
        // very slow when there are many sides), we simply pick an arbitrary
        // horizontal or vertical line, preferably somewhere close to the
        // middle of the group.
        //
        // The logic here splits along seed boundaries,
        // which is optimal for avoiding region splits.  It would still work
        // though if the Lua code used a different seed size.

        double gx1, gy1, gx2, gy2;

        group.GetGroupBounds(&gx1, &gy1, &gx2, &gy2);

        int sx1 = floor(gx1 / CHUNK_SIZE + SNAG_EPSILON);
        int sy1 = floor(gy1 / CHUNK_SIZE + SNAG_EPSILON);
        int sx2 = ceil(gx2 / CHUNK_SIZE - SNAG_EPSILON);
        int sy2 = ceil(gy2 / CHUNK_SIZE - SNAG_EPSILON);

        int sw = sx2 - sx1;
        int sh = sy2 - sy1;

        if (sw >= 2 || sh >= 2)
        {
            if (sw >= sh)
            {
                double px = (sx1 + sw / 2) * CHUNK_SIZE;
                return AddPartition(px, gy1, px, OBSIDIAN_MAX(gy2, gy1 + 4));
            }
            else
            {
                double py = (sy1 + sh / 2) * CHUNK_SIZE;
                return AddPartition(gx1, py, OBSIDIAN_MAX(gx2, gx1 + 4), py);
            }
        }

        // we have reached a chunk, yay!
        *reached_chunk = true;
    }

    // inside a single chunk : find a side normally

    // -AJA- An obvious thing to try here is to choose the best
    //       horiz/vert node based on distance to the middle.
    //
    //       I tried it and... no benefit, was slower as well.

    snag_c *poss = NULL;

    for (unsigned int i = 0; i < group.regs.size(); i++)
    {
        region_c *R = group.regs[i];

        for (unsigned int k = 0; k < R->snags.size(); k++)
        {
            snag_c *S = R->snags[k];

            if (S->on_node)
            {
                continue;
            }

            // we prefer an axis-aligned node
            if (S->x1 == S->x2 || S->y1 == S->y2)
            {
                // look no further
                return AddPartition(S);
            }

            poss = S;
        }
    }

    if (poss)
    {
        return AddPartition(poss);
    }

    return NULL;
}

static void DivideOneEntity(csg_entity_c *E, partition_c *part, group_c &front, group_c &back)
{
    double d = PerpDist(E->x, E->y, part->x1, part->y1, part->x2, part->y2);

    if (d >= 0)
    {
        front.AddEntity(E);
    }
    else
    {
        back.AddEntity(E);
    }
}

static void SplitGroup(group_c &group, bool reached_chunk, region_c **leaf_out, bsp_node_c **node_out)
{
    *leaf_out = NULL;
    *node_out = NULL;

    if (group.regs.empty())
    {
        if (!group.ents.empty())
        {
            DebugPrint("SplitGroup: lost %zu entities\n", group.ents.size());
        }

        return;
    }

    // Note: there is no explicit check for convexitiy.  We keep going until
    //       every snag has been on a partition.  This means that a convex
    //       region will usually be "split" multiple times where everything
    //       goes to the front and nothing to the back.
    //
    partition_c *part = ChoosePartition(group, &reached_chunk);

    if (part)
    {
        //    fprintf(stderr, "Partition: %p (%1.2f %1.2f) --> (%1.2f %1.2f)\n",
        //            part, part->x1, part->y1, part->x2, part->y2);

        // divide the group
        group_c front;
        group_c back;

        for (unsigned int i = 0; i < group.regs.size(); i++)
        {
            DivideOneRegion(group.regs[i], part, front, back);
        }

        for (unsigned int k = 0; k < group.ents.size(); k++)
        {
            DivideOneEntity(group.ents[k], part, front, back);
        }

        region_c *front_leaf;
        region_c *back_leaf;

        bsp_node_c *front_node;
        bsp_node_c *back_node;

        // recursively handle each side
        SplitGroup(front, reached_chunk, &front_leaf, &front_node);
        SplitGroup(back, reached_chunk, &back_leaf, &back_node);

        // don't create a node unless there is something on both sides
        if (!(front_leaf || front_node))
        {
            *leaf_out = back_leaf;
            *node_out = back_node;
        }
        else if (!(back_leaf || back_node))
        {
            *leaf_out = front_leaf;
            *node_out = front_node;
        }
        else
        {
            bsp_node_c *node = new bsp_node_c(part->x1, part->y1, part->x2, part->y2);

            node->front_leaf = front_leaf;
            node->front_node = front_node;
            node->back_leaf  = back_leaf;
            node->back_node  = back_node;

            *node_out = node;
        }

        // input group has been consumed now
    }
    else
    {
        // at here, we have a leaf group which is convex,
        // hence merge all the regions into one.

        *leaf_out = MergeGroup(group);
    }
}

//------------------------------------------------------------------------

static void MergeSnags(snag_c *A, snag_c *B)
{
    SYS_ASSERT(A->region);
    SYS_ASSERT(B->region);

    /// -AJA- Hmmmm: why should this be true? (I forget)
    ///
    /// SYS_ASSERT(A->region == B->region);

    if (!B->mini)
    {
        A->mini = false;
        A->TransferSides(B);
    }

    if (B->partner && B->partner->partner == B)
    {
        B->partner->partner = NULL;
    }

    B->region->RemoveSnag(B);
}

static void PartnerSnags(snag_c *A, snag_c *B)
{
    A->partner = B;
    B->partner = A;
}

static bool SplitSnag(snag_c *S, double ix, double iy, std::vector<snag_c *> &overlap_list)
{
    snag_c *T = S->Cut(ix, iy);

    S->region->AddSnag(T);

    overlap_list.push_back(T);

    S->CalcAlongs();
    T->CalcAlongs();

    return true;
}

static bool TestOverlap(std::vector<snag_c *> &list, int i, int k)
{
    snag_c *A = list[i];
    snag_c *B = list[k];

    if (!A || !B)
    {
        return false;
    }

    int a_min = OBSIDIAN_MIN(A->q_along1, A->q_along2);
    int a_max = OBSIDIAN_MAX(A->q_along1, A->q_along2);

    int b_min = OBSIDIAN_MIN(B->q_along1, B->q_along2);
    int b_max = OBSIDIAN_MAX(B->q_along1, B->q_along2);

    if (a_min >= b_max || a_max <= b_min)
    {
        return false;
    }

    // Note: it's possible one of the new (split off) snags is still
    //       overlapping another one.  This will be detected and handled
    //       in a future pass.

    if (B->q_along1 > a_min && B->q_along1 < a_max)
    {
        return SplitSnag(A, B->x1, B->y1, list);
    }

    if (B->q_along2 > a_min && B->q_along2 < a_max)
    {
        return SplitSnag(A, B->x2, B->y2, list);
    }

    if (A->q_along1 > b_min && A->q_along1 < b_max)
    {
        return SplitSnag(B, A->x1, A->y1, list);
    }

    if (A->q_along2 > b_min && A->q_along2 < b_max)
    {
        return SplitSnag(B, A->x2, A->y2, list);
    }

    // to get here, the snags must be directly overlapping.

    SYS_ASSERT(a_min == b_min);
    SYS_ASSERT(a_max == b_max);

    // same direction?
    if (A->q_along1 == B->q_along1)
    {
        MergeSnags(A, B);

        // remove B from list and free it
        for (size_t i = 0; i < list.size(); i++)
        {
            snag_c *S = list[i];
            if (S && S->partner == B)
            {
                DebugPrint("TestOverlap: FOUND DANGLING PARTNER (%zu, %d)\n", i, k);
                S->partner = NULL;
            }
        }
        delete B;
        list[k] = NULL;

        return true;
    }
    else
    {
        PartnerSnags(A, B);

        // mere partnering is not significant (won't need an extra pass)
        return false;
    }
}

static void ProcessOverlapList(std::vector<snag_c *> &overlap_list)
{
    ///??  partition_c *part = overlap_list[0]->on_node;

    //  fprintf(stderr, "ProcessOverlapList: %u snags\n", overlap_list.size());

    for (unsigned int i = 0; i < overlap_list.size(); i++)
    {
        overlap_list[i]->CalcAlongs();
    }

    // TODO: sort list by OBSIDIAN_MIN(q_along), take advantage of that

    int changes;

    do
    {
        changes = 0;

#if 0
        for (int z = 0 ; z < (int)overlap_list.size() ; z++)
            fprintf(stderr, "    snag %p : (%1.0f %1.0f) --> (%1.0f %1.0f)  partner %p\n",
                    overlap_list[z],
                    overlap_list[z] ? overlap_list[z]->x1 : 0,
                    overlap_list[z] ? overlap_list[z]->y1 : 0,
                    overlap_list[z] ? overlap_list[z]->x2 : 0,
                    overlap_list[z] ? overlap_list[z]->y2 : 0,
                    overlap_list[z] ? overlap_list[z]->partner : NULL);
#endif

        // Note that new snags may get added (due to splits) while we are
        // iterating over them.  Removed snags become NULL in the list.

        for (int i = 0; i < (int)overlap_list.size(); i++)
        {
            for (int k = i + 1; k < (int)overlap_list.size(); k++)
            {
                if (TestOverlap(overlap_list, i, k))
                {
                    changes++;
                }
            }
        }

    } while (changes > 0);
}

struct snag_on_node_Compare
{
    inline bool operator()(const snag_c *A, const snag_c *B) const
    {
        return A->on_node < B->on_node;
    }
};

static void CollectAllSnags(std::vector<snag_c *> &list)
{
    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        if (R->degenerate)
        {
            continue;
        }

        for (unsigned int k = 0; k < R->snags.size(); k++)
        {
            snag_c *S = R->snags[k];

            SYS_ASSERT(S->region);

            list.push_back(S);
        }
    }
}

static void HandleOverlaps()
{
    // process each set of snags which lie on the same partition
    // (determined by sorting the snags by their 'on_node' pointer).

    std::vector<snag_c *> all_snags;

    CollectAllSnags(all_snags);

    std::sort(all_snags.begin(), all_snags.end(), snag_on_node_Compare());

    unsigned int i, k;
    unsigned int total = all_snags.size();

    for (i = 0; i < total; i = k + 1)
    {
        k = i;

        while (k + 1 < total && all_snags[k + 1]->on_node == all_snags[k]->on_node)
        {
            k++;
        }

        // fprintf(stderr, "ON NODE %p : %u snags\n", all_snags[i]->on_node,
        // k-i+1);

        if (k > i && all_snags[i]->on_node)
        {
            // copy into a new list, a place where split pieces can go
            std::vector<snag_c *> overlap_list;

            for (; i <= k; i++)
            {
                overlap_list.push_back(all_snags[i]);
            }

            ProcessOverlapList(overlap_list);
        }
    }
}

static void AddBoundingRegion(group_c &group)
{
    double map_x1, map_y1;
    double map_x2, map_y2;

    group.GetGroupBounds(&map_x1, &map_y1, &map_x2, &map_y2);

    SYS_ASSERT(map_x1 < map_x2);
    SYS_ASSERT(map_y1 < map_y2);

    // make the coords integers
    map_x1 = floor(map_x1);
    map_x2 = ceil(map_x2);
    map_y1 = floor(map_y1);
    map_y2 = ceil(map_y2);

    // create the dummy region
    region_c *R = new region_c;

    R->AddSnag(new snag_c(map_x1, map_y1, map_x1, map_y2, NULL));
    R->AddSnag(new snag_c(map_x1, map_y2, map_x2, map_y2, NULL));
    R->AddSnag(new snag_c(map_x2, map_y2, map_x2, map_y1, NULL));
    R->AddSnag(new snag_c(map_x2, map_y1, map_x1, map_y1, NULL));

    group.AddRegion(R);

    all_regions.push_back(R);
}

#if 0 // -AJA- testing showed that this is unnecessary...

static void PruneBSPTree(bsp_node_c * node)
{
    // remove any dead regions from the BSP tree

    if (node->front_leaf && node->front_leaf->degenerate)
        node->front_leaf = NULL;

    if (node->back_leaf && node->back_leaf->degenerate)
        node->back_leaf = NULL;


    if (node->front_node)
    {
        bsp_node_c *sub = node->front_node;

        PruneBSPTree(sub);

        if (! (sub->front_node || sub->front_leaf))
        {
            node->front_node = sub->back_node;
            node->front_leaf = sub->back_leaf;

            sub->back_node = NULL;
            delete sub;
        }
        else if (! (sub->back_node || sub->back_leaf))
        {
            node->front_node = sub->front_node;
            node->front_leaf = sub->front_leaf;

            sub->front_node = NULL;
            delete sub;
        }
    }

    if (node->back_node)
    {
        bsp_node_c *sub = node->back_node;

        PruneBSPTree(sub);

        if (! (sub->front_node || sub->front_leaf))
        {
            node->back_node = sub->back_node;
            node->back_leaf = sub->back_leaf;

            sub->back_node = NULL;
            delete sub;
        }
        else if (! (sub->back_node || sub->back_leaf))
        {
            node->back_node = sub->front_node;
            node->back_leaf = sub->front_leaf;

            sub->front_node = NULL;
            delete sub;
        }
    }
}
#endif

static void RemoveDeadRegions()
{
    int before    = (int)all_regions.size();
    int lost_ents = 0;

    std::vector<region_c *> local_list;

    std::swap(all_regions, local_list);

    for (unsigned int i = 0; i < local_list.size(); i++)
    {
        region_c *R = local_list[i];

        bool dead = R->snags.empty() || R->degenerate;

        if (!dead)
        {
            all_regions.push_back(R);
            continue;
        }

        lost_ents += (int)R->entities.size();

        // snags exist in the all_snags vector, don't free them twice
        R->snags.clear();

        // cannot delete the region here -- it may be in a bsp_node_c
        dead_regions.push_back(R);

        R->degenerate = true; // mark it as dead
    }

    int after = (int)all_regions.size();
    int count = before - after;

    LogPrint("Removed %d dead regions (of %d)\n", count, before);

    if (lost_ents > 0)
    {
        LogPrint("WARNING: %d entities in dead region\n", lost_ents);
    }

    ///  PruneBSPTree(bsp_root);
}

//------------------------------------------------------------------------
//   GAP STUFF
//------------------------------------------------------------------------

static bool CanSwallowBrush(region_c *R, int i, int k)
{
    csg_brush_c *A = R->brushes[i];
    csg_brush_c *B = R->brushes[k];

    if (A->bkind != BKIND_Solid)
    {
        return false;
    }

    // liquids are handled elsewhere
    if (B->bkind == BKIND_Liquid)
    {
        return false;
    }

    return (B->b.z > A->b.z - Z_EPSILON) && (B->t.z < A->t.z + Z_EPSILON);
}

void CSG_SwallowBrushes()
{
    // check each region_c for redundant brushes, ones which are
    // completely surrounded by another brush (on the Z axis).

    int count = 0;
    int total = 0;

    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        total += (int)R->brushes.size();

        R->SortBrushes();

        for (int i = 0; i < (int)R->brushes.size(); i++)
        {
            for (int k = (int)R->brushes.size() - 1; k > i; k--)
            {
                if (CanSwallowBrush(R, i, k))
                {
                    R->RemoveBrush(k);
                    count++;
                }
            }
        }
    }

    LogPrint("Swallowed %d brushes (of %d)\n", count, total);
}

static gap_c *GapForEntity(const region_c *R, csg_entity_c *E)
{
    for (unsigned int i = 0; i < R->gaps.size(); i++)
    {
        gap_c *G = R->gaps[i];

        // allow some leeway
        double z1 = (G->bottom->b.z + G->bottom->t.z) / 2.0;
        double z2 = (G->top->b.z + G->top->t.z) / 2.0;

        if (z1 < E->z && E->z < z2)
        {
            E->ex_floor = (int)i;

            return G;
        }
    }

    return NULL; // not found
}

static void MarkGapsWithEntities()
{
    // this function also sets entity_c::ex_floor

    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        for (unsigned int k = 0; k < R->entities.size(); k++)
        {
            csg_entity_c *E = R->entities[k];

            // ignore lights and boxes
            if (E->Match("light") || E->Match("oblige_sun") || E->Match("oblige_rtlight") || E->Match("oblige_box"))
            {
                continue;
            }

            // ignore map models
            if (!(E->props.getStr("model")).empty())
            {
                continue;
            }

            gap_c *gap = GapForEntity(R, E);

            if (!gap)
            {
                if (!csg_is_clip_hull)
                {
                    LogPrint("WARNING: entity '%s' is inside solid @ "
                             "(%1.0f,%1.0f,%1.0f)\n",
                             E->id.c_str(), E->x, E->y, E->z);
                }
                continue;
            }

            gap->reachable = true;
        }
    }
}

static void CompareRegionGaps(region_c *R1, region_c *R2)
{
    // gaps are sorted from lowest to highest, hence we can optimise
    // the comparison using a staggered approach.
    unsigned int b_idx = 0;
    unsigned int f_idx = 0;

    while (b_idx < R1->gaps.size() && f_idx < R2->gaps.size())
    {
        gap_c *B = R1->gaps[b_idx];
        gap_c *F = R2->gaps[f_idx];

        // FIXME : compute these at middle of the snag
        double B_z1 = R1->TopZ(B->bottom);
        double B_z2 = R1->BottomZ(B->top);

        double F_z1 = R2->TopZ(F->bottom);
        double F_z2 = R2->BottomZ(F->top);

        if (B_z2 < F_z1 + Z_EPSILON)
        {
            b_idx++;
            continue;
        }
        if (F_z2 < B_z1 + Z_EPSILON)
        {
            f_idx++;
            continue;
        }

        // connection found
        B->AddNeighbor(F);
        F->AddNeighbor(B);

        if (F_z2 < B_z2)
        {
            f_idx++;
        }
        else
        {
            b_idx++;
        }
    }
}

static void BuildNeighborMap()
{
    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        for (unsigned int k = 0; k < R->snags.size(); k++)
        {
            snag_c *S = R->snags[k];
            snag_c *T = S->partner;

            if (!S->region)
            {
                continue;
            }

            if (!T || !T->region)
            {
                continue;
            }

            // FIXME??  SYS_ASSERT(T->region != R);
            if (T->region == R)
            {
                continue;
            }

            // no need to repeat the checks (only do one side)
            if (T->region >= R)
            {
                continue;
            }

            CompareRegionGaps(R, T->region);
        }
    }
}

static void SpreadReachability(void)
{
    // Algorithm: spread the 'reachable' flag from each gap to
    //            every neighbour, until it cannot spread any
    //            further.  Then all gaps without the flag are
    //            unreachable and should be filled.

    // firstly, allow brushes to force reachable flag

    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        for (unsigned int k = 0; k < R->gaps.size(); k++)
        {
            gap_c *G = R->gaps[k];

            if (!(G->bottom->t.face.getStr("reachable")).empty() || !(G->top->b.face.getStr("reachable")).empty())
            {
                G->reachable = true;
            }
        }
    }

    int changes;

    do
    {
        changes = 0;

        for (unsigned int i = 0; i < all_regions.size(); i++)
        {
            region_c *R = all_regions[i];

            for (unsigned int k = 0; k < R->gaps.size(); k++)
            {
                gap_c *G = R->gaps[k];

                if (!G->reachable)
                {
                    continue;
                }

                for (unsigned int n = 0; n < G->neighbors.size(); n++)
                {
                    gap_c *H = G->neighbors[n];

                    if (!H->reachable)
                    {
                        H->reachable = true;
                        changes++;
                    }
                }
            }
        }
    } while (changes > 0);
}

static void RemoveUnusedGaps()
{
    // statistics
    int total  = 0;
    int filled = 0;

    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        total += (int)R->gaps.size();

        // must go backwards to allow removal to work properly
        for (int k = (int)R->gaps.size() - 1; k >= 0; k--)
        {
            gap_c *G = R->gaps[k];

            if (!G->reachable)
            {
                filled++;

                R->RemoveGap(k);

                delete G;
            }
        }
    }

    if (filled == total)
    {
        FatalError("CSG: all gaps were unreachable (no entities?)\n");
    }

    LogPrint("Filled %d gaps (of %d total)\n", filled, total);
}

struct csg_brush_bz_Compare
{
    inline bool operator()(const csg_brush_c *A, const csg_brush_c *B) const
    {
        return A->b.z < B->b.z;
    }
};

static void DiscoverThemGaps()
{
    // Algorithm:
    //
    // sort the brushes by ascending z1 values.
    // Hence any gap must occur between two adjacent entries.
    // We also must check the gap is not covered by a previous
    // brush, done by maintaining a ref to the brush with the
    // currently highest z2 value.

    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        // collect all the solid brushes
        // [ detail brushes are skipped, and clip brushes ]
        std::vector<csg_brush_c *> solids;

        for (unsigned int n = 0; n < R->brushes.size(); n++)
        {
            csg_brush_c *B = R->brushes[n];

            if (B->bkind == BKIND_Solid)
            {
                solids.push_back(B);
            }
        }

        if (solids.size() <= 1)
        {
            continue;
        }

        std::sort(solids.begin(), solids.end(), csg_brush_bz_Compare());

        csg_brush_c *high = solids[0];

        for (unsigned int k = 1; k < solids.size(); k++)
        {
            csg_brush_c *A = solids[k];

            if (R->BottomZ(A) > R->TopZ(high) + Z_EPSILON)
            {
                // found a gap
                gap_c *gap = new gap_c(high, A);

                R->AddGap(gap);

                high = A;
                continue;
            }

            // no gap implies that these two brushes touch/overlap,
            // hence update the highest one.

            if (R->TopZ(A) > R->TopZ(high))
            {
                high = A;
            }
        }
    }
}

void DetermineLiquids()
{
    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        if (R->gaps.empty())
        {
            continue;
        }

        double low_z  = R->gaps.front()->bottom->b.z;
        double high_z = R->gaps.back()->top->t.z;

        for (int k = (int)R->brushes.size() - 1; k >= 0; k--)
        {
            csg_brush_c *B = R->brushes[k];

            if (B->bkind != BKIND_Liquid)
            {
                continue;
            }

            // liquid is completely in the void?
            if (B->t.z < low_z + Z_EPSILON || B->b.z > high_z - Z_EPSILON)
            {
                continue;
            }

            // find gap for this liquid
            // FIXME: improve how slopes are handled
            for (int g = (int)R->gaps.size() - 1; g >= 0; g--)
            {
                gap_c *gap   = R->gaps[g];
                double mid_z = (gap->bottom->b.z + gap->bottom->t.z) * 0.5;

                if (R->TopZ(B) > mid_z)
                {
                    gap->liquid = B;
                    break;
                }
            }
        }
    }
}

void CSG_DiscoverGaps()
{
    DiscoverThemGaps();

    MarkGapsWithEntities();

    BuildNeighborMap();

    SpreadReachability();

    RemoveUnusedGaps();

    DetermineLiquids();

    // call this again to set entity 'ex_floor' field
    // (gap removal can invalidate the previously found value).
    MarkGapsWithEntities();
}

void CSG_BSP(double grid, bool is_clip_hull)
{
    CSG_BSP_Free();

    QUANTIZE_GRID = grid;

    csg_is_clip_hull = is_clip_hull;

    group_c root;

    // create a region for every brush
    for (unsigned int i = 0; i < all_brushes.size(); i++)
    {
        CreateRegion(root, all_brushes[i]);
    }

    for (unsigned int i = 0; i < all_entities.size(); i++)
    {
        root.AddEntity(all_entities[i]);
    }

    // create a rectangle region around whole map
    AddBoundingRegion(root);

    region_c *bsp_leaf;

    SplitGroup(root, false /* reached_chunk */, &bsp_leaf, &bsp_root);

    // all valid maps will get a root node -- this is only for sanity
    if (!bsp_root)
    {
        bsp_root = new bsp_node_c(0, 0, 0, 777);
    }

    bsp_root->ComputeBBox();

    HandleOverlaps();

    RemoveDeadRegions();

    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        R->ComputeMidPoint();
        R->ComputeBounds();
        R->ClockwiseSnags();
    }

    // CSG_SwallowBrushes();

    CSG_DiscoverGaps();
}

region_c *CSG_PointInRegion(double x, double y)
{
    for (unsigned int i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        if (R->ContainsPoint(x, y))
        {
            return R;
        }
    }

    return NULL; // not found
}

void CSG_BSP_Free()
{
    unsigned int i;

    for (i = 0; i < all_partitions.size(); i++)
    {
        delete all_partitions[i];
    }

    for (i = 0; i < all_regions.size(); i++)
    {
        delete all_regions[i];
    }

    for (i = 0; i < dead_regions.size(); i++)
    {
        delete dead_regions[i];
    }

    all_partitions.clear();
    all_regions.clear();
    dead_regions.clear();

    delete bsp_root;
    bsp_root = NULL;
}

//------------------------------------------------------------------------
//   TESTING GOODIES
//------------------------------------------------------------------------

#ifdef CSG_DEBUG_BSP

#include "g_doom.h"

static std::map<int, int> test_vertices;

static int TestVertex(snag_c *S, int which)
{
    int RX = (rand() & 3) - 1;
    int RY = (rand() & 3) - 1;

    double x = which ? S->x2 : S->x1;
    double y = which ? S->y2 : S->y1;

    int ix = OBSIDIAN_I_ROUND(x + RX * 0);
    int iy = OBSIDIAN_I_ROUND(y + RY * 0);

    int id = (iy << 16) + ix;

    if (test_vertices.find(id) != test_vertices.end())
        return test_vertices[id];

    int vert = DM_NumVertexes();

    test_vertices[id] = vert;

    DM_AddVertex(ix, iy);

    return vert;
}

void CSG_TestRegions_Doom()
{
    // for debugging only: each region_c becomes a single sector.

    CSG_BSP(4.0);

    test_vertices.clear();

    unsigned int i, k;

    int swob = 0; // snags without brushes
    int bwos = 0; // brushes without snags

    int degens = 0;
    int badref = 0;

    int line_id = 0;

    for (i = 0; i < all_regions.size(); i++)
    {
        region_c *R = all_regions[i];

        if (!R->brushes.empty() && R->snags.empty())
            bwos++;
        if (!R->snags.empty() && R->brushes.empty())
            swob++;

        const char *flat = "FWATER1";

        if (R->brushes.size() > 0)
        {
            csg_brush_c *B = R->brushes[0];

            flat = B->t.face.getStr("tex", "FLAT10");
        }

        int sec_id = DM_NumSectors();

        DM_AddSector(0, flat, 144, flat, (int)R->brushes.size(), 0, (int)R->snags.size());

        DM_AddSidedef(sec_id, "-", "-", "-", 0, 0);

        for (k = 0; k < R->entities.size(); k++)
        {
            csg_entity_c *E = R->entities[k];

            DM_AddThing(OBSIDIAN_I_ROUND(E->x), OBSIDIAN_I_ROUND(E->y), 0, 11, sec_id, 7, 0, 0, NULL);
        }

        for (k = 0; k < R->snags.size(); k++)
        {
            snag_c *S = R->snags[k];

            if (S->partner && S->partner->partner != S)
                badref++;

            int v1 = TestVertex(S, 0);
            int v2 = TestVertex(S, 1);

            if (v1 == v2) // degenerate
            {
                degens++;
                continue;
            }

            DM_AddLinedef(v1, v2, sec_id, -1, S->partner ? 1 : 0, 1 /*impassible*/, 0, NULL /* args */);
            line_id++;
        }
    }

    fprintf(stderr, "DEGEN LINES: %d  BAD REF: %d  NORMAL: %d\n", degens, badref, line_id);
    fprintf(stderr, "REGION SwoB: %d  BwoS:    %d  TOTAL: %u\n", swob, bwos, all_regions.size());
}

#endif // DEBUG_CSG_BSP

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
