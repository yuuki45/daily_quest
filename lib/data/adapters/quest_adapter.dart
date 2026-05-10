import 'package:hive/hive.dart';
import 'package:tri_task/data/models/quest.dart';

/// Hive TypeAdapter for [Quest] (typeId: 0).
///
/// 手書きアダプタ。フィールド追加は末尾に新しいfieldIdで追加すること。
/// 既存fieldIdの意味を変えると過去データが破壊されるので絶対NG。
class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 0;

  @override
  Quest read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return Quest(
      id: fields[0] as String,
      title: fields[1] as String,
      type: QuestType.values[fields[2] as int],
      date: fields[3] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[4] as int),
      isCompleted: fields[5] as bool? ?? false,
      completedAt: fields[6] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(fields[6] as int),
      memo: fields[7] as String?,
      repeatType: RepeatType.values[fields[8] as int? ?? 0],
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type.index)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.completedAt?.millisecondsSinceEpoch)
      ..writeByte(7)
      ..write(obj.memo)
      ..writeByte(8)
      ..write(obj.repeatType.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestAdapter && runtimeType == other.runtimeType;
}
