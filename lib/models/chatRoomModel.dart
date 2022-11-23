class ChatRoomModel {
  String? chatroomid;
  bool? chatClosed;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? createdon;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.chatClosed,
      this.lastMessage,
      this.createdon});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    chatClosed = map["chatClosed"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
    createdon = map["createdon"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "chatClosed": chatClosed,
      "participants": participants,
      "lastMessage": lastMessage,
      "createdon": createdon,
    };
  }
}
