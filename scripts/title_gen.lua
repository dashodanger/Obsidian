------------------------------------------------------------------------
--  Title-pic generator
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2015-2017 Andrew Apted
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------


--
-- The shapes of these characters are based on the DejaVu TTF font.
-- Only contains uppercase letters, digits, and some punctuation.
--

TITLE_LETTER_SHAPES =
{
  [" "] =
  {
    width = 0.5000,
    points = { },
  },

  ["'"] =
  {
    width = 0.0833,
    points =
    {
      { x=0.08333, y=1.00000 },
      { x=0.08333, y=0.88333 },
      { x=0.04167, y=0.80000 },
      { x=0.00000, y=0.75833 },
    },
  },

  ["-"] =
  {
    width = 0.3375,
    points =
    {
      { x=0.00000, y=0.36250 },
      { x=0.33750, y=0.36250 },
    },
  },

  ["_"] =
  {
    width = 0.5000,
    points =
    {
      { x=0.00000, y=0.00000 },
      { x=0.50000, y=0.00000 },
    },
  },

  ["."] =
  {
    width = 0.2000,
    points =
    {
      { x=0.10000, y=0.0 },
      { x=0.10000, y=0.0 },
    },
  },

  [":"] =
  {
    width = 0.2000,
    points =
    {
      { x=0.10000, y=0.68750 },
      { x=0.10000, y=0.68750 },
      {},
      { x=0.10000, y=0.13750 },
      { x=0.10000, y=0.13750 },
    },
  },

  ["A"] =
  {
    width = 0.8083,
    points =
    {
      { x=0.00000, y=0.00417 },
      { x=0.40417, y=0.99167 },
      { x=0.80833, y=0.00417 },
      {},
      { x=0.14167, y=0.33333 },
      { x=0.67083, y=0.33333 },
    },
  },

  ["B"] =
  {
    width = 0.5958,
    points =
    {
      { x=0.00000, y=0.00000 },
      { x=0.00000, y=1.00000 },
      { x=0.34583, y=1.00000 },
      { x=0.44167, y=0.97083 },
      { x=0.54167, y=0.86667 },
      { x=0.55833, y=0.77500 },
      { x=0.52917, y=0.63750 },
      { x=0.43333, y=0.55833 },
      { x=0.29167, y=0.53750 },
      { x=0.00000, y=0.53750 },
      {},
      { x=0.29167, y=0.53750 },
      { x=0.51667, y=0.46250 },
      { x=0.58333, y=0.36667 },
      { x=0.59583, y=0.27917 },
      { x=0.55833, y=0.11667 },
      { x=0.45000, y=0.02083 },
      { x=0.34583, y=0.00000 },
      { x=0.00000, y=0.00000 },
    },
  },

  ["C"] =
  {
    width = 0.7542,
    points =
    {
      { x=0.75000, y=0.91667 },
      { x=0.59167, y=1.00000 },
      { x=0.43750, y=1.00000 },
      { x=0.22500, y=0.94500 },
      { x=0.04167, y=0.76667 },
      { x=0.00000, y=0.52500 },
      { x=0.03333, y=0.27917 },
      { x=0.14167, y=0.08333 },
      { x=0.29167, y=0.00000 },
      { x=0.43750, y=0.00000 },
      { x=0.60000, y=0.03000 },
      { x=0.75417, y=0.08500 },
    },
  },

  ["D"] =
  {
    width = 0.7458,
    points =
    {
      { x=0.00000, y=0.00000 },
      { x=0.00000, y=1.00000 },
      { x=0.28750, y=1.00000 },
      { x=0.49167, y=0.95833 },
      { x=0.65833, y=0.84167 },
      { x=0.73333, y=0.64167 },
      { x=0.74583, y=0.51667 },
      { x=0.72917, y=0.30833 },
      { x=0.63333, y=0.12500 },
      { x=0.43333, y=0.01667 },
      { x=0.30833, y=0.00000 },
      { x=0.00000, y=0.00000 },
    },
  },

  ["E"] =
  {
    width = 0.5500,
    points =
    {
      { x=0.55000, y=0.00000 },
      { x=0.00000, y=0.00000 },
      { x=0.00000, y=1.00000 },
      { x=0.53750, y=1.00000 },
      {},
      { x=0.00000, y=0.53750 },
      { x=0.52083, y=0.53750 },
    },
  },

  ["F"] =
  {
    width = 0.4792,
    points =
    {
      { x=0.00000, y=0.00000 },
      { x=0.00000, y=1.00000 },
      { x=0.47917, y=1.00000 },
      {},
      { x=0.00000, y=0.53750 },
      { x=0.42917, y=0.53750 },
    },
  },

  ["G"] =
  {
    width = 0.7833,
    points =
    {
      { x=0.49583, y=0.45833 },
      { x=0.78333, y=0.45833 },
      { x=0.78333, y=0.04583 },
      { x=0.61667, y=-0.01667 },
      { x=0.46250, y=-0.02917 },
      { x=0.28333, y=0.00417 },
      { x=0.12500, y=0.11250 },
      { x=0.02500, y=0.29167 },
      { x=0.00000, y=0.48333 },
      { x=0.04583, y=0.75000 },
      { x=0.15417, y=0.91667 },
      { x=0.33750, y=1.00000 },
      { x=0.45833, y=1.01250 },
      { x=0.66250, y=0.99167 },
      { x=0.77917, y=0.93333 },
    },
  },

  ["H"] =
  {
    width = 0.6667,
    points =
    {
      { x=0.00000, y=0.00000 },
      { x=0.00000, y=1.00000 },
      {},
      { x=0.00000, y=0.53333 },
      { x=0.66667, y=0.53333 },
      {},
      { x=0.66667, y=0.00000 },
      { x=0.66667, y=1.00000 },
    },
  },

  ["I"] =
  {
    width = 0.3333,
    points =
    {
      { x=0.16667, y=0.00000 },
      { x=0.16667, y=1.00000 },
      {},
      { x=0.00000, y=0.00000 },
      { x=0.33333, y=0.00000 },
      {},
      { x=0.00000, y=1.00000 },
      { x=0.33333, y=1.00000 },
    },
  },

  ["J"] =
  {
    width = 0.4458,
    points =
    {
      { x=0.11250, y=1.00000 },
      { x=0.44583, y=1.00000 },
      {},
      { x=0.28750, y=1.00000 },
      { x=0.28750, y=0.27500 },
      { x=0.25417, y=0.10000 },
      { x=0.19583, y=0.02917 },
      { x=0.10833, y=0.00000 },
      { x=0.00000, y=0.00000 },
    },
  },

  ["K"] =
  {
    width = 0.5917,
    points =
    {
      { x=0.00000, y=0.00000 },
      { x=0.00000, y=1.00000 },
      {},
      { x=0.54167, y=1.00000 },
      { x=0.03583, y=0.53333 },
      { x=0.59167, y=0.00000 },
    },
  },

  ["L"] =
  {
    width = 0.5292,
    points =
    {
      { x=0.52917, y=0.00000 },
      { x=0.00000, y=0.00000 },
      { x=0.00000, y=1.00000 },
    },
  },

  ["M"] =
  {
    width = 0.8600,
    points =
    {
      { x=0.00000, y=0.00000 },
      { x=0.00000, y=1.00000 },
      { x=0.03000, y=1.00000 },
      { x=0.43000, y=0.21250 },
      { x=0.83000, y=1.00000 },
      { x=0.86000, y=1.00000 },
      { x=0.86000, y=0.00000 },
    },
  },

  ["N"] =
  {
    width = 0.6042,
    points =
    {
      { x=0.00000, y=0.00000 },
      { x=0.00000, y=1.00000 },
      { x=0.02500, y=1.00000 },
      { x=0.57917, y=0.00000 },
      { x=0.60417, y=0.00000 },
      { x=0.60417, y=1.00000 },
    },
  },

  ["O"] =
  {
    width = 0.8250,
    points =
    {
      { x=0.00000, y=0.50833 },
      { x=0.03750, y=0.75000 },
      { x=0.15000, y=0.92917 },
      { x=0.29167, y=1.00000 },
      { x=0.40833, y=1.00000 },
      { x=0.62500, y=0.96667 },
      { x=0.75833, y=0.81250 },
      { x=0.81250, y=0.63750 },
      { x=0.82500, y=0.49167 },
      { x=0.78333, y=0.24583 },
      { x=0.65833, y=0.06250 },
      { x=0.52500, y=0.00000 },
      { x=0.40417, y=0.00000 },
      { x=0.26250, y=0.00417 },
      { x=0.10000, y=0.11667 },
      { x=0.02083, y=0.30417 },
      { x=0.00000, y=0.50833 },
    },
  },

  ["P"] =
  {
    width = 0.5417,
    points =
    {
      { x=0.00000, y=0.00000 },
      { x=0.00000, y=1.00000 },
      { x=0.29167, y=1.00000 },
      { x=0.42917, y=0.95833 },
      { x=0.52083, y=0.84583 },
      { x=0.54167, y=0.73333 },
      { x=0.50417, y=0.57500 },
      { x=0.38333, y=0.47083 },
      { x=0.28750, y=0.45417 },
      { x=0.00000, y=0.45417 },
    },
  },

  ["Q"] =
  {
    width = 0.8250,
    points =
    {
      { x=0.00000, y=0.50833 },
      { x=0.03750, y=0.75000 },
      { x=0.15000, y=0.92917 },
      { x=0.29167, y=1.00833 },
      { x=0.40833, y=1.02083 },
      { x=0.62500, y=0.96667 },
      { x=0.75833, y=0.81250 },
      { x=0.81250, y=0.63750 },
      { x=0.82500, y=0.49167 },
      { x=0.78333, y=0.24583 },
      { x=0.65833, y=0.06250 },
      { x=0.52500, y=-0.00833 },
      { x=0.40417, y=-0.02500 },
      { x=0.26250, y=0.00417 },
      { x=0.10000, y=0.11667 },
      { x=0.02083, y=0.30417 },
      { x=0.00000, y=0.50833 },
      {},
      { x=0.54583, y=-0.03333 },
      { x=0.69583, y=-0.19583 },
    },
  },

  ["R"] =
  {
    width = 0.6000,
    points =
    {
      { x=0.00000, y=0.00000 },
      { x=0.00000, y=1.00000 },
      { x=0.29167, y=1.00000 },
      { x=0.42917, y=0.95833 },
      { x=0.52083, y=0.84583 },
      { x=0.54167, y=0.73333 },
      { x=0.50417, y=0.57500 },
      { x=0.38333, y=0.47083 },
      { x=0.28750, y=0.45417 },
      { x=0.00000, y=0.45417 },
      {},
      { x=0.31250, y=0.42500 },
      { x=0.39583, y=0.37083 },
      { x=0.51250, y=0.02917 },
      { x=0.60000, y=0.00000 },
    },
  },

  ["S"] =
  {
    width = 0.6208,
    points =
    {
      { x=0.00000, y=0.06250 },
      { x=0.17500, y=0.00000 },
      { x=0.31250, y=-0.02500 },
      { x=0.45833, y=0.00417 },
      { x=0.57500, y=0.08333 },
      { x=0.62083, y=0.24167 },
      { x=0.58333, y=0.37083 },
      { x=0.44167, y=0.47500 },
      { x=0.15833, y=0.55000 },
      { x=0.05000, y=0.64167 },
      { x=0.02083, y=0.77917 },
      { x=0.06250, y=0.91667 },
      { x=0.17917, y=1.00000 },
      { x=0.32083, y=1.02083 },
      { x=0.48333, y=1.00000 },
      { x=0.60417, y=0.93750 },
    },
  },

  ["T"] =
  {
    width = 0.8333,
    points =
    {
      { x=0.41667, y=0.00000 },
      { x=0.41667, y=1.00000 },
      {},
      { x=0.00000, y=1.00000 },
      { x=0.83333, y=1.00000 },
    },
  },

  ["U"] =
  {
    width = 0.6625,
    points =
    {
      { x=0.00000, y=1.00000 },
      { x=0.00000, y=0.35833 },
      { x=0.02500, y=0.17083 },
      { x=0.09583, y=0.05833 },
      { x=0.21667, y=-0.00833 },
      { x=0.32917, y=-0.02500 },
      { x=0.44167, y=-0.01250 },
      { x=0.55417, y=0.04167 },
      { x=0.62500, y=0.12917 },
      { x=0.66250, y=0.35833 },
      { x=0.66250, y=1.00000 },
    },
  },

  ["V"] =
  {
    width = 0.8208,
    points =
    {
      { x=0.00000, y=1.00000 },
      { x=0.37500, y=0.00000 },
      { x=0.40000, y=0.00000 },
      { x=0.82083, y=1.00000 },
    },
  },

  ["W"] =
  {
    width = 1.1292,
    points =
    {
      { x=0.00000, y=1.00000 },
      { x=0.25417, y=0.00000 },
      { x=0.29583, y=0.00000 },
      { x=0.55417, y=0.58333 },
      { x=0.58750, y=0.58333 },
      { x=0.82917, y=0.00000 },
      { x=0.87083, y=0.00000 },
      { x=1.12917, y=1.00000 },
    },
  },

  ["X"] =
  {
    width = 0.7250,
    points =
    {
      { x=0.00000, y=-0.00833 },
      { x=0.69167, y=1.00000 },
      {},
      { x=0.04583, y=1.00000 },
      { x=0.72500, y=0.00000 },
    },
  },

  ["Y"] =
  {
    width = 0.7200,
    points =
    {
      { x=0.36000, y=-0.00417 },
      { x=0.36000, y=0.49167 },
      { x=0.00000, y=1.00000 },
      {},
      { x=0.36000, y=0.49167 },
      { x=0.72000, y=1.00000 },
    },
  },

  ["Z"] =
  {
    width = 0.8292,
    points =
    {
      { x=0.82917, y=0.00000 },
      { x=0.00000, y=0.00000 },
      { x=0.80833, y=1.00000 },
      { x=0.01667, y=1.00000 },
    },
  },

  ["0"] =
  {
    width = 0.6,
    rx = { 82,145 },
    ry = { 150,48 },
    points =
    {
      { x=118, y=150 },
      { x=108, y=149 },
      { x= 92, y=142 },
      { x= 85, y=122 },

      { x= 84, y=95 },
      { x= 87, y=70 },
      { x=100, y=54 },

      { x=118, y=48 },
      { x=126, y=48 },
      { x=137, y=54 },
      { x=145, y=70 },

      { x=150, y=95 },
      { x=145, y=122 },
      { x=136, y=142 },
      { x=126, y=149 },
      { x=118, y=150 },
    },
  },

  ["1"] =
  {
    width = 0.6,
    rx = { 184,249 },
    ry = { 152,48 },
    points =
    {
      { x=220,y=151 },
      { x=220,y= 48 },
      { x=190,y= 63 },
      {},
      { x=184,y=152 },
      { x=249,y=152 },
    },
  },

  ["2"] =
  {
    width = 0.6,
    rx = { 285,347 },
    ry = { 152,46 },
    points =
    {
      { x=285, y=54 },
      { x=302, y=46 },
      { x=320, y=46 },
      { x=334, y=51 },
      { x=343, y=64 },
      { x=343, y=79 },
      { x=336, y=96 },

      { x=285, y=151 },
      { x=346, y=151 },
    },
  },

  ["3"] =
  {
    width = 0.6,
    rx = { 388,450 },
    ry = { 152,42 },
    points =
    {
      { x=388, y=42 },
      { x=450, y=42 },
      { x=444, y=78 },
      { x=434, y=87 },
      { x=420, y=93 },
      { x=408, y=93 },
      {},
      { x=420, y=93 },
      { x=432, y=97 },
      { x=445, y=105 },
      { x=450, y=119 },
      { x=450, y=130 },
      { x=442, y=143 },
      { x=426, y=152 },
      { x=410, y=152 },
      { x=388, y=147 },
    },
  },

  ["4"] =
  {
    width = 0.6,
    rx = { 490,558 },
    ry = { 152,48 },
    points =
    {
      { x=558,y=121 },
      { x=490,y=121 },
      { x=539,y=48  },
      { x=539,y=152 },
    },
  },

  ["5"] =
  {
    width = 0.6,
    rx = { 82,142 },
    ry = { 338,232 },
    points =
    {
      { x=137,y=232 },
      { x=88, y=232 },
      { x=88, y=278 },
      { x=102,y=273 },
      { x=115,y=273 },
      { x=134,y=282 },
      { x=142,y=300 },
      { x=142,y=312 },

      { x=130,y=330 },
      { x=115,y=338 },
      { x=100,y=338 },
      { x= 82,y=332 },
    },
  },

  ["6"] =
  {
    width = 0.6,
    rx = { 185,249 },
    ry = { 341,231 },
    points =
    {
      { x=245,y=238 },
      { x=231,y=231 },
      { x=221,y=231 },
      { x=204,y=237 },
      { x=190,y=255 },
      { x=185,y=276 },
      { x=185,y=292 },
      { x=189,y=319 },
      { x=202,y=336 },
      { x=214,y=340 },
      { x=223,y=340 },
      { x=242,y=330 },
      { x=249,y=313 },
      { x=249,y=298 },
      { x=241,y=283 },
      { x=226,y=273 },
      { x=214,y=273 },
      { x=201,y=279 },
      { x=191,y=293 },
    },
  },

  ["7"] =
  {
    width = 0.6,
    rx = { 285,347 },
    ry = { 341,232 },
    points =
    {
      { x=285,y=232 },
      { x=347,y=232 },
      { x=307,y=341 },
    },
  },

  ["8"] =
  {
    width = 0.6,
    rx = { 388,451 },
    ry = { 340,231 },
    points =
    {
      { x=415,y=281 },
      { x=427,y=281 },
      { x=442,y=272 },
      { x=449,y=261 },
      { x=449,y=250 },
      { x=441,y=238 },

      { x=427,y=231 },
      { x=415,y=231 },
      { x=399,y=239 },
      { x=392,y=250 },
      { x=392,y=261 },
      { x=400,y=272 },

      { x=415,y=281 },
      { x=427,y=281 },
      { x=442,y=290 },
      { x=451,y=302 },
      { x=451,y=318 },
      { x=444,y=331 },

      { x=427,y=340 },
      { x=415,y=340 },
      { x=397,y=331 },
      { x=388,y=318 },
      { x=388,y=302 },
      { x=398,y=290 },
      { x=415,y=281 },
    },
  },

  ["9"] =
  {
    width = 0.6,
    rx = { 490,554 },
    ry = { 339,232 },
    points =
    {
      { x=494,y=335 },
      { x=511,y=339 },
      { x=522,y=339 },
      { x=534,y=334 },
      { x=547,y=318 },
      { x=554,y=294 },
      { x=554,y=274 },
      { x=549,y=249 },
      { x=538,y=236 },

      { x=528,y=232 },
      { x=516,y=232 },
      { x=499,y=240 },
      { x=490,y=257 },
      { x=490,y=272 },
      { x=500,y=290 },
      { x=515,y=297 },
      { x=526,y=297 },
      { x=539,y=290 },
      { x=548,y=277 },
    },
  },

-- end of letter_shapes
}


