class CommentModel {
  String? commentId;
  String? commentBy;
  String? helperId;
  String? timing;
  DateTime? commentedOn;
  String? note;

  CommentModel({
    this.commentId,
    this.commentBy,
    this.commentedOn,
    this.timing,
    this.helperId,
    this.note,
  });

  CommentModel.fromMap(Map<String, dynamic> map) {
    commentId = map["commentId"];
    commentBy = map["commentby"];
    commentedOn = map["commentedOn"].toDate();
    timing = map["timing"];
    helperId = map["helperId"];
    note = map["note"];
  }

  Map<String, dynamic> toMap() {
    return {
      "commentId": commentId,
      "commentby": commentBy,
      "helperId": helperId,
      "timing": timing,
      "commentedOn": commentedOn,
      "note": note,
    };
  }
}
