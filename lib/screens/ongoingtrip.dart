
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/controller/requestcontroller.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/screens/driver_location_screen.dart';
import 'package:tricycleapp/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Ongoingtrip extends StatefulWidget {

static const screenName = '/ongoingtrip';
  @override
  _OngoingtripState createState() => _OngoingtripState();
}



class _OngoingtripState extends State<Ongoingtrip> {
  var requestxcontroller = Get.find<Requestcontroller>();

  @override
  void initState() {
    super.initState();
    

    requestxcontroller.listenToOngoingTrip();

    
  
  }



  @override
  Widget build(BuildContext context) {

     print(Get.arguments["from"]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(

        
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          Container(
            height: 170,
            width: 170,
            child: Image.asset('assets/images/default-user-avatar.jpg'),
          ),
          Text('John Hernadez', style: Get.theme.textTheme.headline3,),
          Text('Driver', style: Get.theme.textTheme.bodyText1,),

        Obx((){

          if(requestxcontroller.tripisnotcompleted.value){
            return Container();
          }
          return  Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                 Text('Your Driver Is ${requestxcontroller.ongoingtripdetails.value.tripstatus }', style: Get.theme.textTheme.headline3,),
                 SizedBox(
                   height: 12,
                 ),
                GestureDetector(
                  onTap: () async{
                      await launch('tel:09366303145');
                             },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.phoneAlt,),
                
                        SizedBox(
                          width: 12,
                        ),
                    
                    
                      Text('093663123123 ', style: Get.theme.textTheme.headline3,),
                     
                    ],
                  ),
                ),
                SizedBox(
           height: 12,
         ),


       //  if(requestxcontroller.ongoingtripdetails.value.tripstatus != "prepairing")
          ElevatedButton(onPressed: (){
           Get.to(DriverLocationScreen(), fullscreenDialog: true,  transition: Transition.downToUp, duration: Duration(milliseconds: 700), curve: Curves.decelerate  );
         }, child: Text('View Driver Location')),
           Container(
             height: 1,
             color: Colors.red,
                width: double.infinity,
              ),
              ],
            ),
          );
        }),
         
        if(Get.arguments["from"] != null)
        if(Get.arguments["from"] !="trip")
          Container(
              child: ElevatedButton(onPressed: (){

                
                print(Get.arguments["from"]);
                goToScreen();

              }, child: Text("back")),
          ),
        ],
      ),
    ),
    );
  }


  void goToScreen(){
    print(Get.arguments["from"]);
    if(Get.arguments["from"] =="request"){
      
      Get.toNamed(HomeScreenManager.screenName);

    } if(Get.arguments["from"] =="trip"){
      Get.back();

    }

    
  }
}