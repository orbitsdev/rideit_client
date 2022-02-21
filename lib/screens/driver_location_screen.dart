import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleapp/controller/driverlocationcontroller.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';

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

void getLiveDriverPosition(){
   bool isChanging =false;

  if(driverxcontroller.driverpostion != null){
      driverstream =  driverlocationstream!.listen((event) {
      if (event.data() != null) {
        var data = event.data() as Map<String, dynamic>;
        driverxcontroller.driverpostion = LatLng(data['driver_location']['latitude'], data['driver_location']['longitude']);
        print( '______newmarker');
        print(driverxcontroller.driverpostion);
        setDriverMarkerToNewPosition(driverxcontroller.driverpostion as LatLng);
        isChanging =true;
        
      }
    });

   
    }

}
        

@override
void initState() {
  super.initState();
  setCameraInitialValue();

  
}

setCameraInitialValue() async {
    var mapIsReady = await driverxcontroller.setMapCameraInitialValue();
    drivercameraposition = driverxcontroller.drivercameraposition as CameraPosition;
     getLiveDriverPosition();

    if (mapIsReady) {
       setMapIsReady(mapIsReady);
      
    }
  }


void setMapIsReady(bool value){
  setState(() {
    isMapReady = value;
  });
}

void setDriverMarkerToNewPosition(LatLng newdriverpostion){
        print("called");
        drivermarker = Marker(
        markerId: MarkerId('dropmarker'),
        position: newdriverpostion,
        icon: nearTricycleIcon as BitmapDescriptor);

        
        setState(() {
          markerSet.add(drivermarker as Marker);
        });



}
void _moveCameraToDriverPostion() async {
    drivercameraposition = await driverxcontroller.getDriverCamerapostion();
    print(driverxcontroller.driverpostion);

  setDriverMarkerToNewPosition(driverxcontroller.driverpostion as LatLng);

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

  @override
  void dispose() {
    // TODO: implement dispose
    
    if(driverstream != null){
      driverstream!.cancel();
    }
    super.dispose();
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
        onMapCreated: (GoogleMapController mapcontroller) async {

          if(!_googlemapcontroller.isCompleted){     
            _googlemapcontroller.complete(mapcontroller);
            _newgooglemapcontroller = mapcontroller;
            _moveCameraToDriverPostion();
            
             getLiveDriverPosition();
                
          }
         
        },
      ),
 Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Container(
              color: Get.theme.primaryColor,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(onPressed: (){
                    
                    Get.back();
                  }, child: Text('x')),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}