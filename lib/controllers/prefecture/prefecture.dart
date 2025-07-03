import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../extensions/extensions.dart';
import '../../models/prefecture_model.dart';
import '../../utility/utility.dart';

part 'prefecture.freezed.dart';

part 'prefecture.g.dart';

@freezed
class PrefectureState with _$PrefectureState {
  const factory PrefectureState({
    @Default(<PrefectureModel>[]) List<PrefectureModel> prefectureList,
    @Default(<String, PrefectureModel>{}) Map<String, PrefectureModel> prefectureMap,
  }) = _PrefectureState;
}

@Riverpod(keepAlive: true)
class Prefecture extends _$Prefecture {
  final Utility utility = Utility();

  ///
  @override
  PrefectureState build() => const PrefectureState();

  //============================================== api

  ///
  Future<PrefectureState> fetchAllPrefectureData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.getByPath(path: 'https://apis.apima.net/k2srm05wzm1pdl3xk0sv/v1/prefectures/');

      final List<PrefectureModel> list = <PrefectureModel>[];
      final Map<String, PrefectureModel> map = <String, PrefectureModel>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final PrefectureModel val = PrefectureModel.fromJson(value[i] as Map<String, dynamic>);

        list.add(val);
        map[val.name!] = val;
      }

      return state.copyWith(prefectureList: list, prefectureMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllPrefectureData() async {
    try {
      final PrefectureState newState = await fetchAllPrefectureData();

      state = newState;
    } catch (_) {}
  }

//============================================== api
}
