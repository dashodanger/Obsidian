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

#include "csg_main.h"

#include <string.h>

#include <algorithm>

#include "csg_local.h"
#include "lib_util.h"
#include "main.h"
#include "minilua.h"
#include "sys_assert.h"
#include "sys_macro.h"

constexpr double EPSILON = 0.001;

double CLUSTER_SIZE = 128.0;

typedef enum
{
    MEDIUM_AIR = 0,
    MEDIUM_WATER,
    MEDIUM_SLIME,
    MEDIUM_LAVA,
    MEDIUM_SOLID,
} quake_medium_e;

class quake_plane_c
{
  public:
    float x, y, z;    // any point on the plane

    float nx, ny, nz; // normal

  public:
    quake_plane_c() : x(0), y(0), z(0), nx(0), ny(0), nz(0)
    {
    }

    ~quake_plane_c()
    {
    }

    void SetPos(double ax, double ay, double az);

    double CalcDist() const;

    void Flip();

    // make the normal vector be a unit vector
    void Normalize();

    // distance of point to the plane, positive is on the front
    // (same side as normal faces), negative value is on the back.
    float PointDist(float ax, float ay, float az) const;

    // returns -1 if brush completely behind the plane, +1 if completely
    // in front of the plane, or 0 if the brush straddles the plane.
    int BrushSide(csg_brush_c *B, float epsilon = 0.1) const;

    // given an XY coordinate, compute the Z coordinate.
    // result is undefined if the plane is vertical (nz == 0).
    double CalcZ(double ax, double ay) const;
};

void quake_plane_c::SetPos(double ax, double ay, double az)
{
    x = ax;
    y = ay;
    z = az;
}

double quake_plane_c::CalcDist() const
{
    return (x * (double)nx) + (y * (double)ny) + (z * (double)nz);
}

void quake_plane_c::Flip()
{
    nx = -nx;
    ny = -ny;
    nz = -nz;
}

void quake_plane_c::Normalize()
{
    double len = sqrt(nx * nx + ny * ny + nz * nz);

    if (len > 0.000001)
    {
        nx /= len;
        ny /= len;
        nz /= len;
    }
}

float quake_plane_c::PointDist(float ax, float ay, float az) const
{
    return (ax - x) * nx + (ay - y) * ny + (az - z) * nz;
}

int quake_plane_c::BrushSide(csg_brush_c *B, float epsilon) const
{
    float min_d = +9e9;
    float max_d = -9e9;

    for (unsigned int i = 0; i < B->verts.size(); i++)
    {
        brush_vert_c *V = B->verts[i];

        for (unsigned int k = 0; k < 2; k++)
        {
            // TODO : compute proper z coord
            // [ though unlikely to make much difference, due to the
            //   2D-ish nature of our BSP tree... ]

            float x = V->x;
            float y = V->y;
            float z = k ? B->b.z : B->t.z;

            float d = PointDist(x, y, z);

            min_d = OBSIDIAN_MIN(min_d, d);
            max_d = OBSIDIAN_MAX(max_d, d);
        }
    }

    if (min_d > -epsilon)
    {
        return +1;
    }
    if (max_d < epsilon)
    {
        return -1;
    }

    return 0;
}

double quake_plane_c::CalcZ(double ax, double ay) const
{
    // for vertical planes, result is meaningless
    if (fabs(nz) < 0.01)
    {
        return 0;
    }

    if (fabs(nz) > 0.999)
    {
        return z;
    }

    // solve the plane equation:
    //    nx*(ax-x) + ny*(ay-y) + nz*(az-z) = 0

    double tx = (double)nx * (ax - (double)x);
    double ty = (double)ny * (ay - (double)y);

    double dz = (tx + ty) / (double)nz;

    return (double)z - dz;
}

std::vector<csg_brush_c *> all_brushes;

std::vector<csg_entity_c *> all_entities;

std::map<std::string, csg_property_set_c *> all_tex_props;

std::string dummy_wall_tex;
std::string dummy_plane_tex;

double CHUNK_SIZE = 512.0;

// csg_spots.cc
constexpr uint8_t SPOT_LOW_CEIL = 1;
constexpr uint8_t SPOT_WALL     = 2;
constexpr uint8_t SPOT_LEDGE    = 3;

int spot_low_h  = 72;
int spot_high_h = 128;

extern float q_light_scale;
extern int   q_low_light;

extern void SPOT_FillPolygon(uint8_t content, const int *shape, int count);

void csg_property_set_c::Add(const std::string &key, std::string_view value)
{
    dict[key] = value;
}

void csg_property_set_c::Remove(const std::string &key)
{
    dict.erase(key);
}

std::string csg_property_set_c::getStr(const std::string &key, std::string_view def_val) const
{
    std::map<std::string, std::string>::const_iterator PI = dict.find(key);

    if (PI == dict.end())
    {
        return std::string(def_val);
    }

    return PI->second;
}

double csg_property_set_c::getDouble(const std::string &key, double def_val) const
{
    std::string str = getStr(key);

    return !str.empty() ? StringToDouble(str) : def_val;
}

int csg_property_set_c::getInt(const std::string &key, int def_val) const
{
    std::string str = getStr(key);

    return !str.empty() ? OBSIDIAN_I_ROUND(StringToDouble(str)) : def_val;
}

