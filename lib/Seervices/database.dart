import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/models/userModel.dart';

class DataBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? collegevalue;
  String? uid;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore
          .collection("College")
          .doc(collegevalue)
          .collection("users")
          .doc(uid)
          .set(user.toMap())
          .then((value) {
        print("created a new profile");
        FirebaseFirestore.instance
            .collection("College")
            .doc(collegevalue)
            .update({"userCount": FieldValue.increment(1)});
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      Map<String, >
      DocumentSnapshot doc = await _firestore
          .collection("College")
          .doc(collegevalue)
          .collection("users")
          .doc(uid)
          .get();
      return UserModel.fromMap(doc);
    } catch (e) {
      rethrow;
    }
  }
}
