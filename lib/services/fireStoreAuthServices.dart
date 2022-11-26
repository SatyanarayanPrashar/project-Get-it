import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/bttomNav.dart';
import 'package:get_it/common/actionmessage.dart';
import 'package:get_it/models/localStorage.dart';
import 'package:get_it/models/userModel.dart';

class FirestoreAuthServices {
  static Future<void> checkValues(
    String collegevalue,
    String email,
    String fullname,
    String batchvalue,
    String branch,
    BuildContext context,
    User firebaseUser,
    File? idcardimg,
    File? profilepicimg,
  ) async {
    if (idcardimg == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Please upload idCard!',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } else if (profilepicimg == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Please upload Profile picture!',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } else if (fullname != null ||
        collegevalue.isEmpty ||
        branch != null ||
        batchvalue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Please fill all the details',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } else {
      FirestoreAuthServices.createProfile(collegevalue, email, fullname,
          batchvalue, branch, context, firebaseUser, idcardimg, profilepicimg);
    }
  }

  static Future<void> createProfile(
    String collegevalue,
    String email,
    String fullname,
    String batchvalue,
    String branch,
    BuildContext context,
    User firebaseUser,
    File? idcardimg,
    File? profilepicimg,
  ) async {
    String? uid = FirebaseAuth.instance.currentUser!.uid;

    UploadTask uploadidcard = FirebaseStorage.instance
        .ref("profilepictures")
        .child("${uid}idcard")
        .putFile(idcardimg ?? File("assets/Images/auth.jpg"));
    UploadTask uploadprofilepic = FirebaseStorage.instance
        .ref("profilepictures")
        .child("${uid}profilepic")
        .putFile(profilepicimg ?? File("assets/Images/auth.jpg"));
    TaskSnapshot snapshotprofilepic = await uploadprofilepic;
    TaskSnapshot snapshotidcard = await uploadidcard;

    String? profilepicURL = await snapshotprofilepic.ref.getDownloadURL();
    String? idcardURL = await snapshotidcard.ref.getDownloadURL();

    UserModel newUser = UserModel(
      uid: uid,
      email: email,
      college: collegevalue,
      fullname: fullname,
      batch: batchvalue,
      branch: branch,
      idCard: idcardURL,
      profilepic: profilepicURL,
    );
    FirebaseFirestore.instance
        .collection("College")
        .doc(collegevalue)
        .collection("users")
        .doc(uid)
        .set(newUser.toMap())
        .then((value) {
      LocalStorage.saveCollege(collegevalue);

      FirebaseFirestore.instance
          .collection("College")
          .doc(collegevalue)
          .update({"userCount": FieldValue.increment(1)});
      Navigator.popUntil(context, (route) => route.isFirst);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return bottomNav(firebaseUser: firebaseUser, userModel: newUser);
      }));
    });
  }

  static Future<void> login(
      TextEditingController emailController,
      TextEditingController passwordController,
      String collegevalue,
      BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "" || collegevalue == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Please fill all the details!',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } else {
      LocalStorage.saveCollege(collegevalue);
      try {
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        String uid = credential.user!.uid;

        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection("College")
            .doc(collegevalue)
            .collection("users")
            .doc(uid)
            .get();
        UserModel userModel =
            UserModel.fromMap(userData.data() as Map<String, dynamic>);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return bottomNav(
              userModel: userModel, firebaseUser: credential.user!);
        }));
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
}
