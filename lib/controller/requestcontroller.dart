import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tricycleapp/config/cloudmessagingconfig.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/model/neardriver.dart';
import 'package:tricycleapp/screens/ongoingtrip.dart';

class Requestcontroller extends GetxController {
  var authxcontroller = Get.find<Authcontroller>();
  var mapxcontroller = Get.find<Mapcontroller>();

   Stream? collectionStream;
  List<String> devicetokens = [];
  List<Neardriver> listofneardriver= [];
 

  Future<bool> checkIfHasOnGoingTrip() async{
  bool hasOnGoingTrip = false;

      progressDialog("Checking...");
   await requestrefference.doc(authinstance.currentUser!.uid).get().then((value) {
    if(value.data() != null){
      hasOnGoingTrip = true;

    }else{
      hasOnGoingTrip = false;
    }
   });

    print('_____________before returning');
    print(hasOnGoingTrip);
Get.back();

  return hasOnGoingTrip;
  }

  void createRequest() async {


  
    var ifhasavailabler = await checkIfHasAvailabDriver();

    if(ifhasavailabler){
    print('from requast actual merker postion');
    //  print(mapxcontroller.actualdropmarkerposition);

    Map<String, dynamic> picklocation = {
      "latitude": mapxcontroller.pickuplocation.value.latitude.toString(),
      "longitude": mapxcontroller.pickuplocation.value.longitude.toString(),
    };

    Map<String, dynamic> droplocation = {
      "latitude": mapxcontroller.dropofflocation.value.latitude.toString(),
      "longitude": mapxcontroller.dropofflocation.value.longitude.toString(),
    };

    Map<String, dynamic> actualdropmarker = {
      "latitude": mapxcontroller.actualdropmarkerposition!.latitude.toString(),
      "longitude":
          mapxcontroller.actualdropmarkerposition!.longitude.toString(),
    };

    Map<String, dynamic> requestdata = {
      "pick_location_id": mapxcontroller.pickuplocation.value.placeid,
      "drop_location_id": mapxcontroller.dropofflocation.value.placeid,
      "pick_location": picklocation,
      "drop_location": droplocation,
      "pickaddress_name":
          mapxcontroller.pickuplocation.value.placeformattedaddress,
      "dropddress_name":
          mapxcontroller.dropofflocation.value.placeformattedaddress,
      "passenger_name": authxcontroller.user.value.name,
      "passenger_phone": authxcontroller.user.value.phone,
      "actualmarker_position": actualdropmarker,
      "status": "pending",
      "tripstatus": null,
      "driver_id": null,
      "created_at": DateTime.now().toString()
    };

    print('request data');
    print(requestdata['actualmarker_position']);
    print(requestdata);
    try {
      requestrefference
          .doc(authinstance.currentUser!.uid)
          .set(requestdata)
          .then((value) {


        requestDialog("Waiting driver to accept...", cancelRequest);

        sendNotification(authinstance.currentUser!.uid);

           var requeststatus =     requestrefference.doc(authinstance.currentUser!.uid).snapshots();
          
         requestrefference.doc(authinstance.currentUser!.uid).snapshots().listen((event) {
          if(event.data() != null){
               var data = event.data()  as Map<String, dynamic>;

                
                if(data['status'] =="accepted"){
                  Get.back();
                  Get.offNamed(Ongoingtrip.screenName);
                  

                }

          
          }      
         
        });

    

      }).catchError((e) {
        print(e.toString());
      });
    } catch (e) {
      print(e.toString());
    }
    }else{
      handelrDialog("Sorry no availabler drivers found");
    }
    
   
  }

  Future<bool> checkIfHasAvailabDriver() async{
    bool hasAvailableDriver = false;
    var data;
    devicetokens.clear();
    await availabledriversrefference.get().then((QuerySnapshot querySnapshot){

      if(querySnapshot.docs.isNotEmpty){

            querySnapshot.docs.forEach((element) {

              if(element.data() != null){
                data = element.data() as Map<String, dynamic>; 
                
                devicetokens.add(data['token']);

              }    
        });
        hasAvailableDriver =true;
      }else{
        hasAvailableDriver = false;
      }

    });

    print(devicetokens);
    print('_____________________');
    print(hasAvailableDriver);

   return hasAvailableDriver;
  }

  void sendNotification(String requestid) async {

        print('__________sending notfification');
        print(devicetokens);
        if(devicetokens.isNotEmpty){
           var serverKey = Cloudmessagingconfig.CLOUDMESSAGING_SERVER_TOKEN;

        Map<String, String> headerData = {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        };

        Map<String, dynamic> notificationData = {
          'body':
              '${mapxcontroller.dropofflocation.value.placeformattedaddress}',
          'title': 'New Tricycle Request',
          'android_channel_id': 'triograb',
        };

        Map<String, dynamic> passData = {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          "id": 1,
          "status": "done",
          "request_id": requestid,
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
          print("error push notification");
        }
        }else{
           handelrDialog("Sorry no availabler drivers found");
        }
        

   
       

  }

  void cancelRequest() async {
    //  print('cancel hehe');
    try {
      requestrefference
          .doc(authinstance.currentUser!.uid)
          .delete()
          .then((value) {
        print('request canceld');
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
