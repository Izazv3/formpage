import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller.dart';

void bottomSheet(BuildContext context) {
  showModalBottomSheet(
    showDragHandle: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
                onPressed: () {
                  Controller.formcontroller.pickImage(isGallery: false);
                  Get.back();
                },
                child: Text("Open camera")),
            ElevatedButton(
                onPressed: () {
                  Controller.formcontroller.pickImage(isGallery: true);
                  Get.back();
                },
                child: Text("Pick from gallery"))
          ],
        ),
      );
    },
  );
}
