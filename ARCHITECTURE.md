# PCALC Architecture

## Overview

PCALC is a dual-mode Flutter calculator:
- **Programmer mode**: full expression parser with bitwise ops, multiple bases, math functions
- **Basic mode**: simple 4-operation calculator with Apple iPhone aesthetic

Both modes share the same core engine but present different UIs.

## Layer diagram

```
┌──────────────────────────────────────────┐
│               main.dart                   │
│  (App shell, mode toggle, routing)       │
├────────────────┬─────────────────────────┤
│ programmer     │ basic_screen.dart        │
│ _screen.dart   │ (Apple-style buttons,    │
│ (multi-base    │  live digit entry,       │
│  display,      │  no expression parser)   │
│  full keyboard)│                          │
├────────────────┴─────────────────────────┤
│            CalculatorEngine                │
│  (recursive descent parser, tokenizer,    │
│   variables map, history list)            │
├──────────────────────────────────────────┤
│         app_theme.dart / basic_theme.dart  │
│  (colors, typography, component styles)   │
└──────────────────────────────────────────┘
```

## Data flow

### Programmer mode
1. User taps buttons → expression string built in `_expression`
2. User taps `=` → `engine.evaluate(_expression)` called
3. Engine tokenizes input, runs recursive descent parser
4. Returns `num?` result (or sets `lastError`)
5. `CalcDisplay` renders result in DEC/HEX/BIN (and optional OCT)

### Basic mode
1. User taps digits → current operand string built
2. User taps operator → stores current operand, waits for next
3. User taps `=` or next operator → applies pending operation
4. Display shows current accumulator value
5. Backspace removes last digit of current operand

## Engine (programmer mode only)

The `CalculatorEngine` is a hand-written recursive descent parser with this grammar:

```
assignment  →  identifier '=' assignment  |  xor
xor         →  or ( 'X' or )*
or          →  and ( '|' and )*
and         →  shift ( '&' shift )*
shift       →  expr ( '<'|'>' expr )*
expr        →  term ( '+'|'-' term )*
term        →  unary ( '*'|'/'|'%' unary )*
unary       →  '-' unary  |  '~' unary  |  power
power       →  primary ( '^' unary )?
primary     →  NUMBER  |  identifier ( '(' expr ')' )?  |  '(' expr ')'
```

All numbers are stored internally as Dart `num` (which is `double` for decimals, but integer when parsed from integer strings). Bitwise operations cast via `.toInt()`.

## Theme system

- `AppTheme` (programmer mode): dark background, glassmorphism cards, teal/orange accents
- `BasicTheme` (basic mode): light/dark switchable, monochrome palette, SF-pro-like typography

Both share the `monospace` font family for consistency in displays.
