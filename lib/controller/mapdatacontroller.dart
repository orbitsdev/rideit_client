import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/config/mapconfig.dart';
import 'package:tricycleapp/controller/requestdatacontroller.dart';
import 'package:tricycleapp/dialog/authdialog/authdialog.dart';
import 'package:tricycleapp/dialog/failuredialog/failuredialog.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/dialog/mapdialog/mapdialog.dart';
import 'package:tricycleapp/model/direction_details.dart';
import 'package:tricycleapp/model/placeaddress.dart';
import 'package:tricycleapp/model/prediction_place.dart';
import 'package:tricycleapp/services/mapservices.dart';

class Mapdatacontroller extends GetxController {
  Position? currentPosition;
  CameraPosition? cameraPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  LatLng? position;

  var pickuplocationDetails = Placeaddress().obs;
  var droplocationDetails = Placeaddress().obs;
  var directionDetails = DirectionDetails().obs;
  String paymentmethod = 'null';

  LatLng? lastropmarkerposition;
  LatLng? actualdropmarkerposition;

  
  void clearRequestForm() {
    
    pickuplocationDetails(Placeaddress());
    droplocationDetails(Placeaddress());
    directionDetails(DirectionDetails());
    lastropmarkerposition = null;
    actualdropmarkerposition =  null;
    paymentmethod = 'null';
  }

  Future<bool> prepaireRoute(BuildContext context) async {
    lastropmarkerposition = actualdropmarkerposition;
    var response = await gelocationDetailsandSetRoutDeriction(context);
    if (response) {
      return true;
    } else {
      return false;
    }
  }

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
    actualdropmarkerposition = position;

    isdroploading(true);
    try {
      String url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
      var response = await Mapservices.mapRequest(url);
      if (response != 'failed') {
        var isDropSet =
            await setDropOffDetails(response['results'][0]['place_id']);
        if (isDropSet == false) {
          Infodialog.showToastCenter(
              Colors.black, ELSA_TEXT_WHITE, 'failed to set dropofflocation');
          isdroploading(false);
        }

        isdroploading(false);
      } else {
        Infodialog.showToastCenter(
            Colors.black, ELSA_TEXT_WHITE, 'failed to get location details');
      }
    } catch (e) {
      isdroploading(false);
    }
  }

  //dropaddress set

  Future<bool> setDropDetailFromSearch(String placeid) async {
    isdroploading(true);
    var response = await setDropOffDetails(placeid);

    if (response) {

       actualdropmarkerposition = dropmarkerposition as LatLng;
      isdroploading(false);
      
      return true;
    } else {
      isdroploading(false);
      return false;
    }
  }

  LatLng? dropmarkerposition;
  Future<bool> setDropOffDetails(String placeid) async {
    bool isDropSet = false;

    var response = await placeDetails(placeid);
    if (response != 'failed') {
      droplocationDetails(Placeaddress.fromJson(response['result']));
      dropmarkerposition = LatLng(droplocationDetails.value.latitude as double, droplocationDetails.value.longitude as double);
          

      isDropSet = true;
    } else {
      Infodialog.showToastCenter(Colors.black, ELSA_TEXT_WHITE,
          'failed to get dropoff location details');
      isDropSet = false;
    }

    return isDropSet;
  }

  Future<dynamic> placeDetails(String placeid) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?&place_id=${placeid}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    var response;
    try {
      response = await Mapservices.mapRequest(url);
    } catch (e) {
      isdroploading(false);
      print(e.toString());
    }

    return response;
  }

  

  Future<bool> gelocationDetailsandSetRoutDeriction(
      BuildContext context) async {
    Mapdialog.showMapProgress(context, 'Prepairing location details');
    if (currentPosition == null) {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${currentPosition!.latitude},${currentPosition!.longitude}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    var response = await Mapservices.mapRequest(url);
    print(response['results'][0]['place_id']);
    var isSet = await setPickUplocation(response['results'][0]['place_id']);
    if (isSet) {
      Get.back();
      var isdirectionReady = await getDirection( context, pickuplocationDetails.value.placeid as String, LatLng(pickuplocationDetails.value.latitude as double , pickuplocationDetails.value.longitude as double), LatLng(droplocationDetails.value.latitude as double,droplocationDetails.value.longitude as double));
      if (isdirectionReady) {
        return true;
      } else {
        return false;
      }
    } else {
      Get.back();
      Infodialog.showToastCenter(Colors.black, ELSA_TEXT_WHITE,
          'failed to get pickup location details');
      return false;
    }
  }

  Future<bool> setPickUplocation(String placeid) async {
    bool isSet = false;
    var response = await placeDetails(placeid);
    if (response != 'failed') {
      pickuplocationDetails(Placeaddress.fromJson(response['result']));
      print(pickuplocationDetails.toJson());

      isSet = true;
    } else {
      isSet = false;
    }

    return isSet;
  }

  Future<bool> getDirection(
      BuildContext context, String origin_place_id,  LatLng currentlocation , LatLng destination) async {
    Mapdialog.showMapProgress(context, 'Prepairing direction details...');
    //String url = "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:${origin_place_id}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${currentlocation.latitude},${currentlocation.longitude}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    var response = await Mapservices.mapRequest(url);
    if (response != "failed") {
      print(response);
      directionDetails(DirectionDetails.fromJson(response));
      Get.back();
      return true;
    } else {
      Get.back();
      return false;
    }
  }

  String calculateFee() {
    int rate = Get.find<Requestdatacontroller>().publicdata.value.fee as int;
    int minimumratedistance = Get.find<Requestdatacontroller>().publicdata.value.minimum_km_basis as int;
    int distance = directionDetails.value.distanceValue as int;
    var km = distance / 1000;
    var fee_by_km = rate * km;

    if (km.round() <= minimumratedistance) {
      return rate.toString();
    } else {
      return fee_by_km.toStringAsFixed(0);
    }
  }

  var placeprediction = [].obs;
  var isfetching = false.obs;
  LatLng? dropOfMarker;
  void searchPlace(String placename) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placename}}&key=${Mapconfig.GOOGLE_MAP_API_KEY}&components=country:ph";

    isfetching(true);
    var response = await Mapservices.mapRequest(url);
    isfetching(false);

    if (response != "failed") {
      // print(response['predictions']);
      var prediction = response["predictions"];
      var placelist =
          (prediction as List).map((e) => PredictionPlace.fromJson(e)).toList();
      placeprediction = placelist.obs;
    }
  }
}
