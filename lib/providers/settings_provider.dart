import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tri_task/services/hive_service.dart';
import 'package:tri_task/services/notification_service.dart';

part 'settings_provider.g.dart';

// 設定のキー
class SettingsKeys {
  static const String notificationEnabled = 'notification_enabled';
  static const String soundEnabled = 'sound_enabled';
  static const String themeMode = 'theme_mode';
}

// 通知設定のプロバイダー
@riverpod
class NotificationEnabled extends _$NotificationEnabled {
  @override
  bool build() {
    return HiveService.getSetting<bool>(
      SettingsKeys.notificationEnabled,
      defaultValue: true,
    )!;
  }

  Future<void> toggle() async {
    final newValue = !state;
    await HiveService.saveSetting(SettingsKeys.notificationEnabled, newValue);
    state = newValue;

    // 通知の設定を反映
    if (!newValue) {
      await NotificationService.cancelAllNotifications();
    }
    // 通知ONの場合は、TomorrowPlanProviderが自動的にスケジュールする
  }

  Future<void> set(bool value) async {
    await HiveService.saveSetting(SettingsKeys.notificationEnabled, value);
    state = value;

    if (!value) {
      await NotificationService.cancelAllNotifications();
    }
    // 通知ONの場合は、TomorrowPlanProviderが自動的にスケジュールする
  }
}

// 効果音設定のプロバイダー
@riverpod
class SoundEnabled extends _$SoundEnabled {
  @override
  bool build() {
    return HiveService.getSetting<bool>(
      SettingsKeys.soundEnabled,
      defaultValue: true,
    )!;
  }

  Future<void> toggle() async {
    final newValue = !state;
    await HiveService.saveSetting(SettingsKeys.soundEnabled, newValue);
    state = newValue;
  }

  Future<void> set(bool value) async {
    await HiveService.saveSetting(SettingsKeys.soundEnabled, value);
    state = value;
  }
}

// テーマモード設定のプロバイダー
@riverpod
class ThemeModeSetting extends _$ThemeModeSetting {
  @override
  String build() {
    return HiveService.getSetting<String>(
      SettingsKeys.themeMode,
      defaultValue: 'light',
    )!;
  }

  Future<void> setTheme(String mode) async {
    await HiveService.saveSetting(SettingsKeys.themeMode, mode);
    state = mode;
  }
}

// すべての設定を初期化するプロバイダー
@riverpod
class SettingsInitializer extends _$SettingsInitializer {
  @override
  Future<void> build() async {
    // 古いID: 0の通知をキャンセル（もし存在すれば）
    await NotificationService.cancelNotification(0);

    // 通知スケジュールはTomorrowPlanProviderが自動的に行う
  }
}
