import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_list_model.dart';
import '../../utility/utility.dart';

part 'temple_list.freezed.dart';

part 'temple_list.g.dart';

@freezed
class TempleListState with _$TempleListState {
  const factory TempleListState({
    @Default(<TempleListModel>[]) List<TempleListModel> templeListList,
    @Default(<String, TempleListModel>{})
    Map<String, TempleListModel> templeListMap,
    @Default(<String, List<TempleListModel>>{})
    Map<String, List<TempleListModel>> templeStationMap,
  }) = _TempleListState;
}

@Riverpod(keepAlive: true)
class TempleList extends _$TempleList {
  final Utility utility = Utility();

  ///
  @override
  Future<TempleListState> build() async => getAllTempleListTemple();

  ///
  /// home_screen.dart
  Future<TempleListState> getAllTempleListTemple() async {
    final List<TempleListModel> list = <TempleListModel>[];
    final Map<String, TempleListModel> map = <String, TempleListModel>{};
    final Map<String, List<TempleListModel>> templeStationMap =
        <String, List<TempleListModel>>{};

    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client.post(path: APIPath.getTempleListTemple).then((value) {
      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final TempleListModel val = TempleListModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.name] = val;

        val.nearStation.split(',').forEach((String element) {
          templeStationMap[element.trim()] = <TempleListModel>[];
        });
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final TempleListModel val = TempleListModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data'][i] as Map<String, dynamic>,
        );

        val.nearStation.split(',').forEach((String element) {
          templeStationMap[element.trim()]?.add(val);
        });
      }

      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });

    return TempleListState(
      templeListList: list,
      templeListMap: map,
      templeStationMap: templeStationMap,
    );
  }
}
