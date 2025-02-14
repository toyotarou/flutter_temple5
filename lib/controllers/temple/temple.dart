import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_model.dart';
import '../../utility/utility.dart';

part 'temple.freezed.dart';

part 'temple.g.dart';

@freezed
class TempleState with _$TempleState {
  const factory TempleState({
    @Default(<TempleModel>[]) List<TempleModel> templeList,
    @Default(<String, TempleModel>{}) Map<String, TempleModel> dateTempleMap,
    @Default(<String, TempleModel>{}) Map<String, TempleModel> latLngTempleMap,
    @Default(<String, TempleModel>{}) Map<String, TempleModel> nameTempleMap,

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
    @Default(<String, List<String>>{}) Map<String, List<String>> templeVisitDateMap,

    //
    @Default(<String, List<String>>{}) Map<String, List<String>> templeCountMap,
  }) = _TempleState;
}

@Riverpod(keepAlive: true)
class Temple extends _$Temple {
  final Utility utility = Utility();

  ///
  @override
  TempleState build() => const TempleState();

  ///
  /// home_screen.dart
  /// visited_temple_list_alert.dart
  Future<void> getAllTemple() async {
    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client.post(path: APIPath.getAllTemple).then((value) {
      final List<TempleModel> list = <TempleModel>[];
      final Map<String, TempleModel> map = <String, TempleModel>{};
      final Map<String, TempleModel> map2 = <String, TempleModel>{};

      final Map<String, List<String>> map3 = <String, List<String>>{};
      final List<String> templeNameList = <String>[];

      final Map<String, List<String>> map4 = <String, List<String>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['list'].length.toString().toInt(); i++) {
        final TempleModel val = TempleModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['list'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.date.yyyymmdd] = val;

        map2['${val.lat}|${val.lng}'] = val;

        map3[val.temple] = <String>[];
        templeNameList.add(val.temple);

        map4[val.date.yyyy] = <String>[];
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['list'].length.toString().toInt(); i++) {
        final TempleModel val = TempleModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['list'][i] as Map<String, dynamic>,
        );

        val.memo.split('、').forEach((String element) {
          map3[element] = <String>[];
        });
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['list'].length.toString().toInt(); i++) {
        final TempleModel val = TempleModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['list'][i] as Map<String, dynamic>,
        );

        map3[val.temple]?.add(val.date.yyyymmdd);

        map4[val.date.yyyy]?.add(val.temple);

        val.memo.split('、').forEach((String element) {
          if (element != '') {
            map3[element]?.add(val.date.yyyymmdd);

            map4[val.date.yyyy]?.add(element);
          }
        });
      }

      state = state.copyWith(
        templeList: list,
        dateTempleMap: map,
        latLngTempleMap: map2,
        templeVisitDateMap: map3,
        templeCountMap: map4,
      );
      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }

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
}
