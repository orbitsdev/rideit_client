import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/screens/home_screen.dart';

class Closerequest extends StatelessWidget {

  final Function closerequest;
  Closerequest({
  
    required this.closerequest,
  });

  @override
  Widget build(BuildContext context){
    var mapxontroller = Get.put(Mapcontroller());
    return IconButton(onPressed: (){
              closerequest(RequestTricycleState.start);
              mapxontroller.clearRequest();
              }, icon: FaIcon(FontAwesomeIcons.timesCircle));
  }

 

}
