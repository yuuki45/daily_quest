import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/providers/boss_provider.dart';
import 'package:tri_task/widgets/hp_bar.dart';
import 'package:tri_task/widgets/parchment_card.dart';

class BossSummaryCard extends ConsumerWidget {
  const BossSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boss = ref.watch(bossNotifierProvider);

    return ParchmentCard(
      borderColor: AppColors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('今週のボス', style: AppTextStyles.statLabel),
              const Spacer(),
              if (boss.defeated) const _DefeatedBadge(),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.purple, width: 2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: const Icon(
                  Icons.castle_rounded,
                  color: AppColors.purple,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boss.name,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    HpBar(
                      currentHp: boss.currentHp,
                      maxHp: boss.maxHp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DefeatedBadge extends StatelessWidget {
  const _DefeatedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.gold,
        border: Border.all(color: AppColors.brown, width: 1.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        '討伐！',
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.brown,
        ),
      ),
    );
  }
}
