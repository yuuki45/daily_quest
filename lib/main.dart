import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/core/constants/app_constants.dart';
import 'package:tri_task/core/theme/app_theme.dart';
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

class DailyQuestApp extends StatelessWidget {
  final bool showRemakeAnnounce;

  const DailyQuestApp({super.key, this.showRemakeAnnounce = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _PlaceholderHome(),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppConstants.appName,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.surface),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                AppConstants.appTagline,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
