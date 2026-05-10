import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/data/models/quest.dart';
import 'package:tri_task/providers/quest_provider.dart';
import 'package:tri_task/widgets/parchment_card.dart';

class QuestCard extends ConsumerWidget {
  final Quest quest;

  const QuestCard({required this.quest, super.key});

  bool get _isMain => quest.type == QuestType.main;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ParchmentCard(
      borderColor: _isMain ? AppColors.gold : AppColors.border,
      borderWidth: _isMain ? 2.5 : 2.0,
      onTap: () async {
        await HapticFeedback.selectionClick();
        await ref.read(questNotifierProvider.notifier).toggleComplete(quest.id);
      },
      onLongPress: () => _showOptions(context, ref),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isMain) const _MainBadge(),
          if (_isMain) const SizedBox(height: AppTheme.spacingSm),
          Row(
            children: [
              _CheckBox(checked: quest.isCompleted),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Text(
                  quest.title,
                  style: AppTextStyles.questTitle.copyWith(
                    decoration: quest.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: quest.isCompleted
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showOptions(BuildContext context, WidgetRef ref) async {
    await HapticFeedback.lightImpact();
    if (!context.mounted) return;
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline,
                  color: AppColors.crimson),
              title: Text(
                'クエストを削除',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.crimson,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.of(sheetCtx).pop('delete'),
            ),
            ListTile(
              leading: const Icon(Icons.close, color: AppColors.textSecondary),
              title: Text('キャンセル', style: AppTextStyles.bodyLarge),
              onTap: () => Navigator.of(sheetCtx).pop(),
            ),
          ],
        ),
      ),
    );

    if (action == 'delete') {
      await ref.read(questNotifierProvider.notifier).deleteQuest(quest.id);
    }
  }
}

class _MainBadge extends StatelessWidget {
  const _MainBadge();

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: AppColors.brown),
          const SizedBox(width: 4),
          Text(
            'メインクエスト',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  final bool checked;

  const _CheckBox({required this.checked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: checked ? AppColors.gold : AppColors.cream,
        border: Border.all(color: AppColors.brown, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: checked
          ? const Icon(Icons.check_rounded, size: 18, color: AppColors.brown)
          : null,
    );
  }
}
