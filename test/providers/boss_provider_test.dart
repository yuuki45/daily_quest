import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_task/core/constants/boss_constants.dart';
import 'package:tri_task/providers/boss_provider.dart';

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

  group('BossNotifier', () {
    test('初回は今週のボスを生成、HPは weeklyMaxHp', () {
      final boss = container.read(bossNotifierProvider);
      expect(boss.maxHp, BossConstants.weeklyMaxHp);
      expect(boss.currentHp, BossConstants.weeklyMaxHp);
      expect(boss.defeated, false);
      expect(
        BossConstants.presets.any((p) => p.name == boss.name),
        true,
        reason: 'プリセットの中から選ばれていること',
      );
    });

    test('dealDamage で HP 減算', () async {
      final notifier = container.read(bossNotifierProvider.notifier);
      await notifier.dealDamage(1);
      final boss = container.read(bossNotifierProvider);
      expect(boss.currentHp, BossConstants.weeklyMaxHp - 1);
      expect(boss.defeated, false);
    });

    test('HP が 0 になったら defeated = true', () async {
      final notifier = container.read(bossNotifierProvider.notifier);
      await notifier.dealDamage(BossConstants.weeklyMaxHp);
      final boss = container.read(bossNotifierProvider);
      expect(boss.currentHp, 0);
      expect(boss.defeated, true);
    });

    test('討伐済みの場合は dealDamage が無視される', () async {
      final notifier = container.read(bossNotifierProvider.notifier);
      await notifier.dealDamage(BossConstants.weeklyMaxHp);
      await notifier.dealDamage(1); // 既に討伐済み
      final boss = container.read(bossNotifierProvider);
      expect(boss.currentHp, 0);
    });

    test('HP は負にならない（過剰ダメージで0にクランプ）', () async {
      final notifier = container.read(bossNotifierProvider.notifier);
      await notifier.dealDamage(100);
      expect(container.read(bossNotifierProvider).currentHp, 0);
    });
  });
}
