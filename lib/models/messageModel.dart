class MessageModel {
  String? sender;
  String? mssgId;
  String? text;
  bool? seen;
  DateTime? createdon;

  MessageModel({this.sender, this.text, this.seen, this.createdon});

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    text = map["text"];
    mssgId = map["mssgId"];
    seen = map["seen"];
    createdon = map["createdon"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "mssgId": mssgId,
      "seen": seen,
      "createdon": createdon,
    };
  }
}
