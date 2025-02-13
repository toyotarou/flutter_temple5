// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_params/app_params_notifier.dart';
import 'app_params/app_params_response_state.dart';
import 'complement_temple_visited_date/complement_temple_visited_date.dart';
import 'lat_lng_temple/lat_lng_temple.dart';
import 'routing/routing.dart';
import 'temple/temple.dart';

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

//  NotReachStationLineCountState get notReachStationLineCountState => ref.watch(notReachStationLineCountProvider as ProviderListenable<NotReachStationLineCountState>);

//==========================================//

  RoutingState get routingState => ref.watch(routingProvider);

  Routing get routingNotifier => ref.read(routingProvider.notifier);

//==========================================//

//  StationState get stationState => ref.watch(stationProvider as ProviderListenable<StationState>);

//==========================================//

  TempleState get templeState => ref.watch(templeProvider);

  Temple get templeNotifier => ref.read(templeProvider.notifier);

//==========================================//

//==========================================//
}
