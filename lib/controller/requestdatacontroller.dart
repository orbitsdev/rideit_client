import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/config/cloudmessagingconfig.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapdatacontroller.dart';

import 'package:tricycleapp/dialog/authdialog/authdialog.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/dialog/dialog_collection.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/dialog/mapdialog/mapdialog.dart';
import 'package:tricycleapp/helper/audiiomanger.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/model/availabledriver.dart';
import 'package:tricycleapp/model/ongoing_trip_details.dart';
import 'package:tricycleapp/model/public_data.dart';
import 'package:tricycleapp/model/request_details.dart';
import 'package:http/http.dart' as http;
import 'package:tricycleapp/screens/ongoingtrip.dart';
import 'package:tricycleapp/screens/rating_screen.dart';

class Requestdatacontroller extends GetxController {
  var listofavailabledriver = <Availabledriver>[].obs;
  var autxcontroller = Get.put(Authcontroller());
  var mapxcontroller = Get.put(Mapdatacontroller());
  var devicetokens = <String?>[].obs;

  var currentrequest = RequestDetails().obs;
  var monitorcurrentrequest = RequestDetails().obs;
  var monitorequestaftersending = RequestDetails().obs;

  var ongoingtrip = OngoingTripDetails().obs;
  var monitorongoingtrip = OngoingTripDetails().obs;
  var currentStatus = 0.obs;
  var publicdata =  PublicData().obs;

  var isPaymentShowed = false.obs;
  var isRatingShowed = false.obs;
  var isDriverShowed = false.obs;
  var isCanceledShowed= false.obs;
  var isBroken  = false.obs;
 

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

