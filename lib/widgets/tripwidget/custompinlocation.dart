import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';
class Custompinlocation extends StatelessWidget {
  final String title;
  final String lication;
  final IconData icon;
  final Color color;

  const Custompinlocation({
    Key? key,
    required this.title,
    required this.lication,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            title,
            style: Get.textTheme.bodyText1!
                .copyWith(fontWeight: FontWeight.w300, color: ELSA_TEXT_WHITE),
          ),
        ),
        Verticalspace(8),
        Container(
          padding: EdgeInsets.only(
            top: 12,
            bottom: 12,
            right: 5,
          ),
          decoration: BoxDecoration(
            color: BOTTOMNAVIGATOR_COLOR,
            
            borderRadius: BorderRadius.all(Radius.circular(containerRadius)),
          ),
          child: Row(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  child: FaIcon(
                   icon,
                    color: color,
                  )),
              Horizontalspace(2),
              Expanded(
                child: Text(
                  lication,
                  style: Get.theme.textTheme.bodyText1!.copyWith(
                    color: ELSA_TEXT_WHITE,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
            ],
          ),
        ),
                Verticalspace(8),
      ],
    );
  }
}
