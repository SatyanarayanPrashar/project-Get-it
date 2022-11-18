class HelperModel {
  String? helpBy;
  String? helperUid;
  String? helpUid;
  String? helpOn;
  String? note;
  DateTime? requestedOn;

  HelperModel({
    this.helpBy,
    this.helperUid,
    this.helpUid,
    this.helpOn,
    this.note,
    this.requestedOn,
  });

  HelperModel.fromMap(Map<String, dynamic> map) {
    helpBy = map["helpby"];
    helperUid = map["helperUid"];
    helpUid = map["helpUid"];
    helpOn = map["helpOn"];
    note = map["note"];
    requestedOn = map["requestedOn"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "helpby": helpBy,
      "helperUid": helperUid,
      "helpUid": helpUid,
      "helpOn": helpOn,
      "note": note,
      "requestedOn": requestedOn,
    };
  }
}
