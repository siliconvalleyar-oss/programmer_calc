enum TokenType {
  number,
  plus,
  minus,
  star,
  slash,
  percent,
  caret,
  tilde,
  pipe,
  ampersand,
  xor,
  leftShift,
  rightShift,
  equals,
  lparen,
  rparen,
  identifier,
  string,
  comma,
  eof,
}

class Token {
  final TokenType type;
  final String lexeme;
  final num? value;

  const Token(this.type, this.lexeme, [this.value]);

  @override
  String toString() => 'Token($type, $lexeme, $value)';
}

num parseNumber(String s) {
  s = s.replaceAll(RegExp(r'[_,]'), '');
  if (s.startsWith('0x') || s.startsWith('0X')) {
    return int.parse(s.substring(2), radix: 16).toDouble();
  } else if (s.startsWith('0b') || s.startsWith('0y')) {
    return int.parse(s.substring(2), radix: 2).toDouble();
  } else if (s.startsWith('0o') || s.startsWith('0c')) {
    return int.parse(s.substring(2), radix: 8).toDouble();
  } else if (s.startsWith('0') && s.length > 1 && !s.contains('.')) {
    try {
      return int.parse(s, radix: 8).toDouble();
    } catch (_) {}
  }
  return num.parse(s);
}
