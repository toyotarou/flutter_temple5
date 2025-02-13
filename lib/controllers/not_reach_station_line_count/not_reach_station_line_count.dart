import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/not_reach_station_line_count_model.dart';
import '../../utility/utility.dart';

part 'not_reach_station_line_count.freezed.dart';

part 'not_reach_station_line_count.g.dart';

@freezed
class NotReachStationLineCountState with _$NotReachStationLineCountState {
  const factory NotReachStationLineCountState({
    @Default(<NotReachStationCountModel>[]) List<NotReachStationCountModel> notReachStationCountList,
    @Default(<String, NotReachStationCountModel>{}) Map<String, NotReachStationCountModel> notReachStationCountMap,
    @Default(<NotReachLineCountModel>[]) List<NotReachLineCountModel> notReachLineCountList,
    @Default(<String, NotReachLineCountModel>{}) Map<String, NotReachLineCountModel> notReachLineCountMap,
  }) = _NotReachStationLineCountState;
}

@Riverpod(keepAlive: true)
class NotReachStationLineCount extends _$NotReachStationLineCount {
  final Utility utility = Utility();

  ///
  @override
  NotReachStationLineCountState build() => const NotReachStationLineCountState();

  ///
  Future<NotReachStationLineCountState> fetchNotReachStationLineCountData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getTempleNotReachTrain);

      final List<NotReachStationCountModel> list = <NotReachStationCountModel>[];

      final Map<String, NotReachStationCountModel> map = <String, NotReachStationCountModel>{};

      final List<NotReachLineCountModel> list2 = <NotReachLineCountModel>[];

      final Map<String, NotReachLineCountModel> map2 = <String, NotReachLineCountModel>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data']['not_reach_station_count'].length.toString().toInt(); i++) {
        final NotReachStationCountModel val = NotReachStationCountModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data']['not_reach_station_count'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.station] = val;
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data']['not_reach_line_count'].length.toString().toInt(); i++) {
        final NotReachLineCountModel val2 = NotReachLineCountModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data']['not_reach_line_count'][i] as Map<String, dynamic>,
        );

        list2.add(val2);
        map2[val2.line] = val2;
      }

      return state.copyWith(
        notReachStationCountList: list,
        notReachStationCountMap: map,
        notReachLineCountList: list2,
        notReachLineCountMap: map2,
      );
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllNotReachStationLineCount() async {
    try {
      final NotReachStationLineCountState newState = await fetchNotReachStationLineCountData();

      state = newState;
    } catch (_) {}
  }
}
