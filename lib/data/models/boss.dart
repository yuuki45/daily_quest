import 'package:freezed_annotation/freezed_annotation.dart';

part 'boss.freezed.dart';

@freezed
class Boss with _$Boss {
  const factory Boss({
    required String id,
    required String name,
    required int maxHp,
    required int currentHp,
    required String weekStartDate,
    required String weekEndDate,
    required String imageKey,
    @Default(false) bool defeated,
  }) = _Boss;
}
