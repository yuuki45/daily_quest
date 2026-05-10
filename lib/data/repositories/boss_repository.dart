import 'package:hive/hive.dart';
import 'package:tri_task/data/models/boss.dart';
import 'package:tri_task/services/hive_service.dart';

class BossRepository {
  Box<Boss> get _box => Hive.box<Boss>(HiveService.bossesBoxName);

  Boss? getByWeekStart(String weekStartYmd) => _box.get(weekStartYmd);

  List<Boss> getAll() => _box.values.toList(growable: false);

  List<Boss> getDefeated() =>
      _box.values.where((b) => b.defeated).toList(growable: false);

  Future<void> save(Boss boss) => _box.put(boss.weekStartDate, boss);

  Future<void> delete(String weekStartYmd) => _box.delete(weekStartYmd);
}
