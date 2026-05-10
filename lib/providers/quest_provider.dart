import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tri_task/core/constants/app_constants.dart';
import 'package:tri_task/core/constants/exp_constants.dart';
import 'package:tri_task/core/utils/date_helper.dart';
import 'package:tri_task/data/models/adventure_record.dart';
import 'package:tri_task/data/models/quest.dart';
import 'package:tri_task/data/repositories/quest_repository.dart';
import 'package:tri_task/providers/boss_provider.dart';
import 'package:tri_task/providers/record_provider.dart';
import 'package:tri_task/providers/user_status_provider.dart';
import 'package:uuid/uuid.dart';

part 'quest_provider.g.dart';

class QuestLimitException implements Exception {
  final String message;
  const QuestLimitException(this.message);
  @override
  String toString() => message;
}

@riverpod
class QuestNotifier extends _$QuestNotifier {
  final _repo = QuestRepository();
  static const _uuid = Uuid();

  @override
  List<Quest> build() => _repo.getByDate(DateHelper.today());

  Quest? get mainQuest {
    for (final q in state) {
      if (q.type == QuestType.main) return q;
    }
    return null;
  }

  List<Quest> get sideQuests =>
      state.where((q) => q.type == QuestType.side).toList(growable: false);

  Future<Quest> addQuest({
    required String title,
    required QuestType type,
  }) async {
    final mainCount = state.where((q) => q.type == QuestType.main).length;
    final sideCount = state.where((q) => q.type == QuestType.side).length;

    if (type == QuestType.main &&
        mainCount >= AppConstants.maxMainQuestPerDay) {
      throw const QuestLimitException('メインクエストは1日に1つまでです');
    }
    if (type == QuestType.side &&
        sideCount >= AppConstants.maxSideQuestPerDay) {
      throw const QuestLimitException('サイドクエストは1日に2つまでです');
    }

    final quest = Quest(
      id: _uuid.v4(),
      title: title.trim(),
      type: type,
      date: DateHelper.today(),
      createdAt: DateTime.now(),
    );
    await _repo.save(quest);
    state = [...state, quest];
    return quest;
  }

  Future<void> updateQuest(Quest quest) async {
    await _repo.save(quest);
    state = [for (final q in state) q.id == quest.id ? quest : q];
  }

  Future<void> deleteQuest(String id) async {
    await _repo.delete(id);
    state = state.where((q) => q.id != id).toList(growable: false);
  }

  Future<void> toggleComplete(String id) async {
    final quest = state.firstWhere((q) => q.id == id);
    final newCompleted = !quest.isCompleted;
    // completedAt は「初回完了日時」として一度設定したら以後不変。
    // これにより toggle off → toggle on で二重EXP付与を防ぐ。
    final firstCompletion = newCompleted && quest.completedAt == null;

    final updated = quest.copyWith(
      isCompleted: newCompleted,
      completedAt: quest.completedAt ?? (firstCompletion ? DateTime.now() : null),
    );

    await _repo.save(updated);
    state = [for (final q in state) q.id == id ? updated : q];

    if (firstCompletion) {
      await _onFirstQuestCompletion(updated);
    }
  }

  Future<void> _onFirstQuestCompletion(Quest completedQuest) async {
    final today = DateHelper.today();
    final priorRecord =
        ref.read(recordNotifierProvider.notifier).getByDate(today);
    final priorPerfect = priorRecord?.isPerfect ?? false;

    var expGained = completedQuest.type == QuestType.main
        ? ExpConstants.mainQuestExp
        : ExpConstants.sideQuestExp;

    final mainCompleted =
        state.any((q) => q.type == QuestType.main && q.isCompleted);
    final sideCompletedCount =
        state.where((q) => q.type == QuestType.side && q.isCompleted).length;
    final isPerfectNow = mainCompleted &&
        sideCompletedCount >= AppConstants.maxSideQuestPerDay;

    if (isPerfectNow && !priorPerfect) {
      expGained += ExpConstants.perfectDayBonus;
    }

    await ref.read(userStatusNotifierProvider.notifier).addExp(expGained);

    if (completedQuest.type == QuestType.main) {
      final didCount = await ref
          .read(userStatusNotifierProvider.notifier)
          .recordMainQuestCompletion();
      if (didCount) {
        await ref.read(bossNotifierProvider.notifier).dealDamage(1);
      }
    }

    await ref.read(recordNotifierProvider.notifier).save(
          AdventureRecord(
            date: today,
            mainQuestCompleted: mainCompleted,
            sideQuestCompletedCount: sideCompletedCount,
            gainedExp: (priorRecord?.gainedExp ?? 0) + expGained,
            isPerfect: isPerfectNow,
          ),
        );
  }
}
