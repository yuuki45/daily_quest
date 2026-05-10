import 'package:flutter/material.dart';

/// P3風のスタイリッシュなダークパレット。
/// 深ネイビー + 電撃シアン + アクセントイエロー + 白基調。
class AppColors {
  AppColors._();

  // ---- Surface (dark navy palette) ----------------------------------------
  static const Color background = Color(0xFF0E1733);     // 最暗 (画面背景)
  static const Color surface = Color(0xFF1A2649);         // カード背景
  static const Color surfaceVariant = Color(0xFF263566);  // 選択/elevated
  static const Color surfaceMuted = Color(0xFF131C3D);    // 押し下げ感の影

  // ---- Accents -------------------------------------------------------------
  static const Color accent = Color(0xFF5BD7FF);          // 電撃シアン (primary CTA)
  static const Color accentYellow = Color(0xFFFFE03A);    // ベルベット風イエロー
  static const Color accentRed = Color(0xFFFF5C6E);       // HP / 危険
  static const Color accentPurple = Color(0xFFB47EFF);    // ボス
  static const Color accentGreen = Color(0xFF4DE7A6);     // 達成

  // ---- Text ---------------------------------------------------------------
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB5C5E5);
  static const Color textMuted = Color(0xFF6B7894);
  static const Color textOnAccent = Color(0xFF0E1733);    // accent上の文字

  // ---- Functional aliases (旧コード互換) -----------------------------------
  // 既存コードが cream/gold/brown/navy/border 等を参照しているため互換維持。
  // 新規コードは上の名前付き色を直接使うこと。
  static const Color cream = textPrimary;
  static const Color gold = accentYellow;
  static const Color brown = textOnAccent;
  static const Color navy = background;
  static const Color blue = accent;
  static const Color purple = accentPurple;
  static const Color crimson = accentRed;
  static const Color border = textMuted;
  static const Color disabled = textMuted;
  static const Color windowBg = surface;
  static const Color shadowColor = Color(0x80000000);

  // Semantic
  static const Color expBar = accent;
  static const Color hpBar = accentRed;
  static const Color streakHighlight = accentYellow;
  static const Color textOnDark = textPrimary;
}
