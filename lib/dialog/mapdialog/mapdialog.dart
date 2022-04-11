
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/screens/request_screen.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/map/maptype_builder.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class Mapdialog {

static void showMapProgress( String message) {
    Get.defaultDialog(
      title: '',
      radius: 6,
      titlePadding: EdgeInsets.all(0),
     contentPadding:   EdgeInsets.only(right: 18, left: 18, bottom: 0, top: 18),
      barrierDismissible: false,
      backgroundColor: Colors.black,
      content:Container(
              decoration: BoxDecoration(
              
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
           
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
    
        
        }
        static void showMapOption(BuildContext context, Function changeMapType) {
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
              padding:EdgeInsets.symmetric(vertical: 16,),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [   

                    Text(
                      'Select Map Type',
                      style: Get.textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Verticalspace(12),                    
                    Wrap(
                      children: [

                       GestureDetector(
                         onTap: (){
                            changeMapType(MapMode.hybrid);
                            Get.back();
                         },
                         child: MaptypeBuilder(name: 'Hybrid', image: 'assets/images/138621.png')
                         ),

                       GestureDetector(
                         onTap: (){
                            changeMapType(MapMode.satelite);
                            Get.back();
                         },
                         child: MaptypeBuilder(name: 'Satilite', image: 'assets/images/flutter-google-maps31.png',)
                         ),
                     
                      
                      
                       GestureDetector(
                         onTap: (){
                            changeMapType(MapMode.darkmode);
                            Get.back();
                         },
                         child: MaptypeBuilder(name: 'Darkmode', image: 'assets/images/darkmode.png',)
                         ),
                     
                       GestureDetector(
                         onTap: (){
                            changeMapType(MapMode.normal);
                            Get.back();
                         },
                         child: MaptypeBuilder(name: 'Normal', image: 'assets/images/normalmap.png',)
                         ),

                      ],
                    ),

                  ]),
            ),
          );
        });
  }
}