void csg_property_set_c::getHexenArgs(uint8_t *arg5) const
{
    arg5[0] = getInt("arg1");
    arg5[1] = getInt("arg2");
    arg5[2] = getInt("arg3");
    arg5[3] = getInt("arg4");
    arg5[4] = getInt("arg5");
}

void uv_matrix_c::Clear()
{
    s[0] = s[1] = s[2] = s[3] = 0;
    t[0] = t[1] = t[2] = t[3] = 0;
}

void uv_matrix_c::Set(const uv_matrix_c *other)
{
    for (int i = 0; i < 4; i++)
    {
        s[i] = other->s[i];
        t[i] = other->t[i];
    }
}

float uv_matrix_c::Calc_S(float x, float y, float z) const
{
    return s[0] * x + s[1] * y + s[2] * z + s[3];
}

float uv_matrix_c::Calc_T(float x, float y, float z) const
{
    return t[0] * x + t[1] * y + t[2] * z + t[3];
}

brush_vert_c::brush_vert_c(csg_brush_c *_parent, double _x, double _y)
    : parent(_parent), x(_x), y(_y), face(), uv_mat(NULL)
{
}

brush_vert_c::~brush_vert_c()
{
    if (uv_mat)
    {
        delete uv_mat;
    }
}

#if 0 // needed?
brush_plane_c::brush_plane_c(const brush_plane_c& other) :
    z(other.z), slope(NULL), face(other.face), uv_mat(NULL)
{
    // NOTE: slope not cloned
}
#endif

brush_plane_c::~brush_plane_c()
{
    if (slope)
    {
        delete slope;
    }

    if (uv_mat)
    {
        delete uv_mat;
    }
}

double brush_plane_c::CalcZ(double ax, double ay) const
{
    if (slope)
    {
        return slope->CalcZ(ax, ay);
    }

    return z;
}

csg_brush_c::csg_brush_c()
    : bkind(BKIND_Solid), bflags(0), props(), verts(), b(-EXTREME_H), t(EXTREME_H), link_ent(NULL)
{
}

csg_brush_c::csg_brush_c(const csg_brush_c *other)
    : bkind(other->bkind), bflags(other->bflags), props(other->props), verts(), b(other->b), t(other->t),
      link_ent(other->link_ent)
{
    // NOTE: verts and slopes not cloned

    bflags &= ~BRU_IF_Quad;
}

csg_brush_c::~csg_brush_c()
{
    for (int i = 0; i < verts.size(); i++)
    {
        if (verts[i])
        {
            delete verts[i];
        }
    }

    if (b.slope)
    {
        delete b.slope;
    }

    if (t.slope)
    {
        delete t.slope;
    }
}

const char *csg_brush_c::Validate()
{
    if (verts.size() < 3)
    {
        return "Line loop contains less than 3 vertices!";
    }

    // check bbox
    if ((max_x - min_x) < EPSILON)
    {
        return "Line loop has zero width!";
    }

    if ((max_y - min_y) < EPSILON)
    {
        return "Line loop has zero height!";
    }

    // make sure brush is convex (co-linear lines is OK), and
    // that the vertices run anti-clockwise

    double average_ang = 0;

    bflags |= BRU_IF_Quad;

    for (unsigned int k = 0; k < verts.size(); k++)
    {
        brush_vert_c *v1 = verts[k];
        brush_vert_c *v2 = verts[(k + 1) % (int)verts.size()];
        brush_vert_c *v3 = verts[(k + 2) % (int)verts.size()];

        if (fabs(v2->x - v1->x) < EPSILON && fabs(v2->y - v1->y) < EPSILON)
        {
            return "Line loop contains a zero length line!";
        }

        double ang1 = CalcAngle(v2->x, v2->y, v1->x, v1->y);
        double ang2 = CalcAngle(v2->x, v2->y, v3->x, v3->y);

        double diff = ang1 - ang2;

        if (diff < 0)
        {
            diff += 360.0;
        }
        if (diff >= 360)
        {
            diff -= 360.0;
        }

        /*if (diff > 180.1) {
            return "Line loop is not convex!";
        }*/

        average_ang += diff;

        if (fabs(v1->x - v2->x) >= EPSILON && fabs(v1->y - v2->y) >= EPSILON)
        {
            bflags &= ~BRU_IF_Quad; // not a quad
        }
    }

    average_ang /= (double)verts.size();

    // fprintf(stderr, "Average angle = %1.4f\n\n", average_ang);

    /*if (average_ang > 180.0) {
        return "Line loop is not anti-clockwise!";
    }*/

    return NULL; // OK
}

void csg_brush_c::ComputeBBox()
{
    min_x = +9e7;
    min_y = +9e7;
    max_x = -9e7;
    max_y = -9e7;

    for (unsigned int i = 0; i < verts.size(); i++)
    {
        brush_vert_c *V = verts[i];

        if (V->x < min_x)
        {
            min_x = V->x;
        }
        if (V->y < min_y)
        {
            min_y = V->y;
        }

        if (V->x > max_x)
        {
            max_x = V->x;
        }
        if (V->y > max_y)
        {
            max_y = V->y;
        }
    }
}

