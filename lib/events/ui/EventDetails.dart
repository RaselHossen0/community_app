import 'package:flutter/material.dart';

import '../../home/model/EventModel.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  EventDetailsScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Event Details'),
        backgroundColor: Colors.black, // Matching the dark theme from the image
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors
                    .lightGreenAccent, // Green highlight for the event name
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '10 Sept, 5:30 PM', // Static date for now; you can format event times here
                    style: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 20,
                  child: Icon(Icons.group, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text(
                  'Created by Mechanic Club', // Add the creator dynamically if available
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(color: Colors.grey.shade400),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  event.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade300),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
