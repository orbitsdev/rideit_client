import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/sigup_screen.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';



class SigninScreen extends StatefulWidget {
  static const screenName = '/signin';

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  var authxcontroller = Get.find<Authcontroller>();
  var email = TextEditingController();
  var password = TextEditingController();
  bool isobscure = true; 
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void login() {
    var isValidated = _formkey.currentState!.validate();

    if (isValidated) {
      _formkey.currentState!.save();  
      authxcontroller.logInUser(email.text, password.text, context);
    }
  }


  @override
  void initState() {
   password.addListener(() { 
     setState(() {
       
     });
   });

   email.addListener(() { 
     setState(() {
       
     });
   });
    super.initState();
    
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
      backgroundColor: BACKGROUND_BLACK,
      body: SingleChildScrollView(
      
        child: Form(
        
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: Column(

                

                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Verticalspace(MediaQuery.of(context).size.height *0.1),
               
                SizedBox(
                  height: 24
                ),
                  Container(
                  child: Image.asset('assets/images/Group1.png', fit: BoxFit.cover,),
                  height: 180,
                ),
                SizedBox(
                  height: 34
                ),
                  
                TextFormField(
                  cursorColor: GREEN_LIGHT_3,
                  autofocus: false,
                  enableSuggestions: true,
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
                    prefixIcon: Icon(Icons.email_outlined, color: GREEN_LIGHT,),
                     suffixIcon: email.text.isEmpty ? null :  IconButton( onPressed: (){
                        email.clear();

                     }, icon: Icon(Icons.close,color: GREEN_LIGHT, )),
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
                  obscureText: isobscure,
                  cursorColor: GREEN_LIGHT_3,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  controller: password,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_){
                    login();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                     suffixIcon: password.text.isEmpty ? null :  IconButton( onPressed: (){
                        setState(() {
                            isobscure = !isobscure;
                        });

                     }, icon: Icon(isobscure ? Icons.remove_red_eye_outlined: Icons.remove_red_eye,color: GREEN_LIGHT, )),
                    fillColor: BACKGROUND_BLACK_LIGHT,
                    prefixIcon: Icon(Icons.lock_outline,color: GREEN_LIGHT,),
                    
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
                    Column(
                    
                    children: [
                     
                      ElevatedButton(
                        
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                              
                              primary: GREEN_LIGHT,
                              minimumSize: const Size.fromHeight(50)),
                          onPressed: () {
                            login();
                          },
                          child: Text('Sign in' , style: TextStyle(fontSize: 20, color: BACKGROUND_BLACK, fontWeight: FontWeight.w700),)),
                      SizedBox(
                        height: 15,
                      ),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Dont have an account?'),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                                Get.to(()=> SignupScreen());
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: GREEN_LIGHT),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
