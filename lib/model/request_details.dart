import 'package:get/get_connect/http/src/request/request.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class RequestDetails {


  //personal infromation
  String? passenger_name;
  String? passenger_phone;

  //location information
  String? pick_location_id;
  String? drop_location_id;
  String? pickaddress_name;
  String? dropddress_name;
  LatLng? pick_location;
  LatLng? drop_location;
  LatLng? actualmarker_position;

  //payment
  String? paymentmethod;
  int? fee;

  //additional important details that will be use for confrimation
  String? status;
  String? tripstatus;
  String? device_token;
  String? created_at;



  RequestDetails({
    this.passenger_name,
    this.passenger_phone,
    this.pick_location_id,
    this.drop_location_id,
    this.pick_location,
    this.drop_location,
    this.actualmarker_position,
    this.pickaddress_name,
    this.dropddress_name,
    this.paymentmethod,
    this.fee,
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
    requestdetails.passenger_name = json['passenger_name'];
    requestdetails.passenger_phone = json['passenger_phone'];
    requestdetails.pick_location_id = json['pick_location_id'];
    requestdetails.drop_location_id = json['drop_location_id'];
    requestdetails.pick_location = picklocation;
    requestdetails.drop_location = droplocation;
    requestdetails.actualmarker_position =actualmarker;
    requestdetails.pickaddress_name = json['pickaddress_name'];
    requestdetails.dropddress_name = json['dropddress_name'];
    requestdetails.paymentmethod = json['paymentmethod'];
    requestdetails.fee = json['fee'];
    requestdetails.status = json['status'];
    requestdetails.tripstatus = json['tripstatus'];
    requestdetails.device_token = json['device_token'];
    requestdetails.created_at = json['created_at'];
    return requestdetails;  

  }

  
  Map<String, dynamic> toJson() {

    Map<String, dynamic> picklocation = {
      'latitude': pick_location!.latitude,
      'longitude': pick_location!.longitude,
    };

    Map<String, dynamic> droplocation = {
      'latitude': drop_location!.latitude,
      'longitude': drop_location!.longitude,
    };

    Map<String, dynamic> actualmarker = {
      'latitude': actualmarker_position!.latitude,
      'longitude': actualmarker_position!.longitude,
    };

    return {
    'passenger_name':  passenger_name,
    'passenger_phone':     passenger_phone,
    'pick_location_id':     pick_location_id,
    'drop_location_id':     drop_location_id,
    'pick_location':     picklocation,
    'drop_location':     droplocation,
    'actualmarker_position':     actualmarker,
    'pickaddress_name':     pickaddress_name,
    'dropddress_name':     dropddress_name,
    'paymentmethod':     paymentmethod,
    'fee':     fee,
    'status':     status,
    'tripstatus':     tripstatus,
    'device_token':     device_token,
    'created_at':     created_at,
    };
    
  }


  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }

  
}
