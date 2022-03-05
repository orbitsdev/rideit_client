import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotificationServices {

  static final FlutterLocalNotificationsPlugin _notificationplugin =  FlutterLocalNotificationsPlugin();

  
  static void initialize(){

    final InitializationSettings initializationsettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher')
    );

    _notificationplugin.initialize(initializationsettings, onSelectNotification: (String? route) async {
      if(route !=  null){
       print('hhaha_____payload');
      print(route);
      
      }
      
    });

  }

  static void display(RemoteMessage message) async {
    
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;
      final NotificationDetails notificationDetails =  NotificationDetails(
        android: AndroidNotificationDetails(
            "triograb",
            "triograb channel",
            channelDescription: "This is our channel",
            importance: Importance.max,
            priority: Priority.high,
            
            ),
      );
      await _notificationplugin.show( id, message.notification!.title, message.notification!.body, notificationDetails, payload: message.data['route']);
    } on Exception catch (e) {
      
      print(e);

    }
  }


}