import 'dart:math';

import 'package:tricycleapp/model/nearbydriver.dart';

class Geofirehelper {

static List<Nearbydriver> nearAvailableDriber = [];

static void removeDriverFromList(String key ) {

  
  int index = nearAvailableDriber.indexWhere((element) => element.key == key);
  
  if(nearAvailableDriber.length !=0){

  nearAvailableDriber.removeAt(index);
  }

}

static void updateDriverNearByLocation(Nearbydriver driver){

  int index =  nearAvailableDriber.indexWhere((element) => element.key == driver.key);
  nearAvailableDriber[index].latitude = driver.latitude;
  nearAvailableDriber[index].longitude = driver.longitude;
}

static double creatRandomNumber(int num){
  var random =  Random();
  int randNumber =  random.nextInt(num);
  return randNumber.toDouble();
}


static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value.toDouble();
    }
  }

}