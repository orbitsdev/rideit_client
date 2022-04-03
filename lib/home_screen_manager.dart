import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/drivercontroller.dart';
import 'package:tricycleapp/controller/pagecontroller.dart';
import 'package:tricycleapp/controller/passenger_controller.dart';
import 'package:tricycleapp/controller/requestdatacontroller.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/model/availabledriver.dart';
import 'package:tricycleapp/model/request_details.dart';
import 'package:tricycleapp/screens/dashboard.dart';
import 'package:tricycleapp/screens/payment_screen.dart';
import 'package:tricycleapp/screens/me_screen.dart';
import 'package:tricycleapp/screens/request_screen.dart';
import 'package:tricycleapp/screens/request_tricycle_sreen.dart';
import 'package:tricycleapp/screens/trip_screen.dart';

import 'package:tricycleapp/uiconstant/constant.dart';
import 'package:tricycleapp/uiconstant/hex_color.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:getwidget/getwidget.dart';
import 'screens/ongoingtrip.dart';

class HomeScreenManager extends StatefulWidget {
  static const screenName = '/homescreenmanager';

  @override
  _HomeScreenManagerState createState() => _HomeScreenManagerState();
}

class _HomeScreenManagerState extends State<HomeScreenManager>
    with TickerProviderStateMixin {
  var requesstxcontroller = Get.put(Requestdatacontroller());
  var pagexcontroller = Get.put(Pagecontroller());
    var passengerxcontroller = Get.find<PassengerController>();
  var authxcontroller = Get.find<Authcontroller>();
  var driverxcontroller = Get.find<Drivercontroller>();

  Color colorwhite = HexColor("#fbfefb");
  Color iconcolor = HexColor("#2F2191");
  Color iconcolorsecondary = HexColor("#594DAF");

  TabController? _tabController;
  List<Widget> _pages = [
    Dashboard(),
    //HomeScreen(),
    //RequestScreen(),
    TripScreen(),
    MeScreen(),
  ];

  List<String?> _pagename = ["Dashboard", "Trip", "Me"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: pagexcontroller.pageindex.value,
      length: _pages.length,
      vsync: this,
    );
    
    authxcontroller.monitorUserAccount();
    driverxcontroller.monitorAvailableDriver();
    passengerxcontroller.listenToAllTrip();
    requesstxcontroller.monitorAdminData();
    requesstxcontroller.monitorRequest();
    requesstxcontroller.monitorTrip();

  }

 

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
    
  }


  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab:
            _pagename[pagexcontroller.pageindex.value] as String,
        useSafeArea: true, // default: true, apply safe area wrapper
        labels: _pagename,
        icons: const [Icons.dashboard, Icons.history, Icons.people_alt],

        // optional badges, length must be same with labels
        badges: [
          // Default Motion Badge Widget
          // const MotionBadgeWidget(
          //   text: '99+',
          //   textColor: Colors.white, // optional, default to Colors.white
          //   color: Colors.red, // optional, default to Colors.red
          //   size: 18, // optional, default to 18
          // ),

          // // custom badge Widget
          // Container(
          //   color: Colors.black,
          //   padding: const EdgeInsets.all(2),
          //   child: const Text(
          //     '48',
          //     style: TextStyle(
          //       fontSize: 14,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),

          // // allow null
          // null,

          // // Default Motion Badge Widget with indicator only
          // const MotionBadgeWidget(
          //   isIndicator: true,
          //   color: Colors.red, // optional, default to Colors.red
          //   size: 5, // optional, default to 5,
          //   show: true, // true / false
          // ),
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: TextStyle(
            fontSize: 12, color: TEXT_WHITE, fontWeight: FontWeight.w300),
        tabIconColor: ICON_GREY,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Colors.transparent,
        tabIconSelectedColor: GREEN_LIGHT,
        tabBarColor: BACKGROUND_BLACK,
        onTabItemSelected: (int value) {
          pagexcontroller.updatePageIndex(value);
          setState(() {
            _tabController!.index = pagexcontroller.pageindex.value;
          });
        },
      ),
      floatingActionButtonLocation:  FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx((){

          if(requesstxcontroller.monitorcurrentrequest.value.drop_location_id != null){
            return Container(height: 0,);
          }
        
        return GestureDetector(
        onTap: () {
           //print(Get.find<Requestdatacontroller>().listofavailabledriver.length);
          if (requesstxcontroller.monitorcurrentrequest.value.drop_location_id == null) {
            
            if (requesstxcontroller.listofavailabledriver.length == 0) {
              Infodialog.showInfoToastCenter('No available drivers found');
             
            } else {
              Get.to(() => RequestScreen(),
                  fullscreenDialog: true,
                  transition: Transition.circularReveal,
                  duration: Duration(milliseconds: 700));
            }
          } else {
            Infodialog.showInfoToastCenter(
                'You can request tricycle again after you finish the current trip ');
          }
        },
        child: ClipOval(
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: BACKGROUND_BLACK,
            ),
            child:
            Center(
              child:  
              Center(
                  child: FaIcon(
                FontAwesomeIcons.motorcycle,
                size: 32,
                color: GREEN_LIGHT,
              )),
              ),
            ),
          ),
        );
      
      })  ,
      //      floatingActionButton:  GFFloatingWidget(

      //      child: GFIconBadge(

      //             child:  ClipOval(
      //               child: Container(

      //                 height: 100,
      //                 width: 100,
      //                 decoration: BoxDecoration(
      //                 color: Colors.red,

      //                 ),
      //                       child: Text('data'),
      //                     ),
      //             ),
      //          counterChild:  GFBadge(
      //            color: Colors.transparent,
      //          text: '',
      //          shape: GFBadgeShape.circle,
      //          )
      //       ),

      //   verticalPosition: MediaQuery.of(context).size.height * 0.88,
      //   horizontalPosition: MediaQuery.of(context).size.width / 2.933333333 ,
      // )  ,
      body: TabBarView(
        physics:
            NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
        controller: _tabController,
        // ignore: prefer_const_literals_to_create_immutables
        children: _pages,
      ),
    );
  }
}
