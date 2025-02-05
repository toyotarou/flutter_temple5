// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../controllers/tokyo_train/tokyo_train.dart';
// import '../../extensions/extensions.dart';
// import '../../models/tokyo_train_model.dart';
// import '_caution_dialog.dart';
//
// ///
// Widget notReachTempleTrainSelectParts(
//     {required List<TokyoTrainModel> tokyoTrainList,
//     required BuildContext context,
//     required WidgetRef ref,
//     required VoidCallback setDefaultBoundsMap}) {
//   final TokyoTrainState tokyoTrainState = ref.watch(tokyoTrainProvider);
//
//   return DefaultTextStyle(
//     style: const TextStyle(fontSize: 12),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         SizedBox(
//           height: context.screenSize.height * 0.18,
//           child: displayNotReachTempleTrainSelectList(tokyoTrainList: tokyoTrainList, context: context, ref: ref),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Container(),
//             Row(
//               children: <Widget>[
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
//                   onPressed: () {
//                     if (tokyoTrainState.selectTrainList.isEmpty) {
//                       caution_dialog(context: context, content: 'must select train');
//
//                       return;
//                     }
//
//                     setDefaultBoundsMap();
//                   },
//                   child: const Text('map fit'),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
//                   onPressed: () => ref.read(tokyoTrainProvider.notifier).clearTrainList(),
//                   child: const Text('clear select'),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
//                   onPressed: () => setDefaultBoundsMap(),
//                   child: const Text('default range'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// ///
// Widget displayNotReachTempleTrainSelectList(
//     {required List<TokyoTrainModel> tokyoTrainList, required BuildContext context, required WidgetRef ref}) {
//   final TokyoTrainState tokyoTrainState = ref.watch(tokyoTrainProvider);
//
//   return SingleChildScrollView(
//     child: Column(
//       children: tokyoTrainList.map(
//         (TokyoTrainModel element) {
//           return Row(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Checkbox(
//                 activeColor: Colors.greenAccent,
//                 value: tokyoTrainState.selectTrainList.contains(element.trainNumber),
//                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 visualDensity: const VisualDensity(vertical: -2),
//                 onChanged: (bool? value) {
//                   if (!tokyoTrainState.selectTrainList.contains(element.trainNumber)) {
//                     if (tokyoTrainState.selectTrainList.isNotEmpty) {
//                       caution_dialog(context: context, content: 'cant select train');
//
//                       return;
//                     }
//                   }
//
//                   ref.read(tokyoTrainProvider.notifier).setTrainList(trainNumber: element.trainNumber);
//                 },
//               ),
//               const SizedBox(width: 4), // 自由にスペースを指定
//               Expanded(child: Text(element.trainName, style: const TextStyle(color: Colors.white, fontSize: 12))),
//             ],
//           );
//         },
//       ).toList(),
//     ),
//   );
// }
