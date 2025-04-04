// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controllers/routing/routing.dart';
import '../../extensions/extensions.dart';
import '../_parts/_temple_dialog.dart';
import 'route_display_alert.dart';

class RouteDisplaySettingAlert extends ConsumerWidget {
  RouteDisplaySettingAlert({super.key});

  DateTime selectedDateTime = DateTime.now();

  final TextEditingController speedTextController = TextEditingController();
  final TextEditingController spotStayTimeTextController =
      TextEditingController();
  final TextEditingController adjustPercentTextController =
      TextEditingController();

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RoutingState routingState = ref.watch(routingProvider);

    final DateFormat timeFormat = DateFormat('HH:mm');
    final String startTime = (routingState.startTime != '')
        ? timeFormat.format(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            routingState.startTime.split(' ')[1].split(':')[0].toInt(),
            routingState.startTime.split(' ')[1].split(':')[1].toInt()))
        : timeFormat.format(selectedDateTime);

    speedTextController.text = routingState.walkSpeed.toString();
    spotStayTimeTextController.text = routingState.spotStayTime.toString();
    adjustPercentTextController.text = routingState.adjustPercent.toString();

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
              children: <Widget>[
                const SizedBox(height: 20),
                Container(width: context.screenSize.width),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Row(
                        children: <Widget>[
                          const Text('出発時刻：'),
                          if (routingState.startNow) const Text('(現在時刻)'),
                          Text(startTime),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () async {
                          final TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.dark(
                                          primary: Colors.blueGrey)
                                      .copyWith(
                                    background: Colors.black.withOpacity(0.2),
                                  ),
                                ),
                                child: MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                ),
                              );
                            },
                          );

                          if (selectedTime != null) {
                            final String time =
                                '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                            ref.read(routingProvider.notifier).setSelectTime(
                                time: '${DateTime.now().yyyymmdd} $time');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '出発時刻を\n変更する',
                            style: TextStyle(fontSize: 8, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Colors.white.withOpacity(0.2),
                  thickness: 2,
                ),
                Row(
                  children: <Widget>[
                    const Expanded(
                      flex: 7,
                      child: Text('歩く速度（時速）：'),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+(\.\d*)?')),
                        ],
                        controller: speedTextController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        onTapOutside: (PointerDownEvent event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          Text('Km'),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white.withOpacity(0.2),
                  thickness: 2,
                ),
                Row(
                  children: <Widget>[
                    const Expanded(
                      flex: 7,
                      child: Text('施設滞在時間：'),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+(\.\d*)?')),
                        ],
                        controller: spotStayTimeTextController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        onTapOutside: (PointerDownEvent event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          Text('分'),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white.withOpacity(0.2),
                  thickness: 2,
                ),
                Row(
                  children: <Widget>[
                    const Expanded(
                      flex: 7,
                      child: Text('調整率：'),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+(\.\d*)?')),
                        ],
                        controller: adjustPercentTextController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        onTapOutside: (PointerDownEvent event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          Text('%'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    if (routingState.startNow) {
                      ref
                          .watch(routingProvider.notifier)
                          .setSelectTime(time: selectedDateTime.toString());
                    }

                    ref
                        .watch(routingProvider.notifier)
                        .setWalkSpeed(speed: speedTextController.text.toInt());

                    ref.watch(routingProvider.notifier).setSpotStayTime(
                        time: spotStayTimeTextController.text.toInt());

                    ref.watch(routingProvider.notifier).setAdjustPercent(
                        adjust: adjustPercentTextController.text.toInt());

                    TempleDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      widget: const RouteDisplayAlert(),
                      rotate: 0,
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '設定結果を確認する',
                      style: TextStyle(fontSize: 8, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
