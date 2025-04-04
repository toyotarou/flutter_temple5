import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/temple_photo_model.dart';
import '../_parts/_temple_dialog.dart';
import 'visited_temple_photo_alert.dart';

class VisitedTemplePhotoListAlert extends ConsumerStatefulWidget {
  const VisitedTemplePhotoListAlert({super.key, required this.temple, required this.templePhotoTempleMap});

  final TempleData temple;
  final Map<String, List<TemplePhotoModel>> templePhotoTempleMap;

  @override
  ConsumerState<VisitedTemplePhotoListAlert> createState() => _VisitedTemplePhotoListAlertState();
}

class _VisitedTemplePhotoListAlertState extends ConsumerState<VisitedTemplePhotoListAlert>
    with ControllersMixin<VisitedTemplePhotoListAlert> {
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

    widget.templePhotoTempleMap[widget.temple.name]?.forEach((TemplePhotoModel element) {
      list.add(DefaultTextStyle(
        style: const TextStyle(fontSize: 12, color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: context.screenSize.width),
            Text(element.date.yyyymmdd),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: element.templephotos.map((String e) {
                return GestureDetector(
                  onTap: () {
                    TempleDialog(
                      context: context,
                      widget: VisitedTemplePhotoAlert(url: e),
                      rotate: 0,
                    );
                  },
                  child: Hero(
                    tag: e.split('/').last.split('.')[0],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      width: 50,
                      child: CachedNetworkImage(
                        imageUrl: e,
                        placeholder: (BuildContext context, String url) => Image.asset('assets/images/no_image.png'),
                        errorWidget: (BuildContext context, String url, Object error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              }).toList()),
            ),
            const SizedBox(height: 20),
          ],
        ),
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
