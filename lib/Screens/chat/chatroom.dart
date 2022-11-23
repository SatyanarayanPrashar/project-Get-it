import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/main.dart';
import 'package:get_it/models/chatRoomModel.dart';
import 'package:get_it/models/messageModel.dart';
import 'package:get_it/models/userModel.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.targetUser,
    required this.chatRoomModel,
    required this.userModel,
    required this.firebaseUser,
  });
  final UserModel targetUser;
  final UserModel userModel;
  final User firebaseUser;
  final ChatRoomModel chatRoomModel;

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
                    // backgroundColor: NetworkImage(widget.targetUser.profilepic.toString() ),
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: size.width * 0.4,
                    child: Text(
                      widget.targetUser.fullname ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
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
                        return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMssg = MessageModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);

                            return Row(
                              mainAxisAlignment:
                                  (currentMssg.sender == widget.userModel.uid)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      minHeight: 0, maxWidth: size.width * 0.6),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: (currentMssg.sender ==
                                            widget.userModel.uid)
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(14),
                                            topRight: Radius.circular(14),
                                            bottomLeft: Radius.circular(14))
                                        : const BorderRadius.only(
                                            topLeft: Radius.circular(14),
                                            topRight: Radius.circular(14),
                                            bottomRight: Radius.circular(14)),
                                    color: (currentMssg.sender ==
                                            widget.userModel.uid)
                                        ? Colors.blue.withOpacity(0.4)
                                        : Colors.blue.withOpacity(0.7),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: (currentMssg.sender ==
                                            widget.userModel.uid)
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          currentMssg.text.toString(),
                                        ),
                                      ),
                                      Text(
                                        timeago
                                            .format(currentMssg.createdon ??
                                                DateTime.now())
                                            .replaceAll("minutes", "m")
                                            .replaceAll("hours", "hr")
                                            .replaceAll("days", "d"),
                                        style: const TextStyle(
                                            fontSize: 9, color: Colors.white),
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )),
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
                              borderRadius: BorderRadius.circular(5.0),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
