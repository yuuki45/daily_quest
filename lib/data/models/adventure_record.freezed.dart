// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adventure_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AdventureRecord {
  String get date => throw _privateConstructorUsedError;
  bool get mainQuestCompleted => throw _privateConstructorUsedError;
  int get sideQuestCompletedCount => throw _privateConstructorUsedError;
  int get gainedExp => throw _privateConstructorUsedError;
  bool get isPerfect => throw _privateConstructorUsedError;

  /// Create a copy of AdventureRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdventureRecordCopyWith<AdventureRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdventureRecordCopyWith<$Res> {
  factory $AdventureRecordCopyWith(
    AdventureRecord value,
    $Res Function(AdventureRecord) then,
  ) = _$AdventureRecordCopyWithImpl<$Res, AdventureRecord>;
  @useResult
  $Res call({
    String date,
    bool mainQuestCompleted,
    int sideQuestCompletedCount,
    int gainedExp,
    bool isPerfect,
  });
}

/// @nodoc
class _$AdventureRecordCopyWithImpl<$Res, $Val extends AdventureRecord>
    implements $AdventureRecordCopyWith<$Res> {
  _$AdventureRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdventureRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? mainQuestCompleted = null,
    Object? sideQuestCompletedCount = null,
    Object? gainedExp = null,
    Object? isPerfect = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            mainQuestCompleted: null == mainQuestCompleted
                ? _value.mainQuestCompleted
                : mainQuestCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            sideQuestCompletedCount: null == sideQuestCompletedCount
                ? _value.sideQuestCompletedCount
                : sideQuestCompletedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            gainedExp: null == gainedExp
                ? _value.gainedExp
                : gainedExp // ignore: cast_nullable_to_non_nullable
                      as int,
            isPerfect: null == isPerfect
                ? _value.isPerfect
                : isPerfect // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdventureRecordImplCopyWith<$Res>
    implements $AdventureRecordCopyWith<$Res> {
  factory _$$AdventureRecordImplCopyWith(
    _$AdventureRecordImpl value,
    $Res Function(_$AdventureRecordImpl) then,
  ) = __$$AdventureRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    bool mainQuestCompleted,
    int sideQuestCompletedCount,
    int gainedExp,
    bool isPerfect,
  });
}

/// @nodoc
class __$$AdventureRecordImplCopyWithImpl<$Res>
    extends _$AdventureRecordCopyWithImpl<$Res, _$AdventureRecordImpl>
    implements _$$AdventureRecordImplCopyWith<$Res> {
  __$$AdventureRecordImplCopyWithImpl(
    _$AdventureRecordImpl _value,
    $Res Function(_$AdventureRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdventureRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? mainQuestCompleted = null,
    Object? sideQuestCompletedCount = null,
    Object? gainedExp = null,
    Object? isPerfect = null,
  }) {
    return _then(
      _$AdventureRecordImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        mainQuestCompleted: null == mainQuestCompleted
            ? _value.mainQuestCompleted
            : mainQuestCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        sideQuestCompletedCount: null == sideQuestCompletedCount
            ? _value.sideQuestCompletedCount
            : sideQuestCompletedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        gainedExp: null == gainedExp
            ? _value.gainedExp
            : gainedExp // ignore: cast_nullable_to_non_nullable
                  as int,
        isPerfect: null == isPerfect
            ? _value.isPerfect
            : isPerfect // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AdventureRecordImpl implements _AdventureRecord {
  const _$AdventureRecordImpl({
    required this.date,
    this.mainQuestCompleted = false,
    this.sideQuestCompletedCount = 0,
    this.gainedExp = 0,
    this.isPerfect = false,
  });

  @override
  final String date;
  @override
  @JsonKey()
  final bool mainQuestCompleted;
  @override
  @JsonKey()
  final int sideQuestCompletedCount;
  @override
  @JsonKey()
  final int gainedExp;
  @override
  @JsonKey()
  final bool isPerfect;

  @override
  String toString() {
    return 'AdventureRecord(date: $date, mainQuestCompleted: $mainQuestCompleted, sideQuestCompletedCount: $sideQuestCompletedCount, gainedExp: $gainedExp, isPerfect: $isPerfect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdventureRecordImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.mainQuestCompleted, mainQuestCompleted) ||
                other.mainQuestCompleted == mainQuestCompleted) &&
            (identical(
                  other.sideQuestCompletedCount,
                  sideQuestCompletedCount,
                ) ||
                other.sideQuestCompletedCount == sideQuestCompletedCount) &&
            (identical(other.gainedExp, gainedExp) ||
                other.gainedExp == gainedExp) &&
            (identical(other.isPerfect, isPerfect) ||
                other.isPerfect == isPerfect));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    mainQuestCompleted,
    sideQuestCompletedCount,
    gainedExp,
    isPerfect,
  );

  /// Create a copy of AdventureRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdventureRecordImplCopyWith<_$AdventureRecordImpl> get copyWith =>
      __$$AdventureRecordImplCopyWithImpl<_$AdventureRecordImpl>(
        this,
        _$identity,
      );
}

abstract class _AdventureRecord implements AdventureRecord {
  const factory _AdventureRecord({
    required final String date,
    final bool mainQuestCompleted,
    final int sideQuestCompletedCount,
    final int gainedExp,
    final bool isPerfect,
  }) = _$AdventureRecordImpl;

  @override
  String get date;
  @override
  bool get mainQuestCompleted;
  @override
  int get sideQuestCompletedCount;
  @override
  int get gainedExp;
  @override
  bool get isPerfect;

  /// Create a copy of AdventureRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdventureRecordImplCopyWith<_$AdventureRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
