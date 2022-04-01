import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapdatacontroller.dart';
import 'package:tricycleapp/controller/requestdatacontroller.dart';
import 'package:tricycleapp/dialog/dialog_collection.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/screens/driver_location_screen.dart';
import 'package:tricycleapp/widgets/homewidgets/paymensummarybox.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/timelinecustome.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Ongoingtrip extends StatefulWidget {
  const Ongoingtrip({Key? key}) : super(key: key);
  static const screenName = '/ongoingtrip';
  @override
  _OngoingtripState createState() => _OngoingtripState();
}


class _OngoingtripState extends State<Ongoingtrip> {

var requestxcontroller = Get.find<Requestdatacontroller>();
var mapdataxcontroller = Get.find<Mapdatacontroller>();

  
@override
  void setState(VoidCallback fn) {
    
    if(mounted){
      super.setState(fn);

    }
  }



bool isReady = false;
bool hasData = false;



void prepaireData () async{



  var response = await requestxcontroller.checkTripData();
  print('_____resposmne');
  print(response);
   if(response){
    
    
    setState(() {
      isReady= true;
      hasData= true;
      
    });
     await requestxcontroller.monitorOngoingTrip();
  }else{

     setState(() {
      isReady= true;
      hasData= false;
    });

  }
  
}

  @override
  void initState() {
    super.initState();
    prepaireData();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.off(()=> HomeScreenManager());
        }, icon: FaIcon(FontAwesomeIcons.times)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: !isReady 
        ?  Container(
          height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator(
                color: ELSA_BLUE_2_,
              ),),
       ):
        hasData == false 
        ?Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         
          Lottie.asset(
            'assets/images/66528-qntm.json',
          ),
          Text('No current trip yet ',
              style: Get.textTheme.headline1!.copyWith(
                  color: ELSA_TEXT_GREY,
                  fontSize: 24,
                  fontWeight: FontWeight.w800)),
          Verticalspace(8),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              'Where would you like to go?',
              textAlign: TextAlign.center,
              style: Get.theme.textTheme.bodyText1!.copyWith(
                color: ELSA_TEXT_GREY,
              ),
            ),
          ),
          Verticalspace(100),
        ],
      ),
    )
        :Obx((){

      
          
          return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Verticalspace(16),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          //          ElevatedButton(onPressed: (){
          //   DialogCollection.showpaymentToBePayed((requestxcontroller.ongoingtrip.value.fee).toString());
          // }, child: Text('text')),
                  Container(
                    width: double.infinity,
                  ),
                  ClipOval(
                      child: Container(
                    color: TEXT_WHITE_2,
                    padding: EdgeInsets.all(2),
                    child: ClipOval(
                        child: requestxcontroller.ongoingtrip.value.driver_image_url ==  null ? Image.asset(
                      'assets/images/images.jpg',
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                    ): Image.network(
                      '${requestxcontroller.ongoingtrip.value.driver_image_url}',
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                    )),
                  )),
                  Verticalspace(8),
                  Text( '${requestxcontroller.ongoingtrip.value.driver_name}',
                      style: Get.textTheme.headline1!.copyWith(
                          color: ELSA_TEXT_WHITE, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center),
                  Text('Driver',
                      style: Get.textTheme.headline1!.copyWith(
                          color: ELSA_TEXT_GREY,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center),
                  Verticalspace(8),
                 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0,),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      
                        Verticalspace(8),
                        InkWell(
                          onTap: () async {
                            await launch('tel:${requestxcontroller.ongoingtrip.value.driver_phone}');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                            
                               width: 20,
                               height: 30,
                                child: Center(
                                  
                                  child: FaIcon(
                                    FontAwesomeIcons.mobileAlt,
                                    color: ELSA_GREEN,
                                    size: 20,
                                  ),
                                ),
                              ),
                               Horizontalspace(8),
                              Text('${requestxcontroller.ongoingtrip.value.driver_phone}'.toUpperCase(),
                                  style: Get.textTheme.headline1!.copyWith(
                                      color: ELSA_TEXT_WHITE,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w100),
                                  textAlign: TextAlign.center),
                             
                            ],
                          ),
                        ),
                        
                        Verticalspace(2),
                        InkWell(
                          onTap: () async {
                              Get.to(()=> DriverLocationScreen() ,fullscreenDialog: true, transition: Transition.rightToLeft);
                          },
                          child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
 
                                width: 20,

                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.mapMarkerAlt,
                                    color: ELSA_PINK,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Horizontalspace(8),
                              Text('View location',
                                  style: Get.textTheme.headline1!.copyWith(
                                      color: ELSA_TEXT_WHITE,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w100),
                                  textAlign: TextAlign.center),
                              
                            ],
                          ),
                        ),
                        Verticalspace(8),
                         
                      ],
                    ),
                  ),
                  Verticalspace(12),
                  
                ],
              ),
            ),
          

            Container(
              decoration: BoxDecoration(    
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: LIGHT_CONTAINER,
              ),
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Request Details'.toUpperCase()),
                  Divider(
                    thickness: 1,
                    color: ELSA_TEXT_GREY,
                  ),
                  Verticalspace(8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0,),                        
                        constraints: BoxConstraints(
                          minWidth: 50
                        ),
                        child: Text('From')),
                      Horizontalspace(30), 
                      Flexible(child: Text('${requestxcontroller.ongoingtrip.value.pick_location_id }', style: Get.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w100
                      ),), ), 
                    ],
                  ),
                 Divider(
                    thickness: 1,
                    color: ELSA_TEXT_GREY,
                  ),
                  Verticalspace(8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8.0,),
                        constraints: BoxConstraints(
                          minWidth: 50
                        ),
                        child: Text('To')),
                      Horizontalspace(30), 
                      Flexible(child: Text('${requestxcontroller.ongoingtrip.value.dropddress_name}', style: Get.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w100
                      ),), ), 
                    ],
                  ),
                 Divider(
                    thickness: 1,
                    color: ELSA_TEXT_GREY,
                  ),
                  Verticalspace(8),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //                               padding: EdgeInsets.symmetric(horizontal: 8.0,),
                  //       constraints: BoxConstraints(
                  //         minWidth: 50
                  //       ),
                  //       child: Text('Distance')),
                  //     Horizontalspace(30), 
                  //     Flexible(child: Text('${mapdataxcontroller.directionDetails.value.distanceText}', style: Get.textTheme.bodyText1!.copyWith(
                  //       fontWeight: FontWeight.w100
                  //     ),), ), 
                  //   ],
                  // ),
                 
                //  Divider(
                //     thickness: 1,
                //     color: ELSA_TEXT_GREY,
                //   ),
                  Verticalspace(8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8.0,),
                        constraints: BoxConstraints(
                          minWidth: 50
                        ),
                        child: Text('Total Payment', style: Get.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w900
                      ),) ),
                      Horizontalspace(30), 
                      Flexible(child: Text('₱ ${requestxcontroller.ongoingtrip.value.fee }.00', style: Get.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w900
                      ),), ), 
                    ],
                  ),
                 
                ],
              ),
            ),

            Verticalspace(12),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(    
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: LIGHT_CONTAINER,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Text('Current Trip Details'.toUpperCase()),
                     Divider(
                    thickness: 1,
                    color: ELSA_TEXT_GREY,
                  ),

                  TimelineTile(
                    isFirst: true,
                    afterLineStyle:
                        LineStyle(thickness: 2, color:  requestxcontroller.currentStatus >= 1 ?  GREEN_ONLINE :ELSA_TEXT_GREY ),
                    alignment: TimelineAlign.start,
                    indicatorStyle: IndicatorStyle(
                      color:requestxcontroller.currentStatus >= 0 ?  GREEN_ONLINE :ELSA_TEXT_GREY,
                    ),
                    endChild: Timelinecustome(
                      title: 'preparing',
                      label: 'Driver is preparing for the the trip',
                      subtitle: 'ready',
                      color: requestxcontroller.currentStatus >= 0 ?  GREEN_ONLINE :ELSA_TEXT_GREY,
                      status: true,
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    indicatorStyle: IndicatorStyle(
                      color: requestxcontroller.currentStatus >= 1 ?  GREEN_ONLINE :ELSA_TEXT_GREY,
                    ),
                    beforeLineStyle:
                        LineStyle(thickness: 2, color: requestxcontroller.currentStatus >= 1 ?  GREEN_ONLINE :ELSA_TEXT_GREY),
                    afterLineStyle:
                        LineStyle(thickness: 2, color: requestxcontroller.currentStatus >= 2 ?  GREEN_ONLINE :ELSA_TEXT_GREY),
                    endChild: Timelinecustome(
                      title: 'COMING',
                      label: 'Driver is on the way ',
                      subtitle: 'travelling',
                      color: requestxcontroller.currentStatus >= 1 ?  GREEN_ONLINE :ELSA_TEXT_GREY,
                      status: true,
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    indicatorStyle: IndicatorStyle(
                      color: requestxcontroller.currentStatus >= 2 ?  GREEN_ONLINE :ELSA_TEXT_GREY,
                    ),
                    beforeLineStyle:
                        LineStyle(thickness: 2, color: requestxcontroller.currentStatus >= 2 ?  GREEN_ONLINE :ELSA_TEXT_GREY),
                    afterLineStyle:
                        LineStyle(thickness: 2, color: requestxcontroller.currentStatus >= 2 ?  GREEN_ONLINE :ELSA_TEXT_GREY),
                    endChild: Timelinecustome(
                      title: 'Arrived',
                      label: 'Driver has arrived ',
                      subtitle: 'Waiting',
                      color: requestxcontroller.currentStatus >= 2 ?  GREEN_ONLINE :ELSA_TEXT_GREY,
                      status: true,
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    indicatorStyle: IndicatorStyle(
                      color: requestxcontroller.currentStatus >= 4?  GREEN_ONLINE :ELSA_TEXT_GREY,
                    ),
                    beforeLineStyle:
                        LineStyle(thickness: 2, color: requestxcontroller.currentStatus >= 4?  GREEN_ONLINE :ELSA_TEXT_GREY),
                    afterLineStyle:
                        LineStyle(thickness: 2, color: requestxcontroller.currentStatus >= 4?  GREEN_ONLINE :ELSA_TEXT_GREY),
                    endChild: Timelinecustome(
                      title: 'Complete',
                      label: 'Succesffuly dilivered you at the destination',
                      subtitle: 'dilivered',
                      color:  requestxcontroller.currentStatus >= 4?  GREEN_ONLINE :ELSA_TEXT_GREY,
                      status: true,
                    ),
                  ),
                  TimelineTile(
                    isLast: true,
                    alignment: TimelineAlign.start,
                    indicatorStyle: IndicatorStyle(
                      color: requestxcontroller.ongoingtrip.value.payed  ==  true?  GREEN_ONLINE :ELSA_TEXT_GREY,
                    ),
                    beforeLineStyle:
                        LineStyle(thickness: 2, color:requestxcontroller.ongoingtrip.value.payed  ==  true?   GREEN_ONLINE :ELSA_TEXT_GREY),
                    afterLineStyle:
                        LineStyle(thickness: 2, color:requestxcontroller.ongoingtrip.value.payed  ==  true?   GREEN_ONLINE :ELSA_TEXT_GREY),
                    endChild: Timelinecustome(
                      title: 'Payment',
                      label: 'successfully paid the fee',
                      subtitle: 'payed',
                      color:requestxcontroller.ongoingtrip.value.payed  ==  true?   GREEN_ONLINE :ELSA_TEXT_GREY,
                      status: true,
                    ),
                  ),
                ],
              ),
            ),
            Verticalspace(20)
          ],
        );
        }), 
      ),
    );
  }
  
}
