import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final String? Function(String?)? validator;

  CustomTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: isDarkMode
                ? BorderSide.none
                : BorderSide(color: Theme.of(context).primaryColor),
          ),
          fillColor: isDarkMode ? Theme.of(context).primaryColor : null,
          filled: isDarkMode,
        ),
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