------------------------------------------------------------------------


--struct TRANSFORM
--[[
    x, y     -- origin coordinate for transform function
             -- x is the left coord, y is the baseline

    func     -- function(T, x, y) to transform coords to screen space

    along    -- current horizontal position when drawing a string
             -- starts at 0.  units are "local" (NOT screen space)

    spacing  -- space between characters (in "local" space)

    max_along  -- measured width of current string (in "local" space)


    ==== style stuff ====

    fw, fh   -- font width / height

    thick    -- thickness of the drawing pen
--]]


function Title_transform_Straight(T, x, y)
  -- simplest transform: a pure translation
  return T.x + x * T.fw, T.y - y * T.fh
end


function Title_transform_Italics(T, x, y)
  return T.x + x * T.fw + (y - 0.5) * T.fh * 0.3, T.y - y * T.fh
end


function Title_transform_Perspective(T, x, y)
  local m = x / T.max_along

  m = m ^ 0.7
  x = m * T.max_along

  m = 1.2 - m * 0.6

  local n = (1.0 - m) / 2

  return T.x + x * T.fw, T.y - (y * m + n) * T.fh
end


function Title_transform_FatTop(T, x, y)
  local m = x / T.max_along

  m = (1 - (m * 2)) / 3

  return T.x + x * T.fw + (1-y) * m * T.fh, T.y - y * T.fh
