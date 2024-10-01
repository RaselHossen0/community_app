// lib/services/UserService.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/User.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new user to Firestore
  Future<void> addUser(User user) async {
    await _firestore.collection('users').doc(user.uid).set(User.toMap(user));
  }

  // Get a user from Firestore by UID
  Future<User?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return User.fromDocument(doc.data()!);
    }
    return null;
  }

  // Update user information in Firestore
  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.uid).update(User.toMap(user));
  }

  //all users
  Future<List<User>>? getAllUsers() async {
    final querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs
        .map((doc) => User.fromDocument(doc.data()))
        .toList();
  }
}
