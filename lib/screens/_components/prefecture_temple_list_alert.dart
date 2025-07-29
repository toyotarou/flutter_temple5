import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/tokyo_shikuchouson_data.dart';
import '../../models/prefecture_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../utility/tokyo_shikuchouson.dart';
import '../_parts/_temple_dialog.dart';
import 'prefecture_temple_map_alert.dart';

class PrefectureTempleListAlert extends ConsumerStatefulWidget {
  const PrefectureTempleListAlert({super.key});

  @override
  ConsumerState<PrefectureTempleListAlert> createState() => _PrefectureListAlertState();
}

class _PrefectureListAlertState extends ConsumerState<PrefectureTempleListAlert>
    with ControllersMixin<PrefectureTempleListAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(width: context.screenSize.width),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Prefecture List', style: TextStyle(color: Colors.white)),
                  SizedBox.shrink(),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
              Expanded(child: displayPrefectureList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayPrefectureList() {
    final List<Widget> list = <Widget>[];

    final List<TokyoShikuchousonData> tokyoShikuchouson = getTokyoShikuchouson();

    final Map<String, List<TempleLatLngModel>> tokyoTempleMap = <String, List<TempleLatLngModel>>{};
    final Map<String, List<TempleLatLngModel>> prefectureTempleMap = <String, List<TempleLatLngModel>>{};

    for (final PrefectureModel element in prefectureState.prefectureList) {
      if (element.name != null) {
        if (element.id == 13) {
          for (final TokyoShikuchousonData element3 in tokyoShikuchouson) {
            final RegExp reg = RegExp('${element.name}${element3.name}');

            for (final TempleLatLngModel element2 in templeLatLngState.templeLatLngList) {
              if (reg.firstMatch(element2.address) != null) {
                (tokyoTempleMap['${element.name}${element3.name}'] ??= <TempleLatLngModel>[]).add(element2);
              }
            }
          }
        } else {
          final RegExp reg = RegExp(element.name!);

          for (final TempleLatLngModel element2 in templeLatLngState.templeLatLngList) {
            if (reg.firstMatch(element2.address) != null) {
              (prefectureTempleMap[element.name!] ??= <TempleLatLngModel>[]).add(element2);
            }
          }
        }
      }
    }

    final Map<String, List<TempleLatLngModel>> roopVal = <String, List<TempleLatLngModel>>{
      ...tokyoTempleMap,
      ...prefectureTempleMap
    };

    roopVal.forEach(
      (String key, List<TempleLatLngModel> value) {
        list.add(
          DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(key),
                  Row(
                    children: <Widget>[
                      Text('${value.length}'),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          TempleDialog(
                            context: context,
                            widget: PrefectureTempleMapAlert(
                              templeLatLngModelList: value,
                              prefectureName: key,
                            ),
                            rotate: 0,
                            clearBarrierColor: true,
                          );
                        },
                        child: Icon(Icons.map, color: Colors.white.withValues(alpha: 0.4)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

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
