import 'package:get/get.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/controller/requestcontroller.dart';

class Gextbinding implements Bindings{
 
 
  @override
  void dependencies() {
 
    Get.lazyPut(() => Authcontroller());
    Get.lazyPut(() => Mapcontroller());
    Get.lazyPut(() =>Requestcontroller());
  }



}