import 'package:flutter/material.dart';
import 'package:get_it/Screens/auth/SetProfilePage.dart';
import 'package:get_it/Screens/auth/widgets/animatedButton.dart';
import 'package:get_it/common/actionmessage.dart';
import 'package:get_it/common/commonTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/models/userModel.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

  void signup() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cpassword = cpasswordController.text.trim();

    if (email == "" || password == "" || cpassword == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Please fill all the details!',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } else if (password != cpassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Passwords are not matching',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          Navigator.popUntil(context, (route) => route.isFirst);

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return SetProfilePage(email: email);
          }));
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Actionmessage(
            message: e.code.toString(),
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
              commonTextField(
                inputcontroller: emailController,
                title: "Email",
                hint: "Enter your email",
              ),
              commonTextField(
                inputcontroller: passwordController,
                title: "Password",
                hint: "Enter your password",
                ispassword: true,
              ),
              commonTextField(
                inputcontroller: cpasswordController,
                title: "Confirm Password",
                hint: "Reenter your password",
                ispassword: true,
              ),
              ElevatedButton(
                onPressed: () {
                  signup();
                },
                child: SizedBox(
                  height: 45,
                  width: size.width,
                  child: const Center(
                    child: Text(
                      "Signup",
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: InkWell(
                  onTap: () {
                    // Authentication here
                    print("tapped");
                  },
                  child: const Button(
                      buttonText:
                          "For seamless one-tap Sign Up, please use your Google account to continue."),
                ),
              ),
              const SizedBox(height: 57),
              const Text("Already have an account?"),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                    letterSpacing: 1,
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
