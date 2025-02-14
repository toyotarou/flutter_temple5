import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/lat_lng_temple_model.dart';
import '../../models/near_station_model.dart';
import '../../utility/utility.dart';

part 'lat_lng_temple.freezed.dart';

part 'lat_lng_temple.g.dart';

@freezed
class LatLngTempleState with _$LatLngTempleState {
  const factory LatLngTempleState({
    @Default(<LatLngTempleModel>[]) List<LatLngTempleModel> latLngTempleList,
    @Default(<String, LatLngTempleModel>{})
    Map<String, LatLngTempleModel> latLngTempleMap,
    @Default(false) bool listSorting,
    @Default(false) bool orangeDisplay,
    NearStationResponseStationModel? selectedNearStation,
    @Default('') String paramLat,
    @Default('') String paramLng,
  }) = _LatLngTempleState;
}

@Riverpod(keepAlive: true)
class LatLngTemple extends _$LatLngTemple {
  final Utility utility = Utility();

  ///
  @override
  LatLngTempleState build() => const LatLngTempleState();

  ///
  /// temple_train_station_list_alert.dart
  Future<void> getLatLngTemple() async {
    final HttpClient client = ref.read(httpClientProvider);

    await client.post(
      path: APIPath.getLatLngTemple,
      body: <String, dynamic>{
        'latitude': state.paramLat,
        'longitude': state.paramLng,
        'radius': 10
      },
      // ignore: always_specify_types
    ).then((value) {
      final List<LatLngTempleModel> list = <LatLngTempleModel>[];
      final Map<String, LatLngTempleModel> map = <String, LatLngTempleModel>{};

      // ignore: avoid_dynamic_calls, always_specify_types
      final id = (value['data'][0] as Map<String, dynamic>)['id'];

      if (id != '88888888') {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          final LatLngTempleModel val = LatLngTempleModel.fromJson(
            // ignore: avoid_dynamic_calls
            value['data'][i] as Map<String, dynamic>,
          );

          list.add(val);
          map[val.name] = val;
        }
      }

      state = state.copyWith(latLngTempleList: list, latLngTempleMap: map);
      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }

  ///
  void setParamLatLng({required String latitude, required String longitude}) {
    state = state.copyWith(paramLat: latitude, paramLng: longitude);
  }

  ///
  void clearParamLatLng() {
    state = state.copyWith(paramLat: '', paramLng: '');
  }

  ///
  void setOrangeDisplay() {
    final bool orangeDisplay = state.orangeDisplay;
    state = state.copyWith(orangeDisplay: !orangeDisplay);
  }

  ///
  void setSelectedNearStation(
      {required NearStationResponseStationModel station}) {
    state = state.copyWith(selectedNearStation: station);
  }

  ///
  void clearSelectedNearStation() {
    state = state.copyWith(selectedNearStation: null);
  }
}
