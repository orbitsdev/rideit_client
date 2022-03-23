import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/mapdatacontroller.dart';
import 'package:tricycleapp/screens/home_screen.dart';

import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);
  static const String screenName = "/requestscreen";
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  int currenStep = 0;
  late String paymentmethod;

  void setPaymentMethod(String value) {
    setState(() {
      paymentmethod = value;
    });
    print(paymentmethod);
  }

  double mappadding = 0;

  Completer<GoogleMapController> _macontroller = Completer();
  GoogleMapController? newgooglemapcontroller;

  var mapdatacontroller = Get.put(Mapdatacontroller());
  Position? currenPostion;
  void getCurrentLocation() {
    newgooglemapcontroller!.animateCamera(
        CameraUpdate.newCameraPosition(mapdatacontroller.cameraPosition!));
  }

  bool isMapReady = false;
  void setMap(bool value) {
    setState(() {
      isMapReady = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setCameraPostionToMyCurrentLocation();
    paymentmethod = "null";
  }

  void setCameraPostionToMyCurrentLocation() async {
    var response = await mapdatacontroller.setCameraPostionToMycurrenPostion();
    if (response) {
      setMap(response);
    }
  }

  Marker? droplocationmarker;
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  Set<Polyline> polylineSet = {};
  void setDropMarker(LatLng postion) {
    droplocationmarker = Marker(
      markerId: MarkerId('dropmarker'),
      position: postion,
    );

    setState(() {
      markerSet.add(droplocationmarker as Marker);
    });

    moveCamera(postion);
  }

  void placeMarker(LatLng position) {
    mapdatacontroller.getDropOffLocation(position);
    setDropMarker(position);
  }

  void moveCamera(LatLng position) {
    newgooglemapcontroller!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 17.999),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {

                mapdatacontroller.clearRequestForm();
              }, icon: FaIcon(FontAwesomeIcons.times)),
        ),
        body: isMapReady == false
            ? Container(
                height: 500,
                child: Center(
                    child: CircularProgressIndicator(
                  color: ELSA_BLUE_1_,
                )),
              )
            : Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        GoogleMap(
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                          onTap: placeMarker,
                          onLongPress: placeMarker,
                          padding:
                              EdgeInsets.only(top: 100, bottom: mappadding),
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          markers: markerSet,
                          circles: circleSet,
                          polylines: polylineSet,
                          mapType: MapType.normal,
                          initialCameraPosition: mapdatacontroller
                              .cameraPosition as CameraPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _macontroller.complete(controller);
                            newgooglemapcontroller = controller;
                            getCurrentLocation();
                            // setState(() {
                            //   mappadding = 300;
                            // });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    constraints: BoxConstraints(minHeight: 225),
                    decoration: BoxDecoration(
                        color: BOTTOMNAVIGATOR_COLOR,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                    child: Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          
                          Verticalspace(5),

                          


                          Column(
                            children: [
                              if(mapdatacontroller.droplocationDetails.value.placeid != null)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 34,
                                        child: Center(
                                            child: FaIcon(
                                          FontAwesomeIcons.mapMarkerAlt,
                                          color: ELSA_PINK,
                                        )),
                                      ),
                                      Text('Your Destination'.toUpperCase(),
                                          style: Get.textTheme.headline1!.copyWith(
                                            color: ELSA_TEXT_WHITE,
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                  
                          Divider(
                            thickness: 1,
                            color: ELSA_TEXT_LIGHT,
                          ),
                                ],
                              ),
                           mapdatacontroller.isdroploading.value 
                                ? Container(
                                  height: 150,
                                  padding: EdgeInsets.all(12),
                                 
                                  child: Center(
                                    child: SpinKitThreeBounce(
                                      duration: Duration(milliseconds: 700),
                                      color: ELSA_GREEN,
                                      size: 20.0,
                                    ),
                                  ),
                                )
                                : 

                                mapdatacontroller.droplocationDetails.value.placeid == null? 
                                  Container(
                                    child: Column(
                            children: [
                              Text(
                                ' Tap the map or use search bar to select location',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(color: ELSA_TEXT_WHITE),
                              ),
                              Container(
                                    height: 160,
                                    width: 160 ,
                                    child: Center(
                                        child: lottie.Lottie.asset(
                                            "assets/images/86234-select-location.json"))),
                            ],
                          ),
                                  ):
                           Column(
                             children: [
                               Container(
                                padding: EdgeInsets.all(12),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: LIGHT_CONTAINER,
                                    borderRadius: BorderRadius.circular(8)),
                                child:Text(
                                        '${mapdatacontroller.droplocationDetails.value.placeformattedaddress }',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(fontWeight: FontWeight.w300),
                                      ),
                          ),

                          Verticalspace(16),
                          Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: ELSA_BLUE_1_,
                                    ),
                                    onPressed: mapdatacontroller.droplocationDetails.value.placeid == null? null: () {
                                      Get.to(() => HomeScreen(),
                                          fullscreenDialog: true,
                                          transition: Transition.rightToLeft);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Continue'.toUpperCase()),
                                        Horizontalspace(5),
                                        // Container(
                                        //     child: Center(
                                        //         child: FaIcon(
                                        //   FontAwesomeIcons.angleRight,
                                        //   size: 24,
                                        // )))
                                      ],
                                    )),
                          ),
                             ],
                           ),
                            ],
                          ),

                         
                        ],
                      );
                    }),
                  ),
                ],
              ));
  }
}
