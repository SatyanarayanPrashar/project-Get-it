import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/insiderScreens/RequestDetailsPage.dart';
import 'package:get_it/common/actionmessage.dart';
import 'package:get_it/common/bottomSheet.dart';
import 'package:get_it/common/bottomsheetItem.dart';
import 'package:get_it/common/commonTextField.dart';
import 'package:get_it/common/custom_confirmation_dialog.dart';
import 'package:get_it/main.dart';
import 'package:get_it/models/comment.dart';
import 'package:get_it/models/localStorage.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:timeago/timeago.dart' as timeago;

class RequestTile extends StatefulWidget {
  final bool? isUserPost;
  final String? tileLocation;

  final String? requestedby;
  final DateTime requestedon;
  final String? one;
  final String? oneQuantity;
  final String? two;
  final String? twoQuantity;
  final String? three;
  final String? threeQuantity;
  final String? getitBy;
  final String? price;
  final String? note;
  final String? requestid;
  final String? profilePic;
  final UserModel loggedUserModel;
  final User firebaseUser;
  final void Function()? refresh;

  RequestTile({
    super.key,
    this.requestedby,
    required this.requestedon,
    this.one,
    this.oneQuantity,
    this.two,
    this.twoQuantity,
    this.three,
    this.threeQuantity,
    this.getitBy,
    this.price,
    this.note,
    this.requestid,
    this.refresh,
    this.isUserPost,
    this.tileLocation,
    required this.loggedUserModel,
    required this.firebaseUser,
    this.profilePic,
  });

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  UserModel? thisUserModel;
  bool isHelpPressed = false;
  TextEditingController timeController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  void deleteRequest() async {
    String? currentCollege = await LocalStorage.getCollege();
    FirebaseFirestore.instance
        .collection("College")
        .doc(currentCollege)
        .collection("requests")
        .doc(widget.requestid)
        .delete()
        .then((value) {
      Navigator.pop(context);
      widget.refresh;
    });
  }

