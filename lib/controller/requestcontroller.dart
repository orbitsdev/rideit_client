import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:tricycleapp/config/cloudmessagingconfig.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/controller/pagecontroller.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/dialog/dialog_collection.dart';
import 'package:tricycleapp/dialog/ongointripdialog/ongoingtripdialog.dart';
import 'package:tricycleapp/dialog/ongointripdialog/tripdialog.dart';
import 'package:tricycleapp/dialog/requestdialog/requestdialog.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/model/availabledriver.dart';
import 'package:tricycleapp/model/neardriver.dart';
import 'package:tricycleapp/model/request_details.dart';
import 'package:tricycleapp/model/tripdetails.dart';
import 'package:tricycleapp/screens/home_screen.dart';
import 'package:tricycleapp/screens/ongoingtrip.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Requestcontroller extends GetxController {
  var authxcontroller = Get.find<Authcontroller>();
  var mapxcontroller = Get.put(Mapcontroller());
  var pagexcontroller = Get.find<Pagecontroller>();
  

  Stream? collectionStream;

  List<Neardriver> listofneardriver = [];
  var checking = false.obs;
  var requeststatus = false.obs;
  var loader = false.obs;
  var hasdata = false.obs;
  var collecting = false.obs;
  var requestdetails = Tripdetails().obs;
  var ongoingtripdetails = Tripdetails().obs;
  var hasongoingtrip = false.obs;
  var payed = false.obs;
  var paymentshowed = false.obs;
  var ifnotread = false.obs;
  var tripisnotcompleted = false.obs;
  var canceling = false.obs;
  double ratevalue = 0.0;
  var listofavailabledriver = <Availabledriver>[].obs;
  var devicetokens = <String?>[].obs;
  var currentrequest = RequestDetails().obs;
  





  Future<bool> checkIfHasOnGoingTrip() async {
    bool hasOnGoingTrip = false;
    checking(true);
    //  progressDialog("Checking...");
    await requestrefference
        .doc(authinstance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.data() != null) {
        hasOnGoingTrip = true;
      } else {
        hasOnGoingTrip = false;
      }
    });

    print('_____________before returning');
    print(hasOnGoingTrip);

    checking(false);
    return hasOnGoingTrip;
  }

  void createRequest(BuildContext context) async {


    
      print('from requast actual merker postion');
      //  print(mapxcontroller.actualdropmarkerposition);

      Map<String, dynamic> picklocation = {
        "latitude": mapxcontroller.pickuplocation.value.latitude,
        "longitude": mapxcontroller.pickuplocation.value.longitude,
      };

      Map<String, dynamic> droplocation = {
        "latitude": mapxcontroller.dropofflocation.value.latitude,
        "longitude": mapxcontroller.dropofflocation.value.longitude,
      };

      Map<String, dynamic> actualdropmarker = {
        "latitude": mapxcontroller.actualdropmarkerposition!.latitude,
        "longitude": mapxcontroller.actualdropmarkerposition!.longitude,
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
        'tripstatus': 'notready',
        'device_token':  authxcontroller.user.value.device_token,
        "created_at": DateTime.now().toString()
      };

      try {
        requestrefference
            .doc(authinstance.currentUser!.uid)
            .set(requestdata)
            .then((value) {

              DialogCollection.requestDialog(context, 'Waiting driver to accept...');
     // requestDialog(message, cancelrequest)
          sendNotification(authinstance.currentUser!.uid);

          requeststream!.listen((event) {
            if (event.data() != null) {
              var data = event.data() as Map;

              if ((data['status'] == "accepted") &&
                  (data['tripstatus'] == 'notready')) {
                Get.back();
                progressDialog("Accepted prepairing trip...");
              }
              if ((data['status'] == "accepted") &&
                  (data['tripstatus'] == 'ready')) {
                Get.back();
                
                // Get.offNamedUntil(HomeScreenManager.screenName, (route) => false);
                Future.delayed(Duration(milliseconds: 300), () {
                  Get.off(Ongoingtrip());
                });
              }
            }
          });
        }).catchError((e) {
          print(e.toString());
        });
      } catch (e) {
        print(e.toString());
      }
   
  }

  Future<bool> checkIfHasAvailabDriver() async {
    bool hasAvailableDriver = false;
    var data;
    devicetokens.clear();
    await availabledriversrefference.get().then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((element) {
          if (element.data() != null) {
            data = element.data() as Map<String, dynamic>;

            devicetokens.add(data['token']);
          }
        });
        hasAvailableDriver = true;
      } else {
        hasAvailableDriver = false;
      }
    });

    return hasAvailableDriver;
  }

  void  sendNotification(String requestid) async {
    print('__________sending notfification');
    print(devicetokens);
    if (devicetokens.isNotEmpty) {
      var serverKey = Cloudmessagingconfig.CLOUDMESSAGING_SERVER_TOKEN;

     
      //prepair data

      Map<String, dynamic> picklocation = {
        "latitude": mapxcontroller.pickuplocation.value.latitude,
        "longitude": mapxcontroller.pickuplocation.value.longitude,
      };

      Map<String, dynamic> droplocation = {
        "latitude": mapxcontroller.dropofflocation.value.latitude,
        "longitude": mapxcontroller.dropofflocation.value.longitude,
      };

      Map<String, dynamic> unacceptedrequest = {
       "request_id": requestid,
       "picklocation_name": mapxcontroller.pickuplocation.value.placeformattedaddress,
       "droplocation_name": mapxcontroller.dropofflocation.value.placeformattedaddress,
        "pick_location":picklocation ,
        "drop_location":droplocation ,
      };

      
      //prepaire pushnotification

       Map<String, String> headerData = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      };

      Map<String, dynamic> notificationData = {
        'body': '${mapxcontroller.dropofflocation.value.placeformattedaddress}',
        'title': 'New Tricycle Request',
        'android_channel_id': 'triograb',
      };

      Map<String, dynamic> passData = {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        "id": 1,
        "status": "done",
        "recieve_request":unacceptedrequest,

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
    } else {
      handelrDialog("Sorry no availabler drivers found");
    }
  }

  void cancelRequest() async {
    //  print('cancel hehe');
    try {
    canceling(true);
      requestrefference
          .doc(authinstance.currentUser!.uid)
          .delete()
          .then((value) {
            canceling(false);
            currentrequest(RequestDetails());
        print('request canceld');
      });
    } catch (e) {
      canceling(false);
      print(e.toString());
    }
  }


  Future<bool> checkIfHasOnoingTripRequest() async {
  bool checking = false;

    try {
    
      var response =   await ongoingtriprefference.doc(authinstance.currentUser!.uid).get();
      if (response.exists) {
        requestdetails = Tripdetails.fromJson(response.data() as Map<String, dynamic>).obs;
        print(requestdetails.value.passengerphone);
        hasdata(true);
        hasongoingtrip(true);
        checking =true;
      } else {
     
        print('_nothing');
        checking = false;
      }
    } on FirebaseException catch (e) {
       
        checking =false;

    }

    // if(response.exists){
    //  //
    //  //prin print(response.data() as DocumentSnapshot);
    //   print('has data');
    //   print(response.data() as Map<String, dynamic>);
    // }else{
    //   print('no data');
    // }
    return checking;

  }

  void checkIfHasDataRequest() async {
    loader(true);
    var response =
        await ongoingtriprefference.doc(authinstance.currentUser!.uid).get();
    if (response.exists) {
      requestdetails =
          Tripdetails.fromJson(response.data() as Map<String, dynamic>).obs;
      print(requestdetails.value.passengerphone);
      hasdata(true);
    } else {
      print('_nothing');
    }

    // if(response.exists){
    //  //
    //  //prin print(response.data() as DocumentSnapshot);
    //   print('has data');
    //   print(response.data() as Map<String, dynamic>);
    // }else{
    //   print('no data');
    // }

    loader(false);
  }

  void listenToOngoingTrip(BuildContext context) async {
    await ongoingtriprefference
        .doc(authinstance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        hasongoingtrip(true);

        print('exist');
        if (ongoingtripstream != null) {
          ongoingtripstream!.listen((event) {
            if (event.data() != null) {
              Tripdetails newtripdetails =
                  Tripdetails.fromJson(event.data() as Map<String, dynamic>);

              ongoingtripdetails(newtripdetails);

              var data = event.data() as Map;

              print(data['tripstatus']);

              switch (data['tripstatus']) {
                case 'coming':
                  break;
                case 'arrived':

               Tripdialog.showInfoDialog(context, 'Driver has arrived ');
                  // showTripDialog("Thd driver has arrived");
                  //show notification when arrived
                  break;
                case 'picked':
                  //show travelling
                  break;
                case 'complete':
                  //update read
                  if (data['read'] == false) {
                    ongoingtriprefference
                        .doc(authinstance.currentUser!.uid)
                        .update({'read': true});
                  }
                  //showpayment if not payed

                  if (data['payed'] == false) {
                    if (paymentshowed == false) {
                      showPayments();
                      paymentshowed(true);
                    }
                  }

                    if(data['tripstatus' == 'canceled']){
                          Tripdialog.canceledDialog(context,'Trip has been canceld');
                      }
                  //if naka bayad show ratings optional then exit
                  if (data['read'] == true && data['payed'] == true) {
                    if (ifnotread == false) {
                      Get.defaultDialog(
                          title: '',
                          radius: 2,
                          barrierDismissible: false,
                          backgroundColor: Colors.white,
                          titlePadding: EdgeInsets.all(0),
                          content: Column(
                            children: [
                              Text(
                                "Thank You !",
                                style: Get.theme.textTheme.headline3,
                              ),
                              RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  ratevalue = rating;
                                  print('______________');
                                  print(rating);
                                },
                              ),
                              Text(
                                "Rated Our Driver ",
                                style: Get.theme.textTheme.bodyText1,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    await ratingsrefference
                                        .doc(ongoingtripdetails.value.driverid)
                                        .collection('ratings')
                                        .add({
                                      'rate': ratevalue,
                                      'comment': 'Excellent Worl',
                                      'passenger_id':authinstance.currentUser!.uid,
                                      'passenger_name': authxcontroller.user.value.name,
                                      'created_at': DateTime.now().toString(),
                                    }).then((_) async {
                                      await ongoingtriprefference
                                          .doc(authinstance.currentUser!.uid)
                                          .delete()
                                          .then((value) async {
                                        tripisnotcompleted(true);
                                        hasongoingtrip(false);
                                        payed(false);
                                        paymentshowed(false);
                                        ifnotread(false);
                                        tripisnotcompleted(false);
                                        requestdetails = Tripdetails().obs;
                                        ongoingtripdetails = Tripdetails().obs;
                                        mapxcontroller.clearRequest();
                                        currentrequest(RequestDetails());

                                        if (pagexcontroller.pageindex == 2) {
                                          pagexcontroller.updatePageIndex(1);
                                        }
                                        //Get.offNamed(HomeScreenManager.screenName, (route) => false);
                                        Get.offNamed(
                                            HomeScreenManager.screenName);
                                      });
                                    });
                                  },
                                  child: Text('rate')),
                            ],
                          ));
                      ifnotread(true);
                    }
                  }

                  break;
                case 'payed':
                  payed(true);
                  if (payed == true) {
                    Get.offNamed(HomeScreenManager.screenName);
                  }
                  break;
              }
            }
          });
        }
      } else {
        hasongoingtrip(false);
        Get.offNamed(HomeScreenManager.screenName);
        print('not exist');
      }
    });
  }

  void checkIdhasOngoinRequestNotRead(BuildContext context) async {
    print('_______________________________________listen called');
    await ongoingtriprefference
        .doc(authinstance.currentUser!.uid)
        .get()
        .then((value) async {
      if (value.exists) {
        var data = value.data() as Map<String, dynamic>;

        if (data != null) {


          if(data['tripstatus'] == 'arrived'){

            Tripdialog.showInfoDialog(context, 'Driver Has Arrived');

          }
          
         if(data['tripstatus'] == 'canceled'){
            print('HEYYYYYYYYYYYY');
              Tripdialog.canceledDialog(context,'Trip has been canceld');
          }


          if (data['tripstatus'] == 'complete' &&
              data['payed'] == true &&
              data['read'] == false) {
            await ongoingtriprefference
                .doc(authinstance.currentUser!.uid)
                .update({'read': true}).then((_) async {
              if (ifnotread == false) {
                Get.defaultDialog(
                    title: '',
                    radius: 2,
                    barrierDismissible: false,
                    backgroundColor: Colors.white,
                    titlePadding: EdgeInsets.all(0),
                    content: Column(
                      children: [
                        Text(
                          "Thank You !",
                          style: Get.theme.textTheme.headline3,
                        ),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {

                          
                          
                            ratevalue = rating;
                            print('______________');
                            print(rating);
                          },
                        ),
                        Text(
                          "Rated Our Driver ",
                          style: Get.theme.textTheme.bodyText1,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await ratingsrefference
                                  .doc(ongoingtripdetails.value.driverid)
                                  .collection('ratings')
                                  .add({
                                'rate': ratevalue,
                                'comment': 'Nice And Good Services',
                                'passenger_id': authinstance.currentUser!.uid,
                                'passenger_name': authxcontroller.user.value.name,
                                'created_at': DateTime.now().toString(),
                              }).then((_) async {
                                await ongoingtriprefference
                                    .doc(authinstance.currentUser!.uid)
                                    .delete()
                                    .then((value) async {
                                  loader(false);
                                  tripisnotcompleted(true);
                                  hasongoingtrip(false);
                                  payed(false);
                                  paymentshowed(false);
                                  ifnotread(false);
                                  tripisnotcompleted(false);
                                  requestdetails = Tripdetails().obs;
                                  ongoingtripdetails = Tripdetails().obs;
                                  mapxcontroller.clearRequest();
                                  Get.back();
                                  //Get.offNamed(HomeScreenManager.screenName);
                                });
                              });
                            },
                            child: Text('rate')),
                      ],
                    ));
                ifnotread(true);
              }
            });
          }
          //show when the app is open and not payed but complete
          if (data['tripstatus'] == 'complete' &&
              data['payed'] == false &&
              data['read'] == false) {
            if (paymentshowed == false) {
              showPayments();
              paymentshowed(true);
            }
          }
        }

        print('exist from home manage___________________');
        print(data);
      }
    });
  }

  void deleteOngoingTrip() async{
    await ongoingtriprefference
                                    .doc(authinstance.currentUser!.uid)
                                    .delete()
                                    .then((value) async {
                                  loader(false);
                                  tripisnotcompleted(true);
                                  hasongoingtrip(false);
                                  payed(false);
                                  paymentshowed(false);
                                  ifnotread(false);
                                  tripisnotcompleted(false);
                                  requestdetails = Tripdetails().obs;
                                  ongoingtripdetails = Tripdetails().obs;
                                  mapxcontroller.clearRequest();
                                  Get.back();
                                });
                              
  }
}
