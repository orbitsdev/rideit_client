import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/screens/ongoingtrip.dart';
import 'package:tricycleapp/widgets/elsabutton.dart';

import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/tripwidget/custompinlocation.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';
import 'package:url_launcher/url_launcher.dart';

class OngoingTripBuilder extends StatelessWidget {
final String topay;
final String drivername;
final String driverphone;
final String picklocation;
final String droplocation;
  const OngoingTripBuilder({
    Key? key,
    required this.topay,
    required this.drivername,
    required this.driverphone,
    required this.picklocation,
    required this.droplocation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context){
    return  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Verticalspace(12),
            
            Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    BACKGROUND_BOTTOM,
                    BACKGROUND_TOP,
                  ],
                ),
                borderRadius:
                    BorderRadius.all(Radius.circular(containerRadius)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To pay',
                            style: Get.textTheme.bodyText1!
                                .copyWith(fontWeight: FontWeight.w300),
                          ),
                          RichText(
                            text: TextSpan(
                              style: Get.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 34),
                              children: [
                                TextSpan(
                                    text: '₱ ',
                                    style: TextStyle(color: Colors.amber[300])),
                                TextSpan(
                                    text:
                                        '${topay}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.all(12),
                      child: FaIcon(
                        FontAwesomeIcons.coins,
                        color: Colors.amber[400],
                        size: 34,
                      )),
                ],
              ),
            ),
            Verticalspace(12),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(containerRadius)),
                  color: LIGHT_CONTAINER,
                ),
                constraints: BoxConstraints(minHeight: 200),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Horizontalspace(12),
                        ClipOval(
                          child: Material(
             
                            child: InkWell(
                              splashColor: Colors.red, // Splash color
                              onTap: () {
                                Infodialog.info(context,'If you press the phone number it will redirect you to the dial number ☺️');

                              },
                              child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(17)),
                                //
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    ELSA_GREEN,
                                    ELSA_BLUE,
                                  ],
                                )),
                            child: Center(
                                child: FaIcon(
                              FontAwesomeIcons.exclamation,
                              color: Colors.white,
                            ))
                            ),
                          ),
                        )
                        ),
                      ],
                    ),
                    Custompinlocation(
                        title: 'Driver name',
                        lication:
                            '${drivername}',
                        icon: FontAwesomeIcons.user,
                        color: ELSA_BLUE_2_),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          await launch(
                              'tel:093123123');
                        },
                        child: Custompinlocation(
                            title: 'Drive Phone',
                            lication:
                                '9083712731723',
                            icon: FontAwesomeIcons.mobileAlt,
                            color: ELSA_ORANGE),
                      ),
                    ),
                    Custompinlocation(
                        title: 'Your Pickup Location',
                        lication:
                            '${picklocation}',
                        icon: FontAwesomeIcons.mapMarkerAlt,
                        color: ELSA_PINK),
                    Custompinlocation(
                        title: 'Your Drop off Location',
                        lication:
                            '${droplocation}',
                        icon: FontAwesomeIcons.mapPin,
                        color: ELSA_GREEN),
                  ],
                ),
              ),
            ),
            Verticalspace(24),
            Elsabutton(
                label: 'View',
                function: () {
                    Get.off(()=> Ongoingtrip(), fullscreenDialog: true, transition: Transition.rightToLeft);
                }
                ),
            Verticalspace(120),
          ],
        ),
      );
  }
}
