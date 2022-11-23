class MessageModel {
  String? mssgId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;

  MessageModel(
      {this.mssgId, this.sender, this.text, this.seen, this.createdon});

  MessageModel.fromMap(Map<String, dynamic> map) {
    mssgId = map["mssgId"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "mssgId": mssgId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon,
    };
  }
}
