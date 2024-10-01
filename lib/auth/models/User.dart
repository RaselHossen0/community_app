// lib/auth/models/User.dart
import 'dart:convert';

class User {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final String role;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.role,
  });

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? role,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
    );
  }

  String toJson() {
    return json.encode({
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'role': role,
    });
  }

  static User fromJson(String source) {
    final data = json.decode(source);
    return User(
      uid: data['uid'],
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      role: data['role'] ?? 'user',
    );
  }

  static User fromDocument(Map<String, dynamic> data) {
    return User(
      uid: data['uid'],
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      role: data['role'] ?? 'user',
    );
  }

  static Map<String, dynamic> toMap(User user) {
    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'role': user.role,
    };
  }
}
