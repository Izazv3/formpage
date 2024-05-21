import 'package:flutter/material.dart';
import 'package:formpage/controller.dart';
import 'package:formpage/utils/database.dart';
import 'package:formpage/view/widgets/form_dialog.dart';
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
                                        leading: element.profile == null
                                            ? Icon(Icons.person)
                                            : CircleAvatar(
                                                backgroundImage: MemoryImage(
                                                    element.profile!),
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

                                                  Controller.formcontroller
                                                          .profileImage =
                                                      element.profile;

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
