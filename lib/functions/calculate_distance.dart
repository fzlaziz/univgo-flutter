import 'dart:math';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const radius = 6371;
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return radius * c;
}

double _toRadians(double degrees) {
  return degrees * pi / 180;
}
