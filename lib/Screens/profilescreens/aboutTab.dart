import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/auth/LoginPage.dart';
import 'package:get_it/common/bottomSheet.dart';
import 'package:get_it/common/commonTextField.dart';
import 'package:get_it/common/custom_confirmation_dialog.dart';
import 'package:get_it/common/loadingDialoge.dart';
import 'package:get_it/models/userModel.dart';
import 'package:get_it/services/fireStoreAuthServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AboutTab extends StatefulWidget {
  const AboutTab(
      {super.key, required this.userModel, required this.firebaseUser});
  final UserModel userModel;
  final User firebaseUser;

  @override
  State<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  bool isEditClicked = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController batchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.userModel.fullname ?? "";
    branchController.text = widget.userModel.branch ?? "";
    batchController.text = widget.userModel.batch ?? "";
  }

  File? idcardimg;
  File? profilepicimg;

  void selectidCard(ImageSource source) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 20);
    if (pickedFile != null) {
      idcardimg = File(pickedFile.path);
    } else {
      setState(() {
        idcardimg =
            File(widget.userModel.profilepic ?? "assets/Images/auth.jpg");
      });
    }
  }

  void selectprofilepic(ImageSource source) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

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

  void logout() async {
    UIHelper.showLoadingDialog(context, "Logging In..");

    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    isEditClicked
                        ? null
                        : showConfirmationDialog(
                            context: context,
                            message: "Are you sure you want to Log out?",
                            onPress: () {
                              logout();
                            });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(11, 2, 11, 2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isEditClicked
                              ? Icons.compress_outlined
                              : Icons.logout_outlined,
                          color: Colors.red,
                          size: 17,
                        ),
                        Text(
                          isEditClicked ? "Cancel" : "Log out",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    isEditClicked
                        ? FirestoreAuthServices.editProfile(
                            widget.userModel,
                            widget.userModel.college ?? "",
                            widget.userModel.email ?? "",
                            nameController.text.trim(),
                            batchController.text.trim(),
                            branchController.text.trim(),
                            context,
                            widget.firebaseUser,
                            idcardimg,
                            profilepicimg,
                          )
                        : setState(() {
                            isEditClicked = true;
                          });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(11, 1, 11, 1),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isEditClicked
                            ? Colors.green
                            : Colors.blue.withOpacity(0.6),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isEditClicked ? Icons.done_all : Icons.edit_outlined,
                          color: isEditClicked
                              ? Colors.green
                              : Colors.blue.withOpacity(0.6),
                          size: 21,
                        ),
                        Text(
                          isEditClicked
                              ? "Save"
                              : widget.userModel.profileComplete ?? true
                                  ? "Edit"
                                  : "Complete Profile",
                          style: TextStyle(
                            fontSize: 14,
                            color: isEditClicked
                                ? Colors.green
                                : Colors.blue.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.userModel.profilepic != null
                    ? isEditClicked
                        ? InkWell(
                            onTap: () async {
                              PermissionStatus storageStatus =
                                  await Permission.storage.request();
                              if (storageStatus == PermissionStatus.granted) {
                                showprofileoption();
                              } else if (storageStatus ==
                                  PermissionStatus.denied) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("This permission is recommended"),
                                  ),
                                );
                              } else if (storageStatus ==
                                  PermissionStatus.permanentlyDenied) {
                                openAppSettings();
                              }
                            },
                            child: (profilepicimg != null)
                                ? CircleAvatar(
                                    radius: size.width * 0.15,
                                    backgroundImage: FileImage(profilepicimg!))
                                : CircleAvatar(
                                    radius: size.width * 0.15,
                                    backgroundImage: NetworkImage(
                                        widget.userModel.profilepic ?? ""),
                                    child: Icon(Icons.person,
                                        size: size.width * 0.12),
                                  ),
                          )
                        : widget.userModel.profilepic != ""
                            ? CircleAvatar(
                                radius: size.width * 0.15,
                                backgroundImage: NetworkImage(
                                    widget.userModel.profilepic ?? ""),
                                backgroundColor:
                                    const Color.fromARGB(255, 177, 220, 255),
                              )
                            : CircleAvatar(
                                radius: size.width * 0.15,
                                backgroundColor:
                                    const Color.fromARGB(255, 177, 220, 255),
                                child:
                                    Icon(Icons.person, size: size.width * 0.12),
                              )
                    : InkWell(
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
                          radius: size.width * 0.15,
                          backgroundImage: (profilepicimg != null)
                              ? FileImage(profilepicimg!)
                              : null,
                          backgroundColor:
                              const Color.fromARGB(255, 177, 220, 255),
                        ),
                      ),
                const SizedBox(width: 11),
              ],
            ),
            const SizedBox(height: 16),
            isEditClicked
                ? commonTextField(
                    inputcontroller: nameController,
                    title: "Fullname*",
                    hint: "Enter your Fullname",
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name:",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        widget.userModel.fullname ?? "Not set",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 11),
                    ],
                  ),
            Text(
              "College:",
              style: TextStyle(
                fontSize: 11,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Text(
              widget.userModel.college ?? "Not set",
              style: TextStyle(
                fontSize: 17,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            isEditClicked
                ? commonTextField(
                    inputcontroller: branchController,
                    title: "Branch",
                    hint: "Enter your branch",
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: Row(
                      children: [
                        Text(
                          "Branch:",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          widget.userModel.branch ?? "Not set",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
            isEditClicked
                ? commonTextField(
                    inputcontroller: batchController,
                    title: "batch",
                    hint: "Enter your batch",
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: Row(
                      children: [
                        Text(
                          "Batch:",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          widget.userModel.batch ?? "Not set",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
            Row(
              children: [
                Text(
                  "Id card:",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.userModel.idCard != ""
                      ? "Uploaded"
                      : "Not Uploaded :(",
                  style: TextStyle(
                    fontSize: 17,
                    color: widget.userModel.idCard != null
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                isEditClicked
                    ? InkWell(
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
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            (idcardimg != null) ? "Selected" : "Select New",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      )
                    : widget.userModel.idCard != ""
                        ? InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => CustomBottomSheet(
                                  height: size.height,
                                  childern: [
                                    Container(
                                      height: 0.5 * size.height,
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              widget.userModel.idCard ?? ""),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "view",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          )
                        : Container(),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Groups:",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Text(
              "Coming Soon",
              style: TextStyle(
                fontSize: 17,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
