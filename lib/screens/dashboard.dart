

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/passenger_controller.dart';
import 'package:tricycleapp/dialog/dialog_collection.dart';
import 'package:tricycleapp/screens/list_screen.dart';
import 'package:tricycleapp/widgets/homewidgets/customsbox.dart';
import 'package:tricycleapp/widgets/homewidgets/totalearningline.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class Dashboard extends StatefulWidget {
  static const screenName = '/dashboard';
const Dashboard({ Key? key }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}




class _DashboardState extends State<Dashboard> {

  var passengerxcontroller = Get.find<PassengerController>();

  @override
  void initState() {
    super.initState();
   
    
  }

  @override
  Widget build(BuildContext context){
   return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: 170),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        BACKGROUND_TOP,
                        BACKGROUND_CEENTER,
                      ],
                    ),
                    // color: BACKGROUND_BLACK_LIGHT_MORE_LIGHT,
                    borderRadius: BorderRadius.only(
                        // topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                        //topLeft: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(


                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    
                    children: [
                      Text(
                        'Total Spend',
                        style: Get.textTheme.bodyText1,
                      ),
                      Verticalspace(8),
                     
                      Container(
                        child: RichText(
                          text: TextSpan(
                            style: Get.textTheme.headline5!.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 34),
                                children: [
                                  TextSpan(text: '₱ ', style: TextStyle(color: Colors.amber[400])),
                                  TextSpan(text: '${passengerxcontroller.totalspend}.00'),
                                 
                                ],
                          ),
                        ),
                        // Text('₱ ${passengerxcontroller.totalearning}.00',style: Get.textTheme.headline5!.copyWith(
                        //   fontWeight: FontWeight.w700,
                        //   fontSize: 34
                        // ), )
                      ),
                      Verticalspace(12),
                      Totalearningline(),
                      Verticalspace(12),
                    ],
                  ),
                ),
                Verticalspace(12),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'Dashboard',
                      style: Get.textTheme.headline5!.copyWith(
                        fontSize: 20,
                      ),
                    )),
                Verticalspace(8),

              
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: GestureDetector(
                          onTap: passengerxcontroller.listofsuccesstrip.length> 0 ? (){
                            Get.to(()=> ListScreen(collection: passengerxcontroller.listofsuccesstrip, ), fullscreenDialog: true, transition: Transition.rightToLeft );
                          } : null,
                          child: Customsbox(
                              title: 'Success',
                              subtitle:
                                  '${passengerxcontroller.totalsuccestrip.value}',
                              icon: Icons.check,
                              colors: [ELSA_GREEN, ELSA_BLUE]),
                        )),
                    Expanded(
                        child: GestureDetector(
                           onTap: passengerxcontroller.listofcanceledtrip.length> 0 ? (){
                            Get.to(()=> ListScreen(collection: passengerxcontroller.listofcanceledtrip, ), fullscreenDialog: true, transition: Transition.rightToLeft);
                          } : null,
                          child: Customsbox(
                              title: 'Canceled',
                              subtitle: '${passengerxcontroller.canceledtrip.value}',
                              icon: Icons.cancel_schedule_send_sharp,
                              colors: [ELSA_ORANGE, ELSA_PINK]),
                        )),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}