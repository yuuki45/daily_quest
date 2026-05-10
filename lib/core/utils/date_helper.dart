import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  static final DateFormat _ymd = DateFormat('yyyy-MM-dd');

  static String formatYmd(DateTime date) => _ymd.format(date);

  static DateTime parseYmd(String ymd) => _ymd.parseStrict(ymd);

  static String today() => formatYmd(DateTime.now());

  static String yesterday() =>
      formatYmd(DateTime.now().subtract(const Duration(days: 1)));

  static String tomorrow() =>
      formatYmd(DateTime.now().add(const Duration(days: 1)));

  static bool isToday(String ymd) => ymd == today();

  static bool isYesterday(String ymd) => ymd == yesterday();

  static int daysBetween(String fromYmd, String toYmd) {
    final from = parseYmd(fromYmd);
    final to = parseYmd(toYmd);
    return to.difference(from).inDays;
  }
}