void csg_brush_c::ComputePlanes()
{
    // for sloped tops and bottom faces, compute the coordinate
    // which defines each plane (i.e. a point ON the plane).

    if (t.slope)
    {
        // find the vertex with the HIGHEST computed Z value.
        // the plane position is still unset (at the origin) here.

        unsigned int best_v = 0;
        double       best_z = -9e9;

        for (unsigned int i = 0; i < verts.size(); i++)
        {
            brush_vert_c *V = verts[i];

            double z = t.slope->CalcZ(V->x, V->y);

            if (z > best_z)
            {
                best_v = i;
                best_z = z;
            }
        }

        brush_vert_c *best_vert = verts[best_v];

        t.slope->SetPos(best_vert->x, best_vert->y, t.z);
    }

    if (b.slope)
    {
        // for bottom plane we want the LOWEST computed Z.

        unsigned int best_v = 0;
        double       best_z = +9e9;

        for (unsigned int i = 0; i < verts.size(); i++)
        {
            brush_vert_c *V = verts[i];

            double z = b.slope->CalcZ(V->x, V->y);

            if (z < best_z)
            {
                best_v = i;
                best_z = z;
            }
        }

        brush_vert_c *best_vert = verts[best_v];

        b.slope->SetPos(best_vert->x, best_vert->y, b.z);
    }
}

int csg_brush_c::CalcMedium() const
{
    if (bflags & BFLAG_NoDraw)
    {
        return -1;
    }
    if (bflags & BFLAG_NoClip)
    {
        return -1;
    }

    switch (bkind)
    {
    case BKIND_Solid:
        return MEDIUM_SOLID;

    case BKIND_Liquid: {
        std::string str = props.getStr("medium", "");

        if (StringCompare(str, "slime") == 0)
        {
            return MEDIUM_SLIME;
        }

        if (StringCompare(str, "lava") == 0)
        {
            return MEDIUM_LAVA;
        }

        return MEDIUM_WATER;
    }

    default:
        return -1;
    }
}

bool csg_brush_c::ContainsPoint(float x, float y, float z) const
{
    // the test uses a slightly expanded brush
    const double epsilon = 0.01;

    // see if point lies inside the 2D sides
    for (unsigned int k = 0; k < verts.size(); k++)
    {
        brush_vert_c *v1 = verts[k];
        brush_vert_c *v2 = verts[(k + 1) % (int)verts.size()];

        double d = PerpDist(x, y, v1->x, v1->y, v2->x, v2->y);

        if (d > epsilon)
        {
            return false;
        }
    }

    // check the 3rd dimension...
    if (z < b.CalcZ(x, y) - epsilon)
    {
        return false;
    }
    if (z > t.CalcZ(x, y) + epsilon)
    {
        return false;
    }

    return true;
}

bool csg_brush_c::IntersectRay(float x1, float y1, float z1, float x2, float y2, float z2) const
{
    // clip the 2D line to the brush sides

    for (unsigned int k = 0; k < verts.size(); k++)
    {
        brush_vert_c *v1 = verts[k];
        brush_vert_c *v2 = verts[(k + 1) % (int)verts.size()];

        double a = PerpDist(x1, y1, v1->x, v1->y, v2->x, v2->y);
        double b = PerpDist(x2, y2, v1->x, v1->y, v2->x, v2->y);

        // ray is completely outside the brush?
        if (a > 0 && b > 0)
        {
            return false;
        }

        // ray is completely inside it?
        if (a <= 0 && b <= 0)
        {
            continue;
        }

        // gotta clip the ray

        double frac = a / (double)(a - b);

        if (a > 0)
        {
            x1 = x1 + (x2 - x1) * frac;
            y1 = y1 + (y2 - y1) * frac;
            z1 = z1 + (z2 - z1) * frac;
        }
        else
        {
            x2 = x1 + (x2 - x1) * frac;
            y2 = y1 + (y2 - y1) * frac;
            z2 = z1 + (z2 - z1) * frac;
        }
    }

    // at here, the clipped ray lies inside the brush

    double bz = b.CalcZ(x1, y1);
    double tz = t.CalcZ(x1, y1);

    if (OBSIDIAN_MAX(z1, z2) < bz - 0.1)
    {
        return false;
    }
    if (OBSIDIAN_MIN(z1, z2) > tz + 0.1)
    {
        return false;
    }

    return true;
}

csg_entity_c::csg_entity_c() : id(), x(0), y(0), z(0), props(), ex_floor(-1)
{
}

csg_entity_c::~csg_entity_c()
{
}

bool csg_entity_c::Match(std::string_view want_name) const
{
    return (StringCompare(id, want_name) == 0);
}

//------------------------------------------------------------------------

constexpr uint16_t QUAD_NODE_SIZE = 320;

class brush_quad_node_c
{
  public:
    int lo_x, lo_y, size;

    brush_quad_node_c *children[2][2]; // [x][y]

    std::vector<csg_brush_c *> brushes;

  public:
    inline int hi_x() const
    {
        return lo_x + size;
    }
    inline int hi_y() const
    {
        return lo_y + size;
    }

    inline int mid_x() const
    {
        return lo_x + size / 2;
    }
    inline int mid_y() const
    {
        return lo_y + size / 2;
    }

  public:
    brush_quad_node_c(int x1, int y1, int _size) : lo_x(x1), lo_y(y1), size(_size), brushes()
    {
        children[0][0] = NULL;
        children[0][1] = NULL;
        children[1][0] = NULL;
        children[1][1] = NULL;

        Subdivide();
    }

