import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/models/chatRoomModel.dart';
import 'package:get_it/models/userModel.dart';

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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController messageController = TextEditingController();

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                ),
                Flexible(
                  child: SizedBox(
                    width: size.width * 0.4,
                    child: Text(
                      "UserName",
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
                height: size.height,
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
//
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
