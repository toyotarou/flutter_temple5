import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart' as cni;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_model.dart';
import '../../utility/tile_provider.dart';
import '../_parts/_temple_dialog.dart';
import '../function.dart';
import 'temple_course_display_alert.dart';
import 'temple_photo_gallery_alert.dart';

class TempleDetailMapAlert extends ConsumerStatefulWidget {
  const TempleDetailMapAlert({super.key, required this.date, required this.data});

  final DateTime date;

  final TempleModel data;

  @override
  ConsumerState<TempleDetailMapAlert> createState() => _TempleDetailMapAlertState();
}

class _TempleDetailMapAlertState extends ConsumerState<TempleDetailMapAlert>
    with ControllersMixin<TempleDetailMapAlert> {
  List<TempleData> templeDataList = <TempleData>[];

  List<double> latList = <double>[];
  List<double> lngList = <double>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  List<Marker> markerList = <Marker>[];

  String start = '';
  String end = '';

  final MapController mapController = MapController();

  double currentZoomEightTeen = 18;

  bool isLoading = false;

  double? currentZoom;

  bool getBoundsZoomValue = false;

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
    makeTempleDataList();

    makeMinMaxLatLng();

    makeMarker();

    makeStartEnd();

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

              MarkerLayer(markers: markerList),
              // ignore: always_specify_types
              PolylineLayer(
                polylines: <Polyline<Object>>[
                  // ignore: always_specify_types
                  Polyline(
                    points: templeDataList.map((TempleData e) {
                      return LatLng(e.latitude.toDouble(), e.longitude.toDouble());
                    }).toList(),
                    color: Colors.redAccent,
                    strokeWidth: 5,
                  ),
                ],
              ),
            ],
          ),
          Positioned(top: 5, right: 5, left: 5, child: displayInfoPlate()),
          if (isLoading) ...<Widget>[
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  ///
  Widget displayInfoPlate() {
    final TempleModel? temple = templeState.dateTempleMap[widget.date.yyyymmdd];

    return Container(
      width: context.screenSize.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () {
              TempleDialog(
                context: context,
                widget: TempleCourseDisplayAlert(data: templeDataList),
                paddingLeft: context.screenSize.width * 0.2,
                clearBarrierColor: true,
              );
            },
            icon: const Icon(Icons.info_outline, size: 30, color: Colors.white),
          ),
          if (temple == null)
            Container()
          else
            DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.date.yyyymmdd),
                  Text(temple.temple),
                  const SizedBox(height: 10),
                  Text(start),
                  Text(end),
                  if (temple.memo != '') ...<Widget>[
                    const SizedBox(height: 10),
                    Flexible(
                      child: SizedBox(
                        width: context.screenSize.width * 0.6,
                        child: Text(temple.memo),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  displayThumbNailPhoto(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  ///
  Widget displayThumbNailPhoto() {
    final TempleModel? temple = templeState.dateTempleMap[widget.date.yyyymmdd];

    final List<Widget> list = <Widget>[];

    if (temple != null) {
      if (temple.photo.isNotEmpty) {
        for (int i = 0; i < temple.photo.length; i++) {
          list.add(
            GestureDetector(
              onTap: () =>
                  TempleDialog(context: context, widget: TemplePhotoGalleryAlert(photoList: temple.photo, number: i)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: 50,
                child: cni.CachedNetworkImage(
                  imageUrl: temple.photo[i],
                  placeholder: (BuildContext context, String url) => Image.asset('assets/images/no_image.png'),
                  errorWidget: (BuildContext context, String url, Object error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        }
      }
    }

    return SizedBox(
      width: context.screenSize.width * 0.6,
      child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: list)),
    );
  }

  ///
  void makeTempleDataList() {
    templeDataList = <TempleData>[];

    final TempleModel? temple = templeState.dateTempleMap[widget.date.yyyymmdd];

    if (temple != null) {
      getStartEndPointInfo(temple: temple, flag: 'start');

      if (templeLatLngState.templeLatLngMap[temple.temple] != null) {
        templeDataList.add(
          TempleData(
            name: temple.temple,
            address: templeLatLngState.templeLatLngMap[temple.temple]!.address,
            latitude: templeLatLngState.templeLatLngMap[temple.temple]!.lat,
            longitude: templeLatLngState.templeLatLngMap[temple.temple]!.lng,
            mark: '01',
          ),
        );
      }

      if (temple.memo != '') {
        int i = 2;
        temple.memo.split('、').forEach((String element) {
          final TempleLatLngModel? latlng = templeLatLngState.templeLatLngMap[element];

          if (latlng != null) {
            templeDataList.add(
              TempleData(
                name: element,
                address: latlng.address,
                latitude: latlng.lat,
                longitude: latlng.lng,
                mark: i.toString().padLeft(2, '0'),
              ),
            );
          }

          i++;
        });
      }

      getStartEndPointInfo(temple: temple, flag: 'end');
    }
  }

  ///
  Future<void> getStartEndPointInfo({required TempleModel temple, required String flag}) async {
    String point = '';
    switch (flag) {
      case 'start':
        point = temple.startPoint;
      case 'end':
        point = temple.endPoint;
    }

    if (stationState.stationMap[point] != null) {
      templeDataList.add(
        TempleData(
          name: stationState.stationMap[point]!.stationName,
          address: stationState.stationMap[point]!.address,
          latitude: stationState.stationMap[point]!.lat,
          longitude: stationState.stationMap[point]!.lng,
          mark: (flag == 'end')
              ? (temple.startPoint == temple.endPoint)
                  ? 'S/E'
                  : 'E'
              : (temple.startPoint == temple.endPoint)
                  ? 'S/E'
                  : 'S',
        ),
      );
    } else {
      switch (point) {
        case '自宅':
          templeDataList.add(
            TempleData(
              name: point,
              address: '千葉県船橋市二子町492-25-101',
              latitude: '35.7102009',
              longitude: '139.9490672',
              mark: (flag == 'end')
                  ? (temple.startPoint == temple.endPoint)
                      ? 'S/E'
                      : 'E'
                  : (temple.startPoint == temple.endPoint)
                      ? 'S/E'
                      : 'S',
            ),
          );

        case '実家':
          templeDataList.add(
            TempleData(
              name: point,
              address: '東京都杉並区善福寺4-22-11',
              latitude: '35.7185071',
              longitude: '139.5869534',
              mark: (flag == 'end')
                  ? (temple.startPoint == temple.endPoint)
                      ? 'S/E'
                      : 'E'
                  : (temple.startPoint == temple.endPoint)
                      ? 'S/E'
                      : 'S',
            ),
          );
      }
    }
  }

  ///
  void makeMinMaxLatLng() {
    for (final TempleData element in templeDataList) {
      latList.add(element.latitude.toDouble());
      lngList.add(element.longitude.toDouble());
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
    markerList = <Marker>[];

    for (int i = 0; i < templeDataList.length; i++) {
      markerList.add(
        Marker(
          point: LatLng(templeDataList[i].latitude.toDouble(), templeDataList[i].longitude.toDouble()),
          width: 40,
          height: 40,
          child: CircleAvatar(
            backgroundColor: getCircleAvatarBgColor(element: templeDataList[i], ref: ref),
            child: Text(
              templeDataList[i].mark,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
  }

  ///
  void makeStartEnd() {
    if (templeDataList.isNotEmpty) {
      final Iterable<TempleData> sWhere =
          templeDataList.where((TempleData element) => element.mark == 'S' || element.mark == 'S/E');
      if (sWhere.isNotEmpty) {
        start = sWhere.first.name;
      }

      final Iterable<TempleData> eWhere =
          templeDataList.where((TempleData element) => element.mark == 'E' || element.mark == 'S/E');

      if (eWhere.isNotEmpty) {
        end = eWhere.first.name;
      }
    }

    setState(() {});
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
}
