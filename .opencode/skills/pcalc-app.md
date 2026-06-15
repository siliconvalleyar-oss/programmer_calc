# PCALC — Programmer's Calculator

Flutter app with a full-featured programmer's calculator (inspired by `pcalc` / GNU `bc`) plus a basic iPhone-style calculator mode.

## Project structure

```
calc/
├── lib/
│   ├── main.dart                  # Entry point, routes between modes
│   ├── app_theme.dart             # Dark programmer theme (glassmorphism)
│   ├── basic_theme.dart           # Apple-style light/dark basic theme
│   ├── engine/
│   │   ├── token.dart             # Token types, lexer utilities
│   │   └── calculator_engine.dart # Recursive-descent parser & evaluator
│   ├── screens/
│   │   ├── programmer_screen.dart # Programmer calculator (multi-base, bitwise)
│   │   ├── basic_screen.dart      # Basic calculator (iPhone aesthetic)
│   │   ├── history_screen.dart    # Calculation history viewer
│   │   └── variables_screen.dart  # Variable/constant inspector
│   └── widgets/
│       ├── calc_display.dart      # Multi-base result display
│       ├── calc_button.dart       # Programmer-mode button
│       └── basic_button.dart      # Apple-style circular button
├── TODO.md
├── ARCHITECTURE.md
├── SYNTAX.md
├── ver/                           # Reference C source (gitignored)
└── .opencode/skills/pcalc-app.md
```

## Key conventions

- **StatefulWidget** for screens that hold expression state
- **StatelessWidget** for display-only components
- **CalculatorEngine** singleton injected via constructor (no global state)
- **Recursive descent parser** for expression evaluation (no external dep)
- **Two display modes**: programmer (DEC/HEX/BIN/OCT side-by-side) and basic (single result)
- **History** stored in-memory in the engine (max 100 entries)
- **Variables** stored in `Map<String, num>` on the engine, persisted per session

## Mode switching

The `main.dart` holds a `_mode` state (`programmer` / `basic`). Pressing the mode icon in the AppBar toggles between:
- **Programmer mode**: full keyboard, multi-base display, bitwise ops, functions
- **Basic mode**: simplified layout, iPhone aesthetic, 4-operations + memory

## Calculator engine

- Tokenizes via `_advance()` character-by-character scanner
- Grammar: `assignment → xor ( '|' xor )*` → `and ( '&' and )*` → `shift ( '<<'|'>>' shift )*` → `expr ( '+'|'-' expr )*` → `term ( '*'|'/'|'%' term )*` → `unary ( '~'|'-' )` → `power ( '^' )` → `primary`
- All numbers stored as `num` (double); bitwise ops truncate via `.toInt()`
- Uppercase `X` is XOR operator; lowercase `x` is identifier
- Functions are called as `sin(x)` or `sin x`

## Tests

```bash
flutter test
flutter analyze
```

## Build

```bash
flutter build apk --release
flutter build linux
```
