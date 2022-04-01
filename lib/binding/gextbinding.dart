import 'package:get/get.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/drivercontroller.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/controller/mapdatacontroller.dart';
import 'package:tricycleapp/controller/pagecontroller.dart';
import 'package:tricycleapp/controller/passenger_controller.dart';
import 'package:tricycleapp/controller/permissioncontrooler.dart';
import 'package:tricycleapp/controller/requestdatacontroller.dart';

class Gextbinding implements Bindings{
 
 
  @override
  void dependencies() {
 
    Get.lazyPut(() => Authcontroller());
    Get.lazyPut(() => Mapcontroller());

    Get.lazyPut(() =>Drivercontroller());
    Get.lazyPut(() =>Pagecontroller());
    Get.lazyPut(() =>PassengerController());
    Get.lazyPut(() =>Permissioncontrooler());
    Get.lazyPut(() =>Mapdatacontroller());
    Get.lazyPut(() =>Requestdatacontroller());
  }



}