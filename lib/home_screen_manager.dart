import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/pagecontroller.dart';
import 'package:tricycleapp/controller/requestcontroller.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/screens/home_screen.dart';
import 'package:tricycleapp/screens/me_screen.dart';
import 'package:tricycleapp/screens/request_tricycle_sreen.dart';
import 'package:tricycleapp/screens/trip_history_screen.dart';
import 'package:tricycleapp/testwidgets/dashboard.dart';
import 'package:tricycleapp/uiconstant/constant.dart';
import 'package:tricycleapp/uiconstant/hex_color.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';

import 'screens/ongoingtrip.dart';



class HomeScreenManager extends StatefulWidget {
static const screenName = '/homescreenmanager';
  

  @override
  _HomeScreenManagerState createState() => _HomeScreenManagerState();
}

class _HomeScreenManagerState extends State<HomeScreenManager> with TickerProviderStateMixin {
  var requesstxcontroller = Get.put(Requestcontroller());
  var pagexcontroller = Get.put(Pagecontroller());
  var authxcontroller = Get.find<Authcontroller>();

    Color colorwhite = HexColor("#fbfefb");
    Color iconcolor = HexColor("#2F2191");
    Color iconcolorsecondary = HexColor("#594DAF");
     

  TabController? _tabController;
  List<Widget> _pages =[
    Dashboard(),
    HomeScreen(),
    TripHistoryScreen(),
    MeScreen(),
  ];



  List<String?> _pagename = ["Dashboard", "Home", "Trip", "Me"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: pagexcontroller.pageindex.value,
      length: _pages.length,
      vsync: this,
    );

    requesstxcontroller.checkIdhasOngoinRequestNotRead(); 
    authxcontroller.checkIfAcountDetailsIsNull();
    
  }
  @override
  void setState(VoidCallback fn) {
    
    if(mounted){
    super.setState(fn);

    }
    // TODO: implement setState
  }

void requestListiners() async{
   var requeststatus =   requestrefference.doc(authinstance.currentUser!.uid).snapshots();
          
         requestrefference.doc(authinstance.currentUser!.uid).snapshots().listen((event) {
          if(event.data() != null){
               var data = event.data()  as Map<String, dynamic>;

                  print('_______status');
                  print(data['status']);
                if(data['status'] =="accepted"){
                  Get.back();
                  pagexcontroller.updatePageIndex(2);
                  Get.offNamed(Ongoingtrip.screenName);
                  

                }

                 if(data['tripstatus'] =="complete"){
                  
                  handelrDialog("completed");

                }

          
          }      
         
        });
}


  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =  Theme.of(context);
    return Scaffold(
    
      bottomNavigationBar: MotionTabBar(
        
        initialSelectedTab: _pagename[pagexcontroller.pageindex.value] as String,
        useSafeArea: true, // default: true, apply safe area wrapper
        labels: _pagename,
        icons: const [Icons.dashboard, Icons.home, Icons.history, Icons.people_alt],

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
        textStyle:theme.textTheme.subtitle1,
        tabIconColor: iconcolor,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: iconcolorsecondary,
        tabIconSelectedColor: COLOR_WHITE,
        tabBarColor: colorwhite,
        onTabItemSelected: (int value) {
            pagexcontroller.updatePageIndex(value);
             setState(() {
            _tabController!.index = pagexcontroller.pageindex.value;
            
             });
        },
      ),
        body: 
        
        TabBarView(
          physics: NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
          controller: _tabController,
          // ignore: prefer_const_literals_to_create_immutables
          children:_pages,
        ),
    );
  }
}