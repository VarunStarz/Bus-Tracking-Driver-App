import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class mapScreen extends StatefulWidget {
  const mapScreen({Key? key}) : super(key: key);

  @override
  State<mapScreen> createState() => _mapScreenState();
}

class _mapScreenState extends State<mapScreen> {
  GoogleMapController? mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng _center = LatLng(13.0827, 80.2707);

  Location? location;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(13.0827, 80.2707), zoom: 15),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          mapType: MapType.hybrid,
          compassEnabled: true,
          markers: markers.values.toSet(),
          onTap: _addMarker(),
        ),
        Positioned(
          bottom: 50,
          right: 10,
          child: ElevatedButton(
            onPressed: _addMarker,
            child: Icon(
              Icons.pin_drop,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  _addMarker() {
    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(13.0827, 80.2707),
      icon: BitmapDescriptor.defaultMarker,
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }

  _animateToUser() async {
    var pos;
  }

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(13.0827, 80.2707),
      icon: BitmapDescriptor.defaultMarker,
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }
}
