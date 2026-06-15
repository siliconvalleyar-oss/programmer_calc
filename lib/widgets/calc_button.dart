import 'package:flutter/material.dart';
import '../app_theme.dart';

class CalcButton extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? bgColor;
  final VoidCallback onTap;
  final double? fontSize;

  const CalcButton({
    super.key,
    required this.label,
    this.color,
    this.bgColor,
    required this.onTap,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final bg = bgColor ?? AppTheme.bgGlass;
    final fg = color ?? AppTheme.textPrimary;

    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            splashColor: fg.withValues(alpha: 0.15),
            highlightColor: fg.withValues(alpha: 0.08),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 44,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: fg.withValues(alpha: 0.12)),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontSize: fontSize ?? 15,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
