// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prefecture.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PrefectureState {
  List<PrefectureModel> get prefectureList =>
      throw _privateConstructorUsedError;
  Map<String, PrefectureModel> get prefectureMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of PrefectureState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrefectureStateCopyWith<PrefectureState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrefectureStateCopyWith<$Res> {
  factory $PrefectureStateCopyWith(
          PrefectureState value, $Res Function(PrefectureState) then) =
      _$PrefectureStateCopyWithImpl<$Res, PrefectureState>;
  @useResult
  $Res call(
      {List<PrefectureModel> prefectureList,
      Map<String, PrefectureModel> prefectureMap});
}

/// @nodoc
class _$PrefectureStateCopyWithImpl<$Res, $Val extends PrefectureState>
    implements $PrefectureStateCopyWith<$Res> {
  _$PrefectureStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrefectureState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prefectureList = null,
    Object? prefectureMap = null,
  }) {
    return _then(_value.copyWith(
      prefectureList: null == prefectureList
          ? _value.prefectureList
          : prefectureList // ignore: cast_nullable_to_non_nullable
              as List<PrefectureModel>,
      prefectureMap: null == prefectureMap
          ? _value.prefectureMap
          : prefectureMap // ignore: cast_nullable_to_non_nullable
              as Map<String, PrefectureModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrefectureStateImplCopyWith<$Res>
    implements $PrefectureStateCopyWith<$Res> {
  factory _$$PrefectureStateImplCopyWith(_$PrefectureStateImpl value,
          $Res Function(_$PrefectureStateImpl) then) =
      __$$PrefectureStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PrefectureModel> prefectureList,
      Map<String, PrefectureModel> prefectureMap});
}

/// @nodoc
class __$$PrefectureStateImplCopyWithImpl<$Res>
    extends _$PrefectureStateCopyWithImpl<$Res, _$PrefectureStateImpl>
    implements _$$PrefectureStateImplCopyWith<$Res> {
  __$$PrefectureStateImplCopyWithImpl(
      _$PrefectureStateImpl _value, $Res Function(_$PrefectureStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrefectureState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prefectureList = null,
    Object? prefectureMap = null,
  }) {
    return _then(_$PrefectureStateImpl(
      prefectureList: null == prefectureList
          ? _value._prefectureList
          : prefectureList // ignore: cast_nullable_to_non_nullable
              as List<PrefectureModel>,
      prefectureMap: null == prefectureMap
          ? _value._prefectureMap
          : prefectureMap // ignore: cast_nullable_to_non_nullable
              as Map<String, PrefectureModel>,
    ));
  }
}

/// @nodoc

class _$PrefectureStateImpl implements _PrefectureState {
  const _$PrefectureStateImpl(
      {final List<PrefectureModel> prefectureList = const <PrefectureModel>[],
      final Map<String, PrefectureModel> prefectureMap =
          const <String, PrefectureModel>{}})
      : _prefectureList = prefectureList,
        _prefectureMap = prefectureMap;

  final List<PrefectureModel> _prefectureList;
  @override
  @JsonKey()
  List<PrefectureModel> get prefectureList {
    if (_prefectureList is EqualUnmodifiableListView) return _prefectureList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prefectureList);
  }

  final Map<String, PrefectureModel> _prefectureMap;
  @override
  @JsonKey()
  Map<String, PrefectureModel> get prefectureMap {
    if (_prefectureMap is EqualUnmodifiableMapView) return _prefectureMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_prefectureMap);
  }

  @override
  String toString() {
    return 'PrefectureState(prefectureList: $prefectureList, prefectureMap: $prefectureMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrefectureStateImpl &&
            const DeepCollectionEquality()
                .equals(other._prefectureList, _prefectureList) &&
            const DeepCollectionEquality()
                .equals(other._prefectureMap, _prefectureMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_prefectureList),
      const DeepCollectionEquality().hash(_prefectureMap));

  /// Create a copy of PrefectureState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrefectureStateImplCopyWith<_$PrefectureStateImpl> get copyWith =>
      __$$PrefectureStateImplCopyWithImpl<_$PrefectureStateImpl>(
          this, _$identity);
}

abstract class _PrefectureState implements PrefectureState {
  const factory _PrefectureState(
          {final List<PrefectureModel> prefectureList,
          final Map<String, PrefectureModel> prefectureMap}) =
      _$PrefectureStateImpl;

  @override
  List<PrefectureModel> get prefectureList;
  @override
  Map<String, PrefectureModel> get prefectureMap;

  /// Create a copy of PrefectureState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrefectureStateImplCopyWith<_$PrefectureStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
