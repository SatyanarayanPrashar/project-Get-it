import 'package:flutter/material.dart';
import 'package:get_it/Screens/auth/OtpVerfPage.dart';
import 'package:get_it/Screens/auth/widgets/animatedButton.dart';
import 'package:get_it/common/commonTextField.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
                inputcontroller: passwordController,
                title: "Confirm Password",
                hint: "Reenter your password",
                ispassword: true,
              ),
              ElevatedButton(
                onPressed: () {
                  print("to Home Home page");
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OtpPage();
                  }));
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
