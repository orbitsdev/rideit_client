import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';

class Firststep extends StatelessWidget {
  final Function backToStartRequest;

  Firststep({required this.backToStartRequest});

  @override
  Widget build(BuildContext context) {
    var mapxcontroller = Get.put(Mapcontroller());

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 4,
      ),
      padding: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 12),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
                color: Colors.black54,
                blurRadius: 8.0,
                spreadRadius: 1.0,
                offset: Offset(0.7, 0.20)),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Select Location',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            thickness: 2,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 8,
          ),
          // Row(
          //   children: [
          //     FaIcon(FontAwesomeIcons.mapPin),
          //     SizedBox(
          //       width: 20,
          //     ),
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'Your Current Location',
          //             style:
          //                 TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //           ),
          //           SizedBox(
          //             height: 3,
          //           ),
          //           Text('Salem St Kalawag 2 Salem St '),
          //         ],
          //       ),
          //     )
          //   ],
          // ),
          // Divider(
          //   thickness: 2,
          //   color: Colors.grey[300],
          // ),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.mapMarker),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Destination',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Obx(() {
                      if (mapxcontroller.isaddresloading.value) {
                        return SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      }
                      return Text('${mapxcontroller.picklocation}');
                    }),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                  icon: FaIcon(FontAwesomeIcons.solidTimesCircle),
                  onPressed: () {
                    backToStartRequest();
                  },
                  label: Text('CLOSE')),
              ElevatedButton.icon(
                  icon: FaIcon(FontAwesomeIcons.arrowCircleRight),
                  onPressed: () {
                    backToStartRequest();
                  },
                  label: Text('NEXT')),
            ],
          ),
          Divider(
            thickness: 2,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
