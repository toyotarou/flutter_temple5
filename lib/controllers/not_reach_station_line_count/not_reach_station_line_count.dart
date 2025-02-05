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
    @Default(<NotReachStationCountModel>[])
    List<NotReachStationCountModel> notReachStationCountList,
    @Default(<String, NotReachStationCountModel>{})
    Map<String, NotReachStationCountModel> notReachStationCountMap,
    @Default(<NotReachLineCountModel>[])
    List<NotReachLineCountModel> notReachLineCountList,
    @Default(<String, NotReachLineCountModel>{})
    Map<String, NotReachLineCountModel> notReachLineCountMap,
  }) = _NotReachStationLineCountState;
}

@Riverpod(keepAlive: true)
class NotReachStationLineCount extends _$NotReachStationLineCount {
  final Utility utility = Utility();

  ///
  @override
  Future<NotReachStationLineCountState> build() async {
    return getAllNotReachStationLineCount();
  }

  ///
  /// temple_train_station_list_alert.dart
  Future<NotReachStationLineCountState> getAllNotReachStationLineCount() async {
    final HttpClient client = ref.read(httpClientProvider);

    final List<NotReachStationCountModel> list = <NotReachStationCountModel>[];

    final Map<String, NotReachStationCountModel> map =
        <String, NotReachStationCountModel>{};

    final List<NotReachLineCountModel> list2 = <NotReachLineCountModel>[];

    final Map<String, NotReachLineCountModel> map2 =
        <String, NotReachLineCountModel>{};

    // ignore: always_specify_types
    await client.post(path: APIPath.getTempleNotReachTrain).then((value) {
      for (int i = 0;
          i <
              // ignore: avoid_dynamic_calls
              value['data']['not_reach_station_count']
                  .length
                  .toString()
                  .toInt();
          i++) {
        final NotReachStationCountModel val =
            NotReachStationCountModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data']['not_reach_station_count'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.station] = val;
      }

      for (int i = 0;
          // ignore: avoid_dynamic_calls
          i < value['data']['not_reach_line_count'].length.toString().toInt();
          i++) {
        final NotReachLineCountModel val2 = NotReachLineCountModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data']['not_reach_line_count'][i] as Map<String, dynamic>,
        );

        list2.add(val2);
        map2[val2.line] = val2;
      }

      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });

    return NotReachStationLineCountState(
        notReachStationCountList: list,
        notReachStationCountMap: map,
        notReachLineCountList: list2,
        notReachLineCountMap: map2);
  }
}
