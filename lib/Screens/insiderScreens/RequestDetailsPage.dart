// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/HomePage/requestTile.dart';
import 'package:get_it/Screens/chat/chatroom.dart';
import 'package:get_it/common/custom_confirmation_dialog.dart';
import 'package:get_it/main.dart';
import 'package:get_it/models/chatRoomModel.dart';
import 'package:get_it/models/comment.dart';
import 'package:get_it/models/firebaseHelper.dart';
import 'package:get_it/models/localStorage.dart';
import 'package:get_it/models/messageModel.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:timeago/timeago.dart' as timeago;

class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({
    super.key,
    required this.requestModel,
    this.isUserPost,
    required this.loggedUserModel,
    required this.firebaseUser,
  });
  final RequestModel requestModel;
  final UserModel loggedUserModel;
  final User firebaseUser;
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
        .doc(widget.requestModel.requestid)
        .collection("comments")
        .orderBy("commentedOn", descending: true)
        .get();

    return data;
  }

  void createChat() async {
    String? currentCollege = await LocalStorage.getCollege();
    String? chatid = uuid.v1();

    DocumentSnapshot chatData = await FirebaseFirestore.instance
        .collection("College")
        .doc(currentCollege)
        .collection("Chats")
        .doc(chatid)
        .get();
    ChatRoomModel chatRoomModel =
        ChatRoomModel.fromMap(chatData.data() as Map<String, dynamic>);
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
                                          tileLocation: "detailpg",
                                          requestid:
                                              widget.requestModel.requestid,
                                          profilePic: widget
                                              .requestModel.requesterProfilePic,
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
                                          firebaseUser: widget.firebaseUser,
                                        ),
                                        commentTile(
                                          helperProfilePic:
                                              currentHelp.helperProfilePic,
                                          helperName: currentHelp.commentBy,
                                          loggedUserModel:
                                              widget.loggedUserModel,
                                          firebaseUsser: widget.firebaseUser,
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
                                          helperProfilePic:
                                              currentHelp.helperProfilePic,
                                          firebaseUsser: widget.firebaseUser,
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
                                tileLocation: "detailpg",
                                requestid: widget.requestModel.requestid,
                                profilePic:
                                    widget.requestModel.requesterProfilePic,
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
                                firebaseUser: widget.firebaseUser,
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
  final String? helperProfilePic;
  final UserModel loggedUserModel;
  final User firebaseUsser;
  final DateTime? commentedOn;
  final String? time;
  final String? note;
  final RequestModel requestModel;

  const commentTile({
    super.key,
    this.helperName,
    this.commentedOn,
    this.time,
    this.note,
    required this.requestModel,
    this.helperId,
    required this.loggedUserModel,
    required this.firebaseUsser,
    this.helperProfilePic,
  });

  @override
  State<commentTile> createState() => _commentTileState();
}

class _commentTileState extends State<commentTile> {
  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("College")
        .doc(widget.loggedUserModel.college)
        .collection("chatrooms")
        .where("participants.${widget.loggedUserModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // fetch
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatroom;

      FirebaseFirestore.instance
          .collection("College")
          .doc(widget.loggedUserModel.college)
          .collection("chatrooms")
          .doc(chatRoom.chatroomid)
          .update({"chatClosed": false}).then(
              (value) => print(chatRoom?.chatClosed));
    } else {
      // create
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        requestid: widget.requestModel.requestid,
        chatClosed: false,
        createdon: DateTime.now(),
        participants: {
          widget.loggedUserModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );
      await FirebaseFirestore.instance
          .collection("College")
          .doc(widget.loggedUserModel.college)
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());
      chatRoom = newChatroom;
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar , about and options
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.helperProfilePic ??
                    "https://firebasestorage.googleapis.com/v0/b/get-it-8a8a7.appspot.com/o/profilepictures%2FpraposalHome.png?alt=media&token=6ea273da-f64b-4c30-b6ef-7770d8ac6b82"),
                // onBackgroundImageError: AssetImage("assets/Images/praposalHome.png"),
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
                    style: const TextStyle(
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
                  linkStyle:
                      const TextStyle(decoration: TextDecoration.underline),
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
                              onSubmit: () async {
                                showConfirmationDialog(
                                  context: context,
                                  message: "Go to chat and discuss :D",
                                  onPress: () async {
                                    Navigator.pop(context);
                                    UserModel? targetModel =
                                        await FirebaseHelper.getUserModelById(
                                            widget.helperId ?? "",
                                            widget.loggedUserModel.college);

                                    ChatRoomModel? chatroomModel =
                                        await getChatRoomModel(targetModel ??
                                            widget.loggedUserModel);

                                    if (chatroomModel != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ChatScreen(
                                              accessedFrom: "request",
                                              targetUser: targetModel ??
                                                  widget.loggedUserModel,
                                              userModel: widget.loggedUserModel,
                                              firebaseUser:
                                                  widget.firebaseUsser,
                                              chatRoomModel: chatroomModel,
                                              requestModel: widget.requestModel,
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                );
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
