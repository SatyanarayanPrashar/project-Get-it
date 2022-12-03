import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/bttomNav.dart';
import 'package:get_it/common/actionmessage.dart';
import 'package:get_it/common/loadingDialoge.dart';
import 'package:get_it/models/collegeModel.dart';
import 'package:get_it/models/localStorage.dart';
import 'package:get_it/models/userModel.dart';

class FirestoreAuthServices {
  static Future<void> signUp(
    String college,
    String email,
    String fullname,
    BuildContext context,
    User firebaseUser,
  ) async {
    UIHelper.showLoadingDialog(context, "Logging In..");

    String? uid = FirebaseAuth.instance.currentUser!.uid;

    UserModel newUser = UserModel(
      uid: uid,
      email: email,
      college: college,
      profileComplete: false,
      fullname: fullname,
      batch: "",
      branch: "",
      idCard: "",
      profilepic: "",
    );
    FirebaseFirestore.instance
        .collection("College")
        .doc(college)
        .collection("users")
        .doc(uid)
        .set(newUser.toMap())
        .then((value) {
      LocalStorage.saveCollege(college);

      FirebaseFirestore.instance
          .collection("College")
          .doc(college)
          .update({"userCount": FieldValue.increment(1)});
      Navigator.popUntil(context, (route) => route.isFirst);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return bottomNav(firebaseUser: firebaseUser, userModel: newUser);
      }));
    });
  }

  static Future<void> createCommunity(String community) async {
    CollegeModel newCollege = CollegeModel(
      name: community,
      userCount: 0,
    );
    FirebaseFirestore.instance
        .collection("College")
        .doc(community)
        .set(newCollege.toMap());
  }

  static Future<void> editProfile(
    UserModel userModel,
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
    UIHelper.showLoadingDialog(context, "Saving");

    String? uid = FirebaseAuth.instance.currentUser!.uid;
    String? idcardURL;
    String? profilepicURL;

    if (idcardimg != null) {
      UploadTask uploadidcard = FirebaseStorage.instance
          .ref("profilepictures")
          .child("${uid}idcard")
          .putFile(idcardimg);
      TaskSnapshot snapshotidcard = await uploadidcard;
      idcardURL = await snapshotidcard.ref.getDownloadURL();
    } else {
      idcardURL = userModel.idCard;
    }
    if (profilepicimg != null) {
      UploadTask uploadprofilepic = FirebaseStorage.instance
          .ref("profilepictures")
          .child("${uid}profilepic")
          .putFile(profilepicimg);
      TaskSnapshot snapshotprofilepic = await uploadprofilepic;
      profilepicURL = await snapshotprofilepic.ref.getDownloadURL();
    } else {
      profilepicURL = userModel.profilepic;
    }

    UserModel newUser = UserModel(
        uid: uid,
        email: email,
        college: collegevalue,
        fullname: fullname,
        batch: batchvalue,
        branch: branch,
        idCard: idcardURL,
        profilepic: profilepicURL,
        profileComplete:
            (idcardimg != null && idcardimg != "" && fullname != ""));
    FirebaseFirestore.instance
        .collection("College")
        .doc(collegevalue)
        .collection("users")
        .doc(uid)
        .set(newUser.toMap())
        .then((value) {
      LocalStorage.saveCollege(collegevalue);

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
    UIHelper.showLoadingDialog(context, "Logging In..");
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
