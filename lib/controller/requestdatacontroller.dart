import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/config/cloudmessagingconfig.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapdatacontroller.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/dialog/dialog_collection.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/dialog/mapdialog/mapdialog.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/model/availabledriver.dart';
import 'package:tricycleapp/model/request_details.dart';
import 'package:http/http.dart' as http;
import 'package:tricycleapp/screens/ongoingtrip.dart';

class Requestdatacontroller extends GetxController {
  var listofavailabledriver = <Availabledriver>[].obs;
  var autxcontroller = Get.find<Authcontroller>();
  var mapxcontroller = Get.find<Mapdatacontroller>();
  var devicetokens = <String?>[].obs;
  var currentrequest = RequestDetails().obs;
  var monitorcurrentrequest = RequestDetails().obs;
  var monitorequestaftersending = RequestDetails().obs;

  void createRequest(BuildContext context) async {
    Map<String, dynamic> picklocation = {
      'latitude': mapxcontroller.pickuplocationDetails.value.latitude,
      'longitude': mapxcontroller.pickuplocationDetails.value.longitude,
    };

    Map<String, dynamic> droplocation = {
      'latitude': mapxcontroller.droplocationDetails.value.latitude,
      'longitude': mapxcontroller.droplocationDetails.value.latitude,
    };

    Map<String, dynamic> actualmarker = {
      'latitude': mapxcontroller.actualdropmarkerposition!.latitude,
      'longitude': mapxcontroller.actualdropmarkerposition!.longitude,
    };

    Map<String, dynamic> newrequest = {
      'passenger_name': autxcontroller.user.value.name,
      'passenger_phone': autxcontroller.user.value.phone,
      'pick_location_id': mapxcontroller.pickuplocationDetails.value.placeid,
      'drop_location_id': mapxcontroller.droplocationDetails.value.placeid,
      'pick_location': picklocation,
      'drop_location': droplocation,
      'actualmarker_position': actualmarker,
      'pickaddress_name':
          mapxcontroller.pickuplocationDetails.value.placeformattedaddress,
      'dropddress_name':
          mapxcontroller.droplocationDetails.value.placeformattedaddress,
      'paymentmethod': mapxcontroller.paymentmethod,
      'fee': int.parse(mapxcontroller.calculateFee()),
      'status': 'pending',
      'tripstatus': 'notready',
      'device_token': autxcontroller.user.value.device_token,
      'created_at': DateTime.now().toString(),
    };

    try {
      

      await requestrefference.doc(authinstance.currentUser!.uid).set(newrequest).then((value) async{
       //  sendNotification(authinstance.currentUser!.uid);
         DialogCollection.requestDialog(context, 'Waiting driver to accept...');

        requeststream!.listen((event) {
          //store it locally
          monitorequestaftersending(  RequestDetails.fromJson(event.data() as Map<String, dynamic>));

          if (event.data() != null) {
            var data = event.data() as Map;

            if ((data['status'] == "accepted") &&
                (data['tripstatus'] == 'notready')) {
                 Get.back();
                 
                  Mapdialog.showMapProgress(context, 'Request accepted...');        
                 Future.delayed(Duration(seconds: 1),(){
                   Get.back();
                  Mapdialog.showMapProgress(context, 'Prepairing trip please wait...');        

                 });         
                  
            }
            if ((data['status'] == "accepted") &&
                (data['tripstatus'] == 'ready')) {
                 Get.back();

              // Get.offNamedUntil(HomeScreenManager.screenName, (route) => false);
              Future.delayed(Duration(milliseconds: 300), () {
                Get.off(Ongoingtrip(), transition: Transition.zoom);
              });
            }
          }
        });
      });
    } catch (e) {
      Infodialog.showInfoToast(e.toString());
    }    
}


  var iscancel = false.obs;
  void cancelRequest(BuildContext context) async {
      iscancel(true);
        

        if(monitorcurrentrequest.value.status == "pending"){

            try{

            // requestrefference.doc(authinstance.currentUser!.uid).get().then((value)  async{

            //     RequestDetails pendingrequest =  RequestDetails.fromJson(value.data()  as Map<String, dynamic>);
            //       if(pendingrequest.status == "pending"){

            //       } 

            // });


      await requestrefference.doc(authinstance.currentUser!.uid).delete().then((value) {
         Infodialog.showInfoToast('Request canceled');
         iscancel(false);
        Get.back();
      
      });
    }catch(e){
      Infodialog.showInfoToast(e.toString());
        iscancel(false);
        Get.back();
          }

        }else{
    
        Infodialog.showInfoToast('Your request has been accepted please contact the driver if you want to cancel the trip');
         iscancel(false);
         Get.back();

        }      
  }


  void sendNotification(String requestid) async {
   
    if (devicetokens.isNotEmpty) {
      var serverKey = Cloudmessagingconfig.CLOUDMESSAGING_SERVER_TOKEN;

      //prepair data

      Map<String, dynamic> picklocation = {
        "latitude": mapxcontroller.pickuplocationDetails.value.latitude,
        "longitude": mapxcontroller.pickuplocationDetails.value.longitude,
      };

      Map<String, dynamic> droplocation = {
        "latitude":mapxcontroller.droplocationDetails.value.latitude,
        "longitude": mapxcontroller.droplocationDetails.value.longitude,
      };

      Map<String, dynamic> unacceptedrequest = {
        "request_id": requestid,
        "picklocation_name":  mapxcontroller.pickuplocationDetails.value.placeformattedaddress,
        "droplocation_name":mapxcontroller.droplocationDetails.value.placeformattedaddress,
        "pick_location": picklocation,
        "drop_location": droplocation,
        "image_url": autxcontroller.user.value.image_url, 
      };

      //prepaire pushnotification

      Map<String, String> headerData = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      };

      Map<String, dynamic> notificationData = {
        'body': '${mapxcontroller.droplocationDetails.value.placeformattedaddress}',
        'title': 'New Tricycle Request',
        'android_channel_id': 'triograb',
      };

      Map<String, dynamic> passData = {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        "id": 1,
        "status": "done",
        "recieve_request": unacceptedrequest,
      };

      Map<String, dynamic> sendPushNotification = {
        "notification": notificationData,
        "data": passData,
        "priority": "high",
        "registration_ids": devicetokens,
        //"to": token,
      };

      var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

      try {
        var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: headerData,
          body: jsonEncode(sendPushNotification),
        );
      } catch (e) {
        Infodialog.showInfoToastCenter('Push notification error ${e}');
      }
    } else {
      Infodialog.showInfoToastCenter('Sorry no availabler drivers found');
     
    }
  }
}
