// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../controllers/lat_lng_temple/lat_lng_temple.dart';
// import '../../controllers/near_station/near_station.dart';
// import '../../controllers/routing/routing.dart';
// import '../../controllers/tokyo_train/tokyo_train.dart';
// import '../../extensions/extensions.dart';
// import '../../models/common/temple_data.dart';
// import '../../models/near_station_model.dart';
// import '../../models/temple_model.dart';
// import '../../models/tokyo_station_model.dart';
// import '../../models/tokyo_train_model.dart';
// import '../_parts/_temple_dialog.dart';
// import '../function.dart';
// import 'visited_temple_photo_alert.dart';
//
// class TempleInfoDisplayAlert extends ConsumerStatefulWidget {
//   const TempleInfoDisplayAlert({
//     super.key,
//     required this.temple,
//     required this.from,
//     this.station,
//     required this.templeVisitDateMap,
//     required this.dateTempleMap,
//     required this.tokyoTrainList,
//   });
//
//   final TempleData temple;
//   final String from;
//   final TokyoStationModel? station;
//   final Map<String, List<String>> templeVisitDateMap;
//   final Map<String, TempleModel> dateTempleMap;
//   final List<TokyoTrainModel> tokyoTrainList;
//
//   @override
//   ConsumerState<TempleInfoDisplayAlert> createState() =>
//       _TempleInfoDisplayAlertState();
// }
//
// class _TempleInfoDisplayAlertState
//     extends ConsumerState<TempleInfoDisplayAlert> {
//   ///
//   @override
//   Widget build(BuildContext context) {
//     final NearStationResponseStationModel? selectedNearStation = ref.watch(
//         latLngTempleProvider
//             .select((LatLngTempleState value) => value.selectedNearStation));
//
//     return AlertDialog(
//       titlePadding: EdgeInsets.zero,
//       contentPadding: EdgeInsets.zero,
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.zero,
//       content: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         width: double.infinity,
//         height: double.infinity,
//         child: DefaultTextStyle(
//           style: const TextStyle(fontSize: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               const SizedBox(height: 20),
//               displayTempleInfo(),
//               displayAddRemoveRoutingButton(),
//               const SizedBox(height: 10),
//               displayNearStation(),
//               GestureDetector(
//                 onTap: (selectedNearStation != null)
//                     ? () {
//                         ref.read(tokyoTrainProvider.notifier).clearTrainList();
//
//                         for (final TokyoTrainModel element
//                             in widget.tokyoTrainList) {
//                           if (element.trainName == selectedNearStation.line) {
//                             ref
//                                 .read(tokyoTrainProvider.notifier)
//                                 .setTrainList(trainNumber: element.trainNumber);
//                           }
//                         }
//                       }
//                     : null,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
//                   child: Text(
//                     (selectedNearStation != null)
//                         ? selectedNearStation.line
//                         : '',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///
//   Widget displayAddRemoveRoutingButton() {
//     if (widget.from != 'LatLngTempleMapAlert') {
//       return Container();
//     }
//
//     final List<TempleData> routingTempleDataList = ref.watch(routingProvider
//         .select((RoutingState value) => value.routingTempleDataList));
//
//     final int pos = routingTempleDataList
//         .indexWhere((TempleData element) => element.mark == widget.temple.mark);
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Container(),
//         ElevatedButton(
//           onPressed: () {
//             ref
//                 .read(routingProvider.notifier)
//                 .setRouting(templeData: widget.temple, station: widget.station);
//           },
//           style: ElevatedButton.styleFrom(
//               backgroundColor: (pos != -1)
//                   ? Colors.white.withOpacity(0.2)
//                   : Colors.indigo.withOpacity(0.2)),
//           child: Text((pos != -1) ? 'remove routing' : 'add routing'),
//         ),
//       ],
//     );
//   }
//
//   ///
//   Widget displayTempleInfo() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         displayTempleInfoCircleAvatar(),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(width: context.screenSize.width),
//               Text(widget.temple.name),
//               Text(widget.temple.address),
//               Text(widget.temple.latitude),
//               Text(widget.temple.longitude),
//               const SizedBox(height: 10),
//               displayTempleVisitDate(),
//             ],
//           ),
//         ),
//         displayVisitedTemplePhoto(),
//       ],
//     );
//   }
//
//   ///
//   Widget displayVisitedTemplePhoto() {
//     if (widget.from != 'VisitedTempleMapAlert') {
//       return Row(
//         children: <Widget>[Container(), const SizedBox(width: 20)],
//       );
//     }
//
//     return GestureDetector(
//       onTap: () {
//         TempleDialog(
//           context: context,
//           widget: VisitedTemplePhotoAlert(
//             templeVisitDateMap: widget.templeVisitDateMap,
//             temple: widget.temple,
//             dateTempleMap: widget.dateTempleMap,
//           ),
//           paddingTop: context.screenSize.height * 0.1,
//           paddingLeft: context.screenSize.width * 0.2,
//         );
//       },
//       child: const Icon(Icons.photo, color: Colors.white),
//     );
//   }
//
//   ///
//   Widget displayTempleInfoCircleAvatar() {
//     if (widget.from == 'VisitedTempleMapAlert') {
//       return Row(
//         children: <Widget>[Container(), const SizedBox(width: 20)],
//       );
//     }
//
//     return Row(
//       children: <Widget>[
//         CircleAvatar(
//           backgroundColor:
//               getCircleAvatarBgColor(element: widget.temple, ref: ref),
//           child: Text(
//             widget.temple.mark.padLeft(2, '0'),
//             style: const TextStyle(color: Colors.white),
//           ),
//         ),
//         const SizedBox(width: 20),
//       ],
//     );
//   }
//
//   ///
//   Widget displayTempleVisitDate() {
//     if (widget.from != 'VisitedTempleMapAlert') {
//       return Container();
//     }
//
//     return SizedBox(
//       height: 80,
//       width: double.infinity,
//       child: Scrollbar(
//         thumbVisibility: true,
//         child: SingleChildScrollView(
//           child: Wrap(
//             children:
//                 widget.templeVisitDateMap[widget.temple.name]!.map((String e) {
//               return Container(
//                 width: context.screenSize.width / 5,
//                 padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
//                 margin: const EdgeInsets.all(1),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white.withOpacity(0.2)),
//                 ),
//                 child: Text(e, style: const TextStyle(fontSize: 12)),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///
//   Widget displayNearStation() {
//     if (widget.from == 'LatLngTempleMapAlert' ||
//         widget.from == 'NotReachTempleMapAlert') {
//       final NearStationResponseStationModel? selectedNearStation = ref.watch(
//           latLngTempleProvider
//               .select((LatLngTempleState value) => value.selectedNearStation));
//       //===================================//
//
//       return ref
//           .watch(
//             nearStationProvider(
//               latitude: widget.temple.latitude,
//               longitude: widget.temple.longitude,
//             ),
//           )
//           .when(
//             data: (NearStationState value) {
//               final List<NearStationResponseStationModel> nsList =
//                   // ignore: always_specify_types
//                   List.of(value.nearStationList);
//
//               nsList.sort((NearStationResponseStationModel a,
//                       NearStationResponseStationModel b) =>
//                   a.name.compareTo(b.name));
//
//               return SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                     children: nsList.map((NearStationResponseStationModel e) {
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 10, bottom: 5),
//                     child: GestureDetector(
//                       onTap: () {
//                         ref
//                             .read(latLngTempleProvider.notifier)
//                             .setSelectedNearStation(station: e);
//                       },
//                       child: CircleAvatar(
//                         backgroundColor: (selectedNearStation != null &&
//                                 e.name == selectedNearStation.name)
//                             ? Colors.brown.withOpacity(0.8)
//                             : Colors.brown.withOpacity(0.4),
//                         child:
//                             Text(e.name, style: const TextStyle(fontSize: 10)),
//                       ),
//                     ),
//                   );
//                 }).toList()),
//               );
//             },
//             error: (Object error, StackTrace stackTrace) =>
//                 const Center(child: CircularProgressIndicator()),
//             loading: () => const Center(child: CircularProgressIndicator()),
//           );
//     } else {
//       return Container();
//     }
//   }
// }
