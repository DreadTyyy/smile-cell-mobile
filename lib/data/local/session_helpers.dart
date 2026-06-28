import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smile_cell/data/models/user_model.dart';

class SessionHelpers {

  static final _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true
    )
  );

  Future<void> saveSessionData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getSessionData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> removeSesssionData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> saveUserProfile(UserProfile user) async {
    await _secureStorage.write(key: "user", value: user.toJson());
  }

  Future<UserProfile?> getUserProfile() async {
    try {
      String? jsonString;

      jsonString = await _secureStorage.read(key: "user");
      if (jsonString != null) {
        return UserProfile.fromJson(jsonString);
      }
      return null;
    } catch (e) {
      // print("Error get data $e");
      return null;
    }
  }

  Future<void> removeUserProfile() async {
    await _secureStorage.delete(key: "user");
  }
}