import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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

  group('UserStatusNotifier', () {
    test('初期状態は Lv.1, EXP 0, ストリーク 0', () {
      final state = container.read(userStatusNotifierProvider);
      expect(state.level, 1);
      expect(state.exp, 0);
      expect(state.totalExp, 0);
      expect(state.streakDays, 0);
      expect(state.lastCompletedDate, isNull);
    });

    test('addExpで totalExp が加算され、レベルとexp(現Lv内)が更新される', () async {
      final notifier = container.read(userStatusNotifierProvider.notifier);
      await notifier.addExp(50);

      final state = container.read(userStatusNotifierProvider);
      expect(state.totalExp, 50);
      expect(state.level, 1);
      expect(state.exp, 50);
    });

    test('100EXP到達でレベルアップ', () async {
      final notifier = container.read(userStatusNotifierProvider.notifier);
      await notifier.addExp(99);
      expect(container.read(userStatusNotifierProvider).level, 1);
      await notifier.addExp(1);
      expect(container.read(userStatusNotifierProvider).level, 2);
    });

    test('addExp(0以下)は無視される', () async {
      final notifier = container.read(userStatusNotifierProvider.notifier);
      await notifier.addExp(50);
      await notifier.addExp(0);
      await notifier.addExp(-10);
      expect(container.read(userStatusNotifierProvider).totalExp, 50);
    });

    test('recordMainQuestCompletion 初回は true、ストリーク 1', () async {
      final notifier = container.read(userStatusNotifierProvider.notifier);
      final didCount = await notifier.recordMainQuestCompletion();
      expect(didCount, true);
      expect(container.read(userStatusNotifierProvider).streakDays, 1);
    });

    test('recordMainQuestCompletion 同日2回目は false、ストリーク変わらず', () async {
      final notifier = container.read(userStatusNotifierProvider.notifier);
      await notifier.recordMainQuestCompletion();
      final secondCall = await notifier.recordMainQuestCompletion();
      expect(secondCall, false);
      expect(container.read(userStatusNotifierProvider).streakDays, 1);
    });

    test('reset で初期値に戻る', () async {
      final notifier = container.read(userStatusNotifierProvider.notifier);
      await notifier.addExp(150);
      await notifier.recordMainQuestCompletion();

      await notifier.reset();
      final state = container.read(userStatusNotifierProvider);
      expect(state.level, 1);
      expect(state.totalExp, 0);
      expect(state.streakDays, 0);
    });
  });
}
