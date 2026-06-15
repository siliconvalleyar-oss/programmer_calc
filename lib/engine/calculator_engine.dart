import 'dart:math' as math;
import 'token.dart';

class CalculatorEngine {
  final Map<String, num> variables = {
    'PI': math.pi,
    'E': math.e,
  };

  final List<Map<String, dynamic>> history = [];

  String _input = '';
  int _pos = 0;
  Token _currentToken = const Token(TokenType.eof, '');
  String _lastError = '';

  String get lastError => _lastError;

  void clearError() => _lastError = '';

  void setVariable(String name, num value) {
    variables[name.toUpperCase()] = value;
  }

  num? getVariable(String name) => variables[name.toUpperCase()];

  num? evaluate(String expression) {
    _input = expression;
    _pos = 0;
    _lastError = '';

    try {
      _advance();
      final result = _parseAssignment();
      if (_currentToken.type != TokenType.eof) {
        _error('Unexpected token: ${_currentToken.lexeme}');
        return null;
      }
      history.insert(0, {
        'expression': expression,
        'result': result,
        'timestamp': DateTime.now(),
      });
      if (history.length > 100) history.removeLast();
      return result;
    } catch (e) {
      _lastError = e.toString().replaceFirst('FormatException: ', '');
      return null;
    }
  }

  void _error(String msg) {
    throw FormatException(msg);
  }

  void _advance() {
    while (_pos < _input.length && _input[_pos] == ' ') {
      _pos++;
    }
    if (_pos >= _input.length) {
      _currentToken = const Token(TokenType.eof, '');
      return;
    }

    final c = _input[_pos];

    if (c == '0' && _pos + 1 < _input.length) {
      final n = _input[_pos + 1];
      if (n == 'x' || n == 'X' || n == 'b' || n == 'y' || n == 'o' || n == 'c') {
        _readNumber();
        return;
      }
    }

    if (_isDigit(c) || (c == '.')) {
      _readNumber();
      return;
    }

    if (_isAlpha(c)) {
      _readIdentifier();
      return;
    }

    _pos++;
    switch (c) {
      case '+': _currentToken = const Token(TokenType.plus, '+'); break;
      case '-': _currentToken = const Token(TokenType.minus, '-'); break;
      case '*': _currentToken = const Token(TokenType.star, '*'); break;
      case '/': _currentToken = const Token(TokenType.slash, '/'); break;
      case '%': _currentToken = const Token(TokenType.percent, '%'); break;
      case '^': _currentToken = const Token(TokenType.caret, '^'); break;
      case '~': _currentToken = const Token(TokenType.tilde, '~'); break;
      case '|': _currentToken = const Token(TokenType.pipe, '|'); break;
      case '&': _currentToken = const Token(TokenType.ampersand, '&'); break;
      case '<':
        if (_pos < _input.length && _input[_pos] == '<') {
          _pos++;
          _currentToken = const Token(TokenType.leftShift, '<<');
        } else {
          _currentToken = const Token(TokenType.leftShift, '<');
        }
        break;
      case '>':
        if (_pos < _input.length && _input[_pos] == '>') {
          _pos++;
          _currentToken = const Token(TokenType.rightShift, '>>');
        } else {
          _currentToken = const Token(TokenType.rightShift, '>');
        }
        break;
      case '(': _currentToken = const Token(TokenType.lparen, '('); break;
      case ')': _currentToken = const Token(TokenType.rparen, ')'); break;
      case '=': _currentToken = const Token(TokenType.equals, '='); break;
      case ',': _currentToken = const Token(TokenType.comma, ','); break;
      default: _error('Unknown character: $c');
    }
  }

