
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';

class Mapdialog {

static void showMapProgress(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    color: GREEN_LIGHT,
                  ),
                 
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            message,
                            style: Get.textTheme.bodyText2,
textAlign: TextAlign.center,
                          ),), )
                ],
              ),
            ),
          );
        });
        
        }
}