import 'package:flutter/material.dart';

class Verticalspace extends StatelessWidget {

  final double verticalvalue;

  Verticalspace(this.verticalvalue);

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: verticalvalue,
    );
  }
}