    ~brush_quad_node_c()
    {
        brushes.clear();
        delete children[0][0];
        delete children[0][1];
        delete children[1][0];
        delete children[1][1];
    }

  private:
    void Subdivide()
    {
        if (size <= QUAD_NODE_SIZE)
        {
            return;
        }

        int new_size = (size + 1) / 2;

        for (int cx = 0; cx < 2; cx++)
        {
            for (int cy = 0; cy < 2; cy++)
            {
                int new_x = cx ? mid_x() : lo_x;
                int new_y = cy ? mid_y() : lo_y;

                children[cx][cy] = new brush_quad_node_c(new_x, new_y, new_size);
            }
        }
    }

  private:
    void DoAddBrush(csg_brush_c *B, int x1, int y1, int x2, int y2)
    {
        // does it fit in a child node?
        if (children[0][0])
        {
            int cx = -1;
            int cy = -1;

            if (x1 > lo_x && x2 < mid_x())
            {
                cx = 0;
            }
            if (x1 > mid_x() && x2 < hi_x())
            {
                cx = 1;
            }

            if (y1 > lo_y && y2 < mid_y())
            {
                cy = 0;
            }
            if (y1 > mid_y() && y2 < hi_y())
            {
                cy = 1;
            }

            if (cx >= 0 && cy >= 0)
            {
                children[cx][cy]->DoAddBrush(B, x1, y1, x2, y2);
                return;
            }
        }

        // nope -- gotta go in this node
        brushes.push_back(B);
    }

  public:
    void Add(csg_brush_c *B)
    {
        int x1 = floor(B->min_x);
        int y1 = floor(B->min_y);
        int x2 = ceil(B->max_x);
        int y2 = ceil(B->max_y);

        DoAddBrush(B, x1, y1, x2, y2);
    }

  private:
    bool IntersectBrush(const csg_brush_c *B, double x1, double y1, double z1, double x2, double y2, double z2,
                        std::string_view mode)
    {
        if (mode[0] == 'v')
        {
            if ((B->bflags & BFLAG_NoDraw) || B->bkind == BKIND_Light || B->bkind == BKIND_Rail ||
                B->bkind == BKIND_Trigger)
            {
                return false;
            }
        }
        else if (mode[0] == 'p')
        {
            if ((B->bflags & BFLAG_NoClip) || B->bkind == BKIND_Liquid || B->bkind == BKIND_Light ||
                B->bkind == BKIND_Rail || B->bkind == BKIND_Trigger)
            {
                return false;
            }
        }

        return B->IntersectRay(x1, y1, z1, x2, y2, z2);
    }

    bool BoxTouchesThis(double x1, double y1, double x2, double y2) const
    {
        if (OBSIDIAN_MAX(x1, x2) < lo_x)
        {
            return false;
        }
        if (OBSIDIAN_MAX(y1, y2) < lo_y)
        {
            return false;
        }

        if (OBSIDIAN_MIN(x1, x2) > hi_x())
        {
            return false;
        }
        if (OBSIDIAN_MIN(y1, y2) > hi_y())
        {
            return false;
        }

        return true;
    }

    bool RayTouchesBox(double x1, double y1, double x2, double y2) const
    {
        // TODO: a _proper_ line/box test will be much more optimal
        //       (assuming the average ray is fairly long).

        return BoxTouchesThis(x1, y1, x2, y2);
    }

  public:
    bool TraceRay(double x1, double y1, double z1, double x2, double y2, double z2, std::string_view mode)
    {
        for (unsigned int k = 0; k < brushes.size(); k++)
        {
            if (IntersectBrush(brushes[k], x1, y1, z1, x2, y2, z2, mode))
            {
                return true;
            }
        }

        if (children[0][0])
        {
            for (int cx = 0; cx < 2; cx++)
            {
                for (int cy = 0; cy < 2; cy++)
                {
                    if (children[cx][cy]->RayTouchesBox(x1, y1, x2, y2))
                    {
                        if (children[cx][cy]->TraceRay(x1, y1, z1, x2, y2, z2, mode))
                        {
                            return true;
                        }
                    }
                }
            }
        }

        return false; // did not hit anything
    }

  private:
    void SpotTestBrush(const csg_brush_c *B, int x1, int y1, int x2, int y2, int floor_h)
    {
        // ignore non-solid brushes
        if (B->bkind != BKIND_Solid || (B->bflags & BFLAG_NoClip))
        {
            return;
        }

        // bbox check (skip if merely touching the bbox)
        if (B->max_x <= x1 || B->min_x >= x2 || B->max_y <= y1 || B->min_y >= y2)
        {
            return;
        }

        double t_delta = B->t.face.getDouble("delta_z", 0);
        double b_delta = B->b.face.getDouble("delta_z", 0);

        int t_z = OBSIDIAN_I_ROUND(B->t.z + t_delta);
        int b_z = OBSIDIAN_I_ROUND(B->b.z + b_delta);

        // skip brushes underneath the floor (or the floor itself)
        if (t_z < floor_h + 1)
        {
            return;
        }

        // skip brushes far above the floor (like ceilings)
        if (b_z >= floor_h + spot_high_h)
        {
            return;
        }

        /* this brush is a potential blocker */

        int content = SPOT_LEDGE;

        if (b_z >= floor_h + spot_low_h)
        {
            content = SPOT_LOW_CEIL;
        }
        else if (b_z <= floor_h && t_z >= floor_h + spot_low_h)
        {
            content = SPOT_WALL;
        }

        // build the polygon
        std::vector<int> shape;

        int num_vert = (int)B->verts.size();

        for (int i = 0; i < num_vert; i++)
        {
            const brush_vert_c *V = B->verts[i];

            // rounding to integer here, I don't think it is any problem,
            // as the spot polygon-drawing code is fairly robust.
            shape.push_back(OBSIDIAN_I_ROUND(V->x));
            shape.push_back(OBSIDIAN_I_ROUND(V->y));
        }

        SPOT_FillPolygon(content, &shape[0], num_vert);
    }

