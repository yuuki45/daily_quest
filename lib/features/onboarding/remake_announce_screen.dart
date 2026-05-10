import 'package:flutter/material.dart';
import 'package:tri_task/core/constants/app_constants.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/widgets/pixel_button.dart';
import 'package:tri_task/widgets/slab_card.dart';

class RemakeAnnounceScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const RemakeAnnounceScreen({required this.onContinue, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.vertical -
                  AppTheme.spacingLg * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppTheme.spacingXl),
                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          blurRadius: 32,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.castle_rounded,
                      color: AppColors.accent,
                      size: 56,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Center(
                  child: Text(
                    AppConstants.appName,
                    style: AppTextStyles.displayLarge.copyWith(fontSize: 36),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Center(
                  child: Text(
                    'TriTask が新しく生まれ変わりました',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXl),
                const _ChangeCard(
                  icon: Icons.star_rounded,
                  accent: AppColors.accentYellow,
                  title: 'タスクは「クエスト」に',
                  description: '今日のクエストを冒険感覚で達成しよう',
                ),
                const SizedBox(height: AppTheme.spacingMd),
                const _ChangeCard(
                  icon: Icons.bolt_rounded,
                  accent: AppColors.accent,
                  title: 'EXPでレベルアップ',
                  description: '達成するたびに経験値が貯まり、成長を実感',
                ),
                const SizedBox(height: AppTheme.spacingMd),
                const _ChangeCard(
                  icon: Icons.castle_rounded,
                  accent: AppColors.accentPurple,
                  title: '週ボスに挑もう',
                  description: 'メイン達成でボスHP-1。1週間で討伐を目指す',
                ),
                const SizedBox(height: AppTheme.spacingXl),
                PixelButton(
                  label: 'START  ADVENTURE',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: onContinue,
                  fullWidth: true,
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Center(
                  child: Text(
                    '※ TriTask の旧データは削除されています',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangeCard extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String title;
  final String description;

  const _ChangeCard({
    required this.icon,
    required this.accent,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SlabCard(
      accentColor: accent,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accent, size: 24),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text(description, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
