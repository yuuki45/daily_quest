// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyPlan _$DailyPlanFromJson(Map<String, dynamic> json) {
  return _DailyPlan.fromJson(json);
}

/// @nodoc
mixin _$DailyPlan {
  String get date => throw _privateConstructorUsedError; // YYYY-MM-DD format
  String? get mainTaskId => throw _privateConstructorUsedError; // メインタスク（1つ、必須）
  List<String> get subTaskIds =>
      throw _privateConstructorUsedError; // サブタスク（最大2つ、任意）
  bool get completedMain => throw _privateConstructorUsedError; // メインタスクの完了状態
  int get streakCount => throw _privateConstructorUsedError;
  int get plantStage => throw _privateConstructorUsedError;

  /// Serializes this DailyPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyPlanCopyWith<DailyPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyPlanCopyWith<$Res> {
  factory $DailyPlanCopyWith(DailyPlan value, $Res Function(DailyPlan) then) =
      _$DailyPlanCopyWithImpl<$Res, DailyPlan>;
  @useResult
  $Res call(
      {String date,
      String? mainTaskId,
      List<String> subTaskIds,
      bool completedMain,
      int streakCount,
      int plantStage});
}

/// @nodoc
class _$DailyPlanCopyWithImpl<$Res, $Val extends DailyPlan>
    implements $DailyPlanCopyWith<$Res> {
  _$DailyPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? mainTaskId = freezed,
    Object? subTaskIds = null,
    Object? completedMain = null,
    Object? streakCount = null,
    Object? plantStage = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      mainTaskId: freezed == mainTaskId
          ? _value.mainTaskId
          : mainTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      subTaskIds: null == subTaskIds
          ? _value.subTaskIds
          : subTaskIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedMain: null == completedMain
          ? _value.completedMain
          : completedMain // ignore: cast_nullable_to_non_nullable
              as bool,
      streakCount: null == streakCount
          ? _value.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      plantStage: null == plantStage
          ? _value.plantStage
          : plantStage // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyPlanImplCopyWith<$Res>
    implements $DailyPlanCopyWith<$Res> {
  factory _$$DailyPlanImplCopyWith(
          _$DailyPlanImpl value, $Res Function(_$DailyPlanImpl) then) =
      __$$DailyPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      String? mainTaskId,
      List<String> subTaskIds,
      bool completedMain,
      int streakCount,
      int plantStage});
}

/// @nodoc
class __$$DailyPlanImplCopyWithImpl<$Res>
    extends _$DailyPlanCopyWithImpl<$Res, _$DailyPlanImpl>
    implements _$$DailyPlanImplCopyWith<$Res> {
  __$$DailyPlanImplCopyWithImpl(
      _$DailyPlanImpl _value, $Res Function(_$DailyPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? mainTaskId = freezed,
    Object? subTaskIds = null,
    Object? completedMain = null,
    Object? streakCount = null,
    Object? plantStage = null,
  }) {
    return _then(_$DailyPlanImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      mainTaskId: freezed == mainTaskId
          ? _value.mainTaskId
          : mainTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      subTaskIds: null == subTaskIds
          ? _value._subTaskIds
          : subTaskIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedMain: null == completedMain
          ? _value.completedMain
          : completedMain // ignore: cast_nullable_to_non_nullable
              as bool,
      streakCount: null == streakCount
          ? _value.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      plantStage: null == plantStage
          ? _value.plantStage
          : plantStage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyPlanImpl implements _DailyPlan {
  const _$DailyPlanImpl(
      {required this.date,
      this.mainTaskId,
      final List<String> subTaskIds = const [],
      this.completedMain = false,
      this.streakCount = 0,
      this.plantStage = 0})
      : _subTaskIds = subTaskIds;

  factory _$DailyPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyPlanImplFromJson(json);

  @override
  final String date;
// YYYY-MM-DD format
  @override
  final String? mainTaskId;
// メインタスク（1つ、必須）
  final List<String> _subTaskIds;
// メインタスク（1つ、必須）
  @override
  @JsonKey()
  List<String> get subTaskIds {
    if (_subTaskIds is EqualUnmodifiableListView) return _subTaskIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subTaskIds);
  }

// サブタスク（最大2つ、任意）
  @override
  @JsonKey()
  final bool completedMain;
// メインタスクの完了状態
  @override
  @JsonKey()
  final int streakCount;
  @override
  @JsonKey()
  final int plantStage;

  @override
  String toString() {
    return 'DailyPlan(date: $date, mainTaskId: $mainTaskId, subTaskIds: $subTaskIds, completedMain: $completedMain, streakCount: $streakCount, plantStage: $plantStage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyPlanImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.mainTaskId, mainTaskId) ||
                other.mainTaskId == mainTaskId) &&
            const DeepCollectionEquality()
                .equals(other._subTaskIds, _subTaskIds) &&
            (identical(other.completedMain, completedMain) ||
                other.completedMain == completedMain) &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            (identical(other.plantStage, plantStage) ||
                other.plantStage == plantStage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      mainTaskId,
      const DeepCollectionEquality().hash(_subTaskIds),
      completedMain,
      streakCount,
      plantStage);

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyPlanImplCopyWith<_$DailyPlanImpl> get copyWith =>
      __$$DailyPlanImplCopyWithImpl<_$DailyPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyPlanImplToJson(
      this,
    );
  }
}

abstract class _DailyPlan implements DailyPlan {
  const factory _DailyPlan(
      {required final String date,
      final String? mainTaskId,
      final List<String> subTaskIds,
      final bool completedMain,
      final int streakCount,
      final int plantStage}) = _$DailyPlanImpl;

  factory _DailyPlan.fromJson(Map<String, dynamic> json) =
      _$DailyPlanImpl.fromJson;

  @override
  String get date; // YYYY-MM-DD format
  @override
  String? get mainTaskId; // メインタスク（1つ、必須）
  @override
  List<String> get subTaskIds; // サブタスク（最大2つ、任意）
  @override
  bool get completedMain; // メインタスクの完了状態
  @override
  int get streakCount;
  @override
  int get plantStage;

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyPlanImplCopyWith<_$DailyPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
