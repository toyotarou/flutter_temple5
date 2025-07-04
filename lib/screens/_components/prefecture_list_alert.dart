import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/tokyo_shikuchouson_data.dart';
import '../../models/prefecture_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../utility/tokyo_shikuchouson.dart';

class PrefectureListAlert extends ConsumerStatefulWidget {
  const PrefectureListAlert({super.key});

  @override
  ConsumerState<PrefectureListAlert> createState() => _PrefectureListAlertState();
}

class _PrefectureListAlertState extends ConsumerState<PrefectureListAlert> with ControllersMixin<PrefectureListAlert> {
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

    tokyoTempleMap.forEach((String key, List<TempleLatLngModel> value) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(key),
          Text('${value.length}'),
        ],
      ));
    });

    prefectureTempleMap.forEach((String key, List<TempleLatLngModel> value) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(key),
          Text('${value.length}'),
        ],
      ));
    });

    /*

    final RegExp reg = RegExp('東京都');

    final List<TempleLatLngModel> notTokyoTemple = <TempleLatLngModel>[];

    for (final TempleLatLngModel element in templeLatLngState.templeLatLngList) {
      if (reg.firstMatch(element.address) == null) {
        notTokyoTemple.add(element);
      }
    }

    print(templeLatLngState.templeLatLngList.length);

    print(notTokyoTemple.length);


    for (final PrefectureModel element in prefectureState.prefectureList) {
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(element.name!), const SizedBox.shrink()],
        ),
      );

      if (element.id == 13) {
        list.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox.shrink(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: tokyoShikuchouson.map(
                  (TokyoShikuchousonData e) {
                    return Text(e.name);
                  },
                ).toList(),
              ),
            ],
          ),
        );
      }
    }

    */

    return SingleChildScrollView(
      child: DefaultTextStyle(style: const TextStyle(fontSize: 12), child: Column(children: list)),
    );
  }
}
