import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../function.dart';

class TempleRankInputAlert extends ConsumerStatefulWidget {
  const TempleRankInputAlert({super.key, required this.data});

  final List<TempleData> data;

  @override
  ConsumerState<TempleRankInputAlert> createState() => _TempleRankInputAlertState();
}

class _TempleRankInputAlertState extends ConsumerState<TempleRankInputAlert>
    with ControllersMixin<TempleRankInputAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: () async {
                    await templeRankNotifier.inputTempleRank(recordNum: widget.data.length);

                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                  child: const Text('input'),
                ),
              ],
            ),
            Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
            Expanded(child: displayTempleRankSettingList()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayTempleRankSettingList() {
    final List<Widget> list = <Widget>[];

    for (final TempleData element in widget.data) {
      if (int.tryParse(element.mark) != null) {
        list.add(Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: getCircleAvatarBgColor(element: element, ref: ref),
                child: Text(element.mark, style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(element.name),
                      Text(element.address),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),
                          Row(
                            children: <String>['S', 'A', 'B', 'C'].map(
                              (String e) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () => templeRankNotifier.setTempleRankNameAndRank(
                                        pos: element.mark.toInt(), name: element.name, rank: e),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: (templeRankState.templeRankRankList[element.mark.toInt()] == e)
                                          ? Colors.yellowAccent.withOpacity(0.3)
                                          : Colors.white.withOpacity(0.3),
                                      child: Text(e, style: const TextStyle(color: Colors.black)),
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
              ),
            ],
          ),
        ));
      }
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
