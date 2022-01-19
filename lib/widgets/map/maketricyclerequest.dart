import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Maketricyclerequest extends StatelessWidget {
  final Function startRequest;
  Maketricyclerequest({
    required this.startRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(
      //   horizontal: 4,
      // ),
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 30,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
                color: Colors.black54,
                blurRadius: 20,
                spreadRadius: 1.0,
                offset: Offset(0.7, 0.20)),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              child: ElevatedButton.icon(
                  onPressed: () {
                    startRequest();
                  },
                  icon: FaIcon(FontAwesomeIcons.car),
                  label: Text('Request Tricycle')))
        ],
      ),
    );
  }
}
