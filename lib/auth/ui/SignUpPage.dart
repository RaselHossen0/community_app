import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ThemeNotifier.dart';
import '../../core/widgets/CustomButton.dart';
import '../../core/widgets/CustomTextField.dart';

class SignUpPage extends ConsumerStatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // Perform sign-up logic
    }
  }

  void _loginWithGoogle() {
    // Perform Google login logic
  }

  void _loginWithApple() {
    // Perform Apple login logic
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Sign Up'),
        actions: [
          Switch(
            value: themeNotifier.isDarkMode,
            onChanged: (value) {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomTextField(
                controller: _nameController,
                labelText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                ),
                onPressed: _signUp,
                child: Text('Sign Up'),
              ),
              SizedBox(height: 20),
              CustomButton(
                onPressed: _loginWithGoogle,
                icon: Icon(Icons.earbuds, color: Colors.white),
                label: 'Login with Google',
              ),
              SizedBox(height: 20),
              CustomButton(
                onPressed: _loginWithApple,
                icon: Icon(Icons.apple, color: Colors.white),
                label: 'Login with Apple',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
