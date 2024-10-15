// lib/auth/ui/LoginScreen.dart
import 'package:community_app/auth/data/UserService.dart';
import 'package:community_app/home/ui/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/UserState.dart';
import 'SignUpScreen.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef watch) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Figtree',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      height: 28.8 / 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildLabeledTextField(
                      'Email', 'Enter your email here', emailController),
                  SizedBox(height: 16),
                  _buildLabeledTextField(
                      'Password', 'Enter password', passwordController,
                      isPassword: true),
                  SizedBox(height: 24),
                  _buildLoginButton(context, watch),
                  SizedBox(height: 16),
                  _buildSignUpRow(context),
                  SizedBox(height: 16),
                  _buildSocialSignInButton('Sign in with Google',
                      'https://www.google.com/favicon.ico'),
                  SizedBox(height: 16),
                  _buildSocialSignInButton('Sign in with Apple', null,
                      isApple: true),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(
      String label, String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Figtree',
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 24 / 14,
          ),
        ),
        SizedBox(height: 8),
        _buildTextField(hintText, controller, isPassword: isPassword),
      ],
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return SizedBox(
      width: 345,
      height: 56,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          fillColor: Color(0xFF181818),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Color(0xFF282828),
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Color(0xFF282828),
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFC1E0FF),
            Color(0xFF92C9FF),
          ],
          stops: [0.0863, 0.9908],
        ),
      ),
      child: ElevatedButton(
        child: Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () async {
          await _login(context, ref);
        },
      ),
    );
  }

  Future<void> _login(BuildContext context, WidgetRef ref) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final UserService userService = UserService();
    final userNotifier = ref.read(userProvider.notifier);

    EasyLoading.show(status: 'Logging in...');

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = await userService.getUser(userCredential.user!.uid);

      userNotifier.setUser(user!);
      EasyLoading.showSuccess('Login successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      print('Failed to login: ${e.message}');
      EasyLoading.showError(e.message ?? 'Login failed');
    } on Exception catch (e) {
      print('Failed to login: $e');
      EasyLoading.showError('Login failed');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Widget _buildSignUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
          child: Text('Sign up', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSocialSignInButton(String text, String? iconUrl,
      {bool isApple = false}) {
    return OutlinedButton.icon(
      icon: isApple
          ? Icon(Icons.apple, color: Colors.white)
          : Image.network(iconUrl!, height: 24),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.grey),
      ),
      onPressed: () {},
    );
  }
}
