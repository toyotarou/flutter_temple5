import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'app_params_response_state.freezed.dart';

@freezed
class AppParamsResponseState with _$AppParamsResponseState {
  const factory AppParamsResponseState({
    @Default(0) double currentZoom,
    @Default(5) int currentPaddingIndex,
    Offset? overlayPosition,

    ///
    List<OverlayEntry>? firstEntries,
    List<OverlayEntry>? secondEntries,

    ///
    @Default(false) bool visitedTempleMapDisplayFinish,

    ///
    @Default(true) bool homeTextFormFieldVisible,
    @Default('') String notReachTempleNearStationName,

    ///
    @Default(0) int visitedTempleSelectedYear,
    @Default('') String visitedTempleSelectedDate,
    @Default('') String visitedTempleSelectedRank,

    ///
    LatLng? visitedTempleFromHomeLatLng,
    @Default(<String>[]) List<String> visitedTempleFromHomeSelectedDateList,
    @Default('') String visitedTempleFromHomeSearchAddress,

    ///
    @Default('') String selectedTokyoJinjachouTempleName,
  }) = _AppParamsResponseState;
}
