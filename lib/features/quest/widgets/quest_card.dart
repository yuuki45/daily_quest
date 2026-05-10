import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/data/models/quest.dart';
import 'package:tri_task/providers/quest_provider.dart';
import 'package:tri_task/widgets/command_window.dart';

class QuestCard extends ConsumerWidget {
  final Quest quest;

  const QuestCard({required this.quest, super.key});

  bool get _isMain => quest.type == QuestType.main;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommandWindow(
      borderColor: _isMain ? AppColors.gold : AppColors.cream,
      borderWidth: _isMain ? 3.5 : 2.5,
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
              if (_isMain && !quest.isCompleted)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    '▶',
                    style: AppTextStyles.statValue.copyWith(
                      color: AppColors.gold,
                      fontSize: 18,
                    ),
                  ),
                ),
              _CheckBox(checked: quest.isCompleted),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Text(
                  quest.title,
                  style: AppTextStyles.questTitle.copyWith(
                    color: quest.isCompleted
                        ? AppColors.cream.withValues(alpha: 0.45)
                        : AppColors.cream,
                    decoration: quest.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor:
                        AppColors.cream.withValues(alpha: 0.45),
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
      backgroundColor: AppColors.windowBg,
      shape: const Border(
        top: BorderSide(color: AppColors.gold, width: 3),
        left: BorderSide(color: AppColors.gold, width: 3),
        right: BorderSide(color: AppColors.gold, width: 3),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: AppColors.crimson),
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
              leading: const Icon(Icons.close, color: AppColors.cream),
              title: Text(
                'キャンセル',
                style:
                    AppTextStyles.bodyLarge.copyWith(color: AppColors.cream),
              ),
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
        border: Border.all(color: AppColors.cream, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: AppColors.brown),
          const SizedBox(width: 4),
          Text(
            'メインクエスト',
            style: AppTextStyles.statLabel.copyWith(
              color: AppColors.brown,
              fontWeight: FontWeight.bold,
              fontSize: 11,
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
        color: checked ? AppColors.gold : AppColors.windowBg,
        border: Border.all(color: AppColors.cream, width: 2),
      ),
      child: checked
          ? const Icon(Icons.check_rounded, size: 18, color: AppColors.brown)
          : null,
    );
  }
}
