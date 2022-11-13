class RequestModel {
  String? commentBy;
  DateTime? commentedOn;
  String? note;

  RequestModel({
    this.commentBy,
    this.commentedOn,
    this.note,
  });

  RequestModel.fromMap(Map<String, dynamic> map) {
    commentBy = map["commentby"];
    commentedOn = map["commentedOn"];
    note = map["note"];
  }

  Map<String, dynamic> toMap() {
    return {
      "commentby": commentBy,
      "commentedOn": commentedOn,
      "note": note,
    };
  }
}
