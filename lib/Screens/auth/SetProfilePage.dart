import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/bttomNav.dart';
import 'package:get_it/common/actionmessage.dart';
import 'package:get_it/common/commonTextField.dart';
import 'package:get_it/models/localStorage.dart';
import 'package:get_it/models/userModel.dart';
import 'package:get_it/services/fireStoreAuthServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SetProfilePage extends StatefulWidget {
  final String email;
  final User firebaseUser;

  const SetProfilePage(
      {super.key, required this.email, required this.firebaseUser});

  @override
  State<SetProfilePage> createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController collageController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController batchController = TextEditingController();

  String collegevalue = "";
  String batchvalue = "";

  var colleges = [
    'NMIT, Bengaluru',
    'SMVIT, Bengaluru',
  ];
  var batches = ['2023', '2024', '2025', '2026'];

  File? idcardimg;
  File? profilepicimg;

  void selectidCard(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      idcardimg = File(pickedFile.path);
    } else {
      setState(() {
        idcardimg = File("assets/Images/auth.jpg");
      });
    }
  }

  void selectprofilepic(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        profilepicimg = File(pickedFile.path);
      });
    } else {
      setState(() {
        profilepicimg = File("assets/Images/auth.jpg");
      });
    }
  }

  void showprofileoption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Upload Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectprofilepic(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo_album),
                title: const Text("Select from Gallery"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectprofilepic(ImageSource.camera);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a photo"),
              )
            ],
          ),
        );
      },
    );
  }

  void showidcardoption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Upload Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectidCard(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo_album),
                title: const Text("Select from Gallery"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectidCard(ImageSource.camera);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a photo"),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.17),
              const Text(
                "GetiT",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 47,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 18.0),
                child: Text(
                  "La Dunga yrr!",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      PermissionStatus storageStatus =
                          await Permission.storage.request();
                      if (storageStatus == PermissionStatus.granted) {
                        showprofileoption();
                      } else if (storageStatus == PermissionStatus.denied) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("This permission is recommended"),
                          ),
                        );
                      } else if (storageStatus ==
                          PermissionStatus.permanentlyDenied) {
                        openAppSettings();
                      }
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: (profilepicimg != null)
                          ? FileImage(profilepicimg!)
                          : null,
                      child: (profilepicimg == null)
                          ? const Icon(
                              Icons.person,
                              size: 60,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 17),
                  Flexible(
                    child: commonTextField(
                      inputcontroller: nameController,
                      title: "Name",
                      hint: "Enter your name",
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "College",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Color(0xff385585)),
                  ),
                  const Spacer(),
                  DropdownButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    hint: collegevalue == ""
                        ? const Text("Select your college")
                        : Text(collegevalue),
                    menuMaxHeight: size.height * 0.2,
                    isDense: true,
                    items: colleges.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        collegevalue = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: commonTextField(
                  inputcontroller: branchController,
                  title: "Branch",
                  hint: "select your branch",
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Batch",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Color(0xff385585)),
                  ),
                  const Spacer(),
                  DropdownButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    hint: batchvalue == ""
                        ? const Text("Select your batch")
                        : Text(batchvalue),
                    menuMaxHeight: size.height * 0.2,
                    isDense: true,
                    items: batches.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        batchvalue = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  "Upload College ID Card",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xff385585)),
                ),
              ),
              InkWell(
                onTap: () async {
                  PermissionStatus storageStatus =
                      await Permission.storage.request();
                  if (storageStatus == PermissionStatus.granted) {
                    showidcardoption();
                  } else if (storageStatus == PermissionStatus.denied) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("This permission is recommended"),
                      ),
                    );
                  } else if (storageStatus ==
                      PermissionStatus.permanentlyDenied) {
                    openAppSettings();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Container(
                    height: 37,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Color(0xff17056EAC),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                          color: Color(0xff17056EAC).withOpacity(0.1),
                          width: 1),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          idcardimg == null ? Icons.camera : Icons.done,
                          color: idcardimg == null
                              ? Colors.black.withOpacity(0.6)
                              : Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // FirestoreAuthServices.checkValues(
                  //     collegevalue,
                  //     widget.email,
                  //     nameController.text.trim(),
                  //     batchvalue,
                  //     branchController.text.trim(),
                  //     context,
                  //     widget.firebaseUser,
                  //     idcardimg,
                  //     profilepicimg);
                },
                child: SizedBox(
                  height: 45,
                  width: size.width,
                  child: const Center(
                    child: Text(
                      "Create Profile",
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
