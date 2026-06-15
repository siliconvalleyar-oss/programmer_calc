import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'engine/calculator_engine.dart';
import 'widgets/calc_display.dart';
import 'widgets/calc_button.dart';
import 'screens/history_screen.dart';
import 'screens/variables_screen.dart';

enum InputBase { hex, dec, oct, bin }

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleMode;

  const HomeScreen({super.key, required this.onToggleMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CalculatorEngine _engine = CalculatorEngine();
  String _expression = '';
  num? _result;
  String? _error;
  InputBase _inputBase = InputBase.hex;
  bool _fresh = true;

  @override
  void initState() {
    super.initState();
    _resetToBase();
  }

  String _basePrefix() {
    switch (_inputBase) {
      case InputBase.hex: return '0x';
      case InputBase.oct: return '0o';
      case InputBase.bin: return '0b';
      case InputBase.dec: return '';
    }
  }

  String _baseInitExpr() {
    switch (_inputBase) {
      case InputBase.hex: return '0x0';
      case InputBase.oct: return '0o0';
      case InputBase.bin: return '0b0';
      case InputBase.dec: return '0';
    }
  }

  String _baseValidDigits() {
    switch (_inputBase) {
      case InputBase.hex: return '0123456789ABCDEFabcdef';
      case InputBase.oct: return '01234567';
      case InputBase.bin: return '01';
      case InputBase.dec: return '0123456789.';
    }
  }

  bool _isBaseNum(String expr) {
    return RegExp(r'^(0[xXbBoOcC])?[0-9a-fA-F]+(\.[0-9]+)?$').hasMatch(expr);
  }

  void _resetToBase() {
    setState(() {
      _expression = _baseInitExpr();
      _fresh = true;
      _error = null;
    });
    _autoEval();
  }

  void _pressDigit(String d) {
    setState(() {
      _error = null;
      if (_fresh) {
        _expression = _baseInitExpr();
        _fresh = false;
      }
      final prefix = _basePrefix();
      if (_expression.length == prefix.length + 1 &&
          _expression.startsWith(prefix) &&
          _expression.endsWith('0')) {
        _expression = _expression.substring(0, _expression.length - 1) + d;
      } else {
        _expression += d;
      }
    });
    _autoEval();
  }

  void _pressOperator(String op) {
    setState(() {
      _error = null;
      _fresh = false;
      _expression += op;
    });
  }

  void _insertFunction(String name) {
    setState(() {
      _error = null;
      _fresh = false;
      _expression += '$name(';
    });
  }

  void _clear() {
    _resetToBase();
  }

  void _backspace() {
    setState(() {
      _error = null;
      if (_fresh || _expression.isEmpty) return;
      final prefix = _basePrefix();
      if (_expression.length <= prefix.length + 1) return;
      _expression = _expression.substring(0, _expression.length - 1);
    });
    _autoEval();
  }

  void _evaluate() {
    if (_expression.isEmpty) {
      _resetToBase();
      return;
    }
    setState(() {
      _engine.clearError();
      final r = _engine.evaluate(_expression);
      if (r != null) {
        _result = r;
        _error = null;
        _fresh = true;
      } else {
        _error = _engine.lastError.isNotEmpty ? _engine.lastError : 'Error';
      }
    });
  }

  void _autoEval() {
    if (_expression.isEmpty) return;
    if (!_isBaseNum(_expression)) return;
    setState(() {
      _engine.clearError();
      final r = _engine.evaluate(_expression);
      if (r != null) {
        _result = r;
        _error = null;
      } else {
        _error = _engine.lastError.isNotEmpty ? _engine.lastError : 'Error';
      }
    });
  }

  void _setBase(InputBase base) {
    if (base == _inputBase) return;
    setState(() => _inputBase = base);
    _resetToBase();
  }

  void _toggleOctal() {
    setState(() => _engine.showOctal = !_engine.showOctal);
  }

  Color _baseColor(InputBase base) {
    switch (base) {
      case InputBase.hex: return AppTheme.hexColor;
      case InputBase.dec: return AppTheme.decColor;
      case InputBase.oct: return AppTheme.octColor;
      case InputBase.bin: return AppTheme.binColor;
    }
  }

  String _baseLabel(InputBase base) {
    switch (base) {
      case InputBase.hex: return 'HEX';
      case InputBase.dec: return 'DEC';
      case InputBase.oct: return 'OCT';
      case InputBase.bin: return 'BIN';
    }
  }

  bool _isValidForBase(String s) {
    for (var i = 0; i < s.length; i++) {
      if (!_baseValidDigits().contains(s[i])) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _baseColor(_inputBase);
    final isHex = _inputBase == InputBase.hex;
    final isBin = _inputBase == InputBase.bin;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'History',
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => HistoryScreen(engine: _engine),
            )),
          ),
          IconButton(
            icon: const Icon(Icons.abc),
            tooltip: 'Variables',
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => VariablesScreen(engine: _engine),
            )),
          ),
          IconButton(
            icon: const Icon(Icons.calculate_outlined),
            tooltip: 'Basic mode',
            onPressed: widget.onToggleMode,
          ),
        ],
      ),
      body: Column(
        children: [
          CalcDisplay(
            expression: _expression,
            result: _result,
            error: _error,
            showOctal: _engine.showOctal,
            engine: _engine,
          ),
          _buildBaseSelector(baseColor),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Column(
                children: [
                  _buildRow(['⌫', '(', ')', '<<', '>>', '&']),
                  const SizedBox(height: 2),
                  _buildFunctionRow(),
                  const SizedBox(height: 2),
                  _buildHexRow(isHex),
                  const SizedBox(height: 2),
                  _buildRow(['7', '8', '9', '<<', '>>', '&']),
                  const SizedBox(height: 2),
                  _buildRow(['4', '5', '6', '|', 'X', '^']),
                  const SizedBox(height: 2),
                  _buildRow(['1', '2', '3', '+', '-', '~']),
                  const SizedBox(height: 2),
                  _customBottomRow(isBin),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaseSelector(Color baseColor) {
    final bases = [InputBase.hex, InputBase.dec, InputBase.oct, InputBase.bin];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          ...bases.map((b) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: GestureDetector(
                onTap: () => _setBase(b),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _inputBase == b
                        ? _baseColor(b).withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _inputBase == b
                          ? _baseColor(b).withValues(alpha: 0.6)
                          : AppTheme.textDim.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _baseLabel(b),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _inputBase == b ? _baseColor(b) : AppTheme.textDim,
                      fontSize: 13,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          )),
          const SizedBox(width: 4),
          _miniToggle('Oct', _engine.showOctal, _toggleOctal),
        ],
      ),
    );
  }

  Widget _miniToggle(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppTheme.accentTeal.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AppTheme.accentTeal.withValues(alpha: 0.6) : AppTheme.textDim.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppTheme.accentTeal : AppTheme.textDim,
            fontSize: 11,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionRow() {
    return _buttonRow6([
      _btn('sin', () => _insertFunction('sin')),
      _btn('cos', () => _insertFunction('cos')),
      _btn('sqrt', () => _insertFunction('sqrt')),
      _btn('log', () => _insertFunction('log')),
      _btn('int', () => _insertFunction('int')),
      _btn('abs', () => _insertFunction('abs')),
    ]);
  }

  Widget _buildHexRow(bool isHex) {
    final alpha = isHex ? 1.0 : 0.3;
    return _buttonRow6([
      _btn('A', () => _pressDigit('A'), disabled: !isHex, opacity: alpha),
      _btn('B', () => _pressDigit('B'), disabled: !isHex, opacity: alpha),
      _btn('C', () => _pressDigit('C'), disabled: !isHex, opacity: alpha),
      _btn('D', () => _pressDigit('D'), disabled: !isHex, opacity: alpha),
      _btn('E', () => _pressDigit('E'), disabled: !isHex, opacity: alpha),
      _btn('F', () => _pressDigit('F'), disabled: !isHex, opacity: alpha),
    ]);
  }

  Widget _buildRow(List<String> labels) {
    return _buttonRow6(labels.map((l) {
      VoidCallback? onTap;
      if (l == '(') { onTap = () => _pressOperator('('); }
      else if (l == ')') { onTap = () => _pressOperator(')'); }
      else if (l == 'C') { onTap = _clear; }
      else if (l == '⌫') { onTap = _backspace; }
      else if (_isValidForBase(l)) { onTap = () => _pressDigit(l); }
      else { onTap = () => _pressOperator(l); }
      return _btn(l, onTap);
    }).toList());
  }

  Widget _buttonRow6(List<Widget> buttons) {
    return Row(children: buttons.map((b) => Expanded(child: b)).toList());
  }

  Widget _customBottomRow(bool isBin) {
    return Row(children: [
      Expanded(flex: 2, child: CalcButton(
        label: 'C',
        onTap: _clear,
        color: AppTheme.accentOrange,
        fontSize: 18,
      )),
      Expanded(child: _btn(isBin ? '0/1' : '0', () => _pressDigit('0'))),
      Expanded(child: _btn('.', () => _pressDigit('.'))),
      Expanded(child: _btn('%', () => _pressOperator('%'))),
      Expanded(child: _btn('*', () => _pressOperator('*'))),
      Expanded(child: _btn('/', () => _pressOperator('/'))),
      Expanded(child: _btn('=', _evaluate, color: AppTheme.accentOrange)),
    ]);
  }

  Widget _btn(String label, VoidCallback? onTap, {Color? color, bool disabled = false, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: CalcButton(
        label: label,
        onTap: (disabled || onTap == null) ? () {} : onTap,
        color: color,
      ),
    );
  }
}
