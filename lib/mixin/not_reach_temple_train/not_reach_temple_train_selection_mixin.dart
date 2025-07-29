import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/extensions.dart';
import '../../../models/tokyo_train_model.dart';
import '../../controllers/app_param/app_param.dart';
import '../../screens/_parts/_caution_dialog.dart';

/// mixinを定義して、共通処理をまとめる
mixin NotReachTempleTrainSelectionMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// 電車選択部分（リスト＋操作ボタン）をビルドするメソッド
  Widget buildNotReachTempleTrainSelectParts(List<TokyoTrainModel> tokyoTrainList, VoidCallback setDefaultBoundsMap) {
    var appParamState = ref.watch(appParamProvider);

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: context.screenSize.height * 0.18, child: buildNotReachTempleTrainSelectList(tokyoTrainList)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    onPressed: () {
                      if (appParamState.selectTrainList.isEmpty) {
                        caution_dialog(context: context, content: 'must select train');
                        return;
                      }
                      setDefaultBoundsMap();
                    },
                    child: const Text('map fit'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    onPressed: () => ref.read(appParamProvider.notifier).clearTrainList(),
                    child: const Text('clear select'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    onPressed: setDefaultBoundsMap,
                    child: const Text('default range'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 電車リスト（チェックボックス付き）のウィジェットをビルドするメソッド
  Widget buildNotReachTempleTrainSelectList(List<TokyoTrainModel> tokyoTrainList) {
    var appParamState = ref.watch(appParamProvider);

    return SingleChildScrollView(
      child: Column(
        children: tokyoTrainList.map(
          (TokyoTrainModel element) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Checkbox(
                  activeColor: Colors.greenAccent,
                  value: appParamState.selectTrainList.contains(element.trainNumber),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(vertical: -2),
                  onChanged: (bool? value) {
                    if (!appParamState.selectTrainList.contains(element.trainNumber)) {
                      if (appParamState.selectTrainList.isNotEmpty) {
                        caution_dialog(context: context, content: 'cant select train');
                        return;
                      }
                    }
                    ref.read(appParamProvider.notifier).setTrainList(trainNumber: element.trainNumber);
                  },
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(element.trainName, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
