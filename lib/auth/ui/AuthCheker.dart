// lib/auth/ui/AuthChecker.dart
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/ui/Home.dart';
import '../provider/UserState.dart';
import 'SignUpScreen.dart';

class AuthChecker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the authentication state directly from Firebase
    final firebaseUser = auth.FirebaseAuth.instance.currentUser;

    // If no user is signed in, go directly to SignUpScreen
    if (firebaseUser == null) {
      return SignUpScreen();
    }

    // Watch the userProvider, which loads user data from Firestore
    final userAsync = ref.watch(userProvider);

    // Show loading indicator while Firestore user data is being loaded
    return userAsync == null
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Loading indicator
            ),
          )
        : Home(); // If user data exists, show Home screen
  }
}
