import 'package:eduMap/models/lecture.dart';
import 'package:eduMap/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Place>?> getLectureMarkers() async {
  http.Response response;
  try {
    response = await http
        .get(Uri.parse('http://192.168.0.21:3000/api/getBusanLecture'));
  } catch (e) {
    return null;
  }

  final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
  final data = jsonResponse['data'];
  Map<String, List<Lecture>> map = {};

  for (var lecture in data) {
    final String eduNm = lecture['eduNm'];
    final DateTime eduSdate = DateTime.parse(lecture['eduSdate']);
    final DateTime eduFdate = DateTime.parse(lecture['eduFdate']);
    final String eduTime = lecture['eduTime'];
    final String eduLoc = lecture['eduLoc'];
    final String people = lecture['people'];
    final String eduExp = lecture['eduExp'];
    final String months = lecture['months'];
    final String target = lecture['target'];
    final String period = lecture['period'];
    final String tel = lecture['tel'];
    final String days = lecture['days'];
    final String gugun = lecture['gugun'];
    final DateTime dataDay = DateTime.parse(lecture['dataDay']);
    final String roadAddr = lecture['roadAddr'];
    final String addr = lecture['addr'];
    final double lat = lecture['lat'];
    final double lng = lecture['lng'];
    final String streetViewUrl = lecture['streetViewUrl'];

    Lecture lectureBusan = Lecture(
      eduNm: eduNm,
      eduSdate: eduSdate,
      eduFdate: eduFdate,
      eduTime: eduTime,
      eduLoc: eduLoc,
      people: people,
      eduExp: eduExp,
      months: months,
      target: target,
      period: period,
      tel: tel,
      days: days,
      gugun: gugun,
      dataDay: dataDay,
      roadAddr: roadAddr,
      addr: addr,
      lat: lat,
      lng: lng,
      streetViewUrl: streetViewUrl,
      latLng: LatLng(lat, lng),
    );
    String key = lectureBusan.eduLoc;
    // Check if the location key exists in the map
    if (map.containsKey(key)) {
      // Location already exists, add the curriculum to the list
      map[key]!.add(lectureBusan);
    } else {
      // Location doesn't exist, create a new list with the curriculum
      map[key] = [lectureBusan];
    }
  }

  List<Place> places = [];
  map.forEach((key, value) {
    places.add(
      Place(
          name: key,
          latLng: value[0].latLng,
          lecture: value,
          streetViewUrl: value[0].streetViewUrl),
    );
  });

  return places;
}
