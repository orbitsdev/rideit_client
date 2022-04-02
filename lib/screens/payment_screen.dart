import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapdatacontroller.dart';
import 'package:tricycleapp/controller/permissioncontrooler.dart';
import 'package:tricycleapp/controller/requestdatacontroller.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/uiconstant/widget_function.dart';
import 'package:tricycleapp/widgets/homewidgets/detailsbuilder.dart';
import 'package:tricycleapp/widgets/homewidgets/paymensummarybox.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  static const screenName = "/paymentscreen";

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int currenStep = 0;
  late String paymentmethod;
  var mapadatacontroller = Get.find<Mapdatacontroller>();
  var authcontroller = Get.find<Authcontroller>();
  var requestcontrolelr = Get.find<Requestdatacontroller>();
  void setPaymentMethod(String value) {
    setState(() {
      paymentmethod = value;
      mapadatacontroller.paymentmethod = value;

    });
    print(paymentmethod);
  }

//map variales

  

  @override
  void initState() {
    super.initState();
 
    paymentmethod = mapadatacontroller.paymentmethod;
  }

  

  

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          elevation: 0,

          leading: IconButton(onPressed: currenStep == 0?  (){
              Get.back();
          }:  null, icon:FaIcon(FontAwesomeIcons.arrowLeft)),
        ),
        body: SingleChildScrollView(
            child: Column(
                    children: [
                     
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Theme(
                          data: ThemeData(
                              colorScheme:
                                  ColorScheme.light(primary: ELSA_BLUE_1_)),
                          child: Stepper(
                              physics: ClampingScrollPhysics(),
                              margin: EdgeInsets.all(0),
                              controlsBuilder: (BuildContext context,
                                  ControlsDetails functions) {
                                return Container(
                                  margin: EdgeInsets.only(top: 4, bottom: 100),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(

                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Divider(
                                          thickness: 1,
                                          color: ELSA_TEXT_LIGHT,
                                        ),
                                        if (currenStep != 0)
                                          Expanded(
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                              ),
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors
                                                              .transparent,
                                                          elevation: 0),
                                                  onPressed:
                                                      functions.onStepCancel,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          child: Center(
                                                              child: FaIcon(
                                                        FontAwesomeIcons
                                                            .angleLeft,
                                                        size: 24,
                                                      ))),
                                                      Horizontalspace(5),
                                                      Text(
                                                        'Back',
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                            ),
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .pressed))
                                                        return Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(0.5);
                                                      else if (states.contains(
                                                          MaterialState
                                                              .disabled))
                                                        return LIGHT_CONTAINER2;
                                                      return currenStep == getStep(context).length -1
                                                          ? GREEN_ONLINE
                                                          :  DARK_GREEN; // Use the component's default.
                                                    },
                                                  ),
                                                ),
                                              

                                                onPressed: paymentmethod ==
                                                            'null' &&
                                                        currenStep == 0
                                                    ? null
                                                    : functions.onStepContinue,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: Text(currenStep == getStep(context).length -1 
                                                          ? 'Request'.toUpperCase()
                                                          : 'Continue'.toUpperCase()),
                                                    ),
                                                    if( currenStep == getStep(context).length -1)
                                                    Container(
                                                        child: Center(
                                                            child: FaIcon(
                                                     
                                                           FontAwesomeIcons
                                                              .motorcycle,
                                                         
                                                      size: 24,
                                                    )))
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
                              // onStepTapped: (step){
                              //     if(paymentmethod != 'null'){

                              //     setState((){
                              //       currenStep = step;
                              //     });
                              //     }
                              // },
                              steps: getStep(context),
                              currentStep: currenStep,
                              onStepContinue: () {
                                final isLastStep =
                                    currenStep == getStep(context).length - 1;
                                if (isLastStep) {
                                    if(requestcontrolelr.listofavailabledriver.length != 0){
                                      
                                        requestcontrolelr.createRequest(context);
                                    }else{
                                        Infodialog.showInfoToastCenter('No available drivers found');
                                    }
                                

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
                    ],
                  )),
      ),
    );
  }

  List<Step> getStep(BuildContext context) => [
        
        Step(
            state: currenStep > 0? StepState.complete : StepState.indexed,
            isActive: currenStep >= 0,
            title: Text('Payment'),
            content: Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                  
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          color: LIGHT_CONTAINER,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment method',
                              style: Get.textTheme.headline1!.copyWith(
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
                            activeColor:  DARK_GREEN,
                            onChanged: (val) {
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          color: LIGHT_CONTAINER,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Summary',
                              style: Get.textTheme.headline1!.copyWith(
                                color: ELSA_TEXT_WHITE,
                                fontSize: 16,
                              )),
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                          Text(
                              'Your current location will be uses as your pickup address',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w100)),
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                          Paymensummarybox(
                              title: 'From',
                              value:
                                  '${mapadatacontroller.pickuplocationDetails.value.placeformattedaddress}'),
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                          Paymensummarybox(
                              title: 'To',
                              value:
                                  '${mapadatacontroller.droplocationDetails.value.placeformattedaddress}'),
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                          
                          Paymensummarybox(title: 'Distance', value: '${mapadatacontroller.directionDetails.value.distanceText}'),
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
                                    child: Text('Amount to pay',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                                Horizontalspace(16),
                                Flexible(
                                  child: Text('₱ ${mapadatacontroller.calculateFee()}.00'
                                    ,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Step(
            state: currenStep >= 1 ? StepState.complete : StepState.indexed,
            isActive: currenStep >= 1,
            title: Text('Review'),
            content: Container(
              padding: EdgeInsets.all(8),
              color: LIGHT_CONTAINER,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Personal information',
                      style: Get.textTheme.headline1!.copyWith(
                        color: ELSA_TEXT_WHITE,
                        fontSize: 16,
                      )),
                  Divider(
                    thickness: 1,
                    color: ELSA_TEXT_LIGHT,
                  ),
                  Detailsbuilder(title: 'Your name', body: '${authcontroller.user.value.name}'),
                  Verticalspace(4),
                  Verticalspace(4),
                  Detailsbuilder(title: 'Phone number', body: '${authcontroller.user.value.phone}'),
                  Divider(
                    thickness: 1,
                    color: ELSA_TEXT_LIGHT,
                  ),
                  Text('Request information',
                      style: Get.textTheme.headline1!.copyWith(
                        color: ELSA_TEXT_WHITE,
                        fontSize: 16,
                      )),
                  Divider(
                    thickness: 1,
                    color: ELSA_TEXT_LIGHT,
                  ),
                  Verticalspace(4),
                  Detailsbuilder(title: 'From', body: '${mapadatacontroller.pickuplocationDetails.value.placeformattedaddress}'),
                  Verticalspace(4),
                  Detailsbuilder(title: 'To', body: '${mapadatacontroller.droplocationDetails.value.placeformattedaddress}'),
                  Verticalspace(4),
                  Detailsbuilder(title: 'Distance', body: '${mapadatacontroller.directionDetails.value.distanceText}'),
                  Divider(
                    thickness: 1,
                    color: ELSA_TEXT_LIGHT,
                  ),
                  Text('Payment information',
                      style: Get.textTheme.headline1!.copyWith(
                        color: ELSA_TEXT_WHITE,
                        fontSize: 16,
                      )),
                  Divider(
                    thickness: 1,
                    color: ELSA_TEXT_LIGHT,
                  ),
                  Verticalspace(4),
                  Detailsbuilder(title: 'Payment method', body: '${mapadatacontroller.paymentmethod}'),
                  Verticalspace(4),
                  Divider(
                    thickness: 1,
                    color: ELSA_TEXT_LIGHT,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            child: Text('Total ',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                          ),
                        ),
                        Horizontalspace(16),
                        Flexible(
                          child: Text(
                            '₱ ${mapadatacontroller.calculateFee()}.00',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ];
}
