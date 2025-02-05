import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/complement_temple_visited_date.dart';
import '../../utility/utility.dart';

part 'complement_temple_visited_date.freezed.dart';

part 'complement_temple_visited_date.g.dart';

@freezed
class ComplementTempleVisitedDateState with _$ComplementTempleVisitedDateState {
  const factory ComplementTempleVisitedDateState({
    @Default(<String, List<DateTime>>{}) Map<String, List<DateTime>> idBaseComplementTempleVisitedDateMap,
    @Default(<String, List<DateTime>>{}) Map<String, List<DateTime>> templeBaseComplementTempleVisitedDateMap,
  }) = _ComplementTempleVisitedDateState;
}

@Riverpod(keepAlive: true)
class ComplementTempleVisitedDate extends _$ComplementTempleVisitedDate {
  final Utility utility = Utility();

  ///
  @override
  ComplementTempleVisitedDateState build() => const ComplementTempleVisitedDateState();

  ///
  Future<void> getComplementTempleVisitedDate() async {
    final HttpClient client = ref.read(httpClientProvider);

    final Map<String, List<DateTime>> map = <String, List<DateTime>>{};
    final Map<String, List<DateTime>> map2 = <String, List<DateTime>>{};

    // ignore: always_specify_types
    await client.post(path: APIPath.getComplementTempleVisitedDate).then((value) {
      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final ComplementTempleVisitedDateModel val = ComplementTempleVisitedDateModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data'][i] as Map<String, dynamic>,
        );

        map[val.id] = val.date;
        map2[val.temple] = val.date;
      }

      state = state.copyWith(idBaseComplementTempleVisitedDateMap: map, templeBaseComplementTempleVisitedDateMap: map2);
      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}