  public:
    void SpotStuff(int x1, int y1, int x2, int y2, int floor_h)
    {
        for (unsigned int k = 0; k < brushes.size(); k++)
        {
            SpotTestBrush(brushes[k], x1, y1, x2, y2, floor_h);
        }

        if (children[0][0])
        {
            for (int cx = 0; cx < 2; cx++)
            {
                for (int cy = 0; cy < 2; cy++)
                {
                    if (children[cx][cy]->BoxTouchesThis(x1, y1, x2, y2))
                    {
                        children[cx][cy]->SpotStuff(x1, y1, x2, y2, floor_h);
                    }
                }
            }
        }
    }

    bool BrushContents(double x, double y, double z, int *result, double *liquid_depth = NULL)
    {
        // check all brushes in this section of the quad-tree,
        // and update 'result' to be the hardest MEDIUM_XXX value
        // (e.g. MEDIUM_SOLID > MEDIUM_WATER > MEDIUM_AIR).
        //
        // returns true if hit solid (and hence no need to check
        // further nodes or brushes).

        for (unsigned int k = 0; k < brushes.size(); k++)
        {
            csg_brush_c *B = brushes[k];

            // ignore map-models
            if (B->link_ent)
            {
                continue;
            }

            if (!B->ContainsPoint(x, y, z))
            {
                continue;
            }

            int med = B->CalcMedium();

            if (med > *result)
            {
                *result = med;

                if (liquid_depth && med >= MEDIUM_WATER && med <= MEDIUM_LAVA)
                {
                    *liquid_depth = B->t.CalcZ(x, y) - z;
                }
            }

            return (*result == MEDIUM_SOLID);
        }

        if (children[0][0])
        {
            for (int cx = 0; cx < 2; cx++)
            {
                for (int cy = 0; cy < 2; cy++)
                {
                    if (children[cx][cy]->RayTouchesBox(x, y, x, y))
                    {
                        if (children[cx][cy]->BrushContents(x, y, z, result, liquid_depth))
                        {
                            return true;
                        }
                    }
                }
            }
        }

        return false;
    }
};

brush_quad_node_c *brush_quad_tree;

static void CSG_CreateQuadTree()
{
    // TODO : ability to set this via gui.property()
    int size = 65536;

    brush_quad_tree = new brush_quad_node_c(-(size / 2), -(size / 2), size);
}

static void CSG_DeleteQuadTree()
{
    delete brush_quad_tree;

    brush_quad_tree = NULL;
}

//------------------------------------------------------------------------

int Grab_Properties(lua_State *L, int stack_pos, csg_property_set_c *props, bool skip_singles = false)
{
    if (stack_pos < 0)
    {
        stack_pos += lua_gettop(L) + 1;
    }

    if (lua_isnil(L, stack_pos))
    {
        return 0;
    }

    if (lua_type(L, stack_pos) != LUA_TTABLE)
    {
        return luaL_argerror(L, stack_pos, "bad property table");
    }

    for (lua_pushnil(L); lua_next(L, stack_pos) != 0; lua_pop(L, 1))
    {
        // skip keys which are not strings
        if (lua_type(L, -2) != LUA_TSTRING)
        {
            continue;
        }

        const char *key = lua_tostring(L, -2);

        // optionally skip single letter keys ('x', 'y', etc)
        if (skip_singles && strlen(key) == 1)
        {
            continue;
        }

        // validate the value
        if (lua_type(L, -1) == LUA_TBOOLEAN)
        {
            props->Add(key, lua_toboolean(L, -1) ? "1" : "0");
            continue;
        }

        if (lua_type(L, -1) == LUA_TSTRING || lua_type(L, -1) == LUA_TNUMBER)
        {
            props->Add(key, lua_tostring(L, -1));
            continue;
        }

        // ignore other values (tables etc)

        //// return luaL_error(L, "bad property: weird value for '%s'", key);
    }

    return 0;
}

