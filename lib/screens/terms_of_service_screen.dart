import 'package:flutter/material.dart';
import 'package:tri_task/constants/app_theme.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
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
              _buildSection(
                context,
                title: '第1条（適用）',
                content: '本利用規約は、本アプリケーション「TriTask」（以下「本アプリ」といいます）の利用に関する条件を定めるものです。利用者の皆様には、本利用規約に同意いただいた上で、本アプリをご利用いただくものとします。',
              ),
              _buildSection(
                context,
                title: '第2条（利用登録）',
                content: '本アプリは利用登録を必要とせず、ダウンロード後すぐにご利用いただけます。すべてのデータは端末内にのみ保存され、外部サーバーへの送信は行われません。',
              ),
              _buildSection(
                context,
                title: '第3条（プライバシー）',
                content: '本アプリは、利用者の個人情報を収集しません。タスクデータ、達成履歴、設定情報などすべてのデータは、利用者の端末内にのみ保存されます。開発者がこれらのデータにアクセスすることはありません。',
              ),
              _buildSection(
                context,
                title: '第4条（通知機能）',
                content: '本アプリは、タスク設定のリマインダーとして通知機能を提供します。通知の送信にあたり、個人情報が外部に送信されることはありません。通知設定は端末の設定からいつでも変更できます。',
              ),
              _buildSection(
                context,
                title: '第5条（禁止事項）',
                content: '利用者は、本アプリの利用にあたり、以下の行為をしてはなりません。\n\n• 本アプリを不正な目的で使用する行為\n• 本アプリの運営を妨害する行為\n• 本アプリのリバースエンジニアリング、逆コンパイル、または逆アセンブル\n• その他、開発者が不適切と判断する行為',
              ),
              _buildSection(
                context,
                title: '第6条（免責事項）',
                content: '開発者は、本アプリの利用により生じた損害について、一切の責任を負いません。本アプリは現状有姿で提供され、特定の目的への適合性、正確性、完全性について保証しません。',
              ),
              _buildSection(
                context,
                title: '第7条（データのバックアップ）',
                content: '本アプリのデータは端末内にのみ保存されます。アプリの削除や端末の初期化により、すべてのデータが失われます。重要なデータは利用者自身で管理していただくようお願いいたします。',
              ),
              _buildSection(
                context,
                title: '第8条（サービスの変更・終了）',
                content: '開発者は、利用者への事前の通知なく、本アプリの内容を変更、または提供を終了することができるものとします。これにより利用者に生じた損害について、開発者は一切の責任を負いません。',
              ),
              _buildSection(
                context,
                title: '第9条（利用規約の変更）',
                content: '開発者は、必要に応じて本利用規約を変更することができます。変更後の利用規約は、アプリ内に掲示された時点で効力を生じるものとします。',
              ),
              _buildSection(
                context,
                title: '第10条（お問い合わせ）',
                content: '本アプリに関するお問い合わせは、アプリストアのレビュー欄または開発者の連絡先までお願いいたします。',
              ),
              const SizedBox(height: AppTheme.spacing),
              Center(
                child: Text(
                  '最終更新日: 2025年10月6日',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingLarge),
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
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
          ),
          const SizedBox(height: AppTheme.spacing),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}
