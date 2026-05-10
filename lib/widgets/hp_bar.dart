import 'package:flutter/material.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';

class HpBar extends StatelessWidget {
  final int currentHp;
  final int maxHp;
  final double height;
  final bool showLabel;
  final String label;

  const HpBar({
    required this.currentHp,
    required this.maxHp,
    super.key,
    this.height = 14,
    this.showLabel = true,
    this.label = 'HP',
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
              Text('$currentHp / $maxHp', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXs),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: radius,
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: ratio,
                heightFactor: 1.0,
                child: Container(color: AppColors.hpBar),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
