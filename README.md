Oxanium
=======

This is the source repository for the Oxanium font family.
TODO links


Build
-----

The fonts can be compiled with the provided Makefile,
which runs the scripts from the `tools` directory:

```
make all     Compile all fonts
make clean   Delete generated files and directories
```

Each font can be compiled individually as well:

```
make fonts/ttf/Oxanium-Regular.ttf
```

FontForge might complain about non-BMP kern pairs.
These are fixed during the build process.


Dependencies
------------

### TTF

- [FontForge](https://fontforge.github.io) 20170731
- [FontTools](https://github.com/fonttools/fonttools) 3.24.1
- [Humble Type Instruction Compiler](https://gitlab.com/sev/htic) 3.0.0

### WOFF

- [Zopfli Python wrapper](https://pypi.python.org/pypi/zopfli)
- [Brotli Python wrapper](https://pypi.python.org/pypi/Brotli)
