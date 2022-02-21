

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showTripDialog(String message){
   Get.defaultDialog(
                        title: '',
                        radius: 2,
                        barrierDismissible: false,
                        backgroundColor: Colors.white,
                        titlePadding: EdgeInsets.all(0),
                        content: Column(
                          children: [
                            Text(message, style: Get.theme.textTheme.headline4
                            ,),
                            SizedBox(
                              height: 12,
                            ),
                            ElevatedButton(onPressed: (){
                              Get.back();
                            }, child: Text('Ok'))

                          ],

                        )); 
}