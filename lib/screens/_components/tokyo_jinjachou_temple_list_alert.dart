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

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Expanded(child: _displayTokyoJinjachouTempleList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayTokyoJinjachouTempleList() {
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

      list.add(
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: (idList.contains(templeListState.templeListList[i].id))
                        ? Colors.yellowAccent.withOpacity(0.2)
                        : Colors.white.withOpacity(0.2),
                    radius: 15,
                    child: Text(templeListState.templeListList[i].id.toString(),
                        style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  Text(dateList.length.toString(), style: const TextStyle(color: Colors.white)),
                  Text(templeRankMap[templeListState.templeListList[i].name] ?? '-'),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(templeListState.templeListList[i].name),
                    Text(templeListState.templeListList[i].address),
                    const SizedBox(height: 5),
                    if (dateList.isEmpty) ...<Widget>[
                      const Padding(padding: EdgeInsets.all(10), child: Text('not visit')),
                    ],
                    if (dateList.isNotEmpty) ...<Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                            children: dateList.map((String e) {
                          return Container(
                            margin: const EdgeInsets.all(3),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.3))),
                            child: Text(e),
                          );
                        }).toList()),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                  onTap: () {
                    TempleDialog(
                      context: context,
                      widget: VisitedTemplePhotoListAlert(
                        temple: TempleData(
                          name: templeListState.templeListList[i].name,
                          address: templeListState.templeListList[i].address,
                          latitude: templeListState.templeListList[i].lat,
                          longitude: templeListState.templeListList[i].lng,
                        ),
                        templePhotoTempleMap: templePhotoTempleMap,
                      ),
                      rotate: 0,
                    );
                  },
                  child: const Icon(Icons.call_made, color: Colors.white)),
            ],
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
}
