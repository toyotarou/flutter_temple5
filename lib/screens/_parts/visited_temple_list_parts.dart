import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/temple/temple.dart';

import '../../extensions/extensions.dart';

import '../../models/temple_model.dart';

// import '../function.dart';
//
//
//

///
Widget visitedTempleListParts({
  //   required List<TempleModel> templeList,
  // required Map<String, List<String>> templeVisitDateMap,
  // required Map<String, TempleModel> dateTempleMap,
  required WidgetRef ref,
  // required BuildContext context
  //
  //
}) {
  // List<int> yearList = <int>[];
  //
  // if (yearList.isEmpty) {
  //   yearList = makeTempleVisitYearList(ref: ref);
  // }

  final TempleState templeState = ref.watch(templeProvider);

  final List<TempleModel> roopList = List<TempleModel>.from(templeState.templeList);

  return DefaultTextStyle(
    style: const TextStyle(fontSize: 12),
    child: Column(
      children: roopList.map((TempleModel e) {
        final List<String> templeList = <String>[e.temple];

        if (e.memo.isNotEmpty) {
          e.memo.split('、').forEach((String e2) => templeList.add(e2));
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 80, child: Text(e.date.yyyymmdd)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: templeList.map((String e3) {
                  return Text(e3);
                }).toList(),
              ),
            ),
          ],
        );
      }).toList(),
    ),
  );
}