end


function Title_transform_FatBottom(T, x, y)
  local m = x / T.max_along

  m = (1 - (m * 2)) / 3

  return T.x + x * T.fw + y * m * T.fh, T.y - y * T.fh
end



TITLE_TRANSFORM_LIST =
{
  straight    = Title_transform_Straight,
  italics     = Title_transform_Italics,
  perspective = Title_transform_Perspective,
  fat_top     = Title_transform_FatTop,
  fat_bottom  = Title_transform_FatBottom
}


------------------------------------------------------------------------


function Title_make_stroke(T, x1,y1, x2,y2)
  x1, y1 = T.func(T, x1, y1)
  x2, y2 = T.func(T, x2, y2)

  gui.title_draw_line(math.floor(x1 + T.ofs_x), math.floor(y1 + T.ofs_y), math.floor(x2 + T.ofs_x), math.floor(y2 + T.ofs_y))
end



function Title_draw_char(T, ch)
  -- we draw lowercase characters as smaller uppercase ones
  local local_w = 1.0
  local local_h = 1.0

  if string.match(ch, "[a-z]") then
    local_w = 0.8
    local_h = 0.7

    ch = string.upper(ch)
  end


  local info = TITLE_LETTER_SHAPES[ch]

  -- ignore any unknown characters
  if not info then return end


  -- draw the lines --

  for i = 1, #info.points - 1 do
    local x1 = info.points[i].x
    local y1 = info.points[i].y

    local x2 = info.points[i + 1].x
    local y2 = info.points[i + 1].y

    if not x1 or not x2 then goto continue end

    x1 = T.along + x1 * local_w ; y1 = y1 * local_h
    x2 = T.along + x2 * local_w ; y2 = y2 * local_h

    Title_make_stroke(T, x1,y1, x2,y2)
    ::continue::
  end

  -- advance horizontally for next character
  T.along = T.along + local_w * info.width + T.spacing
