import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/temple_model.dart';
import '../_parts/_temple_dialog.dart';
import 'visited_temple_photo_list_alert.dart';

class VisitedTempleListAlert extends ConsumerStatefulWidget {
  const VisitedTempleListAlert({super.key, required this.templeVisitDateMap, required this.dateTempleMap});

  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, TempleModel> dateTempleMap;

  @override
  ConsumerState<VisitedTempleListAlert> createState() => _VisitedTempleListAlertState();
}

class _VisitedTempleListAlertState extends ConsumerState<VisitedTempleListAlert>
    with ControllersMixin<VisitedTempleListAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Container(width: context.screenSize.width),
          displayTempleRankSelect(),
          Divider(
            color: Colors.white.withOpacity(0.3),
            thickness: 5,
          ),
          Expanded(child: displayVisitedTempleList()),
        ],
      )),
    );
  }

  ///
  Widget displayTempleRankSelect() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <String>['', 'S', 'A', 'B', 'C'].map((String e) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () => appParamNotifier.setVisitedTempleSelectedRank(rank: e),
                  child: CircleAvatar(
                    backgroundColor: (appParamState.visitedTempleSelectedRank == e)
                        ? Colors.yellowAccent.withOpacity(0.1)
                        : Colors.white.withOpacity(0.1),
                    child: Text(e, style: const TextStyle(color: Colors.black)),
                  ),
                ),
              );
            }).toList(),
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await templeRankNotifier.inputTempleRank(recordNum: templeLatLngState.templeLatLngList.length);

                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                child: const Text('input'),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget displayVisitedTempleList() {
    final List<Widget> list = <Widget>[];

    for (int i = 0; i < templeLatLngState.templeLatLngList.length; i++) {
      if (appParamState.visitedTempleSelectedRank != '') {
        if (templeLatLngState.templeLatLngList[i].rank != appParamState.visitedTempleSelectedRank) {
          continue;
        }
      }

      list.add(
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12, color: Colors.white),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 40, child: Text((i + 1).toString().padLeft(4, '0'))),
                IconButton(
                  onPressed: () {
                    TempleDialog(
                      context: context,
                      widget: VisitedTemplePhotoListAlert(
                        temple: TempleData(
                          name: templeLatLngState.templeLatLngList[i].temple,
                          address: templeLatLngState.templeLatLngList[i].address,
                          latitude: templeLatLngState.templeLatLngList[i].lat,
                          longitude: templeLatLngState.templeLatLngList[i].lng,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.info, color: Colors.white.withOpacity(0.3)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(templeLatLngState.templeLatLngList[i].temple),
                      Text(templeLatLngState.templeLatLngList[i].address),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(templeLatLngState.templeLatLngList[i].lat),
                                Text(templeLatLngState.templeLatLngList[i].lng),
                              ],
                            ),
                          ),
                          Row(
                            children: <String>['S', 'A', 'B', 'C'].map(
                              (String e) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () => templeRankNotifier.setTempleRankNameAndRank(
                                      pos: i,
                                      name: templeLatLngState.templeLatLngList[i].temple,
                                      rank: e,
                                    ),
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: (e == templeRankState.templeRankRankList[i])
                                          ? Colors.yellowAccent.withOpacity(0.2)
                                          : (e == templeLatLngState.templeLatLngList[i].rank)
                                              ? Colors.pinkAccent.withOpacity(0.2)
                                              : Colors.white.withOpacity(0.2),
                                      child: Text(e, style: const TextStyle(color: Colors.black, fontSize: 12)),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
}
