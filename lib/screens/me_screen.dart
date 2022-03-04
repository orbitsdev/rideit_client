import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/profile_controller.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/signin_screen.dart';
import 'package:path/path.dart' as p;

class MeScreen extends StatefulWidget {
  static const screenName = '/me';

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
var profilexcontroller = Get.find<ProfileController>();
var authcontoller =  Get.find<Authcontroller>();
File? image;
UploadTask? task;

Future pickedImage(ImageSource imagesource) async{
 
       final selectedimage = await ImagePicker().pickImage(source: imagesource,maxHeight: 480, imageQuality: 85) ; 
       if(selectedimage == null) return;
       final temporaryimage =  File(selectedimage.path);
       final image_file_name =  DateTime.now().millisecond.toString() +  p.basename(temporaryimage.path);
       final destinationwithfile = "passengerusers/${image_file_name}";
      task =  await profilexcontroller.uploadFile(destinationwithfile, temporaryimage);  
      //stop when not uploaded
      if(task ==  null) return;
      final snapshot =  await task!.whenComplete(() => null);
      final downloadedUrl =  await snapshot.ref.getDownloadURL();
      var isUpdated = await  profilexcontroller.updateProfileImage(downloadedUrl , destinationwithfile);
      //get image file name
        if(isUpdated){
            setState(() {
            image =  temporaryimage;
      });
        }


      //  print(p.basename(temporaryimage.path));
      //  print(destination);
        // final localdocumentstorage = await getApplicationDocumentsDirectory();
       //print(localdocumentstorage.path);
  
      
        
     
}
@override
  void initState() {

    print(')))))))))))))))))))))(((((((((((((((');
    print(authcontoller.user.value.image_url);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: 
      
      
      Column(
        children: [ 
            Stack(
              children:[ 


                authcontoller.user.value.image_url !=  null ? 
         
              Image.network(

                    authcontoller.user.value.image_url as String, fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress){
                      
                      if(progress ==  null){
                        return child;
                      }
                      return  Center(child: CircularProgressIndicator(),);
                    },  
                    height: 170,
                    width: 170,
                    ): Container(
                      height: 100,
                      width: 100,
                      color: Colors.green,
                    ), 
             
                  

                // Obx((){
                //     return  Container(
                //     height: 100,
                //     width: 200,
                //     child: Text(authcontoller.user.value.image_url as String),
                //   );
                // }),
                  
                // Center(
                //   child: Image.network(
                //     authcontoller.user.value.image_url as String,
                //     loadingBuilder: (context, child, progress){
                //       if(progress == null){
                //         return child;
                //       }else{
                //       return Container(
                //         height: 170,
                //         width: 170,
                //         child:     Center(child: CircularProgressIndicator(),),
                //       );

                //       }
                //     },
                //     fit: BoxFit.cover,
                //       height: 170,
                //       width: 170,
                //     ),
                // ),

                //  Image.network(
                //    child: ClipRRect(
                //                  borderRadius: BorderRadius.circular(100),
                //                  child: Container(
                //     width: 170,
                //     height: 170,
                //     color: Colors.pinkAccent,
                //     child:   image != null?  Image.file(image as File, fit: BoxFit.cover,) :  Text("No Image")),
                               
                //                  ),
                //  ),

                Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                    onPressed: () {
                    pickedImage(ImageSource.camera);
                    },
                    icon: Icon(
                      Icons.camera_alt,
                    ),
                    iconSize: 34,
                    color: Colors.white))
                 ]),


      ElevatedButton(onPressed: (){
        pickedImage(ImageSource.gallery);
      }, child: Text("Galeery")),

       ElevatedButton(
              onPressed: () {
                authinstance.signOut();
                Get.offAllNamed(SigninScreen.screenName);
              },
              child: Text('Signout')),
              ]
        ,


      
      ),
    );
  }
}
