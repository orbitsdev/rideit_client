import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleapp/controller/driverlocationcontroller.dart';

class DriverLocationScreen extends StatefulWidget {

  static const screenName = "/showdriverlocation";

  @override
  _DriverLocationScreenState createState() => _DriverLocationScreenState();
}

class _DriverLocationScreenState extends State<DriverLocationScreen> {

    var requestxcontroller = Get.put(Driverlocationcontroller());

    Completer<GoogleMapController> _googlemapcontroller = Completer();
    GoogleMapController? _newgooglemapcontroller;

     static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);



@override
void initState() {
  
  
  super.initState();  

  requestxcontroller.getLiveDriverPosition();


}


@override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);

    }
    // TODO: implement setState
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Location'),
      ),
      body: Stack(
        
        children: [
          
          GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kLake,
        onMapCreated: (GoogleMapController mapcontroller) {

          if(!_googlemapcontroller.isCompleted){     
            _googlemapcontroller.complete(mapcontroller);
            _newgooglemapcontroller = mapcontroller;

          }
          // if (!_googlmapcompleter.isCompleted) {
          //             _googlmapcompleter.complete(mapcontroller);
          //             _newgooglemapcontroller = mapcontroller;
          //             _moveCameraToCurrentPostion();
          //           }
          // _googlemapcontroller.complete(controller);
        },
      ),


        ],
      ),
    );
  }
}