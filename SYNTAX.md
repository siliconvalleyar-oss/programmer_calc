# PCALC Expression Syntax

## Number formats

| Prefix   | Base   | Examples                    |
|----------|--------|-----------------------------|
| `0x`/`0X` | HEX   | `0xFF`, `0xABCD`, `0x1A_2F` |
| `0b`/`0y` | BIN   | `0b1010`, `0y1100_0011`     |
| `0o`/`0c` | OCT   | `0o777`, `0c755`            |
| `0`      | OCT*   | `0777` (legacy octal)       |
| (none)   | DEC    | `123`, `3.14`, `1,234`      |

Underscores (`_`) and commas (`,`) are allowed as digit separators.

## Operators (precedence, low → high)

| Operators             | Assoc | Description         |
|-----------------------|-------|---------------------|
| `=`                   | right | Variable assignment |
| <code>&#124;</code>   | left  | Bitwise OR          |
| `&`                   | left  | Bitwise AND         |
| `X`                   | left  | Bitwise XOR         |
| `<<`  `>>`            | left  | Left / Right shift  |
| `+`  `-`              | left  | Addition/Subtraction|
| `*`  `/`  `%`         | left  | Multiply/Divide/Mod |
| `-`  `~`              | right | Unary minus / NOT   |
| `^`                   | right | Exponentiation      |

## Built-in functions

| Function    | Description                          |
|-------------|--------------------------------------|
| `sin(x)`    | Sine (radians)                       |
| `cos(x)`    | Cosine (radians)                     |
| `atan(x)`   | Arctangent (radians)                 |
| `log(x)`    | Natural logarithm                    |
| `log10(x)`  | Base-10 logarithm                    |
| `exp(x)`    | Exponential (e^x)                    |
| `sqrt(x)`   | Square root                          |
| `int(x)`    | Truncate to integer                  |
| `abs(x)`    | Absolute value                       |
| `f2c(x)`    | Fahrenheit → Celsius                 |
| `c2f(x)`    | Celsius → Fahrenheit                 |
| `in2mm(x)`  | Inches → Millimeters                 |
| `mm2in(x)`  | Millimeters → Inches                 |
| `po2kg(x)`  | Pounds → Kilograms                   |
| `kg2po(x)`  | Kilograms → Pounds                   |

Functions can be called with parentheses (`sin(3.14)`) or without (`sin 3.14`).

## Constants & variables

| Name | Value        | Description     |
|------|--------------|-----------------|
| `PI` | 3.14159…     | π               |
| `E`  | 2.71828…     | Euler's number  |

User variables are created via assignment: `X = 42 + 1`

## Examples

```
0xFF + 1            → 256  (DEC)  0x100  (HEX)  0b100000000  (BIN)
0x300 + 0x20        → 800  (DEC)  0x320  (HEX)
0b1010 | 0b1100     → 14   (DEC)  0xE    (HEX)  0b1110  (BIN)
0xFF << 2           → 1020 (DEC)  0x3FC  (HEX)
sqrt(2)             → 1.4142
sin(PI/2)           → 1.0
A = 0x20  A + 1     → 33
```
