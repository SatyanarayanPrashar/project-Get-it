import 'package:flutter/material.dart';
import 'package:get_it/common/commonTextField.dart';

class SetProfilePage extends StatefulWidget {
  SetProfilePage({super.key});

  @override
  State<SetProfilePage> createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController collageController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController batchController = TextEditingController();

  String collegevalue = 'NMIT, Bengaluru';
  String batchvalue = '2023';

  var colleges = [
    'NMIT, Bengaluru',
    'SMVIT, Bengaluru',
  ];
  var batches = ['2023', '2024', '2025', '2026'];

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
              commonTextField(
                inputcontroller: nameController,
                title: "Name",
                hint: "Enter your name",
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
                    hint: Text("Select your college"),
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
                    hint: Text("Select your batch"),
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
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  height: 37,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Color(0xff17056EAC),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                        color: Color(0xff17056EAC).withOpacity(0.1), width: 1),
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
            ],
          ),
        ),
      ),
    );
  }
}
