import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<bool> saveCollege(String college) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool result = await sharedPreferences.setString("college", college);
    return result;
  }

  static Future<String?> getCollege() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? currentcollege = sharedPreferences.getString("college");
    return currentcollege;
  }
}
