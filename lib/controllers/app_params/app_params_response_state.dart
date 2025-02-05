import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
  }) = _AppParamsResponseState;
}
