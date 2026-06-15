# PCALC — Roadmap

## Phase 1 — Core (done)
- [x] Recursive descent parser with full operator precedence
- [x] Number bases: DEC, HEX (`0x`), OCT (`0o`/`0c`), BIN (`0b`/`0y`)
- [x] Bitwise ops: `|`, `&`, `X` (XOR), `~` (NOT), `<<`, `>>`
- [x] Arithmetic: `+`, `-`, `*`, `/`, `%`, `^` (pow)
- [x] Functions: sin, cos, atan, log, log10, exp, sqrt, int, abs
- [x] Conversions: f2c, c2f, in2mm, mm2in, po2kg, kg2po
- [x] Constants: PI, E + user-defined variables (`X = 42`)
- [x] Multi-base display (DEC / HEX / BIN + optional OCT)
- [x] Nibble mode (group binary by 4 bits)
- [x] Calculation history (last 100)
- [x] Variables viewer

## Phase 2 — UX & Modes (done)
- [x] Basic/simple mode (Apple iPhone aesthetic)
- [x] Mode toggle (programmer ↔ basic)
- [x] `ver/` reference code archived in `.gitignore`

## Phase 3 — Polish
- [ ] Memory buttons (M+, M-, MR, MC)
- [ ] Keyboard support (desktop)
- [ ] Expression history (tap past expressions to re-use)
- [ ] Dark/light theme toggle
- [ ] Haptic feedback on button press
- [ ] Landscape layout for tablets

## Phase 4 — Advanced
- [ ] Script mode (run `.pcalc` files, like `pcalc @script`)
- [ ] Store/restore variables to disk
- [ ] Floating-point display modes (fixed, scientific)
- [ ] Copy result to clipboard (tap on result row)
- [ ] Unit tests for parser (100+ edge cases)
- [ ] i18n (English + Spanish)
