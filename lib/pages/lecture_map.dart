import 'dart:async';
import 'dart:ui';

import 'package:eduMap/constants/constants.dart';
import 'package:eduMap/pages/lecture.detail.dart';
import 'package:eduMap/services/calulate_distance.dart';
import 'package:eduMap/utils/fetch_data.dart';
import 'package:eduMap/widgets/spinner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;

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
  Place? selectedPlaceDetail;

  @override
  void initState() {
    super.initState();
    asyncInit();
    _manager = _initClusterManager();
  }

  void asyncInit() async {
    await _requestLocationPermission();
    await _getBusanLectures();
    _clickClosestLocation();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(
      places,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0],
    );
  }

  void _clickClosestLocation() {
    int nearestDistance = 10;
    Place? nearPlace;

    for (var place in places) {
      var distanceBetween = calculateDistance(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        LatLng(place.latLng.latitude, place.latLng.longitude),
      );
      if (distanceBetween < 10 && distanceBetween < nearestDistance) {
        nearestDistance = distanceBetween;
        nearPlace = place;
      }
    }
    if (nearPlace != null) {
      // _showDetail(nearPlace);
      _moveCamera(nearPlace.latLng.latitude, nearPlace.latLng.longitude);
    }
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
              // _showDetail(cluster.items.first);
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
    // setState(() {
    //   _markers = markers;
    // });
  }

  Future _getBusanLectures() async {
    List<Place>? fetchedPlaces = await getLectureMarkers();
    if (fetchedPlaces == null) return;
    setState(() {
      try {
        places = fetchedPlaces;
        _markers.clear(); // Clear existing markers
        if (places.isNotEmpty) {
          for (var place in places) {
            _addMarker(place);
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
      await _getCurrentPosition();
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

  // void _showDetail(Place place) {
  //   int step = 0;
  //   List<Lecture> curriculums = place.lecture;
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return BottomSheet(
  //             onClosing: () {},
  //             builder: (context) =>
  //                 StatefulBuilder(builder: (BuildContext, setState) {
  //                   if (step == 0) {
  //                     return Container(
  //                       height: 300,
  //                       child: Container(
  //                         child: Column(
  //                           children: [
  //                             SizedBox(height: 10),
  //                             Text(place.name, style: StyleConstants.heading),
  //                             SizedBox(height: 10),
  //                             Container(
  //                               width: MediaQuery.of(context).size.width * 0.8,
  //                               height: 200,
  //                               child: ClipRRect(
  //                                 borderRadius: BorderRadius.circular(15),
  //                                 child: Image.network(
  //                                   place.streetViewUrl!,
  //                                   fit: BoxFit.fitWidth,
  //                                 ),
  //                               ),
  //                             ),
  //                             TextButton(
  //                                 onPressed: () {
  //                                   setState(() {
  //                                     step = 1;
  //                                   });
  //                                 },
  //                                 child: Text('커리큘럼 보기'))
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   } else {
  //                     return Container(
  //                         height: 300,
  //                         padding: const EdgeInsets.all(10.0),
  //                         child: ListView.builder(
  //                           itemCount: curriculums.length,
  //                           itemBuilder: (context, index) {
  //                             return ListTile(
  //                               leading: const Icon(Icons.location_on_outlined),
  //                               title: Text(curriculums[index].eduNm),
  //                               onTap: () {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                     builder: (context) => LectureDetail(
  //                                         place: place,
  //                                         curriculum: curriculums[index]),
  //                                   ),
  //                                 );
  //                               },
  //                             );
  //                           },
  //                         ));
  //                   }
  //                 }));
  //       });
  // }

//place.name, place.latLng, place.lecture
  Future _addMarker(Place place) async {
    final marker = Marker(
      markerId: MarkerId(place.name),
      position: place.latLng,
      infoWindow: InfoWindow(
        title: place.lecture.length == 1
            ? place.name
            : '${place.name} (${place.lecture.length})',
        snippet:
            'Lat: ${place.latLng.latitude}, Lng: ${place.latLng.longitude}',
        onTap: () {
          // _showDetail(place);
        },
      ),
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

  void _moveCamera(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    try {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(lat, lng),
          zoom: 12.0,
        ),
      ));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Center(child: Spinner());
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: GoogleMap(
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
          ),
          Expanded(
            child: places.isEmpty
                ? Container()
                : (selectedPlaceDetail == null)
                    ? placesList(places)
                    : curriculumList(selectedPlaceDetail!),
          ),
        ],
      ),
    );
  }

  Widget placesList(List<Place> places) => ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          Place place = places[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPlaceDetail = place;
              });
              _moveCamera(place.latLng.latitude, place.latLng.longitude);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 50,
                    child: Image.network(
                      place.streetViewUrl!,
                      width: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(place.name)
                ],
              ),
            ),
          );
        },
      );

  Widget curriculumList(Place place) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPlaceDetail = null;
                    });
                  },
                  child: Icon(Icons.arrow_back),
                )),
                Center(
                    child: Text(
                  place.name,
                  style: StyleConstants.headingBlue,
                )),
              ],
            ),
          ),
          Container(
              height: 190,
              child: ListView.builder(
                itemCount: place.lecture.length,
                itemBuilder: (context, index) {
                  Lecture lecture = place.lecture[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LectureDetail(place: place, lecture: lecture),
                          ));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(lecture.eduNm),
                          Icon(Icons.location_on),
                        ],
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}

Future<Uint8List?> getMarkerIcon(String? streetViewUrl) async {
  if (streetViewUrl == null) return null;
  final NetworkAssetBundle bundle =
      NetworkAssetBundle(Uri.parse(streetViewUrl));
  try {
    final ByteData byteData = await bundle.load('');
    Uint8List resizedData = byteData.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(resizedData);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const int size = 100;
    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        const Radius.circular(40)));

    canvas.clipPath(clipPath);
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      image: imageFI.image,
    );
    //convert canvas as PNG bytes
    final image = await pictureRecorder
        .endRecording()
        .toImage(size, (size * 1.1).toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    //convert PNG bytes as BitmapDescriptor
    return data!.buffer.asUint8List();
  } catch (e) {
    print('Failed to load marker icon: $e');
    return null;
  }
}
