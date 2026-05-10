import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/app.dart';
import 'package:tri_task/services/hive_service.dart';
import 'package:tri_task/services/migration_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();
  final didMigrate = await MigrationService.runIfNeeded();

  runApp(ProviderScope(
    child: DailyQuestApp(showRemakeAnnounce: didMigrate),
  ));
}
