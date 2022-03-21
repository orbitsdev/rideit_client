import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/model/ongoing_trip_details.dart';
import 'package:tricycleapp/model/users.dart';

class PassengerController extends GetxController {
  var authxcontroller = Get.find<Authcontroller>();
  var listofsuccesstrip = <OngoingTripDetails>[].obs;
  var listofcanceledtrip = <OngoingTripDetails>[].obs;
  var lisoftriprecord = <OngoingTripDetails>[].obs;

  var totalsuccestrip = 0.obs;
  var canceledtrip = 0.obs;
  var totalspend = 0.obs;

  var isUpdateProfile = false.obs;
  var isupdatingloading = false.obs;
  Future<UploadTask?> uploadFile(String destination, File file) async {
    try {
      //set destination
      progressDialog('Uploadings....');
      final ref = storage.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e.message);
      Get.back();
      return null;
    }
  }

  updateProfileDetails(String name, String email) async {
    isupdatingloading(true);
    try {
      await userrefference
          .doc(authinstance.currentUser!.uid)
          .update({'name': name, 'phone': email.trim()}).then((_) async {
        isupdatingloading(false);
        Fluttertoast.showToast(
            msg: "Update success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: ELSA_GREEN,
            fontSize: 16.0);
        Get.back();
      });
    } catch (e) {
      isupdatingloading(false);
    }
  }

  void listenToAllTrip() async {
    passengertriphistoryreferrence
        .doc(authinstance.currentUser!.uid)
        .collection('trips')
        .snapshots()
        .listen((event) {
      listofsuccesstrip.clear();
      listofcanceledtrip.clear();
      event.docs.forEach((element) {
        var data = element.data() as Map<String, dynamic>;

        lisoftriprecord.add(OngoingTripDetails.fromJson(data));
        if (data['tripstatus'] == "complete") {
          listofsuccesstrip.add(OngoingTripDetails.fromJson(data));
        }
        if (data['tripstatus'] == "canceled") {
          listofcanceledtrip.add(OngoingTripDetails.fromJson(data));
        }
      });
      totalspend(listofsuccesstrip.fold(
          0,
          (prev, trip) =>
              int.parse(prev.toString()) +
              int.parse(trip.payedamount.toString())));

      totalsuccestrip(listofsuccesstrip.length);
      canceledtrip(listofcanceledtrip.length);

      // print('mylist PRINTINg');
      // print(listofsuccesstrip.length);
      // print(listofcanceledtrip.length);
    });
  }

  void listenToAcountUser() async {
    userrefference
        .doc(authinstance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      var data = event.data() as Map<String, dynamic>;

      authxcontroller.user(Users.fromJson(data));
    });
  }
}
