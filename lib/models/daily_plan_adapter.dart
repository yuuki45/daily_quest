import 'package:hive/hive.dart';
import 'package:tri_task/models/daily_plan.dart';

class DailyPlanAdapter extends TypeAdapter<DailyPlan> {
  @override
  final int typeId = 1;

  @override
  DailyPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // 互換性のため、古いデータ構造（plannedTaskIds）を新しい構造に変換
    String? mainTaskId;
    List<String> subTaskIds = [];

    // 新しいデータ構造（field 5, 6）が存在するかチェック
    if (fields.containsKey(5) || fields.containsKey(6)) {
      mainTaskId = fields[5] as String?;
      subTaskIds = (fields[6] as List?)?.cast<String>() ?? [];
    } else if (fields.containsKey(1)) {
      // 古いデータ構造（field 1: plannedTaskIds）から変換
      final oldTaskIds = (fields[1] as List?)?.cast<String>() ?? [];
      if (oldTaskIds.isNotEmpty) {
        mainTaskId = oldTaskIds.first;
        subTaskIds = oldTaskIds.skip(1).toList();
      }
    }

    return DailyPlan(
      date: fields[0] as String? ?? '',
      mainTaskId: mainTaskId,
      subTaskIds: subTaskIds,
      completedMain: fields[2] as bool? ?? false,
      streakCount: fields[3] as int? ?? 0,
      plantStage: fields[4] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, DailyPlan obj) {
    writer
      ..writeByte(6) // フィールド数を正確に
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.completedMain)
      ..writeByte(3)
      ..write(obj.streakCount)
      ..writeByte(4)
      ..write(obj.plantStage)
      ..writeByte(5)
      ..write(obj.mainTaskId)
      ..writeByte(6)
      ..write(obj.subTaskIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
