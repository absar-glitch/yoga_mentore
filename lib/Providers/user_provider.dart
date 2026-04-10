import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = 'Absar';
  String _email = 'absar@example.com';
  String _profileImage = 'assets/images/profile.jpg';
  bool _isDarkMode = false;

  String get name => _name;
  String get email => _email;
  String get profileImage => _profileImage;
  bool get isDarkMode => _isDarkMode;

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void updateProfileImage(String newPath) {
    _profileImage = newPath;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void updateUserDetails(String newName, String newEmail) {
    _name = newName;
    _email = newEmail;
    notifyListeners();
  }
}
