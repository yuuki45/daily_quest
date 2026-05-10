// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_plan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mainTaskHash() => r'0f8c2b96f0abf792f6e63e72dad02a5bc4a9f51b';

/// See also [mainTask].
@ProviderFor(mainTask)
final mainTaskProvider = AutoDisposeProvider<Task?>.internal(
  mainTask,
  name: r'mainTaskProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mainTaskHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MainTaskRef = AutoDisposeProviderRef<Task?>;
String _$subTasksHash() => r'16d23814141d4647f4a2c1737f988c9ffc9d1af8';

/// See also [subTasks].
@ProviderFor(subTasks)
final subTasksProvider = AutoDisposeProvider<List<Task>>.internal(
  subTasks,
  name: r'subTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$subTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubTasksRef = AutoDisposeProviderRef<List<Task>>;
String _$todaysTasksHash() => r'5375a5bd9695da410bde62bfcd89cb6ad44f1fe5';

/// See also [todaysTasks].
@ProviderFor(todaysTasks)
final todaysTasksProvider = AutoDisposeProvider<List<Task>>.internal(
  todaysTasks,
  name: r'todaysTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todaysTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodaysTasksRef = AutoDisposeProviderRef<List<Task>>;
String _$plantEmojiHash() => r'6e72ca544cf48cec1e338483bc1611368ae35d3d';

/// See also [plantEmoji].
@ProviderFor(plantEmoji)
final plantEmojiProvider = AutoDisposeProvider<String>.internal(
  plantEmoji,
  name: r'plantEmojiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$plantEmojiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlantEmojiRef = AutoDisposeProviderRef<String>;
String _$isTodayCompleteHash() => r'74deeeddd5706f222c99a7bfb836dc68793ccab1';

/// See also [isTodayComplete].
@ProviderFor(isTodayComplete)
final isTodayCompleteProvider = AutoDisposeProvider<bool>.internal(
  isTodayComplete,
  name: r'isTodayCompleteProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isTodayCompleteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsTodayCompleteRef = AutoDisposeProviderRef<bool>;
String _$tomorrowPlanHash() => r'a375cd5cc06825ba4893d0d0054960788924d831';

/// See also [tomorrowPlan].
@ProviderFor(tomorrowPlan)
final tomorrowPlanProvider = AutoDisposeProvider<DailyPlan>.internal(
  tomorrowPlan,
  name: r'tomorrowPlanProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tomorrowPlanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TomorrowPlanRef = AutoDisposeProviderRef<DailyPlan>;
String _$tomorrowMainTaskHash() => r'7a2eed416bec8c4f52940cd00d97f975daf13058';

/// See also [tomorrowMainTask].
@ProviderFor(tomorrowMainTask)
final tomorrowMainTaskProvider = AutoDisposeProvider<Task?>.internal(
  tomorrowMainTask,
  name: r'tomorrowMainTaskProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tomorrowMainTaskHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TomorrowMainTaskRef = AutoDisposeProviderRef<Task?>;
String _$tomorrowSubTasksHash() => r'246c6d2db53a6481e8cd0482440867ee1626edea';

/// See also [tomorrowSubTasks].
@ProviderFor(tomorrowSubTasks)
final tomorrowSubTasksProvider = AutoDisposeProvider<List<Task>>.internal(
  tomorrowSubTasks,
  name: r'tomorrowSubTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tomorrowSubTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TomorrowSubTasksRef = AutoDisposeProviderRef<List<Task>>;
String _$dailyPlanNotifierHash() => r'1f958a323dab93e7e2065cae6f22ac15f8c51fd9';

/// See also [DailyPlanNotifier].
@ProviderFor(DailyPlanNotifier)
final dailyPlanNotifierProvider =
    AutoDisposeNotifierProvider<DailyPlanNotifier, DailyPlan>.internal(
  DailyPlanNotifier.new,
  name: r'dailyPlanNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyPlanNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DailyPlanNotifier = AutoDisposeNotifier<DailyPlan>;
String _$tomorrowPlanNotifierHash() =>
    r'1143038a9a5d9ac3a37901da4326dd595bc5daac';

/// See also [TomorrowPlanNotifier].
@ProviderFor(TomorrowPlanNotifier)
final tomorrowPlanNotifierProvider =
    AutoDisposeNotifierProvider<TomorrowPlanNotifier, DailyPlan>.internal(
  TomorrowPlanNotifier.new,
  name: r'tomorrowPlanNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tomorrowPlanNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TomorrowPlanNotifier = AutoDisposeNotifier<DailyPlan>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