end



function Title_measure_char(ch, spacing)
  local local_w = 1.0

  if string.match(ch, "[a-z]") then
    local_w = 0.8
    ch = string.upper(ch)
  end

  local info = TITLE_LETTER_SHAPES[ch]

  if not info then return 0 end

  return local_w * info.width + spacing
end



function Title_draw_string(T, text)
  T.along = 0

  for i = 1, #text do
    local ch = string.sub(text, i, i)

    Title_draw_char(T, ch)
  end
end



function Title_measure_string(text, spacing)
  local width = 0

  for i = 1, #text do
    local ch = string.sub(text, i, i)

    -- do not include the spacing on the final letter
    if i == #text then spacing = 0 end

    width = width + Title_measure_char(ch, spacing)
  end

  return width
end



function Title_centered_string(T, mx, my, text, style)
  assert(style.font_mode)

  -- do not create really tall letters
  if T.fh / T.fw > 2.5 then
     T.fh = T.fw * 2.5
  end


  -- measure string and set position --

  local width = Title_measure_string(text, T.spacing)

  T.max_along = width

  width = width * T.fw

  T.x = mx - width * 0.5
  T.y = my + T.fh  * 0.5

  local base_ofs = 0 - T.thick / 2

  local thick


  -- TODO : support "thin_horiz" and "thin_vert" pens
  -- [ not real pens, just use different box_w than box_h ]

  -- FIXME : the "slash" pens should adjust box_h too

  gui.title_prop("pen_type", T.pen_type or "circle")


  -- do the outlines --

  if style.font_outlines then
    gui.title_prop("render_mode", "solid")

    for i = #style.font_outlines, 1, -1 do
      local outline = style.font_outlines[i]

      gui.title_prop("color", outline)

      if style.font_outline_mode == "shadow" then
        thick = T.thick + i

        T.ofs_x = base_ofs
        T.ofs_y = base_ofs

      elseif style.font_outline_mode == "shadow2" then
        thick = T.thick + i

        T.ofs_x = base_ofs - i
        T.ofs_y = base_ofs

      elseif style.font_outline_mode == "zoom" then
        thick = T.thick + i

        T.ofs_x = base_ofs - i / 2
        T.ofs_y = base_ofs + i * 1.5

      else  -- the normal "surround" mode
        thick = T.thick + i * 2

        T.ofs_x = base_ofs - i
        T.ofs_y = base_ofs - i
      end

      gui.title_prop("box_w", math.floor(thick))
      gui.title_prop("box_h", math.floor(thick))

      Title_draw_string(T, text)
    end
  end


  -- do central part of text --

  if style.font_mode == "texture" and style.font_texture then
    gui.title_prop("texture", GAME.title_screen_asset_dir .. "/" .. style.font_texture .. ".tga")
  else
    gui.title_prop("render_mode", style.font_mode)

    for k = 1, 4 do
      if style.font_colors[k] then
        gui.title_prop("color" .. k, style.font_colors[k])
      end
    end
  end

  if style.font_mode == "gradient" or style.font_mode == "gradient3" then
    gui.title_prop("grad_y1", math.floor(T.y - T.fh + 1))
    gui.title_prop("grad_y2", math.floor(T.y - 1))
  end

  gui.title_prop("box_w", math.floor(T.thick))
  gui.title_prop("box_h", math.floor(T.thick))

  T.ofs_x = base_ofs
  T.ofs_y = base_ofs

  Title_draw_string(T, text)
end



function Title_widest_size_to_fit(text, box_w, max_w, spacing)
  for w = max_w, 11, -1 do
    if w * Title_measure_string(text, spacing) <= box_w then
      return w
    end
  end

  return 10
