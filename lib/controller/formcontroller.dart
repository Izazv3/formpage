import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:formpage/model/user.dart';
import 'package:get/get.dart';

import '../utils/database.dart';

class FormController extends GetxController {
  TextEditingController userName = TextEditingController(text: "");
  TextEditingController userEmail = TextEditingController(text: "");
  TextEditingController userProfile = TextEditingController(text: "");

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

  Future<void> fetchUser() async {
    var users = await DatabaseHelper().getUsers();

    userData.value = users.toList();
  }
}
