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
import 'package:image_picker/image_picker.dart';

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

  // void cropId(XFile file) async {
  //   CroppedFile? croppedImage = await ImageCropper().cropImage(
  //       sourcePath: file.path,
  //       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  //       compressQuality: 10);

  //   if (croppedImage != null) {
  //     setState(() {
  //       idcardimg = File(croppedImage.path);
  //     });
  //   }
  // }

  // void cropprofilepic(XFile file) async {
  //   CroppedFile? croppedImage = await ImageCropper().cropImage(
  //       sourcePath: file.path,
  //       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  //       compressQuality: 10);

  //   if (croppedImage != null) {
  //     setState(() {
  //       profilepicimg = File(croppedImage.path);
  //     });
  //   }
  // }

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

  void checkImg() {
    if (idcardimg == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Please upload idCard!',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } else if (profilepicimg == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Please upload Profile picture!',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } else if (nameController.text.isEmpty ||
        collegevalue.isEmpty ||
        branchController.text.isEmpty ||
        batchvalue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Please fill all the details',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } else {
      createProfile();
    }
  }

  void createProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    UploadTask uploadidcard = FirebaseStorage.instance
        .ref("profilepictures")
        .child("${uid}idcard")
        .putFile(idcardimg ?? File("assets/Images/auth.jpg"));
    UploadTask uploadprofilepic = FirebaseStorage.instance
        .ref("profilepictures")
        .child("${uid}profilepic")
        .putFile(profilepicimg ?? File("assets/Images/auth.jpg"));
    TaskSnapshot snapshotprofilepic = await uploadprofilepic;
    TaskSnapshot snapshotidcard = await uploadidcard;
    String? profilepicURL = await snapshotprofilepic.ref.getDownloadURL();
    String? idcardURL = await snapshotidcard.ref.getDownloadURL();
    UserModel newUser = UserModel(
      uid: uid,
      email: widget.email,
      college: collegevalue,
      fullname: nameController.text,
      batch: batchvalue,
      branch: branchController.text,
      idCard: idcardURL,
      profilepic: profilepicURL,
    );
    FirebaseFirestore.instance
        .collection("College")
        .doc(collegevalue)
        .collection("users")
        .doc(uid)
        .set(newUser.toMap())
        .then((value) {
      LocalStorage.saveCollege(collegevalue);

      FirebaseFirestore.instance
          .collection("College")
          .doc(collegevalue)
          .update({"userCount": FieldValue.increment(1)});
      Navigator.popUntil(context, (route) => route.isFirst);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return bottomNav(firebaseUser: widget.firebaseUser, userModel: newUser);
      }));
    });
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
                    onTap: () {
                      showprofileoption();
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
                onTap: () {
                  showidcardoption();
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
                          Icons.camera,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  checkImg();
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