  void _readNumber() {
    final start = _pos;
    bool isHex = false, isBin = false, isOct = false;

    if (_input[_pos] == '0' && _pos + 1 < _input.length) {
      final n = _input[_pos + 1];
      if (n == 'x' || n == 'X') { isHex = true; _pos += 2; }
      else if (n == 'b' || n == 'y') { isBin = true; _pos += 2; }
      else if (n == 'o' || n == 'c') { isOct = true; _pos += 2; }
    }

    bool hasDot = false;
    while (_pos < _input.length) {
      final c = _input[_pos];
      if (c == '_' || c == ',') { _pos++; continue; }
      if (c == '.' && !isHex && !isBin && !isOct && !hasDot) { hasDot = true; _pos++; continue; }
      if (isHex && _isHexDigit(c)) { _pos++; continue; }
      if (isBin && (c == '0' || c == '1')) { _pos++; continue; }
      if (isOct && c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 55) { _pos++; continue; }
      if (!isHex && !isBin && !isOct && _isDigit(c)) { _pos++; continue; }
      break;
    }

    final lexeme = _input.substring(start, _pos);
    _currentToken = Token(TokenType.number, lexeme, parseNumber(lexeme));
  }

  void _readIdentifier() {
    final start = _pos;
    while (_pos < _input.length && (_isAlphaNum(_input[_pos]) || _input[_pos] == '_')) {
      _pos++;
    }
    final name = _input.substring(start, _pos);
    if (name == 'X') {
      _currentToken = const Token(TokenType.xor, 'X');
    } else {
      _currentToken = Token(TokenType.identifier, name);
    }
  }

  bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
  bool _isHexDigit(String c) {
    final code = c.codeUnitAt(0);
    return _isDigit(c) || ((code | 32) >= 97 && (code | 32) <= 102);
  }
  bool _isAlpha(String c) {
    final code = c.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122) || code == 95;
  }
  bool _isAlphaNum(String c) => _isAlpha(c) || _isDigit(c);

  void _expect(TokenType type) {
    if (_currentToken.type == type) {
      _advance();
    } else {
      _error('Expected $type, got ${_currentToken.type}');
    }
  }

  num _parseAssignment() {
    if (_currentToken.type == TokenType.identifier) {
      final name = _currentToken.lexeme;
      final savePos = _pos;
      final saveToken = _currentToken;
      _advance();
      if (_currentToken.type == TokenType.equals) {
        _advance();
        final value = _parseAssignment();
        variables[name.toUpperCase()] = value;
        return value;
      }
      _pos = savePos;
      _currentToken = saveToken;
    }
    return _parseXor();
  }

  num _parseXor() {
    var left = _parseOr();
    while (_currentToken.type == TokenType.xor) {
      _advance();
      final right = _parseOr();
      left = (left.toInt() ^ right.toInt()).toDouble();
    }
    return left;
  }

  num _parseOr() {
    var left = _parseAnd();
    while (_currentToken.type == TokenType.pipe) {
      _advance();
      final right = _parseAnd();
      left = (left.toInt() | right.toInt()).toDouble();
    }
    return left;
  }

  num _parseAnd() {
    var left = _parseShift();
    while (_currentToken.type == TokenType.ampersand) {
      _advance();
      final right = _parseShift();
      left = (left.toInt() & right.toInt()).toDouble();
    }
    return left;
  }

  num _parseShift() {
    var left = _parseExpression();
    while (_currentToken.type == TokenType.leftShift || _currentToken.type == TokenType.rightShift) {
      final op = _currentToken.type;
      _advance();
      final right = _parseExpression();
      final shift = right.toInt();
      if (op == TokenType.leftShift) {
        left = (left.toInt() << shift).toDouble();
      } else {
        left = (left.toInt() >> shift).toDouble();
      }
    }
    return left;
  }

  num _parseExpression() {
    var left = _parseTerm();
    while (_currentToken.type == TokenType.plus || _currentToken.type == TokenType.minus) {
      final op = _currentToken.type;
      _advance();
      final right = _parseTerm();
      if (op == TokenType.plus) {
        left = left + right;
      } else {
        left = left - right;
      }
    }
    return left;
  }

  num _parseTerm() {
    var left = _parseUnary();
    while (_currentToken.type == TokenType.star || _currentToken.type == TokenType.slash || _currentToken.type == TokenType.percent) {
      final op = _currentToken.type;
      _advance();
      final right = _parseUnary();
      if (op == TokenType.star) {
        left = left * right;
      } else if (op == TokenType.slash) {
        if (right == 0) {
          _error('Division by zero');
        }
        left = left / right;
      } else {
        left = (left.toInt() % right.toInt()).toDouble();
      }
    }
    return left;
  }

  num _parseUnary() {
    if (_currentToken.type == TokenType.minus) {
      _advance();
      return -_parsePower();
    }
    if (_currentToken.type == TokenType.tilde) {
      _advance();
      return (~_parsePower().toInt()).toDouble();
    }
    return _parsePower();
  }

  num _parsePower() {
    var left = _parsePrimary();
    if (_currentToken.type == TokenType.caret) {
      _advance();
      final right = _parseUnary();
      left = math.pow(left, right);
    }
    return left;
  }

  num _parsePrimary() {
    if (_currentToken.type == TokenType.number) {
      final val = _currentToken.value!;
      _advance();
      return val;
    }

    if (_currentToken.type == TokenType.identifier) {
      final name = _currentToken.lexeme.toUpperCase();
      _advance();

      if (_currentToken.type == TokenType.lparen) {
        _advance();
        final arg = _parseAssignment();
        _expect(TokenType.rparen);
        return _callFunction(name, arg);
      }

      if (variables.containsKey(name)) {
        return variables[name]!;
      }

      _error('Undefined variable: $name');
      return 0;
    }

    if (_currentToken.type == TokenType.lparen) {
      _advance();
      final expr = _parseAssignment();
      _expect(TokenType.rparen);
      return expr;
    }

    _error('Unexpected token: ${_currentToken.lexeme}');
    return 0;
  }

  num _callFunction(String name, num arg) {
    switch (name) {
      case 'SIN': return math.sin(arg);
      case 'COS': return math.cos(arg);
      case 'ATAN': return math.atan(arg);
      case 'LOG': return math.log(arg);
      case 'LOG10': return math.log(arg) / math.ln10;
      case 'EXP': return math.exp(arg);
      case 'SQRT': return math.sqrt(arg);
      case 'INT': return arg.toInt().toDouble();
      case 'ABS': return arg.abs();
      case 'F2C': return (5 * (arg - 32)) / 9;
      case 'C2F': return (arg * 9) / 5 + 32;
      case 'IN2MM': return arg * 25.4;
      case 'MM2IN': return arg / 25.4;
      case 'PO2KG': return (arg * 453.592) / 1000;
      case 'KG2PO': return (arg * 1000) / 453.592;
      default:
        _error('Unknown function: $name');
        return 0;
    }
  }

  String formatDec(num value) => value.toString();

  String formatHex(num value) {
    final intVal = value.toInt() & 0xFFFFFFFF;
    return intVal.toRadixString(16).toUpperCase();
  }

  String formatOct(num value) {
    final intVal = value.toInt() & 0xFFFFFFFF;
    return intVal.toRadixString(8);
  }

  String formatBin(num value) {
    final intVal = value.toInt() & 0xFFFFFFFF;
    var s = intVal.toRadixString(2);
    final pad = (8 - s.length % 8) % 8;
    s = s.padLeft(s.length + pad, '0');
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && i % 8 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  String formatBinLabels(num value) {
    final binStr = formatBin(value);
    final groups = binStr.split(' ');
    final buf = StringBuffer();
    int currentPos = 0;
    for (int g = 0; g < groups.length; g++) {
      final group = groups[g];
      final label = (g * 8).toString();
      final labelEnd = currentPos + group.length - 1;
      final labelStart = labelEnd - label.length + 1;
      final spaces = labelStart - buf.length;
      if (spaces > 0) buf.write(''.padLeft(spaces));
      buf.write(label);
      currentPos += group.length + 1;
    }
    return buf.toString();
  }

  bool showOctal = false;
}
