import 'package:flutter/material.dart';
import 'package:get_it/common/commonTextField.dart';

class HelperFormPage extends StatelessWidget {
  const HelperFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    TextEditingController notecontroller = TextEditingController();
    TextEditingController availablecontroller = TextEditingController();

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
