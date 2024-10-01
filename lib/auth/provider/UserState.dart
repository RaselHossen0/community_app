// lib/auth/data/UserNotifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/User.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null) {
    _loadUserFromPreferences();
  }

  void setUser(User user) async {
    state = user;
    await _saveUserToPreferences(user);
  }

  User? getUser() {
    return state;
  }

  void clearUser() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  void updateUser(User updatedUser) async {
    state = updatedUser;
    await _saveUserToPreferences(updatedUser);
  }

  Future<void> _saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user.toJson());
  }

  Future<void> _loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      state = User.fromJson(userJson);
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
