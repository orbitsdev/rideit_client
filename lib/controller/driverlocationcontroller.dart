import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';

class Driverlocationcontroller extends GetxController {
  LatLng? pickuplocation;
  Marker? pickupmarker;
  Marker? drivermarker;
  LatLng? driverpostion;
  CameraPosition? drivercameraposition;

  

Future<bool> setMapCameraInitialValue() async {
    bool? isMapIsReady;

    await ongoingtriprefference.doc(authinstance.currentUser!.uid).get().then((value) {
    

    if(value.data() != null){
        var data =  value.data() as Map<String, dynamic>;
        double dlat =  checkDouble((data['pick_location']['latitude']));
        double dlng =  checkDouble((data['pick_location']['latitude']));
        print(data);
        pickuplocation = LatLng(double.parse(data['pick_location']['latitude']) ,double.parse(data['pick_location']['longitude']) );
        print('picllocation_____________');
        print(pickuplocation);
        driverpostion = LatLng(dlat,dlat);
        print('driverpostion________');
        print(driverpostion);

       drivercameraposition = CameraPosition(
      target: driverpostion as LatLng,
      zoom: 16.999,
      tilt: 40,
      bearing: -1000);
      isMapIsReady = true;
    }else{  
      isMapIsReady =false;
    }      
        
    });

    print('isdriverlocation ready __________before returning');
    print(isMapIsReady);


    return isMapIsReady as bool;

  }

  Future<bool> getLiveDriverPosition() async {
    
    bool isChanging =false;

    if(driverpostion != null){
      driverstream =  driverlocationstream!.listen((event) {
      if (event.data() != null) {
        var data = event.data() as Map;

        print('_________driver location');

       // print(data);

        driverpostion = LatLng(data['driver_location']['latitude'], data['driver_location']['longitude']);
        // driverpostion = LatLng(data['driver_location']['latitude'], data['driver_location']['longitude']);
        // print(data['driver_location']['latitude']);
        // print(data['driver_location']['longitude']);
        print(driverpostion);
        isChanging =true;
        print(isChanging);
      
      }
    });

   
    }
    
    return isChanging;
  }

 Future<CameraPosition> getDriverCamerapostion() async {
    drivercameraposition = CameraPosition(
      target: driverpostion as LatLng,
      zoom: 16.999,
      tilt: 40,
      bearing: -1000);

      return drivercameraposition as CameraPosition;


      
  }

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }



}
