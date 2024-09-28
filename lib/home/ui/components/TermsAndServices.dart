import 'package:flutter/material.dart';

class TermsAndServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Terms & Services',
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
                'These Terms of Service ("Terms") govern your use of [App Name], an AI-powered application designed to assist you in scheduling AI-based tasks based on your available time, as analyzed from your calendar. By accessing or using [App Name], you agree to be bound by these Terms. If you do not agree to these Terms, please do not use [App Name].'),
            _buildSection('2. Services',
                '[App Name] provides a platform that allows users to:',
                bulletPoints: [
                  'Analyze their calendar data to identify available time slots.',
                  'Schedule AI-based tasks during those available time slots.',
                  'Receive notifications about upcoming scheduled tasks.'
                ]),
            _buildSection('3. User Data', '',
                bulletPoints: [
                  'Calendar Access: You grant [App Name] permission to access and analyze your calendar data to determine your availability.',
                  'Data Security: [App Name] is committed to protecting your data privacy. We will implement reasonable security measures to safeguard your information.',
                  'Data Usage: Your data will be used solely for the purpose of providing [App Name] services. We will not share your personal information with third parties without your consent, except as required by law or to provide the services.'
                ]),
            _buildSection('4. Intellectual Property',
                '[App Name] and its content, including but not limited to the software, design, and logos, are the property of [Your Company] or its licensors and are protected by intellectual property laws. You may not reproduce, modify, distribute, or otherwise exploit any part of [App Name] without our prior written consent.'),
            _buildSection('5. Disclaimer',
                '[App Name] is provided on an "as is" basis without warranties of any kind, either express or implied. [Your Company] does not guarantee the accuracy, completeness, or reliability of the information provided through [App Name]. You use [App Name] at your own risk.'),
            _buildSection('6. Limitation of Liability',
                '[Your Company] shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with your use of [App Name], even if [Your Company] has been advised of the possibility of such damages.'),
            _buildSection('7. Termination',
                '[Your Company] may terminate your access to [App Name] at any time, without cause and without notice.'),
            _buildSection('8. Governing Law',
                'These Terms shall be governed by and construed in accordance with the laws of [Jurisdiction].'),
            _buildSection('9. Changes',
                '[Your Company] may update these Terms from time to time. By continuing to use [App Name] after such changes are made, you agree to be bound by the revised Terms.'),
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