import 'package:google_maps_flutter/google_maps_flutter.dart';

class Availabledriver {

  String? id;
  String? device_token;
  String? status;
  LatLng? driver_location;


  Availabledriver({
    this.id,
    this.device_token,
    this.status,
    this.driver_location,
  });

  factory Availabledriver.fromJson(Map<String, dynamic> json){

    LatLng driverlocation  = LatLng(checkDouble(json['driver_location']['latitude']), json['driver_location']['longitude']);
    Availabledriver availabledriver = Availabledriver();

    availabledriver.id = json['driver_id'];
    availabledriver.device_token = json['device_token'];
    availabledriver.status = json['status'];
    availabledriver.driver_location = driverlocation;
    return availabledriver;
  }


  


static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }

}
