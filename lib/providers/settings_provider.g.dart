// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationEnabledHash() =>
    r'089a1a119afc55dc37cc1a12e4f6390f70ee24c2';

/// See also [NotificationEnabled].
@ProviderFor(NotificationEnabled)
final notificationEnabledProvider =
    AutoDisposeNotifierProvider<NotificationEnabled, bool>.internal(
  NotificationEnabled.new,
  name: r'notificationEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationEnabled = AutoDisposeNotifier<bool>;
String _$soundEnabledHash() => r'f72890c85638446f615da51e70d74fa22aa73021';

/// See also [SoundEnabled].
@ProviderFor(SoundEnabled)
final soundEnabledProvider =
    AutoDisposeNotifierProvider<SoundEnabled, bool>.internal(
  SoundEnabled.new,
  name: r'soundEnabledProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$soundEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SoundEnabled = AutoDisposeNotifier<bool>;
String _$themeModeSettingHash() => r'6402e10e626df833174ae619f566efea1e7ff1a0';

/// See also [ThemeModeSetting].
@ProviderFor(ThemeModeSetting)
final themeModeSettingProvider =
    AutoDisposeNotifierProvider<ThemeModeSetting, String>.internal(
  ThemeModeSetting.new,
  name: r'themeModeSettingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeSettingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeModeSetting = AutoDisposeNotifier<String>;
String _$settingsInitializerHash() =>
    r'7e43ef3ae6076a9615b135414f757700b2b3b96f';

/// See also [SettingsInitializer].
@ProviderFor(SettingsInitializer)
final settingsInitializerProvider =
    AutoDisposeAsyncNotifierProvider<SettingsInitializer, void>.internal(
  SettingsInitializer.new,
  name: r'settingsInitializerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsInitializerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsInitializer = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
