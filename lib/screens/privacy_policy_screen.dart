import 'package:flutter/material.dart';
import 'package:tri_task/constants/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー'),
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
                title: '基本方針',
                content: '本アプリケーション「TriTask」（以下「本アプリ」といいます）は、利用者のプライバシーを尊重し、個人情報の保護に最大限の注意を払います。本プライバシーポリシーは、本アプリにおける個人情報の取り扱いについて説明するものです。',
              ),
              _buildSection(
                context,
                title: '個人情報の収集について',
                content: '本アプリは、利用者の個人情報を一切収集しません。\n\n本アプリでは以下のような情報も収集しません：\n• 氏名、メールアドレス、電話番号などの個人を識別できる情報\n• 位置情報\n• デバイス情報\n• 利用状況や行動履歴\n• その他一切の個人情報',
              ),
              _buildSection(
                context,
                title: 'データの保存について',
                content: '本アプリで作成・管理されるすべてのデータ（タスク、達成履歴、設定情報など）は、利用者の端末内にのみ保存されます。\n\nこれらのデータは：\n• 外部サーバーへ送信されることはありません\n• 開発者がアクセスすることはできません\n• 利用者の端末からのみアクセス可能です\n• アプリを削除すると完全に消去されます',
              ),
              _buildSection(
                context,
                title: '第三者への情報提供',
                content: '本アプリは、利用者の情報を第三者に提供、開示、共有することは一切ありません。',
              ),
              _buildSection(
                context,
                title: '通知機能について',
                content: '本アプリは、タスク設定のリマインダーとして通知機能を使用します。\n\n通知機能について：\n• 通知は端末のローカル機能を使用して送信されます\n• 通知の送信にあたり、個人情報が外部に送信されることはありません\n• 通知設定は端末の設定からいつでも変更できます',
              ),
              _buildSection(
                context,
                title: 'アクセス解析ツール',
                content: '本アプリは、Google Analyticsやその他のアクセス解析ツールを使用していません。利用者の行動を追跡することはありません。',
              ),
              _buildSection(
                context,
                title: '広告について',
                content: '本アプリには広告が表示されません。第三者の広告ネットワークによる情報収集も行われません。',
              ),
              _buildSection(
                context,
                title: 'Cookie（クッキー）について',
                content: '本アプリはCookieを使用しません。',
              ),
              _buildSection(
                context,
                title: 'お子様の個人情報',
                content: '本アプリは個人情報を収集しないため、お子様の個人情報が収集されることもありません。安心してご利用いただけます。',
              ),
              _buildSection(
                context,
                title: 'データのバックアップと復元',
                content: '本アプリのデータは端末内にのみ保存されるため、開発者側でバックアップを保持することはできません。\n\n重要な注意点：\n• アプリを削除するとすべてのデータが失われます\n• 端末の初期化やリセットでデータが消去されます\n• 機種変更時のデータ移行はサポートされていません\n\n大切なデータは利用者自身で管理していただくようお願いいたします。',
              ),
              _buildSection(
                context,
                title: 'セキュリティ',
                content: '本アプリのデータは端末内にのみ保存されるため、端末のセキュリティ設定に依存します。端末のロック機能やセキュリティ設定を適切に管理することをお勧めします。',
              ),
              _buildSection(
                context,
                title: 'プライバシーポリシーの変更',
                content: '本プライバシーポリシーの内容は、法令の変更やサービス内容の変更に伴い、予告なく変更される場合があります。変更後のプライバシーポリシーは、アプリ内に掲示された時点で効力を生じるものとします。',
              ),
              _buildSection(
                context,
                title: 'お問い合わせ',
                content: '本プライバシーポリシーに関するお問い合わせは、設定画面の「お問い合わせ」からご連絡ください。',
              ),
              const SizedBox(height: AppTheme.spacing),
              Center(
                child: Text(
                  '最終更新日: 2025年10月12日',
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
