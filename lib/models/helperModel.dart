class RequestModel {
  String? helpBy;
  DateTime? helpOn;
  String? note;

  RequestModel({
    this.helpBy,
    this.helpOn,
    this.note,
  });

  RequestModel.fromMap(Map<String, dynamic> map) {
    helpBy = map["helpby"];
    helpOn = map["helpOn"];
    note = map["note"];
  }

  Map<String, dynamic> toMap() {
    return {
      "helpby": helpBy,
      "helpOn": helpOn,
      "note": note,
    };
  }
}
