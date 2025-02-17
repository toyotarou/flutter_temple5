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
    @Default(<String, TempleListModel>{}) Map<String, TempleListModel> templeListMap,
    @Default(<String, List<TempleListModel>>{}) Map<String, List<TempleListModel>> templeStationMap,
  }) = _TempleListState;
}

@Riverpod(keepAlive: true)
class TempleList extends _$TempleList {
  final Utility utility = Utility();

  ///
  @override
  TempleListState build() => const TempleListState();

  ///
  Future<TempleListState> fetchTempleListData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getTempleListTemple);

      final List<TempleListModel> list = <TempleListModel>[];

      final Map<String, TempleListModel> map = <String, TempleListModel>{};

      final Map<String, List<TempleListModel>> map2 = <String, List<TempleListModel>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final TempleListModel val = TempleListModel.fromJson(value['data'][i] as Map<String, dynamic>);

        list.add(val);
        map[val.name] = val;

        val.nearStation.split(',').forEach((String element) => map2[element.trim()] = <TempleListModel>[]);
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final TempleListModel val = TempleListModel.fromJson(value['data'][i] as Map<String, dynamic>);

        val.nearStation.split(',').forEach((String element) => map2[element.trim()]?.add(val));
      }

      return state.copyWith(templeListList: list, templeListMap: map, templeStationMap: map2);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllTempleList() async {
    try {
      final TempleListState newState = await fetchTempleListData();

      state = newState;
    } catch (_) {}
  }
}
