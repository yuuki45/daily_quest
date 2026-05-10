import 'package:hive_flutter/hive_flutter.dart';

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

    // TypeAdapter登録は Step 2 でモデル作成後に追加する。
    //   Hive.registerAdapter(QuestAdapter());
    //   Hive.registerAdapter(UserStatusAdapter());
    //   Hive.registerAdapter(BossAdapter());
    //   Hive.registerAdapter(AdventureRecordAdapter());

    // Box open も Step 2 で追加する。
    //   await Hive.openBox<Quest>(questsBoxName);
    //   ...

    _initialized = true;
  }

  static Future<void> closeAll() async {
    await Hive.close();
    _initialized = false;
  }
}
