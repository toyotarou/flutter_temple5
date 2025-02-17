import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/lat_lng_temple_model.dart';
import '../../models/temple_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../models/tokyo_train_model.dart';
import '../../utility/tile_provider.dart';
import '../_parts/_caution_dialog.dart';
import '../_parts/_temple_dialog.dart';
import '../_parts/temple_info_display_parts.dart';
import '../_parts/temple_overlay.dart';
import '../function.dart';
import 'route_display_setting_alert.dart';
import 'route_goal_station_setting_alert.dart';

class RouteSettingMapAlert extends ConsumerStatefulWidget {
  const RouteSettingMapAlert({
    super.key,
    required this.templeList,
    this.station,
    required this.tokyoStationMap,
    required this.tokyoTrainList,
    required this.templeVisitDateMap,
    required this.dateTempleMap,
    required this.tokyoTrainIdMap,
  });

  final List<LatLngTempleModel> templeList;
  final TokyoStationModel? station;
  final Map<String, TokyoStationModel> tokyoStationMap;
  final List<TokyoTrainModel> tokyoTrainList;
  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, TempleModel> dateTempleMap;
  final Map<int, TokyoTrainModel> tokyoTrainIdMap;

  @override
  ConsumerState<RouteSettingMapAlert> createState() => _RouteSettingMapAlertState();
}

