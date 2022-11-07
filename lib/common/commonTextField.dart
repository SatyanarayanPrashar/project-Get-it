import 'package:flutter/material.dart';

class commonTextField extends StatelessWidget {
  const commonTextField(
      {super.key,
      this.title,
      required this.inputcontroller,
      this.ispassword,
      this.hint,
      this.maxLine});

  final String? title;
  final bool? ispassword;
  final String? hint;
  final int? maxLine;
  final TextEditingController inputcontroller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Text(
                title ?? "",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Color(0xff385585)),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Material(
            elevation: 10,
            shadowColor: Color(0xff17056EAC),
            child: TextField(
              controller: inputcontroller,
              obscureText: ispassword ?? false,
              decoration: InputDecoration(
                hintText: hint ?? 'Enter $title',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.white, width: 3.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
