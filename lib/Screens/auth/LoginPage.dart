import 'package:flutter/material.dart';
import 'package:get_it/Screens/auth/SignupPage.dart';
import 'package:get_it/common/commonTextField.dart';
import 'package:get_it/services/fireStoreAuthServices.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String collegevalue = "";
  var colleges = [
    'NMIT, Bengaluru',
    'SMVIT, Bengaluru',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
              SizedBox(height: size.height * 0.02),
              commonTextField(
                inputcontroller: emailController,
                title: "Email",
                hint: "Enter your email",
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    const Text(
                      "College",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff385585)),
                    ),
                    const Spacer(),
                    DropdownButton(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      hint: collegevalue == ""
                          ? Text("Select your college")
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
              ),
              commonTextField(
                inputcontroller: passwordController,
                title: "Password",
                hint: "Enter your password",
                ispassword: true,
              ),
              ElevatedButton(
                onPressed: () {
                  FirestoreAuthServices.login(emailController,
                      passwordController, collegevalue, context);
                },
                child: SizedBox(
                  height: 45,
                  width: size.width,
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: TextButton(
                  onPressed: () {
                    //
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(letterSpacing: 0.7),
                  ),
                ),
              ),
              const Text("Don't have a GetiT account?"),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SignupPage();
                  }));
                },
                child: const Text(
                  "SignUp",
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
