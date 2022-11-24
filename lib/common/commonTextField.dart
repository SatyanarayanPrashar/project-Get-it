import 'package:flutter/material.dart';

class commonTextField extends StatelessWidget {
  commonTextField(
      {super.key,
      this.title,
      this.tiptool,
      required this.inputcontroller,
      this.ispassword,
      this.hint,
      this.maxLine,
      this.enableToolTip,
      this.length,
      this.disabletitle});

  final String? title;
  String? tiptool = "";
  final bool? ispassword;
  final bool? disabletitle;
  final bool? enableToolTip;
  final String? hint;
  final int? maxLine;
  final double? length;
  final TextEditingController inputcontroller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        disabletitle ?? false
            ? Container()
            : Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Text(
                      title ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff385585)),
                    ),
                  ),
                  enableToolTip ?? false
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 7, left: 17),
                          child: Tooltip(
                            showDuration: const Duration(seconds: 4),
                            message: tiptool ?? "",
                            triggerMode: TooltipTriggerMode.tap,
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                color: const Color(0xffA6BBDE),
                                borderRadius: BorderRadius.circular(17)),
                            child: const Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xff385585),
                              size: 18,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Material(
            elevation: 10,
            shadowColor: const Color(0xff17056EAC),
            child: SizedBox(
              width: length ?? size.width,
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
                    borderSide: BorderSide(
                        color: const Color(0xff17056EAC).withOpacity(0.1),
                        width: 1),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
