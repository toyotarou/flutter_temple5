import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../mixin/not_reach_temple_train/not_reach_temple_train_select_widget.dart';
import '../../models/common/temple_data.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../models/tokyo_train_model.dart';
import '../_parts/temple_info_display_parts.dart';
import '../_parts/temple_overlay.dart';

class NotReachTempleMapAlert extends ConsumerStatefulWidget {
  const NotReachTempleMapAlert(
      {super.key,
      required this.tokyoTrainIdMap,
      required this.tokyoTrainList,
      required this.templeVisitDateMap,
      required this.dateTempleMap});

  final Map<int, TokyoTrainModel> tokyoTrainIdMap;
  final List<TokyoTrainModel> tokyoTrainList;
  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, TempleModel> dateTempleMap;

  @override
  ConsumerState<NotReachTempleMapAlert> createState() => _NotReachTempleMapAlertState();
}

class _NotReachTempleMapAlertState extends ConsumerState<NotReachTempleMapAlert>
    with ControllersMixin<NotReachTempleMapAlert> {
  List<TempleData> templeDataList = <TempleData>[];

  List<double> latList = <double>[];
  List<double> lngList = <double>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  final MapController mapController = MapController();

  double currentZoomEightTeen = 18;

  bool isLoading = false;

  double? currentZoom;

  bool getBoundsZoomValue = false;

  List<Polyline<Object>> polylineList = <Polyline<Object>>[];

  List<Marker> markerList = <Marker>[];

  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];

  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  final List<LatLng> _selectedPoints = <LatLng>[];

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
    getNotReachTemple();

    makePolylineList();

    makeMarker();

    double? distance;
    if (_selectedPoints.length == 2) {
      distance = _calculateDistance(_selectedPoints[0], _selectedPoints[1]);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(zenpukujiLat, zenpukujiLng),
              initialZoom: currentZoomEightTeen,
              onPositionChanged: (MapCamera position, bool isMoving) {
                if (isMoving) {
                  appParamNotifier.setCurrentZoom(zoom: position.zoom);
                }
              },
              onTap: (TapPosition tapPosition, LatLng latlng) {
                setState(() {
                  if (_selectedPoints.length < 2) {
                    _selectedPoints.add(latlng);
                  }
                });
              },
            ),
            children: <Widget>[
              TileLayer(urlTemplate: 'https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png'),
              MarkerLayer(markers: markerList),
              // ignore: always_specify_types
              PolylineLayer(polylines: polylineList),

              MarkerLayer(
                markers: _selectedPoints.map((LatLng point) {
                  return Marker(
                    point: point,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                  );
                }).toList(),
              ),
              if (_selectedPoints.length == 2)
                // ignore: always_specify_types
                PolylineLayer(
                  polylines: <Polyline<Object>>[
                    // ignore: always_specify_types
                    Polyline(points: _selectedPoints, strokeWidth: 4.0, color: Colors.blue),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            left: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (distance != null)
                  Text('距離: ${distance.toStringAsFixed(2)} m', style: const TextStyle(fontSize: 16))
                else
                  Container(),
                Row(
                  children: <Widget>[
                    Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () => setState(() => _selectedPoints.clear()),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () {
                          appParamNotifier.setSecondOverlayParams(secondEntries: _secondEntries);

                          addSecondOverlay(
                            context: context,
                            secondEntries: _secondEntries,
                            setStateCallback: setState,
                            width: context.screenSize.width,
                            height: context.screenSize.height * 0.3,
                            color: Colors.blueGrey.withOpacity(0.3),
                            initialPosition: Offset(0, context.screenSize.height * 0.7),
                            widget: NotReachTempleTrainSelectWidget(
                                tokyoTrainList: widget.tokyoTrainList, setDefaultBoundsMap: setDefaultBoundsMap),
                            onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
                            fixedFlag: true,
                          );
                        },
                        icon: const Icon(Icons.train, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
        ],
      ),
    );
  }

  ///
  double _calculateDistance(LatLng p1, LatLng p2) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, p1, p2);
  }

  ///
  void getNotReachTemple() {
    templeDataList = <TempleData>[];

    final List<String> jogaiTempleNameList = <String>[];
    final List<String> jogaiTempleAddressList = <String>[];
    final List<String> jogaiTempleAddressList2 = <String>[];

    for (final TempleLatLngModel element in templeLatLngState.templeLatLngList) {
      jogaiTempleNameList.add(element.temple);
      jogaiTempleAddressList.add(element.address);
      jogaiTempleAddressList2.add('東京都${element.address}');
    }

    final List<double> latList = <double>[];
    final List<double> lngList = <double>[];

    for (int i = 0; i < templeListState.templeListList.length; i++) {
      if (jogaiTempleNameList.contains(templeListState.templeListList[i].name)) {
        continue;
      }

      if (jogaiTempleAddressList.contains(templeListState.templeListList[i].address)) {
        continue;
      }

      if (jogaiTempleAddressList2.contains(templeListState.templeListList[i].address)) {
        continue;
      }

      if (jogaiTempleAddressList.contains('東京都${templeListState.templeListList[i].address}')) {
        continue;
      }

      if (jogaiTempleAddressList2.contains('東京都${templeListState.templeListList[i].address}')) {
        continue;
      }

      latList.add(double.parse(templeListState.templeListList[i].lat));
      lngList.add(double.parse(templeListState.templeListList[i].lng));

      templeDataList.add(
        TempleData(
          name: templeListState.templeListList[i].name,
          address: templeListState.templeListList[i].address,
          latitude: templeListState.templeListList[i].lat,
          longitude: templeListState.templeListList[i].lng,
          mark: templeListState.templeListList[i].id.toString(),
        ),
      );
    }

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }
  }

  ///
  void setDefaultBoundsMap() {
    if (templeDataList.length > 1) {
      final List<double> stationLatList = <double>[];
      final List<double> stationLngList = <double>[];

      if (tokyoTrainState.selectTrainList.isNotEmpty) {
        final TokyoTrainModel? map = widget.tokyoTrainIdMap[tokyoTrainState.selectTrainList[0]];

        map?.station.forEach((TokyoStationModel element) {
          stationLatList.add(element.lat.toDouble());
          stationLngList.add(element.lng.toDouble());
        });

        minLat = stationLatList.reduce(min);
        maxLat = stationLatList.reduce(max);
        minLng = stationLngList.reduce(min);
        maxLng = stationLngList.reduce(max);
      }

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
  void makePolylineList() {
    polylineList = <Polyline<Object>>[];

    final List<LatLng> points = <LatLng>[];

    for (int i = 0; i < tokyoTrainState.selectTrainList.length; i++) {
      final TokyoTrainModel? map = widget.tokyoTrainIdMap[tokyoTrainState.selectTrainList[i]];

      map?.station.forEach(
          (TokyoStationModel element2) => points.add(LatLng(element2.lat.toDouble(), element2.lng.toDouble())));

      // ignore: always_specify_types
      polylineList.add(Polyline(points: points, color: Colors.blueAccent, strokeWidth: 5));
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
      markerList.add(
        Marker(
          point: LatLng(templeDataList[i].latitude.toDouble(), templeDataList[i].longitude.toDouble()),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              templeNotifier.setSelectTemple(
                  name: templeDataList[i].name, lat: templeDataList[i].latitude, lng: templeDataList[i].longitude);

              appParamNotifier.setFirstOverlayParams(firstEntries: _firstEntries);

              addFirstOverlay(
                context: context,
                firstEntries: _firstEntries,
                setStateCallback: setState,
                width: context.screenSize.width * 0.5,
                height: 320,
                color: Colors.blueGrey.withOpacity(0.3),
                initialPosition: initialPosition,
                widget: Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    return templeInfoDisplayParts(
                      context: context,
                      temple: templeDataList[i],
                      from: 'NotReachTempleMapAlert',
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
                ref: ref,
                from: 'NotReachTempleMapAlert',
              );
            },
            child: CircleAvatar(
              backgroundColor: (templeState.selectTempleName == templeDataList[i].name &&
                      templeState.selectTempleLat == templeDataList[i].latitude &&
                      templeState.selectTempleLng == templeDataList[i].longitude)
                  ? Colors.redAccent.withOpacity(0.5)
                  : Colors.orangeAccent.withOpacity(0.5),
              child: Text(
                templeDataList[i].mark.padLeft(3, '0'),
                style: const TextStyle(fontSize: 10, color: Colors.black),
              ),
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
                backgroundColor: Colors.purple.withOpacity(0.5),
                child: const Text(''),
              ),
            ),
          ),
        );
      }
    }
  }
}

// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:latlong2/latlong.dart';
//
// import '../../controllers/lat_lng_temple/lat_lng_temple.dart';
// import '../../controllers/temple/temple.dart';
// import '../../controllers/temple_lat_lng/temple_lat_lng.dart';
// import '../../controllers/temple_list/temple_list.dart';
// import '../../controllers/tokyo_train/tokyo_train.dart';
// import '../../extensions/extensions.dart';
// import '../../models/common/temple_data.dart';
// import '../../models/near_station_model.dart';
// import '../../models/temple_lat_lng_model.dart';
// import '../../models/temple_list_model.dart';
// import '../../models/temple_model.dart';
// import '../../models/tokyo_station_model.dart';
// import '../../models/tokyo_train_model.dart';
// import '../../utility/tile_provider.dart';
// import '../../utility/utility.dart';
// import '../_parts/_temple_dialog.dart';
// import 'not_reach_temple_train_select_alert.dart';
// import 'temple_info_display_alert.dart';
//
// class NotReachTempleMapAlert extends ConsumerStatefulWidget {
//   const NotReachTempleMapAlert(
//       {super.key,
//       required this.tokyoTrainIdMap,
//       required this.tokyoTrainList,
//       required this.templeVisitDateMap,
//       required this.dateTempleMap});
//
//   final Map<int, TokyoTrainModel> tokyoTrainIdMap;
//   final List<TokyoTrainModel> tokyoTrainList;
//   final Map<String, List<String>> templeVisitDateMap;
//   final Map<String, TempleModel> dateTempleMap;
//
//   @override
//   ConsumerState<NotReachTempleMapAlert> createState() =>
//       _NotReachTempleMapAlertState();
// }
//
// class _NotReachTempleMapAlertState
//     extends ConsumerState<NotReachTempleMapAlert> {
//   List<TempleData> templeDataList = <TempleData>[];
//
//   List<Marker> markerList = <Marker>[];
//
//   List<Polyline<Object>> polylineList = <Polyline<Object>>[];
//
//   Utility utility = Utility();
//
//   final MapController mapController = MapController();
//
//   double minLat = 0.0;
//   double maxLat = 0.0;
//   double minLng = 0.0;
//   double maxLng = 0.0;
//
//   bool firstMapDisplay = false;
//
//   ///
//   Future<void> _loadMapTiles() async {
//     // ignore: always_specify_types
//     return Future.delayed(Duration(seconds: firstMapDisplay ? 0 : 2));
//   }
//
//   ///
//   @override
//   Widget build(BuildContext context) {
//     getNotReachTemple();
//
//     makePolylineList();
//
//     makeMarker();
//
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Column(
//         children: <Widget>[

//           const SizedBox(height: 10),

//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   templeDataList.length.toString(),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     TempleDialog(
//                       context: context,
//                       widget: NotReachTempleTrainSelectAlert(
//                         tokyoTrainList: widget.tokyoTrainList,
//                       ),
//                       paddingRight: context.screenSize.width * 0.2,
//                       clearBarrierColor: true,
//                     );
//                   },
//                   icon: const Icon(Icons.train, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             child: FutureBuilder<void>(
//               future: _loadMapTiles(),
//               builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return const Center(child: Text('Error loading map'));
//                 } else {
//                   firstMapDisplay = true;
//
//                   return FlutterMap(
//                     mapController: mapController,
//                     options: MapOptions(
//                       initialCameraFit: CameraFit.bounds(
//                         bounds: LatLngBounds.fromPoints(
//                           <LatLng>[
//                             LatLng(minLat, maxLng),
//                             LatLng(maxLat, minLng)
//                           ],
//                         ),
//                         padding: const EdgeInsets.all(50),
//                       ),
//                     ),
//                     children: <Widget>[
//                       TileLayer(
//                         urlTemplate:
//                             'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                         tileProvider: CachedTileProvider(),
//                         userAgentPackageName: 'com.example.app',
//                       ),
//                       MarkerLayer(markers: markerList),
//                       // ignore: always_specify_types
//                       PolylineLayer(polylines: polylineList),
//                     ],
//                   );
//                 }
//               },
//             ),
//           ),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               TextButton(
//                   onPressed: () {
//                     ref.read(tokyoTrainProvider.notifier).clearTrainList();
//
//                     ref
//                         .read(latLngTempleProvider.notifier)
//                         .clearSelectedNearStation();
//
//                     ref
//                         .read(templeProvider.notifier)
//                         .setSelectTemple(name: '', lat: '', lng: '');
//                   },
//                   child: const Text(
//                     'clear selected station and line',
//                     style: TextStyle(color: Colors.white),
//                   )),
//               Container(),
//             ],
//           ),

//         ],
//       ),
//     );
//   }
//
//   ///
//   void getNotReachTemple() {
//     templeDataList = <TempleData>[];
//
//     final List<String> jogaiTempleNameList = <String>[];
//     final List<String> jogaiTempleAddressList = <String>[];
//     final List<String> jogaiTempleAddressList2 = <String>[];
//
//     final AsyncValue<TempleLatLngState> templeLatLngState =
//         ref.watch(templeLatLngProvider);
//     final List<TempleLatLngModel>? templeLatLngList =
//         templeLatLngState.value?.templeLatLngList;
//
//     if (templeLatLngList != null) {
//       for (final TempleLatLngModel element in templeLatLngList) {
//         jogaiTempleNameList.add(element.temple);
//         jogaiTempleAddressList.add(element.address);
//         jogaiTempleAddressList2.add('東京都${element.address}');
//       }
//     }
//
//     final AsyncValue<TempleListState> templeListState =
//         ref.watch(templeListProvider);
//     final List<TempleListModel>? templeListList =
//         templeListState.value?.templeListList;
//
//     if (templeListList != null) {
//       final List<double> latList = <double>[];
//       final List<double> lngList = <double>[];
//
//       for (int i = 0; i < templeListList.length; i++) {
//         if (jogaiTempleNameList.contains(templeListList[i].name)) {
//           continue;
//         }
//
//         if (jogaiTempleAddressList.contains(templeListList[i].address)) {
//           continue;
//         }
//
//         if (jogaiTempleAddressList2.contains(templeListList[i].address)) {
//           continue;
//         }
//
//         if (jogaiTempleAddressList
//             .contains('東京都${templeListList[i].address}')) {
//           continue;
//         }
//
//         if (jogaiTempleAddressList2
//             .contains('東京都${templeListList[i].address}')) {
//           continue;
//         }
//
//         latList.add(double.parse(templeListList[i].lat));
//         lngList.add(double.parse(templeListList[i].lng));
//
//         templeDataList.add(
//           TempleData(
//             name: templeListList[i].name,
//             address: templeListList[i].address,
//             latitude: templeListList[i].lat,
//             longitude: templeListList[i].lng,
//             mark: templeListList[i].id.toString(),
//           ),
//         );
//       }
//
//       if (latList.isNotEmpty && lngList.isNotEmpty) {
//         minLat = latList.reduce(min);
//         maxLat = latList.reduce(max);
//         minLng = lngList.reduce(min);
//         maxLng = lngList.reduce(max);
//       }
//     }
//   }
//
//   ///
//   void makeMarker() {
//     final TempleState templeState = ref.watch(templeProvider);
//
//     markerList = <Marker>[];
//
//     for (int i = 0; i < templeDataList.length; i++) {
//       markerList.add(
//         Marker(
//           point: LatLng(
//             templeDataList[i].latitude.toDouble(),
//             templeDataList[i].longitude.toDouble(),
//           ),
//           width: 40,
//           height: 40,
//           child: GestureDetector(
//             onTap: () {
//               ref.read(templeProvider.notifier).setSelectTemple(
//                     name: templeDataList[i].name,
//                     lat: templeDataList[i].latitude,
//                     lng: templeDataList[i].longitude,
//                   );
//
//               TempleDialog(
//                 context: context,
//                 widget: TempleInfoDisplayAlert(
//                   temple: templeDataList[i],
//                   from: 'NotReachTempleMapAlert',
//                   templeVisitDateMap: widget.templeVisitDateMap,
//                   dateTempleMap: widget.dateTempleMap,
//                   tokyoTrainList: widget.tokyoTrainList,
//                 ),
//                 paddingTop: context.screenSize.height * 0.5,
//                 clearBarrierColor: true,
//               );
//             },
//             child: CircleAvatar(
//               backgroundColor:
//                   (templeState.selectTempleName == templeDataList[i].name &&
//                           templeState.selectTempleLat ==
//                               templeDataList[i].latitude &&
//                           templeState.selectTempleLng ==
//                               templeDataList[i].longitude)
//                       ? Colors.redAccent.withOpacity(0.5)
//                       : Colors.orangeAccent.withOpacity(0.5),
//               child: Text(
//                 templeDataList[i].mark.padLeft(3, '0'),
//                 style: const TextStyle(fontSize: 10, color: Colors.black),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//
//     final NearStationResponseStationModel? selectedNearStation = ref.watch(
//         latLngTempleProvider
//             .select((LatLngTempleState value) => value.selectedNearStation));
//
//     if (selectedNearStation != null) {
//       if (selectedNearStation.y > 0 && selectedNearStation.x > 0) {
//         markerList.add(
//           Marker(
//             point: LatLng(selectedNearStation.y, selectedNearStation.x),
//             width: 40,
//             height: 40,
//             child: GestureDetector(
//               child: CircleAvatar(
//                 backgroundColor: Colors.purple.withOpacity(0.5),
//                 child: const Text(''),
//               ),
//             ),
//           ),
//         );
//       }
//     }
//   }
//
//   ///
//   void makePolylineList() {
//     polylineList = <Polyline<Object>>[];
//
//     final TokyoTrainState tokyoTrainState = ref.watch(tokyoTrainProvider);
//
//     final List<LatLng> points = <LatLng>[];
//
//     for (int i = 0; i < tokyoTrainState.selectTrainList.length; i++) {
//       final TokyoTrainModel? map =
//           widget.tokyoTrainIdMap[tokyoTrainState.selectTrainList[i]];
//
//       map?.station.forEach((TokyoStationModel element2) =>
//           points.add(LatLng(element2.lat.toDouble(), element2.lng.toDouble())));
//
//       polylineList.add(
//         // ignore: always_specify_types
//         Polyline(points: points, color: Colors.blueAccent, strokeWidth: 5),
//       );
//     }
//   }
// }
