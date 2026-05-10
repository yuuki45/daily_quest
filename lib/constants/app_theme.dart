import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color backgroundColor = Color(0xFFF6F7FB);
  static const Color primaryColor = Color(0xFF5B8CFF);
  static const Color secondaryColor = Color(0xFFFF9B9B);
  static const Color accentColor = Color(0xFFFF9B9B);
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF9094A6);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color shadowColor = Color(0x1A000000);

  // Plant stage colors
  static const Color seedColor = Color(0xFF8B7355);
  static const Color sproutColor = Color(0xFF7CB342);
  static const Color budColor = Color(0xFF66BB6A);
  static const Color flowerColor = Color(0xFFEC407A);
  static const Color bouquetColor = Color(0xFFAB47BC);

  // Border radius
  static const double borderRadius = 24.0;
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;

  // Spacing
  static const double spacing = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingSmall = 8.0;

  // Theme data
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.notoSansJpTextTheme().copyWith(
        displayLarge: GoogleFonts.notoSansJp(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.notoSansJp(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.notoSansJp(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.notoSansJp(
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.notoSansJp(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      cardTheme: const CardThemeData(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
      ),
    );
  }
}
