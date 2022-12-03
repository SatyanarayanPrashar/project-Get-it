import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/common/actionmessage.dart';
import 'package:get_it/common/bottomSheet.dart';
import 'package:get_it/common/commonTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/models/collegeModel.dart';
import 'package:get_it/services/fireStoreAuthServices.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController collegeController = TextEditingController();
  TextEditingController addCllgController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  void signup() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String fullname = fullnameController.text.trim();
    String college = collegeController.text.trim();

    if (email == "" || password == "" || college == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Please fill all the * details!',
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
          FirestoreAuthServices.signUp(
              college, email, fullname, context, userCredential.user!);
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Actionmessage(
            message: e.code.toString(),
          ),
          duration: const Duration(seconds: 2),
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
                title: "Email*",
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
                                                : TextButton(
                                                    onPressed: () {
                                                      FirestoreAuthServices
                                                          .createCommunity(
                                                              searchController
                                                                  .text
                                                                  .trim());
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                        "add ${searchController.text} to community"),
                                                  );
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
                inputcontroller: fullnameController,
                title: "Username",
                hint: "Enter your name",
              ),
              commonTextField(
                inputcontroller: passwordController,
                title: "Password*",
                hint: "Enter your password",
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
              const SizedBox(height: 17),
              Column(
                children: [
                  const Text("By Signing up you are agreegin to Getit's"),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Terms and Conditions",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
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
