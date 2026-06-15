import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../engine/calculator_engine.dart';

class CalcDisplay extends StatelessWidget {
  final String expression;
  final num? result;
  final String? error;
  final bool showOctal;
  final bool showFloat;
  final Set<String> visibleTypes;
  final CalculatorEngine engine;

  const CalcDisplay({
    super.key,
    required this.expression,
    this.result,
    this.error,
    this.showOctal = false,
    this.showFloat = false,
    this.visibleTypes = const {'DEC', 'HEX', 'BIN'},
    required this.engine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(
          bottom: BorderSide(color: AppTheme.textDim.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildExpressionBar(),
          if (result != null) _buildResultDisplays(),
          if (error != null) _buildErrorBar(),
        ],
      ),
    );
  }

  Widget _buildExpressionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      color: AppTheme.bgDark,
      child: Text(
        expression.isEmpty ? '0' : expression,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 18,
          fontFamily: 'monospace',
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildResultDisplays() {
    final v = result!;
    final rows = <Widget>[];
    if (visibleTypes.contains('DEC')) {
      rows.add(_resultRow('DEC', AppTheme.decColor, engine.formatDec(v)));
    }
    if (visibleTypes.contains('HEX')) {
      rows.add(_resultRow('HEX', AppTheme.hexColor, '0x${engine.formatHex(v)}'));
    }
    if (visibleTypes.contains('BIN')) {
      final binValue = engine.formatBin(v);
      rows.add(_binRow(binValue));
    }
    if (showOctal) {
      rows.add(_resultRow('OCT', AppTheme.octColor, '0o${engine.formatOct(v)}'));
    }
    if (showFloat && visibleTypes.contains('FLOAT')) {
      rows.add(_resultRow('FLOAT', AppTheme.accentTeal, engine.formatFloat(v)));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DefaultTextStyle(
        style: const TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows.map((r) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: r,
          )).toList(),
        ),
      ),
    );
  }

  Widget _binRow(String binValue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.binColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text('BIN', style: TextStyle(color: AppTheme.binColor, fontSize: 11, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            '0b$binValue',
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _resultRow(String label, Color color, String value) {
    return Row(
      children: [
        Container(
          width: 46,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: Text(
        error!,
        style: const TextStyle(color: AppTheme.accentOrange, fontSize: 13, fontFamily: 'monospace'),
        textAlign: TextAlign.right,
      ),
    );
  }
}
