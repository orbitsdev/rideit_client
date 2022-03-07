import 'package:get/get_connect/http/src/request/request.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class RequestDetails {

  String? pick_location_id;
  String? drop_location_id;
  LatLng? pick_location;
  LatLng? drop_location;
  String? pickaddress_name;
  String? dropddress_name;
  String? passenger_name;
  String? passenger_phone;
  LatLng? actualmarker_position;
  String? status;
  String? tripstatus;
  String? device_token;
  String? created_at;
  
  
  RequestDetails({
    this.pick_location_id,
    this.drop_location_id,
    this.pick_location,
    this.drop_location,
    this.pickaddress_name,
    this.dropddress_name,
    this.passenger_name,
    this.passenger_phone,
    this.actualmarker_position,
    this.status,
    this.tripstatus,
    this.device_token,
    this.created_at,
  });
  
  factory RequestDetails.fromJson(Map<String, dynamic> json){
  
    LatLng picklocation = LatLng(checkDouble(json['pick_location']['latitude']), checkDouble(json['pick_location']['longitude']));
    LatLng droplocation = LatLng(checkDouble(json['drop_location']['latitude']), checkDouble(json['drop_location']['longitude']));
    LatLng actualmarker = LatLng(checkDouble(json['actualmarker_position']['latitude']), checkDouble(json['actualmarker_position']['longitude']));

    RequestDetails requestdetails = RequestDetails();
     requestdetails.pick_location_id = json['pick_location_id'];
     requestdetails.drop_location_id = json['drop_location_id'];
     requestdetails.pick_location =picklocation;
     requestdetails.drop_location = droplocation;
     requestdetails.pickaddress_name = json['pickaddress_name'];
     requestdetails.dropddress_name = json['dropddress_name'];
     requestdetails.passenger_name = json['passenger_name'];
     requestdetails.passenger_phone = json['passenger_phone'];
     requestdetails.actualmarker_position = actualmarker;
     requestdetails.status = json['status'];
     requestdetails.tripstatus = json['tripstatus'];
     requestdetails.device_token = json['device_token'];
     requestdetails.created_at = json['created_at'];
    return requestdetails;  

  }


  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }

  
}
