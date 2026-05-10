import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tri_task/constants/app_theme.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const String contactEmail = 'web-studio@ymail.ne.jp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お問い合わせ'),
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // お問い合わせ内容
              Text(
                'お問い合わせ内容',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: AppTheme.spacing),

              _buildInfoCard(
                context,
                icon: Icons.bug_report_rounded,
                title: 'バグ報告',
                description: 'アプリの不具合やエラーを発見された場合',
              ),
              _buildInfoCard(
                context,
                icon: Icons.lightbulb_outline_rounded,
                title: '機能リクエスト',
                description: '新しい機能のご提案やアイデア',
              ),
              _buildInfoCard(
                context,
                icon: Icons.help_outline_rounded,
                title: '使い方の質問',
                description: 'アプリの使い方に関するご質問',
              ),
              _buildInfoCard(
                context,
                icon: Icons.feedback_outlined,
                title: 'ご意見・ご感想',
                description: 'アプリに関するご意見やご感想',
              ),

              const SizedBox(height: AppTheme.spacingLarge * 2),

              // メールアドレス
              Text(
                'メールアドレス',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: AppTheme.spacing),

              Container(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(
                    color: AppTheme.accentColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.email_rounded,
                          color: AppTheme.accentColor,
                          size: 24,
                        ),
                        const SizedBox(width: AppTheme.spacing),
                        Expanded(
                          child: SelectableText(
                            contactEmail,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: contactEmail));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('メールアドレスをコピーしました'),
                              backgroundColor: AppTheme.accentColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        label: const Text('メールアドレスをコピー'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingLarge,
                            vertical: AppTheme.spacing,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingLarge * 2),

              // 注意事項
              Text(
                'ご注意',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: AppTheme.spacing),

              Container(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNoticeItem(
                      context,
                      '• お問い合わせには順次対応させていただきます',
                    ),
                    _buildNoticeItem(
                      context,
                      '• 内容によっては回答までお時間をいただく場合があります',
                    ),
                    _buildNoticeItem(
                      context,
                      '• 営業時間外のお問い合わせは翌営業日以降の対応となります',
                    ),
                    _buildNoticeItem(
                      context,
                      '• すべてのお問い合わせに回答できない場合があります',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
      padding: const EdgeInsets.all(AppTheme.spacing),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
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
                        color: AppTheme.textPrimary,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
      ),
    );
  }
}
