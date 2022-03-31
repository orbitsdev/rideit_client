import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleapp/controller/requestdatacontroller.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/model/availabledriver.dart';
import 'package:tricycleapp/model/neardriver.dart';

class Drivercontroller extends GetxController {
  var requesstxcontroller = Get.find<Requestdatacontroller>();
  LatLng? pickuplocation;
  Marker? pickupmarker;
  Marker? drivermarker;
  LatLng? driverpostion;
  CameraPosition? drivercameraposition;
  List<Availabledriver> availabledriver = [];

  

Future<bool> setMapCameraInitialValue() async {
    bool? isMapIsReady;

    await requestrefference.doc(authinstance.currentUser!.uid).collection('ongoingtrip').doc(authinstance.currentUser!.uid).get().then((value) {
    

    if(value.data() != null){
        var data =  value.data() as Map<String, dynamic>;
        double dlat =  checkDouble((data['pick_location']['latitude']));
        double dlng =  checkDouble((data['pick_location']['latitude']));
        print(data);
        
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


void monitorAvailableDriver() async {
  print('MONITORING AVAILABLE');
    List<String> testlist = [];
    availabledriversrefference
        .where('status', isEqualTo: 'online')
        .snapshots()
        .listen((qeurySnapShot) {
      if (qeurySnapShot.docs.length > 0) {
        requesstxcontroller.listofavailabledriver(qeurySnapShot.docs.map((e) {
          var data = e.data() as Map<String, dynamic>;
          data['driver_id'] = e.id;
          Availabledriver availabledriver = Availabledriver.fromJson(data);
          return availabledriver;
        }).toList());
       
      }

     requesstxcontroller.devicetokens.clear();
       if (requesstxcontroller.listofavailabledriver.length > 0) {
          requesstxcontroller.listofavailabledriver.forEach((element) {
            print(element.device_token);
            requesstxcontroller.devicetokens.add(element.device_token);
          });
        }

    
        

        print('AVAILABLE DRIVER ');
        print(requesstxcontroller.listofavailabledriver.length);
        print('AVAILABLE DRIVER TOKEN');
        print(requesstxcontroller.devicetokens);
    });
  }

}
