import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tri_task/data/models/adventure_record.dart';
import 'package:tri_task/data/repositories/record_repository.dart';

part 'record_provider.g.dart';

@riverpod
class RecordNotifier extends _$RecordNotifier {
  final _repo = RecordRepository();

  @override
  List<AdventureRecord> build() => _repo.getAll();

  AdventureRecord? getByDate(String ymd) {
    for (final r in state) {
      if (r.date == ymd) return r;
    }
    return null;
  }

  List<AdventureRecord> getInRange(String fromYmd, String toYmd) => state
      .where((r) =>
          r.date.compareTo(fromYmd) >= 0 && r.date.compareTo(toYmd) <= 0)
      .toList(growable: false);

  Future<void> save(AdventureRecord record) async {
    await _repo.save(record);
    final exists = state.any((r) => r.date == record.date);
    state = exists
        ? [for (final r in state) r.date == record.date ? record : r]
        : [...state, record];
  }
}
