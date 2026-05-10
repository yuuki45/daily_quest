import 'dart:io';

import 'package:hive/hive.dart';
import 'package:tri_task/data/adapters/adventure_record_adapter.dart';
import 'package:tri_task/data/adapters/boss_adapter.dart';
import 'package:tri_task/data/adapters/quest_adapter.dart';
import 'package:tri_task/data/adapters/user_status_adapter.dart';
import 'package:tri_task/data/models/adventure_record.dart';
import 'package:tri_task/data/models/boss.dart';
import 'package:tri_task/data/models/quest.dart';
import 'package:tri_task/data/models/user_status.dart';
import 'package:tri_task/services/hive_service.dart';

/// テスト用の一時ディレクトリにHiveを初期化し、4つのBoxを開く。
///
/// 各テスト関数の冒頭で呼び、`addTearDown(tearDownHiveForTest)` をセットする想定。
/// Hive.initFlutter は path_provider 依存で動かないため、
/// プレーンな Hive.init を使う。
Future<Directory> setUpHiveForTest() async {
  final tempDir = await Directory.systemTemp.createTemp('daily_quest_test');
  Hive.init(tempDir.path);

  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(QuestAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(UserStatusAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(BossAdapter());
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(AdventureRecordAdapter());
  }

  await Hive.openBox<Quest>(HiveService.questsBoxName);
  await Hive.openBox<UserStatus>(HiveService.userStatusBoxName);
  await Hive.openBox<Boss>(HiveService.bossesBoxName);
  await Hive.openBox<AdventureRecord>(HiveService.recordsBoxName);

  return tempDir;
}

Future<void> tearDownHiveForTest(Directory tempDir) async {
  await Hive.deleteFromDisk();
  await Hive.close();
  if (tempDir.existsSync()) {
    await tempDir.delete(recursive: true);
  }
}
