import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/temple_model.dart';

class VisitedTemplePhotoListAlert extends ConsumerStatefulWidget {
  const VisitedTemplePhotoListAlert(
      {super.key, required this.templeVisitDateMap, required this.temple, required this.dateTempleMap});

  final Map<String, List<String>> templeVisitDateMap;
  final TempleData temple;
  final Map<String, TempleModel> dateTempleMap;

  @override
  ConsumerState<VisitedTemplePhotoListAlert> createState() => _VisitedTemplePhotoListAlertState();
}

class _VisitedTemplePhotoListAlertState extends ConsumerState<VisitedTemplePhotoListAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            Text(widget.temple.name, style: const TextStyle(color: Colors.white)),
            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
            const SizedBox(height: 10),
            Expanded(child: displayVisitedTemplePhoto()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayVisitedTemplePhoto() {
    final List<Widget> list = <Widget>[];

    widget.templeVisitDateMap[widget.temple.name]?.forEach((String element) {
      list.add(
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[Colors.white.withOpacity(0.1), Colors.transparent],
              stops: const <double>[0.7, 1],
            ),
          ),
          padding: const EdgeInsets.all(5),
          child: Text(element, style: const TextStyle(color: Colors.white)),
        ),
      );

      final List<Widget> list2 = <Widget>[];

      widget.dateTempleMap[element]?.photo.forEach((String element2) {
        list2.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            width: 50,
            child: CachedNetworkImage(
              imageUrl: element2,
              placeholder: (BuildContext context, String url) => Image.asset('assets/images/no_image.png'),
              errorWidget: (BuildContext context, String url, Object error) => const Icon(Icons.error),
            ),
          ),
        );
      });

      list.add(SizedBox(
        height: 100,
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: list2)),
      ));
    });

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
