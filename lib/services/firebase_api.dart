import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import 'package:path_provider/path_provider.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/model/users.dart';

class FirebaseApi {
  static Future<UploadTask?> uploadFile(String destionation, File file) async {

    try {
      final ref = storage.ref(destionation);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return null;  
    }
  }

  static Future<UploadTask?> uploauploadBytes(
      String destionation, Uint8List data) async {
    try {
      final ref = storage.ref(destionation);
      return ref.putData(data);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return null;
    }
  }

  static Future<bool> updateProfile(String imageurl, String file) async {
    bool isupdate = false;
    var lastimagefile; 
     try {

      await userrefference
        .doc(authinstance.currentUser!.uid)
        .get()
        .then((value) async {
          var data =  value.data() as Map<String, dynamic>;
          lastimagefile = data["image_file"];

          
        await userrefference.doc(authinstance.currentUser!.uid).update({
          "image_url": imageurl,
          "image_file": file,
          
        }).then((value) async {
          if(lastimagefile != null){
          await storage.ref(lastimagefile).delete();
          isupdate = true;    

           Fluttertoast.showToast(
                                    msg: "Updated Success",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: ELSA_GREEN,
                                    fontSize: 16.0);
          }
          
        });

          

    });

      } catch (e) {
        isupdate = false;
      }

   

    return isupdate;
  }

  static Future<Users?> getUserDetails() async {
    Users? userdetails;
    userdetails = await userrefference
        .doc(authinstance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.data() != null) {
        var data = value.data() as Map<String, dynamic>;
        print(data);
        var newuserdetails = Users.fromJson(data);
        print('_______________________________________________');
        print('_______________________________________________');
        print('_______________________________user details');
        print(newuserdetails.image_url);
        return newuserdetails;
      } else {
        return null;
      }
    });
    if (userdetails != null) {
      print(userdetails.image_url);
    }

    return userdetails;
  }
}
