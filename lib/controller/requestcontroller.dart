import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tricycleapp/config/cloudmessagingconfig.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/dialog/requestdialog/requestdialog.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/model/neardriver.dart';
import 'package:tricycleapp/model/tripdetails.dart';
import 'package:tricycleapp/screens/home_screen.dart';
import 'package:tricycleapp/screens/ongoingtrip.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Requestcontroller extends GetxController {
  var authxcontroller = Get.find<Authcontroller>();
  var mapxcontroller = Get.find<Mapcontroller>();

  Stream? collectionStream;
  List<String> devicetokens = [];
  List<Neardriver> listofneardriver = [];
  var checking = false.obs;
  var requeststatus = false.obs;
  var loader = false.obs;
  var hasdata = false.obs;
  var requestdetails = Tripdetails().obs;
  var ongoingtripdetails = Tripdetails().obs;
  var hasongoingtrip = false.obs;
  var payed = false.obs;
  var paymentshowed = false.obs;
  var ifnotread = false.obs;
  var tripisnotcompleted = false.obs;

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

  void createRequest() async {
    var ifhasavailabler = await checkIfHasAvailabDriver();

    if (ifhasavailabler) {
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
        "latitude":
            mapxcontroller.actualdropmarkerposition!.latitude.toString(),
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
        'tripstatus':'notready',
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

          requeststream!.listen((event) {
            if (event.data() != null) {
              var data = event.data() as Map;
              print(event.data());

              if ((data['status'] == "accepted") && (data['tripstatus'] == 'notready') ){
                Get.back();
                requestDialog("Accepted prepairing trip...", cancelRequest);

                // Future.delayed(Duration(milliseconds: 300), () {
                //   Get.offNamed(Ongoingtrip.screenName,
                //       arguments: {"from": "request"});
                // });

                // }
              }
               if ((data['status'] == "accepted") && (data['tripstatus'] == 'ready')){
                 Get.back();
                  Future.delayed(Duration(milliseconds: 300), () {
                  Get.offNamed(Ongoingtrip.screenName,
                      arguments: {"from": "request"});
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
    } else {
      handelrDialog("Sorry no availabler drivers found");
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

    print(devicetokens);
    print('_____________________');
    print(hasAvailableDriver);

    return hasAvailableDriver;
  }

  void sendNotification(String requestid) async {
    print('__________sending notfification');
    print(devicetokens);
    if (devicetokens.isNotEmpty) {
      var serverKey = Cloudmessagingconfig.CLOUDMESSAGING_SERVER_TOKEN;

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
    } else {
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

  void checkIfHasDataRequest() async {
    loader(true);
    var response =
        await requestrefference.doc(authinstance.currentUser!.uid).get();
    if (response.exists) {
      print(response.data());
      requestdetails =
          Tripdetails.fromJson(response.data() as Map<String, dynamic>).obs;

      print(requestdetails.value.passengerphone);
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
    print('hhaas data');
    print(hasdata(response.exists));
    loader(false);
  }

  void listenToOngoingTrip() async {
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
              Tripdetails newtripdetails =Tripdetails.fromJson(event.data() as Map<String, dynamic>);
                
              ongoingtripdetails(newtripdetails);

              print(
                  'ongoingtiep_______________________________________________');
              print(newtripdetails.tripstatus);

              print(event.data());
              var data = event.data() as Map;

              print(data['tripstatus']);

              switch (data['tripstatus']) {
                case 'coming':
                  break;
                case 'arrived':
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
                  //if naka bayad show ratings optional then exit
                  if (data['read'] == true && data['payed'] == true) {
                    if (ifnotread == false) {
                      Get.defaultDialog(
                        title: '',
                        radius: 2,
                        barrierDismissible: false,
                        titlePadding: EdgeInsets.all(0),
                        content: Column(
                          children: [
                              Text("Thank You !", style: Get.theme.textTheme.headline3,),
                              

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
                                print(rating);
                              },
                            ),
                              Text("Rated Our Driver ", style: Get.theme.textTheme.bodyText1,),
                              ElevatedButton(
                            onPressed: () async {
                              ongoingtriprefference
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
                                Get.offNamed(HomeScreenManager.screenName);
                              });
                            },
                            child: Text('rate')),
                          ],

                        )
                        // content: ElevatedButton(
                        //     onPressed: () async {
                        //       ongoingtriprefference
                        //           .doc(authinstance.currentUser!.uid)
                        //           .delete()
                        //           .then((value) async {
                        //         tripisnotcompleted(true);
                        //         hasongoingtrip(false);
                        //         payed(false);
                        //         paymentshowed(false);
                        //         ifnotread(false);
                        //         tripisnotcompleted(false);
                        //         requestdetails = Tripdetails().obs;
                        //         ongoingtripdetails = Tripdetails().obs;1
                        //         mapxcontroller.clearRequest();
                        //         Get.offNamed(HomeScreenManager.screenName);
                        //       });
                        //     },
                        //     child: Text('rate')),
                      );
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
}
