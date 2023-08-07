import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'lecture.dart';

class Place with ClusterItem {
  final String name;
  final LatLng latLng;
  final List<Lecture> lecture;
  final String? streetViewUrl;

  Place({
    required this.name,
    required this.latLng,
    List<Lecture>? lecture,
    this.streetViewUrl,
  }) : lecture = lecture ?? [];

  @override
  String toString() {
    return 'Place $name';
  }

  @override
  LatLng get location => latLng;
}
