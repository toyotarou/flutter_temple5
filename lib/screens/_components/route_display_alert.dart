import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../function.dart';

class RouteDisplayAlert extends ConsumerStatefulWidget {
  const RouteDisplayAlert({super.key});

  @override
  ConsumerState<RouteDisplayAlert> createState() => _RouteDisplayAlertState();
}

class _RouteDisplayAlertState extends ConsumerState<RouteDisplayAlert> with ControllersMixin<RouteDisplayAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    routingNotifier.insertRoute();
                  },
                  icon: const Icon(
                    Icons.input,
                    color: Colors.white,
                  ),
                ),
                Container(),
              ],
            ),
            Divider(
              color: Colors.white.withOpacity(0.5),
              thickness: 5,
            ),
            Expanded(child: displayRoute()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayRoute() {
    final List<Widget> list = <Widget>[];

    final DateFormat timeFormat = DateFormat('HH:mm');
    final String startTime = timeFormat.format(DateTime.parse(routingState.startTime));

    String keepEndTime = '';

    final List<TempleData> record = routingState.routingTempleDataList;

    for (int i = 0; i < record.length; i++) {
      final List<String> ll = <String>[record[i].latitude, record[i].longitude];

      String distance = '';
      int walkMinutes = 0;
      if (i < record.length - 1) {
        if ((record[i].latitude == record[i + 1].latitude) && (record[i].longitude == record[i + 1].longitude)) {
          // 緯度経度が同じ場合
          distance = '0';
        } else {
          distance = calcDistance(
            originLat: record[i].latitude.toDouble(),
            originLng: record[i].longitude.toDouble(),
            destLat: record[i + 1].latitude.toDouble(),
            destLng: record[i + 1].longitude.toDouble(),
          );
        }

        final int dist1000 = int.parse(
          (double.parse(distance) * 1000).toString().split('.')[0],
        );
        final int ws = routingState.walkSpeed * 1000;
        final double percent = (100 + routingState.adjustPercent) / 100;
        walkMinutes = ((dist1000 / ws * 60) * percent).round();
      }

      final List<String> exMark = record[i].mark.split('-');

      //------------------------//
      String st = (i == 0) ? startTime : keepEndTime;
      final int spotStayTime = (exMark.length == 1) ? routingState.spotStayTime : 0;
      st = getTimeStr(time: st, minutes: spotStayTime);
      final String endTime = getTimeStr(time: st, minutes: walkMinutes);
      //------------------------//

      list.add(
        Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: getCircleAvatarBgColor(
                    element: record[i],
                    ref: ref,
                  ),
                  child: Text(
                    i.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(record[i].name),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(record[i].address),
                            Text(
                              ll.join(' / '),
                              style: const TextStyle(fontSize: 8),
                            ),
                            if (exMark.length == 1) ...<Widget>[
                              Text('滞在時間：$spotStayTime 分'),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (i < record.length - 1)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.arrow_downward_outlined,
                    size: 40,
                    color: Colors.white.withOpacity(0.4),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(st),
                        Row(
                          children: <Widget>[
                            Text('$distance Km'),
                            const Text(' / '),
                            Text('$walkMinutes 分'),
                          ],
                        ),
                        Text(endTime),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 30),
          ],
        ),
      );

      keepEndTime = endTime;
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: list[index],
            ),
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  ///
  String getTimeStr({required String time, required int minutes}) {
    final DateTime dt = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      time.split(':')[0].toInt(),
      time.split(':')[1].toInt(),
    ).add(Duration(minutes: minutes));

    final DateFormat timeFormat = DateFormat('HH:mm');

    return timeFormat.format(dt);
  }
}
