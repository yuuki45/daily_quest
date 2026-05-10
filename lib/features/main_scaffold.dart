import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/features/boss/boss_screen.dart';
import 'package:tri_task/features/quest/quest_screen.dart';
import 'package:tri_task/features/record/record_screen.dart';
import 'package:tri_task/features/settings/settings_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = 0;

  static const _tabs = <Widget>[
    QuestScreen(),
    RecordScreen(),
    BossScreen(),
    SettingsScreen(),
  ];

  static const _items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.shield_outlined),
      activeIcon: Icon(Icons.shield),
      label: '冒険',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.menu_book_outlined),
      activeIcon: Icon(Icons.menu_book),
      label: '記録',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.castle_outlined),
      activeIcon: Icon(Icons.castle),
      label: 'ボス',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined),
      activeIcon: Icon(Icons.settings),
      label: '設定',
    ),
  ];

  void _onTap(int i) {
    if (i == _index) return;
    HapticFeedback.selectionClick();
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.gold, width: 2),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: _onTap,
          items: _items,
        ),
      ),
    );
  }
}
