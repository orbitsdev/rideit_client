import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';

class ProfileController extends GetxController {
  
  var isUpdateProfile = false.obs;
  Future<UploadTask?> uploadFile(String destination, File file) async {
    try {
      //set destination
      progressDialog('Uploadings....');
      final ref = storage.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e.message);
      Get.back();
      return null;
    }
  }

  Future<bool> updateProfileImage(String downloadedurl,  String image_file_name) async {
    bool isUpdated = false;

    String? lastprofileimagefilename;
    try {
      isUpdateProfile(true);
      await userrefference
          .doc(authinstance.currentUser!.uid)
          .get()
          .then((value) async {
        //get last profile name
        var usersdata = value.data() as Map<String, dynamic>;
        lastprofileimagefilename = usersdata['image_file'];
        //update profile into new value
        await userrefference.doc(authinstance.currentUser!.uid).update({
          "image_url": downloadedurl,
          "image_file": image_file_name,

        }).then((value) async {
            Get.find<Authcontroller>().user.value.image_url = downloadedurl;
          if(lastprofileimagefilename != null){
           await storage.ref(lastprofileimagefilename).delete();
          }
          print('succefully deleted');
        });
      });
      isUpdated = true;
            isUpdateProfile(false);
            Get.back();
    } on FirebaseException catch (e) {
      Get.back();
      isUpdated = false;
            isUpdateProfile(false);
    }

    return isUpdated;
  }




}
