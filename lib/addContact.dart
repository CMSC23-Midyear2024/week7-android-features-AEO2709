import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/email.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:image_picker/image_picker.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {

  Permission permission = Permission.camera;
  PermissionStatus permissionStatus = PermissionStatus.denied;
  File? imageFile;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await permission.status;
    setState(() => permissionStatus = status);
  }

  Contact newContact = Contact();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Scaffold(
            appBar: AppBar(
              title: Text("add Contact"),
            ),
            body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (permissionStatus == PermissionStatus.granted) {
                              final image = await ImagePicker()
                                  .pickImage(source: ImageSource.camera);
                              setState(() {
                                imageFile = image == null ? null : File(image.path);
                              });
                            } else {
                              requestPermission();
                            }
                          }, 
                          icon: Icon(Icons.camera_alt, size: 80),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "First Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Last Name",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name.';
                          }
                          return null;
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: TextFormField(
                        controller: numberController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Phone Number (09XXXXXXXXX)",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || int.tryParse(value) == null) {
                            return 'Please enter your Phone Number.';
                          }
                          return null;
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Email",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address.';
                          }
                          return null;
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, top: 10, right: 20, bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 4, 46, 80)),
                                side: MaterialStateProperty.all(BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(255, 4, 46, 80)))),
                            onPressed: () {
                              if (formKey.currentState!.validate()){
                                final newContact = Contact()
                                  ..name.first = firstNameController.text
                                  ..name.last = lastNameController.text
                                  ..phones = [Phone(numberController.text)]
                                  ..emails = [Email(emailController.text)];
                                newContact.insert();
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Add Contact",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget drawer() {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 133, 185, 227),
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 4, 46, 80)),
              child: Text(
                "Exercise 5: Menu, Routes, and Navigation",
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
          ListTile(
            title: Text("Friends"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/friends");
            },
          ),
          ListTile(
              title: Text("Slambook"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/slambook");
              }),
        ],
      ),
    );
  }
}