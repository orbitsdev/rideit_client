import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lotie;
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/helper/geofirehelper.dart';
import 'package:tricycleapp/model/nearbydriver.dart';
import 'package:tricycleapp/uiconstant/constant.dart';
import 'package:tricycleapp/uiconstant/widget_function.dart';


enum tricycleRequestState{
  starting,
  requesting
  
}

class HomeScreen extends StatefulWidget {
  static const screenName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var mapxcontroller = Get.find<Mapcontroller>();
  

  //_____________ gor google map
  Completer<GoogleMapController> _googlmapcompleter = Completer();
  GoogleMapController? _newgooglemapcontroller;
  Position? currenpositon;
  CameraPosition? cameraposition;
  LatLng? cameralatlng;
  bool isMapReady = false;
  Set<Polyline>? polylinesSet = {};
  Set<Marker>? markersSet = {};
  List<Nearbydriver> nearbydriverlist = [];
  bool nearDriverIsLoad = false;
  BitmapDescriptor? nearTricycleIcon;





  //_____________ for the page

  tricycleRequestState currentrequestpagestate = tricycleRequestState.starting;

  bool isSwitch = false;
  double _containerHeight = 200;



   setCameraInitialValue() async {
    var mapIsReady = await mapxcontroller.setMapCameraInitialValue();

    if(mapIsReady){
     setMapIsReady(mapIsReady);
     showNearDriver();

    }
    print(isMapReady);

    
    cameraposition = mapxcontroller.cameraposition;
  }

  void setMapIsReady(bool value) {
    setState(() {
      isMapReady = value;
    });
  }

  void setCurrentRequestState(tricycleRequestState value){
    setState(() {
      currentrequestpagestate = value;
    });
  }


  void _moveCameraToCurrentPostion() async {
    cameraposition = await mapxcontroller.moveMapCameraToCurrentPosition();

    _newgooglemapcontroller!.animateCamera(
        CameraUpdate.newCameraPosition(cameraposition as CameraPosition));
  }

@override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
@override
  void dispose() {
    _newgooglemapcontroller!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    setCameraInitialValue();
 
    super.initState();
  }

  

  void showNearDriver() async{
   await  Geofire.initialize("availableDrivers");

    Geofire.queryAtLocation(mapxcontroller.currentPosition!.latitude, mapxcontroller.currentPosition!.longitude , 5)!.listen((map) {
        print(map);
        if (map != null) {
          var callBack = map['callBack'];

          //latitude will be retrieved from map['latitude']
          //longitude will be retrieved from map['longitude']

          switch (callBack) {
            case Geofire.onKeyEntered:
            Nearbydriver driver =  Nearbydriver();
            driver.key = map["key"];
            driver.latitude = map["latitude"];
            driver.longitude = map["longitude"];
            Geofirehelper.nearAvailableDriber.add(driver);
            if(nearDriverIsLoad == true){
              updateAvailableDriverOnMap();
            }
             // keysRetrieved.add(map["key"]);
              break;

            case Geofire.onKeyExited:
            Geofirehelper.removeDriverFromList(map["key"]);
            updateAvailableDriverOnMap();

             // keysRetrieved.remove(map["key"]);
              break;

            case Geofire.onKeyMoved:
            Nearbydriver driver =  Nearbydriver();
            driver.key = map["key"];
            driver.latitude = map["latitude"];
            driver.longitude = map["longitude"];
            Geofirehelper.updateDriverNearByLocation(driver);
            updateAvailableDriverOnMap();
            // Update your key's location
              break;

            case Geofire.onGeoQueryReady:
            updateAvailableDriverOnMap();
            // All Intial Data is loaded
           // print(map['result'])

              break;
          }
        }

        setState(() {});
    });


  }

  void updateAvailableDriverOnMap(){

setState(() {
        markersSet!.clear();
    });

    for(Nearbydriver drivers in Geofirehelper.nearAvailableDriber)
    {

      
        
      print('______  hey testing');
      print(drivers.latitude);
      print(drivers.longitude);
      LatLng driverposition = LatLng(drivers.latitude as double, drivers.longitude as double);
      print(driverposition);
    }

    

    Set<Marker> tmarker = Set<Marker>();


    for(Nearbydriver driver  in Geofirehelper.nearAvailableDriber){
        LatLng driverpostion = LatLng(driver.latitude as double , driver.longitude as double);
        Marker newMarker = Marker(
          markerId: MarkerId(driver.key as String),
          position: driverpostion,
          icon: nearTricycleIcon as BitmapDescriptor,
         


           );

      tmarker.add(newMarker);
          

    }
    setState(() {
      markersSet = tmarker; 
    });


  }

  void  createCustomMarker(){
    if(nearTricycleIcon == null){
       ImageConfiguration imageconfiguration = createLocalImageConfiguration(context, size: Size(12, 12));
       BitmapDescriptor.fromAssetImage(imageconfiguration,"assets/images/Motorcycle_8.png").then((value) {
         nearTricycleIcon = value;
       });

    }
  }

