import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formpage/model/user.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/database.dart';

class FormController extends GetxController {
  TextEditingController userName = TextEditingController(text: "");
  TextEditingController userEmail = TextEditingController(text: "");

  Uint8List? profileImage;

  RxBool isFilePicked = true.obs;

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

  Future<void> pickImage({required bool isGallery}) async {
    isFilePicked.value = false;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera);

    if (pickedFile != null) {
      profileImage = await pickedFile.readAsBytes();
      isFilePicked.value = true;
    }
  }
}
