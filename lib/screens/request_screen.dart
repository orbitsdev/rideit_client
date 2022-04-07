import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapdatacontroller.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/dialog/mapdialog/mapdialog.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/model/prediction_place.dart';
import 'package:tricycleapp/screens/payment_screen.dart';
import 'package:tricycleapp/uiconstant/constant.dart';

import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

enum MapMode { normal, hybrid, satelite, darkmode }

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);
  static const String screenName = "/requestscreen";
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  var authcontroller = Get.find<Authcontroller>();

  MapMode mapmode = MapMode.hybrid;
  MapType maptype = MapType.hybrid;

  void getCurrenMaptyoe() {
    print(authcontroller.user.value.map_mode);
    if (authcontroller.user.value.map_mode == 'normal') {

      setState(() {
        mapmode = MapMode.normal;
        maptype = MapType.normal;
         newgooglemapcontroller!.setMapStyle(null);
      });
     
    }
    if (authcontroller.user.value.map_mode == 'darkmode') {
        
        setState(() {
          
        mapmode = MapMode.normal;
        maptype = MapType.normal;
        newgooglemapcontroller!.setMapStyle(mapdarktheme);
        });

    }
    if (authcontroller.user.value.map_mode == 'satelite') {
      setState(() {
        mapmode = MapMode.satelite;
        maptype = MapType.satellite;
      });
    }
    if (authcontroller.user.value.map_mode == 'hybrid') {
      setState(() {
        mapmode = MapMode.hybrid;
        maptype = MapType.hybrid;
      });
    }
  }

  void mapTypeChange(MapMode value) async {
    print('MAP MODE');
    print(value);

    if (value == MapMode.normal) {
      setState(() {
        mapmode = value;
        maptype = MapType.normal;
        newgooglemapcontroller!.setMapStyle(null);
      });
    }
    if (value == MapMode.darkmode) {
      setState(() {
        mapmode = value;
        maptype = MapType.normal;
        newgooglemapcontroller!.setMapStyle(mapdarktheme);
      });
    }
    if (value == MapMode.satelite) {
      setState(() {
        mapmode = value;
        maptype = MapType.satellite;
      });
    }
    if (value == MapMode.hybrid) {
      setState(() {
        mapmode = value;
        maptype = MapType.hybrid;
      });
    }

    await authcontroller.updateMapOfUser(value.name);
  }

  void setMapStyle(bool value) {
    if (value) {
      setState(() {
        newgooglemapcontroller!.setMapStyle(mapdarktheme);
      });
    } else {
      setState(() {
        newgooglemapcontroller!.setMapStyle(null);
      });
    }
  }

  void setMapStylle(MapType value) {
    setState(() {
      maptype = value;
    });
  }

  int currenStep = 0;

  void setCurrentStep(int value) {
    setState(() {
      currenStep = value;
    });
  }

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

  var searchcontroller = FloatingSearchBarController();
  bool isSearchFocus = false;

  setSearchFocus(bool value) {
    setState(() {
      isSearchFocus = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setCameraPostionToMyCurrentLocation();

    paymentmethod = "null";
  }

  @override
  void dispose() {
    if (newgooglemapcontroller != null) {
      newgooglemapcontroller!.dispose();
    }
    searchcontroller.dispose();
    super.dispose();
  }

  void setCameraPostionToMyCurrentLocation() async {
    var response = await mapdatacontroller.setCameraPostionToMycurrenPostion();
    if (response) {
      setMap(response);
    }
  }

  Marker? droplocationmarker;
  Circle? dropcircle;
  Circle? pickcircle;

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  Set<Polyline> polylineSet = {};

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

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

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
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

  void startingCamera() {
    newgooglemapcontroller!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: mapdatacontroller.position as LatLng,
          zoom: 16.999,
          tilt: 40,
          bearing: -1000),
    ));
  }

  int _polylincecounter = 1;
  void setPolylines() async {
    LatLng piclatlng = LatLng(
        mapdatacontroller.pickuplocationDetails.value.latitude as double,
        mapdatacontroller.pickuplocationDetails.value.longitude as double);
    //LatLng picklatlng = mapdatacontroller.actualdropmarkerposition as LatLng;
    pickcircle = Circle(
        zIndex: 1,
        fillColor: Colors.purpleAccent.withOpacity(0.5),
        strokeWidth: 1,
        radius: 12,
        center: piclatlng,
        strokeColor: Colors.purpleAccent,
        circleId: CircleId("pickcicrcle"));

    dropcircle = Circle(
        fillColor: Colors.redAccent.withOpacity(0.5),
        center: mapdatacontroller.actualdropmarkerposition as LatLng,
        strokeWidth: 1,
        radius: 15,
        strokeColor: Colors.redAccent,
        circleId: CircleId("dropcircle"));

    // print(mapdatacontroller.directionDetails.value.polylines_encoded);
    String polylineIdVal = "polyline_id${_polylincecounter}";
    polylineSet.clear();
    circleSet.clear();
    setState(() {
      circleSet.add(dropcircle as Circle);
      circleSet.add(pickcircle as Circle);

      _polylincecounter++;
      polylineSet.add(
        Polyline(
            polylineId: PolylineId(polylineIdVal),
            width: 8,
            jointType: JointType.mitered,
            endCap: Cap.squareCap,
            startCap: Cap.squareCap,
            color: ELSA_BLUE,
            points: mapdatacontroller.directionDetails.value.polylines_encoded!
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList()),
      );
    });

    _caneraBoundToRoute();
  }

  void _caneraBoundToRoute() {
    var bound_sw = mapdatacontroller.directionDetails.value.bound_sw as LatLng;
    var bound_ne = mapdatacontroller.directionDetails.value.bound_ne as LatLng;

    newgooglemapcontroller!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: bound_sw, northeast: bound_ne), 45));
  }

  bool isRouteReady = false;

  void setDropOffMarker(LatLng position) {
    droplocationmarker = Marker(
      markerId: MarkerId('dropmarker'),
      position: position,
    );

    setState(() {
      markerSet.add(droplocationmarker as Marker);
    });

    moveCamera(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
                mapdatacontroller.clearRequestForm();
                setCurrentStep(0);
                startingCamera();
              },
              icon: FaIcon(FontAwesomeIcons.times)),
          actions: [
            GestureDetector(
              onTap: (){
                  Mapdialog.showMapOption(context,mapTypeChange);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [
                    LIGHT_CONTAINER,
                    LIGHT_CONTAINER2,
                  ],
                )),
                margin: EdgeInsets.all(10),
                width: 35,
                child:  Center(child: FaIcon(FontAwesomeIcons.satellite,size: 20,)),
              ),
            ),

          ],
        ),
        body: isMapReady == false
            ? Container(
                child: Column(
                  children: [
                    Verticalspace(100),
                    lottie.Lottie.asset('assets/images/99103-red-pin-map.json',
                        width: 250, height: 250, fit: BoxFit.contain),
                    Container(width: double.infinity)
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        GoogleMap(
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                          onTap: currenStep == 0
                              ? placeMarker
                              : (LatLng point) {
                                  Infodialog.showToastCenter(
                                      Colors.black,
                                      ELSA_TEXT_WHITE,
                                      'Go back to first step if you want to change your destination');
                                },
                          onLongPress: currenStep == 0
                              ? placeMarker
                              : (LatLng point) {
                                  Infodialog.showToastCenter(
                                      Colors.black,
                                      ELSA_TEXT_WHITE,
                                      'Go back to first step if you want to change your destination');
                                },
                          padding:
                              EdgeInsets.only(top: 100, bottom: mappadding),
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          markers: markerSet,
                          circles: circleSet,
                          polylines: polylineSet,
                          mapType: maptype,
                          initialCameraPosition: mapdatacontroller
                              .cameraPosition as CameraPosition,
                          onMapCreated: (GoogleMapController controller) {
                            if(!_macontroller.isCompleted){
                          _macontroller.complete(controller);
                            newgooglemapcontroller = controller;
                            //newgooglemapcontroller!.setMapStyle(mapdarktheme);
                            getCurrentLocation();
                            }
                           
                            getCurrenMaptyoe();
                            // setState(() {
                            //   mappadding = 300;
                            // });
                          },
                        ),
                        if (currenStep == 0) buildFloatingSearchBar(),
                      ],
                    ),
                  ),
                  AnimatedSwitcher(
                    transitionBuilder: (child, animation) => ScaleTransition(
                        alignment: Alignment.bottomCenter,
                        child: child,
                        scale: animation),
                    duration: Duration(milliseconds: 300),
                    child: isSearchFocus
                        ? Container(
                            key: Key('c1'),
                          )
                        : Container(
                            key: Key('c2'),
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
                                      if (mapdatacontroller.droplocationDetails
                                              .value.placeid !=
                                          null)
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 34,
                                                      child: Center(
                                                          child: FaIcon(
                                                        FontAwesomeIcons
                                                            .mapMarkerAlt,
                                                        color: ELSA_PINK,
                                                      )),
                                                    ),
                                                    Text(
                                                        'Your Destination'
                                                            .toUpperCase(),
                                                        style: Get.textTheme
                                                            .headline1!
                                                            .copyWith(
                                                          color:
                                                              ELSA_TEXT_WHITE,
                                                          fontSize: 16,
                                                        )),
                                                  ],
                                                ),
                                                if (mapdatacontroller
                                                        .directionDetails
                                                        .value
                                                        .polylines !=
                                                    null)
                                                  ClipOval(
                                                      child: Material(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Infodialog.showInfo(
                                                            context,
                                                            'If the guide route did not reach your selected destination it is probably because you are located inside the scope of the same address or  google map cannot draw route to your location. Due to this limitation of google map features. We have added circle to the map. The red circle represent the actual position of your selected destination and purple circle represent your current location. ');
                                                      },
                                                      child: Container(
                                                          height: 26,
                                                          width: 26,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              17)),
                                                                  //
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomLeft,
                                                                    colors: [
                                                                      ELSA_GREEN,
                                                                      ELSA_BLUE,
                                                                    ],
                                                                  )),
                                                          child: Center(
                                                              child: FaIcon(
                                                            FontAwesomeIcons
                                                                .exclamation,
                                                            color: Colors.white,
                                                          ))),
                                                    ),
                                                  )),
                                              ],
                                            ),
                                            Verticalspace(8),
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
                                                  duration: Duration(
                                                      milliseconds: 700),
                                                  color: ELSA_GREEN,
                                                  size: 20.0,
                                                ),
                                              ),
                                            )
                                          : mapdatacontroller
                                                      .droplocationDetails
                                                      .value
                                                      .placeid ==
                                                  null
                                              ? Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        ' Tap map or use search bar to select your destination',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1!
                                                            .copyWith(
                                                                color:
                                                                    ELSA_TEXT_WHITE),
                                                      ),
                                                      Container(
                                                          height: 160,
                                                          width: 160,
                                                          child: Center(
                                                              child: lottie
                                                                      .Lottie
                                                                  .asset(
                                                                      "assets/images/86234-select-location.json"))),
                                                    ],
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    Material(
                                                      color: LIGHT_CONTAINER,
                                                      child: InkWell(
                                                        onTap: () {
                                                          print('hey');
                                                          moveCamera(LatLng(
                                                            mapdatacontroller
                                                                .droplocationDetails
                                                                .value
                                                                .latitude as double,
                                                            mapdatacontroller
                                                                    .droplocationDetails
                                                                    .value
                                                                    .longitude
                                                                as double,
                                                          ));
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12),
                                                          width:
                                                              double.infinity,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Text(
                                                            '${mapdatacontroller.droplocationDetails.value.placeformattedaddress}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Verticalspace(16),
                                                    AnimatedSwitcher(
                                                      transitionBuilder: (child,
                                                              animation) =>
                                                          ScaleTransition(
                                                              child: child,
                                                              scale: animation),
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      child: currenStep == 0
                                                          ? Container(
                                                              key: Key('b1'),
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4)),
                                                              ),
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        primary:
                                                                            DARK_GREEN,
                                                                      ),
                                                                      onPressed: mapdatacontroller.droplocationDetails.value.placeid ==
                                                                              null
                                                                          ? null
                                                                          : () async {
                                                                              if (mapdatacontroller.lastropmarkerposition.toString() != mapdatacontroller.actualdropmarkerposition.toString()) {
                                                                                isRouteReady = await mapdatacontroller.prepaireRoute(context);
                                                                                if (isRouteReady) {
                                                                                  print('ready napo sir');
                                                                                  print(isRouteReady);
                                                                                  setState(() {
                                                                                    setCurrentStep(1);
                                                                                  });

                                                                                  setPolylines();
                                                                                } else {
                                                                                  print(isRouteReady);
                                                                                  print('yugs di pa ready');
                                                                                }
                                                                              } else {
                                                                                print(mapdatacontroller.lastropmarkerposition.toString() + ' actual marker');
                                                                                print('_____________________________________________--');
                                                                                print('_____________________________________________');
                                                                                print(mapdatacontroller.actualdropmarkerposition.toString() + ' actual marker');
                                                                                print('bri thi ma procceess');
                                                                                setCurrentStep(1);
                                                                              }

                                                                              // Get.to(() => HomeScreen(),
                                                                              //     fullscreenDialog: true,
                                                                              //     transition: Transition.rightToLeft);
                                                                            },
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text('Get Route'
                                                                              .toUpperCase()),
                                                                          Horizontalspace(
                                                                              5),
                                                                          // Container(
                                                                          //     child: Center(
                                                                          //         child: FaIcon(
                                                                          //   FontAwesomeIcons.angleRight,
                                                                          //   size: 24,
                                                                          // )))
                                                                        ],
                                                                      )),
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              key: Key('b2'),
                                                              children: [
                                                                Container(
                                                                  width: 120,
                                                                  height: 50,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(4)),
                                                                  ),
                                                                  child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        primary:
                                                                            LIGHT_CONTAINER2,
                                                                      ),
                                                                      onPressed: () {
                                                                        setState(
                                                                            () {
                                                                          setCurrentStep(
                                                                              0);
                                                                        });
                                                                      },
                                                                      child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                              child: Center(
                                                                                  child: FaIcon(
                                                                            FontAwesomeIcons.angleLeft,
                                                                            size:
                                                                                24,
                                                                          ))),
                                                                          Horizontalspace(
                                                                              5),
                                                                          Text('Back'
                                                                              .toUpperCase()),
                                                                        ],
                                                                      )),
                                                                ),
                                                                Horizontalspace(
                                                                    20),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    height: 50,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(4)),
                                                                    ),
                                                                    child: ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary:
                                                                              DARK_GREEN,
                                                                        ),
                                                                        onPressed: () {
                                                                          Get.to(
                                                                            () =>
                                                                                PaymentScreen(),
                                                                            fullscreenDialog:
                                                                                true,
                                                                            transition:
                                                                                Transition.rightToLeft,
                                                                          );
                                                                        },
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text('Checkout'.toUpperCase()),
                                                                            Horizontalspace(5),
                                                                          ],
                                                                        )),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                    ),
                                                    Verticalspace(16),
                                                  ],
                                                ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                  ),
                ],
              ));
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      controller: searchcontroller,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),

      onFocusChanged: (_) {
        //isopen
        if (isSearchFocus == false) {
          setSearchFocus(true);
        } else {
          //close
          setState(() {
            searchcontroller.close();
          });
          setSearchFocus(false);
        }
      },
      onQueryChanged: (query) {
        if (query.isEmpty || query == '') {
          mapdatacontroller.placeprediction.clear();
        }

        mapdatacontroller.searchPlace(query);

        // Call your model, bloc, controller here.
      },
      onSubmitted: (query) async {
        if (mapdatacontroller.placeprediction.length != 0) {
          PredictionPlace firstresult = mapdatacontroller.placeprediction[0];
          print('___________________________');
          print('_____________________________________');
          // print(firstresult.toJson());
          var ismarkerSet = await mapdatacontroller
              .setDropDetailFromSearch(firstresult.placeId as String);

          if (ismarkerSet) {
            print(mapdatacontroller.droplocationDetails.toJson());

            setDropMarker(mapdatacontroller.dropmarkerposition as LatLng);
          }
        }
        closeGoogleMapSearch();
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: SlideFadeFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Container(
              color: COLOR_WHITE,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    if (mapdatacontroller.isfetching.value) {
                      // when fetching
                    }
                    if (mapdatacontroller.placeprediction.length <= 0) {
                      return Container();
                    }
                    return ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              height: 2,
                              thickness: 1,
                            ),
                        itemCount: mapdatacontroller.placeprediction.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Container(
                                width: 20,
                                height: 20,
                                child: Center(
                                    child: FaIcon(
                                  FontAwesomeIcons.mapMarkerAlt,
                                ))),
                            title: Text(
                                '${mapdatacontroller.placeprediction[index].maintext}'),
                            subtitle: Text(
                                '${mapdatacontroller.placeprediction[index].secondrarytext}'),
                            onTap: () async {
                              var ismarkerSet = await mapdatacontroller
                                  .setDropDetailFromSearch(mapdatacontroller
                                      .placeprediction[index].placeId);

                              setDropOffMarker(mapdatacontroller
                                  .dropmarkerposition as LatLng);
                              if (ismarkerSet) {
                                setState(() {
                                  searchcontroller.close();
                                  mapdatacontroller.placeprediction.clear();
                                });
                              }
                            },
                          );
                        });
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void closeGoogleMapSearch() {
    setState(() {
      searchcontroller.close();
      mapdatacontroller.placeprediction.clear();
    });
  }
}
