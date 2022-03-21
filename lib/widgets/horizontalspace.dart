import 'package:flutter/material.dart';

class Horizontalspace extends StatelessWidget {
final double horizontalvalue;
Horizontalspace(this.horizontalvalue);
  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: horizontalvalue,
    );
  }
}