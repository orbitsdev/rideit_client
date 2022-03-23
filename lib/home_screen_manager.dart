import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/pagecontroller.dart';
import 'package:tricycleapp/controller/requestcontroller.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/model/availabledriver.dart';
import 'package:tricycleapp/model/request_details.dart';
import 'package:tricycleapp/screens/payment_screen.dart';
import 'package:tricycleapp/screens/me_screen.dart';
import 'package:tricycleapp/screens/request_screen.dart';
import 'package:tricycleapp/screens/request_tricycle_sreen.dart';
import 'package:tricycleapp/screens/trip_screen.dart';
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
    RequestScreen(),
    TripScreen(),
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

    // ever(pagexcontroller.pageindex , (_)=> refreshPage() );
    
    listentoavailabledriver();
    listenIfHasRequest();

//    requesstxcontroller.checkIdhasOngoinRequestNotRead(); 
    authxcontroller.checkIfAcountDetailsIsNull();
    
  }



  void listentoavailabledriver() async{

        List<String> testlist = [];
       availabledriversrefference.where('status',isEqualTo: 'online').snapshots().listen((qeurySnapShot) {
        

        print("_____________listetning to availbale driver");

       requesstxcontroller.listofavailabledriver(qeurySnapShot.docs.map((e) {
          var data = e.data() as Map<String, dynamic>;
          data['driver_id'] = e.id;
          Availabledriver availabledriver= Availabledriver.fromJson(data);
          return availabledriver;
        }).toList());

            requesstxcontroller.devicetokens.clear();
        if(requesstxcontroller.listofavailabledriver.length >0){

              requesstxcontroller.listofavailabledriver.forEach((element) {
                print(element.device_token);
                requesstxcontroller.devicetokens.add(element.device_token);    
               });
        }


        print('available_______________driver device');
        print(requesstxcontroller.devicetokens.length);
        print('available_______________driver lenth');
        print(requesstxcontroller.listofavailabledriver.length);

     });
  }

  void listenIfHasRequest() async{

      
      requestrefference.doc(authinstance.currentUser!.uid).snapshots().listen((event) { 
        
          if(event.data() !=  null){
           requesstxcontroller.currentrequest(RequestDetails.fromJson(event.data() as Map<String, dynamic>));
           
          }else{
            print('_____________________listening to current request');
            print('_____________________libut nolllt');
            print('_____________________lio current request');

          }
     

      });

  }

  bool isdiddepencicalled = false;

  @override
  void didChangeDependencies() {

    if(isdiddepencicalled == false){
      requesstxcontroller.checkIdhasOngoinRequestNotRead(context); 

      setState(() {
        isdiddepencicalled = true;
      });

    }
    super.didChangeDependencies();
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
        textStyle:TextStyle(fontSize: 12, color: TEXT_WHITE, fontWeight: FontWeight.w300),
        tabIconColor: ICON_GREY,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor:  Colors.transparent,
        tabIconSelectedColor: GREEN_LIGHT,
        tabBarColor: BACKGROUND_BLACK,
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