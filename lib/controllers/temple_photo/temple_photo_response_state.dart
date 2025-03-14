import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/temple_photo_model.dart';

part 'temple_photo_response_state.freezed.dart';

@freezed
class TemplePhotoResponseState with _$TemplePhotoResponseState {
  const factory TemplePhotoResponseState({
    @Default(AsyncValue<List<TemplePhotoModel>>.loading()) AsyncValue<List<TemplePhotoModel>> templePhotoList,
    @Default(AsyncValue<Map<String, List<TemplePhotoModel>>>.loading())
    AsyncValue<Map<String, List<TemplePhotoModel>>> templePhotoTempleMap,
    @Default(AsyncValue<Map<String, List<TemplePhotoModel>>>.loading())
    AsyncValue<Map<String, List<TemplePhotoModel>>> templePhotoDateMap,
  }) = _TemplePhotoResponseState;
}
