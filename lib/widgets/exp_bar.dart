import 'package:flutter/material.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';

class ExpBar extends StatelessWidget {
  final int currentExp;
  final int maxExp;
  final double height;
  final bool showLabel;

  const ExpBar({
    required this.currentExp,
    required this.maxExp,
    super.key,
    this.height = 14,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxExp > 0 ? (currentExp / maxExp).clamp(0.0, 1.0) : 0.0;
    final radius = BorderRadius.circular(height / 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('EXP', style: AppTextStyles.statLabel),
              Text('$currentExp / $maxExp', style: AppTextStyles.caption),
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
                child: Container(color: AppColors.expBar),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
