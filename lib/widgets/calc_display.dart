import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../engine/calculator_engine.dart';

class CalcDisplay extends StatelessWidget {
  final String expression;
  final num? result;
  final String? error;
  final bool showOctal;
  final CalculatorEngine engine;

  const CalcDisplay({
    super.key,
    required this.expression,
    this.result,
    this.error,
    this.showOctal = false,
    required this.engine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.textDim.withValues(alpha: 0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildExpressionBar(),
            if (result != null) _buildResultDisplays(),
            if (error != null) _buildErrorBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpressionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
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
    final binValue = engine.formatBin(v);
    final binLabels = engine.formatBinLabels(v);
    final rows = <Widget>[
      _resultRow('DEC', AppTheme.decColor, engine.formatDec(v)),
      _resultRow('HEX', AppTheme.hexColor, '0x${engine.formatHex(v)}'),
      _binRow(binValue, binLabels),
    ];
    if (showOctal) {
      rows.add(_resultRow('OCT', AppTheme.octColor, '0o${engine.formatOct(v)}'));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DefaultTextStyle(
        style: const TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows),
      ),
    );
  }

  Widget _binRow(String binValue, String binLabels) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '0b$binValue',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.right,
                ),
                Text(
                  ' $binLabels',
                  style: const TextStyle(color: AppTheme.textDim, fontSize: 11),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultRow(String label, Color color, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Container(
            width: 40,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
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
