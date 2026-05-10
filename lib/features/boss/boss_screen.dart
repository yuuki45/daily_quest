import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/data/models/boss.dart';
import 'package:tri_task/data/repositories/boss_repository.dart';
import 'package:tri_task/providers/boss_provider.dart';
import 'package:tri_task/widgets/hp_bar.dart';
import 'package:tri_task/widgets/screen_header.dart';
import 'package:tri_task/widgets/slab_card.dart';

class BossScreen extends ConsumerWidget {
  const BossScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boss = ref.watch(bossNotifierProvider);
    final defeatedBosses = BossRepository().getDefeated();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingLg,
            AppTheme.spacingMd,
            AppTheme.spacingLg,
            AppTheme.spacingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScreenHeader(
                title: 'BOSS',
                subtitle: 'メインクエスト達成で HP -1',
                accentColor: AppColors.accentPurple,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _CurrentBossCard(boss: boss),
              const SizedBox(height: AppTheme.spacingLg + 8),
              _SectionDivider(label: 'DEFEATED  /  ${defeatedBosses.length}'),
              const SizedBox(height: AppTheme.spacingMd),
              if (defeatedBosses.isEmpty)
                const _EmptyDefeated()
              else
                ...defeatedBosses.map(
                  (b) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppTheme.spacingSm + 4),
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
    return SlabCard(
      accentColor: AppColors.accentPurple,
      accentWidth: 6,
      padding: const EdgeInsets.all(AppTheme.spacingLg + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('THIS  WEEK', style: AppTextStyles.statLabel),
          const SizedBox(height: AppTheme.spacingMd),
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.accentPurple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.accentPurple.withValues(alpha: 0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPurple.withValues(alpha: 0.4),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Icon(
                boss.defeated
                    ? Icons.celebration_rounded
                    : Icons.castle_rounded,
                color: AppColors.accentPurple,
                size: 64,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            boss.name,
            style: AppTextStyles.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${boss.weekStartDate}  〜  ${boss.weekEndDate}',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          HpBar(
            currentHp: boss.currentHp,
            maxHp: boss.maxHp,
            height: 12,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          if (boss.defeated)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.accentYellow,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events_rounded,
                      color: AppColors.textOnAccent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'DEFEATED',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.textOnAccent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else
            Center(
              child: Text(
                'あと ${boss.currentHp} 回のメイン達成で討伐',
                style: AppTextStyles.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String label;

  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.statLabel.copyWith(color: AppColors.accent),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Container(
              height: 1,
              color: AppColors.accent.withValues(alpha: 0.3),
            ),
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
    return SlabCard(
      accentColor: AppColors.accentYellow,
      accentWidth: 3,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm + 2,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accentYellow.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.emoji_events_rounded,
                color: AppColors.accentYellow, size: 20),
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
                const SizedBox(height: 2),
                Text(boss.weekStartDate, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDefeated extends StatelessWidget {
  const _EmptyDefeated();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.textMuted.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: AppColors.textSecondary, size: 28),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Text(
              'まだ討伐したボスはいません。\n今週のボスを倒そう。',
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
