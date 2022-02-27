import 'package:google_maps_flutter/google_maps_flutter.dart';

class Availabledriver {

  String? id;
  String? devicetoken;
  LatLng? location;


  Availabledriver({
    this.id,
    this.devicetoken,
    this.location,
  });

  factory Availabledriver.fromJson(Map<String, dynamic> json) {

    
    Availabledriver onlinedriver =  Availabledriver();
    onlinedriver.id = json['id'];
    onlinedriver.devicetoken = json['token'];
    onlinedriver.location = LatLng(json['driver_location']['latitude'], json['driver_location']['latitude']);

    return onlinedriver;

    
  }

}
