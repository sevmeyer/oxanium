#!/usr/bin/env python3
# Converts ttf font to optimized woff or woff2 webfont.

import sys
from fontTools import subset
from fontTools.ttLib import sfnt

# Read arguments.
TTF  = sys.argv[1] # *.ttf
WOFF = sys.argv[2] # *.woff|*.woff2

# Increase zopfli compression for woff.
sfnt.ZOPFLI_LEVELS[sfnt.ZLIB_COMPRESSION_LEVEL] = 500

# Generate webfont.
subset.main([
	TTF,
	"--glyphs=*",
	"--notdef-glyph",
	"--notdef-outline",
	"--no-recommended-glyphs",
	"--layout-features=*",
	"--hinting",
	"--no-desubroutinize",
	"--no-legacy-kern",
	"--name-IDs=*",
	"--no-name-legacy",
	"--no-glyph-names",
	"--no-legacy-cmap",
	"--no-symbol-cmap",
	"--no-recalc-bounds",
	"--no-recalc-timestamp",
	"--canonical-order",
	"--prune-unicode-ranges",
	"--no-recalc-average-width",
	"--with-zopfli",
	"--flavor=" + WOFF.split(".")[-1],
	"--output-file=" + WOFF
	])
