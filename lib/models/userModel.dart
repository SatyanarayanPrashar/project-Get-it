class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? college;
  String? profilepic;
  String? idCard;
  String? batch;
  String? branch;
  bool? profileComplete;

  UserModel(
      {this.uid,
      this.fullname,
      this.email,
      this.college,
      this.profilepic,
      this.idCard,
      this.batch,
      this.branch,
      this.profileComplete});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    college = map["college"];
    profilepic = map["profilepic"];
    idCard = map["idCard"];
    batch = map["batch"];
    branch = map["branch"];
    profileComplete = map["profileComplete"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "college": college,
      "profilepic": profilepic,
      "idCard": idCard,
      "branch": branch,
      "batch": batch,
      "profileComplete": profileComplete,
    };
  }
}
