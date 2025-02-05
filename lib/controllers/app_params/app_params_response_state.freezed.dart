// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_params_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppParamsResponseState {
  double get currentZoom => throw _privateConstructorUsedError;
  int get currentPaddingIndex => throw _privateConstructorUsedError;
  Offset? get overlayPosition => throw _privateConstructorUsedError;

  ///
  List<OverlayEntry>? get firstEntries => throw _privateConstructorUsedError;
  List<OverlayEntry>? get secondEntries => throw _privateConstructorUsedError;

  /// Create a copy of AppParamsResponseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppParamsResponseStateCopyWith<AppParamsResponseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppParamsResponseStateCopyWith<$Res> {
  factory $AppParamsResponseStateCopyWith(AppParamsResponseState value,
          $Res Function(AppParamsResponseState) then) =
      _$AppParamsResponseStateCopyWithImpl<$Res, AppParamsResponseState>;
  @useResult
  $Res call(
      {double currentZoom,
      int currentPaddingIndex,
      Offset? overlayPosition,
      List<OverlayEntry>? firstEntries,
      List<OverlayEntry>? secondEntries});
}

/// @nodoc
class _$AppParamsResponseStateCopyWithImpl<$Res,
        $Val extends AppParamsResponseState>
    implements $AppParamsResponseStateCopyWith<$Res> {
  _$AppParamsResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppParamsResponseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentZoom = null,
    Object? currentPaddingIndex = null,
    Object? overlayPosition = freezed,
    Object? firstEntries = freezed,
    Object? secondEntries = freezed,
  }) {
    return _then(_value.copyWith(
      currentZoom: null == currentZoom
          ? _value.currentZoom
          : currentZoom // ignore: cast_nullable_to_non_nullable
              as double,
      currentPaddingIndex: null == currentPaddingIndex
          ? _value.currentPaddingIndex
          : currentPaddingIndex // ignore: cast_nullable_to_non_nullable
              as int,
      overlayPosition: freezed == overlayPosition
          ? _value.overlayPosition
          : overlayPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
      firstEntries: freezed == firstEntries
          ? _value.firstEntries
          : firstEntries // ignore: cast_nullable_to_non_nullable
              as List<OverlayEntry>?,
      secondEntries: freezed == secondEntries
          ? _value.secondEntries
          : secondEntries // ignore: cast_nullable_to_non_nullable
              as List<OverlayEntry>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppParamsResponseStateImplCopyWith<$Res>
    implements $AppParamsResponseStateCopyWith<$Res> {
  factory _$$AppParamsResponseStateImplCopyWith(
          _$AppParamsResponseStateImpl value,
          $Res Function(_$AppParamsResponseStateImpl) then) =
      __$$AppParamsResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double currentZoom,
      int currentPaddingIndex,
      Offset? overlayPosition,
      List<OverlayEntry>? firstEntries,
      List<OverlayEntry>? secondEntries});
}

/// @nodoc
class __$$AppParamsResponseStateImplCopyWithImpl<$Res>
    extends _$AppParamsResponseStateCopyWithImpl<$Res,
        _$AppParamsResponseStateImpl>
    implements _$$AppParamsResponseStateImplCopyWith<$Res> {
  __$$AppParamsResponseStateImplCopyWithImpl(
      _$AppParamsResponseStateImpl _value,
      $Res Function(_$AppParamsResponseStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppParamsResponseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentZoom = null,
    Object? currentPaddingIndex = null,
    Object? overlayPosition = freezed,
    Object? firstEntries = freezed,
    Object? secondEntries = freezed,
  }) {
    return _then(_$AppParamsResponseStateImpl(
      currentZoom: null == currentZoom
          ? _value.currentZoom
          : currentZoom // ignore: cast_nullable_to_non_nullable
              as double,
      currentPaddingIndex: null == currentPaddingIndex
          ? _value.currentPaddingIndex
          : currentPaddingIndex // ignore: cast_nullable_to_non_nullable
              as int,
      overlayPosition: freezed == overlayPosition
          ? _value.overlayPosition
          : overlayPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
      firstEntries: freezed == firstEntries
          ? _value._firstEntries
          : firstEntries // ignore: cast_nullable_to_non_nullable
              as List<OverlayEntry>?,
      secondEntries: freezed == secondEntries
          ? _value._secondEntries
          : secondEntries // ignore: cast_nullable_to_non_nullable
              as List<OverlayEntry>?,
    ));
  }
}

/// @nodoc

class _$AppParamsResponseStateImpl implements _AppParamsResponseState {
  const _$AppParamsResponseStateImpl(
      {this.currentZoom = 0,
      this.currentPaddingIndex = 5,
      this.overlayPosition,
      final List<OverlayEntry>? firstEntries,
      final List<OverlayEntry>? secondEntries})
      : _firstEntries = firstEntries,
        _secondEntries = secondEntries;

  @override
  @JsonKey()
  final double currentZoom;
  @override
  @JsonKey()
  final int currentPaddingIndex;
  @override
  final Offset? overlayPosition;

  ///
  final List<OverlayEntry>? _firstEntries;

  ///
  @override
  List<OverlayEntry>? get firstEntries {
    final value = _firstEntries;
    if (value == null) return null;
    if (_firstEntries is EqualUnmodifiableListView) return _firstEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<OverlayEntry>? _secondEntries;
  @override
  List<OverlayEntry>? get secondEntries {
    final value = _secondEntries;
    if (value == null) return null;
    if (_secondEntries is EqualUnmodifiableListView) return _secondEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AppParamsResponseState(currentZoom: $currentZoom, currentPaddingIndex: $currentPaddingIndex, overlayPosition: $overlayPosition, firstEntries: $firstEntries, secondEntries: $secondEntries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppParamsResponseStateImpl &&
            (identical(other.currentZoom, currentZoom) ||
                other.currentZoom == currentZoom) &&
            (identical(other.currentPaddingIndex, currentPaddingIndex) ||
                other.currentPaddingIndex == currentPaddingIndex) &&
            (identical(other.overlayPosition, overlayPosition) ||
                other.overlayPosition == overlayPosition) &&
            const DeepCollectionEquality()
                .equals(other._firstEntries, _firstEntries) &&
            const DeepCollectionEquality()
                .equals(other._secondEntries, _secondEntries));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentZoom,
      currentPaddingIndex,
      overlayPosition,
      const DeepCollectionEquality().hash(_firstEntries),
      const DeepCollectionEquality().hash(_secondEntries));

  /// Create a copy of AppParamsResponseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppParamsResponseStateImplCopyWith<_$AppParamsResponseStateImpl>
      get copyWith => __$$AppParamsResponseStateImplCopyWithImpl<
          _$AppParamsResponseStateImpl>(this, _$identity);
}

abstract class _AppParamsResponseState implements AppParamsResponseState {
  const factory _AppParamsResponseState(
      {final double currentZoom,
      final int currentPaddingIndex,
      final Offset? overlayPosition,
      final List<OverlayEntry>? firstEntries,
      final List<OverlayEntry>? secondEntries}) = _$AppParamsResponseStateImpl;

  @override
  double get currentZoom;
  @override
  int get currentPaddingIndex;
  @override
  Offset? get overlayPosition;

  ///
  @override
  List<OverlayEntry>? get firstEntries;
  @override
  List<OverlayEntry>? get secondEntries;

  /// Create a copy of AppParamsResponseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppParamsResponseStateImplCopyWith<_$AppParamsResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
