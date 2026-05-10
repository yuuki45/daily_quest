import 'package:hive_flutter/hive_flutter.dart';
import 'package:tri_task/data/adapters/adventure_record_adapter.dart';
import 'package:tri_task/data/adapters/boss_adapter.dart';
import 'package:tri_task/data/adapters/quest_adapter.dart';
import 'package:tri_task/data/adapters/user_status_adapter.dart';
import 'package:tri_task/data/models/adventure_record.dart';
import 'package:tri_task/data/models/boss.dart';
import 'package:tri_task/data/models/quest.dart';
import 'package:tri_task/data/models/user_status.dart';

class HiveService {
  HiveService._();

  static const String questsBoxName = 'quests';
  static const String userStatusBoxName = 'user_status';
  static const String bossesBoxName = 'bosses';
  static const String recordsBoxName = 'adventure_records';

  static const String userStatusKey = 'singleton';

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    Hive.registerAdapter(QuestAdapter());
    Hive.registerAdapter(UserStatusAdapter());
    Hive.registerAdapter(BossAdapter());
    Hive.registerAdapter(AdventureRecordAdapter());

    await Hive.openBox<Quest>(questsBoxName);
    await Hive.openBox<UserStatus>(userStatusBoxName);
    await Hive.openBox<Boss>(bossesBoxName);
    await Hive.openBox<AdventureRecord>(recordsBoxName);

    _initialized = true;
  }

  static Future<void> closeAll() async {
    await Hive.close();
    _initialized = false;
  }
}
