// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'boss.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Boss {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get maxHp => throw _privateConstructorUsedError;
  int get currentHp => throw _privateConstructorUsedError;
  String get weekStartDate => throw _privateConstructorUsedError;
  String get weekEndDate => throw _privateConstructorUsedError;
  String get imageKey => throw _privateConstructorUsedError;
  bool get defeated => throw _privateConstructorUsedError;

  /// Create a copy of Boss
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BossCopyWith<Boss> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BossCopyWith<$Res> {
  factory $BossCopyWith(Boss value, $Res Function(Boss) then) =
      _$BossCopyWithImpl<$Res, Boss>;
  @useResult
  $Res call({
    String id,
    String name,
    int maxHp,
    int currentHp,
    String weekStartDate,
    String weekEndDate,
    String imageKey,
    bool defeated,
  });
}

/// @nodoc
class _$BossCopyWithImpl<$Res, $Val extends Boss>
    implements $BossCopyWith<$Res> {
  _$BossCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Boss
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? maxHp = null,
    Object? currentHp = null,
    Object? weekStartDate = null,
    Object? weekEndDate = null,
    Object? imageKey = null,
    Object? defeated = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            maxHp: null == maxHp
                ? _value.maxHp
                : maxHp // ignore: cast_nullable_to_non_nullable
                      as int,
            currentHp: null == currentHp
                ? _value.currentHp
                : currentHp // ignore: cast_nullable_to_non_nullable
                      as int,
            weekStartDate: null == weekStartDate
                ? _value.weekStartDate
                : weekStartDate // ignore: cast_nullable_to_non_nullable
                      as String,
            weekEndDate: null == weekEndDate
                ? _value.weekEndDate
                : weekEndDate // ignore: cast_nullable_to_non_nullable
                      as String,
            imageKey: null == imageKey
                ? _value.imageKey
                : imageKey // ignore: cast_nullable_to_non_nullable
                      as String,
            defeated: null == defeated
                ? _value.defeated
                : defeated // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BossImplCopyWith<$Res> implements $BossCopyWith<$Res> {
  factory _$$BossImplCopyWith(
    _$BossImpl value,
    $Res Function(_$BossImpl) then,
  ) = __$$BossImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int maxHp,
    int currentHp,
    String weekStartDate,
    String weekEndDate,
    String imageKey,
    bool defeated,
  });
}

/// @nodoc
class __$$BossImplCopyWithImpl<$Res>
    extends _$BossCopyWithImpl<$Res, _$BossImpl>
    implements _$$BossImplCopyWith<$Res> {
  __$$BossImplCopyWithImpl(_$BossImpl _value, $Res Function(_$BossImpl) _then)
    : super(_value, _then);

  /// Create a copy of Boss
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? maxHp = null,
    Object? currentHp = null,
    Object? weekStartDate = null,
    Object? weekEndDate = null,
    Object? imageKey = null,
    Object? defeated = null,
  }) {
    return _then(
      _$BossImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        maxHp: null == maxHp
            ? _value.maxHp
            : maxHp // ignore: cast_nullable_to_non_nullable
                  as int,
        currentHp: null == currentHp
            ? _value.currentHp
            : currentHp // ignore: cast_nullable_to_non_nullable
                  as int,
        weekStartDate: null == weekStartDate
            ? _value.weekStartDate
            : weekStartDate // ignore: cast_nullable_to_non_nullable
                  as String,
        weekEndDate: null == weekEndDate
            ? _value.weekEndDate
            : weekEndDate // ignore: cast_nullable_to_non_nullable
                  as String,
        imageKey: null == imageKey
            ? _value.imageKey
            : imageKey // ignore: cast_nullable_to_non_nullable
                  as String,
        defeated: null == defeated
            ? _value.defeated
            : defeated // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$BossImpl implements _Boss {
  const _$BossImpl({
    required this.id,
    required this.name,
    required this.maxHp,
    required this.currentHp,
    required this.weekStartDate,
    required this.weekEndDate,
    required this.imageKey,
    this.defeated = false,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final int maxHp;
  @override
  final int currentHp;
  @override
  final String weekStartDate;
  @override
  final String weekEndDate;
  @override
  final String imageKey;
  @override
  @JsonKey()
  final bool defeated;

  @override
  String toString() {
    return 'Boss(id: $id, name: $name, maxHp: $maxHp, currentHp: $currentHp, weekStartDate: $weekStartDate, weekEndDate: $weekEndDate, imageKey: $imageKey, defeated: $defeated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BossImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.maxHp, maxHp) || other.maxHp == maxHp) &&
            (identical(other.currentHp, currentHp) ||
                other.currentHp == currentHp) &&
            (identical(other.weekStartDate, weekStartDate) ||
                other.weekStartDate == weekStartDate) &&
            (identical(other.weekEndDate, weekEndDate) ||
                other.weekEndDate == weekEndDate) &&
            (identical(other.imageKey, imageKey) ||
                other.imageKey == imageKey) &&
            (identical(other.defeated, defeated) ||
                other.defeated == defeated));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    maxHp,
    currentHp,
    weekStartDate,
    weekEndDate,
    imageKey,
    defeated,
  );

  /// Create a copy of Boss
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BossImplCopyWith<_$BossImpl> get copyWith =>
      __$$BossImplCopyWithImpl<_$BossImpl>(this, _$identity);
}

abstract class _Boss implements Boss {
  const factory _Boss({
    required final String id,
    required final String name,
    required final int maxHp,
    required final int currentHp,
    required final String weekStartDate,
    required final String weekEndDate,
    required final String imageKey,
    final bool defeated,
  }) = _$BossImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  int get maxHp;
  @override
  int get currentHp;
  @override
  String get weekStartDate;
  @override
  String get weekEndDate;
  @override
  String get imageKey;
  @override
  bool get defeated;

  /// Create a copy of Boss
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BossImplCopyWith<_$BossImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
