import 'dart:async';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/UI/palette.dart';
import 'package:tricycleapp/binding/gextbinding.dart';
import 'package:tricycleapp/config/firebaseconfig.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/dialog/infodialog/infodialog.dart';
import 'package:tricycleapp/emailverifying_screen.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';
import 'package:tricycleapp/home_screen_manager.dart';
import 'package:tricycleapp/localnotification/local_notification_services.dart';
import 'package:tricycleapp/screens/driver_location_screen.dart';
import 'package:tricycleapp/screens/editprofile_screen.dart';
import 'package:tricycleapp/screens/home_screen.dart';
import 'package:tricycleapp/screens/me_screen.dart';
import 'package:tricycleapp/screens/ongoingtrip.dart';
import 'package:tricycleapp/screens/request_tricycle_sreen.dart';
import 'package:tricycleapp/screens/trip_screen.dart';
import 'package:tricycleapp/signin_screen.dart';
import 'package:tricycleapp/sigup_screen.dart';
import 'package:tricycleapp/testcloudfunction.dart';
import 'package:tricycleapp/testotp.dart';
import 'package:tricycleapp/testsign_screen.dart';
import 'package:tricycleapp/testwidgets/dashboard.dart';
import 'package:tricycleapp/uiconstant/constant.dart';
import 'package:tricycleapp/verifyingemail_screen.dart';

Future<void> backgroundhandler(RemoteMessage message) async {
  print('notification from backgournd');
  print(message.notification!.title);
  print(message.notification!.body);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationServices.initialize();

  try {
    await Firebaseconfig.firebaseinitilizeapp().then((value) {});
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
    } else {
      throw e;
    }
  } catch (e) {
    rethrow;
  }

  //backoufn handler
  FirebaseMessaging.onBackgroundMessage(backgroundhandler);

  runApp(const TricycleApp());
}

class TricycleApp extends StatefulWidget {
  const TricycleApp({Key? key}) : super(key: key);

  @override
  _TricycleAppState createState() => _TricycleAppState();
}

class _TricycleAppState extends State<TricycleApp> {
  late StreamSubscription<ConnectivityResult> sunscription;

  late StreamSubscription<User?> user;

  void listenToInternetConnection(BuildContext context) async {
    sunscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        Infodialog.showToastCenter( Colors.black, ELSA_GREEN, 'Connected'.toUpperCase());
        Get.find<Authcontroller>().hasinternet(true);
        // I am connected to a mobile network.
      } else if (result == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        Infodialog.showToastCenter( Colors.black, ELSA_GREEN, 'Connected'.toUpperCase());
        Get.find<Authcontroller>().hasinternet(true);
      } else {
        Get.find<Authcontroller>().hasinternet(false);

           Infodialog.showToastCenter( Colors.black, Colors.grey[400], 'No Enternet'.toUpperCase());

      
      }
      // Got a new connectivity status!
    });
  }

  @override
  void initState() {
    super.initState();

    Gextbinding().dependencies();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    //it will open the app close tor terminated iot will open the ap
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        print('forgound');
        print(message.notification!.title);
        print(message.notification!.body);

        Get.toNamed(message.data["screenname"]);
      }
    });

    //forground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print('forgound');
        print(message.notification!.title);
        print(message.notification!.body);

        LocalNotificationServices.display(message);
      }
    });

    //when click the notficale on background state
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.notification!.title);
      print('click notification from backgournd');
      print(message.notification!.title);
      print(message.notification!.body);

      Get.toNamed(message.data["screenname"]);
    });
  }

  bool isdidchangecalled = false;

  @override
  void didChangeDependencies() {
    if (isdidchangecalled == false) {
      listenToInternetConnection(context);
      setState(() {
        isdidchangecalled = true;
      });
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = window.physicalSize.width;

    return GetMaterialApp(
      smartManagement: SmartManagement.keepFactory,
      initialBinding: Gextbinding(),

      theme: ThemeData(
        scaffoldBackgroundColor: BOTTOMNAVIGATOR_COLOR,
        textTheme: TEXT_THEME_DEFAULT_DARK,
        primarySwatch: Palette.generateMaterialColor(0xFF151147),
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? SigninScreen()
          : FirebaseAuth.instance.currentUser!.emailVerified == false
              ? VerifyingemailScreen()
              : HomeScreenManager(),
      //HomeScreenManager(),
      //Testcloudfunction(),
      //SigninScreen(),
      //   authinstance.currentUser ==  null?  SigninScreen() : HomeScreenManager(),
      getPages: [
        GetPage(
            name: SignupScreen.screenName,
            page: () => SignupScreen(),
            binding: Gextbinding()),
        GetPage(
            name: SigninScreen.screenName,
            page: () => SigninScreen(),
            binding: Gextbinding()),
        GetPage(
            name: Dashboard.screenName,
            page: () => Dashboard(),
            binding: Gextbinding()),
        GetPage(
            name: HomeScreenManager.screenName,
            page: () => HomeScreenManager(),
            binding: Gextbinding()),
        GetPage(
            name: HomeScreen.screenName,
            page: () => HomeScreen(),
            binding: Gextbinding()),
        GetPage(
            name: RequestTricycleSreen.screenName,
            page: () => RequestTricycleSreen(),
            binding: Gextbinding()),
        GetPage(
            name: TripScreen.screenName,
            page: () => TripScreen(),
            binding: Gextbinding()),
        GetPage(
            name: MeScreen.screenName,
            page: () => MeScreen(),
            binding: Gextbinding()),
        GetPage(
            name: Ongoingtrip.screenName,
            page: () => Ongoingtrip(),
            binding: Gextbinding()),
        GetPage(
          name: DriverLocationScreen.screenName,
          page: () => DriverLocationScreen(),
          binding: Gextbinding(),
        ),
        GetPage(
          name: EditprofileScreen.screenName,
          page: () => EditprofileScreen(),
          binding: Gextbinding(),
        ),
        GetPage(
            name: VerifyingemailScreen.screenName,
            page: () => VerifyingemailScreen(),
            binding: Gextbinding()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
