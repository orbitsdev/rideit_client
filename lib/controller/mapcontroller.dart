import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleapp/config/mapconfig.dart';
import 'package:tricycleapp/services/mapservices.dart';

class Mapcontroller extends GetxController {
  var currentaddress;
  var picklocation = 'No Destination was seleced'.obs;
  var isaddresloading = false.obs;
  void currentAddressCoorDinate(LatLng position) async {
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    var response = await Mapservices.mapRequest(url);
    var data = response['results'][0];
    currentaddress = data['formatted_address'];
    picklocation = 'No Destination was seleced'.obs;
  }

  void placeMarkerAddressCoordinate(LatLng position) async {
    isaddresloading(true);
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Mapconfig.GOOGLE_MAP_API_KEY}";
    var response = await Mapservices.mapRequest(url);

    isaddresloading(false);
    var data = response['results'][0];
    String address = data['formatted_address'];
    picklocation = address.obs;
    print('______________');
    print(currentaddress);
    print('______________');
    print(picklocation);
  }
}
