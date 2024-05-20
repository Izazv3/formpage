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
  FireBaseApi api = FireBaseApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Form Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Enter details",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: Controller.formcontroller.userName,
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
                  labelText: "Profile picture",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: Controller.formcontroller.userEmail,
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
              decoration: InputDecoration(
                  hintText: "User ID",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: () {
                      var obj = User(
                          name: Controller.formcontroller.userName.text,
                          email: Controller.formcontroller.userEmail.text,
                          id: Controller.formcontroller.userId.text,
                          profile: Controller.formcontroller.userProfile.text);
                      Controller.formcontroller.userData.add(obj);
                      FireBaseApi.sendNotificationToFirebase(
                          "Hello buddy", "How are you");
                    },
                    child: Text("Submit"))),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.maxFinite,
              child: OutlinedButton(
                  onPressed: () {
                    Get.to(UserView());
                  },
                  child: Text("View User Data")),
            )
          ],
        ),
      ),
    );
  }
}

class UserView extends StatelessWidget {
  const UserView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Page"),
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
                                .map((element) => ListTile(
                                      title: Text("user"),
                                    ))
                          ],
                        ))
            ],
          )),
    );
  }
}
