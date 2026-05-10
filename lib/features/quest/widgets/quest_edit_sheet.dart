import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/data/models/quest.dart';
import 'package:tri_task/providers/quest_provider.dart';
import 'package:tri_task/widgets/pixel_button.dart';

class QuestEditSheet extends ConsumerStatefulWidget {
  final QuestType? initialType;

  const QuestEditSheet({super.key, this.initialType});

  @override
  ConsumerState<QuestEditSheet> createState() => _QuestEditSheetState();
}

class _QuestEditSheetState extends ConsumerState<QuestEditSheet> {
  final _controller = TextEditingController();
  late QuestType _selectedType;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final quests = ref.read(questNotifierProvider);
    final hasMain = quests.any((q) => q.type == QuestType.main);
    final canMain = !hasMain;
    _selectedType =
        widget.initialType ?? (canMain ? QuestType.main : QuestType.side);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quests = ref.watch(questNotifierProvider);
    final hasMain = quests.any((q) => q.type == QuestType.main);
    final sideCount = quests.where((q) => q.type == QuestType.side).length;
    final canMain = !hasMain;
    final canSide = sideCount < 2;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
            top: BorderSide(
                color: AppColors.accent.withValues(alpha: 0.6), width: 2),
          ),
        ),
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text('NEW  QUEST', style: AppTextStyles.statLabel),
            const SizedBox(height: 4),
            Text('クエストを追加', style: AppTextStyles.headlineLarge),
            const SizedBox(height: AppTheme.spacingLg),
            Text('TYPE', style: AppTextStyles.statLabel),
            const SizedBox(height: AppTheme.spacingSm),
            Row(
              children: [
                Expanded(
                  child: _TypeChip(
                    label: 'メイン',
                    icon: Icons.star_rounded,
                    accent: AppColors.accentYellow,
                    selected: _selectedType == QuestType.main,
                    enabled: canMain || _selectedType == QuestType.main,
                    onTap: canMain
                        ? () => setState(() => _selectedType = QuestType.main)
                        : null,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Expanded(
                  child: _TypeChip(
                    label: 'サイド',
                    icon: Icons.flag_outlined,
                    accent: AppColors.accent,
                    selected: _selectedType == QuestType.side,
                    enabled: canSide || _selectedType == QuestType.side,
                    onTap: canSide
                        ? () => setState(() => _selectedType = QuestType.side)
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text('TITLE', style: AppTextStyles.statLabel),
            const SizedBox(height: AppTheme.spacingSm),
            TextField(
              controller: _controller,
              autofocus: true,
              maxLength: 60,
              style: AppTextStyles.bodyLarge,
              cursorColor: AppColors.accent,
              decoration: InputDecoration(
                hintText: '例: アプリのLPを30分作る',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingMd,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.accent,
                    width: 2,
                  ),
                ),
                errorText: _errorText,
                errorStyle: TextStyle(color: AppColors.accentRed),
              ),
              onChanged: (_) {
                if (_errorText != null) setState(() => _errorText = null);
              },
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            PixelButton(
              label: 'ADD',
              icon: Icons.add_rounded,
              onPressed: _submit,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      setState(() => _errorText = 'クエスト名を入力してください');
      return;
    }
    try {
      await ref.read(questNotifierProvider.notifier).addQuest(
            title: title,
            type: _selectedType,
          );
      if (mounted) Navigator.of(context).pop();
    } on QuestLimitException catch (e) {
      setState(() => _errorText = e.message);
    }
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.accent,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? accent.withValues(alpha: 0.18)
        : AppColors.background;
    final borderColor = selected
        ? accent
        : (enabled
            ? AppColors.textMuted.withValues(alpha: 0.4)
            : AppColors.textMuted.withValues(alpha: 0.2));

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacingMd,
              horizontal: AppTheme.spacingSm,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    color: selected ? accent : AppColors.textSecondary,
                    size: 22),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: selected ? accent : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
