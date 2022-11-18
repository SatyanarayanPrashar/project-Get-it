class CommentModel {
  String? commentBy;
  String? helperId;
  DateTime? commentedOn;
  String? note;

  CommentModel({
    this.commentBy,
    this.commentedOn,
    this.helperId,
    this.note,
  });

  CommentModel.fromMap(Map<String, dynamic> map) {
    commentBy = map["commentby"];
    commentedOn = map["commentedOn"];
    helperId = map["helperId"];
    note = map["note"];
  }

  Map<String, dynamic> toMap() {
    return {
      "commentby": commentBy,
      "helperId": helperId,
      "commentedOn": commentedOn,
      "note": note,
    };
  }
}
