import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/providers/boss_provider.dart';
import 'package:tri_task/widgets/hp_bar.dart';
import 'package:tri_task/widgets/slab_card.dart';

class BossSummaryCard extends ConsumerWidget {
  const BossSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boss = ref.watch(bossNotifierProvider);

    return SlabCard(
      accentColor: AppColors.accentPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('THIS WEEK / BOSS', style: AppTextStyles.statLabel),
              const Spacer(),
              if (boss.defeated) const _DefeatedBadge(),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.accentPurple.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.castle_rounded,
                  color: AppColors.accentPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boss.name,
                      style: AppTextStyles.headlineMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
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
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentYellow,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'DEFEATED',
        style: AppTextStyles.statLabel.copyWith(
          color: AppColors.textOnAccent,
          fontSize: 10,
        ),
      ),
    );
  }
}
