import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_plan.freezed.dart';
part 'daily_plan.g.dart';

@freezed
class DailyPlan with _$DailyPlan {
  const factory DailyPlan({
    required String date, // YYYY-MM-DD format
    String? mainTaskId, // メインタスク（1つ、必須）
    @Default([]) List<String> subTaskIds, // サブタスク（最大2つ、任意）
    @Default(false) bool completedMain, // メインタスクの完了状態
    @Default(0) int streakCount,
    @Default(0) int plantStage, // 0-4
  }) = _DailyPlan;

  factory DailyPlan.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanFromJson(json);
}
