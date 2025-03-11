import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../_parts/_temple_dialog.dart';
import '../function.dart';
import 'temple_rank_input_alert.dart';

class TempleCourseDisplayAlert extends ConsumerStatefulWidget {
  const TempleCourseDisplayAlert({super.key, required this.data});

  final List<TempleData> data;

  @override
  ConsumerState<TempleCourseDisplayAlert> createState() => _TempleCourseDisplayAlertState();
}

class _TempleCourseDisplayAlertState extends ConsumerState<TempleCourseDisplayAlert>
    with ControllersMixin<TempleCourseDisplayAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(width: context.screenSize.width),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox.shrink(),
                    IconButton(
                      onPressed: () {
                        templeRankNotifier.clearTempleRankNameAndRank();

                        TempleDialog(
                          context: context,
                          widget: TempleRankInputAlert(data: widget.data),
                          paddingTop: context.screenSize.height * 0.4,
                          clearBarrierColor: true,
                        );
                      },
                      icon: Icon(
                        Icons.input,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: widget.data.map((TempleData e) => displayCourseData(data: e)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayCourseData({required TempleData data}) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            if (templeLatLngState.templeLatLngMap[data.name] != null) ...<Widget>[
              Positioned(
                right: 0,
                child: Text(
                  templeLatLngState.templeLatLngMap[data.name]!.rank,
                  style: TextStyle(fontSize: 30, color: Colors.white.withOpacity(0.4)),
                ),
              ),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: getCircleAvatarBgColor(element: data, ref: ref),
                  child: Text(
                    data.mark,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(data.name),
                    Text(data.address),
                  ],
                )),
              ],
            ),
          ],
        ),
        const Divider(color: Colors.white),
      ],
    );
  }
}
