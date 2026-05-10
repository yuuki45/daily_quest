import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tri_task/core/constants/app_constants.dart';

/// 旧TriTask v1.0.0 → Daily Quest v2.0.0 へのアップデート時、
/// 旧データを破棄してクリーンスタートするための処理。
///
/// 一度だけ実行され、以降はSharedPreferencesのフラグでスキップされる。
class MigrationService {
  MigrationService._();

  static const List<String> _legacyBoxNames = [
    'tasks',
    'daily_plans',
    'settings',
  ];

  /// v1からの初回起動時のみ、旧Hive Boxと旧通知を全削除する。
  ///
  /// 戻り値: 移行が走った場合 true（リニューアル告知画面を表示すべき）
  static Future<bool> runIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyMigrated =
        prefs.getBool(AppConstants.prefsKeyV2Migrated) ?? false;

    if (alreadyMigrated) return false;

    await _deleteLegacyHiveBoxes();
    await _cancelLegacyNotifications();

    await prefs.setBool(AppConstants.prefsKeyV2Migrated, true);
    return true;
  }

  static Future<void> _deleteLegacyHiveBoxes() async {
    for (final name in _legacyBoxNames) {
      try {
        await Hive.deleteBoxFromDisk(name);
      } catch (e) {
        debugPrint('Migration: failed to delete legacy box "$name": $e');
      }
    }
  }

  static Future<void> _cancelLegacyNotifications() async {
    try {
      final plugin = FlutterLocalNotificationsPlugin();
      await plugin.cancelAll();
    } catch (e) {
      debugPrint('Migration: failed to cancel legacy notifications: $e');
    }
  }
}
