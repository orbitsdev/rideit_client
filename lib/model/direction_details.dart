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
  
  
}
