import 'package:flutter/material.dart';
import 'package:tri_task/core/constants/app_constants.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/widgets/parchment_card.dart';
import 'package:tri_task/widgets/pixel_button.dart';

class RemakeAnnounceScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const RemakeAnnounceScreen({required this.onContinue, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
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
              children: [
                const SizedBox(height: AppTheme.spacingXl),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.18),
                    border: Border.all(color: AppColors.gold, width: 3),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: const Icon(
                    Icons.castle_rounded,
                    color: AppColors.gold,
                    size: 56,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColors.cream,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Text(
                  'TriTask が新しく生まれ変わりました',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingXl),
                const _ChangeCard(
                  icon: Icons.star_rounded,
                  title: 'タスクは「クエスト」に',
                  description: '今日のクエストを冒険感覚で達成しよう',
                ),
                const SizedBox(height: AppTheme.spacingMd),
                const _ChangeCard(
                  icon: Icons.bolt_rounded,
                  title: 'EXPでレベルアップ',
                  description: '達成するたびに経験値が貯まり、成長を実感',
                ),
                const SizedBox(height: AppTheme.spacingMd),
                const _ChangeCard(
                  icon: Icons.castle_rounded,
                  title: '週ボスに挑もう',
                  description: 'メイン達成でボスHP-1。1週間で討伐を目指す',
                ),
                const SizedBox(height: AppTheme.spacingXl),
                PixelButton(
                  label: '冒険を始める',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: onContinue,
                  fullWidth: true,
                  variant: PixelButtonVariant.secondary,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  '※ TriTask の旧データは削除されています',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
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
  final String title;
  final String description;

  const _ChangeCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ParchmentCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.18),
              border: Border.all(color: AppColors.gold, width: 2),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: AppColors.gold, size: 28),
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
