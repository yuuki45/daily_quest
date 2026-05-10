import 'package:freezed_annotation/freezed_annotation.dart';

part 'adventure_record.freezed.dart';

@freezed
class AdventureRecord with _$AdventureRecord {
  const factory AdventureRecord({
    required String date,
    @Default(false) bool mainQuestCompleted,
    @Default(0) int sideQuestCompletedCount,
    @Default(0) int gainedExp,
    @Default(false) bool isPerfect,
  }) = _AdventureRecord;
}
