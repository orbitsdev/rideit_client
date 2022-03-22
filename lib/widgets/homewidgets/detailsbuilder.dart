import 'package:flutter/material.dart';

class Detailsbuilder extends StatelessWidget {

final String title;
  final String body;
  const Detailsbuilder({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);


  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('${title}'),
        Text('${body} ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),),
      ],
    );
  }
}
