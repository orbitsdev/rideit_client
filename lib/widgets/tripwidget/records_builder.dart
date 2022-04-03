import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/passenger_controller.dart';
import 'package:tricycleapp/controller/requestdatacontroller.dart';
import 'package:tricycleapp/screens/tripdetails_screen.dart';

import 'package:tricycleapp/widgets/tripwidget/listcontainer.dart';

class RecordsBuilder extends StatelessWidget {

var passengerxcontroller = Get.find<PassengerController>();
  @override
  Widget build(BuildContext context){
    return  AnimationLimiter(
           child: ListView.builder(
            shrinkWrap: true,
            itemCount: passengerxcontroller.lisoftriprecord.length,
            itemBuilder: (context, index) {
              return Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        Get.to(
                            () => TripdetailsScreen(
                                  trip:
                                      passengerxcontroller.lisoftriprecord[index],
                                    
                                ),
                            fullscreenDialog: true, transition: Transition.zoom);
                      },
                      child: Listcontainer(
                          status: passengerxcontroller.lisoftriprecord[index].status.toString(),
                          statuscolor: ELSA_GREEN,
                          picklocation:
                              passengerxcontroller.lisoftriprecord[index].pickaddress_name.toString(),
                          droplocation:
                              passengerxcontroller.lisoftriprecord[index].dropddress_name.toString(),
                          date:
                          //DateFormat().format(DateTime.parse('${passengerxcontroller.lisoftriprecord[index].created_at}'))
                         DateFormat('EEEE MMMM d, y h:m a ').format(DateTime.parse('${passengerxcontroller.lisoftriprecord[index].created_at}'))
                          )
                          )
                          );
            }),
         );
  }
}