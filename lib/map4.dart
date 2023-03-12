import 'dart:async';
import 'package:bus_tracking_test/services/data.dart';
import 'package:bus_tracking_test/userlocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

LocationData? currentLocation;

class map4 extends StatefulWidget {
  const map4({Key? key}) : super(key: key);
  @override
  State<map4> createState() => map4State();
}

class map4State extends State<map4> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(13.0088029, 80.0054776);
  static const LatLng destination = LatLng(13.108818, 80.105423);

  final _firestore = FirebaseFirestore.instance;
  GeoFlutterFire? geo;
  Stream<List<DocumentSnapshot>>? stream;
  final radius = BehaviorSubject<double>.seeded(1.0);

  bool started = false;
  String? busNumber;

  bool startPressed = false;
  bool stopPressed = true;

  Location location = Location();
  StreamSubscription<LocationData>? locationSubscription;

  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyB8un86Eki04e0fN0JSEzd5BPt_Ge3YoqQ', // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  getCurrentLocation() async {
    await location.getLocation().then(
      (location) {
        setState(() {
          currentLocation = location;
        });
        print('LOCATION IS ${currentLocation.toString()}');
      },
    );

    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    getPolyPoints();
    getCurrentLocation();
    Data.setBusNumber('28');

    geo = GeoFlutterFire();
    GeoFirePoint center = geo!.point(latitude: 12.960632, longitude: 77.641603);
    stream = radius.switchMap((rad) {
      var collectionReference = _firestore.collection('locations');
//          .where('name', isEqualTo: 'darshan');
      return geo!.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);

      /*

      var collectionReference = _firestore.collection('nestedLocations');
//          .where('name', isEqualTo: 'darshan');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'address.location.position');

      */
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Data.setBusNumber('28');
    busNumber = Data.getBusNumber();
    print(currentLocation.toString());

    return Scaffold(
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                    zoom: 13.5,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("currentLocation"),
                      position: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                    ),
                    /*const Marker(
                      markerId: MarkerId("source"),
                      position: sourceLocation,
                    ),
                    const Marker(
                      markerId: MarkerId("destination"),
                      position: destination,
                    ),*/
                  },
                  onMapCreated: (mapController) {
                    _controller.complete(mapController);
                  },
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("route"),
                      points: polylineCoordinates,
                      color: const Color(0xFF7B61FF),
                      width: 6,
                    ),
                  },
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Click the button(s) to start/stop sharing the location',
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            /*SearchMapPlaceWidget(
                          apiKey: 'AIzaSyCu0EbP48H4G8vzUKFyGw5LHO57lRbtr2s',
                          hasClearButton: true,
                          placeType: PlaceType.address,
                          placeholder: 'Enter Destination',
                          onSelected: (Place place) async {
                            Geolocation? geolocation = await place.geolocation;
                            mapController.animateCamera(CameraUpdate.newLatLng(
                                geolocation!.coordinates));
                            mapController.animateCamera(
                                CameraUpdate.newLatLngBounds(
                                    geolocation.bounds, 0));
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),*/
                            /*Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.3,
                              /*child: TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Select Bus Number',
                                  hintText: 'Start',
                                ),
                                onChanged: (text) {
                                  // place = text;
                                },
                              ),*/
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                border: Border.all(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: DropdownButton<String>(
                                value: busNumber,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.deepPurple),
                                onChanged: (newValue) {
                                  setState(() {
                                    busNumber = newValue!;
                                  });
                                },
                                items: <String>[
                                  '1',
                                  '2',
                                  '3',
                                  '28',
                                  '28C'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),*/
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                stopPressed == true
                                    ? ElevatedButton(
                                        onPressed: () {
                                          // print(busNumber.toString());
                                          setState(() {
                                            started = true;
                                            startPressed = true;
                                            stopPressed = false;
                                          });
                                          print('ENTERED START: $startPressed');

                                          locationSubscription = location
                                              .onLocationChanged
                                              .listen((locationData) {
                                            print(
                                                'LOCATION DATA : ${locationData.toString()}');

                                            GeoFirePoint geoFirePoint = geo!
                                                .point(
                                                    latitude: currentLocation!
                                                        .latitude!
                                                        .toDouble(),
                                                    longitude: currentLocation!
                                                        .longitude!
                                                        .toDouble());

                                            /*_firestore.collection('$busNumber').add({
                          'name': 'randomname',
                          'position': geoFirePoint.data
                        }).then((_) {
                          print('added ${geoFirePoint.hash} successfully');
                        });*/

                                            _firestore
                                                .collection('$busNumber')
                                                .doc('$busNumber coordinates')
                                                .set({
                                              'name': 'geocoordinates',
                                              'position': geoFirePoint.data
                                            }).then((_) {
                                              print(
                                                  'added ${geoFirePoint.hash} successfully');
                                            });
                                          });
                                        },
                                        child: const Text('START'))
                                    : Container(),
                                startPressed == true
                                    ? ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            started = false;
                                            stopPressed = true;
                                            startPressed = false;
                                          });

                                          print('ENTERED STOP: $stopPressed');

                                          setState(() {
                                            locationSubscription!.cancel();
                                          });

                                          _firestore
                                              .collection('$busNumber')
                                              .get()
                                              .then((snapshot) {
                                            snapshot.docs.forEach((doc) {
                                              doc.reference.delete();
                                            });
                                          });
                                        },
                                        child: const Text('STOP'))
                                    : Container(),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                /*Positioned(
                  bottom: 20,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        started = false;
                      });

                      setState(() {
                        locationSubscription!.cancel();
                      });

                      _firestore
                          .collection('$busNumber')
                          .get()
                          .then((snapshot) {
                        snapshot.docs.forEach((doc) {
                          doc.reference.delete();
                        });
                      });
                    },
                    child: Text('Stop'),
                  ),
                ),*/
                /*Positioned(
                  bottom: 50,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      print(busNumber.toString());
                      setState(() {
                        started = true;
                      });

                      locationSubscription =
                          location.onLocationChanged.listen((locationData) {
                        print('LOCATION DATA : ${locationData.toString()}');

                        GeoFirePoint geoFirePoint = geo!.point(
                            latitude: currentLocation!.latitude!.toDouble(),
                            longitude: currentLocation!.longitude!.toDouble());

                        /*_firestore.collection('$busNumber').add({
                          'name': 'randomname',
                          'position': geoFirePoint.data
                        }).then((_) {
                          print('added ${geoFirePoint.hash} successfully');
                        });*/

                        _firestore
                            .collection('$busNumber')
                            .doc('$busNumber coordinates')
                            .set({
                          'name': 'geocoordinates',
                          'position': geoFirePoint.data
                        }).then((_) {
                          print('added ${geoFirePoint.hash} successfully');
                        });
                      });

                      /*GeoFirePoint geoFirePoint = geo!.point(
                          latitude: currentLocation!.latitude!.toDouble(),
                          longitude: currentLocation!.longitude!.toDouble());
                      _firestore.collection('locations1').add({
                        'name': 'random name',
                        'position': geoFirePoint.data
                      }).then((_) {
                        print('added ${geoFirePoint.hash} successfully');
                      });*/
                    },
                    child: Text('Start'),
                  ),
                ),*/
              ],
            ),
    );
  }
}
