import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEventHeader(),
              SizedBox(height: 16),
              _buildCreatedBy(),
              SizedBox(height: 16),
              _buildEventDescription(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFD4FFBA), // Background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Row( // Use Row widget to make it a whole row
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded( // Make sure the text can take available space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event Name This',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '10 Sept, 5:30 PM',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          // You can add an optional icon or button here
          // Example:

        ],
      ),
    );

  }

  Widget _buildCreatedBy() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/avatar.png'),
          radius: 20,
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created by',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            Text(
              'Mechanic Club',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hundreds of students gathered today at the University of [Your City] to voice their opposition to the recent educational reforms proposed by the administration. The protest, which began at 10:00 AM in front of the Administration Building, quickly grew as students from various faculties joined in solidarity.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 16),
        Text(
          'The proposed reforms, which include changes to the curriculum, increased tuition fees, and the potential reduction of certain student services, have sparked widespread concern among the student body. Many students feel that these changes will disproportionately affect those from lower-income backgrounds and undermine the quality of education.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 16),
        Text(
          '"We are here to make our voices heard," said Emily Carter, a third-year student from the Department of Political Science. "These reforms are being pushed through without proper consultation, and they will have a devastating impact on our education and our future."',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}