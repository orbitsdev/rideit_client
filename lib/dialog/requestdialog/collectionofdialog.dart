

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleapp/UI/constant.dart';


void infoDialog(String message){
  Get.defaultDialog(
    radius: 2,
    backgroundColor: Colors.black54,
    title: '',
    titlePadding: EdgeInsets.all(0),
    content: Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: [
              Text(message, style: Get.theme.textTheme.headline6,),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(onPressed: (){
                Get.back();
                Get.back();
        
              }, child: Text('Ok')),
            ],
        ),
      ) ,
    ),); 
}
void internetinfoDialog(String title, String body){
  Get.defaultDialog(
    radius: 2,
    backgroundColor: Colors.black54,
    title: '',
    titlePadding: EdgeInsets.all(0),
    content:  Container(
             decoration: const BoxDecoration(
                color: DIALOG_WHITE,
               borderRadius: BorderRadius.all(Radius.circular(containerRadius)),
             ),
           
            
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(


                mainAxisSize: MainAxisSize.min,
                children: 
                [ 

                  Container(
                  
                    width: double.infinity,
                    child:  Lottie.asset('assets/images/97572-connecting.json', )
                  ),

            
                  Column(
                    children: [
                      Text(title.toUpperCase(), style:Get.textTheme.headline1,),
                      SizedBox(height: 5,),
                      Container(child: Text(body,  textAlign: TextAlign.center, style: Get.textTheme.headline4  ,)),
                      SizedBox(height: 20,),
                      ElevatedButton(
                            
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                                  
                                  primary: Colors.redAccent ,
                                  minimumSize: const Size.fromHeight(50)),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('OK'.toUpperCase() , style: Get.textTheme.headline3,)),
                    ],
                  )
                ],
              ),
            )
             ),
    ); 
}