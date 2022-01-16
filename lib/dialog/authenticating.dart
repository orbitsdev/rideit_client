import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void progressDialog(String message) async {
  Get.defaultDialog(
    backgroundColor: Colors.black54,
    title: '',
    titlePadding: EdgeInsets.all(0),
    content: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 18,
          ),
          Container(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              )),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    ),
  );
}

void notificationDialog(BuildContext context, String  message) {
 AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Failed',
        desc:message ,
        btnOkOnPress: () {},
      )..show();
}
