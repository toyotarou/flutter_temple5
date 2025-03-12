import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';

class NeedleCompassSelectedListAlert extends ConsumerStatefulWidget {
  const NeedleCompassSelectedListAlert({super.key, required this.selectedGeoloc});

  final Set<LatLng> selectedGeoloc;

  @override
  ConsumerState<NeedleCompassSelectedListAlert> createState() => _NeedleCompassSelectedListAlertState();
}

class _NeedleCompassSelectedListAlertState extends ConsumerState<NeedleCompassSelectedListAlert>
    with ControllersMixin<NeedleCompassSelectedListAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Container(width: context.screenSize.width),
          Expanded(child: displayNeedleCompassSelectedTempleList()),
        ],
      )),
    );
  }

  ///
  Widget displayNeedleCompassSelectedTempleList() {
    final List<Widget> list = <Widget>[];

    for (final LatLng element in widget.selectedGeoloc) {
      list.add(DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(element.latitude.toString()),
                  Text(element.longitude.toString()),
                ],
              ),
              const SizedBox.shrink(),
            ],
          ),
        ),
      ));
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) => list[index], childCount: list.length),
        ),
      ],
    );
  }
}
