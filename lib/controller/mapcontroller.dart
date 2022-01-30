import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleapp/config/mapconfig.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/model/direction_details.dart';
import 'package:tricycleapp/model/directiondetails.dart';
import 'package:tricycleapp/model/placeaddress.dart';
import 'package:tricycleapp/model/prediction_place.dart';
import 'package:tricycleapp/services/mapservices.dart';

class Mapcontroller extends GetxController {

  var userFromAuthcontroller = Get.find<Authcontroller>().user;

  var placeprediction = [].obs;
  var isaddresloading = false.obs;
  var isfetching = false.obs;
  var issettingnewmarker = false.obs;
  var isPrepairingDetails = false.obs;

  var dropofflocation = Placeaddress().obs;
  var pickuplocation = Placeaddress().obs;
  String? lastpickedlocation;

  var routedirectiondetails = DirectionDetails().obs;
  Position? currentPosition;
  CameraPosition? cameraposition;
  LatLng? markerPositon;

  Future<bool> setMapCameraInitialValue() async {

    bool? isMapIsReady;
    
    var localpermission = await requestLocationPermision();
    if(localpermission){
        currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          
       String? getinitialpositionString = currentPosition!.latitude.toString() + currentPosition!.longitude.toString();
        cameraposition = CameraPosition( target: LatLng(currentPosition!.latitude, currentPosition!.longitude), zoom:  16.500);

        if (getinitialpositionString.isNotEmpty) {
      isMapIsReady = true;

    } else {
      isMapIsReady = false;
    }

    }else{
      isMapIsReady = false;
    }

    return isMapIsReady;
     
   

     
   
  }

  Future<CameraPosition> moveMapCameraToCurrentPosition() async{
    
    currentPosition = await Geolocator.getCurrentPosition( desiredAccuracy: LocationAccuracy.best);
    LatLng newcameraposition =
        LatLng(currentPosition!.latitude, currentPosition!.longitude);
    cameraposition = CameraPosition(
      target: newcameraposition,
      zoom: 16.999,
      tilt: 40,
      bearing: -1000,
    );

    return cameraposition as CameraPosition;


  }

