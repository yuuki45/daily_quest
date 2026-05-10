import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tri_task/constants/app_constants.dart';
import 'package:tri_task/models/daily_plan.dart';
import 'package:tri_task/models/task.dart';
import 'package:tri_task/providers/task_provider.dart';
import 'package:tri_task/services/hive_service.dart';
import 'package:tri_task/services/notification_service.dart';
import 'package:tri_task/utils/date_helper.dart';

part 'daily_plan_provider.g.dart';

@riverpod
class DailyPlanNotifier extends _$DailyPlanNotifier {
  @override
  DailyPlan build() {
    // 今日のプランを取得、なければ新規作成
    final today = DateHelper.getTodayString();
    final existingPlan = HiveService.getDailyPlan(today);

    // 既に今日のプランが存在し、かつcompletedMainフラグが設定されている場合は
    // 既にストリークが正しく計算されているのでそのまま返す
    if (existingPlan != null && existingPlan.completedMain) {
      return existingPlan;
    }

    // 昨日の日付
    final yesterday = DateHelper.formatDate(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    final yesterdayPlan = HiveService.getDailyPlan(yesterday);

    // 前日のStreakを引き継ぐ
    // 昨日メインタスクを完了していればストリーク継続、未完了なら0にリセット
    final previousStreak =
        yesterdayPlan?.completedMain == true ? yesterdayPlan!.streakCount : 0;

    // 既存のプランがある場合（明日の予定として作成されたプラン）
    if (existingPlan != null) {
      // ストリーク数を更新して保存
      final updatedPlan = existingPlan.copyWith(
        streakCount: previousStreak,
        completedMain: false, // 新しい日なのでリセット
      );
      HiveService.saveDailyPlan(updatedPlan);
      return updatedPlan;
    }

    // 新規プラン作成
    return DailyPlan(
      date: today,
      streakCount: previousStreak,
    );
  }

  // メインタスクを設定
  Future<void> setMainTask(String? taskId) async {
    final updatedPlan = state.copyWith(mainTaskId: taskId);
    await HiveService.saveDailyPlan(updatedPlan);
    state = updatedPlan;
  }

  // サブタスクを追加
  Future<void> addSubTask(String taskId) async {
    if (state.subTaskIds.length >= AppConstants.maxSubTasks) {
      throw Exception('Maximum ${AppConstants.maxSubTasks} sub tasks allowed');
    }

    if (state.subTaskIds.contains(taskId)) {
      return; // すでに追加済み
    }

    final updatedPlan = state.copyWith(
      subTaskIds: [...state.subTaskIds, taskId],
    );

    await HiveService.saveDailyPlan(updatedPlan);
    state = updatedPlan;
  }

  // サブタスクを削除
  Future<void> removeSubTask(String taskId) async {
    final updatedPlan = state.copyWith(
      subTaskIds: state.subTaskIds.where((id) => id != taskId).toList(),
    );

    await HiveService.saveDailyPlan(updatedPlan);
    state = updatedPlan;
  }

  // タスクの完了状態をチェックして、メインタスク完了ならStreakを更新
  Future<void> checkCompletion() async {
    print('🔍 checkCompletion 呼び出し');

    if (state.mainTaskId == null) {
      print('⚠️ メインタスクIDがnull');
      return; // メインタスクがない
    }

    final tasks = ref.read(taskNotifierProvider);
    final mainTask = tasks.where((t) => t.id == state.mainTaskId).firstOrNull;

    if (mainTask == null) {
      print('⚠️ メインタスクが見つからない');
      return;
    }

    final mainCompleted = mainTask.done;
    print('📊 状態: mainCompleted=$mainCompleted, completedMain=${state.completedMain}, streakCount=${state.streakCount}');

    if (mainCompleted && !state.completedMain) {
      // 初めてメインタスクを完了した（1日1回のみストリークを増やす）
      final newStreakCount = state.streakCount + 1;
      final newPlantStage = AppConstants.getPlantStage(newStreakCount);

      final updatedPlan = state.copyWith(
        completedMain: true,
        streakCount: newStreakCount,
        plantStage: newPlantStage,
      );

      await HiveService.saveDailyPlan(updatedPlan);
      state = updatedPlan;

      print('✅ ストリーク更新: $newStreakCount (今日は完了済み)');
    } else if (mainCompleted && state.completedMain) {
      print('ℹ️ すでに今日のストリークはカウント済みです (ストリーク: ${state.streakCount})');
    } else if (!mainCompleted && state.completedMain) {
      // メインタスクの完了が解除されても、completedMainフラグは維持する
      // これにより、同じ日に何度トグルしてもストリークは1回のみカウントされる
      print('⚠️ メインタスクの完了を解除しましたが、ストリークフラグは維持されます (ストリーク: ${state.streakCount})');
    } else {
      print('🤔 条件に該当しない状態');
    }
  }

  // Streakをリセット
  Future<void> resetStreak() async {
    final updatedPlan = state.copyWith(
      streakCount: 0,
      plantStage: AppConstants.plantStageSeed,
    );

    await HiveService.saveDailyPlan(updatedPlan);
    state = updatedPlan;
  }
}

// 今日のメインタスクを取得
@riverpod
Task? mainTask(Ref ref) {
  final plan = ref.watch(dailyPlanNotifierProvider);
  if (plan.mainTaskId == null) return null;

  final tasks = ref.watch(taskNotifierProvider);
  return tasks.where((t) => t.id == plan.mainTaskId).firstOrNull;
}

// 今日のサブタスクリストを取得
@riverpod
List<Task> subTasks(Ref ref) {
  final plan = ref.watch(dailyPlanNotifierProvider);
  final tasks = ref.watch(taskNotifierProvider);

  return plan.subTaskIds
      .map((id) => tasks.where((t) => t.id == id).firstOrNull)
      .whereType<Task>()
      .toList();
}

// 今日のタスク全て（メイン + サブ）を取得
@riverpod
List<Task> todaysTasks(Ref ref) {
  final mainTask = ref.watch(mainTaskProvider);
  final subTasks = ref.watch(subTasksProvider);

  return [
    if (mainTask != null) mainTask,
    ...subTasks,
  ];
}

// 植物の絵文字を取得
@riverpod
String plantEmoji(Ref ref) {
  final plan = ref.watch(dailyPlanNotifierProvider);
  return AppConstants.getPlantEmoji(plan.streakCount);
}

// 今日のプランが完了しているかチェック（メインタスクのみ）
@riverpod
bool isTodayComplete(Ref ref) {
  final plan = ref.watch(dailyPlanNotifierProvider);
  return plan.completedMain;
}

// ========== 明日のプラン関連 ==========

// 明日のプラン管理
@riverpod
class TomorrowPlanNotifier extends _$TomorrowPlanNotifier {
  @override
  DailyPlan build() {
    // 古いID: 0の通知を削除（初回のみ）
    NotificationService.cancelNotification(0);

    // 明日のプランを取得、なければ新規作成
    final tomorrow = DateHelper.getTomorrowString();
    final existingPlan = HiveService.getDailyPlan(tomorrow);

    if (existingPlan != null) {
      // 既存プランがある場合、通知をスケジュール（非同期だが待たない）
      Future.microtask(() => _scheduleNotification(existingPlan.mainTaskId != null));
      return existingPlan;
    }

    // 新規プランの場合、通知をスケジュール（メインタスク未設定）
    Future.microtask(() => _scheduleNotification(false));
    return DailyPlan(date: tomorrow);
  }

