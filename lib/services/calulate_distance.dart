import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

int calculateDistance(LatLng from, LatLng to) {
  final double earthRadius = 6371; // Radius of the earth in kilometers

  final double latDifference = _degreesToRadians(to.latitude - from.latitude);
  final double lonDifference = _degreesToRadians(to.longitude - from.longitude);

  final double a = sin(latDifference / 2) * sin(latDifference / 2) +
      cos(_degreesToRadians(from.latitude)) *
          cos(_degreesToRadians(to.latitude)) *
          sin(lonDifference / 2) *
          sin(lonDifference / 2);

  final double c = 2 * asin(sqrt(a));

  final double distance = earthRadius * c; // Distance in kilometers
  return distance.toInt();
}

double _degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}
