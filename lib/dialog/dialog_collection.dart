import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/pagecontroller.dart';
import 'package:tricycleapp/controller/requestcontroller.dart';
import 'package:tricycleapp/controller/requestdatacontroller.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';

class DialogCollection {
  static void showpaymentToBePayed(BuildContext context) {
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
                Text('₱ 50'),
                Text('To Be Payed'),
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("OK"))
              ],
            ),
          ]));
        });
  }

  static void showRequestInfo(BuildContext context) {
    var requestxcontroller = Get.find<Requestcontroller>();
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
                            requestxcontroller.canceling.value
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
