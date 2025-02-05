import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/app_params/app_params_response_state.dart';
import '../../controllers/temple/temple.dart';
import '../../controllers/temple_lat_lng/temple_lat_lng.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_model.dart';
import '../../models/tokyo_train_model.dart';
import '../../utility/tile_provider.dart';
import '../_parts/temple_info_display_parts.dart';
import '../_parts/temple_overlay.dart';
import '../_parts/visited_temple_list_parts.dart';

class VisitedTempleMapAlert extends ConsumerStatefulWidget {
  const VisitedTempleMapAlert({
    super.key,
    required this.templeList,
    required this.templeVisitDateMap,
    required this.dateTempleMap,
    this.pinpointLat,
    this.pinpointLng,
  });

  final List<TempleModel> templeList;
  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, TempleModel> dateTempleMap;

  final double? pinpointLat;
  final double? pinpointLng;

  @override
  ConsumerState<VisitedTempleMapAlert> createState() => _VisitedTempleMapAlertState();
}

class _VisitedTempleMapAlertState extends ConsumerState<VisitedTempleMapAlert> {
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

    if (widget.pinpointLat == null && widget.pinpointLng == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => isLoading = true);

        // ignore: always_specify_types
        Future.delayed(const Duration(seconds: 2), () {
          setDefaultBoundsMap();

          setState(() => isLoading = false);
        });
      });
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeTempleDataList();

    makeMarker();

    double pinpointLat = 35.718532;
    double pinpointLng = 139.586639;

    if (widget.pinpointLat != null) {
      pinpointLat = widget.pinpointLat!;
    }

    if (widget.pinpointLng != null) {
      pinpointLng = widget.pinpointLng!;
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(pinpointLat, pinpointLng),
              initialZoom: currentZoomEightTeen,
              onPositionChanged: (MapCamera position, bool isMoving) {
                if (isMoving) {
                  ref.read(appParamProvider.notifier).setCurrentZoom(zoom: position.zoom);
                }
              },
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: CachedTileProvider(),
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: markerList),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            left: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    onPressed: () {
                      ref.read(appParamProvider.notifier).setSecondOverlayParams(secondEntries: _secondEntries);

                      addSecondOverlay(
                        context: context,
                        secondEntries: _secondEntries,
                        setStateCallback: setState,
                        width: context.screenSize.width,
                        height: context.screenSize.height * 0.3,
                        color: Colors.blueGrey.withOpacity(0.3),
                        initialPosition: Offset(0, context.screenSize.height * 0.7),
                        widget: Consumer(
                          builder: (BuildContext context, WidgetRef ref, Widget? child) {
                            // return notReachTempleTrainSelectParts(
                            //   context: context,
                            //   ref: ref,
                            //   tokyoTrainList: widget.tokyoTrainList,
                            //   setDefaultBoundsMap: setDefaultBoundsMap,
                            // );

                            return visitedTempleListParts(
                              ref: ref,

                              //
                              //
                              //
                              // context: context,
                              // templeList: widget.templeList,
                              // templeVisitDateMap: widget.templeVisitDateMap,
                              // dateTempleMap: widget.dateTempleMap,
                            );
                          },
                        ),
                        onPositionChanged: (Offset newPos) =>
                            ref.read(appParamProvider.notifier).updateOverlayPosition(newPos),
                        fixedFlag: true,
                      );
                    },
                    icon: const Icon(FontAwesomeIcons.toriiGate, color: Colors.white),
                  ),
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
  void setDefaultBoundsMap() {
    if (templeDataList.length > 1) {
      final int currentPaddingIndex =
          ref.watch(appParamProvider.select((AppParamsResponseState value) => value.currentPaddingIndex));

      final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)]);

      final CameraFit cameraFit = CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(currentPaddingIndex * 10));

      mapController.fitCamera(cameraFit);

      /// これは残しておく
      // final LatLng newCenter = mapController.camera.center;

      final double newZoom = mapController.camera.zoom;

      setState(() => currentZoom = newZoom);

      ref.read(appParamProvider.notifier).setCurrentZoom(zoom: newZoom);

      getBoundsZoomValue = true;
    }
  }

  ///
  void makeTempleDataList() {
    templeDataList = <TempleData>[];

    final List<double> latList = <double>[];
    final List<double> lngList = <double>[];

    final List<TempleModel> templeList = ref.watch(templeProvider.select((TempleState value) => value.templeList));

    final List<String> templeNamesList = <String>[];

    templeList
      ..forEach((TempleModel element) => templeNamesList.add(element.temple))
      ..forEach((TempleModel element) {
        if (element.memo != '') {
          element.memo.split('、').forEach((String element2) {
            if (!templeNamesList.contains(element2)) {
              templeNamesList.add(element2);
            }
          });
        }
      });

    final AsyncValue<TempleLatLngState> templeLatLngState = ref.watch(templeLatLngProvider);
    final Map<String, TempleLatLngModel>? templeLatLngMap = templeLatLngState.value?.templeLatLngMap;

    if (templeLatLngMap != null) {
      for (final String element in templeNamesList) {
        final TempleLatLngModel? temple = templeLatLngMap[element];

        if (temple != null) {
          if (temple.lat != 'null' && temple.lng != 'null') {
            latList.add(double.parse(temple.lat));
            lngList.add(double.parse(temple.lng));

            templeDataList.add(
              TempleData(name: temple.temple, address: temple.address, latitude: temple.lat, longitude: temple.lng),
            );
          }
        }
      }

      if (latList.isNotEmpty && lngList.isNotEmpty) {
        minLat = latList.reduce(min);
        maxLat = latList.reduce(max);
        minLng = lngList.reduce(min);
        maxLng = lngList.reduce(max);
      }
    }
  }

  ///
  void makeMarker() {
    final AppParamsResponseState appParamState = ref.watch(appParamProvider);

    Offset initialPosition = Offset(context.screenSize.width * 0.5, context.screenSize.height * 0.2);

    if (appParamState.overlayPosition != null) {
      initialPosition = appParamState.overlayPosition!;
    }

    final TempleState templeState = ref.watch(templeProvider);

    markerList = <Marker>[];

    for (int i = 0; i < templeDataList.length; i++) {
      markerList.add(
        Marker(
          point: LatLng(templeDataList[i].latitude.toDouble(), templeDataList[i].longitude.toDouble()),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: (templeDataList[i].mark == '0')
                ? null
                : () {
                    ref.read(templeProvider.notifier).setSelectTemple(
                          name: templeDataList[i].name,
                          lat: templeDataList[i].latitude,
                          lng: templeDataList[i].longitude,
                        );

                    addFirstOverlay(
                      context: context,
                      firstEntries: _firstEntries,
                      setStateCallback: setState,
                      width: context.screenSize.width * 0.5,
                      height: 250,
                      color: Colors.blueGrey.withOpacity(0.3),
                      initialPosition: initialPosition,
                      widget: Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          final AppParamsResponseState appParamState = ref.watch(appParamProvider);

                          return templeInfoDisplayParts(
                            context: context,
                            temple: templeDataList[i],
                            from: 'VisitedTempleMapAlert',
                            templeVisitDateMap: widget.templeVisitDateMap,
                            dateTempleMap: widget.dateTempleMap,
                            // ignore: prefer_const_literals_to_create_immutables
                            tokyoTrainList: <TokyoTrainModel>[],
                            appParamState: appParamState,
                            ref: ref,
                          );
                        },
                      ),
                      onPositionChanged: (Offset newPos) =>
                          ref.read(appParamProvider.notifier).updateOverlayPosition(newPos),
                      secondEntries: _secondEntries,
                    );
                  },
            child: CircleAvatar(
              backgroundColor: (templeState.selectTempleName == templeDataList[i].name &&
                      templeState.selectTempleLat == templeDataList[i].latitude &&
                      templeState.selectTempleLng == templeDataList[i].longitude)
                  ? Colors.redAccent.withOpacity(0.5)
                  : Colors.pinkAccent.withOpacity(0.5),
              child: const Text('', style: TextStyle(fontSize: 10, color: Colors.black)),
            ),
          ),
        ),
      );
    }
  }
}

// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:latlong2/latlong.dart';
//
// import '../../controllers/temple/temple.dart';
// import '../../controllers/temple_lat_lng/temple_lat_lng.dart';
// import '../../extensions/extensions.dart';
// import '../../models/common/temple_data.dart';
// import '../../models/temple_lat_lng_model.dart';
// import '../../models/temple_model.dart';
// import '../../models/tokyo_train_model.dart';
// import '../../utility/tile_provider.dart';
// import '../_parts/_temple_dialog.dart';
// import 'temple_info_display_alert.dart';
// import 'visited_temple_list_alert.dart';
//
// class VisitedTempleMapAlert extends ConsumerStatefulWidget {
//   const VisitedTempleMapAlert(
//       {super.key, required this.templeList, required this.templeVisitDateMap, required this.dateTempleMap});
//
//   final List<TempleModel> templeList;
//   final Map<String, List<String>> templeVisitDateMap;
//   final Map<String, TempleModel> dateTempleMap;
//
//   @override
//   ConsumerState<VisitedTempleMapAlert> createState() => _VisitedTempleMapAlertState();
// }
//
// class _VisitedTempleMapAlertState extends ConsumerState<VisitedTempleMapAlert> {
//   List<TempleData> templeDataList = <TempleData>[];
//
//   List<Marker> markerList = <Marker>[];
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
//     makeTempleDataList();
//
//     makeMarker();
//
//     final TempleState templeState = ref.watch(templeProvider);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               IconButton(
//                 onPressed: () {
//                   TempleDialog(
//                     context: context,
//                     widget: VisitedTempleListAlert(
//                       templeList: widget.templeList,
//                       templeVisitDateMap: widget.templeVisitDateMap,
//                       dateTempleMap: widget.dateTempleMap,
//                     ),
//                     paddingLeft: context.screenSize.width * 0.1,
//                   );
//                 },
//                 icon: const Icon(Icons.list, color: Colors.white),
//               ),
//               if (templeState.selectTempleName != '') ...<Widget>[
//                 IconButton(
//                   onPressed: () {
//                     ref.read(templeProvider.notifier).setSelectTemple(name: '', lat: '', lng: '');
//
//                     Navigator.pop(context);
//
//                     TempleDialog(
//                       context: context,
//                       widget: VisitedTempleMapAlert(
//                         templeList: widget.templeList,
//                         templeVisitDateMap: widget.templeVisitDateMap,
//                         dateTempleMap: widget.dateTempleMap,
//                       ),
//                       clearBarrierColor: true,
//                     );
//                   },
//                   icon: const Icon(Icons.map, color: Colors.white),
//                 ),
//               ],
//               if (templeState.selectTempleName == '') ...<Widget>[Container()],
//             ],
//           ),
//         ),
//         Expanded(
//           child: FutureBuilder<void>(
//             future: _loadMapTiles(),
//             builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return const Center(child: Text('Error loading map'));
//               } else {
//                 firstMapDisplay = true;
//
//                 return FlutterMap(
//                   mapController: mapController,
//                   options: (templeState.selectTempleName != '')
//                       ? MapOptions(
//                           initialCenter:
//                               LatLng(templeState.selectTempleLat.toDouble(), templeState.selectTempleLng.toDouble()),
//                           initialZoom: 16,
//                           maxZoom: 17,
//                           minZoom: 3,
//                         )
//                       : MapOptions(
//                           initialCameraFit: CameraFit.bounds(
//                             bounds: LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)]),
//                             padding: const EdgeInsets.all(50),
//                           ),
//                         ),
//                   children: <Widget>[
//                     TileLayer(
//                       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                       tileProvider: CachedTileProvider(),
//                       userAgentPackageName: 'com.example.app',
//                     ),
//                     MarkerLayer(markers: markerList),
//                   ],
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   ///
//   void makeTempleDataList() {
//     templeDataList = <TempleData>[];
//
//     final List<double> latList = <double>[];
//     final List<double> lngList = <double>[];
//
//     final List<TempleModel> templeList = ref.watch(templeProvider.select((TempleState value) => value.templeList));
//
//     final List<String> templeNamesList = <String>[];
//
//     templeList
//       ..forEach((TempleModel element) => templeNamesList.add(element.temple))
//       ..forEach((TempleModel element) {
//         if (element.memo != '') {
//           element.memo.split('、').forEach((String element2) {
//             if (!templeNamesList.contains(element2)) {
//               templeNamesList.add(element2);
//             }
//           });
//         }
//       });
//
//     final AsyncValue<TempleLatLngState> templeLatLngState = ref.watch(templeLatLngProvider);
//     final Map<String, TempleLatLngModel>? templeLatLngMap = templeLatLngState.value?.templeLatLngMap;
//
//     if (templeLatLngMap != null) {
//       for (final String element in templeNamesList) {
//         final TempleLatLngModel? temple = templeLatLngMap[element];
//
//         if (temple != null) {
//           if (temple.lat != 'null' && temple.lng != 'null') {
//             latList.add(double.parse(temple.lat));
//             lngList.add(double.parse(temple.lng));
//
//             templeDataList.add(
//               TempleData(name: temple.temple, address: temple.address, latitude: temple.lat, longitude: temple.lng),
//             );
//           }
//         }
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
//           point: LatLng(templeDataList[i].latitude.toDouble(), templeDataList[i].longitude.toDouble()),
//           width: 40,
//           height: 40,
//           child: GestureDetector(
//             onTap: (templeDataList[i].mark == '0')
//                 ? null
//                 : () {
//                     ref.read(templeProvider.notifier).setSelectTemple(
//                           name: templeDataList[i].name,
//                           lat: templeDataList[i].latitude,
//                           lng: templeDataList[i].longitude,
//                         );
//
//                     TempleDialog(
//                       context: context,
//                       widget: TempleInfoDisplayAlert(
//                         temple: templeDataList[i],
//                         from: 'VisitedTempleMapAlert',
//                         templeVisitDateMap: widget.templeVisitDateMap,
//                         dateTempleMap: widget.dateTempleMap,
//                         // ignore: prefer_const_literals_to_create_immutables
//                         tokyoTrainList: <TokyoTrainModel>[],
//                       ),
//                       paddingTop: context.screenSize.height * 0.6,
//                       clearBarrierColor: true,
//                     );
//                   },
//             child: CircleAvatar(
//               backgroundColor: (templeState.selectTempleName == templeDataList[i].name &&
//                       templeState.selectTempleLat == templeDataList[i].latitude &&
//                       templeState.selectTempleLng == templeDataList[i].longitude)
//                   ? Colors.redAccent.withOpacity(0.5)
//                   : Colors.pinkAccent.withOpacity(0.5),
//               child: const Text('', style: TextStyle(fontSize: 10, color: Colors.black)),
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }
