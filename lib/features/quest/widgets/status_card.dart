import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/constants/exp_constants.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/providers/user_status_provider.dart';
import 'package:tri_task/widgets/command_window.dart';
import 'package:tri_task/widgets/exp_bar.dart';

class StatusCard extends ConsumerWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStatusNotifierProvider);

    return CommandWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.gold,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ぼうけんしゃ',
                      style: AppTextStyles.statLabel.copyWith(
                        color: AppColors.cream.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      'Lv. ${user.level}',
                      style: AppTextStyles.statValue.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
              _StreakBadge(streakDays: user.streakDays),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          ExpBar(
            currentExp: user.exp,
            maxExp: ExpConstants.expPerLevel,
            onDark: true,
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
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.gold,
        border: Border.all(color: AppColors.cream, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.crimson,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            '$streakDays日',
            style: AppTextStyles.statLabel.copyWith(
              color: AppColors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