                Authdialog.showAuthProGress('Request accepted...');
                Future.delayed(Duration(seconds: 1), () {
                  Get.back();
                  Mapdialog.showMapProgress(
                      'Prepairing trip please wait...');
                });
              }

              /// prepairing data
              if ((data['status'] == "accepted") &&
                  (data['tripstatus'] == 'ready')) {
                Future.delayed(Duration(milliseconds: 300), () {
                  Get.offAll(()=> Ongoingtrip());
                 // Get.off(() => Ongoingtrip());
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
 
    await requestrefference
        .doc(authinstance.currentUser!.uid)
        .collection('ongoingtrip')
        .doc(authinstance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        ongoingtrip(
            OngoingTripDetails.fromJson(value.data() as Map<String, dynamic>));
        
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

      ongoingtripstream!.listen((event) async {

      if(event.exists){
      
 

      ongoingtrip(
          OngoingTripDetails.fromJson(event.data() as Map<String, dynamic>));
        
        
      if(ongoingtrip.value.tripstatus == "canceled"){
            if(isCanceledShowed==false){
              DialogCollection.showCancelInfo('Your Trip has been canceled');
              isCanceledShowed(true);
            }
              
          
      }

      if (ongoingtrip.value.tripstatus == "prepairing") {
        currentStatus(0);
      } else if (ongoingtrip.value.tripstatus == "coming") {
        currentStatus(1);
      } else if (ongoingtrip.value.tripstatus == "arrived") {
        currentStatus(2);
         
            if(isDriverShowed.value == false){
              DialogCollection.showInfo('The driver has arrived');
              isDriverShowed(true);  
            }

        
      } else if (ongoingtrip.value.tripstatus == "travelling") {
        currentStatus(3);
      } else if (ongoingtrip.value.tripstatus == "complete") {
        currentStatus(4);
        
        if(ongoingtrip.value.tripstatus =="complete" && ongoingtrip.value.payed==false){
            if(isPaymentShowed.value == false){
              DialogCollection.showpaymentToBePayed((ongoingtrip.value.fee).toString());
              isPaymentShowed(true);  
            }

        }

        if(ongoingtrip.value.tripstatus =="complete" && ongoingtrip.value.payed==true){
            if(isRatingShowed.value == false){
              Get.off(()=> RatingScreen() ,fullscreenDialog: true, transition: Transition.zoom);
              isRatingShowed(true);  
            }

        }
      }

      }
    
     
    });
  }

  void monitorRequest() async {
   
    requestrefference
        .doc(authinstance.currentUser!.uid)
        .snapshots()
        .listen((event) async {
          
      if (event.exists) {
        monitorcurrentrequest(RequestDetails.fromJson(event.data() as Map<String, dynamic>));
        

        
       
      } else {
        monitorcurrentrequest(RequestDetails());
        isBroken(false);
      }
    });
  }

  void deleteOngoingTrip() async{

  }

void monitorTrip() async {

    
    ongoingtripstream!.listen((event) async {
      if (event.exists) {
        monitorongoingtrip(  OngoingTripDetails.fromJson(event.data() as Map<String, dynamic>));

           if(monitorongoingtrip.value.tripstatus == "canceled"){
         if(isCanceledShowed==false){
              DialogCollection.showCancelInfo('Your Trip has been canceled');
              isCanceledShowed(true);
            }
          
        }
        


        if(monitorongoingtrip.value.tripstatus =="arrived"){
             Audiiomanger.player.play('sounds/216676__robinhood76__04864-notification-music-box.wav');  
        }
         if(monitorongoingtrip.value.tripstatus =="complete" && monitorongoingtrip.value.payed==false){
            if(isPaymentShowed.value == false){
              DialogCollection.showpaymentToBePayed((monitorongoingtrip.value.fee).toString());
              isPaymentShowed(true);  
            }

        }
      
      
        
         if(monitorongoingtrip.value.tripstatus =="complete" && monitorongoingtrip.value.payed==true){
          
            if(isRatingShowed.value == false){
               Get.off(()=> RatingScreen() ,fullscreenDialog: true, transition: Transition.zoom);
              isRatingShowed(true);  
            }

        }
        
      } else {
        isBroken(false);
        monitorongoingtrip(OngoingTripDetails());
          
        await requestrefference.doc(authinstance.currentUser!.uid).get().then((value) async{
          if(value.exists){
              var data = value.data() as Map<String, dynamic>;
            if(data['status']=="accepted"){
              print('is broken');
              isBroken(true);
              print(isBroken);
             }
          }else{
              print('is broken');
              isBroken(false);
              print(isBroken);
          }
        });  
          
      }
    });
  }




var isRatingload = false.obs;
void rateDriver(String? comment, int rate, String ratedescription) async{

    try{
   
      isRatingload(true);
       await ratingsrefference.doc(monitorongoingtrip.value.driver_id).collection('ratings').doc().set({

      'rate': rate,
      'comment': comment,
      'passenger_image_url': autxcontroller.user.value.image_url,
      'passenger_name':autxcontroller.user.value.name,
      'passenger_id':authinstance.currentUser!.uid,
      'rate_description':ratedescription,
      'created_at': DateTime.now().toString(), 
      
    }).then((value) async{

      await deleteTrip();
      isRatingload(false);

    });
    }catch(e){
   
      isRatingload(false);
      Infodialog.showInfoToastCenter(e.toString());
      Get.offAll(HomeScreenManager());
    }
   

  
    

}

Future<void> deleteRequest() async{
     try {
       Authdialog.showAuthProGress('Please wait...');
           
          await requestrefference.doc(authinstance.currentUser!.uid).delete().then((value) async{
       
          Get.back();
          await clearLocalData();
          await mapxcontroller.clearRequestForm();
          Get.offAll(HomeScreenManager());
          });
     } on Exception catch (e) {
          Get.back();
          await clearLocalData();
          await mapxcontroller.clearRequestForm();
          Get.offAll(HomeScreenManager());
     }
        
}

Future<void> deleteTrip() async{

  try{
    
       Authdialog.showAuthProGress('Please wait...');
    await requestrefference.doc(authinstance.currentUser!.uid).collection('ongoingtrip').doc(authinstance.currentUser!.uid).delete().then((value) async {
       await requestrefference.doc(authinstance.currentUser!.uid).delete();
        
      
    });
      
    Get.back();
    
    await clearLocalData();
    mapxcontroller.clearRequestForm();
    Get.offAll(HomeScreenManager());
  }catch(e){
      
    Get.back();
     mapxcontroller.clearRequestForm();
    Infodialog.showInfoToastCenter(e.toString());
    Get.offAll(HomeScreenManager());
  };

  
}

Future<void> clearLocalData()async{

   currentrequest(RequestDetails());
   monitorcurrentrequest(RequestDetails());
   monitorequestaftersending(RequestDetails());

   ongoingtrip(OngoingTripDetails());
   monitorongoingtrip(OngoingTripDetails());
   currentStatus(0);
   isPaymentShowed(false);
   isRatingShowed(false);
   isDriverShowed(false);
   isCanceledShowed(false);
  
}

void monitorAdminData() async{
    publicreferrence.doc('data').snapshots().listen((event) { 
      print('PUBLIC DATA IS MONITORING');
      if(event.exists){
           
          publicdata(PublicData.fromJson(event.data() as Map<String, dynamic>));

   
        
      }

   }); 
 }

}
