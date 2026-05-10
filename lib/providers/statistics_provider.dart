import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tri_task/models/daily_plan.dart';
import 'package:tri_task/services/hive_service.dart';

part 'statistics_provider.g.dart';

// 統計データモデル
class Statistics {
  final int totalDays; // 総日数
  final int completedDays; // 完了した日数
  final int currentStreak; // 現在のストリーク
  final int maxStreak; // 最大ストリーク
  final double completionRate; // 達成率
  final List<DailyPlan> recentPlans; // 最近のプラン（30日分）

  Statistics({
    required this.totalDays,
    required this.completedDays,
    required this.currentStreak,
    required this.maxStreak,
    required this.completionRate,
    required this.recentPlans,
  });
}

// 統計データプロバイダー
@riverpod
Statistics statistics(Ref ref) {
  final allPlans = HiveService.getAllDailyPlans();

  // 日付でソート（古い順）
  final sortedPlans = allPlans.toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  // 明日のデータのみ除外（今日と過去のデータを含む）
  final today = DateTime.now();
  final tomorrow = today.add(const Duration(days: 1));
  final tomorrowString = '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';

  final historyPlans = sortedPlans.where((plan) => plan.date != tomorrowString).toList();

  // 総日数と完了日数
  final totalDays = historyPlans.length;
  final completedDays = historyPlans.where((plan) => plan.completedMain).length;

  // 達成率
  final completionRate = totalDays > 0 ? (completedDays / totalDays) * 100 : 0.0;

  // 現在のストリーク（今日のプランから取得）
  final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  final todayPlan = historyPlans.where((p) => p.date == todayString).firstOrNull;
  final currentStreak = todayPlan?.streakCount ?? 0;

  // 最大ストリーク
  final maxStreak = historyPlans.isEmpty
    ? 0
    : historyPlans.map((p) => p.streakCount).reduce((a, b) => a > b ? a : b);

  // 最近30日分のプラン
  final recentPlans = historyPlans.reversed.take(30).toList();

  return Statistics(
    totalDays: totalDays,
    completedDays: completedDays,
    currentStreak: currentStreak,
    maxStreak: maxStreak,
    completionRate: completionRate,
    recentPlans: recentPlans,
  );
}

// 週間統計（今週：月曜日〜今日）
@riverpod
Statistics weeklyStatistics(Ref ref) {
  final allPlans = HiveService.getAllDailyPlans();

  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);

  // 今週の月曜日を計算（weekday: 1=月, 7=日）
  final weekday = today.weekday; // 1-7
  final mondayThisWeek = todayStart.subtract(Duration(days: weekday - 1));

  // 今週のプランを取得（月曜日〜今日）
  final weekPlans = allPlans.where((plan) {
    final planDate = DateTime.parse(plan.date);
    final planDateStart = DateTime(planDate.year, planDate.month, planDate.day);
    return (planDateStart.isAfter(mondayThisWeek) || planDateStart.isAtSameMomentAs(mondayThisWeek)) &&
           (planDateStart.isBefore(todayStart) || planDateStart.isAtSameMomentAs(todayStart));
  }).toList();

  final totalDays = weekPlans.length;
  final completedDays = weekPlans.where((plan) => plan.completedMain).length;
  final completionRate = totalDays > 0 ? (completedDays / totalDays) * 100 : 0.0;

  // 現在のストリーク（今日のプランから取得）
  final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  final todayPlan = weekPlans.where((p) => p.date == todayString).firstOrNull;
  final currentStreak = todayPlan?.streakCount ?? 0;

  // 最大ストリーク
  final maxStreak = weekPlans.isEmpty
      ? 0
      : weekPlans.map((p) => p.streakCount).reduce((a, b) => a > b ? a : b);

  return Statistics(
    totalDays: totalDays,
    completedDays: completedDays,
    currentStreak: currentStreak,
    maxStreak: maxStreak,
    completionRate: completionRate,
    recentPlans: weekPlans,
  );
}

// 月間統計（今月：1日〜今日）
@riverpod
Statistics monthlyStatistics(Ref ref) {
  final allPlans = HiveService.getAllDailyPlans();

  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);

  // 今月の1日を計算
  final firstDayOfMonth = DateTime(today.year, today.month, 1);

  // 今月のプランを取得（1日〜今日）
  final monthPlans = allPlans.where((plan) {
    final planDate = DateTime.parse(plan.date);
    final planDateStart = DateTime(planDate.year, planDate.month, planDate.day);
    return (planDateStart.isAfter(firstDayOfMonth) || planDateStart.isAtSameMomentAs(firstDayOfMonth)) &&
           (planDateStart.isBefore(todayStart) || planDateStart.isAtSameMomentAs(todayStart));
  }).toList();

  final totalDays = monthPlans.length;
  final completedDays = monthPlans.where((plan) => plan.completedMain).length;
  final completionRate = totalDays > 0 ? (completedDays / totalDays) * 100 : 0.0;

  // 現在のストリーク（今日のプランから取得）
  final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  final todayPlan = monthPlans.where((p) => p.date == todayString).firstOrNull;
  final currentStreak = todayPlan?.streakCount ?? 0;

  // 最大ストリーク
  final maxStreak = monthPlans.isEmpty
      ? 0
      : monthPlans.map((p) => p.streakCount).reduce((a, b) => a > b ? a : b);

  return Statistics(
    totalDays: totalDays,
    completedDays: completedDays,
    currentStreak: currentStreak,
    maxStreak: maxStreak,
    completionRate: completionRate,
    recentPlans: monthPlans,
  );
}
