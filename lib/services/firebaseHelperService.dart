import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/bttomNav.dart';
import 'package:get_it/models/helperModel.dart';
import 'package:get_it/models/userModel.dart';

class HelperService extends ChangeNotifier {
  Future<QuerySnapshot> fetchHelpers(UserModel userModel) async {
    final QuerySnapshot data = await FirebaseFirestore.instance
        .collection("College")
        .doc(userModel.college)
        .collection("helpers")
        .orderBy("requestedOn", descending: true)
        .get();
    return data;
  }

  static Future<void> createHelper(
      BuildContext context,
      User firebaseUser,
      UserModel userModel,
      String helpUid,
      TextEditingController notecontroller,
      TextEditingController availablecontroller) async {
    if (availablecontroller.text.isNotEmpty) {
      HelperModel newhelper = HelperModel(
        helpBy: userModel.fullname,
        helperUid: userModel.uid,
        helpUid: helpUid,
        helpOn: availablecontroller.text,
        helperProfilePic: userModel.profilepic,
        note: notecontroller.text,
        requestedOn: DateTime.now(),
      );
      FirebaseFirestore.instance
          .collection("College")
          .doc(userModel.college)
          .collection("helpers")
          .doc(helpUid)
          .set(newhelper.toMap());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return bottomNav(
          userModel: userModel,
          firebaseUser: firebaseUser,
        );
      }));
    }
  }
}
