import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest.freezed.dart';

enum QuestType { main, side }

enum RepeatType { none, daily }

@freezed
class Quest with _$Quest {
  const factory Quest({
    required String id,
    required String title,
    required QuestType type,
    required String date,
    required DateTime createdAt,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    String? memo,
    @Default(RepeatType.none) RepeatType repeatType,
  }) = _Quest;
}
