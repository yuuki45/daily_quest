import 'package:hive/hive.dart';
import 'package:tri_task/data/models/adventure_record.dart';

/// Hive TypeAdapter for [AdventureRecord] (typeId: 3).
class AdventureRecordAdapter extends TypeAdapter<AdventureRecord> {
  @override
  final int typeId = 3;

  @override
  AdventureRecord read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return AdventureRecord(
      date: fields[0] as String,
      mainQuestCompleted: fields[1] as bool? ?? false,
      sideQuestCompletedCount: fields[2] as int? ?? 0,
      gainedExp: fields[3] as int? ?? 0,
      isPerfect: fields[4] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, AdventureRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.mainQuestCompleted)
      ..writeByte(2)
      ..write(obj.sideQuestCompletedCount)
      ..writeByte(3)
      ..write(obj.gainedExp)
      ..writeByte(4)
      ..write(obj.isPerfect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdventureRecordAdapter && runtimeType == other.runtimeType;
}
