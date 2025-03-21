import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/app_params/app_params_response_state.dart';
import '../../controllers/temple/temple.dart';

import '../../extensions/extensions.dart';

import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_model.dart';

///
Widget visitedTempleListParts({
  required WidgetRef ref,
  required Map<String, TempleLatLngModel> templeLatLngMap,
  required double listHeight,
  required String from,
  required BuildContext context,
}) {
  final ScrollController scrollController = ScrollController();

  final List<Widget> list = <Widget>[];

  final TempleState templeState = ref.watch(templeProvider);

  final List<TempleModel> roopList = List<TempleModel>.from(templeState.templeList);

  final List<String> yearList = <String>[];

  for (final TempleModel element in roopList) {
    if (!yearList.contains(element.date.yyyymmdd.split('-')[0])) {
      yearList.add(element.date.yyyymmdd.split('-')[0]);
    }
  }

  final int visitedTempleSelectedYear =
      ref.watch(appParamProvider.select((AppParamsResponseState value) => value.visitedTempleSelectedYear));

  String keepYear = '';

  for (final TempleModel element in roopList) {
    if (visitedTempleSelectedYear == 0 || visitedTempleSelectedYear == element.date.yyyymmdd.split('-')[0].toInt()) {
      final List<String> templeList = <String>[element.temple];

      if (element.memo.isNotEmpty) {
        element.memo.split('、').forEach((String e2) => templeList.add(e2));
      }

      if (keepYear != element.date.yyyymmdd.split('-')[0]) {
        list.add(
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
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
              SizedBox(
                width: 120,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () =>
                          ref.read(appParamProvider.notifier).setVisitedTempleSelectedDate(date: element.date.yyyymmdd),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5, right: 15),
                        child: Icon(Icons.location_on, color: Colors.white),
                      ),
                    ),
                    Text(element.date.yyyymmdd),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: templeList.map((String element2) {
                    return Row(
                      children: <Widget>[
                        if (from == 'VisitedTempleMapAlert') ...<Widget>[
                          GestureDetector(
                            onTap: () {
                              if (templeLatLngMap[element2] != null) {
                                ref.read(appParamProvider.notifier).setVisitedTempleMapDisplayFinish(flag: false);

                                ref.read(templeProvider.notifier).setSelectTemple(
                                    name: element2,
                                    lat: templeLatLngMap[element2]!.lat,
                                    lng: templeLatLngMap[element2]!.lng);
                              }
                            },
                            child: Container(
                              width: 40,
                              alignment: Alignment.topLeft,
                              child: const Icon(Icons.all_out, color: Colors.white),
                            ),
                          ),
                        ],
                        if (from == 'VisitedTempleFromHomeMapAlert') ...<Widget>[const SizedBox(width: 40)],
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
    }

    keepYear = element.date.yyyymmdd.split('-')[0];
  }

  return DefaultTextStyle(
    style: const TextStyle(fontSize: 12),
    child: Column(
      children: <Widget>[
        SizedBox(
          height: 60,
          child: Row(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  ref.read(appParamProvider.notifier).setVisitedTempleSelectedYear(year: 0);
                },
                child: const Text('YEAR\nCLEAR', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              TextButton(
                onPressed: () {
                  ref.read(appParamProvider.notifier).setVisitedTempleSelectedDate(date: '');

                  ref.read(appParamProvider.notifier).setVisitedTempleMapDisplayFinish(flag: true);

                  ref.read(templeProvider.notifier).setSelectTemple(name: '', lat: '', lng: '');
                },
                child: const Text('SELECT\nCLEAR', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: yearList.map(
                      (String e) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              ref.read(appParamProvider.notifier).setVisitedTempleSelectedYear(year: e.toInt());

                              scrollController.jumpTo(0);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.blueAccent.withOpacity(0.4),
                              child: Text(e, style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: listHeight,
          child: SingleChildScrollView(controller: scrollController, child: Column(children: list)),
        ),
      ],
    ),
  );
}
