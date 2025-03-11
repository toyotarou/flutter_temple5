import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_list_model.dart';

class NeedleCompassMapAlert extends ConsumerStatefulWidget {
  const NeedleCompassMapAlert({super.key});

  @override
  ConsumerState<NeedleCompassMapAlert> createState() => _NeedleCompassMapAlertState();
}

class _NeedleCompassMapAlertState extends ConsumerState<NeedleCompassMapAlert>
    with ControllersMixin<NeedleCompassMapAlert>, SingleTickerProviderStateMixin {
  final MapController mapController = MapController();

  double currentZoomEightTeen = 13;

  List<Marker> markerList = <Marker>[];

  late AnimationController _controller;

  late Animation<double> _animation;

  double _currentPointerAngle = 0.0;

  double? finalPointerAngleDegrees;

  final MapController _mapController = MapController();
  double _currentZoom = 16.0;

  final LatLng _tokyoStation = const LatLng(35.718532, 139.586639);

  bool markerDisp = false;

  double _needleFactor = 0.8;

  ///
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(_controller);

    _animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        double compassAngle = _animation.value % (2 * pi);
        if (compassAngle < 0) {
          compassAngle += 2 * pi;
        }

        setState(() => finalPointerAngleDegrees = compassAngle * 180 / pi);
      }
    });
  }

  ///
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///
  void _spinPointer() {
    final Random random = Random();

    final double randomTurns = random.nextDouble() * 3 + 2;

    final double newAngle = _currentPointerAngle + (2 * pi * randomTurns);

    _animation = Tween<double>(begin: _currentPointerAngle, end: newAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    setState(() => finalPointerAngleDegrees = null);

    _controller.reset();

    _controller.forward();

    _currentPointerAngle = newAngle;
  }

  ///
  void _zoomIn() => setState(() {
        _currentZoom += 1;
        _mapController.move(_tokyoStation, _currentZoom);
      });

  ///
  void _zoomOut() => setState(() {
        _currentZoom -= 1;
        _mapController.move(_tokyoStation, _currentZoom);
      });

  ///
  @override
  Widget build(BuildContext context) {
    makeMarker();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _tokyoStation,
              initialZoom: _currentZoom,
              onPositionChanged: (MapCamera position, bool isMoving) {
                if (isMoving) {
                  _mapController.rotate(0);
                }
              },
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.myapp',
              ),
              MarkerLayer(
                markers: <Marker>[
                  Marker(
                    point: _tokyoStation,
                    width: 200,
                    height: 200,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, Widget? child) =>
                          Transform.rotate(angle: _animation.value, child: child),
                      child: CustomPaint(painter: PointerPainter(needleFactor: _needleFactor)),
                    ),
                  ),
                ],
              ),
              if (markerDisp) MarkerLayer(markers: markerList),
            ],
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: finalPointerAngleDegrees == null
                  ? Container()
                  : Text(
                      '針先の向き: ${finalPointerAngleDegrees!.toStringAsFixed(2)}° (${getCompassDirection(finalPointerAngleDegrees!)})',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        backgroundColor: Colors.white70,
                      ),
                    ),
            ),
          ),
          Positioned(
            bottom: 90,
            left: 10,
            child: Column(
              children: <Widget>[
                FloatingActionButton(onPressed: _zoomIn, mini: true, child: const Icon(Icons.add)),
                const SizedBox(height: 10),
                FloatingActionButton(onPressed: _zoomOut, mini: true, child: const Icon(Icons.remove)),
              ],
            ),
          ),
          Positioned(
            bottom: 90,
            right: 10,
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _increaseNeedle,
                  mini: true,
                  backgroundColor: Colors.green,
                  tooltip: '針を長くする',
                  child: const Icon(Icons.arrow_upward),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _decreaseNeedle,
                  mini: true,
                  backgroundColor: Colors.orange,
                  tooltip: '針を短くする',
                  child: const Icon(Icons.arrow_downward),
                ),
              ],
            ),
          ),
          Positioned(
            top: 150,
            left: 30,
            child: IconButton(
                onPressed: () => setState(() => markerDisp = !markerDisp),
                icon: const Icon(Icons.ac_unit)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _spinPointer, child: const Icon(Icons.refresh)),
    );
  }

  ///
  void _increaseNeedle() => setState(() => _needleFactor += 0.5);

  ///
  void _decreaseNeedle() => setState(() => _needleFactor = max(0.5, _needleFactor - 0.5));

  ///
  void makeMarker() {
    for (final TempleListModel element in templeListState.templeListList) {
      markerList.add(
        Marker(
          point: LatLng(element.lat.toDouble(), element.lng.toDouble()),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {},
            child: CircleAvatar(backgroundColor: Colors.pinkAccent.withOpacity(0.1)),
          ),
        ),
      );
    }
  }
}

///
String getCompassDirection(double degrees) {
  const List<String> directions = <String>[
    '北',
    '北北東',
    '北東',
    '東北東',
    '東',
    '東南東',
    '南東',
    '南南東',
    '南',
    '南南西',
    '南西',
    '西南西',
    '西',
    '西北西',
    '北西',
    '北北西'
  ];

  final int index = (((degrees + 11.25) % 360) / 22.5).floor() % 16;

  return directions[index];
}

///
class PointerPainter extends CustomPainter {
  const PointerPainter({required this.needleFactor});

  final double needleFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double needleLength = size.width * needleFactor;
    final Offset needleEnd = Offset(center.dx, center.dy - needleLength);
    final Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleEnd, paint);
    canvas.drawCircle(center, 6.0, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant PointerPainter oldDelegate) => oldDelegate.needleFactor != needleFactor;
}
