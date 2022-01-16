import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/screens/home_screen.dart';
import 'package:tricycleapp/screens/me_screen.dart';
import 'package:tricycleapp/screens/request_tricycle_sreen.dart';
import 'package:tricycleapp/screens/trip_history_screen.dart';
import 'package:tricycleapp/signin_screen.dart';
import 'package:tricycleapp/sigup_screen.dart';
import 'package:tricycleapp/testotp.dart';
import 'package:tricycleapp/testsign_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBAu_0jNcwH8OC8Mva4f_5ARKEgsu6Hz5U",
            appId: "1:162571879335:android:8b1e81380c3c34f417ac82",
            messagingSenderId: "162571879335",
            projectId: "tricyleapp-f8fff"));
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
    } else {
      throw e;
    }
  } catch (e) {
    rethrow;
  }

  runApp(const TricycleApp());
}

class TricycleApp extends StatefulWidget {
  const TricycleApp({Key? key}) : super(key: key);

  @override
  _TricycleAppState createState() => _TricycleAppState();
}

class _TricycleAppState extends State<TricycleApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        primarySwatch: Colors.red,
      ),
      home: HomeScreenManager(),
      getPages: [
        GetPage(name: SigupScreen.screenName, page: () => SigupScreen()),
        GetPage(name: SigninScreen.screenName, page: () => SigninScreen()),
        GetPage(
            name: HomeScreenManager.screenName,
            page: () => HomeScreenManager()),
        GetPage(name: HomeScreen.screenName, page: () => HomeScreen()),
        GetPage(
            name: RequestTricycleSreen.screenName,
            page: () => RequestTricycleSreen()),
        GetPage(
            name: TripHistoryScreen.screenName,
            page: () => TripHistoryScreen()),
        GetPage(name: MeScreen.screenName, page: () => MeScreen()),
        GetPage(name: TestsignScreen.screenName, page: () => TestsignScreen()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
