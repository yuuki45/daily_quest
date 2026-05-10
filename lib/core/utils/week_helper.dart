import 'package:tri_task/core/utils/date_helper.dart';

class WeekHelper {
  WeekHelper._();

  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - DateTime.monday;
    final monday = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: daysFromMonday));
    return monday;
  }

  static DateTime endOfWeek(DateTime date) {
    return startOfWeek(date).add(const Duration(days: 6));
  }

  static String currentWeekStartYmd() =>
      DateHelper.formatYmd(startOfWeek(DateTime.now()));

  static String currentWeekEndYmd() =>
      DateHelper.formatYmd(endOfWeek(DateTime.now()));

  static bool isInCurrentWeek(String ymd) {
    final date = DateHelper.parseYmd(ymd);
    final start = startOfWeek(DateTime.now());
    final end = endOfWeek(DateTime.now());
    return !date.isBefore(start) && !date.isAfter(end);
  }
}
