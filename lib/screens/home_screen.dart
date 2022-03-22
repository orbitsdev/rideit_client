import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/widgets/homewidgets/detailsbuilder.dart';
import 'package:tricycleapp/widgets/homewidgets/paymensummarybox.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const screenName = "/request_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currenStep = 0;
  late String paymentmethod;

  void setPaymentMethod(String value) {
    setState(() {
      paymentmethod = value;
    });
    print(paymentmethod);
  }

  @override
  void initState() {
    super.initState();
    paymentmethod = "none";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Theme(
          data:
              ThemeData(colorScheme: ColorScheme.light(primary: ELSA_BLUE_1_)),
          child: Stepper(
              controlsBuilder:
                  (BuildContext context, ControlsDetails functions) {
                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Center(
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (currenStep != 0)
                         Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),

                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0
                                ),
                                onPressed: functions.onStepCancel,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                     Container(   child: Center(child: FaIcon(FontAwesomeIcons.angleLeft , size: 24, ))),
                                    Horizontalspace(5),
                                    Text('Back', ),
                                  ],
                                )),
                          ),
                        ),
                        if (currenStep != 0) Horizontalspace(50),
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),

                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: ELSA_BLUE_1_,
                                ),
                                onPressed: functions.onStepContinue,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Next'),Horizontalspace(5), Container(   child: Center(child: FaIcon(FontAwesomeIcons.angleRight , size: 24,)))
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              type: StepperType.horizontal,
              steps: getStep(),
              currentStep: currenStep,
              onStepContinue: () {
                final isLastStep = currenStep == getStep().length - 1;
                if (isLastStep) {
                  print('comoplerte');
                } else {
                  setState(() {
                    currenStep += 1;
                    print(currenStep);
                  });
                }
              },
              onStepCancel: () {
                if (currenStep != 0) {
                  setState(() {
                    currenStep -= 1;
                  });
                }
              }),
        ),
      ),
    );
  }

  List<Step> getStep() => [
        Step(
            state: currenStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currenStep >= 0,
            title: Text('Location'),
            content: Container(
              child: Center(
                child: Text('Map'),
              ),
            )),
        Step(
            state: currenStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currenStep >= 1,
            title: Text('Payment'),
            content: Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   width: double.infinity,
                    //   child: Text(
                    //     'Payment Details',
                    //     style: Get.textTheme.headline5!.copyWith(
                    //       fontSize: 20,
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    Verticalspace(20),
                    Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                     decoration: BoxDecoration(

                      color: LIGHT_CONTAINER,
                      borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text('Payment method', style: Get.textTheme.headline1!.copyWith(
                            color: ELSA_TEXT_WHITE,
                            fontSize: 16,
                          )),
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                          RadioListTile(
                            toggleable: true,
                            value: 'Cash',
                            groupValue: paymentmethod,
                            activeColor: ELSA_BLUE,
                            onChanged: (val) {
                              print(val);

                              setPaymentMethod(val.toString());
                            },
                            title: Text(
                              'Cash',
                              style: Get.textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Verticalspace(20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(

                      color: LIGHT_CONTAINER,
                      borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Summary', style: Get.textTheme.headline1!.copyWith(
                            color: ELSA_TEXT_WHITE,
                            fontSize: 16,
                          )),
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                          Paymensummarybox(title: 'From', value: 'Isulan Sultan Kudarat Salem St dIsulan Sultan '),
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                          Paymensummarybox(title: 'To', value: 'Isulan Sultan Kudarat Salem St dIsulan Sultan '),
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                          Paymensummarybox(title: 'Distance', value: '1 km'),
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                           Container(
    
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Container(
                                    child: Text('Amount to pay', style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                    )),
                                  ),
                                ),
                                Horizontalspace(16),
                                Flexible(
                                  child: Text('₱ 10.00', style: TextStyle(
                                    fontSize: 24,

                                    fontWeight: FontWeight.w900
                                  ), ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Step(
            state: currenStep >= 2 ? StepState.complete : StepState.indexed,
            isActive: currenStep >= 2,
            title: Text('Review'),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                     Text('Personal information', style: Get.textTheme.headline1!.copyWith(
                            color: ELSA_TEXT_WHITE,
                            fontSize: 16,
                          )),
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                    Detailsbuilder(title: 'Your name', body: 'Kate Kristine'),
                    Verticalspace(4),
                    Verticalspace(4),
                    
                    Detailsbuilder(title: 'Phone number', body: '0938383123'),
                  
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                     Text('Request information', style: Get.textTheme.headline1!.copyWith(
                            color: ELSA_TEXT_WHITE,
                            fontSize: 16,
                          )),
                           Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                    Verticalspace(4),
                    Detailsbuilder(title: 'From', body: 'Isulan Sultan Kudarat'),
                    Verticalspace(4),
                    Detailsbuilder(title: 'To', body: 'Bamab Sultan Kudarat'),
                    Verticalspace(4),
                    Detailsbuilder(title: 'Distance', body: '1.5 km'),
                      Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                     Text('Payment information', style: Get.textTheme.headline1!.copyWith(
                            color: ELSA_TEXT_WHITE,
                            fontSize: 16,
                          )),
                      Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                    Verticalspace(4),
                    Detailsbuilder(title: 'Payment method', body: 'Cash'),
               
                    Verticalspace(4),
                    Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),                   Container(
    
                         
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Container(
                                    child: Text('Total ', style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                    )),
                                  ),
                                ),
                                Horizontalspace(16),
                                Flexible(
                                  child: Text('₱ 10.00', style: TextStyle(
                                    fontSize: 24,

                                    fontWeight: FontWeight.w900
                                  ), ),
                                ),
                              ],
                            ),
                          )
             
               
                ],
              ),
            )),
      ];
}
