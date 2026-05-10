import 'package:hive_flutter/hive_flutter.dart';
import 'package:tri_task/models/task.dart';
import 'package:tri_task/models/daily_plan.dart';
import 'package:tri_task/models/task_adapter.dart';
import 'package:tri_task/models/daily_plan_adapter.dart';

class HiveService {
  static const String tasksBoxName = 'tasks';
  static const String dailyPlansBoxName = 'daily_plans';
  static const String settingsBoxName = 'settings';

  static Future<void> init() async {
    try {
      await Hive.initFlutter();

      // Register adapters
      Hive.registerAdapter(TaskAdapter());
      Hive.registerAdapter(DailyPlanAdapter());

      // Open boxes with error recovery
      try {
        await Hive.openBox<Task>(tasksBoxName);
      } catch (e) {
        // タスクボックスが壊れている場合は削除して再作成
        await Hive.deleteBoxFromDisk(tasksBoxName);
        await Hive.openBox<Task>(tasksBoxName);
      }

      try {
        await Hive.openBox<DailyPlan>(dailyPlansBoxName);
      } catch (e) {
        // デイリープランボックスが壊れている場合は削除して再作成
        await Hive.deleteBoxFromDisk(dailyPlansBoxName);
        await Hive.openBox<DailyPlan>(dailyPlansBoxName);
      }

      try {
        await Hive.openBox(settingsBoxName);
      } catch (e) {
        // 設定ボックスが壊れている場合は削除して再作成
        await Hive.deleteBoxFromDisk(settingsBoxName);
        await Hive.openBox(settingsBoxName);
      }
    } catch (e) {
      throw Exception('Failed to initialize Hive: $e');
    }
  }

  // Task operations
  static Box<Task> get tasksBox => Hive.box<Task>(tasksBoxName);

  static Future<void> addTask(Task task) async {
    try {
      await tasksBox.put(task.id, task);
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  static Future<void> updateTask(Task task) async {
    try {
      await tasksBox.put(task.id, task);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  static Future<void> deleteTask(String id) async {
    try {
      await tasksBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  static List<Task> getAllTasks() {
    try {
      return tasksBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get all tasks: $e');
    }
  }

  static Task? getTask(String id) {
    try {
      return tasksBox.get(id);
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  // Daily plan operations
  static Box<DailyPlan> get dailyPlansBox => Hive.box<DailyPlan>(dailyPlansBoxName);

  static Future<void> saveDailyPlan(DailyPlan plan) async {
    try {
      await dailyPlansBox.put(plan.date, plan);
    } catch (e) {
      throw Exception('Failed to save daily plan: $e');
    }
  }

  static DailyPlan? getDailyPlan(String date) {
    try {
      return dailyPlansBox.get(date);
    } catch (e) {
      throw Exception('Failed to get daily plan: $e');
    }
  }

  static List<DailyPlan> getAllDailyPlans() {
    try {
      return dailyPlansBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get all daily plans: $e');
    }
  }

  // Settings operations
  static Box get settingsBox => Hive.box(settingsBoxName);

  static Future<void> saveSetting(String key, dynamic value) async {
    try {
      await settingsBox.put(key, value);
    } catch (e) {
      throw Exception('Failed to save setting: $e');
    }
  }

  static T? getSetting<T>(String key, {T? defaultValue}) {
    try {
      return settingsBox.get(key, defaultValue: defaultValue) as T?;
    } catch (e) {
      throw Exception('Failed to get setting: $e');
    }
  }

  // Delete all data
  static Future<void> deleteAllData() async {
    try {
      // すべてのタスクを削除
      await tasksBox.clear();

      // すべてのデイリープランを削除（ストリークと履歴も削除）
      await dailyPlansBox.clear();

      print('✅ すべてのデータを削除しました');
    } catch (e) {
      throw Exception('Failed to delete all data: $e');
    }
  }
}
