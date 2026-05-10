import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/constants/app_theme.dart';
import 'package:tri_task/providers/settings_provider.dart';
import 'package:tri_task/providers/task_provider.dart';
import 'package:tri_task/providers/daily_plan_provider.dart';
import 'package:tri_task/services/hive_service.dart';
import 'package:tri_task/services/notification_service.dart';
import 'package:tri_task/screens/terms_of_service_screen.dart';
import 'package:tri_task/screens/contact_screen.dart';
import 'package:tri_task/screens/privacy_policy_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationEnabled = ref.watch(notificationEnabledProvider);
    final soundEnabled = ref.watch(soundEnabledProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.primaryColor.withOpacity(0.05),
              AppTheme.secondaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildAppBar(context),

              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  children: [
          // Notification section
          _buildSectionHeader(context, '通知'),
          _buildSettingCard(
            context: context,
            icon: Icons.notifications,
            title: '毎日21:00の通知',
            subtitle: '明日のタスク設定リマインダー',
            trailing: Switch(
              value: notificationEnabled,
              onChanged: (_) {
                ref.read(notificationEnabledProvider.notifier).toggle();
              },
              activeColor: AppTheme.primaryColor,
            ),
          ),

          const SizedBox(height: AppTheme.spacingLarge),

          // About section
          _buildSectionHeader(context, 'アプリについて'),
          _buildSettingCard(
            context: context,
            icon: Icons.info,
            title: 'バージョン',
            subtitle: '1.0.0',
            trailing: const SizedBox.shrink(),
          ),
          _buildSettingCard(
            context: context,
            icon: Icons.favorite,
            title: 'TriTask',
            subtitle: '毎日3つのタスクに集中する習慣化アプリ',
            trailing: const SizedBox.shrink(),
          ),
          _buildSettingCard(
            context: context,
            icon: Icons.help_outline,
            title: 'ユーザーサポート',
            subtitle: 'よくある質問とサポート情報',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _launchUserSupport,
          ),
          _buildSettingCard(
            context: context,
            icon: Icons.privacy_tip,
            title: 'プライバシーポリシー',
            subtitle: '個人情報の取り扱いについて',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          _buildSettingCard(
            context: context,
            icon: Icons.description,
            title: '利用規約',
            subtitle: 'アプリの利用規約を確認',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsOfServiceScreen(),
                ),
              );
            },
          ),
          _buildSettingCard(
            context: context,
            icon: Icons.mail_outline,
            title: 'お問い合わせ',
            subtitle: 'バグ報告やご意見・ご要望はこちら',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: AppTheme.spacingLarge),

          // Data section
          _buildSectionHeader(context, 'データ'),
          _buildSettingCard(
            context: context,
            icon: Icons.delete_forever,
            title: 'すべてのデータを削除',
            subtitle: '完了したタスクとStreakがリセットされます',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showDeleteConfirmation(context, ref),
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

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLarge,
        vertical: AppTheme.spacing,
      ),
      child: Row(
        children: [
          // Title
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.secondaryColor,
                ],
              ).createShader(bounds),
              child: Text(
                '設定',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppTheme.spacingSmall,
        bottom: AppTheme.spacingSmall,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
        padding: const EdgeInsets.all(AppTheme.spacing),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSmall),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: AppTheme.spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _launchUserSupport() async {
    final url = Uri.parse('https://right-curio-eb8.notion.site/TriTask-289bc3f4df4080f2a88ad926a548dd51');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundColor,
        title: Text(
          'データを削除',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          'すべてのタスク、ストリーク、履歴が完全に削除されます。\nこの操作は取り消せません。',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'キャンセル',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // すべてのデータを削除
                await HiveService.deleteAllData();

                // プロバイダーの状態をリセット
                ref.invalidate(taskNotifierProvider);
                ref.invalidate(dailyPlanNotifierProvider);
                ref.invalidate(tomorrowPlanNotifierProvider);

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('すべてのデータを削除しました'),
                      backgroundColor: AppTheme.accentColor,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('エラーが発生しました: $e'),
                      backgroundColor: AppTheme.accentColor,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}
