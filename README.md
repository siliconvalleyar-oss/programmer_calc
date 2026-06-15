# PCALC — Programmer's Calculator

[![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart)](https://dart.dev)

A dual-mode Flutter calculator for developers:
- **Programmer mode** — multi-base arithmetic, bitwise ops, math functions
- **Basic mode** — clean Apple iPhone-style calculator

Inspired by [pcalc](https://github.com/vapier/pcalc) (GNU programmer's calculator).

## Features

### Programmer mode
- Decimal, hexadecimal (`0x`), octal (`0o`/`0c`), binary (`0b`/`0y`)
- Bitwise: `|` OR, `&` AND, `X` XOR, `~` NOT, `<<` `>>` shifts
- Arithmetic: `+` `-` `*` `/` `%` `^` (exponentiation)
- Math functions: sin, cos, atan, log, log10, exp, sqrt, int, abs
- Unit conversions: f2c, c2f, in2mm, mm2in, po2kg, kg2po
- Multi-base result display (DEC + HEX + BIN + optional OCT)
- User variables + built-in constants (PI, E)
- Calculation history

### Basic mode
- Clean Apple iPhone aesthetic
- Light/dark theme toggle
- Standard 4-operation calculator
- Large readable display

## Quick start

```bash
flutter pub get
flutter run
flutter test
flutter analyze
```

## Build

```bash
flutter build apk --release   # Android
flutter build linux           # Linux
```

## Documentation

| File | Description |
|------|-------------|
| `SYNTAX.md` | Full expression syntax reference |
| `ARCHITECTURE.md` | Codebase architecture & data flow |
| `TODO.md` | Development roadmap |
| `.opencode/skills/pcalc-app.md` | OpenCode skill definition |

## License

GPLv2 — see [COPYING](ver/COPYING) (upstream pcalc license).
