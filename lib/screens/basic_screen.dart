import 'package:flutter/material.dart';
import '../basic_theme.dart';
import '../widgets/basic_button.dart';

class BasicScreen extends StatefulWidget {
  final VoidCallback onToggleMode;

  const BasicScreen({super.key, required this.onToggleMode});

  @override
  State<BasicScreen> createState() => _BasicScreenState();
}

class _BasicScreenState extends State<BasicScreen> {
  bool _isDark = true;
  String _display = '0';
  double? _leftOperand;
  String? _pendingOp;
  bool _newDigit = true;

  void _onDigit(String d) {
    setState(() {
      if (_newDigit) {
        _display = d;
        _newDigit = false;
      } else {
        if (_display.length < 15) {
          _display = _display == '0' ? d : _display + d;
        }
      }
    });
  }

  void _onDecimal() {
    setState(() {
      if (_newDigit) {
        _display = '0.';
        _newDigit = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onOperator(String op) {
    setState(() {
      final current = double.tryParse(_display) ?? 0;
      if (_leftOperand == null) {
        _leftOperand = current;
      } else if (_pendingOp != null) {
        _leftOperand = _compute(_leftOperand!, current, _pendingOp!);
        _display = _formatResult(_leftOperand!);
      }
      _pendingOp = op;
      _newDigit = true;
    });
  }

  void _onEquals() {
    setState(() {
      final current = double.tryParse(_display) ?? 0;
      if (_leftOperand != null && _pendingOp != null) {
        final result = _compute(_leftOperand!, current, _pendingOp!);
        _display = _formatResult(result);
        _leftOperand = null;
        _pendingOp = null;
        _newDigit = true;
      }
    });
  }

  void _onClear() {
    setState(() {
      _display = '0';
      _leftOperand = null;
      _pendingOp = null;
      _newDigit = true;
    });
  }

  void _onPlusMinus() {
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else if (_display != '0') {
        _display = '-$_display';
      }
    });
  }

  void _onPercent() {
    setState(() {
      final v = double.tryParse(_display) ?? 0;
      _display = _formatResult(v / 100);
      _newDigit = true;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  double _compute(double a, double b, String op) {
    switch (op) {
      case '+': return a + b;
      case '-': return a - b;
      case '×': return a * b;
      case '÷': return b != 0 ? a / b : 0;
      default: return b;
    }
  }

  String _formatResult(double v) {
    if (v == v.toInt() && v.abs() < 1e15) {
      return v.toInt().toString();
    }
    final s = v.toStringAsFixed(10);
    return s.replaceAll(RegExp(r'\.?0+$'), '');
  }

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final displaySize = screen.width - 32;

    return Scaffold(
      backgroundColor: _isDark ? BasicTheme.bgDark : BasicTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildDisplay(displaySize),
            const Spacer(),
            _buildKeypad(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              _isDark ? Icons.light_mode : Icons.dark_mode,
              color: _isDark ? Colors.white : Colors.black,
            ),
            onPressed: _toggleTheme,
          ),
          Text(
            'PCALC',
            style: TextStyle(
              color: _isDark ? Colors.white38 : Colors.black38,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.developer_mode,
              color: BasicTheme.accentOrange,
            ),
            onPressed: widget.onToggleMode,
          ),
        ],
      ),
    );
  }

  Widget _buildDisplay(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: Text(
          _display,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: _isDark ? Colors.white : Colors.black,
            fontSize: 64,
            fontWeight: FontWeight.w300,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          _row([
            BasicButton(label: 'AC', kind: BasicButtonKind.action, onTap: _onClear, isDark: _isDark),
            BasicButton(label: '±', kind: BasicButtonKind.action, onTap: _onPlusMinus, isDark: _isDark),
            BasicButton(label: '%', kind: BasicButtonKind.action, onTap: _onPercent, isDark: _isDark),
            BasicButton(label: '÷', kind: BasicButtonKind.operator_, onTap: () => _onOperator('÷'), isDark: _isDark),
          ]),
          _row([
            BasicButton(label: '7', kind: BasicButtonKind.number, onTap: () => _onDigit('7'), isDark: _isDark),
            BasicButton(label: '8', kind: BasicButtonKind.number, onTap: () => _onDigit('8'), isDark: _isDark),
            BasicButton(label: '9', kind: BasicButtonKind.number, onTap: () => _onDigit('9'), isDark: _isDark),
            BasicButton(label: '×', kind: BasicButtonKind.operator_, onTap: () => _onOperator('×'), isDark: _isDark),
          ]),
          _row([
            BasicButton(label: '4', kind: BasicButtonKind.number, onTap: () => _onDigit('4'), isDark: _isDark),
            BasicButton(label: '5', kind: BasicButtonKind.number, onTap: () => _onDigit('5'), isDark: _isDark),
            BasicButton(label: '6', kind: BasicButtonKind.number, onTap: () => _onDigit('6'), isDark: _isDark),
            BasicButton(label: '-', kind: BasicButtonKind.operator_, onTap: () => _onOperator('-'), isDark: _isDark),
          ]),
          _row([
            BasicButton(label: '1', kind: BasicButtonKind.number, onTap: () => _onDigit('1'), isDark: _isDark),
            BasicButton(label: '2', kind: BasicButtonKind.number, onTap: () => _onDigit('2'), isDark: _isDark),
            BasicButton(label: '3', kind: BasicButtonKind.number, onTap: () => _onDigit('3'), isDark: _isDark),
            BasicButton(label: '+', kind: BasicButtonKind.operator_, onTap: () => _onOperator('+'), isDark: _isDark),
          ]),
          _lastRow(),
        ],
      ),
    );
  }

  Widget _row(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _lastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BasicButton(label: '⌫', kind: BasicButtonKind.action, onTap: _onBackspace, isDark: _isDark),
        BasicButton(label: '0', kind: BasicButtonKind.number, onTap: () => _onDigit('0'), isDark: _isDark),
        BasicButton(label: '.', kind: BasicButtonKind.number, onTap: _onDecimal, isDark: _isDark),
        BasicButton(label: '=', kind: BasicButtonKind.operator_, onTap: _onEquals, isDark: _isDark),
      ],
    );
  }
}
