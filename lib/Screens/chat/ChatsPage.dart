import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/chat/chatroom.dart';
import 'package:get_it/models/chatRoomModel.dart';
import 'package:get_it/models/firebaseHelper.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';

class ChatPage extends StatefulWidget {
  final UserModel loggedinUserModel;
  final User firebaseUser;

  const ChatPage(
      {super.key, required this.loggedinUserModel, required this.firebaseUser});

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
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("College")
                .doc(widget.loggedinUserModel.college)
                .collection("chatrooms")
                .where("participants.${widget.loggedinUserModel.uid}",
                    isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                  return dataSnapshot.docs.length == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(),
                            Container(
                              height: 250,
                              width: 250,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/Images/auth.jpg"),
                                ),
                              ),
                            ),
                            const Text(
                                "You have not discussed anyy request yet"),
                            const Text("XD")
                          ],
                        )
                      : ListView.builder(
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            Map<String, dynamic> participants =
                                chatRoomModel.participants!;
                            List<String> participantsKeys =
                                participants.keys.toList();
                            participantsKeys
                                .remove(widget.loggedinUserModel.uid);

                            return FutureBuilder(
                              future: FirebaseHelper.getUserModelById(
                                  participantsKeys[0],
                                  widget.loggedinUserModel.college),
                              builder: (context, userData) {
                                return FutureBuilder(
                                    future: FirebaseHelper.getReqModelById(
                                        chatRoomModel.requestid ?? ""),
                                    builder: (context, requestData) {
                                      if (requestData.connectionState ==
                                          ConnectionState.done) {
                                        if (requestData.data != null) {
                                          RequestModel requestModel =
                                              requestData.data as RequestModel;
                                          if (userData.connectionState ==
                                              ConnectionState.done) {
                                            if (userData.data != null) {
                                              UserModel targetUser =
                                                  userData.data as UserModel;
                                              return ListTile(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return ChatScreen(
                                                          accessedFrom: "inbox",
                                                          requestModel:
                                                              requestModel,
                                                          targetUser:
                                                              targetUser,
                                                          userModel: widget
                                                              .loggedinUserModel,
                                                          firebaseUser: widget
                                                              .firebaseUser,
                                                          chatRoomModel:
                                                              chatRoomModel,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                leading: const CircleAvatar(
                                                  backgroundColor:
                                                      Colors.yellow,
                                                ),
                                                title: Text(targetUser.fullname
                                                    .toString()),
                                                subtitle: Text(chatRoomModel
                                                    .lastMessage
                                                    .toString()),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          } else {
                                            return Container();
                                          }
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return Container();
                                      }
                                    });
                              },
                            );
                          },
                        );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Text("Nothing to show here");
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}
