#!/usr/bin/env python3
# Cleans up font compiled by FontForge.

import sys
from fontTools.ttLib import TTFont
from fontTools.feaLib import builder

# Read arguments.
TTF   = sys.argv[1] # *.ttf
FEA   = sys.argv[2] # *.fea
CLEAN = sys.argv[3] # *.ttf

# Load font.
font = TTFont(TTF)

# Re-compile the features with FontTools.
builder.addOpenTypeFeatures(font, FEA)

# Remove FontForge table.
if "FFTM" in font:
	del font["FFTM"]

# Remove characters with a period in their name from
# the kern table, because they do not have a unicode
# mapping, which causes problems on Windows.
if "kern" in font:
	for table in font["kern"].kernTables:
		subtable = table.kernTable # Structure: {(char,char):val}
		for pair in list(subtable.keys()):
			if "." in pair[0] or "." in pair[1]:
				del subtable[pair]

# Recalculate correct xAvgCharWidth (FontValidator E2135).
# It seems that the value should be truncated, not rounded.
widths = [m[0] for m in font["hmtx"].metrics.values() if m[0] > 0]
font["OS/2"].xAvgCharWidth = int(sum(widths) / len(widths))

# Recalculate correct maxComponentDepth (FontValidator E1900).
maxp = font["maxp"]
maxp.recalc(font)

# Windows limits name ID2 to the four RIBBI styles.
# Adjust the name table in accordance to the spec.
# Parameters: (nameID, platformID, platEncID, langID)
name = font["name"]
family = str(name.getName(1, 3, 1, 0x409))
style  = str(name.getName(2, 3, 1, 0x409))
if not style in ("Regular", "Bold"):
	name.setName(family + " " + style, 1, 3, 1, 0x409)
	name.setName("Regular"           , 2, 3, 1, 0x409)

# Save font.
font.save(CLEAN)
