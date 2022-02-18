import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tripdetails {
 String? triprequestid;
      String? picklocationid;
      String? droplocationid;
      LatLng? picklocation;
      LatLng? droplocation;
      LatLng? actualmarkerposition;
      String? pickaddressname;
      String? dropddressname;
      String? passengername;
      String? passengerphone;
      String? status;
      String? tripstatus;
      String? driverid;
      
  Tripdetails({
    this.triprequestid,
    this.picklocationid,
    this.droplocationid,
    this.picklocation,
    this.droplocation,
    this.actualmarkerposition,
    this.pickaddressname="",
    this.dropddressname="",
    this.passengername,
    this.passengerphone,
    this.status,
    this.tripstatus,
    this.driverid,
  });

factory Tripdetails.fromJson(Map<String,dynamic> json){

        Tripdetails newtripdetails = Tripdetails();
       newtripdetails.picklocationid = json['pick_location_id'];
        newtripdetails.pickaddressname = json['pickaddress_name'];
        newtripdetails.actualmarkerposition = LatLng(
            double.parse(json['actualmarker_position']['latitude']),
            double.parse(json['actualmarker_position']['longitude']));
        newtripdetails.picklocation = LatLng(
            double.parse(json['pick_location']['latitude']),
            double.parse(json['pick_location']['longitude']));
        newtripdetails.droplocationid = json['drop_location_id'];
        newtripdetails.dropddressname = json['dropddress_name'];
        newtripdetails.droplocation = LatLng(
            double.parse(json['drop_location']['latitude']),
            double.parse(json['drop_location']['longitude']));
        newtripdetails.passengername = json["passenger_name"];
        newtripdetails.passengerphone = json["passenger_phone"];
        newtripdetails.status = json["status"];
        newtripdetails.tripstatus = json["tripstatus"];


        return newtripdetails;
}
}