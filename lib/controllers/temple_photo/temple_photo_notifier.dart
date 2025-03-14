// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:http/http.dart';

//
// import '../../models/holiday.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_photo_model.dart';
import 'temple_photo_response_state.dart';

final AutoDisposeStateNotifierProvider<TemplePhotoNotifier, TemplePhotoResponseState> templePhotoProvider =
    StateNotifierProvider.autoDispose<TemplePhotoNotifier, TemplePhotoResponseState>(
        (AutoDisposeStateNotifierProviderRef<TemplePhotoNotifier, TemplePhotoResponseState> ref) {
  return TemplePhotoNotifier(const TemplePhotoResponseState())..getTemplePhoto();
});

class TemplePhotoNotifier extends StateNotifier<TemplePhotoResponseState> {
  TemplePhotoNotifier(super.state);

  Future<void> getTemplePhoto() async {
    try {
      const String url = 'http://toyohide.work/BrainLog/api/getTempleDatePhoto';

      final Response response = await post(Uri.parse(url));

      // ignore: always_specify_types
      final templePhoto = jsonDecode(response.body);

      final List<TemplePhotoModel> list = <TemplePhotoModel>[];
      final Map<String, List<TemplePhotoModel>> map = <String, List<TemplePhotoModel>>{};
      final Map<String, List<TemplePhotoModel>> map2 = <String, List<TemplePhotoModel>>{};

      for (int i = 0; i < (templePhoto['data'] as List<dynamic>).length; i++) {
        final TemplePhotoModel value = TemplePhotoModel.fromJson(templePhoto['data'][i] as Map<String, dynamic>);

        map[value.date.yyyymmdd] = <TemplePhotoModel>[];

        map2[value.temple] = <TemplePhotoModel>[];
      }

      for (int i = 0; i < (templePhoto['data'] as List<dynamic>).length; i++) {
        final TemplePhotoModel value = TemplePhotoModel.fromJson(templePhoto['data'][i] as Map<String, dynamic>);

        if (value.date.isAfter(DateTime(2023, 3))) {
          list.add(value);

          map[value.date.yyyymmdd]?.add(value);

          map2[value.temple]?.add(value);
        }
      }

      state = state.copyWith(
        // ignore: always_specify_types
        templePhotoList: AsyncValue.data(list),
        // ignore: always_specify_types
        templePhotoDateMap: AsyncValue.data(map),
        // ignore: always_specify_types
        templePhotoTempleMap: AsyncValue.data(map2),
      );
    } catch (e) {
      // ignore: only_throw_errors
      throw e.toString();
    }
  }
}
