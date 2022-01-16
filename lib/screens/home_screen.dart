import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/widgets/map/firststep.dart';
import 'package:tricycleapp/widgets/map/maketricyclerequest.dart';

enum MapSelected { normal, satelite, hybrid }

enum RequestTricycleState { start, picklocation, checkingpayment, sendrequest }

class HomeScreen extends StatefulWidget {
  static const screenName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //prepairing map

  var maxcontroller = Get.put(Mapcontroller());
  Completer<GoogleMapController> _googlemapcontroller = Completer();
  GoogleMapController? _newgooglemapcontroller;
  Position? currentPosition;
  CameraPosition? cameraposition;
  bool isMapReady = false;
  Position? markerPosition;

  void setMapCameraInitialValue() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    var getinitialposition = await Geolocator.getCurrentPosition();
    String? getinitialpositionString = getinitialposition.latitude.toString() +
        getinitialposition.longitude.toString();
    cameraposition = CameraPosition(
        target:
            LatLng(getinitialposition.latitude, getinitialposition.longitude),
        zoom: 15);

    if (getinitialpositionString.isNotEmpty) {
      setMapIsReady(true);
    } else {
      setMapIsReady(false);
    }
  }

  void setMapIsReady(bool value) {
    setState(() {
      isMapReady = value;
    });
  }

  void _moveMapCameraToCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng newcameraposition =
        LatLng(currentPosition!.latitude, currentPosition!.longitude);
    cameraposition = CameraPosition(target: newcameraposition, zoom: 17);
    _newgooglemapcontroller!.animateCamera(
        CameraUpdate.newCameraPosition(cameraposition as CameraPosition));
    // maxcontroller.currentAddressCoorDinate(newcameraposition);
  }

  //placing marker in map

  LatLng? _placedMarkerLocation;

  void placeMarker(LatLng position) {
    setState(() {
      _placedMarkerLocation = position;
    });

    maxcontroller.placeMarkerAddressCoordinate(_placedMarkerLocation as LatLng);
  }

  RequestTricycleState requestformstate = RequestTricycleState.start;

  void setRequestState(RequestTricycleState requeststate) {
    setState(() {
      requestformstate = requeststate;
    });
  }

  void startRequest() {
    setRequestState(RequestTricycleState.picklocation);
  }

  void backToStartRequest() {
    setRequestState(RequestTricycleState.start);
    _placedMarkerLocation = null;

  }

  @override
  void initState() {
    super.initState();
    setMapCameraInitialValue();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (requestformstate == RequestTricycleState.start)
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white,
                // borderRadius: BorderRadius.only(
                //     bottomLeft: Radius.circular(12),
                //     bottomRight: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 6.5,
                      spreadRadius: 6.0,
                      offset: Offset(0.7, 0.7)),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi There',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4,
                ),
                Text('Where  would you like to go?')
              ],
            ),
          ),
        isMapReady == false
            ? Expanded(
                child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ))
            : Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      padding: EdgeInsets.only(bottom: 30),
                      mapType: MapType.normal,
                      initialCameraPosition: cameraposition as CameraPosition,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController mapcontroller) {
                        _googlemapcontroller.complete(mapcontroller);
                        _newgooglemapcontroller = mapcontroller;
                        _moveMapCameraToCurrentPosition();
                      },
                      onTap:
                          requestformstate == RequestTricycleState.picklocation
                              ? placeMarker
                              : null,
                      markers: _placedMarkerLocation == null
                          ? {}
                          : {
                              Marker(
                                  markerId: MarkerId('m1'),
                                  position: _placedMarkerLocation as LatLng)
                            },
                    )
                  ],
                ),
              ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          reverseDuration: Duration(milliseconds: 200),
          child: requestformBuilder(),
        ),

        // Maketricyclerequest(),
      ],
    );
  }

  Widget requestformBuilder() {
    if (requestformstate == RequestTricycleState.picklocation) {
      return Firststep(
        backToStartRequest: backToStartRequest,
      );
    }
    return Maketricyclerequest(
      startRequest: startRequest,
    );
  }
}
