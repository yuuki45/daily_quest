import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/core/utils/date_helper.dart';
import 'package:tri_task/data/models/adventure_record.dart';
import 'package:tri_task/providers/record_provider.dart';
import 'package:tri_task/widgets/parchment_card.dart';
import 'package:tri_task/widgets/screen_header.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(recordNotifierProvider);
    final recordMap = {for (final r in records) r.date: r};

    final monthRecords = records
        .where((r) =>
            DateHelper.parseYmd(r.date).year == _focusedDay.year &&
            DateHelper.parseYmd(r.date).month == _focusedDay.month)
        .toList(growable: false);
    final monthAchievedDays =
        monthRecords.where((r) => r.mainQuestCompleted).length;
    final monthTotalExp =
        monthRecords.fold<int>(0, (sum, r) => sum + r.gainedExp);

    final selectedRecord = _selectedDay == null
        ? null
        : recordMap[DateHelper.formatYmd(_selectedDay!)];

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingMd,
            AppTheme.spacingSm,
            AppTheme.spacingMd,
            AppTheme.spacingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScreenHeader(
                title: '冒険の記録',
                subtitle: 'これまでの歩みを振り返ろう',
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _MonthSummaryCard(
                achievedDays: monthAchievedDays,
                totalExp: monthTotalExp,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              ParchmentCard(
                child: TableCalendar(
                  firstDay: DateTime.utc(2024),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) =>
                      _selectedDay != null && isSameDay(day, _selectedDay),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    });
                  },
                  onPageChanged: (focused) {
                    setState(() => _focusedDay = focused);
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: AppTextStyles.titleMedium,
                    leftChevronIcon:
                        const Icon(Icons.chevron_left, color: AppColors.brown),
                    rightChevronIcon: const Icon(Icons.chevron_right,
                        color: AppColors.brown),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    weekendStyle: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.crimson,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: AppTextStyles.bodyMedium,
                    weekendTextStyle: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.crimson),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.blue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, _) {
                      final ymd = DateHelper.formatYmd(day);
                      final r = recordMap[ymd];
                      if (r == null) return null;
                      if (r.isPerfect) {
                        return const Positioned(
                          bottom: 2,
                          child: Icon(Icons.star_rounded,
                              color: AppColors.gold, size: 14),
                        );
                      }
                      if (r.mainQuestCompleted) {
                        return const Positioned(
                          bottom: 2,
                          child: Icon(Icons.local_fire_department_rounded,
                              color: AppColors.crimson, size: 14),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              const _LegendCard(),
              const SizedBox(height: AppTheme.spacingMd),
              if (_selectedDay != null)
                _SelectedDayDetail(
                  day: _selectedDay!,
                  record: selectedRecord,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthSummaryCard extends StatelessWidget {
  final int achievedDays;
  final int totalExp;

  const _MonthSummaryCard({
    required this.achievedDays,
    required this.totalExp,
  });

  @override
  Widget build(BuildContext context) {
    return ParchmentCard(
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              label: '今月の達成日',
              value: '$achievedDays日',
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.crimson,
            ),
          ),
          Container(
            width: 1.5,
            height: 40,
            color: AppColors.border.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _StatColumn(
              label: '今月の獲得EXP',
              value: '$totalExp',
              icon: Icons.bolt_rounded,
              iconColor: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 4),
            Text(value, style: AppTextStyles.statValue),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _LegendCard extends StatelessWidget {
  const _LegendCard();

  @override
  Widget build(BuildContext context) {
    return const ParchmentCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _LegendItem(
            icon: Icons.star_rounded,
            color: AppColors.gold,
            label: '完全達成',
          ),
          _LegendItem(
            icon: Icons.local_fire_department_rounded,
            color: AppColors.crimson,
            label: 'メイン達成',
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _LegendItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _SelectedDayDetail extends StatelessWidget {
  final DateTime day;
  final AdventureRecord? record;

  const _SelectedDayDetail({required this.day, required this.record});

  @override
  Widget build(BuildContext context) {
    final dateStr = '${day.year}/${day.month}/${day.day}';
    return ParchmentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dateStr, style: AppTextStyles.titleMedium),
          const SizedBox(height: AppTheme.spacingSm),
          if (record == null)
            Text('この日の記録はありません', style: AppTextStyles.caption)
          else ...[
            _DetailRow(
              icon: record!.mainQuestCompleted
                  ? Icons.check_circle
                  : Icons.cancel_outlined,
              iconColor: record!.mainQuestCompleted
                  ? AppColors.blue
                  : AppColors.disabled,
              label: 'メインクエスト',
              value: record!.mainQuestCompleted ? '達成' : '未達成',
            ),
            const SizedBox(height: AppTheme.spacingXs),
            _DetailRow(
              icon: Icons.flag_outlined,
              iconColor: AppColors.brown,
              label: 'サイドクエスト達成数',
              value: '${record!.sideQuestCompletedCount}件',
            ),
            const SizedBox(height: AppTheme.spacingXs),
            _DetailRow(
              icon: Icons.bolt_rounded,
              iconColor: AppColors.blue,
              label: '獲得EXP',
              value: '${record!.gainedExp}',
            ),
            if (record!.isPerfect) ...[
              const SizedBox(height: AppTheme.spacingSm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: AppTheme.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  border: Border.all(color: AppColors.brown, width: 1.5),
                  borderRadius:
                      BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 16, color: AppColors.brown),
                    const SizedBox(width: 4),
                    Text(
                      '完全達成日！',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.brown,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: AppTheme.spacingSm),
        Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
