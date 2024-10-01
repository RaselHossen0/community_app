// lib/auth/ui/AuthChecker.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/ui/Home.dart';
import '../provider/AuthProvider.dart';
import 'SignUpScreen.dart';

class AuthChecker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    if (user != null) {
      return Home();
    } else {
      return SignUpScreen();
    }
  }
}
