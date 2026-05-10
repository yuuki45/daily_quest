class AppConstants {
  AppConstants._();

  static const String appName = 'Daily Quest';
  static const String appTagline = '毎日のタスクを冒険に変える';

  static const int maxMainQuestPerDay = 1;
  static const int maxSideQuestPerDay = 2;

  static const int notificationHour = 21;
  static const int notificationMinute = 0;
  static const int dailyReminderNotificationId = 100;

  static const String prefsKeyV2Migrated = 'v2_migrated';
  static const String prefsKeyAnnounceShown = 'remake_announce_shown';
  static const String prefsKeyNotificationsEnabled = 'notifications_enabled';
}
