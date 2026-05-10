import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/constants/app_constants.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/data/models/quest.dart';
import 'package:tri_task/features/quest/widgets/boss_summary_card.dart';
import 'package:tri_task/features/quest/widgets/quest_card.dart';
import 'package:tri_task/features/quest/widgets/quest_edit_sheet.dart';
import 'package:tri_task/features/quest/widgets/status_card.dart';
import 'package:tri_task/providers/quest_provider.dart';

const _weekdayJp = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

class QuestScreen extends ConsumerWidget {
  const QuestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(questNotifierProvider);
    final mainQuest = quests
        .where((q) => q.type == QuestType.main)
        .cast<Quest?>()
        .firstWhere((_) => true, orElse: () => null);
    final sideQuests =
        quests.where((q) => q.type == QuestType.side).toList(growable: false);

    final canAddMore = mainQuest == null || sideQuests.length < 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingLg,
            AppTheme.spacingMd,
            AppTheme.spacingLg,
            96,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              const SizedBox(height: AppTheme.spacingLg),
              const StatusCard(),
              const SizedBox(height: AppTheme.spacingMd),
              const BossSummaryCard(),
              const SizedBox(height: AppTheme.spacingLg + 8),
              _SectionTitle(
                  label: 'TODAY / QUEST', count: quests.length, max: 3),
              const SizedBox(height: AppTheme.spacingMd),
              if (mainQuest == null)
                _MainQuestPlaceholder(
                  onTap: () => _openEditSheet(context, QuestType.main),
                )
              else
                QuestCard(quest: mainQuest),
              const SizedBox(height: AppTheme.spacingSm + 4),
              if (sideQuests.isNotEmpty)
                ...sideQuests.map(
                  (q) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppTheme.spacingSm + 4),
                    child: QuestCard(quest: q),
                  ),
                )
              else if (mainQuest != null)
                _SideQuestHint(
                  onTap: () => _openEditSheet(context, QuestType.side),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: canAddMore
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.6),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.textOnAccent,
                elevation: 0,
                shape: const CircleBorder(),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _openEditSheet(context, null);
                },
                child: const Icon(Icons.add_rounded, size: 32),
              ),
            )
          : null,
    );
  }

  void _openEditSheet(BuildContext context, QuestType? initialType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuestEditSheet(initialType: initialType),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateText =
        '${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}  ${_weekdayJp[now.weekday - 1]}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.displayLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  AppConstants.appTagline,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text(
            dateText,
            style: AppTextStyles.statLabel.copyWith(
              color: AppColors.accent,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  final int count;
  final int max;

  const _SectionTitle({
    required this.label,
    required this.count,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.statLabel.copyWith(
              color: AppColors.accent,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Container(
              height: 1,
              color: AppColors.accent.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            '$count / $max',
            style: AppTextStyles.statLabel.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainQuestPlaceholder extends StatelessWidget {
  final VoidCallback onTap;

  const _MainQuestPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.accentYellow.withValues(alpha: 0.4),
              width: 1.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.add_rounded,
                color: AppColors.accentYellow,
                size: 28,
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MAIN  QUEST',
                      style: AppTextStyles.statLabel.copyWith(
                        color: AppColors.accentYellow,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'タップしてメインクエストを設定',
                      style: AppTextStyles.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideQuestHint extends StatelessWidget {
  final VoidCallback onTap;

  const _SideQuestHint({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingMd,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.textMuted.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.add_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  'サイドクエストを追加（最大2件）',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
