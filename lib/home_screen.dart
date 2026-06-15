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
  InputBase _inputBase = InputBase.dec;

  @override
  void initState() {
    super.initState();
    _result = 0;
  }

  void _append(String s) {
    setState(() {
      _error = null;
      _expression += s;
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = null;
      _error = null;
    });
  }

  void _backspace() {
    setState(() {
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
        _error = null;
      }
    });
  }

  void _evaluate() {
    if (_expression.isEmpty) return;
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
    setState(() => _inputBase = base);
  }

  void _toggleNibble() {
    setState(() => _engine.nibbleMode = !_engine.nibbleMode);
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

  void _insertFunction(String name) {
    _append('$name(');
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _baseColor(_inputBase);
    final isHex = _inputBase == InputBase.hex;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('PCALC'),
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
            nibbleMode: _engine.nibbleMode,
            engine: _engine,
          ),
          _buildBaseSelector(baseColor),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Column(
                children: [
                  _buildRow(['C', '⌫', '(', ')', '<<', '>>']),
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
                  _buttonRow6([
                    _btn(_inputBase == InputBase.bin ? '0/1' : '0', () => _append('0')),
                    _btn('.', () => _append('.')),
                    _btn('%', () => _append('%')),
                    _btn('*', () => _append('*')),
                    _btn('/', () => _append('/')),
                    _btn('=', _evaluate, color: AppTheme.accentOrange),
                  ]),
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
          _miniToggle('Nib', _engine.nibbleMode, _toggleNibble),
          const SizedBox(width: 2),
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
      _btn('A', () => _append('A'), disabled: !isHex, opacity: alpha),
      _btn('B', () => _append('B'), disabled: !isHex, opacity: alpha),
      _btn('C', () => _append('C'), disabled: !isHex, opacity: alpha),
      _btn('D', () => _append('D'), disabled: !isHex, opacity: alpha),
      _btn('E', () => _append('E'), disabled: !isHex, opacity: alpha),
      _btn('F', () => _append('F'), disabled: !isHex, opacity: alpha),
    ]);
  }

  Widget _buildRow(List<String> labels) {
    return _buttonRow6(labels.map((l) {
      VoidCallback? onTap;
      if (l == '(') { onTap = () => _append('('); }
      else if (l == ')') { onTap = () => _append(')'); }
      else if (l == 'C') { onTap = _clear; }
      else if (l == '⌫') { onTap = _backspace; }
      else { onTap = () => _append(l); }
      return _btn(l, onTap);
    }).toList());
  }

  Widget _buttonRow6(List<Widget> buttons) {
    return Row(children: buttons.map((b) => Expanded(child: b)).toList());
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
