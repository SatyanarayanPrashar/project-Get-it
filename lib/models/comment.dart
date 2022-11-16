class CommentModel {
  String? commentBy;
  DateTime? commentedOn;
  String? note;

  CommentModel({
    this.commentBy,
    this.commentedOn,
    this.note,
  });

  CommentModel.fromMap(Map<String, dynamic> map) {
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
