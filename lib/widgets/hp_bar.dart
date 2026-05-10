import 'package:flutter/material.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';

/// 8bit風セグメントHPバー。
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
    this.height = 14,
    this.showLabel = true,
    this.label = 'HP',
    this.onDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = onDark
        ? AppColors.cream.withValues(alpha: 0.85)
        : AppColors.textSecondary;
    final valueColor =
        onDark ? AppColors.cream : AppColors.textPrimary;
    final emptyColor = onDark
        ? Colors.black.withValues(alpha: 0.45)
        : AppColors.cream;
    final borderColor =
        onDark ? AppColors.gold : AppColors.border;

    // HP は段数を maxHp に合わせる（7HPなら7セグメント）と分かりやすい
    final segmentCount = maxHp.clamp(1, 20);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.statLabel.copyWith(color: labelColor)),
              Text(
                '$currentHp / $maxHp',
                style: AppTextStyles.statLabel.copyWith(color: valueColor),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXs),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: emptyColor,
            border: Border.all(color: borderColor, width: 2),
          ),
          padding: const EdgeInsets.all(2),
          child: Row(
            children: List.generate(segmentCount, (i) {
              final filled = i < currentHp;
              return Expanded(
                child: Container(
                  margin:
                      EdgeInsets.only(right: i == segmentCount - 1 ? 0 : 1),
                  color: filled ? AppColors.hpBar : Colors.transparent,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
