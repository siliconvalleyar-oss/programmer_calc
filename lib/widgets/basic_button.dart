import 'package:flutter/material.dart';
import '../basic_theme.dart';

class BasicButton extends StatelessWidget {
  final String label;
  final BasicButtonKind kind;
  final VoidCallback onTap;
  final bool isDark;

  const BasicButton({
    super.key,
    required this.label,
    required this.kind,
    required this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (kind) {
      case BasicButtonKind.number:
        bgColor = isDark ? const Color(0xFF333333) : const Color(0xFFFFFFFF);
        textColor = isDark ? Colors.white : Colors.black;
      case BasicButtonKind.operator_:
        bgColor = BasicTheme.accentOrange;
        textColor = Colors.white;
      case BasicButtonKind.action:
        bgColor = isDark ? const Color(0xFFA5A5A5) : const Color(0xFFD1D1D6);
        textColor = isDark ? Colors.white : Colors.black;
      case BasicButtonKind.zero:
        bgColor = isDark ? const Color(0xFF333333) : const Color(0xFFFFFFFF);
        textColor = isDark ? Colors.white : Colors.black;
    }

    final size = (MediaQuery.of(context).size.width - 48) / 4;

    if (kind == BasicButtonKind.zero) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          width: size * 2 + 8,
          height: size,
          child: _buildButton(bgColor, textColor, alignment: Alignment.centerLeft),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        width: size,
        height: size,
        child: _buildButton(bgColor, textColor),
      ),
    );
  }

  Widget _buildButton(Color bg, Color fg, {Alignment alignment = Alignment.center}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        splashColor: fg.withValues(alpha: 0.2),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          alignment: alignment,
          padding: kind == BasicButtonKind.zero
              ? const EdgeInsets.only(left: 24)
              : EdgeInsets.zero,
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: kind == BasicButtonKind.action ? 22 : 28,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
