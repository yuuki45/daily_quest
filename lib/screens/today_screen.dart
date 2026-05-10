import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:confetti/confetti.dart';
import 'package:tri_task/constants/app_constants.dart';
import 'package:tri_task/constants/app_theme.dart';
import 'package:tri_task/models/task.dart';
import 'package:tri_task/providers/daily_plan_provider.dart';
import 'package:tri_task/providers/task_provider.dart';
import 'package:tri_task/providers/subtitle_provider.dart';
import 'package:tri_task/widgets/plant_widget.dart';
import 'package:tri_task/widgets/plan_editor_sheet.dart';
import 'package:tri_task/widgets/task_card.dart';
import 'package:tri_task/widgets/task_edit_dialog.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _bannerController;
  late Animation<Offset> _bannerSlideAnimation;
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(milliseconds: 800));

    _bannerController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _bannerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _bannerController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  void _showCompletionBanner() {
    setState(() {
      _showBanner = true;
    });
    _bannerController.forward();

    // 2秒後に自動で消す
    Future.delayed(const Duration(seconds: 2), () {
      _bannerController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showBanner = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final todaysTasks = ref.watch(todaysTasksProvider);
    final mainTask = ref.watch(mainTaskProvider);
    final subTasks = ref.watch(subTasksProvider);
    final plantEmoji = ref.watch(plantEmojiProvider);
    final plan = ref.watch(dailyPlanNotifierProvider);
    final isComplete = ref.watch(isTodayCompleteProvider);

    // 完了したタスク数をカウント
    final completedCount = todaysTasks.where((task) => task.done).length;

    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLarge,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppTheme.spacing),

                      // Plant Widget with enhanced design
                      Center(
                        child: _buildPlantSection(plantEmoji, plan.streakCount, isComplete),
                      ),

                      // Plant stage explanation
                      Center(
                        child: _buildPlantStageExplanation(plan.streakCount),
                      ),

                      const SizedBox(height: AppTheme.spacingLarge * 2),

                      // Today's Tasks Header with cute design
                      _buildTasksHeader(context, ref, completedCount),

                      const SizedBox(height: AppTheme.spacingLarge),

                      // Main Task (目立たせる)
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
                          child: _buildMainTaskCard(context, ref, mainTask),
                        ),
                        const SizedBox(height: AppTheme.spacingLarge),
                      ],

                      // Sub Tasks
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
                              onToggle: () async {
                                await ref
                                    .read(taskNotifierProvider.notifier)
                                    .toggleTaskDone(task.id);
                              },
                              onLongPress: () => _showTaskOptions(context, ref, task, false),
                            ),
                          );
                        }),
                      ],

                      // Empty State
                      if (mainTask == null && subTasks.isEmpty)
                        _buildEmptyState(context),

                      // Share Button (always visible)
                      if (mainTask != null)
                        _buildShareButton(context, todaysTasks),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
          ),
          // Confetti アニメーション
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2, // 下向き
              emissionFrequency: 0.1,
              numberOfParticles: 15,
              maxBlastForce: 8,
              minBlastForce: 4,
              gravity: 0.4,
              colors: [
                AppTheme.primaryColor,
                AppTheme.secondaryColor,
                AppTheme.accentColor,
                Colors.yellow,
                Colors.green,
              ],
            ),
          ),
          // スライドイン通知バナー
          if (_showBanner)
            SlideTransition(
              position: _bannerSlideAnimation,
              child: SafeArea(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '🎉',
                          style: TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'よくできました！',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'メインタスク達成 🎊',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
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
              transitionAnimationController: AnimationController(
                vsync: Navigator.of(context),
                duration: const Duration(milliseconds: 400),
              ),
              builder: (context) => const PlanEditorSheet(),
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

  Widget _buildAppBar(BuildContext context) {
    final now = DateTime.now();
    final dateText = '${now.month}/${now.day}';
    final weekdayText = ['月', '火', '水', '木', '金', '土', '日'][now.weekday - 1];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLarge,
        vertical: AppTheme.spacing,
      ),
      child: Row(
        children: [
          // App Title with gradient
          Column(
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
                  'TriTask',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
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
          const SizedBox(width: AppTheme.spacing),
          // Subtitle text
          Expanded(
            child: Text(
              ref.watch(randomSubtitleProvider),
              style: TextStyle(
                color: AppTheme.textPrimary.withOpacity(0.7),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPlantSection(String plantEmoji, int streakCount, bool isComplete) {
    return PlantWidget(
      emoji: plantEmoji,
      streakCount: streakCount,
    );
  }

  Widget _buildPlantStageExplanation(int streakCount) {
    String stageName;
    int? daysToNext;

    if (streakCount < AppConstants.streakForSprout) {
      stageName = '種';
      daysToNext = AppConstants.streakForSprout - streakCount;
    } else if (streakCount < AppConstants.streakForBud) {
      stageName = '芽';
      daysToNext = AppConstants.streakForBud - streakCount;
    } else if (streakCount < AppConstants.streakForFlower) {
      stageName = 'つぼみ';
      daysToNext = AppConstants.streakForFlower - streakCount;
    } else if (streakCount < AppConstants.streakForBouquet) {
      stageName = '花';
      daysToNext = AppConstants.streakForBouquet - streakCount;
    } else {
      stageName = '花束';
      daysToNext = null; // 最終段階
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppTheme.spacing),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing,
          vertical: AppTheme.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          daysToNext != null
              ? '$stageName (${streakCount}日目) • あと${daysToNext}日で成長'
              : '$stageName (${streakCount}日目) • 最高段階達成！',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTasksHeader(BuildContext context, WidgetRef ref, int completedCount) {
    final mainTask = ref.watch(mainTaskProvider);
    final isMainComplete = mainTask?.done ?? false;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '今日のタスク',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (isMainComplete)
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                  if (isMainComplete) const SizedBox(width: 4),
                  Text(
                    isMainComplete ? 'メインタスク達成！' : 'メインタスクを完了させよう',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isMainComplete
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondary,
                          fontWeight: isMainComplete
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Progress indicator
        if (completedCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
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
                  Icons.task_alt,
                  size: 18,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  '$completedCount完了',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMainTaskCard(BuildContext context, WidgetRef ref, Task task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "必ずやる" バッジ
        Row(
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
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 18,
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
        const SizedBox(height: AppTheme.spacingSmall),
        // タスクカード
        TaskCard(
          task: task,
          onToggle: () async {
            final wasNotDone = !task.done;
            await ref
                .read(taskNotifierProvider.notifier)
                .toggleTaskDone(task.id);
            await ref
                .read(dailyPlanNotifierProvider.notifier)
                .checkCompletion();

            // メインタスクを完了した時にアニメーションを再生
            if (wasNotDone) {
              _confettiController.play();
              _showCompletionBanner();
            }
          },
          onLongPress: () => _showTaskOptions(context, ref, task, true),
        ),
        // ストリーク動作の説明
        if (task.done)
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
                    'ストリークは1日1回のみカウントされます',
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
                Icons.playlist_add_rounded,
                size: 80,
                color: AppTheme.primaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            Text(
              'さあ、始めましょう！',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              '今日の3つのタスクを設定して\n目標を達成しましょう',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            // FABへのヒント
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


  Widget _buildShareButton(BuildContext context, List todaysTasks) {
    return Padding(
      padding: const EdgeInsets.only(top: AppTheme.spacingLarge),
      child: Column(
        children: [
          Text(
            'Xで今日のタスクを宣言しよう！',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppTheme.spacing),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.secondaryColor,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  // 軽い振動フィードバック
                  HapticFeedback.lightImpact();

                  final plan = ref.read(dailyPlanNotifierProvider);
                  final mainTask = ref.read(mainTaskProvider);
                  final subTasks = ref.read(subTasksProvider);

                  if (mainTask == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('メインタスクを設定してください'),
                        backgroundColor: AppTheme.accentColor,
                      ),
                    );
                    return;
                  }

                  final plantEmoji = AppConstants.getPlantEmoji(plan.streakCount);
                  final subTaskTitles = subTasks.map((t) => t.title).toList();
                  final shareText = AppConstants.getXShareText(
                    mainTask.title,
                    subTaskTitles,
                    plan.streakCount,
                    plantEmoji,
                  );

                  final encodedText = Uri.encodeComponent(shareText);
                  final xUrl = Uri.parse('https://twitter.com/intent/tweet?text=$encodedText');

                  if (await canLaunchUrl(xUrl)) {
                    await launchUrl(xUrl, mode: LaunchMode.externalApplication);
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Xアプリを開けませんでした'),
                          backgroundColor: AppTheme.accentColor,
                        ),
                      );
                    }
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.share_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Xでシェア',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
                      await ref.read(dailyPlanNotifierProvider.notifier).setMainTask(null);
                    } else {
                      await ref.read(dailyPlanNotifierProvider.notifier).removeSubTask(task.id);
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
