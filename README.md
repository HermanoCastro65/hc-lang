# HC Language

HC (Hierarchical C) is an indentation-based interface for writing C code without using `{}`, `}` and `;`.

The goal of HC is to provide a cleaner and more readable syntax for C while maintaining 100% compatibility with the C language.

HC is transpiled into standard C code, which is then compiled using GCC or Clang.

---

## 🚀 Motivation

C is powerful but syntactically verbose.
HC removes:

* Curly braces `{ }`
* Semicolons `;`

And replaces block structure with indentation.

Example:

### HC

```
int main()
    int x = 10
    if (x > 5)
        printf("Greater")
    return 0
```

### Generated C

```
int main() {
    int x = 10;
    if (x > 5) {
        printf("Greater");
    }
    return 0;
}
```

---

## 🏗 Project Structure

```
hc-lang/
│
├── bin/          # CLI entry point
├── src/          # Transpiler source code
├── examples/     # Example .hc programs
├── docs/         # Documentation
├── tests/        # Test cases
```

---

## 🧠 Architecture

HC works as a structural preprocessor:

HC → Lua Transpiler → C → GCC/Clang → Executable

The transpiler:

* Detects indentation
* Inserts `{}` automatically
* Inserts `;` automatically

---

## 📌 Current Status

Version: 0.1 (Indentation Engine under development)

---

## 📜 License

MIT License
