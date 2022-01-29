import 'package:flutter/material.dart';
import 'package:tricycleapp/uiconstant/constant.dart';

class BorderBox extends StatelessWidget {


final Widget child;
final EdgeInsets padding;
final double height;
final double width;

  const BorderBox({
    Key? key,
    required this.child,
    required this.padding,
    required this.height,
    required this.width,
  }) : super(key: key);



  @override
  Widget build(BuildContext context){
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: COLOR_WHITE,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: COLOR_GEY.withAlpha(40), width: 2)
      ),
      padding: padding ,
      child: Center(child: child),
    );
  }
}
