// lib/auth/ui/AuthChecker.dart
import 'package:community_app/auth/provider/UserState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/ui/Home.dart';
import 'SignUpScreen.dart';

class AuthChecker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Refers to the userProvider which will manage the loading state internally
    final userAsync = ref.watch(userProvider);

    return userAsync == null
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Show a loading indicator
            ),
          )
        : userAsync != null
            ? Home() // If user is authenticated, show Home screen
            : SignUpScreen(); // If user is not authenticated, show Sign-up screen
  }
}
