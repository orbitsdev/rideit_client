import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/controller/requestcontroller.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/screens/ongoingtrip.dart';

class TripHistoryScreen extends StatefulWidget {
  static const screenName = '/triphistory';

  @override
  _TripHistoryScreenState createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> with SingleTickerProviderStateMixin{
  var requestxcontroller = Get.put(Requestcontroller());
  late TabController controller;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
    // TODO: implement setState
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller =  TabController(length: 2, vsync: this);
    controller.addListener(() { 
      setState(() { });
    });
    requestxcontroller.checkIfHasOnoingTripRequest();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      body: Column(
        children: [
        Container(
          width: double.infinity,
          color: Colors.blueAccent,
          child: TabBar(
            controller: controller,
          indicatorColor: Colors.pinkAccent,
          tabs: [
           Tab(text: 'Ongoing', icon: Icon(Icons.document_scanner)),
                Tab(text: 'History', icon: Icon(Icons.time_to_leave)),
          ],
          ),
        ),

          Expanded(
            child: TabBarView(
              controller: controller,
              children: 
              [
                  Obx((){
                    
                   if(requestxcontroller.loader.value){
        return Container(
          child: Center(child: CircularProgressIndicator()),
        );
      }else{
        
      if(requestxcontroller.hasongoingtrip.value){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("drop location"),
            Text(requestxcontroller.requestdetails.value.dropddressname as String),
            Center(
              child: ElevatedButton(onPressed: (){
                 
                Get.to(Ongoingtrip(from: "trip"));

              }, child: Text('View')),
            )
          ],
        );
        
      }

      return Container(child: Text('nodata'),);
        
         
      }
      
     

                  }),

                tripHistoryBuilder(),
              ]
            ),
          ),
        ],
      ),
    );

   
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> tripHistoryBuilder() {
    return StreamBuilder(
  stream: firestore.collection('passengertriphistory').doc(authinstance.currentUser!.uid).collection('trips').snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    if(!snapshot.hasData){
      return Center(
        child: CircularProgressIndicator(),
      );
        }
      return ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index){
        return ListTile(
          title: Text("${snapshot.data!.docs[index]['dropddress_name']}"),
          subtitle: Text("${snapshot.data!.docs[index]['created_at']}"),
        );
      });

  }
);
  }
}
