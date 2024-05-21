import 'package:flutter/material.dart';
import 'package:formpage/api/firebase.dart';
import 'package:formpage/controller.dart';
import 'package:formpage/model/user.dart';
import 'package:formpage/utils/database.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    initDB();
    Controller.formcontroller.fetchUser();
    super.initState();
  }

  Future initDB() async {
    await DatabaseHelper().database;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Form Page"),
        centerTitle: true,
      ),
      body: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Controller.formcontroller.userData.isEmpty
                      ? Center(
                          child: Text("Create a first user"),
                        )
                      : ListView(
                          children: [
                            ...Controller.formcontroller.userData
                                .map((element) => Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade300)),
                                      child: ListTile(
                                        leading: element.profile.isEmpty
                                            ? Icon(Icons.person)
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    element.profile),
                                              ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Controller
                                                      .formcontroller
                                                      .userName
                                                      .text = element.name;
                                                  Controller
                                                      .formcontroller
                                                      .userEmail
                                                      .text = element.email;

                                                  Controller
                                                      .formcontroller
                                                      .userProfile
                                                      .text = element.profile;
                                                  Get.dialog(FormDialog(
                                                    formKey: formKey,
                                                    userId: element.id!,
                                                    from: "Edit",
                                                  ));
                                                },
                                                icon: Icon(Icons.edit)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Get.dialog(AlertDialog(
                                                    title: Text(
                                                        "Are you sure to delete?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text("Back")),
                                                      TextButton(
                                                          onPressed: () async {
                                                            await DatabaseHelper()
                                                                .deleteUser(
                                                                    element.id!)
                                                                .then((value) =>
                                                                    Controller
                                                                        .formcontroller
                                                                        .fetchUser());

                                                            Get.back();
                                                          },
                                                          child: Text("Delete"))
                                                    ],
                                                  ));
                                                },
                                                icon: Icon(Icons.delete))
                                          ],
                                        ),
                                        title: Text(
                                          "${element.name} - (${element.id})",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Text(element.email),
                                      ),
                                    ))
                          ],
                        ))
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.dialog(FormDialog(
            formKey: formKey,
            from: "Add",
          ));
        },
        icon: Icon(Icons.add),
        label: Text("New User"),
      ),
    );
  }
}

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
      Controller.formcontroller.userProfile.clear();

      Controller.formcontroller.userName.clear();

      Controller.formcontroller.userEmail.clear();
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      controller: Controller.formcontroller.userProfile,
                      decoration: InputDecoration(
                          hintText: "https://example.com/image.png",
                          labelText: "Profile picture (optional)",
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
                    Spacer(),
                    SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                            onPressed: () async {
                              bool isProfileValid = true;

                              if (Controller
                                  .formcontroller.userProfile.text.isNotEmpty) {
                                isProfileValid = GetUtils.isURL(
                                    Controller.formcontroller.userProfile.text);
                              }

                              if (widget.formKey.currentState!.validate()) {
                                if (isProfileValid) {
                                  var obj = User(
                                      name: Controller
                                          .formcontroller.userName.text,
                                      email: Controller
                                          .formcontroller.userEmail.text,
                                      profile: Controller
                                          .formcontroller.userProfile.text);

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
                                } else {
                                  Get.snackbar(
                                      "Profic url not valid", "invalid url");
                                }
                              }
                            },
                            child: Text("Complete"))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
