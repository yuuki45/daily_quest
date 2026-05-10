import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  static const double borderWidth = 2.0;

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  static const double minTapSize = 48.0;

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.blue,
        secondary: AppColors.gold,
        surface: AppColors.cream,
        onSurface: AppColors.textPrimary,
        error: AppColors.crimson,
      ),
      textTheme: GoogleFonts.notoSansJpTextTheme(base.textTheme).copyWith(
        displayLarge: AppTextStyles.displayLarge,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        titleMedium: AppTextStyles.titleMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        labelLarge: AppTextStyles.button,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cream,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: const BorderSide(color: AppColors.border, width: borderWidth),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.cream,
          textStyle: AppTextStyles.button,
          minimumSize: const Size(double.infinity, minTapSize),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            side: const BorderSide(color: AppColors.brown, width: borderWidth),
          ),
          elevation: 0,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.gold
              : AppColors.cream,
        ),
        checkColor: WidgetStateProperty.all(AppColors.brown),
        side: const BorderSide(color: AppColors.brown, width: borderWidth),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall / 2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.navy,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.cream,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
