import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class TestsignScreen extends StatefulWidget {
  static const screenName = '/testsignin';

  @override
  _TestsignScreenState createState() => _TestsignScreenState();
}

class _TestsignScreenState extends State<TestsignScreen> {
  String? verid;
  String? phone;
  String? pincode;
  bool? codeSent = false;

  

  void verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone as String,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          var snaBar = SnackBar(content: Text('Login Success'));
          ScaffoldMessenger.of(context).showSnackBar(snaBar);
        },
        verificationFailed: (FirebaseAuthException e) {
          var snaBar = SnackBar(content: Text(e.message.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snaBar);
        },
        codeSent: (String verificationId, int? resentToken)  async {
          setState(() {
            codeSent = true;
            verid = verificationId;
          });

        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verid = verificationId;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            codeSent == true
                ? OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 20,
                    style: TextStyle(fontSize: 17),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    onChanged: (String? pin) {
                      if (pin?.length == 6) {}
                    },
                    onCompleted: (pin) {
                      verifyPin(pin);
                    },
                  )
                : IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    initialCountryCode: 'PH',
                    onChanged: (mobile) {
                      setState(() {
                        phone = mobile.completeNumber;
                      });
                    },
                  ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    verifyPhone();
                  },
                  child: Text('Verify')),
            ),
          ],
        ),
      ),
    );
  }

  void verifyPin(String pin) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verid as String, smsCode: pin);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      var snaBar = SnackBar(content: Text('Login Success'));
      ScaffoldMessenger.of(context).showSnackBar(snaBar);
    } on FirebaseAuthException catch (e) {
      var snaBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snaBar);
    } catch (e) {
      rethrow;
    }
  }

  
}
