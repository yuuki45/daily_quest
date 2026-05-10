import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateHelper {
  static bool _initialized = false;

  static Future<void> init() async {
    if (!_initialized) {
      await initializeDateFormatting('ja_JP');
      _initialized = true;
    }
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDisplayDate(DateTime date) {
    return DateFormat('M月d日(E)', 'ja_JP').format(date);
  }

  static String getTodayString() {
    return formatDate(DateTime.now());
  }

  static String getTomorrowString() {
    return formatDate(DateTime.now().add(const Duration(days: 1)));
  }

  static DateTime parseDate(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }

  static bool isToday(String dateString) {
    return dateString == getTodayString();
  }

  static bool isTomorrow(String dateString) {
    return dateString == getTomorrowString();
  }

  static int getDaysDifference(String dateString) {
    final date = parseDate(dateString);
    final today = DateTime.now();
    return date.difference(DateTime(today.year, today.month, today.day)).inDays;
  }
}
