import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/tokyo_station_model.dart';
import '../../utility/utility.dart';

part 'routing.freezed.dart';

part 'routing.g.dart';

@freezed
class RoutingState with _$RoutingState {
  const factory RoutingState({
    @Default(<TempleData>[]) List<TempleData> routingTempleDataList,
    @Default(<String, TempleData>{})
    Map<String, TempleData> routingTempleDataMap,

    ///
    @Default('') String startStationId,
    @Default('') String goalStationId,

    //
    @Default(true) bool startNow,
    @Default('') String startTime,

    //
    @Default(5) int walkSpeed,

    //
    @Default(20) int spotStayTime,

    //
    @Default(20) int adjustPercent,
  }) = _RoutingState;
}

@Riverpod(keepAlive: true)
class Routing extends _$Routing {
  final Utility utility = Utility();

  ///
  @override
  RoutingState build() => const RoutingState();

  ///
  void setRouting(
      {required TempleData templeData, TokyoStationModel? station}) {
    final List<TempleData> list = <TempleData>[...state.routingTempleDataList];

    if (list.isEmpty) {
      if (station != null) {
        final TempleData stationTempleData = TempleData(
          name: station.stationName,
          address: station.address,
          latitude: station.lat,
          longitude: station.lng,
          mark: station.id,
        );

        list.add(stationTempleData);
      }
    }

    if (station?.stationName == templeData.name) {
      if (list.last.mark.split('-').length == 2) {
        list.removeAt(list.length - 1);
      }
    } else {
      final List<String> markList = <String>[];
      for (final TempleData element in list) {
        markList.add(element.mark);
      }

      final int pos =
          markList.indexWhere((String element) => element == templeData.mark);

      if (pos != -1) {
        list.removeAt(pos);
      } else {
        list.add(templeData);
      }
    }

    if (station?.stationName != templeData.name) {
      if (templeData.mark.split('-').length == 2) {
        list[list.length - 1] = templeData;
      }
    }

    state = state.copyWith(routingTempleDataList: list);
  }

  ///
  void removeGoalStation() {
    final List<TempleData> list = <TempleData>[...state.routingTempleDataList];

    int pos = 0;
    for (int i = 1; i < list.length; i++) {
      final int exMarkLength = list[i].mark.split('-').length;

      if (exMarkLength == 2) {
        pos = i;
      }
    }

    list.removeAt(pos);

    state = state.copyWith(routingTempleDataList: list, goalStationId: '');
  }

  ///
  void clearRoutingTempleDataList() =>
      state = state.copyWith(routingTempleDataList: <TempleData>[]);

  ///
  void setStartStationId({required String id}) =>
      state = state.copyWith(startStationId: id);

  ///
  void setGoalStationId({required String id}) =>
      state = state.copyWith(goalStationId: id);

  ///
  void setSelectTime({required String time}) =>
      state = state.copyWith(startNow: false, startTime: time);

  ///
  void setWalkSpeed({required int speed}) =>
      state = state.copyWith(walkSpeed: speed);

  ///
  void setSpotStayTime({required int time}) =>
      state = state.copyWith(spotStayTime: time);

  ///
  void setAdjustPercent({required int adjust}) =>
      state = state.copyWith(adjustPercent: adjust);

  ///
  /// route_display_alert.dart
  Future<void> insertRoute() async {
    final List<TempleData> list = <TempleData>[...state.routingTempleDataList];
    final TempleData first = list.first;
    final TempleData last = list.last;

    final String firstMark = first.mark.split('-')[1];
    final String lastMark = last.mark.split('-')[1];

    final List<String> data = <String>['start-$firstMark'];
    for (int i = 1; i < list.length - 1; i++) {
      data.add(list[i].mark);
    }
    data.add('goal-$lastMark');

    final HttpClient client = ref.read(httpClientProvider);

    await client
        .post(
          path: APIPath.insertTempleRoute,
          body: <String, dynamic>{
            'date': DateTime.now().yyyymmdd,
            'data': data
          },
        )
        // ignore: always_specify_types
        .then((value) {})
        // ignore: always_specify_types
        .catchError((error, _) {
          utility.showError('予期せぬエラーが発生しました');
        });
  }
}
