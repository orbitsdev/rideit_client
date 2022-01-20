import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/sigup_screen.dart';

class SigninScreen extends StatefulWidget {
  static const screenName = '/signin';

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  var authxcontroller = Get.find<Authcontroller>();
  var email = TextEditingController();
  var password = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void login() {
    var isValidated = _formkey.currentState!.validate();

    if (isValidated) {
      _formkey.currentState!.save();
      authxcontroller.logInUser(email.text, password.text, context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: Column(
                children: [
                  TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email enter a name';
                      }

                      if (!value.contains("@")) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(
                        'Email',
                        style: TextStyle(fontSize: 14),
                      ),
                      hintStyle: TextStyle(fontSize: 10),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    controller: password,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      login();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(
                        'Password',
                        style: TextStyle(fontSize: 14),
                      ),
                      hintStyle: TextStyle(fontSize: 10),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          child: Text('Signin')),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Dont Have account?'),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(SigupScreen.screenName);
                            },
                            child: Text(
                              'Signup',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
