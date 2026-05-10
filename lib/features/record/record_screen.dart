import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';
import 'package:tri_task/core/utils/date_helper.dart';
import 'package:tri_task/data/models/adventure_record.dart';
import 'package:tri_task/providers/record_provider.dart';
import 'package:tri_task/widgets/screen_header.dart';
import 'package:tri_task/widgets/slab_card.dart';

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingLg,
            AppTheme.spacingMd,
            AppTheme.spacingLg,
            AppTheme.spacingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScreenHeader(
                title: 'RECORD',
                subtitle: 'これまでの冒険を振り返ろう',
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _MonthSummary(
                achievedDays: monthAchievedDays,
                totalExp: monthTotalExp,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              SlabCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: AppTheme.spacingSm,
                ),
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
                    leftChevronIcon: const Icon(Icons.chevron_left,
                        color: AppColors.textSecondary),
                    rightChevronIcon: const Icon(Icons.chevron_right,
                        color: AppColors.textSecondary),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: AppTextStyles.statLabel.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    weekendStyle: AppTextStyles.statLabel.copyWith(
                      color: AppColors.accentRed,
                      fontSize: 11,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: AppTextStyles.bodyMedium,
                    weekendTextStyle: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.accentRed),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    selectedTextStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textOnAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    todayTextStyle: AppTextStyles.bodyMedium,
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
                              color: AppColors.accentYellow, size: 12),
                        );
                      }
                      if (r.mainQuestCompleted) {
                        return Positioned(
                          bottom: 4,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.accentGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              const _Legend(),
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

class _MonthSummary extends StatelessWidget {
  final int achievedDays;
  final int totalExp;

  const _MonthSummary({
    required this.achievedDays,
    required this.totalExp,
  });

  @override
  Widget build(BuildContext context) {
    return SlabCard(
      accentColor: AppColors.accent,
      child: Row(
        children: [
          Expanded(
            child: _Stat(
              label: 'ACHIEVED  DAYS',
              value: '$achievedDays',
              accent: AppColors.accentGreen,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.textMuted.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _Stat(
              label: 'TOTAL  EXP',
              value: '$totalExp',
              accent: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _Stat({
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.statLabel.copyWith(fontSize: 10)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.statValue.copyWith(
            color: accent,
            fontSize: 26,
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star_rounded,
              color: AppColors.accentYellow, size: 14),
          const SizedBox(width: 4),
          Text('完全達成', style: AppTextStyles.caption),
          const SizedBox(width: AppTheme.spacingMd),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.accentGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text('メイン達成', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _SelectedDayDetail extends StatelessWidget {
  final DateTime day;
  final AdventureRecord? record;

  const _SelectedDayDetail({required this.day, required this.record});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${day.year}.${day.month.toString().padLeft(2, '0')}.${day.day.toString().padLeft(2, '0')}';

    return SlabCard(
      accentColor: AppColors.textMuted,
      accentWidth: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dateStr,
              style: AppTextStyles.statValueSmall.copyWith(fontSize: 18)),
          const SizedBox(height: AppTheme.spacingSm),
          if (record == null)
            Text('この日の記録はありません', style: AppTextStyles.caption)
          else ...[
            _DetailRow(
              label: 'メインクエスト',
              value: record!.mainQuestCompleted ? '達成' : '未達成',
              valueColor: record!.mainQuestCompleted
                  ? AppColors.accentGreen
                  : AppColors.textMuted,
            ),
            _DetailRow(
              label: 'サイドクエスト',
              value: '${record!.sideQuestCompletedCount} 件',
            ),
            _DetailRow(
              label: '獲得 EXP',
              value: '${record!.gainedExp}',
              valueColor: AppColors.accent,
            ),
            if (record!.isPerfect) ...[
              const SizedBox(height: AppTheme.spacingSm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: AppColors.textOnAccent),
                    const SizedBox(width: 4),
                    Text(
                      'PERFECT',
                      style: AppTextStyles.statLabel.copyWith(
                        color: AppColors.textOnAccent,
                        fontSize: 10,
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
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
