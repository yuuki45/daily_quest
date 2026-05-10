import 'package:hive/hive.dart';
import 'package:tri_task/data/models/boss.dart';

/// Hive TypeAdapter for [Boss] (typeId: 2).
class BossAdapter extends TypeAdapter<Boss> {
  @override
  final int typeId = 2;

  @override
  Boss read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return Boss(
      id: fields[0] as String,
      name: fields[1] as String,
      maxHp: fields[2] as int,
      currentHp: fields[3] as int,
      weekStartDate: fields[4] as String,
      weekEndDate: fields[5] as String,
      imageKey: fields[6] as String,
      defeated: fields[7] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, Boss obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.maxHp)
      ..writeByte(3)
      ..write(obj.currentHp)
      ..writeByte(4)
      ..write(obj.weekStartDate)
      ..writeByte(5)
      ..write(obj.weekEndDate)
      ..writeByte(6)
      ..write(obj.imageKey)
      ..writeByte(7)
      ..write(obj.defeated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BossAdapter && runtimeType == other.runtimeType;
}
