

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/signin_screen.dart';

class EmailverifyingScreen extends StatefulWidget {

  static const screenName ="/emailverifying";

  @override
  State<EmailverifyingScreen> createState() => _EmailverifyingScreenState();
}



class _EmailverifyingScreenState extends State<EmailverifyingScreen> with WidgetsBindingObserver {
bool isEmailVerified = false;
Timer? time;  

var autxcontroller =  Get.find<Authcontroller>();

  @override
  void initState() {

  WidgetsBinding.instance!.addObserver(this);

  checkIfEmailIsNotVerified();
    super.initState();
    
    
  }

@override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    if(time !=  null){
    time!.cancel();

    }

    super.dispose();
  }
 
 @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
     if(state == AppLifecycleState.resumed){
       checkIfEmailIsNotVerified();
      print('resumed called');
       
             }

     if(state == AppLifecycleState.paused){
       print('paused called');
       time!.cancel();
     }
  }
 
  void checkIfEmailIsNotVerified() async{

 //await autxcontroller.sendVerification();
    print('_____________________veriyf start');
    isEmailVerified =  authinstance.currentUser!.emailVerified;

    if(!isEmailVerified){
        time = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }

  }


  Future  checkEmailVerified() async{

    print("timer called___________________________________timer");

    await authinstance.currentUser!.reload();

    setState(() {
      isEmailVerified =  authinstance.currentUser!.emailVerified;
    });

    if(isEmailVerified){
    time!.cancel();
    Get.offAllNamed(HomeScreenManager.screenName);

    } 



  }

  @override
  Widget build(BuildContext context){
    return  Scaffold(
      body: Column(
        
      children: [

        Center(child: Text('Verifying Email')),
        ElevatedButton(onPressed: (){
          authinstance.signOut();
          Get.offAllNamed(SigninScreen.screenName);
        }, child: Text('Cancel'))   
        ],

      ),
    );
  }
}