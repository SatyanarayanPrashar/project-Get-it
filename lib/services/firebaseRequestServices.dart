import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/bttomNav.dart';
import 'package:get_it/Screens/chat/chatroom.dart';
import 'package:get_it/common/actionmessage.dart';
import 'package:get_it/models/chatRoomModel.dart';
import 'package:get_it/models/firebaseHelper.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';
import 'package:get_it/services/fireStoreChatServices.dart';

class RequestServices extends ChangeNotifier {
  bool isLoading = false;

  Future<QuerySnapshot> fetchRequests(
      bool isOnHomepage, UserModel userModel) async {
    isLoading = true;
    final QuerySnapshot data = isOnHomepage
        ? await FirebaseFirestore.instance
            .collection("College")
            .doc(userModel.college)
            .collection("requests")
            .orderBy("requestedOn", descending: true)
            .where("personalised", isEqualTo: false)
            .get()
        : await FirebaseFirestore.instance
            .collection("College")
            .doc(userModel.college)
            .collection("requests")
            .where("requestedby", isEqualTo: userModel.fullname)
            .get();
    isLoading = false;
    return data;
  }

  static Future<void> createRequestfromHelper(
      UserModel userModel,
      User firebaseUser,
      String helperUid,
      TextEditingController getitBycontroller,
      TextEditingController onecontroller,
      TextEditingController onequantitycontroller,
      TextEditingController pricecontroller,
      String requestid,
      String note,
      String two,
      String twoQuantity,
      String three,
      String threeQuantity,
      bool sendtohelperonly,
      bool? isitPersonalised,
      BuildContext context) async {
    UserModel? targetModel =
        await FirebaseHelper.getUserModelById(helperUid, userModel.college);
    ChatRoomModel? chatRoomModel = await FirestoreChatServices.getChatRoomModel(
        targetModel ?? userModel, userModel, requestid);

    if (getitBycontroller.text.isNotEmpty) {
      if (onecontroller.text.isNotEmpty) {
        if (onequantitycontroller.text.isNotEmpty) {
          if (pricecontroller.text.isNotEmpty) {
            RequestModel newRequest = RequestModel(
              requestid: requestid,
              getby: getitBycontroller.text,
              requestedBy: userModel.fullname,
              requesterProfilePic: userModel.profilepic,
              requesterUid: userModel.uid,
              requestedOn: DateTime.now(),
              price: pricecontroller.text,
              note: note,
              one: onecontroller.text.trim(),
              two: two,
              three: three,
              oneQuantity: onequantitycontroller.text.trim(),
              twoQuantity: twoQuantity,
              threeQuantity: threeQuantity,
              status: "pending",
              personalised: sendtohelperonly,
            );
            FirebaseFirestore.instance
                .collection("College")
                .doc(userModel.college)
                .collection("requests")
                .doc(requestid)
                .set(newRequest.toMap())
                .then((value) {
              isitPersonalised ?? false
                  ? chatRoomModel != null
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChatScreen(
                                accessedFrom: "request",
                                targetUser: targetModel ?? userModel,
                                userModel: userModel,
                                firebaseUser: firebaseUser,
                                chatRoomModel: chatRoomModel,
                                requestModel: newRequest,
                              );
                            },
                          ),
                        )
                      : print("failed")
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return bottomNav(
                            userModel: userModel,
                            firebaseUser: firebaseUser,
                          );
                        },
                      ),
                    );
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Actionmessage(
                message: 'Please enter the price you can offer!',
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Actionmessage(
              message: 'Please enter item ones quantity!',
            ),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Actionmessage(
            message: 'Please enter the item 1!',
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Please enter get it by!',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    }
  }

  static Future<void> createRequestfromHome(
      UserModel userModel,
      User firebaseUser,
      String helperUid,
      TextEditingController getitBycontroller,
      TextEditingController onecontroller,
      TextEditingController onequantitycontroller,
      TextEditingController pricecontroller,
      String requestid,
      String note,
      String two,
      String twoQuantity,
      String three,
      String threeQuantity,
      bool sendtohelperonly,
      bool? isitPersonalised,
      BuildContext context) async {
    if (getitBycontroller.text.isNotEmpty) {
      if (onecontroller.text.isNotEmpty) {
        if (onequantitycontroller.text.isNotEmpty) {
          if (pricecontroller.text.isNotEmpty) {
            RequestModel newRequest = RequestModel(
              requestid: requestid,
              getby: getitBycontroller.text,
              requestedBy: userModel.fullname,
              requesterProfilePic: userModel.profilepic,
              requesterUid: userModel.uid,
              requestedOn: DateTime.now(),
              price: pricecontroller.text,
              note: note,
              one: onecontroller.text.trim(),
              two: two,
              three: three,
              oneQuantity: onequantitycontroller.text.trim(),
              twoQuantity: twoQuantity,
              threeQuantity: threeQuantity,
              status: "pending",
              personalised: sendtohelperonly,
            );
            FirebaseFirestore.instance
                .collection("College")
                .doc(userModel.college)
                .collection("requests")
                .doc(requestid)
                .set(newRequest.toMap())
                .then((value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return bottomNav(
                      userModel: userModel,
                      firebaseUser: firebaseUser,
                    );
                  },
                ),
              );
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Actionmessage(
                message: 'Please enter the price you can offer!',
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Actionmessage(
              message: 'Please enter item ones quantity!',
            ),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Actionmessage(
            message: 'Please enter the item 1!',
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Actionmessage(
          message: 'Please enter get it by!',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    }
  }

  Future<QuerySnapshot> fetchComments(
      UserModel userModel, RequestModel requestModel) async {
    final QuerySnapshot data = await FirebaseFirestore.instance
        .collection("College")
        .doc(userModel.college)
        .collection("requests")
        .doc(requestModel.requestid)
        .collection("comments")
        .orderBy("commentedOn", descending: true)
        .get();

    return data;
  }
}
