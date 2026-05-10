import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tri_task/core/theme/app_colors.dart';

/// P3風のモダンタイポグラフィ。
/// - 日本語: M PLUS 1p (Bold/ExtraBold)
/// - ALL CAPS / 数値: Outfit (Bold/Italic)
class AppTextStyles {
  AppTextStyles._();

  // ===== Display / Headlines (M PLUS 1p Bold) ==============================

  static TextStyle get displayLarge => GoogleFonts.mPlus1(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
        height: 1.1,
      );

  static TextStyle get headlineLarge => GoogleFonts.mPlus1(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
        height: 1.2,
      );

  static TextStyle get headlineMedium => GoogleFonts.mPlus1(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get titleMedium => GoogleFonts.mPlus1(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  // ===== Body (M PLUS 1p Regular) ===========================================

  static TextStyle get bodyLarge => GoogleFonts.mPlus1(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.mPlus1(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get caption => GoogleFonts.mPlus1(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.4,
      );

  static TextStyle get questTitle => GoogleFonts.mPlus1(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.35,
      );

  // ===== Stats / Labels (Outfit, ALL CAPS, italic可) ========================

  static TextStyle get statLabel => GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 2.0,
      );

  /// 巨大な数値表示 (Lv. や EXP 値など)。Outfit Italic で勢いを出す。
  static TextStyle get statValue => GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        fontStyle: FontStyle.italic,
        letterSpacing: -1.0,
        height: 1.0,
      );

  static TextStyle get statValueSmall => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        fontStyle: FontStyle.italic,
        letterSpacing: -0.5,
      );

  static TextStyle get button => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnAccent,
        letterSpacing: 1.5,
      );
}