  Future<bool> requestLocationPermision() async{
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

  Future<bool> prepairRequestDetails() async {
    var isrouteset;
    isPrepairingDetails(true);
    progressDialog('Getting current location');
    Position getposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
      Get.back();  

     progressDialog('Setting up pickup location');
    LatLng userposition = LatLng(getposition.latitude, getposition.longitude);
    var ispicklocationready = await getcurrentLocation(userposition);
    Get.back();
    if (ispicklocationready) {
      progressDialog('Prepairing route');
      isrouteset = await getroutedirection();
      
      Get.back();
    }

    if (isrouteset) {
      print('______');
      print('nice ');
      lastpickedlocation  = dropofflocation.value.placeid;
      calculateFee();
     
      return true;
    } else {
      print('______');
      print('sad ');
      return false;
    }

    // getcurrentLocation(userposition);
  }

  Future<bool> getcurrentLocation(LatLng position) async {
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    var response = await Mapservices.mapRequest(url);
    var data = response['results'][0];
    var isset = await setPickUplocation(data['place_id']);

    if (isset == true) {
      return true;
    } else {
      return false;
    }

    //   picklocation = 'No Destination was seleced'.obs;
  }

  Future<bool> setPickUplocation(String placeid) async {
    var response = await placeDetails(placeid);
    var data = response['result'];

    if (response == "failed") {
      return false;
    } else {
      Placeaddress currentaddress = Placeaddress();
      currentaddress.placeformattedaddress = data['formatted_address'];
      currentaddress.placeName = data['name'];
      currentaddress.placeid = placeid;
      currentaddress.latitude = data['geometry']['location']['lat'];
      currentaddress.longitude = data['geometry']['location']['lng'];
      var newmarkerpostion = LatLng(currentaddress.latitude as double, currentaddress.longitude as double); pickuplocation(currentaddress);

      print('_________pickuplocation details');
      print(pickuplocation.value.placeformattedaddress);
      print(pickuplocation.value.placeName);
      print(pickuplocation.value.placeid);
      print(pickuplocation.value.latitude);
      print(pickuplocation.value.longitude);

      return true;
    }
  }

  void placeMarkerAddressCoordinate(LatLng position) async {
    isaddresloading(true);
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    var response = await Mapservices.mapRequest(url);
    var data = response['results'][0];
    setDropOffLocationFromSearch((data['place_id']));
  }

  void searchPlace(String placename) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placename}}&key=${Mapconfig.GOOGLE_MAP_API_KEY}&components=country:ph";
    isfetching(true);
    var response = await Mapservices.mapRequest(url);
    isfetching(false);
    if (response["status"] == "OK") {
      var prediction = response["predictions"];

      var placelist =
          (prediction as List).map((e) => PredictionPlace.fromJson(e)).toList();

      placeprediction = placelist.obs;
    }
  }

  Future<dynamic> placeDetails(String placeid) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?&place_id=${placeid}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";

    var response = await Mapservices.mapRequest(url);

    return response;
  }

  Future<bool> setDropOffLocationFromSearch(String placeid) async {
    if (isaddresloading == false) {
      isaddresloading(true);
    }
    issettingnewmarker(true);
    var response = await placeDetails(placeid);

    var data = response['result'];
    if (response['status'] == "OK") {
      Placeaddress selectedaddress = Placeaddress();
      selectedaddress.placeformattedaddress = data['formatted_address'];
      selectedaddress.placeName = data['name'];
      selectedaddress.placeid = placeid;
      selectedaddress.latitude = data['geometry']['location']['lat'];
      selectedaddress.longitude = data['geometry']['location']['lng'];
      var newmarkerpostion = LatLng(selectedaddress.latitude as double,
          selectedaddress.longitude as double);

      dropofflocation(selectedaddress);
      

      setNewMarker(newmarkerpostion);
      isaddresloading(false);

      print('_________dropoff details');
      print(dropofflocation.value.placeformattedaddress);
      print(dropofflocation.value.placeName);
      print(dropofflocation.value.placeid);
      print(dropofflocation.value.latitude);
      print(dropofflocation.value.longitude);
      return true;
    } else {
      issettingnewmarker(true);

      return false;
    }
  }

  void setNewMarker(LatLng position) async {
    markerPositon = position;
    issettingnewmarker(false);
  }

  Future<bool> getroutedirection() async {
    LatLng picklocation = LatLng(pickuplocation.value.latitude as double,
        pickuplocation.value.longitude as double);
    LatLng droplocation = LatLng(dropofflocation.value.latitude as double,
        dropofflocation.value.longitude as double);

    //String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${picklocation.latitude},${picklocation.longitude}&destination=${droplocation.latitude},${droplocation.longitude}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:${pickuplocation.value.placeid}&destination=place_id:${dropofflocation.value.placeid}&mode=walking&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    var response = await Mapservices.mapRequest(url);

    if (response == "failed") {
      isPrepairingDetails(false);
      return false;
    }

    var boundne = response['routes'][0]['bounds']['northeast'];
    var boundswe = response['routes'][0]['bounds']['southwest'];
    var startlocations = response['routes'][0]['legs'][0]['start_location'];
    var endlocation = response['routes'][0]['legs'][0]['end_location'];

    DirectionDetails directiondetails = DirectionDetails();
    directiondetails.bound_ne = LatLng(boundne['lat'], boundne['lng']);
    directiondetails.bound_sw = LatLng(boundswe['lat'], boundswe['lng']);
    directiondetails.startlocation = LatLng(startlocations['lat'], startlocations['lng']);
    directiondetails.endlocation = LatLng(endlocation['lat'], endlocation['lng']);
    directiondetails.polylines =response['routes'][0]['overview_polyline']['points'];
    directiondetails.polylines_encoded = PolylinePoints().decodePolyline(response['routes'][0]['overview_polyline']['points']);
    directiondetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
    directiondetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];
    directiondetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
    directiondetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];
   
    routedirectiondetails = directiondetails.obs;


    print('__________ routedirection details');
    print(routedirectiondetails.value.bound_ne);
    print(routedirectiondetails.value.bound_sw);
    print(routedirectiondetails.value.startlocation);
    print(routedirectiondetails.value.endlocation);
    print(routedirectiondetails.value.polylines);
    print(routedirectiondetails.value.distanceText);
    print(routedirectiondetails.value.distanceValue);
    print(routedirectiondetails.value.durationText);
    print(routedirectiondetails.value.durationValue);
    isPrepairingDetails(false);


    print(response);

    return true;
  }

  void clearRequest(){
     
   dropofflocation = Placeaddress().obs;
   pickuplocation = Placeaddress().obs;
   routedirectiondetails = DirectionDetails().obs;
   lastpickedlocation = null;
   


   }


    int calculateFee(){

     double distanceTraveledFare;
     double totalfare;


     if(routedirectiondetails.value.distanceValue! < 2000 && routedirectiondetails.value.distanceValue! > 500 ){

          totalfare = 10.00;
     }else{
          distanceTraveledFare  = (routedirectiondetails.value.distanceValue! /1500) *10;
          totalfare = distanceTraveledFare;
     }

     double totaLocalAmount = totalfare ;
      print('duration');
      print(routedirectiondetails.value.durationValue);
      print('distance');
      print(routedirectiondetails.value.distanceValue);
      print('______fee');
      print(totaLocalAmount.truncate());
     return totaLocalAmount.truncate();
   }


   void senRequest() async{

      Map locationtopick ={
        "latitude": pickuplocation.value.latitude.toString(),
        "longitude": pickuplocation.value.longitude.toString(),
      };

      Map locationtodrop ={
        "latitude": dropofflocation.value.latitude.toString(),
        "longitude": dropofflocation.value.longitude.toString(),
      };

      print(userFromAuthcontroller.value.name);
      print(userFromAuthcontroller.value.email);
      print(userFromAuthcontroller.value.name);
  


      Map<String, dynamic> requestdata ={
        
        "driver_id": "null",
        "phone": userFromAuthcontroller.value.phone,
        "pickuplocation": locationtopick,
        "dropoflocation": locationtodrop,
        "status": "waiting",
        "created_at":  DateTime.now().toString(),
        "pickup_address":  pickuplocation.value.placeformattedaddress,
        "drop_address": dropofflocation.value.placeName,
      } ;


      print(requestdata);
        requestcollecctionrefference.doc(authinstance.currentUser!.uid).get().then((snapshot) {

          if(snapshot.exists){
              print(' you have 1 request pending. you can only send request 1 at a time. if you wish to creat new request cancel the pending request firest');
          }else{

             requestcollecctionrefference.doc(authinstance.currentUser!.uid).set(requestdata);  
          }

      });

   }

   void cancelRequest() async{

      
  
           requestcollecctionrefference.doc(authinstance.currentUser!.uid).delete().then((value) => print('deleted'));

   }

  double createRandomeNumber(int num){
  var random = Random();
  int randomNumber = random.nextInt(num);
  return randomNumber.toDouble();
}



}
