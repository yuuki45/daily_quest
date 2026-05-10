import 'package:flutter/material.dart';
import 'package:tri_task/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double radiusSmall = 6.0;
  static const double radiusMedium = 10.0;
  static const double radiusLarge = 16.0;

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  static const double minTapSize = 48.0;

  static ThemeData get dark {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentYellow,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.accentRed,
      ),
    );
  }

  /// 旧コード互換 (内部はダークテーマ)。
  static ThemeData get light => dark;
}
