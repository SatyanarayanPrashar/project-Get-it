class RequestModel {
  String? requestedBy;
  DateTime? requestedOn;
  String? note;
  List<String>? items;
  String? getby;
  String? price;

  RequestModel(
      {this.requestedBy,
      this.requestedOn,
      this.note,
      this.items,
      this.getby,
      this.price});

  RequestModel.fromMap(Map<String, dynamic> map) {
    requestedBy = map["requestedby"];
    requestedOn = map["requestedOn"];
    note = map["note"];
    items = map["items"];
    getby = map["getby"];
    price = map["price"];
  }

  Map<String, dynamic> toMap() {
    return {
      "requestedby": requestedBy,
      "requestedOn": requestedOn,
      "note": note,
      "items": items,
      "getby": getby,
      "price": price,
    };
  }
}
