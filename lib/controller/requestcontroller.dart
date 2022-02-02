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

class Requestcontroller  extends GetxController{

  var authxcontroller = Get.find<Authcontroller>();
  var mapxcontroller = Get.find<Mapcontroller>();


 void createRequest() async{

  
   Map picklocation ={
     "latitude": mapxcontroller.pickuplocation.value.latitude.toString(),
     "longitude": mapxcontroller.pickuplocation.value.longitude.toString(),
   };

   Map droplocation ={
     "latitude": mapxcontroller.pickuplocation.value.latitude.toString(),
     "longitude": mapxcontroller.pickuplocation.value.longitude.toString(),
   };

    Map<String, dynamic> requestdata = {
      "pick_location": picklocation,
      "drop_location": droplocation,
      "pickaddress_name":mapxcontroller.pickuplocation.value.placeformattedaddress,
      "dropddress_name": mapxcontroller.dropofflocation.value.placeformattedaddress,
      "passenger_name": authxcontroller.user.value.name,
      "passenger_phone": authxcontroller.user.value.phone,
      "status": "pending",
      "driver_id": "null",
      "created_at": DateTime.now().toString()
    };  

    print('request data');
    print(requestdata);
    try{
      requestrefference.doc(authinstance.currentUser!.uid).set(requestdata).then((value)  {
         requestDialog("Waiting driver to accept...", cancelRequest);
        sendNotification();
    }).catchError((e){
      print(e.toString());
    });

    }catch(e){
      print(e.toString());
    }


   

 }


  void sendNotification() async {
    List<Neardriver> listd = [];

    listd.clear();
    await availabledriversrefference.limit(5).get().then((collection) {
      if (collection.docs.isNotEmpty) {
        collection.docs.forEach((element) {
          var data = element.data() as Map<String, dynamic>;

          Neardriver ndriver = Neardriver();
          ndriver.key = element.id;
          ndriver.status = data['status'];
          ndriver.devicetoken = data['token'];

          listd.add(ndriver);
        });

        print('______________');
        print(listd[0].key);
      } else {

      }
    });

    String tokens = listd[0].devicetoken as String;

    Map<String, String> headerData = {
      'Content-Type': 'application/json',
      'Authorization': Cloudmessagingconfig.CLOUDMESSAGING_SERVER_TOKEN,
    };

    Map notificationData = {
      'body': 'Drop Location',
      'title': 'New Tricyle Request',
    };

    Map passData = {
      "id": 1,
      "status": "done",
    };

    Map sendPushNotification = {
      "notification": notificationData,
      "data": passData,
      "priority": "high",
      "to": tokens,
    };

    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    var serverKey = Cloudmessagingconfig.CLOUDMESSAGING_SERVER_TOKEN;

    try {
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '${mapxcontroller.dropofflocation.value.placeformattedaddress}',
              'title': 'New tricycle request'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': tokens,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }


  void cancelRequest()  async{

  //  print('cancel hehe');
      try{
        
      requestrefference.doc(authinstance.currentUser!.uid).delete().then((value) {
  print('request canceld');
});
      }catch(e){

          print(e.toString());
      }

      
  }


}