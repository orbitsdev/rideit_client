import 'package:google_maps_flutter/google_maps_flutter.dart';

class OngoingTripDetails {
  String? request_id;
  String? pick_location_id;
  String? drop_location_id;

  String? pickaddress_name;
  String? dropddress_name;

  //passenger
  String? passenger_name;
  String? passenger_phone;
  String? device_token;

  //driver
  String? driver_id;
  String? driver_name;
  String? driver_phone;
  LatLng? driver_location;



  LatLng? pick_location;
  LatLng? drop_location;
  LatLng? actualmarker_position;

  String? status;
  String? created_at;

  String? tripstatus;
  int? payedamount;
  bool? payed;
  bool? read;


  OngoingTripDetails({
    this.request_id,
    this.pick_location_id,
    this.drop_location_id,
    this.pickaddress_name,
    this.dropddress_name,
    this.passenger_name,
    this.passenger_phone,
    this.driver_id,
    this.driver_name,
    this.driver_phone,
    this.driver_location,
    this.pick_location,
    this.drop_location,
    this.actualmarker_position,
    this.status,
    this.tripstatus,
    this.created_at,
    this.payedamount,
    this.payed,
    this.read,
    this.device_token,
  });


  factory OngoingTripDetails.fromJson(Map<String, dynamic> json){
      

      int? payedamount;
      if(json['payedamount'] == null ){
          payedamount = 0;
      }else{
        payedamount = json['payedamount'].toInt();

      }
    
    LatLng picklocation = LatLng(checkDouble(json['pick_location']['latitude']), checkDouble(json['pick_location']['longitude']) );
    LatLng droplocation = LatLng(checkDouble(json['drop_location']['latitude'])  , checkDouble( json['drop_location']['longitude']) );
    LatLng actualmarker = LatLng(checkDouble(json['actualmarker_position']['latitude']) , checkDouble(json['actualmarker_position']['longitude']) );

    OngoingTripDetails ongoingtripdetails = OngoingTripDetails();
    ongoingtripdetails.request_id= json['request_id']; 
    ongoingtripdetails.pick_location_id= json['pick_location_id']; 
    ongoingtripdetails.drop_location_id= json['drop_location_id']; 
    ongoingtripdetails.pickaddress_name= json['pickaddress_name']; 
    ongoingtripdetails.dropddress_name= json['dropddress_name']; 
    ongoingtripdetails.passenger_name= json['passenger_name']; 
    ongoingtripdetails.passenger_phone= json['passenger_phone']; 
    ongoingtripdetails.pick_location= picklocation; 
    ongoingtripdetails.drop_location= droplocation; 
    ongoingtripdetails.actualmarker_position= actualmarker; 
    ongoingtripdetails.status= json['status']; 
    ongoingtripdetails.created_at= json['created_at']; 

    //driver information
    LatLng driverlocation = LatLng(json['driver_location']['latitude'], json['driver_location']['longitude']);
    ongoingtripdetails.driver_id = json["driver_id"];
    ongoingtripdetails.driver_name = json["driver_name"];
    ongoingtripdetails.driver_phone = json["driver_phone"];
    ongoingtripdetails.driver_location = driverlocation;

    //
    ongoingtripdetails.tripstatus= json['tripstatus']; 
    ongoingtripdetails.payedamount =  payedamount  as int ;
    ongoingtripdetails.payed =  json['payed'];
    ongoingtripdetails.read = json['read'];
    ongoingtripdetails.device_token = json['device_token'];

    return ongoingtripdetails;

    
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> picklocation = {
      "latitude": pick_location!.latitude,
      "longitude": pick_location!.longitude,
    };

    Map<String, dynamic> droplocation = {
      "latitude": drop_location!.latitude,
      "longitude": drop_location!.longitude,
    };

    Map<String, dynamic> actualdropmarker = {
      "latitude": actualmarker_position!.latitude,
      "longitude": actualmarker_position!.longitude,
    };

    Map<String, dynamic> driverlocation = {
      "latitude": driver_location!.latitude,
      "longitude": driver_location!.longitude,
    };

    return {


    "request_id": request_id,
    "pick_location_id":pick_location_id ,
    "drop_location_id": drop_location_id,
    "pickaddress_name":pickaddress_name ,
    "dropddress_name":dropddress_name ,
    "passenger_name": passenger_name,
    "passenger_phone":passenger_phone ,
    "driver_id": driver_id,
    "driver_name": driver_name,
    "driver_phone":driver_phone ,
    "driver_location": driverlocation,
    "pick_location": picklocation,
    "drop_location": droplocation,
    "actualmarker_position": actualdropmarker,
    "status": status,
    "tripstatus": tripstatus,
    "created_at":created_at ,
    "payedamount":payedamount ,
    "payed":payed ,
    "read":read ,
    "device_token": device_token
    };
  }

printOngoingData(Map<String, dynamic> json){
  print(json);
}


static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }

}
