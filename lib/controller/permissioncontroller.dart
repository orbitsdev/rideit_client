import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/dialog/dialog_collection.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/dialog/requestdialog/collectionofdialog.dart';

class Permissioncontroller {

static Permissioncontroller instance =  Get.find();

Future<bool> geolocationServicePermission() async{
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
       DialogCollection.showInfo('Location services are disabled. Please Enable the location'); 
    return Future.error('Location services are disabled.');

  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
 
      DialogCollection.showInfo('Sence You dinied the app location Twice you cannot request permission again. Clear app data to request again or go to setting and allow app toa access location permission'); 
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
   
    // Permissions are denied forever, handle appropriately. 
    DialogCollection.showInfo('since you denied location permission Twice we could not send request permission again but you can clear app caches to refresh the app');
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

    // setMapIsReady(false);


    // LocationPermission permission;
    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.deniedForever) {
    //     return Future.error('Location Not Available');
    //   }
    // } else {
    //   throw Exception('Error');
    // } 

return serviceEnabled;
}

}