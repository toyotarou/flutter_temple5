import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_model.dart';

class SameDateVisitedTempleListAlert extends ConsumerStatefulWidget {
  const SameDateVisitedTempleListAlert({super.key});

  @override
  ConsumerState<SameDateVisitedTempleListAlert> createState() => _SameDateVisitedTempleListAlertState();
}

class _SameDateVisitedTempleListAlertState extends ConsumerState<SameDateVisitedTempleListAlert>
    with ControllersMixin<SameDateVisitedTempleListAlert> {
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
                Text('SameDateVisitedTempleListAlert', style: TextStyle(color: Colors.white)),
                SizedBox.shrink(),
              ],
            ),
            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
            Expanded(child: _displaySameDateVisitedTempleList()),
          ],
        ),
      ),
    );
  }

  ///
  Widget _displaySameDateVisitedTempleList() {
    final List<Widget> list = <Widget>[];

    final int roopNum = DateTime(2025).difference(DateTime(2024)).inDays;

    for (int i = 0; i < roopNum; i++) {
      final DateTime listDate = DateTime(2024).add(Duration(days: i));

      final List<Widget> list2 = <Widget>[];
      templeState.dateTempleMap.forEach(
        (String key, TempleModel value) {
          if ('${key.split('-')[1]}-${key.split('-')[2]}' == listDate.mmdd) {
            list2.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(value.temple),
                  Text(value.date.yyyy),
                ],
              ),
            );

            if (value.memo != '') {
              final List<String> exMemo = value.memo.split('、');
              for (final String element in exMemo) {
                list2.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(element),
                    Text(value.date.yyyy),
                  ],
                ));
              }
            }
          }
        },
      );

      list.add(
        DefaultTextStyle(
          style: const TextStyle(color: Colors.white, fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: (list2.isNotEmpty)
                      ? Colors.yellowAccent.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.1),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(listDate.mmdd), const SizedBox.shrink()],
                ),
              ),
              Column(children: list2.map((Widget e) => e).toList()),
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
