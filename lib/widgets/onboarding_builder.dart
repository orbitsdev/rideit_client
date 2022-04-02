import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/dialog/authdialog/authdialog.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class OnboardingBuilder extends StatelessWidget {

  final String title;
  final String body;
  final String image;
  const OnboardingBuilder({
    Key? key,
    required this.title,
    required this.body,
    required this.image,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [

                Verticalspace(30),          
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset('${image}', fit: BoxFit.cover,)),
                Positioned(
                  bottom: 0,
                  left:0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          BOTTOMNAVIGATOR_COLOR,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                      ),
                    ),
                    height: 80,
                  ),
                )
               
              ],
            ),
    
            Container(
              constraints: BoxConstraints(
                minHeight: 200,
              ),
              padding: EdgeInsets.all(22),
         
              child: Column(
                children: [
                  Verticalspace(34),
                  Container(
                    width: double.infinity,
                    child: Center(child: Text(title.toUpperCase(), style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, height: 1),textAlign: TextAlign.center,))),
                  Verticalspace(16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8,),
                    width: double.infinity,
                    child: Center(child: Text(body, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, height: 1.5, wordSpacing: 3) , ))),
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
