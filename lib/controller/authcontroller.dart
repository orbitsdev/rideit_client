import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/config/twilioconfig.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/model/users.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';

class Authcontroller extends GetxController {
  
  var user = Users().obs;
  late TwilioPhoneVerify _twilioPhoneVerify;
  var isSignUpLoading = false.obs;
  var isCodeSent = false.obs;
  var isVerifying = false.obs;


  String? gname;
  String? gphone;
  String? gemail;
  String? gpassword;

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();

    _twilioPhoneVerify = TwilioPhoneVerify(
        accountSid: Twilioconfig.ACCOUNT_SID,
        serviceSid:  Twilioconfig.SERVICE_SID,
        authToken: Twilioconfig.AUTH_TOKEN);



  }

  
  void createUser(String name, String phone, String email, String password,
      BuildContext context) async {
    gname = name.trim();
    gphone = "+63" + phone.trim();
    gemail = email.trim();
    gpassword = password.trim();

    try {
      isSignUpLoading(true);
      await authinstance
          .createUserWithEmailAndPassword(
              email: gemail as String, password: gpassword as String)
          .then((credential) async {
        // progressDialog('Authenticating..');
        await firestore.collection('passengers').doc(credential.user!.uid).set({
          "name": gname as String,
          "email": gemail as String,
          "phone": gphone as String,
        }).then((_) async {
          // Get.back();
         // verifyPhone(context);
          // Get.offAllNamed(HomeScreenManager.screenName);

          progressDialog('Authenticating...');
        Future.delayed(Duration(seconds: 1), () {
          Get.back();
          clearFields();
          Get.offAndToNamed(HomeScreenManager.screenName);
        });
        });
      });
    } on FirebaseAuthException catch (e) {
      isSignUpLoading(false);

      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: e.message.toString(),
        desc: e.message.toString(),
        btnOkOnPress: () {},
      )..show();
    } catch (e) {
      rethrow;
    }
  }

  void verifyPhone(BuildContext context) async {
    var twilioResponse = await _twilioPhoneVerify.sendSmsCode(gphone as String);
    if (twilioResponse.successful as bool) {
      isSignUpLoading(false);
      isCodeSent(true);
    } else {
      isSignUpLoading(false);
      isCodeSent(false);
      print('______from twiilio');
      print(twilioResponse.statusCode);
      notificationDialog(context, twilioResponse.errorMessage.toString());
      print(twilioResponse.errorMessage);
    }
  }

  void verifyCode(String smsCode, BuildContext context) async {
    isVerifying(true);
    var twilioResponse = await _twilioPhoneVerify.verifySmsCode(
        phone: gphone as String, code: smsCode.trim());

    if (twilioResponse.successful as bool) {
      if (twilioResponse.verification!.status == VerificationStatus.approved) {
        //print('Phone number is approved');
        isVerifying(false);
        progressDialog('Authenticating...');
        Future.delayed(Duration(seconds: 1), () {
          Get.back();
          clearFields();
          Get.offAndToNamed(HomeScreenManager.screenName);
        });
      } else {
        isVerifying(false);
        //print('Invalid code');
        notificationDialog(context, 'Inavlid Code');
      }
    } else {
      isVerifying(false);
      notificationDialog(context, twilioResponse.errorMessage.toString());
      //print(twilioResponse.errorMessage);
    }
  }

  void getUserData() async{

      if(user.value.id == null){
         try{

         await userrefference.doc(authinstance.currentUser!.uid).get().then((querySnapshot) {

            var data = querySnapshot.data() as Map<String, dynamic>;
            
           if (querySnapshot. data() != null) {

           Users userdata = Users();
          userdata.id = authinstance.currentUser!.uid;
          userdata.name = data['name'];
          userdata.email = data['email'];
          userdata.phone = data['phone'];
          



          print('___userdata _________');
          print(userdata.id);
          print(userdata.name);
          print(userdata.phone);
          print(userdata.email);

          user = userdata.obs;
          
        }
        

         });

      }catch(e){
        
        print(e.toString());
      }
      }else{
        print('not null');
      }

     
   
  }


  void logInUser(String email, String password, BuildContext context) async {
    try {
      progressDialog("Loading...");
      var authuser = await authinstance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      Get.back();
      progressDialog("Authenticating...");
      await firestore
          .collection('passengers')
          .doc(authuser.user!.uid)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.data() != null) {
          print(querySnapshot.data());

          Users userdata = Users();
          userdata.id = authuser.user!.uid;
          userdata.name = querySnapshot.data()!['name'];
          userdata.email = querySnapshot.data()!['email'];
          userdata.phone = querySnapshot.data()!['phone'];
          


          //make global variable    
          firebaseuser = authuser.user;
          user = userdata.obs;
          
          Get.back();
          Get.offAllNamed(HomeScreenManager.screenName);
        } else {
          Get.back();
          notificationDialog(context, 'User doesnt exist');
          authinstance.signOut();
        }
      });
    } on FirebaseAuthException catch (e) {
      Get.back();
      notificationDialog(context, e.message.toString());
    } catch (e) {
      rethrow;
    }
  }

  void clearFields() {
    gname = null;
    gemail = null;
    gphone = null;
    gpassword = null;
  }
}
