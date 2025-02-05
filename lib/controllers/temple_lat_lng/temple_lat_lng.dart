import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../utility/utility.dart';

part 'temple_lat_lng.freezed.dart';

part 'temple_lat_lng.g.dart';

@freezed
class TempleLatLngState with _$TempleLatLngState {
  const factory TempleLatLngState({
    @Default(<TempleLatLngModel>[]) List<TempleLatLngModel> templeLatLngList,
    @Default(<String, TempleLatLngModel>{})
    Map<String, TempleLatLngModel> templeLatLngMap,
  }) = _TempleLatLngState;
}

@riverpod
class TempleLatLng extends _$TempleLatLng {
  final Utility utility = Utility();

  ///
  @override
  Future<TempleLatLngState> build() async => getAllTempleLatLng();

  ///
  /// temple_detail_map_alert.dart
  /// not_reach_temple_map_alert.dart
  /// visited_temple_map_alert.dart
  Future<TempleLatLngState> getAllTempleLatLng() async {
    final HttpClient client = ref.read(httpClientProvider);

    final List<TempleLatLngModel> list = <TempleLatLngModel>[];
    final Map<String, TempleLatLngModel> map = <String, TempleLatLngModel>{};

    // ignore: always_specify_types
    await client.post(path: APIPath.getTempleLatLng).then((value) {
      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['list'].length.toString().toInt(); i++) {
        final TempleLatLngModel val = TempleLatLngModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['list'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.temple] = val;
      }

      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });

    return TempleLatLngState(templeLatLngList: list, templeLatLngMap: map);
  }
}
