class ChatRoomModel {
  String? chatroomid;
  bool? chatClosed;
  Map<String, dynamic>? participants;
  String? lastMessage;
  String? requestid;
  DateTime? createdon;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.requestid,
      this.chatClosed,
      this.lastMessage,
      this.createdon});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    requestid = map["requestid"];
    chatClosed = map["chatClosed"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
    createdon = map["createdon"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "chatClosed": chatClosed,
      "requestid": requestid,
      "participants": participants,
      "lastMessage": lastMessage,
      "createdon": createdon,
    };
  }
}