static quake_plane_c *Grab_Slope(lua_State *L, int stack_pos, bool is_ceil)
{
    if (stack_pos < 0)
    {
        stack_pos += lua_gettop(L) + 1;
    }

    if (lua_isnil(L, stack_pos))
    {
        return NULL;
    }

    if (lua_type(L, stack_pos) != LUA_TTABLE)
    {
        luaL_argerror(L, stack_pos, "missing table: slope normal");
        return NULL; /* NOT REACHED */
    }

    quake_plane_c *P = new quake_plane_c();

    lua_getfield(L, stack_pos, "nx");
    lua_getfield(L, stack_pos, "ny");
    lua_getfield(L, stack_pos, "nz");

    P->nx = luaL_checknumber(L, -3);
    P->ny = luaL_checknumber(L, -2);
    P->nz = luaL_checknumber(L, -1);

    lua_pop(L, 3);

    // NOTE: x/y/z are set later in ComputePlanes()

    P->Normalize();

    // completely flat?  then don't need it
    if (fabs(P->nz) > 0.999)
    {
        delete P;
        return NULL;
    }

    // too steep?
    if (fabs(P->nz) < 0.1)
    {
        luaL_error(L, "bad slope: too steep!");
        return NULL; /* NOT REACHED */
    }

    // floor slopes should have negative dz, and ceilings positive
    if ((is_ceil ? 1 : -1) * P->nz > 0)
    {
        luaL_error(L, "bad slope: nz should be >0 for floor, <0 for ceiling");
        return NULL; /* NOT REACHED */
    }

    return P;
}

static uv_matrix_c *Grab_UVMatrix(lua_State *L, int stack_pos)
{
    if (stack_pos < 0)
    {
        stack_pos += lua_gettop(L) + 1;
    }

    if (lua_isnil(L, stack_pos))
    {
        return NULL;
    }

    if (lua_type(L, stack_pos) != LUA_TTABLE)
    {
        luaL_argerror(L, stack_pos, "missing table: uv_matrix");
        return NULL; /* NOT REACHED */
    }

    uv_matrix_c *uv_mat = new uv_matrix_c;

    for (int n = 0; n < 8; n++)
    {
        lua_rawgeti(L, stack_pos, 1 + n);

        if (lua_type(L, -1) != LUA_TNUMBER)
        {
            luaL_error(L, "bad uv_matrix: too short");
            return NULL; /* NOT REACHED */
        }

        float val = lua_tonumber(L, -1);

        if (n < 4)
        {
            uv_mat->s[n] = val;
        }
        else
        {
            uv_mat->t[n - 4] = val;
        }

        lua_pop(L, 1);
    }

    return uv_mat;
}

static void Grab_BrushMode(csg_brush_c *B, lua_State *L, const char *kind)
{
    // parse brush kind from 'm' field of the props table

    SYS_ASSERT(kind);

    if (StringCompare(kind, "solid") == 0)
    {
        B->bkind = BKIND_Solid;
    }
    else if (StringCompare(kind, "liquid") == 0)
    {
        B->bkind = BKIND_Liquid;
    }
    else if (StringCompare(kind, "trigger") == 0)
    {
        B->bkind = BKIND_Trigger;
    }
    else if (StringCompare(kind, "light") == 0)
    {
        B->bkind = BKIND_Light;
    }
    else if (StringCompare(kind, "rail") == 0)
    {
        B->bkind = BKIND_Rail;
    }
    else if (StringCompare(kind, "sky") == 0) // back compat
    {
        B->bkind = BKIND_Solid;
        B->bflags |= BFLAG_Sky;
    }
    else if (StringCompare(kind, "clip") == 0) // back compat
    {
        B->bkind = BKIND_Solid;
        B->bflags |= BFLAG_NoDraw | BFLAG_Detail;
    }
    else if (StringCompare(kind, "detail") == 0) // back compat
    {
        B->bkind = BKIND_Solid;
        B->bflags |= BFLAG_Detail;
    }
    else
    {
        luaL_error(L, "gui.add_brush: unknown kind '%s'", kind);
    }

    // parse flags from the props table

    if (B->props.getInt("detail") > 0)
    {
        B->bflags |= BFLAG_Detail;
    }

    if (B->props.getInt("sky") > 0)
    {
        B->bflags |= BFLAG_Sky;
    }

    if (B->props.getInt("noclip") > 0)
    {
        B->bflags |= BFLAG_NoClip | BFLAG_Detail;
    }

    if (B->props.getInt("nodraw") > 0)
    {
        B->bflags |= BFLAG_NoDraw | BFLAG_Detail;
    }

    if (B->props.getInt("noshadow") > 0)
    {
        B->bflags |= BFLAG_NoShadow | BFLAG_Detail;
    }
}

static int Grab_Vertex(lua_State *L, int stack_pos, csg_brush_c *B)
{
    if (stack_pos < 0)
    {
        stack_pos += lua_gettop(L) + 1;
    }

    if (lua_type(L, stack_pos) != LUA_TTABLE)
    {
        return luaL_error(L, "gui.add_brush: missing vertex info");
    }

    lua_getfield(L, stack_pos, "m");

    if (!lua_isnil(L, -1))
    {
        const char *kind_str = luaL_checkstring(L, -1);

        Grab_Properties(L, stack_pos, &B->props, true);

        Grab_BrushMode(B, L, kind_str);

        lua_pop(L, 1);

        return 0;
    }

    lua_pop(L, 1);

    lua_getfield(L, stack_pos, "uv_mat");
    lua_getfield(L, stack_pos, "slope");
    lua_getfield(L, stack_pos, "b");
    lua_getfield(L, stack_pos, "t");

    if (!lua_isnil(L, -2) || !lua_isnil(L, -1))
    {
        if (lua_isnil(L, -2)) // top
        {
            B->t.z      = luaL_checknumber(L, -1);
            B->t.slope  = Grab_Slope(L, -3, false);
            B->t.uv_mat = Grab_UVMatrix(L, -4);

            Grab_Properties(L, stack_pos, &B->t.face, true);
        }
        else // bottom
        {
            B->b.z      = luaL_checknumber(L, -2);
            B->b.slope  = Grab_Slope(L, -3, true);
            B->b.uv_mat = Grab_UVMatrix(L, -4);

            Grab_Properties(L, stack_pos, &B->b.face, true);
        }
    }
    else // side info
    {
        brush_vert_c *V = new brush_vert_c(B);

        V->uv_mat = Grab_UVMatrix(L, -4);

        lua_getfield(L, stack_pos, "x");
        lua_getfield(L, stack_pos, "y");

        V->x = luaL_checknumber(L, -2);
        V->y = luaL_checknumber(L, -1);

        lua_pop(L, 2);

        Grab_Properties(L, stack_pos, &V->face, true);

        B->verts.push_back(V);
    }

    lua_pop(L, 4); // uv_mat, slope, b, t

    return 0;
}

