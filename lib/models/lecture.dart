import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Lecture with ClusterItem {
  final String eduNm;
  final DateTime eduSdate;
  final DateTime eduFdate;
  final String eduTime;
  final String eduLoc;
  final String people;
  final String eduExp;
  final String months;
  final String target;
  final String period;
  final String tel;
  final String days;
  final String gugun;
  final DateTime dataDay;
  final String roadAddr;
  final String addr;
  final double lat;
  final double lng;
  final String streetViewUrl;
  final bool isClosed;
  final LatLng latLng;

  Lecture({
    required this.eduNm,
    required this.eduSdate,
    required this.eduFdate,
    required this.eduTime,
    required this.eduLoc,
    required this.people,
    required this.eduExp,
    required this.months,
    required this.target,
    required this.period,
    required this.tel,
    required this.days,
    required this.gugun,
    required this.dataDay,
    required this.roadAddr,
    required this.addr,
    required this.lat,
    required this.lng,
    required this.streetViewUrl,
    required this.latLng,
    this.isClosed = false,
  });

  @override
  String toString() {
    return 'Place $eduNm (closed : $isClosed)';
  }

  @override
  LatLng get location => latLng;

  Map<String, dynamic> toJson() {
    return {
      'streetViewUrl': streetViewUrl,
      'eduNm': eduNm,
      'eduSdate': eduSdate.toString(),
      'eduFdate': eduFdate.toString(),
      'eduTime': eduTime,
      'eduLoc': eduLoc,
      'people': people,
      'eduExp': eduExp,
      'months': months,
      'target': target,
      'period': period,
      'tel': tel,
      'days': days,
      'gugun': gugun,
      'dataDay': dataDay.toString(),
      'roadAddr': roadAddr,
      'addr': addr,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'isClosed': isClosed,
      "latLng": latLng,
    };
  }
}
