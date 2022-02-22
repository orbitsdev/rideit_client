import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/controller/requestcontroller.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/screens/ongoingtrip.dart';

class TripHistoryScreen extends StatefulWidget {
  static const screenName = '/triphistory';

  @override
  _TripHistoryScreenState createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  var requestxcontroller = Get.put(Requestcontroller());

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
    // TODO: implement setState
  }

  @override
  void initState() {
    super.initState();
    requestxcontroller.checkIfHasOnoingTripRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){

      if(requestxcontroller.loader.value){
        return Container(
          child: Center(child: CircularProgressIndicator()),
        );
      }else{
        if(!requestxcontroller.hasdata.value){
         return Container(
          child: Center(child: Text('no data')),
        );
        
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("drop location"),
            Text(requestxcontroller.requestdetails.value.dropddressname as String),
            Center(
              child: ElevatedButton(onPressed: (){ 
                Get.toNamed(Ongoingtrip.screenName, arguments: {"from": "trip"});

              }, child: Text('View')),
            )
          ],
        );
         
      }
      
     
    });
  }
}
