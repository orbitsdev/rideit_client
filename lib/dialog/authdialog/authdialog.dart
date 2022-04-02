import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/signin_screen.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class Authdialog {
  static void showAuthProGress( String message) {

    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.all(0),
    
      barrierDismissible: false,
      backgroundColor: Colors.black,
      contentPadding:   EdgeInsets.only(right: 18, left: 18, bottom: 0, top: 18),
      radius:  6,
      content: Container(
              decoration: BoxDecoration(
               
               
              ),
            
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    color: GREEN_LIGHT,
                  ),
                  SizedBox(
                    width: 23,
                  ),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            message,
                            style: Get.textTheme.bodyText2,
                          )))
                ],
              ),
            ),
    );
   
  }

  static void shouwLogoutDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: BOTTOMNAVIGATOR_COLOR,
            child: Container(
              decoration: BoxDecoration(
                  color: BOTTOMNAVIGATOR_COLOR,
                  borderRadius:
                      BorderRadius.all(Radius.circular(containerRadius))),
              padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Verticalspace(12),
                    Text(
                      'Are you sure you want to log out?',
                      style: Get.textTheme.headline1!.copyWith(
                        color: ELSA_TEXT_WHITE,
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Verticalspace(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        height: 50,
                        decoration: const ShapeDecoration(
                          shape: StadiumBorder(),
                          gradient: LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                            colors: [
                              ELSA_BLUE_1_,
                              ELSA_BLUE_1_,
                            ],
                          ),
                        ),
                        child: MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: const StadiumBorder(),
                          child: Text('Yes',
                              style: Get.textTheme.bodyText1!
                                  .copyWith(fontWeight: FontWeight.w400)),
                          onPressed: () async {

                               authinstance.signOut();
                            Get.offAll(()=> SigninScreen());

                          },
                        ),
                      ),
                      Horizontalspace(10),
                      Container(
                        height: 50,
                        decoration: const ShapeDecoration(
                          shape: StadiumBorder(),
                          gradient: LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                            colors: [
                              ELSA_BLUE_1_,
                              ELSA_BLUE_1_,
                            ],
                          ),
                        ),
                        child: MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: const StadiumBorder(),
                          child: Text('No',
                              style: Get.textTheme.bodyText1!
                                  .copyWith(fontWeight: FontWeight.w400)),
                          onPressed: () async {
                           Get.back();
                          },
                        ),
                      ),
                    ]),
                  ]),
            ),
          );
        });
  }
}
