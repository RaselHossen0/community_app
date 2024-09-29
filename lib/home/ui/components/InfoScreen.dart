import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Info',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'See Community Members',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Add functionality to see community members
            },
          ),
          Divider(color: Colors.grey[800], height: 1),
          ListTile(
            title: Text(
              'Leave Community',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.logout, color: Colors.white),
            onTap: () {
              // Add functionality to leave community
            },
          ),
          Divider(color: Colors.grey[800], height: 1),
        ],
      ),
    );
  }
}