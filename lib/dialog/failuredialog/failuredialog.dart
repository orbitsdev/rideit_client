
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';


class Failuredialog {
static void noDataDialog(BuildContext context, String title, String body){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
         return Dialog(
           insetPadding:const EdgeInsets.all(containerPadding),
           backgroundColor: Colors.transparent,
           child: Container(
             decoration: const BoxDecoration(
                color: colorwhite,
               borderRadius: BorderRadius.all(Radius.circular(containerRadius)),
             ),
           
            
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(


                mainAxisSize: MainAxisSize.min,
                children: 
                [ 

                  Container(
                  
                    width: double.infinity,
                    child:  Lottie.asset('assets/images/86045-no-data-found-json.json', )
                  ),

            
                  Column(
                    children: [
                      Text(title.toUpperCase(), style: Get.textTheme.headline1,),
                      SizedBox(height: 5,),
                      Container(child: Text(body,  textAlign: TextAlign.center, style: Get.textTheme.headline4,)),
                      SizedBox(height: 20,),
                      ElevatedButton(
                            
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                                  
                                  primary: Colors.redAccent,
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
        });
  }
static void showErrorDialog(BuildContext context, String title, String body){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
         return Dialog(
           insetPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
           backgroundColor: Colors.transparent,
           child:  Container(
             decoration: const BoxDecoration(
                color: colorwhite,
               borderRadius: BorderRadius.all(Radius.circular(containerRadius)),
             ),
           
            
            child: SingleChildScrollView(
               padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
            
            
                mainAxisSize: MainAxisSize.min,
                children: 
                [ 
            
                  Container(
                  
                    width: double.infinity,
                    child:  Lottie.asset('assets/images/84655-swinging-sad-emoji.json', )
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
                                  
                                  primary: ORRANGE ,
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
        });
  }
static void showInternetConnectionInfoDialog(BuildContext context, String title, String body){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
         return Dialog(
           insetPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
           backgroundColor: Colors.transparent,
           child:  Container(
             decoration: const BoxDecoration(
                color: colorwhite,
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
                    child:  Lottie.asset('assets/images/84655-swinging-sad-emoji.json', )
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
                                  
                                  primary: ORRANGE ,
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
        });
  }

  static void shouwUploadFailedDialog(BuildContext context){
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
                      'Failed?',
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
                          child: Text('Ok',
                              style: Get.textTheme.bodyText1!
                                  .copyWith(fontWeight: FontWeight.w400)),
                          onPressed: () async {
                           Get.back();
                          },
                        ),
                      ),
                      Horizontalspace(10),
                      
                    ]),
                  ]),
            ),
          );
        });
  }
}


