import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/providers/boss_provider.dart';
import 'package:tri_task/providers/quest_provider.dart';
import 'package:tri_task/providers/record_provider.dart';
import 'package:tri_task/providers/user_status_provider.dart';
import 'package:tri_task/services/hive_service.dart';
import 'package:tri_task/widgets/parchment_card.dart';
import 'package:tri_task/widgets/screen_header.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              const ScreenHeader(title: '設定'),
              const SizedBox(height: AppTheme.spacingLg),
              const _SectionLabel(text: 'データ'),
              const SizedBox(height: AppTheme.spacingSm),
              ParchmentCard(
                padding: EdgeInsets.zero,
                child: _SettingsTile(
                  icon: Icons.delete_outline_rounded,
                  iconColor: AppColors.crimson,
                  title: 'すべてのデータをリセット',
                  subtitle: 'クエスト・レベル・ボス・記録が全て削除されます',
                  onTap: () => _confirmReset(context, ref),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              const _SectionLabel(text: 'このアプリについて'),
              const SizedBox(height: AppTheme.spacingSm),
              ParchmentCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    const _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: 'バージョン',
                      trailingText: '2.0.0',
                    ),
                    const _Divider(),
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      title: '利用規約',
                      onTap: () => _showComingSoon(context, '利用規約'),
                    ),
                    const _Divider(),
                    _SettingsTile(
                      icon: Icons.shield_outlined,
                      title: 'プライバシーポリシー',
                      onTap: () => _showComingSoon(context, 'プライバシーポリシー'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              Text(
                'Daily Quest',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.cream.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          side: const BorderSide(color: AppColors.border, width: 2),
        ),
        title: Text('データをリセット', style: AppTextStyles.titleMedium),
        content: Text(
          'すべてのクエスト・レベル・ボス・冒険記録が削除されます。\nこの操作は元に戻せません。',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'キャンセル',
              style: AppTextStyles.button.copyWith(color: AppColors.brown),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              '削除する',
              style: AppTextStyles.button.copyWith(color: AppColors.crimson),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await Hive.box(HiveService.questsBoxName).clear();
    await Hive.box(HiveService.userStatusBoxName).clear();
    await Hive.box(HiveService.bossesBoxName).clear();
    await Hive.box(HiveService.recordsBoxName).clear();

    ref.invalidate(questNotifierProvider);
    ref.invalidate(userStatusNotifierProvider);
    ref.invalidate(bossNotifierProvider);
    ref.invalidate(recordNotifierProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('データをリセットしました', style: AppTextStyles.bodyMedium),
          backgroundColor: AppColors.brown,
        ),
      );
    }
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label は準備中です', style: AppTextStyles.bodyMedium),
        backgroundColor: AppColors.brown,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.iconColor,
    this.subtitle,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingMd,
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? AppColors.brown, size: 22),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: iconColor ?? AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: AppTextStyles.caption),
                    ],
                  ],
                ),
              ),
              if (trailingText != null)
                Text(trailingText!, style: AppTextStyles.bodyMedium),
              if (onTap != null && trailingText == null)
                Icon(Icons.chevron_right,
                    color: AppColors.brown.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Container(
        height: 1,
        color: AppColors.border.withValues(alpha: 0.2),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
      child: Text(
        text,
        style: AppTextStyles.statLabel.copyWith(color: AppColors.cream),
      ),
    );
  }
}
