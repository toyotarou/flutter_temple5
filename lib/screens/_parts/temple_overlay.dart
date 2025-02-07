import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/app_params/app_params_response_state.dart';
import '../../controllers/temple/temple.dart';

//=======================================================//

class DraggableOverlayItem {
  DraggableOverlayItem({required this.position, required this.width, required this.height, required this.color});

  late OverlayEntry entry;

  Offset position;

  final double width;
  final double height;

  final Color color;
}

//=======================================================//

OverlayEntry createDraggableOverlayEntry({
  required BuildContext context,
  required Offset initialOffset,
  required double width,
  required double height,
  required Color color,
  required VoidCallback onRemove,
  required Widget widget,
  required ValueChanged<Offset> onPositionChanged,
  bool? fixedFlag,
}) {
  final Size screenSize = MediaQuery.of(context).size;

  final DraggableOverlayItem item =
      DraggableOverlayItem(position: initialOffset, width: width, height: height, color: color);

  final OverlayEntry entry = OverlayEntry(
    builder: (BuildContext context) {
      return Positioned(
        left: item.position.dx,
        top: item.position.dy,
        child: Material(
          elevation: 8,
          color: item.color,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: item.width,
            height: item.height,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  height: 40,
                  width: double.infinity,
                  child: Listener(
                    // ignore: use_if_null_to_convert_nulls_to_bools
                    onPointerMove: (fixedFlag == true)
                        ? null
                        : (PointerMoveEvent event) {
                            if (event.buttons == 1) {
                              item.position += event.delta;

                              final double maxX = screenSize.width - item.width;
                              final double maxY = screenSize.height - item.height;
                              final num clampedX = item.position.dx.clamp(0, maxX);
                              final num clampedY = item.position.dy.clamp(0, maxY);

                              item.position =
                                  Offset(double.parse(clampedX.toString()), double.parse(clampedY.toString()));

                              onPositionChanged(item.position);

                              item.entry.markNeedsBuild();
                            }
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // ignore: use_if_null_to_convert_nulls_to_bools
                        if (fixedFlag == true)
                          const Icon(Icons.check_box_outline_blank, color: Colors.transparent)
                        else
                          const Icon(Icons.drag_indicator, color: Colors.white),
                        const Expanded(child: Text('')),
                        IconButton(onPressed: onRemove, icon: const Icon(Icons.close, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(width: double.infinity),
                        widget,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  item.entry = entry;
  return entry;
}

//=======================================================//

///
void addFirstOverlay({
  required BuildContext context,
  required List<OverlayEntry> firstEntries,
  required List<OverlayEntry> secondEntries,
  required void Function(VoidCallback fn) setStateCallback,
  required double width,
  required double height,
  required Color color,
  required Offset initialPosition,
  required Widget widget,
  required ValueChanged<Offset> onPositionChanged,
  bool? fixedFlag,
  WidgetRef? ref,
  String? from,
}) {
  if (firstEntries.isNotEmpty) {
    for (final OverlayEntry e in firstEntries) {
      e.remove();
    }
    setStateCallback(() => firstEntries.clear());
  }

  late OverlayEntry entry;
  entry = createDraggableOverlayEntry(
    context: context,
    initialOffset: initialPosition,
    width: width,
    height: height,
    color: color,
    onRemove: () {
      if (from == 'NotReachTempleMapAlert') {
        if (ref != null) {
          ref.read(templeProvider.notifier).setSelectTemple(name: '', lat: '', lng: '');
        }
      }

      if (from == 'VisitedTempleMapAlert') {
        if (ref != null) {
          ref.read(templeProvider.notifier).setSelectTemple(name: '', lat: '', lng: '');
        }
      }

      entry.remove();
      setStateCallback(() => firstEntries.remove(entry));
    },
    widget: widget,
    onPositionChanged: onPositionChanged,
    fixedFlag: fixedFlag,
  );

  setStateCallback(() => firstEntries.add(entry));

  final OverlayState overlayState = Overlay.of(context);

  if (secondEntries.isNotEmpty) {
    overlayState.insert(entry, above: secondEntries.last);
  } else {
    overlayState.insert(entry);
  }
}

//=======================================================//

///
void addSecondOverlay({
  required BuildContext context,
  required List<OverlayEntry> secondEntries,
  required void Function(VoidCallback fn) setStateCallback,
  required double width,
  required double height,
  required Color color,
  required Offset initialPosition,
  required Widget widget,
  required ValueChanged<Offset> onPositionChanged,
  bool? fixedFlag,
}) {
  if (secondEntries.isNotEmpty) {
    for (final OverlayEntry e in secondEntries) {
      e.remove();
    }
    setStateCallback(() => secondEntries.clear());
  }

  late OverlayEntry entry;
  entry = createDraggableOverlayEntry(
    context: context,
    initialOffset: initialPosition,
    width: width,
    height: height,
    color: color,
    onRemove: () {
      entry.remove();
      setStateCallback(() => secondEntries.remove(entry));
    },
    widget: widget,
    onPositionChanged: onPositionChanged,
    fixedFlag: fixedFlag,
  );

  setStateCallback(() => secondEntries.add(entry));
  Overlay.of(context).insert(entry);
}

///
void closeAllOverlays({required WidgetRef ref}) {
  final List<OverlayEntry>? firstEntries =
      ref.watch(appParamProvider.select((AppParamsResponseState value) => value.firstEntries));

  if (firstEntries != null) {
    for (final OverlayEntry e in firstEntries) {
      e.remove();
    }
  }

  final List<OverlayEntry>? secondEntries =
      ref.watch(appParamProvider.select((AppParamsResponseState value) => value.secondEntries));

  if (secondEntries != null) {
    for (final OverlayEntry e2 in secondEntries) {
      e2.remove();
    }
  }
}
