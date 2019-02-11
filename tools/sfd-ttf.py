#!/usr/bin/env python3
# Converts sfd and supplementary source files to ttf font.

import sys
import fontforge
import htic

# Read arguments.
SFD = sys.argv[1] # *.sfd
FEA = sys.argv[2] # *.fea
HTI = sys.argv[3] # *.hti
VER = sys.argv[4] # version
TTF = sys.argv[5] # *.ttf

# Prepare font.
font = fontforge.open(SFD)
font.version = VER
font.appendSFNTName("English (US)", "Version", "Version " + VER)
font.appendSFNTName("English (US)", "UniqueID", font.fullname + " " + VER)

# Add features to generate legacy kern table.
font.mergeFeature(FEA)

# Add instructions.
htic.toFontforge(HTI, font)

# Save font.
font.generate(TTF, flags=("opentype", "old-kern", "dummy-dsig"))
font.close()
