import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/home_screen_manager.dart';

class Ongoingtrip extends StatelessWidget {
  static const screenName="/ongoingtrip";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Column(
        children: [

          ElevatedButton(onPressed: (){
            Get.toNamed(HomeScreenManager.screenName);
          }, child: Text('go to home')),
          Container(
          child: Center(
            child: Text("triscreen"),
          ),
    ),
        ],
      ),
    );
  }
}