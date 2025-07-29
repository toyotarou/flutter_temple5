import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../extensions/extensions.dart';
import '../../models/temple_photo_model.dart';
import '../../utility/utility.dart';

part 'temple_photo.freezed.dart';

part 'temple_photo.g.dart';

@freezed
class TemplePhotoState with _$TemplePhotoState {
  const factory TemplePhotoState({
    @Default(AsyncValue<List<TemplePhotoModel>>.loading()) AsyncValue<List<TemplePhotoModel>> templePhotoList,
    @Default(AsyncValue<Map<String, List<TemplePhotoModel>>>.loading())
    AsyncValue<Map<String, List<TemplePhotoModel>>> templePhotoTempleMap,
    @Default(AsyncValue<Map<String, List<TemplePhotoModel>>>.loading())
    AsyncValue<Map<String, List<TemplePhotoModel>>> templePhotoDateMap,
  }) = _TemplePhotoState;
}

@Riverpod(keepAlive: true)
class TemplePhoto extends _$TemplePhoto {
  final Utility utility = Utility();

  ///
  @override
  TemplePhotoState build() => const TemplePhotoState();

  ///
  Future<void> getTemplePhoto() async {
    try {
      const String url = 'http://toyohide.work/BrainLog/api/getTempleDatePhoto';

      final Response response = await post(Uri.parse(url));

      // ignore: always_specify_types
      final templePhoto = jsonDecode(response.body);

      final List<TemplePhotoModel> list = <TemplePhotoModel>[];
      final Map<String, List<TemplePhotoModel>> map = <String, List<TemplePhotoModel>>{};
      final Map<String, List<TemplePhotoModel>> map2 = <String, List<TemplePhotoModel>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < (templePhoto['data'] as List<dynamic>).length; i++) {
        // ignore: avoid_dynamic_calls
        final TemplePhotoModel value = TemplePhotoModel.fromJson(templePhoto['data'][i] as Map<String, dynamic>);

        map[value.date.yyyymmdd] = <TemplePhotoModel>[];

        map2[value.temple] = <TemplePhotoModel>[];
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < (templePhoto['data'] as List<dynamic>).length; i++) {
        // ignore: avoid_dynamic_calls
        final TemplePhotoModel value = TemplePhotoModel.fromJson(templePhoto['data'][i] as Map<String, dynamic>);

        list.add(value);

        map[value.date.yyyymmdd]?.add(value);

        map2[value.temple]?.add(value);
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
