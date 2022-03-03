import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogCollection {

static void showpaymentToBePayed(BuildContext context){

  showDialog(
                                     
                                     barrierDismissible: false,
                                      context: context, builder: (context){
                                    return Dialog(
                                      child:Column(mainAxisSize: MainAxisSize.min, children: [
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('₱ 50'),
                                                        Text('To Be Payed'),
                                                        ElevatedButton(onPressed: () {
                                                            Get.back();
                                                          
                                                        }, child: Text("OK"))
                                                      ],
                                                    ),
                                                  ])
                                        
                                    );
                                   });
  }
}
