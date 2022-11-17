import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/insiderScreens/RequestDetailsPage.dart';
import 'package:get_it/common/bottomSheet.dart';
import 'package:get_it/common/bottomsheetItem.dart';
import 'package:get_it/common/custom_confirmation_dialog.dart';
import 'package:get_it/models/localStorage.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:timeago/timeago.dart' as timeago;

class RequestTile extends StatefulWidget {
  final bool? isUserPost;
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
  final String? requestUid;
  final void Function()? refresh;

  const RequestTile(
      {super.key,
      this.isUserPost,
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
      this.requestUid,
      this.refresh});

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  UserModel? thisUserModel;

  void deleteRequest() async {
    String? currentCollege = await LocalStorage.getCollege();
    FirebaseFirestore.instance
        .collection("College")
        .doc(currentCollege)
        .collection("requests")
        .doc(widget.requestUid)
        .delete()
        .then((value) {
      Navigator.pop(context);
      widget.refresh;
    });
  }

  void toDetails() async {
    String? currentCollege = await LocalStorage.getCollege();

    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection("College")
        .doc(currentCollege)
        .collection("requests")
        .doc(widget.requestUid)
        .get();
    RequestModel requestModel =
        RequestModel.fromMap(userData.data() as Map<String, dynamic>);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RequestDetailPage(
        requestModel: requestModel,
        isUserPost: widget.isUserPost,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        toDetails();
      },
      child: Container(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar , about and options
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("assets/Images/praposalHome.png"),
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
                      widget.requestedon != null
                          ? timeago.format(widget.requestedon)
                          : "NA :(",
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
                          Container(
                            margin: EdgeInsets.fromLTRB(11, 7, 0, 0),
                            width: size.width * 0.57,
                            child: widget.isUserPost ?? false
                                ? InkWell(
                                    onTap: () {
                                      toDetails();
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(27),
                                      ),
                                      child: const Center(
                                          child: Text(
                                        "View",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    ),
                                  )
                                : SlideAction(
                                    onSubmit: () {
                                      //
                                      toDetails();
                                    },
                                    outerColor: Colors.blue,
                                    submittedIcon: const Icon(Icons.handshake,
                                        color: Colors.white),
                                    animationDuration:
                                        Duration(milliseconds: 170),
                                    height: 50,
                                    sliderButtonIconSize: 17,
                                    sliderButtonIconPadding: 11,
                                    text: "help",
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.7)),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color(0xffEAEAEA),
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}