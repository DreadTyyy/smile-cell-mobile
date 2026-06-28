import 'package:flutter/material.dart';
import 'package:smile_cell/data/local/session_helpers.dart';
import 'package:smile_cell/data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  void initUser() async {
    _userProfile = await SessionHelpers().getUserProfile();
    notifyListeners();
  }

  void setUserProfile(UserProfile user) async {
    _userProfile = user;
    await SessionHelpers().saveUserProfile(user);
    notifyListeners();
  }

  void removeUserProfile() async {
    _userProfile = null;
    await SessionHelpers().removeUserProfile();
    notifyListeners();
  }
}