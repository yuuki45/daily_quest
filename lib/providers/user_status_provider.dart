import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tri_task/core/constants/exp_constants.dart';
import 'package:tri_task/core/utils/date_helper.dart';
import 'package:tri_task/data/models/user_status.dart';
import 'package:tri_task/data/repositories/user_status_repository.dart';

part 'user_status_provider.g.dart';

@riverpod
class UserStatusNotifier extends _$UserStatusNotifier {
  final _repo = UserStatusRepository();

  @override
  UserStatus build() => _repo.current;

  Future<void> addExp(int amount) async {
    if (amount <= 0) return;
    final newTotal = state.totalExp + amount;
    final updated = state.copyWith(
      totalExp: newTotal,
      level: ExpConstants.levelFromTotalExp(newTotal),
      exp: ExpConstants.currentLevelExp(newTotal),
    );
    await _repo.save(updated);
    state = updated;
  }

  /// メインクエスト完了を記録。
  ///
  /// 戻り値:
  /// - `true`: 当日初の完了 → ストリーク更新済み（呼び出し側はボスHP減算等の追加処理を実行可）
  /// - `false`: 既に当日カウント済み（二重カウント防止）
  Future<bool> recordMainQuestCompletion() async {
    final today = DateHelper.today();
    if (state.lastCompletedDate == today) return false;

    final newStreak = state.lastCompletedDate == DateHelper.yesterday()
        ? state.streakDays + 1
        : 1;

    final updated = state.copyWith(
      streakDays: newStreak,
      lastCompletedDate: today,
    );
    await _repo.save(updated);
    state = updated;
    return true;
  }

  Future<void> reset() async {
    await _repo.reset();
    state = UserStatus.initial;
  }
}
