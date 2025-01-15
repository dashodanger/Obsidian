//----------------------------------------------------------------------
//  SPOTS for MONSTERS / ITEMS
//----------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2010-2017 Andrew Apted
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
//----------------------------------------------------------------------

#include "lib_argv.h"
#include "lib_util.h"
#include "main.h"
#include "minilua.h"
#include "sys_assert.h"
#include "sys_macro.h"

constexpr uint8_t GRID_SIZE = 20;

constexpr uint8_t MAX_MON_CELLS = 14; /* i.e. 280 units */

constexpr uint8_t SPOT_CLEAR    = 0;
constexpr uint8_t SPOT_LOW_CEIL = 1;
constexpr uint8_t SPOT_WALL     = 2;
constexpr uint8_t SPOT_LEDGE    = 3;

constexpr uint8_t NEAR_WALL = 0x08;
constexpr uint8_t HAS_ITEM  = 0x10;
constexpr uint8_t HAS_MON   = 0x20;
constexpr uint8_t IS_DUD    = 0x40;

static int grid_min_x, grid_min_y;
static int grid_max_x, grid_max_y;

static int grid_floor_h;

extern int spot_low_h;
extern int spot_high_h;

// number of grid squares
static int grid_W, grid_H;

static uint8_t **spot_grid;

static int *grid_lefties;
static int *grid_righties;

// declare this here (don't pull in all CSG headers)
extern void CSG_spot_processing(int x1, int y1, int x2, int y2, int floor_h);

void SPOT_CreateGrid(uint8_t content, int min_x, int min_y, int max_x, int max_y)
{
    grid_min_x = min_x;
    grid_min_y = min_y;

    grid_max_x = max_x;
    grid_max_y = max_y;

    grid_W = (grid_max_x - grid_min_x + GRID_SIZE - 1) / GRID_SIZE;
    grid_H = (grid_max_y - grid_min_y + GRID_SIZE - 1) / GRID_SIZE;

    SYS_ASSERT(grid_W >= 1);
    SYS_ASSERT(grid_H >= 1);

#if 1 // padding
    grid_W += 2;
    grid_H += 2;
#endif

    spot_grid = new uint8_t *[grid_W];

    for (int x = 0; x < grid_W; x++)
    {
        spot_grid[x] = new uint8_t[grid_H];

        memset(spot_grid[x], content, grid_H);
    }

    grid_lefties  = new int[grid_H];
    grid_righties = new int[grid_H];
}

void SPOT_FreeGrid()
{
    if (spot_grid)
    {
        for (int x = 0; x < grid_W; x++)
        {
            delete[] spot_grid[x];
        }

        delete[] spot_grid;

        spot_grid = NULL;
    }

    if (grid_lefties)
    {
        delete[] grid_lefties;
    }
    if (grid_righties)
    {
        delete[] grid_righties;
    }
}

void SPOT_DumpGrid(const char *info)
{
    DebugPrint("%s: (%d %d) .. (%d %d)\n", info, grid_min_x, grid_min_y, grid_max_x, grid_max_y);

    const int MAX_WIDTH = 256;

    for (int y = grid_H - 1; y >= 0; y--)
    {
        char buffer[MAX_WIDTH + 2];

        int width = OBSIDIAN_MIN(MAX_WIDTH, grid_W);

        for (int x = 0; x < width; x++)
        {
            uint8_t content = spot_grid[x][y];

            if (content & HAS_MON)
            {
                buffer[x] = 'm';
            }
            else if (content & HAS_ITEM)
            {
                buffer[x] = 'i';
            }
            else if ((content & 3) == SPOT_LEDGE)
            {
                buffer[x] = '/';
            }
            else if ((content & 3) == SPOT_WALL)
            {
                buffer[x] = '#';
            }
            else if ((content & 3) == SPOT_LOW_CEIL)
            {
                buffer[x] = '=';
            }
            else if (content & NEAR_WALL)
            {
                buffer[x] = '%';
            }
            else
            {
                buffer[x] = '.';
            }
        }

        buffer[width] = 0;

        DebugPrint(" % 3d %s\n", y, buffer);
    }

    DebugPrint("\n");
}

class grid_point_c
{
  public:
    int x, y;

  public:
    grid_point_c()
    {
    }

    grid_point_c(int _x, int _y) : x(_x), y(_y)
    {
    }

    ~grid_point_c()
    {
    }
};

