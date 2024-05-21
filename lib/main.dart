import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:formpage/api/firebase.dart';
import 'package:formpage/view/home_page.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAnalytics.instance.logEvent(name: 'app_open');

  FireBaseApi firebaseApi = FireBaseApi();
  await firebaseApi.initNotification();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'reminders',
        channelKey: 'instant_notification',
        channelName: 'Basic Instant Notification',
        channelDescription:
            'Notification channel that can trigger notification instantly.',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Form Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
