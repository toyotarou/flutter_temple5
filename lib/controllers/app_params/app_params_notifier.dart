import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_params_response_state.dart';

final AutoDisposeStateNotifierProvider<AppParamNotifier, AppParamsResponseState> appParamProvider =
    StateNotifierProvider.autoDispose<AppParamNotifier, AppParamsResponseState>(
        (AutoDisposeStateNotifierProviderRef<AppParamNotifier, AppParamsResponseState> ref) {
  return AppParamNotifier(const AppParamsResponseState());
});

class AppParamNotifier extends StateNotifier<AppParamsResponseState> {
  AppParamNotifier(super.state);

  ///
  void setCurrentZoom({required double zoom}) => state = state.copyWith(currentZoom: zoom);

  ///
  void setFirstOverlayParams({required List<OverlayEntry>? firstEntries}) =>
      state = state.copyWith(firstEntries: firstEntries);

  ///
  void setSecondOverlayParams({required List<OverlayEntry>? secondEntries}) =>
      state = state.copyWith(secondEntries: secondEntries);

  ///
  void updateOverlayPosition(Offset newPos) => state = state.copyWith(overlayPosition: newPos);

  ///
  void setVisitedTempleMapDisplayFinish({required bool flag}) =>
      state = state.copyWith(visitedTempleMapDisplayFinish: flag);

  ///
  void setHomeTextFormFieldVisible({required bool flag}) => state = state.copyWith(homeTextFormFieldVisible: flag);

  ///
  void setNotReachTempleNearStationName({required String name}) =>
      state = state.copyWith(notReachTempleNearStationName: name);

  ///
  void setVisitedTempleSelectedYear({required int year}) => state = state.copyWith(visitedTempleSelectedYear: year);

  ///
  void setVisitedTempleSelectedDate({required String date}) => state = state.copyWith(visitedTempleSelectedDate: date);
}
