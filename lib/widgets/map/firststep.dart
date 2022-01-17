import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/model/placeaddress.dart';

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
          Obx(() {
            return Column(
              children: [
                mapxcontroller.dropofflocation.value.placeformattedaddress !=
                        null
                    ? Row(
                        children: [
                          FaIcon(FontAwesomeIcons.mapMarkerAlt),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Destination',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                mapxcontroller.isaddresloading.value
                                    ? SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        '${mapxcontroller.dropofflocation.value.placeformattedaddress}')
                              ],
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                              'Select your location by marking the map or by using search field ')
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

                          mapxcontroller.dropofflocation = Placeaddress().obs;
                        },
                        label: Text('CLOSE')),
                    ElevatedButton.icon(
                        icon: FaIcon(FontAwesomeIcons.arrowCircleRight),
                        onPressed: mapxcontroller.dropofflocation.value
                                    .placeformattedaddress ==
                                null
                            ? null
                            : () {
                                backToStartRequest();
                              },
                        label: Text('NEXT')),
                  ],
                ),
              ],
            );
          }),
          Divider(
            thickness: 2,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
