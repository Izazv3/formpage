import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/firebase.dart';
import '../../controller.dart';
import '../../model/user.dart';
import '../../utils/database.dart';

class FormDialog extends StatefulWidget {
  const FormDialog(
      {super.key, required this.formKey, required this.from, this.userId});

  final GlobalKey<FormState> formKey;
  final String from;
  final int? userId;

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  @override
  void initState() {
    if (widget.from == "Add") {
      Controller.formcontroller.userName.clear();

      Controller.formcontroller.userEmail.clear();

      Controller.formcontroller.profileImage = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.from == "Add"
                    ? Text(
                        "Fill this form",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    : Text(
                        "Update Form",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                CloseButton()
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            ),
            Expanded(
              child: Form(
                key: widget.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: Controller.formcontroller.userName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Input required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "User name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: Controller.formcontroller.userEmail,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Input required";
                          }

                          if (!GetUtils.isEmail(value)) {
                            return "Invalid email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "User Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () {
                          Controller.formcontroller.isFilePicked.value;
                          return Column(
                            children: [
                              Controller.formcontroller.profileImage != null
                                  ? Container(
                                      height: 200,
                                      alignment: Alignment.topRight,
                                      padding:
                                          EdgeInsets.only(right: 5, top: 5),
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(Controller
                                                  .formcontroller
                                                  .profileImage!))),
                                      child: IconButton(
                                          onPressed: () {
                                            Controller.formcontroller
                                                .profileImage = null;
                                            Controller.formcontroller
                                                    .isFilePicked.value =
                                                !Controller.formcontroller
                                                    .isFilePicked.value;
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          )),
                                    )
                                  : SizedBox(
                                      width: double.maxFinite,
                                      child: OutlinedButton(
                                          onPressed: () {
                                            Controller.formcontroller
                                                .pickImage();
                                          },
                                          child: Text("Pick Profile image")),
                                    ),
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (widget.formKey.currentState!.validate()) {
                                  var obj = User(
                                      name: Controller
                                          .formcontroller.userName.text,
                                      email: Controller
                                          .formcontroller.userEmail.text);

                                  if (Controller.formcontroller.profileImage !=
                                      null) {
                                    obj.profile =
                                        Controller.formcontroller.profileImage;
                                  }

                                  if (widget.from == 'Add') {
                                    await DatabaseHelper().insertUser(obj).then(
                                        (value) => Controller.formcontroller
                                            .fetchUser());

                                    FireBaseApi.sendNotificationToFirebase(
                                        "New user Created - ${Controller.formcontroller.userName.text}",
                                        "${Controller.formcontroller.userEmail.text}");
                                  } else if (widget.from == "Edit") {
                                    await DatabaseHelper()
                                        .updateUser(obj, widget.userId)
                                        .then((value) => Controller
                                            .formcontroller
                                            .fetchUser());

                                    FireBaseApi.sendNotificationToFirebase(
                                        "User updated - ${Controller.formcontroller.userName.text}",
                                        "${Controller.formcontroller.userEmail.text}");
                                  }

                                  Get.back();
                                }
                              },
                              child: Text("Complete"))),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
