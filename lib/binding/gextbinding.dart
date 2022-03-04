import 'package:get/get.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/driverlocationcontroller.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/controller/pagecontroller.dart';
import 'package:tricycleapp/controller/profile_controller.dart';
import 'package:tricycleapp/controller/requestcontroller.dart';

class Gextbinding implements Bindings{
 
 
  @override
  void dependencies() {
 
    Get.lazyPut(() => Authcontroller());
    Get.lazyPut(() => Mapcontroller());
    Get.lazyPut(() =>Requestcontroller());
    Get.lazyPut(() =>Driverlocationcontroller());
    Get.lazyPut(() =>Pagecontroller());
    Get.lazyPut(() =>ProfileController());
  }



}