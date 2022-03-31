import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class RequestBuilder extends StatelessWidget {



final String picklocationname;
final String droplocationname;
final IconData pickicon;
final IconData dropicon;

  const RequestBuilder({
    Key? key,
    required this.picklocationname,
    required this.droplocationname,
    required this.pickicon,
    required this.dropicon,
  }) : super(key: key);


  @override
  Widget build(BuildContext context){
    var LIGHT_CONTAINER;
    return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: LIGHT_CONTAINER,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 
                                  Row(
                                    children: [
                                      Container(
                                          width: 40,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(17)),
                                              //
                                          ),
                                          padding: EdgeInsets.all(12),
                                          child: Center(
                                            child: FaIcon(
                                              pickicon,
                                              color: ELSA_PINK,
                                              size: 24,
                                            ),
                                          )),
                                      Horizontalspace(8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'From',
                                              style: Get.textTheme.headline1!
                                                  .copyWith(
                                                      color: ELSA_PINK,
                                                      fontSize: 16,

                                                          ),
                                            ),
                                            Verticalspace(4),
                                            Text(
                                              '${picklocationname}',
                                              style: Get
                                                  .theme.textTheme.bodyText1!
                                                  .copyWith(
                                                color: ELSA_TEXT_WHITE,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w100
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          width: 40,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(17)),
                                              //
                                          ),
                                          padding: EdgeInsets.all(12),
                                          child: Center(
                                            child: FaIcon(
                                              dropicon,
                                              color: ELSA_GREEN,
                                              size: 24,
                                            ),
                                          )),
                                      Horizontalspace(8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'To',
                                              style: Get.textTheme.headline1!
                                                  .copyWith(
                                                      color: ELSA_GREEN,
                                                      fontSize: 16,

                                                          ),
                                            ),
                                            Verticalspace(4),
                                            Text(
                                              '${droplocationname}',
                                              style: Get
                                                  .theme.textTheme.bodyText1!
                                                  .copyWith(
                                                color: ELSA_TEXT_WHITE,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w100
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),

                                  
                                ],
                              ));
  }
}
