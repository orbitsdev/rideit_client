import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleapp/UI/constant.dart';

class Profiledialog {
  static void showUploadDialog(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: BOTTOMNAVIGATOR_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    color: ELSA_GREEN,
                  ),
                  SizedBox(
                    width: 23,
                  ),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            message,
                            style: Get.textTheme.bodyText2!.copyWith(
                              color: Colors.white

                            ),
                          )))
                ],
              ),
            ),
          );
        });
  }



  static void showSimpleDialog(BuildContext context, Function pickImage) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: DIALOG_WHITE,
            title: Text(
              'Change Profile',
              style: Get.textTheme.headline4!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  pickImage(ImageSource.camera);
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.camera_alt_outlined, color: BACKGROUND_BLACK),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Camera',
                      style: Get.textTheme.subtitle1,
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImage(ImageSource.gallery);
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      color: BACKGROUND_BLACK,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Gallery',
                      style: Get.textTheme.subtitle1,
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
