import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/signin_screen.dart';

class MeScreen extends StatelessWidget {
  static const screenName = '/me';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
         await authinstance.signOut().then((value) {
            
            Get.offAllNamed(SigninScreen.screenName) ;} );
        },
        child: Text('Signout'),
      ),
    );
  }
}
