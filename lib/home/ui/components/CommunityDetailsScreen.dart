import 'package:flutter/material.dart';
import 'InfoScreen.dart';

class CommunityDetailsScreen extends StatelessWidget {
  final String name;
  final String members;
  final String subtitle;

  const CommunityDetailsScreen({
    Key? key,
    required this.name,
    required this.members,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Color(0xFF92C9FF), fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => InfoScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/image1.png', // Replace with your asset image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Hundreds of students gathered today at the University of [Your City] to voice their opposition to the recent educational reforms proposed by the administration. The protest, which began at 10:00 AM in front of the Administration Building, quickly grew as students from various faculties joined in solidarity.',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '9OCT | 22:53 PM',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Spacer(),
                      Text(
                        'Sent by Hishami',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/image1.png', // Replace with your asset image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Hundreds of students gathered today at the University of [Your City] to voice their opposition to the recent educational reforms proposed by the administration. The protest, which began at 10:00 AM in front of the Administration Building, quickly grew as students from various faculties joined in solidarity.',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '9OCT | 22:53 PM',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Spacer(),
                      Text(
                        'Sent by Hishami',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.people, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  '$members | Only Admin can send message',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
