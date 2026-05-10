import 'package:hive/hive.dart';
import 'package:tri_task/data/models/quest.dart';
import 'package:tri_task/services/hive_service.dart';

class QuestRepository {
  Box<Quest> get _box => Hive.box<Quest>(HiveService.questsBoxName);

  List<Quest> getAll() => _box.values.toList(growable: false);

  Quest? getById(String id) => _box.get(id);

  List<Quest> getByDate(String ymd) =>
      _box.values.where((q) => q.date == ymd).toList(growable: false);

  Quest? getMainQuestForDate(String ymd) {
    for (final q in _box.values) {
      if (q.date == ymd && q.type == QuestType.main) return q;
    }
    return null;
  }

  List<Quest> getSideQuestsForDate(String ymd) => _box.values
      .where((q) => q.date == ymd && q.type == QuestType.side)
      .toList(growable: false);

  Future<void> save(Quest quest) => _box.put(quest.id, quest);

  Future<void> delete(String id) => _box.delete(id);

  Future<void> clear() => _box.clear();
}
