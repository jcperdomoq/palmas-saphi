import 'package:syncfusion_flutter_maps/maps.dart';

class FilterCoordinates {
  static bool checkIfValidMarker(MapLatLng tap, List<MapLatLng> vertices) {
    int intersectCount = 0;
    bool intersecCoords = false;
    for (int j = 0; j < vertices.length - 1; j++) {
      if (_rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
        intersectCount++;
      }
      if (tap.latitude == vertices[j].latitude &&
          tap.longitude == vertices[j].longitude) {
        intersecCoords = true;
      }
    }

    return ((intersectCount % 2) == 1) ||
        intersecCoords; // odd = inside, even = outside;
  }

  static bool _rayCastIntersect(
      MapLatLng tap, MapLatLng vertA, MapLatLng vertB) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
    double pY = tap.latitude;
    double pX = tap.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false; // a and b can't both be above or below pt.y, and a or
      // b must be east of pt.x
    }

    double m = (aY - bY) / (aX - bX); // Rise over run
    double bee = (-aX) * m + aY; // y = mx + b
    double x = (pY - bee) / m; // algebra is neat!

    return x > pX;
  }
}
