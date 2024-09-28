import 'package:flutter/material.dart';
import '../../home/ui/UserProfile.dart'; // Ensure this import is correct and UserProfile is a valid widget.

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black, // Dark background to match your design
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
                      fontFamily: 'Figtree', // Use the variable Figtree font
                      fontWeight: FontWeight.w700, // Bold weight (700)
                      fontSize: 24, // Font size 24px
                      height: 28.8 / 24, // Line height 28.8px
                      color: Colors.white, // White color for contrast
                    ),
                  ),
                  SizedBox(height: 40),

                  _buildLabeledTextField('Email', 'Enter your email here'),
                  SizedBox(height: 16),
                  _buildLabeledTextField('Password', 'Enter password', isPassword: true),
                  SizedBox(height: 16),
                  _buildLabeledTextField('Confirm Password', 'Repeat your password', isPassword: true),
                  SizedBox(height: 24),

                  _buildSignUpButton(),
                  SizedBox(height: 16),

                  _buildSignInRow(context), // Pass the context to the sign-in row

                  SizedBox(height: 16),

                  _buildSocialSignInButton('Sign in with Google', 'https://www.google.com/favicon.ico'),
                  SizedBox(height: 16),
                  _buildSocialSignInButton('Sign in with Apple', null, isApple: true),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to build labeled text fields
  Widget _buildLabeledTextField(String label, String hintText, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Text
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Figtree', // Use the Figtree font
            color: Colors.white, // Label text color
            fontSize: 14, // Font size set to 14px
            fontWeight: FontWeight.w600, // Semi-bold label
            height: 24 / 14, // Line height based on font size (24px)
          ),
        ),
        SizedBox(height: 8), // Spacing between label and text field
        // Text Field
        _buildTextField(hintText, isPassword: isPassword),
      ],
    );
  }

  // Function to build the text fields
  Widget _buildTextField(String hintText, {bool isPassword = false}) {
    return SizedBox(
      width: 345, // Fixed width
      height: 56, // Fixed height
      child: TextField(
        obscureText: isPassword,
        style: TextStyle(color: Colors.white), // White input text
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey), // Grey hint text
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Padding
          fillColor: Color(0xFF181818), // Background color set to #181818
          filled: true, // Ensure background is filled
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), // All corners rounded with 16px
            borderSide: BorderSide(
              color: Color(0xFF282828), // Border color set to #282828
              width: 1, // Border thickness of 1px
              style: BorderStyle.solid, // Solid border style
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), // All corners rounded with 16px
            borderSide: BorderSide(
              color: Color(0xFF282828), // Border color set to #282828
              width: 1,
              style: BorderStyle.solid, // Solid border style
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), // All corners rounded with 16px
            borderSide: BorderSide(
              color: Colors.blue, // Blue border when focused
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }

  // Function to build the sign-up button
  Widget _buildSignUpButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFC1E0FF),  // Gradient start color
            Color(0xFF92C9FF),  // Gradient end color
          ],
          stops: [0.0863, 0.9908], // Stops for the gradient
        ),
      ),
      child: ElevatedButton(
        child: Text(
          'Sign up',
          style: TextStyle(color: Colors.black), // Black text color for button
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Transparent to show gradient
          shadowColor: Colors.transparent, // No shadow
          padding: EdgeInsets.symmetric(vertical: 16), // Padding inside the button
        ),
        onPressed: () {},
      ),
    );
  }

  // Function to build the sign-in row
// Function to build the sign-in row
  Widget _buildSignInRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: Colors.white), // White text color
        ),
        TextButton(
          child: Text('Sign in', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            // Navigate to the UserProfile screen when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfile()), // Use push instead of pushReplacement
            );
          },
        ),
      ],
    );
  }


  // Function to build social sign-in buttons
  Widget _buildSocialSignInButton(String text, String? iconUrl, {bool isApple = false}) {
    return OutlinedButton.icon(
      icon: isApple
          ? Icon(Icons.apple, color: Colors.white) // Apple icon for sign-in with Apple
          : Image.network(iconUrl!, height: 24), // Network image for other icons
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12), // Padding inside the button
        side: BorderSide(color: Colors.grey), // Grey border color
      ),
      onPressed: () {},
    );
  }
}
