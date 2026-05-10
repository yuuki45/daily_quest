import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/data/models/quest.dart';
import 'package:tri_task/providers/quest_provider.dart';
import 'package:tri_task/widgets/slab_card.dart';

class QuestCard extends ConsumerWidget {
  final Quest quest;

  const QuestCard({required this.quest, super.key});

  bool get _isMain => quest.type == QuestType.main;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accentColor = _isMain ? AppColors.accentYellow : AppColors.accent;

    return SlabCard(
      accentColor: accentColor,
      accentWidth: _isMain ? 5 : 3,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingMd,
      ),
      onTap: () async {
        await HapticFeedback.selectionClick();
        await ref.read(questNotifierProvider.notifier).toggleComplete(quest.id);
      },
      onLongPress: () => _showOptions(context, ref),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _isMain ? 'MAIN  QUEST' : 'SIDE  QUEST',
                style: AppTextStyles.statLabel.copyWith(
                  color: accentColor,
                  fontSize: _isMain ? 11 : 10,
                ),
              ),
              if (quest.isCompleted) ...[
                const SizedBox(width: AppTheme.spacingSm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    'CLEAR',
                    style: AppTextStyles.statLabel.copyWith(
                      color: AppColors.accentGreen,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Row(
            children: [
              _CheckBox(checked: quest.isCompleted, accent: accentColor),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Text(
                  quest.title,
                  style: AppTextStyles.questTitle.copyWith(
                    color: quest.isCompleted
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                    decoration: quest.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: AppColors.textMuted,
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
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppTheme.spacingSm),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: AppColors.accentRed),
              title: Text(
                'クエストを削除',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.accentRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.of(sheetCtx).pop('delete'),
            ),
            ListTile(
              leading:
                  const Icon(Icons.close, color: AppColors.textSecondary),
              title: Text(
                'キャンセル',
                style: AppTextStyles.bodyLarge,
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

class _CheckBox extends StatelessWidget {
  final bool checked;
  final Color accent;

  const _CheckBox({required this.checked, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: checked ? accent : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: checked ? accent : AppColors.textMuted,
          width: 2,
        ),
      ),
      child: checked
          ? const Icon(
              Icons.check_rounded,
              size: 16,
              color: AppColors.textOnAccent,
            )
          : null,
    );
  }
}
