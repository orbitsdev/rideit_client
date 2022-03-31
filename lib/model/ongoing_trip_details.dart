import 'package:google_maps_flutter/google_maps_flutter.dart';

class OngoingTripDetails {
  String? request_id;
  String? passenger_name;
  String? passenger_phone;
  String? passenger_image_url;

  String? pick_location_id;
  String? drop_location_id;
  String? pickaddress_name;
  String? dropddress_name;
  LatLng? pick_location;
  LatLng? drop_location;
  LatLng? actualmarker_position;

  String? paymentmethod;
  int? fee;
  String? status;
  String? tripstatus;
  String? device_token;
  String? created_at;

//added fields driver information
  String? driver_id;
  String? driver_name;
  String? driver_phone;
  String? driver_image_url;
  LatLng? driver_location;
  bool? payed;
  bool? read;

  OngoingTripDetails({
    this.request_id,
    this.passenger_name,
    this.passenger_phone,
    this.passenger_image_url,
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
    this.driver_id,
    this.driver_name,
    this.driver_phone,
    this.driver_image_url,
    this.driver_location,
    this.payed,
    this.read,
  });

  factory OngoingTripDetails.fromJson(Map<String, dynamic> json) {
    LatLng picklocation = LatLng(checkDouble(json['pick_location']['latitude']),
        checkDouble(json['pick_location']['longitude']));
    LatLng droplocation = LatLng(checkDouble(json['drop_location']['latitude']),
        checkDouble(json['drop_location']['longitude']));
    LatLng actualmarker = LatLng(
        checkDouble(json['actualmarker_position']['latitude']),
        checkDouble(json['actualmarker_position']['longitude']));
    LatLng driverlocation = LatLng(
        checkDouble(json['driver_location']['latitude']),
        checkDouble(json['driver_location']['longitude']));

    OngoingTripDetails ongoingTripDetails = OngoingTripDetails();
    ongoingTripDetails.request_id = json['request_id'];
    ongoingTripDetails.passenger_name = json['passenger_name'];
    ongoingTripDetails.passenger_phone = json['passenger_phone'];
    ongoingTripDetails.passenger_image_url = json['passenger_image_url'];
    ongoingTripDetails.pick_location_id = json['pick_location_id'];
    ongoingTripDetails.drop_location_id = json['drop_location_id'];
    ongoingTripDetails.pick_location = picklocation;
    ongoingTripDetails.drop_location = droplocation;
    ongoingTripDetails.actualmarker_position = actualmarker;
    ongoingTripDetails.pickaddress_name = json['pickaddress_name'];
    ongoingTripDetails.dropddress_name = json['dropddress_name'];
    ongoingTripDetails.paymentmethod = json['paymentmethod'];
    ongoingTripDetails.fee = json['fee'];
    ongoingTripDetails.status = json['status'];
    ongoingTripDetails.tripstatus = json['tripstatus'];
    ongoingTripDetails.device_token = json['device_token'];
    ongoingTripDetails.created_at = json['created_at'];
    ongoingTripDetails.driver_id = json['driver_id'];
    ongoingTripDetails.driver_name = json['driver_name'];
    ongoingTripDetails.driver_phone = json['driver_phone'];
    ongoingTripDetails.driver_image_url = json['driver_image_url'];
    ongoingTripDetails.driver_location = driverlocation;
    ongoingTripDetails.payed = json['payed'];
    ongoingTripDetails.read = json['read'];

    return ongoingTripDetails;
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
    Map<String, dynamic> driverlocation = {
      'latitude': driver_location!.latitude,
      'longitude': driver_location!.longitude,
    };

    return {
      'request_id': request_id,
      'passenger_name': passenger_name,
      'passenger_phone': passenger_phone,
      'passenger_image_url': passenger_phone,
      'pick_location_id': pick_location_id,
      'drop_location_id': drop_location_id,
      'pick_location': picklocation,
      'drop_location': droplocation,
      'actualmarker_position': actualmarker,
      'pickaddress_name': pickaddress_name,
      'dropddress_name': dropddress_name,
      'paymentmethod': paymentmethod,
      'fee': fee,
      'status': status,
      'tripstatus': tripstatus,
      'device_token': device_token,
      'created_at': created_at,
      'driver_id': driver_id,
      'driver_name': driver_name,
      'driver_phone': driver_phone,
      'driver_image_url': driver_image_url,
      'driver_location': driverlocation,
      'payed': payed,
      'read': read,
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
