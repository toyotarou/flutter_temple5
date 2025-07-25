import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';

import '../_parts/temple_overlay.dart';
import '../_parts/visited_temple_list_parts.dart';

class VisitedTempleFromHomeMapAlert extends ConsumerStatefulWidget {
  const VisitedTempleFromHomeMapAlert({super.key});

  @override
  ConsumerState<VisitedTempleFromHomeMapAlert> createState() => _VisitedTempleFromHomeMapAlertState();
}

class _VisitedTempleFromHomeMapAlertState extends ConsumerState<VisitedTempleFromHomeMapAlert>
    with ControllersMixin<VisitedTempleFromHomeMapAlert> {
  final MapController mapController = MapController();

  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  List<Marker> markerList = <Marker>[];

  List<Polyline<Object>> polylineList = <Polyline<Object>>[];

  bool searchAddressAreaDisplayFlag = false;
  TextEditingController searchAddressEditingController = TextEditingController();

  ///
  @override
  Widget build(BuildContext context) {
    makeMarker();

    makePolyline();

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
              TileLayer(urlTemplate: 'https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png'),
              MarkerLayer(
                markers: <Marker>[
                  Marker(
                    point: appParamState.visitedTempleFromHomeLatLng!,
                    child: const Icon(Icons.home, color: Colors.redAccent),
                  ),
                ],
              ),
              // ignore: always_specify_types
              PolylineLayer(polylines: polylineList),
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
                          appParamNotifier.setSecondOverlayParams(secondEntries: _secondEntries);

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
                                context: context,
                                ref: ref,
                                templeLatLngMap: templeLatLngState.templeLatLngMap,
                                listHeight: context.screenSize.height * 0.28,
                                from: 'VisitedTempleFromHomeMapAlert',
                              ),
                            ),
                            onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
                            fixedFlag: true,
                            scrollStopFlag: true,
                          );
                        },
                        icon: const Icon(Icons.calendar_month, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),

                    Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () => mapController.rotate(0),
                        icon: const Icon(FontAwesomeIcons.n, color: Colors.white),
                      ),
                    ),

                    // Container(
                    //   decoration:
                    //       BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                    //   child: IconButton(
                    //     onPressed: () => setState(() => searchAddressAreaDisplayFlag = !searchAddressAreaDisplayFlag),
                    //     icon: const Icon(Icons.search, color: Colors.white),
                    //   ),
                    // ),
                  ],
                ),
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
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  onPressed: () => setState(() => searchAddressAreaDisplayFlag = !searchAddressAreaDisplayFlag),
                  icon: const Icon(Icons.search, color: Colors.white),
                ),
              ),

              // Container(
              //   decoration:
              //       BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
              //   child: IconButton(
              //     onPressed: () => mapController.rotate(0),
              //     icon: const Icon(FontAwesomeIcons.n, color: Colors.white),
              //   ),
              // ),

              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: <Widget>[
                    if (searchAddressAreaDisplayFlag) ...<Widget>[
                      Container(
                        height: 50,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.pinkAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: searchAddressEditingController,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                  hintText: '住所',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                ),
                                style: const TextStyle(fontSize: 13, color: Colors.black),
                                onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (searchAddressEditingController.text.trim() != '') {
                                  appParamNotifier.setVisitedTempleFromHomeSearchAddress(
                                    str: searchAddressEditingController.text.trim(),
                                  );
                                }
                              },
                              icon: const Icon(Icons.input),
                            ),
                            IconButton(
                              onPressed: () {
                                searchAddressEditingController.clear();

                                appParamNotifier.setVisitedTempleFromHomeSearchAddress(str: '');
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox.shrink(),
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                              child: IconButton(
                                onPressed: () {
                                  final num zoom = appParamState.currentZoom == 0 ? 10 : appParamState.currentZoom;
                                  final double newZoom = zoom + 0.5;

                                  appParamNotifier.setCurrentZoom(zoom: newZoom);

                                  mapController.move(appParamState.visitedTempleFromHomeLatLng!, newZoom);
                                },
                                icon: const Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                              child: IconButton(
                                onPressed: () {
                                  final num zoom = appParamState.currentZoom == 0 ? 10 : appParamState.currentZoom;

                                  double newZoom = zoom - 0.5;
                                  if (newZoom < 0) {
                                    newZoom = 0;
                                  }

                                  appParamNotifier.setCurrentZoom(zoom: newZoom);

                                  mapController.move(appParamState.visitedTempleFromHomeLatLng!, newZoom);
                                },
                                icon: const Icon(Icons.remove, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  void makeMarker() {
    // final List<LatLng> latLngList = makeLatLngList();
    //
    // print(latLngList);
  }

  ///
  void makePolyline() {
    polylineList = <Polyline<Object>>[];

    final Map<String, List<LatLng>> latLngMap = makeLatLngMap();

    if (latLngMap.isNotEmpty) {
      latLngMap.forEach((String key, List<LatLng> value) {
        polylineList.add(
          // ignore: always_specify_types
          Polyline(points: value.map((LatLng e) => e).toList(), color: Colors.redAccent, strokeWidth: 5),
        );
      });
    }
  }

  ///
  Map<String, List<LatLng>> makeLatLngMap() {
    final Map<String, List<LatLng>> latLngMap = <String, List<LatLng>>{};

    if (appParamState.visitedTempleFromHomeSelectedDateList.isNotEmpty) {
      for (final String element in appParamState.visitedTempleFromHomeSelectedDateList) {
        latLngMap[element] = <LatLng>[];
      }

      for (final String element in appParamState.visitedTempleFromHomeSelectedDateList) {
        //////////////// start
        if (templeState.dateTempleMap[element] != null) {
          if (stationState.stationMap[templeState.dateTempleMap[element]!.startPoint] != null) {
            latLngMap[element]?.add(
              LatLng(
                stationState.stationMap[templeState.dateTempleMap[element]!.startPoint]!.lat.toDouble(),
                stationState.stationMap[templeState.dateTempleMap[element]!.startPoint]!.lng.toDouble(),
              ),
            );
          } else {
            switch (templeState.dateTempleMap[element]!.startPoint) {
              case '自宅':
                latLngMap[element]?.add(const LatLng(funabashiLat, funabashiLng));
              case '実家':
                latLngMap[element]?.add(const LatLng(zenpukujiLat, zenpukujiLng));
            }
          }
        }
        //////////////// start

        //////////////// temple
        final List<String> templeList = <String>[];
        if (templeState.dateTempleMap[element] != null) {
          templeList.add(templeState.dateTempleMap[element]!.temple);

          if (templeState.dateTempleMap[element]!.memo.isNotEmpty) {
            templeState.dateTempleMap[element]!.memo.split('、').forEach((String e) {
              templeList.add(e);
            });
          }
        }

        if (templeList.isNotEmpty) {
          for (final String element2 in templeList) {
            if (templeLatLngState.templeLatLngMap[element2] != null) {
              latLngMap[element]?.add(LatLng(
                templeLatLngState.templeLatLngMap[element2]!.lat.toDouble(),
                templeLatLngState.templeLatLngMap[element2]!.lng.toDouble(),
              ));
            }
          }
        }
        //////////////// temple

        //////////////// goal
        if (templeState.dateTempleMap[element] != null) {
          if (stationState.stationMap[templeState.dateTempleMap[element]!.endPoint] != null) {
            latLngMap[element]?.add(
              LatLng(
                stationState.stationMap[templeState.dateTempleMap[element]!.endPoint]!.lat.toDouble(),
                stationState.stationMap[templeState.dateTempleMap[element]!.endPoint]!.lng.toDouble(),
              ),
            );
          } else {
            switch (templeState.dateTempleMap[element]!.endPoint) {
              case '自宅':
                latLngMap[element]?.add(const LatLng(funabashiLat, funabashiLng));
              case '実家':
                latLngMap[element]?.add(const LatLng(zenpukujiLat, zenpukujiLng));
            }
          }
        }
        //////////////// goal
      }
    }

    return latLngMap;
  }
}
