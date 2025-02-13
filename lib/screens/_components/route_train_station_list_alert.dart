import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../controllers/not_reach_station_line_count/not_reach_station_line_count.dart';
import '../../controllers/routing/routing.dart';
import '../../controllers/temple/temple.dart';
import '../../controllers/tokyo_train/tokyo_train.dart';
import '../../extensions/extensions.dart';
import '../../models/lat_lng_temple_model.dart';
import '../../models/not_reach_station_line_count_model.dart';
import '../../models/temple_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../models/tokyo_train_model.dart';
import '../_parts/_caution_dialog.dart';
import '../_parts/_temple_dialog.dart';
import 'route_setting_map_alert.dart';

class RouteTrainStationListAlert extends ConsumerStatefulWidget {
  const RouteTrainStationListAlert({
    super.key,
    required this.tokyoStationMap,
    required this.tokyoTrainList,
    required this.templeVisitDateMap,
    required this.dateTempleMap,
    required this.tokyoTrainIdMap,
  });

  final Map<String, TokyoStationModel> tokyoStationMap;
  final List<TokyoTrainModel> tokyoTrainList;
  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, TempleModel> dateTempleMap;
  final Map<int, TokyoTrainModel> tokyoTrainIdMap;

  @override
  ConsumerState<RouteTrainStationListAlert> createState() => _TempleTrainListAlertState();
}

class _TempleTrainListAlertState extends ConsumerState<RouteTrainStationListAlert>
    with ControllersMixin<RouteTrainStationListAlert> {
  int reachTempleNum = 0;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: displaySelectedStation(),
            ),
            const SizedBox(height: 20),
            Expanded(child: displayTokyoTrainList()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayTempleTrainStationListButton() {
    final String startStationId = ref.watch(routingProvider.select((RoutingState value) => value.startStationId));

    return IconButton(
      onPressed: (startStationId == '')
          ? null
          : () {
              if (latLngTempleState.latLngTempleList.isEmpty) {
                caution_dialog(context: context, content: 'no hit');

                return;
              }

              ref.read(routingProvider.notifier).clearRoutingTempleDataList();

              ref.read(routingProvider.notifier).setGoalStationId(id: '');

              latLngTempleNotifier.clearSelectedNearStation();

              ref.read(templeProvider.notifier).setSelectTemple(name: '', lat: '', lng: '');

              ref.read(tokyoTrainProvider.notifier).clearTrainList();

              latLngTempleNotifier.clearParamLatLng();

              TempleDialog(
                context: context,
                widget: RouteSettingMapAlert(
                  templeList: latLngTempleState.latLngTempleList,
                  station: widget.tokyoStationMap[startStationId],
                  tokyoStationMap: widget.tokyoStationMap,
                  tokyoTrainList: widget.tokyoTrainList,
                  templeVisitDateMap: widget.templeVisitDateMap,
                  dateTempleMap: widget.dateTempleMap,
                  tokyoTrainIdMap: widget.tokyoTrainIdMap,
                ),
                executeFunctionWhenDialogClose: true,
                ref: ref,
              );
            },
      icon: Icon(
        Icons.map,
        color: (startStationId != '' && latLngTempleState.latLngTempleList.isNotEmpty)
            ? Colors.yellowAccent.withOpacity(0.4)
            : Colors.white.withOpacity(0.4),
      ),
    );
  }

  ///
  Widget displaySelectedStation() {
    final String startStationId = ref.watch(routingProvider.select((RoutingState value) => value.startStationId));

    getReachTempleNum();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          (widget.tokyoStationMap[startStationId] != null)
              ? widget.tokyoStationMap[startStationId]!.stationName
              : '-----',
        ),
        Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(latLngTempleState.latLngTempleList.length.toString()),
                Text(reachTempleNum.toString()),
                Text(
                  (latLngTempleState.latLngTempleList.length - reachTempleNum).toString(),
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
              ],
            ),
            SizedBox(width: 40, child: displayTempleTrainStationListButton()),
          ],
        ),
      ],
    );
  }

  ///
  Widget displayTokyoTrainList() {
    final List<Widget> list = <Widget>[];

    final String startStationId = ref.watch(routingProvider.select((RoutingState value) => value.startStationId));

    final AsyncValue<NotReachStationLineCountState> notReachStationLineCountState =
        ref.watch(notReachStationLineCountProvider);

    final Map<String, NotReachLineCountModel>? notReachLineCountMap =
        notReachStationLineCountState.value?.notReachLineCountMap;

    final Map<String, NotReachStationCountModel>? notReachStationCountMap =
        notReachStationLineCountState.value?.notReachStationCountMap;

    for (final TokyoTrainModel element in widget.tokyoTrainList) {
      list.add(
        ExpansionTile(
          collapsedIconColor: Colors.white,
          backgroundColor: Colors.blueAccent.withOpacity(0.1),
          title: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  element.trainName,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                if (notReachLineCountMap != null) ...<Widget>[
                  Text(
                    (notReachLineCountMap[element.trainName]?.count ?? 0).toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: (notReachLineCountMap[element.trainName] != null) ? Colors.white : Colors.transparent,
                    ),
                  ),
                ],
              ],
            ),
          ),
          children: element.station.map((TokyoStationModel e2) {
            return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: (e2.id == startStationId) ? Colors.yellowAccent : Colors.white,
                  fontSize: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(e2.stationName),
                    Row(
                      children: <Widget>[
                        if (notReachStationCountMap != null) ...<Widget>[
                          Text(
                            (notReachStationCountMap[e2.stationName]?.count ?? 0).toString(),
                            style: TextStyle(
                              color:
                                  (notReachStationCountMap[e2.stationName] != null) ? Colors.white : Colors.transparent,
                            ),
                          ),
                        ],
                        GestureDetector(
                          onTap: () async {
                            latLngTempleNotifier.setParamLatLng(latitude: e2.lat, longitude: e2.lng);

                            latLngTempleNotifier.getLatLngTemple();

                            ref.read(routingProvider.notifier).setStartStationId(id: e2.id);
                          },
                          child: Icon(
                            Icons.location_on,
                            color: (e2.id == startStationId)
                                ? Colors.yellowAccent.withOpacity(0.4)
                                : Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  ///
  void getReachTempleNum() {
    reachTempleNum = 0;

    for (final LatLngTempleModel element in latLngTempleState.latLngTempleList) {
      if (element.cnt > 0) {
        reachTempleNum++;
      }
    }
  }
}
