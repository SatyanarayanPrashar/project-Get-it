import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/auth/SignupPage.dart';
import 'package:get_it/common/bottomSheet.dart';
import 'package:get_it/common/commonTextField.dart';
import 'package:get_it/models/collegeModel.dart';
import 'package:get_it/services/fireStoreAuthServices.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController collegeController = TextEditingController();
  TextEditingController searchController = TextEditingController();

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
              InkWell(
                onTap: () async {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return CustomBottomSheet(
                            // height: size.height * 0.4,
                            childern: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: commonTextField(
                                          title: "Search your College",
                                          hint: "enter your college name",
                                          inputcontroller: searchController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.3,
                                    child: StreamBuilder(
                                      stream: searchController.text.isEmpty
                                          ? FirebaseFirestore.instance
                                              .collection("College")
                                              .snapshots()
                                          : FirebaseFirestore.instance
                                              .collection("College")
                                              .where("name",
                                                  isEqualTo:
                                                      searchController.text)
                                              .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.active) {
                                          if (snapshot.hasData) {
                                            QuerySnapshot colleges =
                                                snapshot.data as QuerySnapshot;
                                            print(colleges.docs.length);
                                            return colleges.docs.length != 0
                                                ? ListView.builder(
                                                    itemCount:
                                                        colleges.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      CollegeModel cllg =
                                                          CollegeModel.fromMap(
                                                              colleges.docs[
                                                                          index]
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>);
                                                      return ListTile(
                                                        dense: true,
                                                        onTap: () {
                                                          setState(() {
                                                            collegeController
                                                                    .text =
                                                                cllg.name;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        title: Text(cllg.name),
                                                      );
                                                    },
                                                  )
                                                : Text(
                                                    "add ${searchController.text} to community");
                                          } else if (snapshot.hasError) {
                                            return const Center(
                                              child: Text(
                                                  "somthing went wrong :("),
                                            );
                                          } else {
                                            return const Center(
                                              child: Text("No results found"),
                                            );
                                          }
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ]);
                      });
                },
                child: commonTextField(
                  enable: false,
                  inputcontroller: collegeController,
                  title: "college*",
                  hint: "Choose your College",
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
                  FirestoreAuthServices.login(
                      emailController,
                      passwordController,
                      collegeController.text.trim(),
                      context);
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
