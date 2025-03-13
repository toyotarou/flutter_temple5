import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
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
  const VisitedTempleMapAlert(
      {super.key, required this.templeList, required this.templeVisitDateMap, required this.dateTempleMap});

  final List<TempleModel> templeList;
  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, TempleModel> dateTempleMap;

  @override
  ConsumerState<VisitedTempleMapAlert> createState() => _VisitedTempleMapAlertState();
}

class _VisitedTempleMapAlertState extends ConsumerState<VisitedTempleMapAlert>
    with ControllersMixin<VisitedTempleMapAlert> {
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
  Widget build(BuildContext context) {
    makeTempleDataList();

    makeMarker();

    if (!appParamState.visitedTempleMapDisplayFinish) {
      if (templeState.selectTempleLat != '' && templeState.selectTempleLng != '') {
        // ignore: always_specify_types
        Future(() {
          appParamNotifier.setVisitedTempleMapDisplayFinish(flag: true);
        });

        mapController.move(LatLng(templeState.selectTempleLat.toDouble(), templeState.selectTempleLng.toDouble()), 13);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() => isLoading = true);

          // ignore: always_specify_types
          Future.delayed(const Duration(seconds: 2), () {
            appParamNotifier.setVisitedTempleMapDisplayFinish(flag: true);

            setDefaultBoundsMap();

            setState(() => isLoading = false);
          });
        });
      }
    }

    return Scaffold(
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
          if (!isLoading) ...<Widget>[
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
                        appParamNotifier.setSecondOverlayParams(secondEntries: _secondEntries);

                        appParamNotifier.setVisitedTempleSelectedYear(year: 0);

                        addSecondOverlay(
                          context: context,
                          secondEntries: _secondEntries,
                          setStateCallback: setState,
                          width: context.screenSize.width,
                          height: context.screenSize.height * 0.4,
                          color: Colors.blueGrey.withOpacity(0.3),
                          initialPosition: Offset(0, context.screenSize.height * 0.6),
                          widget: Consumer(
                            builder: (BuildContext context, WidgetRef ref, Widget? child) => visitedTempleListParts(
                              ref: ref,
                              templeLatLngMap: templeLatLngState.templeLatLngMap,
                              listHeight: context.screenSize.height * 0.28,
                            ),
                          ),
                          onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
                          fixedFlag: true,
                          scrollStopFlag: true,
                        );
                      },
                      icon: const Icon(FontAwesomeIcons.toriiGate, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
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
  void makeTempleDataList() {
    templeDataList = <TempleData>[];

    final List<double> latList = <double>[];
    final List<double> lngList = <double>[];

    final List<String> templeNamesList = <String>[];

    templeState.templeList
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

    for (final String element in templeNamesList) {
      final TempleLatLngModel? temple = templeLatLngState.templeLatLngMap[element];

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

  ///
  void makeMarker() {
    Offset initialPosition = Offset(context.screenSize.width * 0.5, context.screenSize.height * 0.2);

    if (appParamState.overlayPosition != null) {
      initialPosition = appParamState.overlayPosition!;
    }

    // ===================================

    final List<TempleData> selectedTempleDateList = <TempleData>[];

    if (appParamState.visitedTempleSelectedDate == '') {
      selectedTempleDateList.add(
        TempleData(
          name: templeState.selectTempleName,
          address: '',
          latitude: templeState.selectTempleLat,
          longitude: templeState.selectTempleLng,
        ),
      );
    } else {
      final List<TempleModel> roopList = List<TempleModel>.from(templeState.templeList);

      for (final TempleModel element in roopList) {
        if (element.date.yyyymmdd == appParamState.visitedTempleSelectedDate) {
          final List<String> templeList = <String>[element.temple];

          if (element.memo.isNotEmpty) {
            element.memo.split('、').forEach((String e2) => templeList.add(e2));
          }

          for (final String element2 in templeList) {
            if (templeLatLngState.templeLatLngMap[element2] != null) {
              selectedTempleDateList.add(
                TempleData(
                  name: templeLatLngState.templeLatLngMap[element2]!.temple,
                  address: templeLatLngState.templeLatLngMap[element2]!.address,
                  latitude: templeLatLngState.templeLatLngMap[element2]!.lat,
                  longitude: templeLatLngState.templeLatLngMap[element2]!.lng,
                ),
              );
            }
          }
        }
      }
    }

    // ===================================

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
                      height: 250,
                      color: Colors.blueGrey.withOpacity(0.3),
                      initialPosition: initialPosition,
                      widget: Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
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
                      onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
                      secondEntries: _secondEntries,
                      ref: ref,
                      from: 'VisitedTempleMapAlert',
                    );
                  },
            child: CircleAvatar(
              backgroundColor: getVisitedTempleCircleAvatarBgColor(
                  templeData: templeDataList[i], selectedTempleDateList: selectedTempleDateList),
              child: const Text('', style: TextStyle(fontSize: 10, color: Colors.black)),
            ),
          ),
        ),
      );
    }
  }

  ///
  Color getVisitedTempleCircleAvatarBgColor(
      {required TempleData templeData, required List<TempleData> selectedTempleDateList}) {
    Color color = Colors.pinkAccent.withOpacity(0.5);

    for (final TempleData element in selectedTempleDateList) {
      if (element.name == templeData.name &&
          element.latitude == templeData.latitude &&
          element.longitude == templeData.longitude) {
        color = Colors.blueAccent.withOpacity(0.5);
      }
    }

    return color;
  }
}
