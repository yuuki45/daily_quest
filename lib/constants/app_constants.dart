class AppConstants {
  // Task limits
  static const int maxMainTasks = 1;
  static const int maxSubTasks = 2;
  static const int maxDailyTasks = 3; // 互換性のため残す

  // Notification
  static const int notificationId = 0;
  static const int tomorrowReminderNotificationId = 1;
  static const String notificationChannelId = 'daily_planning';
  static const String notificationChannelName = 'Daily Planning';
  static const String notificationChannelDescription =
      'Notifications for daily task planning';
  static const int notificationHour = 21;
  static const int notificationMinute = 0;
  static const String notificationTitle = 'TriTask';
  static const String notificationBody = '明日の3つを決めよう';
  static const String tomorrowReminderTitle = 'TriTask';
  static const String tomorrowReminderBody = '明日のタスクを設定しましょう';

  // Plant stages
  static const int plantStageSeed = 0;
  static const int plantStageSprout = 1;
  static const int plantStageBud = 2;
  static const int plantStageFlower = 3;
  static const int plantStageBouquet = 4;

  // Plant stage emojis
  static const String seedEmoji = '🌱';
  static const String sproutEmoji = '🌿';
  static const String budEmoji = '🌺';
  static const String flowerEmoji = '🌸';
  static const String bouquetEmoji = '💐';

  // Streak thresholds for plant stages
  static const int streakForSprout = 3;
  static const int streakForBud = 7;
  static const int streakForFlower = 14;
  static const int streakForBouquet = 30;

  // Tag labels
  static const String tagWork = '仕事';
  static const String tagLife = '生活';
  static const String tagStudy = '勉強';
  static const String tagHealth = '健康';
  static const String tagOther = 'その他';

  static const List<String> availableTags = [
    tagWork,
    tagLife,
    tagStudy,
    tagHealth,
    tagOther,
  ];

  // Share text template for X (Twitter)
  static String getXShareText(String mainTaskTitle, List<String> subTaskTitles, int streakCount, String plantEmoji) {
    final streakText = streakCount > 0 ? '（現在$streakCount日連続）' : '';

    final tasks = StringBuffer();
    tasks.writeln('✅ $mainTaskTitle');
    for (final subTask in subTaskTitles) {
      tasks.writeln('✅ $subTask');
    }

    return '''今日やること$plantEmoji$streakText

${tasks.toString().trim()}

#TriTask #継続は力なり''';
  }

  // Get plant emoji by streak count
  static String getPlantEmoji(int streakCount) {
    if (streakCount >= streakForBouquet) return bouquetEmoji;
    if (streakCount >= streakForFlower) return flowerEmoji;
    if (streakCount >= streakForBud) return budEmoji;
    if (streakCount >= streakForSprout) return sproutEmoji;
    return seedEmoji;
  }

  // Get plant stage by streak count
  static int getPlantStage(int streakCount) {
    if (streakCount >= streakForBouquet) return plantStageBouquet;
    if (streakCount >= streakForFlower) return plantStageFlower;
    if (streakCount >= streakForBud) return plantStageBud;
    if (streakCount >= streakForSprout) return plantStageSprout;
    return plantStageSeed;
  }

  // App subtitles (displayed randomly)
  static const List<String> appSubtitles = [
    'あなたの毎日に、小さな達成感を',
    '1日の積み重ねが、未来を変える',
    'ToDoではなく、Tryする日々を',
    '小さな習慣、大きな成長',
    '毎日コツコツ、確実に',
    '続けることが、力になる',
    '積み重ねが、未来を作る',
  ];
}