end



function Title_draw_lit_box(x, y, w, h, hue1, hue2, hue3)
  if hue2 then
    gui.title_prop("color", hue2)
    gui.title_draw_rect(x, y, w, h)
  end

  gui.title_prop("color", hue3)

  gui.title_draw_rect(x, y, w, 1)
  gui.title_draw_rect(x, y, 1, h)

  gui.title_prop("color", hue1)

  gui.title_draw_rect(x, y + h - 1, w, 1)
  gui.title_draw_rect(x + w - 1, y, 1, h)
end



function Title_interp_color(list, ity, out)
  ity = math.clamp(0, ity, 1)
  ity = ity * (#list - 1)

  for pos = 1, #list - 1 do
    if ity <= 1 then
      local A = list[pos]
      local B = list[pos+1]

      out[1] = math.floor(A[1] * (1 - ity) + B[1] * ity)
      out[2] = math.floor(A[2] * (1 - ity) + B[2] * ity)
      out[3] = math.floor(A[3] * (1 - ity) + B[3] * ity)
      return
    end

    ity = ity - 1
  end

  out[1] = list[#list][1]
  out[2] = list[#list][2]
  out[3] = list[#list][3]
end


------------------------------------------------------------------------


TITLE_MAIN_STYLE =
{ }


TITLE_SUB_STYLE =
{ }


TITLE_SPACE_STYLE =
{ }


TITLE_INTERMISSION_STYLE =
{ }


TITLE_COLOR_RAMPS =
{ }


------------------------------------------------------------------------


TITLE_SEED = 0


function Title_gen_space_scene()
  --
  -- generate a night sky scene
  --

  local style = TITLE_SPACE_STYLE

  local density = rand.pick({40,70,100})

  local big_stars = {}


  local function distance_to_big_star(mx, my, r, x, y)
    -- account for the curvey-cross shape of big stars
    local dx = math.abs(x - mx)
    local dy = math.abs(y - my)

    if dy >= dx then dx, dy = dy, dx end

    local best_d = 9e9

    for i = 0, 1, 0.05 do
      local px = i * r
      local py = (1 - i) * 0.4

      local d = geom.dist(px, py, dx, dy)

      best_d = math.min(best_d, d)
    end

    return best_d
  end


  local function nearest_big_star(x, y)
    -- avoid the logo too
    local near_d = geom.dist(315, 195, x, y)

    for _,B in pairs(big_stars) do
      local d = distance_to_big_star(B.mx, B.my, B.r, x, y)

      near_d = math.min(near_d, d)
    end

    return near_d
  end


  local function draw_big_star(mx, my, r)
    local r2 = math.floor(r * 1.2)

    local DD = 0.09

    for y = my - r,  my + r  do
    for x = mx - r2, mx + r2 do
      local dx = (x - mx) / r2
      local dy = (y - my) / r

      local ity = 1.0 / (math.abs(dx) + DD) + 1.0 / (math.abs(dy) + DD)

      ity = ity / (1.0 / DD)
      ity = ity ^ 3.2
      ity = ity * (1.0 - geom.dist(0, 0, dx, dy))
      ity = 240 * math.clamp(0, ity, 1)

      if ity < 50 then goto continue end
      
      ity = math.floor(ity)

      gui.title_prop("color", { ity, ity, ity })
      gui.title_draw_rect(x, y, 1, 1)
      ::continue::
    end -- x, y
    end
  end


  local function location_for_big_star(r)
    local mx, my
    local best_d = -1

    for loop = 1, 9 do
      local tx = rand.irange(r+2, 320 - (r+2))
      local ty = rand.irange(r+2, 200 - (r+2))

      local d = nearest_big_star(tx, ty)

      if d > best_d then
        best_d = d
        mx, my = tx, ty
      end
    end

    assert(mx and my)

    return mx, my
  end


  local function add_big_stars()
    gui.title_prop("render_mode", "additive")

    local BIG_SIZES = { 56, 36, 16 }

    for _,r in pairs(BIG_SIZES) do
      if rand.odds(50) then
        local mx, my = location_for_big_star(r)
        table.insert(big_stars, { mx=mx, my=my, r=r })
        draw_big_star(mx, my, r)
      end
    end
  end


  local function draw_small_star(mx, my, size, col)
    -- determine brightness
    local ity = rand.pick({64,96,120,144,160,224})

    col[1] = ity
    col[2] = ity
    col[3] = ity

    gui.title_prop("color", col)

    if size == 1 then
      gui.title_draw_rect(mx, my, 1, 1)

    elseif size == 2 then
      gui.title_draw_rect(mx, my, 2, 2)

    else
      gui.title_draw_rect(mx, my, 1, 1)

      col[1] = math.floor(col[1] * 0.6)
      col[2] = math.floor(col[2] * 0.6)
      col[3] = math.floor(col[3] * 0.6)

      gui.title_prop("color", col)

      gui.title_draw_rect(mx-1, my, 1, 1)
      gui.title_draw_rect(mx+1, my, 1, 1)
      gui.title_draw_rect(mx, my-1, 1, 1)
      gui.title_draw_rect(mx, my+1, 1, 1)
    end
  end


  local function add_little_stars()
    gui.title_prop("render_mode", "additive")

    local col = { 0,0,0 }

    for x = 0, 319 do
      -- begin somewhere off-screen
      local y = rand.irange(-300, -500)

      while y < 200 do
        if y >= 0 then
          local size = 1
          if rand.odds(15) then size = 3 end
          if rand.odds(3)  then size = 2 end

          if nearest_big_star(x, y) >= 7 then
            draw_small_star(x, y, size, col)
          end
        end

        y = y + rand.irange(density / 2, density * 2)
      end
    end
  end


  gui.title_draw_clouds(TITLE_SEED, style.hue1, style.hue2, style.hue3,
                        style.thresh or 0, style.power or 1,
                        style.fracdim or 2.4)

  add_big_stars()

  add_little_stars()
end



function Title_gen_ray_burst()
  local mx, my

  mx = rand.pick({30,270, 160,160})
  my = rand.pick({-10,160, 80,90,100,100,110,120})

  local step = rand.pick({20,24,30,36})

  local ray_colors =
  {
    blue_white = 60,
    blue = 30,

    red_white = 30,
    orange_white = 30,
    brown_yellow = 30,
    dark_grey = 30,

    red = 10,
    pink = 10,
    light_brown = 10,
  }

  local color_name = rand.key_by_probs(ray_colors)

  local color_list = TITLE_COLOR_RAMPS[color_name]
  assert(color_list)


  local function coord(angle, dist)
    local x = mx + math.sin(angle * math.pi / 180) * dist * 1.2
    local y = my + math.cos(angle * math.pi / 180) * dist

    return x, y
  end

  local function draw_ray(angle, thick, col)
    local col = { 0,0,0 }

    for side = 0,1 do
    for m = thick, 0, -0.1 do
      local da = sel(side > 0, -1, 1) * m

      local x1, y1 = coord(angle + da, 380)

      local ity = 1.0 - m / thick

      ity = (ity ^ 1.4) * 0.8

      Title_interp_color(color_list, ity, col)

      gui.title_prop("color", col)
      gui.title_draw_line(mx, my, math.floor(x1), math.floor(y1), col)
    end
    end
  end


  -- draw each ray

  for angle = step/2, 361-step/2, step do
    draw_ray(angle, step * 0.4, col)
  end
end



function Title_gen_wall_scene()
  local style = TITLE_MAIN_STYLE

  -- draw the background over the whole screen
  gui.title_prop("texture", GAME.title_screen_asset_dir .. "/" .. style.background .. ".tga")

  gui.title_draw_rect(0, 0, 320, 200)

  if not style.props then return end

  -- apply lighting effect???
  --[[gui.title_prop("render_mode", "multiply")

  local col = { 0,0,0 }
  
  local xf = 1.0
  if #style.props == 1 then xf = 0.7 end
  if #style.props == 3 then xf = 1.6 end

  for x = 0, 319 do
  for y = 0, 199  do
    local d = 9e9
    for _,prop in pairs(style.props) do
      d = math.min(d, geom.dist(prop.x * xf, prop.y, x * xf, y))
    end

    local ity = math.exp(-d / 50) * 255  --- 255 - (d ^ 1.5) / 2.0,
    ity = math.clamp(0, ity, 255)
    
    ity = math.floor(ity)

    col[1] = ity
    col[2] = ity
    col[3] = ity

    gui.title_prop("color", col)
    gui.title_draw_rect(x, y, 1, 1)
  end
  end]]--

  -- draw each prop
  for _,prop in pairs(style.props) do
    gui.title_load_image(prop.x, prop.y, GAME.title_screen_asset_dir .. "/" .. prop.image .. ".tga")
  end
end



function Title_gen_cave_scene()
  local factor = math.sqrt(6)
  local sun_x = 2 / factor
  local sun_y = 1 / factor
  local sun_z = 1 / factor

  if rand.odds(50) then sun_x = - sun_x end

  local tall_mode = rand.odds(35)


  local cave_colors =
  {
    light_brown  = 60,
    brown_yellow = 60,

    red_white = 30,
    orange_white = 30,
    light_grey = 30,

    blue_white = 10,
    pink = 10,
    green = 10,
  }

  local color_name = rand.key_by_probs(cave_colors)

  local color_list = TITLE_COLOR_RAMPS[color_name]
  assert(color_list)


  local function intensity(mx, r, sx, sy)
    -- compute the normal vector
    local z = (sy - 99.5) / 99.5

    if tall_mode then z = (sy / 190) ^ 1.4 end

    local x = (sx - mx) / (r + 1)
    x = x * x * sel(x < 0, -1, 1)

    local y = math.sqrt(1 - x*x)

    -- normalize
    local len = math.sqrt(x*x + y*y + z*z)

    x = x / len
    y = y / len
    z = z / len

    return x * sun_x + y * sun_y + z * sun_z;
  end


  local function draw_cone(mx, dist)
    local col = { 0,0,0 }

    local dist_factor = 1.4 / (1 + math.log(dist + 0.5))

    for y = 0, 199 do
      -- calc radius at this point
      local r = math.abs(y - 99.5)
      r = 3 + r ^ 1.6 / 24

      if (dist < 5) then
        r = r + (5 - dist)
      end

      if tall_mode then
        r = (y - (dist-1)*3) * 0.5
        if r < 0 then goto continue end

        r = 1.2 + r ^ 2.2 / 240
      end

      for x = mx - r, mx + r do
        local ity = intensity(mx, r, x, y)

        ity = math.clamp(0, ity, 1) ^ 0.7
        ity = ity * dist_factor

        Title_interp_color(color_list, ity, col)

        gui.title_prop("color", col)
        gui.title_draw_rect(math.floor(x), math.floor(y), 1, 1)
      end
      ::continue::
    end
  end


  -- cave scene --

  if rand.odds(50) and not tall_mode then
    gui.title_prop("color", "#ffa")
    gui.title_draw_rect(0,0, 320,200)
  end


  for dist = 30, 1, -1 do
    local mx = rand.irange(5, 315)

    draw_cone(mx, dist)
  end
end



function Title_gen_tunnel_scene()
  local mx = 60
  local my = 60

  local x_mul = 0.75
  local y_mul = 0.25

  if rand.odds(50) then
    mx = 320 - mx
    x_mul = 1.0 - x_mul
  end


  local tunnel_colors =
  {
    blue_white   = 30,
    red_white    = 20,
    brown_yellow = 10,
    mid_green    = 10,
    mid_grey     = 10,
  }

  local color_name = rand.key_by_probs(tunnel_colors)

  local color_list = TITLE_COLOR_RAMPS[color_name]
  assert(color_list)

  local col = { 0,0,0 }

  for r = 1202, 2, -2 do
    local bump = (gui.random() ^ 5) * 0.7
    local ity = math.clamp(0.0, r / 1200, 0.9) + bump

    ity = ity * (1.0 - r / 900)

    Title_interp_color(color_list, ity, col)

    gui.title_prop("color", col)
    gui.title_draw_disc(math.floor(mx - r*x_mul), math.floor(my - r*y_mul), math.floor(r*1.2), math.floor(r))
  end
end



function Title_split_into_lines()
  --
  -- Determines whether to use one or two main lines for the title.
  -- It will depend on the length of the title (somewhat).
  -- Return can be:
  --   (a) a single string -- use it on a single line
  --   (b) two or three words -- first two are main lines, third is the
  --       little "of", "in", etc.. to be placed in-between
  --   (c) fourth value can be "The",
  --

  -- MSSP's notes:
  -- The lines are in the format:
  --
  -- top_line
  -- line1,
  -- mid_line
  -- line2,
  --
  -- Actual return pattern:
  -- line1, line2, mid_line, top_line

  local words = {}

  for w in string.gmatch(GAME.title, "%S+") do
    table.insert(words, w)
  end

  local top_line

  -- MSSP-FIXME: kind of broken
  -- for apostrophes and colons
  --[[if string.match(GAME.title, "'s")
  or string.match(GAME.title, ":") then
    local lf1 = "",
    local lf2 = "",

    local divider_encountered = false
    local since_div = 0,

    for w in string.gmatch(GAME.title, "%S+") do

      if since_div <= 1 then
        lf1 = lf1 .. w .. " ",
      end

      if since_div > 1 then
        lf2 = lf2 .. w .. " ",
      end

      if string.gmatch(w, "'s")
      or string.gmatch(w, ":") then
        divider_encountered = true
      end

      if divider_encountered then
        since_div = since_div + 1,
      end

    end

    lf1 = lf1:match("^%s*(.-)%s*$")
    lf2 = lf2:match("^%s*(.-)%s*$")

    return lf1, lf2, nil, nil
  end]]

  if words[1] == "The" or words[1] == "A" or words[1] == "An" then
    top_line = table.remove(words, 1)
  end

  -- handle titles like "X of the Y",
  if #words >= 4 and #words <=5 then
    words[2] = words[2] .. " " .. words[3]
    words[3] = words[4]
    if words[5] then
      words[3] = words[3] .. " " .. words[5]
    end
  end

  -- no choice?
  if #words < 2 then return GAME.title end

  local split_prob = 70

  if #GAME.title <= 12 then split_prob =  30 end
  if #GAME.title >= 17 then split_prob = 100 end

  if not rand.odds(split_prob) then return GAME.title end

  -- multiple lines
  if words[6] then
    local line1 = words[1]
    local line2 = words[4] .. " " .. words[5] .. " " .. words[6]
    local mid_line = words[2] .. " " .. words[3]
    return line1, line2, mid_line, top_line
  end

  if words[3] then
    return words[1], words[3], words[2], top_line
  else
    return words[1], words[2], nil,      top_line
  end
end



function Title_calc_max_thickness(fw, fh)
  -- TODO (1) : if pen style is thin_horiz/thin_vert, ignore that axis

  -- TODO (2) : slighly reduced value for perspective/fat_top/fat_bottom

  fw = math.min(fw, fh)

  fw = math.round(fw / 5 + 0.5)

  if fw < 1 then return 1 end

  return fw
end



function Title_pick_style(style_tab, reqs)

  local function matches(def)
    return true
  end

  local tab = {}

  for name,def in pairs(style_tab) do
    if matches(def) then
      tab[name] = def.prob or 50
    end
  end

  if table.empty(tab) then
    error("No title styles matching requirements")
  end

  local name = rand.key_by_probs(tab)

  return style_tab[name]
end



function Title_add_title()
  gui.title_prop("reset", "all")

  -- determine if we have one or two main lines
  local line1, line2, mid_line, top_line = Title_split_into_lines()

  if line1 then line1 = string.upper(line1) end
  if line2 then line2 = string.upper(line2) end

  if mid_line then mid_line = string.upper(mid_line) end

  -- determine what kind of sub-title we will draw (if any)
  local sub_title

  local bottom_line

  if rand.odds(50) and GAME.sub_title then
    if #GAME.sub_title <= 4 and string.upper(GAME.sub_title) == GAME.sub_title then
      -- this will be part of main title (a "version" string)
      bottom_line = GAME.sub_title
    else
      sub_title = GAME.sub_title
    end
  end


  local main_lines = 1 + sel(line2, 1, 0)

  local other_lines = sel(top_line, 1, 0) + sel(mid_line, 1, 0) + sel(bottom_line, 1, 0)

  local num_lines  = main_lines + other_lines


  -- figure out sizes of main area and sub-title area
  local bb_main = { w=280 }
  local bb_sub  = { w=240 }

  bb_main.h = 110 + num_lines * 5
  bb_sub.h  =  50 - num_lines * 5

  bb_main.x = (320 - bb_main.w) / 2
  bb_main.y = 20

  bb_sub.x  = (320 - bb_sub.w) / 2
  bb_sub.y  = 190 - bb_sub.h

  if not sub_title then
    bb_main.w = 260
    bb_main.x = (320 - bb_main.w) / 2

    bb_main.h = sel(bottom_line, 145, 135)
    bb_main.y = sel(bottom_line,  20,  22)

    -- dummy values (not used)
    bb_sub.h = 5
    bb_sub.y = 195
  end

  if top_line then
    bb_main.y = bb_main.y - 5
    bb_main.h = bb_main.h + 5
  end

  local style = TITLE_MAIN_STYLE

  -- FIXME : this used for the smaller words, often make it different (and simpler)
  local mid_style = style.alt or style

  -- vertical sizing of the main title
  local line_h = bb_main.h / (main_lines * 2 + other_lines)


  -- choose font sizes for the main lines
  local w1, w2

  local spacing = 0.45

  if not line2 then
    w1 = Title_widest_size_to_fit(line1, bb_main.w - 30, 50, spacing)
    w2 = w1
  else
    w1 = Title_widest_size_to_fit(line1, bb_main.w - 30, 50, spacing)
    w2 = Title_widest_size_to_fit(line2, bb_main.w - 30, 50, spacing)

    if false then
      w1 = math.min(w1, w2)
      w2 = w1
    end
  end

  local w3 = math.min(w1, w2) * 0.6


  local h1 = line_h * 1.2
  local h2 = line_h * 1.4

  local h3 = line_h * 0.7


  -- TODO: find a good naming scheme for these title parts

  -- decide geometry for major parts --

  local line1_T = { fw=w1, fh=h1, spacing=spacing }
  local line2_T = { fw=w2, fh=h2, spacing=spacing }
  local   mid_T = { fw=w3, fh=h3, spacing=spacing }

  local GEOMETRIES = { straight=60, italics=30, perspective=20, fat_bottom=20, fat_top=10 }

  local geometry1 = rand.key_by_probs(GEOMETRIES)

  line1_T.func = TITLE_TRANSFORM_LIST[geometry1]
  line2_T.func = TITLE_TRANSFORM_LIST[geometry1]
    mid_T.func = TITLE_TRANSFORM_LIST[geometry1]

  if rand.odds(50) or geometry1 == "perspective" then
    if geometry1 == "straight" then
      mid_T.func = TITLE_TRANSFORM_LIST["italics"]
    else
      mid_T.func = TITLE_TRANSFORM_LIST["straight"]
    end
  end


  line2_T.thick = Title_calc_max_thickness(line2_T.fw, line2_T.fh) * (style.narrow or 1)
  line1_T.thick = line2_T.thick

  mid_T.thick = Title_calc_max_thickness(mid_T.fw, mid_T.fh) * (mid_style.narrow or 1)


  -- decide pen type
  local PEN_TYPES = { circle=50, box=50 }

  if not style.texture and (style.narrow or 1) < 0.62 then
    PEN_TYPES.slash = 50
  end

  line1_T.pen_type = rand.key_by_probs(PEN_TYPES)
  line2_T.pen_type = line1_T.pen_type


  --- draw main title lines ---

  local mx = 160
  local my = bb_main.y

  if top_line then
    Title_centered_string(mid_T, mx, my + line_h/2, top_line, mid_style)
    my = my + line_h
  end

  if line1 then
    Title_centered_string(line1_T, mx, my + line_h, line1, style)
    my = my + line_h * 2
  end

  if mid_line then
    Title_centered_string(mid_T, mx, my + line_h/2 + 1, mid_line, mid_style)
    my = my + line_h
  end

  if line2 then
    Title_centered_string(line2_T, mx, my + line_h, line2, style)
    my = my + line_h * 2
  end

  if bottom_line then
    mid_T.fw = mid_T.fw * 2
    mid_T.fh = mid_T.fh * 1.4

    my = my + 10

    Title_centered_string(mid_T, mx, my + line_h/2, bottom_line, mid_style)
  end


  --- draw the sub-title ---

  if sub_title then
    -- create the transform
    local sub_T = {}

    -- TODO : more variety than this [ depends on the other parts though! ]
    local sub_geometry = "straight"

    sub_T.func = TITLE_TRANSFORM_LIST[sub_geometry]
    assert(sub_T.func)

    local mx = 160
    local my = bb_sub.y + bb_sub.h / 2

    style = TITLE_SUB_STYLE

    sub_T.fw = rand.sel(25, 13, 11)
    sub_T.fh = 13
    sub_T.spacing = rand.sel(50, 0.3, 0.4)

    sub_T.thick = Title_calc_max_thickness(sub_T.fw, sub_T.fh)

    -- adjust for a mix of upper/lower case
    if string.upper(GAME.sub_title) ~= GAME.sub_title then
      my = my - sub_T.fh / 8
    end

    Title_centered_string(sub_T, mx, my, GAME.sub_title, style)
  end
end



function Title_add_credit()
  gui.title_prop("reset", "all")
  gui.title_prop("color", "#000")

  gui.title_draw_rect(310, 190, 10, 10)

  gui.title_load_image(285, 163, "data/logo1.tga")
end



function Title_process_raw_fonts()
  local function dump_line(...)
    -- gui.debugf(...)
  end

  local function update(CH)
    dump_line("    points =\n")
    dump_line("    {\n")

    for _,P in pairs(CH.points) do
      local x = P.x
      local y = P.y

      if x == nil and y == nil then
        dump_line("      {}\n")
        goto continue
      end

      x = (P.x - CH.rx[1]) / (CH.rx[2] - CH.rx[1])
      y = (P.y - CH.ry[1]) / (CH.ry[2] - CH.ry[1])

      x = x * 0.6

      P.x = x
      P.y = y

      dump_line("      { x=%1.4f, y=%1.4f }\n", x, y)
      ::continue::
    end

    dump_line("    }\n")

    CH.rx = nil
    CH.ry = nil
  end

  local keys = table.keys(TITLE_LETTER_SHAPES)
  table.sort(keys)

  for _,let in pairs(keys) do
    local CH = TITLE_LETTER_SHAPES[let]
    if CH.rx then
      dump_line("RAW FONT '%s'\n", let)
      update(CH)
    end
  end
end



function Title_make_interpic()
  if not PARAM.interpic_lump then return end

  gui.title_create(320, 200, "#000")
  gui.title_set_palette(GAME.RESOURCES.PALETTES.normal)

  local style = TITLE_INTERMISSION_STYLE

  gui.title_draw_clouds(TITLE_SEED, style.hue1, style.hue2, style.hue3,
                        style.thresh or 0, style.power or 1,
                        style.fracdim or 2.4)

  local BW = 32
  local BH = 25

  local bricky = rand.odds(30)

  for bx = 0, 10 do
  for by = 0, 8 do
    local ofs = 0

    if bricky then ofs = (by % 2) * (BW / 2) end

    Title_draw_lit_box(bx*BW - ofs, by*BH, BW, BH,
                       style.hue1, nil, style.hue3)
  end
  end

  local lump   = PARAM.interpic_lump
  local format = PARAM.interpic_format

  if PARAM.tga_images then format = "tga" end

  gui.title_write(lump, format)
  gui.title_free()
end



function Title_add_background()
  if TITLE_MAIN_STYLE.background then
    Title_gen_wall_scene()
  elseif rand.odds(12) then
    Title_gen_ray_burst()
  elseif rand.odds(12) then
    Title_gen_tunnel_scene()
  elseif rand.odds(6) then
    Title_gen_cave_scene()
  else
    Title_gen_space_scene()
  end
end



function Title_make_titlepic()
  if not PARAM.titlepic_lump then return end

  gui.title_create(320, 200, "#000")
  gui.title_set_palette(GAME.RESOURCES.PALETTES.normal)

  Title_add_background()
  Title_add_credit()
  Title_add_title()

  local lump   = PARAM.titlepic_lump
  local format = PARAM.titlepic_format

  if PARAM.tga_images then format = "tga" end

  gui.title_write(lump, format)
  gui.title_free()
end



function Title_generate()
  assert(GAME.title)
  assert(GAME.RESOURCES.PALETTES)
  assert(GAME.RESOURCES.PALETTES.normal)
  assert(GAME.TITLE_MAIN_STYLES)
  assert(GAME.TITLE_SUB_STYLES)
  assert(GAME.TITLE_SPACE_STYLES)
  assert(GAME.TITLE_INTERMISSION_STYLES)
  assert(GAME.TITLE_COLOR_RAMPS)

  Title_process_raw_fonts()

  TITLE_SEED = gui.random_int()
  TITLE_MAIN_STYLE = Title_pick_style(GAME.TITLE_MAIN_STYLES, {})
  TITLE_SUB_STYLE = Title_pick_style(GAME.TITLE_SUB_STYLES, {})
  TITLE_SPACE_STYLE = Title_pick_style(GAME.TITLE_SPACE_STYLES, {})
  TITLE_COLOR_RAMPS = GAME.TITLE_COLOR_RAMPS
  TITLE_INTERMISSION_STYLE = Title_pick_style(GAME.TITLE_INTERMISSION_STYLES, {})

  Title_make_interpic()
  Title_make_titlepic()
end