static void test_item_spot(int x, int y, std::vector<grid_point_c> &spots)
{
    int near_walls = 0;

    for (int dx = 0; dx < 2; dx++)
    {
        for (int dy = 0; dy < 2; dy++)
        {
            uint8_t content = spot_grid[x + dx][y + dy];

            if (content & (7 | HAS_ITEM))
            {
                return; // no good, something in the way
            }

            if (content & NEAR_WALL)
            {
                near_walls += 1;
            }
        }
    }

    if (near_walls == 0)
    {
        return; // no good, not near a wall
    }

    if (near_walls == 4)
    {
        return; // no good, too close to walls
    }

    // this would be (x + 1) if there was no padding
    int real_x = grid_min_x + (x + 0) * GRID_SIZE;
    int real_y = grid_min_y + (y + 0) * GRID_SIZE;

    DebugPrint("Item spot ---> [%d %d] real: (%d %d)\n", x, y, real_x, real_y);

    spots.push_back(grid_point_c(real_x, real_y));

    // reserve these cells, prevent overlapping item spots
    spot_grid[x + 0][y + 0] |= HAS_ITEM;
    spot_grid[x + 0][y + 1] |= HAS_ITEM;
    spot_grid[x + 1][y + 0] |= HAS_ITEM;
    spot_grid[x + 1][y + 1] |= HAS_ITEM;
}

static void clean_up_grid()
{
    for (int x = 0; x < grid_W; x++)
    {
        for (int y = 0; y < grid_H; y++)
        {
            spot_grid[x][y] &= 7;
        }
    }
}

void SPOT_ItemSpots(std::vector<grid_point_c> &spots)
{
    // The ideal spots are close to a wall.
    // Using the middle of a grid square is too close though.
    // Hence we use the middle of a 2x2 empty space.
    int w2 = grid_W - 1;
    int h2 = grid_H - 1;

    int x, y;

    // first, mark squares which are near a wall
    for (x = 0; x < grid_W; x++)
    {
        for (y = 0; y < grid_H; y++)
        {
            if ((spot_grid[x][y] & 3) == SPOT_WALL)
            {
                if (x > 0)
                {
                    spot_grid[x - 1][y] |= NEAR_WALL;
                }
                if (x < w2)
                {
                    spot_grid[x + 1][y] |= NEAR_WALL;
                }

                if (y > 0)
                {
                    spot_grid[x][y - 1] |= NEAR_WALL;
                }
                if (y < h2)
                {
                    spot_grid[x][y + 1] |= NEAR_WALL;
                }
            }
        }
    }

    for (y = 1; y < grid_H - 2; y++)
    {
        for (x = 1; x < grid_W - 2; x++)
        {
            test_item_spot(x, y, spots);
        }
    }
}

//----------------------------------------------------------------------

static void remove_dud_cells()
{
    for (int x = 0; x < grid_W; x++)
    {
        for (int y = 0; y < grid_H; y++)
        {
            spot_grid[x][y] &= ~IS_DUD;
        }
    }
}

static bool test_mon_area(int x1, int y1, int x2, int y2, int want)
{
    if (x1 < 0 || x2 >= grid_W || y1 < 0 || y2 >= grid_H)
    {
        return false;
    }

    for (int x = x1; x <= x2; x++)
    {
        for (int y = y1; y <= y2; y++)
        {
            uint8_t content = spot_grid[x][y];

            if (content & (HAS_MON | IS_DUD))
            {
                return false;
            }

            if ((content & 3) > want)
            {
                return false;
            }
        }
    }

    return true;
}

static int biggest_gap(int *y1, int *y2, int want)
{
    // Note: this also duds any single square spots, which will never
    //       get used because they'll never form a 2x2 group.

    int best_x   = -1;
    int best_num = 0;

    for (int x = 0; x < grid_W; x++)
    {
        int y = 0;

        while (y < grid_H - 1)
        {
            if (!test_mon_area(x, y, x, y, want))
            {
                y++;
                continue;
            }

            int ey = y;

            while (ey < grid_H - 1 && test_mon_area(x, ey + 1, x, ey + 1, want))
            {
                ey++;
            }

            int num = ey - y + 1;

            if (num == 1)
            {
                // single squares are useless, remove them now
                spot_grid[x][y] |= IS_DUD;
            }
            else if (num > best_num)
            {
                best_x   = x;
                best_num = num;

                *y1 = y;
                *y2 = ey;
            }

            y = ey + 1;
        }
    }

    return best_x;
}

