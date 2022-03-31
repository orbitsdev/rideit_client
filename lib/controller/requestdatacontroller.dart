import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/config/cloudmessagingconfig.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapdatacontroller.dart';
import 'package:tricycleapp/controller/requestcontroller.dart';
import 'package:tricycleapp/dialog/authdialog/authdialog.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/dialog/dialog_collection.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/dialog/mapdialog/mapdialog.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/model/availabledriver.dart';
import 'package:tricycleapp/model/ongoing_trip_details.dart';
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

  var ongoingtrip = OngoingTripDetails().obs;
  var monitorongoingtrip = OngoingTripDetails().obs;
  var currentStatus = 0.obs;

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
      'passenger_image_url': autxcontroller.user.value.image_url,
      'device_token': autxcontroller.user.value.device_token,
      'created_at': DateTime.now().toString(),
    };

    try {
      await requestrefference
          .doc(authinstance.currentUser!.uid)
          .set(newrequest)
          .then((value) async {
        sendNotification(authinstance.currentUser!.uid);
        DialogCollection.requestDialog(context, 'Waiting driver to accept...');

        /// monitor request after sending
        requeststream!.listen((event) async {
          if (event.exists) {
            monitorequestaftersending(
                RequestDetails.fromJson(event.data() as Map<String, dynamic>));

            if (event.data() != null) {
              var data = event.data() as Map;

              /// waiting for to accept
              if ((data['status'] == "accepted") &&
                  (data['tripstatus'] == 'notready')) {
                Get.back();

                Authdialog.showAuthProGress(context, 'Request accepted...');
                Future.delayed(Duration(seconds: 1), () {
                  Get.back();
                  Mapdialog.showMapProgress(
                      context, 'Prepairing trip please wait...');
                });
              }

              /// prepairing data
              if ((data['status'] == "accepted") &&
                  (data['tripstatus'] == 'ready')) {
                Future.delayed(Duration(milliseconds: 300), () {
                  Get.off(() => Ongoingtrip());
                });
              }
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

    if (monitorcurrentrequest.value.status == "pending") {
      try {
     

        await requestrefference
            .doc(authinstance.currentUser!.uid)
            .delete()
            .then((value) {
          Infodialog.showInfoToast('Request canceled');
          iscancel(false);
          Get.back();
        });
      } catch (e) {
        Infodialog.showInfoToast(e.toString());
        iscancel(false);
        Get.back();
      }
    } else {
      Infodialog.showInfoToast(
          'Your request has been accepted please contact the driver if you want to cancel the trip');
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
        "latitude": mapxcontroller.droplocationDetails.value.latitude,
        "longitude": mapxcontroller.droplocationDetails.value.longitude,
      };

      Map<String, dynamic> unacceptedrequest = {
        "request_id": requestid,
        "picklocation_name":
            mapxcontroller.pickuplocationDetails.value.placeformattedaddress,
        "droplocation_name":
            mapxcontroller.droplocationDetails.value.placeformattedaddress,
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
        'body':
            '${mapxcontroller.droplocationDetails.value.placeformattedaddress}',
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

  Future<bool> checkTripData() async {
    bool isTripData = false;
    print('checkdata');
    await requestrefference
        .doc(authinstance.currentUser!.uid)
        .collection('ongoingtrip')
        .doc(authinstance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        ongoingtrip(
            OngoingTripDetails.fromJson(value.data() as Map<String, dynamic>));
        print(ongoingtrip.toJson());
        isTripData = true;
      } else {
        isTripData = false;
      }
    }).catchError((e) {
      isTripData = false;
      Infodialog.showInfoToastCenter(e.toString());
    });

    return isTripData;
    ;
  }

  Future<void> monitorOngoingTrip() async {
    print('trip minotr caleed');
    ongoingtripstream!.listen((event) async {

      if(event.exists){
           print('______________________');
      print('________________________');

      print(ongoingtrip.toJson());
      //print(ongoingtrip.value.tripstatus);

      ongoingtrip(
          OngoingTripDetails.fromJson(event.data() as Map<String, dynamic>));

      if (ongoingtrip.value.tripstatus == "prepairing") {
        currentStatus(0);
      } else if (ongoingtrip.value.tripstatus == "coming") {
        currentStatus(1);
      } else if (ongoingtrip.value.tripstatus == "arrived") {
        currentStatus(2);
      } else if (ongoingtrip.value.tripstatus == "travelling") {
        currentStatus(3);
      } else if (ongoingtrip.value.tripstatus == "complete") {
        currentStatus(4);
      }

      print('__________TRIPS STATUS');
      print(currentStatus);
      }
      //print('event.data()');
     
    });
  }

  void monitorRequest() async {
    print('MONITOR REQUEST START');
    requestrefference
        .doc(authinstance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        monitorcurrentrequest(RequestDetails.fromJson(event.data() as Map<String, dynamic>));
        print(monitorcurrentrequest.toJson());
      } else {
        monitorcurrentrequest(RequestDetails());
          print('NO REQUET FOUND');
      }
    });
  }

  void monitorTrip() async {
        print('MONITOR ONGOING TRIP START');
    ongoingtripstream!.listen((event) async {
      if (event.exists) {
        monitorongoingtrip(
            OngoingTripDetails.fromJson(event.data() as Map<String, dynamic>));
      } else {
        monitorongoingtrip(OngoingTripDetails());
      }
    });
  }

}
