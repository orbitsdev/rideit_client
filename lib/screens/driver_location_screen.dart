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

    var driverxcontroller = Get.put(Driverlocationcontroller());
    CameraPosition? drivercameraposition;
    Marker? drivermarker;
  
    Completer<GoogleMapController> _googlemapcontroller = Completer();
    GoogleMapController? _newgooglemapcontroller;
    Set<Marker> markerSet = {};
     static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  
        bool isMapReady = false;
        BitmapDescriptor? nearTricycleIcon;
    
        

@override
void initState() {
  super.initState();
  setCameraInitialValue();

  //driverxcontroller.getLiveDriverPosition();
}

setCameraInitialValue() async {
    var mapIsReady = await driverxcontroller.setMapCameraInitialValue();
    drivercameraposition = driverxcontroller.drivercameraposition as CameraPosition;

    if (mapIsReady) {
       setMapIsReady(mapIsReady);
    }
  }


void setMapIsReady(bool value){
  setState(() {
    isMapReady = value;
  });
}
void _moveCameraToDriverPostion() async {
    drivercameraposition = await driverxcontroller.getDriverCamerapostion();
    print(driverxcontroller.driverpostion);

    
        drivermarker = Marker(
        markerId: MarkerId('dropmarker'),
        position: driverxcontroller.driverpostion as LatLng,
        icon: nearTricycleIcon as BitmapDescriptor);

        
        setState(() {
          markerSet.add(drivermarker as Marker);
        });


        _newgooglemapcontroller!.animateCamera(
        CameraUpdate.newCameraPosition(drivercameraposition as CameraPosition, ), );

        
}






@override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);

    }
    // TODO: implement setState
  }

  void createCustomMarker() {
    if (nearTricycleIcon == null) {
      ImageConfiguration imageconfiguration =
          createLocalImageConfiguration(context, size: Size(12, 12));
      BitmapDescriptor.fromAssetImage(
              imageconfiguration, "assets/images/Motorcycle_8.png")
          .then((value) {
        nearTricycleIcon = value;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
createCustomMarker();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Location'),
      ),
      body: isMapReady ==false ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ): 
       Stack(
        
        children: [
          
          GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: drivercameraposition as CameraPosition,
        markers: markerSet,
        onMapCreated: (GoogleMapController mapcontroller) {

          if(!_googlemapcontroller.isCompleted){     
            _googlemapcontroller.complete(mapcontroller);
            _newgooglemapcontroller = mapcontroller;
            _moveCameraToDriverPostion();

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