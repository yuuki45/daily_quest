import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/constants/exp_constants.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/providers/user_status_provider.dart';
import 'package:tri_task/widgets/exp_bar.dart';
import 'package:tri_task/widgets/slab_card.dart';

class StatusCard extends ConsumerWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStatusNotifierProvider);

    return SlabCard(
      accentColor: AppColors.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ADVENTURER', style: AppTextStyles.statLabel),
                    const SizedBox(height: AppTheme.spacingXs),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Lv',
                          style: AppTextStyles.statValueSmall.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${user.level}',
                          style: AppTextStyles.statValue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _StreakBadge(streakDays: user.streakDays),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ExpBar(
            currentExp: user.exp,
            maxExp: ExpConstants.expPerLevel,
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int streakDays;

  const _StreakBadge({required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentYellow.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.accentYellow.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.accentYellow,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '$streakDays',
            style: AppTextStyles.statValueSmall.copyWith(
              color: AppColors.accentYellow,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            'd',
            style: AppTextStyles.statLabel.copyWith(
              color: AppColors.accentYellow,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
