import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NeedleCompassMapAlert extends StatefulWidget {
  const NeedleCompassMapAlert({super.key});

  @override
  State<NeedleCompassMapAlert> createState() => _NeedleCompassMapAlertState();
}

class _NeedleCompassMapAlertState extends State<NeedleCompassMapAlert> with SingleTickerProviderStateMixin {
  final GlobalKey _mapKey = GlobalKey();

  late AnimationController _controller;

  late Animation<double> _animation;

  double _currentPointerAngle = 0.0;

  double? finalPointerAngleDegrees;

  double _needleFactor = 0.8;

  bool _showRectangle = true;

  final double _tolerance = 0.000001;

  final MapController _mapController = MapController();

  double _currentZoom = 16.0;

  final LatLng _centerCoord = const LatLng(35.718532, 139.586639);

  List<LatLng> _additionalMarkers = <LatLng>[];

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
  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
      _mapController.move(_centerCoord, _currentZoom);
    });
  }

  ///
  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
      _mapController.move(_centerCoord, _currentZoom);
    });
  }

  ///
  void _increaseNeedle() => setState(() => _needleFactor += 0.5);

  ///
  void _decreaseNeedle() => setState(() => _needleFactor = max(0.5, _needleFactor - 0.5));

  ///
  void _toggleRectangle() => setState(() => _showRectangle = !_showRectangle);

  ///
  void _checkMarkersInPolygon() {
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

    final List<LatLng> insideMarkers = <LatLng>[];

    for (final LatLng marker in _additionalMarkers) {
      if (isPointInsidePolygonWithTolerance(marker, polygonLatLng, _tolerance)) {
        insideMarkers.add(marker);
      }
    }

    // ignore: inference_failure_on_function_invocation
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: insideMarkers.isEmpty
              ? const Text('ポリゴン内にはマーカーがありません。')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('ポリゴン内のマーカー：', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...insideMarkers.map((LatLng m) => Text('Lat: ${m.latitude}, Lng: ${m.longitude}'))
                  ],
                ),
        );
      },
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

  @override
  Widget build(BuildContext context) {
    makeMarker();

    return Scaffold(
      appBar: AppBar(
        title: const Text('地図上で針が回るサンプル'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_showRectangle ? Icons.visibility : Icons.visibility_off),
            tooltip: '長方形（ポリゴン）の表示切替',
            onPressed: _toggleRectangle,
          ),
        ],
      ),
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
                      builder: (BuildContext context, Widget? child) =>
                          Transform.rotate(angle: _animation.value, child: child),
                      child: CustomPaint(
                        painter: PointerPainter(needleFactor: _needleFactor, showRectangle: _showRectangle),
                      ),
                    ),
                  ),
                ],
              ),
              MarkerLayer(
                markers: _additionalMarkers.map((LatLng latlng) {
                  return Marker(
                    point: latlng,
                    width: 20,
                    height: 20,
                    child: Container(decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                  );
                }).toList(),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: finalPointerAngleDegrees == null
                  ? Container()
                  : Text(
                      '針先の向き: ${finalPointerAngleDegrees!.toStringAsFixed(2)}° (${getCompassDirection(finalPointerAngleDegrees!)})',
                      style: const TextStyle(fontSize: 20, color: Colors.black, backgroundColor: Colors.white70),
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
            bottom: 90,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(onPressed: _checkMarkersInPolygon, child: const Text('ポリゴン内のマーカーをチェック')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _spinPointer, child: const Icon(Icons.refresh)),
    );
  }

  ///
  void makeMarker() {
    // ignore: always_specify_types
    _additionalMarkers = List.generate(20, (int index) {
      final Random rand = Random(index);

      final double offsetLat = 35.718532 + (rand.nextDouble() - 0.5) * 0.0004;

      final double offsetLng = 139.586639 + (rand.nextDouble() - 0.5) * 0.0004;

      return LatLng(offsetLat, offsetLng);
    });
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
  const PointerPainter({required this.needleFactor, required this.showRectangle});

  final double needleFactor;
  final bool showRectangle;

  ///
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    final double needleLength = size.width * needleFactor;

    final Offset needleEnd = Offset(center.dx, center.dy - needleLength);

    final Paint needlePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    canvas.drawCircle(center, 6.0, Paint()..color = Colors.black);

    if (showRectangle) {
      final double rectWidth = needleLength * 0.2;

      final Rect rect = Rect.fromLTWH(center.dx - rectWidth / 2, center.dy - needleLength, rectWidth, needleLength);

      final Paint rectPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawRect(rect, rectPaint);
    }
  }

  ///
  @override
  bool shouldRepaint(covariant PointerPainter oldDelegate) =>
      oldDelegate.needleFactor != needleFactor || oldDelegate.showRectangle != showRectangle;
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
bool isPointInsidePolygonWithTolerance(LatLng point, List<LatLng> polygon, double tolerance) {
  for (int i = 0; i < polygon.length; i++) {
    final LatLng a = polygon[i];

    final LatLng b = polygon[(i + 1) % polygon.length];

    if (distancePointToSegment(point, a, b) <= tolerance) {
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