  // 通知をスケジュール
  Future<void> _scheduleNotification(bool hasTomorrowMainTask) async {
    print('📢 通知スケジュール: hasTomorrowMainTask=$hasTomorrowMainTask');
    await NotificationService.scheduleTomorrowReminderIfNeeded(hasTomorrowMainTask);
    await NotificationService.checkPendingNotifications();
  }

  // メインタスクを設定
  Future<void> setMainTask(String? taskId) async {
    final updatedPlan = state.copyWith(mainTaskId: taskId);
    await HiveService.saveDailyPlan(updatedPlan);
    state = updatedPlan;

    // 通知を更新
    await _scheduleNotification(taskId != null);
  }

  // サブタスクを追加
  Future<void> addSubTask(String taskId) async {
    if (state.subTaskIds.length >= AppConstants.maxSubTasks) {
      throw Exception('Maximum ${AppConstants.maxSubTasks} sub tasks allowed');
    }

    if (state.subTaskIds.contains(taskId)) {
      return; // すでに追加済み
    }

    final updatedPlan = state.copyWith(
      subTaskIds: [...state.subTaskIds, taskId],
    );

    await HiveService.saveDailyPlan(updatedPlan);
    state = updatedPlan;
  }

  // サブタスクを削除
  Future<void> removeSubTask(String taskId) async {
    final updatedPlan = state.copyWith(
      subTaskIds: state.subTaskIds.where((id) => id != taskId).toList(),
    );

    await HiveService.saveDailyPlan(updatedPlan);
    state = updatedPlan;
  }
}

// 明日のプランを取得
@riverpod
DailyPlan tomorrowPlan(Ref ref) {
  return ref.watch(tomorrowPlanNotifierProvider);
}

// 明日のメインタスクを取得
@riverpod
Task? tomorrowMainTask(Ref ref) {
  final plan = ref.watch(tomorrowPlanNotifierProvider);
  if (plan.mainTaskId == null) return null;

  final tasks = ref.watch(taskNotifierProvider);
  return tasks.where((t) => t.id == plan.mainTaskId).firstOrNull;
}

// 明日のサブタスクリストを取得
@riverpod
List<Task> tomorrowSubTasks(Ref ref) {
  final plan = ref.watch(tomorrowPlanNotifierProvider);
  final tasks = ref.watch(taskNotifierProvider);

  return plan.subTaskIds
      .map((id) => tasks.where((t) => t.id == id).firstOrNull)
      .whereType<Task>()
      .toList();
}
