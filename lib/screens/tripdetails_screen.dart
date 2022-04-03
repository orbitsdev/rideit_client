import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/model/ongoing_trip_details.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';
import 'package:intl/intl.dart';




class TripdetailsScreen extends StatelessWidget {
  static const screenName = "/pastriprecordetailsscreen";

  OngoingTripDetails? trip;
  TripdetailsScreen({
    Key? key,
    this.trip,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: FaIcon(FontAwesomeIcons.times)),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          //padding: EdgeInsets.all(8),
          padding: EdgeInsets.all(20),
          width: double.infinity,
          

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
             //columnBuilder('Driver', '#1'),
           
             Verticalspace(8),
             columnBuilder('From'.toUpperCase(), '${trip!.pickaddress_name}'),
             Verticalspace(12),
             columnBuilder('To'.toUpperCase(), '${trip!.dropddress_name}'),
             Verticalspace(12),
             seperator(),
               Verticalspace(12),
             columnBuilder('Driver name'.toUpperCase(), 'Juan Delacruz'),
               Verticalspace(12),
             columnBuilder('Total amount payed'.toUpperCase(), '₱ ${trip!.fee}.00'),
             Verticalspace(12),
             columnBuilder('Trip Status'.toUpperCase(), '${trip!.tripstatus}'),
             Verticalspace(12),
             columnBuilder('Date'.toUpperCase(), 
             DateFormat('EEEE MMMM d, y  h:m a ').format(DateTime.parse('${trip!.created_at}'))
              // DateFormat().format(DateTime.parse('${trip!.created_at}'))
             //DateFormat.yMMMMd().format(DateTime.parse('${trip!.created_at}')) 
             ),
             Verticalspace(12),
             
            ],
          ),
        ),
      ),
    );
  }

  Widget seperator(){
    return  Divider(
               height: 1,
               color: ELSA_DARK_LIGHT_TEXT,
             );
  }
  Widget columnBuilder(String title, String subtitle){
    return  Column(
        mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${title}',  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
                  Text('${subtitle}',  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
                ],
              );
  }
}
