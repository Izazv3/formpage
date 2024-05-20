import 'package:flutter/material.dart';
import 'package:formpage/api/firebase.dart';
import 'package:formpage/controller/formcontroller.dart';
import 'package:formpage/model/user.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var formcontroller = Get.put(FormControlle());
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
              controller: formcontroller.userName,
              decoration: InputDecoration(
                  hintText: "User name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: formcontroller.userProfile,
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
              controller: formcontroller.userEmail,
              decoration: InputDecoration(
                  hintText: "User Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: formcontroller.userId,
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
                          name: formcontroller.userName.text,
                          email: formcontroller.userEmail.text,
                          id: formcontroller.userId.text,
                          profile: formcontroller.userProfile.text);
                      formcontroller.userData.add(obj);
                      FireBaseApi.sendNotificationToFirebase(
                          "d3jkFVBkQz2P_AOoAn3MSV:APA91bHAxpp48GqC8OxL1OD1m-YGtg_pwWXpHpyObmuJpO0GxCK67gR3qv1yG09sAkR981t8v5XPKbrpxg0YeMA6IpV_tpOvxDDt02nv0S3xyitGJXwcN6DK32BK3wUIVnRRZUNRcF0n",
                          "Hello buddy",
                          "How are you");
                    },
                    child: Text("Submit"))),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.maxFinite,
              child: OutlinedButton(
                  onPressed: () {
                    Get.to(UserView(formcontroller: formcontroller));
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
    required this.formcontroller,
  });

  final FormControlle formcontroller;

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
                  child: formcontroller.userData.isEmpty
                      ? Center(
                          child: Text("No user found!"),
                        )
                      : ListView(
                          children: [
                            ...formcontroller.userData
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
