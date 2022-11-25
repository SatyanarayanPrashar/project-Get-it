import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/HomePage/requestTile.dart';
import 'package:get_it/common/bottomSheet.dart';
import 'package:get_it/common/custom_confirmation_dialog.dart';
import 'package:get_it/main.dart';
import 'package:get_it/models/chatRoomModel.dart';
import 'package:get_it/models/messageModel.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.targetUser,
    required this.chatRoomModel,
    required this.userModel,
    required this.firebaseUser,
    this.requestModel,
    required this.accessedFrom,
  });
  final UserModel targetUser;
  final UserModel userModel;
  final User firebaseUser;
  final ChatRoomModel chatRoomModel;
  final RequestModel? requestModel;
  final String accessedFrom;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  void sendmssg() async {
    String mssg = messageController.text.trim();
    if (mssg != "") {
      //send mssg
      MessageModel newMssg = MessageModel(
        mssgId: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: mssg,
        seen: false,
      );
      FirebaseFirestore.instance
          .collection("College")
          .doc(widget.userModel.college)
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatroomid)
          .collection("messages")
          .doc(newMssg.mssgId)
          .set(newMssg.toMap());
      messageController.clear();

      FirebaseFirestore.instance
          .collection("College")
          .doc(widget.userModel.college)
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatroomid)
          .update({"lastMessage": mssg, "createdon": DateTime.now()});
    }
  }

  void closeChat() async {
    print(widget.chatRoomModel.chatClosed);
    FirebaseFirestore.instance
        .collection("College")
        .doc(widget.userModel.college)
        .collection("chatrooms")
        .doc(widget.chatRoomModel.chatroomid)
        .update({"chatClosed": true}).then(
            (value) => print(widget.chatRoomModel.chatClosed));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundImage:
                        NetworkImage(widget.targetUser.profilepic ?? ""),
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: size.width * 0.4,
                    child: Text(
                      widget.targetUser.fullname ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // chats StremBuilder will be placed in this Expanded
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("College")
                      .doc(widget.userModel.college)
                      .collection("chatrooms")
                      .doc(widget.chatRoomModel.chatroomid)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        return dataSnapshot.docs.length == 0
                            ? SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(),
                                    Container(
                                      height: 250,
                                      width: 250,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/Images/auth.jpg"),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                        "Discuss more about your request,"),
                                    const Text(
                                        "like location for hand over and payments."),
                                    const Text("GetiT;)"),
                                    const SizedBox(height: 16),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 11),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(21),
                                            border: Border.all()),
                                        child: RequestTile(
                                          tileLocation: "chat",
                                          requestedon: DateTime.now(),
                                          loggedUserModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser,
                                          note:
                                              "Hii ${widget.targetUser.fullname}, can you Please get it for me :)",
                                          one: widget.requestModel?.one,
                                          oneQuantity:
                                              widget.requestModel?.oneQuantity,
                                          two: widget.requestModel?.two,
                                          twoQuantity:
                                              widget.requestModel?.twoQuantity,
                                          three: widget.requestModel?.three,
                                          threeQuantity: widget
                                              .requestModel?.threeQuantity,
                                          getitBy: widget.requestModel?.getby,
                                          price: widget.requestModel?.price,
                                        )),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                reverse: true,
                                itemCount: dataSnapshot.docs.length,
                                itemBuilder: (context, index) {
                                  MessageModel currentMssg =
                                      MessageModel.fromMap(
                                          dataSnapshot.docs[index].data()
                                              as Map<String, dynamic>);

                                  return index == dataSnapshot.docs.length - 1
                                      ? Column(
                                          children: [
                                            Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 11),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            21),
                                                    border: Border.all()),
                                                child: RequestTile(
                                                  tileLocation: "chat",
                                                  requestedon: DateTime.now(),
                                                  loggedUserModel:
                                                      widget.userModel,
                                                  firebaseUser:
                                                      widget.firebaseUser,
                                                  note:
                                                      "Hii ${widget.targetUser.fullname}, can you Please get it for me :)",
                                                  one: widget.requestModel?.one,
                                                  oneQuantity: widget
                                                      .requestModel
                                                      ?.oneQuantity,
                                                  two: widget.requestModel?.two,
                                                  twoQuantity: widget
                                                      .requestModel
                                                      ?.twoQuantity,
                                                  three: widget
                                                      .requestModel?.three,
                                                  threeQuantity: widget
                                                      .requestModel
                                                      ?.threeQuantity,
                                                  getitBy: widget
                                                      .requestModel?.getby,
                                                  price: widget
                                                      .requestModel?.price,
                                                )),
                                            Row(
                                              mainAxisAlignment:
                                                  (currentMssg.sender ==
                                                          widget.userModel.uid)
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                      minHeight: 0,
                                                      maxWidth:
                                                          size.width * 0.6),
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 2),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: (currentMssg
                                                                .sender ==
                                                            widget
                                                                .userModel.uid)
                                                        ? const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    14),
                                                            topRight:
                                                                Radius.circular(
                                                                    14),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    14))
                                                        : const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    14),
                                                            topRight:
                                                                Radius.circular(
                                                                    14),
                                                            bottomRight:
                                                                Radius.circular(14)),
                                                    color: (currentMssg
                                                                .sender ==
                                                            widget
                                                                .userModel.uid)
                                                        ? Colors.blue
                                                            .withOpacity(0.4)
                                                        : Colors.blue
                                                            .withOpacity(0.7),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        (currentMssg.sender ==
                                                                widget.userModel
                                                                    .uid)
                                                            ? CrossAxisAlignment
                                                                .start
                                                            : CrossAxisAlignment
                                                                .end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 4),
                                                        child: Text(
                                                          currentMssg.text
                                                              .toString(),
                                                        ),
                                                      ),
                                                      Text(
                                                        timeago
                                                            .format(currentMssg
                                                                    .createdon ??
                                                                DateTime.now())
                                                            .replaceAll(
                                                                "minutes", "m")
                                                            .replaceAll(
                                                                "hours", "hr")
                                                            .replaceAll(
                                                                "days", "d"),
                                                        style: const TextStyle(
                                                            fontSize: 9,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              (currentMssg.sender ==
                                                      widget.userModel.uid)
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                  minHeight: 0,
                                                  maxWidth: size.width * 0.6),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: (currentMssg
                                                            .sender ==
                                                        widget.userModel.uid)
                                                    ? const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(14),
                                                        topRight:
                                                            Radius.circular(14),
                                                        bottomLeft:
                                                            Radius.circular(14))
                                                    : const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(14),
                                                        topRight:
                                                            Radius.circular(14),
                                                        bottomRight:
                                                            Radius.circular(
                                                                14)),
                                                color: (currentMssg.sender ==
                                                        widget.userModel.uid)
                                                    ? Colors.blue
                                                        .withOpacity(0.4)
                                                    : Colors.blue
                                                        .withOpacity(0.7),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: (currentMssg
                                                            .sender ==
                                                        widget.userModel.uid)
                                                    ? CrossAxisAlignment.start
                                                    : CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text(
                                                      currentMssg.text
                                                          .toString(),
                                                    ),
                                                  ),
                                                  Text(
                                                    timeago
                                                        .format(currentMssg
                                                                .createdon ??
                                                            DateTime.now())
                                                        .replaceAll(
                                                            "minutes", "m")
                                                        .replaceAll(
                                                            "minute", "m")
                                                        .replaceAll(
                                                            "hours", "hr")
                                                        .replaceAll(
                                                            "days", "d"),
                                                    style: const TextStyle(
                                                        fontSize: 9,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                },
                              );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong :("),
                        );
                      } else {
                        return const Center(
                          child: Text("You can disccuss the meet here :)"),
                        );
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
              )),
              widget.chatRoomModel.chatClosed ?? false
                  ? Container()
                  : Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "show:",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => CustomBottomSheet(
                                      height: size.height,
                                      childern: [
                                        Container(
                                          height: 0.5 * size.height,
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(widget
                                                      .targetUser.idCard ??
                                                  "https://firebasestorage.googleapis.com/v0/b/get-it-8a8a7.appspot.com/o/profilepictures%2FpraposalHome.png?alt=media&token=6ea273da-f64b-4c30-b6ef-7770d8ac6b82"),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(21, 4, 21, 4),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 206, 228, 246),
                                    border: Border.all(
                                        color: Colors.lightBlueAccent),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "ID Card",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7)),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => CustomBottomSheet(
                                      height: size.height * 0.4,
                                      childern: [
                                        Column(
                                          children: [
                                            Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 11),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            21),
                                                    border: Border.all()),
                                                child: RequestTile(
                                                  tileLocation: "chat",
                                                  requestedon: DateTime.now(),
                                                  loggedUserModel:
                                                      widget.userModel,
                                                  firebaseUser:
                                                      widget.firebaseUser,
                                                  note:
                                                      widget.requestModel?.note,
                                                  one: widget.requestModel?.one,
                                                  oneQuantity: widget
                                                      .requestModel
                                                      ?.oneQuantity,
                                                  two: widget.requestModel?.two,
                                                  twoQuantity: widget
                                                      .requestModel
                                                      ?.twoQuantity,
                                                  three: widget
                                                      .requestModel?.three,
                                                  threeQuantity: widget
                                                      .requestModel
                                                      ?.threeQuantity,
                                                  getitBy: widget
                                                      .requestModel?.getby,
                                                  price: widget
                                                      .requestModel?.price,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(21, 4, 21, 4),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 206, 228, 246),
                                    border: Border.all(
                                        color: Colors.lightBlueAccent),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Request",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7)),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showConfirmationDialog(
                                      context: context,
                                      message:
                                          "Are you sure, close the chat?\nYou can reopen it by accepting the help from the request",
                                      onPress: () {
                                        closeChat();
                                        Navigator.pop(context);
                                        setState(() {});
                                      });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(21, 4, 21, 4),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 237, 247, 255),
                                    border: Border.all(
                                        color: Colors.lightBlueAccent
                                            .withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "close chat",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.4)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 11, right: 11, bottom: 11),
                                child: Material(
                                  elevation: 10,
                                  shadowColor: Colors.black.withOpacity(0.5),
                                  child: TextField(
                                    controller: messageController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: "Message",
                                      hintStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10.0, 10.0, 20.0, 10.0),
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.6),
                                            width: 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 11, 11),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(11)),
                                child: IconButton(
                                    onPressed: () {
                                      sendmssg();
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
