import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_lat_lng_model.dart';
import '../_parts/_temple_dialog.dart';
import 'needle_compass_selected_list_alert.dart';

class NeedleCompassMapAlert extends ConsumerStatefulWidget {
  const NeedleCompassMapAlert({super.key});

  @override
  ConsumerState<NeedleCompassMapAlert> createState() => _NeedleCompassMapAlertState();
}

class _NeedleCompassMapAlertState extends ConsumerState<NeedleCompassMapAlert>
    with SingleTickerProviderStateMixin, ControllersMixin<NeedleCompassMapAlert> {
  final GlobalKey _mapKey = GlobalKey();

  late AnimationController _controller;

  late Animation<double> _animation;

  double _currentPointerAngle = 0.0;

  double? finalPointerAngleDegrees;

  final double _needleFactor = 2;

  final bool _showRectangle = true;

  final double _tolerance = 0.000001;

  final double _selectionMargin = 0.000000;

  final MapController _mapController = MapController();

  final double _currentZoom = 10.0;

  // 中心座標
  final LatLng _centerCoord = const LatLng(zenpukujiLat, zenpukujiLng);

  final List<LatLng> _additionalMarkers = <LatLng>[];

  Set<LatLng> _insideMarkers = <LatLng>{};

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
  void spinNeedle() {
    setState(() => _insideMarkers.clear());

    final Random random = Random();

    final double randomTurns = random.nextDouble() * 3 + 2;

    final double newAngle = _currentPointerAngle + (2 * pi * randomTurns);

    _animation = Tween<double>(begin: _currentPointerAngle, end: newAngle)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    setState(() => finalPointerAngleDegrees = null);

    _controller.reset();

    _controller.forward();

    _currentPointerAngle = newAngle;
  }

  // void _zoomIn() {
  //   setState(() {
  //     _currentZoom += 1;
  //     _mapController.move(_centerCoord, _currentZoom);
  //   });
  // }
  //
  // void _zoomOut() {
  //   setState(() {
  //     _currentZoom -= 1;
  //     _mapController.move(_centerCoord, _currentZoom);
  //   });
  // }

  // void _increaseNeedle() {
  //   setState(() {
  //     _needleFactor += 0.05;
  //   });
  // }
  //
  // void _decreaseNeedle() {
  //   setState(() {
  //     _needleFactor = max(0.05, _needleFactor - 0.05);
  //   });
  // }

  // void _toggleRectangle() {
  //   setState(() {
  //     _showRectangle = !_showRectangle;
  //   });
  // }

  // void _increaseSelectionMargin() {
  //   setState(() {
  //     _selectionMargin += 0.000001;
  //   });
  // }
  //
  // void _decreaseSelectionMargin() {
  //   setState(() {
  //     _selectionMargin = max(0.0, _selectionMargin - 0.000001);
  //   });
  // }

  ///
  void getSelectedTemple() {
    const double widgetSize = 200.0;

    const Offset widgetCenter = Offset(widgetSize / 2, widgetSize / 2);

    final double needleLength = widgetSize * _needleFactor;

    final double rectWidth = needleLength * 0.2;

    final Offset topLeft = Offset(widgetCenter.dx - rectWidth / 2, widgetCenter.dy - needleLength);

    final Offset topRight = Offset(widgetCenter.dx + rectWidth / 2, widgetCenter.dy - needleLength);

    final Offset bottomRight = Offset(widgetCenter.dx + rectWidth / 2, widgetCenter.dy);

    final Offset bottomLeft = Offset(widgetCenter.dx - rectWidth / 2, widgetCenter.dy);

    final List<Offset> rotatedPoints = <Offset>[
      _rotateOffset(topLeft, _animation.value, widgetCenter),
      _rotateOffset(topRight, _animation.value, widgetCenter),
      _rotateOffset(bottomRight, _animation.value, widgetCenter),
      _rotateOffset(bottomLeft, _animation.value, widgetCenter),
    ];

    final Offset centerPixel = latLngToPixel(_centerCoord, _currentZoom);

    final List<LatLng> polygonLatLng = rotatedPoints.map((Offset pt) {
      final Offset pixel = centerPixel + (pt - widgetCenter);
      return pixelToLatLng(pixel, _currentZoom);
    }).toList();

    final double effectiveTolerance = _tolerance + _selectionMargin;

    final Set<LatLng> insideMarkers = <LatLng>{};

    for (final LatLng marker in _additionalMarkers) {
      if (isPointInsidePolygonWithTolerance(marker, polygonLatLng, effectiveTolerance)) {
        insideMarkers.add(marker);
      }
    }

    setState(() => _insideMarkers = insideMarkers);

    if (insideMarkers.isEmpty) {
      // ignore: inference_failure_on_function_invocation
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: const Text('ポリゴン内にはマーカーがありません。'),
          );
        },
      );

      return;
    }

    TempleDialog(
      context: context,
      widget: NeedleCompassSelectedListAlert(selectedGeoloc: insideMarkers),
      paddingLeft: context.screenSize.width * 0.3,
      clearBarrierColor: true,
    );
  }

  ///
  Offset _rotateOffset(Offset point, double angle, Offset center) {
    final Offset translated = point - center;

    final Offset rotated = Offset(
      translated.dx * cos(angle) - translated.dy * sin(angle),
      translated.dx * sin(angle) + translated.dy * cos(angle),
    );

    return rotated + center;
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeMarker();

    final Offset centerPixel = latLngToPixel(_centerCoord, _currentZoom);

    final Offset offsetPixel =
        latLngToPixel(LatLng(_centerCoord.latitude + _selectionMargin, _centerCoord.longitude), _currentZoom);

    final double selectionMarginPixels = (offsetPixel - centerPixel).dy.abs();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('地図上で針が回るサンプル'),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(_showRectangle ? Icons.visibility : Icons.visibility_off),
      //       tooltip: '長方形（ポリゴン）の表示切替',
      //       onPressed: _toggleRectangle,
      //     ),
      //   ],
      // ),
      body: Stack(
        children: <Widget>[
          FlutterMap(
            key: _mapKey,
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _centerCoord,
              initialZoom: _currentZoom,
              minZoom: _currentZoom,
              maxZoom: _currentZoom,
              onPositionChanged: (MapCamera position, bool hasGesture) => _mapController.rotate(0),
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.myapp',
              ),
              MarkerLayer(
                markers: <Marker>[
                  Marker(
                    point: _centerCoord,
                    width: 200,
                    height: 200,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(angle: _animation.value, child: child);
                      },
                      child: CustomPaint(
                        painter: PointerPainter(
                          needleFactor: _needleFactor,
                          showRectangle: _showRectangle,
                          selectionMarginPixels: selectionMarginPixels,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              MarkerLayer(
                markers: _additionalMarkers.map((LatLng latlng) {
                  final bool isInside = _insideMarkers.contains(latlng);
                  return Marker(
                    point: latlng,
                    width: 20,
                    height: 20,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: isInside ? Colors.green.withOpacity(0.3) : Colors.orangeAccent.withOpacity(0.3),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          Positioned(
            top: 5,
            right: 5,
            left: 5,
            child: Container(
              width: context.screenSize.width,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    onPressed: () => spinNeedle(),
                    icon: const Icon(Icons.refresh, size: 30, color: Colors.white),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(color: Colors.white),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            child: finalPointerAngleDegrees == null
                                ? Container()
                                : Text(
                                    '${finalPointerAngleDegrees!.toStringAsFixed(2)}° (${getCompassDirection(finalPointerAngleDegrees!)})',
                                    style: const TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => getSelectedTemple(),
                    icon: const Icon(Icons.list, size: 30, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Positioned(
          //   bottom: 200,
          //   left: 10,
          //   child: Column(
          //     children: <Widget>[
          //       FloatingActionButton(
          //         onPressed: _zoomIn,
          //         mini: true,
          //         child: const Icon(Icons.add),
          //       ),
          //       const SizedBox(height: 10),
          //       FloatingActionButton(
          //         onPressed: _zoomOut,
          //         mini: true,
          //         child: const Icon(Icons.remove),
          //       ),
          //     ],
          //   ),
          // ),
          // Positioned(
          //   bottom: 90,
          //   right: 10,
          //   child: Column(
          //     children: <Widget>[
          //       FloatingActionButton(
          //         onPressed: _increaseNeedle,
          //         mini: true,
          //         backgroundColor: Colors.green,
          //         tooltip: '針を長くする',
          //         child: const Icon(Icons.arrow_upward),
          //       ),
          //       const SizedBox(height: 10),
          //       FloatingActionButton(
          //         onPressed: _decreaseNeedle,
          //         mini: true,
          //         backgroundColor: Colors.orange,
          //         tooltip: '針を短くする',
          //         child: const Icon(Icons.arrow_downward),
          //       ),
          //     ],
          //   ),
          // ),
          // Positioned(
          //   bottom: 200,
          //   right: 10,
          //   child: Column(
          //     children: <Widget>[
          //       FloatingActionButton(
          //         onPressed: _increaseSelectionMargin,
          //         mini: true,
          //         backgroundColor: Colors.purple,
          //         tooltip: '選択余裕を増やす',
          //         child: const Icon(Icons.arrow_forward),
          //       ),
          //       const SizedBox(height: 10),
          //       FloatingActionButton(
          //         onPressed: _decreaseSelectionMargin,
          //         mini: true,
          //         backgroundColor: Colors.purpleAccent,
          //         tooltip: '選択余裕を減らす',
          //         child: const Icon(Icons.arrow_back),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
//      floatingActionButton: FloatingActionButton(onPressed: spinNeedle, child: const Icon(Icons.refresh)),
    );
  }

  ///
  void makeMarker() {
    for (final TempleLatLngModel element in templeLatLngState.templeLatLngList) {
      if (<String>['S', 'A'].contains(element.rank)) {
        _additionalMarkers.add(LatLng(element.lat.toDouble(), element.lng.toDouble()));
      }
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
  const PointerPainter({required this.needleFactor, required this.showRectangle, required this.selectionMarginPixels});

  final double needleFactor;
  final bool showRectangle;

  final double selectionMarginPixels;

  ///
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    final double needleLength = size.width * needleFactor;

    final Offset needleEnd = Offset(center.dx, center.dy - needleLength);

    final Paint needlePaint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    canvas.drawCircle(center, 6.0, Paint()..color = Colors.black);

    if (showRectangle) {
      final double rectWidth = needleLength * 0.2;

      final Rect baseRect = Rect.fromLTWH(
        center.dx - rectWidth / 2,
        center.dy - needleLength,
        rectWidth,
        needleLength,
      );

      final Paint basePaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawRect(baseRect, basePaint);

      final Rect outerRect = baseRect.inflate(selectionMarginPixels);

      final Paint outerPaint = Paint()
        ..color = Colors.greenAccent.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.drawRect(outerRect, outerPaint);
    }
  }

  ///
  @override
  bool shouldRepaint(covariant PointerPainter oldDelegate) =>
      oldDelegate.needleFactor != needleFactor ||
      oldDelegate.showRectangle != showRectangle ||
      oldDelegate.selectionMarginPixels != selectionMarginPixels;
}

///
Offset latLngToPixel(LatLng latlng, double zoom) {
  final double latRad = latlng.latitude * pi / 180;

  final num scale = 256 * pow(2, zoom);

  final double x = (latlng.longitude + 180) / 360 * scale;

  final double y = (1 - log(tan(latRad) + 1 / cos(latRad)) / pi) / 2 * scale;

  return Offset(x, y);
}

///
LatLng pixelToLatLng(Offset pixel, double zoom) {
  final num scale = 256 * pow(2, zoom);

  final double lng = pixel.dx / scale * 360 - 180;

  final double n = pi - 2 * pi * pixel.dy / scale;

  final double lat = 180 / pi * atan(sinh(n));

  return LatLng(lat, lng);
}

///
double sinh(num x) => (exp(x) - exp(-x)) / 2.0;

///
double distancePointToSegment(LatLng p, LatLng a, LatLng b) {
  if (a.latitude == b.latitude && a.longitude == b.longitude) {
    return sqrt(pow(p.latitude - a.latitude, 2) + pow(p.longitude - a.longitude, 2));
  }

  final double dx = b.longitude - a.longitude;

  final double dy = b.latitude - a.latitude;

  double t = ((p.longitude - a.longitude) * dx + (p.latitude - a.latitude) * dy) / (dx * dx + dy * dy);

  t = t.clamp(0.0, 1.0);

  final double projX = a.longitude + t * dx;

  final double projY = a.latitude + t * dy;

  return sqrt(pow(p.longitude - projX, 2) + pow(p.latitude - projY, 2));
}

///
bool isPointInsidePolygonWithTolerance(LatLng point, List<LatLng> polygon, double effectiveTolerance) {
  for (int i = 0; i < polygon.length; i++) {
    final LatLng a = polygon[i];
    final LatLng b = polygon[(i + 1) % polygon.length];
    if (distancePointToSegment(point, a, b) <= effectiveTolerance) {
      return true;
    }
  }

  int intersectCount = 0;

  for (int i = 0; i < polygon.length; i++) {
    final LatLng a = polygon[i];

    final LatLng b = polygon[(i + 1) % polygon.length];

    final bool cond1 = ((a.latitude > point.latitude) != (b.latitude > point.latitude));

    final double intersectX =
        (b.longitude - a.longitude) * (point.latitude - a.latitude) / (b.latitude - a.latitude) + a.longitude;

    final bool cond2 = point.longitude < intersectX;

    if (cond1 && cond2) {
      intersectCount++;
    }
  }

  return intersectCount.isOdd;
}
