import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionDetails {
  LatLng? bound_ne;
  LatLng? bound_sw;
  LatLng? startlocation;
  LatLng? endlocation;
  String? polylines;
  List<PointLatLng>? polylines_encoded;
  String? distanceText;
  String? durationText;
  int? distanceValue;
  int? durationValue;

  DirectionDetails({
    this.bound_ne,
    this.bound_sw,
    this.startlocation,
    this.endlocation,
    this.polylines,
    this.polylines_encoded,
    this.distanceText,
    this.durationText,
    this.distanceValue,
    this.durationValue,
  });

  factory DirectionDetails.fromJson(Map<String, dynamic> json) {
    

     var boundne = json['routes'][0]['bounds']['northeast'];
    var boundswe = json['routes'][0]['bounds']['southwest'];
    var startlocations = json['routes'][0]['legs'][0]['start_location'];
    var endlocation = json['routes'][0]['legs'][0]['end_location'];

    DirectionDetails directiondetails = DirectionDetails();
    directiondetails.bound_ne = LatLng(boundne['lat'], boundne['lng']);
    directiondetails.bound_sw = LatLng(boundswe['lat'], boundswe['lng']);
    directiondetails.startlocation = LatLng(startlocations['lat'], startlocations['lng']);
    directiondetails.endlocation = LatLng(endlocation['lat'], endlocation['lng']);
    directiondetails.polylines =json['routes'][0]['overview_polyline']['points'];
    directiondetails.polylines_encoded = PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']);
    directiondetails.distanceText = json['routes'][0]['legs'][0]['distance']['text'];
    directiondetails.distanceValue = json['routes'][0]['legs'][0]['distance']['value'];
    directiondetails.durationText = json['routes'][0]['legs'][0]['duration']['text'];
    directiondetails.durationValue =json['routes'][0]['legs'][0]['duration']['value'];
    return directiondetails;
  }

  // Map<String, dynamic> toJson() {

  //     Map<String, dynamic> boundne = {
  //       'latitude': bound_ne!.latitude,
  //       'longitude': bound_ne!.longitude,
  //     };
  //     Map<String, dynamic> boundsw = {
  //       'latitude': bound_sw!.latitude,
  //       'longitude': bound_sw!.longitude,
  //     };
  //     Map<String, dynamic> start_location = {
  //       'latitude': startlocation!.latitude,
  //       'longitude': startlocation!.longitude,
  //     };

  //   return {
  //       'bound_ne': boundne,
  //       'bound_sw': boundsw,
  //       'startlocation': start_location,
  //       'endlocation': endlocation,
  //       'polylines': polylines,
  //       'polylines_encoded': polylines_encoded,
  //       'distanceText': distanceText,
  //       'durationText': durationText,
  //       'distanceValue': distanceValue,
  //       'durationValue': durationValue,
  //     };

  // }
  
 
}
