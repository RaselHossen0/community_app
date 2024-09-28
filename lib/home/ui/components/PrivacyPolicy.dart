import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('1. Introduction',
                'This Privacy Policy outlines how [Your Company] collects, uses, and protects the personal information of individuals who use our [App Name] application. By using [App Name], you consent to the collection and use of your information as described in this policy.'),
            _buildSection('2. Information We Collect',
                'We may collect the following types of personal information:',
                bulletPoints: [
                  'Personal Information: This includes your name, email address, phone number, and other information you voluntarily provide when using the app.',
                  'Usage Data: We may collect information about how you use the app, such as your IP address, device type, browser type, and the pages you visit.'
                ]),
            _buildSection('3. How We Use Your Information',
                'We may use your information for the following purposes:',
                bulletPoints: [
                  'To provide and improve our services: We use your information to deliver the app\'s features and functionalities.',
                  'To communicate with you: We may use your contact information to send you notifications, updates, and marketing communications.',
                  'To analyze and improve the app: We may use your usage data to analyze trends, identify usage patterns, and improve the app\'s performance.'
                ]),
            _buildSection('4. Sharing Your Information',
                'We may share your information with:',
                bulletPoints: [
                  'Third-party service providers: We may engage third-party service providers to help us deliver our services. These providers may have access to your information to perform their functions on our behalf.',
                  'Legal authorities: We may disclose your information to comply with legal requirements, such as subpoenas or court orders.'
                ]),
            _buildSection('5. Data Security',
                'We implement reasonable security measures to protect your personal information from unauthorized access, disclosure, alteration, or destruction. However, no method of transmission over the internet or electronic storage is completely secure.'),
            _buildSection('6. Your Rights',
                'You may have certain rights regarding your personal information, including the right to:',
                bulletPoints: [
                  'Access your personal information',
                  'Rectify inaccurate information',
                  'Erase your personal information',
                  'Object to the processing of your personal information',
                  'Restrict the processing of your personal information',
                  'Data portability'
                ]),
            Text('To exercise these rights, please contact us using the information provided below.',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 16),
            _buildSection('7. Changes to This Policy',
                'We may update this Privacy Policy from time to time. Any changes will be posted on this page.'),
            _buildSection('8. Contact Us',
                'If you have any questions about this Privacy Policy or our practices, please contact us at:'),
            Text('[Your Company Name]', style: TextStyle(color: Colors.white, fontSize: 16)),
            Text('[Your Contact Information]', style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 16),
            Text('Please note: This is a basic template. You may need to add or modify terms based on your specific requirements and local laws. It\'s recommended to consult with an attorney to ensure that your Privacy Policy is legally sound and compliant.',
                style: TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, {List<String>? bulletPoints}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        if (bulletPoints != null) ...[
          SizedBox(height: 8),
          ...bulletPoints.map((point) => Padding(
            padding: EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: Colors.white, fontSize: 16)),
                Expanded(
                  child: Text(point, style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          )),
        ],
        SizedBox(height: 16),
      ],
    );
  }
}