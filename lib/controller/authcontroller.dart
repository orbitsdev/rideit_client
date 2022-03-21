import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:tricycleapp/config/twilioconfig.dart';
import 'package:tricycleapp/dialog/authdialog/authdialog.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/dialog/failuredialog/failuredialog.dart';
import 'package:tricycleapp/emailverifying_screen.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/model/users.dart';
import 'package:tricycleapp/verifyingemail_screen.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';

class Authcontroller extends GetxController {
  var hasinternet = false.obs;
  var user = Users().obs;
  late TwilioPhoneVerify _twilioPhoneVerify;
  
  var isSignUpLoading = false.obs;
  var isCodeSent = false.obs;
  var isVerifying = false.obs;
  bool mailverified = false;

  String? gname;
  String? gphone;
  String? gemail;
  String? gpassword;

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();

    // _twilioPhoneVerify = TwilioPhoneVerify(
    //     accountSid: Twilioconfig.ACCOUNT_SID,
    //     serviceSid:  Twilioconfig.SERVICE_SID,
    //     authToken: Twilioconfig.AUTH_TOKEN);
  }

  String? devicetoken;
  Future<void> getDeviceToken() async {
    devicetoken = await messaginginstance.getToken();

    if (devicetoken != null) {
      print('device  token is here__________________');
    }
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
        progressDialog('Checking..');

        await getDeviceToken();
        Map<String, dynamic> userdetailstostore = {
          "name": gname as String,
          "email": gemail as String,
          "phone": gphone as String,
          "image_url": null,
          "image_file": null,
          'device_token': devicetoken,
        };
        await firestore
            .collection('passengers')
            .doc(credential.user!.uid)
            .set(userdetailstostore)
            .then((_) async {
          isSignUpLoading(false);
          user(Users.fromJson(userdetailstostore));
          Get.back();

          // Get.back();
          // verifyPhone(context);
          // Get.offAllNamed(HomeScreenManager.screenName);

          //check if verified
          mailverified = authinstance.currentUser!.emailVerified;

          if (mailverified == false) {
           // await sendVerification();
            Get.back();
            Future.delayed(Duration(milliseconds: 300),
                () => Get.offNamed(EmailverifyingScreen.screenName));
          } else {
            progressDialog('Authenticating..');
            Future.delayed(Duration(seconds: 1), () {
              clearFields();
              Get.back();
              Get.offAndToNamed(HomeScreenManager.screenName);
            });
          }

          // progressDialog('Authenticating...');
        });
      });
    } on FirebaseAuthException catch (e) {
      isSignUpLoading(false);
    Failuredialog.showErrorDialog(context, 'OPS', e.message.toString());
    
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

  void logInUser(String email, String password, BuildContext context) async {
    try {
      Authdialog.showAuthProGress(context, 'Please wait...');
      var authuser = await authinstance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

     
      
      await firestore
          .collection('passengers')
          .doc(authuser.user!.uid)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.data() != null) {
          var data = querySnapshot.data() as Map<String, dynamic>;
          var useracount = Users.fromJson(data);
          useracount.id = authuser.user!.uid;
          user(useracount);


           await getDeviceToken();
          if(devicetoken !=  null){
            if(user.value.device_token != devicetoken){
              await updateDeviceToken(devicetoken);
              user.value.device_token = devicetoken;
            }
          }
          //check mail
          mailverified = authinstance.currentUser!.emailVerified;

          if (mailverified == false) {
            await sendVerification();
           Get.back();
            Future.delayed(Duration(milliseconds: 300),
                () => Get.offNamed(VerifyingemailScreen.screenName));
          } else {
              
            Future.delayed(Duration(seconds: 1), () {
           
            Get.back();
              Get.offAndToNamed(HomeScreenManager.screenName);
            });
          }

        } else {
          Get.back();
          Failuredialog.noDataDialog(context,'Ops', 'User doesnt exist');
  //        notificationDialog(context, 'User doesnt exist');
          authinstance.signOut();
        }
      });
    } on FirebaseAuthException catch (e) {
      Get.back();
       // notificationDialog(context, e.message.toString());
          Failuredialog.noDataDialog(context,'Ops' ,e.message.toString());
    } catch (e) {
      rethrow;
    }
  }

  void checkIfAcountDetailsIsNull() async {
    if (user.value.id == null) {

      await firestore
          .collection('passengers')
          .doc(authinstance.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.data() != null) {
          
          var useracount = Users.fromJson(querySnapshot.data() as Map<String, dynamic>);
          useracount.id = authinstance.currentUser!.uid;
          user(useracount);
          
          await getDeviceToken();
       
          if(devicetoken !=  null){
            if(user.value.device_token !=  devicetoken){
              await updateDeviceToken(devicetoken);
              user.value.device_token = devicetoken;
            }
          }
        

          print(user.value.id);
          print(user.value.name);
          print(user.value.phone);
          print('________________________________________');
          print('__________________________________________');
          print('____________________________________________');
          print('______________________________________________');
          print(user.value.image_file);
          print(user.value.image_url);
          print(user.value.device_token);
        }
      });



    }
  }

  void clearFields() {
    gname = null;
    gemail = null;
    gphone = null;
    gpassword = null;
  }

  Future<void> sendVerification() async {
    try {
      final user = authinstance.currentUser;
      await user!.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

 Future<void> updateDeviceToken(String? devicetoken) async{

    await userrefference.doc(authinstance.currentUser!.uid).update({
      "device_token": devicetoken
    });
    print('device token updated');
  }
}
