import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_model.dart';
import '../../models/temple_photo_model.dart';
import '../_parts/_temple_dialog.dart';
import 'visited_temple_photo_list_alert.dart';

class TokyoJinjachouTempleListAlert extends ConsumerStatefulWidget {
  const TokyoJinjachouTempleListAlert(
      {super.key,
      required this.templeVisitDateMap,
      required this.idBaseComplementTempleVisitedDateMap,
      required this.dateTempleMap});

  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, List<DateTime>> idBaseComplementTempleVisitedDateMap;
  final Map<String, TempleModel> dateTempleMap;

  @override
  ConsumerState<TokyoJinjachouTempleListAlert> createState() => _TokyoJinjachouTempleListAlertState();
}

class _TokyoJinjachouTempleListAlertState extends ConsumerState<TokyoJinjachouTempleListAlert>
    with ControllersMixin<TokyoJinjachouTempleListAlert> {
  List<int> idList = <int>[];

  Map<String, List<TemplePhotoModel>> templePhotoTempleMap = <String, List<TemplePhotoModel>>{};

  Map<String, List<String>> templeVisitedDateMap = <String, List<String>>{};

  Map<String, TempleData> templeDataMap = <String, TempleData>{};

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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('東京神社庁', style: TextStyle(color: Colors.white)),
                SizedBox.shrink(),
              ],
            ),
            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
            Expanded(
              child: SizedBox(
                width: context.screenSize.width,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: context.screenSize.width * 0.3, child: displayTokyoJinjachouTempleList()),
                    Expanded(child: _displayTempleVisitedDateList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayTokyoJinjachouTempleList() {
    final List<Widget> list = <Widget>[];

    if (templePhotoState.templePhotoDateMap.value != null) {
      templePhotoTempleMap = templePhotoState.templePhotoTempleMap.value!;
    }

    final List<String> jogaiTempleNameList = <String>[];
    final List<String> jogaiTempleAddressList = <String>[];
    final List<String> jogaiTempleAddressList2 = <String>[];

    final Map<String, String> templeRankMap = <String, String>{};

    for (final TempleLatLngModel element in templeLatLngState.templeLatLngList) {
      jogaiTempleNameList.add(element.temple);
      jogaiTempleAddressList.add(element.address);
      jogaiTempleAddressList2.add('東京都${element.address}');

      templeRankMap[element.temple] = element.rank;
    }

    for (int i = 0; i < templeListState.templeListList.length; i++) {
      if (jogaiTempleNameList.contains(templeListState.templeListList[i].name)) {
        idList.add(templeListState.templeListList[i].id);
      }

      if (jogaiTempleAddressList.contains(templeListState.templeListList[i].address)) {
        idList.add(templeListState.templeListList[i].id);
      }

      if (jogaiTempleAddressList2.contains(templeListState.templeListList[i].address)) {
        idList.add(templeListState.templeListList[i].id);
      }

      if (jogaiTempleAddressList.contains('東京都${templeListState.templeListList[i].address}')) {
        idList.add(templeListState.templeListList[i].id);
      }

      if (jogaiTempleAddressList2.contains('東京都${templeListState.templeListList[i].address}')) {
        idList.add(templeListState.templeListList[i].id);
      }
    }

    idList = idList.toSet().toList();

    for (int i = 0; i < templeListState.templeListList.length; i++) {
      List<String> dateList = <String>[];
      if (idList.contains(templeListState.templeListList[i].id)) {
        if (widget.templeVisitDateMap[templeListState.templeListList[i].name] != null) {
          dateList = widget.templeVisitDateMap[templeListState.templeListList[i].name]!;
        } else {
          widget.idBaseComplementTempleVisitedDateMap[templeListState.templeListList[i].id.toString()]
              ?.forEach((DateTime element) => dateList.add(element.yyyymmdd));
        }
      }

      templeVisitedDateMap[templeListState.templeListList[i].name] = dateList;

      templeDataMap[templeListState.templeListList[i].name] = TempleData(
        name: templeListState.templeListList[i].name,
        address: templeListState.templeListList[i].address,
        latitude: templeListState.templeListList[i].lat,
        longitude: templeListState.templeListList[i].lng,
      );

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            color: (dateList.isNotEmpty) ? Colors.transparent : Colors.white.withValues(alpha: 0.1),
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(3),
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white, fontSize: 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: context.screenSize.height / 8),
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox.shrink(),
                      CircleAvatar(
                        backgroundColor: (idList.contains(templeListState.templeListList[i].id))
                            ? Colors.yellowAccent.withOpacity(0.1)
                            : Colors.white.withOpacity(0.1),
                        radius: 15,
                        child: Text(
                          templeListState.templeListList[i].id.toString(),
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                        ),
                      ),
                    ],
                  ),
                  Positioned(bottom: 5, right: 5, child: Text(dateList.length.toString())),
                  Positioned(
                    bottom: 5,
                    left: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.pinkAccent.withOpacity(0.3),
                      radius: 10,
                      child: Text(templeRankMap[templeListState.templeListList[i].name] ?? '-'),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(width: double.infinity),
                      Text(templeListState.templeListList[i].name)
                    ],
                  ),
                  Positioned(
                    bottom: 30,
                    right: 5,
                    child: GestureDetector(
                      onTap: () => appParamNotifier.setSelectedTokyoJinjachouTempleName(
                        name: templeListState.templeListList[i].name,
                      ),
                      child: Icon(
                        Icons.info,
                        color:
                            (appParamState.selectedTokyoJinjachouTempleName == templeListState.templeListList[i].name)
                                ? Colors.yellowAccent.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
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

  Widget _displayTempleVisitedDateList() {
    final List<Widget> list = <Widget>[];

    templeVisitedDateMap[appParamState.selectedTokyoJinjachouTempleName]?.forEach(
      (String element) {
        list.add(
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: 0.4))),
            child: Text(element, style: const TextStyle(color: Colors.white)),
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 100),
            child: (appParamState.selectedTokyoJinjachouTempleName != '')
                ? DefaultTextStyle(
                    style: const TextStyle(color: Colors.white),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(width: double.infinity),
                            Text(appParamState.selectedTokyoJinjachouTempleName),
                            Text(
                              (templeDataMap[appParamState.selectedTokyoJinjachouTempleName] != null)
                                  ? templeDataMap[appParamState.selectedTokyoJinjachouTempleName]!.address
                                  : '',
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 5,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              if (templeDataMap[appParamState.selectedTokyoJinjachouTempleName] != null) {
                                TempleDialog(
                                  context: context,
                                  widget: VisitedTemplePhotoListAlert(
                                    temple: templeDataMap[appParamState.selectedTokyoJinjachouTempleName]!,
                                    templePhotoTempleMap: templePhotoTempleMap,
                                  ),
                                  rotate: 0,
                                );
                              }
                            },
                            child: Icon(Icons.photo, color: Colors.white.withValues(alpha: 0.4)),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
          Divider(color: Colors.white.withOpacity(0.4), thickness: 2),
          Expanded(child: SingleChildScrollView(child: Column(children: list))),
        ],
      ),
    );
  }
}
