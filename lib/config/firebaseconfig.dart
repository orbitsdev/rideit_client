import 'package:firebase_core/firebase_core.dart';

class Firebaseconfig {

static const String FIREBASE_API_KEY ="AIzaSyBAu_0jNcwH8OC8Mva4f_5ARKEgsu6Hz5U";
static const String FIREBASE_APP_ID ="1:162571879335:android:8b1e81380c3c34f417ac82";
static const String FIREBASE_MESSAGING_ID ="162571879335";
static const String FIREBASE_PROJECT_ID ="tricyleapp-f8fff";



static Future<FirebaseApp>  firebaseinitilizeapp() async{
  var firebaseapp =   await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: FIREBASE_API_KEY,
            appId: FIREBASE_APP_ID,
            messagingSenderId: FIREBASE_MESSAGING_ID,
            projectId: FIREBASE_PROJECT_ID));

  return firebaseapp;
}

}