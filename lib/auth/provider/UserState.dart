// lib/auth/data/UserNotifier.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/User.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null) {
    _loadUserFromFirestore();
  }

  void setUser(User user) async {
    state = user;
    await _saveUserToFirestore(user);
  }

  User? getUser() {
    _loadUserFromFirestore();
    return state;
  }

  void clearUser() async {
    state = null;
  }

  void updateUser(User updatedUser) async {
    state = updatedUser;
    await _saveUserToFirestore(updatedUser);
  }

  Future<void> _saveUserToFirestore(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // assuming the user model has a `uid` field
          .set(
            User.toMap(user),
            SetOptions(merge: true),
          ); // Assuming your User model has a toJson() method
    } catch (e) {
      // Handle errors if needed
      print('Error saving user to Firestore: $e');
    }
  }

  Future<void> _loadUserFromFirestore() async {
    try {
      // Assuming user.uid is known, you might need to pass it via arguments
      final uid = auth.FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final docSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (docSnapshot.exists) {
          state = User.fromDocument(docSnapshot
              .data()!); // Assuming your User model has a fromJson() method
        }
      }
    } catch (e) {
      // Handle errors if needed
      print('Error loading user from Firestore: $e');
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
