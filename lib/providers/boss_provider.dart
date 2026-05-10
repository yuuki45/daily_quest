import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tri_task/core/constants/boss_constants.dart';
import 'package:tri_task/core/utils/week_helper.dart';
import 'package:tri_task/data/models/boss.dart';
import 'package:tri_task/data/repositories/boss_repository.dart';
import 'package:uuid/uuid.dart';

part 'boss_provider.g.dart';

@riverpod
class BossNotifier extends _$BossNotifier {
  final _repo = BossRepository();
  static const _uuid = Uuid();

  @override
  Boss build() {
    final weekStart = WeekHelper.currentWeekStartYmd();
    final existing = _repo.getByWeekStart(weekStart);
    if (existing != null) return existing;

    final fresh = _generateForCurrentWeek();
    // ignore: discarded_futures — Hive write is fast and we want sync state init
    _repo.save(fresh);
    return fresh;
  }

  Boss _generateForCurrentWeek() {
    final preset = BossConstants
        .presets[Random().nextInt(BossConstants.presets.length)];
    return Boss(
      id: _uuid.v4(),
      name: preset.name,
      maxHp: BossConstants.weeklyMaxHp,
      currentHp: BossConstants.weeklyMaxHp,
      weekStartDate: WeekHelper.currentWeekStartYmd(),
      weekEndDate: WeekHelper.currentWeekEndYmd(),
      imageKey: preset.imageKey,
    );
  }

  Future<void> dealDamage(int dmg) async {
    if (state.defeated || dmg <= 0) return;
    final newHp = (state.currentHp - dmg).clamp(0, state.maxHp);
    final updated = state.copyWith(
      currentHp: newHp,
      defeated: newHp <= 0,
    );
    await _repo.save(updated);
    state = updated;
  }
}
