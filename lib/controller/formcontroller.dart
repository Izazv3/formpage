import 'package:flutter/material.dart';
import 'package:formpage/model/user.dart';
import 'package:get/get.dart';

class FormControlle extends GetxController {
  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userId = TextEditingController();
  TextEditingController userProfile = TextEditingController();

  var userData = <User>[].obs;
}
