import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/common/commonTextField.dart';
import 'package:get_it/main.dart';
import 'package:get_it/models/userModel.dart';
import 'package:get_it/services/firebaseHelperService.dart';

class HelperFormPage extends StatefulWidget {
  const HelperFormPage(
      {super.key, required this.userModel, required this.firebaseUser});
  final UserModel userModel;
  final User firebaseUser;

  @override
  State<HelperFormPage> createState() => _HelperFormPageState();
}

class _HelperFormPageState extends State<HelperFormPage> {
  TextEditingController notecontroller = TextEditingController();
  TextEditingController availablecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String helpUid = uuid.v1();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black.withOpacity(0.6)),
        title: Text(
          "GetiT",
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              commonTextField(
                inputcontroller: notecontroller,
                title: "Note",
                hint: "Enter a note",
                enableToolTip: true,
                tiptool: "Enter a note for others. :D",
              ),
              commonTextField(
                inputcontroller: availablecontroller,
                title: "Available on",
                hint: "Enter when you are avialable to help",
                enableToolTip: true,
                tiptool: "Enter by when you are avialable to help. :D",
              ),
              InkWell(
                onTap: () {
                  //
                  HelperService.createHelper(
                    context,
                    widget.firebaseUser,
                    widget.userModel,
                    helpUid,
                    notecontroller,
                    availablecontroller,
                  );
                },
                child: Container(
                  width: size.width,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                      child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
