import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/controller/requestcontroller.dart';

class Tripdialog {

  static void showInfoDialog(BuildContext context , String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message),
                ElevatedButton(onPressed: () {
                  Get.back();
                }, child: Text("OK"))
              ],
            ),
          ]));
        });
  }
  static void canceledDialog(BuildContext context , String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message),
                ElevatedButton(onPressed: () async {

                  Get.find<Requestcontroller>().deleteOngoingTrip();
                  Get.back();
                }, child: Text("OK"))
              ],
            ),
          ]));
        });
  }
}
