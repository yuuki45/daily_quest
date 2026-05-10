import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/constants/app_theme.dart';
import 'package:tri_task/providers/statistics_provider.dart';
import 'package:tri_task/models/daily_plan.dart';
import 'package:tri_task/models/task.dart';
import 'package:tri_task/services/hive_service.dart';
import 'package:tri_task/providers/task_provider.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  int _selectedPeriod = 0; // 0: 全期間, 1: 週間, 2: 月間

  @override
  Widget build(BuildContext context) {
    final stats = _selectedPeriod == 0
        ? ref.watch(statisticsProvider)
        : _selectedPeriod == 1
            ? ref.watch(weeklyStatisticsProvider)
            : ref.watch(monthlyStatisticsProvider);

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
              _buildHeader(context),
              _buildPeriodSelector(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsCards(stats),
                      const SizedBox(height: AppTheme.spacingLarge),
                      _buildCalendarView(stats.recentPlans),
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
                '統計',
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

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
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
          _buildPeriodButton('全期間', 0),
          _buildPeriodButton('週間', 1),
          _buildPeriodButton('月間', 2),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String label, int index) {
    final isSelected = _selectedPeriod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.secondaryColor,
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(Statistics stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '達成率',
                '${stats.completionRate.toStringAsFixed(1)}%',
                Icons.trending_up,
                AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: AppTheme.spacing),
            Expanded(
              child: _buildStatCard(
                '完了日数',
                '${stats.completedDays}/${stats.totalDays}',
                Icons.check_circle,
                AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '現在のストリーク',
                '${stats.currentStreak}日',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ),
            const SizedBox(width: AppTheme.spacing),
            Expanded(
              child: _buildStatCard(
                '最大ストリーク',
                '${stats.maxStreak}日',
                Icons.star,
                Colors.amber,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(List<DailyPlan> plans) {
    if (plans.isEmpty) {
      return _buildEmptyState();
    }

    // 期間に応じたサブタイトルを設定
    String subtitle;
    switch (_selectedPeriod) {
      case 1: // 週間
        subtitle = '今週の達成状況（月曜〜今日）';
        break;
      case 2: // 月間
        subtitle = '今月の達成状況（1日〜今日）';
        break;
      default: // 全期間
        subtitle = '今月の達成状況';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '達成カレンダー',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        const SizedBox(height: AppTheme.spacing),
        Container(
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
          child: _selectedPeriod == 1
              ? _buildWeekCalendar(plans)
              : _buildHeatmap(plans),
        ),
      ],
    );
  }

  Widget _buildWeekCalendar(List<DailyPlan> plans) {
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    // 今週の月曜日を計算
    final weekday = today.weekday; // 1-7
    final mondayThisWeek = todayDateOnly.subtract(Duration(days: weekday - 1));

    // プランをマップに変換
    final Map<String, DailyPlan?> planMap = {};
    for (final plan in plans) {
      planMap[plan.date] = plan;
    }

    return Column(
      children: [
        // 曜日ラベル
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['月', '火', '水', '木', '金', '土', '日']
              .map((day) => SizedBox(
                    width: 36,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        // 今週の7日間（月〜日）
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final date = mondayThisWeek.add(Duration(days: index));
            final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            final plan = planMap[dateString];
            final hasTask = plan?.mainTaskId != null;
            final isCompleted = plan?.completedMain ?? false;
            final isFuture = date.isAfter(todayDateOnly);

            return _buildHeatmapCell(date, hasTask, isCompleted, isFuture);
          }),
        ),
        const SizedBox(height: AppTheme.spacing),
        // 凡例
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('未設定', AppTheme.textSecondary.withOpacity(0.15)),
            const SizedBox(width: AppTheme.spacing),
            _buildLegendItem('未達成', Colors.orange.withOpacity(0.3)),
            const SizedBox(width: AppTheme.spacing),
            _buildLegendItem('達成', AppTheme.primaryColor),
          ],
        ),
      ],
    );
  }

  Widget _buildHeatmap(List<DailyPlan> plans) {
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    final currentYear = today.year;
    final currentMonth = today.month;

    // 今月の1日と最終日を取得
    final firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
    final lastDayOfMonth = DateTime(currentYear, currentMonth + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // プランをマップに変換
    final Map<String, DailyPlan?> planMap = {};
    for (final plan in plans) {
      planMap[plan.date] = plan;
    }

    // 月の最初の日の曜日（月曜=1, 日曜=7）
    final firstWeekday = firstDayOfMonth.weekday;

    // カレンダーの開始位置（月曜始まりで調整）
    final startOffset = firstWeekday - 1; // 月曜=0, 日曜=6

    // 必要な週数を計算
    final totalCells = startOffset + daysInMonth;
    final weeksNeeded = (totalCells / 7).ceil();

    return Column(
      children: [
        // 曜日ラベル
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['月', '火', '水', '木', '金', '土', '日']
              .map((day) => SizedBox(
                    width: 36,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        // カレンダーグリッド
        ...List.generate(weeksNeeded, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                final cellIndex = weekIndex * 7 + dayIndex;

                // 月の開始前または終了後のセル
                if (cellIndex < startOffset || cellIndex >= startOffset + daysInMonth) {
                  return const SizedBox(width: 36, height: 36);
                }

                // 実際の日付を計算
                final day = cellIndex - startOffset + 1;
                final date = DateTime(currentYear, currentMonth, day);
                final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                final plan = planMap[dateString];
                final hasTask = plan?.mainTaskId != null;
                final isCompleted = plan?.completedMain ?? false;
                final isFuture = date.isAfter(todayDateOnly);

                return _buildHeatmapCell(date, hasTask, isCompleted, isFuture);
              }),
            ),
          );
        }),
        const SizedBox(height: AppTheme.spacing),
        // 凡例
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('未設定', AppTheme.textSecondary.withOpacity(0.15)),
            const SizedBox(width: AppTheme.spacing),
            _buildLegendItem('未達成', Colors.orange.withOpacity(0.3)),
            const SizedBox(width: AppTheme.spacing),
            _buildLegendItem('達成', AppTheme.primaryColor),
          ],
        ),
      ],
    );
  }

  Widget _buildHeatmapCell(DateTime date, bool hasTask, bool isCompleted, bool isFuture) {
    // 色を決定
    Color cellColor;
    Color textColor;

    if (isFuture) {
      // 未来の日付
      cellColor = AppTheme.backgroundColor;
      textColor = AppTheme.textSecondary.withOpacity(0.3);
    } else if (isCompleted) {
      // タスク達成
      cellColor = AppTheme.primaryColor;
      textColor = Colors.white;
    } else if (hasTask) {
      // タスク設定済みだが未達成
      cellColor = Colors.orange.withOpacity(0.3);
      textColor = AppTheme.textPrimary;
    } else {
      // タスク未設定
      cellColor = AppTheme.textSecondary.withOpacity(0.15);
      textColor = AppTheme.textSecondary.withOpacity(0.5);
    }

    return GestureDetector(
      onTap: () => _showDayDetail(date, hasTask, isCompleted),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppTheme.backgroundColor,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  void _showDayDetail(DateTime date, bool hasTask, bool isCompleted) {
    // 未来の日付はタップ不可
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    if (date.isAfter(todayDateOnly)) {
      return;
    }

    // 該当日のDailyPlanを取得
    final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final plan = HiveService.getDailyPlan(dateString);

    // タスク情報を取得
    final allTasks = ref.read(taskNotifierProvider);
    final mainTask = plan?.mainTaskId != null
        ? allTasks.where((t) => t.id == plan!.mainTaskId).firstOrNull
        : null;
    final subTasks = plan?.subTaskIds
        .map((id) => allTasks.where((t) => t.id == id).firstOrNull)
        .whereType<Task>()
        .toList() ?? [];

    // 状態メッセージを作成
    String statusMessage;
    IconData statusIcon;
    Color statusColor;

    if (isCompleted) {
      statusMessage = 'メインタスクを達成しました！';
      statusIcon = Icons.check_circle;
      statusColor = AppTheme.primaryColor;
    } else if (hasTask) {
      statusMessage = 'メインタスクが未達成です';
      statusIcon = Icons.cancel;
      statusColor = Colors.orange;
    } else {
      statusMessage = 'タスクが設定されていません';
      statusIcon = Icons.info_outline;
      statusColor = AppTheme.textSecondary;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        title: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 28),
            const SizedBox(width: 12),
            Text(
              '${date.month}月${date.day}日',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statusMessage,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
              ),
            ),
            if (mainTask != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'メインタスク',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    mainTask.done ? Icons.check_circle : Icons.circle_outlined,
                    size: 20,
                    color: mainTask.done ? AppTheme.primaryColor : AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mainTask.title,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        decoration: mainTask.done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (subTasks.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'サブタスク',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...subTasks.map((Task task) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      task.done ? Icons.check_circle : Icons.circle_outlined,
                      size: 18,
                      color: task.done ? AppTheme.primaryColor : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          decoration: task.done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '閉じる',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLarge * 2),
        child: Column(
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 80,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppTheme.spacing),
            Text(
              'データがありません',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              'タスクを完了すると統計が表示されます',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
