import 'dart:math';

import 'package:tricycleapp/model/nearbydriver.dart';

class Geofirehelper {

static List<Nearbydriver> nearbydrivercollection = [];

static void removeDriverFromList(String key){
  int index =  nearbydrivercollection.indexWhere((element) => element.key == key);
  nearbydrivercollection.removeAt(index);

}

static void updateDriverNearByLocation(Nearbydriver drivers){
  int index  = nearbydrivercollection.indexWhere((element) => element.key == drivers.key);
  nearbydrivercollection[index].latitude = drivers.latitude;
  nearbydrivercollection[index].longitude = drivers.longitude;


}



static double createRandomNumber(int num){
var random = Random();
var randomNumber =  random.nextInt(num);
return randomNumber.toDouble();
}

}