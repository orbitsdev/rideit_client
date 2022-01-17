import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleapp/config/mapconfig.dart';
import 'package:tricycleapp/model/placeaddress.dart';
import 'package:tricycleapp/model/prediction_place.dart';
import 'package:tricycleapp/services/mapservices.dart';

class Mapcontroller extends GetxController {
  var isaddresloading = false.obs;
  var placeprediction = [].obs;
  var isfetching = false.obs;
  var dropofflocation = Placeaddress().obs;
  LatLng? markerPositon;

  void currentAddressCoorDinate(LatLng position) async {
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    var response = await Mapservices.mapRequest(url);
    var data = response['results'][0];
    print(data['place_id']);

    //   picklocation = 'No Destination was seleced'.obs;
  }

  void placeMarkerAddressCoordinate(LatLng position) async {
    isaddresloading(true);
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    var response = await Mapservices.mapRequest(url);

    var data = response['results'][0];

    placeDetails(data['place_id']);
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

  void placeDetails(String placeid) async {
    if (isaddresloading == false) {
      isaddresloading(true);
    }

    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?&place_id=${placeid}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";

    var response = await Mapservices.mapRequest(url);
    isaddresloading(false);
    var data = response['result'];

    Placeaddress selectedaddress = Placeaddress();
    selectedaddress.placeformattedaddress = data['formatted_address'];
    selectedaddress.placeName = data['name'];
    selectedaddress.placeid = placeid;
    selectedaddress.latitude = data['geometry']['location']['lat'];
    selectedaddress.longitude = data['geometry']['location']['lng'];

    markerPositon = LatLng(selectedaddress.latitude as double,
        selectedaddress.longitude as double);

    dropofflocation(selectedaddress);
    print(markerPositon);
    print('_________selecteddress details');
    print(dropofflocation.value.placeformattedaddress);
    print(dropofflocation.value.placeName);
    print(dropofflocation.value.placeid);
    print(dropofflocation.value.latitude);
    print(dropofflocation.value.longitude);
  }
}
