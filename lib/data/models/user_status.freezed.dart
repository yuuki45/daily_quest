// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserStatus {
  int get level => throw _privateConstructorUsedError;
  int get exp => throw _privateConstructorUsedError;
  int get totalExp => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  String? get lastCompletedDate => throw _privateConstructorUsedError;

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatusCopyWith<UserStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatusCopyWith<$Res> {
  factory $UserStatusCopyWith(
    UserStatus value,
    $Res Function(UserStatus) then,
  ) = _$UserStatusCopyWithImpl<$Res, UserStatus>;
  @useResult
  $Res call({
    int level,
    int exp,
    int totalExp,
    int streakDays,
    String? lastCompletedDate,
  });
}

/// @nodoc
class _$UserStatusCopyWithImpl<$Res, $Val extends UserStatus>
    implements $UserStatusCopyWith<$Res> {
  _$UserStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? exp = null,
    Object? totalExp = null,
    Object? streakDays = null,
    Object? lastCompletedDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            exp: null == exp
                ? _value.exp
                : exp // ignore: cast_nullable_to_non_nullable
                      as int,
            totalExp: null == totalExp
                ? _value.totalExp
                : totalExp // ignore: cast_nullable_to_non_nullable
                      as int,
            streakDays: null == streakDays
                ? _value.streakDays
                : streakDays // ignore: cast_nullable_to_non_nullable
                      as int,
            lastCompletedDate: freezed == lastCompletedDate
                ? _value.lastCompletedDate
                : lastCompletedDate // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserStatusImplCopyWith<$Res>
    implements $UserStatusCopyWith<$Res> {
  factory _$$UserStatusImplCopyWith(
    _$UserStatusImpl value,
    $Res Function(_$UserStatusImpl) then,
  ) = __$$UserStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int level,
    int exp,
    int totalExp,
    int streakDays,
    String? lastCompletedDate,
  });
}

/// @nodoc
class __$$UserStatusImplCopyWithImpl<$Res>
    extends _$UserStatusCopyWithImpl<$Res, _$UserStatusImpl>
    implements _$$UserStatusImplCopyWith<$Res> {
  __$$UserStatusImplCopyWithImpl(
    _$UserStatusImpl _value,
    $Res Function(_$UserStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? exp = null,
    Object? totalExp = null,
    Object? streakDays = null,
    Object? lastCompletedDate = freezed,
  }) {
    return _then(
      _$UserStatusImpl(
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        exp: null == exp
            ? _value.exp
            : exp // ignore: cast_nullable_to_non_nullable
                  as int,
        totalExp: null == totalExp
            ? _value.totalExp
            : totalExp // ignore: cast_nullable_to_non_nullable
                  as int,
        streakDays: null == streakDays
            ? _value.streakDays
            : streakDays // ignore: cast_nullable_to_non_nullable
                  as int,
        lastCompletedDate: freezed == lastCompletedDate
            ? _value.lastCompletedDate
            : lastCompletedDate // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UserStatusImpl implements _UserStatus {
  const _$UserStatusImpl({
    this.level = 1,
    this.exp = 0,
    this.totalExp = 0,
    this.streakDays = 0,
    this.lastCompletedDate,
  });

  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int exp;
  @override
  @JsonKey()
  final int totalExp;
  @override
  @JsonKey()
  final int streakDays;
  @override
  final String? lastCompletedDate;

  @override
  String toString() {
    return 'UserStatus(level: $level, exp: $exp, totalExp: $totalExp, streakDays: $streakDays, lastCompletedDate: $lastCompletedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatusImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.exp, exp) || other.exp == exp) &&
            (identical(other.totalExp, totalExp) ||
                other.totalExp == totalExp) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.lastCompletedDate, lastCompletedDate) ||
                other.lastCompletedDate == lastCompletedDate));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    level,
    exp,
    totalExp,
    streakDays,
    lastCompletedDate,
  );

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatusImplCopyWith<_$UserStatusImpl> get copyWith =>
      __$$UserStatusImplCopyWithImpl<_$UserStatusImpl>(this, _$identity);
}

abstract class _UserStatus implements UserStatus {
  const factory _UserStatus({
    final int level,
    final int exp,
    final int totalExp,
    final int streakDays,
    final String? lastCompletedDate,
  }) = _$UserStatusImpl;

  @override
  int get level;
  @override
  int get exp;
  @override
  int get totalExp;
  @override
  int get streakDays;
  @override
  String? get lastCompletedDate;

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatusImplCopyWith<_$UserStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
