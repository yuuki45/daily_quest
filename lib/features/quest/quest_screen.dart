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

const _weekdayJp = ['月', '火', '水', '木', '金', '土', '日'];

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
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingMd,
            AppTheme.spacingSm,
            AppTheme.spacingMd,
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
              const SizedBox(height: AppTheme.spacingLg),
              const _SectionTitle(title: '今日のクエスト'),
              const SizedBox(height: AppTheme.spacingMd),
              if (mainQuest == null)
                _MainQuestPlaceholder(
                  onTap: () => _openEditSheet(context, QuestType.main),
                )
              else
                QuestCard(quest: mainQuest),
              const SizedBox(height: AppTheme.spacingMd),
              if (sideQuests.isNotEmpty)
                ...sideQuests.map(
                  (q) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppTheme.spacingSm),
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
          ? FloatingActionButton(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.brown,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                side: const BorderSide(color: AppColors.brown, width: 2),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                _openEditSheet(context, null);
              },
              child: const Icon(Icons.add_rounded, size: 32),
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
    final dateText = '${now.month}/${now.day}（${_weekdayJp[now.weekday - 1]}）';

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
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColors.cream,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppConstants.appTagline,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          Text(
            dateText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
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

class _MainQuestPlaceholder extends StatelessWidget {
  final VoidCallback onTap;

  const _MainQuestPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: AppColors.cream.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.gold,
                size: 32,
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'メインクエストを追加',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.cream,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '今日一番やるべきタスクを1つ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.cream.withValues(alpha: 0.7),
                      ),
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
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
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
                Icons.flag_outlined,
                color: AppColors.cream.withValues(alpha: 0.7),
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  'サイドクエストを追加（最大2件）',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.8),
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
