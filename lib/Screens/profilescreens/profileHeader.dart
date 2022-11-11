import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/HomePage/header.dart';
import 'package:get_it/Screens/auth/LoginPage.dart';
import 'package:get_it/common/bottomSheet.dart';
import 'package:get_it/common/bottomsheetItem.dart';
import 'package:get_it/common/custom_confirmation_dialog.dart';

class profileHeader extends StatelessWidget {
  const profileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      print("to Home Home page");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    }

    return Container(
      height: size.height * 0.2,
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CustomBottomSheet(
                      height: size.height * 0.2,
                      childern: true
                          ? [
                              BottomSheetItems(
                                onTap: () {
                                  print("object");
                                  showConfirmationDialog(
                                      context: context,
                                      message:
                                          "Are you sure you want to Log out?",
                                      onPress: () {
                                        //
                                        logout();
                                      });
                                },
                                title: "Logout",
                              ),
                            ]
                          : [
                              BottomSheetItems(
                                onTap: () {
                                  //
                                },
                                title: "Share",
                              ),
                            ],
                    ),
                  );
                },
                icon: Icon(Icons.menu_rounded)),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/Images/praposalHome.png"),
                      radius: size.width * 0.1,
                    ),
                    SizedBox(
                      height: size.width * 0.25,
                      width: size.width * 0.7,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Satyanarayan Prashar",
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                Text(
                                  "ECE ",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "2025",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                //
                              },
                              child: Container(
                                width: 70,
                                margin: EdgeInsets.only(top: 4),
                                padding: EdgeInsets.fromLTRB(11, 7, 11, 7),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                    child: Text(
                                  "Edit",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(bottom: 10, child: CollegeFlag()),
        ],
      ),
    );
  }
}
