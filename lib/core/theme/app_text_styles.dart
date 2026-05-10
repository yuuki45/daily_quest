import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tri_task/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ===== Pixel font (DotGothic16) ===========================================
  // 日本語対応のピクセルフォント。見出し・統計値・ボタン等のJRPG感を出したい箇所に使用。
  // 本文系は可読性のため Noto Sans JP を継続。

  static TextStyle get displayLarge => GoogleFonts.dotGothic16(
        fontSize: 28,
        color: AppColors.textPrimary,
        letterSpacing: 1.0,
      );

  static TextStyle get headlineLarge => GoogleFonts.dotGothic16(
        fontSize: 22,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get headlineMedium => GoogleFonts.dotGothic16(
        fontSize: 18,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get statLabel => GoogleFonts.dotGothic16(
        fontSize: 13,
        color: AppColors.textSecondary,
        letterSpacing: 1.5,
      );

  static TextStyle get statValue => GoogleFonts.dotGothic16(
        fontSize: 22,
        color: AppColors.textPrimary,
      );

  static TextStyle get button => GoogleFonts.dotGothic16(
        fontSize: 18,
        color: AppColors.cream,
        letterSpacing: 1.5,
      );

  // ===== Body font (Noto Sans JP) ===========================================

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

  static TextStyle get questTitle => GoogleFonts.notoSansJp(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );
}
