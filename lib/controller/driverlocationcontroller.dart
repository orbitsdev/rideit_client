import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';

class Driverlocationcontroller extends GetxController{

  
LatLng? pickuplocation;
Marker? pickupmarker;
Marker? drivermarker;
LatLng? driverpostion;
CameraPosition? currentCamerapositon;



void getLiveDriverPosition() async{

  driverlocationstream!.listen((event) { 
    if(event.data() != null){
      var data =  event.data() as Map;

      print('_________driver location');

      driverpostion  = LatLng(data['driver_location']['latitude'], data['driver_location']['longitude']);
      // print(data['driver_location']['latitude']);
      // print(data['driver_location']['longitude']);
      print(driverpostion);

    }    
  });

      print('_________driver location outlside listener');
      print(driverpostion);


}









}