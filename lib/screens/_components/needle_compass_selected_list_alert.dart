import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../utility/utility.dart';

class NeedleCompassSelectedListAlert extends ConsumerStatefulWidget {
  const NeedleCompassSelectedListAlert({super.key, required this.selectedGeoloc});

  final Set<LatLng> selectedGeoloc;

  @override
  ConsumerState<NeedleCompassSelectedListAlert> createState() => _NeedleCompassSelectedListAlertState();
}

class _NeedleCompassSelectedListAlertState extends ConsumerState<NeedleCompassSelectedListAlert>
    with ControllersMixin<NeedleCompassSelectedListAlert> {
  Utility utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Container(width: context.screenSize.width),
          Expanded(child: displayNeedleCompassSelectedTempleList()),
        ],
      )),
    );
  }

  ///
  Widget displayNeedleCompassSelectedTempleList() {
    final List<Widget> list = <Widget>[];

    final Map<double, List<TempleData>> map = <double, List<TempleData>>{};

    final List<double> distanceList = <double>[];

    String distance = '';

    for (final LatLng element in widget.selectedGeoloc) {
      distance = utility
          .calculateDistance(const LatLng(zenpukujiLat, zenpukujiLng), LatLng(element.latitude, element.longitude))
          .toString();

      map[distance.toDouble()] = <TempleData>[];

      distanceList.add(distance.toDouble());
    }

    for (final LatLng element in widget.selectedGeoloc) {
      distance = utility
          .calculateDistance(const LatLng(zenpukujiLat, zenpukujiLng), LatLng(element.latitude, element.longitude))
          .toString();

      final TempleLatLngModel? templeLatLngModel =
          templeLatLngState.templeLatLngLatLngMap['${element.latitude}|${element.longitude}'];

      map[distance.toDouble()]?.add(
        TempleData(
          name: templeLatLngModel?.temple ?? '',
          address: templeLatLngModel?.address ?? '',
          latitude: element.latitude.toString(),
          longitude: element.longitude.toString(),
          mark: templeLatLngModel?.rank ?? '',
        ),
      );
    }

    distanceList
      ..sort((double a, double b) => a.compareTo(b) * -1)
      ..forEach(
        (double element) {
          map[element]?.forEach(
            (TempleData element2) {
              list.add(
                DefaultTextStyle(
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(element.toString()),
                            Text(element2.name),
                            Text(element2.address),
                            Text(element2.latitude),
                            Text(element2.longitude),
                            Text(element2.mark),
                          ],
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) => list[index], childCount: list.length),
        ),
      ],
    );
  }
}
