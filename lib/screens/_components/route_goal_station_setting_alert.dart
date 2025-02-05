import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/routing/routing.dart';
import '../../controllers/temple/temple.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/tokyo_station_model.dart';
import '../../models/tokyo_train_model.dart';

class RouteGoalStationSettingAlert extends ConsumerStatefulWidget {
  const RouteGoalStationSettingAlert(
      {super.key, required this.tokyoStationMap, required this.tokyoTrainList});

  final Map<String, TokyoStationModel> tokyoStationMap;
  final List<TokyoTrainModel> tokyoTrainList;

  @override
  ConsumerState<RouteGoalStationSettingAlert> createState() =>
      _GoalStationSettingAlertState();
}

class _GoalStationSettingAlertState
    extends ConsumerState<RouteGoalStationSettingAlert> {
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
            Expanded(child: displayGoalTrain()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayGoalTrain() {
    final List<Widget> list = <Widget>[];

    for (final TokyoTrainModel element in widget.tokyoTrainList) {
      list.add(ExpansionTile(
        collapsedIconColor: Colors.white,
        title: Text(element.trainName,
            style: const TextStyle(fontSize: 12, color: Colors.white)),
        children: element.station
            .map((TokyoStationModel e2) => displayGoalStation(data: e2))
            .toList(),
      ));
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
  Widget displayGoalStation({required TokyoStationModel data}) {
//    final tokyoTrainState = ref.watch(tokyoTrainProvider);

    final String goalStationId = ref.watch(
        routingProvider.select((RoutingState value) => value.goalStationId));

    final String startStationId = ref.watch(
        routingProvider.select((RoutingState value) => value.startStationId));

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 12,
          color:
              (data.id == goalStationId) ? Colors.yellowAccent : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(data.stationName),
            GestureDetector(
              onTap: () {
                ref
                    .read(routingProvider.notifier)
                    .setGoalStationId(id: data.id);

                ref
                    .read(templeProvider.notifier)
                    .setSelectTemple(name: '', lat: '', lng: '');

                final TokyoStationModel? station =
                    widget.tokyoStationMap[data.id];

                ref.read(routingProvider.notifier).setRouting(
                      templeData: TempleData(
                        name: (station != null) ? station.stationName : '',
                        address: (station != null) ? station.address : '',
                        latitude: (station != null) ? station.lat : '',
                        longitude: (station != null) ? station.lng : '',
                        mark: (station != null) ? station.id : '',
                      ),
                      station: widget.tokyoStationMap[startStationId],
                    );

                Navigator.pop(context);
              },
              child: Icon(
                Icons.location_on,
                color: (data.id == goalStationId)
                    ? Colors.yellowAccent.withOpacity(0.4)
                    : Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
