Oxanium
=======

Oxanium is a square, futuristic font family. It feels at home on the
head-up display of a spaceship, or the scoreboard of a video game.
Its intuitive strokes ensure legibility at small sizes and quick
glances, while angled cuts add charisma to big headlines.

Oxanium includes seven weights, and supports the Adobe Latin 3
character set. It is released under the SIL Open Font License.


Build
-----

The fonts can be compiled with the provided Makefile,
which runs the scripts from the `tools` directory:

    make fonts
    make webfonts

Fonts can be compiled individually as well:

    make fonts/Oxanium-Regular.ttf

Intermediate files can be deleted with:

    make clean

FontForge might complain about non-BMP kern pairs,
these are fixed during the build process.


Dependencies
------------

### TTF

- [FontForge](https://fontforge.github.io) 20170731
- [FontTools](https://github.com/fonttools/fonttools) 3.34.2
- [Humble Type Instruction Compiler](https://gitlab.com/sev/htic) 3.4.0

### WOFF

- [Zopfli Python wrapper](https://pypi.python.org/pypi/zopfli)
- [Brotli Python wrapper](https://pypi.python.org/pypi/Brotli)
