import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleapp/config/mapconfig.dart';
import 'package:tricycleapp/dialog/failuredialog/failuredialog.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/model/placeaddress.dart';
import 'package:tricycleapp/services/mapservices.dart';

class Mapdatacontroller extends GetxController {
  Position? currentPosition;
  CameraPosition? cameraPosition;
  LatLng? position;

  var droplocationDetails = Placeaddress().obs;


  Future<bool> setCameraPostionToMycurrenPostion() async {
    bool? isMapIsReady;

    var localpermission = await requestLocationPermision();
    if (localpermission) {
      try {
        currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        position =
            LatLng(currentPosition!.latitude, currentPosition!.longitude);
        cameraPosition = CameraPosition(
            target: position as LatLng, zoom: 16.999, tilt: 40, bearing: -1000);
        if (currentPosition != null) {
          isMapIsReady = true;
        } else {
          isMapIsReady = false;
        }
      } catch (e) {
        Infodialog.showToastCenter(Colors.black, Colors.white, e.toString());
        isMapIsReady = false;
      }
    } else {
      isMapIsReady = false;
    }

    return isMapIsReady as bool;
  }

  Future<bool> requestLocationPermision() async {
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
    return serviceEnabled;
  }

  var isdroploading = false.obs;

  void getDropOffLocation(LatLng position) async {
    isdroploading(true);
    try {
    

      String url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
      var response = await Mapservices.mapRequest(url);
      if (response != 'failed') {
        setDropOffDetails(response['results'][0]['place_id']);
      }

     
    } catch (e) {
      isdroploading(false);
    }
  }

  //dropaddress set
  
  void setDropOffDetails(String placeid) async {

   var response = await placeDetails(placeid);
    droplocationDetails(Placeaddress.fromJson(response['result']));
    isdroploading(false);
  }

  Future<dynamic> placeDetails(String placeid) async {
    String url =  "https://maps.googleapis.com/maps/api/place/details/json?&place_id=${placeid}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
      var response;
      try{
       response = await Mapservices.mapRequest(url);
        
      }catch(e){
        isdroploading(false);
        print(e.toString());  
      }

    return response;
  }

  void clearRequestForm(){
    
    droplocationDetails(Placeaddress());

  }
}
