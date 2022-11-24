import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/models/localStorage.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(
      String uid, String? college) async {
    UserModel? userModel;
    String? currentCollege = await LocalStorage.getCollege();
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("College")
        .doc(college ?? currentCollege)
        .collection("users")
        .doc(uid)
        .get();
    if (docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }
    return userModel;
  }

  static Future<RequestModel?> getReqModelById(String requestid) async {
    RequestModel? requestModel;
    String? currentCollege = await LocalStorage.getCollege();
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("College")
        .doc(currentCollege)
        .collection("requests")
        .doc(requestid)
        .get();
    if (docSnap.data() != null) {
      requestModel =
          RequestModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }
    return requestModel;
  }
}
