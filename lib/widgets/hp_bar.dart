import 'package:flutter/material.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';

/// 赤グロー付きHPバー。
class HpBar extends StatelessWidget {
  final int currentHp;
  final int maxHp;
  final double height;
  final bool showLabel;
  final String label;
  final bool onDark;

  const HpBar({
    required this.currentHp,
    required this.maxHp,
    super.key,
    this.height = 8,
    this.showLabel = true,
    this.label = 'HP',
    this.onDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxHp > 0 ? (currentHp / maxHp).clamp(0.0, 1.0) : 0.0;
    final radius = BorderRadius.circular(height / 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.statLabel),
              Text(
                '$currentHp / $maxHp',
                style: AppTextStyles.statLabel.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXs),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: radius,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: ratio == 0 ? 0.001 : ratio,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentRed.withValues(alpha: 0.9),
                        AppColors.accentRed,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentRed.withValues(alpha: 0.55),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
