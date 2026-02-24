# HC – Test Commands

This document explains how to test `.hc` files using the HC CLI.

All test files must be inside the `examples/` folder.

---

## ▶ Run a Single File

Transpile, compile and execute one file:

```bash
lua bin/hc.lua examples/hello.hc
```
### What happens:

* The .hc file is converted to .c

* GCC compiles it

* The program runs

* The generated .c and executable are deleted

## ▶ Run All Examples

Run all .hc files inside examples/:
```bash
lua bin/hc.lua --all
```
### Each file will:

* Be transpiled

* Be compiled

* Be executed

* Be cleaned automatically

## ▶ Keep Generated C Files

If you want to keep the generated .c files:
```bash
lua bin/hc.lua --all --keepc
```
### The generated C files will be saved in:

* examples/generated/

* Executables are still deleted.

## Requirements

Make sure you have:
```bash
lua -v
gcc --version
```
Both must be installed and working.