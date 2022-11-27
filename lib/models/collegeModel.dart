class CollegeModel {
  String name = "";
  int? userCount;

  CollegeModel({
    required this.name,
    this.userCount,
  });

  CollegeModel.fromMap(Map<String, dynamic> map) {
    name = map["name"];
    userCount = map["userCount"];
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "userCount": userCount,
    };
  }
}
