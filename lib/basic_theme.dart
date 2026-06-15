import 'package:flutter/material.dart';

class BasicTheme {
  static const Color bgLight = Color(0xFFF2F2F6);
  static const Color bgLightCard = Color(0xFFFFFFFF);
  static const Color bgDark = Color(0xFF1C1C1E);
  static const Color bgDarkCard = Color(0xFF2C2C2E);

  static const Color accentOrange = Color(0xFFFF9500);
  static const Color accentGray = Color(0xFFA5A5A5);
  static const Color accentDarkGray = Color(0xFF333333);
  static const Color accentLightGray = Color(0xFFD1D1D6);

  static const Color textLight = Color(0xFF1C1C1E);
  static const Color textDark = Color(0xFFFFFFFF);

  static ThemeData lightTheme(bool isIOS) => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: bgLight,
    fontFamily: isIOS ? null : 'monospace',
    colorScheme: const ColorScheme.light(
      primary: accentOrange,
      surface: bgLightCard,
    ),
  );

  static ThemeData darkTheme(bool isIOS) => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDark,
    fontFamily: isIOS ? null : 'monospace',
    colorScheme: const ColorScheme.dark(
      primary: accentOrange,
      surface: bgDarkCard,
    ),
  );
}

enum BasicButtonKind { number, operator_, action, zero }
