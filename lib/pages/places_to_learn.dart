import 'dart:async';
import 'dart:ui';

import 'package:eduMap/pages/lecture.detail.dart';
import 'package:eduMap/utils/fetch_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../models/models.dart';

class PlacesToLearn extends StatefulWidget {
  const PlacesToLearn({super.key});

  @override
  PlacesToLearnState createState() => PlacesToLearnState();
}

class PlacesToLearnState extends State<PlacesToLearn> {
  bool _locationPermissionGranted = false;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  List<Place> places = [];
  late ClusterManager _manager;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    _requestLocationPermission();
    _getBusanLectures();
    _manager = _initClusterManager();
    super.initState();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(
      places,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0],
    );
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        Uint8List? markerData;

        // if (!cluster.isMultiple) {
        //   markerData = await getMarkerIcon(cluster.items.first.streetViewUrl);
        // }

        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () async {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
            if (!cluster.isMultiple) {
              _showDetail(cluster.items.first.lecture);
            }
          },
          icon: cluster.isMultiple
              ? await _getMarkerBitmap(125,
                  text: cluster.isMultiple ? cluster.count.toString() : null)
              : BitmapDescriptor.fromBytes(markerData!),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blueAccent;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      _markers = markers;
    });
  }

  Future _getBusanLectures() async {
    if (!mounted) return;
    List<Place>? fetchedPlaces = await getLectureMarkers();
    if (fetchedPlaces == null) return;
    setState(() {
      try {
        places = fetchedPlaces;
        _markers.clear(); // Clear existing markers
        if (places.isNotEmpty) {
          for (var place in places) {
            _addMarker(place.name, place.latLng, place.lecture);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  Future _requestLocationPermission() async {
    final permissionStatus = await Geolocator.requestPermission();
    setState(() {
      _locationPermissionGranted =
          permissionStatus == LocationPermission.always ||
              permissionStatus == LocationPermission.whileInUse;
    });
    if (_locationPermissionGranted) {
      _getCurrentPosition();
    }
  }

  Future _getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showDetail(List<Lecture> curriculums) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              padding: const EdgeInsets.all(10.0),
              // child: CurriculumList(curriculums),
              child: ListView.builder(
                itemCount: curriculums.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(curriculums[index].eduNm),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LectureDetail(curriculum: curriculums[index]),
                        ),
                      );
                    },
                  );
                },
              ));
        });
  }

  Future _addMarker(
      String title, LatLng latLng, List<Lecture> curriculums) async {
    final marker = Marker(
      markerId: MarkerId(title),
      position: latLng,
      infoWindow: InfoWindow(
        title:
            curriculums.length == 1 ? title : '$title (${curriculums.length})',
        snippet: 'Lat: ${latLng.latitude}, Lng: ${latLng.longitude}',
        onTap: () {
          _showDetail(curriculums);
        },
      ),
      // onTap: () {
      //   print('chk');
      //   _showDetail(curriculums);
      // },
      // icon: markerData == null
      //     ? BitmapDescriptor.defaultMarker
      //     : BitmapDescriptor.fromBytes(markerData),
    );
    setState(() {
      _markers.add(marker);
    });
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    try {
      final position = await Geolocator.getCurrentPosition();
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(position.latitude, position.longitude),
          zoom: 12.0,
        ),
      ));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _currentPosition != null
            ? Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 12,
                    ),
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      _manager.setMapId(controller.mapId);
                    },
                    onCameraMove: _manager.onCameraMove,
                    onCameraIdle: _manager.updateMap,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100.0, right: 10.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          _currentLocation();
                        },
                        mini: true,
                        child: const Icon(Icons.location_on_outlined),
                      ),
                    ),
                  ),
                  // NaverMap(
                  //   options: NaverMapViewOptions(),
                  //   onMapReady: (controller) => print('naver map ready.'),
                  // ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    // child: FloatingItems(
                    //   markerMap: places,
                    //   showDetailCallback: _showDetail,
                    // ),
                    child: places.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: places
                                  .map((item) => GestureDetector(
                                        // onTap: () =>
                                        //     showDetailCallback(item.lecture),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                item.name,
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )
                        : Container(),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
