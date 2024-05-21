import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:formpage/model/user.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  TextEditingController userName = TextEditingController(text: "rose");
  TextEditingController userEmail =
      TextEditingController(text: "rose1234@gmail.com");
  TextEditingController userId = TextEditingController(text: "12345678");
  TextEditingController userProfile = TextEditingController(
      text:
          "https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg");

  var userData = <User>[].obs;

  String fcmToken = "";

  Future<bool> showNotification(title, body) async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

    awesomeNotifications.setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        print(receivedAction);
      },
    );

    return awesomeNotifications.createNotification(
      content: NotificationContent(
        id: Random().nextInt(100),
        title: title,
        body: body,
        channelKey: 'instant_notification',
      ),
    );
  }
}
