import 'package:flutter/material.dart';
import 'package:get_it/Screens/HomePage/home.dart';
import 'package:get_it/Screens/auth/LoginPage.dart';
import 'package:get_it/Screens/auth/SignupPage.dart';
import 'package:get_it/Screens/auth/widgets/animatedButton.dart';
import 'package:get_it/common/commonTextField.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController usernameController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xffFBFCFE),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: size.height * 0.07),
              Padding(
                padding: const EdgeInsets.only(left: 11, bottom: 7),
                child: Row(
                  children: [
                    Text(
                      "We have sent an OTP on ",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "satya@gmail.com",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 11, bottom: 11, top: 11),
                    child: Text(
                      "Enter OTP",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.74,
                    child: OTPTextField(
                      length: 4,
                      fieldWidth: 50,
                      style: TextStyle(fontSize: 21),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (value) {
                        //
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.04),
              ElevatedButton(
                onPressed: () {
                  print("to Home Home page");
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                },
                child: SizedBox(
                  height: 45,
                  width: size.width,
                  child: const Center(
                    child: Text(
                      "Verify",
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
