class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? college;
  String? idCard;
  String? batch;
  String? branch;

  UserModel(
      {this.uid,
      this.fullname,
      this.email,
      this.college,
      this.idCard,
      this.batch,
      this.branch});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    college = map["college"];
    idCard = map["idcard"];
    batch = map["batch"];
    branch = map["branch"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "college": college,
      "idCard": idCard,
      "branch": branch,
      "batch": batch,
    };
  }
}
