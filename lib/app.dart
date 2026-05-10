import 'package:flutter/material.dart';
import 'package:tri_task/core/constants/app_constants.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/features/main_scaffold.dart';
import 'package:tri_task/features/onboarding/remake_announce_screen.dart';

class DailyQuestApp extends StatefulWidget {
  final bool showRemakeAnnounce;

  const DailyQuestApp({super.key, this.showRemakeAnnounce = false});

  @override
  State<DailyQuestApp> createState() => _DailyQuestAppState();
}

class _DailyQuestAppState extends State<DailyQuestApp> {
  late bool _showAnnounce;

  @override
  void initState() {
    super.initState();
    _showAnnounce = widget.showRemakeAnnounce;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _showAnnounce
          ? RemakeAnnounceScreen(
              onContinue: () => setState(() => _showAnnounce = false),
            )
          : const MainScaffold(),
    );
  }
}
