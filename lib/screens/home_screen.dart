import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/widgets/map/firststep.dart';
import 'package:tricycleapp/widgets/map/maketricyclerequest.dart';
import 'package:tricycleapp/widgets/map/search.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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

  List<LatLng> plineCoordinates = [];
  Set<Polyline> _polyline = {};

  int _polylincecounter = 1;

  void setMapCameraInitialValue() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    var getinitialposition = await Geolocator.getCurrentPosition();
    String? getinitialpositionString = getinitialposition.latitude.toString() +
        getinitialposition.longitude.toString();
    cameraposition = CameraPosition(
        target:
            LatLng(getinitialposition.latitude, getinitialposition.longitude),
        zoom: 16.500);

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
    cameraposition = CameraPosition(
      target: newcameraposition,
      zoom: 16.999,
      tilt: 40,
      bearing: -1000,
    );
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

    print("from marker");
    print("____________");
    print(position);
    // print("____________");
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
    // maxcontroller.picklocation('No Destination was seleced');
  }

  //search
  bool isSearchingLocation = false;

  void setisSearchingLocation(bool value) {
    setState(() {
      isSearchingLocation = value;
    });
  }

  void selectedLocationFromSearch(LatLng position) {
    setState(() {
      _placedMarkerLocation = position;
      cameraposition = CameraPosition(
        target: position,
        zoom: 16.999,
        tilt: 40,
        bearing: 985,
      );
      _newgooglemapcontroller!.animateCamera(
          CameraUpdate.newCameraPosition(cameraposition as CameraPosition));
    });
  }

  void drawRoutes(String polylincecode) {
    PolylinePoints polylinepoints = PolylinePoints();

    List<PointLatLng> decodePolylinesResultPoint =
        polylinepoints.decodePolyline(polylincecode);
    plineCoordinates.clear();

    if (decodePolylinesResultPoint.isNotEmpty) {
      decodePolylinesResultPoint.forEach((PointLatLng points) {
        plineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }

    _polyline.cast();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polylineId'),
        color: Colors.pink,
        jointType: JointType.round,
        points: plineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polyline.add(polyline);
    });

    LatLngBounds latlngbounds;

    LatLng pick = LatLng(maxcontroller.pickuplocation.value.latitude as double,
        maxcontroller.pickuplocation.value.longitude as double);
    LatLng drop = LatLng(maxcontroller.dropofflocation.value.latitude as double,
        maxcontroller.dropofflocation.value.longitude as double);

    if (pick.latitude > drop.longitude && pick.longitude > drop.longitude) {
      latlngbounds = LatLngBounds(southwest: drop, northeast: pick);
    } else if (pick.longitude > drop.longitude) {
      latlngbounds = LatLngBounds(
          southwest: LatLng(pick.latitude, drop.longitude),
          northeast: LatLng(drop.latitude, pick.longitude));
    } else if (pick.latitude > drop.latitude) {
      latlngbounds = LatLngBounds(
          southwest: LatLng(drop.latitude, pick.longitude),
          northeast: LatLng(pick.latitude, drop.longitude));
    } else {
      latlngbounds =
          latlngbounds = LatLngBounds(southwest: pick, northeast: drop);
    }

    _newgooglemapcontroller!
        .animateCamera(CameraUpdate.newLatLngBounds(latlngbounds, 70));
  }

  void setPolyLine(List<PointLatLng> points, LatLng sw, LatLng ne) {
    String polylineIdVal = "polyline_id${_polylincecounter}";
    _polyline.clear();
    setState(() {
      _polylincecounter++;
      _polyline.add(
        Polyline(
            polylineId: PolylineId(polylineIdVal),
            width: 5,
            color: Colors.blue,
            points:
                points.map((e) => LatLng(e.latitude, e.longitude)).toList()),
      );
    });

    // LatLngBounds latlngbounds;
    // LatLng pick = ne;
    // LatLng drop = sw;
    // if (pick.latitude > drop.longitude && pick.longitude > drop.longitude) {
    //   latlngbounds = LatLngBounds(southwest: drop, northeast: pick);
    // } else if (pick.longitude > drop.longitude) {
    //   latlngbounds = LatLngBounds(
    //       southwest: LatLng(pick.latitude, drop.longitude),
    //       northeast: LatLng(drop.latitude, pick.longitude));
    // } else if (pick.latitude > drop.latitude) {
    //   latlngbounds = LatLngBounds(
    //       southwest: LatLng(drop.latitude, pick.longitude),
    //       northeast: LatLng(pick.latitude, drop.longitude));
    // } else {
    //   latlngbounds =
    //       latlngbounds = LatLngBounds(southwest: pick, northeast: drop);
    // }

    _newgooglemapcontroller!
        .animateCamera(CameraUpdate.newLatLngBounds(LatLngBounds(southwest: ne, northeast: sw), 35));
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
                  fit: StackFit.expand,
                  children: [
                    GoogleMap(
                      padding: EdgeInsets.only(top: 70, bottom: 5, left: 5),
                      mapType: MapType.hybrid,
                      initialCameraPosition: cameraposition as CameraPosition,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      polylines: _polyline,
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
                    ),
                    if (requestformstate == RequestTricycleState.picklocation)
                      Search(
                        passcontext: context,
                        setisSearchingLocation: setisSearchingLocation,
                        selectedLocationFromSearch: selectedLocationFromSearch,
                      ),
                  ],
                ),
              ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          reverseDuration: Duration(milliseconds: 200),
          child: isSearchingLocation ? Container() : requestformBuilder(),
        ),

        // Maketricyclerequest(),
      ],
    );
  }

  Widget requestformBuilder() {
    if (requestformstate == RequestTricycleState.picklocation) {
      //hide if the user search
      if (!isSearchingLocation) {
        return Firststep(
          backToStartRequest: backToStartRequest,
          drawRoutes: setPolyLine,
        );
      }
    }
    return Maketricyclerequest(
      startRequest: startRequest,
    );
  }
}
