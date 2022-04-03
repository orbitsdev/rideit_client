import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/requestdatacontroller.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tricycleapp/widgets/onboarding_builder.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  static const String screenName ="/boardingscreen";

  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  var pagecontroller = PageController();
  var requestxcontroller = Get.find<Authcontroller>();
  
  bool isLastIndex = false;
  @override
  void dispose() {
    pagecontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      
      body: Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: pagecontroller,
          onPageChanged: (index) {
            setState(() => isLastIndex = index == 2);
          },
          children: [
            OnboardingBuilder(title: 'Ride service solution', body: 'Our goal is to connect passengers and driver wherever they are. ', image: 'assets/images/rider.png'),
            OnboardingBuilder(title: 'How It works', body: 'Select destination, review request details and make request', image: 'assets/images/Directions-rafiki.png'),
            OnboardingBuilder(title: 'Join with us', body: 'We are ready to serve you let\'s go!', image: 'assets/images/Welcome-cuate.png'),
          ],
        ),
      ),
      bottomSheet: Container(
              height: 80,
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              color: BOTTOMNAVIGATOR_COLOR,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: SmoothPageIndicator(
                      onDotClicked: (index) => pagecontroller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      controller: pagecontroller,
                      count: 3,
                      effect: WormEffect(
                          activeDotColor: PINK_1, dotColor: LIGHT_CONTAINER),
                    ),
                  ),
                 
                  Horizontalspace(50),
                  Obx((){

                    if(requestxcontroller.gettingstartedload.value ==true){
                        
                          return Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ELSA_BLUE_2_,
                                ),
                              ),
                            ),
                          );
                    }

                    return  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(50),
                      color: isLastIndex
          ? ELSA_BLUE_1_: PINK_1,
                      child: InkWell(
                        onTap: (){
                          
                          if(isLastIndex == false){
                              pagecontroller.nextPage(
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            
                            curve: Curves.easeInOut);
                          }else{

                           requestxcontroller.updateToOld();
                          }
                          
                        },

                        child:  Container(
                          height: 50,                         
                          child: Center(child: Text( isLastIndex
          ? 'Get started'.toUpperCase() :'Next', style: Get.textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w600
                          ),)),
                        ),
                      ),
                    ),
                  );


                        }),
                 
                ],
              ),
            ),
    );
  }
}
