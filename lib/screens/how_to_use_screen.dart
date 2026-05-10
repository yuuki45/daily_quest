import 'package:flutter/material.dart';
import 'package:tri_task/constants/app_theme.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              // ヘッダー
              _buildHeader(context),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLarge,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppTheme.spacing),

                      // アプリの概要
                      _buildSectionCard(
                        context,
                        icon: Icons.rocket_launch_rounded,
                        title: 'TriTaskとは',
                        description: '毎日3つのタスクに集中することで、継続的な習慣化をサポートするアプリです。',
                        gradient: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                        ],
                      ),

                      const SizedBox(height: AppTheme.spacingLarge),

                      // 基本的な使い方
                      Text(
                        '基本的な使い方',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacing),

                      _buildFeatureItem(
                        context,
                        number: '1',
                        icon: Icons.star_rounded,
                        title: 'メインタスク（必須）',
                        description: '今日必ずやることを1つ設定します。\nこのタスクを完了するとストリークがカウントされます。',
                        color: AppTheme.primaryColor,
                      ),

                      _buildFeatureItem(
                        context,
                        number: '2',
                        icon: Icons.playlist_add_check_rounded,
                        title: 'サブタスク（任意）',
                        description: '余裕があればやりたいことを最大2つ設定できます。\nストリークには影響しません。',
                        color: AppTheme.primaryColor,
                      ),

                      _buildFeatureItem(
                        context,
                        number: '3',
                        icon: Icons.check_circle_rounded,
                        title: 'タスクの完了',
                        description: 'タスクをタップしてチェックを入れると完了になります。\nメインタスクを完了すると達成アニメーションが表示されます。',
                        color: AppTheme.primaryColor,
                      ),

                      _buildFeatureItem(
                        context,
                        number: '4',
                        icon: Icons.add_circle_rounded,
                        title: 'タスクの追加',
                        description: '右下のボタン（FAB）をタップすると、新しいタスクを追加できます。\nメインタスクとサブタスクを選択して追加しましょう。',
                        color: AppTheme.primaryColor,
                      ),

                      _buildFeatureItem(
                        context,
                        number: '5',
                        icon: Icons.edit_rounded,
                        title: 'タスクの編集・削除',
                        description: 'タスクを長押しすると、編集や削除ができます。\nタイトルやカテゴリーの変更が可能です。',
                        color: AppTheme.primaryColor,
                      ),

                      const SizedBox(height: AppTheme.spacingLarge * 2),

                      // ストリーク機能
                      Text(
                        'ストリーク機能',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacing),

                      _buildStreakExplanation(context),

                      const SizedBox(height: AppTheme.spacingLarge * 2),

                      // 明日の予定
                      Text(
                        '明日の予定',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacing),

                      _buildSectionCard(
                        context,
                        icon: Icons.calendar_month_rounded,
                        title: '明日のタスクを事前設定',
                        description: '画面下部の「明日」タブから、明日のタスクを事前に設定できます。\n日付が変わると自動的に今日のタスクに反映されます。',
                        gradient: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                        ],
                      ),

                      const SizedBox(height: AppTheme.spacingLarge * 2),

                      // 統計機能
                      Text(
                        '統計機能',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacing),

                      _buildSectionCard(
                        context,
                        icon: Icons.bar_chart_rounded,
                        title: '達成状況を確認',
                        description: '画面下部の「統計」タブから、達成率やストリーク数を確認できます。\n過去のタスク履歴をカレンダー形式で表示し、全期間・週間・月間の切り替えが可能です。',
                        gradient: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                        ],
                      ),

                      const SizedBox(height: AppTheme.spacingLarge * 2),

                      // 通知機能
                      Text(
                        '通知機能',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacing),

                      _buildNotificationExplanation(context),

                      const SizedBox(height: AppTheme.spacingLarge * 2),

                      // Tips
                      Text(
                        '効果的な使い方のコツ',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacing),

                      _buildTipsCard(
                        context,
                        tips: [
                          '朝、その日のメインタスクを1つだけ決める',
                          '小さな達成を積み重ねてストリークを伸ばす',
                          '夜、明日のタスクを設定して準備万端に',
                          'カテゴリーを使って生活のバランスを意識する',
                          '30日継続を目標に、習慣化を目指す',
                        ],
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLarge,
        vertical: AppTheme.spacing,
      ),
      child: Row(
        children: [
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.secondaryColor,
                ],
              ).createShader(bounds),
              child: Text(
                '使い方',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
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

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient.map((c) => c.withOpacity(0.1)).toList(),
        ),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: gradient.first.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: AppTheme.spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required String number,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakExplanation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'メインタスクを完了すると、ストリークがカウントされます。\n連続達成日数に応じて植物が成長します。',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          _buildStreakStage('1日目', '🌱', '種を植えよう'),
          _buildStreakStage('3日目', '🌿', '新芽が出たよ'),
          _buildStreakStage('7日目', '🌼', 'つぼみができました'),
          _buildStreakStage('14日目', '🌸', '花が咲きました'),
          _buildStreakStage('30日目', '💐', '満開の花！'),
          const SizedBox(height: AppTheme.spacing),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ストリークは1日1回のみカウントされます',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakStage(String day, String emoji, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationExplanation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active_rounded,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingSmall),
              Text(
                '21:00に通知',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing),
          Text(
            '明日のメインタスクが未設定の場合、毎日21:00に通知が届きます。\nメインタスクを設定すると通知はキャンセルされます。',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context, {required List<String> tips}) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cardColor,
            AppTheme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tips.map((tip) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacing),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing),
                Expanded(
                  child: Text(
                    tip,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          height: 1.5,
                        ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