  void createComment() async {
    String? currentCollege = await LocalStorage.getCollege();
    String commentId = uuid.v1();

    if (timeController.text.isNotEmpty) {
      CommentModel newComment = CommentModel(
        commentBy: widget.loggedUserModel.fullname,
        timing: timeController.text,
        helperId: widget.loggedUserModel.uid,
        note: noteController.text,
        commentedOn: DateTime.now(),
        commentId: commentId,
      );
      FirebaseFirestore.instance
          .collection("College")
          .doc(currentCollege)
          .collection("requests")
          .doc(widget.requestid)
          .collection("comments")
          .doc(commentId)
          .set(newComment.toMap())
          .then((value) {
        setState(() {
          isHelpPressed = false;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Actionmessage(
            message: 'Please enter the timming!',
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      );
    }
  }

  void toDetails() async {
    String? currentCollege = await LocalStorage.getCollege();

    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection("College")
        .doc(currentCollege)
        .collection("requests")
        .doc(widget.requestid)
        .get();
    RequestModel requestModel =
        RequestModel.fromMap(userData.data() as Map<String, dynamic>);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RequestDetailPage(
        requestModel: requestModel,
        isUserPost: widget.isUserPost,
        loggedUserModel: widget.loggedUserModel,
        firebaseUser: widget.firebaseUser,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        (widget.tileLocation == "homepg") ? toDetails() : null;
      },
      child: Container(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.tileLocation == "chat"
                ? Container()
                : Row(
                    children: [
                      // Avatar , about and options
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.profilePic ?? ""),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.requestedby ?? "NA :(",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            timeago.format(widget.requestedon),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          //
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => CustomBottomSheet(
                              height: size.height * 0.2,
                              childern: widget.isUserPost ?? false
                                  ? [
                                      BottomSheetItems(
                                        onTap: () async {
                                          //
                                        },
                                        title: "Share",
                                      ),
                                      BottomSheetItems(
                                        onTap: () async {
                                          showConfirmationDialog(
                                              context: context,
                                              message:
                                                  "Are you sure you want to Log out?",
                                              onPress: () {
                                                //
                                                deleteRequest();
                                                print("torefresh");
                                                widget.refresh;
                                              });
                                        },
                                        title: "Delete",
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
                        icon: Icon(
                          Icons.more_vert,
                          size: 21,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      )
                    ],
                  ),
            widget.note != ""
                ? Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: ExpandableText(
                      widget.note ?? "",
                      style: const TextStyle(fontSize: 14),
                      expandText: "more",
                      collapseText: "show less",
                      maxLines: 2,
                      linkColor: Colors.black.withOpacity(0.3),
                      linkStyle:
                          const TextStyle(decoration: TextDecoration.underline),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(top: 11, bottom: 11),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      // height: 107,
                      width: size.width * 0.57,
                      decoration: BoxDecoration(
                        color: Color(0xffA6BBDE).withOpacity(0.2),
                        border: Border.all(color: Color(0xffEAEAEA)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(7),
                            margin: EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(widget.one ?? "",
                                        overflow: TextOverflow.clip),
                                  ),
                                ),
                                Text(widget.oneQuantity ?? ""),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(7),
                            margin: EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(widget.two ?? "",
                                        overflow: TextOverflow.clip),
                                  ),
                                ),
                                Text(widget.twoQuantity ?? ""),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(widget.three ?? "",
                                        overflow: TextOverflow.clip),
                                  ),
                                ),
                                // Spacer(),
                                Text(widget.threeQuantity ?? ""),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(7),
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Color(0xffA6BBDE).withOpacity(0.2),
                              border: Border.all(color: Color(0xffEAEAEA)),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            margin: EdgeInsets.only(left: 11),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "GetiT by: ${widget.getitBy ?? ""}",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "Price: ${widget.price ?? ""}",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          widget.tileLocation == "chat"
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.fromLTRB(11, 7, 0, 0),
                                  width: size.width * 0.57,
                                  child: (widget.isUserPost ?? false)
                                      ? (widget.tileLocation == "homepg")
                                          ? InkWell(
                                              onTap: () {
                                                toDetails();
                                              },
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(27),
                                                ),
                                                child: const Center(
                                                    child: Text(
                                                  "View",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                // toDetails();
                                              },
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(27),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "Edit",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                      : SlideAction(
                                          onSubmit: () {
                                            setState(() {
                                              isHelpPressed = true;
                                            });
                                          },
                                          outerColor: Colors.blue,
                                          submittedIcon: const Icon(
                                              Icons.handshake,
                                              color: Colors.white),
                                          animationDuration:
                                              const Duration(milliseconds: 170),
                                          height: 50,
                                          sliderButtonIconSize: 17,
                                          sliderButtonIconPadding: 11,
                                          text: "help",
                                          textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white
                                                  .withOpacity(0.7)),
                                        ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget.tileLocation == "chat"
                ? Container()
                : const Divider(
                    color: Color(0xffEAEAEA),
                    thickness: 1,
                  ),
            isHelpPressed
                ? Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          // width: size.width,
                          child: Column(
                            children: [
                              commonTextField(
                                inputcontroller: timeController,
                                title: "Timing*",
                                hint: "Enter time",
                                enableToolTip: true,
                                tiptool:
                                    "Enter the time at which you can hand over the item :D",
                              ),
                              commonTextField(
                                inputcontroller: noteController,
                                title: "Note",
                                hint: "Add a note",
                                enableToolTip: true,
                                tiptool: "You can add a note for the helper :D",
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                createComment();
                                setState(() {});
                              },
                              child: const Text("  Save  "),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isHelpPressed = false;
                                });
                              },
                              child: const Text(" Cancel "),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            isHelpPressed
                ? const Divider(
                    color: Color(0xffEAEAEA),
                    thickness: 1,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
