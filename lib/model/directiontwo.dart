import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directiontwo {
  LatLng? bound_ne;
  LatLng? bound_sw;
  LatLng? startlocation;
  LatLng? endlocation;
  String? polylines;
  List<PointLatLng>? polylines_encoded;
  
  Directiontwo({
    this.bound_ne,
    this.bound_sw,
    this.startlocation,
    this.endlocation,
    this.polylines,
    this.polylines_encoded,
  });
}
