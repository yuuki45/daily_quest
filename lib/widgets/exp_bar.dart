import 'package:flutter/material.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';

/// 8bit風セグメントEXPバー。CommandWindow（ダーク）でも ParchmentCard（ライト）でも見えるよう
/// `onDark` で配色を切り替える。
class ExpBar extends StatelessWidget {
  final int currentExp;
  final int maxExp;
  final double height;
  final bool showLabel;
  final bool onDark;

  const ExpBar({
    required this.currentExp,
    required this.maxExp,
    super.key,
    this.height = 14,
    this.showLabel = true,
    this.onDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxExp > 0 ? (currentExp / maxExp).clamp(0.0, 1.0) : 0.0;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('EXP', style: AppTextStyles.statLabel.copyWith(color: labelColor)),
              Text(
                '$currentExp / $maxExp',
                style: AppTextStyles.statLabel.copyWith(color: valueColor),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXs),
        ],
        _SegmentBar(
          ratio: ratio,
          height: height,
          fillColor: AppColors.expBar,
          emptyColor: emptyColor,
          borderColor: borderColor,
          segmentCount: 20,
        ),
      ],
    );
  }
}

/// 横方向にセグメント分割された進捗バー。
class _SegmentBar extends StatelessWidget {
  final double ratio;
  final double height;
  final Color fillColor;
  final Color emptyColor;
  final Color borderColor;
  final int segmentCount;

  const _SegmentBar({
    required this.ratio,
    required this.height,
    required this.fillColor,
    required this.emptyColor,
    required this.borderColor,
    required this.segmentCount,
  });

  @override
  Widget build(BuildContext context) {
    final filledSegments = (ratio * segmentCount).round();
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: emptyColor,
        border: Border.all(color: borderColor, width: 2),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        children: List.generate(segmentCount, (i) {
          final filled = i < filledSegments;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i == segmentCount - 1 ? 0 : 1),
              color: filled ? fillColor : Colors.transparent,
            ),
          );
        }),
      ),
    );
  }
}
