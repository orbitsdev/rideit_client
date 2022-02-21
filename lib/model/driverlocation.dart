
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driverlocation {


LatLng? driverposition;
LatLng? picklocation;

Driverlocation({
    this.driverposition,
    this.picklocation,
});



Driverlocation.fromJson(Map<String, dynamic> json){


  Driverlocation newdriverlocation = Driverlocation();


  newdriverlocation.driverposition =  LatLng(
            double.parse(json['driver_location']['latitude']),
            double.parse(json['driver_location']['longitude']));
        
    

}


}
