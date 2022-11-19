import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/HomePage/requestTile.dart';
import 'package:get_it/models/comment.dart';
import 'package:get_it/models/localStorage.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:timeago/timeago.dart' as timeago;

class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage(
      {super.key,
      required this.requestModel,
      this.isUserPost,
      required this.loggedUserModel});
  final RequestModel requestModel;
  final UserModel loggedUserModel;
  final bool? isUserPost;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  late Future<QuerySnapshot> commentList;

  @override
  void initState() {
    super.initState();
    commentList = fetchComments();
  }

  Future<QuerySnapshot> fetchComments() async {
    String? college = await LocalStorage.getCollege();
    final QuerySnapshot data = await FirebaseFirestore.instance
        .collection("College")
        .doc(college)
        .collection("requests")
        .doc(widget.requestModel.requestUid)
        .collection("comments")
        .orderBy("commentedOn", descending: true)
        .get();

    return data;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black.withOpacity(0.6)),
        title: Text(
          "GetiT",
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 11),
        child: FutureBuilder<QuerySnapshot>(
            future: commentList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  QuerySnapshot commentSnapshot =
                      snapshot.data as QuerySnapshot;
                  int doclength = commentSnapshot.docs.length;
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        commentList = fetchComments();
                      });
                    },
                    child: doclength != 0
                        ? ListView.builder(
                            itemCount: doclength,
                            itemBuilder: (context, index) {
                              CommentModel currentHelp = CommentModel.fromMap(
                                  commentSnapshot.docs[index].data()
                                      as Map<String, dynamic>);

                              return index == 0
                                  ? Column(
                                      children: [
                                        RequestTile(
                                          isOnHome: false,
                                          requestUid:
                                              widget.requestModel.requestUid,
                                          isUserPost: widget.isUserPost,
                                          requestedby:
                                              widget.requestModel.requestedBy,
                                          note: widget.requestModel.note,
                                          one: widget.requestModel.one,
                                          oneQuantity:
                                              widget.requestModel.oneQuantity,
                                          two: widget.requestModel.two,
                                          twoQuantity:
                                              widget.requestModel.twoQuantity,
                                          three: widget.requestModel.three,
                                          threeQuantity:
                                              widget.requestModel.threeQuantity,
                                          getitBy: widget.requestModel.getby,
                                          price: widget.requestModel.price,
                                          requestedon:
                                              widget.requestModel.requestedOn ??
                                                  DateTime.now(),
                                          loggedUserModel:
                                              widget.loggedUserModel,
                                        ),
                                        commentTile(
                                          helperName: currentHelp.commentBy,
                                          loggedUserModel:
                                              widget.loggedUserModel,
                                          time: currentHelp.timing,
                                          commentedOn: currentHelp.commentedOn,
                                          note: currentHelp.note,
                                          helperId: currentHelp.helperId,
                                          requestModel: widget.requestModel,
                                        ),
                                        doclength == 1
                                            ? const Text(
                                                "there are no one else to help :(")
                                            : Container(),
                                        doclength == 1
                                            ? const Text(
                                                "Make sure to share with your friends :)")
                                            : Container(),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        commentTile(
                                          loggedUserModel:
                                              widget.loggedUserModel,
                                          helperName: currentHelp.commentBy,
                                          time: currentHelp.timing,
                                          commentedOn: currentHelp.commentedOn,
                                          note: currentHelp.note,
                                          helperId: currentHelp.helperId,
                                          requestModel: widget.requestModel,
                                        ),
                                        index == doclength - 1
                                            ? const Text(
                                                "there are no one else to help :(")
                                            : Container(),
                                        index == doclength - 1
                                            ? const Text(
                                                "Make sure to share with your friends :)")
                                            : Container(),
                                      ],
                                    );
                            },
                          )
                        : Column(
                            children: [
                              RequestTile(
                                isOnHome: false,
                                requestUid: widget.requestModel.requestUid,
                                isUserPost: widget.isUserPost,
                                requestedby: widget.requestModel.requestedBy,
                                note: widget.requestModel.note,
                                one: widget.requestModel.one,
                                oneQuantity: widget.requestModel.oneQuantity,
                                two: widget.requestModel.two,
                                twoQuantity: widget.requestModel.twoQuantity,
                                three: widget.requestModel.three,
                                threeQuantity:
                                    widget.requestModel.threeQuantity,
                                getitBy: widget.requestModel.getby,
                                price: widget.requestModel.price,
                                requestedon: widget.requestModel.requestedOn ??
                                    DateTime.now(),
                                loggedUserModel: widget.loggedUserModel,
                              ),
                              Center(
                                child: Text("No one offered any help yet :("),
                              ),
                            ],
                          ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("somthing went wrong :("),
                  );
                } else {
                  return const Center(
                    child: Text("YOu have not requested anything yet:("),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

class commentTile extends StatefulWidget {
  final String? helperName;
  final String? helperId;
  final UserModel loggedUserModel;

  final DateTime? commentedOn;
  final String? time;
  final String? note;
  final RequestModel requestModel;

  const commentTile(
      {super.key,
      this.helperName,
      this.commentedOn,
      this.time,
      this.note,
      required this.requestModel,
      this.helperId,
      required this.loggedUserModel});

  @override
  State<commentTile> createState() => _commentTileState();
}

class _commentTileState extends State<commentTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 7),
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
                    widget.helperName ?? "NA :(",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.commentedOn != null
                        ? timeago.format(widget.commentedOn ?? DateTime.now())
                        : "NA :(",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
          widget.note != ""
              ? ExpandableText(
                  widget.note ?? "",
                  style: const TextStyle(fontSize: 14),
                  expandText: "more",
                  collapseText: "show less",
                  maxLines: 1,
                  linkColor: Colors.black.withOpacity(0.3),
                  linkStyle: TextStyle(decoration: TextDecoration.underline),
                )
              : Container(),
          Container(
            margin: const EdgeInsets.only(top: 11, bottom: 11),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: const Color(0xffA6BBDE).withOpacity(0.2),
                      border: Border.all(color: const Color(0xffEAEAEA)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    margin: const EdgeInsets.only(right: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Time:"),
                        Text(widget.time ?? "NA :("),
                      ],
                    ),
                  ),
                ),
                widget.requestModel.requestedBy != widget.helperName
                    ? widget.requestModel.requestedBy ==
                            widget.loggedUserModel.fullname
                        ? Flexible(
                            child: SlideAction(
                              onSubmit: () {
                                //
                              },
                              outerColor: const Color(0xffA6BBDE),
                              submittedIcon: const Icon(Icons.handshake,
                                  color: Colors.white),
                              animationDuration:
                                  const Duration(milliseconds: 170),
                              height: 50,
                              sliderButtonIconSize: 17,
                              sliderButtonIconPadding: 11,
                              text: "accept",
                              textStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7)),
                            ),
                          )
                        : Container()
                    : Column(
                        children: [
                          Text(widget.helperName ?? ""),
                          Text(widget.requestModel.requestedBy ?? "")
                        ],
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
    );
  }
}
