import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_lat_lng_model.dart';
import '../_parts/temple_overlay.dart';

class PrefectureTempleMapAlert extends ConsumerStatefulWidget {
  const PrefectureTempleMapAlert({super.key, required this.templeLatLngModelList, required this.prefectureName});

  final List<TempleLatLngModel> templeLatLngModelList;
  final String prefectureName;

  @override
  ConsumerState<PrefectureTempleMapAlert> createState() => _PrefectureTempleMapAlertState();
}

class _PrefectureTempleMapAlertState extends ConsumerState<PrefectureTempleMapAlert>
    with ControllersMixin<PrefectureTempleMapAlert> {
  final MapController mapController = MapController();

  double currentZoomEightTeen = 18;

  List<double> latList = <double>[];
  List<double> lngList = <double>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  bool isLoading = false;

  double? currentZoom;

  bool getBoundsZoomValue = false;

  List<Marker> markerList = <Marker>[];

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
    makeMinMaxLatLng();

    makeMarker();

    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                TileLayer(urlTemplate: 'https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png'),
                MarkerLayer(markers: markerList),
              ],
            ),
            Positioned(
              top: 5,
              right: 5,
              left: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              widget.prefectureName,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
            if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
          ],
        ),
      ),
    );
  }

  ///
  void makeMinMaxLatLng() {
    latList.clear();
    lngList.clear();

    for (final TempleLatLngModel element in widget.templeLatLngModelList) {
      latList.add(double.parse(element.lat));
      lngList.add(double.parse(element.lng));
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
    if (widget.templeLatLngModelList.length > 1) {
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
    markerList = <Marker>[];

    for (int i = 0; i < widget.templeLatLngModelList.length; i++) {
      markerList.add(
        Marker(
          point: LatLng(widget.templeLatLngModelList[i].lat.toDouble(), widget.templeLatLngModelList[i].lng.toDouble()),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              appParamNotifier.setSecondOverlayParams(secondEntries: _secondEntries);

              addSecondOverlay(
                context: context,
                secondEntries: _secondEntries,
                setStateCallback: setState,
                width: context.screenSize.width,
                height: context.screenSize.height * 0.4,
                color: Colors.blueGrey.withOpacity(0.3),
                initialPosition: Offset(0, context.screenSize.height * 0.6),
                // widget: Consumer(
                //   builder: (BuildContext context, WidgetRef ref, Widget? child) => visitedTempleListParts(
                //     context: context,
                //     ref: ref,
                //     templeLatLngMap: templeLatLngState.templeLatLngMap,
                //     listHeight: context.screenSize.height * 0.28,
                //     from: 'VisitedTempleFromHomeMapAlert',
                //   ),
                // ),
                //
                //
                //

                widget: Container(
                  child: Text('aaaaaaa'),
                ),

                onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
                fixedFlag: true,
                scrollStopFlag: true,
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent.withValues(alpha: 0.3),
              child: Text(
                widget.templeLatLngModelList[i].rank,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }
  }
}
