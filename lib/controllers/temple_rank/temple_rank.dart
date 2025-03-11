import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../utility/utility.dart';

part 'temple_rank.freezed.dart';

part 'temple_rank.g.dart';

@freezed
class TempleRankState with _$TempleRankState {
  const factory TempleRankState({
    @Default(<String>[]) List<String> templeRankNameList,
    @Default(<String>[]) List<String> templeRankRankList,
  }) = _TempleRankState;
}

@Riverpod(keepAlive: true)
class TempleRank extends _$TempleRank {
  final Utility utility = Utility();

  ///
  @override
  TempleRankState build() {
    return TempleRankState(
      // ignore: always_specify_types
      templeRankNameList: List.generate(100, (int index) => ''),
      // ignore: always_specify_types
      templeRankRankList: List.generate(100, (int index) => ''),
    );
  }

  ///
  void setTempleRankNameAndRank({required int pos, required String name, required String rank}) {
    final List<String> list = <String>[...state.templeRankNameList];

    list[pos] = name;

    final List<String> list2 = <String>[...state.templeRankRankList];

    list2[pos] = rank;

    state = state.copyWith(templeRankNameList: list, templeRankRankList: list2);
  }

  ///
  void clearTempleRankNameAndRank() {
    state = state.copyWith(
      // ignore: always_specify_types
      templeRankNameList: List.generate(100, (int index) => ''),
      // ignore: always_specify_types
      templeRankRankList: List.generate(100, (int index) => ''),
    );
  }

  ///
  Future<void> inputTempleRank({required int recordNum}) async {
    final List<String> list = <String>[...state.templeRankNameList];

    final List<String> list2 = <String>[...state.templeRankRankList];

    final List<Map<String, String>> data = <Map<String, String>>[];

    for (int i = 0; i < recordNum; i++) {
      if (list[i] != '' && list2[i] != '') {
        data.add(<String, String>{'temple': list[i], 'rank': list2[i]});
      }
    }

    final HttpClient client = ref.read(httpClientProvider);

    await client
        .post(path: APIPath.insertTempleRank, body: <String, dynamic>{'data': data})
        // ignore: always_specify_types
        .then((value) {})
        // ignore: invalid_return_type_for_catch_error, always_specify_types
        .catchError((error, _) => utility.showError('予期せぬエラーが発生しました'));
  }
}
