import 'package:flutter/material.dart';
import 'package:formpage/controller/formcontroller.dart';
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
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
                child: ElevatedButton(onPressed: () {}, child: Text("Submit")))
          ],
        ),
      ),
    );
  }
}
