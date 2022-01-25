import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/helper/Geofirehelper.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/model/nearbydriver.dart';
import 'package:tricycleapp/widgets/map/checkrequest.dart';
import 'package:tricycleapp/widgets/map/firststep.dart';
import 'package:tricycleapp/widgets/map/maketricyclerequest.dart';
import 'package:tricycleapp/widgets/map/search.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:rxdart/rxdart.dart';

enum MapSelected { normal, satelite, hybrid }

enum RequestTricycleState { start, picklocation, checkrequest, sendrequest }

class HomeScreen extends StatefulWidget {
  static const screenName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //prepairing map

  var maxcontroller = Get.find<Mapcontroller>();
  Completer<GoogleMapController> _googlemapcontroller = Completer();
  GoogleMapController? _newgooglemapcontroller;
  Position? currentPosition;
  CameraPosition? cameraposition;
  bool isMapReady = false;
  Position? markerPosition;
  List<LatLng> plineCoordinates = [];
  Set<Polyline> polyline = {};

  Set<Marker> markerSet = {};


bool isnearAvailableDriverKeysReaload = true;


  
  int _polylincecounter = 1;
  void setMapCameraInitialValue() async {
    var mapisready =  await maxcontroller.setMapCameraInitialValue();  
    setMapIsReady(mapisready);
    cameraposition = maxcontroller.cameraposition;
    
  }


void setMapIsReady(bool value) {
    setState(() {
      isMapReady = value;
    });
  }
  

  void _moveMapCameraToCurrentPosition() async {
    var loccationpermisiion = await maxcontroller.requestLocationPermision();
    if(loccationpermisiion){
      cameraposition = await maxcontroller.moveMapCameraToCurrentPosition();
    initGeoFireListener();
    print('inithey');
     }
    _newgooglemapcontroller!.animateCamera(CameraUpdate.newCameraPosition(cameraposition as CameraPosition));
   
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
    // maxcontroller.picklocation('No Destination was seleced');
  }

  void prepairrequest() {
    setRequestState(RequestTricycleState.checkrequest);
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

    polyline.clear();
    setState(() {
      Polyline polylines = Polyline(
        polylineId: PolylineId('polylineId'),
        color: Colors.pink,
        jointType: JointType.round,
        points: plineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polyline.add(polylines);
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
    polyline.clear();
    setState(() {
      _polylincecounter++;
      polyline.add(
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

    _newgooglemapcontroller!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: ne, northeast: sw), 35));
  }

  void clearPolyLines() {
    setState(() {
      polyline = {};
    });
  }

  String field = 'position';

 
  void initGeoFireListener() async {

    currentPosition = maxcontroller.currentPosition;
  print('___________');    


    Geofire.initialize('availableDrivers');

    Geofire.queryAtLocation(currentPosition!.latitude, currentPosition!.longitude, 15)!.listen((map) {
        print(map);
        if (map != null) {
          var callBack = map['callBack'];

          //latitude will be retrieved from map['latitude']
          //longitude will be retrieved from map['longitude']

          switch (callBack) {
            case Geofire.onKeyEntered:
            Nearbydriver neardriver = Nearbydriver();
            neardriver.key = map["key"];
            neardriver.latitude = map["latitude"];
            neardriver.longitude = map["longitude"];
            Geofirehelper.nearbydrivercollection.add(neardriver);
            if(isnearAvailableDriverKeysReaload == true){
              updateAvailableDriver();
            }
             // keysRetrieved.add(map["key"]);
              break;

            case Geofire.onKeyExited:
            Geofirehelper.removeDriverFromList(map["key"]);
             // keysRetrieved.remove(map["key"]);
            updateAvailableDriver();
              break;

            case Geofire.onKeyMoved:
              Nearbydriver neardriver = Nearbydriver();
            neardriver.key = map["key"];
            neardriver.latitude = map["latitude"];
            neardriver.longitude = map["longitude"];
            Geofirehelper.updateDriverNearByLocation(neardriver);
            updateAvailableDriver();
            // Update your key's location
              break;

            case Geofire.onGeoQueryReady:
            // All Intial Data is loaded
           // print(map['result'])
                updateAvailableDriver();
              break;
          }
        }

        setState(() {});

    });

  }

  void updateAvailableDriver(){
    setState(() {
      
      markerSet.clear();

    });

    Set<Marker> tmarker = Set<Marker>();

    for(Nearbydriver driver in Geofirehelper.nearbydrivercollection){

      LatLng driverpostition  = LatLng(driver.latitude as double, driver.longitude as double);

      Marker marker =  Marker(
        markerId: MarkerId("driver${driver.key}"),
        position: driverpostition,
        icon: nearByIcon as BitmapDescriptor,
        rotation: Geofirehelper.createRandomNumber(360),

         );

         tmarker.add(marker);

    }

    setState(() {
      markerSet = tmarker;
    });
  }


  BitmapDescriptor? nearByIcon;

  void creatIconsMarker(){

    if(nearByIcon == null){
      ImageConfiguration imageconfigiration =   createLocalImageConfiguration(context, size:Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageconfigiration, "assets/images/car_android.png").then((value) {
        nearByIcon = value;
      });
    }
  }


  @override
  void initState() {
    super.initState();

    setMapCameraInitialValue();
  }

  @override
  Widget build(BuildContext context) {

    creatIconsMarker();

    return Column(
      children: [
        if (requestformstate == RequestTricycleState.start)
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                      polylines: polyline,
                      onMapCreated: (GoogleMapController mapcontroller) {
                        _googlemapcontroller.complete(mapcontroller);
                        _newgooglemapcontroller = mapcontroller;
                        _moveMapCameraToCurrentPosition();
                      },
                      onTap:
                          requestformstate == RequestTricycleState.picklocation
                              ? placeMarker
                              : null,
                      markers: markerSet
                          //Set<Marker>.of(markers.values) ,
                          // requestformstate == RequestTricycleState.start
                          //     ? {}
                          //     : _placedMarkerLocation == null
                          //         ? {}
                          //         : {
                          //             Marker(
                          //                 markerId: MarkerId('m1'),
                          //                 position:
                          //                     _placedMarkerLocation as LatLng)
                          //           },
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
          duration: Duration(milliseconds: 400),
          reverseDuration: Duration(milliseconds: 400),
          child: isSearchingLocation ? Container() : requestformBuilder(),
        ),
      ],
    );
  }

  Widget requestformBuilder() {
    if (requestformstate == RequestTricycleState.start) {
      return Maketricyclerequest(
        startRequest: startRequest,
      );
    } else if (requestformstate == RequestTricycleState.picklocation) {
      //hide if the user search
      if (!isSearchingLocation) {
        return Firststep(
          setRequestState: setRequestState,
          setPolyLine: setPolyLine,
          clearPolylines: clearPolyLines,
        );
      }
    } else if (requestformstate == RequestTricycleState.checkrequest) {
      return Checkrequest(
        setRequestState: setRequestState,
        setPolyLine: setPolyLine,
        clearPolylines: clearPolyLines,
      );
    }

    return Maketricyclerequest(
      startRequest: startRequest,
    );
  }
}
