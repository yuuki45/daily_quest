import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
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

  void _onTap(int i) {
    if (i == _index) return;
    HapticFeedback.selectionClick();
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
                color: AppColors.accent.withValues(alpha: 0.4), width: 1.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                _NavItem(
                  label: 'QUEST',
                  icon: Icons.shield_outlined,
                  selectedIcon: Icons.shield,
                  selected: _index == 0,
                  onTap: () => _onTap(0),
                ),
                _NavItem(
                  label: 'RECORD',
                  icon: Icons.menu_book_outlined,
                  selectedIcon: Icons.menu_book,
                  selected: _index == 1,
                  onTap: () => _onTap(1),
                ),
                _NavItem(
                  label: 'BOSS',
                  icon: Icons.castle_outlined,
                  selectedIcon: Icons.castle,
                  selected: _index == 2,
                  onTap: () => _onTap(2),
                ),
                _NavItem(
                  label: 'SETTINGS',
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  selected: _index == 3,
                  onTap: () => _onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? AppColors.accent : AppColors.textMuted;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(selected ? selectedIcon : icon, color: color, size: 22),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTextStyles.statLabel.copyWith(
                    color: color,
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: 18,
                  height: 2,
                  color: selected ? AppColors.accent : Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
