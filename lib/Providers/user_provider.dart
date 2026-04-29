import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';

class UserProvider with ChangeNotifier {
  int? _userId;
  String _name = '';
  String _email = '';
  String _profileImage = 'assets/images/profile.jpg';
  bool _isDarkMode = false;
  bool _isAdmin = false;
  bool _isLoggedIn = false;

  int? get userId => _userId;
  String get name => _name;
  String get email => _email;
  String get profileImage => _profileImage;
  bool get isDarkMode => _isDarkMode;
  bool get isAdmin => _isAdmin;
  bool get isLoggedIn => _isLoggedIn;

  /// Called on app start — restores session from SharedPreferences.
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getInt('logged_in_user_id');
    if (savedId == null) return false;

    final user = await DBHelper.getUserById(savedId);
    if (user == null) {
      await prefs.remove('logged_in_user_id');
      return false;
    }
    _loadUser(user);
    return true;
  }

  /// Load user data into provider and persist session.
  Future<void> loginUser(Map<String, dynamic> user) async {
    _loadUser(user);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('logged_in_user_id', _userId!);
  }

  void _loadUser(Map<String, dynamic> user) {
    _userId = user['id'] as int;
    _name = user['name'] as String;
    _email = user['email'] as String;
    _profileImage =
        (user['profile_image'] as String?) ?? 'assets/images/profile.jpg';
    _isAdmin = (user['is_admin'] as int?) == 1;
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Clear session — used on logout.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user_id');
    _userId = null;
    _name = '';
    _email = '';
    _profileImage = 'assets/images/profile.jpg';
    _isAdmin = false;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> updateName(String newName) async {
    _name = newName;
    if (_userId != null) await DBHelper.updateUser(_userId!, {'name': newName});
    notifyListeners();
  }

  Future<void> updateEmail(String newEmail) async {
    _email = newEmail;
    if (_userId != null) {
      await DBHelper.updateUser(_userId!, {'email': newEmail});
    }
    notifyListeners();
  }

  Future<void> updateUserDetails(String newName, String newEmail) async {
    _name = newName;
    _email = newEmail;
    if (_userId != null) {
      await DBHelper.updateUser(_userId!, {
        'name': newName,
        'email': newEmail,
      });
    }
    notifyListeners();
  }

  Future<void> updateProfileImage(String newPath) async {
    _profileImage = newPath;
    if (_userId != null) {
      await DBHelper.updateUser(_userId!, {'profile_image': newPath});
    }
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
