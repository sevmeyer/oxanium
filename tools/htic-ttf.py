#!/usr/bin/env python3
# Compile HTIC TrueType instructions into ttf font.

import sys
from fontTools.ttLib import TTFont

import htic

# Read arguments.
TTF = sys.argv[1] # *.ttf
HTI = sys.argv[2] # *.hti

font = TTFont(TTF)

# Add instructions.
htic.toFontTools(HTI, font)

# Save font.
font.save(TTF)
