import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utility/utility.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
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

    ///
    @Default('') String searchWord,
    @Default(false) bool doSearch,

    ///
    @Default('') String selectYear,

    //
    @Default('') String selectTempleName,
    @Default('') String selectTempleLat,
    @Default('') String selectTempleLng,

    //
    @Default(-1) int selectVisitedTempleListKey,

    //
    @Default(<int>[]) List<int> selectTrainList,
  }) = _AppParamState;
}

@Riverpod(keepAlive: true)
class AppParam extends _$AppParam {
  final Utility utility = Utility();

  ///
  @override
  AppParamState build() => const AppParamState();

  ///
  void doSearch({required String searchWord}) => state = state.copyWith(searchWord: searchWord, doSearch: true);

  ///
  void clearSearch() => state = state.copyWith(searchWord: '', doSearch: false);

  ///
  void setSelectYear({required String year}) => state = state.copyWith(selectYear: year);

  ///
  void setSelectTemple({required String name, required String lat, required String lng}) =>
      state = state.copyWith(selectTempleName: name, selectTempleLat: lat, selectTempleLng: lng);

  ///
  void setSelectVisitedTempleListKey({required int key}) => state = state.copyWith(selectVisitedTempleListKey: key);

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

  ///
  void setVisitedTempleSelectedRank({required String rank}) => state = state.copyWith(visitedTempleSelectedRank: rank);

  ///
  void setVisitedTempleFromHomeLatLng({required LatLng latlng}) =>
      state = state.copyWith(visitedTempleFromHomeLatLng: latlng);

  ///
  void setVisitedTempleFromHomeSelectedDateList({required String date}) {
    final List<String> dateList = <String>[...state.visitedTempleFromHomeSelectedDateList];
    (dateList.contains(date)) ? dateList.remove(date) : dateList.add(date);
    state = state.copyWith(visitedTempleFromHomeSelectedDateList: dateList);
  }

  ///
  void clearVisitedTempleFromHomeSelectedDateList() =>
      state = state.copyWith(visitedTempleFromHomeSelectedDateList: <String>[]);

  ///
  void setVisitedTempleFromHomeSearchAddress({required String str}) {
    state = state.copyWith(visitedTempleFromHomeSearchAddress: str);
  }

  ///
  void setSelectedTokyoJinjachouTempleName({required String name}) =>
      state = state.copyWith(selectedTokyoJinjachouTempleName: name);

  ///
  void setTrainList({required int trainNumber}) {
    final List<int> list = <int>[...state.selectTrainList];

    if (list.contains(trainNumber)) {
      list.remove(trainNumber);
    } else {
      list.add(trainNumber);
    }

    state = state.copyWith(selectTrainList: list);
  }

  ///
  void clearTrainList() => state = state.copyWith(selectTrainList: <int>[]);
}
