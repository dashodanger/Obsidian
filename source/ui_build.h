//------------------------------------------------------------------------
//  Build panel
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

#include <string>
#include <vector>

#include "FL/Fl_Box.H"
#include "FL/Fl_Group.H"
#include "FL/Fl_Progress.H"
#include "ui_map.h"

class UI_Build : public Fl_Group
{
  public:
    UI_MiniMap  *mini_map;
    Fl_Box      *seed_disp;
    Fl_Box      *name_disp;
    Fl_Box      *alt_disp;
    Fl_Box      *status;
    Fl_Progress *progress;

  private:
    std::string status_label;
    std::string prog_label;

    int level_index; // starts at 1
    int level_total;

    bool  node_begun;
    float node_ratio;
    float node_along;
    float node_fracs;

    std::vector<std::string> step_names;

  public:
    UI_Build(int x, int y, int w, int h, const char *label = NULL);
    virtual ~UI_Build();

  public:
    void Prog_Init(int node_perc, const char *extra_steps);
    void Prog_AtLevel(int index, int total);
    void Prog_Step(const char *step_name);
    void Prog_Nodes(int pos, int limit);
    void Prog_Finish();
    void ParseSteps(const char *list);

    void SetStatus(std::string_view msg);

    void AddStatusStep(const std::string &name);

  private:
    void resize(int X, int Y, int W, int H);

    int FindStep(std::string_view name); // -1 if not found
};

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