static bool grow_spot(int &x1, int &y1, int &x2, int &y2, int want)
{
    // (passing parameters by reference for nicer code)

    // special case for initial square, try to become a 2x2 square
    // since that is the minimum requirement.

    if (x1 == x2 && y1 == y2)
    {
        if (test_mon_area(x1, y1, x2 + 1, y2 + 1, want))
        {
            x2++;
            y2++;
            return true;
        }
        if (test_mon_area(x1, y1 - 1, x2 + 1, y2, want))
        {
            x2++;
            y1--;
            return true;
        }
        if (test_mon_area(x1 - 1, y1, x2, y2 + 1, want))
        {
            x1--;
            y2++;
            return true;
        }
        if (test_mon_area(x1 - 1, y1 - 1, x2, y2, want))
        {
            x1--;
            y1--;
            return true;
        }

        // return now, will mark this square as a dud
        return false;
    }

    // determine the order of sides to try and grow
    int x1_pass = 0;
    int x2_pass = 1;

    int y1_pass = 2;
    int y2_pass = 3;

    // wider than tall? then do Y first, otherwise X
    int w = x2 - x1;
    int h = y2 - y1;

    if (w > h)
    {
        x1_pass ^= 2;
        x2_pass ^= 2;
        y1_pass ^= 2;
        y2_pass ^= 2;
    }

    // also vary whether we go left or right first
    if (w & 1)
    {
        x1_pass ^= 1;
        x2_pass ^= 1;
    }

    if (h & 1)
    {
        y1_pass ^= 1;
        y2_pass ^= 1;
    }

    // don't make long narrow areas, i.e. keep aspect nice
    if (w > h * 2)
    {
        x1_pass = x2_pass = -1;
    }
    if (h > w * 2)
    {
        y1_pass = y2_pass = -1;
    }

    // prevent growing too large
    if (w + 1 >= MAX_MON_CELLS)
    {
        x1_pass = x2_pass = -1;
    }
    if (h + 1 >= MAX_MON_CELLS)
    {
        y1_pass = y2_pass = -1;
    }

    for (int pass = 0; pass < 4; pass++)
    {
        if (pass == x1_pass && test_mon_area(x1 - 1, y1, x1 - 1, y2, want))
        {
            x1--;
            return true;
        }
        if (pass == x2_pass && test_mon_area(x2 + 1, y1, x2 + 1, y2, want))
        {
            x2++;
            return true;
        }

        if (pass == y1_pass && test_mon_area(x1, y1 - 1, x2, y1 - 1, want))
        {
            y1--;
            return true;
        }
        if (pass == y2_pass && test_mon_area(x1, y2 + 1, x2, y2 + 1, want))
        {
            y2++;
            return true;
        }
    }

    return false;
}

static void mark_monster(int x1, int y1, int x2, int y2, uint8_t flag)
{
    for (int x = x1; x <= x2; x++)
    {
        for (int y = y1; y <= y2; y++)
        {
            spot_grid[x][y] |= flag;
        }
    }
}

void SPOT_MonsterSpots(std::vector<grid_point_c> &spots, int want)
{
    // Algorithm:
    //   find the biggest vertical gap which is free, and use the
    //   middle square as our starting point.  Then grow it as much as
    //   as possible (minimum size is 2x2 squares).
    //
    //   repeat until no more available.

    for (;;)
    {
        int x1, x2;
        int y1 = 0, y2 = 0;

        x1 = biggest_gap(&y1, &y2, want);

        if (x1 < 0)
        {
            return;
        }

        y1 = (y1 + y2) / 2;

        SYS_ASSERT((spot_grid[x1][y1] & 3) <= want);

        x2 = x1;
        y2 = y1;

        while (grow_spot(x1, y1, x2, y2, want))
        {
        }

        if (x2 > x1 && y2 > y1)
        {
            mark_monster(x1, y1, x2, y2, HAS_MON);

            int real_x1 = grid_min_x + (x1 - 1) * GRID_SIZE;
            int real_y1 = grid_min_y + (y1 - 1) * GRID_SIZE;

            int real_x2 = grid_min_x + (x2 + 0) * GRID_SIZE;
            int real_y2 = grid_min_y + (y2 + 0) * GRID_SIZE;

            // TODO: use a proper rectangle class
            spots.push_back(grid_point_c(real_x1, real_y1));
            spots.push_back(grid_point_c(real_x2, real_y2));

            DebugPrint("Monster spot ---> [%d %d] size [%d %d]\n", x1, y1, x2 - x1 + 1, y2 - y1 + 1);
        }
        else
        {
            // mark the cells as useless
            // [ need this marking so that processing will eventually finish ]
            mark_monster(x1, y1, x2, y2, IS_DUD);
        }
    }
}

