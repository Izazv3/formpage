import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:formpage/controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FireBaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final FCMtoken = await _firebaseMessaging.getToken();

    Controller.formcontroller.fcmToken = FCMtoken!;

    print("fcm token : ${Controller.formcontroller.fcmToken}");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle data message
      print("Message data: ${message.data}");

      // Handle notification message
      print("Message notification: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification that opened the app
      print("Notification opened app: ${message.data}");
    });
    // FirebaseMessaging.onBackgroundMessage(
    //     (message) => handleBackgroundMessage(message));
  }

  static Future<void> sendNotificationToFirebase(
      String title, String body) async {
    final String serverKey =
        'AAAAA_aA8eE:APA91bEgDQuBKsRi1Yt7fA0IoCLKuMmaTl0GqEHPwQ4xidHdFYivHNb8feWTHA068gHLUHVdUEW55l_RtsPe49j6cn2xP86-8T52KWtsv39k6vY7VQtfH3poqX4kFlFnL0nsKojw1l0K';

    final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    final payload = {
      'to': Controller.formcontroller.fcmToken,
      'notification': {
        'title': title,
        'body': body,
      },
      'data': {
        'key1': 'value1',
        'key2': 'value2',
      },
    };

    print(payload);

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("title : ${message.notification?.title ?? "title"}");
  print("body : ${message.notification?.body ?? "body"}");
  print("payload : ${message.data}");
}
