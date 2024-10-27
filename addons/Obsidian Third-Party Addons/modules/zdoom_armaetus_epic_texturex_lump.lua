------------------------------------------------------------------------
--  MODULE: Obsidian Resource Pack Composite Textures Lump
------------------------------------------------------------------------
--
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
-------------------------------------------------------------------

EPIC_TEXTUREX_LUMP =
[[
WallTexture "T_TECH01", 128, 512
{
  Patch "PLAT1", -64, 0
  {
    Blend "#E4B381"
  }
  Patch "PLAT1", 64, 0
  {
    Blend "#E4B381"
  }
  Patch "PLAT1", -64, 256
  {
    Blend "#E4B381"
  }
  Patch "PLAT1", 64, 256
  {
    Blend "#E4B381"
  }
  Patch "PLAT1", -64, 384
  {
    FlipY
    Blend "#E4B381"
  }
  Patch "PLAT1", 64, 384
  {
    FlipY
    Blend "#E4B381"
  }
  Patch "PLAT1", -64, 128
  {
    FlipX
    FlipY
    Blend "#E4B381"
  }
  Patch "PLAT1", 64, 128
  {
    FlipX
    FlipY
    Blend "#E4B381"
  }
  Patch "RW37_4", 96, 0
  {
    Blend "#E4B381"
  }
  Patch "RW37_4", 96, 128
  {
    Blend "#E4B381"
  }
  Patch "RW37_4", 96, 256
  {
    Blend "#E4B381"
  }
  Patch "RW37_4", 96, 384
  {
    Blend "#E4B381"
  }
  Patch "RW37_4", -32, 0
  {
    FlipX
    Blend "#E4B381"
  }
  Patch "RW37_4", -32, 128
  {
    FlipX
    Blend "#E4B381"
  }
  Patch "RW37_4", -32, 256
  {
    FlipX
    Blend "#E4B381"
  }
  Patch "RW37_4", -32, 384
  {
    FlipX
    Blend "#E4B381"
  }
  Patch "RW37_2", 64, 488
  {
    Blend "#E4B381"
  }
  Patch "RW37_2", 64, -96
  {
    Blend "#E4B381"
  }
  Patch "RW37_2", 0, 488
  {
    Blend "#E4B381"
  }
  Patch "RW37_2", 0, -96
  {
    Blend "#E4B381"
  }
}

Texture "TP_HLBH", 64, 16
{
  Patch "T14_5", 0, 0
  {
    Rotate 90
  }
}

Texture "TP_HLCRE", 120, 10
{
  Patch "T_HLITE1", -4, -3
}

WallTexture "T_HLITE1", 128, 16
{
  Patch "TP_HLBH", 0, 0
  Patch "TP_HLBH", 64, 0
  {
    FlipX
  }
}

WallTexture "T_HLITEY", 128, 16
{
  Patch "T_HLITE1", 0, 0
  Patch "TP_HLCRE", 4, 3
  {
    Translation "83:111=161:167"
  }
}

WallTexture "T_HLITEG", 128, 16
{
  Patch "T_HLITE1", 0, 0
  Patch "TP_HLCRE", 4, 3
  {
    Translation "84:111=112:127"
  }
}

WallTexture "T_HLITEB", 128, 16
{
  Patch "T_HLITE1", 0, 0
  Patch "TP_HLCRE", 4, 3
  {
    Translation "80:111=192:207"
  }
}

WallTexture "T_GTHLY", 64, 128
{
  Patch "GOTH21", 0, 0
  {
    Translation "168:191=160:167", "17:47=160:167"
  }
}

WallTexture "T_GTHLG", 64, 128
{
  Patch "GOTH21", 0, 0
  {
    Translation "168:191=112:127", "17:47=112:127"
  }
}

WallTexture "T_GTHLB", 64, 128
{
  Patch "GOTH21", 0, 0
  {
    Translation "168:191=192:207", "17:47=192:207"
  }
}

WallTexture "T_GTHLP", 64, 128
{
  Patch "GOTH21", 0, 0
  {
    Translation "168:191=250:254", "17:47=250:254"
  }
}

Texture "TP_LIT5C", 14, 6
{
  Patch "LITE4", -1, 0
}

Texture "TP_LIL5C", 10, 64
{
  Patch "LITE4", -3, -59
}

Texture "T_VLITER", 16, 128
{
  Patch "LITE4", 0, 0
  Patch "LITEBLU4", 0, -72
  {
    Translation "201:207=172:191"
  }
  Patch "TP_LIL5C", 3, 59
  {
    Translation "80:95=169:191", "96:111=191:191"
  }
}

Texture "T_VLITEO", 16, 128
{
  Patch "LITE4", 0, 0
  Patch "LITEBLU4", 0, -72
  {
    Translation "201:207=211:223"
  }
  Patch "TP_LIL5C", 3, 59
  {
    Translation "80:95=211:223", "96:111=223:223"
  }
}

Texture "T_VLITEY", 16, 128
{
  Patch "LITE4", 0, 0
  Patch "LITEBLU4", 0, -72
  {
    Translation "201:207=160:167"
  }
  Patch "TP_LIL5C", 3, 59
  {
    Translation "80:95=160:167", "96:111=167:167"
  }
}

Texture "T_VLITEG", 16, 128
{
  Patch "LITE4", 0, 0
  Patch "LITEBLU4", 0, -72
  {
    Translation "201:207=112:127"
  }
  Patch "TP_LIL5C", 3, 59
  {
    Translation "80:95=112:127", "96:111=127:127"
  }
}

Texture "T_VLITEP", 16, 128
{
  Patch "LITE4", 0, 0
  Patch "LITEBLU4", 0, -72
  {
    Translation "201:207=250:254"
  }
  Patch "TP_LIL5C", 3, 59
  {
    Translation "80:95=250:254", "96:111=254:254"
  }
}

Texture "T_VSLTER", 16, 8
{
  Patch "T_VLITER", 0, 0
}

Texture "T_VSLTEO", 16, 8
{
  Patch "T_VLITEO", 0, 0
}

Texture "T_VSLTEY", 16, 8
{
  Patch "T_VLITEY", 0, 0
}

Texture "T_VSLTEG", 16, 8
{
  Patch "T_VLITEG", 0, 0
}

Texture "T_VSLTEP", 16, 8
{
  Patch "T_VLITEP", 0, 0
}

Flat "T_GHFLY", 64, 64
{
  Patch "GLITE04", 0, 0
  {
    Translation "168:191=160:167"
  }
}

Flat "T_GHFLG", 64, 64
{
  Patch "GLITE04", 0, 0
  {
    Translation "168:191=112:127"
  }
}

Flat "T_GHFLB", 64, 64
{
  Patch "GLITE04", 0, 0
  {
    Translation "168:191=192:200"
  }
}

Flat "T_GHFLP", 64, 64
{
  Patch "GLITE04", 0, 0
  {
    Translation "168:191=249:254"
  }
}

Flat "T_CL43R", 64, 64
{
  Patch "CEIL4_3", 0, 0
  {
    Translation "240:247=186:191", "192:207=185:185"
  }
}

Flat "T_CL43Y", 64, 64
{
  Patch "CEIL4_3", 0, 0
  {
    Translation "240:247=164:167", "192:207=163:163"
  }
}

Flat "T_CL43G", 64, 64
{
  Patch "CEIL4_3", 0, 0
  {
    Translation "240:247=120:127", "192:207=119:119"
  }
}

Flat "T_CL43P", 64, 64
{
  Patch "CEIL4_3", 0, 0
  {
    Translation "240:247=252:255", "192:207=252:252"
  }
}

Flat "T_SDTCH1", 64, 64
{
  Patch "SAND3", 0, 0
  Patch "SHINY03", 0, 0
  {
    Alpha 0.40
    Style Translucent
  }
}

Flat "T_SDTCH2", 64, 64
{
  Patch "GRATE7", 0, 0
  Patch "SAND4", 0, 0
  {
    Alpha 0.60
    Style Translucent
  }
  Patch "SAND4", 0, 0
  {
    Alpha 0.40
    Style Add
  }
}

Flat "T_SDTCH3", 64, 64
{
  Patch "GRATE1", 0, 0
  Patch "SAND4", 0, 0
  {
    Alpha 0.60
    Style Translucent
  }
  Patch "SAND4", 0, 0
  {
    Alpha 0.20
    Style Add
  }
}

Flat "T_SDTCH4", 64, 64
{
  Patch "FLAT3", 0, 0
  Patch "FLAT3", 0, 0
  {
    Style Add
  }
  Patch "SAND3", 0, 0
  {
    Alpha 0.60
    Style Translucent
  }
}

Flat "T_SDTCH5", 64, 64
{
  Patch "DARKM01", 0, 0
  Patch "DARKM01", 0, 0
  {
    Alpha 0.90
    Style Add
  }
  Patch "DARKM01", 0, 0
  {
    Alpha 0.90
    Style Add
  }
  Patch "SAND2", 0, 0
  {
    Alpha 0.70
    Style Translucent
  }
}

Texture "T_SHAWCR", 128, 64
{
  Patch "SHAWN1", 6, -3
  Patch "SHAWN1", -122, -3
}

Texture "T_RAILST", 64, 192
{
  Patch "RAIL1", 0, 0
  Patch "RAIL1", 0, 64
}

Texture "T_RAILS2", 64, 320
{
  Patch "RAIL1", 0, 0
  Patch "RAIL1", 0, 64
  Patch "RAIL1", 0, 128
  Patch "RAIL1", 0, 192
}

Texture "COMPYELL", 64, 128
{
  Patch "COMP03_1", 0, 0
  {
    Translation "192:207=160:163", "240:247=164:167"
  }
  Patch "COMP03_2", 0, 64
  {
    Translation "192:207=160:163", "240:247=164:167"
  }
}

Texture "TLIT65OF", 64, 64
{
	Patch "TLITE6_5", -48, -48
	Patch "TLITE6_5", 16, -48
	Patch "TLITE6_5", 16, 16
	Patch "TLITE6_5", -48, 16
}

// Composites based on Vol. 3
WallTexture "DECO1RED", 64, 128
{
	Patch "DECO1GRY", 0, 0
	{
		Blend "#FF0000"
	}
}

WallTexture "DECO1GRN", 64, 128
{
	Patch "DECO1GRY", 0, 0
	{
		Blend "#20FF18"
	}
}

WallTexture "DECO1TAN", 64, 128
{
	Patch "DECO1GRY", 0, 0
	{
		Blend "#FFAC04"
	}
}

WallTexture "DECO1BRN", 64, 128
{
	Patch "DECO1GRY", 0, 0
	{
		Blend "#675333"
	}
}

WallTexture "BRIC9GRN", 128, 128
{
	Patch "BRIC9GRY", 0, 0
	{
		Blend "#BFFA85"
	}
}

WallTexture "BRIC9TAN", 128, 128
{
	Patch "BRIC9GRY", 0, 0
	{
		Blend "#AF7B1F"
	}
}

WallTexture "BRICEGRN", 128, 128
{
	Patch "BRICEGRY", 0, 0
	{
		Blend "#BFFA85"
	}
}

// MSSP texture composites
Texture "OBTSTX1B", 128, 128
{
	Patch "OBTBSTX1", 0, 0
	{
		Blend "#826A55"
	}
}

Texture "OBTSTX1G", 128, 128
{
	Patch "OBTBSTX1", 0, 0
	{
		Blend "#779C67"
	}
}

Texture "OBTBSB2B", 256, 128
{
	Patch "OBTBSLB2", 0, 0
	{
		Blend "#E4AA7E"
	}
}

Texture "OBTBSB3B", 256, 128
{
	Patch "OBTBSLB3", 0, 0
	{
		Blend "#E4AA7E"
	}
}

Texture "OBTBSB4B", 256, 128
{
	Patch "OBTBSLB4", 0, 0
	{
		Blend "#E4AA7E"
	}
}

Texture "OBTBSB5B", 256, 128
{
	Patch "OBTBSLB5", 0, 0
	{
		Blend "#E4AA7E"
	}
}

Texture "OBTSBF1B", 64, 64
{
	Patch "OBTSVBF1", 0, 0
	{
		Blend "#E4AA7E"
	}
}

Texture "OBTSBF2B", 64, 64
{
	Patch "OBTSVBF2", 0, 0
	{
		Blend "#E4AA7E"
	}
}

Texture "OBTSBF3B", 64, 64
{
	Patch "OBTSVBF3", 0, 0
	{
		Blend "#E4AA7E"
	}
}

Texture "OBTSBF1R", 64, 64
{
	Patch "OBTSVBF1", 0, 0
	{
		Blend "#E41818"
	}
}

Texture "OBTSBF2R", 64, 64
{
	Patch "OBTSVBF2", 0, 0
	{
		Blend "#E41818"
	}
}

Texture "OBTSBF3R", 64, 64
{
	Patch "OBTSVBF3", 0, 0
	{
		Blend "#E41818"
	}
}

Texture "OBTBCMR1", 128, 128
{
	Patch "OBTBCEM1", 0, 0
	{
		Blend "#B52020"
	}
}

Texture "OBTBCMR2", 128, 128
{
	Patch "OBTBCEM2", 0, 0
	{
		Blend "#B52020"
	}
}

Texture "OBTBCMR3", 128, 128
{
	Patch "OBTBCEM3", 0, 0
	{
		Blend "#B52020"
	}
}

Texture "T_GLT5GN", 64, 64
{
	Patch "GLITE05", 0, 0
	{
		Translation "76:77=122:123", "160:167=114:121"
	}
}

Texture "T_GLT5RD", 64, 64
{
	Patch "GLITE05", 0, 0
	{
		Translation "76:78=186:191", "160:167=168:185"
	}
}

Texture "T_GLT5WT", 64, 64
{
	Patch "GLITE05", 0, 0
	{
		Translation "160:167=80:95", "76:77=96:103"
	}
}

Texture "T_GLT5BL", 64, 64
{
	Patch "GLITE05", 0, 0
	{
		Translation "160:167=192:203", "76:77=204:207"
	}
}

Texture "T_GLT5YL", 64, 64
{
	Patch "GLITE05", 0, 0
	{
		Translation "160:167=160:163", "76:77=164:167"
	}
}
]]
