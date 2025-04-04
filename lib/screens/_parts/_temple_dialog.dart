// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/temple_lat_lng/temple_lat_lng.dart';
import 'temple_overlay.dart';

Future<void> TempleDialog({
  required BuildContext context,
  required Widget widget,
  double paddingTop = 0,
  double paddingRight = 0,
  double paddingBottom = 0,
  double paddingLeft = 0,
  bool clearBarrierColor = false,
  bool? executeFunctionWhenDialogClose,
  WidgetRef? ref,
  String? from,
  required int rotate,
}) {
  // ignore: inference_failure_on_function_invocation
  return showDialog(
    context: context,
    barrierColor: clearBarrierColor ? Colors.transparent : Colors.blueGrey.withOpacity(0.3),
    builder: (_) {
      return Container(
        padding: EdgeInsets.only(top: paddingTop, right: paddingRight, bottom: paddingBottom, left: paddingLeft),
        child: Dialog(
          backgroundColor: Colors.blueGrey.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          insetPadding: const EdgeInsets.all(30),
          child: RotatedBox(quarterTurns: rotate, child: widget),
        ),
      );
    },
    // ignore: always_specify_types
  ).then((value) {
    // ignore: use_if_null_to_convert_nulls_to_bools
    if (executeFunctionWhenDialogClose == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //-------------------------//
        final ModalRoute<Object?>? route = ModalRoute.of(context);
        if (route != null && route.isCurrent) {
          closeAllOverlays(ref: ref!);
        }

        //-------------------------//

        if (from == 'RouteTrainStationListAlert') {
          if (ref != null) {
            ref.read(appParamProvider.notifier).setHomeTextFormFieldVisible(flag: true);

            ref.read(appParamProvider.notifier).setNotReachTempleNearStationName(name: '');
          }
        }

        if (from == 'TempleRankInputAlert' || from == 'VisitedTempleListAlert') {
          if (ref != null) {
            ref.read(templeLatLngProvider.notifier).getAllTempleLatLng();
          }
        }
      });
    }
  });
}
