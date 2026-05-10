import 'package:flutter/material.dart';
import 'package:tri_task/core/constants/app_constants.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/features/main_scaffold.dart';

class DailyQuestApp extends StatelessWidget {
  final bool showRemakeAnnounce;

  const DailyQuestApp({super.key, this.showRemakeAnnounce = false});

  @override
  Widget build(BuildContext context) {
    // TODO(phase1): showRemakeAnnounce が true の場合はリニューアル告知画面 (Step 7) を表示
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainScaffold(),
    );
  }
}
