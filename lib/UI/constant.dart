
import 'package:flutter/material.dart';


String mapdarktheme = '''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''';
const double screenPadding = 25;
//containers
const double containerPadding = 25;
const double containerRadius = 6;
const DIALOG_WHITE =  Color(0xFFfbfefb);


const COLOR_BLACK = Color.fromRGBO(48, 47, 48, 1.0);
const COLOR_GEY = Color.fromRGBO(141, 141, 141, 1.0);
const BACKGROUND_BLACK =Color(0xFF0D101A);



const TEXT_COLOR_WHITE = Color(0xFFfbfefb);
const colorwhite = Color(0xFFfbfefb);
const iconcolor = Color(0xFF2F2191);
const iconcolorsecondary = Color(0xFF594DAF);

//Color BACKGROUND_BLACK = Color(0xFF0D101A);
const BACKGROUND_BLACK_LIGHT = Color(0xFF161828);
const BACKGROUND_BLACK_LIGHT_MORE_LIGHT = Color(0xFF292C3B);
const BACKGROUND_BLACK_LIGHT_MORE_LIGHT_2 = Color(0xFF383C51);

const ICON_GREY = Color(0xFF696C76);

//
const GREEN_LIGHT =  Color(0xFFB9E33F); 
const GREEN_LIGHT_2 =  Color(0xFFB8E23E); 
const GREEN_LIGHT_3 =  Color(0xFF93B92B); 
const GREEN_ONLINE =  Color(0xFF27CE59); 

const DARK_GREEN =  Color(0xFF239035); 
const YELLOW =  Color(0xFFF7FC29); 
const ORRANGE =  Color(0xFFFAA001); 

//text color
const TEXT_WHITE =  Color(0xFFFEFEFF); 
const TEXT_WHITE_2 =  Color.fromARGB(255, 225, 226, 226); 

//for small text
const TEXT_BLACK_DARK =  Color(0xFF484956); 

//gradient
const COLOR_G1 =  Color(0xFF0B0830); 
const COLOR_G2 =  Color(0xFF0C0A31); 


//elsa color
const BACKGROUND_TOP =  Color(0xFF02051C); 
const BACKGROUND_CEENTER =  Color(0xFF0C0A33); 
const BACKGROUND_BOTTOM =  Color(0xFF151147); 
const BOTTOMNAVIGATOR_COLOR =  Color(0xFF13112F); 
const ELSA_CONTAINER_DARK =  Color(0xFF0D0A34); 

//linegradient
const LINE_LEFT =  Color(0xFF22694E); 
const lINE_RIGHT =  Color(0xFF161A9E); 
const lINE_LIGHT =  Color(0xFF5E617A); 
//container Light box
const LIGHT_CONTAINER =  Color(0xFF322F65); 
const LIGHT_CONTAINER2 =  Color.fromARGB(255, 34, 31, 73); 
//elsa text
const ELSA_TEXT_WHITE =  Color(0xFFF6F6F8); 
const ELSA_TEXT_LIGHT =  Color(0xFF5E617A); 
const ELSA_TEXT_GREY =  Color(0xFF9897A9); 

//light bg color icon

const ELSA_ORANGE =  Color(0xFFFFAC3E); 
const ELSA_PINK =  Color(0xFFFA5F62); 

const ELSA_GREEN =  Color(0xFF61F3A8); 
const ELSA_BLUE =  Color(0xFF09B5FA); 
//button
const ELSA_BLUE_1_ =  Color(0xFF5560FF); 
const ELSA_BLUE_2_ =  Color(0xFF32D0FF); 
//prurple

const ELSA_PURPLE_1_ =  Color(0xFF9731FD); 
const ELSA_PURPLE_2_ =  Color(0xFFD75BFA); 

const ELSA_DARK_TEX =  Color(0xFF43425B); 
const ELSA_DARK_LIGHT_TEXT =  Color(0xFFD6D9E1); 

const ELSA_PINK_TEXT =  Color(0xFFDE5D7B); 
const ELSA_YELLOW_TEXT =  Color(0xFFE5BB26); 
//__________________________________________
const PINK_1 =  Color(0xFFFD007A); 
//|headline1 use in error dialog as title
//|headline2 use as body text
// headline3 use in button
//|_________________________________________
//

const TextTheme TEXT_THEME_DEFAULT_DARK  =  TextTheme(

  headline1: TextStyle(color:BACKGROUND_BLACK_LIGHT,fontWeight: FontWeight.w900,  fontSize: 26 , ),
  headline2: TextStyle(color:BACKGROUND_BLACK_LIGHT,  fontSize: 22 , ),
  headline3: TextStyle(color:BACKGROUND_BLACK_LIGHT,  fontSize: 20 , fontWeight: FontWeight.w700),
  //black
  headline4: TextStyle(color:BACKGROUND_BLACK_LIGHT,  fontSize: 26 , ),
  headline5: TextStyle(color:TEXT_COLOR_WHITE,  fontSize: 26 , ),
  headline6: TextStyle(color:BACKGROUND_BLACK_LIGHT,  fontSize: 12 , ),
  bodyText1: TextStyle(color:TEXT_WHITE_2, fontWeight: FontWeight.w300, fontSize: 16 ,  ),
  bodyText2: TextStyle(color:TEXT_WHITE_2, fontWeight: FontWeight.w600, fontSize: 14 , height: 1.5 ),
  subtitle1: TextStyle(color:BACKGROUND_BLACK, fontWeight: FontWeight.w300, fontSize: 16 , ),
  subtitle2: TextStyle(color:COLOR_GEY, fontWeight: FontWeight.w400, fontSize: 12 ),
);



const TextTheme TEXT_THEME_DEFAULT  =  TextTheme(
  headline1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 26 ,),
  headline2: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 22 ,),
  headline3: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 20 ,),
  headline4: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 16 ,),
  headline5: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 14 ,),
  headline6: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 12 ,),
  bodyText1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 14 , height: 1.5 ),
  bodyText2: TextStyle(color:TEXT_WHITE, fontWeight: FontWeight.w500, fontSize: 14 , height: 1.5 ),
  subtitle1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w400, fontSize: 12 ),
  subtitle2: TextStyle(color:COLOR_GEY, fontWeight: FontWeight.w400, fontSize: 12 ),
);


const TextTheme TEXT_THEME_SMALL  =  TextTheme(
  headline1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 22 ,),
  headline2: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 20 ,),
  headline3: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 18 ,),
  headline4: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 14 ,),
  headline5: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 12 ,),
  headline6: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 10 ,),
  bodyText1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 12 , height: 1.5 ),
  bodyText2: TextStyle(color:COLOR_GEY, fontWeight: FontWeight.w500, fontSize: 12 , height: 1.5 ),
  subtitle1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w400, fontSize: 10 ),
  subtitle2: TextStyle(color:COLOR_GEY, fontWeight: FontWeight.w400, fontSize: 10 ),
);

