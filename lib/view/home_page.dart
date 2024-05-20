import 'package:flutter/material.dart';
import 'package:formpage/api/firebase.dart';
import 'package:formpage/controller.dart';
import 'package:formpage/model/user.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
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
                          child: Text("No user found!"),
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
                                                onPressed: () {},
                                                icon: Icon(Icons.edit)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            IconButton(
                                                onPressed: () {},
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
          Get.dialog(AlertDialog(
            scrollable: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Fill this form"), CloseButton()],
            ),
            content: Form(
              key: formKey,
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
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "User Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: Controller.formcontroller.userId,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Input required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "User ID",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: () {
                            bool isProfileValid = true;

                            if (Controller
                                .formcontroller.userProfile.text.isNotEmpty) {
                              isProfileValid = GetUtils.isURL(
                                  Controller.formcontroller.userProfile.text);
                            }

                            if (formKey.currentState!.validate() &&
                                isProfileValid) {
                              var obj = User(
                                  name: Controller.formcontroller.userName.text,
                                  email:
                                      Controller.formcontroller.userEmail.text,
                                  id: Controller.formcontroller.userId.text,
                                  profile: Controller
                                      .formcontroller.userProfile.text);

                              Controller.formcontroller.userData.add(obj);
                              FireBaseApi.sendNotificationToFirebase(
                                  "New user Created - ${Controller.formcontroller.userName.text}",
                                  "${Controller.formcontroller.userEmail.text}");
                              Get.back();
                            }
                          },
                          child: Text("Submit"))),
                ],
              ),
            ),
          ));
        },
        icon: Icon(Icons.add),
        label: Text("New User"),
      ),
    );
  }
}
