import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/main.dart';
import 'package:get_it/models/chatRoomModel.dart';
import 'package:get_it/models/messageModel.dart';
import 'package:get_it/models/userModel.dart';

class FirestoreChatServices {
  static Future<void> sendMssg(
      String mssg,
      UserModel userModel,
      ChatRoomModel chatRoomModel,
      TextEditingController messageController) async {
    if (mssg != "") {
      MessageModel newMssg = MessageModel(
        mssgId: uuid.v1(),
        sender: userModel.uid,
        createdon: DateTime.now(),
        text: mssg,
        seen: false,
      );
      FirebaseFirestore.instance
          .collection("College")
          .doc(userModel.college)
          .collection("chatrooms")
          .doc(chatRoomModel.chatroomid)
          .collection("messages")
          .doc(newMssg.mssgId)
          .set(newMssg.toMap());
      messageController.clear();
      FirebaseFirestore.instance
          .collection("College")
          .doc(userModel.college)
          .collection("chatrooms")
          .doc(chatRoomModel.chatroomid)
          .update({"lastMessage": mssg, "createdon": DateTime.now()});
    }
  }

  static Future<void> closeChat(
      UserModel userModel, ChatRoomModel chatRoomModel) async {
    FirebaseFirestore.instance
        .collection("College")
        .doc(userModel.college)
        .collection("chatrooms")
        .doc(chatRoomModel.chatroomid)
        .update({"chatClosed": true});
  }

  static Future<ChatRoomModel?> getChatRoomModel(
      UserModel targetUser, UserModel userModel, String requestid) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("College")
        .doc(userModel.college)
        .collection("chatrooms")
        .where("participants.${userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // fetch
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatroom;

      FirebaseFirestore.instance
          .collection("College")
          .doc(userModel.college)
          .collection("chatrooms")
          .doc(chatRoom.chatroomid)
          .update({"chatClosed": false});
    } else {
      // create
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        requestid: requestid,
        chatClosed: false,
        createdon: DateTime.now(),
        participants: {
          userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );
      await FirebaseFirestore.instance
          .collection("College")
          .doc(userModel.college)
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());
      chatRoom = newChatroom;
    }
    return chatRoom;
  }
}
