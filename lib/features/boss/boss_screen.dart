import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/data/models/boss.dart';
import 'package:tri_task/data/repositories/boss_repository.dart';
import 'package:tri_task/providers/boss_provider.dart';
import 'package:tri_task/widgets/hp_bar.dart';
import 'package:tri_task/widgets/parchment_card.dart';
import 'package:tri_task/widgets/screen_header.dart';

class BossScreen extends ConsumerWidget {
  const BossScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boss = ref.watch(bossNotifierProvider);
    final defeatedBosses = BossRepository().getDefeated();

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingMd,
            AppTheme.spacingSm,
            AppTheme.spacingMd,
            AppTheme.spacingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScreenHeader(
                title: '今週のボス',
                subtitle: 'メインクエスト達成でHP-1',
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _CurrentBossCard(boss: boss),
              const SizedBox(height: AppTheme.spacingLg),
              const _SectionTitle(title: '討伐の記録'),
              const SizedBox(height: AppTheme.spacingMd),
              if (defeatedBosses.isEmpty)
                _EmptyDefeated()
              else
                ...defeatedBosses.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                    child: _DefeatedBossTile(boss: b),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentBossCard extends StatelessWidget {
  final Boss boss;

  const _CurrentBossCard({required this.boss});

  @override
  Widget build(BuildContext context) {
    return ParchmentCard(
      borderColor: AppColors.purple,
      borderWidth: 2.5,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.15),
              border: Border.all(color: AppColors.purple, width: 2.5),
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: Icon(
              boss.defeated ? Icons.celebration_rounded : Icons.castle_rounded,
              color: AppColors.purple,
              size: 72,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            boss.name,
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            '${boss.weekStartDate} 〜 ${boss.weekEndDate}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          HpBar(
            currentHp: boss.currentHp,
            maxHp: boss.maxHp,
            height: 18,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          if (boss.defeated)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.gold,
                border: Border.all(color: AppColors.brown, width: 2),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events_rounded,
                      color: AppColors.brown, size: 20),
                  const SizedBox(width: AppTheme.spacingXs),
                  Text(
                    '討伐に成功！',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.brown,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              'あと${boss.currentHp}回のメイン達成で討伐！',
              style: AppTextStyles.bodyMedium,
            ),
        ],
      ),
    );
  }
}

class _DefeatedBossTile extends StatelessWidget {
  final Boss boss;

  const _DefeatedBossTile({required this.boss});

  @override
  Widget build(BuildContext context) {
    return ParchmentCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              border: Border.all(color: AppColors.gold, width: 1.5),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: const Icon(Icons.emoji_events_rounded,
                color: AppColors.gold, size: 22),
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
                Text(
                  '${boss.weekStartDate} 〜',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDefeated extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppColors.cream.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            color: AppColors.cream.withValues(alpha: 0.7),
            size: 32,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Text(
              'まだ討伐したボスはいません。\n今週のボスを倒そう！',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.cream.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            title,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.cream,
            ),
          ),
        ],
      ),
    );
  }
}
