import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/passenger_controller.dart';
import 'package:tricycleapp/controller/requestcontroller.dart';

import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({Key? key}) : super(key: key);
  static const screenName = '/tripscreen';

  @override
  _TripHistoryScreenState createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  var requestxcontroller = Get.find<Requestcontroller>();
  var passengerxcontroller = Get.find<PassengerController>();
  bool hasongointrip = false;
  bool loadingrequest = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    this.tabController.addListener(() => setState(() {}));
  }

  bool isdepencycalled = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
  }


  
 

@override
  void setState(VoidCallback fn) {
    if(mounted){
    super.setState(fn);

    }
  }

  void tripSetter(bool value) {
    setState(() {
      hasongointrip = value;
    });
  }

  void loaderSetter(bool value) {
    setState(() {
      loadingrequest = value;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child:
         Column(children: [
          Container(
            padding: EdgeInsets.only(top: 40),
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
            ),
            height: 80,
            child: TabBar(
                controller: tabController,
                labelColor: TEXT_COLOR_WHITE,
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ELSA_BLUE_2_,
                      ELSA_BLUE_1_,
                    ],
                  ),
                ),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Pending".toUpperCase()),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Ongoing".toUpperCase()),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Records".toUpperCase()),
                    ),
                  ),
                ]),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    BACKGROUND_TOP,
                    BACKGROUND_BOTTOM,
                  ],
                ),
                borderRadius:
                    BorderRadius.all(Radius.circular(containerRadius)),
              ),
              child: TabBarView(
                controller: tabController,
                children: [
                  Container(child: Center(child: Text('pending request'),),),
                  Container(child: Center(child: Text('Ongoingtirp'),),),
                  Container(child: Center(child: Text('Records'),),),
                ],
              ),
            ),
          ),
        ]),
       
      ),
    );
  }

  
  

  

}
