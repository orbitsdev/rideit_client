import 'dart:async';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lotie;
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/dialog/authenticating.dart';
import 'package:tricycleapp/helper/geofirehelper.dart';
import 'package:tricycleapp/model/nearbydriver.dart';
import 'package:tricycleapp/model/prediction_place.dart';
import 'package:tricycleapp/uiconstant/constant.dart';
import 'package:tricycleapp/uiconstant/hex_color.dart';
import 'package:tricycleapp/uiconstant/widget_function.dart';

enum tricycleRequestState { starting, requesting }

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
  BitmapDescriptor? selectedLocationIcon;
  double mpappading = 200;
  Marker? pickupmarker;
  Marker? dropoffmarker;
  bool isPicking = false;

  setCameraInitialValue() async {
    var mapIsReady = await mapxcontroller.setMapCameraInitialValue();

    if (mapIsReady) {
      setMapIsReady(mapIsReady);
      showNearDriver();
    }


    cameraposition = mapxcontroller.cameraposition;
  }

  void setMapIsReady(bool value) {
    setState(() {
      isMapReady = value;
    });
  }

  void setCurrentRequestState(tricycleRequestState value) {
    setState(() {
      currentrequestpagestate = value;
    });
  }

  void placeMarker(LatLng position) async {
    mapxcontroller.placeMarkerAddressCoordinate(position);
    setDropOffMarker(position);
  }

  void _moveCameraToCurrentPostion() async {
    cameraposition = await mapxcontroller.moveMapCameraToCurrentPosition();
    _newgooglemapcontroller!.animateCamera(
        CameraUpdate.newCameraPosition(cameraposition as CameraPosition));
   
   
  }

  //_____________ for the page

  tricycleRequestState currentrequestpagestate = tricycleRequestState.starting;

  bool isSwitch = false;
  double _containerHeight = 200;

  //_____________ for floating search

  var searchcontroller = FloatingSearchBarController();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _newgooglemapcontroller!.dispose();
    searchcontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    setCameraInitialValue();

    super.initState();
  }

  void showNearDriver() async {
    await Geofire.initialize("availableDrivers");

    Geofire.queryAtLocation(mapxcontroller.currentPosition!.latitude,
            mapxcontroller.currentPosition!.longitude, 5)!
        .listen((map) {
     
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            Nearbydriver driver = Nearbydriver();
            driver.key = map["key"];
            driver.latitude = map["latitude"];
            driver.longitude = map["longitude"];
            Geofirehelper.nearAvailableDriber.add(driver);
            if (nearDriverIsLoad == true) {
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
            Nearbydriver driver = Nearbydriver();
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

  void updateAvailableDriverOnMap() {
    setState(() {
      markersSet!.clear();
    });

    for (Nearbydriver drivers in Geofirehelper.nearAvailableDriber) {
     
      LatLng driverposition =  LatLng(drivers.latitude as double, drivers.longitude as double);
     
    }

    Set<Marker> tmarker = Set<Marker>();

    for (Nearbydriver driver in Geofirehelper.nearAvailableDriber) {
      LatLng driverpostion =
          LatLng(driver.latitude as double, driver.longitude as double);
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

  void createCustomMarker() {
    if (nearTricycleIcon == null) {
      ImageConfiguration imageconfiguration =
          createLocalImageConfiguration(context, size: Size(12, 12));
      BitmapDescriptor.fromAssetImage(
              imageconfiguration, "assets/images/Motorcycle_8.png")
          .then((value) {
        nearTricycleIcon = value;
      });
    }
  }

  void createCustomLocationMarker() {
    if (nearTricycleIcon == null) {
      ImageConfiguration imageconfiguration =
          createLocalImageConfiguration(context, size: Size(12, 12));
      BitmapDescriptor.fromAssetImage(
              imageconfiguration, "assets/images/locationmarker.png")
          .then((value) {
        selectedLocationIcon = value;
      });
    }
  }

  void setDropOffMarker(LatLng position) {
    dropoffmarker = Marker(
        markerId: MarkerId('dropmarker'),
        position: position,
        icon: selectedLocationIcon as BitmapDescriptor);

    setState(() {
      markersSet!.add(dropoffmarker as Marker);
    });

    _moveCamera(position);
  }

  void _moveCamera(LatLng position) {
    _newgooglemapcontroller!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 17.999),
    ));
  }

  int _polylincecounter = 1;
  void prepaireRequest() async {
    var isRequestReady = await mapxcontroller.prepairRequestDetails();
    String polylineIdVal = "polyline_id${_polylincecounter}";
    polylinesSet!.clear();
    setState(() {
      _polylincecounter++;
      polylinesSet!.add(
        Polyline(
            polylineId: PolylineId(polylineIdVal),
            width: 5,
            jointType: JointType.mitered,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
            color: iconcolorsecondary,
            points: mapxcontroller
                .routedirectiondetails.value.polylines_encoded!
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList()),
      );
    });
    _caneraBoundToRoute();
  }

  void _caneraBoundToRoute() {
    var bound_sw =
        mapxcontroller.routedirectiondetails.value.bound_sw as LatLng;
    var bound_ne =
        mapxcontroller.routedirectiondetails.value.bound_ne as LatLng;

  
    _newgooglemapcontroller!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: bound_sw, northeast: bound_ne), 45));
  }

  bool searchNearDriver(){
      if(nearbydriverlist.length == 0){
        handelrDialog("No available driver");

              
        return false;
      }else{
        var driver  = nearbydriverlist[0];
        nearbydriverlist.removeAt(0);
        return true;
      }




  }
  @override
  Widget build(BuildContext context) {
    createCustomMarker();
    createCustomLocationMarker();
    return Column(children: [
      isMapReady == false
          ? Expanded(
              child: lotie.Lottie.asset(
                'assets/images/52141-balancing-loader.json',
                //animate: true,
              ),
            )
          : Expanded(
              child: Stack(
              fit: StackFit.expand,
              children: [
                GoogleMap(
                  padding: EdgeInsets.only(top: 100, bottom: mpappading),
                  mapType: MapType.hybrid,
                  initialCameraPosition: cameraposition as CameraPosition,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: isPicking ? markersSet as Set<Marker> : {},
                  polylines: polylinesSet as Set<Polyline>,
                  onMapCreated: (GoogleMapController mapcontroller) {
                    if (!_googlmapcompleter.isCompleted) {
                      _googlmapcompleter.complete(mapcontroller);
                      _newgooglemapcontroller = mapcontroller;
                      _moveCameraToCurrentPostion();
                    }
                  },
                  onTap: _currentStep >= 1 ? null : placeMarker,

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
                    decoration: BoxDecoration(),
                    child: AnimatedSwitcher(
                      reverseDuration: Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOutBack,
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (child, animatin) => ScaleTransition(
                        scale: animatin,
                        child: child,
                      ),
                      child: currentrequestpagestate ==
                              tricycleRequestState.starting
                          ? startSearching(context)
                          : requestForm(context),
                    ),
                  ),
                ),
                if (isPicking && _currentStep == 0) buildFloatingSearchBar()
              ],
            ))
    ]);
  }

  int _currentStep = 0;

  List<Step> _getSteps() => [
        Step(
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 0,
            title: Text('Select Destination'),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if (mapxcontroller
                            .dropofflocation.value.placeformattedaddress ==
                        null) {
                      return Column(
                        children: [
                          Text(
                            'Choose Destination',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          Text(
                            ' Tap the map or use search bar to select location ',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          addVerticalSpace(8),
                          Divider(
                            height: 2,
                          ),
                          Container(
                              height: 125,
                              child: Center(
                                  child: lotie.Lottie.asset(
                                      "assets/images/86234-select-location.json"))),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                width: 30,
                                height: 30,
                                child: Center(
                                    child: FaIcon(
                                  FontAwesomeIcons.map,
                                  size: 30,
                                ))),
                            addHorizontalSpace(15),
                            Expanded(
                                child: Text(
                              'Selected Location',
                              style: Theme.of(context).textTheme.bodyText1,
                            ))
                          ],
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              LatLng droposition = LatLng(
                                  mapxcontroller.dropofflocation.value.latitude
                                      as double,
                                  (mapxcontroller.dropofflocation.value
                                      .longitude as double));
                              _moveCamera(droposition);
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                        child: FaIcon(
                                      FontAwesomeIcons.mapMarkerAlt,
                                      size: 30,
                                    ))),
                                addHorizontalSpace(15),
                                mapxcontroller.isaddresloading.value
                                    ? Container(
                                        width: 100,
                                        height: 100,
                                        child: Center(
                                            child: lotie.Lottie.asset(
                                          "assets/images/84272-loading-colour.json",
                                        )))
                                    : Expanded(
                                        child: Text(
                                        '${mapxcontroller.dropofflocation.value.placeformattedaddress}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ))
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                  addVerticalSpace(12),
                  Divider(
                    height: 2,
                  ),
                ],
              ),
            )),
        Step(
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 1,
            title: Text('Send Request'),
            content: Container(
              child: Text('b'),
            )),
      ];

  Widget requestForm(BuildContext context) {
    return Container(
      height: 300,
      color: COLOR_WHITE,
      key: Key('2'),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(primary: iconcolorsecondary)),
              child: Stepper(
                onStepTapped: (step) => setState(() => _currentStep = step),
                currentStep: _currentStep,
                type: StepperType.horizontal,
                steps: _getSteps(),
                onStepContinue: () {
                  final lastStep = _currentStep == _getSteps().length - 1;

               

                  if (lastStep) {
                    print('completed');
                  } else {

                    if (mapxcontroller.lastpickedlocation !=
                        mapxcontroller.dropofflocation.value.placeid) {
                      prepaireRequest();
                    }
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
                controlsBuilder:
                    (BuildContext context, ControlsDetails detail) {
                  final lastStep = _currentStep == _getSteps().length - 1;
                  return Container(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(child: Obx(() {
                          return ElevatedButton(
                              child: Text(lastStep ? "CONFIRM" : "NEXT"),
                              onPressed: mapxcontroller.dropofflocation.value
                                          .placeformattedaddress ==
                                      null
                                  ? null
                                  : detail.onStepContinue);
                        })),
                        addHorizontalSpace(12),
                        if (_currentStep != 0)
                          Expanded(
                              child: ElevatedButton(
                                  child: Text("BACK"),
                                  onPressed: detail.onStepCancel)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: -25,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: InkWell(
                  onTap: () {
                    requestLogic();
                    //switchContainer();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: COLOR_WHITE,
                    height: 50,
                    width: 50,
                    child: Center(child: FaIcon(FontAwesomeIcons.timesCircle)),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Container startSearching(BuildContext context) {
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
                // switchContainer();
                requestLogic();
              },
              child: Text('FIND TRICYCLE'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(iconcolorsecondary),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showRequestForm() {
    setCurrentRequestState(tricycleRequestState.requesting);
  }

  void requestLogic()  {

     

    
    if (currentrequestpagestate == tricycleRequestState.starting) {
       nearbydriverlist = Geofirehelper.nearAvailableDriber;


     
         print('___________hey');
         print(nearbydriverlist.length);
         setState(() {
        isPicking = true;
        _containerHeight = 250;
        mpappading = 300;
        currentrequestpagestate = tricycleRequestState.requesting;
      });

    


    } else {
      clearRequest();
    }
  }

  void clearRequest() {
     mapxcontroller.clearRequest();
    setState(() {
      isPicking = false;
      _containerHeight = 200;
      mpappading = 200;
      markersSet!.clear();
      polylinesSet!.clear();
      isPicking = false;
      _currentStep = 0;
      currentrequestpagestate = tricycleRequestState.starting;
    });
  }

  bool isSearchFocus = false;
  void setSearchFocus(bool value) {
    setState(() {
      isSearchFocus = value;
    });
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
          mapxcontroller.placeprediction.clear();
        }

        mapxcontroller.searchPlace(query);

        // Call your model, bloc, controller here.
      },
      onSubmitted: (query) async {

        if(mapxcontroller.placeprediction.length != 0 ){
            PredictionPlace firstresult = mapxcontroller.placeprediction[0];
        var ismarkerSet = await mapxcontroller
            .setDropOffLocationFromSearch(firstresult.placeId as String);
        setDropOffMarker(mapxcontroller.markerPositon as LatLng);
        if (ismarkerSet) {
          setState(() {
            searchcontroller.close();
            mapxcontroller.placeprediction.clear();
          });
        }
        }
        

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
                  Obx(() {
                    if (mapxcontroller.isfetching.value) {
                      // when fetching
                    }
                    if (mapxcontroller.placeprediction.length <= 0) {
                      return Container();
                    }
                    return ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              height: 2,
                              thickness: 1,
                            ),
                        itemCount: mapxcontroller.placeprediction.length,
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
                                '${mapxcontroller.placeprediction[index].maintext}'),
                            subtitle: Text(
                                '${mapxcontroller.placeprediction[index].secondrarytext}'),
                            onTap: () async {
                              var ismarkerSet = await mapxcontroller
                                  .setDropOffLocationFromSearch(mapxcontroller
                                      .placeprediction[index].placeId);

                              setDropOffMarker(
                                  mapxcontroller.markerPositon as LatLng);
                              if (ismarkerSet) {
                                setState(() {
                                  searchcontroller.close();
                                  mapxcontroller.placeprediction.clear();
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
}
