import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:tri_task/core/constants/app_constants.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'daily_quest_reminder';
  static const String _channelName = 'デイリーリマインダー';
  static const String _channelDescription =
      '21:00 に冒険記録のリマインドを送ります';

  static const String _notificationTitle = 'Daily Quest';
  static const String _notificationBody = '今日の冒険を記録しよう';

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      // パーミッションは scheduleDailyReminder 時に明示的に要求する
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(settings);
  }

  /// iOS と Android 13+ で必要なパーミッションを要求する。
  /// 戻り値: 通知が許可されている場合 true。
  static Future<bool> requestPermissions() async {
    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final iosGranted = await iosImpl?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        true;

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final androidGranted =
        await androidImpl?.requestNotificationsPermission() ?? true;

    return iosGranted && androidGranted;
  }

  static Future<void> scheduleDailyReminder() async {
    await cancelDailyReminder();

    final scheduled = _nextOccurrence(
      AppConstants.notificationHour,
      AppConstants.notificationMinute,
    );

    try {
      await _plugin.zonedSchedule(
        AppConstants.dailyReminderNotificationId,
        _notificationTitle,
        _notificationBody,
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        // SCHEDULE_EXACT_ALARM 権限を要求しない inexact モードを使用
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('NotificationService.scheduleDailyReminder failed: $e');
    }
  }

  static Future<void> cancelDailyReminder() async {
    await _plugin.cancel(AppConstants.dailyReminderNotificationId);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static tz.TZDateTime _nextOccurrence(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var dt = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!dt.isAfter(now)) {
      dt = dt.add(const Duration(days: 1));
    }
    return dt;
  }
}