class _RouteSettingMapAlertState extends ConsumerState<RouteSettingMapAlert>
    with ControllersMixin<RouteSettingMapAlert> {
  List<TempleData> templeDataList = <TempleData>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  List<Marker> markerList = <Marker>[];

  final MapController mapController = MapController();

  double currentZoomEightTeen = 18;

  bool isLoading = false;

  double? currentZoom;

  bool getBoundsZoomValue = false;

  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];

  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  ///
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => isLoading = true);

      // ignore: always_specify_types
      Future.delayed(const Duration(seconds: 2), () {
        setDefaultBoundsMap();

        setState(() => isLoading = false);
      });
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    templeDataList = <TempleData>[];

    final List<double> latList = <double>[];
    final List<double> lngList = <double>[];

    for (final LatLngTempleModel element in widget.templeList) {
      latList.add(double.parse(element.latitude));
      lngList.add(double.parse(element.longitude));

      templeDataList.add(
        TempleData(
          name: element.name,
          address: element.address,
          latitude: element.latitude,
          longitude: element.longitude,
          mark: element.id.toString(),
          cnt: element.cnt,
        ),
      );
    }

    if (widget.station != null) {
      latList.add(double.parse(widget.station!.lat));
      lngList.add(double.parse(widget.station!.lng));

      templeDataList.add(TempleData(
        name: widget.station!.stationName,
        address: widget.station!.address,
        latitude: widget.station!.lat,
        longitude: widget.station!.lng,
        mark: 'STA',
      ));
    }

    if (tokyoTrainState.tokyoStationMap[routingState.goalStationId] != null) {
      final TokyoStationModel? goal = tokyoTrainState.tokyoStationMap[routingState.goalStationId];

      if (goal != null) {
        latList.add(double.parse(goal.lat));
        lngList.add(double.parse(goal.lng));
      }

      templeDataList.add(
        TempleData(
            name: goal!.stationName, address: goal.address, latitude: goal.lat, longitude: goal.lng, mark: goal.id),
      );
    }

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }

    makeMarker();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(35.718532, 139.586639),
              initialZoom: currentZoomEightTeen,
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

              // ignore: always_specify_types
              PolylineLayer(
                polylines: <Polyline<Object>>[
                  // ignore: always_specify_types
                  Polyline(
                    points: routingState.routingTempleDataList
                        .map((TempleData e) => LatLng(e.latitude.toDouble(), e.longitude.toDouble()))
                        .toList(),
                    color: Colors.redAccent,
                    strokeWidth: 5,
                  ),

                  if (tokyoTrainState.selectTrainList.isNotEmpty) ...<Polyline<Object>>[getTrainPolyline()],
                ],
              ),

              MarkerLayer(markers: markerList),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            left: 5,
            child: Column(
              children: <Widget>[
                Container(
                  width: context.screenSize.width,
                  padding: const EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 60,
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.green[900]!.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Text('Start', style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(widget.station!.stationName, style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (routingState.routingTempleDataList.length < 2) {
                                      caution_dialog(context: context, content: 'cant setting goal');

                                      return;
                                    }

                                    TempleDialog(
                                      context: context,
                                      widget: RouteGoalStationSettingAlert(
                                          tokyoStationMap: widget.tokyoStationMap,
                                          tokyoTrainList: widget.tokyoTrainList),
                                      paddingTop: context.screenSize.height * 0.6,
                                      clearBarrierColor: true,
                                    );
                                  },
                                  child: Container(
                                    width: 60,
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.purpleAccent.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: const Text('Goal', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    (tokyoTrainState.tokyoStationMap[routingState.goalStationId] != null)
                                        ? tokyoTrainState.tokyoStationMap[routingState.goalStationId]!.stationName
                                        : '-----',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => routingNotifier.removeGoalStation(),
                                  child: const Icon(Icons.close, color: Colors.purpleAccent),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          closeAllOverlays(ref: ref);

                          TempleDialog(
                            context: context,
                            widget: RouteDisplaySettingAlert(),
                            paddingLeft: context.screenSize.width * 0.1,
                          );

                          _firstEntries.clear();
                        },
                        child: const Icon(Icons.settings, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => latLngTempleNotifier.setOrangeDisplay(),
                        child: CircleAvatar(backgroundColor: Colors.orangeAccent.withOpacity(0.6), radius: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: context.screenSize.width,
                  padding: const EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(color: Colors.blueAccent.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: context.screenSize.height / 15),
                    child: displaySelectedRoutingTemple(),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) ...<Widget>[
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  ///
  void setDefaultBoundsMap() {
    if (templeDataList.length > 1) {
      final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)]);

      final CameraFit cameraFit =
          CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(appParamState.currentPaddingIndex * 10));

      mapController.fitCamera(cameraFit);

      /// これは残しておく
      // final LatLng newCenter = mapController.camera.center;

      final double newZoom = mapController.camera.zoom;

      setState(() => currentZoom = newZoom);

      appParamNotifier.setCurrentZoom(zoom: newZoom);

      getBoundsZoomValue = true;
    }
  }

  ///
  void makeMarker() {
    Offset initialPosition = Offset(context.screenSize.width * 0.5, context.screenSize.height * 0.2);

    if (appParamState.overlayPosition != null) {
      initialPosition = appParamState.overlayPosition!;
    }

    markerList = <Marker>[];

    for (int i = 0; i < templeDataList.length; i++) {
      if (latLngTempleState.orangeDisplay) {
        if (templeDataList[i].cnt > 0) {
          continue;
        }
      }

      markerList.add(
        Marker(
          point: LatLng(templeDataList[i].latitude.toDouble(), templeDataList[i].longitude.toDouble()),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: (templeDataList[i].mark == '0')
                ? null
                : () {
                    final int exMarkLength = templeDataList[i].mark.split('-').length;

                    if (exMarkLength == 2) {
                      return;
                    } else {
                      templeNotifier.setSelectTemple(
                          name: templeDataList[i].name,
                          lat: templeDataList[i].latitude,
                          lng: templeDataList[i].longitude);

                      appParamNotifier.setFirstOverlayParams(firstEntries: _firstEntries);

                      addFirstOverlay(
                        context: context,
                        firstEntries: _firstEntries,
                        setStateCallback: setState,
                        width: context.screenSize.width * 0.5,
                        height: 300,
                        color: Colors.blueGrey.withOpacity(0.3),
                        initialPosition: initialPosition,
                        widget: Consumer(
                          builder: (BuildContext context, WidgetRef ref, Widget? child) {
                            return templeInfoDisplayParts(
                              context: context,
                              temple: templeDataList[i],
                              from: 'RouteSettingMapAlert',
                              station: widget.station,
                              templeVisitDateMap: widget.templeVisitDateMap,
                              dateTempleMap: widget.dateTempleMap,
                              tokyoTrainList: widget.tokyoTrainList,
                              appParamState: appParamState,
                              ref: ref,
                            );
                          },
                        ),
                        onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
                        secondEntries: _secondEntries,
                      );
                    }
                  },
            child: CircleAvatar(
              backgroundColor: getCircleAvatarBgColor(element: templeDataList[i], ref: ref),
              child: getCircleAvatarText(element: templeDataList[i]),
            ),
          ),
        ),
      );
    }

    if (latLngTempleState.selectedNearStation != null) {
      if (latLngTempleState.selectedNearStation!.y > 0 && latLngTempleState.selectedNearStation!.x > 0) {
        markerList.add(
          Marker(
            point: LatLng(latLngTempleState.selectedNearStation!.y, latLngTempleState.selectedNearStation!.x),
            width: 40,
            height: 40,
            child: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.brown.withOpacity(0.5),
                child: const Text(''),
              ),
            ),
          ),
        );
      }
    }
  }

  ///
  Widget getCircleAvatarText({required TempleData element}) {
    String str = '';
    if (element.mark == '0') {
      str = 'S';
    } else if (element.mark.split('-').length == 2) {
      if (routingState.routingTempleDataList.isNotEmpty && routingState.routingTempleDataList[0].name == element.name) {
        str = 'S';
      } else {
        str = 'G';
      }
    } else {
      str = element.mark.padLeft(3, '0');
    }

    return Text(str, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12));
  }

  ///
  Widget displaySelectedRoutingTemple() {
    final List<Widget> list = <Widget>[];

    for (int i = 1; i < routingState.routingTempleDataList.length; i++) {
      final String distance = calcDistance(
        originLat: routingState.routingTempleDataList[i - 1].latitude.toDouble(),
        originLng: routingState.routingTempleDataList[i - 1].longitude.toDouble(),
        destLat: routingState.routingTempleDataList[i].latitude.toDouble(),
        destLng: routingState.routingTempleDataList[i].longitude.toDouble(),
      );

      list.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 5),
              width: 40,
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white))),
              alignment: Alignment.topRight,
              child: Text(distance, style: const TextStyle(fontSize: 10, color: Colors.white)),
            ),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
              decoration: (routingState.routingTempleDataList[i].mark.split('-').length != 2)
                  ? BoxDecoration(
                      color: (routingState.routingTempleDataList[i].cnt > 0)
                          ? Colors.pinkAccent.withOpacity(0.5)
                          : Colors.orangeAccent.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: (routingState.routingTempleDataList[i].mark.split('-').length != 2)
                  ? Text(routingState.routingTempleDataList[i].mark,
                      style: const TextStyle(fontSize: 10, color: Colors.white))
                  : const Text(''),
            ),
          ],
        ),
      );
    }

    return (list.isNotEmpty) ? Wrap(children: list) : const Text('No Routing', style: TextStyle(color: Colors.white));
  }

  // ignore: always_specify_types
  Polyline getTrainPolyline() {
    final List<LatLng> points = <LatLng>[];

    if (tokyoTrainState.selectTrainList.isNotEmpty) {
      final TokyoTrainModel? selectedTokyoTrainMap = widget.tokyoTrainIdMap[tokyoTrainState.selectTrainList[0]];

      selectedTokyoTrainMap?.station.forEach(
          (TokyoStationModel element2) => points.add(LatLng(element2.lat.toDouble(), element2.lng.toDouble())));
    }

    // ignore: always_specify_types
    return Polyline(points: points, color: Colors.blueAccent, strokeWidth: 5);
  }
}
