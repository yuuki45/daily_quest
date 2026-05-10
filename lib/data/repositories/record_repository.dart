import 'package:hive/hive.dart';
import 'package:tri_task/data/models/adventure_record.dart';
import 'package:tri_task/services/hive_service.dart';

class RecordRepository {
  Box<AdventureRecord> get _box =>
      Hive.box<AdventureRecord>(HiveService.recordsBoxName);

  AdventureRecord? getByDate(String ymd) => _box.get(ymd);

  List<AdventureRecord> getAll() => _box.values.toList(growable: false);

  List<AdventureRecord> getInRange(String fromYmd, String toYmd) => _box.values
      .where((r) =>
          r.date.compareTo(fromYmd) >= 0 && r.date.compareTo(toYmd) <= 0)
      .toList(growable: false);

  Future<void> save(AdventureRecord record) => _box.put(record.date, record);

  Future<void> delete(String ymd) => _box.delete(ymd);
}
