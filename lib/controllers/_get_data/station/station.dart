import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/station_model.dart';
import '../../../utility/utility.dart';

part 'station.freezed.dart';

part 'station.g.dart';

@freezed
class StationState with _$StationState {
  const factory StationState({
    @Default(<StationModel>[]) List<StationModel> stationList,
    @Default(<String, StationModel>{}) Map<String, StationModel> stationMap,
  }) = _StationState;
}

@Riverpod(keepAlive: true)
class Station extends _$Station {
  final Utility utility = Utility();

  ///
  @override
  StationState build() => const StationState();

  //============================================== api

  ///
  Future<StationState> fetchAllStationData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getAllStation);

      final List<StationModel> list = <StationModel>[];

      final Map<String, StationModel> map = <String, StationModel>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final StationModel val = StationModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.id.toString()] = val;
      }

      return state.copyWith(stationList: list, stationMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllStation() async {
    try {
      final StationState newState = await fetchAllStationData();

      state = newState;
    } catch (_) {}
  }

//============================================== api
}
