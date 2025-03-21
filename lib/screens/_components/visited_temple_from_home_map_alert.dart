import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../utility/tile_provider.dart';

class VisitedTempleFromHomeMapAlert extends ConsumerStatefulWidget {
  const VisitedTempleFromHomeMapAlert({super.key});

  @override
  ConsumerState<VisitedTempleFromHomeMapAlert> createState() => _VisitedTempleFromHomeMapAlertState();
}

class _VisitedTempleFromHomeMapAlertState extends ConsumerState<VisitedTempleFromHomeMapAlert>
    with ControllersMixin<VisitedTempleFromHomeMapAlert> {
  final MapController mapController = MapController();

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(zenpukujiLat, zenpukujiLng),
              initialZoom: 10,
              onPositionChanged: (MapCamera position, bool isMoving) {
                if (isMoving) {
                  appParamNotifier.setCurrentZoom(zoom: position.zoom);
                }
              },
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: CachedTileProvider(),
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: <Marker>[
                  Marker(
                    point: appParamState.visitedTempleFromHomeLatLng!,
                    child: const Icon(Icons.home, color: Colors.redAccent),
                  ),
                ],
              ),
            ],
          ),
          displayMapStackPartsUpper(),
        ],
      ),
    );
  }

  ///
  Widget displayMapStackPartsUpper() {
    return Positioned(
      top: 5,
      right: 5,
      left: 5,
      child: Column(
        children: <Widget>[
          Container(
            width: context.screenSize.width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: () {
                          appParamNotifier.setVisitedTempleFromHomeLatLng(
                            latlng: const LatLng(zenpukujiLat, zenpukujiLng),
                          );

                          mapController.move(const LatLng(zenpukujiLat, zenpukujiLng),
                              appParamState.currentZoom == 0 ? 10 : appParamState.currentZoom);
                        },
                        icon: Icon(
                          Icons.home,
                          color: (appParamState.visitedTempleFromHomeLatLng!.latitude == zenpukujiLat &&
                                  appParamState.visitedTempleFromHomeLatLng!.longitude == zenpukujiLng)
                              ? Colors.redAccent
                              : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: () {
                          appParamNotifier.setVisitedTempleFromHomeLatLng(
                            latlng: const LatLng(funabashiLat, funabashiLng),
                          );

                          mapController.move(const LatLng(funabashiLat, funabashiLng),
                              appParamState.currentZoom == 0 ? 10 : appParamState.currentZoom);
                        },
                        icon: Icon(
                          Icons.home,
                          color: (appParamState.visitedTempleFromHomeLatLng!.latitude == funabashiLat &&
                                  appParamState.visitedTempleFromHomeLatLng!.longitude == funabashiLng)
                              ? Colors.redAccent
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_month, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
