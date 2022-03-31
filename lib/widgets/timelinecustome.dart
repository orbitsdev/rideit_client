import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class Timelinecustome extends StatelessWidget {
  final String title;
  final String label;
  final String subtitle;
  final Color color;
  final bool status;
   
  const Timelinecustome({
    Key? key,
    required this.title,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.status,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
                      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(left: 4, top: 1, bottom: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      
      ),
      constraints: const BoxConstraints(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(

                height: 40,
                width: 40,
                child: Center(
                  child: FaIcon(FontAwesomeIcons.checkCircle, color: color),
                ),
              ),

              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: Get.textTheme.bodyText1!.copyWith(
                          fontSize: 16,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Text(
                        label,
                        style: Get.textTheme.bodyText1!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: color as Color,
                        ),
                      ),
                        Verticalspace(4),
                      if(status)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '[ ${subtitle} ]'.toUpperCase(),
                            style: Get.textTheme.bodyText1!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: color as Color,
                            ),
                          ),
                          Horizontalspace(8),
                         
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
