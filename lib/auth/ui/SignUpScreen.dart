// lib/auth/ui/SignUpScreen.dart
import 'package:community_app/auth/data/UserService.dart';
import 'package:community_app/auth/ui/LoginScreen.dart';
import 'package:community_app/home/ui/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../models/User.dart' as t;

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    'Sign up',
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
                  SizedBox(height: 16),
                  _buildLabeledTextField('Confirm Password',
                      'Repeat your password', confirmPasswordController,
                      isPassword: true),
                  SizedBox(height: 24),
                  _buildSignUpButton(context),
                  SizedBox(height: 16),
                  _buildSignInRow(context),
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

  Widget _buildSignUpButton(BuildContext context) {
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
          'Sign up',
          style: TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () async {
          await _signUp(context);
        },
      ),
    );
  }

  // lib/auth/ui/SignUpScreen.dart

  Future<void> _signUp(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final UserService userService = UserService();

    if (password != confirmPassword) {
      EasyLoading.showError('Passwords do not match');
      return;
    }

    EasyLoading.show(status: 'Signing up...');

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = t.User(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        displayName: userCredential.user!.displayName ?? '',
        photoURL: userCredential.user!.photoURL ?? '',
        role: 'user',
      );

      await userService.addUser(user);
      EasyLoading.showSuccess('Sign up successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      print('Failed to create user: ${e.message}');
      EasyLoading.showError(e.message ?? 'Sign up failed');
    } on Exception catch (e) {
      print('Failed to create user: $e');
      EasyLoading.showError('Sign up failed');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Widget _buildSignInRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
          child: Text('Sign in', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
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
