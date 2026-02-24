# HC Architecture

## Overview

HC (Hierarchical C) is an indentation-based interface for writing C code.

The compiler is not a full C parser.  
Instead, HC works as a structural preprocessor that converts indentation-based syntax into valid C code.

Pipeline:

HC Source (.hc)
    ↓
Indentation Engine
    ↓
Block Generator
    ↓
Semicolon Inserter
    ↓
C Output (.c)
    ↓
GCC / Clang

---

## Design Philosophy

HC does NOT reimplement the C compiler.

Instead, it:

- Preserves full C syntax compatibility
- Converts indentation into `{}` blocks
- Automatically inserts `;` where required
- Delegates semantic validation to GCC/Clang

This keeps the project:
- Simple
- Maintainable
- Fully compatible with modern C

---

## Indentation Engine (v0.1)

The indentation engine is responsible for:

- Reading source lines
- Detecting indentation levels
- Emitting structural tokens

### Generated Tokens

- `LINE`   → Represents a line of code
- `INDENT` → Represents block entry
- `DEDENT` → Represents block exit

Example:

HC Input:

```c
int main()
    int x = 10
    if (x > 5)
        x++
    return 0
```

Generated Tokens:
```c
LINE int main()
INDENT
LINE int x = 10
LINE if (x > 5)
INDENT
LINE x++
DEDENT
LINE return 0
DEDENT
```

---

## Why Token-Based Design?

Using structural tokens allows:

- Clean separation between indentation logic and code generation
- Future extensibility (formatter, linter, LSP)
- Easier debugging

The indent engine does not:
- Validate C syntax
- Insert `{}` yet
- Insert `;` yet

Those responsibilities belong to later modules.