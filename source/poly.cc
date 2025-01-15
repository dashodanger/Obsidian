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

#include <stddef.h>

#include "lib_util.h"
#include "poly.h"
#include "poly_map.h"
#include "poly_util.h"
#include "sys_debug.h"
#include "sys_macro.h"

#define AJPOLY_DEBUG_POLY 0

namespace ajpoly
{

// the currently processed sector
sector_c *build_sector;

const int SPLIT_FACTOR = 10;
const int MISS_FACTOR  = 47;

const double NEAR_MISS_LEN = 8.0;

/*
 * an "intersection" remembers a vertex that sits on a partition line
 * (especially a new vertex created at an edge split).
 */
class intersect_c
{
  public:
    // link in list
    intersect_c *next;
    intersect_c *prev;

    // vertex in question
    vertex_c *vertex;

    // how far along the partition line the vertex is.
    // zero is at the partition start vertex, and positive values move
    // in the same direction as the partition.
    // the intersection list is kept sorted by this value.
    double along_dist;

    // open flag on each side of the vertex (along the partition)
    int before;
    int after;
};

intersect_c *quick_alloc_cuts = NULL;

intersect_c *NewIntersection()
{
    intersect_c *cut;

    if (quick_alloc_cuts)
    {
        cut = quick_alloc_cuts;

        quick_alloc_cuts = cut->next;
    }
    else
    {
        cut = new intersect_c;
    }

    return cut;
}

void FreeQuickAllocCuts()
{
    while (quick_alloc_cuts)
    {
        intersect_c *cut = quick_alloc_cuts;
        quick_alloc_cuts = cut->next;

        delete cut;
    }
}

void InsertEdge(edge_c **list_ptr, edge_c *E)
{
    E->next = *list_ptr;

    (*list_ptr) = E;
}

#if AJPOLY_DEBUG_POLY
void DumpEdges(edge_c *edge_list)
{
    for (edge_c *cur = edge_list; cur; cur = cur->next)
    {
        LogPrint("  edge #%d (%s)  sector=%d  (%1.1f %1.1f) -> (%1.1f %1.1f)\n", cur->index,
                 cur->linedef ? "LINE" : "mini", cur->sector->index, cur->start->x, cur->start->y, cur->end->x,
                 cur->end->y);
    }
}
#endif

void edge_c::Recompute()
{
    psx = start->x;
    psy = start->y;
    pex = end->x;
    pey = end->y;
    pdx = pex - psx;
    pdy = pey - psy;

    p_length = hypot(pdx, pdy);
    p_angle  = ComputeAngle(pdx, pdy);

    if (p_length <= 0)
    {
        FatalError("INTERNAL ERROR: edge has zero length!\n");
    }

    p_perp = psy * pdx - psx * pdy;
    p_para = -psx * pdx - psy * pdy;
}

double edge_c::AlongDist(double x, double y) const
{
    return (x * pdx + y * pdy + p_para) / p_length;
}

double edge_c::PerpDist(double x, double y) const
{
    return (x * pdy - y * pdx + p_perp) / p_length;
}

void edge_c::CopyInfo(const edge_c *other)
{
    start = other->start;
    end   = other->end;

    linedef = other->linedef;
    sector  = other->sector;
    side    = other->side;
}

edge_c *SplitEdge(edge_c *old_edge, double x, double y)
{
#if AJPOLY_DEBUG_POLY
    LogPrint("Splitting Edge #%d (line #%d) at (%1.1f,%1.1f)\n", old_edge->index,
             old_edge->linedef ? old_edge->linedef->index : -1, x, y);
#endif

    vertex_c *vert = NewVertexFromSplit(old_edge, x, y);

    edge_c *new_edge = NewEdge();

    new_edge->CopyInfo(old_edge);

    old_edge->end = vert;
    old_edge->Recompute();

    new_edge->start = vert;
    new_edge->Recompute();

#if AJPOLY_DEBUG_POLY
    LogPrint("Splitting Vertex is %04X at (%1.1f,%1.1f)\n", vert->index, vert->x, vert->y);
#endif

    // handle partners

    if (old_edge->partner)
    {
#if AJPOLY_DEBUG_POLY
        LogPrint("Splitting partner #%d\n", old_edge->partner->index);
#endif

        new_edge->partner = NewEdge();

        new_edge->partner->CopyInfo(old_edge->partner);

        // IMPORTANT: keep partner relationship valid
        new_edge->partner->partner = new_edge;

        old_edge->partner->start = vert;
        old_edge->partner->Recompute();

        new_edge->partner->end = vert;
        new_edge->partner->Recompute();

        // link it into list
        new_edge->partner->next = old_edge->partner->next;
        old_edge->partner->next = new_edge->partner;
    }

    return new_edge;
}

inline void CalcIntersection(edge_c *cur, edge_c *part, double perp_c, double perp_d, double *x, double *y)
{
    // 0 = start, 1 = end
    double ds = perp_c / (perp_c - perp_d);

    if (cur->pdx == 0)
    {
        *x = cur->psx;
    }
    else
    {
        *x = cur->psx + (cur->pdx * ds);
    }

    if (cur->pdy == 0)
    {
        *y = cur->psy;
    }
    else
    {
        *y = cur->psy + (cur->pdy * ds);
    }
}

void AddIntersection(intersect_c **cut_list, vertex_c *vert, edge_c *part)
{
    intersect_c *cut;

    // check if vertex already present
    for (cut = (*cut_list); cut; cut = cut->next)
    {
        if (vert == cut->vertex)
        {
            return;
        }
    }

    // create new intersection
    cut = NewIntersection();

    cut->vertex     = vert;
    cut->along_dist = part->AlongDist(vert->x, vert->y);

    sector_c *before = vert->CheckOpen(-part->pdx, -part->pdy);
    sector_c *after  = vert->CheckOpen(part->pdx, part->pdy);

    cut->before = (before == build_sector) ? 1 : 0;
    cut->after  = (after == build_sector) ? 1 : 0;

    // find place for new intersection, and link it in...
    intersect_c *next;

    for (next = (*cut_list); next && next->next; next = next->next)
    {
    }

    while (next && cut->along_dist < next->along_dist)
    {
        next = next->prev;
    }

    cut->next = next ? next->next : (*cut_list);
    cut->prev = next;

    if (next)
    {
        if (next->next)
        {
            next->next->prev = cut;
        }

        next->next = cut;
    }
    else
    {
        if (*cut_list)
        {
            (*cut_list)->prev = cut;
        }

        (*cut_list) = cut;
    }
}

int EvalPartition(edge_c *part, edge_c *edge_list)
{
    int cost   = 0;
    int splits = 0;

    int near_miss = 0;

    int real_left  = 0;
    int real_right = 0;
    int mini_left  = 0;
    int mini_right = 0;

    double qnty;

    /* check partition against all the edges */

    for (edge_c *check = edge_list; check; check = check->next)
    {
        // get relationship of edge to the partition
        double a = part->PerpDist(check->psx, check->psy);
        double b = part->PerpDist(check->pex, check->pey);

        if (part->source_line && check->source_line == part->source_line)
        {
            a = b = 0;
        }

        double fa = fabs(a);
        double fb = fabs(b);

        int a_side = (fa <= OBSIDIAN_POLY_EPSILON) ? 0 : (a < 0) ? -1 : +1;
        int b_side = (fb <= OBSIDIAN_POLY_EPSILON) ? 0 : (b < 0) ? -1 : +1;

        // check for being on the same line
        if (a_side == 0 && b_side == 0)
        {
            if (check->pdx * part->pdx + check->pdy * part->pdy < 0)
            {
                if (check->linedef)
                    real_left += 1;
                else
                    mini_left += 1;
            }
            else
            {
                if (check->linedef)
                    real_right += 1;
                else
                    mini_right += 1;
            }

            continue;
        }

        // check for near misses.  These are bad since they cause short
        // edges to be created (either now or in future processing).

        if (a_side != 0 && fa < NEAR_MISS_LEN)
        {
            near_miss++;

            // the closer to the end, the higher the cost
            qnty = NEAR_MISS_LEN / fa;

            cost += (int)(100 * MISS_FACTOR * qnty * qnty);
        }

        if (b_side != 0 && fb < NEAR_MISS_LEN)
        {
            near_miss++;

            qnty = NEAR_MISS_LEN / fb;

            cost += (int)(100 * MISS_FACTOR * qnty * qnty);
        }

        // check for right side
        if (a_side >= 0 && b_side >= 0)
        {
            if (check->linedef)
                real_right += 1;
            else
                mini_right += 1;
            continue;
        }

        // check for left side
        if (a_side <= 0 && b_side <= 0)
        {
            if (check->linedef)
                real_left += 1;
            else
                mini_left += 1;
            continue;
        }

        // When we reach here, we have a and b non-zero and opposite sign,
        // hence this edge will be split by the partition line.

        splits++;

        cost += 100 * SPLIT_FACTOR;
    }

    // make sure there is at least one linedef on each side
    if (real_left == 0 || real_right == 0)
    {
#if AJPOLY_DEBUG_POLY
        LogPrint("Eval : No linedefs on %s%sside\n", real_left ? "" : "left ", real_right ? "" : "right ");
#endif

        return -1;
    }

    // increase cost by the difference between left and right
    cost += 100 * OBSIDIAN_ABS(real_left - real_right);
    cost += 30 * OBSIDIAN_ABS(mini_left - mini_right);

    // show a slight preference for purely horizontally or vertical
    // partition lines.
    if (part->pdx != 0 && part->pdy != 0)
    {
        cost += 60;
    }

#if AJPOLY_DEBUG_POLY
    LogPrint("Eval %p: splits=%d near_miss=%d left=%d+%d right=%d+%d "
             "cost=%d.%02d\n",
             part, splits, near_miss, real_left, mini_left, real_right, mini_right, cost / 100, cost % 100);
#endif

    return cost;
}

void DivideAnEdge(edge_c *cur, edge_c *part, edge_c **left_list, edge_c **right_list, intersect_c **cut_list)
{
    /* edge will either move left, move right, or be split */

    // get relationship of edge to the partition
    double a = part->PerpDist(cur->psx, cur->psy);
    double b = part->PerpDist(cur->pex, cur->pey);

    if (part->source_line && cur->source_line == part->source_line)
    {
        a = b = 0;
    }

    int a_side = (fabs(a) <= OBSIDIAN_POLY_EPSILON) ? 0 : (a < 0) ? -1 : +1;
    int b_side = (fabs(b) <= OBSIDIAN_POLY_EPSILON) ? 0 : (b < 0) ? -1 : +1;

    // check for being on the same line
    if (a_side == 0 && b_side == 0)
    {
        AddIntersection(cut_list, cur->start, part);
        AddIntersection(cut_list, cur->end, part);

        // this edge runs along the same line as the partition.
        // check whether it goes in the same direction or the opposite.

        if (cur->pdx * part->pdx + cur->pdy * part->pdy < 0)
        {
            InsertEdge(left_list, cur);
        }
        else
        {
            InsertEdge(right_list, cur);
        }

        return;
    }

    // check for right side
    if (a_side >= 0 && b_side >= 0)
    {
        if (a_side == 0)
        {
            AddIntersection(cut_list, cur->start, part);
        }
        if (b_side == 0)
        {
            AddIntersection(cut_list, cur->end, part);
        }

        InsertEdge(right_list, cur);
        return;
    }

    // check for left side
    if (a_side <= 0 && b_side <= 0)
    {
        if (a_side == 0)
        {
            AddIntersection(cut_list, cur->start, part);
        }
        if (b_side == 0)
        {
            AddIntersection(cut_list, cur->end, part);
        }

        InsertEdge(left_list, cur);
        return;
    }

    // when we reach here, we have a and b non-zero and opposite sign,
    // hence this edge will be split by the partition line.

    double x, y;

    CalcIntersection(cur, part, a, b, &x, &y);

    edge_c *newbie = SplitEdge(cur, x, y);

    AddIntersection(cut_list, cur->end, part);

    if (a < 0)
    {
        InsertEdge(left_list, cur);
        InsertEdge(right_list, newbie);
    }
    else
    {
        InsertEdge(right_list, cur);
        InsertEdge(left_list, newbie);
    }
}

edge_c *ChoosePartition(edge_c *edge_list, int depth)
{
    edge_c *best = NULL;

    int best_cost = 1 << 30;

#if AJPOLY_DEBUG_POLY
    LogPrint("ChoosePartition: BEGUN (depth %d)\n", depth);
#endif

    for (edge_c *part = edge_list; part; part = part->next)
    {
        // ignore edges which are not from a linedef
        if (!part->linedef)
        {
            continue;
        }

        int cost = EvalPartition(part, edge_list);

#if AJPOLY_DEBUG_POLY
        LogPrint("ChoosePartition: EDGE #%d -> cost:%d  | sector:%d  (%1.1f %1.1f) "
                 "-> (%1.1f %1.1f)\n",
                 part->index, cost, part->sector->index, part->start->x, part->start->y, part->end->x, part->end->y);
#endif

        // unsuitable or too costly?
        if (cost < 0 || cost >= best_cost)
        {
            continue;
        }

        best      = part;
        best_cost = cost;
    }

#if AJPOLY_DEBUG_POLY
    if (!best)
    {
        LogPrint("ChoosePartition: NO BEST FOUND\n");
    }
    else
    {
        LogPrint("ChoosePartition: Best has score %d.%02d  (%1.1f %1.1f) -> (%1.1f "
                 "%1.1f)\n",
                 best_cost / 100, best_cost % 100, best->start->x, best->start->y, best->end->x, best->end->y);
    }
#endif

    return best;
}

// remove all the edges from the list, sending them into the left
// or right lists based on the given partition line (may get split too).
// adds any intersections onto the intersection list as it goes.
//
void DivideEdges(edge_c *edge_list, edge_c *part, edge_c **left_list, edge_c **right_list, intersect_c **cut_list)
{
    while (edge_list)
    {
        edge_c *cur = edge_list;
        edge_list   = edge_list->next;

        DivideAnEdge(cur, part, left_list, right_list, cut_list);
    }
}

void EdgesAlongPartition(edge_c *part, edge_c **left_list, edge_c **right_list, intersect_c *cut_list)
{
    if (!cut_list)
    {
        return;
    }

#if AJPOLY_DEBUG_POLY
    LogPrint("CUT LIST:\n");
    LogPrint("PARTITION: (%1.1f %1.1f) += (%1.1f %1.1f)\n", part->psx, part->psy, part->pdx, part->pdy);

    for (intersect_c *I = cut_list; I; I = I->next)
    {
        LogPrint("  Vertex %8X (%1.1f,%1.1f)  Along %1.2f  [%d/%d]\n", I->vertex->index, I->vertex->x, I->vertex->y,
                 I->along_dist, I->before, I->after);
    }
#endif

    // STEP 1: fix problems the intersection list...

    intersect_c *cur  = cut_list;
    intersect_c *next = cur->next;

    while (cur && next)
    {
        double len = next->along_dist - cur->along_dist;

        if (len < -0.1)
        {
            FatalError("INTERNAL ERROR: intersect list not sorted\n");
        }

        if (len > 0.2)
        {
            cur  = next;
            next = cur->next;
            continue;
        }

        // merge the two intersections into one

#if AJPOLY_DEBUG_POLY
        LogPrint("Merging cut (%1.0f,%1.0f) [%d/%d] with %p (%1.0f,%1.0f) [%d/%d]\n", cur->vertex->x, cur->vertex->y,
                 cur->before, cur->after, next->vertex, next->vertex->x, next->vertex->y, next->before, next->after);
#endif

        if (!cur->before && next->before)
        {
            cur->before = next->before;
        }

        if (!cur->after && next->after)
        {
            cur->after = next->after;
        }

#if AJPOLY_DEBUG_POLY
        LogPrint("---> merged (%1.0f,%1.0f) [%d/%d]\n", cur->vertex->x, cur->vertex->y, cur->before, cur->after);
#endif

        // free the unused cut

        cur->next = next->next;

        next->next       = quick_alloc_cuts;
        quick_alloc_cuts = next;

        next = cur->next;
    }

    // STEP 2: find connections in the intersection list...

    for (cur = cut_list; cur && cur->next; cur = cur->next)
    {
        next = cur->next;

        if (!cur->after && !next->before)
        {
            continue;
        }

        // check for some nasty OPEN/CLOSED or CLOSED/OPEN cases
        if ((cur->after && !next->before) || (!cur->after && next->before))
        {
            continue;
        }

        /* Righteo, we have definite open space here */

        // create the edge pair
        edge_c *edge  = NewEdge();
        edge_c *buddy = NewEdge();

        edge->partner  = buddy;
        buddy->partner = edge;

        edge->start = cur->vertex;
        edge->end   = next->vertex;
        edge->Recompute();

        buddy->start = next->vertex;
        buddy->end   = cur->vertex;
        buddy->Recompute();

        // leave 'linedef' field as NULL.
        // leave 'side' as zero too (not needed here)

        edge->sector  = build_sector;
        buddy->sector = build_sector;

        edge->source_line  = part->linedef;
        buddy->source_line = part->linedef;

        // add the new edges to the appropriate lists
        InsertEdge(right_list, edge);
        InsertEdge(left_list, buddy);

#if AJPOLY_DEBUG_POLY
        LogPrint("EdgesAlongPartition: %p RIGHT  sector %d  (%1.1f %1.1f) -> (%1.1f "
                 "%1.1f)\n",
                 edge, edge->sector ? edge->sector->index : -1, edge->start->x, edge->start->y, edge->end->x,
                 edge->end->y);

        LogPrint("EdgesAlongPartition: %p LEFT   sector %d  (%1.1f %1.1f) -> (%1.1f "
                 "%1.1f)\n",
                 buddy, buddy->sector ? buddy->sector->index : -1, buddy->start->x, buddy->start->y, buddy->end->x,
                 buddy->end->y);
#endif
    }

    // free intersection structures into quick-alloc list
    while (cut_list)
    {
        cur      = cut_list;
        cut_list = cur->next;

        cur->next        = quick_alloc_cuts;
        quick_alloc_cuts = cur;
    }
}

//------------------------------------------------------------------------

int polygon_c::CountEdges() const
{
    int count = 0;

    for (edge_c *cur = edge_list; cur; cur = cur->next)
    {
        count++;
    }

    return count;
}

void polygon_c::CalcMiddle()
{
    mid_x = 0;
    mid_y = 0;

    int total = 0;

    for (edge_c *E = edge_list; E; E = E->next)
    {
        mid_x += E->start->x + E->end->x;
        mid_y += E->start->y + E->end->y;

        total += 2;
    }

    mid_x = mid_x / total;
    mid_y = mid_y / total;
}

bool polygon_c::ContainsPoint(double x, double y) const
{
    // this is large, matching the precision of DOOM vertices
    const double epsilon = 0.99;

    for (edge_c *E = edge_list; E; E = E->next)
    {
        double d = E->PerpDist(x, y);

        if (d < -epsilon)
        {
            return false;
        }
    }

    return true;
}

static constexpr size_t EDGE_BUFFER_SIZE = 32;

void polygon_c::ClockwiseOrder()
{
    edge_c  *cur;
    edge_c **array;
    edge_c  *edge_buffer[EDGE_BUFFER_SIZE];

    int i;
    int total = 0;

#if AJPOLY_DEBUG_POLY
    LogPrint("Polygon: Clockwising #%d (sector #%d)\n", index, sector->index);
#endif

    // count edges and create an array to manipulate them
    for (cur = edge_list; cur; cur = cur->next)
    {
        total++;
    }

    // use local array if small enough
    if (total <= EDGE_BUFFER_SIZE)
    {
        array = edge_buffer;
    }
    else
    {
        array = new edge_c *[total];
    }

    for (cur = edge_list, i = 0; cur; cur = cur->next, i++)
    {
        array[i] = cur;
    }

    if (i != total)
    {
        FatalError("INTERNAL ERROR: ClockwiseOrder miscounted\n");
    }

    // sort them by angle (from the middle point to the start vertex).
    // the desired order (clockwise) means descending angles.

    i = 0;

    while (i + 1 < total)
    {
        edge_c *A = array[i];
        edge_c *B = array[i + 1];

        double angle1 = ComputeAngle(A->start->x - mid_x, A->start->y - mid_y);
        double angle2 = ComputeAngle(B->start->x - mid_x, B->start->y - mid_y);

        if (angle1 + OBSIDIAN_ANG_EPSILON < angle2)
        {
            // swap 'em
            array[i]     = B;
            array[i + 1] = A;

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

    // transfer sorted array back into the polygon
    edge_list = NULL;

    for (i = total - 1; i >= 0; i--)
    {
        array[i]->next = edge_list;
        edge_list      = array[i];
    }

    if (total > EDGE_BUFFER_SIZE)
    {
        delete[] array;
    }

#if 0 // DEBUGGING
    LogPrint("Sorted edges around (%1.1f %1.1f)\n", poly->mid_x, poly->mid_y);

    for (cur = edge_list ; cur ; cur = cur->next)
    {
        double angle = ComputeAngle(cur->start->x - mid_x, cur->start->y - mid_y);

        LogPrint("  edge #%d : angle %1.6f  (%1.1f %1.1f) -> (%1.1f %1.1f)\n",
                    cur->index, angle,
                    cur->start->x, cur->start->y,
                    cur->end->x, cur->end->y);
    }
#endif
}

polygon_c *CreatePolygon(edge_c *edge_list)
{
    polygon_c *poly = NewPolygon();

    poly->sector    = build_sector;
    poly->edge_list = edge_list;

    poly->CalcMiddle();

#if AJPOLY_DEBUG_POLY
    LogPrint("Created Polygon #%d @ (%1.1f %1.1f)\n", poly->index, poly->mid_x, poly->mid_y);
    DumpEdges(edge_list);
#endif

    return poly;
}

bool RecursiveDivideEdges(edge_c *edge_list, int depth)
{
#if AJPOLY_DEBUG_POLY
    LogPrint("Build: BEGUN @ %d\n", depth);

    DumpEdges(edge_list);
#endif

    // try to find a partition -- none means convex

    edge_c *part = ChoosePartition(edge_list, depth);

    if (!part)
    {
#if AJPOLY_DEBUG_POLY
        LogPrint("Build: CONVEX\n");
#endif
        CreatePolygon(edge_list);
        return true; // OK
    }

#if AJPOLY_DEBUG_POLY
    LogPrint("Build: PARTITION %p (%1.0f,%1.0f) -> (%1.0f,%1.0f)\n", part, part->start->x, part->start->y, part->end->x,
             part->end->y);
#endif

    // divide the edges between left and right

    edge_c *rights = NULL;
    edge_c *lefts  = NULL;

    intersect_c *cut_list = NULL;

    DivideEdges(edge_list, part, &lefts, &rights, &cut_list);

    /* sanity checks... */
    if (!rights)
    {
        FatalError("INTERNAL ERROR: Separated edge-list has no RIGHT side\n");
    }

    if (!lefts)
    {
        FatalError("INTERNAL ERROR: Separated edge-list has no LEFT side\n");
    }

    EdgesAlongPartition(part, &lefts, &rights, cut_list);

#if AJPOLY_DEBUG_POLY
    LogPrint("Build: Going LEFT\n");
#endif

    if (!RecursiveDivideEdges(lefts, depth + 1))
    {
        return false;
    }

#if AJPOLY_DEBUG_POLY
    LogPrint("Build: Going RIGHT\n");
#endif

    if (!RecursiveDivideEdges(rights, depth + 1))
    {
        return false;
    }

#if AJPOLY_DEBUG_POLY
    LogPrint("Build: DONE\n");
#endif

    return true; // OK
}

bool ProcessOneSector(sector_c *sec)
{
    build_sector = sec;

    return RecursiveDivideEdges(sec->edge_list, 0);
}

bool ProcessSectors()
{
    // this automatically includes the 'void_sector'

    for (int i = 0; i < num_sectors; i++)
    {
        sector_c *sec = Sector(i);

        // skip unused sectors
        if (!sec->edge_list)
        {
            continue;
        }

        // skip dummy sectors
        if (sec->is_dummy)
        {
            continue;
        }

#if AJPOLY_DEBUG_POLY
        LogPrint("-------------------------------\n");
        LogPrint("Processing Sector #%d\n", i);
        LogPrint("-------------------------------\n");
#endif

        if (!ProcessOneSector(sec))
        {
            return false;
        }
    }

    return true; // OK
}

void ClockwisePolygons()
{
    for (int i = 0; i < num_polygons; i++)
    {
        polygon_c *poly = Polygon(i);

        poly->ClockwiseOrder();
    }
}

edge_c *CreateAnEdge(linedef_c *line, vertex_c *start, vertex_c *end, sidedef_c *side, int side_num)
{
    edge_c *E = NewEdge();

    E->start   = start;
    E->end     = end;
    E->linedef = line;
    E->side    = side_num;
    E->sector  = side ? side->sector : void_sector;
    E->partner = NULL;

    E->source_line = E->linedef;

    E->Recompute();

    // add the edge to the sector's list
    InsertEdge(&E->sector->edge_list, E);

    return E;
}

void CreateEdges()
{
    /* create all edges, two for each linedef (usually) */

    int i;

    edge_c *left, *right;

    for (i = 0; i < num_linedefs; i++)
    {
        linedef_c *line = Linedef(i);

        // ignore dummy sectors
        if (line->right && line->right->sector && line->right->sector->is_dummy)
        {
            continue;
        }

        right = CreateAnEdge(line, line->start, line->end, line->right, 0);

        if (line->is_border)
        {
            left = NULL;
        }
        else
        {
            left = CreateAnEdge(line, line->end, line->start, line->left, 1);
        }

        if (left && right)
        {
            // maintain one-to-one correspondence via 'partner' field.
            // if one of them gets split, the other must be split too.

            left->partner  = right;
            right->partner = left;
        }
    }
}

void CreateOuterEdges()
{
    limit_x1 -= 64;
    limit_y1 -= 64;
    limit_x2 += 64;
    limit_y2 += 64;

    vertex_c *v[4];

    v[0]    = NewSplit();
    v[0]->x = limit_x1;
    v[0]->y = limit_y2;

    v[1]    = NewSplit();
    v[1]->x = limit_x2;
    v[1]->y = limit_y2;

    v[2]    = NewSplit();
    v[2]->x = limit_x2;
    v[2]->y = limit_y1;

    v[3]    = NewSplit();
    v[3]->x = limit_x1;
    v[3]->y = limit_y1;

    for (int i = 0; i < 4; i++)
    {
        int k = (i + 1) % 4;

        edge_c *E = NewEdge();

        E->start   = v[i];
        E->end     = v[k];
        E->sector  = void_sector;
        E->partner = NULL;

        E->Recompute();

        InsertEdge(&E->sector->edge_list, E);

        v[i]->AddTip(v[k]->x - v[i]->x, v[k]->y - v[i]->y, NULL, void_sector);
        v[k]->AddTip(v[i]->x - v[k]->x, v[i]->y - v[k]->y, void_sector, NULL);
    }
}

//------------------------------------------------------------------------
//   API FUNCTIONS
//------------------------------------------------------------------------

bool Polygonate(bool require_border)
{
    bool need_outer = false;

    if (!VerifyOuterLines())
    {
        if (require_border)
        {
            SetErrorMsg("Level is not surrounded by four linedefs");
            return false;
        }

        need_outer = true;
    }

    CreateEdges();

    if (need_outer)
    {
        CreateOuterEdges();
    }

    bool was_ok = ProcessSectors();

    if (was_ok)
    {
        ClockwisePolygons();
    }

    FreeQuickAllocCuts();

    return was_ok;
}

} // namespace ajpoly

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
