import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/chat/chatroom.dart';
import 'package:get_it/models/chatRoomModel.dart';
import 'package:get_it/models/userModel.dart';

class ChatPage extends StatefulWidget {
  final UserModel targetUser;
  final UserModel loggedinUserModel;
  final ChatRoomModel chatroom;
  final User firebaseUser;

  const ChatPage(
      {super.key,
      required this.targetUser,
      required this.loggedinUserModel,
      required this.chatroom,
      required this.firebaseUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Chats",
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: null,
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChatScreen(
                          chatRoomModel: widget.chatroom,
                          firebaseUser: widget.firebaseUser,
                          userModel: widget.loggedinUserModel,
                          targetUser: widget.targetUser,
                        );
                      }),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 155, 231, 157),
                    //   backgroundImage: NetworkImage(
                    //       targetUser.profilepic.toString()),
                  ),
                  title: Text(
                    "Satya",
                    // targetUser.username.toString(),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: true
                      ? Text(
                          "ok",
                          // chatRoomModel.lastMessage.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          "Say hi to your new friend!",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                );
              },
            );
          },
        ));
  }
}
