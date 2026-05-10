import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tri_task/app.dart';
import 'package:tri_task/core/constants/app_constants.dart';
import 'package:tri_task/services/hive_service.dart';
import 'package:tri_task/services/migration_service.dart';
import 'package:tri_task/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();
  await NotificationService.init();

  final didMigrate = await MigrationService.runIfNeeded();

  // 通知が有効ならリマインダーをスケジュール（権限未付与の場合は失敗するが、無視する）
  final prefs = await SharedPreferences.getInstance();
  final notificationsEnabled =
      prefs.getBool(AppConstants.prefsKeyNotificationsEnabled) ?? true;
  if (notificationsEnabled) {
    await NotificationService.scheduleDailyReminder();
  }

  runApp(ProviderScope(
    child: DailyQuestApp(showRemakeAnnounce: didMigrate),
  ));
}
