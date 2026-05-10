import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_status.freezed.dart';

@freezed
class UserStatus with _$UserStatus {
  const factory UserStatus({
    @Default(1) int level,
    @Default(0) int exp,
    @Default(0) int totalExp,
    @Default(0) int streakDays,
    String? lastCompletedDate,
  }) = _UserStatus;

  static const UserStatus initial = UserStatus();
}
