import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgDark = Color(0xFF0D1117);
  static const Color bgCard = Color(0xFF161B22);
  static const Color bgGlass = Color(0x1AFFFFFF);
  static const Color accentTeal = Color(0xFF2DD4BF);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textDim = Color(0xFF484F58);
  static const Color hexColor = Color(0xFF58A6FF);
  static const Color decColor = Color(0xFFE6EDF3);
  static const Color octColor = Color(0xFFD2A8FF);
  static const Color binColor = Color(0xFF3FB950);

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDark,
    colorScheme: const ColorScheme.dark(
      primary: accentTeal,
      secondary: accentOrange,
      surface: bgCard,
    ),
    fontFamily: 'monospace',
    appBarTheme: const AppBarTheme(
      backgroundColor: bgCard,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
      iconTheme: IconThemeData(color: textSecondary),
    ),
  );
}
