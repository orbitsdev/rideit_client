import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class Nodatabuilder extends StatelessWidget {

final String title;
final String subtitle;

  const Nodatabuilder({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/images/66528-qntm.json',
          ),
          Text(title,
              style: Get.textTheme.headline1!.copyWith(
                  color: ELSA_TEXT_GREY,
                  fontSize: 24,
                  fontWeight: FontWeight.w800)),
          Verticalspace(8),
          Container(

            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Get.theme.textTheme.bodyText1!.copyWith(
                color: ELSA_TEXT_GREY,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
