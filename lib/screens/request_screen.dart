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
import 'package:tricycleapp/controller/mapdatacontroller.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/dialog/mapdialog/mapdialog.dart';
import 'package:tricycleapp/screens/payment_screen.dart';
import 'package:tricycleapp/uiconstant/constant.dart';

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


  void setCurrentStep(int value){
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

    setSearchFocus(bool value){
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
    super.dispose();
    
  searchcontroller.dispose();
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
    if(mounted){

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

  void startingCamera(){
     
     newgooglemapcontroller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: mapdatacontroller.position as LatLng, zoom: 16.999, tilt: 40, bearing: -1000),));
  }

int _polylincecounter = 1;
void setPolylines() async{


LatLng piclatlng = LatLng(mapdatacontroller.pickuplocationDetails.value.latitude as double, mapdatacontroller.pickuplocationDetails.value.longitude as double);
    //LatLng picklatlng = mapdatacontroller.actualdropmarkerposition as LatLng;
  pickcircle = Circle(
        zIndex: 1,
        fillColor: Colors.purpleAccent.withOpacity(0.5),
        strokeWidth: 1,
        radius: 5,
        center: piclatlng,
        strokeColor: Colors.purpleAccent,
        circleId: CircleId("pickcicrcle"));

    dropcircle = Circle(
        fillColor: Colors.redAccent.withOpacity(0.5),
        center:mapdatacontroller.actualdropmarkerposition as LatLng,
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
            width: 5,
            jointType: JointType.mitered,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
            color: ELSA_BLUE_2_,
            points: mapdatacontroller
                .directionDetails.value.polylines_encoded!
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList()),
      );
    });

    _caneraBoundToRoute();
}



  void _caneraBoundToRoute() {
    var bound_sw =
        mapdatacontroller.directionDetails.value.bound_sw as LatLng;
    var bound_ne =
        mapdatacontroller.directionDetails.value.bound_ne as LatLng;

    newgooglemapcontroller!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: bound_sw, northeast: bound_ne), 45));
  }

  bool isRouteReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {

                mapdatacontroller.clearRequestForm();
                  startingCamera();
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
                          onTap: currenStep == 0 ? placeMarker : (LatLng point){
                            
                            Infodialog.showToastCenter(Colors.black, ELSA_TEXT_WHITE, 'Go back to first step if you want to change your destination');
                          },
                          onLongPress: currenStep == 0 ? placeMarker : (LatLng point){
                            Infodialog.showToastCenter(Colors.black, ELSA_TEXT_WHITE, 'Go back to first step if you want to change your destination');
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
                          mapType: MapType.normal,
                          initialCameraPosition: mapdatacontroller
                              .cameraPosition as CameraPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _macontroller.complete(controller);
                            newgooglemapcontroller = controller;
                            //newgooglemapcontroller!.setMapStyle(mapdarktheme);
                            getCurrentLocation();
                            // setState(() {
                            //   mappadding = 300;
                            // });
                          },
                        ),
                        // buildFloatingSearchBar(),
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
                                                                ' Tap the map to select location',
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
                               Material(

                                 color: LIGHT_CONTAINER,
                                 child: InkWell(
                                    onTap: (){
                                        print('hey');
                                        moveCamera(LatLng(mapdatacontroller.droplocationDetails.value.latitude as double,mapdatacontroller.droplocationDetails.value.longitude as double,));
                                      },
                                   child: Container(
                                    padding: EdgeInsets.all(12),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      
                                        borderRadius: BorderRadius.circular(8)),
                                    child:Text(
                                            '${mapdatacontroller.droplocationDetails.value.placeformattedaddress }',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(fontWeight: FontWeight.w300),
                                          ),
                                                           ),
                                 ),
                               ),
                            
                          Verticalspace(16),

                          
                            AnimatedSwitcher(
                              transitionBuilder: (child, animation)=> ScaleTransition(
                                child: child,
                               
                                scale: animation),
                              duration: Duration(milliseconds: 300),
                              child: currenStep == 0 ?  Container(
                            key: Key('b1'),
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: ELSA_BLUE_1_,
                                    ),
                                    onPressed: mapdatacontroller.droplocationDetails.value.placeid == null? null: ()  async{

                                    if(mapdatacontroller.lastropmarkerposition.toString()!= mapdatacontroller.actualdropmarkerposition.toString()){
                                         isRouteReady = await mapdatacontroller.prepaireRoute(context);   
                                      if(isRouteReady){
                                        print('ready napo sir');
                                        print(isRouteReady);
                                          setState(() {
                                            setCurrentStep(1);
                                           });

                                     
                                          setPolylines();
                                        
                                      }else{
                                        print(isRouteReady);
                                        print('yugs di pa ready');

                                      }
                                    }else{
                                        setCurrentStep(1);
                                    }
                                    
                                  
                                      
                                      // Get.to(() => HomeScreen(),
                                      //     fullscreenDialog: true,
                                      //     transition: Transition.rightToLeft);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Get Route'.toUpperCase()),
                                        Horizontalspace(5),
                                        // Container(
                                        //     child: Center(
                                        //         child: FaIcon(
                                        //   FontAwesomeIcons.angleRight,
                                        //   size: 24,
                                        // )))
                                      ],
                                    )),
                          ):  
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            key: Key('b2'),
                            children: [
                              Container(
                                    width: 120,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                    ),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary:LIGHT_CONTAINER2,
                                        ),
                                        onPressed:(){
                                          setState(() { 

                                            setCurrentStep(0);
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                child: Center(
                                                    child: FaIcon(
                                              FontAwesomeIcons.angleLeft,
                                              size: 24,
                                            ))),
                                            Horizontalspace(5),
                                            Text('Back'.toUpperCase()),
                                          ],
                                        )),
                              ),
                              Horizontalspace(20),
                              Expanded(
                                child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(4)),
                                      ),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary:ELSA_PINK,
                                          ),
                                          onPressed:(){
                                            Get.to(()=> PaymentScreen() , fullscreenDialog: true , transition: Transition.rightToLeft,);
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text('Checkout'.toUpperCase()),
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
                              ),
                            ],
                          ), ),

                        
                         

                         
                          Verticalspace(16),

                         
                          //   AnimatedSwitcher(
                          //     transitionBuilder: (child, animation)=> ScaleTransition(
                          //       child: child,
                               
                          //       scale: animation),
                          //     duration: Duration(milliseconds: 300),
                          //     child: !isRouteReady ?  Container(
                          //   key: Key('b1'),
                          //       height: 50,
                          //       decoration: BoxDecoration(
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(4)),
                          //       ),
                          //       child: ElevatedButton(
                          //           style: ElevatedButton.styleFrom(
                          //             primary: ELSA_BLUE_1_,
                          //           ),
                          //           onPressed: mapdatacontroller.droplocationDetails.value.placeid == null? null: ()  async{

                          //           if(mapdatacontroller.lasdropid != mapdatacontroller.droplocationDetails.value.placeid){
                          //                isRouteReady = await mapdatacontroller.prepaireRoute(context);   
                          //             if(isRouteReady){
                          //               print('ready napo sir');
                          //               print(isRouteReady);

                                     
                          //                 setPolylines();
                                        
                          //             }else{
                          //               print(isRouteReady);
                          //               print('yugs di pa ready');

                          //             }
                          //           }
                                    
                                  
                                      
                          //             // Get.to(() => HomeScreen(),
                          //             //     fullscreenDialog: true,
                          //             //     transition: Transition.rightToLeft);
                          //           },
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             crossAxisAlignment: CrossAxisAlignment.center,
                          //             children: [
                          //               Text('continue'.toUpperCase()),
                          //               Horizontalspace(5),
                          //               // Container(
                          //               //     child: Center(
                          //               //         child: FaIcon(
                          //               //   FontAwesomeIcons.angleRight,
                          //               //   size: 24,
                          //               // )))
                          //             ],
                          //           )),
                          // ): Container(
                          //   key: Key('b2'),
                          //       height: 50,
                          //       decoration: BoxDecoration(
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(4)),
                          //       ),
                          //       child: ElevatedButton(
                          //           style: ElevatedButton.styleFrom(
                          //             primary:ELSA_PINK,
                          //           ),
                          //           onPressed:(){
                          //             print('go to payment');
                          //           },
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             crossAxisAlignment: CrossAxisAlignment.center,
                          //             children: [
                          //               Text('Checkout'.toUpperCase()),
                          //               Horizontalspace(5),
                          //               // Container(
                          //               //     child: Center(
                          //               //         child: FaIcon(
                          //               //   FontAwesomeIcons.angleRight,
                          //               //   size: 24,
                          //               // )))
                          //             ],
                          //           )),
                          // ),
                          //     ),
                         
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
          setSearchFocus(false);
        }
      },
      onQueryChanged: (query) {
        if (query.isEmpty || query == '') {
         // mapxcontroller.placeprediction.clear();
        }

       // mapxcontroller.searchPlace(query);

        // Call your model, bloc, controller here.
      },
      onSubmitted: (query) async {
        // if (mapxcontroller.placeprediction.length != 0) {
        //   PredictionPlace firstresult = mapxcontroller.placeprediction[0];
        //   var ismarkerSet = await mapxcontroller
        //       .setDropOffLocationFromSearch(firstresult.placeId as String);
        //   setDropOffMarker(mapxcontroller.markerPositon as LatLng);
        //   if (ismarkerSet) {
        //     setState(() {
        //       searchcontroller.close();
        //       mapxcontroller.placeprediction.clear();
        //     });
        //   }
        // }

        //mapxcontroller.searchPlace(query);
        // searchcontroller.close();
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
                 
                   ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              height: 2,
                              thickness: 1,
                            ),
                        itemCount: 10,
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
                                'Isulan Sultan Kudarat'),
                            subtitle: Text(
                                'Isulan',),
                            onTap: () async {
                              
                            },
                          );
                        })
                
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  
}
