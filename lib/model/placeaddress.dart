import 'package:google_maps_flutter/google_maps_flutter.dart';

class Placeaddress {
  String? placeformattedaddress;
  String? placeName;
  String? placeid;
  double? latitude;
  double? longitude;


  Placeaddress({
    this.placeformattedaddress,
    this.placeName,
    this.placeid,
    this.latitude,
    this.longitude,
  });
  factory Placeaddress.fromJson(Map<String, dynamic> json){

    Placeaddress placeaddress = Placeaddress();

      placeaddress.placeformattedaddress = json['formatted_address'];
      placeaddress.placeName = json['name'];
      placeaddress.placeid =  json['place_id'];
      placeaddress.latitude = json['geometry']['location']['lat'];
      placeaddress.longitude = json['geometry']['location']['lng'];
      var newmarkerpostion = LatLng(placeaddress.latitude as double,
          placeaddress.longitude as double);
    return placeaddress;
  } 

  
  Map<String, dynamic> toJson() => {
    'placeformattedaddress':  placeformattedaddress,
    'placeName':      placeName,
    'placeid':      placeid,
    'latitude':      latitude,
    'longitude':      longitude,
  };


  
}
