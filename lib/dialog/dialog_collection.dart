import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/pagecontroller.dart';

import 'package:tricycleapp/controller/requestdatacontroller.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class DialogCollection {
  static void showpaymentToBePayed(String payment) {
    var requestxcontoller = Get.find<Requestdatacontroller>();
    Get.defaultDialog(
      title: '',
      barrierDismissible: false,
      backgroundColor: BOTTOMNAVIGATOR_COLOR,
      radius: 2,
      content: Container(
                decoration: BoxDecoration(
               
                  borderRadius: BorderRadius.all(Radius.circular(containerRadius))
                ),
              

                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text('Total amount to pay'.toUpperCase(), style: Get.textTheme.bodyText1!.copyWith(color: ELSA_TEXT_WHITE, fontSize: 14, fontWeight: FontWeight.w100)),
                  Verticalspace(6),
                  Text('₱ ${payment}.00', style: Get.textTheme.headline1!.copyWith(color: ELSA_TEXT_WHITE, fontSize: 34),),
                  Verticalspace(16),

                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 12,),
                                      width: double.infinity,
                                          height: 60,
                                      decoration: const ShapeDecoration(
                                        shape: StadiumBorder(),
                                        gradient: LinearGradient(
                                          end: Alignment.topLeft,
                                          begin: Alignment.bottomRight,
                                          colors: [
                                              ELSA_BLUE,
                                              ELSA_GREEN,
                                          ],
                                        ),
                                      ),
                                      child: MaterialButton(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: const StadiumBorder(),
                                        child:  Text(
                                          'OK',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: (){
                                          Get.back();
                                        },
                                      ),
                                    )
              
                 
                ]),
              ),
    );
  }
  static void showInfo(String mesage) {
    var requestxcontoller = Get.find<Requestdatacontroller>();
    Get.defaultDialog(
      title: '',
      barrierDismissible: false,
      backgroundColor: BOTTOMNAVIGATOR_COLOR,
      radius: 2,
      content: Container(
                decoration: BoxDecoration(
               
                  borderRadius: BorderRadius.all(Radius.circular(containerRadius))
                ),
              

                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text(mesage.toUpperCase(), style: Get.textTheme.bodyText1!.copyWith(color: ELSA_TEXT_WHITE, fontSize: 20, fontWeight: FontWeight.w600)),
                  Verticalspace(16),

                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 12,),
                                      width: double.infinity,
                                          height: 40,
                                      decoration: const ShapeDecoration(
                                        shape: StadiumBorder(),
                                        gradient: LinearGradient(
                                          end: Alignment.topLeft,
                                          begin: Alignment.bottomRight,
                                          colors: [
                                              ELSA_BLUE,
                                              ELSA_GREEN,
                                          ],
                                        ),
                                      ),
                                      child: MaterialButton(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: const StadiumBorder(),
                                        child:  Text(
                                          'OK',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: (){
                                          Get.back();
                                        },
                                      ),
                                    )
              
                 
                ]),
              ),
    );
  }
  static void showCancelInfo(String mesage) {
    var requestxcontoller = Get.find<Requestdatacontroller>();
    Get.defaultDialog(
      title: '',
      barrierDismissible: false,
      backgroundColor: BOTTOMNAVIGATOR_COLOR,
      radius: 2,
      content: Container(
                decoration: BoxDecoration(
               
                  borderRadius: BorderRadius.all(Radius.circular(containerRadius))
                ),
              

                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text(mesage.toUpperCase(), style: Get.textTheme.bodyText1!.copyWith(color: ELSA_TEXT_WHITE, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                  Verticalspace(16),

                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 12,),
                                      width: double.infinity,
                                          height: 40,
                                      decoration: const ShapeDecoration(
                                        shape: StadiumBorder(),
                                        gradient: LinearGradient(
                                          end: Alignment.topLeft,
                                          begin: Alignment.bottomRight,
                                          colors: [
                                              ELSA_BLUE,
                                              ELSA_GREEN,
                                          ],
                                        ),
                                      ),
                                      child: MaterialButton(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: const StadiumBorder(),
                                        child:  Text(
                                          'OK',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: ()async {
                                            Get.back();
                                            requestxcontoller.deleteTrip();
                                          
                                        },
                                      ),
                                    )
              
                 
                ]),
              ),
    );
  }

  static void showRequestInfo(BuildContext context) {
    var requestxcontroller = Get.find<Requestdatacontroller>();
    var pagexcontroller = Get.find<Pagecontroller>();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 12,
            ),
            Obx(() {
              if (requestxcontroller.currentrequest.value.status == "pending") {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'You have pending request do you want to cancel it?'),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            requestxcontroller.iscancel.value
                                ? Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: () {
                                      requestxcontroller.cancelRequest(context);
                                      Get.back();
                                    },
                                    child: Text('Yes')),
                            SizedBox(
                              width: 12,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('no')),
                          ],
                        ),
                      ]),
                );
              }
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'You can make request again after you finish the trip '),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              pagexcontroller.updatePageIndex(2);

                              Get.back();

                              Get.off(HomeScreenManager());
                            },
                            child: Text('View Ongoing Trip')),
                        SizedBox(
                          width: 12,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('OK')),
                      ],
                    ),
                  ]);
            })
          ]));
        });
  }

  static void requestDialog(BuildContext context, String message) {
    var requestxcontrooler = Get.find<Requestdatacontroller>();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: LIGHT_CONTAINER,
              child: Obx(() {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Container(
                        child: LinearProgressIndicator(
                          backgroundColor: BACKGROUND_BLACK,
                          color: ELSA_BLUE_2_,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      requestxcontrooler.iscancel.value
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: LIGHT_CONTAINER2,
                              ),
                              onPressed: () {
                                requestxcontrooler.cancelRequest(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  
                              
                                  Text('Cancel'.toUpperCase()),
                                ],
                              ))
                      // ElevatedButton(onPressed: (){

                      //     requestxcontrooler.cancelRequest(context);

                      // }, child: Text('Cancel'))
                    ],
                  ),
                );
              }));
        });
  }

  
}
