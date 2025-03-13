import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../extensions/extensions.dart';

class Utility {
  ///
  void showError(String msg) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  ///
  Color getYoubiColor({required DateTime date, required String youbiStr, required List<DateTime> holiday}) {
    Color color = Colors.black.withOpacity(0.2);

    switch (youbiStr) {
      case 'Sunday':
        color = Colors.redAccent.withOpacity(0.2);

      case 'Saturday':
        color = Colors.blueAccent.withOpacity(0.2);

      default:
        color = Colors.black.withOpacity(0.2);
        break;
    }

    if (holiday.contains(date)) {
      color = Colors.greenAccent.withOpacity(0.2);
    }

    return color;
  }

  ///
  Color getLeadingBgColor({required String month}) {
    switch (month.toInt() % 6) {
      case 0:
        return Colors.orangeAccent.withOpacity(0.2);
      case 1:
        return Colors.blueAccent.withOpacity(0.2);
      case 2:
        return Colors.redAccent.withOpacity(0.2);
      case 3:
        return Colors.purpleAccent.withOpacity(0.2);
      case 4:
        return Colors.greenAccent.withOpacity(0.2);
      case 5:
        return Colors.yellowAccent.withOpacity(0.2);
      default:
        return Colors.black;
    }
  }

  ///
  List<Color> getTwelveColor() {
    return <Color>[
      const Color(0xffdb2f20),
      const Color(0xffefa43a),
      const Color(0xfffdf551),
      const Color(0xffa6c63d),
      const Color(0xff439638),
      const Color(0xff469c9e),
      const Color(0xff48a0e1),
      const Color(0xff3070b1),
      const Color(0xff020c75),
      const Color(0xff931c7a),
      const Color(0xffdc2f81),
      const Color(0xffdb2f5c),
    ];
  }

  ///
  double calculateDistance(LatLng p1, LatLng p2) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, p1, p2);
  }
}

class NavigationService {
  const NavigationService._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
