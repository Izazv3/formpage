import 'package:firebase_messaging/firebase_messaging.dart';

class FireBaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final FCMtoken = await _firebaseMessaging.getToken();
    print("fcm token : ${FCMtoken}");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle data message
      print("Message data: ${message.data}");

      // Handle notification message
      print("Message notification: ${message.notification?.title}");

      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification!.android;

      // flutterLocalNotificationsPlugin.show(
      //   notification.hashCode,
      //   notification.title,
      //   notification.body,
      //   NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       'channel_id',
      //       'channel_name',
      //       'channel_description',
      //       importance: Importance.max,
      //       priority: Priority.high,
      //       showWhen: false,
      //     ),
      //   ),
      // );

      // Display the notification using a plugin like flutter_local_notifications
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification that opened the app
      print("Notification opened app: ${message.data}");
    });
    // FirebaseMessaging.onBackgroundMessage(
    //     (message) => handleBackgroundMessage(message));
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("title : ${message.notification?.title ?? "title"}");
  print("body : ${message.notification?.body ?? "body"}");
  print("payload : ${message.data}");
}
