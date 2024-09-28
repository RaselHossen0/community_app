import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Import for SVG support

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);  // Navigate back to the previous screen
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Section 1: Personal Info, Account, Notifications, Newsletter
              _buildSettingsSection(
                context,
                items: [
                  _buildSettingItem('assets/icons/personalInfo.svg', "Personal Information", onTap: () {}),
                  _buildDivider(),
                  _buildSettingItem('assets/icons/AccountDetails.svg', "Account Details", onTap: () {}),
                  _buildDivider(),
                  _buildSwitchSettingItem('assets/icons/Notifications.svg', "Notifications", true),
                  _buildDivider(),
                  _buildSwitchSettingItem('assets/icons/Newsletter.svg', "Newsletter", false),
                ],
              ),
              // Section 2: App Language, Updates
              _buildSettingsSection(
                context,
                items: [
                  _buildSettingItem('assets/icons/AppLanguage.svg', "App Language", onTap: () {}),
                  _buildDivider(),
                  _buildSettingItem('assets/icons/AppUpdates.svg', "App Updates", onTap: () {}),
                ],
              ),
              // Section 3: App Version, Terms of Service, Privacy Policy, Contact Info
              _buildSettingsSection(
                context,
                items: [
                  _buildSettingItem('assets/icons/AppVersion.svg', "App Version", onTap: () {}),
                  _buildDivider(),
                  _buildSettingItem('assets/icons/TermsofService.svg', "Terms of Service", onTap: () {}),
                  _buildDivider(),
                  _buildSettingItem('assets/icons/PrivacyPolicy.svg', "Privacy Policy", onTap: () {}),
                  _buildDivider(),
                  _buildSettingItem('assets/icons/ContactInformation.svg', "Contact Information", onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds each section with a list of items and rounded container
  Widget _buildSettingsSection(BuildContext context, {required List<Widget> items}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E), // Dark gray similar to the image
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: items),
    );
  }

  // Builds a list item with an SVG icon, title, and arrow
  Widget _buildSettingItem(String iconPath, String title, {required VoidCallback onTap}) {
    return ListTile(
      leading: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
          // Greenish-blue icon color
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),  // White text color
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),  // Grey arrow
      onTap: onTap,
    );
  }

  // Builds a list item with an SVG icon, title, and a switch
  Widget _buildSwitchSettingItem(String iconPath, String title, bool value) {
    return ListTile(
      leading: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
         // Greenish-blue icon color
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Switch(
        value: value,
        onChanged: (bool newValue) {},
        activeColor: Color(0xFF00BFA6),  // Custom switch active color (greenish-blue)
        inactiveTrackColor: Colors.grey,  // Grey inactive color
      ),
    );
  }

  // Adds a custom divider between settings items
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Colors.grey[600],  // Greyish divider similar to the design
      indent: 16,
      endIndent: 16,
    );
  }
}
