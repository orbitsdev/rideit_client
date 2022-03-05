import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/config/twilioconfig.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/emailverifying_screen.dart';
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
        await firestore.collection('passengers').doc(credential.user!.uid).set({
          "name": gname as String,
          "email": gemail as String,
          "phone": gphone as String,
          "image_url": null,
          "image_file": null
        }).then((_) async {
          Get.back();
          
          

          // Get.back();
          // verifyPhone(context);
          // Get.offAllNamed(HomeScreenManager.screenName);

          //check if verified
          mailverified = authinstance.currentUser!.emailVerified;

          if (mailverified == false) {
            await sendVerification();
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

  void logInUser(String email, String password, BuildContext context) async {
    try {
      progressDialog("Loading...");
      var authuser = await authinstance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      Get.back();
      progressDialog("Checking...");
      await firestore
          .collection('passengers')
          .doc(authuser.user!.uid)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.data() != null) {
          var data = print(querySnapshot.data());

          Users userdata =
              Users.fromJson(querySnapshot.data() as Map<String, dynamic>);
          userdata.id = authuser.user!.uid;
          user(userdata);

          //make global variable
          firebaseuser = authuser.user;

           mailverified = authinstance.currentUser!.emailVerified;
          

          if (mailverified == false) {
            await sendVerification();
            Get.back();
            Future.delayed(Duration(milliseconds: 300), () => Get.offNamed(EmailverifyingScreen.screenName));
          } else {
            Get.back();
            progressDialog('Authenticating..');
            Future.delayed(Duration(seconds: 1), () {
             
              Get.back();
              Get.offAndToNamed(HomeScreenManager.screenName);
            });
          }
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

  void checkIfAcountDetailsIsNull() async {
    if (user.value.id == null) {
      await firestore
          .collection('passengers')
          .doc(authinstance.currentUser!.uid)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.data() != null) {
          var data = querySnapshot.data() as Map<String, dynamic>;
          var useracount = Users.fromJson(data);
          useracount.id = authinstance.currentUser!.uid;
          user(useracount);

          print(user.value.id);
          print(user.value.name);
          print(user.value.phone);
          print('________________________________________');
          print('__________________________________________');
          print('____________________________________________');
          print('______________________________________________');
          print(user.value.image_file);
          print(user.value.image_url);
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
}
