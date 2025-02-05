import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/tokyo_train_model.dart';
import 'not_reach_temple_train_selection_mixin.dart';

/// mixin を利用したウィジェットクラスの例
class NotReachTempleTrainSelectWidget extends ConsumerStatefulWidget {
  const NotReachTempleTrainSelectWidget({required this.tokyoTrainList, required this.setDefaultBoundsMap, super.key});

  final List<TokyoTrainModel> tokyoTrainList;
  final VoidCallback setDefaultBoundsMap;

  @override
  // ignore: library_private_types_in_public_api
  _TrainSelectWidgetState createState() => _TrainSelectWidgetState();
}

class _TrainSelectWidgetState extends ConsumerState<NotReachTempleTrainSelectWidget>
    with
        // ignore: always_specify_types
        NotReachTempleTrainSelectionMixin {
  @override
  Widget build(BuildContext context) {
    // mixin 内のメソッドを利用してウィジェット全体を構築
    return buildNotReachTempleTrainSelectParts(widget.tokyoTrainList, widget.setDefaultBoundsMap);
  }
}
