import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/temple/temple.dart';

import '../../controllers/temple_lat_lng/temple_lat_lng.dart';
import '../../extensions/extensions.dart';

import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_model.dart';

///
Widget visitedTempleListParts({required WidgetRef ref}) {
  final List<Widget> list = <Widget>[];

  final AsyncValue<TempleLatLngState> templeLatLngState = ref.watch(templeLatLngProvider);
  final Map<String, TempleLatLngModel>? templeLatLngMap = templeLatLngState.value?.templeLatLngMap;

  final TempleState templeState = ref.watch(templeProvider);

  final List<TempleModel> roopList = List<TempleModel>.from(templeState.templeList);

  String keepYear = '';

  int i = 0;
  for (final TempleModel element in roopList) {
    final List<String> templeList = <String>[element.temple];

    if (element.memo.isNotEmpty) {
      element.memo.split('、').forEach((String e2) => templeList.add(e2));
    }

    if (keepYear != element.date.yyyymmdd.split('-')[0]) {
      list.add(
        Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
          margin: (i == 0) ? null : const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(element.date.yyyymmdd.split('-')[0]),
              Container(),
            ],
          ),
        ),
      );
    }

    list.add(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 80, child: Text(element.date.yyyymmdd)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: templeList.map((String element2) {
                  return Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (templeLatLngMap?[element2] != null) {
                            ref.read(appParamProvider.notifier).setVisitedTempleMapDisplayFinish(flag: false);

                            ref.read(templeProvider.notifier).setSelectTemple(
                                name: element2,
                                lat: templeLatLngMap![element2]!.lat,
                                lng: templeLatLngMap[element2]!.lng);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5, right: 15),
                          child: Icon(Icons.all_out, color: Colors.white),
                        ),
                      ),
                      Expanded(child: Text(element2)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );

    keepYear = element.date.yyyymmdd.split('-')[0];

    i++;
  }

  return DefaultTextStyle(style: const TextStyle(fontSize: 12), child: Column(children: list));
}
