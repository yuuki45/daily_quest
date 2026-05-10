import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/constants/exp_constants.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/providers/user_status_provider.dart';
import 'package:tri_task/widgets/exp_bar.dart';
import 'package:tri_task/widgets/parchment_card.dart';

class StatusCard extends ConsumerWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStatusNotifierProvider);

    return ParchmentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.gold, width: 2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.brown,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('冒険者', style: AppTextStyles.statLabel),
                    const SizedBox(height: AppTheme.spacingXs),
                    Text('Lv. ${user.level}', style: AppTextStyles.statValue),
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
        color: AppColors.gold.withValues(alpha: 0.18),
        border: Border.all(color: AppColors.gold, width: 1.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
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
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}
