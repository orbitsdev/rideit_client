import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/helper/audiiomanger.dart';

import '../../controller/authcontroller.dart';


enum PageState { siningUpPagegSate, otpPageState }

class SignupScreen extends StatefulWidget {
  static const screenName = '/signup';
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  PageState currentPageState = PageState.siningUpPagegSate;

  final FocusNode node1 = FocusNode();

  var autxcontroller = Get.find<Authcontroller>();

  var name = TextEditingController();

  var email = TextEditingController();

  var phone = TextEditingController();

  var password = TextEditingController();

  var confirmpassword = TextEditingController();

  var smsCodeController = TextEditingController();

  bool isObscure1 = true, isObscure2 = true;

  GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    email.addListener(onListen);

    email.addListener(onListen);
    password.addListener(onListen);
    confirmpassword.addListener(onListen);
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.removeListener(onListen);
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmpassword.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void onListen() => setState(() {});

  void signUp() async {
    var isValidated = _signUpFormKey.currentState!.validate();
    if (isValidated) {
      _signUpFormKey.currentState!.save();
      autxcontroller.createUser(
          name.text, phone.text, email.text, password.text, context);
    }
  }

  void verifycode() async {
    var isValidated = _otpFormKey.currentState!.validate();
    if (isValidated) {
      _otpFormKey.currentState!.save();
      autxcontroller.verifyCode(smsCodeController.text, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_BLACK,
      body: SingleChildScrollView(
        child: Form(
          key: _signUpFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            child: Column(
              children: [

               
                SizedBox(height: 24),
                Container(
                  child: Image.asset(
                    'assets/images/Isulan.png',
                    fit: BoxFit.cover,
                  ),
                  height: 180,
                ),
                
                SizedBox(height: 34),
                // ElevatedButton(onPressed: (){
                //   //Failuredialog.showErrorDialog(context, 'OPS', 'ERROR');
                //      Authdialog.showAuthProGress(context, "Checking...");
                // }, child: Text('test')),
                TextFormField(
                  cursorColor: GREEN_LIGHT_3,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  controller: name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: BACKGROUND_BLACK_LIGHT,
                    prefixIcon: Icon(
                      Icons.account_circle_outlined,
                      color: GREEN_LIGHT,
                    ),
                    label: Text(
                      'Name',
                      style: TextStyle(fontSize: 20),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: GREEN_LIGHT)),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: GREEN_LIGHT,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  cursorColor: GREEN_LIGHT_3,
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return EmailValidator.validate(value!) == true
                        ? null
                        : "Enter A Valid Email";
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: BACKGROUND_BLACK_LIGHT,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: GREEN_LIGHT,
                    ),
                    suffixIcon: email.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              email.clear();
                            },
                            icon: Icon(
                              Icons.close,
                              color: GREEN_LIGHT,
                            )),
                    label: Text(
                      'Email',
                      style: TextStyle(fontSize: 20),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: GREEN_LIGHT)),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: GREEN_LIGHT,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  cursorColor: GREEN_LIGHT_3,
                  autofocus: false,
                  keyboardType: TextInputType.phone,
                  controller: phone,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please a valid number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: BACKGROUND_BLACK_LIGHT,
                    prefixIcon: Icon(
                      Icons.phone_android_outlined,
                      color: GREEN_LIGHT,
                    ),
                    label: Text(
                      'Phone',
                      style: TextStyle(fontSize: 20),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: GREEN_LIGHT)),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: GREEN_LIGHT,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  obscureText: isObscure1,
                  cursorColor: GREEN_LIGHT_3,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  controller: password,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: BACKGROUND_BLACK_LIGHT,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: GREEN_LIGHT,
                    ),
                    suffixIcon: password.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure1 = !isObscure1;
                              });
                            },
                            icon: Icon(
                              isObscure1
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                              color: GREEN_LIGHT,
                            )),
                    label: Text(
                      'Password',
                      style: TextStyle(fontSize: 20),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: GREEN_LIGHT)),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: GREEN_LIGHT,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  cursorColor: GREEN_LIGHT_3,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  controller: confirmpassword,
                  obscureText: isObscure2,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    signUp();
                  },
                  validator: (value) {
                    if (value != password.text) {
                      return "Password did not match";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: BACKGROUND_BLACK_LIGHT,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: GREEN_LIGHT,
                    ),
                    suffixIcon: confirmpassword.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure2 = !isObscure2;
                              });
                            },
                            icon: Icon(
                              isObscure2
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                              color: GREEN_LIGHT,
                            )),
                    label: Text(
                      'Confirm Password',
                      style: TextStyle(fontSize: 20),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: GREEN_LIGHT)),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: GREEN_LIGHT,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),

                Obx(() {
                  if (autxcontroller.isSignUpLoading.value == true) {
                    return Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: GREEN_LIGHT,
                    ));
                  }
                  return Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              primary: GREEN_LIGHT,
                              minimumSize: const Size.fromHeight(50)),
                          onPressed: () {
                            signUp();
                          },
                          child: Text(
                            'Sign-up'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 20,
                                color: BACKGROUND_BLACK,
                                fontWeight: FontWeight.w700),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already Have an account?'),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              'Signin',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: GREEN_LIGHT),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
