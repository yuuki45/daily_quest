import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tri_task/core/constants/app_constants.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/providers/boss_provider.dart';
import 'package:tri_task/providers/quest_provider.dart';
import 'package:tri_task/providers/record_provider.dart';
import 'package:tri_task/providers/user_status_provider.dart';
import 'package:tri_task/services/hive_service.dart';
import 'package:tri_task/services/notification_service.dart';
import 'package:tri_task/widgets/screen_header.dart';
import 'package:tri_task/widgets/slab_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              const ScreenHeader(title: 'SETTINGS'),
              const SizedBox(height: AppTheme.spacingLg),
              const _GroupLabel(label: 'NOTIFICATION'),
              const SizedBox(height: AppTheme.spacingSm),
              SlabCard(
                accentColor: AppColors.accent,
                padding: EdgeInsets.zero,
                child: const _NotificationToggle(),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              const _GroupLabel(label: 'DATA'),
              const SizedBox(height: AppTheme.spacingSm),
              SlabCard(
                accentColor: AppColors.accentRed,
                padding: EdgeInsets.zero,
                child: _SettingsTile(
                  icon: Icons.delete_outline_rounded,
                  iconColor: AppColors.accentRed,
                  title: 'すべてのデータをリセット',
                  subtitle: 'クエスト・レベル・ボス・記録が全て削除されます',
                  onTap: () => _confirmReset(context, ref),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              const _GroupLabel(label: 'ABOUT'),
              const SizedBox(height: AppTheme.spacingSm),
              SlabCard(
                accentColor: AppColors.textMuted,
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
              Center(
                child: Text(
                  'Daily Quest',
                  style: AppTextStyles.statLabel.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
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
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text('データをリセット', style: AppTextStyles.titleMedium),
        content: Text(
          'すべてのクエスト・レベル・ボス・冒険記録が削除されます。\nこの操作は元に戻せません。',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('キャンセル',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('削除する',
                style: TextStyle(color: AppColors.accentRed)),
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
          backgroundColor: AppColors.surfaceVariant,
        ),
      );
    }
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label は準備中です', style: AppTextStyles.bodyMedium),
        backgroundColor: AppColors.surfaceVariant,
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String label;

  const _GroupLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppTheme.spacingSm),
      child: Text(label, style: AppTextStyles.statLabel),
    );
  }
}

class _NotificationToggle extends StatefulWidget {
  const _NotificationToggle();

  @override
  State<_NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<_NotificationToggle> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _enabled =
          prefs.getBool(AppConstants.prefsKeyNotificationsEnabled) ?? true;
    });
  }

  Future<void> _toggle(bool value) async {
    setState(() => _enabled = value);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefsKeyNotificationsEnabled, value);

    if (value) {
      final granted = await NotificationService.requestPermissions();
      if (granted) {
        await NotificationService.scheduleDailyReminder();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '通知が許可されませんでした。端末の設定から有効にしてください。',
              style: AppTextStyles.bodyMedium,
            ),
            backgroundColor: AppColors.surfaceVariant,
          ),
        );
      }
    } else {
      await NotificationService.cancelDailyReminder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = _enabled;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingMd,
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_outlined,
              color: AppColors.accent, size: 22),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('21:00 にリマインド', style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text('毎日21時に「冒険を記録しよう」と通知',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          if (value == null)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Switch.adaptive(
              value: value,
              onChanged: _toggle,
              activeThumbColor: AppColors.accent,
              activeTrackColor: AppColors.accent.withValues(alpha: 0.4),
            ),
        ],
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
              Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22),
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
                Text(trailingText!,
                    style: AppTextStyles.statLabel.copyWith(fontSize: 12)),
              if (onTap != null && trailingText == null)
                Icon(Icons.chevron_right,
                    color: AppColors.textMuted),
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
        color: AppColors.textMuted.withValues(alpha: 0.2),
      ),
    );
  }
}