//------------------------------------------------------------------------
//  POLYGON FILLING
//------------------------------------------------------------------------

static int grid_toppy;
static int grid_botty;

static void clear_rows()
{
    for (int y = 0; y < grid_H; y++)
    {
        grid_lefties[y]  = +9999;
        grid_righties[y] = -9999;
    }

    grid_botty = +9999;
    grid_toppy = -9999;
}

static void raw_pixel(int gx, int gy)
{
    if (gy < 0 || gy >= grid_H)
    {
        return;
    }

    grid_lefties[gy]  = OBSIDIAN_MIN(grid_lefties[gy], gx);
    grid_righties[gy] = OBSIDIAN_MAX(grid_righties[gy], gx);

    grid_botty = OBSIDIAN_MIN(grid_botty, gy);
    grid_toppy = OBSIDIAN_MAX(grid_toppy, gy);
}

static void draw_line(int x1, int y1, int x2, int y2)
{

    // basic cull, Y only
    // (doing X messes up polygons which overlap the sides)
    if (OBSIDIAN_MAX(y1, y2) < grid_min_y || OBSIDIAN_MIN(y1, y2) > grid_max_y)
    {
        return;
    }

    x1 -= grid_min_x;
    y1 -= grid_min_y;
    x2 -= grid_min_x;
    y2 -= grid_min_y;

    // TODO: clip to bounding box

#if 1 // padding
    x1 += GRID_SIZE;
    y1 += GRID_SIZE;
    x2 += GRID_SIZE;
    y2 += GRID_SIZE;
#endif

    int px1 = x1 / GRID_SIZE;
    int px2 = x2 / GRID_SIZE;

    int py1 = y1 / GRID_SIZE;
    int py2 = y2 / GRID_SIZE;

    int h2 = grid_H - 1;

    // same row ?
    if (py1 == py2)
    {
        if (py1 < 0 || py1 > h2)
        {
            return;
        }

        raw_pixel(px1, py1);
        raw_pixel(px2, py1);

        return;
    }

    if (py1 > py2)
    {
        int temp;

        temp = px1;
        px1  = px2;
        px2  = temp;
        temp = py1;
        py1  = py2;
        py2  = temp;

        temp = x1;
        x1   = x2;
        x2   = temp;
        temp = y1;
        y1   = y2;
        y2   = temp;
    }

    int orig_py1 = py1;
    int orig_py2 = py2;

    py1 = OBSIDIAN_MAX(0, py1);
    py2 = OBSIDIAN_MIN(h2, py2);

    // same column ?
    if (px1 == px2)
    {
        for (; py1 <= py2; py1++)
        {
            raw_pixel(px1, py1);
        }

        return;
    }

    // general case

    double slope = (x2 - x1) / (double)(y2 - y1);

    for (int py = py1; py <= py2; py++)
    {
        // compute intersection of current row
        int sy = (py == orig_py1) ? y1 : GRID_SIZE * py;
        int ey = (py == orig_py2) ? y2 : GRID_SIZE * (py + 1);

        int sx = x1 + (int)((sy - y1) * slope);
        int ex = x1 + (int)((ey - y1) * slope);

        int psx = sx / GRID_SIZE;
        int pex = ex / GRID_SIZE;

        raw_pixel(psx, py);
        raw_pixel(pex, py);
    }
}

static inline void replace_cell(int x, int y, uint8_t content)
{
    uint8_t &target = spot_grid[x][y];

    // Note : we allow SPOT_CLEAR to replace anything, though
    //        generally it is only used to initialize the grid.

    // never replace a WALL
    if (content != SPOT_CLEAR && target == SPOT_WALL)
    {
        return;
    }

    // LOW_CEIL cannot replace a LEDGE
    if (content == SPOT_LOW_CEIL && target == SPOT_LEDGE)
    {
        return;
    }

    target = content;
}

static void fill_rows(uint8_t content)
{
    int w2 = grid_W - 1;

    for (int y = grid_botty; y <= grid_toppy; y++)
    {
        if (grid_righties[y] < 0)
        {
            continue;
        }

        int low_x  = OBSIDIAN_MAX(0, grid_lefties[y]);
        int high_x = OBSIDIAN_MIN(w2, grid_righties[y]);

        for (int x = low_x; x <= high_x; x++)
        {
            replace_cell(x, y, content);
        }
    }
}

