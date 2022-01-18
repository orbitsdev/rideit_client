import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleapp/config/mapconfig.dart';
import 'package:tricycleapp/model/directiondetails.dart';
import 'package:tricycleapp/model/directiontwo.dart';
import 'package:tricycleapp/model/placeaddress.dart';
import 'package:tricycleapp/model/prediction_place.dart';
import 'package:tricycleapp/services/mapservices.dart';

class Mapcontroller extends GetxController {
  var placeprediction = [].obs;
  var isaddresloading = false.obs;
  var isfetching = false.obs;
  var issettingnewmarker = false.obs;
  var isPrepairingDetails = false.obs;

  var dropofflocation = Placeaddress().obs;
  var pickuplocation = Placeaddress().obs;
  var routedirection = Directiondetails().obs;
  var routedirectiontwo = Directiontwo().obs;

  LatLng? markerPositon;

  Future<bool> prepairRequestDetails() async {
    var isrouteset;
    isPrepairingDetails(true);
    Position getposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng userposition = LatLng(getposition.latitude, getposition.longitude);

    var ispicklocationready = await getcurrentLocation(userposition);
    if (ispicklocationready) {
      isrouteset = await getroutedirection();
    }

    if (isrouteset) {
      print('______');
      print('nice ');
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
      var newmarkerpostion = LatLng(currentaddress.latitude as double,
          currentaddress.longitude as double);
      pickuplocation(currentaddress);

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
        "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:${pickuplocation.value.placeid}&destination=place_id:${dropofflocation.value.placeid}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    var response = await Mapservices.mapRequest(url);

    if (response == "failed") {
      isPrepairingDetails(false);
      return false;
    }

    var boundne = response['routes'][0]['bounds']['northeast'];
    var boundswe = response['routes'][0]['bounds']['southwest'];
    var startlocations = response['routes'][0]['legs'][0]['start_location'];
    var endlocation = response['routes'][0]['legs'][0]['end_location'];

    Directiontwo directiontwo = Directiontwo();
    directiontwo.bound_ne = LatLng(boundne['lat'], boundne['lng']);
    directiontwo.bound_sw = LatLng(boundswe['lat'], boundswe['lng']);
    directiontwo.startlocation =
        LatLng(startlocations['lat'], startlocations['lng']);
    directiontwo.endlocation = LatLng(endlocation['lat'], endlocation['lng']);
    directiontwo.polylines =
        response['routes'][0]['overview_polyline']['points'];
    directiontwo.polylines_encoded = PolylinePoints()
        .decodePolyline(response['routes'][0]['overview_polyline']['points']);
    // Directiondetails directiondetails = Directiondetails();
    // directiondetails.distanceText =
    //     response['routes'][0]['legs'][0]['distance']['text'];
    // directiondetails.distanceValue =
    //     response['routes'][0]['legs'][0]['distance']['value'];
    // directiondetails.durationText =
    //     response['routes'][0]['legs'][0]['duration']['text'];
    // directiondetails.durationValue =
    //     response['routes'][0]['legs'][0]['duration']['value'];
    // directiondetails.encodePoints =
    //     response['routes'][0]['overview_polyline']['points'];

    // routedirection = directiondetails.obs;

    // print('___________ polylines');
    // print(routedirection.value.distanceText);
    // print(routedirection.value.distanceValue);
    // print(routedirection.value.durationText);
    // print(routedirection.value.durationValue);

    // print('___________ polylines');
    // print(routedirection.value.encodePoints);
    routedirectiontwo = directiontwo.obs;

    print('__________ route');
    print(routedirectiontwo.value.bound_ne);
    print(routedirectiontwo.value.bound_sw);
    print(routedirectiontwo.value.startlocation);
    print(routedirectiontwo.value.endlocation);
    print(routedirectiontwo.value.polylines);
    print(routedirectiontwo.value.polylines_encoded);
    isPrepairingDetails(false);

    return true;
  }
}
