// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_params/app_params_notifier.dart';
import 'app_params/app_params_response_state.dart';
import 'complement_temple_visited_date/complement_temple_visited_date.dart';
import 'lat_lng_temple/lat_lng_temple.dart';
import 'not_reach_station_line_count/not_reach_station_line_count.dart';
import 'routing/routing.dart';
import 'station/station.dart';
import 'temple/temple.dart';
import 'temple_lat_lng/temple_lat_lng.dart';
import 'temple_list/temple_list.dart';
import 'temple_rank/temple_rank.dart';
import 'tokyo_train/tokyo_train.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//
  AppParamsResponseState get appParamState => ref.watch(appParamProvider);

  AppParamNotifier get appParamNotifier => ref.read(appParamProvider.notifier);

  //==========================================//

  ComplementTempleVisitedDateState get complementTempleVisitedDateState =>
      ref.watch(complementTempleVisitedDateProvider);

  ComplementTempleVisitedDate get complementTempleVisitedDateNotifier =>
      ref.read(complementTempleVisitedDateProvider.notifier);

  //==========================================//

  LatLngTempleState get latLngTempleState => ref.watch(latLngTempleProvider);

  LatLngTemple get latLngTempleNotifier => ref.read(latLngTempleProvider.notifier);

//==========================================//

//  NearStationState get nearStationState => ref.watch(nearStationProvider as ProviderListenable<NearStationState>);

//==========================================//

  NotReachStationLineCountState get notReachStationLineCountState => ref.watch(notReachStationLineCountProvider);

  NotReachStationLineCount get notReachStationLineCountNotifier => ref.read(notReachStationLineCountProvider.notifier);

//==========================================//

  RoutingState get routingState => ref.watch(routingProvider);

  Routing get routingNotifier => ref.read(routingProvider.notifier);

//==========================================//

  StationState get stationState => ref.watch(stationProvider);

  Station get stationNotifier => ref.read(stationProvider.notifier);

//==========================================//

  TempleState get templeState => ref.watch(templeProvider);

  Temple get templeNotifier => ref.read(templeProvider.notifier);

//==========================================//

  TempleLatLngState get templeLatLngState => ref.watch(templeLatLngProvider as ProviderListenable<TempleLatLngState>);

  TempleLatLng get templeLatLngNotifier => ref.read(templeLatLngProvider.notifier);

//==========================================//

  TempleListState get templeListState => ref.watch(templeListProvider as ProviderListenable<TempleListState>);

  TempleList get templeListNotifier => ref.read(templeListProvider.notifier);

//==========================================//

  TokyoTrainState get tokyoTrainState => ref.watch(tokyoTrainProvider);

  TokyoTrain get tokyoTrainNotifier => ref.read(tokyoTrainProvider.notifier);

//==========================================//

  TempleRankState get templeRankState => ref.watch(templeRankProvider);

  TempleRank get templeRankNotifier => ref.read(templeRankProvider.notifier);

//==========================================//
}
