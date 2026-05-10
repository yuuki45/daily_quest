import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/constants/app_theme.dart';
import 'package:tri_task/models/task.dart';
import 'package:tri_task/providers/daily_plan_provider.dart';
import 'package:tri_task/providers/task_provider.dart';
import 'package:tri_task/widgets/tomorrow_plan_editor_sheet.dart';
import 'package:tri_task/widgets/task_card.dart';
import 'package:tri_task/widgets/task_edit_dialog.dart';

class TomorrowScreen extends ConsumerWidget {
  const TomorrowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tomorrowPlan = ref.watch(tomorrowPlanProvider);
    final mainTask = ref.watch(tomorrowMainTaskProvider);
    final subTasks = ref.watch(tomorrowSubTasksProvider);

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

                      // 説明テキスト
                      Text(
                        '明日のタスクを設定しましょう',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textPrimary.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacing),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: AppTheme.spacingSmall),
                            Expanded(
                              child: Text(
                                '明日になると自動的に今日のタスクに移動します',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textPrimary,
                                      height: 1.4,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingLarge * 2),

                      // メインタスク
                      if (mainTask != null) ...[
                        TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 400),
                          tween: Tween<double>(begin: 0, end: 1),
                          curve: Curves.easeOutCubic,
                          builder: (context, double value, child) {
                            return Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppTheme.spacing,
                                        vertical: AppTheme.spacingSmall,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppTheme.primaryColor,
                                            AppTheme.secondaryColor,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '必ずやること',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TaskCard(
                                task: mainTask,
                                showCheckbox: false,
                                onLongPress: () => _showTaskOptions(context, ref, mainTask, true),
                              ),
                              // チェックボックス非表示の説明
                              Padding(
                                padding: const EdgeInsets.only(top: AppTheme.spacingSmall),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 14,
                                      color: AppTheme.textSecondary.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '明日になると自動的に今日のタスクに反映されます',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.textSecondary.withOpacity(0.7),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingLarge),
                      ],

                      // サブタスク
                      if (subTasks.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.spacing),
                          child: Text(
                            'サブタスク（任意）',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        ...subTasks.asMap().entries.map((entry) {
                          final index = entry.key;
                          final task = entry.value;
                          return TweenAnimationBuilder(
                            duration: Duration(milliseconds: 300 + (index * 100)),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: TaskCard(
                              task: task,
                              showCheckbox: false,
                              onLongPress: () => _showTaskOptions(context, ref, task, false),
                            ),
                          );
                        }),
                      ],

                      // 空の状態
                      if (mainTask == null && subTasks.isEmpty)
                        _buildEmptyState(context),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor,
              AppTheme.secondaryColor,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const TomorrowPlanEditorSheet(),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final dateText = '${tomorrow.month}/${tomorrow.day}';
    final weekdayText = ['月', '火', '水', '木', '金', '土', '日'][tomorrow.weekday - 1];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLarge,
        vertical: AppTheme.spacing,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.secondaryColor,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    '明日の予定',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$dateText ($weekdayText)',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLarge * 2),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.secondaryColor.withOpacity(0.1),
                  ],
                ),
              ),
              child: Icon(
                Icons.event_available_rounded,
                size: 80,
                color: AppTheme.primaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            Text(
              '明日のタスクを設定して、準備万端で1日を始めましょう',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textPrimary.withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            // タスク追加ボタンへのヒント
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing,
                vertical: AppTheme.spacingSmall,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.15),
                    AppTheme.secondaryColor.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_downward,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      '右下ボタンからタスク追加',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showTaskOptions(BuildContext context, WidgetRef ref, Task task, bool isMainTask) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.borderRadius),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppTheme.spacingSmall),
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppTheme.spacing),

              // Edit option
              ListTile(
                leading: Icon(Icons.edit_rounded, color: AppTheme.primaryColor),
                title: Text(
                  '編集',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) => TaskEditDialog(task: task),
                  );
                  if (result != null) {
                    final updatedTask = task.copyWith(
                      title: result['title'] as String,
                      tag: result['tag'] as String?,
                    );
                    await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
                  }
                },
              ),

              // Delete option
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: AppTheme.accentColor),
                title: Text(
                  '削除',
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppTheme.backgroundColor,
                      title: Text(
                        'タスクを削除',
                        style: TextStyle(color: AppTheme.textPrimary),
                      ),
                      content: Text(
                        'このタスクを削除してもよろしいですか？',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            'キャンセル',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context, true);
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

                  if (confirm == true) {
                    // プランから削除
                    if (isMainTask) {
                      await ref.read(tomorrowPlanNotifierProvider.notifier).setMainTask(null);
                    } else {
                      await ref.read(tomorrowPlanNotifierProvider.notifier).removeSubTask(task.id);
                    }
                    // タスク自体を削除
                    await ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
                  }
                },
              ),
              const SizedBox(height: AppTheme.spacing),
            ],
          ),
        ),
      ),
    );
  }
}