void SPOT_DrawLine(uint8_t content, int x1, int y1, int x2, int y2)
{
    clear_rows();

    draw_line(x1, y1, x2, y2);

    fill_rows(content);
}

void SPOT_FillPolygon(uint8_t content, std::vector<grid_point_c> &points)
{
    // Algorithm:
    //   rather simplistic, draw each edge of the polygon and keep
    //   track of the minimum and maximum X coordinates on each row.
    //   later fill in the intermediate squares in each row.

    clear_rows();

    int count = (int)points.size();

    for (int i = 0; i < count; i++)
    {
        int k = (i + 1) % count;

        draw_line(points[i].x, points[i].y, points[k].x, points[k].y);

        /// fill_rows(content);
        /// SPOT_DumpGrid("");
    }

    fill_rows(content);
}

void SPOT_FillPolygon(uint8_t content, const int *shape, int count)
{
    std::vector<grid_point_c> points;

    for (int i = 0; i < count; i++)
    {
        int x = shape[i * 2 + 0];
        int y = shape[i * 2 + 1];

        points.push_back(grid_point_c(x, y));
    }

    SPOT_FillPolygon(content, points);
}

//------------------------------------------------------------------------
//  LUA INTERFACE
//------------------------------------------------------------------------

// LUA: spots_begin(min_x, min_y, max_x, max_y, floor_h, content)
//
int SPOT_begin(lua_State *L)
{
    int min_x = floor(luaL_checknumber(L, 1));
    int min_y = floor(luaL_checknumber(L, 2));

    int max_x = ceil(luaL_checknumber(L, 3));
    int max_y = ceil(luaL_checknumber(L, 4));

    grid_floor_h = luaL_checkinteger(L, 5);

    int content = luaL_checkinteger(L, 6);

    SPOT_CreateGrid(content, min_x, min_y, max_x, max_y);

    return 0;
}

// LUA: spots_draw_line(x1, y1, x2, y2, content)
//
int SPOT_draw_line(lua_State *L)
{
    int x1 = OBSIDIAN_I_ROUND(luaL_checknumber(L, 1));
    int y1 = OBSIDIAN_I_ROUND(luaL_checknumber(L, 2));
    int x2 = OBSIDIAN_I_ROUND(luaL_checknumber(L, 3));
    int y2 = OBSIDIAN_I_ROUND(luaL_checknumber(L, 4));

    int content = luaL_checkinteger(L, 5);

    SPOT_DrawLine(content, x1, y1, x2, y2);

    return 0;
}

static int polygon_coord(lua_State *L, int stack_pos, std::vector<grid_point_c> &points)
{
    if (stack_pos < 0)
    {
        stack_pos += lua_gettop(L) + 1;
    }

    if (lua_type(L, stack_pos) != LUA_TTABLE)
    {
        return luaL_error(L, "gui.spots_fill_poly: bad coordinate");
    }

    lua_getfield(L, stack_pos, "x");
    lua_getfield(L, stack_pos, "y");

    // ignore non-XY coordinates, to allow passing whole brushes

    if (!lua_isnil(L, -2))
    {
        int x = OBSIDIAN_I_ROUND(luaL_checknumber(L, -2));
        int y = OBSIDIAN_I_ROUND(luaL_checknumber(L, -1));

        points.push_back(grid_point_c(x, y));
    }

    lua_pop(L, 2);

    return 0;
}

// LUA: spots_fill_poly(polygon, content)
//
int SPOT_fill_poly(lua_State *L)
{
    int content = luaL_checkinteger(L, 2);

    std::vector<grid_point_c> points;

    if (lua_type(L, 1) != LUA_TTABLE)
    {
        return luaL_argerror(L, 1, "missing table: polygon");
    }

    int index = 1;

    for (;;)
    {
        lua_pushinteger(L, index);
        lua_gettable(L, 1);

        if (lua_isnil(L, -1))
        {
            lua_pop(L, 1);
            break;
        }

        polygon_coord(L, -1, points);

        lua_pop(L, 1);

        index++;
    }

    if (points.size() < 3)
    {
        return luaL_error(L, "gui.spots_fill_poly: bad polygon");
    }

    SPOT_FillPolygon(content, points);

    return 0;
}