  @override
  Widget build(BuildContext context) {
    createCustomMarker();
    return Column(children: [
      isMapReady == false
          ? Expanded(
            child:lotie.Lottie.asset('assets/images/52141-balancing-loader.json',
            //animate: true,
            ),
            )
          : Expanded(
              child: Stack(
              fit: StackFit.expand,
              children: [
                GoogleMap(
                    padding: EdgeInsets.only(top: 70, bottom: 5, left: 5),
                    mapType: MapType.normal,
                    initialCameraPosition: cameraposition as CameraPosition,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    markers: markersSet as  Set<Marker>,
                    polylines: polylinesSet as Set<Polyline>,
                    onMapCreated: (GoogleMapController mapcontroller) {
                          if(!_googlmapcompleter.isCompleted){
                      _googlmapcompleter.complete(mapcontroller);
                      _newgooglemapcontroller = mapcontroller;
                      _moveCameraToCurrentPostion();


                          }
                    }

                    //           },
                    ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    constraints: BoxConstraints(minHeight: _containerHeight),
                    duration: Duration(milliseconds: 1500),
                    curve: Curves.fastOutSlowIn,
                    decoration: BoxDecoration(
                     
                    ),
                    child: AnimatedSwitcher(
                      reverseDuration: Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOutBack,
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (child, animatin) => ScaleTransition(
                        scale: animatin,
                        child: child,
                      ),
                      child: isSwitch == false
                          ? findTricycle(context)
                          : requestForm(context),
                    ),
                  ),
                )
              ],
            ))
    ]);
  }

  int _currentStep = 0;

  List<Step> _getSteps() => [
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 0,
            title: Text('Destination'),
            subtitle: Text('Picking'),
            content: Container(
              child: Text('a'),
            )),
        Step(
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 1,
            title: Text('Optional'),
            content: Container(
              child: Text('b'),
            )),
        Step(
           state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 2,
            title: Text('Send'),
            content: Container(
              child: Text('c'),
            )),
      ];

  Widget requestForm(BuildContext context) {
    return Container(
      height: 300,
      color: COLOR_SECONDARY_WHITE,
      key: Key('2'),
      child: Column(
        children: [
          SizedBox(
            width: 80,
            child: ElevatedButton(onPressed: (){
              switchContainer();
            }, child: Text('close')),
          ),
          Expanded(
            child: Stepper(
              onStepTapped: (step)=> setState(() => _currentStep = step),
              currentStep: _currentStep,
              type: StepperType.horizontal,
              steps: _getSteps(),
              onStepContinue: () {
                final lastStep = _currentStep == _getSteps().length - 1;

                if (lastStep) {
                  print('compledted');
                } else {
                  setState(() {
                    _currentStep += 1;
                  });
                }
              },
              onStepCancel: _currentStep == 0
                  ? null
                  : () {
                      setState(() {
                        _currentStep -= 1;
                      });
                    },
            ),
          ),
        ],
      ),
    );
    // return Container(
    //        key: Key('2'),

    //               margin:
    //                   EdgeInsets.only(top: 0,right: 20,left: 20,bottom: 40),
    //               padding: EdgeInsets.all(25),
    //               decoration: BoxDecoration(
    //                 color: COLOR_WHITE,
    //                 borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(12),
    //                     topRight: Radius.circular(12)),
    //                 boxShadow: [
    //                   BoxShadow(
    //                       color: COLOR_BLACK.withAlpha(21),
    //                       blurRadius: 6.0,
    //                       spreadRadius: 0.7,
    //                       offset: Offset(0, 10))
    //                 ],
    //               ),
    //               child: Column(
    //                 children: [
    //                   Text(
    //                     'Hellow',
    //                     style: Theme.of(context).textTheme.headline2,
    //                   ),
    //                   addVerticalSpace(15),
    //                   SizedBox(
    //                     width: double.infinity,
    //                     child: ElevatedButton(
    //                       onPressed: () {
    //                          switchContainer();
    //                       },
    //                       child: Text('FIND TRICYCLE'),
    //                       style: ButtonStyle(
    //                         backgroundColor:
    //                             MaterialStateProperty.all<Color>(
    //                                 COLOR_PURPLE_BUTTON),
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             );
  }

  Container findTricycle(BuildContext context) {
    return Container(
      key: Key('1'),
      margin: EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 40),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: COLOR_WHITE,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
              color: COLOR_BLACK.withAlpha(21),
              blurRadius: 6.0,
              spreadRadius: 0.7,
              offset: Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          Text(
            'Where would you like to go?',
            style: Theme.of(context).textTheme.headline2,
          ),
          addVerticalSpace(15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                switchContainer();
              },
              child: Text('FIND TRICYCLE'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(COLOR_PURPLE_BUTTON),
              ),
            ),
          )
        ],
      ),
    );
  }

  
  void showRequestForm(){
      setCurrentRequestState(tricycleRequestState.requesting);
  }

  Widget _requestFormLogic(){

   if(currentrequestpagestate == tricycleRequestState.requesting){
      return requestForm(context);
    }

    return findTricycle(context);

  }

  void switchContainer() {
    setState(() {
      isSwitch = !isSwitch;
      if (_containerHeight == 200) {
        _containerHeight = 300;
      } else {
        _containerHeight = 200;
      }
    });
  }
}