static int Grab_CoordList(lua_State *L, int stack_pos, csg_brush_c *B)
{
    if (lua_type(L, stack_pos) != LUA_TTABLE)
    {
        return luaL_argerror(L, stack_pos, "missing table: coords");
    }

    int index = 1;

    for (;;)
    {
        lua_pushinteger(L, index);
        lua_gettable(L, stack_pos);

        if (lua_isnil(L, -1))
        {
            lua_pop(L, 1);
            break;
        }

        Grab_Vertex(L, -1, B);

        lua_pop(L, 1);

        index++;
    }

    B->ComputeBBox();
    B->ComputePlanes();

    const char *err_msg = B->Validate();

    if (err_msg)
    {
        return luaL_error(L, "%s", err_msg);
    }

    return 0;
}

// LUA: begin_level()
//
int CSG_begin_level(lua_State *L)
{
    SYS_ASSERT(game_object);

    CSG_Main_Free();

    game_object->BeginLevel();

    CSG_CreateQuadTree();

    return 0;
}

// LUA: end_level()
//
int CSG_end_level(lua_State *L)
{
    SYS_ASSERT(game_object);

    game_object->EndLevel();

    CSG_Main_Free();

    CSG_BSP_Free();

    return 0;
}

// LUA: property(key, value)
//
int CSG_property(lua_State *L)
{
    std::string key   = luaL_optstring(L, 1, "");
    std::string value = luaL_optstring(L, 2, "");

    // eat propertities intended for CSG2

    if (StringCompare(key, "error_tex") == 0)
    {
        dummy_wall_tex = value;
        return 0;
    }
    else if (StringCompare(key, "error_flat") == 0)
    {
        dummy_plane_tex = value;
        return 0;
    }
    else if (StringCompare(key, "spot_low_h") == 0)
    {
        spot_low_h = StringToInt(value);
        return 0;
    }
    else if (StringCompare(key, "spot_high_h") == 0)
    {
        spot_high_h = StringToInt(value);
        return 0;
    }
    else if (StringCompare(key, "chunk_size") == 0)
    {
        CHUNK_SIZE = StringToDouble(value);
        return 0;
    }
    else if (StringCompare(key, "cluster_size") == 0)
    {
        CLUSTER_SIZE = StringToDouble(value);
        return 0;
    }

    SYS_ASSERT(game_object);

    game_object->Property(key, value);

    return 0;
}

// LUA: tex_property(texture, key, value)
//
int CSG_tex_property(lua_State *L)
{
    std::string texture = luaL_optstring(L, 1, "");
    std::string key     = luaL_optstring(L, 2, "");
    std::string value   = luaL_optstring(L, 3, "");

    csg_property_set_c *props = NULL;

    std::map<std::string, csg_property_set_c *>::iterator TPI;

    TPI = all_tex_props.find(texture);

    if (TPI == all_tex_props.end())
    {
        props = new csg_property_set_c;

        all_tex_props[texture] = props;
    }
    else
    {
        props = TPI->second;
    }

    props->Add(key, value);

    return 0;
}

// LUA: add_brush(coords)
//
// coords is a list of coordinates of the form:
//   { m="solid", ... }                     -- properties
//   { x=123, y=456,     tex="foo", ... }   -- side of brush
//   { b=200, s={ ... }, tex="bar", ... }   -- top of brush
//   { t=240, s={ ... }, tex="gaz", ... }   -- bottom of brush
//
// 'm' is the brush mode, default "solid", can also be
//     "sky", "liquid", "detail", "clip", etc..
//
// tops and bottoms are optional, when absent then it means the
// brush extends to infinity in that direction.
//
// 's' are slope specifications, which are optional.
// They contain these fields: { x1, y1, x2, y2, dz }
// When used, the slope must be "shrinky", i.e. the z1..z2 range needs
// to cover the entirety of the full (sloped) brush.
//
// the rest of the fields are for the FACE, and can be:
//
//    tex  :  texture name
//
//    x_offset  BLAH  FIXME
//    y_offset
//
//    delta_z   : a post-CSG height adjustment (top & bottom only)
//    mark      : separating number (top & bottom only)
//
//    kind   : DOOM sector or linedef type
//    flags  : DOOM linedef flags
//    tag    : DOOM sector or linedef tag
//    args   : DOOM sector or linedef args (a table)
//
int CSG_add_brush(lua_State *L)
{
    csg_brush_c *B = new csg_brush_c();

    Grab_CoordList(L, 1, B);

    all_brushes.push_back(B);

    brush_quad_tree->Add(B);

    return 0;
}

