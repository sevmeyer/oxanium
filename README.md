Oxanium
=======

This is the source repository for the
[Oxanium font family](https://sev.dev/fonts/oxanium).


Build
-----

The fonts can be compiled with the provided Makefile,
which runs the scripts from the `tools` directory:

```
make all
```

Fonts can be compiled individually as well:

```
make fonts/ttf/Oxanium-Regular.ttf
```

The generated files can be deleted with:

```
make clean
```

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