// LUA: spots_fill_box(x1, y1, x2, y2, content)
//
int SPOT_fill_box(lua_State *L)
{
    int x1 = luaL_checkinteger(L, 1);
    int y1 = luaL_checkinteger(L, 2);
    int x2 = luaL_checkinteger(L, 3);
    int y2 = luaL_checkinteger(L, 4);

    int content = luaL_checkinteger(L, 5);

    std::vector<grid_point_c> points;

    points.push_back(grid_point_c(x1, y1));
    points.push_back(grid_point_c(x2, y1));
    points.push_back(grid_point_c(x2, y2));
    points.push_back(grid_point_c(x1, y2));

    SPOT_FillPolygon(content, points);

    return 0;
}

// LUA: spots_apply_brushes(floor_h)
//
int SPOT_apply_brushes(lua_State *L)
{
    CSG_spot_processing(grid_min_x, grid_min_y, grid_max_x, grid_max_y, grid_floor_h);

    return 0;
}

static void store_mon_or_item(lua_State *L, int stack_pos, unsigned int index, int x1, int y1, int x2, int y2,
                              bool low_ceil = true)
{
    int ceil_h = grid_floor_h + (low_ceil ? spot_low_h : spot_high_h);

    // clip rectangle to the original room/chunk boundaries
    x1 = OBSIDIAN_MAX(x1, grid_min_x);
    y1 = OBSIDIAN_MAX(y1, grid_min_y);
    x2 = OBSIDIAN_MIN(x2, grid_max_x);
    y2 = OBSIDIAN_MIN(y2, grid_max_y);

    if ((x2 - x1) < 8 || (y2 - y1) < 8)
    {
        return;
    }

    lua_pushinteger(L, index);

    // build the coordinate table
    //   e.g. { x1=50, y1=200, x2=150, y2=400, z1=0, z2=72 }

    lua_newtable(L);

    lua_pushinteger(L, x1);
    lua_setfield(L, -2, "x1");

    lua_pushinteger(L, y1);
    lua_setfield(L, -2, "y1");

    lua_pushinteger(L, x2);
    lua_setfield(L, -2, "x2");

    lua_pushinteger(L, y2);
    lua_setfield(L, -2, "y2");

    lua_pushinteger(L, grid_floor_h);
    lua_setfield(L, -2, "z1");

    lua_pushinteger(L, ceil_h);
    lua_setfield(L, -2, "z2");

    // store coordinate table into user-provided list
    lua_settable(L, stack_pos);
}

// LUA: spots_dump(text)
//
int SPOT_dump(lua_State *L)
{
    const char *text = luaL_checkstring(L, 1);

    if (text)
    {
        SPOT_DumpGrid(text);
    }

    return 0;
}

// LUA: spots_get_mons(list)
//
int SPOT_get_mons(lua_State *L)
{
    if (lua_type(L, 1) != LUA_TTABLE)
    {
        return luaL_argerror(L, 1, "missing table: mons");
    }

    std::vector<grid_point_c> mons;

    // Two passes :
    //   - want = 0 grabs spots with a high ceiling
    //   - want = 1 grabs spots with a low ceiling
    //
    // Note: order of passes matters, second pass depends on the
    //       'HAS_MON' flag added during the first pass.

    clean_up_grid();

    unsigned int index = 1;

    for (int want = 0; want < 2; want++)
    {
        mons.clear();

        SPOT_MonsterSpots(mons, want);

        for (unsigned int m = 0; m < mons.size(); m += 2)
        {
            store_mon_or_item(L, 1, index, mons[m + 0].x, mons[m + 0].y, mons[m + 1].x, mons[m + 1].y,
                              (want > 0) /* low_ceil */);
            index++;
        }

        // All the usable cells became either HAS_MON or IS_DUD.
        // Need to clear all the dud flags now, to allow monsters
        // which straddle a low ceiling and a high ceiling.
        remove_dud_cells();
    }

    return 0;
}

// LUA: spots_get_items(list)
//
int SPOT_get_items(lua_State *L)
{
    if (lua_type(L, 1) != LUA_TTABLE)
    {
        return luaL_argerror(L, 1, "missing table: items");
    }

    std::vector<grid_point_c> items;

    clean_up_grid();

    SPOT_ItemSpots(items);

    for (unsigned int i = 0; i < items.size(); i++)
    {
        store_mon_or_item(L, 1, 1 + i, items[i].x - 8, items[i].y - 8, items[i].x + 8, items[i].y + 8);
    }

    return 0;
}

// LUA: spots_end()
//
int SPOT_end(lua_State *L)
{
    SPOT_FreeGrid();

    return 0;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
