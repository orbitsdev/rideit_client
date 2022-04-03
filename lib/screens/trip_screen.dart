import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/passenger_controller.dart';
import 'package:tricycleapp/controller/requestdatacontroller.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/screens/tripdetails_screen.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/tripwidget/custompinlocation.dart';
import 'package:tricycleapp/widgets/tripwidget/listcontainer.dart';
import 'package:tricycleapp/widgets/tripwidget/nodatabuilder.dart';
import 'package:tricycleapp/widgets/tripwidget/ongoing_trip_builder.dart';
import 'package:tricycleapp/widgets/tripwidget/records_builder.dart';
import 'package:tricycleapp/widgets/tripwidget/request_builder.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({Key? key}) : super(key: key);
  static const screenName = '/tripscreen';

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  var requestxcontroller = Get.find<Requestdatacontroller>();
  var passengerxcontroller = Get.find<PassengerController>();
  bool hasongointrip = false;
  bool loadingrequest = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    this.tabController.addListener(() => setState(() {}));
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
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
        child: Column(children: [
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
                      child: Text("Request".toUpperCase()),
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
                   requestxcontroller.monitorcurrentrequest.value.drop_location_id == null
                          ? Nodatabuilder(title: 'No request yet', subtitle: 'Do you want to go somewhere?')
                          :Container(
                    color: BOTTOMNAVIGATOR_COLOR,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child:Obx((){
                        return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              
                              RequestBuilder(picklocationname: '${requestxcontroller.monitorcurrentrequest.value.pickaddress_name}', droplocationname: '${requestxcontroller.monitorcurrentrequest.value.dropddress_name}', pickicon: FontAwesomeIcons.mapMarkerAlt, dropicon: FontAwesomeIcons.mapPin),
                              Verticalspace(12),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Payment'),
                                  Text('₱ ${requestxcontroller.monitorcurrentrequest.value.fee}.00'),
                                ],
                              ),
                              Verticalspace(12),
                              Divider(
                                thickness: 1,
                                color: ELSA_TEXT_GREY,
                              ),
                             
                              Verticalspace(12),

                              if(requestxcontroller.monitorcurrentrequest.value.status == 'pending')
                               requestxcontroller.iscancel.value
                          ? Center(child: CircularProgressIndicator())
                          :
                              Container(
                                    
                                   width: double.infinity,
                                      height: 60,
                                    decoration: const ShapeDecoration(
                                      shape: StadiumBorder(),
                                      gradient: LinearGradient(
                                        end: Alignment.bottomCenter,
                                        begin: Alignment.topCenter,
                                        colors: [
                                             ELSA_PINK,
                                                PINK_1  ,
                                        ],
                                      ),
                                    ),
                                    child: MaterialButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: const StadiumBorder(),
                                      child:  Text(
                                       'Cancel'
                                       ,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () async{
                                         requestxcontroller.cancelRequest(context);
                                      },  
                                    ),
                                  )
                            ],
                          )
                        ],
                      );
                      }) 
                    ),
                  ),
                     requestxcontroller.monitorongoingtrip.value.drop_location_id ==  null
                      ?Nodatabuilder(title:requestxcontroller.monitorcurrentrequest.value.status == "pending"? 'You have a pending request ': 'No current trip yet', subtitle: requestxcontroller.monitorcurrentrequest.value.status == "pending"? 'Wait for the driver to accept' :'You have to request first')
                      : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       
                     OngoingTripBuilder(topay: '500', drivername: 'bnriadn', driverphone: '021039123', picklocation: 'Isulan Sultan Kudarat', droplocation: 'Bambad'),
                                   
                      ],
                    ),
                  ),
                  passengerxcontroller.lisoftriprecord.length == 0
                  ? Nodatabuilder(title: 'No record yet ', subtitle: 'All of your pass tip will display here')
                  : 
                  Container(
                    child:  AnimationLimiter(
           child:RecordsBuilder(),
         ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

}
