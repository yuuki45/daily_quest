class ExpConstants {
  ExpConstants._();

  static const int mainQuestExp = 50;
  static const int sideQuestExp = 20;
  static const int perfectDayBonus = 30;

  static const int expPerLevel = 100;

  static const int dailyMaxExp =
      mainQuestExp + (sideQuestExp * 2) + perfectDayBonus;

  static int levelFromTotalExp(int totalExp) {
    return (totalExp ~/ expPerLevel) + 1;
  }

  static int currentLevelExp(int totalExp) {
    return totalExp % expPerLevel;
  }
}
