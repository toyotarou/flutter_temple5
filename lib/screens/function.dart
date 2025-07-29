import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/_get_data/temple/temple.dart';
import '../controllers/app_param/app_param.dart';
import '../controllers/routing/routing.dart';
import '../extensions/extensions.dart';
import '../models/common/temple_data.dart';
import '../models/temple_model.dart';

///
Color? getCircleAvatarBgColor({required TempleData element, required WidgetRef ref}) {
  var appParamState = ref.watch(appParamProvider);

  Color? color;

  switch (element.mark) {
    case 'S':
    case 'E':
    case 'S/E':
    case '0':
    case 'STA':
      color = Colors.green[900]?.withOpacity(0.5);
    case '01':
      color = Colors.redAccent.withOpacity(0.5);
    default:
      if (element.cnt > 0) {
        color = Colors.pinkAccent.withOpacity(0.5);
      } else {
        color = Colors.orangeAccent.withOpacity(0.5);
      }
  }

  if (element.mark.split('-').length == 2) {
    color = Colors.purpleAccent.withOpacity(0.5);
  } else {
    final List<TempleData> routingTempleDataList =
        ref.watch(routingProvider.select((RoutingState value) => value.routingTempleDataList));

    final int pos = routingTempleDataList.indexWhere((TempleData element2) => element2.mark == element.mark);

    if (pos != -1) {
      color = Colors.indigo.withOpacity(0.5);
    }
  }

  if (appParamState.selectTempleName == element.name &&
      appParamState.selectTempleLat == element.latitude &&
      appParamState.selectTempleLng == element.longitude) {
    color = Colors.redAccent.withOpacity(0.5);
  }

  return color;
}

///
Map<String, dynamic> makeBounds({required List<TempleData> data}) {
  final List<double> latList = <double>[];
  final List<double> lngList = <double>[];

  for (final TempleData element in data) {
    latList.add(element.latitude.toDouble());
    lngList.add(element.longitude.toDouble());
  }

  if (latList.isNotEmpty && lngList.isNotEmpty) {
    final double minLat = latList.reduce(min);
    final double maxLat = latList.reduce(max);
    final double minLng = lngList.reduce(min);
    final double maxLng = lngList.reduce(max);

    final double latDiff = maxLat - minLat;
    final double lngDiff = maxLng - minLng;
    final double small = (latDiff < lngDiff) ? latDiff : lngDiff;

    final Map<String, double> boundsLatLngMap = <String, double>{
      'minLat': minLat,
      'maxLat': maxLat,
      'minLng': minLng,
      'maxLng': maxLng,
    };

    return <String, dynamic>{'boundsLatLngMap': boundsLatLngMap, 'boundsInner': small};
  }

  return <String, dynamic>{};
}

///
String calcDistance({
  required double originLat,
  required double originLng,
  required double destLat,
  required double destLng,
}) {
  final double distanceKm = 6371 *
      acos(
        cos(originLat / 180 * pi) * cos((destLng - originLng) / 180 * pi) * cos(destLat / 180 * pi) +
            sin(originLat / 180 * pi) * sin(destLat / 180 * pi),
      );

  final List<String> exDistance = distanceKm.toString().split('.');

  final String seisuu = exDistance[0];
  final String shousuu = exDistance[1].substring(0, 2);

  return '$seisuu.$shousuu';
}

///
List<int> makeTempleVisitYearList({required WidgetRef ref}) {
  final List<int> list = <int>[];

  ref.watch(templeProvider.select((TempleState value) => value.templeList)).forEach((TempleModel element) {
    if (!list.contains(element.date.year)) {
      list.add(element.date.year);
    }
  });

  return list;
}
