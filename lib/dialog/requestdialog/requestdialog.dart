import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showPayments(){
   Get.defaultDialog(
              title: '',
              radius: 2,
              barrierDismissible: false,
              titlePadding: EdgeInsets.all(0),
              content:Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('₱ 50'),
                      Text('To Be Payed'),
                      ElevatedButton(onPressed: () {
                          Get.back();

                      }, child: Text("OK"))
                    ],
                  ),
                ),
              ]),
            ))) ,
      );
}