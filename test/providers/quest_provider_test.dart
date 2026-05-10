import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_task/core/constants/exp_constants.dart';
import 'package:tri_task/data/models/quest.dart';
import 'package:tri_task/providers/quest_provider.dart';
import 'package:tri_task/providers/user_status_provider.dart';

import '../helpers/hive_test_helper.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  setUp(() async {
    tempDir = await setUpHiveForTest();
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await tearDownHiveForTest(tempDir);
  });

  group('QuestNotifier', () {
    test('メインクエストは1日に1つしか追加できない', () async {
      final notifier = container.read(questNotifierProvider.notifier);
      await notifier.addQuest(title: 'm1', type: QuestType.main);
      expect(
        () => notifier.addQuest(title: 'm2', type: QuestType.main),
        throwsA(isA<QuestLimitException>()),
      );
    });

    test('サイドクエストは2つまで、3つ目で例外', () async {
      final notifier = container.read(questNotifierProvider.notifier);
      await notifier.addQuest(title: 's1', type: QuestType.side);
      await notifier.addQuest(title: 's2', type: QuestType.side);
      expect(
        () => notifier.addQuest(title: 's3', type: QuestType.side),
        throwsA(isA<QuestLimitException>()),
      );
    });

    test('メインクエスト初回完了で 50 EXP 付与', () async {
      final notifier = container.read(questNotifierProvider.notifier);
      final q = await notifier.addQuest(title: 'main', type: QuestType.main);

      await notifier.toggleComplete(q.id);

      expect(
        container.read(userStatusNotifierProvider).totalExp,
        ExpConstants.mainQuestExp,
      );
    });

    test('toggle off → on で EXP は二重付与されない', () async {
      final notifier = container.read(questNotifierProvider.notifier);
      final q = await notifier.addQuest(title: 'main', type: QuestType.main);

      await notifier.toggleComplete(q.id); // off → on
      await notifier.toggleComplete(q.id); // on → off
      await notifier.toggleComplete(q.id); // off → on (再度)

      expect(
        container.read(userStatusNotifierProvider).totalExp,
        ExpConstants.mainQuestExp,
      );
    });

    test('メイン+サイド2件全達成で perfect ボーナス +30', () async {
      final notifier = container.read(questNotifierProvider.notifier);
      final m = await notifier.addQuest(title: 'm', type: QuestType.main);
      final s1 = await notifier.addQuest(title: 's1', type: QuestType.side);
      final s2 = await notifier.addQuest(title: 's2', type: QuestType.side);

      await notifier.toggleComplete(s1.id); // +20
      await notifier.toggleComplete(s2.id); // +20
      await notifier.toggleComplete(m.id); // +50 +30 (perfect)

      expect(
        container.read(userStatusNotifierProvider).totalExp,
        ExpConstants.sideQuestExp * 2 +
            ExpConstants.mainQuestExp +
            ExpConstants.perfectDayBonus,
      );
    });

    test('サイドクエスト1件しかない場合は perfect ボーナスなし', () async {
      final notifier = container.read(questNotifierProvider.notifier);
      final m = await notifier.addQuest(title: 'm', type: QuestType.main);
      final s1 = await notifier.addQuest(title: 's1', type: QuestType.side);

      await notifier.toggleComplete(s1.id);
      await notifier.toggleComplete(m.id);

      // bonus は付かない
      expect(
        container.read(userStatusNotifierProvider).totalExp,
        ExpConstants.sideQuestExp + ExpConstants.mainQuestExp,
      );
    });

    test('deleteQuest で削除', () async {
      final notifier = container.read(questNotifierProvider.notifier);
      final q = await notifier.addQuest(title: 'm', type: QuestType.main);
      await notifier.deleteQuest(q.id);
      expect(container.read(questNotifierProvider), isEmpty);
    });
  });
}