// LUA: add_entity(props)
//
//   id      -- number or name of thing
//   x y z   -- coordinates
//   angle
//   flags
//   light   -- amount of light emitted
//
//   etc...
//
int CSG_add_entity(lua_State *L)
{
    csg_entity_c *E = new csg_entity_c();

    Grab_Properties(L, 1, &E->props);

    E->id = E->props.getStr("id", "");

    E->x = E->props.getDouble("x");
    E->y = E->props.getDouble("y");
    E->z = E->props.getDouble("z");

    E->flags = E->props.getInt("flags");

    // save a bit of space (and don't write into Q1/2/3 entities lump)
    E->props.Remove("id");
    E->props.Remove("x");
    E->props.Remove("y");
    E->props.Remove("z");
    E->props.Remove("flags");

    all_entities.push_back(E);

    return 0;
}

// LUA: trace_ray(x1,y1,z1, x2,y2,z2, mode)
//
//   x1 y1 z1  -- start coordinate
//   x2 y2 z2  -- end coordinate
//
//   mode -- a string with one or more letters:
//
//      v : visibility [only visible brushes]
//      p : physics    [only solid brushes]
//
//   result is 'true' if something hit, false otherwise
//
int CSG_trace_ray(lua_State *L)
{
    double x1 = luaL_checknumber(L, 1);
    double y1 = luaL_checknumber(L, 2);
    double z1 = luaL_checknumber(L, 3);

    double x2 = luaL_checknumber(L, 4);
    double y2 = luaL_checknumber(L, 5);
    double z2 = luaL_checknumber(L, 6);

    const char *mode = luaL_checkstring(L, 7);

    if (fabs(x2 - x1) < 1 && fabs(y2 - y1) < 1 && fabs(z2 - z1) < 1)
    {
        return luaL_error(L, "gui.trace_ray: zero-length vector");
    }

    if (!(mode[0] == 'v' || mode[0] == 'p'))
    {
        return luaL_argerror(L, 7, "gui.trace_ray: bad mode string");
    }

    SYS_ASSERT(brush_quad_tree);

    bool result = brush_quad_tree->TraceRay(x1, y1, z1, x2, y2, z2, mode);

    lua_pushboolean(L, result ? 1 : 0);
    return 1;
}

bool CSG_TraceRay(double x1, double y1, double z1, double x2, double y2, double z2, std::string_view mode)
{
    SYS_ASSERT(brush_quad_tree);

    return brush_quad_tree->TraceRay(x1, y1, z1, x2, y2, z2, mode);
}

int CSG_BrushContents(double x, double y, double z, double *liquid_depth)
{
    // find the brush(es) which contain the given point, and
    // return a MEDIUM_XXX value for it.  harder values trump
    // softer ones (e.g. MEDIUM_SOLID > MEDIUM_WATER).
    //
    // returns -1 when no brushes contain the brush, which
    // indicates either the point is in the AIR, or the point
    // is completely outside of the map.

    SYS_ASSERT(brush_quad_tree);

    int result = -1;

    brush_quad_tree->BrushContents(x, y, z, &result, liquid_depth);

    return result;
}

void CSG_spot_processing(int x1, int y1, int x2, int y2, int floor_h)
{
    brush_quad_tree->SpotStuff(x1, y1, x2, y2, floor_h);
}

//------------------------------------------------------------------------

csg_property_set_c *CSG_LookupTexProps(const std::string &name)
{
    std::map<std::string, csg_property_set_c *>::iterator TPI;

    TPI = all_tex_props.find(name);

    if (TPI == all_tex_props.end())
    {
        return NULL;
    }

    SYS_ASSERT(TPI->second);

    return TPI->second;
}

static void CSG_FreeTexProps()
{
    std::map<std::string, csg_property_set_c *>::iterator TPI;

    for (TPI = all_tex_props.begin(); TPI != all_tex_props.end(); TPI++)
    {
        delete TPI->second;
    }

    all_tex_props.clear();
}

void CSG_LinkBrushToEntity(csg_brush_c *B, const std::string &link_key)
{
    for (unsigned int k = 0; k < all_entities.size(); k++)
    {
        csg_entity_c *E = all_entities[k];

        std::string E_key = E->props.getStr("link_id");

        if (E_key.empty())
        {
            continue;
        }

        if (StringCompare(E_key, link_key) == 0)
        {
            B->link_ent = E;
            return;
        }
    }

    // not found
    LogPrint("WARNING: brush has unknown link entity '%s'\n", link_key.c_str());

    // ensure we ignore this brush
    B->bkind = BKIND_Light;
}

void CSG_Main_Free()
{
    CSG_DeleteQuadTree();

    unsigned int k;

    for (k = 0; k < all_brushes.size(); k++)
    {
        if (all_brushes[k])
        {
            delete all_brushes[k];
        }
    }

    for (k = 0; k < all_entities.size(); k++)
    {
        if (all_entities[k])
        {
            delete all_entities[k];
        }
    }

    all_brushes.clear();
    all_entities.clear();

    CSG_FreeTexProps();

    dummy_wall_tex.clear();
    dummy_plane_tex.clear();

    spot_low_h  = 72;
    spot_high_h = 128;

    CHUNK_SIZE = 512.0;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
