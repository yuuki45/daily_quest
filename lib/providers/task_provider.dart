import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tri_task/models/task.dart';
import 'package:tri_task/services/hive_service.dart';
import 'package:uuid/uuid.dart';

part 'task_provider.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  List<Task> build() {
    // 初期状態としてHiveから全タスクを読み込む
    return HiveService.getAllTasks();
  }

  // タスクを追加
  Future<String> addTask({
    required String title,
    String? tag,
    DateTime? due,
  }) async {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
      tag: tag,
      due: due,
    );

    await HiveService.addTask(newTask);
    state = [...state, newTask];
    return newTask.id;
  }

  // タスクを更新
  Future<void> updateTask(Task task) async {
    await HiveService.updateTask(task);
    state = [
      for (final t in state)
        if (t.id == task.id) task else t,
    ];
  }

  // タスクの完了状態をトグル
  Future<void> toggleTaskDone(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    final updatedTask = task.copyWith(done: !task.done);
    await updateTask(updatedTask);
  }

  // タスクを削除
  Future<void> deleteTask(String taskId) async {
    await HiveService.deleteTask(taskId);
    state = state.where((t) => t.id != taskId).toList();
  }

  // タスクをアーカイブ
  Future<void> archiveTask(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    final updatedTask = task.copyWith(archived: true);
    await updateTask(updatedTask);
  }

  // 未完了タスクのリストを取得
  List<Task> getIncompleteTasks() {
    return state.where((task) => !task.done && !task.archived).toList();
  }

  // タグでフィルタリング
  List<Task> getTasksByTag(String tag) {
    return state.where((task) => task.tag == tag && !task.archived).toList();
  }

  // アーカイブされたタスクを取得
  List<Task> getArchivedTasks() {
    return state.where((task) => task.archived).toList();
  }
}

// 未完了タスクのプロバイダー
@riverpod
List<Task> incompleteTasks(Ref ref) {
  final tasks = ref.watch(taskNotifierProvider);
  return tasks.where((task) => !task.done && !task.archived).toList();
}

// 特定のタスクを取得するプロバイダー
@riverpod
Task? taskById(Ref ref, String id) {
  final tasks = ref.watch(taskNotifierProvider);
  try {
    return tasks.firstWhere((task) => task.id == id);
  } catch (e) {
    return null;
  }
}
