class RequestModel {
  String? requestid;
  String? requestedBy;
  String? requesterUid;
  String? requesterProfilePic;
  DateTime? requestedOn;
  String? note;
  String? one;
  String? two;
  String? three;
  String? oneQuantity;
  String? twoQuantity;
  String? threeQuantity;
  String? getby;
  String? price;
  String? status;
  bool? personalised;

  RequestModel({
    this.requestid,
    this.requestedBy,
    this.requesterUid,
    this.requesterProfilePic,
    this.requestedOn,
    this.note,
    this.one,
    this.two,
    this.three,
    this.oneQuantity,
    this.twoQuantity,
    this.threeQuantity,
    this.getby,
    this.price,
    this.status,
    this.personalised,
  });

  RequestModel.fromMap(Map<String, dynamic> map) {
    requestid = map["requestid"];
    requestedBy = map["requestedby"];
    requesterUid = map["requestedUid"];
    requesterProfilePic = map["requesterProfilePic"];
    requestedOn = map["requestedOn"].toDate();
    note = map["note"];
    one = map["one"];
    two = map["two"];
    three = map["three"];
    oneQuantity = map["oneQuantity"];
    twoQuantity = map["twoQuantity"];
    threeQuantity = map["threeQuantity"];
    getby = map["getby"];
    price = map["price"];
    status = map["status"];
    personalised = map["personalised"];
  }

  Map<String, dynamic> toMap() {
    return {
      "requestid": requestid,
      "requestedby": requestedBy,
      "requesterProfilePic": requesterProfilePic,
      "requesterUid": requesterUid,
      "requestedOn": requestedOn,
      "note": note,
      "one": one,
      "two": two,
      "three": three,
      "oneQuantity": oneQuantity,
      "twoQuantity": twoQuantity,
      "threeQuantity": threeQuantity,
      "getby": getby,
      "price": price,
      "status": status,
      "personalised": personalised,
    };
  }
}
