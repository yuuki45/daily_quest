import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tri_task/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => GoogleFonts.notoSansJp(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get headlineLarge => GoogleFonts.notoSansJp(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.notoSansJp(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.notoSansJp(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.notoSansJp(
        fontSize: 15,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.notoSansJp(
        fontSize: 14,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get caption => GoogleFonts.notoSansJp(
        fontSize: 12,
        color: AppColors.textSecondary,
      );

  static TextStyle get button => GoogleFonts.notoSansJp(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.cream,
        letterSpacing: 0.5,
      );

  static TextStyle get questTitle => GoogleFonts.notoSansJp(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get statLabel => GoogleFonts.notoSansJp(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 1.0,
      );

  static TextStyle get statValue => GoogleFonts.notoSansJp(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );
}
