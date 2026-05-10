import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:tri_task/constants/app_constants.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));

    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    // iOS permissions
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Android 13+ permissions
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - will be implemented with navigation
    print('Notification tapped: ${response.payload}');
  }

  static tz.TZDateTime _nextInstanceOf9PM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      AppConstants.notificationHour,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // スケジュールされている通知を確認（デバッグ用）
  static Future<void> checkPendingNotifications() async {
    final pendingNotifications = await _notifications.pendingNotificationRequests();
    print('📢 Pending notifications: ${pendingNotifications.length}');
    for (final notification in pendingNotifications) {
      print('  - ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}');
    }
  }

  // 明日のタスク未設定時のリマインダー通知をスケジュール
  static Future<void> scheduleTomorrowReminderIfNeeded(bool hasTomorrowMainTask) async {
    print('📢 scheduleTomorrowReminderIfNeeded: hasTomorrowMainTask=$hasTomorrowMainTask');

    if (hasTomorrowMainTask) {
      // メインタスクが設定されている場合は通知をキャンセル
      print('📢 メインタスクが設定されているため通知をキャンセル');
      await cancelNotification(AppConstants.tomorrowReminderNotificationId);
    } else {
      // メインタスクが未設定の場合は21:00に通知をスケジュール
      final scheduledTime = _nextInstanceOf9PM();
      print('📢 21:00に通知をスケジュール: $scheduledTime');

      await _notifications.zonedSchedule(
        AppConstants.tomorrowReminderNotificationId,
        AppConstants.tomorrowReminderTitle,
        AppConstants.tomorrowReminderBody,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.notificationChannelId,
            AppConstants.notificationChannelName,
            channelDescription: AppConstants.notificationChannelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print('📢 通知スケジュール完了');
    }
  }
}
