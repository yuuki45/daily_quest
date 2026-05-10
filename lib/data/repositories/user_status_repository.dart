import 'package:hive/hive.dart';
import 'package:tri_task/data/models/user_status.dart';
import 'package:tri_task/services/hive_service.dart';

class UserStatusRepository {
  Box<UserStatus> get _box =>
      Hive.box<UserStatus>(HiveService.userStatusBoxName);

  UserStatus get current =>
      _box.get(HiveService.userStatusKey) ?? UserStatus.initial;

  Future<void> save(UserStatus status) =>
      _box.put(HiveService.userStatusKey, status);

  Future<void> reset() => save(UserStatus.initial);
}
