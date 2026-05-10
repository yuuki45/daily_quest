import 'package:hive/hive.dart';
import 'package:tri_task/data/models/user_status.dart';

/// Hive TypeAdapter for [UserStatus] (typeId: 1).
class UserStatusAdapter extends TypeAdapter<UserStatus> {
  @override
  final int typeId = 1;

  @override
  UserStatus read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return UserStatus(
      level: fields[0] as int? ?? 1,
      exp: fields[1] as int? ?? 0,
      totalExp: fields[2] as int? ?? 0,
      streakDays: fields[3] as int? ?? 0,
      lastCompletedDate: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserStatus obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.exp)
      ..writeByte(2)
      ..write(obj.totalExp)
      ..writeByte(3)
      ..write(obj.streakDays)
      ..writeByte(4)
      ..write(obj.lastCompletedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatusAdapter && runtimeType == other.runtimeType;
}
