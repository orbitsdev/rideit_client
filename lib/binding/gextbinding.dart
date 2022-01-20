import 'package:get/get.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';

class Gextbinding implements Bindings{
 
 
  @override
  void dependencies() {
 
    Get.lazyPut(() => Authcontroller());
    Get.lazyPut(() => Mapcontroller());
  }



}